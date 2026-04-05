# SDKMessage、worker_status 与 external_metadata 字段级对照手册

这一章回答六个问题：

1. 宿主到底应该读哪几类状态对象。
2. `SDKMessage`、`worker_status`、`external_metadata` 各自负责什么。
3. 哪些字段是事件时间线，哪些字段是当前快照，哪些字段是恢复后真相。
4. control subtype 与这些状态对象如何闭环。
5. 哪些字段最值得宿主立即消费。
6. 为什么不能只盯着 assistant/result。

## 1. 先说结论

Claude Code 对宿主暴露的不是单一消息流，而是三层真相面：

1. 事件时间线：
   - `SDKMessage`
2. 当前工作状态：
   - `worker_status`
3. 黏性恢复元数据：
   - `external_metadata`

更具体地说：

- `SDKMessage` 负责“发生了什么”
- `worker_status` 负责“现在在什么状态”
- `external_metadata` 负责“当前阻塞点、模式、模型、摘要这些恢复后仍成立的真相”

如果宿主只读 `assistant` 或 `result`，就会漏掉：

- `stream_event`
- `tool_progress`
- `task_started` / `task_progress` / `task_notification`
- `session_state_changed`
- `status`
- `pending_action`

关键证据：

- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1290-1779`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:57-519`
- `claude-code-source-code/src/utils/sessionState.ts:1-149`
- `claude-code-source-code/src/state/onChangeAppState.ts:19-91`
- `claude-code-source-code/src/cli/transports/WorkerStateUploader.ts:1-118`
- `claude-code-source-code/src/cli/structuredIO.ts:469-773`
- `claude-code-source-code/src/utils/sdkEventQueue.ts:1-118`
- `claude-code-source-code/src/utils/task/sdkProgress.ts:1-35`
- `claude-code-source-code/src/utils/sessionStorage.ts:1307-1637`
- `claude-code-source-code/src/utils/sessionRestore.ts:99-177`

## 2. 先看跨平面的主键

如果不先看主键，后面的 crosswalk 很容易混成一团。

最关键的几组键是：

1. `session_id`
   - 会话级主键
2. `uuid`
   - 单条消息 / 事件 identity
3. `request_id`
   - control request/response/cancel 的闭环键
4. `tool_use_id`
   - 权限请求、工具执行、task 进度的关联键
5. `parent_tool_use_id`
   - 运行时父子工具/子代理关系
6. `parentUuid`
   - transcript resume 时的消息链重建键
7. `worker_epoch`
   - CCR worker state 防旧 worker 继续写快照的保护键

这组字段说明 Claude Code 明确区分了三种关系：

- 事件 identity
- 命令闭环 identity
- 恢复链 identity

## 3. 第一层：`SDKMessage` 是时间线，不是最终答案

从 `coreSchemas.ts` 看，`SDKMessage` 至少覆盖六大类对象：

1. turn message：
   - `user`
   - `assistant`
   - `stream_event`
   - `result`
2. 系统初始化与状态：
   - `system:init`
   - `system:status`
   - `system:session_state_changed`
3. task / workflow：
   - `task_started`
   - `task_progress`
   - `task_notification`
4. 执行过程：
   - `tool_progress`
   - `tool_use_summary`
   - `files_persisted`
5. hooks / auth / rate limit：
   - `hook_started`
   - `hook_progress`
   - `hook_response`
   - `auth_status`
   - `rate_limit_event`
6. 其他系统事件：
   - `api_retry`
   - `elicitation_complete`
   - `local_command_output`

因此宿主如果要做完整集成，第一件事不是“等最终 result”，而是先决定：

- 哪些事件进入时间线 UI
- 哪些事件进入活动面板
- 哪些事件只更新状态

## 4. 第二层：`worker_status` 是当前状态，而不是事件

`worker_status` 的语义更窄，但更关键。

当前可见状态至少包括：

- `idle`
- `running`
- `requires_action`

这和 `SDKMessage` 的区别在于：

- 它不是时间线上的一个点
- 而是宿主当前应该显示的 authoritative status

这也是为什么不能只靠“最后一条消息是什么”来猜当前状态。

尤其是：

- `requires_action` 说明当前真的卡在用户批准/输入上
- `idle` 说明 held-back result、后台 agent loop 等都已经收敛

这里要特别区分：

- `system:status`
- `system:session_state_changed`
- `worker_status`

其中最接近 authoritative running/idle 真相的，是：

1. `worker_status`
2. `session_state_changed`

而不是 `system:status`。

## 5. 第三层：`external_metadata` 承担恢复后仍应成立的真相

`SessionExternalMetadata` 当前可见的关键键包括：

- `permission_mode`
- `is_ultraplan_mode`
- `model`
- `pending_action`
- `post_turn_summary`
- `task_summary`

其中最重要的是 `pending_action`。

它与 `RequiresActionDetails` 形成双写：

1. typed 路径：
   - 供 webhook / proto / typed consumer 使用
2. JSON 元数据路径：
   - 供 session 查询与恢复后 UI 直接读取

这说明 Claude Code 不要求宿主自己回放整段 event stream 才能知道“当前到底卡在哪”。

## 6. control 面的关键不是 subtype 名单，而是闭环

`control_request` / `control_response` / `control_cancel_request` 才是宿主真正的命令闭环。

这组封套说明：

- 宿主不只是被动看消息
- 而是在参与运行时仲裁

其中最关键的三个闭环样板是：

### 6.1 `initialize`

顺序通常是：

1. 宿主发 `control_request(initialize)`
2. CLI 回 `control_response(success)`
3. CLI 再发 `system:init`

也就是说：

- 前者是 ack + capability response
- 后者才是 runtime 真正装配好的系统快照

### 6.2 `can_use_tool`

这是最关键的运行时仲裁闭环：

1. CLI 发 `control_request(can_use_tool)`
2. 宿主回 `control_response`
3. 若另一侧已先赢，可能再发 `control_cancel_request`
4. 随后状态面与事件面才继续推进

所以不要把 `can_use_tool` 理解成单纯弹窗 RPC。
它更像 permission arbitration slot。

### 6.3 `resume` / recovery

这里没有单一 subtype，但恢复链明确分层：

1. hydrate transcript
2. `loadConversationForResume(...)`
3. `restoreSessionStateFromLog(...)`
4. snapshot 元数据回填

这说明 recovery 闭环不是只靠 `SDKMessage` 回放完成的。

## 7. 最值得宿主优先消费的字段组

### 7.1 身份封套

多数 `SDKMessage` 都带：

- `uuid`
- `session_id`

部分还带：

- `parent_tool_use_id`

这组字段决定：

- 去重
- 归并
- 子任务/子工具层级显示

### 7.2 初始化快照

`system:init` 直接暴露：

- `tools`
- `mcp_servers`
- `model`
- `permissionMode`
- `slash_commands`
- `skills`
- `plugins`

它不是欢迎语，而是 runtime 装配态快照。

### 7.3 turn 与执行事件

宿主最该消费的执行事件是：

- `stream_event`
- `assistant`
- `tool_progress`
- `task_progress`
- `task_notification`

因为这组字段共同描述“这一轮正在怎么运行”。

### 7.4 状态真相

状态真相则优先消费：

- `worker_status`
- `external_metadata.pending_action`
- `external_metadata.permission_mode`
- `session_state_changed`

这里的优先级应当是：

1. `worker_status`
2. `external_metadata`
3. `SDKMessage` 时间线

而不是倒过来。

## 8. snapshot 与 persistence 不是一回事

这里也很容易混淆。

- snapshot 面：
  - `worker_status`
  - `requires_action_details`
  - `external_metadata`
- persistence/recovery 面：
  - JSONL transcript
  - v1 ingress
  - v2 internal-events
  - file history snapshots
  - attribution snapshots
  - context collapse snapshots
  - todo / metadata tail lines

前者回答“现在是什么”；
后者回答“稍后如何再恢复出这个会话”。

所以恢复系统不是简单把 snapshot 存一下，而是要把消息链、文件状态、工作树状态都带回来。

## 9. control subtype 如何与状态对象闭环

从 `controlSchemas.ts` 看，宿主不只是看消息，还能主动查询或改变状态。

最关键的一组 control subtype 是：

- `can_use_tool`
- `set_permission_mode`
- `get_context_usage`
- `rewind_files`
- `seed_read_state`
- `get_settings`

这几类请求各自对应不同的状态面：

### 6.1 `can_use_tool`

它会把 ask 送到宿主，并最终反映为：

- 权限结果
- `requires_action` / `running` 状态切换
- `pending_action` 元数据

### 6.2 `set_permission_mode`

它不只回一个成功响应，还会通过：

- `notifyPermissionModeChanged(...)`
- `notifySessionMetadataChanged(...)`

把 mode 同步到：

- `system:status`
- `external_metadata.permission_mode`

### 6.3 `get_context_usage`

它直接暴露上下文占用的结构化剖面：

- categories
- tools
- memory files
- skills
- system prompt sections
- api usage

这比只看“还剩多少 token”有用得多。

### 6.4 `rewind_files` / `seed_read_state`

这两者说明宿主不只是读状态，也能参与文件状态正确性与恢复语义。

### 6.5 `get_settings`

它区分：

- `effective`
- `sources`
- `applied`

说明 Claude Code 明确把“磁盘合并后的配置”和“实际运行时采用值”拆成两层。

## 10. `WorkerStateUploader` 说明 snapshot 不是随便写回的

`WorkerStateUploader` 这一层非常关键，因为它写出了 snapshot 面的工程语义：

- 只允许 1 inflight + 1 pending
- top-level last-write-wins
- metadata 走 RFC 7396 merge
- 失败指数退避直到成功

这意味着：

- `worker_status` / `external_metadata` 不是 best-effort decoration
- 而是一个被认真设计的 state writeback plane

## 11. 给宿主的消费建议

如果你在做 SDK host，建议最先消费下面五组：

1. `system:init`
2. `worker_status`
3. `external_metadata.pending_action`
4. `tool_progress` + `task_progress`
5. `result`

然后再按产品需求增补：

- `hook_*`
- `auth_status`
- `rate_limit_event`
- `files_persisted`
- `session_state_changed`

反过来说，最不该做的事情是：

- 只监听 `assistant`
- 用“最后一条消息类型”猜当前状态
- 忽略 `external_metadata`

## 12. 一句话总结

Claude Code 的宿主状态真相必须按“三层面”理解：`SDKMessage` 给时间线，`worker_status` 给当前态，`external_metadata` 给恢复后仍成立的黏性真相。
