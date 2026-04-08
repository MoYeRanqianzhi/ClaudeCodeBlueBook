# 风控专题

`risk/` 只看统一治理收费链在 cleanup 之后怎样被用户侧读回成 `product promise readback / reopen eligibility readback / evidence receipt binding`，不把风控写成账号、入口、恢复或地区场景的并列主题。
这三件事读回的不是第二套支持故事，而是同一条治理尾链在 cleanup 之后留下哪些 liability、哪些 reopen 资格、哪些证据绑定。
若你还没先在 `10` 定位最早 `unpaid expansion`，本页不开始；那时你缺的还是治理前门，不是用户侧读回。
`risk/` 不先做第一轮 intake；它只在 post-cleanup readback 已经成立后，继续区分你现在读到的是 `product promise readback`、`reopen eligibility readback` 还是 `evidence receipt binding`。

还要先记一句：

- 本目录不是在补充另一套规则堆，而是在看同一条治理收费链怎样在 cleanup 之后被用户侧读成 `product promise readback / reopen eligibility readback / evidence receipt binding`；想先抓 why 或机制，先回治理入口与对应 owner README，再回本目录看误伤、恢复与入口差异怎样落到用户侧。

这里还应再多记一句：

- `continuity` 在风控目录里也不是第四类用户风险主题；它只是 `reopen eligibility readback` 与尾部证据在时间轴上的联合读法。

如果只先记风控入口判定的一句话，也只记这句：

- 风控不是第二套安全规则；它只解释 `product promise readback / reopen eligibility readback / evidence receipt binding` 这三类用户侧对象。治理机制 speaking right 仍回治理入口与对应 owner README。

如果你只缺治理收费链的一屏速记，而不是用户侧读回对象的差异，先回 [../10-治理收费链入口卡：最早 unpaid expansion、reject trio 与弱读回面](../10-%E6%B2%BB%E7%90%86%E6%94%B6%E8%B4%B9%E9%93%BE%E5%85%A5%E5%8F%A3%E5%8D%A1%EF%BC%9A%E6%9C%80%E6%97%A9%20unpaid%20expansion%E3%80%81reject%20trio%20%E4%B8%8E%E5%BC%B1%E8%AF%BB%E5%9B%9E%E9%9D%A2.md)；`risk/` 只保留用户侧读法与尾部资格，不直接出 admit / recover / rollback / reopen verdict。

如果把本页压成最短对象，也只剩三类 post-cleanup readback：

- `product promise readback`
  - 用户侧现在被告知什么仍成立、什么已被拒收
- `reopen eligibility readback`
  - cleanup 之后还能不能重开、重开什么、由什么资格约束
- `evidence receipt binding`
  - 申诉、追责与收口后还能绑定什么 receipt，而不是再重判治理真相

这三类对象都只在读回同一条治理尾链：它们对账的是已外化 verdict 与剩余 liability，不是倒放事件去重判当前真相。

更硬一点说，`risk/` 在目录里的发言权也只该剩一句：本页只解释用户侧 readback，不重判 signer、threshold、runtime seam 或执行动作；一旦问题改写成 admit / recover / rollback / reopen 动词，立即离开到 `playbooks/README`。

这里也要先记一句顺序：

- `risk/` 只在 post-cleanup readback 已经成立后开始；若还要回头重判治理链，先退回治理入口与对应机制 owner README，不在本页自己重放治理前门。

因此风控入口说明也不该自己回放事件去猜当前真相，而应沿已外化的 readback、receipt 与 reopen 条件去回读。治理 why 与机制口径统一回对应 owner README；只要问题已经进入验收、修复或 reopen drill，就统一回 `playbooks/README`。

更稳的用户侧失真信号也只记三条：

1. 入口差异开始被写成“能跑就算等价”，而不是 `current admission / product promise` 的差异
2. 恢复动作开始绕开 signer、证据和 reopen 责任，只剩口头安抚或结果词
3. 风控开始脱离治理收费链，被写回“更多封禁 / 更多限制”的独立故事

## 什么时候进来

- 当你已经知道统一定价治理成立，并且 cleanup 已经把旧 authority 收口，准备判断它怎样落到误伤、恢复、支持链路与入口语义差上。
- 当你需要从用户侧读回面理解 `product promise / reopen / evidence` 的样貌，而不是继续停在安全控制面。
- 当你需要判断某种现实入口选择会怎样改写 `product promise`、恢复资格或证据绑定时，再进入本目录。

如果问题已经进入恢复签发、责任划分与 reopen drill，就不要继续停在风控入口摘要，统一回 [../playbooks/README.md](../playbooks/README.md)。

## 继续下潜时

- 只按对象 handoff 继续：还在判治理主键、host truth 或 liability evidence，先回对应 why / mechanism owner；已经进入执行动作，统一回 [../playbooks/README.md](../playbooks/README.md)。
- README 不再按编号正文预排阅读顺序；用户侧样貌、支持链路与入口差异统一留给对应正文。

## 这里不回答什么

- 本目录不负责重讲治理控制面的源码机制，也不负责 host-facing contract 定义。
- 本目录只回答统一定价治理怎样落到误伤、恢复、支持链路与入口语义差上。
- 如果你还在问“治理主键是什么”或“第一条反证信号是什么”，先回 `../navigation/15`、`../navigation/41` 与 `../security/README.md`。

## 维护约定

- `risk/README` 入口判定只负责 `product promise readback / reopen eligibility readback / evidence receipt binding`；账号、地区、入口与支持链路只在编号页里作为样貌出现，不再在 README 里充当并列主题。
- `risk/` 解释的是统一定价控制面怎样落到误伤、恢复、支持链路与地区入口上，不把风控退回“更多规则/更多封禁”叙事。
- `risk/` 入口判定优先解释 `product promise readback / reopen eligibility readback / evidence receipt binding` 这组三个用户侧对象；涉及 signer ladder、治理主键或宿主状态机时，只引用 `security/` 与 `09` 已承认的机制，不在这里第一次改判。
- `risk/README` 只负责 `product promise / reopen eligibility / evidence receipt binding` 这组用户侧入口判定，不和 `security/` 抢 signer/ledger 机制入口判定，不和 `playbooks/` 抢恢复执行链。
- `risk/README` 有用户侧读法解释权，但没有治理机制改判权；一旦它开始自己重讲 signer ladder 或 host truth，对用户的恢复读法就会再次退回第二套故事。
- 需要源码级安全控制面时，回到 [../security/README.md](../security/README.md)。
- 需要失败样本和操作手册时，分别回到 [../casebooks/README.md](../casebooks/README.md) 与 [../playbooks/README.md](../playbooks/README.md)。
