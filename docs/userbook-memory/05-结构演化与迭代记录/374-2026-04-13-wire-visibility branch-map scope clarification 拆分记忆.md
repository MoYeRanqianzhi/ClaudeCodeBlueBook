# wire-visibility branch-map scope clarification 拆分记忆

## 本轮继续深入的核心判断

在上一刀已经把：

- `208-task_summary、post_turn_summary、terminal tail、observer restore 与 suggestion settlement：为什么 100-104 不是并列细页，而是先从 summary 分家，再分叉到终态收口与恢复合同.md`

补成：

- `208` 只抓 branch map 与 contract layering

之后，

当前最自然的下一刀，

不是再回去补 `105/106/108/109/110` 的 leaf 页，

而是回到：

- `209-post_turn_summary、StdoutMessage、SDKMessage、stream-json raw wire 与 streamlined_*：为什么 105、106、108、109、110 不是并列尾页，而是从 wider-wire visibility 分叉出去的四种后继问题.md`

把这一页自己的主语也收紧成一句。

## 为什么这轮值得单独提交

### 判断一：当前缺口不在“209 有没有画出 wider-wire visibility 的分叉图”，而在“209 会不会把 branch map、leaf 主语与局部 helper 证据写成同一层”

`209` 正文已经把这些关系讲出来了：

- `105` 是 wider-wire visibility 根页
- `106` 是 raw wire contract 分叉
- `108` 是 callback narrowing 分叉
- `109` 是 pre-wire projection 分叉
- `110` 是交叉叶子，解释 same skip list != same suppress reason
- stable / conditional / gray 三层也已经在正文后段列出来

但如果读者在进入第一性原理前，

还没先被明确提醒：

- 这里不是在重讲 `105-110` 各页自己的页内证明
- 这里也不该把 `post_turn_summary`、`stream-json --verbose`、`streamlined_*`、`isStdoutMessage(...)`、skip list 这些局部对象重新抬成总纲主角

就仍然很容易把：

- wider-wire visibility 根分裂
- raw wire / callback / projection 三条分叉
- cross-leaf suppress reason split
- stable / conditional / gray layering

重新压回一句：

- “这几页都在讲同一套消息可见性，只是分别举例”

所以这一刀真正补的，

不是更多结构事实，

而是范围声明。

### 判断二：这句必须同时点出 branch map、contract layer 与 helper-evidence 三层

本地复核和旧记忆都指向同一个风险：

- `209` 现在最容易把“图上关系”和“图里各页的局部证明对象”写平

如果只写：

- “这里只讲 wider-wire visibility branch map”

还不够稳，

因为读者仍可能把三层对象压成一层：

- map layer：
  - `105` 根页
  - `106/108/109` 三条分叉
  - `110` 交叉叶子
- contract layer：
  - stable user contract
  - conditional visibility
  - gray implementation evidence
- evidence layer：
  - `post_turn_summary`
  - `stream-json --verbose`
  - `streamlined_*`
  - `isStdoutMessage(...)`
  - skip list / gate / helper 顺序

所以当前最稳的说法必须同时说明：

- 本页主语是跨页 branch map 与合同分层
- 各页页内主语仍留在各自 leaf page
- helper / gate / ledger 名只作 evidence，不再升格成 wider-wire 总纲主角

## 这轮具体怎么拆

这轮只做一件事：

1. 在 `209-...wider-wire visibility...md`
   的导语和第一性原理之间，
   增加一句范围声明：
   - 本页不重讲 `105/106/108/109/110` 各页自己的页内证明
   - 也不把 `post_turn_summary`、`stream-json --verbose`、`streamlined_*`、`isStdoutMessage(...)`、skip list 这些局部对象和 helper 名重新升级成新的总纲主角
   - 这里只整理跨页拓扑：105 根页，106/108/109 三条后继线，110 交叉叶子
   - 并把稳定用户合同、条件性可见合同与灰度实现证据分层
   - 防止把 leaf-level 的局部 wire 证据写成整簇页面的统一运行时结论

这样：

- `209`
  就能和 `208` 一样，先在页首把 branch-map 主语说死
- `209`
  不再像一页“把 105-110 的 helper 和 leaf 结论再总述一次”的后设摘要
- 后面如果继续去 `210` 那簇 builder/callback/UI consumer 的二级结构，
  这页也能更稳地停在 wider-wire visibility 这一层

## 苏格拉底式自审

### 问：为什么这轮不是回去补 105 或 109？

答：因为 `105/106/108/109/110` 的 leaf 页已经各自成立。当前真正缺的是 `209` 自己还没在页首把“branch map，不重讲 leaf proof”写成一句。

### 问：为什么 `209` 还需要 scope guard，正文不是已经在讲结构图了吗？

答：因为当前风险不在正文有没有拓扑，而在读者进入图之前，仍会先把这页误听成“把各页局部 wire/callback/projection 证明再复述一次”。范围声明要先把这条误听切掉。

### 问：为什么这句要显式点名 `post_turn_summary`、`stream-json --verbose`、`streamlined_*`、`isStdoutMessage(...)`、skip list？

答：因为 `209` 最容易在总纲里重新抬高这些局部对象，导致 stable/conditional/gray 三层再次串层。先把它们降回 evidence，后文的三层分层才真正稳。

### 问：为什么这句还要同时提 stable / conditional / gray 三层？

答：因为 `209` 的职责不只是画树，还要告诉读者“哪些判断属于 wider-wire 的稳定对象关系，哪些只是宿主条件或局部实现证据”。如果不先点这三层，拓扑页就会重新塌成一页宽泛综述。
