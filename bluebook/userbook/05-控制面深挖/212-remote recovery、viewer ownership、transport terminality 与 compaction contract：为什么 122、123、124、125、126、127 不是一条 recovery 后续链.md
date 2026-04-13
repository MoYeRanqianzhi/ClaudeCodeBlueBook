# remote recovery、viewer ownership、transport terminality 与 compaction contract：为什么 122、123、124、125、126、127 不是一条 recovery 后续链

## 用户目标

211 已经把：

- completion / waiting
- `system.init` 双轴
- attach / replay

拆成了三组相邻配对。

继续往 122-127 读时，读者最容易再滑进一种新的误判：

- “这几页都在讲 remote session 的恢复，顺着编号往下就是同一条 recovery 链。”

这句话看似自然，

其实会把两个层级重新压平：

1. owner-side recovery、viewer ownership 与 recovery signer 这一层
2. transport action-state、terminality policy 与 compaction contract 这一层

所以这轮最该补的不是再加一页新的叶页证明，

而是先把 122-127 收成一张结构图：

- 为什么 122、123、124、125、126、127 不是一条 recovery 后续链

本页不重讲 122、123、124、125、126、127 各页各自的页内证明，也不把 watchdog、warning、`viewerOnly`、`remoteConnectionStatus`、`handleClose(...)`、`PERMANENT_CLOSE_CODES`、`4001`、`COMPACTION_TIMEOUT_MS` 这些局部对象和 helper / 常量名重新升级成新的总纲主角；这里只整理一张跨页拓扑图：122 是 owner-side recovery 根页，123 是 ownership 侧枝，124 是 signer / proof zoom，125 是 transport authority 的降层根页，126 与 127 再从 125 分到 terminality 与 compaction 两侧，并顺手把稳定用户合同、条件性可见合同与灰度实现证据分层。换句话说，这里要裁定的是“哪些页是什么关系、哪些判断属于哪一层合同”，不是再把 leaf-level 的 recovery edge、ownership gate、stop rule 或 compaction 信号写成整簇页面的统一运行时结论。

## 第一性原理

更稳的提问不是：

- “remote recovery 现在到底进行到哪一步了？”

而是先问八个更底层的问题：

1. 我现在写的是 recovery edge、ownership 边界，还是 signer surface？
2. 我现在写的是 owner-side prompt / proof，还是 raw transport authority？
3. 这个信号是谁写出来的：owner watchdog、transport state machine，还是 UI projection？
4. 这个 client 只是还能发 content，还是也拥有 title / timeout / interrupt 这种 control-plane 主权？
5. 我现在写的是 close path、stop rule，还是 compaction keep-alive / completion marker？
6. 没看到 warning、brief 行或 remote pill，到底是状态不存在，还是 signer/surface 没挂上？
7. 我是不是把 `4001` 在当前 remote-session 栈里的特判，偷换成了所有 transport 的稳定语义？
8. 我是不是又把 owner-side recovery 和 transport-level recovery 压回成一条顺序链？

只要这八轴先拆开，

后面就不会再把：

- 122 的 recovery lifecycle
- 123 的 viewer ownership
- 124 的 recovery signer
- 125 的 transport action-state
- 126 的 terminality policy
- 127 的 compaction contract

重新压成一句模糊的：

- “恢复状态”

## 第二层：这组页不是一条线，而是“双根 + zoom + 降层主干”

更稳的读法是：

```text
211 attach / restore boundary
  ├─ 122 recovery lifecycle          [根页]
  ├─ 123 viewer ownership            [侧枝]
  └─ 124 recovery signer            [122 × 123 的 sibling zoom]

122 往 transport 层继续下沉
  └─ 125 transport action-state     [降层根页]
       ├─ 126 terminality policy    [125 的 zoom]
       └─ 127 compaction contract   [125 的支线；借 126 的 4001 子结论]
```

这里真正该记住的一句是：

- 122 是 owner-side recovery 根页
- 123 是 ownership 侧枝
- 124 是建立在 122 和 123 之上的 signer / proof zoom
- 125 是真正的降层点
- 126 / 127 从 125 分到 terminality 与 compaction 两侧

所以这组六页最不该被写成：

- `122 -> 123 -> 124 -> 125 -> 126 -> 127`

这种线性后继链。

## 第三层：122 是根页，123 不是配对页，而是 ownership 侧枝

122 先回答的是：

- timeout watchdog
- heartbeat clear
- timeout warning
- reconnect action
- reconnecting
- disconnected

为什么 remote session 的 recovery lifecycle 不是同一种状态。

它的主语是：

- owner-side recovery edge taxonomy

123 回答的却不是：

- recovery 还会分几种 edge

而是：

- `viewerOnly` 这类 attached assistant client

到底有没有资格进入并主导这条 owner-side recovery loop。

它问的是：

- content plane
- history ledger
- session metadata
- session control

谁拥有这些面。

所以 123 更准确的位置不是：

- 122 的下一步

而是：

- 在 recovery 语境里专门回答“谁有 owner 主权”的侧枝

## 第四层：124 不是第三张 recovery state 页，而是 signer / proof zoom

124 继续问的不是：

- recovery 到底有几个状态

而是：

- warning prompt
- durable connection state
- transport action
- brief projection
- mode-conditioned absence

这些 surface 为什么不能签出同一种恢复证明。

它的主语已经从：

- recovery edge 本体

切到：

- 谁能给 recovery 签字
- 哪些只是 prompt / action / projection / absence

所以 124 也不该被写成：

- 122 之后的第三个 lifecycle 页

更准确的位置是：

- 建立在 122 的 edge 词汇
- 和 123 的 ownership 缺席语义

之上的 proof/signer zoom page

## 第五层：125 才是真正的降层点

124 以前，正文仍然主要在回答：

- owner-side recovery
- client ownership
- recovery signer

125 开始，问题才真正切到：

- `SessionsWebSocket.handleClose(...)`
- `scheduleReconnect(...)`
- `reconnect()`
- `onReconnecting`
- `onClose`

这些 transport authority / action-state contract。

这一步最该保护的一句是：

- 125 不是 124 的普通叶页，而是从 signer / proof 层降到 transport authority 层的根页

如果这一层不先钉死，

你就会把：

- `reconnect()`
- `onReconnecting`
- `onClose`

继续写成 124 那种 signer surface，

而不是：

- transport 层如何分 action 与 projection

## 第六层：126 与 127 都从 125 分出，但不是线性父子

126 回答的问题是：

- `PERMANENT_CLOSE_CODES`
- `4001`
- ordinary reconnect budget

为什么 terminality policy 不是同一种 stop rule。

它的主语是：

- permanent rejection
- stale exception
- ordinary transient retry

127 回答的问题则是：

- `status=compacting`
- repeated compacting keep-alive
- `COMPACTION_TIMEOUT_MS`
- `4001`
- `compact_boundary`

为什么 compaction contract 不是同一种恢复信号。

它虽然借用了 126 的一个子结论：

- `4001` 在这里是 stale-window exception

但它真正的主语已经换成：

- progress / status
- keep-alive
- local patience
- transport exception
- rewrite completion

所以 127 不该被写成：

- 126 的“下一步”

更稳的写法应是：

- 126 = terminality zoom
- 127 = compaction 支线

它们都从 125 的 transport authority 层分出，

而不是互为父子。

## 第七层：这组页最该保护的稳定主干

| 节点 | 稳定主干 |
| --- | --- |
| 122 | warning、reconnect action、reconnecting、disconnected 不是同一状态；warning 更像 remediation prompt，不是 durable authority |
| 123 | `viewerOnly` 不是“完全只读”，而是 non-owning interactive client：能发 prompt，但不拥有 title / timeout / interrupt 这组三权 |
| 124 | `remoteConnectionStatus` 比 warning / brief 更接近 shared durable authority；absence 不等于 opposite；bridge 与 remote session 不是同一 signer family |
| 125 | `handleClose(...)` 才是 transport authority path；`scheduleReconnect(...)`、`reconnect()`、`onClose`、`onReconnecting` 不应被写成同一种状态 |
| 126 | terminality 至少分成 permanent rejection、`4001` stale exception、ordinary post-connected retry 三桶 |
| 127 | compaction 至少分成 progress/status、keep-alive、local patience、transport exception、rewrite completion 五种信号 |

这里最该保住的一句是：

- recovery、ownership、proof、transport、terminality、compaction 不是一张表

## 第八层：哪些点必须降级为条件或灰度实现证据

| 节点 | 条件 / 灰度证据 |
| --- | --- |
| 122-124 | timeout 后出现 warning 只能证明 watchdog fired；brief 文案、remote pill、history gate、warning 缺席都受挂载条件 / `viewerOnly` / `KAIROS` / UI 投影限制 |
| 125-126 | `60s / 180s` timeout、`500ms` force reconnect、`MAX_RECONNECT_ATTEMPTS`、`MAX_SESSION_NOT_FOUND_RETRIES`、`RECONNECT_DELAY_MS` 都只是当前实现常量 |
| 126-127 | `4001` 只在当前 `SessionsWebSocket` 栈里被当成 stale-window exception；另一层 `WebSocketTransport` 可以把 `4001` 视为 permanent close code |
| 127 | repeated `compacting` 的 keep-alive cadence、`compact_boundary.preserved_segment`、session activity tracking 是否启用，都不该被抬成稳定公共合同 |

更稳的写法应先写：

- 层级分裂
- authority / signer 分裂
- terminality / compaction 分裂

再用 gate 名、常量名、当前 hook 顺序举证，

不要反过来让实现常量替代结构主语。

## 第九层：苏格拉底式自审

每次继续深挖 122-127，先追问自己：

1. 我现在写的是 recovery edge、ownership 边界，还是 signer surface？
2. 这个信号是谁写出来的：owner watchdog、transport state machine，还是 UI projection？
3. 这个 client 只是能发 content，还是也拥有 title / timeout / interrupt 的 control-plane 主权？
4. 我看到的是 action，还是 durable state？
5. 我没看到 warning / brief / remote pill，到底是状态不存在，还是 signer / surface 本来就没挂上？
6. 我现在是在 transport authority 层，还是还停留在 proof/signer 层？
7. 这个 close 属于 permanent rejection、`4001` stale exception，还是 ordinary post-connected drop？
8. 我现在引用的 `compacting` 信号是在报 progress、做 keep-alive、延长本地 patience，还是宣告 rewrite completion？
9. 我是不是把 bridge 的状态面或别的 transport 的 `4001` 语义，误当成 remote session 这条栈的稳定合同？

如果这九个问题里有任何一个回答不稳，

就不该继续往叶页下钻，

而应该先回到这张结构页重找主语。

## 第十层：阅读建议

如果你现在的问题是：

- “为什么 122-127 明明都在讲 recovery，却不能一路按编号往下顺读？”

建议按这个顺序：

1. 211：先记住 attach / restore 这一层已经结束
2. 212：先看 122-127 的双根 + 降层主干结构图
3. 如果你关心 owner-side recovery：读 `122`
4. 如果你关心 attached assistant 的主权边界：读 `123`
5. 如果你关心 recovery 证据的签字权：读 `124`
6. 如果你关心 transport authority：从 `125` 开始，再分到 `126 / 127`

如果你在 127 里再次被 `4001` 带偏，

先退回：

- 126

再回来继续看 compaction 这条线。
