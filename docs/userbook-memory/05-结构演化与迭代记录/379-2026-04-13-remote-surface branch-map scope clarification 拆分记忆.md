# remote-surface branch-map scope clarification 拆分记忆

## 本轮继续深入的核心判断

在当前 worktree 已经补完：

- `212` 的 remote-recovery branch map scope guard
- `213` 的 dual-trunk + zoom scope guard

之后，

当前最自然的下一刀，

不是回去补 `128-132` 的 leaf 页，

而是继续把：

- `214-4001 contract、surface presence、status ledger 与 front-state consumer topology：为什么 128、129、130、131、132 不是线性五连，而是两段延伸加一个后继根页.md`

自己的页首主语也收紧成一句。

## 为什么这轮值得单独提交

### 判断一：当前缺口不在“214 有没有画出两段延伸加一个后继根页”，而在“214 会不会把 branch map、leaf 主语与局部状态/账本对象写成同一层”

`214` 正文已经把这些结构关系讲出来了：

- `128/129` 仍在 transport contract 与 recovery ownership 这条线上
- `130/131` 已经切到 presence signer 与 status ledger 这条线上
- `132` 再把主语抬升成 front-state consumer topology

但如果读者在进入第一性原理前，

还没先被明确提醒：

- 这里不是在重讲 `128/129/130/131/132` 各页自己的页内证明
- 这里也不该把 `4001`、`viewerOnly`、`remoteSessionUrl`、brief line、`remoteConnectionStatus`、`remoteBackgroundTaskCount`、`worker_status`、`external_metadata` 这些局部对象和 helper / state 名重新抬成总纲主角

就仍然很容易把：

- contract owner
- recovery ownership
- surface presence
- status ledger
- front-state consumer topology

重新压回一句：

- “这一组页只是从 transport error 一路细化到 remote UI 厚度”

所以这一刀真正补的，

不是更多结构事实，

而是范围声明。

### 判断二：这句必须同时点出 branch map、contract layer 与 state-evidence 三层

本地复核已经指向同一个风险：

- `214` 现在最容易把“图上关系”和“图里各页局部证明对象”压成一层

如果只写：

- “这里只讲 remote surface branch map”

还不够稳，

因为读者仍可能把三层对象写平：

- map layer：
  - `128/129` 第一段延伸
  - `130/131` 第二段延伸
  - `132` 后继根页
- contract layer：
  - stable user contract
  - conditional visibility / host gates
  - gray implementation evidence
- evidence layer：
  - `4001`
  - `viewerOnly`
  - `remoteSessionUrl`
  - brief line
  - `remoteConnectionStatus`
  - `remoteBackgroundTaskCount`
  - `worker_status`
  - `external_metadata`

所以当前最稳的说法必须同时说明：

- 本页主语是跨页 branch map 与合同分层
- 各页页内主语仍留在各自 leaf page
- helper / state / ledger 名只作 evidence，不再升格成 `214` 的总纲主角

## 这轮具体怎么拆

这轮只做一件事：

1. 在 `214-...两段延伸加一个后继根页...md`
   的导语和第一性原理之间，
   增加一句范围声明：
   - 本页不重讲 `128/129/130/131/132` 各页自己的页内证明
   - 也不把 `4001`、`viewerOnly`、`remoteSessionUrl`、brief line、`remoteConnectionStatus`、`remoteBackgroundTaskCount`、`worker_status`、`external_metadata` 这些局部对象和 helper / state 名重新升级成新的总纲主角
   - 这里只整理跨页拓扑：`128/129` 一段延伸，`130/131` 一段延伸，`132` 一个后继根页
   - 并把稳定用户合同、条件性可见合同与灰度实现证据分层
   - 防止把 leaf-level 的 code contract、surface presence、ledger writer 或 runtime-state consumer 写成一条从 transport 走到 UI 的连续细化链

这样：

- `214`
  就能和 `208-213` 保持同一种 structure-page 节奏
- `214`
  不再像一页“把 128-132 的 leaf proof 再总述一次”的后设摘要
- 后面如果继续去 `215/216/217` 那簇 remote surface / runtime topology 的后继结构，
  这一页也能更稳地停在 `128-132` 这一层

## 苏格拉底式自审

### 问：为什么这轮不是回去补 130 或 132？

答：因为 `128-132` 的 leaf 页已经各自成立。当前真正缺的是 `214` 自己还没在页首把“branch map，不重讲 leaf proof”写成一句。

### 问：为什么 `214` 还需要 scope guard，正文不是已经在讲结构图了吗？

答：因为当前风险不在正文有没有图，而在读者进入图之前，仍会先把这页误听成“把 remote surface / status / topology 的 leaf 证明再复述一次”。范围声明要先把这条误听切掉。

### 问：为什么这句要显式点名 `4001`、`viewerOnly`、`remoteSessionUrl`、brief line、`remoteConnectionStatus`、`remoteBackgroundTaskCount`、`worker_status`、`external_metadata`？

答：因为 `214` 最容易在总纲里重新抬高这些局部对象，导致 stable / conditional / gray 三层再次串层。先把它们降回 evidence，后文的分层才真正稳。

### 问：为什么这句还要同时提 stable / conditional / gray 三层？

答：因为 `214` 的职责不只是画树，还要告诉读者“哪些判断属于这簇页面的稳定层级关系，哪些只是宿主条件或局部实现证据”。如果不先点这三层，拓扑页就会重新塌成一页宽泛综述。
