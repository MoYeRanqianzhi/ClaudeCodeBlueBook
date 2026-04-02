# 结构宿主修复监护协议：authority watch、writeback watch、anti-zombie watch与boundary quarantine

这一章回答五个问题：

1. Claude Code 当前到底通过哪些正式对象让宿主、SDK、CI、评审与交接系统在结构收口之后继续消费 authority watch、writeback watch、anti-zombie watch 与 reopen。
2. 哪些字段属于必须消费的结构 post-closeout watch object，哪些属于 watch verdict 语义，哪些仍然不应被绑定成公共 ABI。
3. 为什么结构监护协议不应退回 pointer 健康感、监控转绿与作者说明。
4. 宿主开发者该按什么顺序消费这套结构 watch 规则面。
5. 哪些现象一旦出现应被直接升级为 reopen required 或 handoff blocked，而不是继续围绕监控与说明解释。

## 0. 关键源码锚点

- `claude-code-source-code/src/utils/QueryGuard.ts:1-121`
- `claude-code-source-code/src/utils/handlePromptSubmit.ts:430-517`
- `claude-code-source-code/src/utils/task/framework.ts:77-248`
- `claude-code-source-code/src/utils/sessionRestore.ts:435-490`
- `claude-code-source-code/src/utils/conversationRecovery.ts:533-570`
- `claude-code-source-code/src/state/onChangeAppState.ts:50-92`
- `claude-code-source-code/src/utils/sessionState.ts:92-149`
- `claude-code-source-code/src/services/api/sessionIngress.ts:57-170`
- `claude-code-source-code/src/bridge/bridgePointer.ts:22-184`
- `claude-code-source-code/src/cli/transports/WorkerStateUploader.ts:3-112`
- `claude-code-source-code/src/cli/structuredIO.ts:362-657`
- `claude-code-source-code/src/cli/print.ts:5048-5067`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:578-619`

## 1. 先说结论

Claude Code 当前并没有公开一份名为：

- `StructureRepairWatchContract`

的单独公共对象。

但结构宿主修复监护实际上已经能围绕五类正式对象稳定成立：

1. `authority_watch`
2. `resume_regression_watch`
3. `writeback_watch`
4. `anti_zombie_watch`
5. `boundary_quarantine`

更成熟的结构监护方式不是：

- 只看 pointer 还在
- 只看监控是不是转绿
- 只看作者说‘应该没问题了’

而是：

- 围绕这五类对象消费结构真相面怎样在 closeout 之后继续防止 authority drift、resume regression、旁路写回与 stale path 回魂

## 2. authority watch：最小监护对象

宿主应至少围绕下面对象消费结构监护真相：

1. `kernel_watch_id`
2. `authority_object_after`
3. `authority_state_surface`
4. `seal_generation`
5. `writer_chokepoint`
6. `watch_deadline`
7. `breadcrumb_demoted`

这些字段回答的不是：

- 现在旧入口是不是还活着

而是：

- 当前到底围绕哪个 authority object 继续观察 post-closeout drift

## 3. resume regression watch 与 writeback watch

结构宿主还必须显式消费：

### 3.1 resume regression watch

1. `resume_closure_order`
2. `late_resume_detected`
3. `stale_adoption_blocked`
4. `generation_regression_detected`
5. `order_regression_cleared`

### 3.2 writeback watch

1. `writeback_path`
2. `worker_status`
3. `external_metadata`
4. `merge_semantics`
5. `side_write_detected`

这说明宿主当前消费的不是：

- 一次 reconnect 成功
- 一串漂亮的日志

而是：

- `resume regression watch + writeback watch` 共同组成的结构监护对象

## 4. anti-zombie watch 与 boundary quarantine

结构监护还必须消费：

### 4.1 anti-zombie watch

1. `anti_zombie_projection`
2. `stale_writer_evidence`
3. `duplicate_or_orphan_control_state_resolved`
4. `transition_legality_snapshot`
5. `regression_detected`

### 4.2 boundary quarantine

1. `recovery_boundary`
2. `rollback_object`
3. `re_entry_condition`
4. `reconnect_quarantined`
5. `quarantine_cleared`

这两组对象回答的不是：

- 现在是不是又能连上了
- later 团队是不是还能再试一次

而是：

- stale path 是否仍被正式压制并持续可审计
- 当前 recovery boundary 是否仍被隔离并在什么条件下必须 reopen

## 5. watch verdict：必须共享的监护语义

更成熟的结构宿主监护 verdict 至少应共享下面枚举：

1. `stable_under_watch`
2. `authority_drift_detected`
3. `resume_regression_detected`
4. `writeback_drift_detected`
5. `anti_zombie_regression_detected`
6. `boundary_drift_detected`
7. `handoff_blocked`
8. `reopen_required`

这些 verdict reason 的价值在于：

- 把“现在先观察”翻译成宿主、CI、评审与交接都能共享的结构 post-closeout 语义

## 6. 不应直接绑定为公共 ABI 的对象

宿主不应直接把下面内容绑成长期契约：

1. pointer mtime
2. sidecar 文件存在性
3. 监控成功率
4. spinner / loading UI
5. PUT 次数
6. reconnect 按钮状态
7. 目录美学描述
8. 作者口头说明

它们可以是监护线索，但不能是监护对象。

## 7. 监护顺序建议

更稳的顺序是：

1. 先验 `authority_watch`
2. 再验 `resume_regression_watch`
3. 再验 `writeback_watch`
4. 再验 `anti_zombie_watch`
5. 最后验 `boundary_quarantine`

不要反过来做：

1. 不要先看 pointer。
2. 不要先看监控转绿。
3. 不要先看 reconnect 是否暂时可用。

## 8. 一句话总结

Claude Code 的结构宿主修复监护协议，不是 closeout 之后的观察清单 API，而是 `authority watch + resume regression watch + writeback watch + anti-zombie watch + boundary quarantine` 共同组成的规则面。
