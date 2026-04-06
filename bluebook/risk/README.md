# 风控专题

`risk/` 当前有 65 篇编号文档，范围 `00-64`。本目录研究账号治理、误伤、恢复、支持链路、入口语义差和中国用户场景，不把风控简化成单一封号开关。

还要先记一句：

- 本目录不是在补充另一套规则堆，而是在看平台怎样给身份、组织、执行连续性与恢复动作收费；想先抓高阶判断，先回 [../09-三张控制面总图：世界进入模型、扩张定价与防过去写坏现在.md](../09-%E4%B8%89%E5%BC%A0%E6%8E%A7%E5%88%B6%E9%9D%A2%E6%80%BB%E5%9B%BE%EF%BC%9A%E4%B8%96%E7%95%8C%E8%BF%9B%E5%85%A5%E6%A8%A1%E5%9E%8B%E3%80%81%E6%89%A9%E5%BC%A0%E5%AE%9A%E4%BB%B7%E4%B8%8E%E9%98%B2%E8%BF%87%E5%8E%BB%E5%86%99%E5%9D%8F%E7%8E%B0%E5%9C%A8.md) 的第二张图与 [../philosophy/85-真正成熟的治理，不是更会拦截，而是更会为扩张定价.md](../philosophy/85-%E7%9C%9F%E6%AD%A3%E6%88%90%E7%86%9F%E7%9A%84%E6%B2%BB%E7%90%86%EF%BC%8C%E4%B8%8D%E6%98%AF%E6%9B%B4%E4%BC%9A%E6%8B%A6%E6%88%AA%EF%BC%8C%E8%80%8C%E6%98%AF%E6%9B%B4%E4%BC%9A%E4%B8%BA%E6%89%A9%E5%BC%A0%E5%AE%9A%E4%BB%B7.md)，再进入风控专题看误伤与恢复怎样显形

风控不是安全之外第二套规则，而是同一价格秩序在身份、组织、入口子集与恢复签发上的用户侧结算面；误伤是在错误冻结能力，恢复是在凭证据和 signer 重新绑定执行连续性。

这里也要先记一句顺序：

- authority source 先决定谁有资格改边界、谁能签发恢复，再谈误伤、阻断、连续性成本与入口差异

因此风控前门也不该自己回放事件去猜当前真相，而应沿 signer、证据和 runtime 已外化的 authority/status 去回读。

如果问题已经进入恢复签发、责任划分与 reopen drill，就不要继续停在风控前门摘要：

- 验收与回退对象：回 [../playbooks/36-治理宿主验收执行手册：authority source、permission ledger、decision window、continuation gate与rollback剧本.md](../playbooks/36-%E6%B2%BB%E7%90%86%E5%AE%BF%E4%B8%BB%E9%AA%8C%E6%94%B6%E6%89%A7%E8%A1%8C%E6%89%8B%E5%86%8C%EF%BC%9Aauthority%20source%E3%80%81permission%20ledger%E3%80%81decision%20window%E3%80%81continuation%20gate%E4%B8%8Erollback%E5%89%A7%E6%9C%AC.md)
- liability / reopen 执行链：回 [../playbooks/66-治理宿主修复稳态纠偏再纠偏改写纠偏精修执行手册：host consumption card、hard reject order与reopen drill.md](../playbooks/66-%E6%B2%BB%E7%90%86%E5%AE%BF%E4%B8%BB%E4%BF%AE%E5%A4%8D%E7%A8%B3%E6%80%81%E7%BA%A0%E5%81%8F%E5%86%8D%E7%BA%A0%E5%81%8F%E6%94%B9%E5%86%99%E7%BA%A0%E5%81%8F%E7%B2%BE%E4%BF%AE%E6%89%A7%E8%A1%8C%E6%89%8B%E5%86%8C%EF%BC%9Ahost%20consumption%20card%E3%80%81hard%20reject%20order%E4%B8%8Ereopen%20drill.md)

## 目录分层

- `00-10`: 研究方法、账号/组织/订阅、遥测、远程下发、本地执行面与总判断。
- `11-24`: 治理闭环、能力分层、异常症状、误伤信号与问题导向索引。
- `25-40`: 症状反查、证明责任、恢复动作、支持链路与结构化求助模板。
- `41-54`: 深化专题、产品化改进、平台治理与长期恢复路线。
- `55-64`: 后期索引、中国用户入口、退出策略与官方/兼容路径语义差。

## 推荐入口

- [../09-三张控制面总图：世界进入模型、扩张定价与防过去写坏现在.md](../09-%E4%B8%89%E5%BC%A0%E6%8E%A7%E5%88%B6%E9%9D%A2%E6%80%BB%E5%9B%BE%EF%BC%9A%E4%B8%96%E7%95%8C%E8%BF%9B%E5%85%A5%E6%A8%A1%E5%9E%8B%E3%80%81%E6%89%A9%E5%BC%A0%E5%AE%9A%E4%BB%B7%E4%B8%8E%E9%98%B2%E8%BF%87%E5%8E%BB%E5%86%99%E5%9D%8F%E7%8E%B0%E5%9C%A8.md): 先抓“扩张如何被定价”的总判断
- [../07-运行时契约、知识层与生态边界.md](../07-%E8%BF%90%E8%A1%8C%E6%97%B6%E5%A5%91%E7%BA%A6%E3%80%81%E7%9F%A5%E8%AF%86%E5%B1%82%E4%B8%8E%E7%94%9F%E6%80%81%E8%BE%B9%E7%95%8C.md): 先抓 authority source、host truth 与 liability evidence 怎样把恢复链写硬
- [../philosophy/85-真正成熟的治理，不是更会拦截，而是更会为扩张定价.md](../philosophy/85-%E7%9C%9F%E6%AD%A3%E6%88%90%E7%86%9F%E7%9A%84%E6%B2%BB%E7%90%86%EF%BC%8C%E4%B8%8D%E6%98%AF%E6%9B%B4%E4%BC%9A%E6%8B%A6%E6%88%AA%EF%BC%8C%E8%80%8C%E6%98%AF%E6%9B%B4%E4%BC%9A%E4%B8%BA%E6%89%A9%E5%BC%A0%E5%AE%9A%E4%BB%B7.md): 先把“风控=定价在用户侧显形”压成第一性原理
- [../playbooks/36-治理宿主验收执行手册：authority source、permission ledger、decision window、continuation gate与rollback剧本.md](../playbooks/36-%E6%B2%BB%E7%90%86%E5%AE%BF%E4%B8%BB%E9%AA%8C%E6%94%B6%E6%89%A7%E8%A1%8C%E6%89%8B%E5%86%8C%EF%BC%9Aauthority%20source%E3%80%81permission%20ledger%E3%80%81decision%20window%E3%80%81continuation%20gate%E4%B8%8Erollback%E5%89%A7%E6%9C%AC.md): 看 signer、证据与恢复资格怎样进入正式验收对象
- [../playbooks/66-治理宿主修复稳态纠偏再纠偏改写纠偏精修执行手册：host consumption card、hard reject order与reopen drill.md](../playbooks/66-%E6%B2%BB%E7%90%86%E5%AE%BF%E4%B8%BB%E4%BF%AE%E5%A4%8D%E7%A8%B3%E6%80%81%E7%BA%A0%E5%81%8F%E5%86%8D%E7%BA%A0%E5%81%8F%E6%94%B9%E5%86%99%E7%BA%A0%E5%81%8F%E7%B2%BE%E4%BF%AE%E6%89%A7%E8%A1%8C%E6%89%8B%E5%86%8C%EF%BC%9Ahost%20consumption%20card%E3%80%81hard%20reject%20order%E4%B8%8Ereopen%20drill.md): 看 liability、re-entry 与 reopen 责任怎样被写成执行链
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

## 维护约定

- `risk/` 负责账号治理、误伤、恢复和入口语义差。
- `risk/` 解释的是统一定价控制面怎样在误伤、恢复、支持链路与地区入口上显形，不把风控退回“更多规则/更多封禁”叙事。
- `risk/` 前门优先解释 signer、证据、恢复资格与 authority source，不自己重做权限或宿主状态机总图。
- 需要源码级安全控制面时，回到 [../security/README.md](../security/README.md)。
- 需要失败样本和操作手册时，分别回到 [../casebooks/README.md](../casebooks/README.md) 与 [../playbooks/README.md](../playbooks/README.md)。
