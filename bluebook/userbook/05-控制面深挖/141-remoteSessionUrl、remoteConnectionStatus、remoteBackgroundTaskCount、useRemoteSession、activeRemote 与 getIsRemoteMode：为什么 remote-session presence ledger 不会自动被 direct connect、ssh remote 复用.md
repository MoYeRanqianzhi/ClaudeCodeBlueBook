# `remoteSessionUrl`、`remoteConnectionStatus`、`remoteBackgroundTaskCount`、`useRemoteSession`、`activeRemote` 与 `getIsRemoteMode`：为什么 remote-session presence ledger 不会自动被 direct connect、ssh remote 复用

## 用户目标

138 已经把 REPL 顶层的 `activeRemote` 拆成：

- shared interaction shell
- not shared remote presence ledger

但如果继续往下不补这一页，读者还是很容易把另一种误解留住：

- 既然 direct connect、ssh remote、remote session 都算 remote mode
- 那 `remoteSessionUrl / remoteConnectionStatus / remoteBackgroundTaskCount` 这张账应该只是还没复用过去

这句不稳。

从当前源码看，这三者并不是一组“自然应当被所有 remote mode 共享”的通用字段，

而更像：

- 只服务 `--remote` / assistant viewer 这一条 presence 模式的 authoritative ledger

所以这页要补的不是：

- “为什么 direct connect / ssh remote UI 更薄”

而是：

- “为什么 remote-session presence ledger 根本就不是给 direct connect / ssh remote 复用的那张账”

## 第一性原理

更稳的提问不是：

- “为什么 direct connect / ssh remote 没复用这些字段？”

而是先问五个更底层的问题：

1. `remoteSessionUrl / remoteConnectionStatus / remoteBackgroundTaskCount` 回答的到底是交互问题，还是 presence 问题？
2. 当前哪些 consumer surface 明确依赖这三个字段？
3. direct connect / ssh remote 当前有没有任何代码把自己的 runtime 事件提升到这三张账里？
4. bootstrap 级 `getIsRemoteMode()` 与 `AppState` authoritative ledger 是不是同一回事？
5. 一个 remote mode 被系统当作“远端交互”对待，是否就等于它也会被当作“远端存在面”对待？

只要这五轴先拆开，remote-session ledger 就不会再被写成：

- “一张尚未普遍复用的 remote 通用状态表”

## 第一层：这三个字段在 `AppStateStore` 里本来就被定义成 remote-session 专属存在账

`AppStateStore.ts` 对这三项的注释非常直接：

- `remoteSessionUrl`: `--remote` mode 的 session URL，显示在 footer indicator
- `remoteConnectionStatus`: `claude assistant` viewer 的 WS 状态
- `remoteBackgroundTaskCount`: `claude assistant` 里远端 daemon child 的后台任务计数

这一步已经说明它们回答的主语不是：

- “任何 remote transport 都适用的状态”

而是：

- `--remote` / assistant viewer presence

所以如果后面再把 direct connect / ssh remote 写成“本来也应该填这张账”，

就已经偏离字段定义本身了。

## 第二层：`useRemoteSession()` 当前才真正建立这张 ledger

`useRemoteSession.ts` 里会明确：

- `useSetAppState()`
- 写 `remoteConnectionStatus`
- 写 `remoteBackgroundTaskCount`

而且这两项都不是一次性 bootstrap 值，

而是：

- 随 WS 生命周期变化而变
- 随远端 task 事件变化而变

这意味着 `useRemoteSession()` 当前不是：

- 又一个能远端发消息的 hook

而是：

- 真正建立 remote-session authoritative ledger 的那条线

所以这张账的归属首先就是：

- remote session path

而不是：

- all remote shells

## 第三层：`main.tsx` 里 `--remote` 会把 `remoteSessionUrl` 写进初始状态，而 direct connect 不会

`main.tsx` 的两条启动路径对比非常关键。

### `--remote` / remote session

它会：

- 构造 `remoteSessionUrl`
- 放进 `remoteInitialState`
- 明确注释 `for footer indicator`

### direct connect

它只会：

- `setDirectConnectServerUrl(...)`
- 写一条 `Connected to server at ...` 的 info message

而不会：

- 写 `remoteSessionUrl`
- 写 `remoteConnectionStatus`
- 写 `remoteBackgroundTaskCount`

所以 direct connect 当前缺的不是：

- “还没从远端同步出几项值”

而是：

- 它根本没被启动路径建模成 remote-session presence ledger 的 owner

## 第四层：`directConnectServerUrl` 只是 bootstrap display hint，不是 ledger 替身

这一步最容易被误判。

因为 bootstrap state 里确实有：

- `directConnectServerUrl`

而且注释也写着：

- for display in header

这说明 direct connect 当前确实有一份远端定位信息，

但这份信息的层级非常不同：

- 它是 bootstrap hint
- 不是 `AppState` 的可订阅 presence ledger

换句话说：

- `directConnectServerUrl` 能证明 direct connect 连接到了哪
- 不能证明它拥有 `remoteSessionUrl` 那种可被 footer / `/session` / brief status 共同消费的 authoritative 账本

## 第五层：`/session` 本身就是强反证，它只认 `remoteSessionUrl`

`commands/session/session.tsx` 这里非常直接：

- 如果没有 `remoteSessionUrl`
- 就提示 `Not in remote mode. Start with claude --remote`

这里最该注意的不是文案本身，

而是：

- 这个 pane 的“remote mode”语义，本质上就是 remote-session presence mode

也就是说，哪怕 direct connect / ssh remote 在别的地方也被算作 remote，

对于 `/session` 这一消费面来说：

- 没有 `remoteSessionUrl`
- 就不在这张账里

这能直接证明：

- remote-session ledger 不是“所有 remote mode 默认共享”的东西

## 第六层：footer 与 brief line 的 consumer 也都只认这张账，不认 direct connect / ssh 的 transport 壳

`PromptInputFooterLeftSide.tsx` 的 remote 链接只读：

- `remoteSessionUrl`

而且还是：

- 从 initial state 懒加载捕获

这说明 footer 的 remote 存在面当前就是：

- 有没有远端 session URL

不是：

- 当前 remote transport 在不在

`Spinner.tsx` 里的 `BriefIdleStatus` 又只读：

- `remoteConnectionStatus`
- `remoteBackgroundTaskCount`

所以 brief line 也在明确说：

- 它消费的是 remote-session ledger
- 不是 direct connect / ssh remote 的交互 runtime 信号

## 第七层：`getIsRemoteMode()` 更像“全局行为降级开关”，不是 presence ledger

这一步必须单独拆，因为它很容易把人带偏。

`bootstrap/state.ts` 里有：

- `getIsRemoteMode()`
- `setIsRemoteMode(...)`

而且它被很多地方用来做：

- 通知禁用
- 插件 / MCP / IDE 相关行为收缩
- 状态线上的 remote tag
- `/session` 命令显隐

这说明 `getIsRemoteMode()` 当前回答的是：

- “系统现在是不是处于某种 remote 运行环境”

它是个全局行为开关，

不是：

- 那张可以被多 surface 共享消费的 remote presence truth

也正因为如此，`commands/session/index.ts` 会出现一个很有价值的分层现象：

- 命令可见性看 `getIsRemoteMode()`
- 真正的 pane 内容却还要再检查 `remoteSessionUrl`

这再次说明：

- remote-mode flag
- remote-session ledger

不是同一层。

## 第八层：所以 direct connect / ssh remote 没复用这张账，不是“少写几项字段”，而是产品边界不同

把前面几层压成一句，更稳的一句是：

- remote-session presence ledger is specialized, not merely unshared

也就是说：

### 这张账当前在回答的是

- 有没有 remote session URL
- viewer WS 当前处于什么连接态
- 远端 daemon child 有多少后台任务

### 它当前并不在回答

- 任意 remote interaction shell 的运行态
- direct connect / ssh remote 的 transport 生命周期
- 所有 remote 模式通用的中断 / 提交 / 消息桥接状态

所以 direct connect / ssh remote 当前没有复用它，

更像是：

- 没有那个产品边界

而不是：

- 一个显然还没接完的 TODO

## 第九层：为什么这页不是 138 的重复

138 讲的是：

- `activeRemote` 统一的是 interaction shell
- 不是 shared presence ledger

141 讲的是：

- 这张 presence ledger 自己到底服务哪条路径
- 又为什么不会自然外溢到 direct connect / ssh remote

一个讲：

- REPL 顶层 abstraction 边界

一个讲：

- remote-session ledger 的专属 consumer / producer 边界

所以 141 不是重写 138，

而是把“不是共享 ledger”继续压到：

- “这张 ledger 本来就不通用”

## 第十层：最常见的四个假等式

### 误判一：所有 remote mode 都该共享 `remoteSessionUrl / remoteConnectionStatus / remoteBackgroundTaskCount`

错在漏掉：

- 字段定义本身就把主语限定在 `--remote` / assistant viewer

### 误判二：direct connect 有 `directConnectServerUrl`，所以它其实只差一步就能算同一张 ledger

错在漏掉：

- `directConnectServerUrl` 只是 bootstrap display hint
- 不是 `AppState` authoritative ledger

### 误判三：`getIsRemoteMode()` 为真，就说明 `/session`、footer、brief line 这些 surface 都该自动适配

错在漏掉：

- 这些 surface 实际消费的是 `remoteSessionUrl / remoteConnectionStatus / remoteBackgroundTaskCount`

### 误判四：direct connect / ssh remote 没复用这张账，只是 UI 还没做

错在漏掉：

- 生产这张账的就是 `useRemoteSession()` 这条 viewer path
- 启动路径和消费路径都把边界写死了

## 第十一层：stable / conditional / internal

### 稳定可见

- `remoteSessionUrl / remoteConnectionStatus / remoteBackgroundTaskCount` 当前就是 remote-session / assistant viewer 账本
- `useRemoteSession()` 当前是这张账的 producer
- footer、brief line、`/session` 当前都只消费这张账
- direct connect 当前只写 `directConnectServerUrl`
- `getIsRemoteMode()` 当前是全局 remote behavior flag，不是 presence ledger

### 条件公开

- 将来 direct connect / ssh remote 完全可以各自接一张 presence ledger，甚至与 remote-session ledger 对齐，但当前还没有这样做
- `getIsRemoteMode()` 的消费者很多，容易让人误以为它就是 presence 证明；这只是条件性误读，不是当前合同
- `/session` 命令显隐和 pane 内部语义分层，说明系统将来可能继续细分 remote 模式，而不是合并它们

### 内部 / 灰度层

- 当前仓内没有公开承诺说 remote-session ledger 永远只服务 `--remote`，但现在所有 producer / consumer 都沿这条边界排布
- direct connect / ssh remote 若将来要复用 ledger，势必需要新增 authority 字段与 consumer wiring，这不是现有合同的自然推论
- `getIsRemoteMode()` 的广泛使用会持续制造“remote mode = presence mode”的误读空间

## 第十二层：苏格拉底式自审

### 问：我现在写的是 remote interaction，还是 remote presence？

答：如果答不出来，就会把 `activeRemote` 和 `remoteSessionUrl` 写成一回事。

### 问：我是不是把 bootstrap display hint 偷换成了 authoritative ledger？

答：如果是，就会把 `directConnectServerUrl` 写过头。

### 问：我是不是因为 `getIsRemoteMode()` 被很多地方消费，就把它写成了 presence truth？

答：如果是，就忽略了 `/session`、footer、brief line 实际认的是哪张账。

### 问：我是不是又回到 138 的“共享交互壳”层，而没有真正回答“这张账为什么不通用”？

答：如果是，就还没真正进入 141。

### 问：我是不是把 direct connect / ssh remote 没复用这张账，自动理解为 UI backlog？

答：如果是，就没有尊重启动路径、producer 和 consumer 三端都已存在的产品边界。

## 源码锚点

- `claude-code-source-code/src/state/AppStateStore.ts`
- `claude-code-source-code/src/hooks/useRemoteSession.ts`
- `claude-code-source-code/src/main.tsx`
- `claude-code-source-code/src/bootstrap/state.ts`
- `claude-code-source-code/src/components/PromptInput/PromptInputFooterLeftSide.tsx`
- `claude-code-source-code/src/components/Spinner.tsx`
- `claude-code-source-code/src/commands/session/index.ts`
- `claude-code-source-code/src/commands/session/session.tsx`
