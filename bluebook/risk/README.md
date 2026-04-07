# 风控专题

`risk/` 只看统一治理收费链怎样在用户侧读回成 `product promise readback / reopen qualification / evidence binding`，不把风控写成账号、入口、恢复或地区场景的并列主题。
这三件事读回的不是第二套支持故事，而是同一条治理尾链在 cleanup 之后仍留下哪些 liability、哪些 reopen 资格、哪些证据绑定。
如果你还没先经过 `09 / 05 / 15 / 41` 这组高阶入口链路，不要急着把风控页读成“另一套安全规则”。
`risk/` 内部也继续继承 `问题分型 -> 工作对象 -> 控制面 -> 入口`：先判这是误伤、恢复、reopen 还是入口差异哪种用户侧工作对象，再决定你主要在读 `product promise readback`、`reopen qualification` 还是 `evidence binding`；若缺治理机制顺序，先回 `09 / 10 / security`，最后才选入口摘要、playbook 或深页。

还要先记一句：

- 本目录不是在补充另一套规则堆，而是在看同一条治理收费链怎样被用户侧读成 `product promise readback / reopen qualification / evidence binding`；想先抓高阶判断，先回 `09 / 10 / security`，再回本目录看误伤、恢复与入口差异怎样落到用户侧。

这里还应再多记一句：

- `continuity` 在风控目录里也不是第四类用户风险主题；它只是 `reopen qualification` 与恢复证据在时间轴上的联合读法。

如果只先记风控入口判定的一句话，也只记这句：

- 风控不是第二套安全规则；它只解释 `product promise readback / reopen qualification / evidence binding` 这三类用户侧对象。治理机制 speaking right 仍回 `09 / 10 / security`。

如果你只缺治理收费链的一屏速记，而不是用户侧读回对象的差异，先回 [../10-治理收费链入口卡：四类被收费资源、reject trio 与弱读回面](../10-%E6%B2%BB%E7%90%86%E6%94%B6%E8%B4%B9%E9%93%BE%E5%85%A5%E5%8F%A3%E5%8D%A1%EF%BC%9A%E5%9B%9B%E7%B1%BB%E8%A2%AB%E6%94%B6%E8%B4%B9%E8%B5%84%E6%BA%90%E3%80%81reject%20trio%20%E4%B8%8E%E5%BC%B1%E8%AF%BB%E5%9B%9E%E9%9D%A2.md)；`risk/` 只保留用户侧读法与恢复资格。

如果把风控入口判定压成最短顺序，也只剩三步：

1. `product promise readback`
   - 先确认自己看到的是哪类用户侧承诺与读回
2. `reopen qualification`
   - 再确认当前问题是否已经进入恢复 / reopen 资格判断
3. `evidence binding`
   - 最后才看自己在用什么证据申诉、恢复或追责

这三步都只在读回同一条治理尾链：它们对账的是已外化 verdict 与剩余 liability，不是倒放事件去重判当前真相。

如果继续把这三步压成最短上游依赖图，也只该再多记三句：

- `product promise readback`
  - 只读已外化 admission / capability / continuity verdict，不配补签 host truth
- `reopen qualification`
  - 只读 stronger signer 留下的 residual liability 与 threshold，不配靠弱投影自行重开
- `evidence binding`
  - 只绑定已外化 evidence 与 future-readable receipt，不回放事件重造治理真相

更硬一点说，`risk/` 在目录里的发言权也只该剩三条：

1. `product promise readback`
   - 用户侧当前读到的 admission、capability 与 continuity claim，究竟在读什么样的 runtime readback。
2. `reopen qualification`
   - cleanup 之后，用户侧为什么会把某件事读成“还能不能重开”。
3. `no mechanism override`
   - `risk/` 只解释用户侧读回与恢复资格，不重判治理主键、宿主状态机或 signer ladder 机制本身。

如果一个风控判断还压不回这三条，它就还停在“更多封禁 / 更多限制”的结果词层。
如果一个风控判断还答不上“它在结算哪类用户侧工作对象、哪段治理收费链、哪个入口只是申诉或执行 consumer”，就说明它还没压回第一性原理。

这里也要先记一句顺序：

- `risk/` 先读用户侧对象，再决定自己该回 `security`、`10` 还是 `playbooks`；不在入口页自己重放治理链

因此风控入口说明也不该自己回放事件去猜当前真相，而应沿已外化的 readback、evidence 与 reopen 条件去回读。
- 恢复与 reopen 的机制口径统一回 `security / playbooks`；通用弱读回面总声明统一回 `10`。
- `product promise readback` 也是弱读回面：它只对账已外化 verdict，不回放事件，不改判治理真相，也不越级宣布恢复成立。
- `reopen qualification` 与 `evidence binding` 也是同一尾链上的弱读回：前者判断剩余 liability 是否仍足以重开，后者判断用户侧申诉还能绑定哪类已外化证据。

更稳的 first reject signal 也应先记三条：

1. 入口差异开始被写成“能跑就算等价”，而不是 `current admission / product promise` 的差异
2. 恢复动作开始绕开 signer、证据和 reopen 责任，只剩口头安抚或结果词
3. 风控开始脱离治理收费链，被写回“更多封禁 / 更多限制”的独立故事

## 什么时候进来

- 当你已经知道统一定价治理成立，准备判断它怎样落到误伤、恢复、支持链路与入口语义差上。
- 当你需要从用户侧读回面理解 `product promise / reopen / evidence` 的样貌，而不是继续停在安全控制面。
- 当你需要判断某种现实入口选择会怎样改写 `product promise`、恢复资格或证据绑定时，再进入本目录。

如果问题已经进入恢复签发、责任划分与 reopen drill，就不要继续停在风控入口摘要：

- 验收与回退对象：回 [../playbooks/36-治理宿主验收执行手册：governance key、typed ask、decision window、continuation pricing与cleanup剧本](../playbooks/36-%E6%B2%BB%E7%90%86%E5%AE%BF%E4%B8%BB%E9%AA%8C%E6%94%B6%E6%89%A7%E8%A1%8C%E6%89%8B%E5%86%8C%EF%BC%9Aauthority%20source%E3%80%81permission%20ledger%E3%80%81decision%20window%E3%80%81continuation%20gate%E4%B8%8Erollback%E5%89%A7%E6%9C%AC.md)
- liability / reopen 执行链：回 [../playbooks/66-治理宿主修复稳态纠偏再纠偏改写纠偏精修执行手册：governance key host consumption card、hard reject order与reopen drill](../playbooks/66-%E6%B2%BB%E7%90%86%E5%AE%BF%E4%B8%BB%E4%BF%AE%E5%A4%8D%E7%A8%B3%E6%80%81%E7%BA%A0%E5%81%8F%E5%86%8D%E7%BA%A0%E5%81%8F%E6%94%B9%E5%86%99%E7%BA%A0%E5%81%8F%E7%B2%BE%E4%BF%AE%E6%89%A7%E8%A1%8C%E6%89%8B%E5%86%8C%EF%BC%9Ahost%20consumption%20card%E3%80%81hard%20reject%20order%E4%B8%8Ereopen%20drill.md)
- liability / reopen 的 canonical `repair card`：回 [../playbooks/72-治理宿主修复稳态纠偏再纠偏改写纠偏精修纠偏精修执行手册：repair card、共同reject order与reopen drill](../playbooks/72-%E6%B2%BB%E7%90%86%E5%AE%BF%E4%B8%BB%E4%BF%AE%E5%A4%8D%E7%A8%B3%E6%80%81%E7%BA%A0%E5%81%8F%E5%86%8D%E7%BA%A0%E5%81%8F%E6%94%B9%E5%86%99%E7%BA%A0%E5%81%8F%E7%B2%BE%E4%BF%AE%E7%BA%A0%E5%81%8F%E7%B2%BE%E4%BF%AE%E6%89%A7%E8%A1%8C%E6%89%8B%E5%86%8C%EF%BC%9Arepair%20card%E3%80%81%E5%85%B1%E5%90%8Creject%20order%E4%B8%8Ereopen%20drill.md)；若你缺的是 host-facing projection dialect，再回 [../playbooks/66-治理宿主修复稳态纠偏再纠偏改写纠偏精修执行手册：governance key host consumption card、hard reject order与reopen drill](../playbooks/66-%E6%B2%BB%E7%90%86%E5%AE%BF%E4%B8%BB%E4%BF%AE%E5%A4%8D%E7%A8%B3%E6%80%81%E7%BA%A0%E5%81%8F%E5%86%8D%E7%BA%A0%E5%81%8F%E6%94%B9%E5%86%99%E7%BA%A0%E5%81%8F%E7%B2%BE%E4%BF%AE%E6%89%A7%E8%A1%8C%E6%89%8B%E5%86%8C%EF%BC%9Ahost%20consumption%20card%E3%80%81hard%20reject%20order%E4%B8%8Ereopen%20drill.md)

## 继续下潜时

- 只按对象 handoff 继续：还在判治理主键、host truth 或 liability evidence，先回 `09 / philosophy/85 / security/README`；已经进入验收与回退对象，回 [../playbooks/36-治理宿主验收执行手册：governance key、typed ask、decision window、continuation pricing与cleanup剧本](../playbooks/36-%E6%B2%BB%E7%90%86%E5%AE%BF%E4%B8%BB%E9%AA%8C%E6%94%B6%E6%89%A7%E8%A1%8C%E6%89%8B%E5%86%8C%EF%BC%9Aauthority%20source%E3%80%81permission%20ledger%E3%80%81decision%20window%E3%80%81continuation%20gate%E4%B8%8Erollback%E5%89%A7%E6%9C%AC.md)；已经进入 liability / reopen drill，先回 [../playbooks/72-治理宿主修复稳态纠偏再纠偏改写纠偏精修纠偏精修执行手册：repair card、共同reject order与reopen drill](../playbooks/72-%E6%B2%BB%E7%90%86%E5%AE%BF%E4%B8%BB%E4%BF%AE%E5%A4%8D%E7%A8%B3%E6%80%81%E7%BA%A0%E5%81%8F%E5%86%8D%E7%BA%A0%E5%81%8F%E6%94%B9%E5%86%99%E7%BA%A0%E5%81%8F%E7%B2%BE%E4%BF%AE%E7%BA%A0%E5%81%8F%E7%B2%BE%E4%BF%AE%E6%89%A7%E8%A1%8C%E6%89%8B%E5%86%8C%EF%BC%9Arepair%20card%E3%80%81%E5%85%B1%E5%90%8Creject%20order%E4%B8%8Ereopen%20drill.md)，若你缺的是 host-facing projection dialect，再回 [../playbooks/66-治理宿主修复稳态纠偏再纠偏改写纠偏精修执行手册：governance key host consumption card、hard reject order与reopen drill](../playbooks/66-%E6%B2%BB%E7%90%86%E5%AE%BF%E4%B8%BB%E4%BF%AE%E5%A4%8D%E7%A8%B3%E6%80%81%E7%BA%A0%E5%81%8F%E5%86%8D%E7%BA%A0%E5%81%8F%E6%94%B9%E5%86%99%E7%BA%A0%E5%81%8F%E7%B2%BE%E4%BF%AE%E6%89%A7%E8%A1%8C%E6%89%8B%E5%86%8C%EF%BC%9Ahost%20consumption%20card%E3%80%81hard%20reject%20order%E4%B8%8Ereopen%20drill.md)。
- 只按用户侧样貌下潜编号正文：方法与总判断看 `00-10`，症状/恢复/支持链路看 `11-40`，产品化改进与长期路线看 `41-54`，现实入口与退出语义差看 `55-64`。

## 这里不回答什么

- 本目录不负责重讲治理控制面的源码机制，也不负责 host-facing contract 定义。
- 本目录只回答统一定价治理怎样落到误伤、恢复、支持链路与入口语义差上。
- 如果你还在问“治理主键是什么”或“第一条反证信号是什么”，先回 `../navigation/15`、`../navigation/41` 与 `../security/README.md`。

## 维护约定

- `risk/README` 入口判定只负责 `product promise readback / reopen qualification / evidence binding`；账号、地区、入口与支持链路只在编号页里作为样貌出现，不再在 README 里充当并列主题。
- `risk/` 解释的是统一定价控制面怎样落到误伤、恢复、支持链路与地区入口上，不把风控退回“更多规则/更多封禁”叙事。
- `risk/` 入口判定优先解释 `product promise readback / reopen qualification / evidence binding` 这组三个用户侧对象；涉及 signer ladder、治理主键或宿主状态机时，只引用 `security/` 与 `09` 已承认的机制，不在这里第一次改判。
- `risk/README` 只负责 `product promise / reopen qualification / evidence binding` 这组用户侧入口判定，不和 `security/` 抢 signer/ledger 机制入口判定，不和 `playbooks/` 抢恢复执行链。
- `risk/README` 有用户侧读法解释权，但没有治理机制改判权；一旦它开始自己重讲 signer ladder 或 host truth，对用户的恢复读法就会再次退回第二套故事。
- 需要源码级安全控制面时，回到 [../security/README.md](../security/README.md)。
- 需要失败样本和操作手册时，分别回到 [../casebooks/README.md](../casebooks/README.md) 与 [../playbooks/README.md](../playbooks/README.md)。
