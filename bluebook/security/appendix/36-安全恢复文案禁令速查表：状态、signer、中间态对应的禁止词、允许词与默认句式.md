# 安全恢复文案禁令速查表：状态、signer、中间态对应的禁止词、允许词与默认句式

## 1. 这一页服务于什么

这一页服务于 [52-安全恢复文案禁令：为什么系统必须禁止过满绿色词，并为半恢复状态提供受约束语言](../52-%E5%AE%89%E5%85%A8%E6%81%A2%E5%A4%8D%E6%96%87%E6%A1%88%E7%A6%81%E4%BB%A4%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%E7%B3%BB%E7%BB%9F%E5%BF%85%E9%A1%BB%E7%A6%81%E6%AD%A2%E8%BF%87%E6%BB%A1%E7%BB%BF%E8%89%B2%E8%AF%8D%EF%BC%8C%E5%B9%B6%E4%B8%BA%E5%8D%8A%E6%81%A2%E5%A4%8D%E7%8A%B6%E6%80%81%E6%8F%90%E4%BE%9B%E5%8F%97%E7%BA%A6%E6%9D%9F%E8%AF%AD%E8%A8%80.md)。

如果 `52` 的长文解释的是：

`为什么半恢复状态下必须禁止过满绿色词，并改用受约束语言，`

那么这一页只做一件事：

`把状态 / signer / 中间态对应的禁止词、允许词与默认句式压成一张可直接用于产品评审和文案校验的矩阵。`

## 2. 文案禁令矩阵

| 对象层级 / 状态 | 当前证据强度 | 禁止词 | 允许词 | 默认句式 | 关键证据 |
| --- | --- | --- | --- | --- | --- |
| L0 活性 signer | 仅活性、仅 write path 或仅低层连接词 | `active`、`connected`、`ready`、`fully` | `attached`、`reachable`、`write path ready` | `已恢复部分 + 当前缺口 + 默认下一步` | `bridgeStatusUtil.ts:123-140`、`replBridgeTransport.ts:289-299` |
| `mirror-only` | 仅 outbound / mirror 路径 | `Remote Control active`、`Fully connected` | `attached (mirror-only)`、`write-only attachment` | `Bridge attached; inbound control unavailable · open bridge details` | `replBridgeTransport.ts:142-147,336-345` |
| `write-ready / read-blind` | 写链恢复，读链未证成 | `Connected`、`Recovered`、`Interactive ready` | `write path ready`、`read path unproven` | `Write path ready; read path unproven · stay in bridge details` | `replBridgeTransport.ts:289-299` |
| L1 restore signer | 旧状态已接回，但并非 fresh | `Up to date`、`Fully restored`、`all clear` | `restored`、`state restored`、`awaiting fresh state` | `State restored; awaiting fresh sync · stay on status` | `ccrClient.ts:474-522`、`print.ts:5048-5058` |
| `restored-but-not-fresh` | restore + hydrate 已接轨，但 fresh 回读未到 | `Fresh`、`synced`、`fully recovered` | `restored`、`not yet fresh` | `Restored; awaiting fresh state · do not trust final completion yet` | `ccrClient.ts:474-522`、`print.ts:5048-5058` |
| L2 state signer | 会话阶段已更新到 `running / requires_action / idle` | 用 `idle` 说 `completed`、用 `running` 说 `healthy` | `idle`、`running`、`requires action` | `Session idle; follow-on effects may still be pending` | `sdkEventQueue.ts:56-66`、`print.ts:818` |
| `control-narrow` | 宿主在线但只支持窄 control 子集 | `Remote control ready`、`control restored`、`full host` | `permission-only`、`control-limited` | `Permission path available; broader control unsupported · use permission flow only` | `directConnectManager.ts:81-98`、`RemoteSessionManager.ts:192-213` |
| L3 effect signer | result 之后的副作用已部分签字 | 仅凭 `result` 或 `idle` 说 `completed` | `persisted`、`result delivered`、`persistence pending` | `Result delivered; persistence pending` 或 `Files persisted; explanation still limited` | `print.ts:2261-2267` |
| `result-ready / effects-pending` | result 已到、`files_persisted` 未到 | `Completed`、`All changes applied` | `result delivered`、`effects pending` | `Result delivered; persistence pending · wait for file confirmation` | `print.ts:2261-2267` |
| L4 explanation signer | 账本补齐、blindspot 缩小、ceiling 恢复 | 无；可使用最高层结论词 | `recovered`、`ready`、`completed`、`all clear` | `解释链完整；可恢复主结论与完整动作集` | `47`-`52` 主线归纳 |

## 3. 最短校验公式

审查任一恢复文案时，先问四句：

1. 这句话当前是在替通知、卡片、动作还是主结论发声
2. 它背后的 signer 是哪一层
3. 这句话里有没有超出当前 signer 强度的绿色词
4. 如果把它照原样显示，最先误导哪一步动作

## 4. 最常见的四类文案越权错误

| 文案越权错误 | 后果 |
| --- | --- |
| 在 `mirror-only` 上说 `active` | 用户把写链恢复误读成入站控制恢复 |
| 在 `restored-but-not-fresh` 上说 `up to date` | 用户把旧状态接回误读成 fresh state 已到 |
| 在 `idle` 上说 `completed` | 用户看不到副作用 signer 仍未到齐 |
| 在 `control-narrow` 上说 `ready` | 用户把窄 control 宿主误读成完整控制宿主 |

## 5. 一条硬结论

对 Claude Code 这类安全控制面来说，  
最危险的不是文案不够好看，  
而是：

`系统明明只拿到了低层或中层恢复证据，却仍然使用只有最高层解释 signer 才配说出的绿色词。`
