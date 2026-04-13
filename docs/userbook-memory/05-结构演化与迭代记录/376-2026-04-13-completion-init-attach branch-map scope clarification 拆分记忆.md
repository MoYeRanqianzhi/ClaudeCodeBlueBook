# completion-init-attach branch-map scope clarification 拆分记忆

## 本轮继续深入的核心判断

在上一刀已经把：

- `210-builder transport、callback surface、streamlined dual-entry 与 UI consumer policy：为什么 111、112、113、114、115 不是并列细页，而是先定四层可见性表，再分叉到 streamlined 与 adapter 两条后继线.md`

补成：

- `210` 只抓 builder-callback-UI branch map 与合同分层

之后，

当前更自然的下一刀，

不是回去补 `116-121` 的单页，

而是回到：

- `211-completion signal、system.init dual-axis、history attach restore 与 loading edge：为什么 116、117、118、119、120、121 不是线性后续页，而是三组相邻配对分叉.md`

把这一页自己的主语再收紧一句。

## 为什么这轮值得单独提交

### 判断一：当前缺口不在“211 有没有画出三组配对”，而在“211 会不会把 branch map、leaf 主语与局部 edge/helper 证据写成同一层”

`211` 正文现在已经把这些关系讲出来了：

- 116/119 是 completion / waiting 配对
- 117/120 是 `system.init` 双轴配对
- 118/121 是 attach / replay 配对
- stable / conditional / gray 的总分层也已经写在正文后段

但如果读者在进入第一性原理前，

还没先被明确提醒：

- 这里不是在重讲 `116-121` 各页自己的页内证明
- 这里也不该把 success `result` ignored、`isSessionEndMessage(...)`、`setIsLoading(true/false)`、`system.init`、`convertInitMessage(...)`、`sentUUIDsRef`、`onInit(...)` 这些局部对象和 helper 名重新抬成总纲主角

就仍然很容易把：

- completion / waiting 的 edge split
- init visibility / thickness 的双轴分裂
- replay dedup / attach restore 的配对关系

重新压回一句：

- “这几页都在讲 direct connect / viewer 的后续状态，只是换几个场景说明”

所以这一刀真正补的，

不是更多结构事实，

而是范围声明。

### 判断二：这句必须同时点出 branch map、contract layer 与 helper-evidence 三层

本地复核与现有记忆都在指向同一个风险：

- `211` 现在最容易把“图上关系”和“图里各页局部证明对象”压成一层

如果只写：

- “这里只讲 completion-init-attach branch map”

还不够稳，

因为读者仍可能把三层对象写平：

- map layer：
  - 116/119 配对
  - 117/120 配对
  - 118/121 配对
- contract layer：
  - stable user contract
  - conditional visibility / host gates
  - gray implementation evidence
- evidence layer：
  - `setIsLoading(true/false)`
  - `isSessionEndMessage(...)`
  - `system.init`
  - `convertInitMessage(...)`
  - `sentUUIDsRef`
  - `onInit(...)`

所以当前最稳的说法必须同时说明：

- 本页主语是跨页 branch map 与合同分层
- 各页页内主语仍留在各自 leaf page
- helper / gate / side effect 名只作 evidence，不再升格成 `211` 的总纲主角

## 这轮具体怎么拆

这轮只做一件事：

1. 在 `211-...completion-init-attach...md`
   的导语和第一性原理之间，
   增加一句范围声明：
   - 本页不重讲 `116/117/118/119/120/121` 各页自己的页内证明
   - 也不把 success `result` ignored、`isSessionEndMessage(...)`、`setIsLoading(true/false)`、`system.init`、`convertInitMessage(...)`、`sentUUIDsRef`、`onInit(...)` 这些局部对象和 helper 名重新升级成新的总纲主角
   - 这里只整理跨页拓扑：116/119 completion-waiting 配对，117/120 init dual-axis 配对，118/121 attach-replay 配对
   - 并把稳定用户合同、条件性可见合同与灰度实现证据分层
   - 防止把 leaf-level 的 edge、payload thickness、dedup 或 bootstrap side effect 写成整簇页面的统一运行时结论

这样：

- `211`
  就能和 `208/209/210` 保持同一种 structure-page 节奏
- `211`
  不再像一页“把 116-121 的 leaf proof 再总述一次”的后设摘要
- 后面如果继续去 `212-214` 那簇 recovery / ownership / terminality 的结构页，
  这一页也能更稳地停在 completion-init-attach 这一层

## 苏格拉底式自审

### 问：为什么这轮不是回去补 116 或 121？

答：因为 `116-121` 的 leaf 页已经各自成立。当前真正缺的是 `211` 自己还没在页首把“branch map，不重讲 leaf proof”写成一句。

### 问：为什么 `211` 还需要 scope guard，正文不是已经在讲结构图了吗？

答：因为当前风险不在正文有没有图，而在读者进入图之前，仍会先把这页误听成“把 direct connect / viewer 的后续状态叶页再复述一次”。范围声明要先把这条误听切掉。

### 问：为什么这句要显式点名 success `result` ignored、`isSessionEndMessage(...)`、`setIsLoading(true/false)`、`system.init`、`convertInitMessage(...)`、`sentUUIDsRef`、`onInit(...)`？

答：因为 `211` 最容易在总纲里重新抬高这些局部对象，导致 stable / conditional / gray 三层再次串层。先把它们降回 evidence，后文的分层才真正稳。

### 问：为什么这句还要同时提 stable / conditional / gray 三层？

答：因为 `211` 的职责不只是画树，还要告诉读者“哪些判断属于这簇页面的稳定层级关系，哪些只是宿主条件或局部实现证据”。如果不先点这三层，拓扑页就会重新塌成一页宽泛综述。
