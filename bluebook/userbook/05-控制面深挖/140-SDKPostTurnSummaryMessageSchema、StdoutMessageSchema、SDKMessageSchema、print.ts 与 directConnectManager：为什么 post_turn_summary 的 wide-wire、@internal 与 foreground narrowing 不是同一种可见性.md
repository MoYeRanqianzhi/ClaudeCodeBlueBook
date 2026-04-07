# `SDKPostTurnSummaryMessageSchema`、`StdoutMessageSchema`、`SDKMessageSchema`、`print.ts` 与 `directConnectManager`：为什么 `post_turn_summary` 的 wide-wire、`@internal` 与 foreground narrowing 不是同一种可见性

## 用户目标

105 已经先讲清：

- `post_turn_summary` 不是 core `SDKMessage` union
- 但不等于完全不可见

108 又进一步讲清：

- direct connect 对 `post_turn_summary` 的过滤
- 不是消息不存在
- 而是 callback consumer-path 收窄

137 则把主语再往外扩了一层：

- `pending_action.input`
- `task_summary`
- `post_turn_summary`

更像跨前端 consumer path，
不是当前 CLI foreground contract。

但继续往下不补这一页，读者还是很容易把 `post_turn_summary` 又重新压成一句粗话：

- “它要么可见，要么不可见。”

这句仍然不稳。

从当前源码看，`post_turn_summary` 至少同时落在四层不同的可见性语义里：

1. schema 类型存在
2. wide stdout wire 可承载
3. core `SDKMessage` 不接纳
4. 当前 CLI foreground / callback / terminal semantics 还会继续主动 narrowing

所以这页要补的不是：

- “`post_turn_summary` 到底能不能被看到”

而是：

- “`post_turn_summary` 的哪一层可见性成立，哪一层又被主动切掉”

## 第一性原理

更稳的提问不是：

- “`post_turn_summary` 可见吗？”

而是先问五个更底层的问题：

1. 当前在说的是 schema existence、wire admissibility，还是 foreground consumer visibility？
2. 当前在说的是 core SDK contract，还是更宽的 stdout/control union？
3. 当前在说的是 raw stream pass-through，还是 callback delivery？
4. 当前在说的是 terminal semantic last message，还是 message merely appearing on the wire？
5. 当前在说的是 `@internal`，还是“当前 CLI 一定完全看不见”？

只要这五轴先拆开，`post_turn_summary` 就不会再被写成：

- “单一可见 / 不可见状态”

## 第一层：`SDKPostTurnSummaryMessageSchema` 证明它是被正式建模的 family，不是幽灵字段

`coreSchemas.ts` 当前单独定义了：

- `SDKPostTurnSummaryMessageSchema`

字段很完整：

- `summarizes_uuid`
- `status_category`
- `status_detail`
- `title`
- `description`
- `recent_action`
- `needs_action`
- `artifact_urls`

这一步先回答的是：

- 这不是临时拼出来的随手 tail
- 它是一种被正式建模的 summary family

所以第一层最该避免的误写是：

- “既然当前 foreground 不用它，它就只是虚设字段。”

这不成立。

## 第二层：同一个 schema 描述又明确把它压进 `@internal` 语义

但同一段 schema 描述里，源码又写得很直白：

- `@internal Background post-turn summary emitted after each assistant turn`

这说明第二层边界也同样重要：

- 它虽然是正式建模的 family
- 但默认语义不是“普通公开 foreground message”

也就是说：

- schema existence

不等于：

- public stable foreground contract

所以 `@internal` 不是在说：

- “它完全不存在”

而是在说：

- “它属于另一层更灰、更窄、更偏内部的可见性”

## 第三层：`StdoutMessageSchema` 再把它接入更宽的 stdout/control wire

`controlSchemas.ts` 的 `StdoutMessageSchema` 会 union：

- `SDKMessageSchema()`
- streamlined variants
- `SDKPostTurnSummaryMessageSchema()`
- control request / response / cancel / keep_alive

这一层极其关键，因为它说明：

- `post_turn_summary` 虽然不在 core `SDKMessage`
- 但在更宽的 stdout/control wire surface 里是 admissible 的

所以这里最稳的一句是：

- not core SDK-visible
- but stdout-wire admissible

如果把这一层漏掉，

就会把：

- `SDKMessageSchema` 不收它

偷换成：

- “它根本不会出现在 stdout wire 上”

## 第四层：`SDKMessageSchema` 又明确把它排除在 core SDK 主合同之外

`coreSchemas.ts` 里的：

- `SDKMessageSchema`

并没有 union `SDKPostTurnSummaryMessageSchema`。

这一步的价值不在于重复“它不在里面”，

而在于进一步说明：

- 当前存在一层明确的 contract cut

也就是说，当前源码已经主动把：

- core SDK message surface

和：

- wider stdout/control wire surface

拆成两层。

因此如果用户问：

- “它是不是普通 `SDKMessage`？”

更准确的答案仍然是：

- 不是

但这还不能推出：

- “因此它没有任何别的可见性”

## 第五层：`print.ts` 说明 raw stream visibility 与 terminal semantic visibility 不是同一回事

`print.ts` 这里又再拆出一层。

### raw stream 这层

当：

- `--output-format=stream-json`
- 且 `--verbose`

时，代码会直接写出 raw `message`。

这意味着只要 upstream 真 emit 了 `post_turn_summary`，

在这一层里它是可能被看到的。

### terminal semantic 这层

但同一个 `print.ts` 随后在维护 `lastMessage` 时，又显式把：

- `system.post_turn_summary`

排除掉。

注释还进一步说明目的：

- SDK-only system events are excluded so `lastMessage` stays at the result

所以 `print.ts` 当前同时在证明两件事：

1. raw stream 可以承载它
2. terminal semantic foreground 不把它当主结果

这两者显然不是同一层可见性。

## 第六层：`directConnectManager` 进一步说明 raw ingress parse 与 callback-visible 也不是同一层

`directConnectManager.ts` 又再把可见性梯子拆细一层。

它面对的是更宽的：

- `StdoutMessage`

并先用：

- `isStdoutMessage(...)`

判断 raw line 能不能被当成 stdout/control message 解析。

但它真正对外暴露的 callback 却是：

- `onMessage: (message: SDKMessage) => void`

而在进入这个 callback 前，它又显式过滤掉：

- `system.post_turn_summary`

因此在 direct connect 这条线上，至少又存在三层不同的对象集：

1. raw wire lines
2. parse 后的 `StdoutMessage`
3. 继续 narrowing 之后的 callback-visible `SDKMessage`

这里如果还写成：

- “direct connect 看不见 `post_turn_summary`”

就太粗了。

更准确的说法应该是：

- direct connect raw ingress 可能承认它
- 但 callback surface 主动不把它交给下游 consumer

## 第七层：因此 `post_turn_summary` 当前至少有四层不同的 visibility ladder

把前面几层压成一句，更稳的一句是：

- `post_turn_summary` has a visibility ladder, not a boolean visibility flag

当前至少可以拆成：

### 1. schema-visible

- `SDKPostTurnSummaryMessageSchema` 存在

### 2. internal-visible

- schema 描述本身是 `@internal`

### 3. stdout-wire-visible

- `StdoutMessageSchema` 接纳它

### 4. core-SDK-invisible

- `SDKMessageSchema` 不接纳它

### 5. callback-invisible by narrowing

- `directConnectManager` 在回调前主动 strip

### 6. terminal-semantic-invisible by narrowing

- `print.ts` 在 `lastMessage` 语义上主动排除

所以真正更稳的结论不是：

- “它可见”
- 或“它不可见”

而是：

- “它在哪一层可见、又在哪一层被切掉”

## 第八层：为什么这页不是 105 的重复

105 讲的是：

- 它不是 core SDK-visible
- 却不等于完全不可见

140 讲的是：

- `@internal`
- `StdoutMessageSchema`
- `SDKMessageSchema`
- `print/directConnect` narrowing

为什么要被理解成一条 visibility ladder。

一个讲：

- binary misunderstanding 的拆解

一个讲：

- 多层 visibility model 的拆解

所以 140 不是重写 105，

而是把“可见 / 不可见”继续展开成梯子。

## 第九层：为什么这页也不是 108 的重复

108 讲的是：

- direct connect 对 `post_turn_summary` 的过滤
- 不是消息不存在
- 而是 callback consumer-path 收窄

140 讲的是：

- direct connect narrowing 只是整条 visibility ladder 里的其中一层
- 不是整个 family 的总可见性判断

一个讲：

- direct connect callback 边界

一个讲：

- family-wide visibility ladder

所以 140 也不是重写 108。

## 第十层：最常见的四个假等式

### 误判一：`@internal` 就等于完全不可见

错在漏掉：

- `StdoutMessageSchema` 仍然接纳它

### 误判二：进入 `StdoutMessageSchema` 就等于属于普通 core SDK contract

错在漏掉：

- `SDKMessageSchema` 并没有接纳它

### 误判三：`print --stream-json --verbose` 能看到它，就等于 terminal foreground 把它当主结果

错在漏掉：

- `lastMessage` 语义会继续主动排除它

### 误判四：direct connect callback 收不到它，就等于 direct connect raw wire 根本不可能有它

错在漏掉：

- parse layer 和 callback layer 之间还有主动 narrowing

## 第十一层：stable / conditional / internal

### 稳定可见

- `SDKPostTurnSummaryMessageSchema` 当前正式存在
- 描述当前明确带 `@internal`
- `StdoutMessageSchema` 当前接纳它
- `SDKMessageSchema` 当前不接纳它
- `print.ts` 与 `directConnectManager.ts` 当前都主动 narrowing 它的 foreground consumer path

### 条件公开

- 运行时是否每次都 emit `post_turn_summary`，当前这页不做过度断言
- raw stream 能否看见它，取决于上游是否实际 emit 以及 consumer 是否选择更宽输出层
- 将来它完全可能被接入更宽 foreground consumer，但当前 CLI 主路径还没有这样做

### 内部 / 灰度层

- `@internal` 本身就是灰度信号
- 它的 wide-wire visibility 与 foreground narrowing 之间的张力，说明这类 summary family 仍在演化带
- 当前仓内并没有把它提升为稳定 public SDK/CLI foreground contract

## 第十二层：苏格拉底式自审

### 问：我现在写的是 schema existence，还是 foreground consumer visibility？

答：如果答不出来，就把不同层的可见性混了。

### 问：我是不是把 `@internal` 偷换成了“根本不会出现”？

答：如果是，就漏掉了 stdout wire 这一层。

### 问：我是不是把 raw stream 能看到，偷换成了 terminal semantics 接纳？

答：如果是，就漏掉了 `print.ts` 的 `lastMessage` narrowing。

### 问：我是不是把 direct connect callback 收不到，偷换成了 raw wire 不存在？

答：如果是，就漏掉了 `StdoutMessage -> callback` 之间的 consumer-path cut。

### 问：我是不是又回到 105/108 的二选一，而没有真正把它写成 visibility ladder？

答：如果是，就还没真正进入 140。

## 源码锚点

- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts`
- `claude-code-source-code/src/cli/print.ts`
- `claude-code-source-code/src/server/directConnectManager.ts`
