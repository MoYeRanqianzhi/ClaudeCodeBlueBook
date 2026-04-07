# 风控专题

`risk/` 当前有 65 篇编号文档，范围 `00-64`。本目录研究账号治理、误伤、恢复、支持链路、入口语义差和中国用户场景，不把风控简化成单一封号开关。
如果你还没先经过 `09 / 05 / 15 / 41` 这组高阶前门，不要急着把风控页读成“另一套安全规则”。
`risk/` 内部也继续继承 `问题分型 -> 工作对象 -> 控制面 -> 入口`：先判这是误伤、恢复、reopen 还是入口差异哪种用户侧工作对象，再判它卡在 `governance key / typed ask / decision window / continuation pricing / durable-transient cleanup` 的哪一段；若问题已经进入恢复签发，再另判 `signer + evidence + reopen`，最后才选前门、playbook 或深页。

还要先记一句：

- 本目录不是在补充另一套规则堆，而是在看平台怎样给身份、组织、执行连续性与恢复动作收费；想先抓高阶判断，先回 [../09-三张控制面总图：世界进入模型、扩张定价与防过去写坏现在.md](../09-%E4%B8%89%E5%BC%A0%E6%8E%A7%E5%88%B6%E9%9D%A2%E6%80%BB%E5%9B%BE%EF%BC%9A%E4%B8%96%E7%95%8C%E8%BF%9B%E5%85%A5%E6%A8%A1%E5%9E%8B%E3%80%81%E6%89%A9%E5%BC%A0%E5%AE%9A%E4%BB%B7%E4%B8%8E%E9%98%B2%E8%BF%87%E5%8E%BB%E5%86%99%E5%9D%8F%E7%8E%B0%E5%9C%A8.md) 的第二张图与 [../philosophy/85-真正成熟的治理，不是更会拦截，而是更会为扩张定价.md](../philosophy/85-%E7%9C%9F%E6%AD%A3%E6%88%90%E7%86%9F%E7%9A%84%E6%B2%BB%E7%90%86%EF%BC%8C%E4%B8%8D%E6%98%AF%E6%9B%B4%E4%BC%9A%E6%8B%A6%E6%88%AA%EF%BC%8C%E8%80%8C%E6%98%AF%E6%9B%B4%E4%BC%9A%E4%B8%BA%E6%89%A9%E5%BC%A0%E5%AE%9A%E4%BB%B7.md)，再进入风控专题看误伤与恢复怎样落到用户侧

这里还应再多记一句：

- `continuity` 在风控目录里也不是第四类用户风险主题；它只是 `continuation pricing`、恢复证据与 `reopen qualification` 在用户侧的结算面。

如果只先记风控前门的一句话，也只记这句：

- 风控不是第二套安全规则，而是同一条治理收费链在 `product promise / reopen qualification / evidence binding` 这组用户侧 consumer 上的读法：先由 `governance key` 决定谁能改边界，再看 `product promise / decision window` 怎样被用户侧读到，先由 `durable-transient cleanup` 收口，再由 `signer + evidence + reopen` 决定恢复是否成立。

这里还应再多记一句：

- 这组用户侧读法并不脱离完整治理链；更稳的读法仍是 `governance key -> externalized truth chain -> typed ask -> decision window -> continuation pricing -> durable-transient cleanup`，只是它在风控目录里主要落到 `product promise`、`reopen qualification` 与 `signer + evidence + reopen` 这组用户侧判断对象。

风控不是安全之外第二套规则，而是同一价格秩序在身份、组织、入口子集与恢复签发上的用户侧读法；误伤是在错误冻结能力，恢复是在凭证据和 signer 重新绑定执行连续性。

如果把风控前门继续压成最短公式，也只剩三条：

1. `governance key`
   - 谁配签发恢复、谁配冻结边界
2. `decision window -> continuation pricing`
   - 当前误伤、恢复与入口差异到底落在用户侧哪一层，以及这次继续是否仍值得续费
3. `durable-transient cleanup`
   - 治理 verdict 到这里先收口；若要恢复，再由 `signer + evidence + reopen` 凭证据重建执行连续性，并把旧的 transient authority 清算干净

如果继续把风控前门也压成和 `security / userbook/05` 共用的三段顺序，也只该再补一句：

- 先判 `governance key / truth-surface`
- 再判 `typed ask / visible-set / sandbox`
- 最后才判 `decision window / continuation pricing / durable-transient cleanup`；若要恢复，再另判 `reopen qualification`

更硬一点说，`risk/` 在目录里的发言权也只该剩三条：

1. `product promise / reopen qualification`
   - 误伤、恢复、入口差异与连续性成本怎样被用户侧读到。
2. `reopen qualification`
   - 哪些 signer、evidence 与 reopen 责任在用户侧重新绑定执行连续性。
3. `no mechanism override`
   - `risk/` 不重判治理主键、宿主状态机或 signer ladder 机制本身。

如果一个风控判断还压不回这三条，它就还停在“更多封禁 / 更多限制”的结果词层。
如果一个风控判断还答不上“它在结算哪类用户侧工作对象、哪段治理收费链、哪个入口只是申诉或执行 consumer”，就说明它还没压回第一性原理。

这里也要先记一句顺序：

- `governance key` 先决定谁有资格改边界、谁能签发恢复，再谈误伤、阻断、连续性成本与入口差异

因此风控前门也不该自己回放事件去猜当前真相，而应沿 signer、证据和 runtime 已外化的 truth-surface / decision window / cleanup verdict 去回读。
- `/status / /doctor / /usage` 只配做 runtime projection；`Compact / Resume / Memory` 只配做 continuation consumer；`Export` 只配做 `Outside` handoff surface；用户侧恢复继续落在 `signer + evidence + reopen`。

更稳的 first reject signal 也应先记三条：

1. 入口差异开始被写成“能跑就算等价”，而不是 `current admission / product promise` 的差异
2. 恢复动作开始绕开 signer、证据和 reopen 责任，只剩口头安抚或结果词
3. 风控开始脱离治理收费链，被写回“更多封禁 / 更多限制”的独立故事

## 什么时候进来

- 当你已经知道统一定价治理成立，准备判断它怎样落到误伤、恢复、支持链路与入口语义差上。
- 当你需要从用户侧结算面理解 signer、liability、reopen 与恢复连续性，而不是继续停在安全控制面。
- 当你需要回答“中国用户入口、兼容路径与官方路径”这些现实选择怎样改变风险语义。

如果问题已经进入恢复签发、责任划分与 reopen drill，就不要继续停在风控前门摘要：

- 验收与回退对象：回 [../playbooks/36-治理宿主验收执行手册：governance key、typed ask、decision window、continuation pricing与cleanup剧本](../playbooks/36-%E6%B2%BB%E7%90%86%E5%AE%BF%E4%B8%BB%E9%AA%8C%E6%94%B6%E6%89%A7%E8%A1%8C%E6%89%8B%E5%86%8C%EF%BC%9Aauthority%20source%E3%80%81permission%20ledger%E3%80%81decision%20window%E3%80%81continuation%20gate%E4%B8%8Erollback%E5%89%A7%E6%9C%AC.md)；当前对象链读法应以 `governance key -> externalized truth chain -> typed ask -> decision window -> continuation pricing -> cleanup` 为准
- liability / reopen 执行链：回 [../playbooks/66-治理宿主修复稳态纠偏再纠偏改写纠偏精修执行手册：governance key host consumption card、hard reject order与reopen drill](../playbooks/66-%E6%B2%BB%E7%90%86%E5%AE%BF%E4%B8%BB%E4%BF%AE%E5%A4%8D%E7%A8%B3%E6%80%81%E7%BA%A0%E5%81%8F%E5%86%8D%E7%BA%A0%E5%81%8F%E6%94%B9%E5%86%99%E7%BA%A0%E5%81%8F%E7%B2%BE%E4%BF%AE%E6%89%A7%E8%A1%8C%E6%89%8B%E5%86%8C%EF%BC%9Ahost%20consumption%20card%E3%80%81hard%20reject%20order%E4%B8%8Ereopen%20drill.md)

## 目录分层

- `00-10`: 研究方法、账号/组织/订阅、遥测、远程下发、本地执行面与总判断。
- `11-24`: 治理闭环、能力分层、异常症状、误伤信号与问题导向索引。
- `25-40`: 症状反查、证明责任、恢复动作、支持链路与结构化求助模板。
- `41-54`: 深化专题、产品化改进、平台治理与长期恢复路线。
- `55-64`: 后期索引、中国用户入口、退出策略与官方/兼容路径语义差。

## 推荐入口

- [../09-三张控制面总图：世界进入模型、扩张定价与防过去写坏现在.md](../09-%E4%B8%89%E5%BC%A0%E6%8E%A7%E5%88%B6%E9%9D%A2%E6%80%BB%E5%9B%BE%EF%BC%9A%E4%B8%96%E7%95%8C%E8%BF%9B%E5%85%A5%E6%A8%A1%E5%9E%8B%E3%80%81%E6%89%A9%E5%BC%A0%E5%AE%9A%E4%BB%B7%E4%B8%8E%E9%98%B2%E8%BF%87%E5%8E%BB%E5%86%99%E5%9D%8F%E7%8E%B0%E5%9C%A8.md): 先抓“扩张如何被定价”的总判断
- [../07-运行时契约、知识层与生态边界.md](../07-%E8%BF%90%E8%A1%8C%E6%97%B6%E5%A5%91%E7%BA%A6%E3%80%81%E7%9F%A5%E8%AF%86%E5%B1%82%E4%B8%8E%E7%94%9F%E6%80%81%E8%BE%B9%E7%95%8C.md): 先抓 `governance key`、host truth 与 liability evidence 怎样把恢复链写硬
- [../philosophy/85-真正成熟的治理，不是更会拦截，而是更会为扩张定价.md](../philosophy/85-%E7%9C%9F%E6%AD%A3%E6%88%90%E7%86%9F%E7%9A%84%E6%B2%BB%E7%90%86%EF%BC%8C%E4%B8%8D%E6%98%AF%E6%9B%B4%E4%BC%9A%E6%8B%A6%E6%88%AA%EF%BC%8C%E8%80%8C%E6%98%AF%E6%9B%B4%E4%BC%9A%E4%B8%BA%E6%89%A9%E5%BC%A0%E5%AE%9A%E4%BB%B7.md): 先把风控怎样回到治理收费链压成第一性原理
- [../playbooks/36-治理宿主验收执行手册：governance key、typed ask、decision window、continuation pricing与cleanup剧本](../playbooks/36-%E6%B2%BB%E7%90%86%E5%AE%BF%E4%B8%BB%E9%AA%8C%E6%94%B6%E6%89%A7%E8%A1%8C%E6%89%8B%E5%86%8C%EF%BC%9Aauthority%20source%E3%80%81permission%20ledger%E3%80%81decision%20window%E3%80%81continuation%20gate%E4%B8%8Erollback%E5%89%A7%E6%9C%AC.md): 看 signer、证据与恢复资格怎样进入正式验收对象
- [../playbooks/66-治理宿主修复稳态纠偏再纠偏改写纠偏精修执行手册：governance key host consumption card、hard reject order与reopen drill](../playbooks/66-%E6%B2%BB%E7%90%86%E5%AE%BF%E4%B8%BB%E4%BF%AE%E5%A4%8D%E7%A8%B3%E6%80%81%E7%BA%A0%E5%81%8F%E5%86%8D%E7%BA%A0%E5%81%8F%E6%94%B9%E5%86%99%E7%BA%A0%E5%81%8F%E7%B2%BE%E4%BF%AE%E6%89%A7%E8%A1%8C%E6%89%8B%E5%86%8C%EF%BC%9Ahost%20consumption%20card%E3%80%81hard%20reject%20order%E4%B8%8Ereopen%20drill.md): 看 liability、re-entry 与 reopen 责任怎样被写成执行链
- [00-研究方法与可信边界](00-研究方法与可信边界.md)
- [01-风控总论：封禁不是单点开关](01-风控总论：封禁不是单点开关.md)
- [11-治理闭环时序：观测、判定、下发、阻断与恢复](11-治理闭环时序：观测、判定、下发、阻断与恢复.md)
- [25-问题导向索引：按症状、源码入口与合规动作阅读风控专题](25-问题导向索引：按症状、源码入口与合规动作阅读风控专题.md)
- [41-连续性成本最小化：把合规自保从故障窗口扩展到日常操作纪律](41-连续性成本最小化：把合规自保从故障窗口扩展到日常操作纪律.md)
- [61-中国用户使用生态与认识论边界：官方路径、中转站与幕后叙事该如何判断](61-中国用户使用生态与认识论边界：官方路径、中转站与幕后叙事该如何判断.md)
- [64-官方路径、云厂商路径与兼容入口的能力语义差清单：哪些只是能跑，哪些更接近等价](64-官方路径、云厂商路径与兼容入口的能力语义差清单：哪些只是能跑，哪些更接近等价.md)

## 适合什么时候读

- 想先建立整体判断：从 `00-10`
- 想从症状和误伤恢复进入：从 `25-40`
- 想看产品与制度层改进：从 `41-54`
- 想看中国用户入口与退出策略：从 `61-64`

## 这里不回答什么

- 本目录不负责重讲治理控制面的源码机制，也不负责 host-facing contract 定义。
- 本目录只回答统一定价治理怎样落到误伤、恢复、支持链路与入口语义差上。
- 如果你还在问“治理主键是什么”或“第一条反证信号是什么”，先回 `../navigation/15`、`../navigation/41` 与 `../security/README.md`。

## 维护约定

- `risk/` 负责账号治理、误伤、恢复和入口语义差。
- `risk/` 解释的是统一定价控制面怎样落到误伤、恢复、支持链路与地区入口上，不把风控退回“更多规则/更多封禁”叙事。
- `risk/` 前门优先解释 signer、证据、恢复资格与 `governance key`，不自己重做权限或宿主状态机总图。
- `risk/README` 只负责 `product promise / reopen qualification / evidence binding` 这组用户侧前门，不和 `security/` 抢 signer/ledger 机制前门，不和 `playbooks/` 抢恢复执行链。
- `risk/README` 有用户侧读法解释权，但没有治理机制改判权；一旦它开始自己重讲 signer ladder 或 host truth，对用户的恢复读法就会再次退回第二套故事。
- 需要源码级安全控制面时，回到 [../security/README.md](../security/README.md)。
- 需要失败样本和操作手册时，分别回到 [../casebooks/README.md](../casebooks/README.md) 与 [../playbooks/README.md](../playbooks/README.md)。
