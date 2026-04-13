# remote-recovery branch-map scope clarification 拆分记忆

## 本轮继续深入的核心判断

在当前 worktree 快进到最新 `main` 之后，

`208-211`

这一串结构页的页首主语已经都补过一轮。

这时再回到：

- `212-remote recovery、viewer ownership、transport terminality 与 compaction contract：为什么 122、123、124、125、126、127 不是一条 recovery 后续链.md`

最值钱的继续深入，

不是回头补 `122-127` 的 leaf 页，

而是把 `212` 自己也补成同样的 structure-page scope guard。

## 为什么这轮值得单独提交

### 判断一：当前缺口不在“212 有没有画出 122-127 的关系”，而在“212 会不会把 branch map、leaf 主语与局部 helper / 常量证据写成同一层”

`212` 正文已经把这些关系讲出来了：

- `122` 是 owner-side recovery 根页
- `123` 是 ownership 侧枝
- `124` 是 signer / proof zoom
- `125` 是 transport authority 的降层根页
- `126` 与 `127` 从 `125` 分到 terminality 与 compaction 两侧
- 稳定用户合同、条件性可见合同与灰度实现证据也已经在正文后段分层

但如果读者在进入第一性原理前，

还没先被明确提醒：

- 这里不是在重讲 `122-127` 各页自己的页内证明
- 这里也不该把 watchdog、warning、`viewerOnly`、`remoteConnectionStatus`、`handleClose(...)`、`PERMANENT_CLOSE_CODES`、`4001`、`COMPACTION_TIMEOUT_MS` 这些局部对象和 helper / 常量名重新抬成总纲主角

就仍然很容易把：

- owner-side recovery
- ownership scope
- signer / proof
- transport authority
- terminality
- compaction

重新压回一句：

- “这一组页都在讲 remote recovery，只是往下越讲越细”

所以这一刀真正补的，

不是更多结构事实，

而是范围声明。

### 判断二：这句必须同时点出 branch map、contract layer 与 helper-evidence 三层

本地复核和现有记忆都在指向同一个风险：

- `212` 现在最容易把“图上关系”和“图里各页局部证明对象”压成一层

如果只写：

- “这里只讲 remote recovery branch map”

还不够稳，

因为读者仍可能把三层对象写平：

- map layer：
  - `122` 根页
  - `123` 侧枝
  - `124` zoom
  - `125` 降层根页
  - `126/127` 双枝
- contract layer：
  - stable user contract
  - conditional visibility / host gates
  - gray implementation evidence
- evidence layer：
  - watchdog / warning
  - `viewerOnly`
  - `remoteConnectionStatus`
  - `handleClose(...)`
  - `PERMANENT_CLOSE_CODES`
  - `4001`
  - `COMPACTION_TIMEOUT_MS`

所以当前最稳的说法必须同时说明：

- 本页主语是跨页 branch map 与合同分层
- 各页页内主语仍留在各自 leaf page
- helper / gate / constant / side-effect 名只作 evidence，不再升格成 `212` 的总纲主角

## 这轮具体怎么拆

这轮只做一件事：

1. 在 `212-...remote recovery...md`
   的导语和第一性原理之间，
   增加一句范围声明：
   - 本页不重讲 `122/123/124/125/126/127` 各页自己的页内证明
   - 也不把 watchdog、warning、`viewerOnly`、`remoteConnectionStatus`、`handleClose(...)`、`PERMANENT_CLOSE_CODES`、`4001`、`COMPACTION_TIMEOUT_MS` 这些局部对象和 helper / 常量名重新升级成新的总纲主角
   - 这里只整理跨页拓扑：122 根页、123 侧枝、124 zoom、125 降层根页、126/127 双枝
   - 并把稳定用户合同、条件性可见合同与灰度实现证据分层
   - 防止把 leaf-level 的 recovery edge、ownership gate、stop rule 或 compaction 信号写成整簇页面的统一运行时结论

这样：

- `212`
  就能和 `208/209/210/211` 保持同一种 structure-page 节奏
- `212`
  不再像一页“把 122-127 的 leaf proof 再总述一次”的后设摘要
- 后面如果继续去 `213/214` 那簇更细的双主干 / cross-transport 分页，
  这一页也能更稳地停在 remote-recovery 这一层

## 苏格拉底式自审

### 问：为什么这轮不是回去补 122 或 126？

答：因为 `122-127` 的 leaf 页已经各自成立。当前真正缺的是 `212` 自己还没在页首把“branch map，不重讲 leaf proof”写成一句。

### 问：为什么 `212` 还需要 scope guard，正文不是已经在讲结构图了吗？

答：因为当前风险不在正文有没有图，而在读者进入图之前，仍会先把这页误听成“把 remote recovery 的 leaf 证明再复述一次”。范围声明要先把这条误听切掉。

### 问：为什么这句要显式点名 watchdog、warning、`viewerOnly`、`remoteConnectionStatus`、`handleClose(...)`、`PERMANENT_CLOSE_CODES`、`4001`、`COMPACTION_TIMEOUT_MS`？

答：因为 `212` 最容易在总纲里重新抬高这些局部对象，导致 stable / conditional / gray 三层再次串层。先把它们降回 evidence，后文的分层才真正稳。

### 问：为什么这句还要同时提 stable / conditional / gray 三层？

答：因为 `212` 的职责不只是画树，还要告诉读者“哪些判断属于这簇页面的稳定层级关系，哪些只是宿主条件或局部实现证据”。如果不先点这三层，拓扑页就会重新塌成一页宽泛综述。
