# 安全审计关闭与不可逆销毁分层速查表：artifact、what audit can close、what irreversible erasure still requires、retention owner与destruction gate

## 1. 这一页服务于什么

这一页服务于 [154-安全审计关闭与不可逆销毁分层：为什么audit-close signer不能越级冒充irreversible-erasure signer](../154-安全审计关闭与不可逆销毁分层：为什么audit-close%20signer不能越级冒充irreversible-erasure%20signer.md)。

如果 `154` 的长文解释的是：

`为什么 audit close 仍不等于 irreversible erasure，`

那么这一页只做一件事：

`把不同 artifact 到底最多能被 audit close 到哪一层、真正 destroy 还缺什么 gate、以及当前是谁在控制 retention，压成一张矩阵。`

## 2. 审计关闭与不可逆销毁分层矩阵

| artifact | what audit can close | what irreversible erasure still requires | retention owner | destruction gate | 关键证据 |
| --- | --- | --- | --- | --- | --- |
| pre-compact / pre-boundary transcript bytes | can stop participating in current load path | actual file rewrite or aged-out cleanup | transcript retention plane | `cleanupPeriodDays` + housekeeping or explicit destructive rewrite | `sessionStoragePortable.ts:613-645,717-792`; `sessionStorage.ts:3539-3579` |
| snipped middle-range messages | can be removed from reconstructed conversation chain | disk-level deletion of original JSONL lines | transcript retention plane | explicit rewrite, not just snip replay | `sessionStorage.ts:1959-1977,1988-2039` |
| orphaned transcript entry | can be tombstoned from local transcript | broader policy saying other replicas/backups are also destroyed | local transcript owner | `removeMessageByUuid()` truncate/rewrite path | `sessionStorage.ts:863-949` |
| hydrated local session file | can be replaced by remote/internal authoritative mirror | proof that old evidence world no longer exists elsewhere | upstream log authority + retention plane | hydration rewrite is not enough by itself | `sessionStorage.ts:1595-1608,1654-1660` |
| in-memory file history window | can forget snapshots beyond current 100-entry state window | backup directory deletion | file-history retention plane | aged-out recursive cleanup | `fileHistory.ts:54,305-325`; `cleanup.ts:305-347` |
| workspace file during rewind | can be deleted to restore target snapshot semantics | backup/session retention delete | rewind operator for workspace only | `applySnapshot()` unlink is not backup destruction | `fileHistory.ts:533-582` |
| old session `.jsonl` / `.cast` / tool-results | can be declared audit-inactive long before deletion | actual age-based unlink | housekeeping + settings-derived cutoff | `cleanupOldSessionFiles()` | `cleanup.ts:25-31,155-257` |
| old file-history session dir | can be audit-inactive | recursive backup removal | housekeeping + settings-derived cutoff | `cleanupOldFileHistoryBackups()` | `cleanup.ts:305-347` |

## 3. 最短判断公式

判断某句“现在已经不可逆销毁”的说法有没有越级，先问五句：

1. 当前变化发生在 read path 还是 disk path
2. 当前动作只是 filter/relink，还是发生了真实 destructive write
3. 这个 destructive write 是局部 repair，还是 retention policy 的正式执行
4. 还有没有其他 backup / mirror / upstream source 继续保存同类证据
5. 是否拿到了比 audit close 更强的 destruction gate

## 4. 最常见的五类误读

| 误读 | 实际问题 |
| --- | --- |
| “loader 不读了，所以等于被删了” | filtering 不等于 erasure |
| “snip 说 removed 了，所以磁盘上也没了” | 注释明确写着 removed messages stay on disk |
| “truncate 一次就说明系统已经完成 destroy” | 局部 destructive edit 不等于系统级 retention verdict |
| “rewind 删除工作区文件，所以备份也一起没了” | workspace delete 与 backup cleanup 是两套主权 |
| “cleanup 迟早会删，所以现在就可说已销毁” | future retention possibility 不等于 current destruction truth |

## 5. 一条硬结论

真正成熟的 destruction grammar 不是：

`audit_closed -> destroyed`

而是：

`audit_participation_closed、local_mirror_rewritten、workspace_rewound、retention_cutoff_reached、destruction_executed`

分别由不同 gate、不同 artifact scope 与不同 owner 署名。
