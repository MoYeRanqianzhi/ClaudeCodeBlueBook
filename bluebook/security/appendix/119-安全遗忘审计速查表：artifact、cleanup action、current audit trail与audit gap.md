# 安全遗忘审计速查表：artifact、cleanup action、current audit trail与audit gap

## 1. 这一页服务于什么

这一页服务于 [135-安全遗忘审计：为什么Claude Code即使允许清理失败痕迹，也不应让清理变成无痕动作，而要留下谁清了、为何清、清后如何回查的线索](../135-%E5%AE%89%E5%85%A8%E9%81%97%E5%BF%98%E5%AE%A1%E8%AE%A1%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88Claude%20Code%E5%8D%B3%E4%BD%BF%E5%85%81%E8%AE%B8%E6%B8%85%E7%90%86%E5%A4%B1%E8%B4%A5%E7%97%95%E8%BF%B9%EF%BC%8C%E4%B9%9F%E4%B8%8D%E5%BA%94%E8%AE%A9%E6%B8%85%E7%90%86%E5%8F%98%E6%88%90%E6%97%A0%E7%97%95%E5%8A%A8%E4%BD%9C%EF%BC%8C%E8%80%8C%E8%A6%81%E7%95%99%E4%B8%8B%E8%B0%81%E6%B8%85%E4%BA%86%E3%80%81%E4%B8%BA%E4%BD%95%E6%B8%85%E3%80%81%E6%B8%85%E5%90%8E%E5%A6%82%E4%BD%95%E5%9B%9E%E6%9F%A5%E7%9A%84%E7%BA%BF%E7%B4%A2.md)。

如果 `135` 的长文解释的是：

`为什么合法清理也必须保留审计线索，`

那么这一页只做一件事：

`把主要 artifact 的 cleanup action、current audit trail 与当前 audit gap 压成一张矩阵。`

## 2. 遗忘审计矩阵

| artifact | cleanup action | current audit trail | audit gap | 关键证据 |
| --- | --- | --- | --- | --- |
| bridge shutdown / env cleanup | archive + deregister + clear pointer | `tengu_bridge_shutdown`、`bridge_shutdown` diagnostics、debug/verbose shutdown trace | 缺统一 `cleanup_reason`/`cleanup_owner` 字段 | `bridgeMain.ts:1407-1415,1543-1579` |
| stale resume pointer | clear stale pointer, then error out | explicit `console.error(...)` + pointer clear path | cleanup 本身缺结构化 audit id | `bridgeMain.ts:2384-2396,2400-2405` |
| fatal reconnect cleanup | fatal 时 clear pointer，transient 时保留 | clear/keep 规则写在 debug-path 注释与 fatal branch | clear vs keep decision 仍主要隐含在 code path | `bridgeMain.ts:2528-2536` |
| background marketplace install | install/update 后 auto-refresh or fallback `needsRefresh` | event `tengu_marketplace_background_install` + diagnostics + debug fallback + error log | fallback 仍未结构化记录为 cleanup-deferred event | `PluginInstallationManager.ts:122-165` |
| active plugin refresh | clear caches, consume `needsRefresh=false`, emit summary logs | debug for cache clear + hook failure + refreshed counts summary | 缺 dedicated refresh-consumed event / ledger row | `refresh.ts:75-80,123-177` |
| weak plugin notice surface | show `plugin-reload-pending` but refuse cleanup | 注释明确 `Do NOT reset needsRefresh`，形成“不可清理性”边界 | 缺显式“cleanup denied by layer” audit trail | `useManagePlugins.ts:287-303` |

## 3. 最短判断公式

判断一条清理路径是否已经具备“遗忘审计”意识，先问四句：

1. 清理动作有没有被记录
2. 清理原因有没有被记录
3. fallback / defer 有没有被记录
4. 之后还能不能回查是谁、为什么、在什么 gate 下做了这次清理

## 4. 最常见的四类误读

| 误读 | 实际问题 |
| --- | --- |
| “有 log 就等于有审计” | 零散 debug 不等于结构化 cleanup ledger |
| “前景清掉了就表示流程结束” | 删除前景不等于删除解释线索 |
| “fallback 只是产品细节” | fallback 本身就是恢复审计的一部分 |
| “弱 surface 不清理就无需留痕” | “无权清理”本身也值得被解释 |

## 5. 一条硬结论

Claude Code 当前最值得学的，不是：

`怎么更快清掉痕迹，`

而是：

`即使要清，也尽量不给系统留下“谁清的、为何清的、清完后还剩什么”无人能答的黑箱。`

