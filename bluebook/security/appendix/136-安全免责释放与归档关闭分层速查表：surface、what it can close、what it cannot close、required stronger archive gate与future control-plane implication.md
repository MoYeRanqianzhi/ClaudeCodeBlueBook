# 安全免责释放与归档关闭分层速查表：surface、what it can close、what it cannot close、required stronger archive gate与future control-plane implication

## 1. 这一页服务于什么

这一页服务于 [152-安全免责释放与归档关闭分层：为什么liability-release signer不能越级冒充archive-close signer](../152-安全免责释放与归档关闭分层：为什么liability-release%20signer不能越级冒充archive-close%20signer.md)。

如果 `152` 的长文解释的是：

`为什么 liability release 仍不等于 archive close，`

那么这一页只做一件事：

`把不同 surface 到底最多能关闭什么、还不能关闭什么、以及真正 archive 还缺什么 gate，压成一张矩阵。`

## 2. 免责释放与归档关闭分层矩阵

| surface | what it can close | what it cannot close | required stronger archive gate | future control-plane implication | 关键证据 |
| --- | --- | --- | --- | --- | --- |
| multi-session completed session | active web UI stale presence | broader bridge lifecycle / deeper semantic closure | session-level active-surface exit | 需要 `archive_close_allowed` | `bridgeMain.ts:553-568` |
| graceful shutdown archive path | sessions exit active server/UI surface | resume honesty preserved path | non-resumable shutdown + environment close | 需要 `environment_offline` 与 `close_reason` | `bridgeMain.ts:1418-1577` |
| single-session non-fatal exit | local process may exit | session/environment archive close | stronger gate: resume promise no longer needs preservation | 需要 `resume_honesty_preserved` 字段 | `bridgeMain.ts:1515-1537` |
| session-gone deterministic failure | stale resume claim | deeper audit close | server-side dead truth | 需要 `close_reason=gone/expired/auth` 分流 | `bridgeMain.ts:2384-2398` |
| transient reconnect failure | current reconnect attempt | archive close / deregister / retry destruction | fatal reconnect failure 才能继续关闭 | 需要 `retry_asset_retained` | `bridgeMain.ts:2524-2540` |
| environment deregister | offline projection + Redis cleanup | per-session audit completion | stronger semantic / audit gate | 需要把 `environment_offline` 与 `audit_close_granted` 分开 | `bridgeMain.ts:1561-1577` |

## 3. 最短判断公式

判断某句“现在已经可以归档关闭”的说法有没有越级，先问四句：

1. 当前关闭的是 active surface、environment projection，还是更深层语义
2. 系统是否仍保留 resume honesty / retry possibility
3. 当前 close reason 是 archive、expiry、fatal，还是只是一次局部失败
4. 是否拿到了比 liability release 更强的 archive close gate

## 4. 最常见的五类误读

| 误读 | 实际问题 |
| --- | --- |
| “责任已经释放，所以应立刻 archive” | release 不等于 active-surface close |
| “archive 了，所以对象已经彻底结束” | archive 不是 audit close |
| “进程退出了，所以环境一定该下线” | resumable shutdown 明确反例 |
| “reconnect 失败了，所以就归档吧” | transient failure 反而要保留 retry truth |
| “web UI 不再显示，所以控制面无需追踪了” | off-screen 不等于 deeper closure |

## 5. 一条硬结论

真正成熟的 close grammar 不是：

`release -> archive`

而是：

`liability_released、archive_close_allowed、environment_offline、audit_close_granted`

分别由不同 gate、不同 operational truth、不同 authority 签字。
