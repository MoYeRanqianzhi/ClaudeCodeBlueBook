# 安全授权连续性速查表：context、continuity owner、allowed substitution与boundary failure

## 1. 这一页服务于什么

这一页服务于 [83-安全授权连续性：为什么session、token、transport与scope真正需要被保护的不是值，而是其背后的授权连续性](../83-%E5%AE%89%E5%85%A8%E6%8E%88%E6%9D%83%E8%BF%9E%E7%BB%AD%E6%80%A7%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88session%E3%80%81token%E3%80%81transport%E4%B8%8Escope%E7%9C%9F%E6%AD%A3%E9%9C%80%E8%A6%81%E8%A2%AB%E4%BF%9D%E6%8A%A4%E7%9A%84%E4%B8%8D%E6%98%AF%E5%80%BC%EF%BC%8C%E8%80%8C%E6%98%AF%E5%85%B6%E8%83%8C%E5%90%8E%E7%9A%84%E6%8E%88%E6%9D%83%E8%BF%9E%E7%BB%AD%E6%80%A7.md)。

如果 `83` 的长文解释的是：

`为什么控制面真正保护的是 authorization continuity，`

那么这一页只做一件事：

`把不同 context 到底由谁持有连续性、允许什么替换、何时必须显式换届，以及一旦错替换会形成什么边界故障压成一张 continuity 矩阵。`

## 2. 授权连续性矩阵

| context | continuity owner | same-boundary requirement | allowed substitution | explicit break signal | boundary failure | 关键证据 |
| --- | --- | --- | --- | --- | --- | --- |
| bridge session identity | current bridge session | `currentSessionId` 在 in-place reconnect 成功时保持不变，并继续承接原 URL / 原历史 | 仅在原环境不可续接时，先 archive old session，再创建 new session | env changed / reconnect failed / archive old session | 把新边界误说成原边界，或把旧边界继续当当前边界 | `replBridge.ts:391-418,588-604,729-744` |
| token semantics | creator-bound `getAccessToken` closure | 调用必须延续创建该 session 时那套 token 语义 | 不允许在外部独立重推导同名 token 获取路径 | handle teardown / new creator-bound handle | staging/prod token divergence | `replBridgeHandle.ts:5-13` |
| control callback transport binding | current transport + current session closure | 控制请求继续沿当前 transport/session 对发送 | 不应把 transport/session 交给 callback 链后续节点重建 | transport replaced under new closure | 控制动作发到错误通道或错误 session | `replBridge.ts:1190-1200` |
| bridge pointer | pointer writer aligned with current reconnect path | pointer 必须只指向当前边界对象 | 非原子换届窗口里禁止独立 timer 覆写 | reconnect completes and writes new pointer | pointer 落回 archived old session，形成 boundary revival | `replBridge.ts:1512-1524` |
| session title | display layer | 只需表达会话列表可读性，不承担授权连续性 | 允许按 prompt 次数和 slug 再派生 | 用户重命名 / 新 prompt 触发再派生 | 最多是展示变化，不是边界漂移 | `initReplBridge.ts:247-257` |
| `/status` / IDE notification summary | summary / routing surface | 只需提示当前摘要与下一跳入口 | 允许按连接统计或错误态重新汇总 | 新轮 status build / new notification emission | 最多造成摘要偏差，不直接改写 authority object | `status.tsx:95-114`、`useIDEStatusIndicator.tsx:119-123,147-150` |

## 3. 最短判断公式

看到一个 context 时，先问五句：

1. 它保护的是显示效果，还是授权连续性
2. 当前 continuity owner 到底是谁
3. 这个 context 如果被替换，是否还算同一边界
4. 如果不再是同一边界，系统是否显式发出了 break signal
5. 一旦错替换，最先坏掉的是 UI 命名，还是边界对象本身

## 4. 最常见的五类连续性误判

| 误判 | 会造成什么问题 |
| --- | --- |
| 把 session identity 当普通字符串 | 把换届误当续接 |
| 把 token 语义当可自由重建参数 | credential continuity 漂移 |
| 把 callback transport 当可后传后算 | 控制动作脱离原授权通道 |
| 把 pointer 写回 race 当普通脏写 | archived boundary revival |
| 把 title / summary surface 和 authority object 混为一谈 | 摘要层越权冒充真实边界 |

## 5. 一条硬结论

对 Claude Code 这类安全控制面来说，  
真正的高价值保护对象不是：

`某个值当前长什么样，`

而是：

`这条值链条是否仍然在延续同一个被授权的边界对象。`
