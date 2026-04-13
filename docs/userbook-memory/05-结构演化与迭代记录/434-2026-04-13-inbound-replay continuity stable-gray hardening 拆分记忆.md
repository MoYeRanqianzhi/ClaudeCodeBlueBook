# inbound-replay continuity stable-gray hardening 拆分记忆

## 本轮继续深入的核心判断

在当前 worktree 已经把：

- `197` 的 ingress reading skeleton
- `196/198/199/201/202` 的 stable-gray 收束

逐步补平之后，

同簇里更值钱的下一刀，

不是继续扩目录入口，

而是回到：

- `192-lastTransportSequenceNum、recentInboundUUIDs、tryReconnectInPlace、createSession 与 rebuildTransport：为什么 same-session continuity 与 fresh-session reset 不是同一种 inbound replay contract.md`

把这张 inbound replay continuity 页，

从旧式的“正文后直接收结论”，

补成最近已经稳定下来的：

- `稳定层、条件层与灰度层`

口径。

## 为什么这轮值得单独提交

### 判断一：`192` 的正文主语已经够硬，当前最明显的缺口只是尾部收束格式

`192`

前六层已经把关键 boundary 拆得很清楚：

- same-session continuity 要保留 replay state
- fresh-session reset 必须归零
- bridge re-init 不会恢复 `recentInboundUUIDs`
- `lastTransportSequenceNum` 与 `recentInboundUUIDs` 共享 session 边界，但不是同一种账

所以现在更值钱的，

不是再补更多 continuity 事实，

而是把它的尾部拉回统一的 stable / conditional / gray 口径。

### 判断二：这页最需要保护的是“continuity 跟 session incarnation 走”与“非统一 reconnect/reset 语义”两句稳定结论

这页最容易重新塌掉的误判是：

- 只要 transport 换了，就都是同一种 reconnect/reset

所以这轮最该保住的是：

- inbound replay continuity 跟 session incarnation 走，不跟 transport 实例字面走
- same-session continuity 与 fresh-session reset 不是同一种 replay contract

最该降到条件或灰度层的则是：

- 某次 reconnect 最终属于哪种 continuity 路径
- `recentInboundUUIDs` 是否继续有效
- host / transport / session route 的未来细分
- helper 调度与 replay state wiring 的 exact 细节

### 判断三：这轮继续贯彻“正文合同厚度优先于新增 hub”的目录策略

当前 `191-206` 簇里，

`206` 已成熟，

`197` 已被拉回 skeleton 页口径，

所以比继续裂 hub 更值钱的，

是把仍停在旧式结论收束的 `192` 补平。

## 这轮具体怎么拆

这轮只做三件事：

1. 修改 `192-...inbound replay contract.md`
   - 在第六层与结论之间新增 `稳定层、条件层与灰度层`
   - 补一句 stop line：结论必须停在 session-incarnation continuity，不滑到统一 reconnect/reset 语义
   - 把结论开头改成“所以这页能安全落下的结论应停在”
2. 新增这条 `434` 记忆
   - 记录为什么这轮优先补 `192` 的 stable-gray 收束
3. 更新 `memory/05 README`
   - 把最新批次索引推进到 `434`

## 苏格拉底式自审

### 问：为什么这轮不是继续回到 `191`？

答：因为 `191` 至少已经有“稳定面与灰度面”；`192` 当前更像旧式直收页，口径落后得更明显。

### 问：为什么这轮不是继续去改 `206`？

答：因为 `206` 已经是成熟页。当前更明显的缺口在 `192` 的尾部收束格式。

### 问：为什么这也算“保护稳定功能和灰度功能”？

答：因为这轮正是在把 `192` 页里哪些 continuity 结论可稳定依赖、哪些仍受 session route 与 replay state wiring 约束写成明确分层，避免把局部实现误抬成公开合同。
