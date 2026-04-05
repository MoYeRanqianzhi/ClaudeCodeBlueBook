# 结构宿主修复解除监护协议：authority release、resume stability seal、writeback release、anti-zombie archive与boundary retirement

这一章回答五个问题：

1. Claude Code 当前到底通过哪些正式对象让宿主、SDK、CI、评审与交接系统在结构 watch correction 之后消费解除监护、归档保证与 boundary retirement。
2. 哪些字段属于必须消费的结构 watch release object，哪些属于 release verdict 语义，哪些仍然不应被绑定成公共 ABI。
3. 为什么结构解除监护协议不应退回 pointer 健康感、telemetry 转绿与作者说明。
4. 宿主开发者该按什么顺序消费这套结构 watch release 规则面。
5. 哪些现象一旦出现应被直接升级为 release blocked、monitor extended 或 reopen required，而不是宣布“观察结束”。

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

- `StructureRepairWatchReleaseContract`

的单独公共对象。

但结构宿主修复解除监护实际上已经能围绕五类正式对象稳定成立：

1. `authority_release_seal`
2. `resume_stability_seal`
3. `writeback_release_seal`
4. `anti_zombie_archive`
5. `boundary_retirement`

更成熟的结构解除监护方式不是：

- 只看 pointer 还在
- 只看监控重新转绿
- 只看作者说“应该没事了”

而是：

- 围绕这五类对象消费结构真相面怎样在停止额外监护之后，仍继续维持单一 authority、唯一写回主路径与 anti-zombie 能力

## 2. authority release seal：最小解除监护对象

宿主应至少围绕下面对象消费结构解除监护真相：

1. `authority_object_after`
2. `authority_state_surface`
3. `writer_chokepoint`
4. `release_generation`
5. `pointer_demoted`
6. `release_scope`
7. `release_evaluated_at`

这些字段回答的不是：

- 旧入口是不是最近还活着

而是：

- 当前到底围绕哪个 authority object、以哪个结构边界合法解除额外监护

## 3. resume stability seal 与 writeback release seal

结构宿主还必须显式消费：

### 3.1 resume stability seal

1. `resume_closure_order`
2. `late_resume_detected`
3. `generation_regression_detected`
4. `stale_adoption_blocked`
5. `stability_sealed`

### 3.2 writeback release seal

1. `writeback_path`
2. `worker_status`
3. `external_metadata`
4. `merge_semantics`
5. `side_write_detected`
6. `writeback_released`

这说明宿主当前消费的不是：

- 一次 reconnect 成功
- 一串更漂亮的 telemetry

而是：

- `resume_stability_seal + writeback_release_seal` 共同组成的结构解除监护证明

## 4. anti-zombie archive 与 boundary retirement

结构解除监护还必须消费：

### 4.1 anti-zombie archive

1. `anti_zombie_projection`
2. `stale_writer_evidence`
3. `duplicate_or_orphan_control_state_resolved`
4. `transition_legality_snapshot`
5. `archive_pointer`

### 4.2 boundary retirement

1. `recovery_boundary`
2. `quarantine_scope`
3. `reopen_reservation`
4. `boundary_retired`
5. `retirement_attested`

这两组对象回答的不是：

- 现在是不是又能稳定连上
- 后面如果有问题是不是大家再试一次

而是：

- zombie 风险是否已经被正式归档并持续可审计
- recovery boundary 是否已经合法退休，同时仍保留正式 reopen reservation

## 5. release verdict：必须共享的解除监护语义

更成熟的结构宿主解除监护 verdict 至少应共享下面枚举：

1. `released`
2. `release_blocked`
3. `monitor_extended`
4. `pointer_based_release_rejected`
5. `side_write_risk_retained`
6. `zombie_archive_missing`
7. `boundary_not_retired`
8. `reopen_required`

这些 verdict reason 的价值在于：

- 把“现在可以不再额外盯防”翻译成宿主、CI、评审与交接都能共享的结构 post-watch 语义

## 6. 不应直接绑定为公共 ABI 的对象

宿主不应直接把下面内容绑成长期契约：

1. pointer mtime
2. sidecar 文件存在性
3. 监控成功率
4. PUT 次数
5. reconnect 按钮状态
6. 目录美学描述
7. archive prose 摘要
8. 作者口头说明

它们可以是解除监护线索，但不能是解除监护对象。

## 7. 解除监护顺序建议

更稳的顺序是：

1. 先验 `authority_release_seal`
2. 再验 `resume_stability_seal`
3. 再验 `writeback_release_seal`
4. 再验 `anti_zombie_archive`
5. 最后验 `boundary_retirement`

不要反过来做：

1. 不要先看 pointer。
2. 不要先看监控转绿。
3. 不要先看作者是否主观放心。

## 8. 一句话总结

Claude Code 的结构宿主修复解除监护协议，不是观察期结束归档 API，而是 `authority release seal + resume stability seal + writeback release seal + anti-zombie archive + boundary retirement` 共同组成的规则面。
