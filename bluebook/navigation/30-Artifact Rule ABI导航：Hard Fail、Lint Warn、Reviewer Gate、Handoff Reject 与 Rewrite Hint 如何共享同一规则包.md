# Artifact Rule ABI导航：Hard Fail、Lint Warn、Reviewer Gate、Handoff Reject 与 Rewrite Hint 如何共享同一规则包

这一篇不再新增新的 validator，而是回答一个更接近系统集成的问题：

- 当团队已经知道哪些 drift 应被拒绝之后，下一步就不该继续把这些规则散落在 reviewer 心法、CI 判断与交接习惯里，而要把它们压成同一份 machine-readable `rule packet`。

它主要回答四个问题：

1. 为什么 Artifact Validator / Linter 层之后还必须继续长出 Artifact Rule ABI 层。
2. 为什么真正成熟的规则，不是多几条 checklist，而是让不同消费者共享同一拒收语义。
3. 怎样把 Prompt、安全/省 token 与结构演化三条线分别压成可执行的 `hard fail / lint warn / reviewer gate / handoff reject / rewrite hint` 规则包。
4. 怎样用苏格拉底式追问避免把这一层写成“机器帮人填表”。

## 1. Prompt Artifact Rule ABI

如果问题是：

- 为什么 Prompt 线不能停在“知道哪些工件会漂移”，而必须继续把 `compiled request object continuity` 压成统一 `rule packet`。
- 为什么 Claude Code 的 Prompt 魔力进入协议层之后，必须让宿主、CI、评审与交接共享同一拒收语义。

建议顺序：

1. `29`
2. `../api/40`
3. `../philosophy/71`

这条线的核心不是：

- 再多几条 Prompt 校验规则

而是：

- 让不同消费者围绕同一 `compiled request object` 共享同一套拒收条件

## 2. 治理 Artifact Rule ABI

如果问题是：

- 为什么治理线不能停在“知道状态色、计数、verdict 会说谎”，而必须继续把 `decision gain`、`failure semantics` 与 `rollback object` 压成统一规则包。
- 为什么安全设计与省 token 设计到了规则层，必须共享同一 `reject semantics`。

建议顺序：

1. `29`
2. `../api/41`
3. `../philosophy/71`

这条线的核心不是：

- 再多几条治理 gate

而是：

- 让没有决策增益的继续、没有回退对象的交接、没有失败语义的 verdict 根本不能通过同一规则 ABI

## 3. 结构 Artifact Rule ABI

如果问题是：

- 为什么结构线不能停在“知道目录图、恢复成功率、作者说明会漂移”，而必须继续把 `authoritative path`、`recovery asset`、`anti-zombie evidence` 压成统一规则包。
- 为什么源码先进性进入协议层之后，仍要让不同消费者共享同一 `split-brain reject semantics`。

建议顺序：

1. `29`
2. `../api/42`
3. `../philosophy/71`

这条线的核心不是：

- 再多几条结构 lint

而是：

- 让目录图、报喜与口头交接无法再绕开同一条拒收语义

## 4. 一句话用法

如果：

- `29` 回答“系统应该怎样正式拒绝 drift”

那么：

- `30` 回答“这些拒绝条件怎样被不同消费者共享成同一份规则包”

## 5. 苏格拉底式自检

在你准备宣布“团队已经有 rule ABI 了”前，先问自己：

1. 这套规则包共享的是同一拒收语义，还是只是很多风格相似的本地规则。
2. CI、评审与交接拿到的是同一条对象判断，还是三份互相翻译的近似版本。
3. 当前 `rewrite hint` 修的是 shared object continuity，还是只修表面格式。
4. 这套 ABI 是在减少人为解释成本，还是在把人为解释换个格式重新存一遍。
