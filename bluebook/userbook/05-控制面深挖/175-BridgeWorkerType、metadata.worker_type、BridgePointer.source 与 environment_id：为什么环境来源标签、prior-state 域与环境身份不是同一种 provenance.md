# `BridgeWorkerType`、`metadata.worker_type`、`BridgePointer.source` 与 `environment_id`：为什么环境来源标签、prior-state 域与环境身份不是同一种 provenance

## 用户目标

174 已经把 register chain 内部继续拆成：

- local env key
- reuse claim
- live env
- session attach target

但如果正文停在这里，读者还是很容易把另一组“看起来都在标注来源”的字段重新写平：

- `workerType` 不就是在说明这是谁开的 bridge 吗？
- `metadata.worker_type` 不也是环境的一种身份吗？
- pointer 里的 `source: 'repl' | 'standalone'` 不也是在说来源吗？
- 既然这些都在分来源，那它们和 `environment_id` 的区别是不是只剩格式不同？

这句还不稳。

从当前源码看，bridge provenance family 至少还分成三种不同对象：

1. environment origin label
2. local prior-state trust domain
3. environment identity

如果这三层 provenance 不先拆开，后面就会把：

- `workerType`
- `metadata.worker_type`
- `BridgePointer.source`
- `environment_id`

重新压成同一种“这个 bridge 来自哪儿”。

## 第一性原理

更稳的提问不是：

- “这些字段是不是都在标记 bridge 的来源？”

而是先问五个更底层的问题：

1. 当前字段服务的是 web/client 侧的 origin filter、local prior-state 过滤，还是 runtime identity？
2. 当前字段活在 environment metadata、pointer artifact，还是 environment lifecycle 主链？
3. 当前字段如果换了值，系统影响的是 picker 过滤、prior reuse，还是真正的 environment identity？
4. 当前字段是代码内约束的有限集合，还是 wire-level 上的 opaque string？
5. 如果消费面、作用域和变更影响都不同，为什么还要把它们写成同一种 provenance？

只要这五轴不先拆开，后面就会把：

- origin label
- prior-state trust domain
- environment identity

混成一句模糊的“桥的来源标识”。

## 第一层：`workerType` 先是 origin label，不是 environment identity

`types.ts` 对 `BridgeWorkerType` 和 `BridgeConfig.workerType` 已经把语义写得很清楚：

- `BridgeWorkerType` 是 this codebase produces 的 well-known values
- 发送到 `metadata.worker_type`
- 让 claude.ai 可以按 origin 过滤 picker
- backend treats this as an opaque string

这说明 `workerType` 回答的问题不是：

- 当前 environment 在系统里唯一是谁

而是：

- 当前这个 environment 在“来源类别”上该被放进哪一类 UI / picker / origin 过滤

所以它的厚度更像：

- environment origin label

不是：

- environment identity

## 第二层：`metadata.worker_type` 是 wire-level filter 字段，不是本体身份

`bridgeApi.ts` 在 `registerBridgeEnvironment(...)` request body 里发送的是：

- `metadata: { worker_type: config.workerType }`

并且注释非常直白：

- web clients can filter environments by origin
- assistant picker only shows assistant-mode workers
- desktop cowork app sends `"cowork"`

这里最值钱的一点是：

- `worker_type` 被放进 `metadata`
- 而不是 `environment_id`
- 也不是 bridge 的主键面

这说明更准确的理解不是：

- `metadata.worker_type` 在给 environment 赋予身份

而是：

- 它在给 environment 增加一层可供前端筛选的来源标签

因此它的作用面是：

- filter / classification

不是：

- identity / lookup

## 第三层：`BridgePointer.source` 也在分来源，但它分的是 local prior-state trust domain

`bridgePointer.ts` 的 schema 里除了 `sessionId` / `environmentId` 之外，还有：

- `source: 'standalone' | 'repl'`

这很容易让人误以为：

- 它和 `workerType` 只是同一件事在本地文件里的另一种写法

但源码并不支持这个写法。

`replBridge.ts` 在 perpetual mode 初始化时会：

- `readBridgePointer(dir)`
- 只复用 `source: 'repl'` 的 prior pointer

而注释又继续说明：

- crashed standalone bridge 会写 `source:'standalone'`
- with a different workerType

这说明 `BridgePointer.source` 回答的问题不是：

- web/client 该把这个 environment 放进哪个 picker

而是：

- 当前这份 local prior-state artifact 是否属于可以被此宿主继续信任和复用的 trust domain

因此更准确的说法不是：

- `source` 与 `workerType` 都是环境来源标签，所以是一回事

而是：

- `workerType` 分的是 origin label
- `source` 分的是 local prior-state trust domain

## 第四层：`environment_id` 仍然是另一层对象身份，不应被来源标签偷换

不管前面是：

- `workerType`
- `metadata.worker_type`
- `BridgePointer.source`

后续 runtime 真正围绕的对象身份仍然是：

- `environment_id`

证据很直接：

- `registerBridgeEnvironment(...)` 返回 `environment_id`
- `pollForWork(environmentId, ...)`
- `deregisterEnvironment(environmentId)`
- `createBridgeSession({ environmentId })`
- env mismatch 也比较的是 environment IDs

这说明环境身份回答的问题是：

- 当前 lifecycle / attach / poll / deregister 具体绑定的是哪条 environment 对象

而不是：

- 它属于哪类来源

所以更准确的理解应是：

- origin label 和 trust domain 会影响谁看见、谁复用
- 但 identity 仍由 `environment_id` 负责

## 第五层：`workerType` 与 `source` 看似都在说 host provenance，但消费宿主完全不同

这是最容易写错的一层。

### `workerType`

- 在 `BridgeConfig` / `metadata.worker_type` 里出现
- 进入 register request
- 主要服务 web/client 的 environment filtering

### `BridgePointer.source`

- 只写进 local pointer artifact
- 主要服务 REPL perpetual / root `--continue` 等本地 prior-state 逻辑
- 不进入 environment registration metadata

因此它们虽都在描述某种“来源”，

但更准确的区分是：

- 一个是 remote-visible origin label
- 一个是 local trust-domain marker

只要这一层没拆开，正文就会把：

- picker filter
- prior reuse filter

误写成同一种 provenance。

## 第六层：`workerType` 连类型层都被刻意做成“代码内窄、wire 上宽”

`types.ts` 和 `replBridge.ts` 对这一点写得很清楚：

- 代码内 REPL 用 `BridgeWorkerType = 'claude_code' | 'claude_code_assistant'`
- 但 wire-level 字段接受 any string
- backend treats this as opaque
- desktop cowork sends `"cowork"`

这说明更准确的理解不是：

- `workerType` 是系统内一个封闭且强主权的身份枚举

而是：

- 代码内部为了 exhaustiveness 先收窄
- wire / backend / 多宿主生态里它仍是一层开放标签

所以它更像：

- label vocabulary

不是：

- identity schema

## 第七层：assistant-mode 只是在 origin label 上分叉，不是在 environment identity 上分叉

`initReplBridge.ts` 里写得很明确：

- 默认 `workerType = 'claude_code'`
- assistant mode 下改成 `claude_code_assistant`
- 目的是让 web UI 能 filter into a dedicated picker

这说明 assistant mode 回答的问题不是：

- 当前 environment 是否换成了另一种 identity space

而是：

- 当前 environment 在来源标签上是否应被放进 assistant 专用入口

所以更准确的结论不是：

- `claude_code_assistant` 是另一种 environment identity

而是：

- 它是另一种 origin label

## 第八层：为什么这页不是 24、33、173 或 174 的附录

### 不是 24 的附录

24 讲的是：

- auto
- mirror
- perpetual
- continue

这些 continuity / startup mode 为什么不是同一种重连。

175 讲的是：

- 来源标签、prior-state 域与 environment identity 为什么不是同一种 provenance

前者更像 continuity model，
后者更像 provenance semantics。

### 不是 33 的附录

33 讲的是：

- pointer 的写入、保留、清理与收口语义

175 只借用其中一条：

- `source:'repl'` / `source:'standalone'` 如何划本地 prior-state trust domain

主语已经不同。

### 不是 173 的附录

173 讲的是：

- env hint
- session env truth
- registered env result

175 讲的是：

- label / trust-domain / identity 三层 provenance

173 的主语是 environment truth thickness，
175 的主语是 provenance category。

### 不是 174 的附录

174 讲的是：

- register chain 里的 config key、reuse claim、live env、attach target

175 讲的是：

- 哪些字段根本不该被当成 environment authority 来读

174 更像 register authority，
175 更像 provenance non-equivalence。

## 第九层：专题内 stable / gray 也要分开

### 专题内更稳定的不变量

- `workerType` / `metadata.worker_type` 服务 origin filtering，不服务 identity。
- `BridgePointer.source` 服务 local prior-state trust domain，不服务 picker filtering。
- `environment_id` 才继续承担 environment lifecycle identity。
- assistant mode 改的是 origin label，不是 environment identity space。

### 更脆弱、应后置的细节

- `"cowork"` 等外部 producer 字符串
- KAIROS guard
- assistant picker 的具体前端实现
- pointer 与 workerType 的注释联动

更准确的写法不是：

- 这页在枚举所有 bridge host 变体

而是：

- 这页只抓 provenance label / trust-domain / identity 三层错位

## 苏格拉底式自审

### 问：如果删掉 `environment_id`，这页还成立吗？

答：不成立。因为没有 identity 这一层，就无法证明前面的 label 与 trust-domain 只是辅助 provenance，而不是对象主权。

### 问：为什么 `workerType` 不能直接被写成 environment identity？

答：因为它进入的是 `metadata.worker_type`，用于 origin filter，且 backend 把它当 opaque string，而不是 lookup 主键。

### 问：为什么 `BridgePointer.source` 也不能被写成 `workerType` 的本地镜像？

答：因为它服务的是 prior-state trust domain；perpetual REPL 只复用 `source:'repl'` 的 local pointer，而不是用它做 web/client 过滤。

### 问：这页是不是又写回 24 或 33 的 continuity / pointer 页面了？

答：不是。24/33 讲 continuity 与 pointer fate；175 讲的是 provenance semantics，主语已经换成 label、trust-domain 与 identity 的分裂。
