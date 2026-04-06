# `createStreamlinedTransformer`、`structuredIO.write`、`lastMessage` 与 `streamlined_*`：为什么 headless print 的 streamlined output 不是 terminal semantics 后处理，而是 pre-wire rewrite

## 用户目标

106 已经讲清：

- `stream-json --verbose` 走的是 raw wire forwarding
- 它不是普通 core `SDKMessage` surface 的终态展开版

101 也已经讲清：

- `lastMessage` 维护的是终态语义
- 它不会让晚到系统尾流抢走 `result` 的主位

但继续往下读时，读者仍然很容易把另一层顺序关系写平：

- streamlined output 看起来像“更干净的显示”，那它是不是在 raw wire 写完以后，再做一次 terminal post-process？
- `lastMessage` 既然还在跑过滤，那 streamlined message 是不是先进入终态 cursor，再决定怎么显示？
- `streamlined_text`、`streamlined_tool_use_summary` 到底是在改 raw write，还是在改 terminal semantics？

如果这些不拆开，正文最容易滑成一句错误总结：

- “streamlined output 只是 headless print 在终态收口之后补的一层显示优化。”

从当前源码看，这个结论并不成立。

## 第一性原理

更稳的提问不是：

- “streamlined output 看起来是不是更简洁？”

而是先问五个更底层的问题：

1. 当前变换发生在 `structuredIO.write(...)` 之前，还是之后？
2. 当前被改写的是 raw outgoing message，还是 terminal final cursor？
3. 当前 transformer 的输入/输出类型是原始 `StdoutMessage`，还是已经筛过的终态对象？
4. 当前 `lastMessage` 还在控制“写什么”，还是只在维护别的模式需要的终态语义？
5. 当前源码证明的是“总会 streamlined”，还是“满足若干 gate 时才切到 rewrite path”？

只要这五轴不先拆开，后续就会把：

- pre-wire rewrite

误写成：

- terminal post-processing

## 第一层：streamlined 模式的 gate 在 streaming loop 之前就决定了

`print.ts` 在进入主循环前先构造：

- `const transformToStreamlined = ... ? createStreamlinedTransformer() : null`

而它的启用条件同时受三层约束：

- build feature `STREAMLINED_OUTPUT`
- 环境变量 `CLAUDE_CODE_STREAMLINED_OUTPUT`
- `options.outputFormat === 'stream-json'`

这说明第一句就不能写成：

- “只要是 `stream-json`，就天然会走 streamlined output”

更准确的说法是：

- streamlined path 是一条条件成立后才会创建的独立 rewrite path

这里很关键的一点是：

- gate 的决定发生在 streaming loop 之前

所以它从一开始就不是：

- “等 raw wire 都写完以后，再决定要不要做一层美化”

## 第二层：循环里的顺序明确是先 transform、先 write，再轮到 `lastMessage`

`for await (const message of runHeadlessStreaming(...))` 的循环体顺序非常硬：

1. 如果 `transformToStreamlined` 存在，先 `const transformed = transformToStreamlined(message)`
2. 如果 `transformed` 存在，立刻 `await structuredIO.write(transformed)`
3. 只有这之后，代码才继续往下跑 `lastMessage` 那套过滤逻辑

而在 streamlined 分支里，源码并不会再写：

- `structuredIO.write(message)`

这说明 streamlined path 做的不是：

- 原始消息先照常写出，之后再额外追加一个简化版

而是：

- 原始消息在 write 之前先被 rewrite / suppress / passthrough，真正写出去的是 rewrite 后的对象

因此这页最需要钉死的一句是：

- streamlined output 的主语是 write-time rewrite，不是 write-after decoration

## 第三层：transformer 的输入/输出类型本身就说明它在改 wire 对象，而不是改终态 cursor

`streamlinedTransform.ts` 里，`createStreamlinedTransformer()` 返回的函数签名是：

- `(message: StdoutMessage) => StdoutMessage | null`

这句很值钱，因为它说明：

- 输入是更宽的 raw `StdoutMessage`
- 输出仍然是要被送去 wire 的 `StdoutMessage`，或者直接 `null`

也就是说，这个 transformer 回答的问题不是：

- “终态 cursor 最后怎样显示”

而是：

- “面对一条 raw outgoing stdout message，现在要把它改写成什么、保留什么、丢弃什么”

如果它是在做 terminal 后处理，函数更像会接收：

- 已经过滤好的终态对象
- 或某种最终 display buffer

但当前源码没有走那条路。

## 第四层：`streamlined_*` schema 自己就把这件事定义成 replacement，而不是后置装饰

`coreSchemas.ts` 对两个 streamlined family 的描述已经非常直接：

- `streamlined_text`：replaces `SDKAssistantMessage` in streamlined output
- `streamlined_tool_use_summary`：replaces tool_use blocks in streamlined output

而 `streamlinedTransform.ts` 里的具体分支也与这个 replacement contract 对齐：

- `assistant` 有文本时，产出 `streamlined_text`
- `assistant` 只有工具调用时，产出 `streamlined_tool_use_summary`
- `result` 保持原样 passthrough
- `system`、`user`、`stream_event`、`tool_progress`、control families、`keep_alive` 等直接返回 `null`

这说明 transformer 干的不是：

- “让终端最后显示得更顺眼一点”

而是：

- 在 outgoing wire 层就把原始 assistant family 改写成新的 streamlined family，并把其他很多 family 直接压掉

所以更准确的说法是：

- streamlined output 是一种替换式 wire projection

不是：

- terminal phase 的附加渲染层

## 第五层：`lastMessage` 里的 `streamlined_*` exclusion 反而证明它们不属于终态 cursor 主合同

`print.ts` 在 write 逻辑之后仍然继续维护 `lastMessage`。

而这套过滤里，源码明确排除了：

- `streamlined_text`
- `streamlined_tool_use_summary`

旁边的注释还写着：

- 这些类型只由 transformer 产生
- SDK-only system events 被排除是为了让 `lastMessage` 保持在 `result`

这说明 `lastMessage` 在这里回答的不是：

- “刚才写出去的到底是什么”

而是：

- “哪些对象可以进入终态 cursor，供其他 output mode 在结尾收口”

于是顺序关系就更清楚了：

1. streamlined path 先决定 outgoing write
2. `lastMessage` 之后只继续维护 terminal semantics 所需的 cursor

所以不能再写成：

- “streamlined message 先进入终态语义，再在最后显示时变成 streamlined”

更准确的写法应是：

- streamlined message 先作为 outgoing write-time projection 被生成
- 然后又被排除在 `lastMessage` cursor 之外

## 第六层：`stream-json --verbose` 与 streamlined path 是并列写出路径，不是先后叠加的两层

`print.ts` 的循环里是一个非常明确的二选一：

1. `if (transformToStreamlined) { ... write(transformed) }`
2. `else if (options.outputFormat === 'stream-json' && options.verbose) { write(message) }`

这意味着：

- streamlined path 和 raw `stream-json --verbose` path 是互斥的写出分支

而不是：

- 先 raw write，再对 raw output 做 streamlined 改写

也不是：

- 先做 terminal 收口，再决定是否转成 streamlined

因此 109 和 106 的关系应写成：

- 106 讲 raw wire contract 面对的是哪一层对象
- 109 讲当 streamlined gate 打开时，这条 wire contract 在写出前会被重写

## 第七层：当前源码能稳定证明什么，不能稳定证明什么

从当前源码可以稳定证明的是：

- streamlined gate 由 feature、env var 与 `outputFormat === 'stream-json'` 共同决定
- transformer 在 streaming loop 内、`structuredIO.write(...)` 之前运行
- transformer 的输入/输出是 `StdoutMessage -> StdoutMessage | null`
- streamlined 分支写出的是 transformed message，而不是原始 message
- `lastMessage` 过滤发生在写出之后，并明确排除 `streamlined_*`

从当前源码不能在这页稳定证明的是：

- 所有 `stream-json` 写出都一定经过主循环里的 streamlined transformer
- 一旦进入 streamlined path，就一定能看到 `streamlined_text` 或 `streamlined_tool_use_summary`
- streamlined output 代表 public SDK surface 的正式替代

所以更稳的结论必须停在：

- conditional pre-wire rewrite

而不能滑到：

- universal stream-json behavior

## 第八层：为什么 109 不能并回 106

106 的主语是：

- `stream-json --verbose` 面对的是 wider raw wire，而不是普通 core SDK surface

109 继续往下压的主语则是：

- 当 streamlined gate 打开时，这条 raw wire write 是在写出前被 rewrite，而不是在 terminal semantics 之后补处理

前者讲：

- output mode contract

后者讲：

- rewrite timing inside that contract

不该揉成一页。

## 第九层：为什么 109 也不能并回 101

101 的主语是：

- `result` 为什么维持 semantic last-message 主位

109 的主语已经换成：

- `streamlined_*` 为什么根本不属于那套终态 cursor 主合同，而是在更前面作为 write-time projection 被生成

前者讲：

- terminal semantics

后者讲：

- pre-terminal rewrite ordering

也必须分开。

## 第十层：最常见的假等式

### 误判一：streamlined output 是 raw wire 写完以后再做的显示优化

错在漏掉：

- transformer 发生在 `structuredIO.write(...)` 之前

### 误判二：原始 message 会照常写出，streamlined message 只是额外补充

错在漏掉：

- streamlined 分支里写出的就是 transformed object，不再写原始 `message`

### 误判三：`lastMessage` 过滤控制了 streamlined message 的写出与否

错在漏掉：

- `lastMessage` 过滤发生在 write 之后，只在维护别的模式的终态 cursor

### 误判四：所有 `stream-json` 都天然等于 streamlined output

错在漏掉：

- 还要通过 build flag、env var 与 outputFormat 三重 gate

### 误判五：`streamlined_*` 只是终端显示层的别名

错在漏掉：

- schema 描述本身就在强调 replacement，而不是 decoration

## 第十一层：苏格拉底式自审

### 问：我是不是又把“看起来更简洁”写成了“发生在更后面”？

答：如果是，就回到循环顺序看 `transform -> write -> lastMessage`。

### 问：我是不是把 `lastMessage` 当成了这条路径的主写出器？

答：如果是，就已经把 terminal contract 和 wire contract 混在一起了。

### 问：我是不是又在暗示“所有 stream-json 都会 streamlined”？

答：如果是，就超出这页的 gate 证据范围了。

### 问：我是不是把 109 写成“哪些 family 常见”的目录学？

答：如果是，就把顺序主轴重新稀释掉了。
