# Headless print summary-tail and observer-restore branch map 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/208-task_summary、post_turn_summary、terminal tail、observer restore 与 suggestion settlement：为什么 100-104 不是并列细页，而是先从 summary 分家，再分叉到终态收口与恢复合同.md`
- `05-控制面深挖/100-task_summary、post_turn_summary、SDKMessageSchema、StdoutMessageSchema 与 ccr init clear：为什么 Claude Code 的 summary 不是同一条 transport-lifecycle contract.md`
- `05-控制面深挖/101-lastMessage、outputFormat switch、gracefulShutdownSync、prompt_suggestion 与 session_state_changed(idle)：为什么 headless print 的 result 是最终输出语义，却不是流读取终点.md`
- `05-控制面深挖/102-lastEmitted、logSuggestionOutcome、interrupt、end_session 与 output.done：为什么 headless print 的已交付 suggestion 不一定留下 accepted、ignored telemetry.md`
- `05-控制面深挖/103-pending_action、task_summary、externalMetadataToAppState、state restore 与 stale scrub：为什么 CCR 的 observer metadata 不是同一种恢复面.md`
- `05-控制面深挖/104-pendingLastEmittedEntry、pendingSuggestion、lastEmitted、interrupt 与 end_session：为什么 headless print 的 deferred suggestion staging 会留下 inert stale slot.md`

边界先说清：

- 这页不是 100-104 的细节证明总集。
- 这页不替代 208 的分叉结构页。
- 这页只抓“100 是根页，`101→102→104` 是主干，103 是 observer-restore 侧枝”的阅读图。

## 1. 分叉图总表

| 节点 | 作用 | 在图上的位置 |
| --- | --- | --- |
| 100 | 先分 `task_summary` / `post_turn_summary` 不是同一条 transport-lifecycle contract | 根页 |
| 208 | 解释 100-104 的分叉关系 | 结构收束页 |
| 101 | 先分 terminal cursor 与 raw stream tail | 主干起点 |
| 102 | 先分 delivered suggestion 与 settled telemetry | 主干 |
| 104 | 解释 cleanup asymmetry 为什么更像 inert stale slot | 主干叶子 |
| 103 | 先分 observer metadata 与 restore input | 侧枝 |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| 100-104 都在讲 result 后面的尾巴，所以可以按兴趣并列读 | 100 是根页；`101→102→104` 是主干；103 是侧枝 |
| 101 只是 100 的输出附录 | 101 在分 terminal cursor 与 raw tail，不在补 summary carrier |
| 102 只是 101 的 suggestion 附录 | 102 在分 delivered ledger 与 settlement ledger |
| 104 只是“确认有 bug”的叶子页 | 104 讨论 cleanup inertness，不直接等于 visible protocol bug |
| 103 只是 100 的恢复附录 | 103 在分 observer metadata 与 restore input |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | summary 不是一条总线；`result` 主位不等于流终点；已交付 suggestion 不等于已结算；observer metadata 不等于 restore input |
| 条件公开 | cleanup 分支只在特定 control-path 下出现；关于 inert stale slot 的判断依赖当前控制流 |
| 内部/灰度层 | `lastMessage`、`lastEmitted`、`pendingLastEmittedEntry`、`externalMetadataToAppState(...)`、worker init scrub、helper 顺序细节 |

## 4. 六个检查问题

- 我现在卡住的是 100 的根分裂，还是 `101→102→104` 的主干，还是 103 的 observer-restore 侧枝？
- 我现在在问 terminal cursor、settlement、restore，还是 summary 根分家？
- 这句话在 helper 名改掉以后还成立吗？
- 我是不是把“已交付”误写成了“已结算”？
- 我是不是把 cleanup asymmetry 直接夸大成了外部协议 bug？
- 我是不是把 observer metadata 的 stale scrub first，误写成了 local restore first？

## 5. 源码锚点

- `claude-code-source-code/src/cli/print.ts`
- `claude-code-source-code/src/utils/sessionState.ts`
- `claude-code-source-code/src/cli/transports/ccrClient.ts`
- `claude-code-source-code/src/state/onChangeAppState.ts`
- `claude-code-source-code/src/services/PromptSuggestion/promptSuggestion.ts`
