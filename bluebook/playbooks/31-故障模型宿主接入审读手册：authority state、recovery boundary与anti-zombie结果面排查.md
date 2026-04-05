# 故障模型宿主接入审读手册：authority state、recovery boundary与anti-zombie结果面排查

这一章不再解释故障模型支持面为什么重要，而是把它压成一张可持续执行的宿主接入审读手册。

它主要回答五个问题：

1. 团队怎样知道宿主当前仍在围绕 authority state、recovery boundary 与 anti-zombie 结果面消费结构故障模型。
2. 哪些症状最能暴露宿主正在猜状态、神化 pointer、崇拜恢复成功率。
3. 哪些检查点最适合作为宿主接入门禁，而不是靠作者解释当前结构状态。
4. 哪些故障模型宿主接法必须直接拒收，而不是等恢复出事后再补。
5. 怎样用苏格拉底式追问避免把这层写成“又一次恢复演练”。

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

对故障模型宿主接入来说，真正重要的不是：

- 找到了 pointer
- 恢复最后成功了
- spinner 看起来停了

而是：

- 宿主当前仍围绕同一个 authority state、recovery boundary 与 anti-zombie 结果面消费结构真相

所以这层审读最先要看的不是：

- 恢复是不是看起来顺了

而是：

1. authority state 是否仍来自正式状态面。
2. recovery asset 是否仍只是资产，而不是主真相。
3. stale-safe merge 与 anti-zombie 结果面是否仍可见。
4. later maintainer 是否还能仅靠宿主投影判断当前故障边界。

## 2. 回归症状

看到下面信号时，应提高警惕：

1. 宿主开始用 spinner、按钮状态或最后一条消息猜当前状态。
2. `bridgePointer` 一旦被找到，宿主就默认“恢复真相已经成立”。
3. 宿主只报恢复成功率，不报 stale writer、adopt 或 boundary 变化。
4. anti-zombie 结果面对宿主完全不可见。
5. later maintainer 仍然需要作者解释“为什么这次算恢复好了”。

## 3. 每轮检查点

每次宿主接入变更后，至少逐项检查：

1. `authority state continuity`
   - 宿主是否仍围绕 `session_state_changed + pending_action + permission_mode` 消费当前状态。
2. `generation evidence continuity`
   - 宿主是否仍只消费 anti-zombie 结果投影，而不绑定内部 generation 细节。
3. `recovery boundary continuity`
   - 宿主是否仍把 pointer、ledger、append-chain 当恢复资产，而不当主真相。
4. `anti-zombie continuity`
   - 宿主是否仍能看到 stale writer / stale merge / rejected outcome 的结果面。
5. `rollback continuity`
   - 当前回退动作是否仍围绕对象边界，而不是围绕目录图与成功率。

## 4. 直接拒收条件

出现下面情况时，应直接拒收：

1. 宿主自己猜 authority state，不消费正式状态面。
2. 宿主把 generation / 去重 / 竞速内部细节绑成公共契约。
3. 宿主把 `bridgePointer` 或其他恢复资产神化成当前真相。
4. 宿主只展示恢复成功率，不展示 boundary 与 stale writer 结果。
5. anti-zombie 结果面对宿主完全缺席。

## 5. 最小演练集

每轮至少跑下面五个宿主演练：

1. requires_action -> idle
   - 确认宿主围绕 authority state 投影切换，而不是围绕 UI heuristic。
2. stale finally / stale task patch 被拒绝
   - 确认宿主能看到 anti-zombie 的结果面。
3. pointer 过期 / schema 失效
   - 确认宿主把 pointer 当资产，不当真相。
4. append-chain adopt / retry
   - 确认宿主能区分“正在收敛”与“已经恢复完成”。
5. `rewind_files + seed_read_state`
   - 确认宿主能围绕回退与恢复边界消费结构对象。

## 6. 复盘记录最少字段

每次故障模型宿主 drift 至少记录：

1. `kernel_object_id`
2. `authority_state_surface`
3. `recovery_boundary`
4. `anti_zombie_projection`
5. `stale_writer_evidence`
6. `rollback_object`
7. `symptom`
8. `reject_reason`
9. `recovery_action`

## 7. 防再发动作

更稳的防再发顺序是：

1. 先把 authority state 从宿主猜测里救出来。
2. 先把 pointer 从“恢复真相”降回“恢复资产”。
3. 先把 stale writer / anti-zombie 结果面补回宿主。
4. 先让恢复边界可视化，而不是只展示成功率。
5. 最后才补更多 debug 细节或界面表现。

## 8. 苏格拉底式检查清单

在你准备宣布“故障模型宿主接入已经稳定”前，先问自己：

1. 宿主消费的是 authority state，还是自己猜出来的状态。
2. 宿主绑定的是结果面，还是内部 generation 细节。
3. recovery asset 在我的系统里还是资产，还是已经被神化成真相。
4. 我看到的是恢复边界，还是恢复成功率。
5. later maintainer 能否只靠宿主投影看见 anti-zombie 证据。

## 9. 一句话总结

真正成熟的故障模型宿主接入审读，不是看恢复最后成没成功，而是持续证明宿主仍围绕 authority state、recovery boundary 与 anti-zombie 结果面消费结构真相。
