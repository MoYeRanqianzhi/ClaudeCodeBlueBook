# `result`、`structured_output`、`permission_denials`、`lastMessage` 与 `gracefulShutdownSync`：为什么 streamlined path 的 passthrough 不是 terminal semantic 主位保留

## 用户目标

101 已经讲清：

- `result` 维持的是终态语义主位
- 但它不是流读取终点

112 又已经讲清：

- streamlined path 里的纳入 gate、rewrite、passthrough 与 suppression 不是同一种动作

但继续往下读时，读者仍然很容易把 `result` 这一个点写平：

- transformer 里 `case 'result': return message`，是不是和 `lastMessage` 维持 `result` 主位在说同一件事？
- `result` 在 streamlined path 里原样保留，是不是因为它天然就是终态语义中心？
- `structured_output`、`permission_denials` 这些字段被保下来，和 `json/default` 收尾时只认 `lastMessage.type === 'result'`，是不是同一种“保留原样”？

如果这些不拆开，正文最容易滑成一句错误总结：

- “streamlined path 里不改写 `result`，本质上就是因为 `result` 在终态语义里必须保持主位。”

从当前源码看，这个结论并不成立。

## 第一性原理

更稳的提问不是：

- “为什么 `result` 没被 streamlined 化？”

而是先问五个更底层的问题：

1. 当前说的是 transformer write-time contract，还是 terminal final contract？
2. 当前说的是保留 payload 字段，还是保留终态语义主位？
3. 当前 `result` 被原样透传，是为了继续写出什么，还是为了决定最后怎么收口？
4. 当前 `lastMessage` 维持 `result` 主位，是为了继续输出原消息，还是为了让别的消息别抢走终态解释权？
5. 当前源码证明的是 same object kept unchanged，还是 two different preservation reasons？

只要这五轴不先拆开，后续就会把：

- same word: keep/preserve

误写成：

- same semantic role

## 第一层：transformer 里对 `result` 的 passthrough，主语是 wire payload 保留

`streamlinedTransform.ts` 的 `case 'result'` 注释写得很直接：

- keep result messages as-is
- they have `structured_output`, `permission_denials`

随后就是：

- `return message`

这说明 transformer 在这里回答的问题不是：

- “谁是最后的终态消息”

而是：

- “进入 streamlined outgoing wire projection 时，这条 `result` 还需要保留哪些原始载荷”

也就是说，`result` 的 passthrough 更接近：

- payload preservation

不是：

- semantic primacy preservation

所以第一句就不能写成：

- `result` 原样透传是因为它天然是终态主位

更准确的写法应是：

- `result` 原样透传，是因为这条 write-time projection 不应丢掉它的结构化载荷

## 第二层：`lastMessage` 里让 `result` 留在主位，主语则是 terminal semantics

`print.ts` 在主循环里继续维护 `lastMessage`。

相关注释写得也很直：

- SDK-only system events are excluded so `lastMessage` stays at the result

随后过滤掉：

- `session_state_changed`
- `task_notification`
- `task_started`
- `task_progress`
- `post_turn_summary`
- `streamlined_*`
- `prompt_suggestion`

然后才：

- `lastMessage = message`

这说明这里回答的问题不是：

- “这条消息的 payload 要不要保持原样”

而是：

- “哪些后到尾流不应该抢走终态解释权，最后收尾仍应围绕 `result`”

所以 `lastMessage` 维持 `result` 主位，更接近：

- terminal semantic primacy

不是：

- payload passthrough

## 第三层：这两种“保留原样”作用在不同对象层级

把前两层合在一起，区别就清楚了：

- transformer 的 `return message` 作用在 per-message outgoing wire object
- `lastMessage` 的主位保持作用在 terminal final cursor

前者在问：

- 当前这条 `result` 要不要被改写成别的 family？

后者在问：

- 全部流过之后，最后哪个对象负责解释这次 run 的终态？

所以这两者虽然都在“保 `result`”，但保的不是同一个东西：

- 一个保载荷
- 一个保主位

## 第四层：`stream-json` 与 `json/default` 收尾也再次证明它们不是同一件事

`print.ts` 的 `outputFormat` switch 把差别写得更死：

- `case 'stream-json'`: already logged above
- `case 'json'`: 要求 `lastMessage.type === 'result'`，再输出 `lastMessage` 或 `messages`
- `default`: 同样要求 `lastMessage.type === 'result'`，再按 success/error 收尾

这说明：

- transformer 里的 passthrough 属于 stream already logged above 的那一层
- `lastMessage` 的主位保持则属于结尾 `json/default/gracefulShutdownSync` 的那一层

所以不能再写成：

- “因为 result 在 transformer 里没变，所以结尾自然也会以它为主”

更准确的说法应是：

- 二者恰好都围绕 `result`，但分别服务于 stream payload 与 final semantics 两套合同

## 第五层：`gracefulShutdownSync` 也在消费 terminal result，而不是 transformer passthrough

循环结束后，`gracefulShutdownSync(...)` 用的是：

- `lastMessage?.type === 'result' && lastMessage?.is_error ? 1 : 0`

这再次证明退出码语义依赖的是：

- terminal cursor 上那个被保住主位的 `result`

而不是：

- 某次 transformer `return message` 的瞬时动作

所以即使 transformer 对 `result` passthrough：

- 若 terminal cursor 没被正确维护，退出语义仍会出问题

这说明 passthrough 与 terminal primacy 之间不是互相替代关系，而是两个相邻但不同的层。

## 第六层：当前源码能稳定证明什么，不能稳定证明什么

从当前源码可以稳定证明的是：

- transformer 对 `result` passthrough 的理由直接写在注释里，主语是 `structured_output` / `permission_denials`
- `lastMessage` 过滤尾流时的主语是让 `result` 保持 semantic last-message 主位
- `json/default/gracefulShutdownSync` 都围绕 terminal `result` cursor 工作
- `stream-json` 分支则不会再在结尾重复写 stream payload

从当前源码不能在这页稳定证明的是：

- 所有宿主路径里 `result` 的保留理由都与这里相同
- transformer passthrough 本身就足以保证 terminal semantic primacy
- `structured_output` / `permission_denials` 是 transformer 保留 `result` 的全部理由

所以更稳的结论必须停在：

- passthrough != terminal primacy

而不能滑到：

- one unified reason for keeping result unchanged

## 第七层：为什么 113 不能并回 101

101 的主语是：

- `result` 为什么维持 semantic last-message 主位

113 继续往下压的主语则是：

- streamlined transformer 里的 `result` passthrough，为什么不是同一种主位保留

前者讲：

- terminal semantics

后者讲：

- payload preservation vs semantic primacy

不该揉成一页。

## 第八层：为什么 113 也不能并回 112

112 的主语是：

- gate、rewrite、passthrough 与 suppression 不是同一种动作

113 的主语已经换成：

- 在 passthrough 这一格里，`result` 的 payload preservation 又为什么不等于 terminal semantic primacy

前者讲：

- action taxonomy

后者讲：

- one action’s deeper semantic split

也必须分开。

## 第九层：最常见的假等式

### 误判一：transformer 里 `return message`，就等于 terminal contract 在保 `result`

错在漏掉：

- transformer 与 terminal cursor 本来就是两层

### 误判二：`result` 原样保留和 `lastMessage` 保主位只是同一件事在不同位置重复实现

错在漏掉：

- 一个保 payload，一个保终态解释权

### 误判三：只要 `result` passthrough 了，退出码和最终收尾就自然正确

错在漏掉：

- `gracefulShutdownSync` 消费的是 terminal `lastMessage`

### 误判四：`structured_output` / `permission_denials` 与 final text/json 收尾属于同一种保留理由

错在漏掉：

- 前者属于 stream payload，后者属于 final semantics

### 误判五：`stream-json`、`json`、default text 三种模式在 `result` 上只是外观不同

错在漏掉：

- 它们分别消费 stream payload 与 terminal cursor，合同不同

## 第十层：苏格拉底式自审

### 问：我是不是又把“原样保留”写成了一个单义词？

答：如果是，就把 payload 与 semantic primacy 重新拆开。

### 问：我是不是把 transformer 返回值直接当成了退出语义的依据？

答：如果是，就漏掉了 `lastMessage` / `gracefulShutdownSync` 那一层。

### 问：我是不是又在复述 101，而没有继续问“为什么两种保留原样不同”？

答：如果是，就说明还没把 113 的主轴立起来。
