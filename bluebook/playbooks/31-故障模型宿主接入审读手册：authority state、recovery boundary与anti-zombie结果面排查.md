# 结构宿主接入审读手册：authority object、per-host authority width、freshness gate 与 anti-zombie 证据排查

结构宿主接入真正要守住的，不是“恢复最后成没成功”，而是下面这条宿主消费链没有被替身化：

1. `authority object`
2. `per-host authority width`
3. `authoritative path`
4. `event-stream-vs-state-writeback`
5. `freshness gate`
6. `stale worldview / ghost capability`
7. `anti-zombie evidence`

`bridgePointer`、append-chain、resume file 与其他 recovery asset 只能帮助你回到当前真相，不能自己宣布当前真相。

## 0. 代表性源码锚点

- `claude-code-source-code/src/utils/sessionState.ts:92-149`
- `claude-code-source-code/src/state/onChangeAppState.ts:50-92`
- `claude-code-source-code/src/utils/QueryGuard.ts:55-121`
- `claude-code-source-code/src/cli/structuredIO.ts:149-187`
- `claude-code-source-code/src/cli/structuredIO.ts:561-657`
- `claude-code-source-code/src/utils/task/framework.ts:160-248`
- `claude-code-source-code/src/bridge/bridgePointer.ts:22-184`
- `claude-code-source-code/src/services/api/sessionIngress.ts:57-170`
- `claude-code-source-code/src/bridge/remoteBridgeCore.ts:824-880`

## 1. 第一性原理

对结构宿主接入来说，真正危险的不是：

- pointer 找不到
- spinner 转得很久
- 恢复偶尔失败

而是：

- recovery asset、event stream 或局部 width 开始冒充当前真相。

所以这层审读最先要问的不是“恢复是不是顺”，而是：

1. 宿主当前围绕哪个 `authority object` 在工作。
2. 宿主拿到的是不是合法 `per-host authority width`。
3. 当前 present truth 是沿哪条 `authoritative path` 被外化。
4. `freshness gate` 有没有先剥夺 stale writer 的写回资格。
5. stale worldview / ghost capability 是否真的会在过期后失效。

## 2. 回归症状

看到下面信号时，应提高警惕：

1. 宿主开始用 spinner、按钮状态或最后一条消息猜当前状态。
2. `bridgePointer` 一旦存在，宿主就默认“当前真相已经恢复”。
3. 宿主只报恢复成功率，不报 stale writer、head adoption、freshness gate 或 eviction 结果。
4. event stream 被当成 present truth 使用。
5. anti-zombie 结果面对宿主完全不可见。
6. later maintainer 仍需要作者解释“为什么这次算恢复好了”。

## 3. 每轮检查点

每次宿主接入变更后，至少逐项检查：

1. `authority object continuity`
   - 宿主是否仍围绕正式状态面消费当前真相，而不是自己猜测当前状态。
2. `per-host authority width continuity`
   - 宿主是否仍只消费自己那一份合法 width，而不是拿 event stream 自己拼 current truth。
3. `authoritative path continuity`
   - 当前 present truth 是否仍沿正式 writeback path 外化，而不是被日志、timeline 或 pointer 越权篡位。
4. `event-stream-vs-state-writeback continuity`
   - 宿主是否仍区分 timeline、internal history 与 current truth。
5. `freshness gate continuity`
   - stale finally、stale snapshot、stale pointer 与 stale task patch 是否仍会在写回前被正式撤权。
6. `recovery asset non-sovereignty`
   - pointer、ledger、append-chain、resume file 是否仍只被当成恢复资产，而不是 authority object。
7. `stale worldview / ghost capability eviction`
   - 过期 worldview、旧 capability、旧 head 假设是否仍会被主动降级或驱逐。
8. `anti-zombie evidence`
   - 宿主是否仍能看见 stale writer rejected、adopted head、evicted capability 等拒收证据。

## 4. 直接拒收条件

出现下面情况时，应直接拒收：

1. 宿主自己猜 `authority object`，不消费正式状态面。
2. 宿主把 width、generation 或去重内部细节绑成公共契约。
3. 宿主把 `bridgePointer`、append-chain 或 resume file 神化成当前真相。
4. 宿主让 event stream 直接宣布 current truth。
5. 宿主没有 freshness gate，只靠“最终成功了”掩盖 stale write。
6. 宿主完全看不见 anti-zombie 结果面。

## 5. 最小演练集

每轮至少跑下面六个宿主演练：

1. `requires_action -> idle`
   - 确认宿主围绕正式状态面切换，而不是围绕 UI heuristic。
2. stale finally / stale task patch 被拒绝
   - 确认宿主能看到 anti-zombie 的结果面。
3. `bridgePointer` 过期 / session head adoption
   - 确认宿主把 pointer 当资产，不当 authority object。
4. append-chain adopt / retry
   - 确认宿主能区分“正在收敛”与“已经恢复完成”。
5. `rewind_files + seed_read_state`
   - 确认宿主沿正式 writeback path 回到当前真相。
6. stale capability / stale worldview 被清理
   - 确认过期对象不会继续挂在当前世界里。

## 6. 复盘记录最少字段

每次结构宿主 drift 至少记录：

1. `authority_object_ref`
2. `per_host_authority_width`
3. `authoritative_path_ref`
4. `event_stream_non_sovereignty`
5. `freshness_gate_ref`
6. `recovery_asset_non_sovereignty`
7. `stale_worldview_evidence`
8. `ghost_capability_eviction`
9. `anti_zombie_evidence`
10. `symptom`
11. `reject_reason`
12. `recovery_action`

## 7. 防再发动作

更稳的防再发顺序是：

1. 先把 `authority object` 从宿主猜测里救出来。
2. 先把 `authoritative path` 与 `event-stream-vs-state-writeback` 分工补回宿主。
3. 先把 pointer 与其他恢复资产从“恢复真相”降回“恢复资产”。
4. 先把 `freshness gate` 与 stale writer 撤权证据补回宿主。
5. 先把 stale worldview / ghost capability 的降级与驱逐补回宿主。
6. 最后才补更多 debug 细节或界面表现。

## 8. 苏格拉底式检查清单

在你准备宣布“结构宿主接入已经稳定”前，先问自己：

1. 宿主消费的是 `authority object`，还是自己猜出来的状态。
2. 宿主绑定的是合法 width，还是内部 generation 细节。
3. 当前 present truth 是否仍沿正式 `authoritative path` 外化。
4. recovery asset 在我的系统里还是资产，还是已经被神化成真相。
5. stale writer 是否已在 `freshness gate` 前被正式撤权。
6. 宿主能否直接看见 stale worldview / ghost capability 的拒收证据。

## 9. 一句话总结

真正成熟的结构宿主接入审读，不是看恢复最后成没成功，而是持续证明宿主仍围绕 `authority object`、合法 `per-host authority width`、正式 `authoritative path`、`freshness gate` 与 `anti-zombie evidence` 消费当前真相。
