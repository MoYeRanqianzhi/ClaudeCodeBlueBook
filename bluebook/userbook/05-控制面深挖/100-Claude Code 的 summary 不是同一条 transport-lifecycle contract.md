# `task_summary`、`post_turn_summary`、`SDKMessageSchema`、`StdoutMessageSchema` 与 ccr init clear：为什么 Claude Code 的 summary 不是同一条 transport-lifecycle contract

## 用户目标

98 和 99 已经把一条重要主线拆开了：

- `result` 的主结果语义不能被晚到尾流抢走
- suggestion 的生成、交付、记账也不是同一步

但读到这里，读者很容易又把另一组名字重新压回一团：

- `task_summary`
- `post_turn_summary`

最常见的误写是：

- “这两个都只是 summary，只是一个更早、一个更晚。”

源码给出的合同比这严格得多。这里真正要分清的是：

- 它们是不是同一种 carrier？
- 它们是不是同一种公开 SDK message？
- 它们是不是同一种清理/恢复对象？
- 它们会不会进入同一条常规输出路径？

如果这些边界不先拆开，正文就会把这里写成一条模糊的 summary 总线。

## 第一性原理

更稳的提问不是：

- “哪个 summary 更重要？”

而是先问六个底层问题：

1. 它回答的是“现在正在做什么”，还是“这一轮刚刚做了什么”？
2. 它是 `external_metadata`，还是 structured system message？
3. 它是否进入 public core SDK message union？
4. 它会不会在 `idle` 或 worker restart 时被主动清理？
5. 它会不会在 resume/restore 时重新注入本地 `AppState`？
6. 它会不会进入 CLI / direct connect 的常规转发或最终输出语义？

只有这六轴先拆开，后面才不会把：

- transient progress metadata
- after-turn recap event

误写成：

- “同一条 summary，只是时机不同”

## 第一层：源码一开始就没把它们声明成同一种对象

`sessionState.ts` 的 `SessionExternalMetadata` 里，二者虽然都出现了，但合同已经明显不对称：

- `task_summary?: string | null`
- `post_turn_summary?: unknown`

更关键的是注释：

- `task_summary` 被直接解释成 forked-agent summarizer 的 mid-turn progress line
- `post_turn_summary` 则刻意保持 opaque，避免把具体类型路径泄漏进公开声明

这说明即使在“名字都出现在 metadata 类型里”这一层，它们也不是同一强度的合同：

- 一个是明确的运行时进度行
- 一个是刻意保留边界的事后摘要槽位

所以这里第一句就不该写成：

- “SessionExternalMetadata 里有两个 summary 字段，所以它们本质相同。”

## 第二层：`task_summary` 回答的是“现在正在做什么”

`task_summary` 最硬的注释有两句：

- mid-turn progress line
- before `post_turn_summary` arrives

这两句已经把它的主语钉死了：

- 它服务的是 long-running turn 的“现在进行中可见性”
- 它不是 turn 结束后的 recap

也正因为如此，它在当前可见源码里表现为：

- CCR worker `external_metadata` 上的一条 string/null
- 而不是一条独立 SDK message schema

所以更准确的写法是：

- `task_summary` 是 live progress metadata

不是：

- “`task_summary` 是较短版的 `post_turn_summary`”

## 第三层：`task_summary` 的生命周期是短期可丢弃的

`sessionState.ts` 明写：

- 到 `idle` 时要把 `task_summary` 清掉
- 避免下一轮短暂看见上一轮进度

`ccrClient.ts` 在 worker init 时又补了一层显式防御：

- clear stale `pending_action` / `task_summary` left by a prior worker crash

这条证据非常值钱，因为它说明 `task_summary` 的真合同不是：

- “这是一份应该稳定保存的摘要”

而是：

- “这是运行中投影；turn 结束或进程崩溃后，宁可清掉，也不要让 stale progress 污染下一轮”

所以这页最该记住的一句是：

- `task_summary` 的设计优先级是 freshness，不是 persistence

## 第四层：`post_turn_summary` 回答的是“这一轮刚刚发生了什么”

`coreSchemas.ts` 给 `post_turn_summary` 单独建了结构化 schema：

- `type: 'system'`
- `subtype: 'post_turn_summary'`
- `summarizes_uuid`
- `status_category`
- `title`
- `description`
- `recent_action`
- `needs_action`
- `artifact_urls`

schema 描述也写得很清楚：

- emitted after each assistant turn

这说明它讨论的不是：

- “现在还在跑什么”

而是：

- “这一轮结束后，要不要再给宿主一份结构化 recap”

所以它的主语从一开始就和 `task_summary` 不一样：

- `task_summary` = mid-turn visibility
- `post_turn_summary` = after-turn recap

## 第五层：`post_turn_summary` 有 schema，不等于它属于 public core SDK message

这是最容易被漏掉的一层。

`coreSchemas.ts` 里：

- `SDKPostTurnSummaryMessageSchema` 单独存在
- 但 `SDKMessageSchema` 的 union 里并没有把它并进去

与此同时，`controlSchemas.ts` 的 `StdoutMessageSchema` 却把它包含进去了。

这说明源码守的是一条更细的边界：

- 它在更宽的 stdout/control 层可存在
- 但它不是 public core SDK message contract 的常规成员

所以“有 schema”不能直接推导出：

- “这就是普通 SDK message，所有 consumer 都该按同一方式看待它”

更准确的写法是：

- `post_turn_summary` 是一个存在于更宽输出层的结构化 side-channel event

## 第六层：常规 CLI / direct connect 路径会主动压掉 `post_turn_summary`

`print.ts` 在 `lastMessage` 过滤名单里显式排除了：

- `post_turn_summary`

这会直接影响：

- 默认文本输出
- 非 verbose JSON 最终输出
- exit code 依赖的 `lastMessage` / `result` 语义

也就是说，在 headless `print` 的常规收口里：

- `post_turn_summary` 可以存在于更宽的输出流世界
- 但它不能篡夺最终 `result` 的输出主位

`directConnectManager.ts` 也做了同类过滤：

- 转发 SDK messages 时排除 `system.post_turn_summary`

这说明它不是只在一个 callsite 被偶然忽略，而是在多条常规消费路径里都被有意压成“非主路径摘要尾流”。

所以更稳的结论是：

- `post_turn_summary` 有自己的 payload
- 但常规 CLI / direct connect 路径并不把它当 canonical result payload

## 第七层：resume / restore 也没把它们当成本地会话真相

`externalMetadataToAppState(...)` 当前恢复的重点其实很克制：

- `permission_mode`
- `is_ultraplan_mode`

`print.ts` 在 restore 时另外手动补：

- `model`

但当前可见恢复路径并没有把：

- `task_summary`
- `post_turn_summary`
- `pending_action`

重新注入本地 `AppState`。

这说明源码没有把这些 summary/progress 对象定义成：

- 会话恢复时必须回填的本地主状态

而是更接近：

- 外部观察面 / transport side state

这也解释了为什么：

- `task_summary` 会被积极清 stale
- `post_turn_summary` 会被允许存在于更宽输出层，却仍被常规消费路径过滤

## 第八层：最常见的假等式

### 误判一：`task_summary` 和 `post_turn_summary` 只是同一个摘要的早晚版本

错在漏掉：

- 一个是 mid-turn metadata，一个是 after-turn structured event

### 误判二：`task_summary` 也是普通 SDK message

错在漏掉：

- 当前可见源码只把它写成 `external_metadata` progress line

### 误判三：`post_turn_summary` 既然有 schema，就一定属于 public core SDK message

错在漏掉：

- 它不在 `SDKMessageSchema` union 里，却在更宽的 `StdoutMessageSchema` 里

### 误判四：resume 会把这些 summary 一起恢复成会话真相

错在漏掉：

- 当前 restore 路径并没有把它们回填到本地 `AppState`

### 误判五：只要能出现在流里，它就应该参与最终输出主位

错在漏掉：

- `print.ts` 和 `directConnectManager.ts` 都在常规路径上主动过滤 `post_turn_summary`

## 第九层：稳定、条件与内部边界

### 稳定可见

- `task_summary` 是 mid-turn progress metadata，不是 turn-end recap。
- `task_summary` 会在 `idle` 时清空；worker init 还会显式清掉 crash 后遗留的 stale `task_summary`。
- `post_turn_summary` 有独立 structured schema，主语是 after-turn recap，而不是当前正在做什么。
- `post_turn_summary` 不会进入 headless `print` 的最终 `result` 主位。

### 条件公开

- `post_turn_summary` 能否被看到，取决于 consumer 走的是更宽 stdout/control 层，还是常规 CLI / direct-connect 路径。
- `task_summary` 是否存在，取决于长任务是否还在进行、是否已经回到 `idle`、worker 是否经历过 restart cleanup。

### 内部 / 灰度层

- `post_turn_summary` 在 schema 上带有 `@internal` 边界。
- `post_turn_summary` 的具体生产路径在当前可见源码里不是这页要证明的重点。
- `SessionExternalMetadata.post_turn_summary` 目前仍保持 opaque typing，而不是展开成公开稳定类型。

## 第十层：苏格拉底式自检

### 问：为什么这页不能并回 51？

答：51 讲的是远端运行态投影面的大分层；这页讲的是 summary family 自己的 transport/lifecycle asymmetry，粒度已经更窄。

### 问：为什么这页也不该并回 98？

答：98 讲的是 `result` 为什么不让位给 late tail；这页讲的是 `task_summary` / `post_turn_summary` 自身的 carrier、union、clear、restore、filter 合同。

### 问：为什么 `ccr init clear` 值得进正文？

答：因为它直接证明 `task_summary` 不是“应该被保留的摘要真相”，而是“宁可丢，也不要 stale”的运行中投影。

### 问：为什么 `SDKMessageSchema` 与 `StdoutMessageSchema` 的差异这么关键？

答：因为它把“有 schema”继续拆成了“属于哪一层输出合同”，这正是读者最容易偷懒写平的地方。

## 源码锚点

- `claude-code-source-code/src/utils/sessionState.ts`
- `claude-code-source-code/src/cli/transports/ccrClient.ts`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts`
- `claude-code-source-code/src/cli/print.ts`
- `claude-code-source-code/src/server/directConnectManager.ts`
- `claude-code-source-code/src/state/onChangeAppState.ts`
