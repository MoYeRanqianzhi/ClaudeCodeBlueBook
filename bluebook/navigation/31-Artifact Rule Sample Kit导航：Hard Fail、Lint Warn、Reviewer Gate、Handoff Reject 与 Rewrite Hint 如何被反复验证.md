# Artifact Rule Sample Kit导航：Hard Fail、Lint Warn、Reviewer Gate、Handoff Reject 与 Rewrite Hint 如何被反复验证

这一篇不再新增新的规则字段，而是回答一个更接近执行验证的问题：

- 当团队已经有 machine-readable `rule packet` 之后，下一步就不该继续停在“定义规则”，而要把这些规则写成最小样例、失败样例、rewrite 样例与 evaluator 接口，让不同消费者反复验证自己共享的是同一拒收语义。

它主要回答四个问题：

1. 为什么 Artifact Rule ABI 层之后还必须继续长出 rule sample kit / evaluator 层。
2. 为什么真正成熟的样例，不是多给几份 YAML，而是让同一 reject reason 能在宿主、CI、评审与交接里重复触发。
3. 怎样把 Prompt、安全/省 token 与结构演化三条线分别压成可验证样例集。
4. 怎样用苏格拉底式追问避免把这一层写成“规则文档的附件”。

## 1. Prompt Artifact Rule Sample Kit

如果问题是：

- 为什么 Prompt 线不能停在 `Rule ABI`，而必须继续给出 `hard fail / lint warn / reviewer gate / handoff reject / rewrite hint` 的最小规则样例与 evaluator 入口。
- 为什么 Claude Code 的 Prompt 魔力进入规则层之后，仍要靠 sample kit 才能证明共享的是同一 continuation 语义。

建议顺序：

1. `30`
2. `../playbooks/20`
3. `../philosophy/72`

这条线的核心不是：

- 再补一份 Prompt 配置

而是：

- 证明原文崇拜、绿灯崇拜、总结崇拜与摘要崇拜会在同一 rule packet 下被重复识别与重写

## 2. 治理 Artifact Rule Sample Kit

如果问题是：

- 为什么治理线不能停在 `Decision Gain` 的规则定义，而必须继续给出状态色、计数、verdict 与状态摘要如何被同一 reject semantics 拦住的样例。
- 为什么安全与省 token 设计到了规则层之后，仍要靠 sample kit 证明共享的是同一“没有决策增益就不该继续”的语义。

建议顺序：

1. `30`
2. `../playbooks/21`
3. `../philosophy/72`

这条线的核心不是：

- 再补一份治理接口说明

而是：

- 证明不同消费者都在围绕同一 rollback object、同一 failure semantics 重复做出相同拒收

## 3. 结构 Artifact Rule Sample Kit

如果问题是：

- 为什么结构线不能停在 `authoritative path / anti-zombie` 的规则定义，而必须继续给出目录图、恢复报喜、作者说明如何在同一规则包下被重复识别的样例。
- 为什么源码先进性进入规则层之后，仍要靠 sample kit 证明共享的是同一 split-brain reject semantics。

建议顺序：

1. `30`
2. `../playbooks/22`
3. `../philosophy/72`

这条线的核心不是：

- 再补一份结构规则

而是：

- 证明权威路径、恢复资产与 anti-zombie 证据会在不同消费者处触发同一对象级拒收

## 4. 一句话用法

如果：

- `30` 回答“这些 reject 条件怎样被不同消费者共享成同一规则包”

那么：

- `31` 回答“这些规则包怎样被最小样例、失败样例和 evaluator 反复证明”

## 5. 苏格拉底式自检

在你准备宣布“团队已经有 rule sample kit 了”前，先问自己：

1. 这些样例共享的是同一 reject reason，还是只是几份长得像的配置片段。
2. evaluator 读到的是同一 shared object 断裂，还是不同消费者各自定义的局部失败。
3. rewrite hint 修复的是 continuation / decision gain / authoritative path，还是只修格式。
4. 如果宿主、CI、评审与交接对同一对象给出不同 verdict，样例是否足以暴露谁在说谎。
