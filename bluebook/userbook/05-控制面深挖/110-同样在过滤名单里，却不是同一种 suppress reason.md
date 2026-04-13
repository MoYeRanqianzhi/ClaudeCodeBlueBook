# `streamlined_*`、`post_turn_summary`、`createStreamlinedTransformer` 与 `directConnectManager`：为什么同样在过滤名单里，却不是同一种 suppress reason

## 用户目标

108 已经讲清：

- direct connect 对 `post_turn_summary` 的过滤，说明的是 callback consumer-path narrowing
- 不是 wire existence denial

109 又已经讲清：

- `streamlined_*` 是 write-time projection
- 不是 terminal semantics 后处理

但继续往下读时，读者仍然很容易把另一层差别写平：

- `directConnectManager` 既然把 `streamlined_text`、`streamlined_tool_use_summary` 和 `system.post_turn_summary` 一起放进 skip list，那它们是不是本质上都属于同一种“内部噪音”？
- 它们既然都不进 `onMessage` callback，是不是就可以压成同一种被 suppress 的 family？
- `StdoutMessageSchema` 既然都接纳它们，为什么还要说它们不是同一种上游对象？

如果这些不拆开，正文最容易滑成一句错误总结：

- “direct connect 同样过滤 `streamlined_*` 和 `post_turn_summary`，因为它们其实是同一种应该被静默掉的内部消息。”

从当前源码看，这个结论并不成立。

## 第一性原理

更稳的提问不是：

- “它们都被过滤了，不就一样吗？”

而是先问五个更底层的问题：

1. 当前比较的是 callback exclusion result，还是 upstream provenance？
2. 当前对象是 raw background family，还是 write-time projection artifact？
3. 当前对象是条件生成，还是在更宽 stdout/control wire 中被单独定义的 family？
4. 当前源码证明的是“同样不交给 callback”，还是“同样从同一来源长出来”？
5. 当前缺的是可见性分层，还是对象来源分层？

只要这五轴不先拆开，后续就会把：

- same skip list

误写成：

- same suppress reason

## 第一层：在 direct connect 的 callback 面上，它们的结果确实一样

`directConnectManager.ts` 的 parse gate 面向更宽的：

- `StdoutMessage`

而 callback contract 面向更窄的：

- `onMessage: (message: SDKMessage) => void`

同一个 manager 又在 skip list 里一起过滤：

- `streamlined_text`
- `streamlined_tool_use_summary`
- `system.post_turn_summary`

这说明只看 callback delivery result 时，它们的确有同一个表象：

- 都不会进入 direct-connect `onMessage` surface

而且 `controlSchemas.ts` 的 `StdoutMessageSchema` 也确实把它们并列接纳进更宽 union：

- `SDKStreamlinedTextMessageSchema()`
- `SDKStreamlinedToolUseSummaryMessageSchema()`
- `SDKPostTurnSummaryMessageSchema()`

所以这页不是要否认：

- 它们在 parse / callback 分层上有相同的 exclusion result

而是要继续往下问：

- 相同的 callback exclusion，是否来自相同的 upstream object identity？

答案是否定的。

## 第二层：`streamlined_*` 是 transformer 生成的 projection family，不是原生 raw summary family

`streamlinedTransform.ts` 很明确：

- `createStreamlinedTransformer()` 返回 `(message: StdoutMessage) => StdoutMessage | null`
- `assistant` 有文本时产出 `streamlined_text`
- `assistant` 只有工具调用时产出 `streamlined_tool_use_summary`
- `result` 原样 passthrough
- 大多数其他 family 直接 `null`

`print.ts` 也明确说明：

- `transformToStreamlined` 只在 feature、env var 与 `outputFormat === 'stream-json'` 同时成立时才创建
- `streamlined_*` 只由 transformer 产生

而 `coreSchemas.ts` 对两种 streamlined schema 的描述也都在强调：

- replace/replaces

这说明 `streamlined_*` 回答的问题不是：

- “系统原本发出了一条怎样的独立背景事件？”

而是：

- “streamlined output path 现在要把原始 assistant family 投影成什么样的替换对象？”

因此 direct connect 过滤 `streamlined_*` 时，更接近在切掉：

- conditional projection artifacts

不是在切掉：

- 独立存在的 raw background summary record

## 第三层：`post_turn_summary` 则是单独定义的 raw background summary family

`coreSchemas.ts` 对 `SDKPostTurnSummaryMessageSchema` 的定义与描述非常直接：

- `type: 'system'`
- `subtype: 'post_turn_summary'`
- `@internal Background post-turn summary emitted after each assistant turn`

这里最关键的是：

- 它不是 transformer 从别的 family 替换出来的
- 它也不是某种 terminal cursor 的派生显示对象

它回答的问题更接近：

- 一条独立的 background summary event，在更宽 stdout/control wire 上怎样被承认

所以 direct connect 过滤 `post_turn_summary` 时，更接近在切掉：

- raw summary tail family

而不是：

- write-time rewrite artifact

## 第四层：因此 same skip list 只是 same callback exclusion，不是 same object class

把前面三层合在一起，才能得到这页真正要钉死的判断：

- `streamlined_*` 与 `post_turn_summary` 在 direct connect 里确实同样不会进入 callback
- 但它们被切掉的“理由类别”不同

更准确地说：

- `streamlined_*` 被切掉，是因为 callback surface 不接纳这种 conditional write-time projection family
- `post_turn_summary` 被切掉，是因为 callback surface 也不接纳这种 raw background summary family

它们的共同点是：

- callback-visible surface 同样不消费

它们的不同点是：

- upstream provenance 根本不是一类

所以这页最需要避免的短路结论就是：

- “都在 skip list 里，所以它们是同一种 suppressed family”

## 第五层：这也解释了为什么不能把 `streamlined_*` 写成“另一种 `post_turn_summary`”

如果把二者压成同一种对象，正文就会连带犯下两个错误：

第一，会把 `streamlined_*` 误写成：

- 某种独立的系统尾流 family

但它其实是：

- streamlined path 对 assistant family 的替换式 projection

第二，会把 `post_turn_summary` 误写成：

- 某种显示优化或 projection artifact

但它其实是：

- 独立定义的 summary tail family

所以二者最准确的关系不是：

- A 是 B 的另一个别名

而是：

- 二者恰好都落在 direct-connect callback 不消费的那一侧，但来源与语义层级不同

## 第六层：稳定层、条件层与灰度层

### 稳定可见

- same callback exclusion, different upstream provenance
- `StdoutMessageSchema` 当前同时接纳 `streamlined_*` 与 `post_turn_summary`
- `SDKMessageSchema` 当前不接纳它们
- `directConnectManager` 当前会把它们一起挡在 `onMessage` callback 之外
- `streamlined_*` 的来源当前是 `createStreamlinedTransformer()` 的条件性 rewrite path
- `post_turn_summary` 的来源身份当前是单独定义的 background summary system family

### 条件公开

- direct connect 运行时是否总会遇到 `streamlined_*`，仍取决于当前 feature/env/outputFormat gate 与 transformer 分支
- direct connect 运行时是否总会遇到 `post_turn_summary`，仍取决于当前 upstream emit/cadence
- manager 是否会继续按同一套 skip 逻辑排除这两类 family，也仍取决于当前 host wiring 与 callback contract

### 内部/灰度层

- manager 是否“知道”这两种 family 的设计理由，并按不同理由执行不同分支
- skip-list 的 exact helper 顺序与 host wiring
- callback 外是否还保留别的 pre-filter consumer

所以更稳的结论必须停在：

- same callback exclusion, different upstream provenance

而不能滑到：

- manager 内部对两者有不同显式分类器

## 第七层：为什么 110 不能并回 108

108 的主语是：

- `post_turn_summary` 在 direct connect 里为什么属于 callback consumer-path narrowing

110 继续往下压的主语则是：

- 为什么在同一 skip list 里的 `streamlined_*` 与 `post_turn_summary` 不能被写成同一种 suppress reason

前者讲：

- one family vs callback surface

后者讲：

- two excluded families vs distinct provenance

不该揉成一页。

## 第八层：为什么 110 也不能并回 109

109 的主语是：

- `streamlined_*` 为什么属于 pre-wire rewrite，而不是 terminal post-process

110 的主语已经换成：

- 这个 projection family 与 `post_turn_summary` 同样被 direct connect 过滤时，为什么不能被视作同一种被 suppress 的对象

前者讲：

- rewrite timing

后者讲：

- exclusion reason split

也必须分开。

## 第九层：最常见的假等式

### 误判一：都在 direct connect 的 skip list 里，所以它们是同一种内部噪音

错在漏掉：

- 相同的 callback exclusion，不等于相同的 upstream provenance

### 误判二：`streamlined_*` 只是另一种 summary tail

错在漏掉：

- 它们是 transformer 生成的 replacement/projection family

### 误判三：`post_turn_summary` 只是另一种 streamlined 输出

错在漏掉：

- 它是独立定义的 background summary system family

### 误判四：manager 既然一起过滤它们，就说明两者一定同样常见、同样稳定

错在漏掉：

- `streamlined_*` 还受 feature、env var 与 outputFormat gate 约束

### 误判五：既然都不进 callback，就都可以写成“不存在”

错在漏掉：

- 这两类对象都属于更宽 `StdoutMessage` 层可承认的 family

## 第十层：苏格拉底式自审

### 问：我是不是把 callback exclusion result 直接写成了 object identity？

答：如果是，就把 “同样被挡住” 和 “来自哪里” 重新拆开。

### 问：我是不是把 `streamlined_*` 写成了独立 raw event？

答：如果是，就回到 `createStreamlinedTransformer()` 的 replacement contract。

### 问：我是不是把 `post_turn_summary` 写成了显示优化？

答：如果是，就回到它在 schema 里的 background summary 身份。

### 问：我是不是又在暗示 direct connect 运行时一定会同时遇到这两类对象？

答：如果是，就已经超出这页的条件证据范围了。
