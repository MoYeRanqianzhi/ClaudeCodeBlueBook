# teleport-model-bridge branch-map scope clarification 拆分记忆

## 本轮继续深入的核心判断

在当前 worktree 已经补完：

- `217`、`218` 的 structure-page scope guard
- `05` 与 memory `README` 的第二层导航

之后，

当前最自然的下一刀，

不是回去补 `180-190` 的 leaf 页，

而是继续把：

- `219-teleport、model 与 bridge 分支：为什么 180-190 不是线性十一连.md`

自己的页首主语也收紧成一句。

## 为什么这轮值得单独提交

### 判断一：当前缺口不在“219 有没有画出三条后继线”，而在“219 会不会把 branch map、runtime contract 主语与局部 helper / transport 证据写成同一层”

`219` 正文已经把这些结构关系讲出来了：

- `178 -> 179 -> 180` 是 teleport runtime branch
- model line 分成 `178 -> 182` 的 ledger trunk 与 `184 -> 185 -> 187 -> 188` 的 selection / source / allowlist trunk
- bridge line 是 `176 -> 181 -> 183 -> 186 -> 189 -> 190` 的 outbound trunk
- `190 -> 191 -> {192, 193 -> 206}` 还是这条 bridge 线的前向 handoff

但如果读者在进入第一性原理前，

还没先被明确提醒：

- 这里不是在重讲 `180/181/182/183/184/185/186/187/188/189/190` 各页自己的页内证明
- 这里也不该把 `teleportToRemote(...)`、`writeBatch(...)`、`session_context.model`、`restoreAgentFromSession(...)`、`getUserSpecifiedModelSetting(...)`、`isModelAllowed(...)`、`flushHistory(...)`、`writeMessages(...)` 这些局部 helper / field / transport 名重新抬成总纲主角

就仍然很容易把：

- repo admission / branch replay
- model ledger / selection / source / allowlist
- bridge birth / hydrate / replay / write

重新压回一句：

- “这一组页只是从 teleport、model 再走到 bridge write 的线性十一连”

所以这一刀真正补的，

不是更多结构事实，

而是范围声明。

### 判断二：这句必须同时点出 branch map、runtime-contract layer 与 transport-evidence 三层

本地复核与 `221` 记忆都在指向同一个风险：

- `219` 现在最容易把“图上关系”和“图里各页局部证明对象”压成一层

如果只写：

- “这里只讲 teleport、model 与 bridge 三条后继线”

还不够稳，

因为读者仍可能把三层对象写平：

- map layer：
  - `178 -> 179 -> 180` teleport branch
  - `178 -> 182` model ledger trunk
  - `184 -> 185 -> 187 -> 188` model selection / allowlist trunk
  - `176 -> 181 -> 183 -> 186 -> 189 -> 190` bridge outbound trunk
  - `190 -> 191 -> {192, 193 -> 206}` bridge forward handoff
- runtime-contract layer：
  - teleport admission / replay contract
  - model ledger vs authority / source / veto contract
  - bridge birth / hydrate / replay / write contract
- evidence layer：
  - `teleportToRemote(...)`
  - `writeBatch(...)`
  - `session_context.model`
  - `restoreAgentFromSession(...)`
  - `getUserSpecifiedModelSetting(...)`
  - `isModelAllowed(...)`
  - `flushHistory(...)`
  - `writeMessages(...)`

所以当前最稳的说法必须同时说明：

- 本页主语是跨页 branch map 与 runtime-contract 分层
- 各页页内主语仍留在各自 leaf page
- helper / field / transport 名只作 evidence，不再升格成 `219` 的总纲主角

## 这轮具体怎么拆

这轮只做一件事：

1. 在 `219-...不是线性十一连.md`
   的导语和第一性原理之间，
   增加一句范围声明：
   - 本页不重讲 `180/181/182/183/184/185/186/187/188/189/190` 各页自己的页内证明
   - 也不把 `teleportToRemote(...)`、`writeBatch(...)`、`session_context.model`、`restoreAgentFromSession(...)`、`getUserSpecifiedModelSetting(...)`、`isModelAllowed(...)`、`flushHistory(...)`、`writeMessages(...)` 这些局部 helper / field / transport 名重新升级成新的总纲主角
   - 这里只整理跨页拓扑：`178 -> 179 -> 180` 是 teleport branch，model line 分成 `178 -> 182` 与 `184 -> 185 -> 187 -> 188` 两条 trunk，bridge line 是 `176 -> 181 -> 183 -> 186 -> 189 -> 190`
   - 并把 stable runtime contract、条件性 model / bridge authority 分支与局部 transport-evidence 分层
   - 同时保留 `190 -> 191 -> {192, 193 -> 206}` 的前向 handoff，不把 `190` 误写成 bridge terminal
   - 防止把 leaf-level 的 repo admission、history hydrate、model ledger、allowlist veto 或 bridge write 证明写成一条从 `180` 顺编号展开的连续链

这样：

- `219`
  就能和 `216-218` 保持同一种 structure-page 节奏
- `219`
  不再像一页“把 180-190 的 leaf proof 再总述一次”的后设摘要
- 后面如果继续推进 `191 -> {192, 193 -> 206}` 那簇 bridge ingress / control / blocked-state 的后继结构，
  这一页也能更稳地停在 `180-190` 这一层

## 苏格拉底式自审

### 问：为什么这轮不是回去补 184 或 190？

答：因为 `180-190` 的 leaf 页已经各自成立。当前真正缺的是 `219` 自己还没在页首把“三条后继线，不重讲 leaf proof”写成一句。

### 问：为什么 `219` 还需要 scope guard，正文不是已经在讲三条线了吗？

答：因为当前风险不在正文有没有图，而在读者进入图之前，仍会先把这页误听成“把 teleport / model / bridge 的 leaf 证明再复述一次”。范围声明要先把这条误听切掉。

### 问：为什么这句要显式点名 `teleportToRemote(...)`、`writeBatch(...)`、`session_context.model`、`restoreAgentFromSession(...)`、`getUserSpecifiedModelSetting(...)`、`isModelAllowed(...)`、`flushHistory(...)`、`writeMessages(...)`？

答：因为 `219` 最容易在总纲里重新抬高这些局部对象，导致 runtime contract / authority / evidence 三层再次串层。先把它们降回 evidence，后文的分层才真正稳。

### 问：为什么这句还要显式保留 `190 -> 191 -> {192, 193 -> 206}` 的 handoff？

答：因为如果把 `190` 写成 terminal，读者就会再次误以为 bridge 线已经在 write contract 处收口，后面的 ingress / control / blocked-state 子树只是另一套题。实际上它们是同一条后继线的下一段。
