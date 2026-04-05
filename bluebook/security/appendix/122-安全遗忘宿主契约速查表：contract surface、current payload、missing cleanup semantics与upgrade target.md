# 安全遗忘宿主契约速查表：contract surface、current payload、missing cleanup semantics与upgrade target

## 1. 这一页服务于什么

这一页服务于 [138-安全遗忘宿主契约：为什么cleanup语义若不进入SDK和host contract，宿主永远只能靠文案与隐式状态猜测](../138-%E5%AE%89%E5%85%A8%E9%81%97%E5%BF%98%E5%AE%BF%E4%B8%BB%E5%A5%91%E7%BA%A6%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88cleanup%E8%AF%AD%E4%B9%89%E8%8B%A5%E4%B8%8D%E8%BF%9B%E5%85%A5SDK%E5%92%8Chost%20contract%EF%BC%8C%E5%AE%BF%E4%B8%BB%E6%B0%B8%E8%BF%9C%E5%8F%AA%E8%83%BD%E9%9D%A0%E6%96%87%E6%A1%88%E4%B8%8E%E9%9A%90%E5%BC%8F%E7%8A%B6%E6%80%81%E7%8C%9C%E6%B5%8B.md)。

如果 `138` 的长文解释的是：

`为什么 cleanup 语义最终必须进入 SDK / host contract，`

那么这一页只做一件事：

`把不同 contract surface 的 current payload、missing cleanup semantics 与 upgrade target 压成一张矩阵。`

## 2. 契约矩阵

| contract surface | current payload | missing cleanup semantics | upgrade target | 关键证据 |
| --- | --- | --- | --- | --- |
| `system:init` | `mcp_servers`、`plugins`、`permissionMode` 等运行时快照 | cleanup owner/reason/gate/replaced_by 全缺 | 初始化时就给宿主 cleanup baseline | `coreSchemas.ts:1457-1493` |
| `system:status` | structured status message | 缺 cleanup summary / deferred cleanup info | 让宿主按状态流收到 cleanup projection | `coreSchemas.ts:1533-1542` |
| `reload_plugins` response | commands/agents/plugins/mcpServers/error_count | 看不见 `needsRefresh` 是否被消费、为何可清 | 返回 cleanup consumption result | `controlSchemas.ts:405-432` |
| `mcp_status` response | `mcpServers` array | 不知道 pending/needs-auth 是否被 cleanup/replaced | 返回 connection cleanup semantics | `controlSchemas.ts:157-173` |
| `mcp_reconnect` / `mcp_toggle` | 只有 request schema | 动作后缺正式 cleanup outcome contract | 增加 reconnect/toggle cleanup result | `controlSchemas.ts:435-452` |
| `post_turn_summary` / `task_notification` | 已有结构化 status/summary | 说明“结构化语义能进 contract”，cleanup 仍缺席 | 参照其风格增加 cleanup event family | `coreSchemas.ts:1544-1569,1694-1712` |

## 3. 最短判断公式

判断某个 cleanup 语义是否已经真正进入宿主契约，先问四句：

1. 它是不是出现在正式 schema 里
2. 它是不是能被宿主结构化读取
3. 它是不是不再依赖文案和推断
4. 它有没有明确的 upgrade target 而不是停留在本地实现细节

## 4. 最常见的四类误读

| 误读 | 实际问题 |
| --- | --- |
| “CLI 内部已经知道，所以宿主也算知道” | 内部知识不等于 contract knowledge |
| “只要有 status 就够了” | status 不等于 cleanup provenance |
| “request 已经有了，response 可以不加” | 没有 outcome contract 宿主仍然只能猜 |
| “host 看到和 UI 一样的文案就行” | host 最需要的是结构化 cleanup 语义 |

## 5. 一条硬结论

Claude Code 若想把 cleanup 从内部经验变成生态能力，最关键的一步不是：

`再多写一点 UI 说明，`

而是：

`把 cleanup 语义正式带进 SDK / host contract。`

