# `restoredWorkerState`、`externalMetadataToAppState`、`SessionExternalMetadata` 与 `RemoteIO`：为什么 CCR v2 的 metadata readback 不是 observer metadata 的同一种本地消费合同

## 用户目标

165 和 166 已经把 `print` 的 remote resume 路径拆成了：

- transcript hydrate
- metadata refill
- emptiness semantics

但如果正文停在这里，读者还是很容易把 `metadata refill` 再次压扁成一句：

- “CCR v2 既然把 remote worker metadata 读回来了，headless runtime 自然就会把这些 observer metadata 一起吃掉。”

这句还不稳。

从当前源码看，至少还要继续拆开四层：

1. transport 有没有 `restoredWorkerState` 这条 readback 能力
2. CCR worker init 读回的是不是一整袋 `external_metadata`
3. 同一袋 metadata 在 live runtime 里是不是还会被更宽地 publish / fan out
4. `print.ts` 当前真的把哪一部分 metadata 回灌到本地
5. `pending_action`、`task_summary`、`post_turn_summary` 这类 observer metadata 是不是因此自动获得同一种本地消费合同

如果这四层不先拆开，`metadata refill` 这句话就会继续偷换成：

- readback bag = local foreground contract

而当前实现不是这么组织的。

## 第一性原理

更稳的提问不是：

- “为什么有些 metadata 没恢复回来？”

而是先问五个更底层的问题：

1. 当前对象是 transport readback capability、worker store readback，还是 local foreground sink？
2. 当前 key 属于 durable execution config，还是 transient observer metadata？
3. 当前代码是在“把整袋 metadata 拿回来”，还是“把其中极窄子集写回本地状态树”？
4. 当前 host 缺 reader，是因为没有 readback，还是因为 admission gate 故意很窄？
5. 如果 readback、scrub、restore sink 与 foreground consumer 都不是同一层，为什么还要把它们写成同一种 metadata refill？

只要这五轴不先拆开，后面就会把：

- `restoredWorkerState`
- `SessionExternalMetadata`
- `externalMetadataToAppState(...)`
- `pending_action` / `task_summary` / `post_turn_summary`

重新压成一条模糊的“metadata 恢复链”。

## 第一层：`restoredWorkerState` 先是 transport capability，不是普遍 resume 合同

`StructuredIO` 默认把：

- `restoredWorkerState: Promise.resolve(null)`

写成一个空实现。

只有 `RemoteIO` 在 CCR v2 条件下：

- 创建 `CCRClient`
- 调 `initialize()`
- 再把 `this.restoredWorkerState = init.catch(() => null)`

挂回去。

这说明 `restoredWorkerState` 首先回答的问题不是：

- “resume 时所有宿主都会得到 remote metadata”

而是：

- “这个 transport family 有没有提供 worker metadata readback 能力”

所以它先属于：

- transport-scoped readback capability

不是：

- universal local restore contract

## 第二层：`CCRClient.initialize()` 读回的是宽 metadata bag，而且读回与 stale scrub 同时发生

`CCRClient.initialize()` 很值钱的一点是它没有把“读回旧状态”和“新 worker 立刻清 stale observer 值”写成同一个动作。

它会并发：

- `getWorkerState()`

同时又在 `PUT /worker` 时主动写：

- `pending_action: null`
- `task_summary: null`

后面再等待那个并发的 GET，并把：

- `data?.worker?.external_metadata ?? null`

作为 readback 结果返回。

这说明第二层的主语是：

- prior worker metadata readback

而不是：

- “旧 metadata 一旦读回，就都值得本地继续生效”

更关键的是，这里从初始化时序上就已经明说：

- observer metadata 里至少有一部分会被优先当成 stale risk

所以 readback 本身就不是 foreground admission proof。

## 第三层：同一袋 `external_metadata` 还存在更宽的 live publish / fanout path

如果只盯着 `print` resume，读者还是可能漏掉另一侧的事实：

- 当前系统并不是只有一个“metadata 恢复入口”
- 同一袋 metadata 还在 live runtime 中走更宽的 publish path

这条链至少包括：

- `notifySessionStateChanged(...)` 把 `pending_action` 镜像进 `external_metadata`
- `notifySessionMetadataChanged(...)` 作为 metadata 更新出口
- `RemoteIO` 把 metadata listener 接到 `ccrClient.reportMetadata(...)`

再加上 `sessionState.ts` 的注释直接写：

- frontend 会读 `external_metadata.pending_action.input`

这说明同一袋 `SessionExternalMetadata` 至少服务两类对象：

1. live observer-facing publish path
2. resume-time local refill path

所以更稳的判断不能写成：

- `external_metadata` 只有一条统一的消费链

而应该写成：

- live publish 很宽
- local refill 很窄

## 第三层：`SessionExternalMetadata` 的袋子比当前本地消费面宽得多

`SessionExternalMetadata` 同时列出：

- `permission_mode`
- `is_ultraplan_mode`
- `model`
- `pending_action`
- `post_turn_summary`
- `task_summary`

这说明它首先是：

- worker/remote side 的 metadata bag

但 metadata bag 的宽度并不自动回答：

- 当前 headless `print` 在恢复时到底消费其中哪些 key

所以这里最该防住的假等式是：

- type bag 宽度 = local sink 宽度

源码没有给这种承诺。

## 第四层：`print.ts` 的 CCR v2 路径确实会等待 readback，但本地 admission gate 非常窄

`print.ts` 在 CCR v2 remote resume 时会：

- `await Promise.all([hydrateFromCCRv2InternalEvents(...), options.restoredWorkerState])`

然后只有在 `metadata` 存在时才做两件事：

- `setAppState(externalMetadataToAppState(metadata))`
- `setMainLoopModelOverride(metadata.model)`

这一步极其关键，因为它说明：

- `print` 确实承认 readback 存在
- 但承认 readback 存在，不等于承认整袋 metadata 都进入同一种本地消费面

所以这一层更准确的说法是：

- narrow local admission after broad remote readback

不是：

- full observer metadata rehydration

## 第五层：`externalMetadataToAppState(...)` 当前只接纳 mode / ultraplan，`model` 还要走单独 override sink

`externalMetadataToAppState(...)` 当前只恢复：

- `permission_mode`
- `is_ultraplan_mode`

没有任何：

- `pending_action`
- `task_summary`
- `post_turn_summary`
- `model`

分支。

`model` 在恢复时还得继续走：

- `setMainLoopModelOverride(...)`

这说明当前本地 sink 至少已经被拆成两张账：

1. `AppState` 窄 mapper
2. main-loop model override sink

而 observer metadata 三兄弟甚至连这两张账都没进去。

所以这里不能再写成：

- “metadata refill 已经把 observer metadata 一起恢复给本地了”

更准确的写法只能是：

- 当前本地 admission 只接受少数 durable-ish 参数
- observer metadata 大多停在 readback bag / cross-surface intent 这一层

## 第六层：因此 `metadata refill` 应继续拆成“live publish”“readback”与“local consumption”三层

到这里，更稳的写法已经不是：

- CCR v2 有 metadata refill

而应该进一步改成：

1. live publish
   `notifySessionMetadataChanged(...)` / `reportMetadata(...)` 把 metadata 广播给 CCR / observer-facing surfaces
2. metadata readback
   `RemoteIO` / `CCRClient.initialize()` 允许 `print` 拿到 prior worker 的 `external_metadata`
3. local consumption
   `print.ts` 只把极窄子集落到 `externalMetadataToAppState(...)` 与 `setMainLoopModelOverride(...)`

这正是 167 和 166 的边界差异：

- 166 讲 remote recovery 内部有 transcript / metadata / emptiness 三层
- 167 讲 metadata 这一层内部，live publish、readback bag 与 local consumption sink 也不是同一种合同

## 第七层：为什么 `pending_action`、`task_summary`、`post_turn_summary` 不能借此被写成“已恢复本地前台”

如果顺着前面六层继续推，结论会更清楚：

- `pending_action` / `task_summary` 可能出现在 readback bag
- `CCRClient.initialize()` 又会优先清掉其中最容易 stale 的两项
- `print.ts` 当前并没有把它们写回本地 `AppState`
- `post_turn_summary` 甚至在当前 foreground path 里还会被显式过滤出主 consumer

所以它们更接近：

- wide metadata presence
- cross-surface or future/frontend intent

不是：

- 当前 headless `print` 的本地恢复面

也就是说，`metadata readback exists` 与 `observer metadata is locally consumed` 之间，源码明确放了一道窄 admission gate。

## 第八层：稳定、条件与灰度边界

### 稳定可见

- `StructuredIO` 默认没有 `restoredWorkerState`，`RemoteIO` 才在 CCR v2 下提供它。
- `CCRClient.initialize()` 会并发读回 worker metadata，并在 init 时清 `pending_action/task_summary` 的 stale 值。
- `notifySessionMetadataChanged(...) -> reportMetadata(...)` 构成更宽的 live metadata publish path。
- `print.ts` 当前只把 `permission_mode` / `is_ultraplan_mode` / `model` 这类窄子集接入本地 sink。

### 条件公开

- `restoredWorkerState` 只在 CCR v2 remote 路径里真正参与 resume。
- v1 ingress hydrate 可以恢复 transcript，但不提供同厚度的 worker metadata readback。

### 内部/灰度层

- `pending_action`、`task_summary`、`post_turn_summary` 未来是否会有新的 foreground consumer，当前代码没有给稳定保证。
- 注释里提到的 frontend read intent，更像跨前端设计空间，不等于当前 CLI foreground 已接上。

## 苏格拉底式自审

### 问：这页是不是 103 的重复版？

答：不是。103 的主语是 observer metadata 为什么不共享同一种恢复合同；167 的主语更窄，是 `print` 的 CCR v2 readback bag 为什么不等于 local consumption sink。

### 问：这页是不是 133 / 137 的重复版？

答：不是。133 / 137 主要讲 schema-store existence 与 cross-frontend consumer path；167 讲的是 readback capability 到 local admission gate 的窄化。

### 问：这页是不是 166 的附录？

答：不是。166 把 remote recovery 拆成 transcript / metadata / emptiness；167 再把 metadata 这层内部拆成 readback 与 consumption。

### 问：为什么一定要把 `StructuredIO` / `RemoteIO` 拉进来？

答：因为不先点破 transport capability，读者就会误以为所有 resume host 都天然拥有 `restoredWorkerState`。

### 问：为什么一定要把 `CCRClient.initialize()` 的 stale scrub 写出来？

答：因为这能直接证明 readback 本身并不是“原样继续生效”的签字，observer metadata 从一开始就被按 stale risk 区别对待。
