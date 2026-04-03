# 安全遗忘协议字段速查表：field、meaning、best current carrier与migration gain

## 1. 这一页服务于什么

这一页服务于 [136-安全遗忘协议字段：为什么下一代控制台必须把cleanup_owner、cleanup_reason、cleanup_gate、cleanup_replaced_by与cleanup_audit_id做成结构化字段](../136-%E5%AE%89%E5%85%A8%E9%81%97%E5%BF%98%E5%8D%8F%E8%AE%AE%E5%AD%97%E6%AE%B5%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%E4%B8%8B%E4%B8%80%E4%BB%A3%E6%8E%A7%E5%88%B6%E5%8F%B0%E5%BF%85%E9%A1%BB%E6%8A%8Acleanup_owner%E3%80%81cleanup_reason%E3%80%81cleanup_gate%E3%80%81cleanup_replaced_by%E4%B8%8Ecleanup_audit_id%E5%81%9A%E6%88%90%E7%BB%93%E6%9E%84%E5%8C%96%E5%AD%97%E6%AE%B5.md)。

如果 `136` 的长文解释的是：

`为什么 cleanup audit 最终必须升级成结构化字段，`

那么这一页只做一件事：

`把候选 field 的 meaning、best current carrier 与 migration gain 压成一张矩阵。`

## 2. 字段矩阵

| field | meaning | best current carrier | migration gain | 当前缺口证据 |
| --- | --- | --- | --- | --- |
| `cleanup_owner` | 谁执行了这次合法清理 | notification / plugin state / bridge pointer companion state | 正式表达“谁配清”，避免弱 surface 脑补 | `notifications.tsx:5-23`; `AppStateStore.ts:185-216`; 全局检索无该字段 |
| `cleanup_reason` | 为何触发清理 | plugin refresh result / bridge pointer lifecycle / reconnect result | UI 和 host 可直接展示“为何清” | `bridgePointer.ts:42-50,186-202`; `AppStateStore.ts:195-215` |
| `cleanup_gate` | 满足了哪道门槛才允许清理 | active plugin refresh result / bridge shutdown summary | 让 cleanup constitution 可机检 | `refresh.ts:123-138`; `bridgeMain.ts:1407-1415` |
| `cleanup_replaced_by` | 旧痕迹被哪个新对象或新语义替代 | notification invalidation / plugin pending state / MCP result state | 避免“清掉以后发生了什么”继续靠推断 | `notifications.tsx:9-22`; `PluginInstallationManager.ts:148-179` |
| `cleanup_audit_id` | 跨 UI / log / diag / event 的统一关联 id | bridge cleanup flow / marketplace install flow / plugin refresh flow | 把散点日志升级成可回查审计链 | `bridgeMain.ts:1407-1415`; `PluginInstallationManager.ts:122-133`; 当前无统一 id |

## 3. 最短判断公式

判断一个 cleanup 语义是否已经值得字段化，先问四句：

1. 它是否已经被多个 surface 共同依赖
2. 它是否仍主要藏在注释与 debug 里
3. 若没有字段，UI / host / tests 是否只能重新推导
4. 一旦字段化，是否能显著降低 overclaim 与误删风险

## 4. 最常见的四类误读

| 误读 | 实际问题 |
| --- | --- |
| “log 已经够用了” | log 不是正式控制面字段 |
| “字段太多会很重” | 关键 cleanup 语义不字段化会更重，因为所有层都要自己猜 |
| “只有 UI 需要这些信息” | tests、SDK host、diag pipeline 也都需要 |
| “先有统一实现再字段化” | 没有字段，统一实现反而更难收敛 |

## 5. 一条硬结论

Claude Code 下一步最值得做的，不是：

`再加更多 cleanup 注释，`

而是：

`把已经客观存在的 cleanup owner / reason / gate / replacement / audit link 正式升级成可消费字段。`

