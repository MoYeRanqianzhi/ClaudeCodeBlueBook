# 安全恢复资格清理权限速查表：carrier、clearer、clear trigger与forbidden premature clear

## 1. 这一页服务于什么

这一页服务于 [90-安全恢复资格清理权限：为什么pointer清理权不是普通清扫动作，而是恢复资格的撤回权](../90-%E5%AE%89%E5%85%A8%E6%81%A2%E5%A4%8D%E8%B5%84%E6%A0%BC%E6%B8%85%E7%90%86%E6%9D%83%E9%99%90%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88pointer%E6%B8%85%E7%90%86%E6%9D%83%E4%B8%8D%E6%98%AF%E6%99%AE%E9%80%9A%E6%B8%85%E6%89%AB%E5%8A%A8%E4%BD%9C%EF%BC%8C%E8%80%8C%E6%98%AF%E6%81%A2%E5%A4%8D%E8%B5%84%E6%A0%BC%E7%9A%84%E6%92%A4%E5%9B%9E%E6%9D%83.md)。

如果 `90` 的长文解释的是：

`为什么恢复资格的清理权属于撤回权，`

那么这一页只做一件事：

`把不同恢复 carrier 到底由谁清、凭什么清、哪些场景禁止提前清理压成一张清理权限矩阵。`

## 2. 恢复资格清理权限矩阵

| carrier | clearer | clear trigger | why this layer owns clearing | forbidden premature clear | 关键证据 |
| --- | --- | --- | --- | --- | --- |
| stale / invalid pointer file | pointer reader | schema invalid / TTL stale | 这是 carrier-level 硬失效，reader 自己就掌握真相 | 不配处理更高层 transient / fatal / suspend 语义 | `bridgePointer.ts:76-113,186-202` |
| leftover pointer on fresh start | bridgeMain startup control flow | 本次不是 resume flow，旧 pointer 代表上次 crash 残留 | 主流程知道当前将走 fresh path，不应让 stale env linger | 不该在 resumable flow 中顺手清掉真正要恢复的 pointer | `bridgeMain.ts:2316-2326` |
| resumePointerDir for dead session | session existence verifier | `!session` | verifier 首次确认对象级死亡 | 不能在 candidate 阶段就假定对象已死 | `bridgeMain.ts:2384-2398` |
| resumePointerDir for non-attachable object | env-binding verifier | `!environment_id` | verifier 首次确认该对象不属于桥接恢复对象族 | 不能把对象存在误清成对象死亡 | `bridgeMain.ts:2400-2404` |
| pointer on transient reconnect failure | nobody yet；明确保留 | transient failure | failure semantics owner 知道仍需保留 retry mechanism | 不能因为“这次失败了”就提前清掉 | `bridgeMain.ts:2524-2530` |
| pointer on fatal reconnect failure | failure semantics owner | fatal reconnect failure | 只有它知道 promise 应被正式撤回 | 不能继续保留 dead boundary 的 retry carrier | `bridgeMain.ts:2527-2534` |
| pointer on resumable shutdown | nobody；显式禁止清理 | single-session + initialSessionId + !fatalExit | shutdown control flow 已确认应保留恢复资格 | 不能 archive+deregister 后再打印 resume hint | `bridgeMain.ts:1515-1538` |
| pointer on non-perpetual clean exit | full teardown owner | archive + deregister 完成 | 它掌握 lifecycle-level 退役真相 | 不能在 suspend/perpetual 路径清掉 | `replBridge.ts:1618-1663` |
| pointer on REPL perpetual teardown | nobody；刷新而非清理 | perpetual suspend | suspend 不等于 retire，carrier 应继续保留 | 不能把 suspend 当 clean retirement 清掉 | `replBridge.ts:1595-1615` |

## 3. 最短判断公式

看到一次清 pointer 动作时，先问五句：

1. 它清的是 carrier-level 失效，还是对象级 / 生命周期级资格
2. 当前 clearer 掌握的真相层级够不够
3. 这次清理是在 revoke，还是只是在 housekeeping
4. 当前是不是 suspend / retryable，本应禁止提前清理
5. 如果现在清掉，是否会错误撤回仍真实存在的恢复资格

## 4. 最常见的五类越权清理

| 越权清理 | 会造成什么问题 |
| --- | --- |
| reader 层替 verifier 层清理对象级失效 | 载体真相和对象真相混淆 |
| retryable failure 提前清 pointer | 把 retry path 错撤为 dead boundary |
| suspend 路径清 pointer | 把挂起对象误说成退役对象 |
| shutdown hint 已发布却继续 archive+deregister | promise issuance 与 revocation 自相矛盾 |
| fresh start 不清旧 pointer | stale env 与旧恢复资格继续 linger |

## 5. 一条硬结论

对 Claude Code 这类安全控制面来说，  
真正成熟的不是：

`什么时候顺手把旧 pointer 清掉，`

而是：

`系统明确知道这次清理是在撤回哪一级恢复资格，并且只有掌握该级真相的层才配执行。`
