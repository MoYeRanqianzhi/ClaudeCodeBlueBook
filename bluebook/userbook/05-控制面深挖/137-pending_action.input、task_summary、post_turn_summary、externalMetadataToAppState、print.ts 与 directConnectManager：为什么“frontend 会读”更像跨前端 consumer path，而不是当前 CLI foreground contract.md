# `pending_action.input`、`task_summary`、`post_turn_summary`、`externalMetadataToAppState`、`print.ts` 与 `directConnectManager`：为什么“frontend 会读”更像跨前端 consumer path，而不是当前 CLI foreground contract

## 用户目标

133 已经把这条线先拆成：

- schema / store 里有账
- 不等于当前前台已经消费

但如果继续往下不补这一页，读者还是很容易被另一层表述带偏：

- `pending_action.input` 的注释明确写了 frontend 会读
- `task_summary` 明说是 mid-turn progress line
- `post_turn_summary` 还有完整 schema

于是正文又会滑成一句看似自然、实际上仍然过快的话：

- “既然源码都已经在说 frontend 了，那当前 CLI 只是还没把 UI 接出来。”

这句也不稳。

从当前源码看，这里至少还有一层必须单独拆开的边界：

- “frontend 会读” 更像跨前端 consumer path
- 不等于当前 CLI foreground contract

所以这页要补的不是：

- “这些字段有没有 producer/store”

而是：

- “这些字段当前更像哪种 frontend 在读，又是哪种 frontend 明确没读”

## 第一性原理

更稳的提问不是：

- “这些字段现在 CLI 到底支不支持？”

而是先问五个更底层的问题：

1. 注释里说的 frontend，到底是当前 CLI foreground，还是别的前端？
2. 当前字段存在于 schema / worker store / restore path / foreground reader 的哪几层？
3. 当前 foreground reader 如果真的存在，应该落在 `AppState`、components、hooks 还是 screens 哪一层？
4. 当前 wide wire 可见，是否就代表 core SDK-visible 或 CLI-visible？
5. 当前 `pending_action`、`task_summary`、`post_turn_summary` 是不是同一种稳定度？

只要这五轴先拆开，这三者就不会再被写成：

- “既然 frontend 会读，那 CLI 前台只是还没做完 UI”

## 第一层：`pending_action.input` 的注释说的是 frontend consumer，不是当前 CLI foreground consumer

`sessionState.ts` 对 `RequiresActionDetails.input` 的注释写得非常直接：

- `the frontend reads from external_metadata.pending_action.input`
- 目的是不用扫描 event stream，就能解析 question options / plan content

这里首先说明的是：

- 这个字段不是随手留下的杂项 JSON
- 它有明确的前端消费意图

但注意，这条注释并没有说：

- 当前 CLI foreground reads it

而且结合当前 repo 的 reader 检索来看，

- `src/state`
- `src/components`
- `src/hooks`
- `src/screens`

里都没有 `pending_action` 的现成 foreground reader。

所以更稳的结论必须是：

- `pending_action.input` 指向 real frontend intent
- but that frontend is not evidenced as the current CLI foreground

## 第二层：`task_summary` 的语义是“让长回合有中途进展面”，但当前 CLI foreground 仍没有对应 consumer

`sessionState.ts` 对 `task_summary` 的描述同样很关键：

- mid-turn progress line from the forked-agent summarizer
- so long-running turns still surface “what's happening right now”

这句话的主语也不是：

- “CLI transcript 马上会显示它”

而是：

- 有一条为了长回合进展而存在的外部状态语义

同时当前代码又做了两件很说明问题的事：

- `notifySessionStateChanged('idle')` 会清 `task_summary`
- `CCRClient.initialize()` 会在 worker init 时清 stale `task_summary`

这意味着 `task_summary` 当前确实是被当作一张真实账本在维护。

但同样重要的是：

- 当前 repo 里没有 `AppState` / component / hook / screen reader 去直接消费它

所以更准确的说法不是：

- “task_summary 已经是 CLI 前台 feature”

而是：

- `task_summary` is a real cross-surface progress field
- current CLI foreground still does not visibly consume it

## 第三层：`post_turn_summary` 的可见性更宽，但它仍然不是当前 core SDK / CLI foreground 的默认合同

`post_turn_summary` 这条线更容易误判。

因为它的 schema 很完整，

而且：

- `SDKPostTurnSummaryMessageSchema` 明确存在
- `StdoutMessageSchema` 也把它 union 进去了

这会让人很容易误写成：

- “既然进了 stdout wire，它当然也属于当前 CLI / SDK 主 consumer”

但源码并不是这么表达的。

第一，`coreSchemas.ts` 对它的描述本身就是：

- `@internal Background post-turn summary emitted after each assistant turn`

第二，它不在：

- `SDKMessageSchema`

这个 core union 里。

也就是说它当前更接近：

- wide wire visible
- but not core SDK-visible by default

这一步如果不拆开，

就会把：

- wire visibility

偷换成：

- current main consumer contract

## 第四层：`print.ts` 的 restore path 只恢复极少 metadata，当前没有把这三者回灌成 CLI foreground state

`print.ts` 在 CCR v2 restore 时确实会做：

- `setAppState(externalMetadataToAppState(metadata))`

但关键不在于“它调用了 restore”，

而在于：

- `externalMetadataToAppState()` 现在只恢复
  - `permission_mode`
  - `is_ultraplan_mode`

除此之外，只对：

- `metadata.model`

走了单独的 override。

也就是说即便 worker store 已经带回：

- `pending_action`
- `task_summary`
- `post_turn_summary`

当前 CLI restore path 也没有把它们写回本地 foreground state。

所以这一步最该写清：

- worker metadata restored
- but CLI foreground rehydration remains deliberately narrow

## 第五层：`print.ts` 和 `directConnectManager.ts` 还会主动绕开 `post_turn_summary`

如果说 restore path 的“没接上”还可以被误读成暂时遗漏，

那这一步就更明确了：

- 当前 consumer 不是没碰到它
- 而是主动绕开它

`print.ts` 在维护 `lastMessage` 时显式排除了：

- `system.post_turn_summary`

它解释得也很清楚：

- SDK-only system events are excluded so `lastMessage` stays at the result

`directConnectManager.ts` 在 forward wire message 时同样显式排除了：

- `system.post_turn_summary`

所以 `post_turn_summary` 当前在 CLI 里的状态不是：

- “还没遇到”

而是：

- “已经知道有这条线，但主 consumer path 选择绕开”

这和“前台只是还没做完 UI”已经不是一回事。

## 第六层：当前 foreground reader 缺席，本身就是边界证据，不是中立空白

这一步很容易被写轻。

因为很多人会觉得：

- “没有 reader 只能说明现在没人用，不能说明什么。”

但对这条链来说，current reader absence 本身已经是很强的边界证据。

当前 repo 里：

- `AppStateStore` 没有这三个字段的本地前台位
- `state/components/hooks/screens` 里没有对应 foreground reader
- `print/directConnect` 又对 `post_turn_summary` 有主动 narrowing

所以当前源码更接近在表达：

- 这些字段面向的是别的 frontend / 别的 consumer path
- 不是当前 CLI foreground contract

这不是“绝对永远不会变”，

但它已经足以说明：

- 当前实现边界是刻意存在的

## 第七层：因此这里更像“跨前端 consumer path”，不是“当前 CLI 前台 feature backlog”

把前面几层压成一句，更稳的一句是：

- “frontend 会读”更像跨前端 consumer path，而不是当前 CLI foreground contract

也就是说：

### `pending_action.input` 当前更像

- 外部 frontend 读取 `external_metadata` 的快捷面
- 避免扫描 event stream

### `task_summary` 当前更像

- 长回合中途进展字段
- 给非 CLI 单一 transcript 面准备的外部状态语义

### `post_turn_summary` 当前更像

- wide stdout wire 可见的 internal tail summary
- 但被当前 CLI 主 consumer path 主动绕开

所以这三者不能被压成一句：

- “CLI 只是还没把它们显示出来”

## 第八层：为什么它不是 133 的重复页

133 讲的是：

- schema/store 里有账
- 不等于 foreground consumer

137 讲的是：

- 注释里出现的 frontend intent
- 更像跨前端 consumer path
- 而不是当前 CLI foreground contract

一个讲：

- producer / store / restore / consumer 四层分离

一个讲：

- 哪个 frontend 在被暗示为 consumer

所以它不是简单重写 133，

而是在 133 的基础上继续压缩主语。

## 第九层：最常见的四个假等式

### 误判一：注释里说 frontend 会读，就等于当前 CLI foreground 会读

错在漏掉：

- 当前 CLI 前台没有对应 reader
- 注释没有承诺 consumer 就是 CLI

### 误判二：只要 `externalMetadataToAppState()` 被调用，metadata 就都回灌进本地前台

错在漏掉：

- 当前 restore 只恢复 `permission_mode` / `is_ultraplan_mode`
- `model` 也走单独通道

### 误判三：`post_turn_summary` 进入 `StdoutMessageSchema`，就等于它属于当前 core SDK / CLI 主合同

错在漏掉：

- 它不在 `SDKMessageSchema`
- 且描述本身还是 `@internal`

### 误判四：当前没显示它们，只是 UI 暂时没做

错在漏掉：

- `print` 和 `directConnect` 已经在主动绕开 `post_turn_summary`
- 这不是单纯“尚未接线”

## 第十层：stable / conditional / internal

### 稳定可见

- `pending_action.input` 注释明确存在 frontend consumer 意图
- `task_summary` 当前是被真实维护和清理的 worker-side字段
- `post_turn_summary` 当前是 wide stdout wire 可见、但不进 `SDKMessageSchema`
- 当前 CLI foreground 没有这三者的现成 reader
- `print` / `directConnect` 当前都主动 narrowing `post_turn_summary`

### 条件公开

- `pending_action.input`、`task_summary` 的真正主 consumer 更像外部 frontend / remote frontend；这是基于注释与 reader 缺席推出来的当前最稳解释
- 将来 CLI foreground 完全可以接上这些字段，但当前代码还没有这样做
- `task_summary` 的 producer 注释明确，但当前仓内看不到完整 emit site，所以它的落地厚度比 `pending_action` 更条件化

### 内部 / 灰度层

- `post_turn_summary` 描述本身带 `@internal`
- 它在 wire 层的可见性和未来 consumer 扩展仍带明显灰度
- 哪个 frontend 最终会把 `pending_action.input` / `task_summary` 做成稳定 UI，当前并不是 CLI 仓内公开合同

## 第十一层：苏格拉底式自审

### 问：我现在写的是 frontend intent，还是 CLI contract？

答：如果答不出来，就把“谁会读”写混了。

### 问：我是不是把 wide wire visibility 偷换成了 core consumer visibility？

答：如果是，就会把 `post_turn_summary` 写过头。

### 问：我是不是把 restore 被调用，偷换成了所有 metadata 都恢复进 foreground？

答：如果是，就漏掉了 `externalMetadataToAppState()` 的窄恢复面。

### 问：我是不是因为 `pending_action.input` 的注释很直白，就直接断言当前 CLI 前台已经有 consumer？

答：如果是，就没有尊重当前 reader 缺席这个负证据。

### 问：我是不是又回到 133 的“四层拆分”，而没有真正回答“frontend 指向谁”？

答：如果是，就还没真正进入 137。

## 源码锚点

- `claude-code-source-code/src/utils/sessionState.ts`
- `claude-code-source-code/src/state/onChangeAppState.ts`
- `claude-code-source-code/src/cli/transports/ccrClient.ts`
- `claude-code-source-code/src/cli/print.ts`
- `claude-code-source-code/src/server/directConnectManager.ts`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts`
