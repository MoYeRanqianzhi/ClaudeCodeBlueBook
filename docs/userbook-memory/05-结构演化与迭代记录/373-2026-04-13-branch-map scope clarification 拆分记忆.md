# branch-map scope clarification 拆分记忆

## 本轮继续深入的核心判断

在上一刀已经把：

- `103-CCR 的 observer metadata 不是同一种恢复面.md`

补成：

- `103` 只抓 observer metadata 的窄恢复合同

之后，

当前更自然的下一刀，

终于不是再补某个 leaf page，

而是回到：

- `208-task_summary、post_turn_summary、terminal tail、observer restore 与 suggestion settlement：为什么 100-104 不是并列细页，而是先从 summary 分家，再分叉到终态收口与恢复合同.md`

把这张结构总纲页自己的主语再收紧一句。

## 为什么这轮值得单独提交

### 判断一：当前缺口不在“208 有没有画出主干和侧枝”，而在“208 会不会把跨页拓扑、页内主语和局部灰度推断写成同一层”

`208` 正文现在已经把这些事讲出来了：

- `100` 是根页，不是并列尾页之一
- `101→102→104` 是终态收口主干
- `103` 是 observer-restore 侧枝
- 稳定用户合同、条件性可见合同、灰度/实现证据需要分层

但如果读者在进入第一性原理前，

还没先被明确提醒：

- 这里不是在重讲 `100-104` 各页的页内证明
- 这里也不该把 `lastMessage`、`lastEmitted`、`pendingLastEmittedEntry`、`externalMetadataToAppState(...)` 这些 helper / ledger 名重新抬成总纲主角

就仍然很容易把：

- 跨页拓扑
- 单页主语
- 稳定合同
- 条件可见边界
- leaf-level gray inference

重新压回一句：

- “这一组页都在讲同一套 result 后尾流，只是分别展开而已”

所以这一刀真正补的，

不是更多结构事实，

而是范围声明。

### 判断二：这句必须把 map、contract layer 与 helper-evidence 三层同时点出来

本地复核和并行只读分析都在指向同一个风险：

- `208` 现在最容易把“图上关系”和“图里各页的具体证明对象”混成一个层级

如果只写：

- “这里只讲 branch map”

还不够稳，

因为读者仍可能把三层对象写平：

- map layer：
  - `100` 是根页
  - `101→102→104` 是主干
  - `103` 是侧枝
- contract layer：
  - 稳定用户合同
  - 条件性可见合同
  - 灰度实现证据
- evidence layer：
  - `lastMessage`
  - `lastEmitted`
  - `pendingLastEmittedEntry`
  - `externalMetadataToAppState(...)`
  - worker init scrub

所以当前最稳的说法必须同时说明：

- 本页主语是跨页拓扑与合同分层
- 各页页内主语仍留在各自 leaf page
- helper / ledger 名只作为 evidence，不再升格成 branch map 的主角

## 这轮具体怎么拆

这轮只做一件事：

1. 在 `208-...branch map...md`
   的导语和第一性原理之间，
   增加一句范围声明：
   - 本页不重讲 `100-104` 各页自己的页内证明
   - 也不把 `lastMessage`、`lastEmitted`、`pendingLastEmittedEntry`、`externalMetadataToAppState(...)` 这类 helper / ledger 名重新升级成新的主角
   - 这里只整理跨页拓扑：100 根页、`101→102→104` 主干、103 侧枝
   - 并把稳定用户合同、条件性可见合同、灰度实现证据分层
   - 防止把 leaf-level gray inference 写成整棵分叉树的统一运行时结论

这样：

- `208`
  终于和 `100-104` 的局部 scope guard 节奏对齐
- `208`
  不再像一页“把所有 helper 名再总述一次”的后设摘要
- 后面如果继续写 `105-110` 或 `103/107/167` 那类二级结构图，
  这一页也能更稳地停在 “100-104 branch map” 的层级

## 苏格拉底式自审

### 问：为什么这轮终于可以回到 `208`？

答：因为 `100/101/102/103/104` 现在都已经补过局部 scope guard。到这一步，再回头把 branch map 的页首主语说死，顺序才不发空。

### 问：为什么 `208` 还需要 scope guard，正文不是已经在讲拓扑了吗？

答：因为当前风险不在正文有没有图，而在读者进入图之前，仍会先把它误听成“把各页 helper 和 runtime 细节再做一遍总复述”。范围声明要先把这条误听切掉。

### 问：为什么要显式点名 helper / ledger 名？

答：因为 `208` 最容易在总纲里重新抬高这些局部证据对象，导致稳定合同、条件边界和实现证据再次串层。把它们先降回 evidence，后文的三层表格才真正稳。

### 问：为什么这句要同时提 stable / conditional / gray 三层？

答：因为 `208` 的职责不只是画树，还要告诉读者“哪些判断属于树上的稳定对象关系，哪些只是路径条件或局部推断”。如果不先点这三层，拓扑页就会重新塌成一页宽泛综述。
