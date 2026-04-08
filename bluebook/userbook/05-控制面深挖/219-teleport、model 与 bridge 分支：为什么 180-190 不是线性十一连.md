# `teleport`、model 与 bridge 分支：为什么 `180-190` 不是线性十一连

## 用户目标

218 刚把 `168-179` 收成：

- `179 -> 180` 还没展开的 git-context runtime 问题
- `178` 里藏着的 `model` 主语
- `176` 附近还没继续拆开的 createSession / history 问题

继续往 `180-190` 读时，读者最容易留下一个新的线性误判：

- `180` 先讲 teleport
- `181` 再讲 history create / hydrate
- `182` 开始讲 model
- `189`、`190` 最后又回到 bridge replay / write

于是正文就会滑成一句看似自然、实际上已经混层的话：

- “`180-190` 只是从 teleport、model 再走到 bridge write 的线性十一连。”

这句不稳。

从当前源码、索引页和记忆页看，更稳的结构不是：

- 一条线性十一连

而是三条从 218 子树继续长出来的后继线：

1. `178 -> 179 -> 180` = git-context 进入 teleport runtime contract
2. model line
   - `178 -> 182` = ledger trunk
   - `184 -> 185 -> 187 -> 188` = selection / source / allowlist trunk
3. bridge line
   - `176 -> 181 -> 183 -> 186 -> 189 -> 190` = outbound birth / hydrate / replay / write trunk
   - `190 -> 191 -> {192, 193 -> 206}` = post-connect ingress / control / blocked-state branch

所以这页要补的不是更多 leaf-level 证明，

而是先把 `180-190` 写成：

- teleport、model 与 bridge 三条后继线

而不是：

- 一条线性十一连

## 第一性原理

更稳的提问不是：

- “`180-190` 最后到底是在讲 teleport、model，还是 bridge replay？”

而是先问六个更底层的问题：

1. 我现在写的是 git-context 进入 runtime 后的 contract，还是 `model` 进入 runtime 后的不同账本 / 主权 / allowlist surface？
2. 当前逻辑在回答 admission / replay、authority / source / veto，还是 birth / hydrate / write？
3. 当前页是前一页的 zoom，还是来自 218 子树里另一条 sibling line？
4. 同样都出现 `model`、`events`、`writeBatch`，它们回答的是同一种对象层问题吗？
5. 当前失败会阻断 teleport / session birth，还是只在 replay / write 阶段产生 notice 或 suppress 差异？
6. 如果三条分支共用一些 helper 名和 transport 名，为什么还要坚持把它们写成不同后继线？

只要这六轴先拆开，

后面就不会再把：

- `180` 的 teleport runtime
- `182` 与 `184/185/187/188` 的 model line
- `181/183/186/189/190` 的 bridge line

压成同一条编号尾巴。

## 第二层：更稳的结构是“三条后继线”，不是一条十一连

更稳的读法是：

```text
218 create-context subtree
  ├─ 178 session_context split
  │   ├─ 179 git declaration vs branch projection
  │   │   └─ 180 teleport runtime: repo admission vs branch replay
  │   └─ model line
  │       ├─ 182 model ledger trunk
  │       └─ 184 runtime selection trunk
  │           └─ 185 startup model source family
  │               └─ 187 allowlist veto stage
  │                   └─ 188 allowlist surface split
  │
  └─ 176 createSession field authority
      └─ 181 session birth vs history hydrate
          └─ 183 initial message ledger
              └─ 186 bridge history projection vs model prompt authority
                  └─ 189 continuity ledger vs fresh-session replay
                      └─ 190 REPL path vs daemon path write contract
                          └─ 191 ingress triage root
                              ├─ 192 read-side continuity vs fresh-session reset
                              └─ 193 control side-channel legs
                                  └─ 206 blocked-state publish ceiling
```

这里真正该记住的一句是：

- `180` 不是 `181` 的上一步
- `182` 也不是 `181` 的旁注
- `181`、`182`、`184` 都是在 218 子树内部，沿不同主语继续长出的后继线

## 第三层：`180` 只属于 `179` 的 git-context 运行时线，不属于 model / bridge 主线

`179` 先回答的是：

- repo declaration
- branch projection

为什么不是同一种 git context。

`180` 则把这条字段语义继续推进到运行时：

- `validateSessionRepository(...)`
- `getBranchFromSession(...)`
- `checkOutTeleportedSessionBranch(...)`
- `teleportToRemote(...)`

为什么说明：

- repo admission
- branch replay

不是同一种 teleport contract。

所以 `180` 的稳定根句不是：

- git 字段终于开始被真正消费

而是：

- declaration / projection 一旦进入 teleport runtime，就会再分成 admission 与 replay 两层合同

这说明 `180` 更准确的位置不是：

- `181` 前面的编号起手页

而是：

- `179` 下面那条 teleport runtime zoom

## 第四层：model 不是一条线性五连，而是“ledger trunk + selection/allowlist trunk”

`178` 先把 `session_context` 拆成：

- `sources`
- `outcomes`
- `model`

三种主语。

`182` 接住的正是：

- `session_context.model`

继续把 model 线拆成：

- create-time stamp
- live shadow
- durable usage ledger
- resumed-agent fallback

所以 `182` 的根句不是：

- 现在开始顺手补一下 model 细节

而是：

- `session_context` 里的 model 一旦进入 runtime / restore / accounting，就会再分成多张 ledger

但这并不自动推出：

- `184/185/187/188` 都是 `182` 的线性后继

因为 `184` 真正换掉的主语已经是：

- persisted preference
- live override
- resumed-agent fallback

为什么不是同一种 authority。

`185` 则继续只问 startup source family：

- ambient env preference
- saved setting
- agent bootstrap
- live launch override

`187` 再把同一条 model selection 线推进到：

- source selection
- allowlist admission
- default fallback

`188` 最后才进入：

- explicit rejection
- option hiding
- silent veto

这些 surface 为什么不是同一种 allowlist contract。

所以更稳的结构不是把 `182/184/185/187/188` 写成：

- 一条 model 线性五连

而是：

- `182` = model ledger trunk
- `184 -> 185 -> 187 -> 188` = model selection / source / allowlist trunk

更稳的 model 子树应该记成：

```text
model line
  ├─ 182 ledger trunk
  │   ├─ create-time stamp
  │   ├─ live shadow / readback
  │   ├─ durable usage ledger
  │   └─ resumed-agent fallback
  └─ 184 resolution trunk
      ├─ authority order
      ├─ 185 startup source-family zoom
      ├─ 187 allowlist-stage zoom
      └─ 188 allowlist-surface zoom
```

这里最容易犯的错不是漏掉某个 helper，

而是把不同层的问题写成同一种“model 设置”：

- `182` 回答的是“到底有哪些 model fact”
- `184` 回答的是“当前 runtime authority 怎么排”
- `185` 回答的是“authority 上游 source family 从哪里来”
- `187` 回答的是“挑出 candidate 之后，admission 怎样改写 runtime 结果”
- `188` 回答的是“allowlist 在不同用户 surface 上怎样显影”

所以如果接下来只想继续深读 model，

目录上也不该再另起一张 model-only branch map。

更稳的做法是：

- 继续把 `182/184/185/187/188` 视为 `180-190` branch map 内部的一条后继线
- 再回各自 leaf page 里追局部证据
- 不把 `183/186` 这类 bridge 节点误判成“model 线中间缺页”

## 第五层：`181 -> 183 -> 186 -> 189 -> 190` 是 bridge outbound trunk，不是 bridge 终点

`176` 先把 `createBridgeSession(...)` 里的 field authority 拆开。

`181` 则不是继续讲这些 field 的主权，

它换成另一条与 createSession 更接近、但主语不同的线：

- `createBridgeSession.events`
- `initialMessages`
- `previouslyFlushedUUIDs`
- `writeBatch(...)`

为什么说明：

- session birth
- history hydrate

不是同一种合同。

所以 `181` 更准确的位置不是：

- `180` 的 session replay后续页

也不是：

- `182` 之前的 model 铺垫

而是：

- 从 `176` 的 createSession 区域继续长出的 birth / hydrate 根页

`183` 再继续只追：

- `initialMessageUUIDs`
- `previouslyFlushedUUIDs`
- `createBridgeSession.events`
- `writeBatch(...)`

为什么说明：

- local dedup seed
- real delivery ledger

不是同一种账。

`186` 又继续追：

- `initialHistoryCap`
- `isEligibleBridgeMessage(...)`
- `toSDKMessages(...)`
- `local_command`

为什么说明：

- bridge history projection

不是：

- model prompt authority

`189` 再把这条线推进到：

- v1 continuity ledger
- v2 fresh-session replay

为什么不是同一种 history contract。

`190` 最后继续只问：

- `writeMessages(...)`
- `writeSdkMessages(...)`
- `initialMessageUUIDs`
- `recentPostedUUIDs`
- `flushGate`

为什么说明：

- REPL path
- daemon path

不是同一种 bridge write contract。

但 `190` 仍然不是这条 bridge 线的终点。

它更准确的位置是：

- outbound write trunk 的末端

因为写完之后，bridge 还会立刻长出下一段 post-connect runtime 问题：

- `191` 先问 ingress triage root
- `192` 再问 read-side continuity vs fresh-session reset
- `193` 再问 control side-channel 两条 callback leg
- `206` 最后继续只追 blocked-state publish ceiling

所以这条线更稳的读法不是：

- create / hydrate / replay / write 的线性自然展开

而是：

- `181` 先问 birth vs hydrate
- `183` 追哪张 ledger 才算真实历史账
- `186` 再追 replay object 与 prompt authority 的错位
- `189` 再追 continuity inheritance
- `190` 先落到 outbound write contract split
- 然后再从 `191 -> {192, 193 -> 206}` 转入 post-connect ingress / control / state 问题

## 第六层：这三条线不能互相偷换

### `180` 不能偷换成 `181`

因为 `180` 回答的是：

- teleport runtime 的 repo admission / branch replay

不是：

- bridge create / hydrate

### `182...188` 不能偷换成 `181...190`

因为前者回答的是：

- model line里的 ledger / authority / source / allowlist

后者回答的是：

- bridge birth / hydrate / replay / write

### `182` 不能偷换成 `180`

因为 `182` 接的是：

- `178` 的 `session_context.model`

而 `180` 接的是：

- `179` 的 git declaration / branch projection

## 第七层：稳定阅读骨架 / 条件公开 / 内部证据层

这里的“稳定”只指：

- `180-190` 作为阅读骨架已经收稳

不指：

- `teleport runtime zoom`、`model ledger`、`bridge outbound trunk` 这些分析节点本身已经升级成稳定公开能力

真正的稳定公开能力判断，仍应回到用户入口、公开主路径与能力边界写作规范。

| 类型 | 对象 |
| --- | --- |
| 稳定阅读骨架 | 稳定的是三条后继线的分层读法：`180` 接 `179` 的 teleport runtime 线；`182 -> 184 -> 185 -> 187 -> 188` 组成 model ledger / resolution / allowlist 线；`181 -> 183 -> 186 -> 189 -> 190` 固定 bridge outbound trunk，并明确它会继续长向 post-190 的 ingress / control / blocked-state 后继问题。 |
| 条件公开 | 显式 `environmentId` teleport path、`outcomes: []`、`ANTHROPIC_MODEL` / agent bootstrap / allowlist veto、v1 continuity 继承与 v2 fresh-session replay、same-session carryover 与 foreground restore 厚度差异 |
| 内部证据层 | `teleport runtime zoom`、`model ledger`、`session_context.model`、`metadata.model`、`lastModelUsage`、override slot 的具体存储形状、`initialMessageUUIDs` / `recentPostedUUIDs` / `recentInboundUUIDs` / `lastTransportSequenceNum` 这些具体账本、branch naming、history cap 数值、provider / allowlist 细则、部分 UX surface 的报错文案 |

## 苏格拉底式自审

### 问：我现在写的是 teleport runtime、model，还是 bridge history/write？

答：如果一句话说不清自己属于哪条线，就不要落字。

### 问：我是不是因为几页都出现 `createBridgeSession`、`writeBatch`、`model`，就把它们混成同一条主线？

答：先分字段语义、runtime contract、ledger、write path，再看是否真的同根。

### 问：我是不是把 `189` 和 `190` 都写成 generic dedup 尾页？

答：先问当前句子在追 continuity inheritance，还是 write contract split。

### 问：我是不是把 `185/187/188` 只写成“模型设置细节”？

答：先分 startup source、admission veto 与 surface contract；这些不是同一层。

### 问：我是不是把 override sink、startup snapshot 与 raw source family 写成同一种来源？

答：同槽不等于同源；先分 env / settings / agent bootstrap，再分 launch sink / initial snapshot。

### 问：我是不是把 `/model`、`/config`、picker 与 silent getter veto 写成同一种 allowlist 行为？

答：先分 explicit rejection、write validator、option hiding、silent veto，再判断哪些属于稳定用户面。

### 问：我是不是把 `190` 写成了 bridge 线的终点？

答：`190` 只结束 outbound write trunk；post-connect 的 ingress / control / blocked-state 问题还会继续长到 `191/192/193/206`。
