# 安全资格投影字段落位速查表：surface、must-show fields、optional fields与forbidden clutter

## 1. 这一页服务于什么

这一页服务于 [104-安全资格投影字段落位：为什么projection-protocol不应平均撒到所有surface，而应随控制面强弱分层布置](../104-%E5%AE%89%E5%85%A8%E8%B5%84%E6%A0%BC%E6%8A%95%E5%BD%B1%E5%AD%97%E6%AE%B5%E8%90%BD%E4%BD%8D%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88projection-protocol%E4%B8%8D%E5%BA%94%E5%B9%B3%E5%9D%87%E6%92%92%E5%88%B0%E6%89%80%E6%9C%89surface%EF%BC%8C%E8%80%8C%E5%BA%94%E9%9A%8F%E6%8E%A7%E5%88%B6%E9%9D%A2%E5%BC%BA%E5%BC%B1%E5%88%86%E5%B1%82%E5%B8%83%E7%BD%AE.md)。

如果 `104` 的长文解释的是：

`为什么 projection fields 必须按界面层级分配，`

那么这一页只做一件事：

`把不同 surface 必须显示什么、可选显示什么、绝不该塞什么压成一张落位矩阵。`

## 2. 安全资格投影字段落位矩阵

| surface | must-show fields | optional fields | forbidden clutter | 关键证据 |
| --- | --- | --- | --- | --- |
| authoritative dialog | `projection_scope`、`visible_truth_subset`、`handoff_route`、核心 status | `hidden_truth_hint`、debug/signer ids | 只给模糊 label 不给解释 | `BridgeDialog.tsx:183-240` |
| footer pill | `label`、最轻 handoff affordance | 极轻量 scope hint | 长段 hidden truth / detail metadata | `PromptInputFooter.tsx:182-189` |
| aggregate summary (`/status`) | counts、`projection_scope` summary hint、`handoff_route` | 极短 hidden truth hint | per-server detail / 长篇说明 | `status.tsx:89-114` |
| notification | 问题 truth、`handoff_route` | 极短 hidden truth hint | 全量成功态 / 多层上下文 | `useMcpConnectivityStatus.tsx:36-63` |
| local detail menu | local `visible_truth_subset`、局部 status、局部 handoff | stronger auth/effective-completion hints | 全局 summary 冒充 | `MCPRemoteServerMenu.tsx:88-100` |

## 3. 最短判断公式

设计某个 surface 时，先问五句：

1. 这个面承担的是 detail、summary、notification 还是入口责任
2. 哪些字段是它必须显示的最低真相
3. 哪些字段可以放到下钻层
4. 哪些字段一塞进去就会形成 clutter 或 overclaim
5. 这里最重要的 handoff 是什么

## 4. 最常见的五类落位错误

| 错误方式 | 会造成什么问题 |
| --- | --- |
| footer 塞进过多 hidden truth | 窄入口失去可扫读性 |
| summary 塞进 per-server detail | 聚合面失去 summary 角色 |
| notification 塞进全量上下文 | 抢占面噪音过大 |
| detail dialog 只给 label 不给解释 | 强面浪费了解释责任 |
| 所有面都显示同一套字段 | surface 强弱层级被抹平 |

## 5. 一条硬结论

对 Claude Code 这类安全控制面来说，  
真正成熟的不是：

`把所有字段都做出来，`

而是：

`让每个字段出现在最配拥有它的界面层级上。`
