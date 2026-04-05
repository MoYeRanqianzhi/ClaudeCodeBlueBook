# 安全能力闭包绑定速查表：handle、captured context、forbidden re-derivation与security gain

## 1. 这一页服务于什么

这一页服务于 [81-安全能力闭包绑定：为什么句柄真正承载的不是方法集合，而是创建时上下文](../81-%E5%AE%89%E5%85%A8%E8%83%BD%E5%8A%9B%E9%97%AD%E5%8C%85%E7%BB%91%E5%AE%9A%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%E5%8F%A5%E6%9F%84%E7%9C%9F%E6%AD%A3%E6%89%BF%E8%BD%BD%E7%9A%84%E4%B8%8D%E6%98%AF%E6%96%B9%E6%B3%95%E9%9B%86%E5%90%88%EF%BC%8C%E8%80%8C%E6%98%AF%E5%88%9B%E5%BB%BA%E6%97%B6%E4%B8%8A%E4%B8%8B%E6%96%87.md)。

如果 `81` 的长文解释的是：

`为什么 handle 的真正安全价值在 creator-bound closure，`

那么这一页只做一件事：

`把不同 handle、其 captured context、禁止重推导对象与安全收益压成一张闭包绑定矩阵。`

## 2. 闭包绑定矩阵

| handle / surface | captured context | forbidden re-derivation | security gain | 关键证据 |
| --- | --- | --- | --- | --- |
| `ReplBridgeHandle` | `currentSessionId`、`transport`、`doTeardownImpl` | 让调用方自己拼 session id、transport、teardown 路径 | 保证控制请求、结果发送与 teardown 都落在正确实例上下文里 | `replBridge.ts:70-80,1779-1834` |
| global `replBridgeHandle` pointer | 创建 session 的 `sessionId` 与 `getAccessToken` 语义 | 在 React 树外独立重建 access token / session 上下文 | 避免 token divergence 与错误上下文调用 | `replBridgeHandle.ts:5-27` |
| `permissionCallbacks` built around `handle_0` | `handle_0` + `pendingPermissionHandlers` map | 外部自行维护 request/response 账本和取消关系 | 把 request-response 配对与删除责任留在正确局部上下文 | `useReplBridge.tsx:369-380,538-586` |
| `BridgeDebugHandle` | 当前 bridge debug surface 的受限操作集 | 暴露整套 bridge 内部状态和任意调试入口 | debug 仍服从最小能力面，而不是全量敞开 | `bridgeDebug.ts:38-52` |
| notifications 当前模型 | 仅有 `key: string`，几乎没有 captured scope | 调用方自己重建 family、owner、allowed operator | 当前仍处于 pre-handle 阶段，容易把边界压力推给调用方 | `notifications.tsx:6-23,31-40,193-213`、`AppStateStore.ts:222-225,532-535` |

## 3. 最短判断公式

看到一个 handle 或接口时，先问四句：

1. 它到底捕获了哪些创建时上下文
2. 调用方还有哪些东西需要自己重新推导
3. 如果这些东西由调用方重推导，最危险的偏差会是什么
4. 把这些上下文绑定进 handle 后，首先消除的是哪类越权或错上下文风险

## 4. 最常见的五类闭包绑定失败

| 失败模式 | 会造成什么问题 |
| --- | --- |
| 只暴露名字，不暴露上下文 | 调用方被迫自己拼边界 |
| 句柄不携带生命周期 | teardown / cleanup 容易落到错误实例 |
| request-response 账本不与句柄绑定 | 回调配对关系容易泄漏或错配 |
| debug surface 直接暴露内部状态 | 调试接口越过最小能力面 |
| 已有 handle 经验却不迁移到其他高风险子系统 | 同仓库内安全成熟度长期失衡 |

## 5. 一条硬结论

对 Claude Code 这类安全控制面来说，  
真正成熟的 handle 不只是：

`我能调用几个方法，`

而是：

`这些方法已经替我把正确上下文一起带来了。`
