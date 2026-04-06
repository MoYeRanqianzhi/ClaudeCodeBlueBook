# Rollout证据消费API手册：worker_status、external_metadata、Context Usage与回退对象边界

这一章回答五个问题：

1. 宿主到底该消费哪些正式 API / 状态面，才能把 rollout 证据做成可运营、可回退的知识面。
2. 为什么 `worker_status`、`external_metadata`、`session_state_changed`、`Context Usage` 与 control 事件必须一起看。
3. 哪些字段属于正式可消费 ABI，哪些仍应被视为宿主自建 envelope 或 internal hint。
4. 为什么回退边界应该按对象写入证据，而不是按文件或 commit 写入。
5. 宿主开发者该按什么顺序接入这套证据消费面。

## 0. 关键源码锚点

- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1735-1745`
- `claude-code-source-code/src/utils/sessionState.ts:1-146`
- `claude-code-source-code/src/state/onChangeAppState.ts:24-90`
- `claude-code-source-code/src/cli/print.ts:1036-1056`
- `claude-code-source-code/src/cli/print.ts:2450-2466`
- `claude-code-source-code/src/cli/remoteIO.ts:111-168`
- `claude-code-source-code/src/query/tokenBudget.ts:1-82`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:243-360`
- `claude-code-source-code/src/services/api/sessionIngress.ts:57-170`
- `claude-code-source-code/src/utils/task/framework.ts:160-248`

## 1. 先说结论

Claude Code 当前并没有公开一份单独的：

- `rollout_evidence`

API 对象。

但宿主已经可以从正式表面拼出一套稳定的证据消费 ABI。

更准确地说，应把证据面分成三层：

1. 正式可消费表面：
   - `session_state_changed`
   - `worker_status`
   - `external_metadata`
   - `requires_action_details`
   - `Context Usage`
   - control request / response / cancel
2. 宿主自建 envelope：
   - 对象卡
   - diff 卡
   - observed window
   - rollback target
3. internal hints：
   - `promptCacheBreakDetection` 的内部细项
   - bridge pointer 文件
   - task framework 内部 patch/eviction 细节

这三层必须分开写。

如果把 rollout 证据消费前门继续压成最短公式，也只剩四句：

1. `same-world test`
   - 宿主先确认自己消费的还是同一个工作对象与继续对象。
2. `decision window`
   - `Context Usage`、continuation 和 stop judgement 回答的是当前是否还配继续，不是最终花了多少。
3. `worker_status + external_metadata + session_state_changed`
   - 当前真相先消费这三组正式外化面，再谈 envelope。
4. `rollback object boundary`
   - 回退先按对象写，不先按文件和 commit 写。

否则宿主很容易把：

- 内部实现细节

误当成：

- 正式公共契约

## 2. 第一层：宿主必须正式消费的当前真相

### 2.1 `session_state_changed`

`coreSchemas.ts` 已把 `session_state_changed` 定义成正式系统消息：

1. `idle`
2. `running`
3. `requires_action`

它回答的是：

- 当前 turn 到底结束了吗

所以宿主不应只从 assistant output 推断“是不是已经结束”，而应优先消费这条 authoritative turn-over signal。

### 2.2 `worker_status`

`print.ts`、`remoteIO.ts` 与 CCR v2 状态回写链共同说明：

- `worker_status` 是当前 worker 真相，不是附属遥测

它回答的是：

- 这个 worker 现在到底在运行、空闲，还是在等待外部动作

### 2.3 `external_metadata`

`sessionState.ts` 与 `onChangeAppState.ts` 已经把下面字段当成正式外化面：

1. `permission_mode`
2. `is_ultraplan_mode`
3. `model`
4. `pending_action`
5. `post_turn_summary`
6. `task_summary`

宿主如果不消费这些字段，就只能得到：

- 模糊的输出历史

而拿不到：

- 当前模式
- 当前阻塞动作
- 当前长任务摘要

## 3. 第二层：宿主必须正式消费的成本与决策窗口

`Context Usage`、budget 决策与 continuation 相关信号回答的不是：

- 最终花了多少 token

而是：

- 这轮继续花 token 是否还有制度收益

因此宿主至少应在证据 envelope 里持续记录：

1. `querySource`
2. 当前上下文占比或 budget 进度
3. `continuationCount`
4. `diminishingReturns`
5. 当前 observed window
6. 最终 judgement:
   - continue / stop / upgrade object / rollback

如果只记录总 token 数，宿主只能看到：

- 成本结果

却看不到：

- 成本决策

更稳一点说：

- `Context Usage` 首先是 `decision window` 的诚实投影，不是成本面板。
- token 总量只是结果证据，observed window 才是继续/停止的判断证据。

这页的 first reject signal 也只该先剩三条：

1. 把 `Context Usage` 当成账单页。
2. 把 event replay 当成当前真相。
3. 把文件回退当成对象回退。

## 4. 第三层：控制请求与审批路径也属于证据面

Claude Code 的审批不是一句：

- ask 了

就结束。

真正有意义的证据至少包括：

1. `request_id`
2. `tool_use_id`
3. 当前 `pending_action`
4. 哪一侧给出决定
5. 是否发生 cancel / response race
6. 等待时长

因为对治理 rollout 来说，关键问题不是：

- 有无审批

而是：

- 它是在正确时机、由正确一侧、以正确结果赢下仲裁的吗

## 5. 第四层：diff 附件与 replacement 附件如何处理

宿主在证据上还应区分：

1. 正式可持久化附件
2. 仅限同环境内部解释的附件

### 5.1 可以稳定持久化的附件

更稳的选择包括：

1. transcript / internal events 引用
2. `pending_action`
3. `task_summary`
4. `post_turn_summary`
5. 已持久化的 content replacement / preview 引用

### 5.2 只能谨慎引用的 internal hints

这类信息很有价值，但不应被宿主写成“稳定公共字段”：

1. `promptCacheBreakDetection` 的内部 hash / per-tool diff 细项
2. `bridgePointer` 文件本身
3. task framework 的内部 patch / eviction 临时结构

正确做法不是忽略它们，而是：

- 把它们作为 evidence ref 或 internal note

而不是：

- 对外声明成稳定 schema

宿主在这一层最容易踩到的 first reject signal 也只有三条：

1. 把 `Context Usage` 当成账单页
2. 把 event replay 当成当前真相
3. 把文件回退当成对象回退

## 6. 回退对象边界：宿主应该怎么写

Claude Code 的很多恢复和并发防护都说明：

- 回退边界首先是对象边界

宿主在证据里更该写的是：

1. `rollback_object_type`
   - session / task / worktree / bridge / prompt assembly
2. `rollback_object_id`
3. `rollback_authority_surface`
4. `retained_assets`
5. `dropped_stale_writers`

而不是只写：

1. 回退了哪些文件
2. 回退了哪个 commit

文件和 commit 可以作为附件，但不应替代对象边界。

因为真正需要被恢复的，是：

- 当前真相对象

而不是：

- 某组文件文本

## 7. 宿主最小 evidence envelope

更稳的宿主接法，不是等待产品提供一个未来的单独 API，而是先在现有正式表面上建立最小 envelope：

```text
record_header:
- record_id
- rollout_line
- owner
- observed_window

authoritative_object:
- type
- id
- authority_surface

current_truth:
- worker_status
- session_state_changed
- external_metadata

decision_window:
- context_usage
- continuation_count
- diminishing_returns
- judgement

control_evidence:
- request_id
- tool_use_id
- pending_action
- winner_source
- latency

rollback:
- rollback_object_type
- rollback_object_id
- retained_assets
- evidence_refs
```

这份 envelope 里：

- 左边的字段名可以由宿主自定
- 右边的数据来源应尽量来自正式 authoritative surfaces

## 8. 宿主接入顺序

如果你要让宿主真正消费 rollout 证据，建议顺序是：

1. 先接 `session_state_changed + worker_status + external_metadata`
2. 再接 `Context Usage` 与 continuation / stop judgement
3. 再接 control request / response / cancel 的结构化证据
4. 最后再把内部 diff / replacement / replay 细节作为附件引入

不要反过来：

1. 先抓内部 diff
2. 再去猜当前状态

那样很容易把细节看得很多，却仍然不知道：

- 当前到底该继续、暂停还是回退

## 9. 宿主实现者的五条纪律

1. 不要只消费 assistant 最终输出，忽略 `worker_status` 与 `session_state_changed`。
2. 不要自己猜 permission mode，优先消费 `external_metadata` 的 authoritative snapshot。
3. 不要把 token 总量当成全部成本证据，优先补上 decision window 与 observed window。
4. 不要把内部 diff 细节直接上升成公共稳定契约。
5. 不要把回退写成文件列表，优先写成对象边界与保留资产。

## 10. 一句话总结

Claude Code 的 rollout 证据消费 API，并不是一个单独 endpoint，而是 `worker_status + external_metadata + Context Usage + control evidence + rollback object boundary` 这组正式表面的组合消费纪律。
