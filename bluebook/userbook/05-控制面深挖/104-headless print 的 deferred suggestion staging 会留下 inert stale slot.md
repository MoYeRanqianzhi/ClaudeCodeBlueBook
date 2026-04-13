# `pendingLastEmittedEntry`、`pendingSuggestion`、`lastEmitted`、`interrupt` 与 `end_session`：为什么 headless print 的 deferred suggestion staging 会留下 inert stale slot

## 用户目标

99 已经讲清：

- `pendingLastEmittedEntry` 为什么存在
- 它为什么必须和 `pendingSuggestion` 成对出现

102 又讲清：

- 已交付 suggestion 为什么不一定留下 accepted / ignored telemetry

但再往下一层读源码，读者还会碰到一个更容易被夸大、也更容易被写歪的问题：

- 为什么某些 cleanup 分支会清掉 `pendingSuggestion`，却不清掉 `pendingLastEmittedEntry`？
- 这是不是说明 suggestion staging 已经损坏了？
- 这会不会导致用户后来看到一条“幽灵 suggestion”？
- 这到底是外部协议 bug，还是内部 cleanup hygiene 的不对称？

如果这些不拆开，正文最容易滑成一句过度结论：

- “`pendingLastEmittedEntry` 没被一起清掉，所以 deferred suggestion 流有可见 bug。”

从当前源码控制流看，这个结论太重了。

本页不重讲 99 页的 staging creation / promotion，也不重讲 102 页的 delivered vs settled telemetry；这里只拆一条更窄的边界：当 `pendingSuggestion` 已被 cleanup 清掉而 `pendingLastEmittedEntry` 仍残留时，这个 deferred staging slot 为什么通常仍停留在 internal inert residue，而不会自动升级成新的 delivered suggestion、settled outcome 或外部协议 bug。换句话说，这里要裁定的是 cleanup asymmetry 能否通向 visible consequence，不是再论证 suggestion 是否已交付或 verdict 是否已结算。

## 第一性原理

更稳的提问不是：

- “有没有留下一个 stale slot？”

而是先问五个更底层的问题：

1. `pendingLastEmittedEntry` 自己单独存在时，算不算一条已交付 suggestion？
2. 它有没有任何脱离 `pendingSuggestion` 的独立 emit / promote / log 路径？
3. 哪些 cleanup 分支会一起清两者，哪些只清其一？
4. 即使留下 stale slot，后续控制流还有没有办法把它变成外部可见错误？
5. 这里讨论的是 protocol-visible bug，还是 internal state hygiene asymmetry？

只要这五轴没先拆开，后续就会把：

- stale internal staging

误写成：

- visible suggestion corruption

## 第一层：`pendingLastEmittedEntry` 天生就不是完整的已交付记录

`suggestionState` 的结构里：

- `lastEmitted` 带有 `emittedAt`
- `pendingLastEmittedEntry` 没有 `emittedAt`

这说明它从类型上就不是：

- 已经真正发出去、可直接用于 settlement 的 suggestion ledger

而只是：

- 等待在 deferred-delivery 路径上被升级的 tracking metadata

所以更准确的说法是：

- `pendingLastEmittedEntry` 是 incomplete staging record

不是：

- “另一种形式的 `lastEmitted`”

## 第二层：它只在 deferred-delivery 路径上被创建

`print.ts` 只有在：

- `heldBackResult` 存在

时，才会同时暂存：

- `pendingSuggestion`
- `pendingLastEmittedEntry`

否则代码走的是直接路径：

- 立刻 `output.enqueue(suggestionMsg)`
- 立刻写 `lastEmitted`

这说明 `pendingLastEmittedEntry` 回答的问题不是：

- suggestion 普遍都要先经过这一层

而是：

- 当主结果还在 hold back、suggestion 也必须延后交付时，tracking metadata 先暂存到哪里

所以它从一开始就是：

- deferred-only staging slot

不是通用协议对象。

## 第三层：promotion 的外层 gate 其实不是它自己，而是 `pendingSuggestion`

这页最值钱的源码事实在于 promotion 逻辑：

- 先看 `if (suggestionState.pendingSuggestion)`
- 只有进入这个块之后
- 才会检查 `pendingLastEmittedEntry`
- 再构造 `lastEmitted` 并补上新的 `emittedAt`

这说明在当前控制流下：

- `pendingLastEmittedEntry` 并没有单独升级成 `lastEmitted` 的资格

它必须依附于：

- 对应的 `pendingSuggestion` 仍然存在
- 且真的被发出

所以更准确的判断应是：

- `pendingSuggestion` 才是 promotion 的外层 gate
- `pendingLastEmittedEntry` 只是 gate 内部要带上的 tracking baggage

## 第四层：真正的不对称是“某些 cleanup 分支清了 `pendingSuggestion`，却没清 `pendingLastEmittedEntry`”

新 prompt intake 那条路径很对称：

- 清 `pendingSuggestion`
- 清 `pendingLastEmittedEntry`

但在：

- `interrupt`
- `end_session`

这些 control-path cleanup 分支里，源码会清：

- `lastEmitted`
- `pendingSuggestion`

却不会同步清：

- `pendingLastEmittedEntry`

这说明不对称本身是真实存在的，不能被抹掉。

但这里还不能立刻跳到“可见 bug”，因为还要继续问：

- 剩下的这个 slot 还有没有任何外部可见路径？

## 第五层：从当前控制流推断，这个 stale slot 更像 inert，不像外部协议 bug

这里需要非常克制地下结论。

从当前源码可见路径推断：

1. `pendingLastEmittedEntry` 的 promote 依赖 `pendingSuggestion`
2. `interrupt` / `end_session` 已经把 `pendingSuggestion` 清掉
3. 新 prompt 路径一开始又会把 `pendingLastEmittedEntry` 清掉
4. closeout / `output.done()` 路径只是放弃 suggestion state，并不会拿这个 slot 单独做 emit 或 outcome logging

这四点合起来，其实在回答三个更底层的问题：

1. 它还有没有独立 promote gate？
2. 它还有没有独立 emit 路径？
3. 它还有没有独立 settlement sink？

从当前正文已经拉出的控制流证据看，答案都偏向：

- 没有 `pendingSuggestion`，它就缺少升级成 `lastEmitted` 的外层 gate
- 没有单独 emit 路径，它就不会自己长成新的 `prompt_suggestion`
- 没有单独 settlement sink，teardown / close 也不会拿它补记 accepted / ignored outcome

因此更稳的说法不是：

- “这完全没有问题”

而是：

- 从当前控制流推断，它更像 inert stale staging
- 而不是会直接污染 `prompt_suggestion` 外部协议的 visible bug

换句话说，这条不对称更像：

- cleanup symmetry 不够整洁

而不是：

- consumer 会看到错误 suggestion

## 第六层：为什么 104 不能并回 99

99 讲的是：

- `pendingLastEmittedEntry` 为什么存在
- 为什么它要跟 `pendingSuggestion` 成对暂存

104 讲的主语已经换了：

- 当这对 staging 被部分 cleanup 时，为什么只剩下它一个也通常不会形成外部错误

前者是：

- creation and promotion semantics

后者是：

- cleanup asymmetry and inertness

不该揉成一页。

## 第七层：为什么 104 也不能并回 102

102 讲的是：

- 已交付 suggestion 为什么不一定留下 accepted / ignored settlement

104 则退回到更内部的一层：

- 某些分支里连“待升级 tracking metadata”都可能留下对称性残影
- 但这个残影未必能升级成任何外部后果

前者的主语是：

- telemetry settlement gap

后者的主语是：

- staging hygiene asymmetry

二者必须分开。

## 第八层：最常见的假等式

### 误判一：`pendingLastEmittedEntry` 留着，就等于还残留一条待发 suggestion

错在漏掉：

- 真正的外层 gate 是 `pendingSuggestion`

### 误判二：它没有被一起清掉，所以以后一定会被错误 promote

错在漏掉：

- 当前可见 promote 路径要求 `pendingSuggestion` 仍然存在

### 误判三：这个问题和 99 完全一样

错在漏掉：

- 99 讲 staging 的必要性；104 讲 cleanup 非对称后的 inertness

### 误判四：这已经足以证明存在用户可见协议 bug

错在漏掉：

- 从当前控制流推断，更接近 internal stale staging，而不是 visible stream corruption

### 误判五：既然只是内部问题，就不值得写

错在漏掉：

- 如果不单列，正文会继续把“内部残影”夸大成“外部协议缺陷”，或者反过来把清理不对称完全抹平

## 第九层：稳定层、条件层与灰度层

### 稳定可见

- `pendingLastEmittedEntry` 是 deferred internal staging record，不是完整已交付记录。
- 它只在 deferred-delivery 路径上创建。
- promotion 到 `lastEmitted` 的外层 gate 是 `pendingSuggestion` 已实际交付。

### 条件公开

- cleanup 非对称只会在先发生 deferred staging、随后又走特定 control/teardown 分支时出现。
- 从当前控制流推断，这个 stale slot 是否会留下后果，取决于后续是否还存在 `pendingSuggestion` 或新 prompt cleanup。

### 内部/灰度层

- `interrupt` / `end_session` 未同步清 `pendingLastEmittedEntry` 的 hygiene asymmetry。
- 这条结论里“更像 inert stale staging”属于基于当前源码路径的推断，不应写成公开稳定合同。

所以这页能安全落下的结论应停在：

- cleanup asymmetry != visible protocol bug

而不能继续滑成：

- orphan `pendingLastEmittedEntry` 必然会重新长成 ghost suggestion

## 第十层：苏格拉底式自检

### 问：为什么这页值得单列，而不是只在 102 末尾补一句？

答：因为 102 的主语是 telemetry settlement；104 的主语是 deferred staging 清理不对称，这已经不是同一层问题。

### 问：为什么要强调“从当前控制流推断”？

答：因为这页最重要的价值是保护稳定/灰度边界。我们能稳定证明“不对称存在”，但“它是否构成 visible bug”只能克制地基于现有路径下推。

### 问：为什么 `pendingSuggestion` 的 gate 性比 `pendingLastEmittedEntry` 本身更重要？

答：因为只要外层 gate 已经没了，孤立的 `pendingLastEmittedEntry` 就缺少升级成外部后果的通道。

## 源码锚点

- `claude-code-source-code/src/cli/print.ts`
- `claude-code-source-code/src/services/PromptSuggestion/promptSuggestion.ts`
