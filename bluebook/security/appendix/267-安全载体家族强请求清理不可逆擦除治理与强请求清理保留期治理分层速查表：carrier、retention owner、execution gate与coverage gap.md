# 安全载体家族强请求清理不可逆擦除治理与强请求清理保留期治理分层速查表：carrier、retention owner、execution gate与coverage gap

## 1. 这一页服务于什么

这一页服务于 [283-安全载体家族强请求清理不可逆擦除治理与强请求清理保留期治理分层：为什么artifact-family cleanup stronger-request irreversible-erasure-governor signer不能越级冒充artifact-family cleanup stronger-request retention-governor signer](../283-安全载体家族强请求清理不可逆擦除治理与强请求清理保留期治理分层.md)。

如果 `283` 的长文解释的是：

`为什么 stronger-request old echo carrier 已经能被 destroy，仍不等于这类 carriers 的 retention horizon、runtime admission 与 coverage boundary 已经被正式治理，`

那么这一页只做一件事：

`把 repo 里现成的 stronger-request carrier retention owner / execution gate / coverage gap，压成一张矩阵。`

## 2. 强请求清理不可逆擦除治理与强请求清理保留期治理分层矩阵

| carrier | current retention owner | execution gate | coverage gap | governor question | 关键证据 |
| --- | --- | --- | --- | --- | --- |
| debug log carrier | `cleanupPeriodDays` -> `getCutoffDate()` -> `cleanupOldDebugLogs()` | background housekeeping admitted and old enough by mtime | repo-local path visible, but still generic age-based cleanup rather than request-scoped horizon | who decides how long stronger-request debug traces deserve to live before purge | `settings/types.ts:325-332`; `cleanup.ts:23-30,396-428,575-593`; `backgroundHousekeeping.ts:43-60,77-80` |
| session transcript / tool-results carrier | `cleanupPeriodDays` -> session cleanup stack | same generic cleanup scheduler + cutoff | public declaration text says transcripts, while executor scope is broader than wording | who decides the real retention scope of stronger-request transcript family beyond narrow public wording | `settings/types.ts:325-332`; `cleanup.ts` session cleanup stack |
| file-history backup carrier | `cleanupPeriodDays` -> backup cleanup stack | generic cleanup scheduler + mtime cutoff | stronger-request traces that reach backup worlds are governed by same stack, not by their local erase operator | who decides how long stronger-request side-effect history remains restorable before purge | `cleanup.ts`; `fileHistory.ts:537-582` |
| cleanup admission itself | user intent + validation guard + scheduler | explicit `cleanupPeriodDays` with validation errors => skip; recent activity => delay | erase operator alone cannot answer whether this run is legitimately admitted now | who decides when cleanup may run at all, rather than merely what it would delete | `settings/settings.ts:871-875,984-1000`; `cleanup.ts:575-584`; `backgroundHousekeeping.ts:43-60,77-80` |
| diagnostics logfile carrier | env-selected external logfile via `CLAUDE_CODE_DIAGNOSTICS_FILE` writer | append happens when env path exists | repo-local writer visible, but same-layer repo-local retention owner is not visible | who decides diagnostics carrier retention horizon for stronger-request old echoes, and where that policy actually lives | `diagLogs.ts:27-60` |

## 3. 三个最重要的判断问题

判断一句

`这个 stronger-request old echo 已经被删掉，所以 retention governance 也已经回答了`

有没有越级，先问三句：

1. 这里回答的是具体 carrier 的 destruction event，还是 carrier family 的 retention horizon
2. 当前 delete path 是否还要经过 settings intent、validation guard 与 background scheduling admission
3. 当前说法是不是把某个已覆盖 carrier 的 retention path 偷写成了所有 stronger-request carriers 都已被同层治理

## 4. 最常见的五类误读

| 误读 | 实际问题 |
| --- | --- |
| “能删 debug log 就等于已回答 retention law” | delete path != time constitution |
| “settings 文案提到 transcripts，所以 coverage 已完全显化” | declaration scope != full carrier coverage |
| “validation 有错时默认值照样可删” | explicit user intent can force cleanup to skip |
| “只要进程启动，cleanup 就算开始执法” | housekeeping still waits for delay / activity gates |
| “diagnostics 也一定在同一个 retention stack 里” | repo-local writer visible != repo-local retention owner visible |

## 5. 技术启示四条

1. 删除路径不等于时间法律。
2. 用户意图诚实性可以高于默认值与删除能力。
3. scheduler admission 是 retention governance 的一部分，不是枝节。
4. 覆盖范围本身就是治理对象，不能拿一个 covered carrier 代表全部 carrier。

## 6. 一条硬结论

真正成熟的 stronger-request cleanup retention grammar 不是：

`carrier erased -> governance complete`

而是：

`retention declared -> intent validated -> scheduler admitted -> covered carriers cleaned -> uncovered carriers honestly named`

只有中间这些层被补上，
stronger-request cleanup irreversible-erasure governance 才不会继续停留在：

`它能说明某个 stronger-request carrier 已经被删掉，却没人正式说明这类 stronger-request carriers 本来该保留多久、什么时候允许删、以及当前哪些 carriers actually 被纳入这条 retention 栈。`
