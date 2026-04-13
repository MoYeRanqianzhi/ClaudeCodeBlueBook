# `extractInboundMessageFields`、`normalizeImageBlocks`、`resolveInboundAttachments`、`prependPathRefs` 与 `resolveAndPrepend`：为什么 image block repair 与 attachment path-ref prepend 不是同一种 inbound normalization contract

## 用户目标

194 已经把 ingress 的 user leg 收成一句：

- 真正兑现的是 `user -> extractInboundMessageFields(...) -> enqueue(prompt)` 这条 transcript adapter

但如果正文停在这里，读者还是很容易把 adapter 内部的前处理继续写平：

- `extractInboundMessageFields(...)` 里已经在做 normalization，后面的 attachment 处理不也只是继续做 normalize 吗？
- 既然最后都是为了把 payload 送进同一个 prompt sink，image block 修复和 attachment path-ref prepend 为什么不能算同一层 inbound normalization？
- `resolveAndPrepend(...)` 不就是把消息再清洗一下再 enqueue 吗？跟 `normalizeImageBlocks(...)` 的差别真的不是实现细节？
- hook 和 print 对 attachment 的接法还不完全一样，这是不是说明这层根本不稳定，没必要单拆？

这句还不稳。

从当前源码看，还得继续拆开两种不同的前处理合同：

1. `message.content` 内部的 schema repair
2. `file_attachments` 外挂附件的 materialization + path-ref prepend

如果这两层不先拆开，后面就会把：

- `normalizeImageBlocks(...)`
- `extractInboundAttachments(...)`
- `resolveInboundAttachments(...)`
- `prependPathRefs(...)`
- `resolveAndPrepend(...)`

重新压成一句模糊的“inbound normalization”。

## 第一性原理

更稳的提问不是：

- “为什么这两段都不算同一种 normalize？”

而是先问六个更底层的问题：

1. 当前修的是 `message.content` 结构本身，还是 message 外挂出来的附件引用？
2. 当前失败的后果是 schema block 直接毒死后续 API 调用，还是附件最好能补成 `@path`、失败也可以降级继续？
3. 当前变换发生在纯内存内容块里，还是需要网络下载和落盘？
4. 当前目标是保证 block schema 合法，还是给 prompt sink 预先拼出可读的 path refs？
5. 当前 fast path 是否强调零分配保持原引用，还是强调 best-effort 与失败降级？
6. 我现在分析的是 194 的 transcript adapter 总句，还是 adapter 内部为什么已经分成两层 normalization contract？

只要这六轴不先拆开，后面就会把：

- schema repair
- attachment materialization
- prompt prepend

混成一张“bridge inbound 归一化表”。

## 第一层：`extractInboundMessageFields(...)` / `normalizeImageBlocks(...)` 修的是 `message.content` 内部坏块，不是附件物化

`inboundMessages.ts` 里，`extractInboundMessageFields(...)` 做的第一件事是：

- 只接受 `msg.type === 'user'`
- 拿出 `msg.message?.content`
- 为空就直接返回 `undefined`

随后它在 `content` 为数组时才调用：

- `normalizeImageBlocks(content)`

而 `normalizeImageBlocks(...)` 的目标非常具体：

- 修复 base64 image block 里错误的 `mediaType`
- 补成合法的 `media_type`
- 或在字段缺失时从 base64 数据推断格式

它甚至还有很明确的性能边界：

- 如果没有坏块，直接返回原数组引用

这说明这层回答的问题不是：

- “附件要不要下载、要不要改写成路径引用”

而是：

- 当前 `message.content` 里的 block schema 是否已经足够合法，能继续进入后续 prompt 流

所以更准确的理解不是：

- `normalizeImageBlocks(...)` 只是 attachment 处理的前半段

而是：

- 它是纯粹的 content-internal schema repair

## 第二层：`extractInboundAttachments(...)` / `resolveInboundAttachments(...)` 处理的是外挂附件引用，不是 block schema 修复

`inboundAttachments.ts` 开头就把对象边界写得很清楚：

- 它处理的是 `file_attachments`
- 这些附件通过 web composer 旁挂在 message 上
- 需要通过 OAuth 下载，写入 `~/.claude/uploads/{sessionId}/`

这跟 `normalizeImageBlocks(...)` 修的对象完全不是同一层：

- 前者修的是 `message.message.content`
- 后者读的是 `msg.file_attachments`

更关键的是，它们的失败语义也不一样：

- image block 坏掉会污染整个 session，后续 API 调用直接失败
- attachment 下载失败只会降级成“没有 `@path`”，消息照样继续送给 Claude

所以更准确的理解不是：

- 两边都叫 normalize，只是对象略有不同

而是：

- 一个是 correctness repair
- 一个是 best-effort materialization

## 第三层：`prependPathRefs(...)` 也不是 generic string concat，而是 prompt sink 对齐合同

attachment 层进一步分成两步：

- `resolveInboundAttachments(...)` 把附件物化成绝对路径
- `prependPathRefs(...)` 把这些路径引用塞回 content

`prependPathRefs(...)` 甚至还写死了与 prompt sink 的耦合点：

- 要把 refs 放到最后一个 text block
- 因为 `processUserInputBase` 只从最后一个 text block 读 `inputString`
- 如果没有 text block，就追加一个末尾 text block

这说明 attachment 层回答的问题也不是：

- “怎样把附件信息附会到消息上就行”

而是：

- 怎样把这些路径引用改写成 prompt sink 实际能消费的形状

所以这层的主语也和 image block repair 不同。

前者是在：

- 让 block schema 合法

后者是在：

- 让 prompt sink 真能看到 `@path`

## 第四层：`resolveAndPrepend(...)` 只是 convenience wrapper，不会把两层重新压成一层

最容易误判的就是：

- `resolveAndPrepend(...)`

因为看起来它把：

- `extractInboundAttachments(...)`
- `resolveInboundAttachments(...)`
- `prependPathRefs(...)`

都包成了一个调用。

但 wrapper 的存在，不等于合同的合并。

它仍然保持了很清楚的边界：

- 没有 `file_attachments` 时直接返回原 content 引用
- 有附件才进下载与 prepend

而它完全没有碰：

- `normalizeImageBlocks(...)`

这说明 wrapper 只是把 attachment pipeline 打包成一个方便入口，

不是说：

- content repair
- attachment materialization

从此变成同一件事。

## 第五层：hook 与 print 的调用点差异，反而证明 attachment 层不是 transcript adapter 的不可分部分

`useReplBridge.tsx` 的 bridge inbound user 流是：

- `extractInboundMessageFields(msg)`
- 可选 webhook sanitize
- `resolveAndPrepend(msg, sanitized)`
- `enqueue(prompt)`

也就是说 hook 这边显式把：

- content repair
- attachment materialization

串在一起。

但 `print.ts` 的 bridge `onInboundMessage(...)` 只显式做了：

- `extractInboundMessageFields(msg)`
- `enqueue(prompt)`

而 `resolveAndPrepend(...)` 在 `print.ts` 的另一条 prompt intake 路径上被单独调用：

- `value: await resolveAndPrepend(message, message.message.content)`

这说明 attachment 层的合同并不是：

- “只要是 bridge inbound user message，就必须和 `extractInboundMessageFields(...)` 焊死在一起”

而是：

- 它可以作为独立的 prompt payload materialization 层，被不同 prompt intake 路径按需接入

所以 hook / print 的差异不是噪音。

它正好证明：

- attachment prepend 不是 transcript adapter 主句本身
- 而是 adapter 后面一层可组合的 materialization contract

## 第六层：这页不是 194 的附录式重写

194 的主语是：

- ingress 上只有 control 旁路与 user-only transcript adapter

195 的主语更窄：

- 同属 user-only transcript adapter 的内部前处理，也不是同一层

194 的问题是：

- 为什么没有第二个 non-user consumer

195 的问题是：

- 为什么同属 user leg，content repair 和 attachment path-ref prepend 也不是同一种 normalization

如果把这层不再拆开，后面就会把：

- malformed image block 修复
- file attachment 下载落盘
- path-ref prepend

都写成一句泛泛的：

- “消息在 enqueue 前会被做一点 normalization”

这句会把真实的正确性边界、失败语义和 sink 对齐合同全部抹掉。

## 第七层：稳定层、条件层与灰度层

### 稳定可见

- `normalizeImageBlocks(...)` 当前修的是 `message.content` 内部坏块，属于 correctness-first 的 schema repair。
- `resolveInboundAttachments(...)` / `prependPathRefs(...)` 当前处理的是 `file_attachments`，属于 best-effort 的 path-ref materialization。
- `resolveAndPrepend(...)` 当前只是 attachment pipeline 的 convenience wrapper，不会把它和 content repair 合并成一层。
- hook / print 的接法差异当前恰好说明 attachment 层是可组合的前处理，而不是 transcript adapter 的唯一主句。
- 这里保护的不是“都叫 normalize”，而是 user leg 内部至少已经分成 content repair 与 attachment materialization 两层合同。

### 条件公开

- attachment materialization 是否真的参与，仍取决于当前 message 上是否带 `file_attachments`。
- attachment 下载与 path-ref prepend 是否成功，仍取决于当前宿主、下载路径与 best-effort 降级条件。
- hook / print 会不会走同样厚度的前处理，也仍取决于当前 consumer route，而不是这页已经稳定暴露的 normalization 边界。

### 内部/灰度层

- `normalizeImageBlocks(...)` 的 exact block rewrite 细节
- `resolveInboundAttachments(...)` 的下载/落盘 wiring
- `prependPathRefs(...)` 与 `resolveAndPrepend(...)` 的 helper 调用顺序
- 其他 normalization 细节与 future pipeline 扩张

所以这页最稳的结论必须停在：

- user leg 内部至少已经分成 correctness repair 与 best-effort materialization 两层 normalization contract
- image block repair 与 attachment path-ref prepend 不是同一种 inbound normalization

而不能滑到：

- 消息在 enqueue 前只是统一做一点清洗

## 结论

所以这页能安全落下的结论应停在：

- `normalizeImageBlocks(...)` 修的是 `message.content` 内部坏块，属于 correctness-first 的 schema repair
- `resolveInboundAttachments(...)` / `prependPathRefs(...)` 处理的是 `file_attachments`，属于 best-effort 的 path-ref materialization
- `resolveAndPrepend(...)` 只是 attachment pipeline 的 convenience wrapper，不会把它和 content repair 合并成一层
- hook / print 的接法差异恰好说明 attachment 层是可组合的前处理，而不是 transcript adapter 的唯一主句

一旦这句成立，就不会再把：

- image block repair
- attachment path-ref prepend

写成同一种 inbound normalization contract。
