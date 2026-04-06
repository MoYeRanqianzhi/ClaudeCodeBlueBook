# `shouldIncludeInStreamlined(...)`、assistant/result 双入口、`streamlined_*` 与 `null`：为什么 streamlined path 的纳入 gate、替换入口与抑制返回不是同一种消息简化

## 用户目标

109 已经讲清：

- streamlined output 是 pre-wire rewrite
- 不是 terminal semantics 后处理

111 又已经讲清：

- builder/control transport、callback surface 与 UI consumer 不是同一张可见性表

但继续往下读时，读者仍然很容易把 streamlined path 自己内部的动作写平：

- 既然 `shouldIncludeInStreamlined(...)` 只让 `assistant` 和 `result` 进入，那是不是进入了就都属于同一种“消息简化”？
- `assistant` 变成 `streamlined_text` / `streamlined_tool_use_summary`，`result` 保持原样，这两者是不是只是在同一条简化链上的不同外观？
- 返回 `null` 的那些情况，是不是也只是“被简化到看不见”？

如果这些不拆开，正文最容易滑成一句错误总结：

- “streamlined mode 对纳入的消息统一做简化，只是输出形态不同。”

从当前源码看，这个结论并不成立。

## 第一性原理

更稳的提问不是：

- “哪些消息会进入 streamlined？”

而是先问五个更底层的问题：

1. 当前说的是纳入 gate，还是纳入后的动作？
2. 当前对象进入 streamlined path 后，会被 rewrite、passthrough，还是 suppression？
3. 当前 `assistant` 与 `result` 的共同点，是同样被纳入，还是同样被改写？
4. 当前 `null` 返回是在表达“被简化”，还是表达“根本不往这条 wire projection 发”？
5. 当前源码证明的是 helper gate，还是实际 emit contract？

只要这五轴不先拆开，后续就会把：

- same inclusion

误写成：

- same simplification

## 第一层：`shouldIncludeInStreamlined(...)` 只是粗粒度 gate，不是 rewrite contract

`streamlinedTransform.ts` 里：

- `shouldIncludeInStreamlined(message: StdoutMessage): boolean`
- 只返回 `message.type === 'assistant' || message.type === 'result'`

而且注释写得也很克制：

- useful for filtering before transformation

这说明这段 helper 回答的问题不是：

- “一旦纳入后要怎样统一改写”

而是：

- “哪些 family 值得被视作 streamlined path 的候选输入”

所以第一句就不能写成：

- `shouldIncludeInStreamlined(...)` 定义了 streamlined 消息会被怎样简化

更准确的说法是：

- 它只定义了一个 coarse inclusion gate

## 第二层：真正的 transformer 对 `assistant` 和 `result` 走的是两种完全不同的动作

`createStreamlinedTransformer()` 返回的是：

- `(message: StdoutMessage) => StdoutMessage | null`

它的 switch 里对 `assistant` 与 `result` 分流得很硬：

- `assistant`：要么 rewrite 成 `streamlined_text`
- 要么 rewrite 成 `streamlined_tool_use_summary`
- 要么在无文本且无 summary 时直接 `return null`
- `result`：注释明确写着 keep as-is，直接 `return message`

这说明即便都属于：

- `shouldIncludeInStreamlined(...) === true`

它们纳入后的动作仍然不是一类：

- `assistant` 更接近 replacement / projection
- `result` 更接近 passthrough / preserve

所以不能再写成：

- “assistant 与 result 都是被 streamlined 化的消息”

更准确的写法应是：

- 这两个 family 只是在纳入 gate 上同路，在 transform action 上并不同路

## 第三层：`assistant` 自己内部又不是一种统一的“简化”

即使只看 `assistant`，动作也不是单一的。

当前 transformer 对 `assistant` 至少分三种情况：

1. 有文本：产出 `streamlined_text`
2. 无文本但有累计工具摘要：产出 `streamlined_tool_use_summary`
3. 两者都没有：直接 `return null`

这说明 `assistant` 分支回答的问题也不是：

- “把 assistant 统一翻译成一类更短消息”

而是：

- 依据文本与累计工具状态，在 replacement family 与 suppression 之间选一个输出

因此 even within assistant：

- replacement
- replacement-of-different-kind
- suppression

也已经不是同一种“简化”

## 第四层：`null` 不是“另一种更短消息”，而是 suppression

这页最容易被写歪的一层，就是把：

- `return null`

理解成：

- “把消息简化到几乎没有内容”

但在当前控制流里，`print.ts` 是这样消费 transformer 的：

1. `const transformed = transformToStreamlined(message)`
2. only if `transformed` 存在，才 `structuredIO.write(transformed)`

这意味着返回 `null` 时，回答的问题不是：

- “现在要写出一个极简版消息”

而是：

- “当前这条原始消息不应该被写进这条 streamlined outgoing wire projection”

所以更准确的区分是：

- rewrite 是另一种输出对象
- passthrough 是保留原输出对象
- suppression 则是不输出对象

`null` 属于第三种，而不是第一种的极端版本

## 第五层：schema 也在支持这种三分，而不是统一“简化”

`coreSchemas.ts` 里只为两种 replacement family 提供了专门 schema：

- `streamlined_text`
- `streamlined_tool_use_summary`

描述也都在强调：

- replaces assistant message
- replaces tool_use blocks

而 `result` 没有对应的 streamlined schema，因为它并不是被改写成另一种 family，而是原样 passthrough。

这说明从 schema 视角看，当前 streamlined path 至少也有三种不同语义：

1. replacement family
2. passthrough family
3. no emitted family

所以不能把这三者一起压进：

- same streamlined simplification

## 第六层：`shouldIncludeInStreamlined(...)` 与当前 `print.ts` 主流程也不是同一件事

还要再钉死一层：

- 当前 `print.ts` 主循环并没有先调 `shouldIncludeInStreamlined(...)` 再决定是否 transform

它做的是：

- 只要 gate 打开，就直接对每条 `message` 调 `transformToStreamlined(message)`

这说明 helper 与实际 emit contract 之间又不是一层。

更准确的说法应是：

- `shouldIncludeInStreamlined(...)` 表达的是简化版 family gate intuition
- `createStreamlinedTransformer(...)` 才是当前主流程真正执行的 per-message contract

所以如果把 helper 的布尔返回，直接等同于：

- 当前 runtime 会如何写出

就会再次把层级写平。

## 第七层：当前源码能稳定证明什么，不能稳定证明什么

从当前源码可以稳定证明的是：

- `shouldIncludeInStreamlined(...)` 只纳入 `assistant` 与 `result`
- `assistant` 分支会在 `streamlined_text`、`streamlined_tool_use_summary` 与 `null` 之间分流
- `result` 分支是原样 passthrough
- 大量其他 family 直接 suppression
- `print.ts` 只有拿到非空 transformed object 才会写出

从当前源码不能在这页稳定证明的是：

- helper 一定参与当前主流程的实际 gating
- 所有 `assistant` 最终都会有 streamlined 输出
- 所有 `result` 都在所有宿主路径里扮演同一种保留角色

所以更稳的结论必须停在：

- inclusion gate != transformation action

而不能滑到：

- one unified streamlined simplification contract

## 第八层：为什么 112 不能并回 109

109 的主语是：

- streamlined output 为什么属于 pre-wire rewrite

112 继续往下压的主语则是：

- streamlined path 内部的 gate、rewrite、passthrough 与 suppression 为什么不是同一种动作

前者讲：

- timing

后者讲：

- action taxonomy inside that timing

不该揉成一页。

## 第九层：为什么 112 也不能并回 111

111 的主语是：

- transport、public SDK、callback 与 UI consumer 为什么不是同一张表

112 的主语已经换成：

- streamlined transformer 自己内部为什么也不是一张统一的“简化表”

前者讲：

- cross-layer visibility tables

后者讲：

- intra-transform action split

也必须分开。

## 第十层：最常见的假等式

### 误判一：被 `shouldIncludeInStreamlined(...)` 纳入，就等于都会被 streamlined 成同一种输出

错在漏掉：

- `assistant` 走 replacement/null，`result` 走 passthrough

### 误判二：`result` 原样保留和其他 family `return null` 本质一样，都是“没做转换”

错在漏掉：

- passthrough 仍然会写出对象，suppression 则根本不写

### 误判三：`null` 只是“更激进的简化”

错在漏掉：

- 在当前控制流里，`null` 的语义是 no outgoing projection

### 误判四：`assistant` 分支就是把消息统一变短

错在漏掉：

- 它还会在 text summary、tool summary 与 no output 三种状态间分流

### 误判五：helper gate 就等于当前 runtime 的真实 emit 规则

错在漏掉：

- 当前主循环直接调用的是 transformer，不是这个 helper

## 第十一层：苏格拉底式自审

### 问：我是不是把“进入这条路径”写成了“都做同一种动作”？

答：如果是，就把 gate 和 transform action 重新拆开。

### 问：我是不是把 passthrough 和 suppression 混成了“都没变”？

答：如果是，就回到 `structuredIO.write(transformed)` 只在非空时发生这一点。

### 问：我是不是又把 helper 当成了当前主流程的唯一真相？

答：如果是，就已经把 helper intuition 和 runtime contract 混在一起了。

### 问：我是不是把 112 又写成了 109 的时序复述？

答：如果是，就说明还没把动作 taxonomy 这个新主轴立起来。
