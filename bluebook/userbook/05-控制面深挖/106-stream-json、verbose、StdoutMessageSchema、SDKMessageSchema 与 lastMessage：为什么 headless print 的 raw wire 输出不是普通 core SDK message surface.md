# `stream-json`、`verbose`、`StdoutMessageSchema`、`SDKMessageSchema` 与 `lastMessage`：为什么 headless print 的 raw wire 输出不是普通 core SDK message surface

## 用户目标

20 页已经讲过：

- `stream-json` 不是普通 JSON 开关，而是持续协议流入口

101 页又讲过：

- `result` 是终态语义
- 但不是流读取终点

105 页继续说明：

- `post_turn_summary` 不是 core SDK-visible，却不等于完全不可见

但到这一步，读者仍然很容易把另一层写平：

- `--output-format=stream-json --verbose` 既然会持续吐消息，那它吐出的就应该是普通 core `SDKMessage`
- 或者它只是把默认 JSON 输出多刷了几行

这两种理解都不够精确。

真正更细的问题是：

- `stream-json --verbose` 到底在输出哪一层对象？
- 它和默认 text/json 收口、和 core `SDKMessage` public surface，到底差在哪里？
- 为什么源码要求 `stream-json` 必须配 `--verbose`？
- `lastMessage` 过滤为什么在这个模式下不再负责“写出什么”，却仍然决定别的模式的终态语义？

如果这些不拆开，正文最容易滑成一句错误总结：

- “`stream-json --verbose` 就是把普通 SDK message 原样打印出来。”

源码给出的合同更宽，也更窄。

## 第一性原理

更稳的提问不是：

- “它输出的是不是 JSON？”

而是先问五个更底层的问题：

1. 当前输出的是 terminal final payload，还是 raw stdout wire frame？
2. 当前对象属于 core `SDKMessage`，还是更宽的 `StdoutMessage`？
3. 当前 path 是默认 text/json 收口，还是 continuous stream forwarding？
4. `--verbose` 在这里改变的是信息厚度，还是协议层级？
5. 这里讨论的是 public SDK surface，还是 SDK builder / control transport 可见性？

只要这五轴没先拆开，后续就会把：

- stream-json raw wire

误写成：

- “普通 JSON 模式的加强版”

## 第一层：源码先把 `stream-json` 和默认收口分成了两套输出合同

`print.ts` 在 `--print` 模式里先明确要求：

- `--output-format=stream-json` 必须搭配 `--verbose`

这已经说明它不是：

- 默认终态收口的一个轻量变体

而是：

- 进入另一条更宽、更连续的输出合同

随后在主循环里，源码对输出分成三种：

1. streamlined transformer path
2. `stream-json && verbose`：每条 raw `message` 直接 `structuredIO.write(message)`
3. 其他模式：不直接逐条写，而在循环结束后再走 `outputFormat` switch 收口

所以这里最先要钉死的一句是：

- `stream-json --verbose` 走的是 raw streaming write path

不是：

- “默认 JSON/text 收口再多带一点日志”

## 第二层：这个 raw write path 面对的是更宽的 stdout wire，不只是 core `SDKMessage`

105 已经证明：

- `post_turn_summary` 不在 core `SDKMessageSchema`
- 却在更宽的 `StdoutMessageSchema` 里

而 `print.ts` 的 raw `structuredIO.write(message)` 正是发生在：

- 逐条消息 arriving 的时刻

这意味着在 `stream-json --verbose` 这条路径上，consumer 面对的不是：

- 只剩 public/core SDK message 的窄面

而是：

- 更接近 stdout wire 的宽面

更稳的写法应是：

- `stream-json --verbose` 让 consumer 接近 `StdoutMessage` 层

不是：

- “它只是在不断输出 ordinary `SDKMessage`”

## 第三层：`lastMessage` 过滤在这个模式下仍然存在，但它不再决定“写出什么”

这页最容易被漏掉的一层是：

- `lastMessage` 过滤逻辑并没有消失

它仍然继续维护：

- filtered terminal cursor

但在 `stream-json --verbose` 模式下，真正写出的对象已经在循环体里逐条落到输出：

- `await structuredIO.write(message)`

所以这时 `lastMessage` 的职责不再是：

- 决定 raw stream 要不要写出某条消息

而是：

- 继续为其他收口路径维护终态语义所需的 cursor

这说明源码把两件事彻底拆开了：

1. raw wire forwarding
2. terminal final semantics

所以不能再写成：

- “`lastMessage` 过滤掉的就一定不会出现在 `stream-json --verbose` 里。”

## 第四层：默认 text/json 和 `stream-json --verbose` 的主语根本不同

`outputFormat` switch 里：

- `json` non-verbose：只输出单个 `lastMessage`
- `json` verbose：输出过滤后的 `messages` 数组
- `default text`：根据 filtered `result` 决定文本收口
- `stream-json`：注释直接写了 `already logged above`

这说明：

- `json` / `text` 模式的主语是“最终该如何收口”
- `stream-json --verbose` 的主语是“协议流原始事件怎样逐条转发”

所以更准确的区分是：

- text/json：terminal contract
- stream-json --verbose：wire contract

而不是：

- “三种只是格式外观不同”

## 第五层：为什么 `--verbose` 在这里不是“多打点日志”，而是进入 raw wire 厚度

如果 `stream-json` 不要求 `--verbose`，系统就会遇到一个语义冲突：

- 你到底想要 final result 的 JSON 收口
- 还是想要逐条 raw wire event

源码直接禁止这种模糊状态：

- `stream-json` without `--verbose` -> error and exit

这说明 `--verbose` 在这里的意义不是：

- “多一点辅助细节”

而是：

- 明确声明 consumer 要的是 wider raw message stream，而不是被终态 cursor 收窄后的结果

所以在这条路径上：

- `--verbose` 不是附属参数
- 它是 raw-wire contract 的开启闸门

## 第六层：这也解释了为什么 SDK builders 和普通 SDK consumers 看到的面不一样

`agentSdkTypes.ts` 明确说：

- 普通 SDK public API 以 `sdk/coreTypes.ts`、`sdk/runtimeTypes.ts` 为主
- SDK builders 如需 control protocol types，应直接走 `sdk/controlTypes.ts`

这和 `stream-json --verbose` 的行为是对齐的：

- 它更接近 builder/control transport 所需的更宽面
- 而不是普通 public SDK consumer 默认会拿到的窄面

所以更准确的说法是：

- `stream-json --verbose` 把 headless `print` 推向 builder/control-facing wire view

而不是：

- “把 public SDK message surface 原样展开”

## 第七层：为什么 106 不能并回 105

105 的主语是：

- `post_turn_summary` 自己的 visibility ladder

106 的主语已经换了：

- 整个 `stream-json --verbose` 路径到底面对哪一层 raw wire
- 以及它为什么不等于普通 core `SDKMessage` surface

前者是：

- one message family visibility

后者是：

- one output mode contract

不该揉回一页。

## 第八层：为什么 106 也不能并回 20

20 页讲的是：

- headless `print` 不是没有 UI 的 REPL
- `stream-json` 是协议流入口

106 继续下压的却是：

- 进入协议流以后，consumer 到底拿到的是更宽 stdout wire、还是普通 core SDK message

前者是：

- mode/entrypoint semantics

后者是：

- runtime message-layer semantics

也必须分开。

## 第九层：最常见的假等式

### 误判一：`stream-json --verbose` 就是在不断打印 ordinary `SDKMessage`

错在漏掉：

- 这条路径更接近 wider stdout wire，而不是仅 core SDK surface

### 误判二：它只是默认 JSON 模式加了更多日志

错在漏掉：

- 默认 json/text 是终态收口；`stream-json --verbose` 是 continuous raw forwarding

### 误判三：`lastMessage` 过滤掉的对象就不会出现在 `stream-json --verbose` 里

错在漏掉：

- 在这个模式里 raw `message` 已经先被逐条写出，`lastMessage` 不再决定“写不写”

### 误判四：`--verbose` 只是调试厚度，不影响协议层级

错在漏掉：

- 它在这里其实是 raw-wire contract 的开启条件

### 误判五：源码已经证明这条路径只会看到 public SDK API 的对象

错在漏掉：

- builder/control transport 面本来就比 public core SDK surface 更宽

## 第十层：稳定、条件与内部边界

### 稳定可见

- `stream-json` 在 `--print` 下必须搭配 `--verbose`。
- `stream-json --verbose` 会逐条 raw write 消息，而不是等终态收口。
- 默认 text/json 与 `stream-json --verbose` 的主语不同：前者是 terminal contract，后者是 wire contract。

### 条件公开

- 这条路径能看到多宽的消息面，取决于 upstream 实际 emit 了什么，以及 consumer 读的是哪条 stdout/control wire。
- streamlined transformer 开启时，又会改走另一条变换后的 streaming path。

### 内部 / 灰度层

- `StdoutMessage` 的具体类型定义与 control builder 子路径。
- 哪些 raw message family 当前运行时常见、哪些只是 schema-admissible。

## 第十一层：苏格拉底式自检

### 问：为什么 `--verbose` 值得进标题？

答：因为没有它，`stream-json` 这条 raw wire 路径根本不会开放；这里它不是装饰，而是协议闸门。

### 问：为什么要强调 `already logged above`？

答：因为那句最直接说明 `stream-json` 分支不再走终态收口逻辑，而是把“写什么”这件事前移到了 streaming loop 里。

### 问：为什么不能把这页写成“哪些消息会出现在 stream-json 里”的列表？

答：因为当前最重要的是 message-layer contract，不是再做一份 family 目录学。

## 源码锚点

- `claude-code-source-code/src/cli/print.ts`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts`
- `claude-code-source-code/src/entrypoints/agentSdkTypes.ts`
