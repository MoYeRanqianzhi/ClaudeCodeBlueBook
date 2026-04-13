# shell-pair branch-map scope clarification 拆分记忆

## 本轮继续深入的核心判断

在当前 worktree 已经补完：

- `216` 的 remote-truth branch-map scope guard

之后，

当前最自然的下一刀，

不是回去补 `144-149` 的 leaf 页，

而是继续把：

- `217-session pane、command shell 与 headless remote memory：为什么 144、145、146、147、148、149 不是线性六连，而是从 143 分出去的三组相邻配对.md`

自己的页首主语也收紧成一句。

## 为什么这轮值得单独提交

### 判断一：当前缺口不在“217 有没有画出三组相邻配对”，而在“217 会不会把 branch map、leaf 主语与局部 helper / env / state 证据写成同一层”

`217` 正文已经把这些结构关系讲出来了：

- `144→145` 是 `/session` pane 与 URL affordance 这一对
- `146→147` 是 coarse remote 合同厚度与 remote-safe command shell 这一对
- `148→149` 是 env-driven remote 轴与 memory persistence 这一对

但如果读者在进入第一性原理前，

还没先被明确提醒：

- 这里不是在重讲 `144/145/146/147/148/149` 各页自己的页内证明
- 这里也不该把 `getIsRemoteMode()`、`remoteSessionUrl`、`REMOTE_SAFE_COMMANDS`、`filterCommandsForRemoteMode(...)`、`CLAUDE_CODE_REMOTE`、`CLAUDE_CODE_REMOTE_MEMORY_DIR` 这些局部对象和 helper / env / state 名重新抬成总纲主角

就仍然很容易把：

- pane gate / URL affordance
- remote-safe command shell
- env-driven remote persistence

重新压回一句：

- “这一组页只是 143 那个 coarse remote bit 往后顺着编号展开的六连页”

所以这一刀真正补的，

不是更多结构事实，

而是范围声明。

### 判断二：这句必须同时点出 branch map、contract layer 与 helper-evidence 三层

本地复核与 `219` 记忆都在指向同一个风险：

- `217` 现在最容易把“图上关系”和“图里各页局部证明对象”压成一层

如果只写：

- “这里只讲三组相邻配对”

还不够稳，

因为读者仍可能把三层对象写平：

- map layer：
  - `144→145` 第一组配对
  - `146→147` 第二组配对
  - `148→149` 第三组配对
- contract layer：
  - stable user contract
  - conditional visibility / host gates
  - gray implementation evidence
- evidence layer：
  - `getIsRemoteMode()`
  - `remoteSessionUrl`
  - `REMOTE_SAFE_COMMANDS`
  - `filterCommandsForRemoteMode(...)`
  - `CLAUDE_CODE_REMOTE`
  - `CLAUDE_CODE_REMOTE_MEMORY_DIR`

所以当前最稳的说法必须同时说明：

- 本页主语是跨页 branch map 与合同分层
- 各页页内主语仍留在各自 leaf page
- helper / env / state 名只作 evidence，不再升格成 `217` 的总纲主角

## 这轮具体怎么拆

这轮只做一件事：

1. 在 `217-...三组相邻配对...md`
   的导语和第一性原理之间，
   增加一句范围声明：
   - 本页不重讲 `144/145/146/147/148/149` 各页自己的页内证明
   - 也不把 `getIsRemoteMode()`、`remoteSessionUrl`、`REMOTE_SAFE_COMMANDS`、`filterCommandsForRemoteMode(...)`、`CLAUDE_CODE_REMOTE`、`CLAUDE_CODE_REMOTE_MEMORY_DIR` 这些局部对象和 helper / env / state 名重新升级成新的总纲主角
   - 这里只整理三组配对：`144→145`、`146→147`、`148→149`
   - 并把稳定用户合同、条件性可见合同与灰度实现证据分层
   - 防止把 leaf-level 的 pane gate、URL 缺席、safe command、env bit 或 remote memory 证明写成一条从 143 顺编号展开的连续链

这样：

- `217`
  就能和 `208-216` 保持同一种 structure-page 节奏
- `217`
  不再像一页“把 144-149 的 leaf proof 再总述一次”的后设摘要
- 后面如果继续去 `218/219` 那簇 remote shell / behavior / memory 的后继结构，
  这一页也能更稳地停在 `144-149` 这一层

## 苏格拉底式自审

### 问：为什么这轮不是回去补 145 或 149？

答：因为 `144-149` 的 leaf 页已经各自成立。当前真正缺的是 `217` 自己还没在页首把“三组相邻配对，不重讲 leaf proof”写成一句。

### 问：为什么 `217` 还需要 scope guard，正文不是已经在讲结构图了吗？

答：因为当前风险不在正文有没有图，而在读者进入图之前，仍会先把这页误听成“把 session pane、command shell、headless remote memory 的 leaf 证明再复述一次”。范围声明要先把这条误听切掉。

### 问：为什么这句要显式点名 `getIsRemoteMode()`、`remoteSessionUrl`、`REMOTE_SAFE_COMMANDS`、`filterCommandsForRemoteMode(...)`、`CLAUDE_CODE_REMOTE`、`CLAUDE_CODE_REMOTE_MEMORY_DIR`？

答：因为 `217` 最容易在总纲里重新抬高这些局部对象，导致 stable / conditional / gray 三层再次串层。先把它们降回 evidence，后文的分层才真正稳。

### 问：为什么这句还要同时提 stable / conditional / gray 三层？

答：因为 `217` 的职责不只是画树，还要告诉读者“哪些判断属于这簇页面的稳定层级关系，哪些只是宿主条件或局部实现证据”。如果不先点这三层，拓扑页就会重新塌成一页宽泛综述。
