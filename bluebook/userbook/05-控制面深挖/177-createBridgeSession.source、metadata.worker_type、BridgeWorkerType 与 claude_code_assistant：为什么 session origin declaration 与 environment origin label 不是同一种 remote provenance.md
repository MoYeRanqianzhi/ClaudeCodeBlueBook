# `createBridgeSession.source`、`metadata.worker_type`、`BridgeWorkerType` 与 `claude_code_assistant`：为什么 session origin declaration 与 environment origin label 不是同一种 remote provenance

## 用户目标

176 已经把 `createBridgeSession(...)` request body 内部继续拆成：

- session attach target
- 来源声明
- 上下文载荷
- 默认策略

但如果正文停在这里，读者还是很容易把另一组“都在说来源”的字段重新写平：

- `source: 'remote-control'` 不就在说这条 session 的来源吗？
- `metadata.worker_type` 不也还是在说来源吗？
- `BridgeWorkerType` 不也就是来源枚举吗？
- `claude_code_assistant` 不就是 remote-control 的另一种 source 吗？

这句还不稳。

从当前源码看，remote provenance 至少还分成两种不同对象：

1. session origin declaration
2. environment origin label

如果这两层不先拆开，后面就会把：

- `createBridgeSession(... source: 'remote-control')`
- `metadata.worker_type`
- `BridgeWorkerType`
- `claude_code_assistant`

重新压成同一种“远端来源”。

## 第一性原理

更稳的提问不是：

- “这些字段是不是都在说明这条 remote session 来自哪里？”

而是先问五个更底层的问题：

1. 当前字段服务的是 session create 的来源声明，还是 environment registration 的来源标签？
2. 当前字段描述的是 session object family，还是 environment origin class？
3. 当前字段变化后，影响的是 session provenance 家族，还是 web/client 的 environment filtering？
4. 当前字段是对外更粗的来源声明，还是对 environment 侧更细的来源标签？
5. 如果字段同在 remote-control 族里，却回答不同对象层的问题，为什么还要把它们写成同一种 remote provenance？

只要这五轴不先拆开，后面就会把：

- session origin family
- environment origin label

混成一句模糊的“这条远端来源是谁”。

## 第一层：`source: 'remote-control'` 先回答 session 属于哪类来源家族

`createSession.ts` 的 request body 里明确写：

- `source: 'remote-control'`

而且 `createBridgeSession(...)` 顶部注释已经写明，这个 helper 同时被：

- `claude remote-control`
- `/remote-control`

两条入口共用。

这说明更准确的理解不是：

- `source: 'remote-control'` 在区分 standalone host 与 REPL host

而是：

- 不管是哪种 host，只要这条 session 是通过 remote-control family 创建出来的
- 它就落在同一个 session provenance family

所以它的厚度更像：

- session origin declaration

不是：

- environment origin label

## 第二层：`metadata.worker_type` 先回答 environment 该被放进哪类来源标签

`bridgeApi.ts` 在 `registerBridgeEnvironment(...)` request body 里发送：

- `metadata: { worker_type: config.workerType }`

对应注释也非常直接：

- web clients can filter environments by origin
- assistant picker only shows assistant-mode workers
- desktop cowork app sends `"cowork"`

这说明 `metadata.worker_type` 回答的问题不是：

- 这条 session 属于哪类来源家族

而是：

- 当前 environment 在 web/client 的视角里，应被归到哪类 origin bucket

所以它的厚度更像：

- environment origin label

不是：

- session origin declaration

## 第三层：`BridgeWorkerType` 只是代码内窄标签，不等于 session source 枚举

`types.ts` 对 `BridgeWorkerType` 的注释已经把边界说透：

- this codebase produces 的 well-known values
- sent as `metadata.worker_type`
- backend treats this as an opaque string
- wire-level fields accept any string

这说明更准确的理解不是：

- `BridgeWorkerType` 是系统级统一 provenance schema

而是：

- 它只是这个代码库内部对 environment origin label 的一个窄集合

所以更稳的区分应是：

- `source: 'remote-control'`：session provenance family 的声明
- `BridgeWorkerType`：代码内 environment origin label 的局部 vocabulary

## 第四层：`claude_code_assistant` 分的是 environment origin class，不是另一种 session source family

`initReplBridge.ts` 写得非常明确：

- 默认 `workerType = 'claude_code'`
- assistant mode 下改成 `claude_code_assistant`
- 目的是让 web UI 能 filter into a dedicated picker

这里最关键的一点是：

- assistant mode 改的是 `workerType`
- 不是 `createBridgeSession(... source: ...)`

而 `createBridgeSession(...)` 仍然统一写：

- `source: 'remote-control'`

这说明更准确的理解不是：

- `claude_code_assistant` 是另一种 session source family

而是：

- 它只是同属 remote-control family 之内，environment 侧再细分出来的一种 origin label

所以更准确的结论不是：

- `remote-control` 与 `claude_code_assistant` 是同一维度上的不同来源值

而是：

- `remote-control` 是 session family
- `claude_code_assistant` 是 environment label

## 第五层：同一 remote-control family 下，本来就允许多个 environment label

这层是本页最硬的一点。

如果 `source: 'remote-control'` 与 `metadata.worker_type` 真在回答同一个问题，

那么：

- 一条 session 的 `source`
- 与承载它的 environment 的 `worker_type`

应该至少在粒度上大体对齐。

但当前实现恰恰不是这样：

### session 侧

- `source` 统一是 `'remote-control'`

### environment 侧

- `worker_type` 至少可落在 `claude_code`
- `claude_code_assistant`
- 甚至更宽的 opaque string，如 `"cowork"`

这说明系统一开始就承认：

- 同一种 session provenance family
- 可以承载在多种 environment origin labels 上

因此它们绝不是同一层 provenance。

## 第六层：`SessionResource` 当前正面暴露 `session_context` 与 `environment_id`，并不等于 `source` 与 `worker_type` 也是同一张表

`utils/teleport/api.ts` 当前 typed `SessionResource` 里明确暴露：

- `environment_id`
- `session_context`

而没有把：

- `source`
- `worker_type`

放进同一层 typed surface。

这至少说明在当前代码可见的 durable readback 面里，

系统更直接承认的是：

- session 挂在哪条 env
- session 带了什么 context

而不是把 session source declaration 与 environment origin label 当作同一组稳定 readback 字段来消费。

更稳的说法不是：

- `source` 与 `worker_type` 只是暂时没显示出来的同类信息

而是：

- 就当前代码可见消费面而言，它们本来就不在同一张稳定可见性表上

## 第七层：因此 remote provenance 至少要沿 session / environment 两层分开

把前面几层合起来，更稳的写法应该是：

### session provenance family

- `source: 'remote-control'`
- 回答这条 session 属于哪类创建来源家族

### environment origin label

- `workerType`
- `metadata.worker_type`
- `claude_code_assistant`
- 回答承载这条 session 的 environment 在来源过滤上属于哪类标签

所以更准确的结论不是：

- 这些字段都只是“remote 来源”在不同位置的同义写法

而是：

- 一个在标 session family
- 一个在标 environment class

## 第八层：为什么这页不是 175、176 或 174 的附录

### 不是 175 的附录

175 讲的是：

- origin label
- trust-domain
- identity

176 讲的是：

- attach
- source declaration
- context
- policy

177 讲的是：

- `source` 与 `worker_type` 虽都在说来源
- 但它们分别落在 session 与 environment 两个对象层

所以 177 不是重复 175/176 的结论，而是在两页交叉处再切出对象层。

### 不是 174 的附录

174 讲的是：

- environment register authority

177 讲的是：

- session provenance family 与 environment origin label

174 的主语是 environment authority，
177 的主语是 remote provenance layering。

## 第九层：专题内 stable / gray 也要分开

### 专题内更稳定的不变量

- `source: 'remote-control'` 负责 session family declaration。
- `metadata.worker_type` 负责 environment origin filtering。
- `claude_code_assistant` 是 environment label，不是另一种 session source。
- 同一 session family 可以对应多种 environment labels。

### 更脆弱、应后置的细节

- `"cowork"` 等外部 producer string
- typed `SessionResource` 当前不暴露 source 的实现现状
- assistant picker 具体前端实现
- KAIROS guard

更准确的写法不是：

- 这页在枚举所有 remote-control 来源值

而是：

- 这页只抓 session family 与 environment label 的层次错位

## 苏格拉底式自审

### 问：如果删掉 `worker_type`，这页还成立吗？

答：不成立。因为这页的核心就是证明 session source declaration 与 environment origin label 不是同一层 provenance。

### 问：为什么 `source:'remote-control'` 不能被写成 environment label？

答：因为它在 `createBridgeSession` 里统一覆盖 standalone 与 `/remote-control`，不承担更细的 environment 过滤职责。

### 问：为什么 `claude_code_assistant` 不能被写成另一种 session source？

答：因为它只落在 `workerType` / `metadata.worker_type` 这条 environment label 线上，而 `createBridgeSession(... source: ...)` 仍统一写 `'remote-control'`。

### 问：这页是不是又写回 175 或 176 了？

答：不是。175 讲 label/trust-domain/identity；176 讲 create request body 内部字段主语；177 讲的是 session 与 environment 这两个对象层上的 provenance 分裂。
