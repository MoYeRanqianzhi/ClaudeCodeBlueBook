# remote approval topology 拆分记忆

## 本轮继续深入的核心判断

第 74 页已经拆开：

- remote session 的远端 ask 只是借本地审批壳
- 不等于本地权限治理链接管

但如果继续只盯 remote session 单路径，正文仍会漏掉一个更大的误判：

- 读者会把 remote session、direct connect、ssh session、bridge
- 一起写成“都会在本地弹审批框，所以都差不多”

这一步必须再拆一层：

- imported remote ask
- exported local ask

否则就会把：

- topology difference

误写成：

- UI family sameness

## 为什么这轮先写 topology，而不是先写 prompt 容器族长文

Huygens 的容器族分析很有价值，它指出：

- `toolUseConfirmQueue`
- `promptQueue`
- `pendingWorkerRequest`

都属于 REPL 里的阻塞式输入/审批容器族，但来源、动作和治理闭环不同。

这条线值得后写，但不该先写，原因有三：

1. 当前连续页 72-74 还在 remote session / approval shell 这条主线上，先补 topology 对照更顺。
2. prompt 容器族专题一旦写太早，容易把 74 页刚拆开的“remote ask 借壳”重新混回本地 modal 家族总论。
3. Sagan 也提醒：stub、no-op、`setImmediate` 扫队列这类事实更适合做证据，不该被误写成稳定产品合同。

所以本轮的更稳切法是：

- 先写 75：四条 approval topology 的方向差
- 后续再择机写 76：shared local modal shell, divergent governance loops

## 本轮最关键的新判断

### 判断一：remote session、direct connect、ssh session 属于同一 imported remote ask family

三条线都在本地：

- `createToolStub(...)`
- `createSyntheticAssistantMessage(...)`
- 构造 `ToolUseConfirm`
- 入 `toolUseConfirmQueue`

因此它们共享的是：

- local approval shell

### 判断二：bridge 的方向正好反过来

bridge 的 ask 先在：

- `useCanUseTool(...)`
- `handleInteractivePermission(...)`

里生成，再由：

- `bridgeCallbacks.sendRequest(...)`

外发给远端参与竞速。

这说明 bridge 不是：

- imported remote ask

而是：

- exported local ask

### 判断三：`recheckPermission()` 是方向差的硬证据

imported remote ask：

- `recheckPermission()` 没有本地治理意义

exported local ask：

- `recheckPermission()` 会重新跑本地 `hasPermissionsToUseTool(...)`
- 本地赢了还会 `cancelRequest(...)` 取消 bridge 远端 prompt

这说明两类 ask 的主权方向正好相反。

## 苏格拉底式自审

### 问：为什么这轮不能只补 direct connect / ssh 的一个小注脚？

答：因为真正新增的不是 direct connect / ssh 的细节，而是：

- ask origin
- shell reuse
- authority return path
- recheck meaning

这是一张拓扑表，不是某一条线的注释。

### 问：为什么 bridge 必须一起写？

答：因为如果不把 bridge 拉进来，读者仍会默认：

- “所有审批框都是远端 ask 进本地”

只有把 bridge 这个反向拓扑摆进来，正文才能真正建立：

- imported remote ask vs exported local ask

这组心智模型。

### 问：为什么 prompt 容器族暂不直接正文展开？

答：因为那条线更像：

- local modal shell taxonomy

而这一轮需要优先解决的是：

- approval topology direction

两者不一样。先后顺序如果反了，正文又会重新混层。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/75-useRemoteSession、useDirectConnect、useSSHSession、handleInteractivePermission 与 bridgeCallbacks：为什么 remote session、direct connect、ssh session 都会借本地审批壳，而 bridge 只是把本地 permission prompt 外发竞速.md`
- `bluebook/userbook/03-参考索引/02-能力边界/64-Remote approval shell topology：remote session、direct connect、ssh session 与 bridge relay 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/75-2026-04-06-remote approval topology 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 目录优化判断

Maxwell 的建议是对的：

- 68-75 已经形成连续阅读组

因此本轮顺手补：

- 05 README 的连续阅读提示
- 00 阅读路径对 75 的挂接

而不急着另起一张更泛的 remote 总索引。

## 下一轮候选

1. 写 `toolUseConfirmQueue` / `promptQueue` / `pendingWorkerRequest` 的本地容器族专题。
2. 把 68-75 再压出一张只讲“对象、入口、区别、去哪篇看”的短索引。
3. 进一步补 remote session 与 tmux worker mailbox ask 共用本地审批壳的对照页。

当前最稳的顺序仍是：

- 先把 remote approval topology 固定下来
- 再写本地容器族
