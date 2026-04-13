# 风控专题

`risk/` 只看统一治理收费链在 cleanup 之后怎样被用户侧读回成三类对象：`product promise readback / reopen eligibility readback / evidence receipt binding`。
若你还没先在 `10` 定位最早 `unpaid expansion`，本页不开始；那时你缺的还是治理前门，不是用户侧读回。
更硬一点说，`risk/` 不补第二套规则，也不代签执行 verdict；它只解释 cleanup 之后用户还能读回并对账哪些 aftermath residues：哪些 liability 还在、哪些 reopen 资格还留着、哪些 receipt-grade 证据还能被绑定。
这里的三类对象也都只配停在 cleanup-aftermath 的 receipt-grade：若某个用户侧 surface 没有新增 signer 证据、boundary delta 或 cleanup delta，它就只能绑定已外化 verdict，不能倒放回治理层重签当前事实。

`continuity` 在这里也不是第四类风险主题；它只是 `reopen eligibility readback` 与 `cleanup-aftermath receipt trail` 在时间轴上的联合读法。

## 三类用户侧 readback

- `product promise readback`
  - 用户侧现在被告知什么仍成立、什么已被拒收
- `reopen eligibility readback`
  - cleanup 之后还能不能重开、重开什么、由什么资格约束
- `evidence receipt binding`
  - 申诉、追责与收口后还能绑定哪些 `receipt-grade` receipt，例如可引用的确认、工单记录或支持链路回执，而不是再重判治理真相

这三类对象都只在读回同一条治理尾链：它们对账的是已外化 verdict 与剩余 liability，不是倒放事件去重判当前真相。
更稳一点说，`risk/` 里的 `product promise / reopen / evidence` 都是 cleanup 之后的 aftermath object；它们最多解释“现在还剩什么承诺、责任与 receipt”，不解释“刚才该不该允许”。

## 用户侧失真信号

1. 入口差异开始被写成“能跑就算等价”，而不是 `current admission / product promise` 的差异
2. 恢复动作开始只剩口头安抚或结果词，看不见明确 readback、receipt-grade acknowledgement 与 reopen responsibility
3. 风控开始脱离治理收费链，被写回“更多封禁 / 更多限制”的独立故事
4. cleanup-aftermath 的 receipt 开始被拿来倒推新的治理事实，而不是只绑定旧 verdict 与剩余 liability

## 什么时候进来

- 当你已经知道统一定价治理成立，并且 cleanup 已经把旧 authority 收口，准备判断它怎样落到误伤、恢复、支持链路与入口语义差上。
- 当你需要从用户侧读回面理解 `product promise / reopen / evidence` 的样貌，而不是继续停在安全控制面。
- 当你需要判断某种现实入口选择会怎样改写 `product promise readback`、恢复资格读回或证据绑定时，再进入本目录。

若还在判 signer、`verdict ledger`、`cleanup authority` 或治理 why，先回 [../security/README.md](../security/README.md)、[../10-治理收费链入口卡：最早 unpaid expansion、reject trio 与弱读回面](../10-%E6%B2%BB%E7%90%86%E6%94%B6%E8%B4%B9%E9%93%BE%E5%85%A5%E5%8F%A3%E5%8D%A1%EF%BC%9A%E6%9C%80%E6%97%A9%20unpaid%20expansion%E3%80%81reject%20trio%20%E4%B8%8E%E5%BC%B1%E8%AF%BB%E5%9B%9E%E9%9D%A2.md) 与对应 why 页；若问题已经进入恢复签发、责任划分与 reopen drill，统一回 [../playbooks/README.md](../playbooks/README.md)。

## 这里不回答什么

- 本目录不负责重讲治理控制面的源码机制，也不负责 host-facing contract 定义。
- 本目录只回答统一定价治理怎样落到误伤、恢复、支持链路与入口语义差上。
- 如果你还在问“治理主键是什么”或“第一条反证信号是什么”，先回 `../navigation/15`、`../navigation/41` 与 `../security/README.md`。

## 维护约定

- `risk/README` 只负责 `product promise readback / reopen eligibility readback / evidence receipt binding` 这组三个用户侧对象，不和 `security/` 抢治理机制入口，不和 `playbooks/` 抢恢复执行链。
- README 不再按编号正文预排阅读顺序；用户侧样貌、支持链路与入口差异统一留给对应正文。
- `risk/README` 有用户侧读法解释权，但没有治理机制改判权；一旦它开始自己重讲 signer ladder、治理主键或 host truth，用户侧读法就会再次退回第二套故事。
- 需要源码级安全控制面时，回到 [../security/README.md](../security/README.md)。
- 需要失败样本和操作手册时，分别回到 [../casebooks/README.md](../casebooks/README.md) 与 [../playbooks/README.md](../playbooks/README.md)。
