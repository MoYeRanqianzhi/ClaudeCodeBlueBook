# `print --continue`、`print --resume session-id`、`print --resume url` 与 `loadConversationForResume`：为什么同属 headless resume，也不是同一种 source certainty

## 用户目标

169 已经把更宽的接续来源拆成三类：

- stable conversation history source
- conditional remote-hydrated transcript source
- bridge pointer continuity source

但如果正文停在这里，读者还是很容易把 `print` 这条线继续写平：

- `print --continue` 也是恢复旧会话
- `print --resume` 也是恢复旧会话
- 区别无非是一个自动找、一个手动指定

这句还不稳。

从当前源码看，即使只留在 `print` / headless host 内部，

它也至少还分成三种不同的 source certainty：

1. implicit recent local source
2. explicit local artifact source
3. conditional remote materialization source

如果这三种 certainty 不先拆开，后面就会把：

- `print --continue`
- `print --resume <session-id>`
- `print --resume <url>`

重新压成同一种“headless continue”。

## 第一性原理

更稳的提问不是：

- “它们是不是都能在 print 模式下恢复旧内容？”

而是先问五个更底层的问题：

1. 当前 source 是自动选择的最近本地 transcript，还是用户显式给出的本地 artifact，还是需要先 remote hydrate 的外部来源？
2. 当前 certainty 来自“默认最近一条可继续会话”，还是“用户指定这条就是我要的”，还是“远端材料先得落地才能判断”？
3. 当前失败时，是“没有最近会话”、还是“指定 artifact 不存在/无效”、还是“remote hydrate 之后为空，最后只能落成 startup”？
4. 当前 host 虽然都叫 `print`，但它消费 source 的顺序与担保程度是不是已经不同？
5. 如果 source certainty、失败语义和 fallback 结果都不同，为什么还要把它们写成同一种 headless resume？

只要这五轴不先拆开，后面就会把：

- local recent
- explicit local
- remote-hydrated provisional

混成一条单层恢复链。

## 第一层：`print --continue` 先站在 implicit recent local source 上

`loadInitialMessages(...)` 对 `options.continue` 的处理非常直接：

- `loadConversationForResume(undefined, undefined)`

这条调用的主语不是：

- “去找某个显式指定 session”

而是：

- “按默认规则挑当前目录最近那条可继续的 conversation history”

所以 `print --continue` 的 certainty 来自：

- implicit recent local source

也就是说，它回答的问题是：

- “如果我什么都不指定，当前目录最近可继续的本地会话是哪条”

不是：

- “我已经明确知道要恢复哪一条”

因此更稳的写法应该是：

- `print --continue` = 默认最近本地 source

而不是：

- headless 版的显式恢复

## 第二层：`print --resume session-id` 已经换成 explicit local artifact source

一旦进入 `options.resume`，

`print.ts` 就不再沿用默认最近 source，

而会先：

- `parseSessionIdentifier(...)`

如果传入的是 plain UUID，

`sessionUrl.ts` 会直接返回：

- `sessionId = provided UUID`
- `isUrl = false`
- `jsonlFile = null`

然后 `print.ts` 直接进入：

- `loadConversationForResume(parsedSessionId.sessionId, ...)`

这说明 `print --resume <session-id>` 回答的问题已经变成：

- “我显式指定的这条本地 artifact，能不能被正式恢复”

所以它的 certainty 不是：

- 默认最近

而是：

- explicit local artifact source

这也意味着它和 `print --continue` 的差异，不是纯粹的 UX：

- 一个依赖默认最近规则
- 一个依赖显式 artifact 指向

## 第三层：`.jsonl` 也属于 explicit local artifact family，而不是 remote source

`parseSessionIdentifier(...)` 还会在更早一步把：

- `.jsonl` 路径

直接识别成：

- `jsonlFile = provided path`
- `isUrl = false`

并给一个新的随机 `sessionId` 载体。

这说明在 `print --resume` 家族内部，`.jsonl` 虽然不是原始 session id，

但它仍然属于：

- explicit local artifact source

因为它的恢复担保仍然来自：

- “本地已有这个明确文件”

而不是：

- 先去远端补材料

所以更稳的二分是：

- explicit local artifact family
  - session-id
  - `.jsonl`

而不是简单地：

- `--resume` 一律同源

## 第四层：`print --resume url` 已经进入 conditional remote materialization source

一旦 `parseSessionIdentifier(...)` 判断这是 URL，

当前 certainty 就换了一层。

因为这时 `sessionId` 甚至不是现成稳定 artifact，

而是：

- 先生成一个随机 `sessionId`
- 再把 URL 当 ingress / remote source

随后 `print.ts` 才会按条件分支去做：

- `hydrateFromCCRv2InternalEvents(...)`
- 或 `hydrateRemoteSession(...)`

然后再进入：

- `loadConversationForResume(...)`

这说明 `print --resume <url>` 回答的问题已经不是：

- “这个本地 artifact 能不能直接恢复”

而是：

- “这条 remote source 能不能先 materialize 成本地 transcript，再由 formal restore 接管”

所以它的 certainty 不是 local certainty，

而是：

- conditional remote materialization source

## 第五层：remote source 的 certainty 甚至可能退化成 startup，而 local explicit source 不会

这里是最关键的差别。

`print.ts` 在 remote / CCR 条件下，会把：

- empty hydrated transcript

解释成：

- `processSessionStartHooks('startup')`

而不是直接报：

- session not found

这说明 `print --resume <url>` 的 source certainty 还有一个额外特点：

- 它不保证最后一定落成“恢复旧对话”
- 它也可能只证明“远端当前没有旧内容，因此现在应启动一个新的 startup”

反过来，`print --resume <session-id>` 这类 explicit local artifact source 的主语则更硬：

- 找到就恢复
- 找不到就报错退出

因此这三类 source certainty 可以更准确地写成：

1. implicit recent local
   依赖默认最近规则
2. explicit local artifact
   依赖已知的本地目标
3. conditional remote materialization
   依赖先 remote hydrate，再决定是恢复旧内容还是退回 startup

## 第六层：所以同属 `print` headless resume，也应再分成一条 certainty ladder

把前面几层合起来，更稳的写法应该是：

### `print --continue`

- recent local
- implicit
- stable default

### `print --resume <session-id>` / `.jsonl`

- local artifact
- explicit
- source certainty 更高

### `print --resume <url>`

- remote source
- conditional
- 先 materialize，后 restore
- 甚至可能退化成 startup

所以更准确的结论不是：

- `print --continue` 和 `print --resume` 都只是 headless resume 的不同参数形式

而是：

- 同属 headless host，不等于 source certainty 相同

## 第七层：为什么这页不是 163 或 169 的附录

### 不是 163 的附录

163 讲的是：

- parse
- hydrate
- restore
- fallback
- rewind

这些 stage 为什么不是同一步。

170 不再讲 stage 自身，而讲：

- 在同一个 `print` host 里，不同调用形式拿到的 source certainty 为什么不同

### 不是 169 的附录

169 讲的是更宽的 source family：

- conversation history
- remote-hydrated transcript
- bridge pointer continuity

170 则继续往 `print` 这一条 source family 内部压缩：

- same host
- different source certainty

所以层级并不相同。

## 第八层：稳定、条件与灰度边界

### 稳定可见

- `print --continue` 继续的是最近本地 conversation history。
- `print --resume <session-id>` / `.jsonl` 继续的是显式本地 artifact。
- 这两者都属于普通用户可理解的 headless local resume。

### 条件公开

- `print --resume <url>` 依赖 URL / ingress / CCR 条件分支。
- remote hydrate 完成后仍可能因为空内容而落成 startup，而不是恢复旧对话。

### 内部/灰度层

- `CLAUDE_CODE_USE_CCR_V2`
- `hydrateFromCCRv2InternalEvents(...)`
- `restoredWorkerState`

这些仍应保留在条件或实现层，不应被写成 stable headless resume 的主句。

## 苏格拉底式自审

### 问：为什么一定要把 `print --continue` 和 `print --resume <session-id>` 分开？

答：因为一个是 implicit recent local，一个是 explicit local artifact；source certainty 本来就不同。

### 问：为什么一定要把 `.jsonl` 放进第二层？

答：因为它和 URL 最大的差别就在于：它仍然是本地显式 artifact，而不是 remote materialization。

### 问：为什么一定要把 startup fallback 写出来？

答：因为这正是 remote source certainty 比 local explicit source 更弱的直接证据。

### 问：这页会不会又卷回 168 的 transport thickness？

答：不会。这里只有在说明 remote certainty 为何更弱时才借用 hydrate 分支；主语始终是 source certainty，不是 transport thickness。
