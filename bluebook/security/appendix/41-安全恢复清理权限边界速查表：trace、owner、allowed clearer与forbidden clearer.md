# 安全恢复清理权限边界速查表：trace、owner、allowed clearer与forbidden clearer

## 1. 这一页服务于什么

这一页服务于 [57-安全恢复清理权限边界：为什么不是任何层都能删除恢复痕迹，必须由对应闭环所有者清理](../57-%E5%AE%89%E5%85%A8%E6%81%A2%E5%A4%8D%E6%B8%85%E7%90%86%E6%9D%83%E9%99%90%E8%BE%B9%E7%95%8C%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%E4%B8%8D%E6%98%AF%E4%BB%BB%E4%BD%95%E5%B1%82%E9%83%BD%E8%83%BD%E5%88%A0%E9%99%A4%E6%81%A2%E5%A4%8D%E7%97%95%E8%BF%B9%EF%BC%8C%E5%BF%85%E9%A1%BB%E7%94%B1%E5%AF%B9%E5%BA%94%E9%97%AD%E7%8E%AF%E6%89%80%E6%9C%89%E8%80%85%E6%B8%85%E7%90%86.md)。

如果 `57` 的长文解释的是：

`为什么恢复痕迹必须由与其闭环强度相匹配的所有者清理，`

那么这一页只做一件事：

`把 trace、owner、allowed clearer 与 forbidden clearer 压成一张可直接用于评审的矩阵。`

## 2. 清理权限边界矩阵

| trace 对象 | owner | allowed clearer | forbidden clearer | 关键证据 |
| --- | --- | --- | --- | --- |
| notification key / toast | 通知系统 | timeout、`invalidates`、`removeNotification(key)` | 低层通知系统越权清高层恢复状态对象 | `notifications.tsx:78-116,193-212` |
| `plugins.needsRefresh` | plugin refresh 闭环 | `refreshActivePlugins()` 真正重建插件事实后置 `false` | 任意 UI 提示消失、局部 auto-refresh 尝试、无 verifier 的路径 | `refresh.ts:123-138`、`useManagePlugins.ts:301-302` |
| auto-refresh 失败后的挂起态 | plugin 域高层挂起态 | 后续显式 repair path（`/reload-plugins`）或同阶成功闭环 | auto-refresh 失败自身顺手清理 | `PluginInstallationManager.ts:146-177` |
| MCP reconnect timer | MCP transport 恢复状态机 | 成功收敛、最终失败、显式手动 reconnect/enable/disable 前取消 | 任意 unrelated success signal | `useManageMCPConnections.ts:387-442,1055-1064,1086-1122` |
| MCP `pending/reconnectAttempt/maxReconnectAttempts` | MCP transport 域 | transport 状态机推进到 connected / failed / disabled | 普通通知层、跨域状态页摘要 | `useManageMCPConnections.ts:387-460` |
| bridge pointer / resume anchor | bridge resume 闭环 | archive+deregister、stale pointer、fatal reconnect failure | transient reconnect failure、普通 UI 成功提示 | `bridgeMain.ts:1520-1577,2385-2403,2524-2533,2700-2728` |
| 高层盲区/解释层痕迹 | explanation signer / 人工确认闭环 | 对应 signer 到位或人工明确确认 | 低层 transport/state success、通知层 cleanup、普通 repair action 完成 | `49`-`57` 主线归纳 |

## 3. 最短判断公式

评审任一恢复痕迹是否可被删除时，先问四句：

1. 这个痕迹的 owner 是谁
2. 当前试图清它的层级是不是与 owner 同阶或更高
3. 当前清理动作是否伴随了对应 verifier / signer
4. 如果这次清理是错的，系统会不会失去再次进入恢复链的能力

## 4. 最常见的四类越权清理错误

| 越权清理错误 | 会造成什么问题 |
| --- | --- |
| 用通知层 remove 清理高层挂起态 | 提示没了，事实还没恢复 |
| 用局部成功 signal 清理 `needsRefresh` | 用户以为 plugin stale 已解决 |
| 用 transient reconnect 结果清理 bridge pointer | 用户失去 resume 锚点 |
| 用 transport/state 层成功清理高层解释痕迹 | 低层恢复被误说成解释链恢复 |

## 5. 一条硬结论

对 Claude Code 这类安全控制面来说，  
最危险的不是痕迹太多，  
而是：

`本该由高层闭环所有者清理的恢复痕迹，被更低层的成功信号越权删除。`
