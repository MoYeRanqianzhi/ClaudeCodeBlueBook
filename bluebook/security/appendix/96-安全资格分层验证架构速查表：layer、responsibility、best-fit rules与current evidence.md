# 安全资格分层验证架构速查表：layer、responsibility、best-fit rules与current evidence

## 1. 这一页服务于什么

这一页服务于 [112-安全资格分层验证架构：为什么真正成熟的安全系统必须把schema、guard、transition、ledger与tests做成验证金字塔](../112-%E5%AE%89%E5%85%A8%E8%B5%84%E6%A0%BC%E5%88%86%E5%B1%82%E9%AA%8C%E8%AF%81%E6%9E%B6%E6%9E%84%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%E7%9C%9F%E6%AD%A3%E6%88%90%E7%86%9F%E7%9A%84%E5%AE%89%E5%85%A8%E7%B3%BB%E7%BB%9F%E5%BF%85%E9%A1%BB%E6%8A%8Aschema%E3%80%81guard%E3%80%81transition%E3%80%81ledger%E4%B8%8Etests%E5%81%9A%E6%88%90%E9%AA%8C%E8%AF%81%E9%87%91%E5%AD%97%E5%A1%94.md)。

如果 `112` 的长文解释的是：

`安全验证必须是分层金字塔，`

那么这一页只做一件事：

`把各验证层该负责什么、最适合承载哪些规则、以及当前源码里已有哪类证据压成一张矩阵。`

## 2. 分层验证金字塔矩阵

| layer | responsibility | best-fit rules | current evidence | 当前主要缺口 |
| --- | --- | --- | --- | --- |
| Schema | 验证对象语法与入场资格 | shape valid、fresh enough、basic type safety | `bridgePointer.safeParse + TTL` | 适用范围仍较窄 |
| Runtime Guard | 在真实时序里阻断局部非法跃迁 | stale actor、duplicate family、absent-remove、error timer | `notifications` 与 `useReplBridge` 多处 `return prev` guard | 规则分散，缺统一 catalog |
| Centralized Transition | 统一高风险状态变化的语法与 gate | permission mode、bridge lifecycle、refresh completion | `transitionPermissionMode()` + guard-before-transition 注释 | 还未推广到更多安全子系统 |
| Ledger / Diff Propagation | 记录并传播合法变化 | metadata sync、UI explanation、audit trail | `onChangeAppState()` 单一 diff choke point | 生命周期账本仍未完全落地 |
| Automated Tests | 持续证明前四层未退化 | property、transition-table、integration ordering | 本地高风险模块 `test/spec` 检索为 `0` | 塔顶明显偏弱 |

## 3. 最短判断公式

看到一条安全规则时，先问五句：

1. 这条规则最适合在哪一层被验证
2. 这一层当前在源码中是否已经存在
3. 它是否被错塞到了别的层
4. 哪一层最容易在未来重构中退化
5. 这条规则是否已经从“作者记忆”升级成“层级责任”

## 4. 最常见的五类分层错误

| 错误方式 | 会造成什么问题 |
| --- | --- |
| 把时序问题只交给 schema | 合法性仍会在运行时破功 |
| 把统一跃迁规则散落成局部 guard | 状态机语法无法收口 |
| 没有 ledger 层只做 guard | 变化无法被统一解释与传播 |
| 没有 tests 层只靠前四层 | 重构退化难以及时发现 |
| 让某一层承担全部责任 | 代码和制度都会失衡 |

## 5. 一条硬结论

对安全控制面来说，  
真正稳固的不是：

`某一层特别强，`

而是：

`每一层都只承担自己最擅长的那一类验证责任，并且一起构成闭环。`
