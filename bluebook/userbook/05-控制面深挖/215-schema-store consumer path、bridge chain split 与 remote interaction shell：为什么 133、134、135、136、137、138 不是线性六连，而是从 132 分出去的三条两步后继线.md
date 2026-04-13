# schema/store consumer path、bridge chain split 与 remote interaction shell：为什么 `133`、`134`、`135`、`136`、`137`、`138` 不是线性六连，而是从 `132` 分出去的三条两步后继线

## 用户目标

214 已经把 `128-132` 收成了：

- `128/129` = transport contract / recovery ownership
- `130/131` = surface presence / status ledger
- `132` = front-state consumer topology 的后继根页

继续往 `133-138` 读时，读者最容易留下新的线性误判：

- `133` 继续讲 metadata
- `134` 继续讲 bridge
- `135` 开始讲 direct connect
- `136` 再补 bridge v2
- `137` 再回到 frontend consumer
- `138` 最后收成 activeRemote

于是正文就会滑成一句看似自然、实际上过粗的话：

- “`133-138` 只是把 132 的 consumer topology 一路往下细化成六篇并列 remote 小文。”

这句不稳。

从当前源码看，`133-138` 至少分成三条不同后继线：

1. `133 -> 137`：schema/store existence 到 cross-frontend consumer path
2. `134 -> 136`：bridge consumer chain 到 v2 active surface split
3. `135 -> 138`：foreground remote runtime 到 shared interaction shell

所以这页要补的不是更多 leaf-level 证明，

而是先把 `133-138` 写成：

- 三条两步后继线

而不是：

- 一条线性六连

本页不重讲 `133/134/135/136/137/138` 各页各自的页内证明，也不把 `pending_action`、`post_turn_summary`、`task_summary`、`externalMetadataToAppState(...)`、`createV1ReplTransport`、`createV2ReplTransport`、`reportState`、`activeRemote`、`remoteSessionUrl` 这些局部对象和 helper / state 名重新升级成新的总纲主角；这里只整理一张跨页拓扑图：`133→137` 这一条讨论 schema/store existence 与 cross-frontend consumer path，`134→136` 这一条讨论 bridge chain split 与 v2 active surface，`135→138` 这一条讨论 foreground remote runtime 与 shared interaction shell，并顺手把稳定用户合同、条件性可见合同与灰度实现证据分层。换句话说，这里要裁定的是“哪几页属于同一条后继线、哪一步是在 zoom、哪一步已经把主语换成 interaction shell”，不是再把 leaf-level 的 metadata producer、bridge publish chain、runtime 壳或 remote presence 证明写成一条从 132 一路细化的连续链。

## 第一性原理

更稳的提问不是：

- “`133-138` 到底把 132 继续细到了哪里？”

而是先问七个更底层的问题：

1. 我现在写的是 schema/store 与当前 foreground consumer 的边界，还是 bridge 内部 chain 的分裂，还是 REPL 顶层 interaction shell？
2. 当前这条判断回答的是 producer/store 是否存在，还是当前 CLI foreground 是否真的消费？
3. 当前我在看的是 bridge 的 publish chain，还是 bridge 的 active front-state surface？
4. 当前我在写的是 direct connect 自身的 runtime 身份，还是 `activeRemote` 这层共享交互壳？
5. 当前这条线会不会继续分叉到更后的 `141/142/143`，还是它只是 `132` 下的一条局部 zoom？
6. 我是不是把同属 remote 词域的页，误写成了同一主语的连续细化？
7. 我是不是又把 `133-138` 压回成“bridge、metadata、runtime 混着讲”的 remote 尾巴？

只要这七轴先拆开，

后面就不会再把：

- `133/137` 的 consumer 边界
- `134/136` 的 bridge chain / active surface
- `135/138` 的 runtime / shared shell

写成同一条线性后续页。

## 第二层：更稳的结构是“从 132 分出去的三条两步后继线”

更稳的读法是：

```text
214 / 132 front-state consumer topology
  ├─ 第一条后继线：schema/store -> cross-frontend consumer path
  │    ├─ 133 schema/store 有账 != 当前 foreground 已消费     [根页]
  │    └─ 137 "frontend 会读" != 当前 CLI foreground contract [zoom]
  │
  ├─ 第二条后继线：bridge chain -> v2 active surface split
  │    ├─ 134 bridge v1/v2 != same consumer chain           [根页]
  │    └─ 136 same v2 != same active front-state surface    [zoom]
  │
  └─ 第三条后继线：foreground runtime -> shared interaction shell
       ├─ 135 direct connect != remote presence store       [根页]
       └─ 138 activeRemote != remote presence ledger        [zoom / 交接点]
```

这里真正该记住的一句是：

- `133/137` 在问 formal state / metadata 为什么不自动等于当前 CLI foreground consumer
- `134/136` 在问 bridge 内部为什么先按 chain depth 分裂，再按 active surface 分裂
- `135/138` 在问 direct connect 与 REPL 顶层为什么先落成 runtime / interaction shell，而不是 presence ledger

所以更准确的主语不是：

- 132 之后还有六张 remote 细页

而是：

- 132 之后先分出三条后继线，每条都只有两步

不过还要补一层更窄的保护句：

- `133` 不只是第一条线的根页，它还给 `134` 这条 bridge 子树提供了“schema/store != current foreground consumer” 的判读前提

## 第三层：`133` 是 consumer 边界根页，`137` 是 cross-frontend consumer path zoom

`133` 先保护的是：

- schema/type 里有字段
- worker store 里有 producer
- restore path 可能接上
- 不等于当前 foreground consumer 已接上

它在回答：

- `pending_action`
- `task_summary`
- `post_turn_summary`
- `externalMetadataToAppState`

为什么不能被写成：

- “既然 schema/store 里有了，前台只是还没把 UI 做完。”

`137` 回答的却不是：

- 还有哪些 metadata key

而是：

- `pending_action.input` 注释里的 frontend
- `task_summary` 的进展语义
- `post_turn_summary` 的 wide-wire / internal 地位
- `print.ts` 与 `directConnectManager` 的主动 narrowing

为什么说明：

- “frontend 会读”更像跨前端 consumer path
- 不是当前 CLI foreground contract

所以 `137` 更准确的位置不是：

- `133` 的 metadata appendix

而是：

- consumer 边界根页之上的 frontend-meaning zoom

这里最该保护的一句还有：

- `pending_action`
- `task_summary`
- `post_turn_summary`

在当前仓里的证据强度并不等档：

- `pending_action` 有明确 producer
- `task_summary` 当前更像有语义与清理，但正向写入证据更弱
- `post_turn_summary` 当前更像 schema / wide-wire 与 foreground narrowing

## 第四层：`134` 是 bridge chain 根页，`136` 是 v2 active surface zoom

`134` 表面上列的是：

- `createV1ReplTransport`
- `createV2ReplTransport`
- `reportState`
- `reportMetadata`
- `reportDelivery`

但它真正要保护的不是：

- v1/v2 协议名字不同

而是：

- same local surface 不等于 same front-state consumer chain
- v1 有本地 `replBridge*` surface，不等于它有 worker-side authoritative upload
- v2 真正新增的是 CCR worker store / delivery bookkeeping

所以 `134` 的稳定根句不是：

- bridge 只是协议有 v1/v2 差异

而是：

- bridge v1/v2 不是同一种 consumer chain

`136` 回答的却不是：

- v2 还有哪些 transport 细节

而是：

- `ccrMirrorEnabled`
- `outboundOnly`
- `system/init`
- `replBridgeConnected`
- `sessionUrl/connectUrl`

为什么说明：

- 即便同属 v2
- 也不是同一种 active front-state surface

所以 `136` 更稳的位置不是：

- `134` 的 v2 appendix

而是：

- bridge chain 根页之后，继续压到 active surface split 的 zoom

## 第五层：`135` 是 foreground runtime 根页，`138` 是 shared interaction shell zoom

`135` 先回答的是：

- `createDirectConnectSession`
- `DirectConnectSessionManager`
- `useDirectConnect`

为什么说明 direct connect 当前更像：

- foreground remote runtime

而不是：

- remote presence store

所以 `135` 的稳定根句是：

- 缺的不是几个 UI 组件
- 而是从启动合同开始就没被建模成 presence ledger

`138` 回答的却不是：

- direct connect 自己还有哪些字段

而是：

- `useDirectConnect`
- `useSSHSession`
- `useRemoteSession`
- `activeRemote`

为什么说明：

- REPL 顶层共享的是 interaction shell
- 不等于共享 remote presence ledger

所以 `138` 更准确的位置不是：

- `135` 的 REPL appendix

而是：

- 从 direct connect runtime 继续收窄到 REPL 顶层 shared shell 的 zoom

## 第六层：`138` 还是这组三线里真正通往 `204` 的交接点

这里还有一层非常值钱的结构关系。

`133/137` 这条线主要在保护：

- consumer boundary
- cross-frontend intent

`134/136` 这条线主要在保护：

- bridge publish chain
- v2 active surface split

只有 `135/138` 这条线会继续把问题送到：

- `141`
- `142`
- `143`

因为到了 `138`，

主语已经变成：

- REPL shared interaction shell

这时后面才自然分叉出：

- remote-session presence ledger
- bridge gray runtime
- global remote behavior bit

所以 `138` 不是单独一张尾页，

它还是：

- 这组三线里唯一继续向 `204` 那条更大分叉图交接的节点

## 第七层：因此 `133-138` 不是线性六连

把前面几层压成一句，更稳的结构句其实是：

- `133 -> 137` 讲 schema/store 到 cross-frontend consumer path
- `134 -> 136` 讲 bridge chain 到 v2 active surface split
- `135 -> 138` 讲 foreground runtime 到 shared interaction shell

所以最该避免的一种写法就是：

- “这些页都是 132 的连续细化，只是按不同对象轮流往下讲。”

## 第八层：稳定层与灰度层

### 稳定可见

- schema/store existence 不等于当前 foreground consumer
- `externalMetadataToAppState()` 当前只恢复极少子集
- bridge v1 的 `report*` 当前是 no-op，v2 才真正接上 worker-side state / delivery chain
- direct connect 当前更像 foreground runtime，不是 presence store
- `activeRemote` 当前统一的是 interaction API，不是 presence truth
- `pending_action/task_summary/post_turn_summary` 当前不能被写成同强度的“已落地 producer/store”事实

### 条件公开

- `task_summary`、`pending_action.input`、`post_turn_summary` 的真实 frontend consumer 仍带跨前端条件
- bridge v2 之内还要再分 full / outboundOnly / mirror 的 active surface
- direct connect / ssh 将来若写 authoritative state，才可能自然并入同一 presence ledger

### 内部/灰度层

- `reportDelivery(received/processed)` 的具体节奏
- `getLastSequenceNum()` / `flush()` 的恢复细节
- direct connect 的 filter 列表与未来 reconnect 策略
- `directConnectServerUrl`、`replBridgeSessionUrl` 等 display hint 的具体挂载时机

## 苏格拉底式自审

### 问：我现在写的是 consumer boundary、bridge chain，还是 interaction shell？

答：主语没先钉住，就不要把 `133-138` 顺着编号压成一条线。

### 问：我是不是把 “frontend 会读” 直接写成 “当前 CLI 会读”？

答：先追问是哪个 frontend，以及当前 repo 里有没有 foreground reader 证据。

### 问：我是不是把 v2 的 worker-side publish chain 写成了整个 bridge 的稳定合同？

答：先问 v1 的 `reportState/reportMetadata/reportDelivery` 在当前是不是 no-op。

### 问：我是不是把 direct connect 和 `activeRemote` 混成同一层？

答：先分 direct connect 自身的 runtime 身份，再分 REPL 顶层的 shared shell。

### 问：我是不是把 `138` 也当成普通 leaf，而忘了它会继续交给 `204`？

答：如果一句话没有先回答 shared interaction shell 与 presence ledger 的边界，它就还没真正进入 `138` 的主语。
