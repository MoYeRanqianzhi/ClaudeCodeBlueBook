# 安全上下文重推导禁令速查表：surface、re-derivable context、forbidden authority context与failure mode

## 1. 这一页服务于什么

这一页服务于 [82-安全上下文重推导禁令：为什么session、token、transport与scope不能像标题那样交给调用方二次重算](../82-%E5%AE%89%E5%85%A8%E4%B8%8A%E4%B8%8B%E6%96%87%E9%87%8D%E6%8E%A8%E5%AF%BC%E7%A6%81%E4%BB%A4%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88session%E3%80%81token%E3%80%81transport%E4%B8%8Escope%E4%B8%8D%E8%83%BD%E5%83%8F%E6%A0%87%E9%A2%98%E9%82%A3%E6%A0%B7%E4%BA%A4%E7%BB%99%E8%B0%83%E7%94%A8%E6%96%B9%E4%BA%8C%E6%AC%A1%E9%87%8D%E7%AE%97.md)。

如果 `82` 的长文解释的是：

`为什么必须区分可重推导上下文与不可重推导的授权上下文，`

那么这一页只做一件事：

`把不同 surface 上哪些上下文可以重算、哪些绝不能重算，以及误重算后的 failure mode 压成一张禁令矩阵。`

## 2. 上下文重推导禁令矩阵

| surface | re-derivable context | forbidden authority context | 为什么不能交给调用方重算 | failure mode | 关键证据 |
| --- | --- | --- | --- | --- | --- |
| bridge session title | title、slug、prompt-derived label | `sessionId`、token、transport | title 只是 cosmetic only，授权边界不在这里 | 若误把 authority context 也当可重算，会把边界信息和展示信息混同 | `initReplBridge.ts:247-257` |
| `ReplBridgeHandle` methods | 几乎不暴露可重算关键上下文 | `currentSessionId`、`transport`、`doTeardownImpl` | 这些都属于 creator-bound capability 的执行上下文 | 请求发错实例、结果落错 session、teardown 错对象 | `replBridge.ts:1779-1834` |
| global `replBridgeHandle` pointer | 兼容 session id 格式转换可派生 | 创建 session 的 `sessionId` 与 `getAccessToken` 语义 | 独立重推导会带来 token divergence | staging/prod token divergence、错上下文调用 | `replBridgeHandle.ts:5-27` |
| bridge reconnect path | 局部 cosmetic/telemetry 可重算 | `currentSessionId` 连续性、pointer 当前值 | session continuity 是控制对象连续性，不是普通派生值 | 旧 session 被错误复活或继续被写入 | `replBridge.ts:390-418,593-604,729-740,1512-1524` |
| server control callback wiring | 局部 handler 组合可变 | `transport` 与 `currentSessionId` | callback 自己线程化重建关键上下文会提升漂移风险 | 错 session / 错 transport 执行控制请求 | `replBridge.ts:1191-1200` |
| notifications 当前模型 | 大量业务逻辑仍在调用方重建 family/owner/scope | family scope、owner、allowed operators | 当前仍处于 pre-handle 阶段，调用方被迫自己拼授权上下文 | 边界压力外溢到调用方，易产生误删误废止 | `notifications.tsx:6-23,31-40,193-213`、`AppStateStore.ts:222-225,532-535` |

## 3. 最短判断公式

看到一个上下文值时，先问四句：

1. 它只是展示派生值，还是授权连续性的一部分
2. 如果让调用方重算，是否会改变“代表谁、对谁说话、在哪个边界里行动”
3. 当前是否已有 creator-bound closure 在替调用方保存它
4. 一旦重算错，最先受损的是 UI 表达、调用路由，还是授权连续性

## 4. 最常见的五类误重推导

| 误重推导 | 会造成什么问题 |
| --- | --- |
| 把 authority context 当 cosmetic value | 把边界信息误当展示信息 |
| callback 自己重建 session/transport | 错上下文执行控制动作 |
| reconnect 窗口里重复写 pointer | 旧边界对象复活 |
| 在 React 树外独立重建 token 语义 | token divergence |
| 在 notifications 外部自己拼 family/owner/scope | 状态主权边界变脆 |

## 5. 一条硬结论

对 Claude Code 这类安全控制面来说，  
真正该被禁的不是“再次计算”这件事本身，  
而是：

`对承载授权连续性的上下文再次计算。`
