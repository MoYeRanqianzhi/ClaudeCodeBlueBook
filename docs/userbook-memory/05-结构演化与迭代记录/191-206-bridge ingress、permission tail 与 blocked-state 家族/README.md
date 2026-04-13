# 191-206 bridge ingress、permission tail 与 blocked-state 家族

这个目录不是新的编号总图，

而是给已经存在的：

- `191-196` bridge ingress 阅读链
- `196-202` permission tail 四分叉
- `206` blocked-state publish ceiling

补一个可浏览的记忆入口。

这里保护的首先是：

- 阅读骨架稳定

不是：

- 目录里出现的中间节点名都已经属于稳定公开能力

如果你已经分清自己在追：

- ingress consumer / replay continuity / control side-channel
- permission verdict / closeout / re-evaluation / host sweep / persist surfaces
- `can_use_tool`、`pending_action`、`requires_action_details` 的 blocked-state 发布上限

但不想再从主 `README` 的全量时间流里逐条找文件，

这里应该先于平铺编号列表阅读。

## 第一性原理

这组记忆真正想回答的不是：

- “`191-206` 该按编号怎么顺着翻”

而是：

- 哪些记忆负责把 `191-196` 收成一条 ingress 阅读链
- 哪些记忆负责把 `196-202` 收成 verdict ledger 之后的四条后继线
- 哪些记忆负责提醒“这里更该分 stable / conditional / internal 厚度，而不是再新造一张范围图”

所以这个目录的作用只是：

- 把现有局部结构页、专题投影与 stable-gray hardening 收成一个家族入口

不是：

- 再制造一张新的 umbrella map

## 先读哪一簇

### 1. 我还在 bridge ingress 的阅读链里（`191-196`）

先读蓝皮书结构页：

- [../../../../bluebook/userbook/05-控制面深挖/197-handleIngressMessage、recentInboundUUIDs、onPermissionResponse、extractInboundMessageFields、resolveAndPrepend 与 pendingPermissionHandlers：为什么 bridge ingress 的 191-196 不是并列碎页，而是一条六层阅读链.md](../../../../bluebook/userbook/05-%E6%8E%A7%E5%88%B6%E9%9D%A2%E6%B7%B1%E6%8C%96/197-handleIngressMessage%E3%80%81recentInboundUUIDs%E3%80%81onPermissionResponse%E3%80%81extractInboundMessageFields%E3%80%81resolveAndPrepend%20%E4%B8%8E%20pendingPermissionHandlers%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%20bridge%20ingress%20%E7%9A%84%20191-196%20%E4%B8%8D%E6%98%AF%E5%B9%B6%E5%88%97%E7%A2%8E%E9%A1%B5%EF%BC%8C%E8%80%8C%E6%98%AF%E4%B8%80%E6%9D%A1%E5%85%AD%E5%B1%82%E9%98%85%E8%AF%BB%E9%93%BE.md)

再看关键记忆：

- [../197-2026-04-08-ingress reading chain split 拆分记忆.md](../197-2026-04-08-ingress%20reading%20chain%20split%20拆分记忆.md)
- [../222-2026-04-08-ingress and permission tail stable-gray hardening 拆分记忆.md](../222-2026-04-08-ingress%20and%20permission%20tail%20stable-gray%20hardening%20拆分记忆.md)

### 2. 我已经进入 permission tail 的四条后继线（`196-202`）

先读蓝皮书结构页：

- [../../../../bluebook/userbook/05-控制面深挖/203-pendingPermissionHandlers、cancelRequest、recheckPermission、hostPattern.host 与 applyPermissionUpdate：为什么 permission tail 的 196、198、199、201、202 不是并列尾页，而是从 verdict ledger 分叉出去的四种后继问题.md](../../../../bluebook/userbook/05-%E6%8E%A7%E5%88%B6%E9%9D%A2%E6%B7%B1%E6%8C%96/203-pendingPermissionHandlers%E3%80%81cancelRequest%E3%80%81recheckPermission%E3%80%81hostPattern.host%20%E4%B8%8E%20applyPermissionUpdate%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%20permission%20tail%20%E7%9A%84%20196%E3%80%81198%E3%80%81199%E3%80%81201%E3%80%81202%20%E4%B8%8D%E6%98%AF%E5%B9%B6%E5%88%97%E5%B0%BE%E9%A1%B5%EF%BC%8C%E8%80%8C%E6%98%AF%E4%BB%8E%20verdict%20ledger%20%E5%88%86%E5%8F%89%E5%87%BA%E5%8E%BB%E7%9A%84%E5%9B%9B%E7%A7%8D%E5%90%8E%E7%BB%A7%E9%97%AE%E9%A2%98.md)

再看关键记忆：

- [../198-2026-04-08-permission closeout split 拆分记忆.md](../198-2026-04-08-permission%20closeout%20split%20拆分记忆.md)
- [../199-2026-04-08-permission reevaluation surface split 拆分记忆.md](../199-2026-04-08-permission%20reevaluation%20surface%20split%20拆分记忆.md)
- [../201-2026-04-08-sandbox host sibling cleanup split 拆分记忆.md](../201-2026-04-08-sandbox%20host%20sibling%20cleanup%20split%20拆分记忆.md)
- [../202-2026-04-08-sandbox persist write surfaces split 拆分记忆.md](../202-2026-04-08-sandbox%20persist%20write%20surfaces%20split%20拆分记忆.md)
- [../386-2026-04-13-permission-tail branch-map scope clarification 拆分记忆.md](../386-2026-04-13-permission-tail%20branch-map%20scope%20clarification%20拆分记忆.md)

### 3. 我已经掉进 blocked-state / 专题出口层

先读：

- [../../../../bluebook/userbook/05-控制面深挖/206-StructuredIO、sessionState、remoteBridgeCore、pending_action、requires_action_details 与 reportState：为什么 can_use_tool 不等于 requires_action-pending_action，而 bridge blocked-state publish 只签裸 blocked bit.md](../../../../bluebook/userbook/05-%E6%8E%A7%E5%88%B6%E9%9D%A2%E6%B7%B1%E6%8C%96/206-StructuredIO%E3%80%81sessionState%E3%80%81remoteBridgeCore%E3%80%81pending_action%E3%80%81requires_action_details%20%E4%B8%8E%20reportState%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%20can_use_tool%20%E4%B8%8D%E7%AD%89%E4%BA%8E%20requires_action-pending_action%EF%BC%8C%E8%80%8C%20bridge%20blocked-state%20publish%20%E5%8F%AA%E7%AD%BE%E8%A3%B8%20blocked%20bit.md)
- [../205-2026-04-08-permission tail topic projection split 拆分记忆.md](../205-2026-04-08-permission%20tail%20topic%20projection%20split%20拆分记忆.md)
- [../222-2026-04-08-ingress and permission tail stable-gray hardening 拆分记忆.md](../222-2026-04-08-ingress%20and%20permission%20tail%20stable-gray%20hardening%20拆分记忆.md)

如果你要跳到专题层，

再看：

- [../../../../bluebook/userbook/04-专题深潜/21-桥接审批后处理与权限尾部分诊专题.md](../../../../bluebook/userbook/04-%E4%B8%93%E9%A2%98%E6%B7%B1%E6%BD%9C/21-%E6%A1%A5%E6%8E%A5%E5%AE%A1%E6%89%B9%E5%90%8E%E5%A4%84%E7%90%86%E4%B8%8E%E6%9D%83%E9%99%90%E5%B0%BE%E9%83%A8%E5%88%86%E8%AF%8A%E4%B8%93%E9%A2%98.md)
- [../../../../bluebook/userbook/04-专题深潜/22-等待输入、权限提问与阻塞态投影专题.md](../../../../bluebook/userbook/04-%E4%B8%93%E9%A2%98%E6%B7%B1%E6%BD%9C/22-%E7%AD%89%E5%BE%85%E8%BE%93%E5%85%A5%E3%80%81%E6%9D%83%E9%99%90%E6%8F%90%E9%97%AE%E4%B8%8E%E9%98%BB%E5%A1%9E%E6%80%81%E6%8A%95%E5%BD%B1%E4%B8%93%E9%A2%98.md)

## 这层入口保护什么

- 保护的是 `191-206` 这簇记忆的家族入口，不是新的编号总图。
- 保护的是 `197 -> 203 -> 206` 的局部接力关系。
- 不把 ingress 阅读链、permission tail 分叉图与 blocked-state ceiling 误写成三份互不相干的旧批次。
- 不在这一轮移动或重命名任何现有记忆文件。
