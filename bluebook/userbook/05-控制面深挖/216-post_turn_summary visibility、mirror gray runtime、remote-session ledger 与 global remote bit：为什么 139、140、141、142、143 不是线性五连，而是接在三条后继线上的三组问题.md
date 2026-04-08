# `post_turn_summary` visibility、mirror gray runtime、remote-session ledger 与 global remote bit：为什么 `139`、`140`、`141`、`142`、`143` 不是线性五连，而是接在三条后继线上的三组问题

## 用户目标

215 已经把 `133-138` 收成了三条两步后继线：

- `133 -> 137` = schema/store 到 cross-frontend consumer path
- `134 -> 136` = bridge consumer chain 到 v2 active surface split
- `135 -> 138` = foreground remote runtime 到 shared interaction shell

继续往 `139-143` 读时，读者最容易再留下一个线性误判：

- `139` 继续讲 mirror
- `140` 又回到 `post_turn_summary`
- `141` 开始讲 ledger
- `142` 又回到 mirror gray runtime
- `143` 最后收成 global remote bit

于是正文就会滑成一句看似自然、实际上过粗的话：

- “`139-143` 只是 remote 这条线往后继续展开的五篇顺序页。”

这句不稳。

从当前源码看，`139-143` 并不是一条编号连线，

而更像：

1. `140` 接在 `133 -> 137` 这条 consumer-boundary 线后面
2. `139 -> 142` 接在 `134 -> 136` 这条 mirror/runtime 线后面
3. `141` 与 `143` 接在 `138 -> 204` 这条 interaction-shell / remote-trunk 线上，分别回答 ledger 与 global bit

所以这页要补的不是更多 leaf-level 证明，

而是先把 `139-143` 写成：

- 三组不同后继问题

而不是：

- 一条线性五连

## 第一性原理

更稳的提问不是：

- “`139-143` 到底把 remote 再往后讲到了哪里？”

而是先问七个更底层的问题：

1. 我现在写的是可见性梯子、mirror runtime topology，还是 remote truth 的分层？
2. 当前这个结论接在 `133/137`、`134/136`，还是 `138/204` 哪条线后面？
3. 当前我在写的是 startup intent / implementation route / gray runtime，还是 authoritative ledger / global behavior bit？
4. 当前这条页在回答的是 raw wire / callback / terminal 可见性，还是 front-state consumer topology？
5. 这条页和前一页是同一主语的 zoom，还是只是编号相邻？
6. 我是不是把 mirror line 和 remote truth line 混成了一条 remote 尾巴？
7. 我是不是又把 `139-143` 压回成“编号挨着，所以顺着读”的线性串？

只要这七轴先拆开，

后面就不会再把：

- `140` 的 visibility ladder
- `139/142` 的 mirror gray runtime
- `141/143` 的 ledger / global bit split

写成同一条线性后续页。

## 第二层：更稳的结构是“三组后继问题”，不是线性五连

更稳的读法是：

```text
215 three-branch split
  ├─ consumer-boundary line
  │    └─ 140 post_turn_summary visibility ladder     [137 的后继 zoom]
  │
  ├─ mirror/runtime line
  │    └─ 139 mirror intent / routing / topology      [136 的后继 zoom]
  │         └─ 142 hook-mirror vs gray runtime        [139 的 zoom]
  │
  └─ interaction-shell / remote-trunk line
       └─ 138 shared interaction shell
            ├─ 141 remote-session presence ledger     [204 的 ledger 分叉]
            └─ 143 global remote behavior bit         [204 的 behavior-bit 分叉]
```

这里真正该记住的一句是：

- `140` 不是又一张 remote 页，而是 `137` 那条 consumer-attribution 线上的 visibility zoom
- `139/142` 不是和 `141/143` 并列的 remote truth 页，而是 mirror/runtime 线上的 contract 与 gray-runtime pair
- `141/143` 才是在 `138/204` 那条 remote-trunk 上，继续回答 authoritative ledger 与 global behavior bit

所以更准确的主语不是：

- `139-143` 是五张连续 remote 页

而是：

- 它们分别接在三条不同后继线后面

## 第三层：`140` 应归到 `133 -> 137` 的 visibility zoom，不该被拖进 mirror / ledger 线

`140` 表面上列的是：

- `SDKPostTurnSummaryMessageSchema`
- `StdoutMessageSchema`
- `SDKMessageSchema`
- `print.ts`
- `directConnectManager`

但它真正要保护的不是：

- 又一张 remote surface

而是：

- `post_turn_summary` 的 schema existence
- `@internal`
- stdout wire admissibility
- core SDK exclusion
- callback narrowing
- terminal semantic narrowing

所以 `140` 更稳的位置不是：

- `141` 前面的过渡页

而是：

- `137` 之后，继续把 “frontend 会读 / foreground 不一定读” 压窄到 visibility ladder 的 zoom

这里最该保护的一句是：

- `post_turn_summary` 不是单一“可见 / 不可见”状态

而是：

- wide-wire visible
- core-SDK invisible
- foreground still narrowed

## 第四层：`139` 是 mirror contract layers 页，`142` 是 gray-runtime zoom

`139` 回答的是：

- `ccrMirrorEnabled`
- `isEnvLessBridgeEnabled`
- `initReplBridge`
- `outboundOnly`
- `createV2ReplTransport`

为什么说明：

- startup intent
- implementation routing
- runtime topology

不是同一层 mirror 合同。

所以 `139` 更稳的位置不是：

- `136` 的重复说明

而是：

- 在 `136` 的 active-surface split 之后，继续压到 mirror contract layers 的后继页

`142` 回答的却不是：

- mirror 开没开

而是：

- hook 已经按 `outboundOnly` 压薄本地 surface
- env-based core 却仍可能保留 ingress / control / permission 的双向 wiring

为什么说明：

- hook 已 mirror
- core 仍可能 gray

所以 `142` 更准确的位置不是：

- 另一张 mirror sibling

而是：

- `139` 那条 contract-layers 页之后，对 gray runtime 的具体 zoom

## 第五层：`141` 与 `143` 接在 `138 -> 204` 这条 truth 分叉线上

到了 `141` 与 `143`，

问题主语已经从 mirror line 换成了：

- shared interaction shell 之后，remote truth 该怎样继续分家

`141` 先回答的是：

- `remoteSessionUrl`
- `remoteConnectionStatus`
- `remoteBackgroundTaskCount`

为什么说明：

- remote-session presence ledger 不会自动被 direct connect / ssh remote 复用

所以它属于：

- authoritative presence ledger 分叉

`143` 回答的却是：

- `getIsRemoteMode()`
- `setIsRemoteMode(...)`

为什么说明：

- 全局 remote behavior 开关
- 不等于 remote presence truth

所以它属于：

- global behavior bit 分叉

这两页都在 `204` 那条大图里有位置，

但主语并不相同：

- `141` 是 ledger truth
- `143` 是 coarse behavior truth

## 第六层：`141` 与 `143` 不是 root+zoom，更像 truth split 下的远距对照 sibling

这里也要避免另一个误判：

- “`143` 只是 `141` 的布尔版。”

这句不稳。

因为 `141` 要保护的是：

- 哪些字段构成 authoritative presence ledger

而 `143` 要保护的是：

- 为什么一个被广泛消费的布尔环境位
- 仍然不等于 presence truth

所以它们更像：

- 同在 `138/204` 之后
- 但分别守 ledger 与 behavior bit 两种 truth

而不是：

- 同一页的粗细两个版本

## 第七层：这也是为什么 `139-143` 不能直接并到一张 “remote truth” 表里

把前面几层压成一句，更稳的结构句其实是：

- `140` 还在讲可见性梯子
- `139/142` 在讲 mirror runtime topology
- `141/143` 在讲 ledger truth 与 behavior truth 的反重叠

所以最该避免的一种写法就是：

- “这些页都在讲 remote truth，只是越往后越细。”

## 第八层：稳定层与灰度层

### 稳定可见

- `post_turn_summary` 当前同时存在 schema / wide-wire / internal / foreground narrowing 多层可见性
- mirror intent、implementation route 与 runtime topology 当前确实不是同一层
- hook side `outboundOnly` 与 core side runtime topology 当前可能分叉
- `remoteSessionUrl / remoteConnectionStatus / remoteBackgroundTaskCount` 当前是 remote-session ledger
- `getIsRemoteMode()` 当前更像 global behavior bit，不是 presence truth

### 条件公开

- `140` 的 raw wire 可见性仍取决于上游是否 emit 以及当前 output/consumer 选择
- `139/142` 的 gray runtime 仍依赖 env-less / env-based 选路与 rollout
- `141/143` 的 consumer 范围仍会受命令显隐、pane 内容与 UI gate 影响

### 内部/灰度层

- `post_turn_summary` 未来是否进入 core SDK contract
- env-based core 是否会真正吃到 `outboundOnly`
- `getIsRemoteMode()` 未来是否继续只保留 behavior 语义
- `directConnectServerUrl`、`remoteSessionUrl`、status line tag 的具体挂载策略

## 苏格拉底式自审

### 问：我现在写的是可见性、mirror topology，还是 truth split？

答：如果一句话不能先回答自己属于哪组三页，就不要落字。

### 问：我是不是把 `140` 误拖进了 remote-truth 线？

答：先追问它回答的是 visibility ladder，还是 presence / behavior truth。

### 问：我是不是把 `142` 当成了另一张 mirror 根页？

答：如果一句话没有先经过 `139` 的 contract-layers，就还没真正进入 gray-runtime zoom。

### 问：我是不是把 `143` 写成了 `141` 的布尔版？

答：先分 ledger truth 与 behavior bit；这两者不共享同一张账。
