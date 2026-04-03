# 安全遗忘契约兼容迁移：为什么cleanup语义必须以optional fields、降级语法、假成功防护与兼容回退渐进进入宿主生态

## 1. 为什么在 `139` 之后还必须继续写“兼容迁移”

`139-安全遗忘契约机检` 已经回答了：

`cleanup 语义一旦进入宿主契约，就必须被 schema、生成类型、handler 与 conformance 共同守住。`

但如果继续追问，  
还会撞上另一个更硬的问题：

`即便 cleanup 语义已经进入契约，怎样把它安全地发布给新旧宿主，而不制造误报、漏报与假成功？`

这个问题不能留给“以后适配”。

因为一条安全契约如果升级方式不对，  
它会立刻在三处失真：

1. 老宿主看不懂新字段，却把沉默误读成“没有 cleanup”
2. 新运行时明明没有真正消费 cleanup 语义，却仍返回 success
3. 中间桥接层把未知/重复/迟到消息压成静默丢弃，导致旧真相被误清

所以 `139` 之后必须继续补的一层就是：

`安全遗忘契约兼容迁移`

也就是：

`安全系统不只要会定义更强真相，还必须会把更强真相渐进发布给异构宿主，而不把兼容性做成诚实性的敌人。`

## 2. 最短结论

Claude Code 当前源码虽然还没有 cleanup-specific contract，  
但已经清楚展示出四种成熟的兼容迁移语法：

1. 对旧协议保留 `optional fields`，而不是粗暴破坏旧输入  
   `src/entrypoints/sdk/coreSchemas.ts:110-116`
2. 对纯保活、无语义副作用的消息允许 silent ignore  
   `src/entrypoints/sdk/controlSchemas.ts:621-627`  
   `src/cli/structuredIO.ts:344-346`  
   `src/cli/print.ts:4036-4038`
3. 对重复、孤儿、迟到的控制响应做去重与降噪，而不是重复执行  
   `src/cli/structuredIO.ts:362-429`  
   `src/cli/print.ts:5252-5303`
4. 对当前上下文无法真正执行的可变请求返回 explicit error，而不是 false success  
   `src/bridge/bridgeMessaging.ts:265-282`  
   `src/bridge/bridgeMessaging.ts:328-357`  
   `src/bridge/bridgeMessaging.ts:373-383`

这些模式合在一起说明：

`Claude Code 的兼容设计并不是“尽量别报错”，而是“只有无语义副作用的东西才能沉默兼容；一旦涉及状态改口与能力变更，就必须诚实降级或显式报错”。`

因此这一章的最短结论是：

`cleanup 语义未来若要进入宿主生态，最安全的路线不是一次性强推，而是 optional fields + truthful downgrade grammar + false-success prevention + compatibility fallback 的渐进迁移。`

再压成一句：

`兼容迁移的本质不是少破坏，而是不撒谎。`

## 3. 第一性原理：为什么兼容不是“老版本还能跑”，而是“跨时间的真相仍被诚实表达”

很多团队把兼容理解成：

`不要把旧客户端搞崩。`

这太浅了。

从第一性原理看，  
安全契约升级真正要保护的对象不是“进程不崩”，  
而是：

1. 真相不能被升级过程偷换
2. 不支持不能被伪装成成功
3. 沉默不能被误读成否定
4. 新旧宿主不能对同一状态做出互相矛盾的更强解释

所以真正成熟的兼容迁移至少要回答四个问题：

1. 新字段如果老宿主不认识，它看到的缺席语义是什么
2. 新动作如果当前上下文不支持，系统会如何显式改口
3. 重复、迟到、孤儿响应是否会造成重复消费与二次清理
4. 哪些消息可以静默忽略，哪些消息绝不能静默忽略

如果这四问没有被回答，  
所谓“兼容”就只是：

1. 把问题延后
2. 把解释责任外包给宿主
3. 把安全失真藏进静默路径

所以从第一性原理看：

`兼容迁移不是宽容旧世界，而是治理新旧世界之间的真相连续性。`

## 4. Claude Code 已经给出了兼容迁移的四种成熟语法

### 4.1 `optional fields` 不是松懈，而是有边界的向后兼容

`src/entrypoints/sdk/coreSchemas.ts:110-116` 里，  
`McpStdioServerConfigSchema` 把 `type: 'stdio'` 明确写成 `.optional()`，  
旁边还直接注释：

`Optional for backwards compatibility`

这说明团队并不把 schema 刚性理解成“越严格越好”，  
而是理解成：

`当旧世界已经存在时，schema 需要把兼容语义本身也编码进去。`

对 cleanup 迁移来说，这个模式尤其关键。  
因为像 `cleanup_owner`、`cleanup_reason`、`cleanup_gate`、`cleanup_replaced_by`、`cleanup_audit_id` 这类字段，  
若未来要进入 `system:init`、`system:status`、`reload_plugins`、`mcp_status` 等 payload，  
最安全的第一步也应是：

1. 先以 optional fields 进入 schema
2. 明确“缺席不等于没有发生，只等于当前 surface 尚未承诺这部分真相”
3. 禁止老宿主把字段缺席翻译成更强否定判断

所以这里真正先进的点不是 `.optional()` 本身，  
而是：

`兼容语义被正式写进了 single source of truth，而不是留在 wiki。`

### 4.2 只有“无语义副作用”的消息才配 silent ignore

`src/entrypoints/sdk/controlSchemas.ts:621-627` 明确把 `keep_alive` 也做成了正式 schema。  
而在消费端：

1. `structuredIO.ts:344-346` 直接 silent ignore `keep_alive`
2. `print.ts:4036-4038` 也再次 silent ignore `keep_alive`
3. `useRemoteSession.ts:222-235` 对重复的 `status='compacting'` keep-alive ticks 只更新 ref，不追加消息

这三处合起来说明：

`Claude Code 并不排斥 silent ignore，但 silent ignore 只留给语义上本就不该改变用户判断的保活流量。`

这对 cleanup 迁移的启示很直接：

1. 可以被静默兼容的，只能是 housekeeping traffic
2. 不能被静默兼容的，是任何会改变“旧痕迹是否已被合法遗忘”的状态语义

换句话说：

`keep_alive 可以被忽略，因为它不声称任何 cleanup truth；cleanup contract 不能被同样对待，因为它决定旧真相是否还能继续存在。`

### 4.3 重复、孤儿、迟到响应必须被吸收，而不是被再次执行

`src/cli/structuredIO.ts:362-429` 给出了一套很成熟的重复响应处理模式：

1. 所有 `control_response` 都先进入生命周期收尾路径
2. 如果 request 已不存在，会继续检查它是否只是 duplicate delivery
3. 对已解析过的 `toolUseID`，直接记录 debug 并忽略  
   `structuredIO.ts:386-394`
4. 对仍未知但合法到达的 orphan response，交给 `unexpectedResponseCallback`
5. 对已知 request，再通过 `schema.parse()` 做结构校验  
   `structuredIO.ts:416-419`

`src/cli/print.ts:5252-5303` 又把 orphaned permission response 的第二层护栏补齐：

1. 先检查 `handledToolUseIds`
2. 已处理过就拒绝再次入队  
   `print.ts:5267-5277`
3. 即使没处理过，也要求能在 transcript 中找到 unresolved `tool_use`
4. 找不到就不执行

这套设计的哲学非常重要：

`兼容不是“所有到达的东西都尽量吃下去”，而是“先区分它是新真相、旧重放、还是无主回声，再决定是否消费”。`

对 cleanup 迁移来说，这意味着：

1. cleanup ack 不能因为重连重放就重复清理
2. cleanup response 不能因为 orphan arrival 就自动宣布成功
3. cleanup-related payload 必须和可追溯 request/owner/gate 重新绑定

否则最危险的失真就是：

`旧响应在新会话里再次生效，替当前状态错误地“清掉了过去”。`

### 4.4 可变请求一旦当前上下文不支持，就必须返回 explicit error

`src/bridge/bridgeMessaging.ts:265-282` 很关键。  
在 outbound-only 模式下，除 `initialize` 外的可变请求一律返回 error，  
注释直接写明这么做是为了避免：

`false success`

`src/bridge/bridgeMessaging.ts:328-357` 进一步说明：  
`set_permission_mode` 如果当前上下文没有注册回调，  
也必须返回 error verdict，  
原因同样被写得很直白：

`the mode is never actually applied in that context, so success would lie to the client`

`src/bridge/bridgeMessaging.ts:373-383` 甚至对 unknown subtype 也统一返回 error，  
避免 server 一直等待或者被沉默挂起。

这三处共同表明：

`Claude Code 的兼容哲学不是“请求来了就给个看起来友好的 success”，而是“只要语义没有真的落地，success 就是谎言”。`

对 cleanup 迁移的直接推论是：

如果未来存在任何 cleanup-affecting control request，  
那么当宿主或 bridge 无法真正提供以下能力时，就不应返回 success：

1. cleanup gate 的真实验证
2. cleanup owner 的真实签字
3. cleanup provenance 的真实产出
4. cleanup ack 的真实消费

这部分是基于现有 false-success 防护模式做的推论，  
不是当前源码里已经出现的 cleanup 请求实现。

### 4.5 兼容回退可以存在，但必须先做消息分类，再决定“可丢”还是“不可丢”

`src/hooks/useRemoteSession.ts:244-249` 说明一个很细的点：

`convertSDKMessage` 在非 viewerOnly 模式下会把某些 user messages 转成 `{type:'ignored'}`，  
因此工具进行中的 bookkeeping 不能依赖转换后消息，  
必须先读取原始 `sdkMessage`。

到 `useRemoteSession.ts:273-329`，  
代码明确把 converted message 分成：

1. `message`
2. `stream_event`
3. `ignored`

最后注释写明：

`'ignored' messages are silently dropped`

这说明真正成熟的 silent drop 还有前提：

`必须先经过语义分类，确认它确实属于“可忽略的那一类”。`

这给 cleanup 迁移的启示是：

1. 可以 downgrade 的，是显示层的低带宽投影
2. 不能 downgrade 的，是签字、清理、替换、审计这些 authority-bearing semantics

也就是说，  
弱 surface 可以继续展示旧词，  
但强 surface 不能借“兼容”之名吃掉 cleanup provenance。

### 4.6 兼容 bug fix 的目标不是“多支持一点”，而是“消灭 silent drop”

`src/cli/print.ts:3709-3736` 展示了另一个很成熟的兼容思路：

1. JSON 序列化会丢掉 `undefined`
2. 调用方于是用 `null` 表达“清除此 key”
3. handler 再把 `null` 转换成 deletion，避免 schema reject 整个对象
4. 同时通过 `notifyChange()` 先重置 cache，再通知 listeners
5. 否则会“read stale cached settings and silently drop the update”
6. 模型切换也额外更新 override，避免 change 被 silently ignored

这段代码说明：

`兼容迁移真正要防的，不只是 parse error，还包括“看起来没报错，但更新其实没生效”的静默丢失。`

这对 cleanup 迁移很重要，  
因为 cleanup 语义最怕的恰恰不是 loud failure，  
而是：

1. 表面成功
2. 实际未消费
3. 旧痕迹被误以为已经合法退场

所以从技术先进性看，  
Claude Code 很强的一点在于它已经把“silent drop 比 loud failure 更危险”写进了不少关键路径。

## 5. 对 cleanup 契约迁移的直接工程启示

基于以上源码模式，可以得到一个严格但务实的 rollout 方案。

### 5.1 第一步：先让 cleanup fields 以 optional 进入强 surface

优先 surface 应是当前已经正式 schema 化的几类 payload：

1. `system:init`  
   `src/entrypoints/sdk/coreSchemas.ts:1457-1493`
2. `system:status`  
   `src/entrypoints/sdk/coreSchemas.ts:1533-1542`
3. `mcp_status` response  
   `src/entrypoints/sdk/controlSchemas.ts:165-173`
4. `reload_plugins` response  
   `src/entrypoints/sdk/controlSchemas.ts:415-432`

最安全的首发策略不是强制必填，  
而是：

1. schema 上 optional
2. host 侧只在字段存在时显示更强 cleanup truth
3. 字段缺席时保持旧 rendering，但明确它只是低分辨率投影

### 5.2 第二步：把“缺席语义”写成降级语法，而不是让宿主自己猜

cleanup fields 缺席时，  
宿主绝不能默认推出：

1. 没发生 cleanup
2. cleanup 一定失败
3. cleanup 已经成功但我懒得显示

更诚实的 downgrade grammar 应是：

1. `unknown / not projected`
2. `not supported on this surface`
3. `legacy payload without cleanup provenance`

这部分是对前述“silent ignore 只适用于无语义副作用消息”的工程化延伸。

### 5.3 第三步：任何 mutating cleanup action 都必须继承 false-success 防护

如果未来加入：

1. cleanup acknowledgement
2. stale-failure clear
3. reconnect-replaced marker
4. consumed-needs-refresh confirmation

那么 bridge / host / handler 只在以下条件都成立时才配 success：

1. gate 已被真实消费
2. owner 已被真实确认
3. provenance 已被真实产出
4. response 已被真实映射到正确 contract

只要缺任一环，  
更安全的行为都应是 explicit error 或 truthful downgrade，  
而不是“先 success，回头再补”。

### 5.4 第四步：conformance 测的不是“能不能读”，而是“会不会误说”

cleanup contract 的兼容测试至少要覆盖：

1. 新 runtime -> 旧 host：旧 host 是否只降级，不 overclaim
2. 旧 runtime -> 新 host：新 host 是否正确识别字段缺席
3. duplicate/orphan cleanup response：是否会重复清理
4. unsupported cleanup action：是否明确 error，而不是假成功

也就是说，  
这类 conformance 的核心 assertion 不是：

`process survived`

而是：

`truth remained honest`

## 6. 一条可执行的迁移路线

把上面的原则压成更具体的 rollout：

1. 先冻结 cleanup lexicon，明确哪些词代表 owner、reason、gate、replacement、audit
2. 在 `system:init`、`system:status`、`mcp_status`、`reload_plugins` 上加 optional cleanup fields
3. 为字段缺席写出统一 downgrade grammar
4. 只在 handler 真正消费 cleanup gate 后产出这些字段
5. 对不支持 cleanup control 的上下文返回 explicit error
6. 增加 old/new host cross-version conformance matrix

这条路线的关键不是快，  
而是：

`每一步都要求“更强表达”与“更强诚实”同步上升。`

## 7. 我们当前能说到哪一步，不能说到哪一步

基于当前可见源码，  
我们可以稳妥地说：

1. Claude Code 已经存在 optional compatibility、silent ignore、duplicate suppression、false-success prevention 这些成熟模式
2. 这些模式足以支撑 cleanup contract 的渐进迁移设计

但我们不能说：

1. cleanup fields 已经进入任何正式 schema
2. cleanup downgrade grammar 已经被正式实现
3. cleanup conformance matrix 已经存在

所以必须把结论压在这一层：

`兼容迁移所需的技术哲学与设计骨架已经清楚可见，但 cleanup-specific rollout 目前仍是可论证的下一步，而不是已完成事实。`

## 8. 苏格拉底式追问：如果这章还要继续提高标准，还缺什么

还可以继续追问六个问题：

1. 哪些 cleanup fields 属于“强 surface 必须显示”，哪些只能在 detail surface 暴露
2. 字段缺席时，UI 最小诚实文案到底应该是什么
3. cleanup 的 duplicate/orphan suppression 是否也该拥有独立 audit ID
4. 是否需要专门的 `cleanup_capability_version` 来避免新旧宿主错判
5. 哪些 cleanup 失败必须 loud error，哪些只需 downgrade
6. conformance 应如何覆盖 bridge、CLI、SDK host 三层联动

这些问题说明：

`兼容迁移不是收尾工作，而是安全契约真正进入生态前的最后一道诚实性工程。`
