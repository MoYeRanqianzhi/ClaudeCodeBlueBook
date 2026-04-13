# ingress-consumer stable-gray hardening 拆分记忆

## 本轮继续深入的核心判断

在当前 worktree 已经把：

- `192` 的 inbound replay continuity stable-gray
- `197` 的 ingress reading skeleton
- `196/198/199/201/202/203` 的 permission-tail 收束

逐步补平之后，

同簇里更值钱的下一刀，

不是继续扩目录入口，

而是回到：

- `191-handleIngressMessage、recentPostedUUIDs、recentInboundUUIDs 与 onInboundMessage：为什么 outbound echo drop、inbound replay guard 与 non-user ignore 不是同一种 ingress consumer contract.md`

把这张 ingress consumer 页，

从旧式的：

- 稳定面与灰度面

拉回最近已经稳定下来的：

- `稳定层、条件层与灰度层`

口径。

## 为什么这轮值得单独提交

### 判断一：`191` 的正文主语已经够硬，当前最明显的缺口只是尾部收束格式

`191`

前八层已经把关键 contract 拆得足够清楚：

- control payload 走 side-channel bypass
- `recentPostedUUIDs` 签 outbound echo drop
- `recentInboundUUIDs` 签 inbound replay guard
- non-user ignore 属于 consumer-domain narrowing

所以现在更值钱的，

不是再补更多 ingress 事实，

而是把它的尾部拉回统一的 stable / conditional / gray 口径。

### 判断二：这页最需要保护的是“四种 contract 并存”与“非统一 ingress 过滤表”两句稳定结论

这页最容易重新塌掉的误判是：

- 所有没进 REPL 的 ingress message，本质上都只是同一种“被过滤掉”

所以这轮最该保住的是：

- ingress reader 内部至少已经分成 control bypass、outbound echo drop、inbound replay guard 与 user-only consumer domain 四种合同
- 这不等于一张统一的 ingress 去重/过滤表

最该降到条件或灰度层的则是：

- replay 是否真的命中
- outboundOnly / gray runtime 的更大分叉
- viewer 侧并行 consumer 路径
- reader wiring 与 helper 顺序的 exact 细节

### 判断三：这轮继续贯彻“正文合同厚度优先于新增 hub”的目录策略

当前 `191-206` 簇里，

- `206` 已成熟
- `197` 已拉回 skeleton 页口径
- `192` 已补成 stable-gray

所以比继续裂 hub 更值钱的，

是把仍停在旧式尾部的 `191` 补平。

## 这轮具体怎么拆

这轮只做三件事：

1. 修改 `191-...ingress consumer contract.md`
   - 把旧式“稳定面与灰度面”改成 `稳定层、条件层与灰度层`
   - 补一句 stop line：结论必须停在“四种 contract 并存”，不滑到统一过滤表
   - 新增一个简短 `## 结论`
2. 新增这条 `435` 记忆
   - 记录为什么这轮优先补 `191` 的 stable-gray 收束
3. 更新 `memory/05 README`
   - 把最新批次索引推进到 `435`

## 苏格拉底式自审

### 问：为什么这轮不是继续回到 `206`？

答：因为 `206` 已经是成熟页。当前更不统一的，是 `191` 这种早期 ingress consumer 页还保留旧式尾部口径。

### 问：为什么这轮不是继续去改 `197`？

答：因为 `197` 已经共享了结构页的 skeleton 收束格式。当前落后的，是 `191` 这种 fact page 的尾部语言。

### 问：为什么这也算“保护稳定功能和灰度功能”？

答：因为这轮正是在把 `191` 页里哪些 ingress contract 可稳定依赖、哪些仍受宿主分叉与 reader wiring 约束写成明确分层，避免把局部实现误抬成公开合同。
