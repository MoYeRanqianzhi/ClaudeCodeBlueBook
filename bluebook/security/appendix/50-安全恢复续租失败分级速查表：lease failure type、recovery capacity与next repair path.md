# 安全恢复续租失败分级速查表：lease failure type、recovery capacity与next repair path

## 1. 这一页服务于什么

这一页服务于 [66-安全恢复续租失败分级：为什么不同lease failure必须分别降到hidden、pending、reconnecting、failed与stale，而不能一律算挂了](../66-%E5%AE%89%E5%85%A8%E6%81%A2%E5%A4%8D%E7%BB%AD%E7%A7%9F%E5%A4%B1%E8%B4%A5%E5%88%86%E7%BA%A7%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%E4%B8%8D%E5%90%8Clease%20failure%E5%BF%85%E9%A1%BB%E5%88%86%E5%88%AB%E9%99%8D%E5%88%B0hidden%E3%80%81pending%E3%80%81reconnecting%E3%80%81failed%E4%B8%8Estale%EF%BC%8C%E8%80%8C%E4%B8%8D%E8%83%BD%E4%B8%80%E5%BE%8B%E7%AE%97%E6%8C%82%E4%BA%86.md)。

如果 `66` 的长文解释的是：

`为什么不同 lease failure 必须分层表达剩余恢复能力，`

那么这一页只做一件事：

`把 lease failure type、recovery capacity 与 next repair path 压成一张失败梯子矩阵。`

## 2. 续租失败分级矩阵

| lease failure type | 典型状态 | recovery capacity | next repair path | 为什么不能压成 generic failed | 关键证据 |
| --- | --- | --- | --- | --- | --- |
| 无需继续展示 | `hidden` | 不需要修复，只是退到非前景 | 无，保持隐藏即可 | 这不是坏掉，而是已无继续展示必要 | `useTasksV2.ts:154-170` |
| 等待中 / 过渡中 | `pending` | 自动或预设路径仍在 | 等待自动重连 / 等待初始化 / 等待 readback | 当前还没恢复完成，但也远未到终局失败 | `useIdeConnectionStatus.ts:4-32`、`useManageMCPConnections.ts:389-391,823,935,1112-1117` |
| 主动重连中 | `reconnecting` | 自动恢复路径正在运行 | 等待 reconnect 完成或升级到更强失败词 | 这是“正在修复”，不是“已修不回来了” | `bridgeStatusUtil.ts:135-140`、`bridge/replBridge.ts:939-947,1066-1071,2239-2244,2345-2348` |
| 资格/令牌失效 | `auth_failed` | 需刷新资格后仍可能恢复 | token refresh、re-dispatch、重新认证 | 根因是资格过期，不等于对象本体终局损坏 | `bridgeMain.ts:198-275` |
| 自动预算耗尽 | `failed` | 需人工或更高层 repair path 介入 | `/mcp`、`/status`、重试命令、人工确认 | 这是自动路径失败后的更终局层级，强于 pending/reconnecting | `useManageMCPConnections.ts:434-441,466` |
| 时间语义过期 | `stale` | 对象仍在，但不再配代表当前现实 | 清理旧对象、重新建立 fresh anchor / pointer | 对象存在不等于仍可作为当前真相使用 | `bridgePointer.ts:22-34,56-70` |

## 3. 最短判断公式

看到一个 failure state 时，先问四句：

1. 当前失败后还剩下多少自动恢复能力
2. 当前失败是资格问题、时间问题、过渡问题，还是终局问题
3. 下一步该走等待、重连、重新认证还是人工 repair path
4. 如果把它压成 generic failed，会不会丢掉正确的下一步动作

## 4. 最常见的四类 failure 压扁错误

| 压扁错误 | 会造成什么问题 |
| --- | --- |
| 把 `pending` / `reconnecting` 说成 failed | 提前放弃仍可自动恢复的路径 |
| 把 `auth_failed` 说成 generic failed | 用户被带去错误修复路径，忽略资格刷新 |
| 把 `stale` 说成 failed | 对象过期被误读成对象损坏 |
| 把 `hidden` 说成 failed | 非失败型退场被误写成错误 |

## 5. 一条硬结论

对 Claude Code 这类安全控制面来说，  
最危险的不是 failure 状态多一点，  
而是：

`系统把剩余恢复能力完全不同的 lease failure 压成了同一个 failed。`
