# wrapFetchWithStepUpDetection、ClaudeAuthProvider与performMCPOAuthFlow的强请求清理step-up重授权治理边界

## 1. 为什么单开这一篇源码剖面

安全主线推进到 `306` 时，
真正需要被单独钉住的已经不是：

`stronger-request cleanup 线未来谁来决定真正 consumer 在使用瞬间是否已经 fresh enough to use，`

而是：

`stronger-request cleanup 线一旦已经拿到 fresh current-use proof，谁来决定这份 proof 对当前更强请求的 authority level 是否仍然不够，从而必须进入 step-up reauthorization。`

如果这个问题只停在主线长文里，
最容易又被压成一句抽象判断：

`use-time revalidation governor 不等于 step-up reauthorization governor。`

这句话还不够硬。
所以这里单开一篇，
只盯住：

- `src/services/mcp/auth.ts`
- `src/services/mcp/client.ts`

把 `403 insufficient_scope` detection、`markStepUpPending()`、
`tokens()` 的 refresh-token suppression、step-up scope persistence、
cached discovery reuse 与 transport fetch hook 并排，
直接钉死 stronger-request cleanup 线当前仍缺的不是 live-use truth，
而是 `higher-authority step-up governance grammar`。

## 2. 最短判断

这组代码最重要的技术事实不是：

`Claude Code 只有 use-time revalidation，没有 step-up reauthorization。`

而是：

`Claude Code 已经在 MCP 线上明确把“当前还能不能用”和“当前即便能用，scope 是否足够支撑更强请求”拆成两层；stronger-request cleanup 线当前缺的不是文化，而是这套 step-up reauthorization governance 还没被正式接到旧 cleanup artifact family 上。`

## 3. 关键源码锚点

| 主题 | 关键源码 | 这里回答的问题 |
| --- | --- | --- |
| insufficient-scope detection | `src/services/mcp/auth.ts:1345-1370` | 为什么 transport fetch 会在最前线把 `403 insufficient_scope` 识别成 authority-level 问题 |
| step-up pending state | `src/services/mcp/auth.ts:1461-1470,1625-1690` | 为什么当前 token fresh 不等于当前 scope 足够 |
| step-up continuation | `src/services/mcp/auth.ts:579-617,903-935,1884-1898` | 为什么更高授权要保留自己的 state across revoke / re-auth |
| transport integration | `src/services/mcp/client.ts:620-633,821-827` | 为什么 step-up detection 是 live transport path 的正式部分 |
| completion semantics | `src/services/mcp/auth.ts:1704-1705` | 为什么 higher-authority pending state 拥有单独的完成条件 |

## 4. `wrapFetchWithStepUpDetection()` 先证明：authority-level 缺口不会被当成 freshness-level 缺口

`auth.ts:1345-1370`
很值钱。

注释已经把整个失败链说透：

1. transport fetch 若看到 `403 insufficient_scope`
2. 就必须先标记 step-up pending
3. 否则 SDK 的 authInternal 会看到 `refresh_token`
4. 走 refresh
5. 由于 RFC 6749 §6 不允许通过 refresh 提升 scope，
   最终只会拿回同等级 token
6. retry
7. 再 403
8. 最后以 upscoping failure 终止

这条证据非常硬。

因为它明确把两类问题拆开了：

1. freshness 不足
2. authority level 不足

源码作者公开承认：

如果不先把第二类问题单独抓出来，
系统就会让第一类路径假装自己已经解决了第二类问题。

这正是 step-up reauthorization governance 的本体：

`scope insufficiency must not be flattened into plain refresh`

## 5. `markStepUpPending()` 与 `tokens()` 再证明：repo 会主动关闭错误的 refresh path，逼系统走更强授权流

`auth.ts:1461-1470,1625-1690`
更硬。

这里 repo 做了四件很关键的事：

1. `markStepUpPending(scope)` 把所需更高 scope 记进 provider
2. `tokens()` 比较 `_pendingStepUpScope` 与当前 token 的实际 scope
3. 若 scope 不覆盖，则设置 `needsStepUp=true`
4. 在返回 token 时故意省略 `refresh_token`

这一步极其值钱。

因为它不是“建议去 step-up”，
而是在控制面上直接做出：

`refresh path suppression`

这意味着 repo 公开承认：

`当前 token 可能完全 fresh、当前 use path 也可能完全 live，但如果 authority level 不够，就必须禁止错误路径继续冒充正确路径`

## 6. `performMCPOAuthFlow()` 与 step-up state persistence 再证明：更高授权拥有自己的跨流程连续性

`auth.ts:579-617,903-935,1884-1898`
很值钱。

这里 repo 明确：

1. re-auth 时可以保留 `stepUpScope` 与 `discoveryState`
2. 下一次 `performMCPOAuthFlow()` 开始前先读取 cached `stepUpScope`
3. 还会把 cached `resourceMetadataUrl` 一并带回
4. transport-attached provider 在收到更高 scope 后会把 `stepUpScope` 持久化

这说明更强授权不是：

`本次失败后，随手再来一轮普通登录`

而是：

`higher-authority request has its own continuation state`

这条证据非常关键。

因为它说明 repo 并不是在使用一个临时 UI patch。
它是在给更高 authority level 建一条正式的 continuation grammar：

1. 哪个 scope 正在 pending
2. 哪个 discovery / metadata state 要保留
3. 下一次 flow 应该以什么 stronger target 继续

如果 cleanup 线未来没有这种 grammar，
那它就仍然回答不了：

`旧 cleanup 对象当前即便还能用，哪些更强动作还必须重新拿到更高等级授权`

## 7. `client.ts` transport hook 再证明：step-up 不是 auth.ts 自言自语，而是 live transport path 的硬门

`client.ts:620-633,821-827`
很硬。

无论 SSE 还是 StreamableHTTP transport，
repo 都把：

`wrapFetchWithStepUpDetection(createFetchWithInit(), authProvider)`

挂在真实 fetch 最前线。

这说明 step-up 不是 auth.ts 的私有注释，
而是 live request semantics 的正式部分。

最值钱的技术启示是：

`higher-authority detection must run where the request actually happens, not after the user has already been misled by a stale success path`

## 8. `saveTokens()` 再补一层：higher-authority flow 也拥有自己的完成条件

`auth.ts:1704-1705`
看起来很短，
但非常值钱。

`saveTokens()` 一开始就清掉：

`this._pendingStepUpScope = undefined`

这说明 step-up 不是无限 pending 的解释性标记。
它拥有自己的 completion semantics：

`只有新的 higher-authority token 真正落盘，pending scope 才被清空`

从第一性原理看，
这非常先进。

因为它让：

1. detection
2. suppression
3. persistence
4. completion

形成了闭环，
而不是只留下一个“需要更高权限”的 UI 影子。

## 9. 这篇源码剖面给主线带来的五条技术启示

### 启示一

`403 insufficient_scope` 必须在 transport 前线被看作 authority-level signal，而不是普通 freshness failure。

### 启示二

refresh 只能修 freshness，不能偷偷冒充 scope elevation。

### 启示三

higher-authority intent 应该拥有跨 revoke / re-auth 的持续状态，否则系统会反复忘记自己真正缺的是什么。

### 启示四

live transport integration 比事后 UI 提示更接近真正的安全边界。

### 启示五

higher-authority flow 也应该有明确的完成条件，而不是只留下 pending 影子。

## 10. 用苏格拉底式反问压缩这篇源码剖面的核心

可以得到五个自检问题：

1. 如果 fresh enough to use 已经足够，为什么 repo 还要在 transport 前线单独抓 `403 insufficient_scope`？
2. 如果 refresh 足够，为什么 `tokens()` 要在 `needsStepUp` 时故意省略 `refresh_token`？
3. 如果更高授权不需要单独连续性，为什么要跨 revocation 保留 `stepUpScope` 与 `discoveryState`？
4. 如果 step-up 只是 auth.ts 的内部实现，为什么 SSE / HTTP transport 都要统一挂接 detection wrapper？
5. 如果 higher-authority 已经自动成立，为什么 `saveTokens()` 还需要以清空 `_pendingStepUpScope` 作为独立完成点？

这些反问共同逼出同一个结论：

`Claude Code 不只在治理你现在还能不能用，也在治理你现在即便能用，是否已经配升级动作等级。`
