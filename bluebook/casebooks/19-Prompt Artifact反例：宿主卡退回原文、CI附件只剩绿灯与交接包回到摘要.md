# Prompt Artifact反例：宿主卡退回原文、CI附件只剩绿灯与交接包回到摘要

这一章不再收集“Prompt contract 本身设计错”的反例，而是收集 Prompt artifact 已经存在之后最常见的工件级失真样本。

它主要回答五个问题：

1. 为什么 Prompt artifact 明明已经有宿主卡、CI 附件、评审卡与交接包，团队仍然会退回原文 prompt、绿灯、总结与摘要四套局部真相。
2. 为什么 Prompt artifact 最容易被退化成“有卡片”“CI 通过”“评审写了结论”“交接给了摘要”。
3. 哪些坏解法最容易让 compiled request truth、stable bytes 与 lawful forgetting ABI 失去权威。
4. 怎样把这些坏解法改写回 Claude Code 式共享 artifact 消费。
5. 怎样用苏格拉底式追问避免把这一章读成“有人没按模板填”。

## 0. 第一性原理

Prompt artifact 层最危险的，不是：

- 没有工件

而是：

- 工件已经存在，却只剩各自看起来完整的局部版本，没人再围绕同一 compiled request object 判断

这样一来，系统虽然已经能要求：

1. `authority_source`
2. `assembly_path`
3. `compiled_request_diff_ref`
4. `stable_bytes_ledger_ref`
5. `lawful_forgetting_abi_ref`
6. `next_step_guard`

团队却依旧回到：

- 看原文 prompt
- 看 CI 是否绿色
- 看评审总结
- 看交接摘要

## 1. 宿主卡退回原文 prompt vs current object

### 坏解法

- 宿主卡虽然存在，但主要展示 prompt 原文、system 片段或作者解释，而不是 `current_object` 与 `compiled_request_summary`。

### 为什么坏

- 这会把宿主重新退回“输入材料展示层”，而不是“当前对象展示层”。
- 一旦 `current_object` 不再是宿主卡入口，Prompt artifact 就会重新退回原文崇拜。
- 后来者会误以为宿主看到的就是模型真正收到的东西。

### Claude Code 式正解

- 宿主卡必须先锁 `current_object`、`authority_source`、`compiled_request_summary` 与 `next_step_guard`。
- prompt 原文最多作为附件，不得替代当前对象。


## 2. CI 附件只剩绿灯 vs stable bytes ledger

### 坏解法

- CI 附件虽然存在，但主要只给 pass / fail、cache hit、token 曲线，不再给出 `compiled_request_diff_ref`、`stable_bytes_ledger_ref` 与 drift reason。

### 为什么坏

- 绿灯只能说明规则被跑过，不能说明 Prompt object 为什么仍成立。
- 没有 stable bytes ledger，CI 就会退回“这轮看起来没坏”的经验判断。
- Prompt 魔力重新退回玄学稳定性。

### Claude Code 式正解

- CI 附件必须同时给出 `compiled_request_diff_ref`、`stable_bytes_ledger_ref`、`lawful_forgetting_abi_ref` 与 drift 解释。
- 绿灯只是工件结论，不是工件本体。


## 3. 评审卡退回总结 vs authority / assembly judgement

### 坏解法

- 评审卡虽然存在，但 reviewer 主要写总结和建议，不再点名 `authority_source`、`assembly_path` 与 `compiled_request_diff_ref`。

### 为什么坏

- 一旦评审卡不再围绕 shared header 继续判断，它就会退回作者总结卡。
- 后来者得到的不是对对象的 judgement，而是对叙述的 judgement。
- 这会把 Prompt review 重新退回修辞审查。

### Claude Code 式正解

- 评审卡必须先回答 authority、assembly、boundary 与 diff judgement，再允许写解释。
- 解释只能是 judgement 的投影，不能替代 judgement 本身。


## 4. 交接包退回摘要 vs lawful forgetting ABI

### 坏解法

- 交接包虽然存在，但主要只给 task summary、背景说明和 transcript 引用，不再给出 `lawful_forgetting_abi_ref`、`current_object` 与 `next_step_guard`。

### 为什么坏

- 这会把 handoff package 退回“更短的历史”，而不是“可继续工作的最小对象”。
- 没有 lawful forgetting ABI，后来者仍然必须考古。
- 交接重新退回摘要崇拜。

### Claude Code 式正解

- 交接包必须先交 `current_object`、`next_step_guard`、`lawful_forgetting_abi_ref` 与 `rollback_hint`。
- 背景说明只能作为后附材料，不得替代 ABI。


## 5. 四件套同时存在却仍然失真

### 坏解法

- 宿主卡、CI 附件、评审卡、交接包四件套都存在，但它们分别围绕原文、绿灯、总结与摘要，不再共享同一 Prompt object。

### 为什么坏

- 这会产生四份“各自都像对的”局部真相。
- 工件存在性会掩盖对象共享性的崩塌。
- 团队会误以为 contract 已落地，实际上 shared header 已经死亡。

### Claude Code 式正解

- 四件套必须先共享同一个 `artifact_line_id + prompt_object_id + authority_source`。
- 差异只允许出现在角色展开字段，不允许出现在 shared header。


## 6. 苏格拉底式追问

在你读完这些反例后，先问自己：

1. 我现在消费的是同一 Prompt object，还是原文、绿灯、总结与摘要四种替身。
2. 这些工件共享的是同一 header，还是只是长得像。
3. later compact 之后，后来者拿到的是 ABI，还是一段更短的故事。
4. 我是在修工件，还是在重新修回 shared object。
