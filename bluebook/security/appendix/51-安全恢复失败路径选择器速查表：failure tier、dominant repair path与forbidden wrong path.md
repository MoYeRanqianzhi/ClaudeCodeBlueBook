# 安全恢复失败路径选择器速查表：failure tier、dominant repair path与forbidden wrong path

## 1. 这一页服务于什么

这一页服务于 [67-安全恢复失败路径选择器：为什么failure ladder必须直接决定下一步repair path，而不是让用户自己猜](../67-%E5%AE%89%E5%85%A8%E6%81%A2%E5%A4%8D%E5%A4%B1%E8%B4%A5%E8%B7%AF%E5%BE%84%E9%80%89%E6%8B%A9%E5%99%A8%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88failure%20ladder%E5%BF%85%E9%A1%BB%E7%9B%B4%E6%8E%A5%E5%86%B3%E5%AE%9A%E4%B8%8B%E4%B8%80%E6%AD%A5repair%20path%EF%BC%8C%E8%80%8C%E4%B8%8D%E6%98%AF%E8%AE%A9%E7%94%A8%E6%88%B7%E8%87%AA%E5%B7%B1%E7%8C%9C.md)。

如果 `67` 的长文解释的是：

`为什么 failure tier 必须直接绑定下一步动作，`

那么这一页只做一件事：

`把 failure tier、dominant repair path 与 forbidden wrong path 压成一张路径选择器矩阵。`

## 2. 失败路径选择器矩阵

| failure tier | dominant repair path | forbidden wrong path | 为什么不能走错 | 关键证据 |
| --- | --- | --- | --- | --- |
| hidden | no action | 把它当 failed 去反复修复 | 这不是坏掉，而是当前无需继续前景展示 | `useTasksV2.ts:154-170` |
| pending | wait / observe automatic path | 立刻人工乱修、抢先重置对象 | 自动路径仍在推进，抢先人工介入会破坏系统收敛 | `useManageMCPConnections.ts:389-441,1112-1123` |
| reconnecting | wait for automatic recovery | 直接放弃对象、误判为终局失败 | 当前 repair path 就是系统主动重连或取 fresh token | `bridge/replBridge.ts:939-965,1064-1071` |
| auth_failed / needs-auth | authenticate via `/mcp`、OAuth URL、`/login` | generic reconnect、继续信旧资格、把对象直接判死 | 根因是资格失效，不是对象本体终局损坏 | `McpAuthTool.ts:86-107,115-205`、`bridgeMain.ts:198-275` |
| failed | manual repair path：`/mcp`、`/status`、重试命令、人工确认 | 一直等待自动恢复、误当 pending/reconnecting | 自动预算已耗尽，继续等只会延误修复 | `useManageMCPConnections.ts:434-441,466` |
| stale / expired | rebuild fresh anchor：`/remote-control` reconnect、重建 pointer / fresh object | 继续信旧对象、generic retry without rebuild | 旧对象仍存在，但已不配代表当前现实 | `bridge/replBridge.ts:2293-2298`、`bridgePointer.ts:22-34,56-70` |

## 3. 最短判断公式

看到任一 failure tier 时，先问四句：

1. 当前最短修复路径是等待、认证、人工修，还是重建 fresh anchor
2. 这个 tier 最大的错误动作是什么
3. 如果按 generic failed 去处理，会不会丢掉更短的修复链
4. 当前状态是在告诉用户“修什么”，还是“先别修”

## 4. 最常见的四类路径选择错误

| 路径选择错误 | 会造成什么问题 |
| --- | --- |
| 把 pending 当成 failed | 提前打断自动恢复链 |
| 把 auth_failed 当成 reconnect | 用户反复重连却始终缺资格 |
| 把 stale 当成 generic retry | 继续信旧对象而不是重建 fresh anchor |
| 把 hidden 当成要修 | 无意义修复动作污染控制面 |

## 5. 一条硬结论

对 Claude Code 这类安全控制面来说，  
最危险的不是 failure state 多一点，  
而是：

`系统已经知道失败层级不同，却仍让用户在多个 repair path 里盲猜。`
