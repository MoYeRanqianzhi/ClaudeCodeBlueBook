# 真正强的Prompt不是信息更多，而是行动语义更密

这一章回答四个问题：

1. 为什么 Claude Code 的 prompt 强项不在“带更多信息”，而在“带更高密度的行动语义”。
2. 为什么最好的上下文不是最长上下文，而是最可继续工作的上下文。
3. 这对 agent 设计者意味着什么。
4. 我们该如何避免把这条线重新写回“prompt 文案更强”。

## 1. 先说结论

“行动语义更密”现在不再单独充当前门，而是六级编译链跑通后的结果，尤其是：

- `Continuation`
- 更准确地说，它只是 `same-world compiler` 跑通后的结果词，不是 Prompt magic 的 owner definition；若把这个结果词重新当前门，读者又会把症状当原因。

Claude Code 的 prompt 之所以强，不是因为塞进了更多原文，而是因为同样的 token 更努力保住了 continuation 真正需要的四类对象：

1. `current work`
2. `next-step guard`
3. `required assets`
4. `continuation qualification`

也就是说，它保的是：

- 当前要继续做什么
- 当前不能越过哪些边界
- 哪些对象必须继续带着
- 为什么这项工作现在仍值得继续

而不是：

- 更多原文残片

## 2. 为什么“信息更多”不自动等于“更强”

很多系统天然相信：

- 上下文越多越好

Claude Code 更成熟，因为它知道：

- 原文更多，往往只是噪声更多

真正值钱的是：

- 哪些语义还能支持下一步行动

所以它宁可：

- 抽 session memory
- 冻结 tool result fate
- 保存 cache-safe params
- 生成 next-action suggestion

也不愿把一切继续平铺进主工作集。

这不是“更会压缩”，而是：

- lawful forgetting 后仍保住 continuation-critical semantics

## 3. 为什么这其实是在保护 Continuation，而不是堆更多文本

如果把 Prompt 写成原文仓库，那么每次 compact、handoff、fork、resume 都会重新失去当前工作主语。

Claude Code 更接近另一种逻辑：

1. `Authority` 与 `Boundary` 先收住同一世界。
2. `Transcript` 与 `Lineage` 再把当前工作对象串起来。
3. `Continuation` 只保留下一步仍然必须知道的高密度语义。

所以“行动语义更密”真正指向的不是抽象效果，而是：

- 工作现场被 runtime 压成更可继续行动的对象

如果这一层重新退回“更多上下文更强”，later maintainer 就会再次把 prompt 写回静态信息堆，而不是 continuation contract。

## 4. 苏格拉底式追问

### 4.1 一个 prompt 里带了更多历史，就一定更接近真相吗

未必。

它也可能只是带了更多不再可行动的残留。

### 4.2 真正该保住的是什么

不是原文量，而是：

- 当前工作能否继续推进所需的最小高密度语义

### 4.3 如果一个系统每轮都重新带着大量原始世界思考，会更强吗

未必。

它更可能只是更重、更慢、更不稳。

### 4.4 这页最容易失真成什么

最容易退回：

- 把“行动语义更密”写成 Prompt magic 的根定义

更稳的写法应该始终承认：

- 这是 `Continuation` 跑通之后出现的结果词

## 5. 对 Agent 设计者的启发

如果想复制 Claude Code 的强点，最该优化的不是：

- 文案更长
- 规则更全

而是：

1. 哪些语义值得长期保留。
2. 哪些语义只需短预览。
3. 哪些语义必须冻结形状。
4. 哪些语义应交给旁路循环处理。
5. 继续资格失效时，哪些语义必须立刻退场。

## 6. 一句话总结

Claude Code 的 prompt 强，不在于它携带了更多信息，而在于它把当前工作压成了更高密度、仍可通过 `Continuation` 合法延续的行动语义。
