# 如何把结构宿主修复稳态纠偏执行失真压回结构真相面：固定纠偏顺序、拒收升级路径与correction、archive与responsibility改写模板骨架

这一章不再解释结构宿主修复稳态纠偏执行最常怎样失真，而是把 Claude Code 式结构 correction-of-correction 压成一张可执行的 builder-facing 手册。

它主要回答五个问题：

1. 为什么结构 correction-of-correction 真正要救回的不是“系统重新恢复秩序感”，而是同一个结构真相面。
2. 怎样把假修正、伪复证、旁路写回与假责任保留压回固定纠偏顺序。
3. 哪些现象应被直接升级为硬拒收，而不是继续补 correction、archive 与责任文案。
4. 怎样把 correction card、archive restitution 与 reopen responsibility 重新压回结构对象骨架。
5. 怎样用苏格拉底式追问避免把纠偏写成“把系统修正流程再做细一点”。

## 0. 代表性源码锚点

- `claude-code-source-code/src/utils/QueryGuard.ts:1-121`
- `claude-code-source-code/src/utils/handlePromptSubmit.ts:430-517`
- `claude-code-source-code/src/utils/task/framework.ts:77-248`
- `claude-code-source-code/src/utils/sessionRestore.ts:435-490`
- `claude-code-source-code/src/utils/conversationRecovery.ts:533-570`
- `claude-code-source-code/src/services/api/sessionIngress.ts:57-170`
- `claude-code-source-code/src/bridge/bridgePointer.ts:22-184`
- `claude-code-source-code/src/cli/transports/WorkerStateUploader.ts:3-112`
- `claude-code-source-code/src/utils/sessionState.ts:1-149`
- `claude-code-source-code/src/state/onChangeAppState.ts:50-92`
- `claude-code-source-code/src/cli/structuredIO.ts:362-657`
- `claude-code-source-code/src/cli/print.ts:5048-5072`

## 1. 第一性原理

结构 correction-of-correction 真正要救回的不是：

- 更像样的 correction 流程
- 更完整的 archive 清单
- 更谨慎的 reopen 提示

而是：

- 无人继续盯防时，同一个结构真相面仍成立

结构先进性的真正前提不是目录更整洁，而是：

- `authority surface` 继续只有一个主语
- `single-source` 没有被第二来源篡位
- `anti-cycle seam` 没有被重依赖击穿
- `anti-zombie evidence` 仍然比 archive prose 更权威

更具体地说，要救回的是：

1. `authority rebind` 仍由唯一 authority object 支撑，而不是由 pointer 可达性支撑。
2. `resume lineage rebuild` 仍由 lineage 与正式顺序支撑，而不是由几次 reconnect 成功感支撑。
3. `writeback recustody` 仍由唯一主写点支撑，而不是由 telemetry 繁荣支撑。
4. `anti-zombie reproof` 与 `archive truth restitution` 仍由 stale / orphan 清退证据支撑，而不是由复盘 prose 与作者说明支撑。
5. `reservation rebinding` 仍保留未来推翻当前 correction 的正式边界，而不是退回“以后再 reconnect”。

所以更稳的纠偏目标不是：

- 先把 correction 与 archive 文档写完整

而是：

1. 先把 pointer、side-write、旧路径与监控转绿降回投影。
2. 先把 authority、resume 与 writeback 重新拉回同一个结构对象。
3. 先把 anti-zombie 与 archive 从 prose 拉回证据。
4. 先把 responsibility 从 reconnect 提示拉回正式边界。

## 2. 固定纠偏顺序

### 2.1 先冻结假 correction

第一步不是补 correction note，而是：

1. demote pointer、sidecar、旧路径与监控转绿，让它们回到辅助信号。
2. 恢复 `authority_object_id`、`authority_state_surface` 与 `correction_generation` 的统一真相面。
3. 禁止入口存在感再次充当 correction 的主对象。

### 2.2 再恢复 `authority_rebind`

第二步要救回：

1. `authority_object_id`
2. `authoritative_path`
3. `authority_state_surface`
4. `writer_chokepoint`
5. `single_source_refs`
6. `dependency_seam_status`
7. `correction_generation`
8. `authority_rebind`

只要 authority 还靠 pointer 与作者说明维持，就不能 restored。

### 2.3 再恢复 `resume_lineage_rebuild`

第三步要修的是：

1. `resume_closure_order`
2. `late_resume_detected`
3. `generation_regression_detected`
4. `return_lineage`
5. `resume_lineage_rebuild`

不要把 reconnect 成功感当作顺序稳定。

### 2.4 再恢复 `writeback_recustody`

第四步要把写回从结果感拉回唯一主路径：

1. `writeback_path`
2. `worker_status`
3. `external_metadata`
4. `side_write_detected`
5. `writeback_recustody`

没有这一步，correction 仍只是“结果暂时没坏”。

### 2.5 再恢复 `anti_zombie_reproof` 与 `archive_truth_restitution`

第五步要救回：

1. `anti_zombie_projection`
2. `stale_writer_evidence`
3. `archive_truth`
4. `archive_pointer`
5. `anti_zombie_reproof`
6. `archive_truth_restitution`

只要这一步没修好，later 团队继承的就仍是一条假连续时间线。

### 2.6 最后恢复 `reservation_rebinding`

最后才修未来重新推翻当前 correction 的合法回跳边界：

1. `recovery_boundary`
2. `reservation_owner`
3. `reopen_trigger`
4. `threshold_retained_until`
5. `return_writeback_path`
6. `reservation_rebinding`

不要反过来：

1. 不要先删临时痕迹，再修 authority。
2. 不要先写“以后再 reconnect”，再修 reservation。
3. 不要先交付 archive 文本，再修 anti-zombie 证据。

## 3. 硬拒收规则

出现下面情况时，应直接升级为硬拒收：

1. `steady_correction_object_missing`
2. `authority_rebind_missing`
3. `pointer_based_restore_detected`
4. `resume_lineage_unproven`
5. `writeback_recustody_missing`
6. `anti_zombie_reproof_missing`
7. `archive_truth_unrestored`
8. `reservation_boundary_unbound`

## 4. 模板骨架

### 4.1 correction card 骨架

1. `correction_card_id`
2. `authority_object_id`
3. `authoritative_path`
4. `single_source_refs`
5. `dependency_seam_status`
6. `authority_rebind_ref`
7. `resume_lineage_rebuild_ref`
8. `writeback_recustody_ref`
9. `anti_zombie_reproof_ref`
10. `archive_truth_restitution_ref`
11. `reservation_rebinding_ref`
12. `correction_verdict`
13. `verdict_reason`

### 4.2 archive restitution block 骨架

1. `archive_restitution_block_reason`
2. `authority_gap`
3. `resume_gap`
4. `writeback_gap`
5. `anti_zombie_gap`
6. `archive_truth_gap`
7. `fallback_verdict`

### 4.3 reopen responsibility ticket 骨架

1. `reopen_responsibility_id`
2. `recovery_boundary`
3. `reservation_owner`
4. `reopen_trigger`
5. `threshold_retained_until`
6. `return_authority_object`
7. `return_writeback_path`
8. `handoff_block_condition`

## 5. 苏格拉底式检查清单

在你准备宣布“结构 steady-state correction execution distortion 已纠偏完成”前，先问自己：

1. 我现在保护的是 authority object，还是一个还没失效的入口感。
2. 我现在验证的是 resume lineage，还是几次幸运成功的 reconnect。
3. 我现在托管的是唯一 writeback 主路径，还是监控转绿带来的安心感。
4. 我现在归档的是 anti-zombie 证据，还是一段更会解释的复盘文本。
5. 如果明天必须 reopen，我保留下来的到底是正式 boundary，还是一句“以后再试一次”。

## 6. 一句话总结

真正成熟的结构宿主修复稳态纠偏再纠偏，不是把 correction、archive 与责任流程写得更像制度，而是把假修正、伪复证、旁路写回与假责任保留重新压回同一个结构真相面。
