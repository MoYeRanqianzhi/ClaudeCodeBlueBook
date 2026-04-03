# 安全遗忘投影速查表：surface、allowed cleanup depth、must-show fields与forbidden overprojection

## 1. 这一页服务于什么

这一页服务于 [137-安全遗忘投影规则：为什么cleanup字段不应平均撒到所有surface，而必须按带宽、责任与解释权分层投影](../137-%E5%AE%89%E5%85%A8%E9%81%97%E5%BF%98%E6%8A%95%E5%BD%B1%E8%A7%84%E5%88%99%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88cleanup%E5%AD%97%E6%AE%B5%E4%B8%8D%E5%BA%94%E5%B9%B3%E5%9D%87%E6%92%92%E5%88%B0%E6%89%80%E6%9C%89surface%EF%BC%8C%E8%80%8C%E5%BF%85%E9%A1%BB%E6%8C%89%E5%B8%A6%E5%AE%BD%E3%80%81%E8%B4%A3%E4%BB%BB%E4%B8%8E%E8%A7%A3%E9%87%8A%E6%9D%83%E5%88%86%E5%B1%82%E6%8A%95%E5%BD%B1.md)。

如果 `137` 的长文解释的是：

`为什么 cleanup fields 必须按 surface 分层投影，`

那么这一页只做一件事：

`把不同 surface 的 allowed cleanup depth、must-show fields 与 forbidden overprojection 压成一张矩阵。`

## 2. 投影矩阵

| surface | allowed cleanup depth | must-show fields | forbidden overprojection | 关键证据 |
| --- | --- | --- | --- | --- |
| notification current | 极浅摘要层 | 短 `cleanup_replaced_by` 或一句 action hint | 长 `cleanup_gate`、完整 `cleanup_owner`、审计 id | `PromptInput/Notifications.tsx:147-163,281-292` |
| footer pill | operational cue 层 | status label + affordance | 宣布 cleanup finality、展开 cleanup cause | `PromptInputFooter.tsx:173-189` |
| `/status` summary | 聚合摘要层 | cleanup counts / deferred presence / handoff hint | 逐条 cleanup 明细、长原因链 | `status.tsx:95-114` |
| bridge dialog / detail pane | detail layer | `cleanup_reason`、`cleanup_gate`、`cleanup_replaced_by` | 只给贫血 label、隐藏关键 error/context | `BridgeDialog.tsx:137-240` |
| SDK host structured surface | full structured layer | `cleanup_owner`、`cleanup_reason`、`cleanup_gate`、`cleanup_replaced_by`、`cleanup_audit_id` | 仅给文案摘要而不给结构化字段 | `coreSchemas.ts:1457-1542` |

## 3. 最短判断公式

判断某个 surface 是否投影过深或过浅，先问四句：

1. 这个 surface 的带宽够不够承载 cleanup 原因
2. 它的责任是提醒、导航、解释，还是结构化承载
3. 若把更强字段塞给它，会不会 overclaim
4. 若不给它应有字段，会不会造成 detail starvation

## 4. 最常见的四类误读

| 误读 | 实际问题 |
| --- | --- |
| “字段有了就应该哪里都显示” | 平均展示会制造 overprojection |
| “footer 也可以解释完整原因” | operational cue 不等于 authoritative detail |
| “`/status` 应该列全量细节” | summary layer 不是 ledger layer |
| “SDK host 只要和 UI 一样的摘要就够了” | host 最适合消费结构化 cleanup 语义 |

## 5. 一条硬结论

Claude Code 下一步如果真把 cleanup protocol 做成产品能力，最关键的不只是：

`把字段加出来，`

而是：

`让不同 surface 只看到它们配看到的 cleanup 深度。`

