# 安全资格重签发协议速查表：artifact、revocation trigger、regrant path与forbidden shortcut

## 1. 这一页服务于什么

这一页服务于 [95-安全资格重签发协议：为什么失效对象不能靠残留工件直接回到current，而必须先回到pending、reload或fresh-session路径](../95-%E5%AE%89%E5%85%A8%E8%B5%84%E6%A0%BC%E9%87%8D%E7%AD%BE%E5%8F%91%E5%8D%8F%E8%AE%AE%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%E5%A4%B1%E6%95%88%E5%AF%B9%E8%B1%A1%E4%B8%8D%E8%83%BD%E9%9D%A0%E6%AE%8B%E7%95%99%E5%B7%A5%E4%BB%B6%E7%9B%B4%E6%8E%A5%E5%9B%9E%E5%88%B0current%EF%BC%8C%E8%80%8C%E5%BF%85%E9%A1%BB%E5%85%88%E5%9B%9E%E5%88%B0pending%E3%80%81reload%E6%88%96fresh-session%E8%B7%AF%E5%BE%84.md)。

如果 `95` 的长文解释的是：

`为什么失效资格只能走 regrant，而不能靠残留工件直接复活，`

那么这一页只做一件事：

`把不同子系统里的撤销触发器、重签发路径与禁止捷径压成一张协议矩阵。`

## 2. 安全资格重签发协议矩阵

| artifact / entitlement | revocation trigger | allowed continuation | required regrant path | intermediate state | forbidden shortcut | 关键证据 |
| --- | --- | --- | --- | --- | --- | --- |
| bridge session on same env | 连续性未断 | `reconnect in place` | 无需重签发 | same-session continuation | 把仍连续对象强制 fresh start | `replBridge.ts:729-735` |
| bridge session on changed env | env mismatch / old env expired | 不允许 | fresh session / archive old / rewrite pointer | fresh-session fallback | 把新 env 说成旧 session 的继续 | `bridgeMain.ts:2473-2489`; `replBridge.ts:737-823` |
| retryable bridge resume | transient reconnect failure | 暂停 current，保留 retry value | 再次运行同一路径重试 | retryable, still resumable | 一次瞬时失败就 clear pointer | `bridgeMain.ts:2524-2539` |
| plugin active capability set | disk changed / `needsRefresh=true` | 不允许直接 current | `/reload-plugins` -> full Layer-3 refresh | `needsRefresh` | 文件已落盘就宣布已激活 | `useManagePlugins.ts:287-303`; `refresh.ts:59-138` |
| plugin-derived MCP/LSP/agents | reload 前旧派生结果已不可信 | 不允许部分复用 | clear caches -> reload -> republish | reload in progress | 只刷新一部分派生物就说完成 | `refresh.ts:75-145` |
| stale MCP client | config removed / config hash changed | 不允许继续 current | stale cleanup -> `pending` -> connect | `pending` | 复用旧 connected client 继续发 tools | `useManageMCPConnections.ts:782-839,856-900` |
| disabled MCP server | policy disabled | 只能停在 disabled | 重新启用后再入 pending/connect | `disabled` / `pending` | disabled 状态下偷偷继续连 | `useManageMCPConnections.ts:817-825,889-893` |

## 3. 最短判断公式

看到一个“想回来”的对象时，先问五句：

1. 它原来的资格到底有没有被正式撤销或打断
2. 现在还能合法续接，还是已经必须重签发
3. 它的中间态是什么
4. 它的 regrant path 是不是完整且唯一
5. 当前系统是不是在偷偷走 resurrection shortcut

## 4. 最常见的五类重签发错误

| 错误方式 | 会造成什么问题 |
| --- | --- |
| env 换了还假装 old session 续上 | 新边界冒充旧边界 |
| plugin 文件改了就自动算已激活 | 半签发能力进入 current |
| MCP config 漂移后沿用旧 client | ghost tools 与旧配置竞争 current |
| transient failure 立刻销毁 retry asset | 合法重试路径被过早抹掉 |
| 没有中间态就直接 current | revocation 失去真实性 |

## 5. 一条硬结论

对 Claude Code 这类安全控制面来说，  
真正成熟的不是：

`让失效对象自己回来，`

而是：

`让失效对象先退出 current，再通过明确的 regrant path 重新申请进入。`
