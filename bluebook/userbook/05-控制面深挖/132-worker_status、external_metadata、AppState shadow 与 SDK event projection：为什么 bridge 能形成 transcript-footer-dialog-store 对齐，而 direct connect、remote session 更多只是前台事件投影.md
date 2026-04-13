# `worker_status`、`external_metadata`、`AppState shadow` 与 SDK event projection：为什么 bridge 能形成 transcript-footer-dialog-store 对齐，而 direct connect、remote session 更多只是前台事件投影

## 用户目标

130 已经把“远端存在感”拆成了不同的 surface presence，

131 又把 remote session 里的 warning / connection status / background count / brief line 拆成了不同的账。

但继续往下读时，读者还是很容易把三条链路重新压成一句：

- direct connect 有 transcript
- remote session 也有 transcript、footer 和一点状态
- bridge 只是再多一个 dialog 和一些 bridge 字段

于是正文就会滑成一句看似自然、实际上过于粗暴的话：

- “三条链路只是前台 UI 厚度不同，本质上都在消费同一套远端运行态。”

这句不稳。

从当前源码看，它们连“有没有真正消费 authoritative runtime state”这件事都不一样。

更准确地说，至少有三种不同前台消费形态：

1. direct connect：主要是 transcript projection + permission queue
2. remote session：主要是 event projection + partial `AppState` shadow
3. bridge：本地 `AppState` shadow、transcript status、footer、dialog，再加 worker-side `worker_status/external_metadata`

所以这页要补的不是：

- “哪条链路 UI 更丰富”

而是：

- “哪条链路到底有没有把正式运行态真正消费到前台”

本页不继续展开：

- direct connect 为什么会被进一步收束成 foreground remote runtime
- `activeRemote` 为什么只是 shared interaction shell
- `remoteSessionUrl / remoteConnectionStatus / remoteBackgroundTaskCount` 为什么会被固定成 presence ledger
- bridge mirror 为什么仍应读作 gray runtime
- `getIsRemoteMode()` 为什么只是 global remote behavior bit

这里先把这些后继问题都降回一句：

- 谁在消费 formal runtime state，谁只有 partial shadow 或 event projection

也就是说，这页只钉三条链路的 front-state consumer topology，

不提前代讲 `135/138/141/142/143` 各自的后继根句。

## 第一性原理

更稳的提问不是：

- “三条链路都能看到状态，差别到底在哪？”

而是先问五个更底层的问题：

1. 哪条链路手里有正式运行态：`worker_status`、`requires_action_details`、`external_metadata`？
2. 哪条链路只是把 SDK event 临时投到 transcript，而没有前台状态账本？
3. 哪条链路有本地 `AppState` shadow，哪条没有？
4. 哪条链路能把同一份状态同时消费到 transcript、footer、dialog、store？
5. v1 / v2 或 viewer / non-viewer 条件变化时，消费断点会不会改变？

只要这五轴先拆开，后三条链路就不会再被写成同一种 front-state consumer。

## 第一层：正式运行态并不是“有消息就算有状态”，而是 `worker_status + external_metadata`

`sessionState.ts` 已经把正式运行态定义得很清楚：

- `SessionState = 'idle' | 'running' | 'requires_action'`
- `SessionExternalMetadata`
  - `pending_action`
  - `post_turn_summary`
  - `task_summary`
  - 以及其他外部元数据

更重要的是，这里还定义了两条正式通知面：

- `setSessionStateChangedListener`
- `setSessionMetadataChangedListener`

也就是说，Claude Code 当前并不是把“前台看到的任何事件”都视为 authoritative state。

真正可被认作正式运行态的东西更接近：

- typed session state
- worker-side external metadata

如果后面某条链路根本没有消费这两张账，

那它就更像：

- event projection

而不是：

- front-state consumer

## 第二层：direct connect 基本没有 dedicated 前台状态账本，更多只是 transcript projection

`main.tsx` 的 direct connect 路径先做的事情很简单：

- 创建 direct connect session
- 注入一条 `Connected to server at ...` 的 info message
- 然后进入 REPL

它没有像 `--remote` / attached viewer 那样：

- `setIsRemoteMode(true)`

只会把：

- `directConnectServerUrl`

写进 bootstrap state，主要给顶部 header / cwd 文案使用。

`useDirectConnect.ts` 再往下看，会发现它的运行态承接相当薄：

- `hasReceivedInitRef`
- `isConnectedRef`
- `setIsLoading`
- `setToolUseConfirmQueue`
- `setMessages`

它没有专门的：

- `remoteConnectionStatus`
- dedicated remote footer state
- dedicated remote dialog state
- dedicated front-stage store shadow

而 `DirectConnectSessionManager` 的消费规则也很克制：

- `can_use_tool` 进入 permission queue
- 普通 SDK message 进 transcript adapter
- `post_turn_summary` 被显式过滤

再加上断线处理是：

- `process.stderr.write(...)`
- `gracefulShutdown(1)`

这说明 direct connect 当前回答的问题更像：

- “把对端 event 投到本地 transcript 和本地审批 UI 上”

而不是：

- “把正式运行态沉到本地前台状态表，再分别喂给 footer / dialog / store”

所以这一层更准确的主语是：

- transcript + permission queue projection

不是：

- front-state shadow store

换句话说，direct connect 当前不是一套独立 remote UI 子系统，

而是：

- 把远端 authoritative stream 裁剪后，接入本地 REPL 现成的 transcript、loading 和 permission queue

## 第三层：remote session 比 direct connect 更厚，但仍然主要是 event projection + partial shadow

remote session 这条线确实比 direct connect 多了一层本地 shadow：

- `remoteSessionUrl`
- `remoteConnectionStatus`
- `remoteBackgroundTaskCount`

但把它写成“已经拥有完整前台状态账本”仍然不对。

`useRemoteSession.ts` 当前明确只把少数东西写进 `AppState`：

- WS lifecycle -> `remoteConnectionStatus`
- 远端 task event counter -> `remoteBackgroundTaskCount`

而 transcript 侧又是通过 `sdkMessageAdapter` 做投影消费：

- `system/init` -> 可见
- `system/status` -> 有选择地可见
- `compact_boundary` -> 可见
- 其他多数 `system` subtype -> ignored

这说明 remote session 当前更像：

- 正式运行态在远端 worker / event stream
- 本地前台只保留一小块 partial shadow
- transcript 再从 event stream 里做选择性投影

它没有像 bridge 那样形成一套同时喂给：

- transcript
- footer
- dialog
- worker-side state store

的统一消费链。

所以 remote session 的当前形态更接近：

- event projection with partial shadow

不是：

- aligned front-state consumer

## 第四层：bridge 才真正拥有“正式状态 -> 多前台 surface” 的对齐链

bridge 这条线的结构明显厚得多。

### 一层：worker-side 正式状态上传

`remoteIO.ts` 在 CCR v2 下会把：

- `setSessionStateChangedListener`
- `setSessionMetadataChangedListener`

都接到：

- `ccrClient.reportState`
- `ccrClient.reportMetadata`

而 `CCRClient` 自己又把它们写成：

- `worker_status`
- `requires_action_details`
- `external_metadata`

并通过 `WorkerStateUploader` 做 coalescing upload。

这说明 bridge 不只是“前台显示一些状态”，

而是把正式运行态写进了 worker-side authoritative store。

### 二层：本地 `AppState` shadow

`useReplBridge.tsx` 又把 bridge 生命周期和桥接资源写进本地状态：

- `replBridgeConnected`
- `replBridgeSessionActive`
- `replBridgeReconnecting`
- `replBridgeConnectUrl`
- `replBridgeSessionUrl`
- `replBridgeEnvironmentId`
- `replBridgeSessionId`
- `replBridgeError`

这使 bridge 在本地前台还有第二张状态账。

### 三层：transcript / footer / dialog 三面消费

bridge 还会把自己的状态再分别喂给：

- transcript：`bridge_status` message
- footer：bridge pill
- dialog：`BridgeDialog`

这三面消费的还是同一批桥接 shadow state。

所以 bridge 当前最像：

- authoritative state + local shadow + multi-surface consumer alignment

这和 direct connect、remote session 的厚度已经不是一个量级。

## 第五层：bridge 的对齐还受 v1 / v2 条件约束，不是无条件全时成立

这里还要再压窄一步，

否则就会把 bridge 写成“永远完整消费正式状态”的绝对真理。

`replBridgeTransport.ts` 很清楚：

- v1 `reportState` / `reportMetadata` / `reportDelivery` 都是 no-op
- v2 才真正把这些接到 `CCRClient`

而 `remoteBridgeCore.ts` 那些：

- `reportState('running')`
- `reportState('requires_action')`
- `reportState('idle')`

也只有在 v2 transport 上才会真正进入 worker store。

所以更准确的说法应是：

- bridge 这条线最接近形成 transcript/footer/dialog/store 对齐
- 但 worker-side authoritative state upload 的完整成立，当前仍取决于 v2

这就是为什么这页必须保留：

- stable / conditional / internal-gray

三层拆法，而不能把 bridge 写成一个无条件完备的前台状态体系。

## 第六层：因此三条链路的本质差别，不是“文案多一点少一点”，而是 consumer topology 不同

把前面几层压成一句，最稳的一句其实是：

- consumer topology differs before UI thickness differs

大致可以压成下面这张矩阵：

| 链路 | transcript | footer | dialog | local shadow | worker store |
| --- | --- | --- | --- | --- | --- |
| direct connect | 强 | 基本无 dedicated remote footer | 无 dedicated remote dialog | 几乎没有 dedicated shadow | 无 |
| remote session | 中强，但选择性投影 | 有，但只是一小块 partial shadow | 基本复用本地审批 dialog，不是 remote state dialog | 有，且范围有限 | 运行态主要仍在远端 worker / event stream |
| bridge | 有专门 `bridge_status` | 有专门 bridge pill | 有专门 `BridgeDialog` | 有，且是系统性的 `replBridge*` | v2 下有正式 `worker_status/external_metadata` |

所以真正该写进 userbook 的结论不是：

- “bridge UI 更多”

而是：

- “bridge 的前台消费拓扑更完整，另外两条线更多只是事件投影”

## 第七层：为什么它不是 28、130、131 的重复页

### 它不是 28

28 讲的是：

- remote session client
- viewer
- bridge host

为什么不是同一种远程工作流。

132 讲的是：

- 它们各自有没有把正式运行态消费进前台

一个讲：

- workflow shape

一个讲：

- consumer topology

### 它不是 130

130 讲的是：

- 哪个 surface 在签 presence

132 讲的不是 presence，

而是：

- 谁在消费 authoritative runtime state

一个讲：

- presence signing

一个讲：

- front-state consumption

### 它不是 131

131 讲的是：

- remote session 内部几类信号分属不同账

132 讲的是：

- 三条链路整体的状态消费断点

一个讲：

- intra-remote-session accounting

一个讲：

- cross-path consumer structure

## 第八层：最常见的假等式

### 误判一：有 transcript banner / status message，就说明这条链路已经消费了正式运行态

错在漏掉：

- transcript 可能只是 event projection

### 误判二：remote session 有 footer 和几个 AppState 字段，就说明它和 bridge 一样有完整前台状态面

错在漏掉：

- remote session 当前只有 partial shadow

### 误判三：direct connect 没有 dedicated footer/dialog，所以说明它没有状态

错在漏掉：

- 它仍有 transcript projection 和 permission queue，只是 consumer topology 更薄

### 误判四：bridge 一定无条件具备 transcript/footer/dialog/store 四面对齐

错在漏掉：

- v1/v2 在 `reportState/reportMetadata` 上有条件分叉

### 误判五：`post_turn_summary`、`task_summary` 既然在 schema / store 里，就说明当前前台一定已经消费了它们

错在漏掉：

- schema/store 存在不等于前台 consumer 已接上

## 第九层：稳定层、条件层与灰度层

### 稳定可见

- `SessionState` 与 `SessionExternalMetadata` 当前构成 formal runtime state 的最稳起点
- direct connect 当前主要消费 transcript + permission queue，不构成 dedicated front-state store
- remote session 当前主要消费 event projection + partial `AppState` shadow
- bridge 当前最接近形成 transcript/footer/dialog/store 的多面对齐
- 这页当前稳定回答的是三条链路在 formal runtime state、partial shadow 与 event projection 之间的 consumer topology，不提前展开后继 remote-surface 分叉

### 条件公开

- bridge 的 worker-side state upload 当前依赖 v2；v1 是 no-op
- remote session 的 transcript thickness 还受 `viewerOnly` 与 adapter 过滤规则影响
- direct connect 当前显式过滤 `post_turn_summary`
- 后继页会不会继续把这些差异收束成 foreground runtime、shared shell、presence ledger、gray runtime 或 behavior bit，仍取决于各自 consumer 与 host gate，不是这页已经稳定公开的合同

### 内部 / 灰度层

- `post_turn_summary` / `task_summary` 当前哪些前台 consumer 尚未接上
- direct connect “没有 dedicated local store” 目前是强推断，依据是字段缺席 + hook refs 形态
- bridge 的 redacted `system/init`、upgrade nudge 等带产品策略色彩的细节

这些更适合作为：

- 当前实现证据

而不是：

- 对外稳定承诺

所以这页最稳的结论必须停在：

- 三条链路在 front-state consumer topology 上并不共享同一种 formal runtime-state 消费合同
- direct connect 当前更像 transcript + permission projection，remote session 当前更像 event projection + partial shadow，bridge 当前最接近 multi-surface alignment
- `132` 到这里为止；foreground runtime、shared interaction shell、presence ledger、gray runtime、behavior bit 这些更窄主语应交给后继页

而不能滑到：

- 只要 bridge UI 更厚，这页就已经替 `135/138/141/142/143` 把后续 remote-surface 细分一并讲完

## 第十层：苏格拉底式自审

### 问：我现在写的是正式运行态，还是事件投影？

答：如果答不出来，就把 authoritative state 和 transcript projection 混了。

### 问：我是不是把“有本地几点状态”偷换成了“有完整前台状态体系”？

答：如果是，就把 partial shadow 写过头了。

### 问：我是不是把 v2 的完整链路偷换成了 bridge 的全时稳定合同？

答：如果是，就漏掉了 v1/v2 分叉。

### 问：我是不是把 schema/store 里存在的字段自动当成了前台已消费的字段？

答：如果是，就把 producer 和 consumer 混成一张表了。

### 问：我是不是又把 130 的 surface presence 或 131 的 ledger 细拆，重复写成这页的主结论？

答：如果是，就还没有把“surface / ledger / consumer topology”三层分开。

## 结论

所以这页能安全落下的结论应停在：

- `SessionState + SessionExternalMetadata` 当前是 formal runtime state 的最稳起点
- direct connect 当前更像 transcript + permission projection
- remote session 当前更像 event projection + partial `AppState` shadow
- bridge 当前最接近 transcript/footer/dialog/store 对齐，但 worker-side authoritative state upload 仍受 v2 限定
- `132` 因而只负责钉死三条链路的 front-state consumer topology，并把 foreground runtime、shared interaction shell、presence ledger、gray runtime、behavior bit 留给后继页

一旦这句成立，

就不会再把：

- bridge 更厚的 UI
- direct connect 的 foreground runtime
- `activeRemote` 的 shared shell
- remote-session presence ledger
- bridge mirror 的 gray runtime
- `getIsRemoteMode()` 的 behavior bit

写成同一层 remote surface 结论。

## 源码锚点

- `claude-code-source-code/src/utils/sessionState.ts`
- `claude-code-source-code/src/cli/remoteIO.ts`
- `claude-code-source-code/src/cli/transports/ccrClient.ts`
- `claude-code-source-code/src/cli/transports/WorkerStateUploader.ts`
- `claude-code-source-code/src/server/directConnectManager.ts`
- `claude-code-source-code/src/hooks/useDirectConnect.ts`
- `claude-code-source-code/src/remote/sdkMessageAdapter.ts`
- `claude-code-source-code/src/hooks/useRemoteSession.ts`
- `claude-code-source-code/src/bridge/replBridgeTransport.ts`
- `claude-code-source-code/src/bridge/remoteBridgeCore.ts`
- `claude-code-source-code/src/hooks/useReplBridge.tsx`
- `claude-code-source-code/src/state/onChangeAppState.ts`
- `claude-code-source-code/src/components/PromptInput/PromptInputFooter.tsx`
- `claude-code-source-code/src/components/BridgeDialog.tsx`
