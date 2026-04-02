# 安全资格中间态速查表：state、meaning、allowed promise与next action

## 1. 这一页服务于什么

这一页服务于 [96-安全资格中间态语法：为什么needsRefresh、pending、retryable与fresh-session-fallback不能压成同一句正在恢复](../96-%E5%AE%89%E5%85%A8%E8%B5%84%E6%A0%BC%E4%B8%AD%E9%97%B4%E6%80%81%E8%AF%AD%E6%B3%95%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88needsRefresh%E3%80%81pending%E3%80%81retryable%E4%B8%8Efresh-session-fallback%E4%B8%8D%E8%83%BD%E5%8E%8B%E6%88%90%E5%90%8C%E4%B8%80%E5%8F%A5%E6%AD%A3%E5%9C%A8%E6%81%A2%E5%A4%8D.md)。

如果 `96` 的长文解释的是：

`为什么不同资格中间态必须保持不同语义，`

那么这一页只做一件事：

`把不同 state 的 meaning、允许承诺与下一步动作压成一张状态语法表。`

## 2. 安全资格中间态矩阵

| state | meaning | allowed promise | next action | forbidden flattening | 关键证据 |
| --- | --- | --- | --- | --- | --- |
| `terminal-invalid` | 旧资格已无继续路径 | 只能说已失效 / 不可恢复 | 结束当前路径，必要时提示 `/login` 或新建 | 说成“再等等可能恢复” | `bridgeMain.ts:2384-2408` |
| `retryable resumable` | 当前尝试失败，但旧资格仍有 retry value | 只能说 may still be resumable | 再次运行同一路径重试 | 说成“已彻底失效”或“已恢复” | `bridgeMain.ts:2524-2539` |
| `fresh-session-fallback` | 旧资格结束，新资格将被签发 | 只能说 creating a fresh session instead | 转入 fresh session path | 说成“原 session 已恢复” | `bridgeMain.ts:2473-2489` |
| `needsRefresh` | 变化已发生，但 active entitlement 未重签发 | 只能说 changed, run `/reload-plugins` to activate | 用户执行 `/reload-plugins` | 说成“插件已激活” | `useManagePlugins.ts:287-303`; `refresh.ts:123-138` |
| `pending` | 已准入重签发流程，但尚未连接完成 | 只能说等待连接 / 发布 | 进入 connect / publish | 说成“已经可用”或“已被禁用” | `useManageMCPConnections.ts:817-839,856-900` |
| `disabled` | 当前策略不允许进入重签发 | 只能说 disabled | 先解除禁用，再入 pending | 说成“只是还没连上” | `useManageMCPConnections.ts:821-823` |

## 3. 最短判断公式

看到一个非-current 状态时，先问五句：

1. 这是真终局、可重试、回退重签发，还是等待连接
2. 当前最多允许系统说多满的话
3. 它的下一步是用户动作还是系统动作
4. 它有没有资格继续保留旧资格的叙事
5. 当前界面是不是把它压平了

## 4. 最常见的五类状态压平错误

| 压平方式 | 会造成什么问题 |
| --- | --- |
| 把 `terminal-invalid` 与 `retryable` 混成同一失败 | 用户失去正确恢复预期 |
| 把 `fresh-session-fallback` 说成 resume 成功 | 新资格冒充旧资格 |
| 把 `needsRefresh` 说成已激活 | 用户误以为能力已生效 |
| 把 `pending` 说成 disabled | 误导用户修改不必要配置 |
| 把 `disabled` 说成 pending | 让用户错误等待系统自动恢复 |

## 5. 一条硬结论

对 Claude Code 这类安全控制面来说，  
真正成熟的不是：

`有很多状态名，`

而是：

`每个中间态都绑定准确意义、准确承诺上限与准确下一步。`
