# 治理宿主接入审读手册：governance key、externalized truth、typed ask与rollback object排查

这一章不再解释统一定价治理为什么重要，而是把它压成一张可持续执行的宿主接入审读手册。

它主要回答五个问题：

1. 团队怎样知道宿主当前仍在围绕同一个治理对象消费 `governance key -> externalized truth chain -> typed ask -> decision window -> continuation pricing -> rollback object`。
2. 哪些症状最能暴露 mode 崇拜、pending action 降格、Context Usage 仪表盘化与文件级回退。
3. 哪些检查点最适合作为宿主接入门禁，而不是靠经验排障。
4. 哪些治理宿主接法必须直接拒收，而不是等线上再救火。
5. 怎样用苏格拉底式追问避免把这层写成“再多做一次权限联调”。

## 0. 代表性源码锚点

- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:106-260`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:308-328`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:475-519`
- `claude-code-source-code/src/cli/structuredIO.ts:470-639`
- `claude-code-source-code/src/utils/sessionState.ts:15-45`
- `claude-code-source-code/src/utils/sessionState.ts:92-149`
- `claude-code-source-code/src/state/onChangeAppState.ts:43-92`
- `claude-code-source-code/src/query/tokenBudget.ts:45-92`
- `claude-code-source-code/src/cli/print.ts:2961-3010`

## 1. 第一性原理

对治理宿主接入来说，真正重要的不是：

- mode 已经能切换
- 弹窗已经能出现
- token 已经能显示

而是：

- 宿主当前仍在围绕同一个治理对象消费 `governance key`、`externalized truth chain`、`typed ask`、`decision window`、`continuation pricing` 与 `rollback object`

所以这层审读最先要看的不是：

- 交互流程顺不顺

而是：

1. `governance key` 是否仍完整存在，而不是只剩 mode 投影。
2. `typed ask` 是否仍是 externalized object，而不是提示语。
3. Context Usage 是否仍在解释 `decision window`。
4. continuation 是否仍围绕同一 settled state 与 externalized truth chain。
5. rollback 是否仍围绕 `durable assets` 与 `transient authority` 的分界，而不是围绕文件。

## 2. 回归症状

看到下面信号时，应提高警惕：

1. 宿主只看 `permission_mode`，不看 `governance key`。
2. `pending_action` 或 typed ask 被降格成“当前卡住了”的一段文案，或靠事件流反推。
3. Context Usage 只剩 token 条或颜色，不再解释窗口。
4. continuation 又退回“只要还能跑就继续”。
5. rollback 开始只剩文件列表、commit 或补丁说明。
6. 宿主开始靠 `lastMessage`、spinner 或 modal heuristic 猜当前真相。

## 3. 每轮检查点

每次宿主接入变更后，至少逐项检查：

1. `governance key continuity`
   - 宿主是否仍一起消费 `sources / effective / applied / externalized + permission_mode`，并知道后者只是投影。
2. `typed ask continuity`
   - 当前动作是否仍由正式 `can_use_tool / decision_reason / request_id / tool_use_id` 支撑。
3. `decision window continuity`
   - 宿主是否仍把 `state + pending_action + Context Usage` 作为同一判断窗口，而不是把 `pending_action` 降格成显示文案。
4. `continuation pricing continuity`
   - 当前 stop / continue / object upgrade 是否仍被当成正式时间边界，而不是脱离 settled state 免费继续。
5. `rollback object continuity`
   - 宿主是否仍知道回退到哪个治理对象、哪些 `durable assets` 应保留、哪些 `transient authority` 必须清空，而不是只剩文件动作。

## 4. 直接拒收条件

出现下面情况时，应直接拒收：

1. 宿主把 `permission_mode` 当成全部 `governance key`。
2. `pending_action` / typed ask 只剩文案，或靠事件流 / spinner 反推，不剩对象字段。
3. Context Usage 只剩仪表盘，不再进入 `decision window`。
4. continuation 只看能不能继续，不看应不应该继续。
5. rollback 被替换成“回退哪些文件”。

## 5. 最小演练集

每轮至少跑下面五个宿主演练：

1. mode 变化 + settings 变化
   - 确认宿主能区分 `governance key` 与 mode 投影。
2. `typed ask` 进入与清空
   - 确认宿主始终消费 externalized object，而不是提示文案。
3. Context Usage 激增但不应继续
   - 确认宿主能把窗口解释成“应停或应升级对象”。
4. headless / background deny
   - 确认宿主不会把无弹窗条件误解成默认继续。
5. `rewind_files`
   - 确认宿主能把 file rewind 链回 rollback object，而不是只展示文件列表。

## 6. 复盘记录最少字段

每次治理宿主 drift 至少记录：

1. `governance_object_id`
2. `governance_key_ref`
3. `externalized_truth_chain_ref`
4. `typed_ask_ref`
5. `decision_window_ref`
6. `continuation_pricing_ref`
7. `rollback_object`
8. `symptom`
9. `reject_reason`
10. `recovery_action`

## 7. 防再发动作

更稳的防再发顺序是：

1. 先把 `governance key` 从 mode 投影里救出来。
2. 先把 typed ask 拉回 externalized object。
3. 先让 Context Usage 回到 `decision window`。
4. 先把 `continuation pricing` 显式化。
5. 最后才补交互样式、弹窗流程与可视化润色。

## 8. 苏格拉底式检查清单

在你准备宣布“治理宿主接入已经稳定”前，先问自己：

1. 宿主消费的是 `governance key`，还是只消费了 mode。
2. typed ask 在我的系统里还是 externalized object，还是已经退化成文案。
3. Context Usage 还在解释 `decision window`，还是只在展示成本。
4. continuation 是正式时间边界，还是默认继续。
5. rollback 在我的系统里还是对象，还是已经退化成文件回退。

## 9. 一句话总结

真正成熟的治理宿主接入审读，不是看控制请求能不能跑通，而是持续证明宿主仍围绕同一个治理对象消费 `governance key`、`externalized truth chain`、`typed ask`、`decision window`、`continuation pricing` 与 `rollback object`。
