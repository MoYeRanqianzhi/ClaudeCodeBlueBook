# headless-subtree branch-map scope clarification 拆分记忆

## 本轮继续深入的核心判断

在当前 worktree 已经补完：

- `217` 的 shell-pair branch-map scope guard

之后，

当前最自然的下一刀，

不是回去补 `168-179` 的 leaf 页，

而是继续把：

- `218-headless source、bridge authority 与 create-context 子树：为什么 168-179 不是线性十二连.md`

自己的页首主语也收紧成一句。

## 为什么这轮值得单独提交

### 判断一：当前缺口不在“218 有没有把 168-179 收成子树”，而在“218 会不会把 branch map、source / authority 主语与局部 helper / field 证据写成同一层”

`218` 正文已经把这些结构关系讲出来了：

- `168` 是贴着 `169` 的 thickness 前置轴
- `169` 是 continuation-source 根页
- `170 -> 171` 是 headless source certainty / local artifact provenance 分支
- `172 -> 173 -> 174` 是 bridge continuity authority / environment truth 主干
- `175/176 -> 177` 是挂在 `174` 下的 provenance / createSession 交叉 zoom
- `176 -> 178 -> 179` 是 `session_context` / git-context 子支

但如果读者在进入第一性原理前，

还没先被明确提醒：

- 这里不是在重讲 `168/169/170/171/172/173/174/175/176/177/178/179` 各页自己的页内证明
- 这里也不该把 `StructuredIO`、`RemoteIO`、`loadConversationForResume(...)`、`readBridgePointerAcrossWorktrees(...)`、`BridgePointer.environmentId`、`registerBridgeEnvironment(...)`、`createBridgeSession(...)`、`session_context` 这些局部 helper / field / type 名重新抬成总纲主角

就仍然很容易把：

- protocol thickness
- continuation source
- bridge continuity authority
- environment truth / provenance
- createSession field authority
- `session_context` / git-context

重新压回一句：

- “这一组页只是从 headless resume 一路走到 bridge context 的线性十二连”

所以这一刀真正补的，

不是更多结构事实，

而是范围声明。

### 判断二：这句必须同时点出 branch map、source-authority layer 与 field-evidence 三层

本地复核和 `220` 记忆都在指向同一个风险：

- `218` 现在最容易把“图上关系”和“图里各页局部证明对象”压成一层

如果只写：

- “这里只讲 headless source 与 create-context 子树”

还不够稳，

因为读者仍可能把三层对象写平：

- map layer：
  - `168` 邻接前置轴
  - `169` source 根页
  - `170 -> 171` print-source 分支
  - `172 -> 173 -> 174 -> (175 / 176 -> 177)` bridge authority / createSession 区域
  - `176 -> 178 -> 179` `session_context` / git-context 子支
- source-authority layer：
  - stable conversation baseline
  - conditional headless source certainty
  - bridge pointer continuity authority
  - environment truth / provenance taxonomy
  - createSession field authority
- evidence layer：
  - `StructuredIO`
  - `RemoteIO`
  - `loadConversationForResume(...)`
  - `readBridgePointerAcrossWorktrees(...)`
  - `BridgePointer.environmentId`
  - `registerBridgeEnvironment(...)`
  - `createBridgeSession(...)`
  - `session_context`

所以当前最稳的说法必须同时说明：

- 本页主语是跨页 branch map 与 source / authority 分层
- 各页页内主语仍留在各自 leaf page
- helper / field / type 名只作 evidence，不再升格成 `218` 的总纲主角

## 这轮具体怎么拆

这轮只做一件事：

1. 在 `218-...不是线性十二连.md`
   的导语和第一性原理之间，
   增加一句范围声明：
   - 本页不重讲 `168/169/170/171/172/173/174/175/176/177/178/179` 各页自己的页内证明
   - 也不把 `StructuredIO`、`RemoteIO`、`loadConversationForResume(...)`、`readBridgePointerAcrossWorktrees(...)`、`BridgePointer.environmentId`、`registerBridgeEnvironment(...)`、`createBridgeSession(...)`、`session_context` 这些局部 helper / field / type 名重新升级成新的总纲主角
   - 这里只整理跨页拓扑：`168` 是邻接前置轴，`169` 是 source 根页，`170 -> 171` 是 headless source 分支，`172 -> 173 -> 174` 是 bridge authority 主干，`175/176 -> 177` 是 `174` 下的 zoom 区域，`176 -> 178 -> 179` 是 `session_context` / git-context 子支
   - 并把 stable continuation 基准项、条件性 source / authority 分支与局部 field-evidence 分层
   - 防止把 leaf-level 的 protocol thickness、source certainty、env truth、provenance label、createSession field 或 `session_context` 证明写成一条从 `168` 顺编号展开的连续链

这样：

- `218`
  就能和 `208-217` 保持同一种 structure-page 节奏
- `218`
  不再像一页“把 168-179 的 leaf proof 再总述一次”的后设摘要
- 后面如果继续去 `172-179` 那簇 bridge authority / create-context 的后继结构，
  这一页也能更稳地停在 `168-179` 这一层

## 苏格拉底式自审

### 问：为什么这轮不是回去补 170 或 176？

答：因为 `168-179` 的 leaf 页已经各自成立。当前真正缺的是 `218` 自己还没在页首把“邻接前置轴 + 两条接续分支 + create-context 子树，不重讲 leaf proof”写成一句。

### 问：为什么 `218` 还需要 scope guard，正文不是已经在讲树形结构了吗？

答：因为当前风险不在正文有没有树，而在读者进入树之前，仍会先把这页误听成“把 headless source / bridge authority / session_context 的 leaf 证明再复述一次”。范围声明要先把这条误听切掉。

### 问：为什么这句要显式点名 `StructuredIO`、`RemoteIO`、`loadConversationForResume(...)`、`readBridgePointerAcrossWorktrees(...)`、`BridgePointer.environmentId`、`registerBridgeEnvironment(...)`、`createBridgeSession(...)`、`session_context`？

答：因为 `218` 最容易在总纲里重新抬高这些局部对象，导致 source / authority / evidence 三层再次串层。先把它们降回 evidence，后文的分层才真正稳。

### 问：为什么这句还要同时提 stable continuation、conditional source / authority 与 field-evidence 三层？

答：因为 `218` 的职责不只是画树，还要告诉读者“哪些判断属于这簇页面的稳定层级关系，哪些只是条件性分支，哪些只是局部字段证据”。如果不先点这三层，拓扑页就会重新塌成一页宽泛综述。
