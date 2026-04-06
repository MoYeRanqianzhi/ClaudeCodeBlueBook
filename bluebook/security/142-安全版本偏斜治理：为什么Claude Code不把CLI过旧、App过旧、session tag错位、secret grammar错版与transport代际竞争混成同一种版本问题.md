# 安全版本偏斜治理：为什么Claude Code不把CLI过旧、App过旧、session tag错位、secret grammar错版与transport代际竞争混成同一种版本问题

## 1. 为什么在 `141` 之后还必须继续写“版本偏斜治理”

`141-安全能力协商与版本地板` 已经回答了：

`安全语义升级不只要靠 optional fields 渐进迁移，还必须通过 initialize、capability surface、minimal reply 与 min_version 正式协商资格边界。`

但如果继续追问，  
还会碰到一个更分布式、更现实的问题：

`即便资格协商已经存在，不同端、不同路径、不同语法层仍可能以完全不同的方式“没跟上”，系统到底如何区分这些偏斜？`

这不是吹毛求疵。  
因为“版本不匹配”这个词本身就太粗：

1. CLI 太旧，意味着当前代码根本不配进入某条远程控制路径
2. claude.ai app 太旧，意味着会话也许已经建立，但前台列表暂时看不见
3. `session_*` / `cse_*` tag 错位，意味着同一会话在不同兼容层穿了不同 costume
4. secret grammar 错版，意味着 credential 根本不该被 best-effort 消费
5. v2 握手被新一轮 JWT / epoch 取代，意味着旧 transport 已经变成陈旧世界

如果这些偏斜被压成同一句：

`升级一下就好`

系统就会立刻失去对真问题的解释力。

所以 `141` 之后必须继续补的一层就是：

`安全版本偏斜治理`

也就是：

`成熟安全系统治理的不是“版本号”本身，而是不同层对象在时间上、路由上、语法上、可见性上与握手代际上的错位。`

## 2. 最短结论

Claude Code 当前源码已经清楚展示出至少五种不同的偏斜治理策略：

1. 对 CLI version floor，不给路走，直接阻断  
   `src/bridge/initReplBridge.ts:410-420,456-460`
2. 对 claude.ai app 可见性滞后，不阻断会话，只给 upgrade nudge  
   `src/bridge/envLessBridgeConfig.ts:38-41,156-164`  
   `src/hooks/useReplBridge.tsx:607-614`
3. 对 `session_*` / `cse_*` 这种 compat tag 错位，不报 generic error，而是显式 retag/translate  
   `src/bridge/sessionIdCompat.ts:25-57`  
   `src/bridge/bridgeEnabled.ts:132-145`
4. 对 secret grammar version 错版，直接 hard reject  
   `src/bridge/workSecret.ts:5-18`
5. 对 v2 transport 代际竞争，不信“先返回者”，而用 generation fencing 丢弃 stale handshake  
   `src/bridge/replBridge.ts:1373-1426`

这些证据合在一起说明：

`Claude Code 的先进性不只是“有版本检查”，而是它知道不同偏斜对象该被不同方式治理。`

因此这一章的最短结论是：

`cleanup 未来若要进入更复杂的宿主生态，版本治理也不能只剩一个 cleanup_contract_version；它更可能需要区分 visibility skew、compat-routing skew、grammar skew、capability skew 与 handshake-generation skew。`

再压成一句：

`真正成熟的版本治理，从来不是一个版本号解决所有错位。`

## 3. 第一性原理：为什么“版本错位”本质上不是数值问题，而是对象错位问题

如果我们把所有偏斜都写成：

`A 比 B 老`

其实什么也没解释。

从第一性原理看，  
系统真正要处理的不是“数字大小关系”，  
而是：

1. 哪个对象落后了
2. 它落后的后果是什么
3. 这种后果属于可见性问题、路由问题、语法问题还是资格问题
4. 系统该提示、翻译、缩域、阻断，还是直接丢弃陈旧世界

所以成熟系统一定会把偏斜拆成类型学：

1. visibility skew
2. routing / identifier skew
3. grammar skew
4. capability / version-floor skew
5. temporal / generation skew

如果不做这个拆分，  
就会出现五类坏事：

1. 应该提示的地方被误阻断
2. 应该阻断的地方被误当提示
3. 同一会话因为 costume 不同被误认成 foreign session
4. 不兼容 grammar 被继续 best-effort 消费
5. 旧握手抢赢新握手，陈旧 transport 回魂

所以从第一性原理看：

`版本治理真正保护的不是“新旧关系”，而是跨层对象在错位时仍保持诚实。`

## 4. Claude Code 已经把“CLI 过旧”和“App 过旧”拆成两种完全不同的问题

### 4.1 CLI 过旧：直接禁止进入该路径

`src/bridge/initReplBridge.ts:410-420,456-460` 很硬：

1. v2 path 先跑 `checkEnvLessBridgeMinVersion()`
2. v1 path 先跑 `checkBridgeMinVersion()`
3. 任何一侧只要版本不够，就：
   `logBridgeSkip('version_too_old', ...)`
   `onStateChange?.('failed', 'run \`claude update\` to upgrade')`
   `return null`

这说明在 Claude Code 看来，  
CLI 版本偏斜属于：

`资格偏斜`

而不是：

`显示层小瑕疵`

### 4.2 App 过旧：不阻断路径，只提醒可见性会滞后

`src/bridge/envLessBridgeConfig.ts:38-41` 与 `156-164` 则展示了完全不同的处理：

1. 配置位叫 `should_show_app_upgrade_message`
2. 注释明确写的是：
   `their claude.ai app may be too old to see v2 sessions`
3. 目的不是阻止 v2 bridge，而是：
   `roll the v2 bridge before the app ships the new session-list query`

`src/hooks/useReplBridge.tsx:607-614` 进一步把它落到 UI：

1. 会话仍然初始化成功
2. 只是在 transcript 里追加一条 status message
3. 提示用户升级 Claude mobile app 以看到 Remote Control sessions

这说明 app 过旧被治理成：

`visibility skew`

不是：

`capability admission failure`

这是非常成熟的区分。  
它避免了两种常见愚蠢：

1. 因为 app 还没跟上 session-list query，就把底层 v2 path 全部阻断
2. 因为会话本身已成功，就假装 app 可见性没有问题

## 5. Claude Code 不把 session tag 错位误判成“会话不是我的”

### 5.1 `session_*` 与 `cse_*` 是同一 UUID 的不同 costume

`src/bridge/sessionIdCompat.ts:25-57` 把这个问题写得非常清楚：

1. worker endpoints 要 `cse_*`
2. client-facing compat endpoints 要 `session_*`
3. same UUID, different costume

这意味着这里的错位不是：

`有两场会话`

而是：

`同一会话在不同兼容层被要求穿不同的 tag 外衣`

### 5.2 shim 还有显式 kill switch，而不是永远硬编码

`src/bridge/bridgeEnabled.ts:132-145` 进一步说明：

1. `cse_* -> session_*` retag shim 是显式 kill switch
2. 当 frontend 未来直接接受 `cse_*` 时，可以把 shim 关掉
3. 默认保持 active，直到明确可退场

这说明 compat translation 不是临时黑魔法，  
而是被正式建模成：

`过渡期协议部件`

### 5.3 某些地方要缓存 compat ID，某些地方反而应 fresh compute

`src/bridge/bridgeMain.ts:166-169` 很关键：

1. spawn 时计算一次 `session_*`
2. 缓存到 `sessionCompatIds`
3. 目的就是让 mid-session gate flip 期间，cleanup / status ticks 仍用同一 key

`src/bridge/bridgeMain.ts:1021-1024` 则在 spawn 前先把 `cse_*` retag 成 compat form。  
但 `src/bridge/remoteBridgeCore.ts:971-982` 又展示了另一种哲学：

1. archive 这类纯 URL path segment 场景
2. 不缓存 compatId
3. 每次 fresh compute
4. 这样能匹配“server 当前到底接受哪种 tag”

这组证据很重要。  
它说明 Claude Code 并没有把所有 compat translation 一刀切：

1. 影响内存状态一致性的地方，缓存
2. 只影响一次性 server path 解析的地方，现算

这其实是非常高级的 skew 治理：

`同一种错位对象，在不同语义场景下，治理策略可以不同。`

### 5.4 `sameSessionId()` 说明比较规则也要脱离 costume

`src/bridge/workSecret.ts:50-72` 明确把 `sameSessionId()` 写成：

1. 先比较是否完全相同
2. 否则比较最后一个 underscore 之后的 UUID body
3. 只按底层 identity 判断，不按 tag costume 判断

`src/bridge/replBridge.ts:1111-1125` 再把它用于 foreign-session 防护：

1. server 不该把别的环境的 session 派给你
2. 但如果只是 `session_*` / `cse_*` 差异，就不应被误判成 foreign

这说明 Claude Code 治理的不是“字符串长得一样吗”，  
而是：

`这两个标识在身份上是否等价。`

## 6. Claude Code 不把 grammar skew 当成“尽量兼容一下”

`src/bridge/workSecret.ts:5-18` 非常直接：

1. 先 decode
2. 必须有 `version`
3. 只接受 `version === 1`
4. 否则直接抛 `Unsupported work secret version`

这说明在高风险 credential / ingress grammar 上，  
Claude Code 的哲学不是：

`旧 grammar 也许还能凑合用`

而是：

`grammar 错版就是不合法输入。`

这与前面 app upgrade nudge 的处理形成鲜明对比：

1. app 可见性偏斜 -> 提示
2. CLI capability 偏斜 -> 阻断
3. secret grammar 偏斜 -> 硬拒绝

这恰恰证明它确实在按偏斜对象分层治理。

## 7. Claude Code 甚至把配置键偏斜也做成代际分流，而不是混用

`src/bridge/pollConfigDefaults.ts:77-80` 给了一个很小但很说明问题的细节：

1. `session_keepalive_interval_v2_ms` 是 `_v2` key
2. 注释直接写：
   `pre-v2 clients read the old key, new clients ignore it`

这说明连配置键层面，  
系统也不试图靠“同一 key 兼容所有代际”硬撑。

它接受：

`不同代际对象应该读不同键`

这对 cleanup future rollout 的启示很大。  
因为 cleanup contract 很可能也会碰到同样问题：

1. 某些旧 surface 只能消费旧 aggregation key
2. 某些新 surface 需要更细的 cleanup provenance key

那时更安全的策略未必是复用同一字段名，  
而可能是显式代际分流。

## 8. Claude Code 还治理“时间代际偏斜”：旧握手不能抢赢新握手

`src/bridge/replBridge.ts:1373-1426` 展示了另一个常被忽视的版本问题：

`同一逻辑路径上的旧握手和新握手竞争，谁代表 current generation？`

这里代码做了几件很成熟的事：

1. 任何新 transport（v1 或 v2）都会 bump `v2Generation`
2. 为本次 v2 handshake 捕获 `thisGen`
3. 如果后面又来了更新的一轮 work / JWT / epoch
4. 即使旧握手先 resolve，也会因为 `thisGen !== v2Generation` 被丢弃

注释说得很清楚：

1. 不能只靠 `transport !== null` 判断
2. 否则 stale epoch 可能抢赢 correct epoch

这说明 Claude Code 把 generation skew 看成：

`陈旧世界回魂风险`

而不是普通 race condition。

这对 cleanup 语义未来极其重要。  
因为 cleanup ack、cleanup replacement、cleanup audit finalize 这些动作一旦进入分布式宿主生态，也会遇到同样的问题：

`旧一轮闭环是否可能在新一轮事实已经出现后，晚到并误清当前真相？`

这部分是基于现有 generation fencing 哲学做的推论，  
不是当前源码中已经存在 cleanup-specific generation check。

## 9. 对 cleanup future design 的直接启示：不要只设计一个 cleanup version

综合以上源码，  
更成熟的 cleanup rollout 很可能需要一张“偏斜类型学”，而不是一个粗糙版本号：

### 9.1 visibility skew

例子：

1. 底层 cleanup 已生效
2. 某些 app / weak surface 还看不到

治理方式更像：

1. upgrade nudge
2. projection downgrade
3. honesty note

### 9.2 compat-routing skew

例子：

1. cleanup object 在强 surface 用新 tag / new identity carrier
2. compat API 还在旧 route / old tag 世界

治理方式更像：

1. retag
2. translate
3. identity-equivalence compare

### 9.3 grammar skew

例子：

1. cleanup signer envelope
2. cleanup audit token
3. cleanup authority proof

治理方式更像：

1. grammar version check
2. hard reject

### 9.4 capability skew

例子：

1. host 能 parse cleanup fields
2. 但不会消费 cleanup action

治理方式更像：

1. initialize capability negotiation
2. minimal reply
3. unsupported verdict

### 9.5 generation skew

例子：

1. 旧 cleanup ack 晚到
2. 新 cleanup replacement 已经生效

治理方式更像：

1. generation fencing
2. stale response discard

## 10. 我们当前能说到哪一步，不能说到哪一步

基于当前可见源码，  
我们可以稳妥地说：

1. Claude Code 已经把多种版本偏斜分成了不同治理对象
2. 不同对象分别采用了提示、翻译、阻断、拒绝和 fencing 等不同策略

但我们不能说：

1. cleanup skew taxonomy 已经被正式实现
2. cleanup contract 已拥有独立的 visibility / routing / grammar / generation guards

所以必须把结论压在这一层：

`Claude Code 已经清楚展示出一套可迁移的版本偏斜治理哲学；cleanup-specific 设计若继续前进，最值得借用的不是单个 min_version，而是这种“按错位对象分类治理”的方法。`

## 11. 苏格拉底式追问：如果这章还要继续提高标准，还缺什么

还可以继续追问六个问题：

1. cleanup future rollout 中，哪些偏斜只该提示，哪些必须 hard reject
2. 是否需要 cleanup identity retag shim，还是直接统一到新 carrier
3. cleanup contract 是否要区分 app-visible version 与 host-consumable version
4. generation fencing 是否应进入 cleanup ack / cleanup replacement path
5. cleanup audit token 是否需要独立 grammar version
6. 哪些 skew 可以 per-surface 处理，哪些必须在控制面中心统一处理

这些问题说明：

`能力协商解决的是“你配不配理解这套语义”，版本偏斜治理解决的则是“即使大家不在同一代际，也不能因此把不同类型的错位误当成同一种故障”。`
