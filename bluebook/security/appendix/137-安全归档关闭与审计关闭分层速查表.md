# 安全归档关闭与审计关闭分层速查表：artifact、what archive can close、what audit still retains、required stronger audit gate与future retention implication

## 1. 这一页服务于什么

这一页服务于 [153-安全归档关闭与审计关闭分层：为什么archive-close signer不能越级冒充audit-close signer](../153-%E5%AE%89%E5%85%A8%E5%BD%92%E6%A1%A3%E5%85%B3%E9%97%AD%E4%B8%8E%E5%AE%A1%E8%AE%A1%E5%85%B3%E9%97%AD%E5%88%86%E5%B1%82%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88archive-close%20signer%E4%B8%8D%E8%83%BD%E8%B6%8A%E7%BA%A7%E5%86%92%E5%85%85audit-close%20signer.md)。

如果 `153` 的长文解释的是：

`为什么 archive close 仍不等于 audit close，`

那么这一页只做一件事：

`把不同 artifact 到底最多能被 archive 到哪一层、审计世界仍保留什么、以及真正 audit close 还缺什么 gate，压成一张矩阵。`

## 2. 归档关闭与审计关闭分层矩阵

| artifact | what archive can close | what audit still retains | required stronger audit gate | future retention implication | 关键证据 |
| --- | --- | --- | --- | --- | --- |
| bridge/session active web surface | active online presence | local transcript + metadata + recovery chain | stronger evidence-world close | 需要 `archive_close_allowed` 与 `audit_material_retained` 分开 | `bridgeMain.ts:1540-1577` |
| transcript JSONL | may no longer represent an active session | still loadable by `loadTranscriptFile/loadFullLog` | explicit transcript retention close | 需要 `audit_scope=transcript` | `sessionStorage.ts:2300-2352,2955-3050` |
| session metadata at EOF | session may be archived | title/tag/agent/mode/worktree/PR still re-appended and recoverable | stronger metadata close | 需要 `audit_scope=metadata` | `sessionStorage.ts:721-839,1509-1534` |
| file history backups | active UI may close | snapshots/backups still copied and re-recorded on resume | stronger backup destruction gate | 需要 `audit_scope=file-history` | `fileHistory.ts:922-1045` |
| content replacements | active work may end | replacement records still persist for resume/cache correctness | stronger replacement close | 需要 `audit_scope=content-replacements` | `sessionRestore.ts:452-462`; `sessionStorage.ts:2308-2344,3038-3040` |
| context collapse history | live session may close | commits/snapshot still restored into runtime state | stronger collapse-log close | 需要 `audit_scope=context-collapse` | `sessionRestore.ts:490-503`; `sessionStorage.ts:2345-2350,3041-3049` |
| cross-directory resume path | object may be off active surface | `fullPath` still carries log into resume world | stronger path invalidation gate | 需要 `resume_reconstructable` 字段 | `conversationRecovery.ts:540-590` |

## 3. 最短判断公式

判断某句“现在已经审计关闭”的说法有没有越级，先问四句：

1. 当前关闭的是 active surface，还是 evidence world
2. transcript / metadata / history / snapshot 是否仍被正式读取
3. 系统是否仍允许 resume / reconstruct / loadFullLog
4. 是否拿到了比 archive close 更强的 audit close gate

## 4. 最常见的五类误读

| 误读 | 实际问题 |
| --- | --- |
| “archive 了，所以 transcript 也算封存完成” | archive 不等于 transcript close |
| “environment offline 了，所以恢复材料也失效了” | offline projection 不等于 local audit death |
| “退出时 metadata 已写回，所以这只是善后细节” | re-append 恰恰说明系统仍在保全 audit context |
| “resume 只是恢复运行，不算审计世界继续存在” | resume 正是 evidence world 仍活着的证明 |
| “file history 只是附属功能” | 只要它仍被 copy/re-record，它就是正式恢复资产 |

## 5. 一条硬结论

真正成熟的 retention grammar 不是：

`archive -> audit close`

而是：

`archive_close_allowed、audit_material_retained、resume_reconstructable、audit_close_granted`

分别由不同 gate、不同 artifact scope、不同 authority 签字。
