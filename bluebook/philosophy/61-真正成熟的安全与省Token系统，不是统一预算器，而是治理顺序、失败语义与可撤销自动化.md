# 真正成熟的安全与省Token系统，不是统一预算器，而是治理顺序、失败语义与可撤销自动化

这一章回答五个问题：

1. 为什么仅仅说“安全、成本与体验共用预算器”还不够。
2. 为什么 Claude Code 真正成熟的地方，在于检查顺序、失败语义分型和自动化撤销路径。
3. 为什么系统只该在“仍有决策增益”的地方继续花 token。
4. 为什么继续前必须先证明 `repricing / lease checkpoint / cleanup` 仍成立。
5. 这对 agent runtime 设计者意味着什么。

## 0. 本页边界

`61` 只保留 why：为什么治理顺序、失败语义、可撤销自动化与可重放证据会同时决定安全与省 token 的成熟度。
更细的治理对象、对象类目、机制差异与执行尾链统一回 `10 / security / playbooks`；本页不再把这些材料写成第二套 owner taxonomy。

## 1. 先说结论

更成熟的安全/省 token 系统，不是：

- 有一个统一预算器就结束了

而是：

1. 先找最早的 unpaid expansion。
2. 再证明 repricing 发生在继续或暴露之前。
3. 证明不了时，只能立即 reject、cleanup 后重开价，或退回人工。
4. 自动化必须随时可撤销，而不是单向升级。
5. 只有仍能支撑 `repricing / cleanup / continue verdict` 的证据才值得被稳定留下。

从第一性原理看，Claude Code 真正在回答的不是：

- 如何更安全
- 如何更便宜

而是：

- 在哪里该更早判断，在哪里该停止判断，在哪里该退回人工，在哪里必须把治理字节稳定下来

更短地说，它在写的不是“安全 feature + 压缩 feature”，而是同一条治理秩序如何对 model-reachable world 的危险扩张与昂贵扩张同时收费。
更硬一点说，真正统一的不是一个 budgeter 或角色表，而是同一条诊断环：先找 `earliest unpaid expansion`，再证明它已被 repriced、仍可续租、且旧 authority 已 cleanup；证明不了就不续租。
这条线再压一层，其实只剩一句：错误顺序的检查与未结算的继续，本质上是同一种制度错误，都是把本该重定价的 authority 当成默认续期。

## 2. 测试一：是不是定价得太晚

很多系统谈安全时，只会说：

- 多加一层检查

Claude Code 更成熟的地方在于：

- 它先决定谁必须先检查
- 具体顺序差异只是在证明同一条原则：检查必须落在最有治理价值的时点；更细 precedence 统一回 `83 / security / playbooks`

这说明安全与省 token 的共同问题其实是：

- 不该把决策放错顺序

因为顺序一旦错了，系统会同时出现两种坏事：

1. 风险绕过；
2. 无谓推理与无谓审批。

所以真正成熟的安全设计，不是“检查更多”，而是：

- 检查发生在最有治理价值的时点

## 3. 测试二：是不是给错了失败语义

Claude Code 对失败并不追求一种统一美德。

它只坚持一条更高的原则：

- 不同资产不该共享同一种失败语义。

远程托管设置、policy limit、classifier 与 autocompact 只是这条原则的不同例子；具体对象与机制差异统一回 `10 / security / playbooks`，本页不再把 case list写成第二套 owner taxonomy。

这说明系统真正追求的不是：

- 永远更保守

也不是：

- 永远更流畅

而是：

- 根据 unpaid expansion 的状态选择失败语义

从第一性原理看，这才是成熟治理系统的共同底盘：

- 该立即 reject 的，不要拖成更多检查。
- 该 cleanup 后重开价的，不要假装还是同一 lease。
- 已无决策增益的，应该退回人工，而不是继续自动化。

## 4. 测试三：自动化是否仍可撤销

如果自动化只能越来越多、越来越强，那它迟早会从行动力变成失控源。

Claude Code 明显在避免这一点：auto mode 不是永久授权，classifier 没有增益时应退出自动化路径，高阶模式本身也继续受 gate 与 killswitch 约束。

这说明 Claude Code 对自动化的理解不是：

- 一旦交给系统，就别回头

而是：

- 自动化必须保留合法撤销路径

真正成熟的自动化，不是覆盖人工，而是：

- 在合适时机把判断权还给人工

这同时是一条安全原则，也是一条省 token 原则，因为：

- 当系统已经没有决策增益时，继续自动化只会更贵、更冒险。

## 5. 测试四：这笔 token 还能改变决策吗

Claude Code 并不追求“检查越多越安全”。

它更像在走一道更硬的 diagnosis loop：

1. 这次检查还能改写哪个 decision。
2. 如果症状来自 `continue / compact / resume / re-entry`，旧 lease 有没有 `repricing proof`。
3. 哪些证据仍必须留下，才能继续支撑 `same scene / still priced`。
4. 哪些 transient authority 必须被 cleanup 撤销，不能伪装成同一现场的合法继续。

四问里只要有一问答不上，系统停掉的就不只是“额外检查”，而是一笔不该默认续租的 authority。
更具体的 `lease checkpoint / repricing proof / cleanup` 对象链统一回 `10`；本页只保留 why：为什么决策增益一旦消失，就不该再免费续租 authority。

更硬一点说，未被重新定价的继续会同时延长 authority 与成本在场；它不是便宜，而是把代价推迟到后面。

这里也要先拒绝一种常见误写：当判断已经不会改变 authority allocation，却还继续加检、重试自动化或保留过大的工作集时，系统只是在用额外 token 购买“看起来更谨慎”的幻觉。具体反例统一回 `10 / security / playbooks`。

所以 Claude Code 的省 token，并不是：

- 少说话

而是：

- 不把 token 花在已无制度收益的判断上

这也是为什么安全与成本在这里并不冲突，而是共享同一条判断：

- 决策增益是否仍存在
- 也就是不让未被重新定价的动作、能力、上下文席位与时间续费继续免费扩张

如果继续讨论谁在代签、谁只在读回、谁在收口，说明你缺的已不是 why，而是治理 owner chain。

## 6. 测试五：继续前还剩哪些证据必须保持可重放

Claude Code 的很多高级设计都在强调：

- 关键字节必须稳定

这里先只保留抽象判断：凡会同时改写治理、成本与解释一致性的证据，都应被当成制度资产稳定下来；更细的缓存、重放与 break 证据统一回源码锚点与对象页。
它们不是第五类被收费资源，而是 `externalized truth chain (verdict ledger)` 的 durable form：正因为这些证据稳定，前面那条 `repricing / cleanup / continue verdict` 才可被重放、复核与结算。
更硬一点说，真正要保留的不是“更长缓存”，而是 later consumer 仍能重放 `repricing / cleanup / continue verdict` 所需的最小证据。

这说明对 Claude Code 来说，真正要被保护的不是“缓存命中率”这个结果，而是：

- 影响治理、成本与解释一致性的那些字节

因为这些证据一旦不稳定，系统会同时损失：

1. 安全边界的一致性；
2. 成本结构的可预测性；
3. 对 prompt 行为的解释能力。

所以更成熟的说法不是：

- cache 很重要

而是：

- 稳定字节本身就是制度资产

## 7. 苏格拉底式追问

### 7.1 为什么仅说“统一预算器”还不够

因为统一预算器回答的是：

- 这些约束在一套秩序里

但还没回答：

- 最早 unpaid expansion 是什么
- repricing 什么时候发生
- 证明不了时是立即 reject、cleanup 后重开价，还是退回人工
- 自动化何时退回人工

### 7.2 为什么安全不该只写成拦截器

因为真正有价值的不是“阻止更多动作”，而是：

- 把检查放在最有治理价值的位置；
- 把无决策增益的检查及时停掉。

### 7.3 为什么省 token 不该只写成压缩技巧

因为很多 token 浪费根本不发生在回答长度，而发生在：

- 错误顺序的检查
- 无意义的自动化重试
- 已无收益的分类与审批

### 7.4 为什么 `compact / resume / re-entry` 也只是治理对象入口

因为 continue 从来不是免费“下一轮”。

- 一旦继续还能改写 authority、价格或清算资格，它就仍是一笔待结算的治理对象。
- 一旦继续已经不能改写这些东西，它就不该继续占据高价上下文与自动化权限。
- 所以 `continuity` 也只是一道 lease checkpoint：`same scene? still priced? who settles?`；`compact / resume / re-entry` 只是这道 checkpoint 的三种入口形式。
- `compact`
  - 只能保留仍足以支持 `same scene / repricing proof` 的 stable bytes；否则它只是摘要，不是合法继续。
- `resume`
  - 只有旧 `verdict ledger` 仍能证明 lease 未被撤销时，才算继续同一现场。
- `re-entry`
  - 先问谁为旧 authority 清账；旧 lease 若未先结算，就不是继续，而是重新开价。
- 更具体的 checkpoint 拆解与拒收顺序统一回 `10`；本页只保留为什么这三种入口本质上仍是同一治理对象。

## 8. 对 Agent 设计者的启发

如果想学 Claude Code，最该抄的不是：

- 更复杂的规则表

而是：

1. 先设计治理顺序，而不是先堆检查器。
2. 先把失败语义压回 `立即 reject / cleanup 后重开价 / 退回人工` 这三类现场判据。
3. 让自动化始终可撤销，而不是只可升级。
4. 用“是否仍有决策增益”来决定是否继续花 token。
5. 把 `repricing / cleanup / continue verdict` 所需的最小证据当成正式制度资产管理。

## 9. 一句话总结

Claude Code 的安全与省 token 之所以成熟，不只是因为它们共用预算器，更因为它把治理顺序、失败语义、可撤销自动化和可重放证据一起写成了同一套运行时制度：同一条链既阻止免费危险扩张，也阻止免费昂贵扩张。
