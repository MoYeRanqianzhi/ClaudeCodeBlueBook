# 结构宿主验收执行手册：authority object、writeback path、freshness gate 与 reopen 边界

结构宿主验收真正要执行的，不是“恢复看起来成功”或“验收卡已经填完”，而是下面这条执行链仍围绕同一个当前真相成立：

1. `authority object`
2. `per-host authority width`
3. `authoritative path`
4. `event-stream-vs-state-writeback`
5. `freshness gate`
6. `stale worldview / ghost capability`
7. `anti-zombie evidence`
8. `reopen boundary`

`resume order` 只能作为 re-entry proof 的子证据，不能继续和 authority object 并列为一级主语。

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
- `claude-code-source-code/src/cli/print.ts:5048-5072`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:578-619`

## 1. 第一性原理

结构宿主验收真正要拒绝的，不是局部报错，而是过去重新写坏现在：

- pointer 冒充当前真相
- event stream 冒充 state writeback
- stale worldview 继续签发允许
- ghost capability 继续挂在当前世界
- stale writer、late finally 或旧 snapshot 在验收后回魂

所以这层 playbook 最先要看的不是“恢复似乎成功了”，而是：

1. 当前 `authority object` 是否唯一。
2. 当前 present truth 是否仍沿正式 `authoritative path` 外化。
3. 当前 `event-stream-vs-state-writeback` 是否仍严格分层。
4. 当前 `freshness gate` 是否先于 continuity 生效。
5. 当前 `reopen boundary` 是否仍能告诉 later 团队从哪个正式对象重新进入。

## 2. 共享验收卡最小字段

每次结构宿主验收，宿主、CI、评审与交接系统至少应共享：

1. `authority_object`
2. `per_host_authority_width`
3. `authoritative_path_ref`
4. `writeback_primary_path`
5. `event_stream_writeback_split`
6. `freshness_gate_attested`
7. `re_entry_proof_ref`
8. `stale_worldview_evidence`
9. `ghost_capability_eviction_state`
10. `anti_zombie_evidence_ref`
11. `transport_boundary_attested`
12. `reject_verdict`
13. `verdict_reason`
14. `reopen_boundary`
15. `return_authority_object`

四类消费者的分工应固定为：

1. 宿主看 `authority object`、width 与 `writeback_primary_path` 是否仍唯一。
2. CI 看 `event-stream-vs-state-writeback`、`freshness gate`、`stale worldview` 与 `ghost capability eviction` 是否完整。
3. 评审看 pointer、breadcrumb、恢复资产与 live truth 是否仍被清楚分层。
4. 交接看 later 团队能否只凭验收卡重建同一 reject 与 reopen 判断。

## 3. 固定执行顺序

### 3.1 先验 `authority object` 与合法 width

先看：

1. 当前 query、task、session 或 remote worker 是否仍有唯一 `authority object`。
2. 每个 host / consumer 是否只消费自己的合法 width。
3. UI heuristic 是否没有冒充 authority。

### 3.2 再验 `authoritative path` 与 `event-stream-vs-state-writeback`

再看：

1. 当前 present truth 是否仍沿正式 `writeback_primary_path` 外化。
2. `event stream` 是否仍只保留时间线，不重建 current truth。
3. 是否存在任何旁路写回绕过主 choke point。

### 3.3 再验 `freshness gate` 与 re-entry proof

再看：

1. stale finally、stale snapshot、stale pointer 与 stale task patch 是否仍会在写回前被撤权。
2. restore / hydrate / adopt 是否仍只是 re-entry proof，而不是新的 authority root。
3. `resume order` 是否只作为 re-entry proof 被消费，而不是冒充当前真相。

### 3.4 再验 stale worldview / ghost capability

再看：

1. validator、adapter 与 host consumer 是否仍站在 fresh worldview 上判断。
2. 旧 capability、旧 token、旧 head 假设是否仍会被主动驱逐。
3. 宿主是否仍能看到 eviction 与降级证据。

### 3.5 最后验 anti-zombie evidence 与 reopen boundary

最后才看：

1. stale writer、late response、duplicate / orphan control response 是否仍被显式拒收。
2. 当前 reject verdict 是否仍能跨宿主、CI、评审与交接共享。
3. 当前 `reopen boundary` 是否仍能明确告诉 later 团队回到哪个 authority object、哪条 writeback path、哪个 freshness floor。

## 4. 直接拒收条件

出现下面情况时，应直接拒收当前结构宿主实现：

1. `ui_heuristic_authority`
2. `pointer_usurps_truth`
3. `event_stream_rebuilds_present`
4. `freshness_gate_missing`
5. `stale_worldview_unchecked`
6. `ghost_capability_not_evicted`
7. `anti_zombie_evidence_missing`
8. `reopen_boundary_unknown`

## 5. 拒收升级与回退顺序

看到 reject verdict 之后，更稳的处理顺序是：

1. 先停止新的 resume、adopt 与 reconnect，不再让旧资产继续写回。
2. 先把 pointer、sidecar 与 UI 投影降回 breadcrumb，不再让它们充当 authority。
3. 先回到上一个仍可验证的 `authority object`、`writeback_primary_path` 与 `freshness_gate`。
4. 先重建 stale worldview / ghost capability 的降级与驱逐，再重跑 re-entry proof。
5. 如果根因落在单一写点、freshness gate 或 reopen boundary，就回跳 `../guides/59` 做制度纠偏。

## 6. 回退演练集

每轮至少跑下面八个结构宿主验收演练：

1. `stale finally`
2. `terminal task revive`
3. `pointer stale but session alive`
4. `worker reconnect hydrate`
5. `duplicate_orphan_control_response`
6. `sidecar_only_recovery`
7. `stale_validator_worldview`
8. `ghost_capability_eviction`

## 7. 复盘记录最少字段

每次结构宿主验收失败或回退，至少记录：

1. `authority_object`
2. `authoritative_path_ref`
3. `writeback_path_gap`
4. `freshness_gate_gap`
5. `worldview_gap`
6. `ghost_capability_gap`
7. `anti_zombie_gap`
8. `reject_verdict`
9. `rollback_action`
10. `reopen_boundary`
11. `re_entry_condition`

## 8. 苏格拉底式检查清单

在你准备宣布“结构宿主验收已经稳定运行”前，先问自己：

1. 当前 `authority object` 到底是什么。
2. 当前 present truth 是从哪条 `authoritative path` 回灌的。
3. event stream 与 writeback 面有没有被混写。
4. `resume order` 现在是 re-entry proof，还是被偷升成 authority root。
5. validator / adapter 看到的是 fresh worldview，还是 stale worldview。
6. 如果丢掉部分中间事件，最终 authority state 是否仍正确。
7. 当前 `reopen boundary` 能否让 later 团队只凭正式对象重新进入。

## 9. 一句话总结

真正成熟的结构宿主验收执行，不是让恢复路径看起来更顺，而是持续证明 `authority object`、正式 `writeback path`、`freshness gate`、`anti-zombie evidence` 与 `reopen boundary` 仍然指向同一个当前真相。
