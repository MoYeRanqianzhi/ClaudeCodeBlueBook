# 治理控制面对象验证手册：authority source、decision window、continuation gate与rollback object回归

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

- 当前边界、当前决定、当前窗口与当前继续条件仍然围绕同一个对象成立

所以这层验证最先要看的不是表象，而是：

1. authority source
2. typed decision continuity
3. decision window continuity
4. continuation gate continuity
5. rollback object continuity

## 2. 回归症状

看到下面信号时，应提高警惕：

1. 团队开始只看 mode，而不看当前 authority source。
2. 审批完成被误当治理完成。
3. Context Usage 被降级成一个 token 面板。
4. 继续条件开始只剩“再来一轮看看”。
5. 回退开始退回文件、commit 或情绪判断，而不是对象边界。

## 3. 每轮检查点

每次变更后，至少逐项检查：

1. `authority source`
   - mode、settings、policy 与状态写回是否仍来自正式权威入口。
2. `typed decision continuity`
   - 当前动作是否仍由正式 deny / ask / allow / reason 语义支撑。
3. `decision window continuity`
   - 当前窗口是否仍把 Context Usage、pending action 与当前状态一起解释。
4. `continuation gate continuity`
   - 当前 stop / continue / upgrade 是否仍是正式时间边界。
5. `rollback object continuity`
   - 当前失败路径是否仍知道回退到哪个对象。

## 4. 直接拒收条件

出现下面情况时，应直接拒收：

1. 宿主、CLI、bridge 开始各自猜 mode 或 pending action。
2. 审批语义退回“弹窗出现过就算通过”。
3. Context Usage 与当前状态不再被并排解释。
4. continuation 只看 token 数，不看 decision gain。
5. rollback 被替换成“回退哪些文件”。

## 5. 复盘记录最少字段

每次治理 drift 至少记录：

1. `governance_object_id`
2. `authority_source`
3. `current_state`
4. `decision_window`
5. `winner_source`
6. `continuation_gate`
7. `rollback_object`
8. `symptom`
9. `reject_reason`

## 6. 防再发动作

更稳的防再发顺序是：

1. 先补 current object / current window 的显式化。
2. 先补 authority source 的单一入口。
3. 先补 typed decision 的拒收语义。
4. 先补 continuation gate 的对象升级条件。
5. 最后才补更多阈值、弹窗或统计项。

## 7. 苏格拉底式检查清单

在你准备宣布“治理机制仍然健康”前，先问自己：

1. 当前所有判断是否仍围绕同一 authority source。
2. 现在看到的是 decision window，还是几个分散面板。
3. continuation 是正式 gate，还是默认继续。
4. 失败时我能否立刻指出 rollback object。
5. 如果把 modal 和 dashboard 藏起来，团队是否仍知道该如何判断。

## 8. 一句话总结

真正成熟的治理机制验证，不是看门禁还在不在，而是持续证明当前治理对象、当前窗口和当前继续边界仍然是同一个判断链。

