# `pendingPermissionHandlers`、`cancelRequest`、`recheckPermission`、`hostPattern.host` 与 `applyPermissionUpdate`：为什么 permission tail 的 196、198、199、201、202 不是并列尾页，而是从 verdict ledger 分叉出去的四种后继问题

## 用户目标

196、198、199、201、202 连着拆完之后，读者最容易出现一种新的误判：

- “这些页都在讲 permission 尾部，应该是五篇平行小文，按兴趣挑一篇读就行。”

这句话看似高效，

其实会让后面的很多句子重新塌掉。

因为 196 不是五页中的一篇并列尾页，

而是整个 permission tail 的根页：

- 它先回答 verdict ledger 记在哪

随后才会分叉出四个不同后继问题：

1. verdict 已判后的 request-level closeout
2. permission context 变化后的 leader-local re-evaluation
3. sandbox network 分支里的 host-level sibling sweep
4. 本地选择 persist 后的 context / settings / runtime 写面传播

如果这个顺序不先写死，读者就会：

- 把 201 写成 sandbox 版 198
- 把 199 写成 198 的 cleanup 附录
- 把 202 写成 repo-wide generic persist family

这句还不稳。

所以这里需要的不是再补一篇新的运行时正文，

而是补一页结构收束：

- 为什么 196、198、199、201、202 不是并列尾页，而是从 verdict ledger 分叉出去的四种后继问题

## 第一性原理

更稳的提问不是：

- “这五页都在讲 permission 尾部，我该先看哪篇？”

而是先问六个更底层的问题：

1. 我现在卡住的是 verdict 记账本身，还是 verdict 之后的某种后继问题？
2. 我现在问的是 `request_id` 的 request-level closeout，还是 leader queue 的本地重判？
3. 我现在问的是 generic bridge permission 尾部，还是 sandbox network 这一条更窄的 host 分支？
4. 我现在关心的是一次 host verdict 的批量 settle，还是一次 persist 手势的多层写面传播？
5. 我现在需要的是一个用户目标入口，还是一个局部子系统的 anti-overlap map？
6. 我是不是已经把 “closeout / re-evaluation / host sweep / persist surfaces” 混成同一种尾巴？

只要这六轴不先拆开，

后面就会把：

- 196 的 verdict ledger
- 198 的 request-level closeout
- 199 的 local re-evaluation
- 201 的 host-level sibling sweep
- 202 的 persist write surfaces

重新压成一句模糊的：

- “permission 尾部还有很多细节”

## 第一层：196 不是尾页之一，而是整组分叉图的根页

196 先回答的是：

- `pendingPermissionHandlers` 这张本地账到底是谁的账

也就是：

- `control_response`
- `request_id`
- `handlePermissionResponse(...)`

之间的本地 verdict ownership。

如果这一层没先读，

你后面会把 198、199、201、202 全都误当成：

- 不同实现位置上的“permission cleanup”

但事实不是。

196 的作用是给整组尾部阅读图固定根页：

- 先定 verdict ledger

然后别的尾部问题才能各自分叉。

## 第二层：198 只回答 request-level closeout，不回答 context 重判、host sweep 或 persist 写面

198 继续问的是：

- verdict 已经判完之后
- `cancelRequest(...)`
- unsubscribe
- `pendingPermissionHandlers.delete(...)`
- leader queue recheck

为什么不是同一种收口合同。

它的主语很窄：

- request-level closeout

这一步如果不先写死，

后面你会很容易把 199 误写成：

- 198 的另一个 cleanup 分支

或者把 201 误写成：

- sandbox network 版的 198

这都不对。

198 的作用是先把：

- request-level closeout

从别的 permission tail 主语里剥出来。

## 第三层：199 不是 198 的附录，而是 permission context change 下的 local re-evaluation 分叉

199 回答的问题不是：

- verdict 判完以后还要怎么收尾

而是：

- 本地 leader 的 permission context 变化后
- queue 里的 ask 为什么会收到 `recheckPermission()`

它的主语是：

- leader-local re-evaluation surface

不是：

- request closeout surface

这一步如果不先拆开，

你就会把：

- `onSetPermissionMode(...)`
- `getLeaderToolUseConfirmQueue()`
- `item.recheckPermission()`

误写成 198 里的 cleanup 延长线。

但 199 实际更靠前，

因为它讨论的是：

- 有些 ask 甚至还没进入 closeout，就先收到一轮本地重判广播

## 第四层：201 不是 198 的 sandbox 版本，而是 host-level sibling sweep 分叉

201 继续往 sandbox network 分支里收窄，回答的是：

- 为什么一次对 `hostPattern.host` 的 verdict
- 会批量 resolve / remove 同 host 请求
- 并扫掉同 host 的 sibling cleanups

它的主语从一开始就不是：

- `request_id`

而是：

- `hostPattern.host`

这一步如果不先读，

你最容易把：

- `sandboxPermissionRequestQueue` filter
- `sandboxBridgeCleanupRef`
- `cancelRequest(...)`

重新压成 198 那种 request-level closeout。

但 201 实际上只属于：

- sandbox network 分支下的 host-level settle 问题

## 第五层：202 不是 repo-wide generic persist family，而是本地 sandbox 响应之后的写面分叉

202 接着回答的是：

- 用户选择 persist 后
- 为什么同一次本地 sandbox 响应
- 还会继续分裂成 context / settings / runtime 三层写面

它的主语不是：

- generic permission governance family

而是：

- sandbox local response 之后的 write-surface propagation

这一步如果不先写死，

你就会把 202 误写成：

- 整个仓库所有 permission update 的总页

但 202 更准确的位置只是：

- sandbox local response 的一个后继问题

它和 201 的关系也不是并列替换，

而是：

- 201 解释同 host 怎么 settle
- 202 解释本地用户一旦选择 persist，这个 settle 还会牵出哪几层写面

## 第六层：这页不是 197，也不是 20，更不是 `00-阅读路径.md` 的复制

这里还要再防三个结构误判。

### 不是 197

197 的主语是：

- `191-196` 这条 ingress 深线为什么要按六层链条读

203 的主语是：

- `196` 之后 permission tail 如何继续分叉

### 不是 20

20 的主语是：

- continuation / host control / ingress input / permission verdict 的用户目标层分工

203 不再回到用户目标层，

它只处理：

- 一个局部子系统里，verdict ledger 之后怎么继续往下分裂

### 不是 `00-阅读路径.md`

`00-阅读路径.md` 回答的是：

- 读者从什么入口走进来

203 回答的是：

- 已经走进 permission tail 子系统之后
- 哪几个后继问题绝不能重新压扁

所以它是一张：

- 局部 anti-overlap map

不是入口清单。

## 结论

更稳的一句应该是：

- 196 是 permission tail 的根页，因为它先定本地 verdict ledger
- 198 只处理 request-level closeout
- 199 处理 permission context change 下的 leader-local re-evaluation
- 201 处理 sandbox network 分支里的 host-level sibling sweep
- 202 处理本地 sandbox persist 之后的 write-surface propagation

一旦这句成立，

就不会再把：

- closeout
- re-evaluation
- host sweep
- persist surfaces

写成同一种“permission 尾页”。
