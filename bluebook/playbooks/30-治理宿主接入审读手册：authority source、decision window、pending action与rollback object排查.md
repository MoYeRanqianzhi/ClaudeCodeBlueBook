# 治理宿主接入审读手册：authority source、decision window、pending action与rollback object排查

这一章不再解释统一定价治理为什么重要，而是把它压成一张可持续执行的宿主接入审读手册。

它主要回答五个问题：

1. 团队怎样知道宿主当前仍在围绕同一个治理对象消费 authority source、decision window、pending action、continuation gate 与 rollback object。
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

- 宿主当前仍在围绕同一个 governance object 消费 authority source、decision window、continuation gate 与 rollback object

所以这层审读最先要看的不是：

- 交互流程顺不顺

而是：

1. authority source 是否仍完整存在。
2. pending action 是否仍是对象，而不是提示语。
3. Context Usage 是否仍在解释 decision window。
4. continuation 是否仍是正式时间边界。
5. rollback 是否仍围绕对象，而不是围绕文件。

## 2. 回归症状

看到下面信号时，应提高警惕：

1. 宿主只看 `permission_mode`，不看 `sources / effective / applied`。
2. `pending_action` 被降格成“当前卡住了”的一段文案。
3. Context Usage 只剩 token 条或颜色，不再解释窗口。
4. continuation 又退回“只要还能跑就继续”。
5. rollback 开始只剩文件列表、commit 或补丁说明。

## 3. 每轮检查点

每次宿主接入变更后，至少逐项检查：

1. `authority source continuity`
   - 宿主是否仍一起消费 `sources / effective / applied + permission_mode`。
2. `typed decision continuity`
   - 当前动作是否仍由正式 `can_use_tool / decision_reason / request_id / tool_use_id` 支撑。
3. `decision window continuity`
   - 宿主是否仍把 `state + pending_action + Context Usage` 作为同一判断窗口。
4. `continuation gate continuity`
   - 当前 stop / continue / object upgrade 是否仍被当成正式时间边界。
5. `rollback object continuity`
   - 宿主是否仍知道回退到哪个治理对象，而不是只剩文件动作。

## 4. 直接拒收条件

出现下面情况时，应直接拒收：

1. 宿主把 `permission_mode` 当成全部 authority source。
2. `pending_action` 只剩文案，不剩对象字段。
3. Context Usage 只剩仪表盘，不再进入 decision window。
4. continuation 只看能不能继续，不看应不应该继续。
5. rollback 被替换成“回退哪些文件”。

## 5. 最小演练集

每轮至少跑下面五个宿主演练：

1. mode 变化 + settings 变化
   - 确认宿主能区分 authority source 与 mode 投影。
2. `pending_action` 进入与清空
   - 确认宿主始终消费对象字段，而不是提示文案。
3. Context Usage 激增但不应继续
   - 确认宿主能把窗口解释成“应停或应升级对象”。
4. headless / background deny
   - 确认宿主不会把无弹窗条件误解成默认继续。
5. `rewind_files`
   - 确认宿主能把 file rewind 链回 rollback object，而不是只展示文件列表。

## 6. 复盘记录最少字段

每次治理宿主 drift 至少记录：

1. `governance_object_id`
2. `authority_source`
3. `decision_window`
4. `pending_action_surface`
5. `continuation_gate_surface`
6. `rollback_object`
7. `symptom`
8. `reject_reason`
9. `recovery_action`

## 7. 防再发动作

更稳的防再发顺序是：

1. 先把 authority source 从 mode 投影里救出来。
2. 先把 `pending_action` 拉回对象。
3. 先让 Context Usage 回到 decision window。
4. 先把 continuation gate 显式化。
5. 最后才补交互样式、弹窗流程与可视化润色。

## 8. 苏格拉底式检查清单

在你准备宣布“治理宿主接入已经稳定”前，先问自己：

1. 宿主消费的是 authority source，还是只消费了 mode。
2. `pending_action` 在我的系统里还是对象，还是已经退化成文案。
3. Context Usage 还在解释 decision window，还是只在展示成本。
4. continuation 是正式时间边界，还是默认继续。
5. rollback 在我的系统里还是对象，还是已经退化成文件回退。

## 9. 一句话总结

真正成熟的治理宿主接入审读，不是看控制请求能不能跑通，而是持续证明宿主仍围绕同一个治理对象消费 authority source、decision window、continuation gate 与 rollback object。
