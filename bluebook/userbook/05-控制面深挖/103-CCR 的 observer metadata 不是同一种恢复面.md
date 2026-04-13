# `pending_action`、`task_summary`、`externalMetadataToAppState`、state restore 与 stale scrub：为什么 CCR 的 observer metadata 不是同一种恢复面

## 用户目标

51 页已经讲清：

- `pending_action`
- `task_summary`

都属于观察面，不是 phase 主状态。

52 页又讲清：

- `permission_mode`
- `is_ultraplan_mode`
- `model`

虽然都在 `external_metadata` 一侧出现，但写回链和恢复链并不相同。

再往下读源码，读者还会碰到一个更容易写错的问题：

- 既然 `pending_action` 和 `task_summary` 也在 `SessionExternalMetadata` 里，为什么 resume 时不把它们一起恢复回来？
- 为什么 CCR worker 启动时反而先把它们清成 `null`？
- 为什么系统会先 `GET /worker` 读回 metadata，却又主动 scrub 其中某些键？
- `external_metadata` 到底是“一张都能双向恢复的状态表”，还是一个混合了 durable config 与 observer state 的袋子？

如果这些不拆开，正文最容易滑成一句错误总结：

- “只要在 `external_metadata` 里，恢复时就应该一起回填到本地状态。”

源码不是这么设计的。

本页不重讲 52 页的 durable parameter restore 差异，也不重讲 transcript/internal-event resume 的内容恢复真相；这里只拆一条更窄的边界：`pending_action` / `task_summary` 虽然也挂在 `SessionExternalMetadata` 这个 bag 上，为什么却只享有 stale scrub first 的观察面合同，而不进入 `externalMetadataToAppState(...)` 或 `model` 那种本地 restore path。换句话说，这里要裁定的是 observer metadata 是否构成可信 restore input，以及 `GET /worker` readback、worker startup scrub、local restore adoption 分别属于哪一层恢复合同，不是再把 metadata bag 宽度写成单一对称恢复路径。

## 第一性原理

更稳的提问不是：

- “这些 key 是不是都存在于 `external_metadata`？”

而是先问五个更底层的问题：

1. 这个 key 代表 durable execution config，还是 transient observer state？
2. 它是为了让远端 UI 当前可见，还是为了让本地恢复时重新生效？
3. 当前恢复讨论的是 worker metadata，还是 transcript/internal events？
4. worker startup 读回旧状态，是为了 replay，还是为了决定哪些 stale 值必须立刻 scrub？
5. 这里讨论的是 type bag 的广度，还是真实 restore contract 的窄度？

只要这五轴没先拆开，后续就会把：

- one metadata bag
- multiple recovery contracts

误写成：

- “一张 metadata 表就应该有一条对称 restore path”

## 第一层：`SessionExternalMetadata` 很宽，不等于 restore contract 也同样宽

`sessionState.ts` 里的 `SessionExternalMetadata` 同时列出了：

- `permission_mode`
- `is_ultraplan_mode`
- `model`
- `pending_action`
- `post_turn_summary`
- `task_summary`

这说明它首先是一个：

- metadata bag

但 metadata bag 回答的问题只是：

- 这些键可能被写进远端 `external_metadata`

它并没有承诺：

- 这些键恢复时都会被本地对称回填

所以这页最先要防住的误判就是：

- type bag 宽度 = restore path 宽度

源码没有给出这种对称性。

## 第二层：`pending_action` 与 `task_summary` 的主语是 observer state，不是 durable config

`sessionState.ts` 对这两者的运行时语义写得很直白：

- `pending_action` 在进入 `requires_action` 时镜像出去
- 离开 blocked 态后就清 `pending_action`
- 回到 `idle` 时清 `task_summary`

这说明它们回答的问题不是：

- 下次恢复时，本地还该继续采用什么配置

而是：

- 远端侧当前应不应该显示“正卡在哪里”
- 这一轮此刻应不应该显示“正在做什么”

所以更准确的说法是：

- `pending_action` 与 `task_summary` 是 transient observer metadata

不是：

- “另一种可恢复会话参数”

## 第三层：CCR init 先 scrub stale 值，正说明它们不可信任作恢复输入

`ccrClient.ts` 的 `initialize()` 有一段很值钱的注释：

- clear stale `pending_action` / `task_summary` left by a prior worker crash

而它真的会在 `PUT /worker` 时写：

- `pending_action: null`
- `task_summary: null`

这说明 worker startup 对这两项的首要目标不是：

- 尽量把旧值恢复回来

而是：

- 防止上一代 crash 留下的 stale blocked/progress UI 污染新 worker

所以这里最该记住的一句是：

- 对 `pending_action` / `task_summary` 来说，recovery contract 是 stale scrub first

不是：

- replay previous observer state first

## 第四层：`GET /worker` 读回 metadata，不等于这些 observer key 会被本地 restore

`initialize()` 在 `PUT /worker` 之外，还会并发：

- `getWorkerState()`

把 prior worker 的 `external_metadata` 读回来。

但 `getWorkerState()` 这一步回答的问题并不是：

- “读回来就都拿去本地恢复”

而是：

- control requests 已处理且不会重投，需要知道 prior worker 留下了什么状态

接下来真正本地回填时，源码走的是：

- `externalMetadataToAppState(metadata)`

而这条 mapper 只处理：

- `permission_mode`
- `is_ultraplan_mode`

然后 `print.ts` 再单独处理：

- `metadata.model`

也就是说：

- `pending_action`
- `task_summary`

虽然可能被 `GET /worker` 读到，但不会被本地恢复回 `AppState`

所以更准确的结论是：

- readback metadata 不是 automatic local restore

## 第五层：真正的恢复还分成 metadata restore 与 transcript/internal-event resume 两条通道

`print.ts` 在 CCR v2 resume 时会并发等待：

- `hydrateFromCCRv2InternalEvents(...)`
- `options.restoredWorkerState`

这说明恢复本身已经至少分成两条通道：

1. transcript / internal events recovery
2. worker metadata recovery

而 `pending_action` / `task_summary` 更像第二条通道里的：

- 观察面 side state

不是第一条通道里的：

- 会话内容恢复真相

所以如果把：

- transcript resume
- metadata restore
- stale scrub

三者写成一个动作，正文就会立刻失焦。

## 第六层：`permission_mode` / `is_ultraplan_mode` / `model` 与 `pending_action` / `task_summary` 的恢复合同根本不同

52 页已经说明：

- `permission_mode` / `is_ultraplan_mode` 走 `externalMetadataToAppState(...)`
- `model` 单独走 `setMainLoopModelOverride(...)`

这批继续下压后，差异反而更清楚：

- 前者属于 durable execution config 或阶段性参数
- 后者属于 live observer metadata

也因此系统才会同时做两件看似矛盾、实则一致的事：

- 读回 prior worker metadata
- 又在 startup 立刻把 `pending_action` / `task_summary` 写成 `null`

因为它守的不是：

- “metadata key 越多越该恢复”

而是：

- “只有可信且值得重新生效的 key 才进入本地 restore path；会误导 UI 的 stale observer state 应优先 scrub”

## 第七层：最常见的假等式

### 误判一：只要 key 在 `SessionExternalMetadata` 里，恢复时就该一起回填

错在漏掉：

- metadata bag 宽度不等于 restore contract 宽度

### 误判二：`pending_action` / `task_summary` 和 `permission_mode` / `model` 都属于“远端会话参数”

错在漏掉：

- 前者是 observer state，后者才是更接近 durable config 的会话参数

### 误判三：既然 `GET /worker` 读回了旧 metadata，本地肯定会继续显示旧 blocked/progress 状态

错在漏掉：

- startup 会显式 scrub stale `pending_action` / `task_summary`

### 误判四：resume 的核心就是把 `external_metadata` 原样 replay 回本地

错在漏掉：

- transcript/internal events 与 metadata restore 是两条不同通道

### 误判五：startup scrub 和 restore path 是互相矛盾的设计

错在漏掉：

- 对 observer metadata 而言，scrub stale 本来就是 recovery contract 的一部分

## 第八层：稳定、条件与内部边界

### 稳定可见

- `pending_action` / `task_summary` 是 observer metadata，不是 durable local resume state。
- worker startup 会显式 scrub stale `pending_action` / `task_summary`。
- 本地 `externalMetadataToAppState(...)` 只恢复 `permission_mode` / `is_ultraplan_mode`；`model` 另走单独路径。
- `pending_action` / `task_summary` 即使被读回 metadata，也不会被本地对称恢复进 `AppState`。

### 条件公开

- 这条 restore 语义主要发生在 CCR v2 resume 路径。
- `getWorkerState()` 是否读到旧 metadata，和这些 observer key 是否进入本地 restore path，是两件不同的事。

### 内部 / 灰度层

- `currentState`、`hasPendingAction` 等 process-local sessionState 内存。
- transcript/internal-event recovery 的具体事件结构与持久化细节。

## 第九层：苏格拉底式自检

### 问：为什么这页不能并回 52？

答：52 讲 durable parameter 的 writeback / restore asymmetry；103 讲 observer metadata 的 stale scrub vs restore absence，主语已经变了。

### 问：为什么这页不能并回 51？

答：51 讲运行态投影面的类型分层；103 讲这些 observer metadata 在 crash / resume 时为什么不享有同一种 recovery contract。

### 问：为什么 CCR startup scrub 值得进正文？

答：因为它直接证明系统并不把 `pending_action` / `task_summary` 当成可信恢复输入，而把它们当成最容易 stale 的观察面残影。

### 问：为什么要把 transcript/internal events 单独提出？

答：因为否则读者会继续把“会话内容恢复”与“observer metadata 是否回填”写成一个恢复动作。

## 源码锚点

- `claude-code-source-code/src/utils/sessionState.ts`
- `claude-code-source-code/src/cli/transports/ccrClient.ts`
- `claude-code-source-code/src/state/onChangeAppState.ts`
- `claude-code-source-code/src/cli/print.ts`
