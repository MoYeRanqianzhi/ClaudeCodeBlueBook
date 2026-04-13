# permission-tail branch-map scope clarification 拆分记忆

## 本轮继续深入的核心判断

在当前 worktree 已经补完：

- `217`、`218`、`219` 的 structure-page scope guard

之后，

当前最自然的下一刀，

不是继续新开 permission leaf 页，

而是回补：

- `203-pendingPermissionHandlers、cancelRequest、recheckPermission、hostPattern.host 与 applyPermissionUpdate：为什么 permission tail 的 196、198、199、201、202 不是并列尾页，而是从 verdict ledger 分叉出去的四种后继问题.md`

自己的页首主语。

## 为什么这轮值得单独提交

### 判断一：当前缺口不在“203 有没有画出 permission tail 分叉图”，而在“203 会不会把 branch map、verdict / host / persist 主语与局部 helper 证据写成同一层”

`203` 正文已经把结构讲出来了：

- `196` 是 verdict ledger 根页
- `198` 是 request-level closeout
- `199` 是 leader-local re-evaluation
- `201` 是 sandbox-network host-level sibling sweep
- `202` 是 persist-to-settings / runtime write surfaces

但如果读者在进入第一性原理前，

还没先被明确提醒：

- 这里不是在重讲 `196/198/199/201/202` 各页自己的页内证明
- 这里也不该把 `pendingPermissionHandlers`、`request_id`、`cancelRequest(...)`、`recheckPermission(...)`、`hostPattern.host`、`applyPermissionUpdate(...)`、`persistPermissionUpdate(...)`、`SandboxManager.refreshConfig(...)` 这些局部 helper / field / queue / settings 名重新抬成总纲主角

就仍然很容易把：

- verdict ownership
- request closeout
- queue re-evaluation
- host sweep
- persist propagation

重新压回一句：

- “permission 尾部还有五篇平行细页”

所以这一刀真正补的，

不是更多结构事实，

而是范围声明。

### 判断二：这句必须同时点出 branch map、contract layer 与 helper-evidence 三层

本地复核与更晚一批 scope guard 已经在指向同一个风险：

- 老结构收束页最容易把“图上关系”和“图里各页局部证明对象”压成一层

如果只写：

- “这里只讲 permission tail 分叉图”

还不够稳，

因为读者仍可能把三层对象写平：

- map layer：
  - `196` 根页
  - `198/199/201/202` 四条后继线
- contract layer：
  - stable verdict ownership
  - host / queue 条件分支
  - persist surfaces
- evidence layer：
  - `pendingPermissionHandlers`
  - `request_id`
  - `cancelRequest(...)`
  - `recheckPermission(...)`
  - `hostPattern.host`
  - `applyPermissionUpdate(...)`
  - `persistPermissionUpdate(...)`
  - `SandboxManager.refreshConfig(...)`

所以当前最稳的说法必须同时说明：

- 本页主语是跨页 branch map 与 permission-tail 分层
- 各页页内主语仍留在各自 leaf page
- helper / field / queue / settings 名只作 evidence，不再升格成 `203` 的总纲主角

## 这轮具体怎么拆

这轮只做一件事：

1. 在 `203-...四种后继问题.md`
   的导语和第一性原理之间，
   增加一句范围声明：
   - 本页不重讲 `196/198/199/201/202` 各页自己的页内证明
   - 也不把 `pendingPermissionHandlers`、`request_id`、`cancelRequest(...)`、`recheckPermission(...)`、`hostPattern.host`、`applyPermissionUpdate(...)`、`persistPermissionUpdate(...)`、`SandboxManager.refreshConfig(...)` 这些局部 helper / field / queue / settings 名重新升级成新的总纲主角
   - 这里只整理跨页拓扑：`196` 是 verdict ledger 根页，随后才分叉出 `198/199/201/202`
   - 并把稳定的 verdict ownership、宿主条件性的 host / queue 分支与局部 persist-evidence 分层
   - 防止把 leaf-level 的 response consume、queue recheck、host cleanup 或 settings refresh 证明写成并排的 permission 尾部细节

这样：

- `203`
  就能和后来的 `216-219` 保持同一种 structure-page 节奏
- `203`
  不再像一页“把 196/198/199/201/202 的 leaf proof 再总述一次”的后设摘要
- 后面如果继续处理 permission / blocked-state 那簇旧结构页，
  这一页也能更稳地停在 `196/198/199/201/202` 这一层

## 苏格拉底式自审

### 问：为什么这轮不是回去补 198 或 202？

答：因为 `196/198/199/201/202` 的 leaf 页已经各自成立。当前真正缺的是 `203` 自己还没在页首把“根页 + 四条后继线，不重讲 leaf proof”写成一句。

### 问：为什么 `203` 还需要 scope guard，正文不是已经在讲分叉图了吗？

答：因为当前风险不在正文有没有图，而在读者进入图之前，仍会先把这页误听成“把 permission tail 的 leaf 证明再复述一次”。范围声明要先把这条误听切掉。

### 问：为什么这句要显式点名 `pendingPermissionHandlers`、`request_id`、`cancelRequest(...)`、`recheckPermission(...)`、`hostPattern.host`、`applyPermissionUpdate(...)`、`persistPermissionUpdate(...)`、`SandboxManager.refreshConfig(...)`？

答：因为 `203` 最容易在总纲里重新抬高这些局部对象，导致 verdict / branch / evidence 三层再次串层。先把它们降回 evidence，后文的分层才真正稳。
