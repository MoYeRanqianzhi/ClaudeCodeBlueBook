# 安全恢复错误路径禁令速查表：failure tier、forbidden adjacent path、block reason与release condition

## 1. 这一页服务于什么

这一页服务于 [68-安全恢复错误路径禁令：为什么控制面必须主动禁止邻近wrong path，而不只是提示dominant repair path](../68-%E5%AE%89%E5%85%A8%E6%81%A2%E5%A4%8D%E9%94%99%E8%AF%AF%E8%B7%AF%E5%BE%84%E7%A6%81%E4%BB%A4%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%E6%8E%A7%E5%88%B6%E9%9D%A2%E5%BF%85%E9%A1%BB%E4%B8%BB%E5%8A%A8%E7%A6%81%E6%AD%A2%E9%82%BB%E8%BF%91wrong%20path%EF%BC%8C%E8%80%8C%E4%B8%8D%E5%8F%AA%E6%98%AF%E6%8F%90%E7%A4%BAdominant%20repair%20path.md)。

如果 `68` 的长文解释的是：

`为什么控制面必须主动排除邻近 wrong path，`

那么这一页只做一件事：

`把不同 failure tier 的 forbidden adjacent path、block reason 与 release condition 压成一张禁令矩阵。`

## 2. 错误路径禁令矩阵

| failure tier | dominant repair path | forbidden adjacent path | block reason | release condition | 关键证据 |
| --- | --- | --- | --- | --- | --- |
| hidden | no action | 把隐藏态重新升级成 failed、重开修复动作 | 这是前景退出，不是待修事故 | 新的不完整任务或更强新证据重新进入前景 | `useTasksV2.ts:154-170` |
| pending | wait / observe automatic path | 抢先人工 reset、提前判 failed、切走人工入口 | 自动恢复预算仍在推进，系统仍拥有当前修复权 | 自动恢复成功，或 retry budget exhausted 后转 `failed` | `useManageMCPConnections.ts:387-441,1112-1123` |
| reconnecting | wait for automatic recovery / fresh token | 立刻整重建、直接宣判 terminal failed、强行人工接管 | 系统正在执行更高层自动恢复，过早接管会破坏更短路径 | 自动重连成功，或 env reconnect 失败后正式落成 `failed` | `replBridge.ts:938-965,1065-1071` |
| auth_failed / needs-auth | authenticate via `/mcp`、OAuth URL、`/login` | generic reconnect、继续信旧 token、把对象直接判死 | 根因属于资格域而不是 transport 域，原因域与修复域不能错配 | 完成认证、拿到 fresh token 或 fresh entitlement 后再恢复后续路径 | `McpAuthTool.ts:86-107,115-205`、`bridgeMain.ts:198-275`、`useManageMCPConnections.ts:596-603` |
| failed | manual repair path | 继续无限等待、假装仍是 `pending`、把“等”当默认动作 | 自动恢复预算已耗尽，被动等待已不再合法 | 人工修复成功并经过对应 authoritative readback / signer 关环 | `useManageMCPConnections.ts:417-441` |
| stale / expired | rebuild fresh anchor：`/remote-control` reconnect、重建 pointer / fresh session | 继续信旧 pointer、对旧 session 做 generic retry、围着旧锚点打转 | 旧对象可能仍存在，但已失去代表现实的资格 | 新 session / 新 pointer 建立完成，旧锚点退出控制链 | `replBridge.ts:2293-2298`、`bridgePointer.ts:22-34,56-60` |

## 3. 最短判断公式

看到任一 failure tier 时，先问四句：

1. 当前 dominant repair path 归系统、用户，还是资格域所有
2. 当前最容易被误选的 adjacent wrong path 是什么
3. 如果用户现在误走这条 wrong path，会破坏什么剩余恢复能力
4. 这条禁令何时解除，系统要靠什么条件正式放行

## 4. 最常见的六类错误路径误选

| 错误路径误选 | 会造成什么问题 |
| --- | --- |
| 把 `hidden` 当 incident 去修 | 无意义制造修复噪音，污染控制面 |
| 把 `pending` 当 failed 去抢修 | 破坏自动恢复的预算窗口 |
| 把 `reconnecting` 当 terminal failed | 提前打断更短的自动闭环 |
| 把 `auth_failed` 当 generic reconnect | 用错误原因域动作掩盖真实资格失效 |
| 把 `failed` 当“再等等” | 延长停机时间，推迟人工接管 |
| 把 `stale / expired` 当普通 retry | 继续信旧锚点，无法真正回到 fresh reality |

## 5. 一条硬结论

对 Claude Code 这类恢复控制面来说，  
真正成熟的不是“告诉用户应该去哪”，  
而是：

`在每个失败层级上，系统都知道哪些邻近路径现在绝对不能走，以及何时才会解除禁令。`
