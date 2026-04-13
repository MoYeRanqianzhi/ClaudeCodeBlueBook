# remote-truth branch-map scope clarification 拆分记忆

## 本轮继续深入的核心判断

在当前 worktree 已经补完：

- `215` 的 schema-store / bridge-shell branch-map scope guard

之后，

当前最自然的下一刀，

不是回去补 `139-143` 的 leaf 页，

而是继续把：

- `216-post_turn_summary visibility、mirror gray runtime、remote-session ledger 与 global remote bit：为什么 139、140、141、142、143 不是线性五连，而是接在三条后继线上的三组问题.md`

自己的页首主语也收紧成一句。

## 为什么这轮值得单独提交

### 判断一：当前缺口不在“216 有没有把 139-143 分成三组问题”，而在“216 会不会把 branch map、leaf 主语与局部 helper / state 证据写成同一层”

`216` 正文已经把这些结构关系讲出来了：

- `140` 接在 `133→137` 这条 consumer-boundary 线后面
- `139→142` 接在 `134→136` 这条 mirror/runtime 线后面
- `141/143` 接在 `138→204` 这条 interaction-shell / remote-trunk 线后面

但如果读者在进入第一性原理前，

还没先被明确提醒：

- 这里不是在重讲 `139/140/141/142/143` 各页自己的页内证明
- 这里也不该把 `post_turn_summary`、`ccrMirrorEnabled`、`outboundOnly`、`remoteSessionUrl`、`remoteConnectionStatus`、`remoteBackgroundTaskCount`、`getIsRemoteMode()` 这些局部对象和 helper / state 名重新抬成总纲主角

就仍然很容易把：

- visibility ladder
- mirror runtime topology
- gray runtime
- remote-session presence ledger
- global remote behavior bit

重新压回一句：

- “这一组页只是 remote 这条线往后继续展开的五篇顺序页”

所以这一刀真正补的，

不是更多结构事实，

而是范围声明。

### 判断二：这句必须同时点出 branch map、contract layer 与 helper-evidence 三层

本地复核和 `218` 记忆都在指向同一个风险：

- `216` 现在最容易把“图上关系”和“图里各页局部证明对象”压成一层

如果只写：

- “这里只讲 remote-truth branch map”

还不够稳，

因为读者仍可能把三层对象写平：

- map layer：
  - `140` 这条 visibility ladder zoom
  - `139→142` 这条 mirror/runtime 线
  - `141/143` 这条 ledger-truth / behavior-bit truth 线
- contract layer：
  - stable user contract
  - conditional visibility / host gates
  - gray implementation evidence
- evidence layer：
  - `post_turn_summary`
  - `ccrMirrorEnabled`
  - `outboundOnly`
  - `remoteSessionUrl`
  - `remoteConnectionStatus`
  - `remoteBackgroundTaskCount`
  - `getIsRemoteMode()`

所以当前最稳的说法必须同时说明：

- 本页主语是跨页 branch map 与合同分层
- 各页页内主语仍留在各自 leaf page
- helper / state / ledger 名只作 evidence，不再升格成 `216` 的总纲主角

## 这轮具体怎么拆

这轮只做一件事：

1. 在 `216-...三组问题...md`
   的导语和第一性原理之间，
   增加一句范围声明：
   - 本页不重讲 `139/140/141/142/143` 各页自己的页内证明
   - 也不把 `post_turn_summary`、`ccrMirrorEnabled`、`outboundOnly`、`remoteSessionUrl`、`remoteConnectionStatus`、`remoteBackgroundTaskCount`、`getIsRemoteMode()` 这些局部对象和 helper / state 名重新升级成新的总纲主角
   - 这里只整理跨页拓扑：`140` 接在 `133→137`，`139→142` 接在 `134→136`，`141/143` 接在 `138→204`
   - 并把稳定用户合同、条件性可见合同与灰度实现证据分层
   - 防止把 leaf-level 的 visibility ladder、mirror gray runtime、presence ledger 或 global bit 证明写成一条从 remote 词域顺编号展开的连续链

这样：

- `216`
  就能和 `208-215` 保持同一种 structure-page 节奏
- `216`
  不再像一页“把 139-143 的 leaf proof 再总述一次”的后设摘要
- 后面如果继续去 `217/204` 那簇 remote shell / behavior / presence 的后继结构，
  这一页也能更稳地停在 `139-143` 这一层

## 苏格拉底式自审

### 问：为什么这轮不是回去补 140 或 143？

答：因为 `139-143` 的 leaf 页已经各自成立。当前真正缺的是 `216` 自己还没在页首把“三组后继问题，不重讲 leaf proof”写成一句。

### 问：为什么 `216` 还需要 scope guard，正文不是已经在讲结构图了吗？

答：因为当前风险不在正文有没有图，而在读者进入图之前，仍会先把这页误听成“把 post_turn_summary / mirror / remote truth 的 leaf 证明再复述一次”。范围声明要先把这条误听切掉。

### 问：为什么这句要显式点名 `post_turn_summary`、`ccrMirrorEnabled`、`outboundOnly`、`remoteSessionUrl`、`remoteConnectionStatus`、`remoteBackgroundTaskCount`、`getIsRemoteMode()`？

答：因为 `216` 最容易在总纲里重新抬高这些局部对象，导致 stable / conditional / gray 三层再次串层。先把它们降回 evidence，后文的分层才真正稳。

### 问：为什么这句还要同时提 stable / conditional / gray 三层？

答：因为 `216` 的职责不只是画树，还要告诉读者“哪些判断属于这簇页面的稳定层级关系，哪些只是宿主条件或局部实现证据”。如果不先点这三层，拓扑页就会重新塌成一页宽泛综述。
