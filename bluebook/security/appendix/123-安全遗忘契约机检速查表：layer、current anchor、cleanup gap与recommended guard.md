# 安全遗忘契约机检速查表：layer、current anchor、cleanup gap与recommended guard

## 1. 这一页服务于什么

这一页服务于 [139-安全遗忘契约机检：为什么cleanup语义一旦进入宿主契约，就必须被schema、生成类型、handler与conformance共同守住](../139-%E5%AE%89%E5%85%A8%E9%81%97%E5%BF%98%E5%A5%91%E7%BA%A6%E6%9C%BA%E6%A3%80%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88cleanup%E8%AF%AD%E4%B9%89%E4%B8%80%E6%97%A6%E8%BF%9B%E5%85%A5%E5%AE%BF%E4%B8%BB%E5%A5%91%E7%BA%A6%EF%BC%8C%E5%B0%B1%E5%BF%85%E9%A1%BB%E8%A2%ABschema%E3%80%81%E7%94%9F%E6%88%90%E7%B1%BB%E5%9E%8B%E3%80%81handler%E4%B8%8Econformance%E5%85%B1%E5%90%8C%E5%AE%88%E4%BD%8F.md)。

如果 `139` 的长文解释的是：

`为什么 cleanup 契约最终必须被机器共同守住，`

那么这一页只做一件事：

`把不同 layer 的 current anchor、cleanup gap 与 recommended guard 压成一张矩阵。`

## 2. 机检矩阵

| layer | current anchor | cleanup gap | recommended guard | 关键证据 |
| --- | --- | --- | --- | --- |
| schema | `coreSchemas.ts` single source of truth；`controlSchemas.ts` control protocol | cleanup fields 尚未进入 schema | 增加 cleanup fields + schema snapshot checks | `coreSchemas.ts:1-8`; `controlSchemas.ts:1-8` |
| generated types | `coreTypes.ts` 明确由 schema 生成 | 当前可见提取树未见生成脚本/生成产物与 cleanup fields | 生成链校验 + generated diff review | `coreTypes.ts:1-9`; `src/entrypoints/sdk/` 目录可见文件仅三项 |
| handler | `print.ts` 已正式处理 `mcp_status`/`reload_plugins`/`mcp_reconnect`/`mcp_toggle` | response payload 不产出 cleanup provenance | handler contract tests + response shape assertions | `print.ts:2957-3225` |
| host contract | `system:init`、`system:status`、`task_notification`、`post_turn_summary` 已 schema 化 | cleanup semantics 未正式进入宿主消息面 | host decoding / fallback tests | `coreSchemas.ts:1457-1542,1544-1569,1694-1712` |
| compatibility / conformance | 当前仅见 schema + handler骨架 | 缺 cleanup-specific conformance story | backward-compat matrix + new/old host cross-tests | 由上层缺口综合推得 |

## 3. 最短判断公式

判断 cleanup 语义是否已经从“字段提案”升级到“可机检契约”，先问四句：

1. schema 有没有它
2. generated types 有没有它
3. handler 有没有真的生产/消费它
4. compatibility / conformance 有没有强制别人也守它

## 4. 最常见的四类误读

| 误读 | 实际问题 |
| --- | --- |
| “schema 里写了就算完成” | 没有 handler 与 conformance 仍然会漂移 |
| “handler 里返回了就够了” | 没有 types 与 compatibility 仍然会破宿主 |
| “宿主以后自己适配” | 没有 contract guard 就会重新回到猜测 |
| “测试以后再补” | 没有测试，cleanup 契约仍然太依赖维护者记忆 |

## 5. 一条硬结论

Claude Code 若真要把 cleanup 从内部经验升级成公共契约，最关键的不只是：

`把语义说清楚，`

而是：

`让机器在 schema、types、handler 和 conformance 四层一起拦住退化。`

