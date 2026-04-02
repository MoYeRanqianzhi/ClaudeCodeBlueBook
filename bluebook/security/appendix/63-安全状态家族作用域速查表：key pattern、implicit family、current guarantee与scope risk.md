# 安全状态家族作用域速查表：key pattern、implicit family、current guarantee与scope risk

## 1. 这一页服务于什么

这一页服务于 [79-安全状态家族作用域：为什么全局key字符串不是长期安全边界，family scope才是状态编辑主权的真正载体](../79-%E5%AE%89%E5%85%A8%E7%8A%B6%E6%80%81%E5%AE%B6%E6%97%8F%E4%BD%9C%E7%94%A8%E5%9F%9F%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%E5%85%A8%E5%B1%80key%E5%AD%97%E7%AC%A6%E4%B8%B2%E4%B8%8D%E6%98%AF%E9%95%BF%E6%9C%9F%E5%AE%89%E5%85%A8%E8%BE%B9%E7%95%8C%EF%BC%8Cfamily%20scope%E6%89%8D%E6%98%AF%E7%8A%B6%E6%80%81%E7%BC%96%E8%BE%91%E4%B8%BB%E6%9D%83%E7%9A%84%E7%9C%9F%E6%AD%A3%E8%BD%BD%E4%BD%93.md)。

如果 `79` 的长文解释的是：

`为什么真正的状态主权载体应该是 family scope，而不是裸 key，`

那么这一页只做一件事：

`把不同 key pattern、implicit family、current guarantee 与 scope risk 压成一张作用域矩阵。`

## 2. 状态家族作用域矩阵

| key pattern | implicit family | 当前靠什么维持作用域 | current guarantee | scope risk | 关键证据 |
| --- | --- | --- | --- | --- | --- |
| `fast-mode-*` | fast mode 状态家族 | 本地常量 + 同一 hook 持有 | 冷却、组织变化、拒绝态大体留在同一家族中 | family 尚未接口化，仍是全局 key 命名约定 | `useFastModeNotification.tsx:8-11,101-121` |
| `ide-status-*` | IDE 状态家族 | 前缀命名 + 同一 hook family editor | disconnected、install error、JetBrains-specific 状态家族边界清楚 | family 仍未显式进入 notifications 协议 | `useIDEStatusIndicator.tsx:88-149` |
| `teammate-*` | teammate lifecycle 家族 | 前缀命名 + 同一 lifecycle hook | spawn/shutdown 聚合语义稳定地留在本家族内 | outsider 仍可从全局 key 层面碰它 | `useTeammateShutdownNotification.ts:24-45` |
| `mcp-*` / `mcp-claudeai-*` | MCP 连接状态家族 | 前缀命名 + 同一 MCP connectivity hook | failed / needs-auth / claude.ai 特例大体在一个家族里治理 | claude.ai 子家族与 generic MCP 仍主要靠命名区分 | `useMcpConnectivityStatus.tsx:36-63` |
| `external-editor-*` | external editor 家族 | 同一 PromptInput / Notifications 子系统 | hint 与 error 各自稳定复用自己的槽位 | 家族关系未显式声明，仍靠命名与文件位置理解 | `Notifications.tsx:150-162`、`PromptInput.tsx:1328-1349` |
| `settings-errors` 这类单点常量 key | 单成员状态家族 | 本地常量 + owner 自管 | 单个状态 owner 清晰 | 只有名字，没有正式 family metadata | `useSettingsErrors.tsx:8-14,37-48` |
| 所有通知 key | 隐式全局命名空间 | `key` equality、Set 去重、全局 remove | 同 key 被视作同一身份槽位 | 作用域全靠命名 discipline，不是显式 family scope | `notifications.tsx:45-76,121-185,193-213` |

## 3. 最短判断公式

看到一个 notification key 时，先问四句：

1. 它属于哪个状态家族
2. 这个家族现在是靠前缀、常量，还是靠正式 scope 维持
3. 当前 notifications API 能否识别这个 family，还是只会全局按 key 比较
4. 如果 key 前缀失控或跨家族撞名，会先破坏哪条主权边界

## 4. 最常见的五类作用域错误

| 作用域错误 | 会造成什么问题 |
| --- | --- |
| 把 key 名当成边界本身 | 实际仍是全局命名空间 |
| family 只在文案前缀里存在 | 工具和接口无法验证主权 |
| 子家族关系不显式声明 | 相似前缀容易被误当成同一作用域 |
| 同一 key 复用但缺 family 说明 | 维护者难判断这是共享槽位还是误撞名 |
| 继续把 remove / fold / invalidate 做全局解析 | family 主权只能靠团队习惯维持 |

## 5. 一条硬结论

对 Claude Code 这类安全控制面来说，  
真正的长期边界不该只是：

`这个 key 叫什么，`

而应当是：

`这个 key 属于哪个被正式承认的状态家族。`
