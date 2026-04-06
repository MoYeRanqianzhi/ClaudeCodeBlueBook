# `post_turn_summary`、`SDKMessageSchema`、`StdoutMessageSchema`、`print.ts` 与 `directConnectManager`：为什么它不是 core SDK-visible，却不等于完全不可见

## 用户目标

100 已经讲清：

- `post_turn_summary` 不属于 core `SDKMessage` union
- 它又能出现在更宽的 `StdoutMessageSchema` 里

101 也讲清：

- 它不会进入 headless `print` 的终态语义

但继续往下读时，读者仍然很容易落进一个二元误判：

- 既然它不在 `SDKMessageSchema` 里，那它就是“不可见”
- 或者既然它在更宽输出层里，那它就是“普通可见消息”

这两句都太粗。

真正更精确的问题是：

- `post_turn_summary` 不属于哪一层可见性？
- 它又能在哪一层仍然被看见？
- `print.ts`、`directConnectManager` 与 SDK public surface 到底各自切掉了哪一层？
- “不属于 core SDK message” 为什么不等于“完全不可见”？

如果这些不拆开，正文最容易滑成一句错误总结：

- “`post_turn_summary` 要么可见，要么不可见。”

源码给出的边界比这细得多。

## 第一性原理

更稳的提问不是：

- “它可见吗？”

而是先问五个更底层的问题：

1. 当前讨论的是 core SDK message surface，还是更宽的 stdout/control wire surface？
2. 当前讨论的是 terminal semantics，还是 raw message admissibility？
3. 当前 consumer 走的是普通 SDK consumer、SDK builder/control path，还是 direct-connect callback？
4. 源码证明的是“允许出现在某层”，还是“保证每轮都会出现”？
5. 这里缺的是 message existence，还是 consumer path filtering？

只要这五轴不先拆开，后续就会把：

- not core SDK-visible

误写成：

- not visible at all

## 第一层：`post_turn_summary` 有 schema，但不属于 core `SDKMessage`

`coreSchemas.ts` 里：

- `SDKPostTurnSummaryMessageSchema` 单独存在
- 而且带 `@internal`

但 `SDKMessageSchema` 的 union 并没有把它并进去。

这说明最先要钉死的一句是：

- `post_turn_summary` 不是 core SDK message surface 的标准成员

所以如果用户问：

- “普通 SDK consumer 按 core message 理解时，它算不算普通消息？”

更准确的答案是：

- 不算

但这一步还不能直接推出：

- “因此它根本不可见”

## 第二层：`StdoutMessageSchema` 又把它加回到了更宽的 wire union

`controlSchemas.ts` 的 `StdoutMessageSchema` 会 union：

- `SDKMessageSchema()`
- streamlined variants
- `SDKPostTurnSummaryMessageSchema()`
- control response / request / cancel / keep_alive

这说明源码守的是两层不同的可见性：

1. core/public SDK message surface
2. wider stdout/control wire surface

`post_turn_summary` 被排除的是第一层，
但又被重新接纳进第二层。

所以更准确的说法是：

- 它不是 core SDK-visible
- 但它仍然是 stdout/control wire-admissible

不是：

- “它完全不可见”

## 第三层：`print.ts` 证明 raw stream 可以承载它，但 terminal semantics 不认它

`print.ts` 在 `--output-format=stream-json --verbose` 时，会把 raw `message` 直接写出去。

这说明只要 upstream 真 emit 了 `post_turn_summary`，并且 consumer 读的是更宽 raw stream：

- 它是可能被看见的

但同一个 `print.ts` 随后又在 `lastMessage` 的过滤名单里排除：

- `post_turn_summary`

这又说明：

- 即使它能在 raw stream 出现
- 它也不是 terminal-semantic message

所以这里最该避免的误写是：

- “能在流里被看见，所以它就是普通终态消息。”

更准确的说法应是：

- raw stream visibility 不等于 terminal semantics membership

## 第四层：`directConnectManager` 进一步证明“wire-visible”与“callback-visible”也不是同一层

`directConnectManager.ts` 的 callback surface 是：

- `onMessage: (message: SDKMessage) => void`

但它解析输入时面对的是更宽的：

- `StdoutMessage`

随后在转发前又显式过滤：

- `system.post_turn_summary`

这说明 even inside direct connect：

- raw incoming wire surface 比 callback-visible surface 更宽

也就是说，`post_turn_summary` 不是：

- 完全不存在于 direct-connect ingress

而是：

- 即便进入更宽 wire path，也会在 callback 暴露前被 intentionally stripped

所以更稳的结论是：

- 它不是 callback-visible
- 但不代表它从未进入 raw wire layer

## 第五层：`not core SDK-visible` 与 `not visible at all` 的差别，正是 105 要单列的核心

这页真正要钉死的一句，不是：

- 它能不能看见

而是：

- 它在哪一层能被看见、在哪一层被故意切掉

从当前源码可稳定证明的是：

- `post_turn_summary` 不属于 core `SDKMessage`
- 它属于更宽的 `StdoutMessage` / stdout-control admissible set
- `print.ts` 会把它排除在 terminal semantics 外
- `directConnectManager` 会把它排除在 `SDKMessage` callback 外

而当前源码不能在这页稳定证明的是：

- 它一定按某个固定频率运行时发出

所以更克制也更准确的表述应是：

- 当前源码证明的是 admissibility + filtering
- 不是 guaranteed emission cadence

## 第六层：为什么 105 不能并回 100

100 的主语是：

- `task_summary` 与 `post_turn_summary` 的 carrier、clear、restore、union 边界总分层

105 则继续往下压成一个更窄的问题：

- `post_turn_summary` 自己的 visibility ladder
- 尤其是“非 core SDK-visible ≠ 完全不可见”

前者是：

- summary family transport/lifecycle contract

后者是：

- post_turn_summary visibility granularity

不该揉回一页。

## 第七层：为什么 105 也不能并回 101

101 的主语是：

- `result`、raw tail、terminal semantics

那里 `post_turn_summary` 只是一个例子，用来说明：

- tail 可以存在
- 但不会改终态

105 则换成另一个主语：

- 同一个对象在 core SDK surface、wider wire、terminal path、direct-connect callback 上分别处于什么可见性层级

前者是：

- terminal contract

后者是：

- multi-surface visibility contract

二者必须分开。

## 第八层：最常见的假等式

### 误判一：不在 `SDKMessageSchema` 里，就等于完全不可见

错在漏掉：

- 它还在 `StdoutMessageSchema` 这类更宽 wire union 里

### 误判二：既然 `StdoutMessageSchema` 包含它，它就等于普通 SDK message

错在漏掉：

- stdout/control wire 可见性比 core SDK message surface 更宽

### 误判三：只要 raw stream 能承载它，`print.ts` 最终结果里就该把它当普通消息

错在漏掉：

- `print.ts` 会在 terminal semantics 层主动过滤它

### 误判四：direct connect 既然能解析 raw `StdoutMessage`，那 callback 一定也能看到它

错在漏掉：

- `directConnectManager` 在 callback 暴露前显式 strip 掉 `post_turn_summary`

### 误判五：源码已经证明它运行时每轮必发

错在漏掉：

- 当前页面的硬证据是 admissibility + filtering，不是 emission frequency

## 第九层：稳定、条件与内部边界

### 稳定可见

- `post_turn_summary` 有独立 schema，但不属于 core `SDKMessageSchema`。
- `post_turn_summary` 属于更宽的 `StdoutMessageSchema` admissible set。
- `print.ts` 会把它排除在 terminal semantics 外。
- `directConnectManager` 会把它排除在 `SDKMessage` callback surface 外。

### 条件公开

- 它只有在实际被 emit、且 consumer 读的是更宽 raw stdout/control wire 时才可能被看见。
- `stream-json` 原始可见性还受 `--verbose` 约束。

### 内部 / 灰度层

- `@internal` 边界、opaque metadata slot，以及具体 emitter 路径与运行时频率。

## 第十层：苏格拉底式自检

### 问：为什么这页不能继续用“可见/不可见”二分法？

答：因为源码明明区分了 core SDK-visible、stdout/control wire-visible、terminal-visible、callback-visible 四层。二分法会直接把这些层级压平。

### 问：为什么 `directConnectManager` 值得进正文？

答：因为它把“更宽 wire 可见”与“最终 callback surface 可见”明确拆成了两层，这是本页最不该丢的证据。

### 问：为什么要强调“admissibility + filtering”，而不是 emission frequency？

答：因为这是当前源码稳能证明的边界；再往下写成“它通常会怎样 emit”就开始越界。

## 源码锚点

- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts`
- `claude-code-source-code/src/entrypoints/agentSdkTypes.ts`
- `claude-code-source-code/src/cli/print.ts`
- `claude-code-source-code/src/server/directConnectManager.ts`
