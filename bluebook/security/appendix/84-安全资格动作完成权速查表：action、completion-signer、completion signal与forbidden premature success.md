# 安全资格动作完成权速查表：action、completion-signer、completion signal与forbidden premature success

## 1. 这一页服务于什么

这一页服务于 [100-安全资格动作完成权：为什么走上正确修复路径不等于资格已恢复，必须由对应completion-signer宣布完成](../100-%E5%AE%89%E5%85%A8%E8%B5%84%E6%A0%BC%E5%8A%A8%E4%BD%9C%E5%AE%8C%E6%88%90%E6%9D%83%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%E8%B5%B0%E4%B8%8A%E6%AD%A3%E7%A1%AE%E4%BF%AE%E5%A4%8D%E8%B7%AF%E5%BE%84%E4%B8%8D%E7%AD%89%E4%BA%8E%E8%B5%84%E6%A0%BC%E5%B7%B2%E6%81%A2%E5%A4%8D%EF%BC%8C%E5%BF%85%E9%A1%BB%E7%94%B1%E5%AF%B9%E5%BA%94completion-signer%E5%AE%A3%E5%B8%83%E5%AE%8C%E6%88%90.md)。

如果 `100` 的长文解释的是：

`为什么正确路径的完成只能由正确 signer 宣布，`

那么这一页只做一件事：

`把不同 action 的 completion-signer、completion signal 与提前成功禁令压成一张完成矩阵。`

## 2. 安全资格动作完成权矩阵

| action | completion-signer | completion signal | forbidden premature success | 关键证据 |
| --- | --- | --- | --- | --- |
| bridge initial reconnect / attach | current transport after flush gate | `onStateChange('connected')` only after flush/gate conditions | socket 刚连上就宣布 active | `replBridge.ts:1234-1240,1306-1328` |
| `/reload-plugins` | `refreshActivePlugins()` full Layer-3 swap | `needsRefresh=false` + `pluginReconnectKey+1` | slash command 发起即算完成 | `refresh.ts:59-71,123-138` |
| MCP reconnect | `result.client.type === 'connected'` | `onComplete("Successfully reconnected ...")` | reconnect 调用返回就算成功 | `MCPReconnect.tsx:40-62` |
| MCP auth gap | `needs-auth` result branch | `requires authentication. Use /mcp to authenticate.` | needs-auth 也说 reconnect success | `MCPReconnect.tsx:48-53` |
| retryable bridge resume | old entitlement still retryable | 保留 pointer + retry message | transient failure 后清理资产并宣布结束 | `bridgeMain.ts:2524-2539` |

## 3. 最短判断公式

看到一个“已完成”宣告时，先问五句：

1. 谁是这个动作的 completion-signer
2. 当前信号是否足够强到能撤销中间态
3. 它清掉了哪些待修复标记
4. 它是不是只是动作发起，而非动作完成
5. 当前系统有没有提前宣布 success

## 4. 最常见的五类提前成功错误

| 错误方式 | 会造成什么问题 |
| --- | --- |
| transport 刚连上就说 connected | 历史未持久化时误报 active |
| `/reload-plugins` 发起即清 `needsRefresh` | 半刷新伪装成 full refresh |
| MCP reconnect 返回就说成功 | `needs-auth/pending/failed` 被误说成恢复完成 |
| transient bridge failure 时清 pointer | retryable 路径被伪装成终局 |
| 弱投影层先撤提示 | completion 真相被局部层越权宣布 |

## 5. 一条硬结论

对 Claude Code 这类安全控制面来说，  
真正成熟的不是：

`把动作做完看起来差不多，`

而是：

`只让拥有最终真相的 signer 来宣布动作真的完成。`
