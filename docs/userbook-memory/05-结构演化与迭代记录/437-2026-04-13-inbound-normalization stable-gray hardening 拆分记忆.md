# inbound-normalization stable-gray hardening 拆分记忆

## 本轮继续深入的核心判断

在当前 worktree 已经把：

- `191` 的 ingress consumer stable-gray
- `192` 的 inbound replay continuity stable-gray
- `194` 的 user-only transcript adapter stable-gray
- `197` 的 ingress reading skeleton

逐步补平之后，

同簇里更值钱的下一刀，

不是继续扩目录入口，

而是回到：

- `195-extractInboundMessageFields、normalizeImageBlocks、resolveInboundAttachments、prependPathRefs 与 resolveAndPrepend：为什么 image block repair 与 attachment path-ref prepend 不是同一种 inbound normalization contract.md`

把这张 inbound normalization 页，

从旧式的“正文后直接收结论”，

补成最近已经稳定下来的：

- `稳定层、条件层与灰度层`

口径。

## 为什么这轮值得单独提交

### 判断一：`195` 的正文主语已经够硬，当前最明显的缺口只是尾部收束格式

`195`

前六层已经把关键 normalization 边界拆得足够清楚：

- `normalizeImageBlocks(...)` 是 content-internal schema repair
- `resolveInboundAttachments(...)` / `prependPathRefs(...)` 是附件 materialization
- `resolveAndPrepend(...)` 只是 attachment wrapper
- hook / print 差异反过来证明 attachment 层可组合

所以现在更值钱的，

不是再补更多 normalization 事实，

而是把它的尾部拉回统一的 stable / conditional / gray 口径。

### 判断二：这页最需要保护的是“两层 normalization contract”与“非统一清洗动作”两句稳定结论

这页最容易重新塌掉的误判是：

- 消息在 enqueue 前不过是统一做一点清洗

所以这轮最该保住的是：

- user leg 内部至少已经分成 correctness repair 与 best-effort materialization 两层 normalization contract
- image block repair 与 attachment path-ref prepend 不是同一种 inbound normalization

最该降到条件或灰度层的则是：

- message 是否带 `file_attachments`
- 下载与 path-ref prepend 是否成功
- hook / print 是否会走同样厚度的前处理
- helper 调用顺序与 normalization 细节

### 判断三：这轮继续贯彻“正文合同厚度优先于新增 hub”的目录策略

当前这条 ingress / user-leg 支线里，

- `191` 已补 ingress consumer stable-gray
- `192` 已补 replay continuity stable-gray
- `194` 已补 user-only transcript adapter stable-gray

所以比继续裂 hub 更值钱的，

是把仍停在旧式结论收束的 `195` 补平。

## 这轮具体怎么拆

这轮只做三件事：

1. 修改 `195-...inbound normalization contract.md`
   - 在第六层与结论之间新增 `稳定层、条件层与灰度层`
   - 补一句 stop line：结论必须停在两层 normalization contract，不滑到统一清洗动作
   - 把结论开头改成“所以这页能安全落下的结论应停在”
2. 新增这条 `437` 记忆
   - 记录为什么这轮优先补 `195` 的 stable-gray 收束
3. 更新 `memory/05 README`
   - 把最新批次索引推进到 `437`

## 苏格拉底式自审

### 问：为什么这轮不是继续回到 `194`？

答：因为 `194` 刚完成 stable-gray hardening。当前更不统一的，是它下面这张 normalization 细化页还停在旧式结论收束。

### 问：为什么这轮不是继续去改 `197`？

答：因为 `197` 已经共享了结构页的 skeleton 收束格式。当前落后的，是 `195` 这种事实页的尾部语言。

### 问：为什么这也算“保护稳定功能和灰度功能”？

答：因为这轮正是在把 `195` 页里哪些 normalization 结论可稳定依赖、哪些仍受下载路径与 helper wiring 约束写成明确分层，避免把局部实现误抬成公开合同。
