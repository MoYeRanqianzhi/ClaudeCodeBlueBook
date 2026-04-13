# builder-callback-ui branch-map scope clarification 拆分记忆

## 本轮继续深入的核心判断

在上一刀已经把：

- `209-post_turn_summary、StdoutMessage、SDKMessage、stream-json raw wire 与 streamlined_*：为什么 105、106、108、109、110 不是并列尾页，而是从 wider-wire visibility 分叉出去的四种后继问题.md`

补成：

- `209` 只抓 wider-wire visibility 的 branch map 与合同分层

之后，

当前更自然的下一刀，

不是回去补 `111-115` 的单页，

而是回到：

- `210-builder transport、callback surface、streamlined dual-entry 与 UI consumer policy：为什么 111、112、113、114、115 不是并列细页，而是先定四层可见性表，再分叉到 streamlined 与 adapter 两条后继线.md`

把这一页自己的主语再收紧一句。

## 为什么这轮值得单独提交

### 判断一：当前缺口不在“210 有没有画出两条支线”，而在“210 会不会把 branch map、leaf 主语与局部 helper / policy 证据写成同一层”

`210` 正文现在已经把这些关系讲出来了：

- `111` 是四层可见性表的根页
- `112→113` 是 streamlined 支线
- `114→115` 是 adapter / UI consumer 支线
- stable / conditional / gray 的总分层也已经写在正文前段

但如果读者在进入正文前，

还没先被明确提醒：

- 这里不是在重讲 `111-115` 各页自己的页内证明
- 这里也不该把 `builder transport`、callback surface、`streamlined_*`、adapter triad、hook sink、`convertSDKMessage(...)` 这些局部对象与 helper 名重新抬成总纲主角

就仍然很容易把：

- 四层可见性表
- streamlined dual-entry / passthrough / suppression
- callback-visible vs adapter triad vs hook sink
- adapter 内部不同 UI policy

重新压回一句：

- “这些页都在讲 callback、adapter 和 streamlined，只是分几个场景说明”

所以这一刀真正补的，

不是更多结构事实，

而是范围声明。

### 判断二：这句必须同时点出 branch map、contract layer 与 helper-evidence 三层

本地复核与旧记忆都在指向同一个风险：

- `210` 现在最容易把“图上关系”和“图里各页局部证明对象”压成一层

如果只写：

- “这里只讲 builder-callback-UI branch map”

还不够稳，

因为读者仍可能把三层对象写平：

- map layer：
  - `111` 根页
  - `112→113` streamlined 支线
  - `114→115` adapter / UI consumer 支线
- contract layer：
  - stable user contract
  - conditional visibility / host gates
  - gray implementation evidence
- evidence layer：
  - `streamlined_*`
  - adapter triad
  - hook sink
  - `convertSDKMessage(...)`
  - host-specific wiring / option / helper 顺序

所以当前最稳的说法必须同时说明：

- 本页主语是跨页 branch map 与合同分层
- 各页页内主语仍留在各自 leaf page
- helper / policy / host wiring 只作 evidence，不再升格成 `210` 的总纲主角

## 这轮具体怎么拆

这轮只做一件事：

1. 在 `210-...builder-callback-ui...md`
   的导语段落里，
   增加一句范围声明：
   - 本页不重讲 `111/112/113/114/115` 各页自己的页内证明
   - 也不把 `builder transport`、callback surface、`streamlined_*`、adapter triad、hook sink、`convertSDKMessage(...)` 这些局部对象和 helper 名重新升级成新的总纲主角
   - 这里只整理跨页拓扑：111 根页，`112→113` streamlined 支线，`114→115` adapter / UI consumer 支线
   - 并把稳定用户合同、条件性可见合同与灰度实现证据分层
   - 防止把 leaf-level dual-entry、passthrough reason、adapter policy 或 host wiring 写成整簇页面的统一运行时结论

这样：

- `210`
  就能和 `208/209` 保持同一种 structure-page 节奏
- `210`
  不再像一页“把 111-115 的 leaf proof 再总述一次”的后设摘要
- 后面如果继续去 `211` 那簇 completion/init/replay 的后继结构页，
  这一页也能更稳地停在 builder-callback-UI 这一层

## 苏格拉底式自审

### 问：为什么这轮不是回去补 112 或 114？

答：因为 `111-115` 的 leaf 页已经各自成立。当前真正缺的是 `210` 自己还没在页首把“branch map，不重讲 leaf proof”写成一句。

### 问：为什么 `210` 还需要 scope guard，正文不是已经在讲结构图了吗？

答：因为当前风险不在正文有没有图，而在读者进入图之前，仍会先把这页误听成“把 callback、adapter、streamlined 的局部证明再复述一次”。范围声明要先把这条误听切掉。

### 问：为什么这句要显式点名 `builder transport`、callback surface、`streamlined_*`、adapter triad、hook sink、`convertSDKMessage(...)`？

答：因为 `210` 最容易在总纲里重新抬高这些局部对象，导致 stable / conditional / gray 三层再次串层。先把它们降回 evidence，后文的分层才真正稳。

### 问：为什么这句还要同时提 stable / conditional / gray 三层？

答：因为 `210` 的职责不只是画树，还要告诉读者“哪些判断属于这簇页面的稳定层级关系，哪些只是宿主条件或局部实现证据”。如果不先点这三层，拓扑页就会重新塌成一页宽泛综述。
