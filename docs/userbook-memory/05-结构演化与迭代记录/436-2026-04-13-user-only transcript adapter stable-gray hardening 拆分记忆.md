# user-only transcript adapter stable-gray hardening 拆分记忆

## 本轮继续深入的核心判断

在当前 worktree 已经把：

- `191` 的 ingress consumer stable-gray
- `192` 的 inbound replay continuity stable-gray
- `197` 的 ingress reading skeleton

逐步补平之后，

同簇里更值钱的下一刀，

不是继续扩目录入口，

而是回到：

- `194-handleIngressMessage、control_response-control_request、extractInboundMessageFields 与 enqueue(prompt)：为什么 bridge ingress 只有 control 旁路和 user-only transcript adapter，non-user SDKMessage 没有第二消费面.md`

把这张 user-only transcript adapter 页，

从旧式的“正文后直接收结论”，

补成最近已经稳定下来的：

- `稳定层、条件层与灰度层`

口径。

## 为什么这轮值得单独提交

### 判断一：`194` 的正文主语已经够硬，当前更明显的缺口只是尾部收束格式

`194`

前六层已经把关键正判断拆得足够清楚：

- bridge ingress 只有 control 旁路和 user-only transcript adapter
- `onInboundMessage` 是 user leg 的 callback slot
- `extractInboundMessageFields(...)` 是第二道 narrowing
- hook / print 共享同一个 `enqueue(prompt)` sink

所以现在更值钱的，

不是再补更多 adapter 事实，

而是把它的尾部拉回统一的 stable / conditional / gray 口径。

### 判断二：这页最需要保护的是“user-only transcript adapter”与“非通用 SDK consumer”两句稳定结论

这页最容易重新塌掉的误判是：

- non-user `SDKMessage` 只是暂时没处理，迟早会接到同一条通用 consumer 上

所以这轮最该保住的是：

- bridge ingress 的消息面只兑现 user-only transcript adapter
- non-user `SDKMessage` 在这里没有第二消费面

最该降到条件或灰度层的则是：

- hook / print 的前处理厚度差异
- attachment resolve / sanitize 等 richer pre-processing 是否参与
- helper 调用顺序与 adapter 细节
- future build 是否会新开 non-user consumer

### 判断三：这轮继续贯彻“正文合同厚度优先于新增 hub”的目录策略

当前这条 ingress / user-leg 支线里，

- `191` 已补 ingress consumer stable-gray
- `192` 已补 replay continuity stable-gray
- `197` 已补 skeleton 页口径

所以比继续裂 hub 更值钱的，

是把仍停在旧式结论收束的 `194` 补平。

## 这轮具体怎么拆

这轮只做三件事：

1. 修改 `194-...user-only transcript adapter.md`
   - 在第六层与结论之间新增 `稳定层、条件层与灰度层`
   - 补一句 stop line：结论必须停在 user-only transcript adapter，不滑到通用 SDK consumer
   - 把结论开头改成“所以这页能安全落下的结论应停在”
2. 新增这条 `436` 记忆
   - 记录为什么这轮优先补 `194` 的 stable-gray 收束
3. 更新 `memory/05 README`
   - 把最新批次索引推进到 `436`

## 苏格拉底式自审

### 问：为什么这轮不是继续回到 `195`？

答：因为 `195` 自己已经明确是 `194` 下面的 normalization 细化。当前更该先补平的，是 user-only transcript adapter 这个上层主句。

### 问：为什么这轮不是继续去改 `193`？

答：因为 `193` 已经是成熟页。当前更不统一的，是 `194` 这种同簇事实页还停在旧式尾部口径。

### 问：为什么这也算“保护稳定功能和灰度功能”？

答：因为这轮正是在把 `194` 页里哪些 adapter 结论可稳定依赖、哪些仍受宿主分叉与前处理 wiring 约束写成明确分层，避免把局部实现误抬成公开合同。
