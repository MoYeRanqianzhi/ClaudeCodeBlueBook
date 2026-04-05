# 安全遗忘契约兼容迁移速查表：surface、current compatibility tactic、cleanup upgrade risk与recommended rollout

## 1. 这一页服务于什么

这一页服务于 [140-安全遗忘契约兼容迁移：为什么cleanup语义必须以optional fields、降级语法、假成功防护与兼容回退渐进进入宿主生态](../140-%E5%AE%89%E5%85%A8%E9%81%97%E5%BF%98%E5%A5%91%E7%BA%A6%E5%85%BC%E5%AE%B9%E8%BF%81%E7%A7%BB%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88cleanup%E8%AF%AD%E4%B9%89%E5%BF%85%E9%A1%BB%E4%BB%A5optional%20fields%E3%80%81%E9%99%8D%E7%BA%A7%E8%AF%AD%E6%B3%95%E3%80%81%E5%81%87%E6%88%90%E5%8A%9F%E9%98%B2%E6%8A%A4%E4%B8%8E%E5%85%BC%E5%AE%B9%E5%9B%9E%E9%80%80%E6%B8%90%E8%BF%9B%E8%BF%9B%E5%85%A5%E5%AE%BF%E4%B8%BB%E7%94%9F%E6%80%81.md)。

如果 `140` 的长文解释的是：

`为什么 cleanup 语义的发布必须同时满足兼容性与诚实性，`

那么这一页只做一件事：

`把不同 surface / path 当前使用的 compatibility tactic、cleanup upgrade risk 与 recommended rollout 压成一张矩阵。`

## 2. 兼容迁移矩阵

| surface / path | current compatibility tactic | cleanup upgrade risk | recommended rollout | 关键证据 |
| --- | --- | --- | --- | --- |
| MCP stdio config schema | 用 `.optional()` 保留旧 payload 兼容 | 新 cleanup 字段若首发即必填，会直接打断旧宿主 | cleanup fields 首发设为 optional，并定义字段缺席语义 | `coreSchemas.ts:110-116` |
| keep_alive message path | 正式 schema 化，但消费端 silent ignore | 若把 cleanup semantic 混入可静默忽略流量，会造成无声失真 | 只允许 housekeeping traffic 静默兼容；cleanup 相关语义禁止 silent ignore | `controlSchemas.ts:621-627`; `structuredIO.ts:344-346`; `print.ts:4036-4038` |
| duplicate / orphan control_response path | 去重、孤儿转交、已处理过的不再重复执行 | cleanup ack 若被重放，可能重复清理或重复关闭失败痕迹 | cleanup response 必须绑定 request / owner / audit，并有 duplicate suppression | `structuredIO.ts:362-429`; `print.ts:5252-5303` |
| outbound-only / unsupported mutable request | 当前一律 explicit error，避免 false success | cleanup control 若上下文不支持却仍 success，会直接撒谎 | future cleanup action 继承 explicit error verdict 规则 | `bridgeMessaging.ts:265-282`; `bridgeMessaging.ts:328-357`; `bridgeMessaging.ts:373-383` |
| remote session converted message path | 先分类成 `message` / `stream_event` / `ignored`，再决定是否 drop | cleanup provenance 若被错误归到 ignored，会被静默吃掉 | cleanup 相关消息不得落入 generic ignored bucket；需强 surface 分类 | `useRemoteSession.ts:244-249`; `useRemoteSession.ts:273-329` |
| apply_flag_settings compatibility path | `null` 转 deletion，先 reset cache，再 fan-out，防止 silent drop | cleanup 升级若只“看起来写入”，却被 cache/stale path 吃掉，会出现假完成 | cleanup fields/acks 必须覆盖 stale cache 与 serialization compatibility tests | `print.ts:3709-3736` |
| `system:init` / `system:status` strong surfaces | 已 schema 化，但尚无 cleanup fields | 老宿主与新宿主会对 cleanup provenance 继续靠猜测 | 在这两类系统消息先落 optional cleanup fields + downgrade grammar | `coreSchemas.ts:1457-1493`; `coreSchemas.ts:1533-1542` |
| `mcp_status` / `reload_plugins` control responses | 已有正式 response schema，但 payload 仍只含结果态 | cleanup 升级若只在内部 handler 做，不进 response，宿主仍不可见 | 把 cleanup provenance 逐步加入 response schema 与 handler payload | `controlSchemas.ts:165-173`; `controlSchemas.ts:415-432`; `print.ts:2957-2960`; `print.ts:3065-3129` |

## 3. 最短判断公式

判断某个 cleanup 迁移方案是否成熟，先问四句：

1. 新字段是不是 optional + 明确缺席语义
2. 老宿主不支持时，是 honest downgrade 还是假成功
3. duplicate / orphan / late delivery 会不会重复消费
4. 哪些路径允许 silent ignore，哪些路径必须 loud error

## 4. 最常见的四类误读

| 误读 | 实际问题 |
| --- | --- |
| “只要不崩就算兼容” | process 存活不等于 truth honest |
| “字段缺席就等于没有 cleanup” | 也可能只是 legacy payload / unprojected truth |
| “先 success，后面再补细节” | 对 mutating cleanup 来说这是典型 false success |
| “未知消息都可以 silently ignore” | 只有无语义副作用的 housekeeping traffic 才适合这样做 |

## 5. 一条硬结论

cleanup 语义若真要进入宿主生态，  
最危险的不是升级太慢，  
而是：

`在新旧宿主并存阶段，把“不支持”“没看见”“重复重放”与“已经合法完成 cleanup”混成同一句 success。`
