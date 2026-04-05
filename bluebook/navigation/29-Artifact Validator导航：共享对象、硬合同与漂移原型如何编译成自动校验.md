# Artifact Validator导航：共享对象、硬合同与漂移原型如何编译成自动校验

这一篇不再新增新的反例，而是回答一个更接近制度落地的问题：

- 当团队已经知道 artifact 应该怎样填写，也已经知道 artifact 最常怎样重新说谎，下一步就不该继续停在“识别问题”，而要把 shared header、hard contract 与 drift 原型编译成 validator、linter、reviewer gate 与 handoff reject rule。

它主要回答四个问题：

1. 为什么 Artifact Drift casebook 层之后仍需要单独讨论 artifact validator / linter 层。
2. 为什么真正成熟的校验，不是检查字段有没有填，而是检查 shared object 是否仍然连续。
3. 怎样把 Prompt、安全/省 token 与结构演化三条线分别压成可执行闸门。
4. 怎样用苏格拉底式追问避免把这层写成“又多了一套 checklist”。

## 1. Prompt Artifact Validator

适合在这些问题下阅读：

- 为什么 Prompt 线不能停在“有样例、有反例”，而必须继续把 compiled request truth、stable bytes 与 lawful forgetting ABI 编译成硬拒收规则。
- 为什么 Claude Code 的 Prompt 魔力进入工件层之后，仍要靠 validator 才能守住 shared object continuity。

稳定阅读顺序：

1. `28`
2. `../guides/39`
3. `../philosophy/70`

这条线的核心不是：

- 再补一轮 Prompt 工件样例

而是：

- 让宿主卡、CI 附件、评审卡与交接包一旦退回原文、绿灯与摘要，就会被正式拒收

## 2. 治理 Artifact Validator

适合在这些问题下阅读：

- 为什么治理线不能停在“知道会退回状态色、计数与 verdict”，而必须继续把 decision window、arbitration truth、rollback object 与 next action 编译成 hard gate。
- 为什么安全设计与省 token 设计到了工件层，必须共用同一套 validator 才不退回局部 KPI。

稳定阅读顺序：

1. `28`
2. `../guides/40`
3. `../philosophy/70`

这条线的核心不是：

- 再补一轮治理 checklist

而是：

- 让没有 decision gain、没有 rollback object、没有 next action 的治理工件无法继续夺权

## 3. 结构 Artifact Validator

适合在这些问题下阅读：

- 为什么结构线不能停在“知道会退回目录图、恢复成功率与作者说明”，而必须继续把 authoritative path、recovery asset ledger、anti-zombie evidence 与 handoff reject 编译成统一闸门。
- 为什么源码先进性进入 artifact 层之后，仍要靠 validator 才能守住 shared structure object。

稳定阅读顺序：

1. `28`
2. `../guides/41`
3. `../philosophy/70`

这条线的核心不是：

- 再补一轮结构样例

而是：

- 让“结构图看起来没问题”不再足以冒充对象级结构真相

## 4. 一句话用法

如果：

- `27` 回答“这套共享工件协议真正填出来长什么样”
- `28` 回答“这些工件最常会怎样重新退回局部真相”

那么：

- `29` 回答“系统应该怎样自动拒绝这些局部真相重新夺权”

## 5. 苏格拉底式自检

在你准备宣布“团队已经有 artifact validator 了”前，先问自己：

1. 这套规则保护的是 shared object，还是只保护表单完整度。
2. 当前 hard fail 拦住的是对象断裂，还是只拦住格式错误。
3. reviewer gate 审的是 authority、window、path 与 rollback，还是只审结论句写得是否完整。
4. handoff reject 拒收的是无法继续行动的工件，还是只拒收不够好看的摘要。
