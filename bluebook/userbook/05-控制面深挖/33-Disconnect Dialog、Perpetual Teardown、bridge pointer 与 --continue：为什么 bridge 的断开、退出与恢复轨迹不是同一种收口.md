# `Disconnect Dialog`、`Perpetual Teardown`、`bridge pointer` 与 `--continue`：为什么 bridge 的断开、退出与恢复轨迹不是同一种收口

## 用户目标

不是只知道 Claude Code 里“Bridge Dialog 里能 `Disconnect this session`、退出 CLI 以后有时还能继续、有时 pointer 又被清掉、`claude remote-control --continue` 偶尔还能找回上一条 bridge”，而是先分清五类不同对象：

- 哪些是在当前会话里显式选择断开。
- 哪些只是关闭当前 UI / 进程，但远端 session 还被故意留活。
- 哪些 closeout 会清掉 crash-recovery pointer。
- 哪些 closeout 会保留或刷新 pointer。
- 下次恢复到底该从哪个入口回来。

如果这些对象不先拆开，读者最容易把下面这些东西压成同一种“结束 bridge”：

- Disconnect Dialog 的 `Disconnect this session`
- Disconnect Dialog 的 `Continue`
- `useReplBridge` 的 hook cleanup
- non-perpetual teardown
- perpetual teardown
- `clearBridgePointer(...)`
- `writeBridgePointer(...)`
- `claude remote-control --continue`

## 第一性原理

bridge 的“收口”至少沿着四条轴线分化：

1. `Closeout Initiator`：这次收口是用户显式断开、当前进程退出，还是下一次启动时主动决定清掉旧轨迹。
2. `Remote Asset Fate`：远端 session / environment / work item 是被正式收尾，还是被故意留活。
3. `Recovery Artifact Fate`：bridge pointer 是被清掉、被刷新，还是被继续沿用。
4. `Resume Entry`：下次恢复要走普通新开、`--session-id`，还是 `remote-control --continue`。

因此更稳的提问不是：

- “bridge 结束时不都是 teardown 吗？”

而是：

- “这次是谁触发收口；远端资产有没有被正式关掉；pointer 是被清掉还是保留；下次又该从哪条恢复轨迹回来？”

只要这四条轴线没先拆开，正文就会把 disconnect、clean exit、perpetual continuity 与 `--continue` 写成同一种收口。

## 第一层：Disconnect Dialog 的 `Continue` 不是“再开一次 bridge”，而是“什么都别动”

### Disconnect Dialog 的对象是“当前已经存在的 bridge 要不要继续保留”

`commands/bridge/bridge.tsx` 里，当前已经：

- `replBridgeConnected || replBridgeEnabled`

且不是 outbound-only 时，会进入：

- `BridgeDisconnectDialog`

这说明这个 dialog 解决的问题不是：

- “要不要重新开一个 bridge”

而是：

- “当前已经存在的这一条 bridge 是断开，还是继续保留”

### 这里的 `Continue` 只是 dismiss，不是重新连接

同一个 dialog 里：

- `handleContinue()` 只是 `onDone(undefined, { display: 'skip' })`

这说明它的语义不是：

- 重新初始化 bridge
- 再做一次 connect

而是：

- 保持现状，退出当前 dialog

### 所以 Disconnect Dialog 先天就不是“开/关”二元按钮

更稳的区分是：

- `Disconnect this session`：当前会话 stop
- `Continue`：保持当前 bridge 原样继续跑

只要这一层没拆开，正文就会把 dialog 写成：

- 一个带确认框的开关

## 第二层：手动 disconnect 走的是当前会话 stop，再链到 non-perpetual teardown

### `/remote-control` 的 disconnect 先改当前会话状态

`commands/bridge/bridge.tsx` 的 disconnect handler 会直接重写：

- `replBridgeEnabled = false`
- `replBridgeExplicit = false`
- `replBridgeOutboundOnly = false`

并返回：

- `Remote Control disconnected.`

这说明它首先回答的问题是：

- “当前这一条 session 的 bridge 现在停不停”

### `replBridgeEnabled=false` 会触发 hook cleanup，再进入真正的 teardown

`useReplBridge.tsx` 的 effect cleanup 会在 `handleRef.current` 存在时：

- 调 `handleRef.current.teardown()`
- 清掉当前 `AppState` 里的 bridge runtime surface

这说明 `/remote-control` 的 disconnect 不是：

- 单独完成全部收口

而是：

- 先把当前会话切到 stop
- 再由 hook cleanup 把真正的 runtime teardown 跑完

### non-perpetual teardown 的对象是“这条 bridge 真的结束了”

`replBridge.ts` 的 non-perpetual teardown 会：

- 发送 result message
- `stopWork(...)`
- `archiveSession(...)`
- 关闭 transport
- `deregisterEnvironment(...)`
- `clearBridgePointer(dir)`

这说明 non-perpetual 收口的真实心智是：

- 当前 bridge 结束
- 远端资产正式收尾
- 本地 crash-recovery 轨迹也一起清掉

## 第三层：hook cleanup 与 explicit disconnect 共享 teardown，但不必共享同一种语义

### hook cleanup 是本地 runtime 层的统一出口

`useReplBridge.tsx` 的 cleanup 不只发生在显式 disconnect。

它也会在：

- effect 被取消
- 当前进程退出
- bridge handle 需要清理时

统一调用：

- `handle.teardown()`

因此它更像：

- local runtime teardown gateway

而不是：

- 某一种单独的用户动作

### 同样是 cleanup，后续轨迹仍由 `teardown()` 内部模式决定

真正决定 closeout 轨迹的不是 cleanup 这个入口本身，而是：

- 当前是不是 perpetual
- teardown 内部到底是清 pointer，还是刷新 pointer 并留活远端 session

这说明更稳的写法应是：

- cleanup 是入口
- closeout 语义要看 teardown 分支

而不能写成：

- 只要进 cleanup，收口语义就完全一样

## 第四层：perpetual teardown 是 local-only closeout，不是“普通退出但以后再连”

### perpetual teardown 故意不做远端正式收尾

`replBridge.ts` 里，perpetual 分支写得很硬：

- 不发 result
- 不 `stopWork`
- 不关 transport 去告诉服务器“要结束了”
- 只做本地 teardown
- 刷新 pointer

这说明 perpetual 回答的问题不是：

- “怎么更优雅地把这条 bridge 关掉”

而是：

- “怎么让本地进程退出，但把远端 session continuity 留着”

### 它留下的是 continuity，不是普通 clean shutdown 的尾巴

同一段注释已经说透：

- 下次 daemon 启动时，通过 pointer + `reconnectSession` 继续

因此更准确的理解应是：

- non-perpetual teardown：结束这条 bridge，并清除恢复轨迹
- perpetual teardown：结束本地进程占用，但故意保留恢复轨迹和远端 continuity

### 所以 perpetual teardown 不应被写成“另一种 disconnect”

只要这一层没拆开，正文就会把：

- 当前会话 stop
- local-only closeout
- continuity preserve

重新压成同一种“退出”。

### 它与 `remote-control --continue` 也不是同一套 prior-state 读取

`replBridge.ts` 的 perpetual init 只会复用：

- `source: 'repl'`

的 prior pointer。

而 root command 侧的 `remote-control --continue` 则先读取：

- 最近期的 bridge pointer

再进入 server 校验链。

因此更稳的区分是：

- perpetual：复用 REPL continuity 专用轨迹
- `remote-control --continue`：消费统一 bridge pointer 恢复入口

## 第五层：`bridge pointer` 是恢复轨迹资产，不是单纯的 session ID 文件

### REPL bridge 在 session 创建后就会写 pointer

`replBridge.ts` 在 session 创建完成后就立即：

- `writeBridgePointer(dir, { sessionId, environmentId, source: 'repl' })`

注释也明确写出：

- 这是 crash-recovery pointer
- kill -9 之后仍留下 recoverable trail

这说明 pointer 的对象不是：

- 只有在 `--continue` 才临时生成的 resume token

而是：

- bridge 生命周期里持续维护的恢复轨迹资产

### non-perpetual clean teardown 会清掉它，perpetual 会刷新并保留

同一个文件里：

- non-perpetual teardown 最后 `clearBridgePointer(dir)`
- perpetual teardown 则 `writeBridgePointer(...)` 刷新 mtime

这说明 pointer 的 fate 本身就是 closeout 语义的一部分：

- clean closeout：清除轨迹
- perpetual closeout：保留轨迹

### fresh start without `--continue` 还会主动清 stale pointer

`bridgeMain.ts` 在没有 `resumeSessionId` 时，会先：

- `clearBridgePointer(dir)`

注释直接写出：

- leftover pointer 表示上一次没有 clean shutdown
- fresh start 应把它清掉

这说明 pointer 不只在 teardown 里会被处理，连下一次启动时也会继续参与 closeout 语义。

## 第六层：`claude remote-control --continue` 读取的是 bridge pointer 恢复轨迹，不是 generic continue

### `--continue` 先从当前目录及 worktrees 找 freshest pointer

`bridgeMain.ts` 里：

- `--continue` 会调用 `readBridgePointerAcrossWorktrees(dir)`
- 先看当前目录
- 再 fan out 到 worktree siblings
- 找 freshest pointer

这说明它回答的问题不是：

- “最近一条普通 Claude 对话是什么”

而是：

- “最近一条 bridge crash-recovery / continuity 轨迹是什么”

### deterministic failure 时，还会清掉“正确的那份 pointer”

同一条 `--continue` 流里，如果：

- session 不存在
- 没有 `environment_id`
- fatal reconnect failure

代码会针对：

- `resumePointerDir`

去 `clearBridgePointer(...)`。

这说明 `--continue` 不只是消费 pointer，它还负责在确定无效时把错误轨迹清理掉。

### 因而 `--continue` 与 fresh start 是相反的两种 pointer policy

更稳的区分是：

- fresh start without `--continue`：主动清 leftover pointer
- `remote-control --continue`：主动读取 pointer，并在确定无效时清掉它

## 第七层：稳定主线、条件面与内部面要继续保护

### 稳定可见或相对稳定可见的

- Disconnect Dialog 的 `Continue` 只是保持当前桥不变
- explicit disconnect 会走当前会话 stop，再链到 teardown
- perpetual teardown 是 local-only closeout，会保留 continuity
- pointer 会在不同 closeout 路径下被清掉或保留
- `remote-control --continue` 读取的是 bridge pointer 轨迹

这些都适合进入 reader-facing 正文。

### 条件公开或应降权写入边界说明的

- pointer 只在特定模式与入口下读写
- `--continue` 的 worktree-aware fanout
- fatal 与 transient reconnect 失败对 pointer 的清理规则不同
- standalone 与 repl pointer 的 `source` 差异

### 更应留在实现边界说明的

- pointer JSON 结构本身
- TTL / mtime 的具体数字
- worktree fanout 上限
- transport close 顺序和 POST drain 细枝末节

这些内容只保留为作者判断依据，不回流正文主线。

## 最后的判断公式

当你看到 disconnect、退出 CLI、perpetual continuity 或 `remote-control --continue` 时，先问七个问题：

1. 这次收口是谁触发的，是显式断开、进程退出，还是下一次启动的清理决策？
2. 当前只是停掉本地 bridge，还是远端 session / env 也被正式收尾了？
3. pointer 这次是被清掉、被刷新，还是被下一次启动读取？
4. 当前是 non-perpetual teardown，还是 perpetual local-only closeout？
5. Disconnect Dialog 的 `Continue` 是重新连接，还是保持现状？
6. 这次恢复要走 fresh start、`--session-id`，还是 `remote-control --continue`？
7. 我是不是又把 disconnect、clean exit、perpetual teardown 与 pointer recovery 压成了同一种收口？

只要这七问先答清，就不会把 bridge 的断开、退出与恢复轨迹写糊。

## 源码锚点

- `claude-code-source-code/src/commands/bridge/bridge.tsx`
- `claude-code-source-code/src/hooks/useReplBridge.tsx`
- `claude-code-source-code/src/bridge/replBridge.ts`
- `claude-code-source-code/src/bridge/bridgePointer.ts`
- `claude-code-source-code/src/bridge/bridgeMain.ts`
