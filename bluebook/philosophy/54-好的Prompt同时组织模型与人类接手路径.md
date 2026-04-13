# 好的Prompt同时组织模型与人类接手路径

这一章回答四个问题：

1. 为什么 Claude Code 的 prompt 不只在组织模型，也在组织人类下一步如何接手。
2. 为什么真正强的 agent runtime 会主动降低人类-模型协调成本。
3. 为什么 suggestion、sticky prompt、session memory、teammate navigation 都该和 prompt 一起理解。
4. 这对 agent 设计者意味着什么。

## 1. 先说结论

Claude Code 的 prompt 真正高级的一层，不是让人类更容易接手，而是把 later consumer 的拒收权、已排除分支的保留义务与同一工作对象的合法继承一起写进继续接口。

所以这里值钱的也不是“接手路径更顺”，而是 `verify / resume / handoff` 之后，接手者继承的仍是同一份工作对象、同一批仍被排除的分支，以及同一条 `continue-or-reject verdict`。
更硬一点说，人类接手不是体验优化，而是另一个 lawful consumer；系统必须先规定他看到哪层 projection、可拒收什么、何时必须 `reopen`，而不是沿旧资格继续。没有新增 `decision delta` 时，旧判断继续退役，人类也不应只靠 summary 或 display convenience 把它们静默拖回候选集。

## 2. 为什么这很重要

一个 coding agent 真正难的，不只是生成下一步动作。

还包括：

1. 人类是否还能快速理解现场。
2. 人类是否知道该从哪里继续。
3. 人类是否能低成本切回另一条执行链。
4. 人类是否能用最少反馈把模型重新导回正轨。

如果这些成本不被主动压低，再强的模型也会在长期协作里显得笨重。
这些成本之所以必须被压低，也不是为了“更顺手”而已，而是为了让 later consumer 不必重读全量 transcript，就能对旧资格做 `continue / reject / reopen` 的正式判断。

## 3. 苏格拉底式追问

### 3.1 prompt 只要把模型组织好就够了吗

不够。

因为长期任务里，人类迟早要接手、确认、切换、纠偏。

### 3.2 suggestion 是在补全文本，还是在降低协调成本

更接近后者。

### 3.3 sticky prompt 是视觉小优化吗

不只是。

它更像在维护“下一步从哪里继续”的行动锚点。

### 3.4 真正强的 prompt 更像什么

更像：

- 一套同时服务模型推进和人类接手的协作接口

## 4. 对 Agent 设计者的启发

如果想学 Claude Code，最该问的不是：

- 模型看见了什么

还要问：

1. 人类接手时会看见什么。
2. 人类接手时看到的是哪层 projection，而不是哪份 summary 体感。
3. 人类如何低成本给出纠偏反馈，同时保留正式 reject 权。
4. 多执行链之间如何切换而不丢现场，并在必要时明确 `reopen` 而不是偷续旧资格。

## 5. 一句话总结

Claude Code 的 prompt 之所以强，不只是因为它让模型更会继续，而是因为它让 later consumer 不必重判世界、重搜动作空间，或把已排除路径与已退役判断重新拉回候选集。
