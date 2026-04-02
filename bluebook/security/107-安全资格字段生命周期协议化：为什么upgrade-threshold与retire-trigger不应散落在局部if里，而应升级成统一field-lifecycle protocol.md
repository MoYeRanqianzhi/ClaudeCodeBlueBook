# 安全资格字段生命周期协议化：为什么upgrade-threshold与retire-trigger不应散落在局部if里，而应升级成统一field-lifecycle protocol

## 1. 为什么在 `106` 之后还必须继续写“字段生命周期协议化”

`106-安全资格字段升级阈值与撤场条件` 已经回答了：

`安全字段不是静态排序对象，而是带 upgrade threshold、stay condition 与 retire trigger 的生命周期对象。`

但如果继续往下追问，  
还会碰到一个更工程化、也更制度化的问题：

`这些生命周期规则现在到底被放在哪里？`

如果答案是：

`散落在每个 hook、controller、comment 和局部 if 里`

那虽然系统已经拥有成熟直觉，  
但它还没有拥有成熟协议。

这会带来四个后果：

1. 生命周期规则很难被跨 surface 复用
2. 代码评审时很难快速回答“这个字段为什么会出现/消失”
3. 不同子系统可能各自形成相似但不完全一致的 upgrade/retire 语义
4. 统一安全控制台无法把“为什么现在显示它”直接讲给用户听

所以 `106` 之后必须继续补出的下一层就是：

`安全资格字段生命周期协议化`

也就是：

`upgrade-threshold、stay-condition 与 retire-trigger 不应继续散落在局部实现里，而应升级成统一的 field-lifecycle protocol。`

## 2. 最短结论

从源码看，Claude Code 已经在多个子系统里形成了成熟的生命周期治理规则，  
但这些规则目前主要以“局部控制逻辑”存在，而不是“全局协议字段”存在：

1. `Notification` 类型已经包含 `priority/invalidates/timeoutMs/fold`，说明队列生命周期有半套协议，但还没有语义级 `upgrade_threshold` 与 `retire_owner`  
   `src/context/notifications.tsx:5-33`
2. AppState 对 notifications 的存储只有 `current/queue`，并不记录这些字段为何升级、为何留场、谁能撤场  
   `src/state/AppStateStore.ts:222-225`
3. `BridgeStatusInfo` 只有 `label/color`，并没有表达失败字段的 threshold、stay basis 或 retire semantics  
   `src/bridge/bridgeStatusUtil.ts:113-140`
4. plugin lifecycle 的核心规则分裂在 `needsRefresh` store 字段、`useManagePlugins` 的 “Do NOT reset” 注释，以及 `refreshActivePlugins()` 的唯一消费路径里  
   `src/state/AppStateStore.ts:209-215`; `src/hooks/useManagePlugins.ts:287-303`; `src/utils/plugins/refresh.ts:59-67,123-138`
5. pointer lifecycle 的核心规则则分裂在 `bridgePointer.ts` 的 freshness 清理、`bridgeMain.ts` 的 resume / fresh-start / fatal / clean-shutdown 分支里  
   `src/bridge/bridgePointer.ts:77-112`; `src/bridge/bridgeMain.ts:1515-1577,2316-2325,2384-2403,2473-2534`

所以这一章的最短结论是：

`Claude Code 已经拥有字段生命周期治理能力，但还没有把它完全升级成统一的生命周期协议。`

再压成一句：

`规则已在，协议未成。`

## 3. notification 子系统已经接近 protocol，但还停在“队列协议”而非“语义协议”

## 3.1 现在已经有的字段，其实就是半套 lifecycle kernel

`src/context/notifications.tsx:5-22` 当前已经定义了：

1. `priority`
2. `invalidates`
3. `timeoutMs`
4. `fold`

这四个字段其实已经很接近真正的 lifecycle kernel：

1. `priority`
   回答谁先说
2. `invalidates`
   回答谁让谁退场
3. `timeoutMs`
   回答默认留场时长
4. `fold`
   回答同家族新旧版本如何合并

所以这里最值得注意的不是“还缺很多”，  
而是：

`Claude Code 已经隐约证明：生命周期规则是可以字段化的。`

## 3.2 但它还没回答更深的四个问题

即便 notification 已经做到这一步，  
它仍没有结构化编码：

1. `upgrade_threshold`
   它凭什么现在能升级成前台字段
2. `stay_condition`
   除 timeout 外，当前还靠什么理由留场
3. `retire_owner`
   谁拥有最终撤场权
4. `evidence_basis`
   这个字段背后的最小 truth bundle 是什么

这意味着 notification 当前更像：

`delivery protocol`

而不是：

`semantic lifecycle protocol`

## 3.3 为什么这是问题

因为如果 lifecycle 只存在于局部代码路径里，  
别的 surface 就几乎无法回答：

1. 为什么这条通知现在出现
2. 为什么它还能继续存在
3. 它会在什么条件下消失
4. 是 timeout 消失，还是 completion 消失，还是更强证据驱逐

也就是说：

`用户现在能看到通知，却看不到通知背后的在场法理。`

## 4. AppState 与 BridgeStatusInfo 进一步暴露了“规则在代码里，协议不在数据里”

## 4.1 AppState 对 notifications 只保存“结果”，不保存“原因”

`src/state/AppStateStore.ts:222-225` 很直接：

1. `current`
2. `queue`

AppState 里没有：

1. `why_current`
2. `why_not_retired`
3. `retire_owner`
4. `threshold_kind`
5. `freshness_basis`

这说明状态树当前保存的是：

`显示结果`

而不是：

`生命周期依据`

如果统一控制台未来要真正回答“为什么是现在这个状态”，  
光有 `current/queue` 其实不够。

## 4.2 `BridgeStatusInfo` 更明显：它只输出结论，不输出结论的合法性说明

`src/bridge/bridgeStatusUtil.ts:113-140` 里，  
bridge status 被压成：

1. `label`
2. `color`

这足以渲染：

1. failed
2. reconnecting
3. active
4. connecting

但它并没有输出：

1. 当前结论基于哪些 truth input
2. 是否处于 narrow projection
3. 是否存在更强但隐藏的 failure detail
4. 这个字段什么时候该退场

所以 `BridgeStatusInfo` 当前是：

`render result`

而不是：

`field-lifecycle object`

## 4.3 `/status` 则再次说明没有协议字段时，很多规则只能靠注释维持

`src/utils/status.tsx:95-114` 已经非常清楚地承认：

1. `/status` 不是 full server list
2. 它只做 counts by state + `/mcp` hint

这本来已经是在表达一条重要规则：

`这是 aggregate summary，不是完整控制面。`

但这条规则没有被编码成字段，  
于是它只能停留在注释和作者意图里。

这再次说明：

`只要生命周期和投影规则没有成为数据，系统就只能“由作者记得”，而不能“由协议保证”。`

## 5. plugin 生命周期是最典型的“规则分裂在三处”的案例

## 5.1 store 只知道 `needsRefresh`

`src/state/AppStateStore.ts:209-215` 告诉我们：

`needsRefresh = true` 代表磁盘态已变化，运行态已 stale。`

但 store 并不知道：

1. 谁拥有消费它的权力
2. 什么动作会让它退场
3. 为什么局部提示层不能 reset 它

## 5.2 hook 只知道“不要乱清”

`src/hooks/useManagePlugins.ts:287-303` 又告诉我们：

1. 可以显示 `plugin-reload-pending`
2. `Do NOT auto-refresh`
3. `Do NOT reset needsRefresh`

这其实已经是在写 lifecycle policy，  
只是它现在以注释存在。

## 5.3 真正的 retire path 则藏在 `refreshActivePlugins()`

`src/utils/plugins/refresh.ts:59-67,123-138` 最后告诉我们：

1. 只有 full refresh 完成
2. 只有相关 active components 真正交换完
3. 才能 `needsRefresh: false`

于是 plugin lifecycle 的完整规则现在被拆成：

1. store 的一个布尔位
2. hook 的一段注释
3. refresh path 的最终消费

这就是典型的：

`控制逻辑正确，但协议边界不完整。`

## 6. pointer 生命周期说明：越高风险的对象，越不能只靠局部 if 记忆规则

## 6.1 pointer 的 freshness 规则在 `bridgePointer.ts`

`src/bridge/bridgePointer.ts:77-112` 已经明确规定：

1. invalid schema -> clear
2. stale TTL -> clear
3. 否则返回 fresh pointer + `ageMs`

## 6.2 pointer 的 resume / shutdown / fatal 规则在 `bridgeMain.ts`

`src/bridge/bridgeMain.ts:1515-1577,2316-2325,2384-2403,2473-2534` 又规定：

1. fresh start without continue -> clear leftover pointer
2. session not found / no env -> clear
3. resumable clean shutdown -> keep
4. archive+deregister clean shutdown -> clear
5. transient reconnect failure -> keep
6. fatal reconnect failure -> clear

也就是说，  
pointer lifecycle 其实已经非常成熟。  
但它成熟的方式主要是：

`由两个文件中的多处分支共同维持。`

这对当前作者当然可控，  
但对统一控制台、自动审查和后续扩展来说仍然不够理想。

## 6.3 这类高风险对象最需要 protocolization

因为 pointer 这样的对象一旦出错，  
影响的不是某条提示文案，  
而是：

1. 用户是否还能 resume
2. 系统是否会误导用户继续重试
3. 已失效边界是否会继续伪装成当前边界

所以风险越高，  
越不该让 lifecycle rule 继续只活在：

1. 局部 if
2. 多文件注释
3. 作者脑内模型

## 7. MCP stale cleanup 则揭示了另一个更深的问题：当前系统缺一张统一的 retire-owner 账本

`src/services/mcp/useManageMCPConnections.ts:791-825` 里，  
作者非常清楚地知道 stale cleanup 需要：

1. 先清 timer
2. 防止旧 `onclose` closure 复活旧配置
3. 只清真正 `connected` 的 stale client
4. 让新 config 下的 client 重新以 `pending/disabled` 入场

这说明作者脑中已经有非常清晰的：

`retire owner + retire sequence`

问题在于，  
这份知识现在并没有成为统一的控制面协议字段。  
它只存在于：

1. 这个 hook 的实现细节里
2. 这段注释里

于是系统外部很难统一回答：

`某个 stale 对象为什么是由这里而不是别处来撤场。`

## 8. 从第一性原理看，为什么这些规则必须协议化

原因其实只有一句：

`一个系统如果不能把“为什么这个字段现在在场”表达成数据，它就无法把自己的治理原则公开给别的系统层。`

再拆开说，就是四条：

## 8.1 没有协议字段，就没有跨 surface 的可解释性

footer、notification、dialog、`/status` 都可能看到同一对象的不同投影。  
如果 lifecycle 只存在于局部 if，  
这些 surface 就只能共享结论，  
不能共享：

1. 升级依据
2. 留场依据
3. 退场依据

## 8.2 没有协议字段，就没有统一评审面

评审时最该问的问题是：

1. 这个字段为什么现在能升级
2. 这个字段为什么还在
3. 这个字段谁能删
4. 这个字段删掉后会不会假装已经安全

如果这些答案只在代码路径里，  
reviewer 只能：

`读实现猜协议`

而不是：

`读协议审实现`

## 8.3 没有协议字段，就没有统一生成能力

未来如果要做统一安全控制台、日志解释器、自动审计器、甚至 agent 自解释层，  
它们都需要同一套 lifecycle 数据。

否则每个新系统都得重新硬编码：

1. bridge 失败怎么消
2. plugin pending 何时消
3. pointer 何时清
4. stale MCP 何时退

这会导致：

`成熟规则被重复实现，而不是被协议复用。`

## 8.4 没有协议字段，就很难用苏格拉底方法逼问系统自身

真正成熟的安全系统，  
应当能被持续追问：

1. 你为什么显示这条字段
2. 你还留着它做什么
3. 谁允许你清掉它
4. 你凭什么说它现在已不重要

如果这些问题没有结构化答案，  
那系统就还不能被真正“自反性审查”。

## 9. 下一代 field-lifecycle protocol 至少应长什么样

如果由我来定义，  
统一生命周期协议至少应包含：

## 9.1 身份与强度

1. `field_id`
2. `field_family`
3. `priority`
4. `projection_scope`

## 9.2 升级依据

1. `upgrade_threshold_kind`
2. `upgrade_threshold_owner`
3. `evidence_bundle_id`
4. `threshold_reason`

## 9.3 留场依据

1. `stay_condition_kind`
2. `freshness_basis`
3. `expires_at`
4. `renewal_mechanism`

## 9.4 退场依据

1. `retire_trigger_kind`
2. `retire_owner`
3. `invalidates`
4. `retire_sequence`

## 9.5 用户解释与跳转

1. `handoff_route`
2. `hidden_truth_hint`
3. `overclaim_ceiling`
4. `premature_retire_risk`

这样做的价值不是把系统变得更抽象，  
而是把它已经拥有的成熟治理直觉，  
从：

`作者习惯`

升级成：

`平台协议`

## 10. 技术启示：真正先进的控制面应该让“实现遵守协议”，而不是让“协议藏在实现里”

Claude Code 当前已经给出一个很强的工程启示：

`生命周期规则如果重要到足以决定安全边界，就不该只作为局部代码习惯存在。`

成熟系统的演进方向应该是：

1. 先在实现中长出正确直觉
2. 再把这些直觉提炼成协议字段
3. 最后让渲染器、调度器、日志器、解释器都消费同一协议

这才是从：

`好代码`

走向：

`好平台`

的关键一步。

## 11. 苏格拉底式反思：如果要把这层做得更好，还应继续追问什么

可以继续追问七个问题：

1. 当前哪些生命周期规则已经足够稳定，可以正式协议化，而不再只放在注释里
2. 当前哪些字段虽然有 `priority`，但还没有可复用的 `upgrade_threshold`
3. 当前哪些字段虽然有 timeout，但没有可解释的 `retire_owner`
4. 当前哪些生命周期对象跨越多个文件，导致 review 时必须拼图才能读懂
5. 当前统一控制台若想解释“为什么还显示它”，是不是还得硬编码很多 subsystem-specific 逻辑
6. 当前哪些地方最容易发生“实现改了，但协议认知没同步”
7. 如果系统今天需要把 lifecycle 解释直接展示给用户，哪些对象已经能做到，哪些还做不到

这些问题的核心只有一句：

`一条规则只要还不能被系统自己用结构化方式说出来，它就还没有真正成为平台能力。`

## 12. 一条硬结论

对 Claude Code 这类安全控制面来说，  
真正的下一步不是：

`再多写几条局部 if，`

而是：

`把 upgrade-threshold、stay-condition、retire-trigger 与 retire-owner 从局部实现抽到统一 field-lifecycle protocol 中。`

因为只有这样，  
系统才不只是：

`会正确治理字段，`

而是：

`会把自己为什么这样治理字段，也变成可复用、可审计、可解释的正式协议。`
