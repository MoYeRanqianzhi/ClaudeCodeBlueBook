# 安全恢复清理门槛速查表：trace、minimum clearer、threshold evidence与auto-clear许可

## 1. 这一页服务于什么

这一页服务于 [58-安全恢复清理门槛：为什么即便清理者正确，也必须等到对应闭环证据足够强才允许删除痕迹](../58-%E5%AE%89%E5%85%A8%E6%81%A2%E5%A4%8D%E6%B8%85%E7%90%86%E9%97%A8%E6%A7%9B%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%E5%8D%B3%E4%BE%BF%E6%B8%85%E7%90%86%E8%80%85%E6%AD%A3%E7%A1%AE%EF%BC%8C%E4%B9%9F%E5%BF%85%E9%A1%BB%E7%AD%89%E5%88%B0%E5%AF%B9%E5%BA%94%E9%97%AD%E7%8E%AF%E8%AF%81%E6%8D%AE%E8%B6%B3%E5%A4%9F%E5%BC%BA%E6%89%8D%E5%85%81%E8%AE%B8%E5%88%A0%E9%99%A4%E7%97%95%E8%BF%B9.md)。

如果 `58` 的长文解释的是：

`为什么 owner 正确也不等于现在就能删，`

那么这一页只做一件事：

`把 trace、minimum clearer、threshold evidence 与 auto-clear 许可压成一张门槛矩阵。`

## 2. 清理门槛矩阵

| trace | owner | minimum clearer | threshold evidence | auto-clear allowed? | manual confirmation required? | forbidden early clear | 关键证据 |
| --- | --- | --- | --- | --- | --- | --- | --- |
| notification key / toast | 通知系统 | timeout、`invalidates`、`removeNotification(key)` | 提示超时、被后继提示明确取代、或显式移除 | 允许，但只限提示层 | 否 | 把提示消失误说成恢复完成 | `notifications.tsx:78-116,176-212` |
| `plugins.needsRefresh`（新 marketplace 安装后的 auto-refresh） | plugin refresh 闭环 | `refreshActivePlugins()` | full rebuild 完成：cache 清理、plugin reload、commands/agents 回写、`pluginReconnectKey` bump | 允许 | 失败时转人工 | reload 刚开始、局部组件已更新、提示消失 | `refresh.ts:81-138`、`PluginInstallationManager.ts:135-165` |
| `plugins.needsRefresh`（updates only） | plugin refresh 闭环 | 用户显式 `/reload-plugins` | 用户触发的完整 refresh 闭环真正完成 | 不允许 | 是 | background reconcile、普通 notice 出现/消失、局部 auto path | `PluginInstallationManager.ts:166-177`、`useManagePlugins.ts:287-303` |
| MCP `pending/reconnectAttempt/maxReconnectAttempts` 与 reconnect timer | MCP transport 状态机 | transport 域自动重连结束，或手工 reconnect / enable / disable 接管 | reconnect 成功收敛、达到上限最终失败、或显式域内控制动作接管 | 允许，但只在 transport 域内且必须走到收敛/终止点 | 某些场景需要 | 单次重试失败、无关 success signal、普通通知消失 | `useManageMCPConnections.ts:363-460,1055-1122` |
| bridge pointer / resume anchor | bridge resume 闭环 | archive+deregister、stale pointer、fatal reconnect failure | 已正常终结、已确认 stale、或已确认 fatal；transient / resumable window 不算 | 不允许在 transient/resumable 窗口 auto-clear | 是 | SIGINT 可恢复退出、transient reconnect failure、表层 connected/disconnected 变化 | `bridgeMain.ts:1515-1577,2384-2403,2524-2533,2700-2728` |
| 高层解释层 trace / host blindspot 痕迹 | explanation signer / 人工确认闭环 | 对应更高层 signer 或人工确认 | read/write/effect/explanation 四层替代证据齐备，或人工明确确认闭环 | 通常不允许 | 是 | transport connected、局部 UI 转绿、低层 repair action 已触发 | `49`-`58` 主线归纳 |

## 3. 最短判断公式

面对任一恢复痕迹，先问五句：

1. 它的 owner 是谁
2. 当前 clearer 是否至少达到 minimum clearer
3. 当前拿到的是过程信号，还是 threshold evidence
4. 这次清理是否仍处在 retry / resume / manual-confirmation window 内
5. 如果现在删掉，系统会不会失去再次进入恢复链的能力

## 4. 最常见的四类门槛误判

| 门槛误判 | 会造成什么问题 |
| --- | --- |
| 把 timeout / notice disappear 当成恢复完成 | 提示没了，但恢复链还没闭环 |
| 把 reload 已启动当成 `needsRefresh` 可清 | plugin 事实尚未全量重建 |
| 把某次 reconnect 尝试结果当成 retry chain 已结束 | transport 还处在可继续恢复窗口 |
| 把 transient failure 或表层在线信号当成 pointer 可清 | 用户失去 resume 锚点与重试入口 |

## 5. 一条硬结论

对 Claude Code 这类安全控制面来说，  
最危险的不是 trace 留得久一点，  
而是：

`在仍有恢复价值时，owner 因为“眼前已经够用”就提前清掉 trace。`
