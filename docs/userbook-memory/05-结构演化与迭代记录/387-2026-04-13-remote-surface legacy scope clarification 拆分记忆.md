# remote-surface legacy scope clarification 拆分记忆

## 本轮继续深入的核心判断

在当前 worktree 已经补完：

- `203` 的 permission-tail scope guard

之后，

当前最自然的下一刀，

不是继续补 `132/135/138/141/142/143` 的 leaf 页，

而是回补：

- `204-activeRemote、remoteSessionUrl、outboundOnly、getIsRemoteMode 与 useReplBridge：为什么 remote surface 的 132、135、138、141、142、143 不是并列 remote 页，而是从 front-state consumer topology 分叉出去的五种后继问题.md`

自己的页首主语。

## 为什么这轮值得单独提交

### 判断一：当前缺口不在“204 有没有画出 remote surface 分叉图”，而在“204 会不会把 branch map、surface 主语与局部 projection / state 证据写成同一层”

`204` 正文已经把结构讲出来了：

- `132` 是 front-state consumer topology 根页
- `135` 固定 foreground remote runtime
- `138` 固定 shared interaction shell
- `141` 是 remote-session presence ledger
- `142` 是 bridge gray runtime
- `143` 是 global remote behavior bit

但如果读者在进入第一性原理前，

还没先被明确提醒：

- 这里不是在重讲 `132/135/138/141/142/143` 各页自己的页内证明
- 这里也不该把 `activeRemote`、`remoteSessionUrl`、`outboundOnly`、`getIsRemoteMode()`、`useReplBridge(...)`、`remoteConnectionStatus`、`remoteBackgroundTaskCount` 这些局部 helper / state / projection 名重新抬成总纲主角

就仍然很容易把：

- foreground runtime
- interaction shell
- presence ledger
- gray runtime
- behavior bit

重新压回一句：

- “remote surface 还有六篇平行小文”

所以这一刀真正补的，

不是更多结构事实，

而是范围声明。

### 判断二：这句必须同时点出 branch map、surface layer 与 projection-evidence 三层

本地复核与后来的 `216/217` scope guard 已经在指向同一个风险：

- 老结构收束页最容易把“图上关系”和“图里各页局部证明对象”压成一层

如果只写：

- “这里只讲 remote surface 分叉图”

还不够稳，

因为读者仍可能把三层对象写平：

- map layer：
  - `132` 根页
  - `135/138/141/142/143` 五条后继线
- surface layer：
  - foreground runtime
  - interaction shell
  - presence ledger
  - gray runtime
  - behavior bit
- evidence layer：
  - `activeRemote`
  - `remoteSessionUrl`
  - `outboundOnly`
  - `getIsRemoteMode()`
  - `useReplBridge(...)`
  - `remoteConnectionStatus`
  - `remoteBackgroundTaskCount`

所以当前最稳的说法必须同时说明：

- 本页主语是跨页 branch map 与 remote-surface 分层
- 各页页内主语仍留在各自 leaf page
- helper / state / projection 名只作 evidence，不再升格成 `204` 的总纲主角

## 这轮具体怎么拆

这轮只做一件事：

1. 在 `204-...五种后继问题.md`
   的导语和第一性原理之间，
   增加一句范围声明：
   - 本页不重讲 `132/135/138/141/142/143` 各页自己的页内证明
   - 也不把 `activeRemote`、`remoteSessionUrl`、`outboundOnly`、`getIsRemoteMode()`、`useReplBridge(...)`、`remoteConnectionStatus`、`remoteBackgroundTaskCount` 这些局部 helper / state / projection 名重新升级成新的总纲主角
   - 这里只整理跨页拓扑：`132` 是根页，`135` 钉 foreground runtime，`138` 钉 interaction shell，然后才继续分叉到 `141/142/143`
   - 并把稳定的 consumer-topology 骨架、宿主条件性的 remote surface 分支与局部 projection-evidence 分层
   - 防止把 leaf-level 的 event projection、URL / ledger、mirror overlay 或 remote bit 证明写成并排的 remote 细节

这样：

- `204`
  就能和后来的 `216-219` 保持同一种 structure-page 节奏
- `204`
  不再像一页“把 132/135/138/141/142/143 的 leaf proof 再总述一次”的后设摘要
- 后面如果继续处理 remote surface / remote truth 那簇旧结构页，
  这一页也能更稳地停在 `132/135/138/141/142/143` 这一层

## 苏格拉底式自审

### 问：为什么这轮不是回去补 141 或 143？

答：因为 `132/135/138/141/142/143` 的 leaf 页已经各自成立。当前真正缺的是 `204` 自己还没在页首把“根页 + 五条后继线，不重讲 leaf proof”写成一句。

### 问：为什么 `204` 还需要 scope guard，正文不是已经在讲分叉图了吗？

答：因为当前风险不在正文有没有图，而在读者进入图之前，仍会先把这页误听成“把 remote surface 的 leaf 证明再复述一次”。范围声明要先把这条误听切掉。

### 问：为什么这句要显式点名 `activeRemote`、`remoteSessionUrl`、`outboundOnly`、`getIsRemoteMode()`、`useReplBridge(...)`、`remoteConnectionStatus`、`remoteBackgroundTaskCount`？

答：因为 `204` 最容易在总纲里重新抬高这些局部对象，导致 surface / branch / evidence 三层再次串层。先把它们降回 evidence，后文的分层才真正稳。
