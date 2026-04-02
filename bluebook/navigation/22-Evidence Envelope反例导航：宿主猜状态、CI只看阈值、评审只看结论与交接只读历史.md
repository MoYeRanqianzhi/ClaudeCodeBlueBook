# Evidence Envelope反例导航：宿主猜状态、CI只看阈值、评审只看结论与交接只读历史

这一篇不新增新的制度判断，而是回答一个更接近落地失真现场的问题：

- 当团队已经有 shared evidence envelope 之后，最常见的失败不再是“没有证据”，而是不同消费者把同一套证据拆散消费，重新退回各看各的局部真相。

它主要回答四个问题：

1. 为什么 shared evidence envelope 层之后还必须继续长出 consumer distortion casebook 层。
2. 为什么宿主、CI、评审与交接最常见的坏解法，往往不是“完全没做”，而是“各自做了一点”。
3. 怎样把 Prompt、安全/省 token 与结构演化三条线分别压成 shared envelope 的反例样本。
4. 怎样用苏格拉底式追问避免把这层写成“吐槽不同角色不会看材料”。

## 1. Prompt 线的 envelope 反例

如果问题是：

- 为什么宿主只看原文 prompt、CI 只看 cache break 指标、评审只看总结、交接只读 transcript，会把 Prompt 魔力重新退回文案崇拜。
- 为什么 prompt 明明已经有 compiled request truth，团队却还在按“这段提示词改得好不好”判断。

建议顺序：

1. `21`
2. `../casebooks/13`

这条线的核心不是：

- 再讲一次 prompt 原理

而是：

- 看清 shared envelope 一旦被拆散，Prompt Constitution 会怎样退回普通提示词

## 2. 治理与省 token 线的 envelope 反例

如果问题是：

- 为什么宿主只看状态、CI 只看 token、评审只看审批次数、交接只看最终结果，会把治理成熟度重新退回单点指标。
- 为什么系统明明已经记录了 decision window、control arbitration 与 rollback boundary，团队却仍只会问“这轮是不是更贵了”“这次是不是更严了”。

建议顺序：

1. `21`
2. `../casebooks/14`

这条线的核心不是：

- 再强调统一定价

而是：

- 看清 envelope 被拆散消费后，治理会怎样退回 token 崇拜、审批崇拜与结果崇拜

## 3. 结构演化线的 envelope 反例

如果问题是：

- 为什么宿主只看文件 diff、CI 只看目录整洁、评审只看结构图、交接只靠作者记忆，会把源码先进性重新退回目录美观和文件级回退。
- 为什么明明已经有 authoritative surface、recovery asset 与 rollback object boundary，团队却仍在按“哪些文件改了”理解结构升级。

建议顺序：

1. `21`
2. `../casebooks/15`

这条线的核心不是：

- 再赞美结构优雅

而是：

- 看清 shared envelope 一旦被拆散，源码先进性会怎样退回目录审美与作者记忆

## 4. 一句话用法

如果：

- `21` 回答“shared evidence envelope 应该长什么样”

那么：

- `22` 回答“它最常见会怎样被不同消费者拆散并失真”

## 5. 苏格拉底式自检

在你准备宣布“大家已经共享同一套证据”前，先问自己：

1. 大家是在共享同一套字段骨架，还是只是在共享同一堆材料。
2. 宿主、CI、评审与交接里，谁已经开始重新猜状态、重新猜窗口、重新猜回退边界。
3. 我是在研究没有证据，还是在研究证据被拆散消费后的次生失真。
4. 如果把作者名字拿掉，后来者还能否仅靠这些反例样本识别哪种消费方式在制造新一轮半真相。
