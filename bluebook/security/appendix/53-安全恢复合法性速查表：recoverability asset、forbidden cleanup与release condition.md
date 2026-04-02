# 安全恢复合法性速查表：recoverability asset、forbidden cleanup与release condition

## 1. 这一页服务于什么

这一页服务于 [69-安全恢复合法性：为什么只要剩余可恢复性仍在，系统就必须禁止destructive cleanup](../69-%E5%AE%89%E5%85%A8%E6%81%A2%E5%A4%8D%E5%90%88%E6%B3%95%E6%80%A7%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%E5%8F%AA%E8%A6%81%E5%89%A9%E4%BD%99%E5%8F%AF%E6%81%A2%E5%A4%8D%E6%80%A7%E4%BB%8D%E5%9C%A8%EF%BC%8C%E7%B3%BB%E7%BB%9F%E5%B0%B1%E5%BF%85%E9%A1%BB%E7%A6%81%E6%AD%A2destructive%20cleanup.md)。

如果 `69` 的长文解释的是：

`为什么 cleanup 不是默认合法动作，`

那么这一页只做一件事：

`把 recoverability asset、forbidden cleanup 与 release condition 压成一张合法性矩阵。`

## 2. 恢复合法性矩阵

| recoverability asset | carrier object | forbidden destructive cleanup | 为什么当前仍受保护 | release condition | 关键证据 |
| --- | --- | --- | --- | --- | --- |
| resume 价值 | single-session bridge 的 session + environment + pointer | `archiveSession`、`deregisterEnvironment`、`clearBridgePointer` | 仍可 `--continue`，清理会让恢复命令变成谎言 | `fatalExit` 或正式 fall through 到 archive+deregister 路径 | `bridgeMain.ts:1515-1537,1573-1577` |
| retry 价值 | resume reconnect 失败后的 existing environment + pointer | transient failure 后 `deregisterEnvironment`、清 pointer | 本次尝试失败不等于 future retry 失效，pointer 本身就是 retry mechanism | reconnect 被判为 `fatal`，或 session 在服务端已确实不存在 | `bridgeMain.ts:2384-2398,2524-2540` |
| 已恢复对象的生存权 | REPL poll loop 刚恢复的 work/session/transport | 继续 stop/archive/rebuild | poll loop 已恢复，后续 cleanup 会把刚恢复的对象再杀一次 | 只有在恢复未发生且更高层路径也失败时，fresh rebuild 才重新合法 | `replBridge.ts:653-672,718-727` |
| crash 后二次恢复价值 | perpetual teardown 下保留的 env/session/pointer | 向服务端发送完成、`stopWork`、关 transport、清 pointer | 系统在主动保留 next-launch reconnect 能力，而不是宣告会话终局 | 用户显式 clean exit，或后续真实 teardown 完成 | `replBridge.ts:1595-1615,1660-1663` |
| 待消费插件恢复信号 | `needsRefresh` | auto-refresh、提前 reset `needsRefresh` | 这是尚未被合法消费的恢复权，不是脏位 | `/reload-plugins` 通过 `refreshActivePlugins()` 正式消费它 | `useManagePlugins.ts:32-35,287-303` |
| 手工应用插件更新的选择权 | updated marketplace 后的 plugin state | 把 updated silently auto-apply 或 refresh 失败后静默抹平 | updates 需要显式 apply 时机，失败后也必须回退到 `needsRefresh` | 用户运行 `/reload-plugins`，或 fresh install auto-refresh 真正确认成功 | `PluginInstallationManager.ts:135-164,166-178` |
| fresh config 一致性 | stale MCP client 的 timer / onclose / old config closure | 让 old timer / old closure 继续活着，或在错误对象上先清后连 | 错序 cleanup 会让 old config 重新抢写，制造伪恢复 | 三类 hazard 被拆除后，fresh connection 接管 | `useManageMCPConnections.ts:782-808` |
| fresh credential 路径 | keychain cache + server cache + fresh connect path | 沿用旧 keychain cache 直接 reconnect | stale credential 会让 subprocess 永远意识不到 token 已被移除 | `clearKeychainCache()` 与 `clearServerCache()` 完成后再 `connectToServer()` | `useManageMCPConnections.ts:1093-1100`、`client.ts:2147-2155` |

## 3. 最短判断公式

看到任一 cleanup 动作时，先问四句：

1. 当前被清理的对象承载的是垃圾，还是 recoverability asset
2. 如果现在清掉它，会不会连 future retry / resume 一起删掉
3. 当前 release condition 是不是已经被 authoritative 证据满足
4. 如果 cleanup 失败或过早发生，系统会不会退化成更长的冷启动路径

## 4. 最常见的六类非法 cleanup

| 非法 cleanup | 会造成什么问题 |
| --- | --- |
| resumable session 上先 `archive + deregister` | 直接销毁 `--continue` 路径 |
| transient reconnect failure 后清 pointer | 把“下次再试”机制自己删掉 |
| poll loop 已恢复后仍继续 rebuild | 把刚恢复的 session 再次摧毁 |
| perpetual teardown 还向服务端宣告终局 | 把本可恢复的 work 伪装成已完成 |
| 直接 reset `needsRefresh` | 把尚未消费的恢复信号静默抹掉 |
| 沿用旧 keychain / old closure 重连 | 制造伪恢复、长期卡在 stale state |

## 5. 一条硬结论

对 Claude Code 这类恢复控制面来说，  
真正高级的不是“什么时候能清理”，  
而是：

`什么时候必须克制自己，不去清理仍承载恢复能力的对象。`
