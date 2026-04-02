# 案例库导航：Prompt事故、治理事故与结构演化样本

这一篇不新增新的制度判断，而是回答一个更贴近现场的问题：

- 当团队已经有方法、模板、手册之后，应该去哪里看“这些制度坏掉时究竟长什么样”。

它主要回答四个问题：

1. 为什么案例样本层应独立成目录，而不是散落在 playbooks 或 docs。
2. 为什么真实失败形态往往比抽象原则更能暴露系统设计的真义。
3. Prompt、治理、源码演化三条线各该看哪类事故样本。
4. 怎样用苏格拉底式追问避免把案例库写成杂乱的 bug 堆。

## 1. Prompt 事故样本线

如果问题是：

- prompt 看起来“变差了”，但团队不知道到底是 section、boundary、compact 还是 invalidation 出了问题。
- 想直接看 prompt 魔力在失效时如何暴露本质。

建议顺序：

1. `guides/27`
2. `playbooks/01`
3. `casebooks/01`

这条线最值得看的不是“怎么写 prompt”，而是：

- section drift
- boundary drift
- path parity split
- lawful-forgetting failure
- invalidation drift

## 2. 治理事故样本线

如果问题是：

- 系统为什么突然更慢、更贵、更多 ask，或反过来突然误放行。
- 想看安全与省 token 的制度边界在真实事故里怎样暴露。

建议顺序：

1. `guides/28`
2. `playbooks/02`
3. `casebooks/02`

这条线最值得看的不是“治理矩阵本身”，而是：

- order violation
- hard-guard bypass
- approval-race degradation
- stable-bytes drift
- stop-logic failure

## 3. 结构演化样本线

如果问题是：

- 仓库为什么明明目录更整齐，却越来越难维护。
- 想看源码先进性在失败时如何失真。

建议顺序：

1. `guides/29`
2. `playbooks/03`
3. `casebooks/03`

这条线最值得看的不是“结构模板本身”，而是：

- shadow fossilization
- transport leakage
- recovery-asset corruption
- zombification
- registry obesity

## 4. 目录职责判断

如果 `10` 回答的是：

- 团队该怎样运行与复盘

那么 `11` 回答的是：

- 团队该看哪些具体失败样本，才能真正理解制度边界

所以最稳的切分是：

- `playbooks/`：运行方法
- `casebooks/`：失败样本

## 5. 苏格拉底式自检

在你准备继续补一篇“更深原则”前，先问自己：

1. 读者现在缺的是原则，还是缺具体失败样本。
2. 这个制度如果坏掉，今天是否已经有对应案例库。
3. 这些案例是在暴露制度边界，还是只是在堆零散 bug。
4. 我是在帮助团队理解本质，还是在制造新的信息噪音。
