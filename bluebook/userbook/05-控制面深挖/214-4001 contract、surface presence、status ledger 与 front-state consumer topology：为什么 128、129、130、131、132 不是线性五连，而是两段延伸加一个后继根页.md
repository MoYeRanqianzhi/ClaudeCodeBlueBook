# `4001 contract`、surface presence、status ledger 与 front-state consumer topology：为什么 `128`、`129`、`130`、`131`、`132` 不是线性五连，而是两段延伸加一个后继根页

## 用户目标

213 已经把 `122-127` 收成了：

- `122/123/124` 这一段 owner-side recovery / ownership / signer 主干
- `125/126/127` 这一段 transport / stop rule / compaction 主干

继续往 `128-132` 读时，读者最容易留下一个新的线性误判：

- `128` 还在讲 transport
- `129` 还在讲恢复
- `130` 开始讲 remote surface
- `131` 继续讲 remote status
- `132` 再补一页 bridge 更厚的 UI

于是正文就会滑成一句看似自然、实际上过粗的话：

- “`128-132` 只是从 transport error 一路细化到 remote UI 厚度的五连页。”

这句不稳。

从当前源码看，`128-132` 至少分成三段不同主语：

1. `128/129`：same `4001` / recovery problem，不等于 same contract owner
2. `130/131`：same remote feel，不等于 same presence signer / same status ledger
3. `132`：问题已经换成谁在消费 formal runtime state，因此应被看成后继根页

所以这页要补的不是更多 leaf-level 证明，

而是先把 `128-132` 写成：

- 两段 `root + zoom`
- 再加一个后继根页

本页不重讲 `128/129/130/131/132` 各页各自的页内证明，也不把 `4001`、`viewerOnly`、`remoteSessionUrl`、brief line、`remoteConnectionStatus`、`remoteBackgroundTaskCount`、`worker_status`、`external_metadata` 这些局部对象和 helper / state 名重新升级成新的总纲主角；这里只整理一张跨页拓扑图：`128/129` 是 contract / recovery ownership 这一段延伸，`130/131` 是 presence signer / status ledger 这一段延伸，而 `132` 再把主语抬升成 front-state consumer topology 的后继根页，并顺手把稳定用户合同、条件性可见合同与灰度实现证据分层。换句话说，这里要裁定的是“哪几页属于同一段延伸、哪一页已经换了上位问题”，不是再把 leaf-level 的 code contract、surface presence、ledger writer 或 runtime-state consumer 写成一条从 transport 走到 UI 的连续细化链。

## 第一性原理

更稳的提问不是：

- “`128-132` 到底从 transport 一路讲到了哪种 remote UI？”

而是先问八个更底层的问题：

1. 我现在写的是 close code contract、recovery authority、presence signer、ledger writer，还是 consumer topology？
2. 当前这个信号写进的是 close path、`AppState`、transcript，还是 worker-side formal state？
3. 当前看到的是 same code，还是 same contract owner？
4. 当前看到的是 same remote 文案，还是 same presence truth？
5. 当前这张面回答的是 URL / attachment / bridge / lifecycle / task count，还是这些对象的摘要投影？
6. 当前这条链路手里有 formal runtime state，还是只有 partial shadow / event projection？
7. 这条 surface 的缺席，说明 authority 缺席，还是只是当前 projection 没挂出来？
8. 我是不是又把 `128-132` 压回成一条“remote 越来越厚”的线性链？

只要这八轴先拆开，

后面就不会再把：

- `128/129` 的 contract / authority
- `130/131` 的 presence / ledger
- `132` 的 front-state consumer topology

写成同一条线性后续页。

## 第二层：更稳的结构是“两段延伸加一个后继根页”

更稳的读法是：

```text
213 owner-side recovery / transport double-trunk
  ├─ 第一段延伸：transport contract / recovery ownership
  │    ├─ 128 same 4001 != same contract owner        [根页]
  │    └─ 129 same recovery problem != same authority [zoom]
  │
  ├─ 第二段延伸：surface presence / status ledger
  │    ├─ 130 same remote feel != same presence signer [根页]
  │    └─ 131 same status feel != same ledger writer   [zoom]
  │
  └─ 后继根页：front-state consumer topology
       └─ 132 谁有 formal runtime state，谁只有 partial shadow / projection
```

这里真正该记住的一句是：

- `128/129` 还在 transport contract 与 recovery ownership 这条线上
- `130/131` 已经切到 presence signer 与 status ledger 这条线上
- `132` 再把主语抬升成 front-state consumer topology

所以更准确的主语不是：

- 从 transport 慢慢细化到 UI

而是：

- 从 contract owner，切到 presence / ledger owner，再切到 consumer topology

## 第三层：`128` 是 contract 根页，`129` 是 recovery ownership zoom

`128` 先保护的是：

- same `4001`
- different component
- different resource object
- different close contract

它在回答：

- `SessionsWebSocket 4001`
- `WebSocketTransport 4001`

为什么不是同一种合同。

`129` 回答的却不是：

- 还有哪些 `4001` 变体

而是：

- `headersRefreshed`
- `refreshHeaders`
- `autoReconnect`
- sleep detection
- terminal close 之后 caller 的接管权

为什么说明 `WebSocketTransport` 的恢复主权不是 `SessionsWebSocket` 的镜像。

所以 `129` 更准确的位置不是：

- `128` 的 error appendix

而是：

- contract 根页之上的 recovery ownership zoom

## 第四层：`130` 不是“remote surface 总览”，而是 presence signer 根页

`130` 表面上列的是：

- `remoteSessionUrl`
- brief line
- bridge pill
- bridge dialog
- attached viewer

但它真正要保护的不是：

- 这些 surface 长什么样

而是：

- 这些 surface 分别由谁签名
- 它们签的是 URL presence、runtime projection、bridge summary / inspect，还是 attachment fact

所以 `130` 的稳定根句不是：

- remote 有很多提示

而是：

- same remote feel does not mean same presence signer

这里如果不先把 signer / writer 钉住，

后面就会把：

- footer `remote`
- brief line
- bridge pill
- attached viewer transcript

误写成同一种 presence。

## 第五层：`131` 不是 `130` 的 UI appendix，而是 status-ledger zoom

`131` 表面上列的是：

- warning transcript
- `remoteConnectionStatus`
- `remoteBackgroundTaskCount`
- brief line

但它真正回答的是：

- remediation prompt 写在哪张账上
- WS lifecycle 写在哪张账上
- remote task count 写在哪张账上
- brief line 又如何做 lossy summary

所以 `131` 更稳的位置不是：

- “130 里 brief line 的补充说明”

而是：

- `130` 这条 presence 根页之后，继续压到 ledger writer / summary policy 的 zoom

这里最该保护的一句是：

- warning transcript、`remoteConnectionStatus`、`remoteBackgroundTaskCount` 与 brief line 不是一张 remote status table

而是：

- 三张账，再加一层 lossy projection

## 第六层：`132` 不是“bridge 更厚”的尾页，而是后继根页

到了 `132`，问题已经换掉了。

它不再先问：

- 哪张 surface 在签 presence
- 哪张账在写 remote status

而是先问：

- 哪条链路真正消费 formal runtime state
- 哪条链路只有 partial `AppState` shadow
- 哪条链路更多只是 transcript / permission projection

源码里，formal runtime state 先被定义成：

- `SessionState`
- `SessionExternalMetadata`

并且有独立的 listener 面。

这说明：

- “前台能看到消息”

不等于：

- “前台已经消费 authoritative runtime state”

从这个角度看：

- direct connect 当前更像 transcript + permission queue projection
- remote session 当前更像 event projection + partial shadow
- bridge 当前才更接近 authoritative state + local shadow + transcript / footer / dialog 的对齐链

所以 `132` 更稳的主语是：

- front-state consumer topology

不是：

- remote surface 的最后一页

## 第七层：`132` 也是后面几页的真正前置根句

如果继续往后读：

- `135`
- `138`
- `141`
- `142`
- `143`

你会发现这些页都更像在继续问：

- foreground runtime
- shared shell
- presence ledger
- gray runtime
- global remote bit

这些问题之所以能分家，

正是因为 `132` 先把真正的上位问题改成了：

- 谁在消费 formal runtime state，谁只是在做 projection / shadow

所以 `132` 不只是 `128-132` 的尾页，

它还是后续 remote surface / runtime topology 那组页的后继根。

## 第八层：因此 `128-132` 不是线性五连

把前面几层压成一句，更稳的结构句其实是：

- `128/129` 讲 transport contract 与 recovery ownership
- `130/131` 讲 presence signer 与 status ledger
- `132` 把主语切换成 front-state consumer topology

所以最该避免的一种写法就是：

- “这些页都是在讲 remote status / remote UI，只是越往后越细。”

## 第九层：稳定层与灰度层

### 稳定可见

- `4001` 的 meaning 仍然必须按 component / contract owner 来读
- `WebSocketTransport` 的恢复主权是分层的，不等于 `SessionsWebSocket` 的镜像
- `remoteSessionUrl`、attachment fact、bridge state 与 brief projection 不是同一种 presence
- warning transcript、`remoteConnectionStatus`、`remoteBackgroundTaskCount` 与 brief line 不是同一张状态表
- `SessionState` / `SessionExternalMetadata` 才更接近 formal runtime state 的定义面
- bridge 当前确实拥有 dedicated local shadow，而 remote session 只有 partial shadow

### 条件公开

- footer `remote` 当前是 mount-time lazy capture，不是 live health indicator
- brief line 只在 brief-only idle 条件下挂载，而且把 local / remote background count 合并
- warning transcript 只在 non-`viewerOnly` watchdog 路径里出现
- bridge 的 transcript / footer / dialog 对齐当前还受 v1 / v2、env-less 与 render gate 约束

### 内部/灰度层

- timeout / retry / sleep 常量
- exact `4003` refresh sequencing
- bridge failure dismiss timer
- `session_state_changed` SDK event 的 env gate
- exact pill / dialog render condition 与 upgrade nudge 文案

## 苏格拉底式自审

### 问：我现在写的是 contract、presence、ledger，还是 consumer topology？

答：主语没先钉住，就不要把不同页压成同一条线。

### 问：这条 surface 缺席，说明 authority 缺席了吗？

答：先问它是不是本来就只是 projection / summary / lazy capture。

### 问：我是不是把 same wording 当成了 same signer / same ledger？

答：`remote`、`Reconnecting…`、`Attached...`、bridge status 的词面接近，不等于 write path 相同。

### 问：我是不是把 `132` 还写成了“bridge 更厚的 UI 页”？

答：如果一句话没有先回答谁在消费 formal runtime state，它就还没真正进入 `132` 的主语。
