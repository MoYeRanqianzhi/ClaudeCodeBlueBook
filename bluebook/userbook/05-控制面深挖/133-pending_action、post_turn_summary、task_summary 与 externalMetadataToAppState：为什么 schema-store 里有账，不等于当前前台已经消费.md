# `pending_action`、`post_turn_summary`、`task_summary` 与 `externalMetadataToAppState`：为什么 schema/store 里有账，不等于当前前台已经消费

## 用户目标

132 已经把三条链路拆成了不同的前台状态消费拓扑：

- direct connect 更像 transcript projection
- remote session 更像 event projection + partial shadow
- bridge 才最接近 transcript/footer/dialog/store 对齐

但继续往下读时，读者又很容易在另一层犯错：

- `sessionState.ts` 里已经有 `pending_action`
- schema 里已经有 `post_turn_summary`
- `task_summary` 也已经定义好了
- `CCRClient` / `WorkerStateUploader` 还会把这些东西写进 `external_metadata`

于是正文就会滑成一句看似合理、实际上太快的话：

- “既然 schema/store 里都已经有了，前台只是还没把 UI 做完。”

这句也不稳。

从当前源码看，这里至少要拆四层：

1. schema / type 是否定义了这张账
2. runtime / worker store 是否真的写了这张账
3. restore path 是否把这张账读回本地
4. CLI 前台 consumer 是否真的消费了这张账

只要这四层不拆开，“有 producer/store” 就会被误写成 “有前台 consumer”。

## 第一性原理

更稳的提问不是：

- “这些字段现在到底支不支持？”

而是先问五个更底层的问题：

1. 这是 schema contract，还是当前 CLI contract？
2. 这是 worker-side persistence，还是 local `AppState` restore？
3. 这是 raw event 流，还是前台真正读到的 shadow state？
4. 这是 producer 已经写出，还是 consumer 已经接上？
5. 当前代码注释里提到“frontend 会读”，说的是哪个 frontend，CLI 还是别的前端？

只要这五轴先拆开，`pending_action`、`post_turn_summary`、`task_summary` 就不会再被写成：

- “既然定义了，就等于 CLI 前台已经有这张面”

## 第一层：`sessionState.ts` 定义的是正式账本，不是 CLI 已消费清单

`sessionState.ts` 当前很明确地定义了：

- `SessionState = 'idle' | 'running' | 'requires_action'`
- `SessionExternalMetadata`
  - `permission_mode`
  - `is_ultraplan_mode`
  - `model`
  - `pending_action`
  - `post_turn_summary`
  - `task_summary`

这里首先回答的是：

- 正式运行态账本有哪些 key

它并没有回答：

- 当前 CLI 前台到底消费了哪些 key

所以 `SessionExternalMetadata` 这层的主语是：

- schema / state contract

不是：

- foreground consumer contract

这也是这页最该先守住的第一条边界。

## 第二层：`pending_action`、`task_summary`、`post_turn_summary` 的 producer/store 确实存在

这一步也不能回避。

### `pending_action`

`notifySessionStateChanged(state, details)` 在：

- `state === 'requires_action' && details`

时会把 `details` 镜像到：

- `metadataListener?.({ pending_action: details })`

而在非 blocked 转移时又会：

- `pending_action: null`

所以 `pending_action` 不是纸面字段，

它当前确实有 producer。

### `task_summary`

`sessionState.ts` 直接写明：

- `task_summary` is written mid-turn by the forked summarizer

而在状态回到 `idle` 时又会：

- `metadataListener?.({ task_summary: null })`

再加上 `CCRClient.initialize()` 还会在 worker init 时显式清掉：

- `pending_action: null`
- `task_summary: null`

这说明当前 store 端也把这两个字段当作真实账本对待，

不是只留在注释里。

### `post_turn_summary`

`coreSchemas.ts` 里已经有完整的：

- `SDKPostTurnSummaryMessageSchema`

而 `print.ts`、`directConnectManager.ts` 里又都能明确过滤它。

这说明 `post_turn_summary` 也不是不存在，

而是：

- producer / schema 存在
- consumer 选择不前台消费

所以更稳的结论必须是：

- producer/store existence is real

而不是：

- 这些字段只是未来规划

## 第三层：worker-side store 存在，不等于 local `AppState` restore 存在

这是最容易被误判的一步。

`RemoteIO` 会把：

- `setSessionStateChangedListener`
- `setSessionMetadataChangedListener`

都接到：

- `ccrClient.reportState`
- `ccrClient.reportMetadata`

`CCRClient` 再把它们写到：

- `worker_status`
- `requires_action_details`
- `external_metadata`

然后 `WorkerStateUploader` 做 merge / coalesce / retry。

到这里为止，结论都还只是：

- worker-side store 已经接上

并不是：

- CLI 本地前台已接上

因为 restore 的下一步还要看：

- 当前有没有把 `external_metadata` 读回本地
- 读回来以后又恢复了哪些 key

这一步一旦漏掉，就很容易把：

- persisted

偷换成：

- foreground-consumed

## 第四层：`externalMetadataToAppState()` 当前只恢复极少子集

`print.ts` 在 hydrate / restore 时确实会做：

- `setAppState(externalMetadataToAppState(metadata))`

但关键在于：

- `externalMetadataToAppState()` 现在只恢复
  - `permission_mode`
  - `is_ultraplan_mode`

除此之外，只有：

- `metadata.model` 走了单独的 `setMainLoopModelOverride(metadata.model)`

也就是说即便 `metadata` 里已经带着：

- `pending_action`
- `task_summary`
- `post_turn_summary`

当前 CLI restore path 也没有把它们写回本地 `AppState`。

所以更稳的表述应该是：

- metadata restored from worker store
- but not fully rehydrated into local AppState

这一步已经足够推翻一种常见误写：

- “既然恢复了 external metadata，那这些字段本地肯定能用。”

## 第五层：当前 CLI 前台几乎没有这些字段的 consumer

再往下一步看当前 CLI 前台 consumer，

证据反而更硬。

### `pending_action`

全仓搜索里，和 CLI 相关的实际使用几乎停在：

- type definition
- metadata mirror
- store upload

并没有看到当前 REPL 前台去读：

- `external_metadata.pending_action.input`

更没有看到它被投成：

- dedicated dialog
- footer badge
- transcript line

所以它当前更像：

- stored but not foreground-consumed

### `task_summary`

这条线更明显。

全仓对 `task_summary` 的命中几乎只有：

- `SessionExternalMetadata` 定义
- `idle` 时清空
- `CCRClient.initialize()` 时清 stale

这意味着当前 CLI 前台根本没有一个明确的 consumer 去读它。

所以更稳的句子不是：

- “task_summary 只是还没接 UI”

而是：

- 当前 CLI 证据链里看不到明确 foreground consumer

### `post_turn_summary`

这条线比前两条更直接：

- `directConnectManager` 显式过滤 `system/post_turn_summary`
- `print.ts` 也在消息筛选里排除了 `post_turn_summary`
- remote session 的 `sdkMessageAdapter` 只吃 `init/status/compact_boundary` 等少数 `system` subtype，其他大多 ignored

这说明 `post_turn_summary` 当前不是“还没单独做 UI”，

而是已经被若干前台入口明确排除在可见消费链之外。

## 第六层：所以这里真正要避免的，不是“低估能力”，而是“高估前台消费”

把前面几层压成一句，最稳的一句其实是：

- schema/store presence does not imply CLI foreground consumption

大致可以压成下面这张矩阵：

| 对象 | schema/type | worker store | local restore | current CLI foreground consumer |
| --- | --- | --- | --- | --- |
| `pending_action` | 有 | 有 | 当前不进 `AppState` restore | 当前看不到明确 consumer |
| `task_summary` | 有 | 有 | 当前不进 `AppState` restore | 当前看不到明确 consumer |
| `post_turn_summary` | 有 | 消息层存在 | 不走 metadata restore | 当前若干入口显式过滤 / 忽略 |

所以真正该写进 userbook 的结论不是：

- “这些字段未来可能很重要”

而是：

- “当前 producer/store 已有，但 CLI 前台消费边界仍然非常窄”

## 第七层：为什么它不是 132 的重复页

132 讲的是：

- direct connect
- remote session
- bridge

三条链路为什么不是同一种 front-state consumer。

133 则只取其中一个更细的点继续往下压：

- 即使正式账本里已经有字段，也不代表 CLI 前台已经接了 consumer

一个讲：

- cross-path consumer topology

一个讲：

- producer/store vs local restore vs foreground consumer split

所以 133 不是把 132 重写一遍，

而是在 132 之下继续把“前台消费边界”再精确一层。

## 第八层：最常见的假等式

### 误判一：schema 里有，就说明 CLI 前台已经支持

错在漏掉：

- schema/type contract 不等于 foreground consumer contract

### 误判二：写进 `external_metadata`，就说明本地 `AppState` 已经恢复

错在漏掉：

- `externalMetadataToAppState()` 当前只恢复极少数 key

### 误判三：restore 读回 metadata，就说明 transcript/footer/dialog 一定会显示

错在漏掉：

- restore、state shadow、UI consumer 是三层不同问题

### 误判四：`post_turn_summary` 只是“暂时没单独做 UI”

错在漏掉：

- 当前多条前台链路已经显式过滤 / 忽略它

### 误判五：注释里写了“frontend 会读”，所以当前 CLI 一定已经读了

错在漏掉：

- 注释没有限定 frontend = 当前 CLI

## 第九层：stable / conditional / internal

### 稳定可见

- `SessionExternalMetadata` 当前正式定义了 `pending_action`、`post_turn_summary`、`task_summary`
- `pending_action` / `task_summary` 当前确实会进入 worker-side `external_metadata`
- `externalMetadataToAppState()` 当前只恢复 `permission_mode`、`is_ultraplan_mode`
- `model` 额外走单独恢复路径

### 条件公开

- `post_turn_summary` 当前在不同前台入口上的可见性取决于各自过滤链
- bridge v2 才真正把 metadata state 上传到 worker store，v1 仍是 no-op
- restore path 只在特定 hydrate / worker-state readback 条件下运行

### 内部 / 灰度层

- 注释里提到的 frontend 对 `pending_action.input`、`task_summary` 的读取者当前在本仓 CLI 里并不清楚
- `post_turn_summary` 在未来是否会接上某个 CLI consumer 目前仍属实现演化空间
- 目前“全仓搜不到 consumer”是强证据，但仍然比显式注释“永不消费”弱一层

这些更适合作为：

- 当前实现证据

而不是：

- 不可变化的产品承诺

## 第十层：苏格拉底式自审

### 问：我现在写的是 schema contract，还是 current CLI contract？

答：如果答不出来，就把定义层和消费层混了。

### 问：我是不是把 store persistence 偷换成了 local restore？

答：如果是，就把 worker-side 和 AppState-side 混了。

### 问：我是不是把 local restore 偷换成了 foreground rendering？

答：如果是，就把 restore 和 consumer 又压成一层了。

### 问：我是不是把“没看到 consumer”夸大成了“永远不会有 consumer”？

答：如果是，就把当前实现证据误写成永久产品承诺了。

### 问：我是不是又把 132 的三链路对比拿来重复书写？

答：如果是，就还没把 133 的边界压到字段级别。

## 源码锚点

- `claude-code-source-code/src/utils/sessionState.ts`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts`
- `claude-code-source-code/src/cli/remoteIO.ts`
- `claude-code-source-code/src/cli/transports/ccrClient.ts`
- `claude-code-source-code/src/cli/transports/WorkerStateUploader.ts`
- `claude-code-source-code/src/state/onChangeAppState.ts`
- `claude-code-source-code/src/cli/print.ts`
- `claude-code-source-code/src/server/directConnectManager.ts`
- `claude-code-source-code/src/remote/sdkMessageAdapter.ts`
