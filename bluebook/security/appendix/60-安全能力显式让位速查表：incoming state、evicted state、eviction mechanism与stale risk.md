# 安全能力显式让位速查表：incoming state、evicted state、eviction mechanism与stale risk

## 1. 这一页服务于什么

这一页服务于 [76-安全能力显式让位：为什么更高风险、更具体的新状态必须主动驱逐旧的弱状态，而不能等它自然过期](../76-%E5%AE%89%E5%85%A8%E8%83%BD%E5%8A%9B%E6%98%BE%E5%BC%8F%E8%AE%A9%E4%BD%8D%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%E6%9B%B4%E9%AB%98%E9%A3%8E%E9%99%A9%E3%80%81%E6%9B%B4%E5%85%B7%E4%BD%93%E7%9A%84%E6%96%B0%E7%8A%B6%E6%80%81%E5%BF%85%E9%A1%BB%E4%B8%BB%E5%8A%A8%E9%A9%B1%E9%80%90%E6%97%A7%E7%9A%84%E5%BC%B1%E7%8A%B6%E6%80%81%EF%BC%8C%E8%80%8C%E4%B8%8D%E8%83%BD%E7%AD%89%E5%AE%83%E8%87%AA%E7%84%B6%E8%BF%87%E6%9C%9F.md)。

如果 `76` 的长文解释的是：

`为什么互斥的新状态必须正式驱逐旧状态，`

那么这一页只做一件事：

`把不同 incoming state、evicted state、eviction mechanism 与 stale risk 压成一张显式让位矩阵。`

## 2. 显式让位矩阵

| incoming state | evicted state | eviction mechanism | 为什么新状态必须赢 | 若不驱逐会出现什么 stale risk | 关键证据 |
| --- | --- | --- | --- | --- | --- |
| 任意带 `invalidates` 的新通知 | queue 或 current 中被指名的旧通知 | `invalidates` + queue filter + current clear | 新语义已声明旧语义失效 | 旧提示稍后复活，形成语义回潮 | `notifications.tsx:6-14,78-117,172-191` |
| `priority: immediate` 新通知 | 当前展示中的低优先级旧通知 | 清 timeout、改写 `current`、过滤旧队列 | 高风险状态必须立刻进入前景 | 屏幕仍保留低风险旧叙述，误导当前动作 | `notifications.tsx:78-117` |
| `IDE extension install failed` | generic `ide-status-disconnected` | `removeNotification("ide-status-disconnected")` | 原因态比症状态更接近真实修复路径 | 用户只看到 disconnected，不知道真正问题是安装失败 | `useIDEStatusIndicator.tsx:78-152` |
| `IDE plugin not connected · /status for info` | generic `ide-status-disconnected` | `removeNotification("ide-status-disconnected")` | JetBrains 特定情形比 generic 断连更具体 | 用户会把特定插件缺失误读成普通连接抖动 | `useIDEStatusIndicator.tsx:83-123` |
| `Remote Control failed` immediate notification | footer 上潜在的 `active / connecting / reconnecting` 弱连续词 | 抢占 notification 前景 + footer 禁止承载 failed | 高风险否定词必须压过连续性弱词 | 用户会以为 bridge 仍可继续等，而不是已进入失败分支 | `useReplBridge.tsx:102-111`、`PromptInputFooter.tsx:173-189` |
| `fast-mode-cooldown-started` | `fast-mode-cooldown-expired` | `invalidates: [COOLDOWN_EXPIRED_KEY]` | started 与 expired 语义互斥 | 旧“已恢复”提示残留，误导当前模式判断 | `useFastModeNotification.tsx:101-112` |
| `fast-mode-cooldown-expired` | `fast-mode-cooldown-started` | `invalidates: [COOLDOWN_STARTED_KEY]` | expired 与 started 语义互斥 | 旧“冷却中”提示残留，误导当前动作和期望 | `useFastModeNotification.tsx:114-121` |

## 3. 最短判断公式

看到新状态到来时，先问四句：

1. 它和屏幕上的旧状态是不是互斥
2. 它是不是更高风险或更具体
3. 它有没有显式 eviction mechanism，而不只是更高优先级
4. 如果旧状态不退场，用户下一步动作会不会被路由错

## 4. 最常见的五类显式让位失败

| 失败模式 | 会造成什么问题 |
| --- | --- |
| 只抢占不失效 | 新提示消失后旧提示复活 |
| 只靠 timeout，不正式撤回 | 互斥真相在同一时间窗里共存 |
| 原因态不驱逐症状态 | 用户拿不到正确修复方向 |
| 高风险否定词不驱逐弱绿色词 | 假恢复、假连续性、假可用 |
| 让位关系靠人脑记忆维护 | 新增 surface 后很容易再次裂脑 |

## 5. 一条硬结论

对 Claude Code 这类安全控制面来说，  
真正危险的不是状态变化太快，  
而是：

`状态已经变了，但旧表述还留在屏幕上替过去作证。`
