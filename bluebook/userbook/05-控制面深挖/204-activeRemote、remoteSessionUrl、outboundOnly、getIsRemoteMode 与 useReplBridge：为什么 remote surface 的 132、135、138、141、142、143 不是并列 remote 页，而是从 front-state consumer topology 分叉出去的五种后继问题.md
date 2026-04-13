# `activeRemote`、`remoteSessionUrl`、`outboundOnly`、`getIsRemoteMode` 与 `useReplBridge`：为什么 remote surface 的 132、135、138、141、142、143 不是并列 remote 页，而是从 front-state consumer topology 分叉出去的五种后继问题

## 用户目标

132、135、138、141、142、143 连着拆完之后，读者最容易出现一种新的误判：

- “这些页都在讲 remote surface，应该是六篇平行小文，按兴趣挑一篇读就行。”

这句话看似高效，

其实会让后面的很多句子重新塌掉。

因为 132 不是六页中的一篇并列 remote 页，

而是整组 remote surface 的根页：

- 它先回答三条链路到底在消费 authoritative state，还是更多只在做前台事件投影

随后这条线才会继续收窄：

1. 先单独把 direct connect 固定成 foreground remote runtime，而不是 presence store
2. 再把 REPL 顶层 `activeRemote` 固定成 shared interaction shell
3. 然后才从这里分叉出三种不同后继问题
4. remote-session presence ledger
5. bridge mirror 的 gray runtime
6. global remote behavior bit

如果这个顺序不先写死，读者就会：

- 把 141 写成所有 remote 壳共享 ledger 的“未完成版”
- 把 142 写成 bridge 版 141
- 把 143 写成 141 的别名

这句还不稳。

所以这里需要的不是再补一篇新的运行时正文，

而是补一页结构收束：

- 为什么 132、135、138、141、142、143 不是并列 remote 页，而是从 front-state consumer topology 分叉出去的五种后继问题

本页不重讲 `132/135/138/141/142/143` 各页各自的页内证明，也不把 `activeRemote`、`remoteSessionUrl`、`outboundOnly`、`getIsRemoteMode()`、`useReplBridge(...)`、`remoteConnectionStatus`、`remoteBackgroundTaskCount` 这些局部 helper / state / projection 名重新升级成新的总纲主角；这里只整理一张跨页拓扑图：`132` 先固定 front-state consumer topology，`135` 先把 direct connect 钉成 foreground remote runtime，`138` 再把 REPL 顶层交互壳钉成 shared interaction shell，随后才从这里继续分叉到 `141` 的 remote-session presence ledger、`142` 的 bridge gray runtime 与 `143` 的 global remote behavior bit，并顺手把稳定的 consumer-topology 骨架、宿主条件性的 remote surface 分支与局部 projection-evidence 分层。换句话说，这里要裁定的是“哪一页还是根页、哪一页已经换成 foreground runtime / interaction shell / presence / gray runtime / behavior bit”，不是再把 leaf-level 的 event projection、URL / ledger、mirror overlay 或 remote bit 证明写成一串并排的 remote 细节。

## 第一性原理

更稳的提问不是：

- “这六页都在讲 remote，我该先看哪篇？”

而是先问六个更底层的问题：

1. 我现在卡住的是三条远端链路的前台消费拓扑，还是某一条更窄的 remote surface 后继问题？
2. 我现在问的是 direct connect 这种 foreground runtime，还是 remote-session / bridge 这类 presence 或 overlay 问题？
3. 我现在问的是 REPL 顶层 shared interaction shell，还是更下游的 authoritative ledger？
4. 我现在关心的是 remote-session presence、bridge gray runtime，还是 global remote behavior bit？
5. 我现在需要的是一个用户目标入口，还是一个局部子系统的 anti-overlap map？
6. 我是不是已经把 runtime、presence、overlay、behavior bit 混成同一种 remote 尾巴？

只要这六轴不先拆开，

后面就会把：

- 132 的 front-state consumer topology
- 135 的 foreground remote runtime
- 138 的 shared interaction shell
- 141 的 remote-session presence ledger
- 142 的 gray runtime
- 143 的 global behavior bit

重新压成一句模糊的：

- “remote 这条线还有很多细节”

## 第一层：132 不是 remote 页之一，而是整组分叉图的根页

132 先回答的是：

- direct connect
- remote session
- bridge

这三条链路到底在消费什么：

- transcript projection
- partial `AppState` shadow
- transcript / footer / dialog / worker-side store 对齐

如果这一层没先读，

你后面会把 135、138、141、142、143 全都误当成：

- 不同 transport 的 remote status 差异页

但事实不是。

132 的作用是给整组 remote surface 阅读图固定根页：

- 先定 front-state consumer topology

然后别的 remote 问题才能继续分叉。

## 第二层：135 先把 direct connect 固定成 foreground remote runtime，不是 presence store

135 回答的问题不是：

- remote 为什么没有全套 presence 字段

而是：

- direct connect 从启动合同、manager 裁剪和 REPL 接口上看，首先就是 foreground interactive transport

它的主语很窄：

- foreground remote runtime

这一步如果不先写死，

后面你会很容易把 138 误写成：

- 所有 remote 壳天然共享同一张 presence 账

或者把 141 误写成：

- direct connect / ssh remote 只是尚未补完的 presence store

这都不对。

135 的作用是先把：

- direct connect 的运行时身份

从别的 remote surface 主语里剥出来。

## 第三层：138 不是 132 的附录，而是 REPL 顶层 shared interaction shell

138 回答的问题不是：

- 哪条链路 authoritative state 更厚

而是：

- REPL 顶层为什么会把 `useRemoteSession`、`useDirectConnect`、`useSSHSession` 压进 `activeRemote`
- 但这仍然不等于共享 remote presence ledger

它的主语是：

- shared interaction shell

不是：

- authoritative presence ledger

这一步如果不先拆开，

你就会把：

- `isRemoteMode`
- `sendMessage(...)`
- `cancelRequest()`
- `disconnect()`

误写成系统的 remote truth。

但 138 更准确的位置只是：

- 在真正分叉到 ledger / gray runtime / remote bit 之前，先把 REPL 共同交互壳单独拎出来

## 第四层：141 不是 138 的自然续写，而是 remote-session presence ledger 分叉

141 继续回答的是：

- `remoteSessionUrl`
- `remoteConnectionStatus`
- `remoteBackgroundTaskCount`

为什么不会自动被 direct connect、ssh remote 复用。

它的主语不是：

- generic remote interaction

而是：

- `--remote` / assistant viewer 那张 authoritative presence ledger

这一步如果不先读，

你最容易把：

- direct connect 没写这些字段
- ssh remote 没写这些字段

重新压成：

- remote surface 只是 UI 厚度不同

但 141 实际只属于：

- remote-session presence 问题

## 第五层：142 不是 141 的 bridge 版，而是 mirror topology 的 gray runtime 分叉

142 继续往 bridge 这条线上收窄，回答的是：

- hook 侧已经按 `outboundOnly` 压薄本地 surface
- 但 env-based core 仍然可能保留 bidirectional wiring

它的主语从一开始就不是：

- presence ledger

而是：

- startup intent、hook semantics 与 runtime topology 之间的 gray split

这一步如果不先读，

你最容易把：

- `replBridgeConnected`
- `sessionUrl/connectUrl`
- inbound / control wiring

重新压成 141 那种 presence 缺失。

但 142 实际上只属于：

- bridge mirror runtime 的 gray topology 问题

## 第六层：143 不是 141 的别名，而是 global remote behavior bit 的分叉

143 接着回答的是：

- `getIsRemoteMode()`
- `setIsRemoteMode(...)`

为什么被很多 consumer 读取，

却仍然不等于：

- `remoteSessionUrl`
- presence truth

它的主语不是：

- authoritative ledger

而是：

- global behavior branch

这一步如果不先写死，

你就会把 143 误写成：

- 141 的简化布尔版

但 143 更准确的位置只是：

- 在 presence ledger 之外，单独解释系统为什么还会再保留一层 coarse remote bit

## 第七层：这页不是 20、不是 197，也不是 `00-阅读路径.md` 的复制

这里还要再防三个结构误判。

### 不是 20

20 的主语是：

- 远端接续、bridge ingress 输入注入、桥接审批与会话接续在用户目标层的分工

204 不再停在用户目标层，

它只处理：

- remote surface 这条局部控制面深线如何继续分叉

### 不是 197

197 的主语是：

- 191-196 这条 ingress 深线为什么要按六层链条读

204 的主语是：

- 132 之后 remote surface 如何继续从 topology、runtime、ledger、gray runtime 和 behavior bit 分裂

### 不是 `00-阅读路径.md`

`00-阅读路径.md` 回答的是：

- 读者从什么入口走进来

204 回答的是：

- 已经走进 remote surface 子系统之后
- 哪几个后继问题绝不能重新压扁

所以它是一张：

- 局部 anti-overlap map

不是入口清单。

## 第八层：稳定阅读骨架 / 条件公开 / 内部证据层

这里的“稳定”只指：

- `132 -> 135 / 138 / 141 / 142 / 143` 这张 remote surface 分叉骨架已经收稳

不指：

- `foreground remote runtime`、`shared interaction shell`、`presence ledger`、`gray runtime`、`behavior bit` 这些中间节点名本身已经升级成稳定公开能力

真正的稳定公开能力判断，仍应回到用户入口、公开主路径与能力边界写作规范。

### 稳定可见

- `132` 当前稳定回答的是三条 remote 链路在消费 formal runtime state、partial shadow 还是前台 projection
- `135` 当前稳定回答的是 direct connect 更像 foreground remote runtime，而不是 presence ledger
- `138` 当前稳定回答的是 `activeRemote` 只是一层 shared interaction shell，不是 authoritative state store
- `141` 当前稳定回答的是 `remoteSessionUrl / remoteConnectionStatus / remoteBackgroundTaskCount` 组成 remote-session presence ledger
- `142` 当前稳定回答的是 bridge mirror 仍应读作 gray runtime topology，而不是另一张 presence truth
- `143` 当前稳定回答的是 `getIsRemoteMode()` 更像 global remote behavior bit，不等于 presence truth

### 条件公开

- `135` 的 connect status、`sessionUrl/connectUrl` 与 interactive affordance 仍受当前宿主、attach 形态与连接路径影响
- `138` 的 shared shell 能覆盖哪些 consumer，仍取决于 frontend host、session family 与 current hook mounting
- `141` 的 ledger 可见面仍受 footer、status line、pane 内容和 host gate 约束
- `142` 的 mirror gray runtime 仍受 `outboundOnly`、`useReplBridge(...)`、env-less / env-based 选路与 rollout 条件影响
- `143` 的 behavior bit 被谁读取、会投影到哪些命令显隐或 status surface，仍取决于具体 consumer gate

### 内部/灰度层

- direct connect 的 exact ingress / control wiring、connection sequencing 与 reconnect 细节
- bridge mirror core 的 exact `session_state_changed`、transport rebuild 与 render gate 顺序
- footer、brief line、remote pill、dialog 的具体 mount / capture / dismiss 条件
- `activeRemote`、`remoteSessionUrl`、`getIsRemoteMode()` 未来是否继续维持当前投影边界

所以这页最稳的结论必须停在：

- `132-143` 之间已经形成一张有顺序的 remote surface 分叉骨架
- 它不是几张可按兴趣任意抽读的并列 remote 页

而不能滑到：

- 只要都和 remote 有关，这几页本质上只是不同写法的同一层说明

## 结论

所以这页能安全落下的结论应停在：

- 132 是 remote surface 的根页，因为它先定三条链路的 front-state consumer topology
- 135 先把 direct connect 固定成 foreground remote runtime
- 138 再把 `activeRemote` 固定成 shared interaction shell
- 141 处理 remote-session presence ledger
- 142 处理 bridge mirror 的 gray runtime
- 143 处理 global remote behavior bit

一旦这句成立，

就不会再把：

- runtime
- presence ledger
- gray runtime
- behavior bit

写成同一种“remote 页”。
