# dual-trunk zoom-map scope clarification 拆分记忆

## 本轮继续深入的核心判断

在最新 `main` 已吸收早期 `userbook` 历史、当前 worktree 又补完：

- `212-remote recovery、viewer ownership、transport terminality 与 compaction contract：为什么 122、123、124、125、126、127 不是一条 recovery 后续链.md`

的页首范围声明之后，

当前更值钱的下一刀，

不是回头补 `122-127` 的单页，

而是继续把：

- `213-owner-side recovery、transport stop rule 与 compaction boundary：为什么 122、123、124、125、126、127 不是线性六连，而是双主干加两个 zoom.md`

自己的页首主语也收紧成一句。

## 为什么这轮值得单独提交

### 判断一：当前缺口不在“213 有没有把 122-127 写成双主干 + zoom”，而在“213 会不会把双主干拓扑、leaf 主语与局部 helper / 常量证据写成同一层”

`213` 正文已经把这些结构关系讲出来了：

- `122/123/124` 是 owner-side recovery / ownership / signer 这一主干
- `125/126/127` 是 transport / terminality / compaction 这一主干
- `124` 是 signer zoom
- `126` 是 terminality zoom
- `124 -> 125` 是真正的降层点

但如果读者在进入第一性原理前，

还没先被明确提醒：

- 这里不是在重讲 `122-127` 各页自己的页内证明
- 这里也不该把 watchdog、warning、`viewerOnly`、`remoteConnectionStatus`、`handleClose(...)`、`reconnect()`、`PERMANENT_CLOSE_CODES`、`4001`、`COMPACTION_TIMEOUT_MS` 这些局部对象和 helper / 常量名重新抬成总纲主角

就仍然很容易把：

- owner-side recovery / ownership / signer
- transport authority / terminality / compaction
- `124` 与 `126` 的 zoom 性质
- `124 -> 125` 的降层点

重新压回一句：

- “122-127 基本上还是同一张 recovery 表，只是一路往下细化”

所以这一刀真正补的，

不是更多结构事实，

而是范围声明。

### 判断二：这句必须同时点出 dual-trunk map、contract layer 与 helper-evidence 三层

本地复核和现有记忆都在指向同一个风险：

- `213` 现在最容易把“图上关系”和“图里各页局部证明对象”压成一层

如果只写：

- “这里只讲 dual-trunk + zoom map”

还不够稳，

因为读者仍可能把三层对象写平：

- map layer：
  - `122/123/124` 第一主干
  - `125/126/127` 第二主干
  - `124/126` 两个 zoom
  - `124 -> 125` 降层点
- contract layer：
  - stable user contract
  - conditional visibility / host gates
  - gray implementation evidence
- evidence layer：
  - watchdog / warning
  - `viewerOnly`
  - `remoteConnectionStatus`
  - `handleClose(...)`
  - `reconnect()`
  - `PERMANENT_CLOSE_CODES`
  - `4001`
  - `COMPACTION_TIMEOUT_MS`

所以当前最稳的说法必须同时说明：

- 本页主语是双主干阅读拓扑与合同分层
- 各页页内主语仍留在各自 leaf page
- helper / gate / constant / side-effect 名只作 evidence，不再升格成 `213` 的总纲主角

## 这轮具体怎么拆

这轮只做一件事：

1. 在 `213-...双主干加两个 zoom...md`
   的导语和第一性原理之间，
   增加一句范围声明：
   - 本页不重讲 `122/123/124/125/126/127` 各页自己的页内证明
   - 也不把 watchdog、warning、`viewerOnly`、`remoteConnectionStatus`、`handleClose(...)`、`reconnect()`、`PERMANENT_CLOSE_CODES`、`4001`、`COMPACTION_TIMEOUT_MS` 这些局部对象和 helper / 常量名重新升级成新的总纲主角
   - 这里只把 `212` 的 remote-recovery branch map 再收紧成“双主干 + 两个 zoom”的阅读拓扑
   - 并继续把稳定用户合同、条件性可见合同与灰度实现证据分层
   - 防止把 leaf-level 的 recovery edge、proof surface、stop rule 或 compaction marker 写成一条连续细化链

这样：

- `213`
  就能和 `208-212` 保持同一种 structure-page 节奏
- `213`
  不再像一页“把 122-127 的 leaf proof 再压缩复述一次”的后设摘要
- 后面如果继续去 `214` 那簇 `128-132` 的后继结构，
  这一页也能更稳地停在 dual-trunk + zoom 这一层

## 苏格拉底式自审

### 问：为什么这轮不是回去补 124 或 126？

答：因为 `122-127` 的 leaf 页已经各自成立。当前真正缺的是 `213` 自己还没在页首把“dual-trunk + zoom map，不重讲 leaf proof”写成一句。

### 问：为什么 `213` 还需要 scope guard，正文不是已经在讲双主干了吗？

答：因为当前风险不在正文有没有图，而在读者进入图之前，仍会先把这页误听成“把 remote recovery 的 leaf 证明再压缩复述一次”。范围声明要先把这条误听切掉。

### 问：为什么这句要显式点名 watchdog、warning、`viewerOnly`、`remoteConnectionStatus`、`handleClose(...)`、`reconnect()`、`PERMANENT_CLOSE_CODES`、`4001`、`COMPACTION_TIMEOUT_MS`？

答：因为 `213` 最容易在总纲里重新抬高这些局部对象，导致 stable / conditional / gray 三层再次串层。先把它们降回 evidence，后文的分层才真正稳。

### 问：为什么这句还要同时提 stable / conditional / gray 三层？

答：因为 `213` 的职责不只是画树，还要告诉读者“哪些判断属于双主干拓扑的稳定层级关系，哪些只是宿主条件或局部实现证据”。如果不先点这三层，拓扑页就会重新塌成一页宽泛综述。
