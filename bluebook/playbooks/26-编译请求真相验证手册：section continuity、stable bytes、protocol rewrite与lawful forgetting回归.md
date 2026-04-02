# 编译请求真相验证手册：section continuity、stable bytes、protocol rewrite与lawful forgetting回归

这一章不再解释 `compiled request truth` 为什么重要，而是把它压成一张可持续执行的验证手册。

它主要回答五个问题：

1. 团队怎样知道当前仍在围绕同一个 `compiled request truth` 工作。
2. 哪些症状最能暴露 Prompt 魔力已经从工作语法退回原文 prompt 崇拜。
3. 哪些检查点最适合作为回归门禁，而不是靠资深 reviewer 心法。
4. 哪些 drift 必须被直接拒收，而不是留到事后解释。
5. 怎样用苏格拉底式追问避免把这层写成“又一份 prompt checklist”。

## 0. 代表性源码锚点

- `claude-code-source-code/src/constants/systemPromptSections.ts:1-51`
- `claude-code-source-code/src/constants/prompts.ts:491-557`
- `claude-code-source-code/src/utils/systemPrompt.ts:28-104`
- `claude-code-source-code/src/query/stopHooks.ts:84-120`
- `claude-code-source-code/src/utils/messages.ts:1989-2148`
- `claude-code-source-code/src/services/compact/prompt.ts:1-260`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:243-520`

## 1. 第一性原理

对 `compiled request truth` 来说，真正重要的不是：

- 这次 prompt 看起来很完整

而是：

- 这次请求对象仍然是同一个对象

所以回归手册最先要验证的不是文本完整度，而是：

1. section continuity
2. stable prefix continuity
3. protocol transcript continuity
4. lawful forgetting continuity
5. stable bytes continuity

## 2. 回归症状

看到下面信号时，应提高警惕：

1. review 开始围绕原文 prompt 改得好不好争论。
2. summary / suggestion / resume 各自长出一份不同世界。
3. UI transcript 与 protocol transcript 开始被混用。
4. compact 之后 next-step guard、tool pairing 或 handoff 条件变得含糊。
5. cache break 发生了，但没人能解释到底哪层字节变了。

## 3. 每轮检查点

每次变更后，至少逐项检查：

1. `section continuity`
   - 这次请求对象头是否仍来自同一 section law 与主权链。
2. `stable prefix continuity`
   - 主线程是否仍是唯一前缀生产者，旁路循环是否仍在复用它。
3. `protocol rewrite continuity`
   - 模型消费的是否仍是规范化后的 protocol transcript，而不是 UI 原样历史。
4. `lawful forgetting continuity`
   - compact / resume / handoff 是否仍保住当前继续条件。
5. `stable bytes explanation`
   - 这次变化是否能被解释到 section、tool schema、boundary 或 strategy。

## 4. 直接拒收条件

出现下面情况时，应直接拒收：

1. 多个入口开始同时生成“最终请求真相”。
2. side loop 在没有合法前缀时自行重建世界。
3. 显示层消息直接进入模型消费主路径。
4. lawful forgetting 删除了当前继续条件、rollback boundary 或 handoff guard。
5. cache break 只能被描述成“好像变贵了”，却无法定位原因。

## 5. 复盘记录最少字段

每次机制 drift 至少记录：

1. `request_object_id`
2. `authority_source`
3. `assembly_path`
4. `compiled_request_diff_ref`
5. `stable_bytes_ledger_ref`
6. `lawful_forgetting_boundary`
7. `symptom`
8. `reject_reason`
9. `recovery_action`

## 6. 防再发动作

更稳的防再发顺序是：

1. 先补 object continuity 解释。
2. 先补 stable bytes inventory。
3. 先补 protocol rewrite 边界说明。
4. 先补 lawful forgetting 的拒收语义。
5. 最后才补更多 Prompt 内容。

## 7. 苏格拉底式检查清单

在你准备宣布“Prompt 机制仍然健康”前，先问自己：

1. 当前保护的是同一份 request truth，还是一组相似文本。
2. 旁路循环是否仍围绕同一前缀对象工作。
3. compact 后系统是否仍知道该怎样继续。
4. 当前 cache break 是否能被正式解释。
5. 如果把原文 prompt 藏起来，团队是否仍能判断对象 continuity。

## 8. 一句话总结

真正成熟的 Prompt 机制验证，不是看 prompt 还在不在，而是持续证明 `compiled request truth` 还在不在。

