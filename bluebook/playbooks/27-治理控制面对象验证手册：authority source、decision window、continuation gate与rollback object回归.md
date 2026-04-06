# 治理控制面对象验证手册：governance key、externalized truth chain、typed ask、decision window、continuation pricing 与 durable-transient cleanup 回归

这一章不再解释 `governance control plane` 为什么重要，而是把它压成一张长期运行里的验证手册。

它主要回答五个问题：

1. 团队怎样知道当前仍在围绕同一个治理对象做判断。
2. 哪些症状最能暴露治理已经从控制面退回 modal、阈值或仪表盘。
3. 哪些检查点最适合作为持续回归门禁。
4. 哪些 drift 必须直接拒收，而不是继续做局部优化。
5. 怎样用苏格拉底式追问避免把这层写成“又一套治理流程”。

## 0. 代表性源码锚点

- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:57-240`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:308-519`
- `claude-code-source-code/src/cli/structuredIO.ts:149-657`
- `claude-code-source-code/src/utils/permissions/permissions.ts:593-984`
- `claude-code-source-code/src/state/onChangeAppState.ts:43-92`
- `claude-code-source-code/src/utils/sessionState.ts:92-146`
- `claude-code-source-code/src/query/tokenBudget.ts:45-92`

## 1. 第一性原理

对治理对象来说，真正重要的不是：

- 现在还能审批
- 现在还能显示 token

而是：

- 当前边界、当前外化真相、当前 ask、当前窗口、当前继续条件与当前 cleanup 责任仍然围绕同一个对象成立

所以这层验证最先要看的不是表象，而是：

1. `governance key continuity`
2. `externalized truth chain continuity`
3. `typed ask continuity`
4. `decision window continuity`
5. `continuation pricing continuity`
6. `durable-transient cleanup continuity`

## 2. 回归症状

看到下面信号时，应提高警惕：

1. 团队开始只看 mode，而不看当前 `governance key`。
2. `worker_status / external_metadata / session_state_changed` 被宿主自己回放拼接，而不是先消费。
3. `pending_action` 被降级成一句“现在卡住了”。
4. `Context Usage` 被降级成一个 token 面板。
5. 继续条件开始只剩“再来一轮看看”。
6. cleanup 开始退回文件、commit 或情绪判断，而不是对象边界。

## 3. 每轮检查点

每次变更后，至少逐项检查：

1. `governance key continuity`
   - `sources / effective / applied / policy` 是否仍来自正式权威入口。
   - `permission_mode` 是否仍只是 projection，而不是 authority source 本体。
2. `externalized truth chain continuity`
   - `worker_status`、`external_metadata`、`session_state_changed` 是否仍属于同一当前真相链。
   - 宿主、CLI、bridge 是否仍在消费外化真相，而不是自己回放事件拼真相。
3. `typed ask continuity`
   - 当前 ask 是否仍由 `request_id / tool_use_id / decision_reason / winner_source` 支撑。
   - `pending_action` 是否仍是 ask transaction 的 witness，而不是 later 提示文案。
4. `decision window continuity`
   - 当前窗口是否仍把 `current_state + pending_action + Context Usage` 一起解释。
5. `continuation pricing continuity`
   - 当前 `continue / stop / upgrade object` 是否仍由 `decision gain + continuationCount + diminishingReturns` 定价。
6. `durable-transient cleanup continuity`
   - 当前失败路径是否仍知道回退到哪个对象、保留哪些 assets、清掉哪些 stale writers。

## 4. 直接拒收条件

出现下面情况时，应直接拒收：

1. `permission_mode` 越位成治理主语。
2. `worker_status / external_metadata / session_state_changed` 不再被共同读取为当前真相链。
3. `pending_action` 脱离 `request_id / tool_use_id / decision_reason / winner_source` 单独出现。
4. `Context Usage` 与当前状态不再被并排解释。
5. continuation 只看 token 数，不看 `decision gain`。
6. cleanup 被替换成“回退哪些文件”。

更稳的 reject trio 仍是：

1. `projection_usurpation`
2. `decision_window_collapse`
3. `free_expansion_relapse`

## 5. 复盘记录最少字段

每次治理 drift 至少记录：

1. `governance_object_id`
2. `governance_key_ref`
3. `truth_chain_ref`
4. `typed_ask_ref`
5. `decision_window_ref`
6. `continuation_pricing_ref`
7. `cleanup_carrier_ref`
8. `symptom`
9. `reject_reason`

## 6. 防再发动作

更稳的防再发顺序是：

1. 先补 `governance key` 的单一入口。
2. 先补 `externalized truth chain` 的单一读取路径。
3. 先补 `typed ask` 的事务对象，而不是只补弹窗语义。
4. 先补 `decision window` 与 `continuation pricing` 的同窗定价。
5. 最后才补更多阈值、弹窗或统计项。

## 7. 苏格拉底式检查清单

在你准备宣布“治理机制仍然健康”前，先问自己：

1. 当前所有判断是否仍围绕同一 `governance key`。
2. 现在看到的是外化真相链，还是几个分散面板。
3. `pending_action` 在这里还是事务 witness，还是已经变成提示文案。
4. continuation 是正式 pricing，还是默认继续。
5. cleanup 恢复的是对象边界，还是文件动作。
6. 如果把 modal 和 dashboard 藏起来，团队是否仍知道该如何判断。

## 8. 一句话总结

真正成熟的治理机制验证，不是看门禁还在不在，而是持续证明 `governance key -> externalized truth chain -> typed ask -> decision window -> continuation pricing -> durable-transient cleanup` 仍然是同一个判断链。
