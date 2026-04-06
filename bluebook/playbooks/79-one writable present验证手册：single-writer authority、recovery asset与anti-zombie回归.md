# one writable present验证手册：per-host authority width、event stream / state writeback、stale worldview与ghost capability回归

这一章不再解释源码先进性为什么成立，而是把 `architecture/84`、`philosophy/86` 与 `guides/101` 继续压成一张长期运行里的验证手册。

它主要回答五个问题：

1. 团队怎样知道当前仍在围绕同一个 one writable present 工作。
2. 哪些症状最能暴露结构已经退回多写入面、恢复篡位或 stale write 复活。
3. 哪些检查点最适合作为持续回归门禁。
4. 哪些 drift 必须直接拒收，而不是继续靠目录整理或作者记忆兜底。
5. 怎样用苏格拉底式追问避免把这层写成“结构卫生检查表”。

## 0. 代表性源码锚点

- `claude-code-source-code/src/entrypoints/cli.tsx:16-33`
- `claude-code-source-code/src/query/config.ts:8-45`
- `claude-code-source-code/src/query/deps.ts:8-40`
- `claude-code-source-code/src/utils/QueryGuard.ts:1-121`
- `claude-code-source-code/src/state/onChangeAppState.ts:43-92`
- `claude-code-source-code/src/services/api/sessionIngress.ts:60-211`
- `claude-code-source-code/src/cli/transports/WorkerStateUploader.ts:3-112`
- `claude-code-source-code/src/bridge/bridgePointer.ts:22-184`
- `claude-code-source-code/src/utils/task/framework.ts:158-269`

## 1. 第一性原理

对 one writable present 来说，真正重要的不是：

- 目录看起来更整齐

而是：

- 现在时态的写入权仍没有被过去对象、错误恢复资产与错误边界重新夺走

所以这层验证最先要看的不是分层截图，而是：

1. authority-width continuity
2. recovery asset non-sovereignty continuity
3. event-stream-vs-state-writeback continuity
4. freshness-gate continuity
5. stale-worldview continuity
6. ghost-capability continuity
7. release-surface shaping continuity
8. later-maintainer rejectability continuity

## 2. 回归症状

看到下面信号时，应提高警惕：

1. 多个 host、adapter 或 projection 开始并行宣布当前真相。
2. pointer、ledger、resume file 开始被当成主真相使用。
3. stale finally、旧 snapshot、旧 pointer 开始回写 fresh state。
4. event stream 开始临时重建 state writeback。
5. validator、adapter 或 host consumer 站在 stale worldview 上继续判断。
6. ghost capability token、旧 pin 或旧 authority width 继续冒充 live authority。
7. compile-time / runtime / artifact gate 混成一层。
8. later maintainer 只能靠作者记忆才能判断哪里最危险。

## 3. 每轮检查点

每次变更后，至少逐项检查：

1. `authority-width continuity`
   - 当前真相是否仍只有一个正式 authority object，各个 host 只消费自己的合法 width。
2. `recovery asset non-sovereignty continuity`
   - 恢复资产是否仍只帮助找回 authority，而不宣布 authority。
3. `event-stream-vs-state-writeback continuity`
   - append-only 时间线与 authoritative current-state surface 是否仍严格分层。
4. `freshness-gate continuity`
   - 旧 head、旧 generation、旧 pointer 是否仍在写回前就被 freshness gate 剥夺 authority。
5. `stale-worldview continuity`
   - validator、adapter 与 host consumer 是否仍不会站在 stale worldview 上继续发放允许。
6. `ghost-capability continuity`
   - dead capability token、旧 pin、旧 authority width 是否仍会 eviction，而不是继续篡位。
7. `anti-zombie continuity`
   - stale finally、stale snapshot、stale pointer 是否仍被正式拒绝。
8. `release shaping continuity`
   - compile-time、runtime 与 artifact 三层边界是否仍然分层。
9. `later-maintainer rejectability continuity`
   - later maintainer 是否仍能直接看出危险改动面与 reject 条件。

## 4. 直接拒收条件

出现下面情况时，应直接拒收：

1. `multi_writer_truth_detected`
2. `per_host_projection_claimed_authority`
3. `recovery_asset_usurped_authority`
4. `event_stream_usurped_present`
5. `freshness_gate_missing`
6. `stale_worldview_unchecked`
7. `ghost_capability_not_evicted`
8. `compile_runtime_artifact_conflated`
9. `later_maintainer_needs_author_memory`

## 5. 复盘记录最少字段

每次 drift 至少记录：

1. `authority_object_id`
2. `per_host_authority_width`
3. `recovery_asset_ledger`
4. `event_stream_writeback_split`
5. `freshness_gate_attested`
6. `stale_worldview_evidence`
7. `ghost_capability_eviction_state`
8. `anti_zombie_evidence`
9. `release_surface_matrix`
10. `symptom`
11. `reject_reason`
12. `rollback_object`
13. `later_maintainer_risk_note`

## 6. 防再发动作

更稳的防再发顺序是：

1. 先补 authority object 与 per-host authority width。
2. 先补 recovery asset 非主权边界。
3. 先补 event stream / state writeback 分层与 freshness gate。
4. 先补 stale worldview guard 与 ghost capability eviction。
5. 先补 generation / fresh-merge / stale-drop 约束。
6. 先补 compile/runtime/artifact 三层边界。
7. 最后才谈目录整理或抽象美学。

## 7. 苏格拉底式检查清单

在你准备宣布“内核结构仍然健康”前，先问自己：

1. 当前到底谁配写当前真相，各个 host 各配消费多宽的 authority。
2. recovery asset 是在帮助恢复，还是已经偷偷篡位。
3. event stream 和 state writeback 有没有被错误混成一层。
4. validator、adapter 与 host consumer 看到的是 fresh worldview，还是 stale worldview。
5. ghost capability token 有没有被正式驱逐，而不是留在系统里等复活。
6. 过去的对象是不是仍无法写坏现在。
7. compile-time、runtime 与 artifact 三层边界有没有被混写。
8. later maintainer 能不能不问作者就看出哪里最危险。
9. 如果删掉漂亮目录图，这套结构先进性还剩下什么。

## 8. 一句话总结

真正成熟的源码验证，不是看结构还整不整齐，而是持续证明 one writable present 仍然成立：同一个 authority object 只按合法 width 被消费，event stream 不篡位 state writeback，freshness gate 先剥夺旧 authority，stale worldview 与 ghost capability 不得继续冒充 live authority。
