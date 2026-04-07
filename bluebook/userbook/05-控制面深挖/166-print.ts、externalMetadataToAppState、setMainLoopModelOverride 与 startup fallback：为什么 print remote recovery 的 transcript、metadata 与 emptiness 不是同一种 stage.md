# `print.ts`、`externalMetadataToAppState`、`setMainLoopModelOverride` 与 `startup fallback`：为什么 `print` remote recovery 的 transcript、metadata 与 emptiness 不是同一种 stage

## 用户目标

165 已经把 `print` remote 路径拆成了：

- transcript hydrate
- metadata refill
- empty-session startup fallback

三张账。

但如果正文停在这里，读者还是很容易把这三层继续压成一句：

- “远端恢复回来以后，顺手把 metadata 也补上；如果没有内容就当新会话。”

这句还不稳。

从当前源码看，这三层虽然挨得很近，但它们各自回答的是完全不同的问题：

1. 远端 transcript 有没有被写回本地
2. 当前 headless runtime 要不要吃远端 metadata shadow
3. 空 transcript 最终应被解释成 startup 还是失败

所以它们不能继续被写成同一种 remote recovery。

## 第一性原理

比起直接问：

- “为什么 remote resume 还要分这么细？”

更稳的问法是先拆五个更底层的问题：

1. 当前输出是本地 transcript 文件，还是 AppState / model override，还是 startup hook messages？
2. 当前动作失败时，影响的是“没文件可读”、还是“状态没补全”、还是“空结果该怎么解释”？
3. 当前阶段会不会直接影响后续 `loadConversationForResume()` 的输入，还是只影响 headless runtime 的状态面？
4. 当前阶段是不是只在 CCR v2 出现，而 v1 ingress 没有？
5. 如果三层的输入、输出、触发条件和失败语义都不同，为什么还要把它们写成同一种 stage？

这五问不先拆开，读者很容易把：

- remote transcript
- observer metadata
- empty result semantics

继续压成一句“远端恢复”。

## 第一层：`hydrateFromCCRv2InternalEvents()` / `hydrateRemoteSession()` 先解决“有没有本地 transcript 文件”

`sessionStorage.ts` 里的：

- `hydrateFromCCRv2InternalEvents(sessionId)`
- `hydrateRemoteSession(sessionId, ingressUrl)`

最先处理的是：

- `switchSession(asSessionId(sessionId))`
- 把远端事件或日志写到本地 transcript path

这层回答的问题很单纯：

- “后续 restore load 有没有一个本地 transcript 文件可以读”

它不回答：

- “当前 headless runtime 的 metadata 该长成什么样”
- “空 transcript 最终该被解释成 startup 还是失败”

所以这层应该被写成：

- transcript materialization stage

不是：

- metadata refill stage

## 第二层：`externalMetadataToAppState()` / `setMainLoopModelOverride()` 回答的是“当前 headless 状态要不要借远端 shadow”

`print.ts` 的 CCR v2 路径在 hydrate 之后，还会并行拿：

- `options.restoredWorkerState`

随后再做：

- `setAppState(externalMetadataToAppState(metadata))`
- `setMainLoopModelOverride(metadata.model)`

这层回答的问题已经完全变了：

- 不是“本地有没有 transcript”

而是：

- “当前 headless 运行时的 observer metadata / model shadow 要不要用远端那份状态来回填”

所以这层更像：

- runtime state refill

不是：

- transcript hydrate 的尾巴

也就是说，哪怕 transcript 文件已经成功写出，

metadata refill 仍然可能是另一张独立的账。

## 第三层：这也说明 CCR v2 remote 路径比 v1 ingress 多了一张“metadata state”账

v1 ingress 路径更像：

- 从 ingress 拉日志
- 写本地 transcript

而 CCR v2 路径更像：

- 从 internal events 写 transcript
- 同时把 `restoredWorkerState` 回填到 AppState / model

这意味着“remote recovery”内部本身就已经至少分成：

- transcript lane
- metadata lane

所以如果正文把它们写成一句：

- “CCR v2 只是换了另一种 hydrate”

其实也不稳。

它还带着：

- 状态回填层

## 第四层：`messages.length === 0` 之后谈的是 emptiness semantics，不是 hydrate 成败

`print.ts` 里的：

- `if (!result || result.messages.length === 0)`

最容易被误写成：

- hydrate failed

但源码实际在判断的是：

- 这次空结果应该被解释成什么

如果当前是：

- URL
- 或 `CLAUDE_CODE_USE_CCR_V2`

那么系统会：

- 回退到 `processSessionStartHooks('startup')`

而不是直接报错。

反过来，普通 session id 空结果才会：

- `emitLoadError(...)`
- `gracefulShutdownSync(1)`

所以这里的主语根本不是：

- hydrate 有没有成功

而是：

- emptiness semantics

## 第五层：startup fallback 的产物是“新 startup payload”，不是“远端恢复残片”

一旦空结果被解释成 startup，

这条链的输出就不再是：

- 旧 transcript
- 远端 metadata shadow

而是：

- `processSessionStartHooks('startup')` 返回的新 startup hook messages

这点必须单独点出来，因为它直接说明：

- 空 remote transcript 并不天然意味着失败

也可能意味着：

- “确认当前没有旧内容，因此启动一个新的 startup 边界”

所以 fallback 的主语不是 recovery 本体，

而是：

- absence interpretation

## 第六层：因此 `print` remote recovery 至少应该拆成“三张账”

更稳的写法应该是：

1. transcript hydrate 账  
   远端事件 / 日志被写成本地 transcript 文件
2. metadata refill 账  
   remote worker metadata 被回填到 headless runtime
3. emptiness semantics 账  
   空 transcript 最终落成 startup 还是失败

所以更准确的结论不是：

- `print` remote recovery 就是“远端恢复成不成功”

而是：

- transcript、metadata、emptiness 是三种不同 recovery 维度

## 苏格拉底式自审

### 问：为什么这页不是 163 的附录？

答：因为 163 讲的是 `print` pre-stage 总链。

166 继续往 remote 路径内部拆 transcript / metadata / emptiness 三层。

### 问：为什么这页不是 162 的附录？

答：因为 162 的主语是 host family。

166 不再比较 `<REPL />` 和 `StructuredIO`，而只比较 `print` remote 路径内部的状态层。

### 问：为什么一定要写 `externalMetadataToAppState()`？

答：因为这就是最直接的证据，说明 remote recovery 不只是“写 transcript 文件”。

### 问：为什么一定要把 empty-session fallback 单列？

答：因为这层真正处理的是“空结果解释学”，不是 hydrate 或 metadata 自身。

## 边界收束

这页只回答：

- 为什么 `print` remote recovery 里的 transcript、metadata 与 emptiness 不是同一种 stage

它不重复：

- 162 的 host family split
- 163 的 print pre-stage taxonomy
- 165 的更宽 remote recovery 初拆
- 更一般的 observer metadata 消费页

更稳的连续写法应该是：

- `print` pre-stage 不止一种
- remote recovery 自己内部也不止一种状态维度
