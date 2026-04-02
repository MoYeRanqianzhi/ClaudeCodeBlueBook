# 安全恢复续租信号速查表：lexicon、renewal signal、cadence与failure branch

## 1. 这一页服务于什么

这一页服务于 [65-安全恢复续租信号：为什么绿色词必须靠heartbeat、poll、refresh与recheck持续续租，而不是一次观察永久有效](../65-%E5%AE%89%E5%85%A8%E6%81%A2%E5%A4%8D%E7%BB%AD%E7%A7%9F%E4%BF%A1%E5%8F%B7%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%E7%BB%BF%E8%89%B2%E8%AF%8D%E5%BF%85%E9%A1%BB%E9%9D%A0heartbeat%E3%80%81poll%E3%80%81refresh%E4%B8%8Erecheck%E6%8C%81%E7%BB%AD%E7%BB%AD%E7%A7%9F%EF%BC%8C%E8%80%8C%E4%B8%8D%E6%98%AF%E4%B8%80%E6%AC%A1%E8%A7%82%E5%AF%9F%E6%B0%B8%E4%B9%85%E6%9C%89%E6%95%88.md)。

如果 `65` 的长文解释的是：

`为什么绿色词必须持续续租，`

那么这一页只做一件事：

`把 lexicon、renewal signal、cadence 与 failure branch 压成一张续租矩阵。`

## 2. 续租信号矩阵

| lexicon | renewal signal | cadence | failure branch | 为什么需要续租 | 关键证据 |
| --- | --- | --- | --- | --- | --- |
| worker `idle` / 存活类绿色词 | `/worker/heartbeat` + `keep_alive` | 持续定时 heartbeat | stopHeartbeat、request 失败后绿色词不应继续保留 | worker liveness 不是一次 register 就永久成立 | `ccrClient.ts:453-520,677-721` |
| crash-recovery pointer 的 “fresh / resumable” | pointer mtime refresh | 小时级 refresh | 超过 TTL 变 stale；clean shutdown 清理；refresh 缺失则失去 freshness | pointer freshness 本质上是时间租约 | `bridgePointer.ts:22-34,56-70`、`bridgeMain.ts:2700-2728` |
| active work / bridge 健康租约 | `heartbeatWork()` + token re-dispatch | poll / heartbeat 循环内持续续租 | `auth_failed`、`failed`、`fatal` 分支 | active work 若不持续 heartbeat，会失去实际可恢复性 | `bridgeMain.ts:198-275` |
| task completion 后可隐藏的绿色词 | hide delay 后 recheck `allStillCompleted` | 短窗再确认 | recheck 失败则不隐藏、继续暴露当前状态 | 单次 completed 观察不够，必须经受短窗续租 | `useTasksV2.ts:138-170` |
| notification 前景词 | timeout 内仍有效、未被更高前景接管 | 秒级 / 事件级 | timeout 到期、`invalidates`、`removeNotification`、`fold` 覆盖 | 前景占位是一种极短租约 | `notifications.tsx:80-104,172-212` |

## 3. 最短判断公式

看到任一绿色词时，先问四句：

1. 它的 renewal signal 是什么
2. 它多久要续一次租
3. 续租失败后会落到哪个 failure branch
4. 如果现在拿不到 renewal signal，这个词还应不应该继续存在

## 4. 最常见的四类续租误判

| 续租误判 | 会造成什么问题 |
| --- | --- |
| 把一次 init/register 当成长期有效 | 绿色词失去持续依据 |
| 把 pointer 写入当成永久 fresh | stale recovery trail 被误当可用 |
| 把 completed 当成无需 recheck | 本地正向词被过早固化 |
| 把 notification 在场当成长期状态 | 瞬时前景误读成稳定真相 |

## 5. 一条硬结论

对 Claude Code 这类安全控制面来说，  
真正危险的不是绿色词需要频繁续租，  
而是：

`系统在续租信号已经中断后，仍继续保留旧的绿色词。`
