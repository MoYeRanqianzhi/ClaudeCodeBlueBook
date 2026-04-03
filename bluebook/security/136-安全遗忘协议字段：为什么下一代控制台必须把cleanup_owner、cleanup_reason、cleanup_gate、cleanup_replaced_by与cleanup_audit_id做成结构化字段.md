# 安全遗忘协议字段：为什么下一代控制台必须把cleanup_owner、cleanup_reason、cleanup_gate、cleanup_replaced_by与cleanup_audit_id做成结构化字段

## 1. 为什么在 `135` 之后还必须继续写“协议字段”

`135-安全遗忘审计` 已经回答了：

`Claude Code 在关键 cleanup 路径上已经形成了“合法遗忘仍要留线索”的雏形，但这些线索还散落在 debug、event、diagnostic 与 error 输出里。`

但如果继续追问，  
还会碰到一个更尖锐的问题：

`如果审计线索只存在于日志和注释里，而不进入结构化字段，它们究竟算不算系统正式能力？`

答案通常是否定的。

因为没有进入结构化字段的线索，  
很难被：

1. UI 正式消费
2. SDK / host 统一消费
3. machine-check 验证
4. 多 surface 一致投影

所以 `135` 之后必须继续补出的下一层就是：

`安全遗忘协议字段`

也就是：

`如果 Claude Code 真的要把 cleanup audit 做成一等能力，它最终必须从零散日志升级成结构化字段。`

## 2. 最短结论

Claude Code 当前已经有不少 cleanup audit 的线索，  
但它们大多仍停留在：

1. `logForDebugging`
2. `logEvent`
3. `logForDiagnosticsNoPII`
4. `console.error`
5. 注释中的隐式语义

从源码看，当前结构化对象本身还明显缺少 cleanup 协议字段：

1. `Notification` 只有 `key/invalidates/priority/timeoutMs/fold`，没有 cleanup metadata  
   `src/context/notifications.tsx:5-23,31-40`
2. `AppState.plugins.installationStatus` 和 `needsRefresh` 只有状态，没有 cleanup reason / owner / gate  
   `src/state/AppStateStore.ts:185-216,519-529`
3. `BridgePointerSchema` 只有 `sessionId/environmentId/source`，没有清理原因、替代对象、审计 id  
   `src/bridge/bridgePointer.ts:42-50`
4. `clearBridgePointer(...)` 会写 debug，但 schema 本身不承载 cleanup semantics  
   `src/bridge/bridgePointer.ts:186-202`
5. 代码库里也根本没有 `cleanup_owner`、`cleanup_reason`、`cleanup_gate`、`cleanup_audit_id` 这类字段  
   全局检索为空

所以这一章的最短结论是：

`Claude Code 已经拥有 cleanup audit 的素材，但还没有把这些素材升级成 cleanup protocol。`

再压成一句：

`没有字段化的审计，仍然太依赖读日志的人。`

## 3. 第一性原理：为什么日志不是协议，字段才是协议

日志当然有价值。  
但日志和协议不是一回事。

日志回答的是：

`发生时，维护者若去翻，或许还能看到什么。`

协议字段回答的是：

`系统正式承认哪些事实可以被各层消费。`

这两者的差别非常大。

没有字段化时：

1. UI 只能靠局部注释和隐式分支推断 cleanup 语义
2. 不同 surface 很容易各自脑补 cleanup 结论
3. host / SDK 很难统一获取 cleanup cause
4. tests 很难直接 assert cleanup semantics

一旦字段化：

1. cleanup 语义成为一等数据
2. 多 surface 可以共享同一真相源
3. 词法与投影都能围绕同一对象建立
4. invariants 与 snapshot tests 才真正有抓手

所以从第一性原理看：

`日志是旁路证据，字段才是控制面语言。`

## 4. 当前源码最明显的缺口：cleanup 事实主要存在于旁路，而不在载体里

### 4.1 Notification 对象没有 cleanup 语义字段

`src/context/notifications.tsx:5-23,31-40` 显示：

`BaseNotification` 当前只有：

1. `key`
2. `invalidates`
3. `priority`
4. `timeoutMs`
5. `fold`

这当然足够描述队列调度，  
但还不足以回答 cleanup audit 的关键问题：

1. 谁拥有这次清理动作
2. 为什么它可以清理
3. 是 timeout 退出、invalidated 退出，还是 authoritative removal
4. 被谁替代了

也就是说，  
今天 notification 层虽然有 lifecycle，  
但没有 cleanup protocol。

### 4.2 Plugin state 只有 `needsRefresh`，没有“为何待刷新/为何已消费”的结构化依据

`src/state/AppStateStore.ts:185-216,519-529` 显示：

1. `installationStatus` 只记录 `pending/installing/installed/failed`
2. `needsRefresh` 只是一个 boolean
3. 没有 `refresh_owner`
4. 没有 `refresh_reason`
5. 没有 `refresh_gate`
6. 没有 `consumed_by`

这意味着很多今天靠阅读源码才能知道的语义，  
例如：

1. 是 background install 触发的 `needsRefresh`
2. 还是 updates-only 触发的 `needsRefresh`
3. 是 auto-refresh failed 后 fallback 来的
4. 还是用户手动 `/reload-plugins` 已消费掉的

都没有被正式挂在状态对象上。

### 4.3 Bridge pointer 也只有恢复载荷，没有清理载荷

`src/bridge/bridgePointer.ts:42-50` 里，  
`BridgePointerSchema` 只有：

1. `sessionId`
2. `environmentId`
3. `source`

而 `186-202` 的 `clearBridgePointer(...)` 虽然会写 debug：

1. cleared
2. clear failed

但这些清理语义并没有回写进任何结构化对象。

这就导致：

`pointer 的存在是结构化的，pointer 的清理原因却仍然是旁路的。`

这正是 cleanup protocol 尚未完成的典型表现。

## 5. 为什么这会成为真正的产品与工程问题

### 5.1 UI 无法正式展示 cleanup provenance

如果没有字段，  
前台想显示：

1. “这条痕迹被谁清理了”
2. “为什么这次是 fallback 而不是 resolved”
3. “当前是 timeout hidden 还是 authoritative cleared”

就只能重新推导。  
一旦重新推导，  
就会再次出现：

`弱 surface 脑补强真相`

### 5.2 host / SDK 无法消费 cleanup semantics

只要 cleanup 语义不进入结构化消息，  
宿主就只能看见：

1. 当前值变了
2. 某个前景没了

却看不见：

3. 变化由谁授权
4. 变化属于哪类 cleanup
5. 是否还有 residual trace

这会严重限制 Claude Code 作为 host-integrated runtime 的可解释性。

### 5.3 测试也无法直接守住 cleanup constitution

没有字段时，  
很多 cleanup 规则只能靠：

1. 注释
2. 代码路径阅读
3. debug log 文本

来间接判断。

这让 machine-check 非常吃力。

但如果 cleanup fields 被结构化，  
就可以直接断言：

1. `cleanup_owner === refreshActivePlugins`
2. `cleanup_gate === layer3_swap_completed`
3. `cleanup_replaced_by === plugin-reload-pending`
4. `cleanup_reason === stale_pointer_session_missing`

这才是可以持续守住的工程能力。

## 6. 下一代控制台最值得引入的 cleanup protocol fields

基于当前缺口，  
最值得引入的字段至少有五个。

### 6.1 `cleanup_owner`

回答：

`是谁执行了这次合法清理。`

候选值例如：

1. `notification_queue`
2. `refresh_active_plugins`
3. `plugin_installation_manager`
4. `mcp_connection_manager`
5. `bridge_loop`

### 6.2 `cleanup_reason`

回答：

`为什么清理会发生。`

候选值例如：

1. `timeout`
2. `invalidated_by_higher_priority_signal`
3. `full_swap_completed`
4. `stale_pointer_session_missing`
5. `environment_deregistered`
6. `fatal_reconnect_failure`

### 6.3 `cleanup_gate`

回答：

`是在哪一道证据门槛被满足后才允许清理。`

候选值例如：

1. `layer3_swap_completed`
2. `final_failure_reached`
3. `authoritative_disable_persisted`
4. `environment_offline_confirmed`
5. `session_missing_confirmed`

### 6.4 `cleanup_replaced_by`

回答：

`这次清理之后，旧痕迹被什么新对象或新语义替代。`

例如：

1. `plugin-reload-pending`
2. `failed`
3. `needs-auth`
4. `none`

### 6.5 `cleanup_audit_id`

回答：

`如果要跨日志、事件、UI 与诊断回查，这次 cleanup 的统一关联 id 是什么。`

这是把散点 evidence 连成真正审计链的关键。

## 7. 技术先进性：Claude Code 的下一步不该是“多打点”，而该是“字段升格”

这也是这一章最重要的技术启示。

很多团队发现 cleanup 不够可解释时，  
第一反应是：

`再多加几条 log。`

但从 Claude Code 当前结构看，  
真正更高收益的一步不是更多 log，  
而是：

`把已有的 cleanup 语义升格成字段。`

因为：

1. log 只能被人看
2. field 才能被系统看

这会直接影响：

1. UI 投影能力
2. host 集成能力
3. machine-check 能力
4. 文案仲裁能力

## 8. 哲学本质：可解释的遗忘，最终必须变成“可消费的遗忘”

这一章真正的哲学核心是：

`能被人类维护者从日志里拼出来，不等于系统已经正式拥有这项知识。`

真正成熟的安全控制面，  
最终必须把“遗忘的解释”从：

1. 注释里的暗知识
2. debug 里的旁路知识
3. 维护者脑中的背景知识

升级成：

`运行时正式承认并可被多层消费的结构化知识。`

所以：

`可解释的遗忘`

若想再进一步，  
最终就必须变成：

`可消费的遗忘`

## 9. 苏格拉底式反思：如果要把 cleanup protocol 再推进一代，还缺什么

继续追问，还能看到三个明显缺口。

### 9.1 缺统一 cleanup schema

这是最大的缺口。  
没有 schema，就没有统一语言。

### 9.2 缺 cleanup lifecycle tests

即便有字段，  
若没有 tests 去断言它们何时出现、何时退场、谁能写，  
仍不够稳。

### 9.3 缺跨 surface 的 cleanup projection rules

即便字段存在，  
也还要继续回答：

1. 哪些 surface 必须看到
2. 哪些 surface 只能看到摘要
3. 哪些 surface 不配显示 cleanup cause

否则又会回到 projection 失真问题。

## 10. 本章结论

把 `135` 再推进一层后，  
Claude Code 安全性的一个关键下一步就很清楚了：

`它不只需要 cleanup audit。`

它最终还需要：

1. cleanup protocol fields
2. cleanup schema
3. cleanup projection rules
4. cleanup lifecycle tests

所以如果要真正学习 Claude Code 的安全设计启示，  
最值得学的不是“再多打几条清理日志”，  
而是：

`把遗忘的因果、门槛、所有者与替代关系正式升级成结构化字段。`

