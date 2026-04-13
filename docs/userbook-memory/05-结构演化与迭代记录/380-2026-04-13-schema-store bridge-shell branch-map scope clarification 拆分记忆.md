# schema-store bridge-shell branch-map scope clarification 拆分记忆

## 本轮继续深入的核心判断

在当前 worktree 已经补完：

- `214` 的 remote-surface branch-map scope guard

之后，

当前最自然的下一刀，

不是回去补 `133-138` 的 leaf 页，

而是继续把：

- `215-schema/store consumer path、bridge chain split 与 remote interaction shell：为什么 133、134、135、136、137、138 不是线性六连，而是从 132 分出去的三条两步后继线.md`

自己的页首主语也收紧成一句。

## 为什么这轮值得单独提交

### 判断一：当前缺口不在“215 有没有画出三条两步后继线”，而在“215 会不会把 branch map、leaf 主语与局部 helper / state 证据写成同一层”

`215` 正文已经把这些结构关系讲出来了：

- `133→137` 这一条是 schema/store 到 cross-frontend consumer path
- `134→136` 这一条是 bridge chain 到 v2 active surface
- `135→138` 这一条是 foreground remote runtime 到 shared interaction shell
- `138` 还是后面 `141/142/143` 那组页的交接点

但如果读者在进入第一性原理前，

还没先被明确提醒：

- 这里不是在重讲 `133/134/135/136/137/138` 各页自己的页内证明
- 这里也不该把 `pending_action`、`post_turn_summary`、`task_summary`、`externalMetadataToAppState(...)`、`createV1ReplTransport`、`createV2ReplTransport`、`reportState`、`activeRemote`、`remoteSessionUrl` 这些局部对象和 helper / state 名重新抬成总纲主角

就仍然很容易把：

- schema/store producer
- cross-frontend consumer path
- bridge publish chain
- v2 active surface
- foreground remote runtime
- shared interaction shell

重新压回一句：

- “这一组页只是把 132 的 consumer topology 一路细化成六篇并列 remote 小文”

所以这一刀真正补的，

不是更多结构事实，

而是范围声明。

### 判断二：这句必须同时点出 branch map、contract layer 与 helper-evidence 三层

本地复核已经指向同一个风险：

- `215` 现在最容易把“图上关系”和“图里各页局部证明对象”压成一层

如果只写：

- “这里只讲 schema-store / bridge / shell branch map”

还不够稳，

因为读者仍可能把三层对象写平：

- map layer：
  - `133→137` 第一条后继线
  - `134→136` 第二条后继线
  - `135→138` 第三条后继线
- contract layer：
  - stable user contract
  - conditional visibility / host gates
  - gray implementation evidence
- evidence layer：
  - `pending_action`
  - `post_turn_summary`
  - `task_summary`
  - `externalMetadataToAppState(...)`
  - `createV1ReplTransport`
  - `createV2ReplTransport`
  - `reportState`
  - `activeRemote`
  - `remoteSessionUrl`

所以当前最稳的说法必须同时说明：

- 本页主语是跨页 branch map 与合同分层
- 各页页内主语仍留在各自 leaf page
- helper / state / ledger 名只作 evidence，不再升格成 `215` 的总纲主角

## 这轮具体怎么拆

这轮只做一件事：

1. 在 `215-...三条两步后继线...md`
   的导语和第一性原理之间，
   增加一句范围声明：
   - 本页不重讲 `133/134/135/136/137/138` 各页自己的页内证明
   - 也不把 `pending_action`、`post_turn_summary`、`task_summary`、`externalMetadataToAppState(...)`、`createV1ReplTransport`、`createV2ReplTransport`、`reportState`、`activeRemote`、`remoteSessionUrl` 这些局部对象和 helper / state 名重新升级成新的总纲主角
   - 这里只整理三条后继线：`133→137`、`134→136`、`135→138`
   - 并把稳定用户合同、条件性可见合同与灰度实现证据分层
   - 防止把 leaf-level 的 metadata producer、bridge publish chain、runtime 壳或 remote presence 证明写成一条从 132 一路细化的连续链

这样：

- `215`
  就能和 `208-214` 保持同一种 structure-page 节奏
- `215`
  不再像一页“把 133-138 的 leaf proof 再总述一次”的后设摘要
- 后面如果继续去 `216/217` 那簇 visibility / shell / remote bit 的后继结构，
  这一页也能更稳地停在 `133-138` 这一层

## 苏格拉底式自审

### 问：为什么这轮不是回去补 133 或 138？

答：因为 `133-138` 的 leaf 页已经各自成立。当前真正缺的是 `215` 自己还没在页首把“三条两步后继线，不重讲 leaf proof”写成一句。

### 问：为什么 `215` 还需要 scope guard，正文不是已经在讲结构图了吗？

答：因为当前风险不在正文有没有图，而在读者进入图之前，仍会先把这页误听成“把 schema/store、bridge、remote shell 的 leaf 证明再复述一次”。范围声明要先把这条误听切掉。

### 问：为什么这句要显式点名 `pending_action`、`post_turn_summary`、`task_summary`、`externalMetadataToAppState(...)`、`createV1ReplTransport`、`createV2ReplTransport`、`reportState`、`activeRemote`、`remoteSessionUrl`？

答：因为 `215` 最容易在总纲里重新抬高这些局部对象，导致 stable / conditional / gray 三层再次串层。先把它们降回 evidence，后文的分层才真正稳。

### 问：为什么这句还要同时提 stable / conditional / gray 三层？

答：因为 `215` 的职责不只是画树，还要告诉读者“哪些判断属于这簇页面的稳定层级关系，哪些只是宿主条件或局部实现证据”。如果不先点这三层，拓扑页就会重新塌成一页宽泛综述。
