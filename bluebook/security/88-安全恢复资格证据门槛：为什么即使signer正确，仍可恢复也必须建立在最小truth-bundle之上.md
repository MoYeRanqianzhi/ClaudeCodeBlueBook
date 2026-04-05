# 安全恢复资格证据门槛：为什么即使signer正确，仍可恢复也必须建立在最小truth-bundle之上

## 1. 为什么在 `87` 之后还要继续写“恢复资格证据门槛”

`87-安全恢复资格签发权` 已经回答了：

`“仍可恢复”这项资格不是谁都能签发，必须由掌握边界真相的控制层签字。`

但如果继续往下追问，  
还会碰到一个更底层的问题：

`就算 signer 是对的，它到底凭什么签发？`

因为在一个成熟控制面里，  
正确的 signer 只是必要条件，  
不是充分条件。

如果 signer 可以仅凭一条局部 signal 就宣布：

`还可恢复`

那系统仍然会把一个并不可靠的 hope，  
误写成正式资格。

所以在 `87` 之后，  
安全专题还必须再补一章，把“谁配签字”继续推进成“签字必须满足什么证据门槛”：

`恢复资格证据门槛。`

也就是：

`成熟控制面不仅要限制恢复资格的签发权，还必须规定：只有当最小 truth bundle 成立时，signer 才配把“仍可恢复”说出口。`

## 2. 最短结论

从源码看，Claude Code 已经不是靠单个布尔值判断 resumability，而是在拼一组最小 truth bundle：

1. 进入 resume flow 前，必须先有 pointer candidate；没有就直接报 `No recent session found`  
   `src/bridge/bridgeMain.ts:2149-2160`
2. 仅有 pointer 还不够，`resumeSessionId` 还必须先通过 `validateBridgeId(...)`  
   `src/bridge/bridgeMain.ts:2363-2373`
3. 还要主动刷新 OAuth token，避免 expired-but-present token 把真实身份问题伪装成 `not found`  
   `src/bridge/bridgeMain.ts:2374-2378`
4. 接着 session 必须真实存在，且必须拥有 `environment_id`  
   `src/bridge/bridgeMain.ts:2380-2415`
5. 就算 session 存在，还要验证 backend 返回的 `environmentId` 是否与 resume 目标一致；不一致就只能降级成 fresh session  
   `src/bridge/bridgeMain.ts:2473-2489`
6. 如果 reconnect 失败，系统还要继续区分 `transient` 与 `fatal`，决定是保留 pointer 还是撤回资格  
   `src/bridge/bridgeMain.ts:2524-2540`
7. pointer 自身也有 schema/TTL 门槛；模式上还必须是 `single-session`，否则连 resumability carrier 都不允许发布  
   `src/bridge/bridgePointer.ts:76-113`  
   `src/bridge/bridgeMain.ts:2290-2326,2709-2728`

所以这一章的最短结论是：

`Claude Code 的“仍可恢复”不是单信号判断，而是 bundle judgment。`

我把它再压成一句：

`signer 必须先拿到足够真的 bundle，才配签字。`

## 3. 源码已经说明：恢复资格必须建立在一组最小 truth bundle 上

## 3.1 pointer 只是第一块证据，不是最终证据

`src/bridge/bridgeMain.ts:2149-2160` 说明一个最基本的事实：

如果连 valid pointer candidate 都没有，  
系统根本不会进入 resume flow，  
而是直接报：

`No recent session found ...`

这说明 pointer 在证据链里的位置只是：

`entry ticket`

也就是：

1. 你至少得有一个值得检查的候选对象
2. 没有候选对象，就不许继续谈恢复资格

但反过来并不成立。  
有 pointer 只意味着：

`可以继续查`

并不意味着：

`已经可以恢复`

## 3.2 ID 合法性是第二块门槛：候选对象必须先像一个合法对象

`src/bridge/bridgeMain.ts:2363-2373` 又加了一层门槛。

在真正去 server 取 session 之前，  
代码先做：

`validateBridgeId(resumeSessionId, 'sessionId')`

这说明即使 pointer 给出一个值，  
系统也不会把它自动当成可信对象。

它还要先满足：

`对象标识合法性。`

从第一性原理看，  
这一步很重要，  
因为它防的是：

`连对象名都不合法，却还继续消耗更多更贵的验证资源。`

所以恢复资格的 truth bundle 第一层至少包含：

1. 有候选
2. 候选 id 合法

## 3.3 token freshness 也是门槛的一部分，因为身份歧义会污染恢复判断

`src/bridge/bridgeMain.ts:2374-2378` 特别有力量。

作者明确写出：

1. `getBridgeSession(...)` 走 raw axios
2. 不会自动做 401 refresh
3. expired-but-present token 否则会制造 misleading `not found`

这说明恢复资格判断里，  
作者防的不是只有对象真假，  
还包括：

`鉴权上下文是否足够新。`

如果 token 已过期，  
系统对 session existence 的判断就会被污染。  
于是：

1. 你以为对象不存在
2. 实际上只是身份验证上下文失真

所以 token freshness 本身就是 resumability truth bundle 的一部分。

## 3.4 session existence 和 `environment_id` 缺一不可

`src/bridge/bridgeMain.ts:2380-2415` 把下一层门槛写得非常清楚。

这里不仅要求：

1. session 存在

还要求：

2. 它必须带 `environment_id`

如果任一条件不成立，  
系统都会：

1. 清 pointer
2. 报错
3. 停止继续承诺恢复

这说明在 Claude Code 的模型里，  
“对象还在”并不等于“对象仍可恢复”。

它至少还要满足：

`对象仍附着在可被恢复的环境结构上。`

也就是说，  
恢复资格的 bundle 已经至少包含：

1. candidate
2. id valid
3. auth fresh
4. session exists
5. environment binding exists

## 3.5 environment match 决定的是“恢复”还是“降级成新建”

`src/bridge/bridgeMain.ts:2473-2489` 更进一步说明：

即使 session 存在且有 `environment_id`，  
也还不能直接宣布：

`可以继续恢复。`

系统还要继续核对：

1. 请求恢复的环境
2. backend 实际返回的环境

如果 mismatch，  
作者明确说：

1. 原环境已 expired 或 reaped
2. reconnect against new env 不成立
3. 只能 fall through 到 fresh session creation

这说明 resumability 不是“对象还在就行”，  
而是：

`对象仍处在同一条可续接边界里。`

一旦环境不匹配，  
虽然用户也许还能“继续做事”，  
但那已经不是恢复，  
而是：

`新建替代。`

## 3.6 transient / fatal 区分说明：失败等级本身也是 evidence threshold 的一部分

`src/bridge/bridgeMain.ts:2524-2540` 把最后一层很关键的门槛补齐了。

这里作者没有把 reconnect failure 压成一个统一失败，  
而是继续区分：

1. fatal  
   撤回恢复资格
2. transient  
   保留 pointer，并允许说 `may still be resumable`

这说明恢复资格的最小 truth bundle 里还必须包含：

`failure semantics`

因为同样都是“当前没恢复成功”，  
不同失败等级对未来可恢复性的含义完全不同。

如果不把 failure semantics 纳入 bundle，  
系统就会把：

1. 真正 dead 的边界
2. 暂时失败但可再试的边界

混成一种 hope。

## 3.7 模式兼容性也是证据门槛，不满足时连 carrier 都不该出现

`src/bridge/bridgeMain.ts:2290-2326,2709-2728` 和 `src/bridge/bridgePointer.ts:76-113` 说明：

resumability 还取决于模式语义。

源码明确写出：

1. `resumeSessionId` 会强制 `spawnMode = single-session`
2. 没有 `--continue` 时，旧 pointer 要清掉，避免 stale env linger
3. pointer 只在 `single-session` 下写
4. multi-session 写 pointer 会与 resume 语义冲突

这说明在 Claude Code 里，  
恢复资格并不只由对象状态决定，  
还由：

`当前制度语义是否允许把这个对象重新作为唯一边界继续追索。`

也就是说，  
mode compatibility 不是外围细节，  
它属于 truth bundle 本体。

## 3.8 第一性原理：恢复资格不是一条事实，而是一组同时成立的事实束

把上面所有证据再压一层，  
Claude Code 实际上是在用一组最小 truth bundle 判断 resumability：

1. `carrier truth`  
   pointer 存在且不 stale
2. `identifier truth`  
   session id 合法
3. `auth truth`  
   token 语义足够新
4. `object truth`  
   session 真实存在
5. `binding truth`  
   `environment_id` 存在且匹配
6. `failure truth`  
   失败等级仍允许 retry
7. `mode truth`  
   当前模式语义支持 resumability

只有这些 truth 足够同时成立，  
系统才配从：

`candidate`

升级到：

`verified resumable`

这就是为什么恢复资格不能靠单信号。

## 3.9 技术先进性：Claude Code 已经在按 proof bundle 而不是 hope bundle 做恢复判断

从技术角度看，  
很多系统会把“恢复”压成：

1. 最近对象存在
2. 先试一下
3. 失败再说

但 Claude Code 更成熟的地方在于：

1. 它先过滤 candidate
2. 再验证 id
3. 再修正 auth freshness
4. 再确认 object 与 binding
5. 再区分 fatal / transient
6. 再决定是 resume、retry 还是 fresh session fallback

这说明它真正治理的不是“恢复体验”，  
而是：

`恢复资格的证明门槛。`

## 4. 安全恢复资格证据门槛的最短规则

把这一章压成最短规则，就是下面七句：

1. signer 正确并不等于资格成立，资格还需要最小 truth bundle
2. pointer 只是候选证据，不是最终证据
3. token freshness 必须纳入恢复资格判断，否则 `not found` 可能是假象
4. session existence 不等于 resumability，`environment_id` 与 environment match 同样重要
5. failure semantics 必须进入 bundle，否则 retryable 与 dead boundary 会被混淆
6. mode compatibility 是证据门槛的一部分，不是事后优化
7. 成熟控制面判断 resumability 应靠 proof bundle，而不是 hope bundle

## 5. 苏格拉底式追问：这套系统还能怎样再向前推进

如果继续自问，  
下一步最值得补的三项升级会是：

1. 把 resumability truth bundle 明确建模成结构化对象，而不只散在多个 if 条件里
2. 给不同 evidence piece 标显式 `confidence` / `freshness` / `owner`，让“候选、已核验、可重试、不可恢复”成为正式机型
3. 在统一安全控制台里把 resumability proof bundle 可视化，让用户看到系统为什么说可以恢复、为什么改口说不行

所以这一章最终沉淀出的设计启示是：

`成熟安全系统不是因为“看起来还有希望”就允许恢复，而是因为一组最小真相束已经同时成立，才配签发恢复资格。`
