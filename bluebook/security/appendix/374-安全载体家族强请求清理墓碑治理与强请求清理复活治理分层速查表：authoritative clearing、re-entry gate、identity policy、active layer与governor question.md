# 安全载体家族强请求清理墓碑治理与强请求清理复活治理分层速查表：authoritative clearing、re-entry gate、identity policy、active layer与governor question

## 1. 这一页服务于什么

这一页服务于 [390-安全载体家族强请求清理墓碑治理与强请求清理复活治理分层](../390-安全载体家族强请求清理墓碑治理与强请求清理复活治理分层.md)。

如果 `390` 的长文解释的是：

`为什么“旧 stronger-request cleanup 世界结束后留下了墓碑”仍不等于“它已经知道哪些对象还能回来、回来时算谁”，`

那么这一页只做一件事：

`把 repo 现有的 resurrection 正对照，与 stronger-request cleanup 当前缺的 re-entry authority grammar 压成一张矩阵。`

## 2. 强请求清理墓碑治理与强请求清理复活治理分层矩阵

| positive control / cleanup surface | authoritative clearing | re-entry gate / active layer | identity or continuity policy | cleanup current gap | governor question | 关键证据 |
| --- | --- | --- | --- | --- | --- | --- |
| plugin orphan marker | installed set clears `.orphaned_at` | marker clear itself does not reload active components | same version becomes only eligible for later readmission | stronger-request cleanup has no authoritative rule for who may clear retirement markers | who decides that a cleared cleanup marker means “eligible for return” rather than “already returned” | `cacheUtils.ts:67-72,82-92,122-130` |
| active plugin return | `/reload-plugins` and `refreshActivePlugins()` perform Layer-3 swap | explicit active-world re-entry signal | current session state rebuilt and `needsRefresh` consumed | stronger-request cleanup has no explicit active-layer re-entry primitive | who decides when old cleanup objects are actually readmitted into current runtime world | `refresh.ts:1-17,59-79,123-137`; `reload-plugins.ts:37-56` |
| mode-sensitive plugin comeback | new installs may auto-refresh; updates stop at `needsRefresh` | auto-admit vs explicit-admit vs pending-admit split | pending world preserved until user or headless path consumes it | stronger-request cleanup has no mode-sensitive comeback contract | who decides which cleanup comeback paths may auto-admit and which must remain explicit | `PluginInstallationManager.ts:53-58,135-160`; `useManagePlugins.ts:28-35,288-303` |
| plan recovery | slug/evidence checked before return | recovery only on ENOENT + remote-session path | resume keeps lineage; fork mints new slug | stronger-request cleanup has no lineage/evidence gate for returning carriers | who decides whether returned cleanup objects preserve identity or only preserve content | `plans.ts:164-231,233-257`; `conversationRecovery.ts:539-547` |
| tombstone deletion path | none; deletion helper only removes old object | no re-entry gate present | no identity return semantics | stronger-request cleanup likewise lacks a dedicated resurrection plane today | who keeps deletion semantics from being mistaken for comeback semantics | `sessionStorage.ts:925-945,1468-1474` |

## 3. 四个最重要的判断问题

判断一句“旧 stronger-request cleanup 对象有墓碑，所以回来规则也已经清楚”有没有越级，先问四句：

1. 这里说的是 marker clear，还是 active-world readmission
2. 当前 comeback 需要 explicit gate，还是被偷写成自动副作用
3. 回来的是 old identity、new identity，还是只是 content continuity
4. 当前 helper 回答的是 deletion / cleanup，还是正式的 re-entry authority

## 4. 最常见的六类误读

| 误读 | 实际问题 |
| --- | --- |
| “marker 清掉就说明对象已经回来” | clearing != active admission |
| “磁盘上又有对象了，所以当前世界已经接纳它” | materialized return != runtime return |
| “能恢复内容，就说明还是原对象” | content return != identity return |
| “有 tombstone grammar 就自然有 resurrection grammar” | tombstone != re-entry authority |
| “所有 comeback path 都该自动恢复” | mature systems split auto-admit and explicit-admit worlds |
| “删除 helper 也能顺便定义 comeback” | deletion semantics should not own readmission semantics |

## 5. 一条硬结论

真正成熟的 stronger-request cleanup-resurrection grammar 不是：

`marker exists or marker cleared -> therefore old object can return`

而是：

`marker governed -> comeback evidence checked -> identity policy chosen -> active-layer admission explicitly signed`

只有这些层被补上，
stronger-request cleanup tombstone-governance 才不会继续停留在：

`系统已经知道旧世界结束后留下什么痕迹，却没人正式决定哪些带碑对象还能重新回来。`
