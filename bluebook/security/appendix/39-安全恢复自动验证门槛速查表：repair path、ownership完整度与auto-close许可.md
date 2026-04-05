# 安全恢复自动验证门槛速查表：repair path、ownership完整度与auto-close许可

## 1. 这一页服务于什么

这一页服务于 [55-安全恢复自动验证门槛：哪些闭环可以自动撤警，哪些必须停留人工确认](../55-%E5%AE%89%E5%85%A8%E6%81%A2%E5%A4%8D%E8%87%AA%E5%8A%A8%E9%AA%8C%E8%AF%81%E9%97%A8%E6%A7%9B%EF%BC%9A%E5%93%AA%E4%BA%9B%E9%97%AD%E7%8E%AF%E5%8F%AF%E4%BB%A5%E8%87%AA%E5%8A%A8%E6%92%A4%E8%AD%A6%EF%BC%8C%E5%93%AA%E4%BA%9B%E5%BF%85%E9%A1%BB%E5%81%9C%E7%95%99%E4%BA%BA%E5%B7%A5%E7%A1%AE%E8%AE%A4.md)。

如果 `55` 的长文解释的是：

`为什么只有在 action/verifier/signer 三权都在系统手里时才配 auto-close，`

那么这一页只做一件事：

`把 repair path、ownership 完整度、auto-close 许可与人工确认门槛压成一张可直接用于评审的矩阵。`

## 2. 自动验证门槛矩阵

| repair path | action ownership | verification ownership | signer ownership | auto-close 许可 | 何时必须转人工确认 | 关键证据 |
| --- | --- | --- | --- | --- | --- | --- |
| 新 marketplace 安装后的 plugin auto-refresh | 系统拥有 | 系统拥有 | 系统拥有到足以更新 plugin 状态 | 允许 | auto-refresh 失败时降级到 `needsRefresh` / `/reload-plugins` | `PluginInstallationManager.ts:136-165`、`refresh.ts:60-138` |
| plugin updates only | 系统不完全拥有；显式要求用户决定何时应用 | 系统可部分读回，但历史上存在 stale-cache bug | signer 不足以自动清高层告警 | 不允许 | 进入 `/reload-plugins` 人工确认态 | `PluginInstallationManager.ts:166-177`、`useManagePlugins.ts:288-303` |
| remote MCP transport automatic reconnection | 系统拥有 | 系统拥有（重连 + 读回 client/capabilities） | 系统拥有 transport / state 层 signer | 允许 | 达到重试上限、状态仍非 connected 时转人工或失败态 | `useManageMCPConnections.ts:354-464`、`mcp/client.ts:2137-2199` |
| `/login` 后认证恢复 | 用户触发；系统不拥有外部认证全过程 | 需要 restart 或 `/status` 复核，系统不完全拥有 | auth / capability signer 不在单轮系统手里 | 不允许 | `/login` 后仍需 restart、/status、或外部条件确认 | `ChannelsNotice.tsx:73`、`teleport.tsx:441` |
| bridge reconnect transient retry | 系统可尝试，但最终是否成功未必由系统单轮掌控 | 需看 re-queue 是否成功，失败时保留 pointer 等下次人工重试 | signer 不稳定，尤其 transient 失败场景 | 有条件；仅对系统确认成功的子路径 | 进入 `try running the same command again` 人工确认态 | `bridgeMain.ts:2499-2539` |
| restore + hydrate | 系统拥有 | 系统拥有 | restore signer 仅够恢复部分状态，不够恢复全部解释权 | 部分允许 | 若后续 fresh state / explanation signer 未到，不得 auto-clear 高层告警 | `print.ts:5048-5058`、`ccrClient.ts:474-522` |
| authoritative idle / files_persisted | 系统拥有 | 系统拥有 | state / effect signer 拥有 | 允许关闭对应层级告警 | 当更高层 explanation signer 未到时，仍不得关闭最高层盲区告警 | `sdkEventQueue.ts:56-66`、`print.ts:2261-2267` |

## 3. 最短门槛公式

评审任一 repair path 是否可 auto-close 时，先问四句：

1. 动作是不是系统自己发起和持有
2. verifier readback 是不是系统自己能稳定拿到
3. signer 是不是系统自己能解释到当前要关闭的对象层级
4. 如果其中任一项不在系统手里，是否应显式停在人工确认态

## 4. 最常见的四类自动化越权错误

| 越权错误 | 会造成什么问题 |
| --- | --- |
| 因为存在 repair command 就允许 auto-close | 系统把用户意图误当成新真相 |
| 在 verifier 不稳定时继续自动撤警 | transient / stale / partial state 被误读成恢复 |
| 在 signer 不足时清高层告警 | 低层 transport/state 恢复被误说成解释链恢复 |
| 不把 auto-close 失败显式转成人工确认 | 用户看不到系统已经退出主权范围 |

## 5. 一条硬结论

对 Claude Code 这类安全控制面来说，  
最危险的不是自动化做得不够多，  
而是：

`系统在并未同时拥有动作、读回和 signer 主权时，仍然越权自动关闭告警。`
