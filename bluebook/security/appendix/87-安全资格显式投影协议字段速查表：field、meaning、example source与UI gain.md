# 安全资格显式投影协议字段速查表：field、meaning、example source与UI gain

## 1. 这一页服务于什么

这一页服务于 [103-安全资格显式投影协议字段：为什么下一代控制台应把projection-scope与hidden-truth做成结构化字段](../103-%E5%AE%89%E5%85%A8%E8%B5%84%E6%A0%BC%E6%98%BE%E5%BC%8F%E6%8A%95%E5%BD%B1%E5%8D%8F%E8%AE%AE%E5%AD%97%E6%AE%B5%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%E4%B8%8B%E4%B8%80%E4%BB%A3%E6%8E%A7%E5%88%B6%E5%8F%B0%E5%BA%94%E6%8A%8Aprojection-scope%E4%B8%8Ehidden-truth%E5%81%9A%E6%88%90%E7%BB%93%E6%9E%84%E5%8C%96%E5%AD%97%E6%AE%B5.md)。

如果 `103` 的长文解释的是：

`为什么投影诚实性需要被字段化，`

那么这一页只做一件事：

`把建议的 projection protocol fields、来源示例与UI收益压成一张字段矩阵。`

这里还要再多记一句：

- owner page 仍是 `security/README` 与 `api/85 / api/94`；这一页只给 projection consumer 提供诚实字段，不代签 `settled_price`、`shared_consumer_surface` 或 current truth。

## 2. 安全资格显式投影协议字段矩阵

| field | meaning | example source | UI gain | 关键证据 |
| --- | --- | --- | --- | --- |
| `projection_scope` | 当前 surface 属于哪类投影层 | footer / notification / summary / dialog | 用户立刻知道这是全量还是子集 | `PromptInputFooter.tsx:173-185`; `status.tsx:96-114` |
| `visible_truth_subset` | 当前 surface 真正看见了哪些 completion facts | failed-only、counts-only、connected+tools | 避免局部 truth 被误当全貌 | `useReplBridge.tsx:102-112`; `MCPRemoteServerMenu.tsx:88-100` |
| `hidden_truth_hint` | 当前未展示但相关的重要真相 | failed routed to notification、server detail hidden | 把“没显示 ≠ 不存在”显式化 | `PromptInputFooter.tsx:173-185`; `status.tsx:96-114` |
| `handoff_route` | 若想看更全或处理下一步，应跳去哪 | `/mcp`、`/remote-control`、`/reload-plugins` | 把解释差异直接连到动作路由 | `useMcpConnectivityStatus.tsx:30-63` |
| `overclaim_ceiling` | 当前 surface 最多允许说多满 | summary only / local detail only / active ok | 防止弱 surface 越权用强词 | `BridgeStatusUtil.ts:113-140` |
| `forbidden_inference` | 用户最不该从此处推出的更强结论 | no notification != all clear | 直接阻断最常见误解 | `context/notifications.tsx:5-33` |

## 3. 最短判断公式

设计一个新 surface 时，先问五句：

1. 它是不是 owner surface；如果是，先回 `security/README` 与 `api/85 / api/94`，不要先套 projection grammar
2. 它属于哪种 `projection_scope`
3. 它真正能看到哪些 `visible_truth_subset`
4. 它必须提醒哪些 `hidden_truth_hint`
5. 它该 handoff 到哪里
6. 它最该阻止哪种 `forbidden_inference`

## 4. 最常见的五类字段缺失问题

| 缺失字段 | 会造成什么问题 |
| --- | --- |
| 缺 `projection_scope` | 用户不知道这是 summary 还是 detailed view |
| 缺 `visible_truth_subset` | 界面误冒充全量控制台 |
| 缺 `hidden_truth_hint` | 用户把没显示误读为没有 |
| 缺 `handoff_route` | 用户不知道去哪看更强真相 |
| 缺 `forbidden_inference` | 最常见误读不会被系统主动阻断 |

## 5. 一条硬结论

对 Claude Code 这类安全控制面来说，  
真正成熟的不是：

`把投影诚实性留在注释里，`

而是：

`把投影诚实性编码成所有 projection consumer 都能消费的结构化字段。`

这些字段真正保护的也不是：

`哪一层有权宣布 current truth，`

而是：

`弱 surface 在消费 shared verdict object 时，不能越级冒充 owner。`
