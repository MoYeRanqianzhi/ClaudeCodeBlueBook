# 结构宿主修复稳态纠偏再纠偏改写纠偏协议：contract、registry、current-truth surface、consumer subset、hotspot kernel 与 reopen boundary

这一章回答五个问题：

1. Claude Code 当前到底通过哪些正式对象，让宿主、SDK、CI、评审与交接系统在结构 rewrite correction 之后继续消费同一个结构真相。
2. 哪些字段属于必须消费的结构 rewrite object，哪些只属于 packet field、mirror gap note 或 rewrite hint。
3. 为什么结构 rewrite correction 不应退回 pointer 健康感、telemetry 转绿、archive prose 与作者说明。
4. 宿主开发者该按什么顺序消费这套结构 rewrite correction 规则面。
5. 哪些现象一旦出现应被直接升级为 reject、reentry 或 reopen，而不是继续宣布结构已经重新稳定。

## 0. 第一性原理

这一页不是一条新的结构对象链，而是 [39](39-结构%20Host%20Artifact%20Contract：权威路径、恢复资产、反zombie%20与交接包字段骨架.md) 与 [42](42-结构%20Artifact%20Rule%20ABI：Authoritative%20Path、Recovery%20Asset、Anti-Zombie%20与%20Reject%20语义的机器可读结构.md) 在 rewrite correction 层的继续展开。

因此它必须继续围绕同一条源码真相链工作：

1. `contract`
2. `registry`
3. `current-truth surface`
4. `consumer subset`
5. `hotspot kernel`
6. `mirror gap discipline`

只有这条链站稳，后面的 `reentry / reopen` 才不是第二主权面。

## 1. 哪些内容只配做 carrier 或 hint

下面这些内容仍可保留，但必须降回 packet field、mirror gap note 或 rewrite hint：

1. `rewrite_correction_session_object`
2. `false_surface_demotion_set`
3. `transport boundary attestation`
4. `dirty_git_fail_closed_attested`
5. `reopen liability rebinding`
6. `rewrite_correction_verdict`

它们的职责不是定义结构世界，而是说明：

- 这次 correction 怎样被记录
- 哪些假 surface 被降级
- later maintainer 将来如何拒收或重开

## 2. 必须消费的结构 rewrite object

### 2.1 `contract`

宿主至少应消费：

1. `contract_ref`
2. `structure_object_type`
3. `structure_object_id`

### 2.2 `registry`

宿主还必须消费：

1. `registry_ref`
2. `registry_generation`
3. `registry_attested_at`

### 2.3 `current-truth surface`

宿主还必须消费：

1. `current_truth_surface_ref`
2. `authoritative_path`
3. `current_write_path`
4. `writer_chokepoint`
5. `one_writable_present_witness`

### 2.4 `consumer subset`

宿主还必须消费：

1. `consumer_subset_ref`
2. `projection_demoted`
3. `pointer_not_authority`
4. `telemetry_not_evidence`

### 2.5 `hotspot kernel`

宿主还必须消费：

1. `hotspot_kernel_ref`
2. `fresh_merge_contract`
3. `anti_zombie_evidence_ref`
4. `transport_boundary_ref`
5. `fail_closed_witness`

### 2.6 `mirror gap discipline`

最后才允许暴露：

1. `mirror_gap_ref`
2. `later_reject_path`
3. `reopen_boundary`
4. `reentry_required_when`
5. `reopen_required_when`

这里最重要的是：

- transport、dirty worktree、unpushed commits 与 reopen boundary 都只配在 mirror gap / later reject path 层出现，不配再长成新的 sovereignty object。

## 3. rewrite correction 消费顺序建议

更稳的顺序是：

1. 先验 `contract`
2. 再验 `registry`
3. 再验 `current-truth surface`
4. 再验 `consumer subset`
5. 再验 `hotspot kernel`
6. 最后才给 `mirror gap discipline`

不要反过来做：

1. 不要先看 pointer。
2. 不要先看 telemetry 转绿。
3. 不要先看 archive prose 是否更完整。
4. 不要先看作者是否主观放心。

## 4. shared reject semantics

这页真正该继承的不是一套更长的 verdict ontology，而是共享拒收语义：

1. `authority_conflict`
2. `writeback_target_ambiguous`
3. `lineage_mismatch`
4. `duplicate_or_zombie`
5. `workspace_not_clean`
6. `reopen_boundary_invalid`

更上层仍要回到结构线稳定的 reject trio：

1. `layout-first drift`
2. `recovery-sovereignty leak`
3. `surface-gap blur`

## 5. 不应直接绑定成公共 ABI 的对象

宿主不应直接把下面内容绑成长期契约：

1. pointer mtime
2. reconnect 按钮状态
3. telemetry 绿灯
4. 单次截图
5. archive prose 摘要
6. 作者口头说明
7. “最近没再出事”的健康感
8. 临时 sidecar 的存在感

它们可以是 rewrite correction 线索，但不能是 rewrite correction 对象。

## 6. 苏格拉底式检查清单

在你准备宣布“结构已完成 rewrite correction”前，先问自己：

1. 我现在修回的是同一个 `current-truth surface`，还是只是把入口感重新包装了一遍。
2. 我现在保住的是 `one writable present`，还是几次幸运 reconnect 的结果。
3. 我现在证明的是 `fresh merge + anti-zombie + fail-closed`，还是只是在享受一张安静的 telemetry 面板。
4. later maintainer 明天如果必须 reject，依赖的是正式 `later_reject_path`，还是一句“以后再试一次”。
5. 如果把 pointer、telemetry、archive prose 与作者说明全部藏起来，这页是否仍然成立。

## 7. 一句话总结

Claude Code 的结构宿主修复稳态纠偏再纠偏改写纠偏协议，不是把健康感写成更正式的流程，而是继续沿 `contract -> registry -> current-truth surface -> consumer subset -> hotspot kernel -> mirror gap discipline` 把 `one writable present`、fail-closed 与 later maintainer rejectability 写硬。
