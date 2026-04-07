# `hydrateFromCCRv2InternalEvents`、`externalMetadataToAppState`、`hydrateRemoteSession` 与 `startup fallback`：为什么 `print` resume 的 remote recovery 不是同一种 stage

## 用户目标

163 已经把 `print.ts` 的 `--resume` 前置链拆成了：

- 标识符解析
- remote hydrate
- formal restore
- empty-session fallback
- rewind

但如果正文停在这里，读者还是很容易把 remote 相关动作压成一句：

- “先把远端会话拉到本地，如果没有内容就走 startup。”

这句还不稳。

从当前源码看，至少还有三层不同 remote recovery stage：

1. remote transcript materialization
2. remote metadata refill
3. empty-session startup fallback

它们都发生在 `print` resume 的 remote 路径周围，但不是同一种动作。

## 第一性原理

比起直接问：

- “remote resume 失败时到底发生了什么？”

更稳的问法是先拆五个更底层的问题：

1. 当前是在把远端 transcript 写回本地文件，还是在把 remote observer metadata 回填到 AppState？
2. 当前 remote hydrate 是通过 CCR v2 internal events 完成，还是通过 v1 session ingress 完成？
3. 当前得到空 transcript 时，系统是在宣告 hydrate 失败，还是在决定“这次应该被当作一个新 startup”？
4. 当前动作的输出是本地 transcript 文件、AppState metadata，还是 startup hook messages？
5. 如果这些层的输入、输出和 consumer 都不同，为什么还要把它们写成同一种 remote recovery？

这五问不先拆开，`print` resume 的 remote 路径很容易被误写成：

- “remote hydrate 成功或失败”的单层判断

而当前源码更接近：

- hydrate transcript
- refill metadata
- interpret emptiness

## 第一层：`hydrateFromCCRv2InternalEvents()` 与 `hydrateRemoteSession()` 先处理的是 transcript materialization

`sessionStorage.ts` 里的：

- `hydrateFromCCRv2InternalEvents(sessionId)`
- `hydrateRemoteSession(sessionId, ingressUrl)`

首先做的都不是恢复包生成，而是：

- `switchSession(asSessionId(sessionId))`
- 拉远端事件或日志
- 在本地 transcript path 写出内容

它们回答的问题是：

- “当前本地文件系统里有没有一份可以被后续 restore 读取的 transcript”

所以这层属于：

- remote transcript materialization

不是：

- AppState refill

也不是：

- startup fallback

这点要写死，因为很多人会把：

- “把远端事件写成文件”

和：

- “把运行时状态恢复回来”

混成一步。

## 第二层：CCR v2 还单独做了 `externalMetadataToAppState()` 与 `setMainLoopModelOverride()`

`print.ts` 的 CCR v2 分支比 v1 ingress 又多了一层：

- `const [, metadata] = await Promise.all([hydrateFromCCRv2InternalEvents(...), options.restoredWorkerState])`
- `setAppState(externalMetadataToAppState(metadata))`
- `setMainLoopModelOverride(metadata.model)`

这层回答的问题不是：

- “本地 transcript 文件有没有写出来”

而是：

- “远端 worker 当前的 metadata shadow 要不要回填到 headless 运行时状态”

所以这层属于：

- remote metadata refill

不是：

- transcript materialization

更不是：

- formal restore payload

这也解释了为什么同样是 remote resume，

CCR v2 比 v1 ingress 多了一层状态回填逻辑。

## 第三层：v1 ingress hydrate 和 CCR v2 hydrate 甚至不是同一种 remote source

再往下拆，`print.ts` 里的两种 remote hydrate 也不是一回事：

### CCR v2

- `hydrateFromCCRv2InternalEvents(sessionId)`
- 读 internal event reader
- 写 foreground transcript
- 再并行拿 `restoredWorkerState`

### v1 ingress

- `hydrateRemoteSession(sessionId, ingressUrl)`
- 通过 session ingress 拿 session logs
- 直接写本地 transcript

所以这里 even before restore，就至少还有：

- internal-event based hydrate
- ingress-log based hydrate

它们都叫 remote hydrate，

但不是同一种 remote source。

这页不需要把两边完全展开成新专题，

但必须点破：

- remote hydrate 也不是单根动作

## 第四层：`messages.length === 0` 的分支在 remote 路径里讨论的是“空结果如何被解释”，不是 hydrate 成败本身

`print.ts` 里最容易被写错的一条逻辑就是：

- `if (!result || result.messages.length === 0)`

很多人会把它写成：

- hydrate 失败

但源码并不是这么处理的。

如果当前是：

- URL
- 或 `CLAUDE_CODE_USE_CCR_V2`

那么空结果并不会直接报错，

而是：

- 执行 `processSessionStartHooks('startup')`
- 把这次运行解释成“已建立 remote context，但当前是空会话 startup”

反过来，如果只是普通 session id 且没有任何消息，

才会：

- `emitLoadError(...)`
- `gracefulShutdownSync(1)`

所以空结果这一层讨论的不是：

- transcript 是否已经 hydrate 成功

而是：

- emptiness semantics

这和 hydrate、本地 restore 都不是同一阶段。

## 第五层：startup fallback 产物不是 transcript，也不是 metadata，而是新的 startup hook payload

一旦远端空结果被解释成 startup，

系统回退到的不是：

- 旧 transcript replay

也不是：

- remote metadata refill

而是：

- `processSessionStartHooks('startup')`

换句话说，startup fallback 的输出是：

- 一个全新的 startup hook payload

不是：

- 从旧会话继续读出的恢复结果

这点非常关键，因为它说明 remote recovery 的终局不总是：

- “恢复旧状态”

也可能是：

- “确认旧会话为空，因此启动一个新的 startup 边界”

## 第六层：因此 `print` remote recovery 至少要拆成“三段”

把前面几层合起来，更稳的写法应该是：

1. remote transcript materialization
   `hydrateFromCCRv2InternalEvents()` / `hydrateRemoteSession()`
2. remote metadata refill
   `externalMetadataToAppState(metadata)` / `setMainLoopModelOverride(...)`
3. empty-session startup fallback
   空 transcript 时回退到 `processSessionStartHooks('startup')`

所以更准确的结论不是：

- remote resume 就是“hydrate 成功”或“hydrate 失败”

而是：

- remote recovery 自己内部也至少分成 transcript、metadata、emptiness semantics 三张账

## 第七层：这也解释了为什么 `print` remote 路径和普通本地 resume 不能写成同一种恢复证明

普通本地 resume 更像：

- 已经有本地 transcript
- 直接进入 `loadConversationForResume()`

而 `print` remote 路径在 formal restore 之前，可能还要经历：

- remote materialization
- metadata refill
- empty-session interpretation

所以它不是本地 resume 的简单远端版，

而是：

- 带有 remote recovery 前置层的 headless resume

## 苏格拉底式自审

### 问：为什么这页不是 163 的附录？

答：因为 163 讲的是 print pre-stage 总链；
165 继续往 remote 路径内部拆 hydrate / metadata / fallback 三层。

### 问：为什么一定要把 `externalMetadataToAppState()` 单列？

答：因为这能证明 CCR v2 remote 路径不只是“写 transcript 文件”，还会回填运行时状态。

### 问：为什么一定要把 empty-session fallback 单列？

答：因为它讨论的是“空结果的解释语义”，不是 hydrate 或 restore 本身。

## 边界收束

这页只回答：

- 为什么 `print` resume 里的 remote hydrate、metadata 回填与空会话 startup fallback 不是同一种 remote recovery stage

它不重复：

- 160 的 payload taxonomy
- 162 的 host family split
- 163 的 print pre-stage taxonomy
- metadata observer 相关旧页的更广泛状态消费话题

更稳的连续写法应该是：

- `print` host 自己内部不止一种 pre-stage
- remote recovery 自己内部也不止一种 stage
