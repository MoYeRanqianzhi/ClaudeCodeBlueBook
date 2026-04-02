# Agent Runtime宿主落地模板：Control、状态写回、Context Usage、恢复与证据包络

这一章不再解释宿主为什么重要，而是把 Claude Code 式宿主接入压成一张可执行模板。

它主要回答五个问题：

1. 一个真正可用的 Agent Runtime 宿主，最小闭环到底是什么。
2. 怎样把 control、状态写回、Context Usage、恢复与 evidence envelope 放进同一张接入卡。
3. 为什么“答案流接进来就行”的宿主，最终一定会重新退回猜状态、猜权限、猜回退边界。
4. 怎样用苏格拉底式追问避免把宿主模板退回 SDK 包装层。
5. 怎样把安全设计、省 token 设计与宿主接入写成同一套落地顺序。

## 0. 代表性源码锚点

- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:57-240`
- `claude-code-source-code/src/cli/structuredIO.ts:149-657`
- `claude-code-source-code/src/cli/remoteIO.ts:54-199`
- `claude-code-source-code/src/utils/sessionState.ts:92-133`
- `claude-code-source-code/src/state/onChangeAppState.ts:43-92`
- `claude-code-source-code/src/query/tokenBudget.ts:45-92`
- `claude-code-source-code/src/services/mcp/config.ts:888-980`
- `claude-code-source-code/src/services/api/sessionIngress.ts:57-186`

这些锚点共同说明：

- Claude Code 的宿主不是答案接收器，而是双向控制面、状态面、预算观测面与恢复面。

## 1. 第一性原理

更成熟的宿主接入，不是：

- 能收答案就算接上了

而是：

- 宿主必须与 Runtime 共用同一套控制、状态、预算、恢复与回退对象

所以宿主模板最该先问的不是：

- 这个 SDK 怎么调

而是：

- 宿主到底持有哪些正式真相，哪些真相只能消费，哪些真相绝不能自己猜

## 2. 宿主最小闭环

Claude Code 式宿主的最小闭环不是一条通道，而是五条：

1. `control_request/control_response/control_cancel_request`
2. `SDKMessage` 事件流
3. `worker_status/external_metadata`
4. `Context Usage`
5. `resume/recovery/snapshot`

任何少掉其中一条的宿主，都会掉进不同的猜测陷阱：

1. 少控制链，就会猜审批。
2. 少状态链，就会猜当前卡在哪。
3. 少 Context Usage，就会猜为什么更贵。
4. 少恢复链，就会猜回退边界。

## 3. 接入顺序

更稳的宿主接入顺序应固定为：

### 3.1 先接控制链

先实现：

1. `control_request`
2. `control_response`
3. `control_cancel_request`

团队规则：

1. `can_use_tool` 必须是异步、可取消、可竞速的仲裁协议。
2. `ask` 是 typed decision，不是弹窗名字。
3. `request_id + tool_use_id` 应是宿主的幂等键。

### 3.2 再接状态写回

再实现：

1. `session_state_changed`
2. `worker_status`
3. `external_metadata.permission_mode`
4. `external_metadata.pending_action`
5. `external_metadata.task_summary`

团队规则：

1. `SDKMessage` 回答“刚发生了什么”。
2. `worker_status/external_metadata` 回答“现在是什么”。
3. host 不得自己镜像 mode、pending_action 或 tool pool 真相。

### 3.3 再接预算观测

再实现：

1. `Context Usage`
2. `continuation count / pct / delta`
3. `systemPromptSections / toolBreakdown / attachmentBreakdown`

团队规则：

1. `get_context_usage` 是 decision window，不是 token 余额。
2. budget 观测必须与当前 `pending_action` 并排看。
3. “成本更高”必须能被解释到 prompt / tool / attachment / continuation。

### 3.4 再接恢复链

再实现：

1. `sessionIngress` / append chain
2. resume snapshot
3. stale-state cleanup
4. rollback object

团队规则：

1. `sessionIngress` 保护的是 append-chain 对象，不是普通重试队列。
2. 初始化 / reconnect 时必须先清 stale state，再 hydrate。
3. 回退不能只剩文件级 diff。

### 3.5 最后接 evidence envelope

最后实现：

1. `current_truth`
2. `decision_window`
3. `control_evidence`
4. `rollback_object`
5. `observed_window`
6. `evidence_refs`

团队规则：

1. 正式字段应是稳定对象。
2. bridge pointer、内部 hash、临时 patch 只能做 evidence ref。
3. 宿主交付的不是零散日志，而是一套可复查对象。

## 4. 宿主 authority checklist

宿主接入时，至少逐项检查：

```text
[ ] permission_mode 是否只消费 external mode
[ ] tool pool 是否来自权威装配层
[ ] schema 是否来自权威 schema / control surface
[ ] worker_status/external_metadata 是否显式区分 timeline 与 snapshot
[ ] Context Usage 是否进入 decision window 解释
[ ] rollback_object 是否进入宿主真相
```

## 5. 风险清单

看到下面信号时，应提高警惕：

1. 宿主只有答案流，没有 control cancel。
2. 宿主自己拼工具池或自己复制 schema。
3. 宿主把 `assistant/result` 当当前状态。
4. 宿主把 token 条形图当预算真相。
5. 宿主把回退理解成“改回哪些文件”。
6. 宿主把 bridge pointer、内部 patch、内部 hash 当公共稳定字段。

## 6. MCP / Settings / Host Control 接入顺序

更稳的治理型宿主接入顺序应是：

1. 先接 control + state writeback
2. 再接 MCP scope / config / connection state
3. 再接 settings `sources/effective/applied`
4. 最后接 channels / managed authority / evidence envelope

不要做的事：

1. 不要先连 MCP，再猜 host 怎么解释状态。
2. 不要直接读磁盘 settings，把它误当 `effective`。
3. 不要让 channels、MCP、settings 各自成为一套孤岛真相。

## 7. 苏格拉底式检查清单

在你准备宣布“宿主已经接好了”前，先问自己：

1. 这个宿主消费的是双向控制面，还是单向答案流。
2. 当前状态是宿主知道的，还是宿主猜的。
3. 当前预算是宿主解释的，还是宿主想象的。
4. 当前回退对象是正式对象，还是事后补写。
5. 如果今天断线重连，这个宿主是否仍知道“当前到底是什么状态”。

## 8. 一句话总结

成熟的 Agent Runtime 宿主，不是把模型回答嵌进自己的界面；而是把 control、状态写回、Context Usage、恢复与 evidence envelope 接成与 Runtime 共用的正式闭环。
