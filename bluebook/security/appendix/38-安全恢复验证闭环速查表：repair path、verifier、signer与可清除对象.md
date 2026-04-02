# 安全恢复验证闭环速查表：repair path、verifier、signer与可清除对象

## 1. 这一页服务于什么

这一页服务于 [54-安全恢复验证闭环：为什么用户执行修复命令不等于状态已恢复，必须由对应回读与signer关环](../54-%E5%AE%89%E5%85%A8%E6%81%A2%E5%A4%8D%E9%AA%8C%E8%AF%81%E9%97%AD%E7%8E%AF%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%E7%94%A8%E6%88%B7%E6%89%A7%E8%A1%8C%E4%BF%AE%E5%A4%8D%E5%91%BD%E4%BB%A4%E4%B8%8D%E7%AD%89%E4%BA%8E%E7%8A%B6%E6%80%81%E5%B7%B2%E6%81%A2%E5%A4%8D%EF%BC%8C%E5%BF%85%E9%A1%BB%E7%94%B1%E5%AF%B9%E5%BA%94%E5%9B%9E%E8%AF%BB%E4%B8%8Esigner%E5%85%B3%E7%8E%AF.md)。

如果 `54` 的长文解释的是：

`为什么 repair action 只能产生修复意图，而真正恢复必须等待 verifier readback 与 signer 关环，`

那么这一页只做一件事：

`把 repair path、verifier、signer 与可清除对象压成一张可直接用于评审和交互实现的矩阵。`

## 2. 恢复验证闭环矩阵

| repair path | verifier readback | 最终 signer | 可清除对象 | 禁止的假闭环 | 关键证据 |
| --- | --- | --- | --- | --- | --- |
| `/reload-plugins` | cache 清空、plugin state 重建、`needsRefresh=false`、`pluginReconnectKey` bump | plugin state + 下游 reconnect 收敛后的状态 signer | plugin activation pending、部分 plugin stale 提示 | 只因用户执行了 `/reload-plugins` 就清告警 | `refresh.ts:60-138` |
| MCP reconnect / `/mcp` 内重连 | `clearKeychainCache()`、`clearServerCache()`、`connectToServer()`、重新拿到 tools/commands/resources | `client.type=connected` 加能力重新可见 | MCP failed / needs-auth 等连接域告警 | 只因点过 reconnect 或打开 `/mcp` 就当已恢复 | `mcp/client.ts:2137-2199` |
| `/login` | credential refresh 之后重新评估 gate；必要时 restart 或 `/status` 复核 | auth gate / capability re-evaluation signer | not logged in、channels auth bottleneck 等认证告警 | 把 `/login` 本身当成 auth 已恢复的充分证据 | `ChannelsNotice.tsx:73`、`PromptInput/Notifications.tsx:306-309`、`teleport.tsx:441` |
| `/remote-control` / bridge reconnect | session 重新被 `bridge/reconnect` 接纳并 re-queue；必要时允许重试 | bridge state 恢复 + 后续 session signer | bridge reconnect / attach 类告警 | 只因发起 reconnect 就说 remote control 已恢复 | `bridgeMain.ts:2499-2539` |
| restore + hydrate 路径 | restore 与 hydrate 都落在 restored state 上，而不是 fresh default | restore signer | stale residue、部分“状态已接回”类提示 | 只因旧状态能看到了就说当前 fresh | `print.ts:5048-5058`、`ccrClient.ts:474-522` |
| turn completion 路径 | authoritative `session_state_changed(idle)` | state signer | 部分阶段性 running / requires_action 提示 | 只因局部队列空了就说 turn over | `sdkEventQueue.ts:56-66` |
| persistence closure 路径 | `files_persisted` 到达 | effect signer | 持久化待确认类告警 | 只因 result 已出就说 all changes applied | `print.ts:2261-2267` |

## 3. 最短闭环公式

评审任一修复流程时，先问四句：

1. repair path 改变的到底是哪一条链
2. 这条链的 verifier 是哪一个具体 readback
3. verifier 之后还要等哪一个 signer 才能正式清告警
4. 如果把 repair action 直接当成闭环，最先会误导哪一步

## 4. 最常见的四类假闭环错误

| 假闭环错误 | 会造成什么问题 |
| --- | --- |
| 把 `/reload-plugins` 当成 plugin 已恢复 | 用户看不到 stale data / reconnect 尚未收敛 |
| 把 MCP reconnect 尝试当成 server 已连回 | 用户看不到 client 仍可能是 failed / needs-auth |
| 把 `/login` 当成 auth gate 已通过 | 用户忽略 restart / `/status` 复核 / org gate 重评 |
| 把 result 已出当成修复已完成 | 用户看不到 `files_persisted` 和 authoritative idle 仍未到 |

## 5. 一条硬结论

对 Claude Code 这类安全控制面来说，  
最危险的不是 repair path 太多，  
而是：

`控制面明明已经知道应该等待哪个 verifier 和 signer，却仍然在用户执行完命令的那一刻就提前宣布闭环。`
