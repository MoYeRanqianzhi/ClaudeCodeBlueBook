# local modal shell family 拆分记忆

## 本轮继续深入的核心判断

第 75 页已经拆开：

- imported remote ask
- exported local ask

但还有一个紧挨着的高频误判没有单独处理：

- 读者会把 REPL 里所有阻塞输入的东西
- 一起写成“同一个审批队列”

这一步必须继续下切到本地宿主层：

- shared blocking family
- shared modal shell
- divergent governance loops

否则 74/75 刚建立起来的拓扑区分，仍会在 REPL 宿主层重新被抹平。

## 为什么这轮要写本地容器族，而不是继续写更多 remote ask

前两批已经够清楚：

- 74 讲 remote session 的 approval shell vs authority
- 75 讲 remote / direct / ssh / bridge 的 topology direction

下一刀如果还继续 remote ask，会开始重复：

- ask origin
- return path
- bridge relay

而 Huygens 之前那条没落地的分析，正好指出 REPL 本地还有一层更容易混淆的对象：

- `toolUseConfirmQueue`
- `promptQueue`
- `sandboxPermissionRequestQueue`
- `workerSandboxPermissions.queue`
- `pendingWorkerRequest`
- `pendingSandboxRequest`
- `elicitation.queue`

这时顺势写本地容器族，比继续加 remote ask 边角页更值。

## 本轮最关键的新判断

### 判断一：这些对象首先共享的是宿主 waiting/focus 仲裁

`REPL.tsx` 把它们一起喂给：

- `isWaitingForApproval`
- `waitingFor`
- `hasActivePrompt`
- `focusedInputDialog`

这说明它们首先同属：

- host-level blocking family

### 判断二：但 `toolUseConfirmQueue` 是治理型容器，`promptQueue` 只是 prompt 协议容器

`ToolUseConfirm` 明确带：

- `onAllow`
- `onReject`
- `onAbort`
- `recheckPermission`

`promptQueue` 只是：

- `resolve`
- `reject`
- `PromptRequest`
- `PromptResponse`

前者带治理闭环，后者只是协议问答。这一刀必须单独写出来。

### 判断三：pending worker / sandbox 不该写成“另一种审批框”

`pendingWorkerRequest` 和 `pendingSandboxRequest` 只是 worker 侧 waiting indicator。

真正 leader 侧替 worker 决策的，是：

- `workerSandboxPermissions.queue`

而不是这些 pending 对象本身。

### 判断四：`PromptDialog` 与 `PermissionRequest` 共享壳，不共享协议

`PromptDialog` 复用 `PermissionDialog` 是关键证据：

- same shell
- different protocol

如果这一点不写，读者会继续把“同样看起来像审批框”误写成“同一 permission queue”。

### 判断五：同族容器连渲染槽位都不相同

`tool-permission` 走：

- overlay

很多其它容器走：

- bottom/modal

这点能进一步说明：

- 宿主家族统一
- 不等于运行位统一

## 苏格拉底式自审

### 问：为什么这轮不能只写一个短索引，不写长文？

答：因为这层不是单纯对象表，还需要解释：

- waiting family 为什么不等于 governance family
- shared shell 为什么不等于 shared protocol
- pending indicator 为什么不等于 decision container

这些都属于因果链，不只是速查表。

### 问：为什么要把 sandbox / worker / elicitation 一起拉进来？

答：因为如果只写 `toolUseConfirmQueue` 和 `promptQueue`，正文仍会留下两个盲区：

- network host ask
- server-driven elicitation

这两个盲区会让读者继续用“弹框家族总论”去错误吸纳它们。

### 问：为什么这轮还要补渲染槽位？

答：因为这是另一个经常被忽略的角度：

- 同族不等于同槽位

把 render lane 也拆出来，正文对“宿主统一、语义分裂”的论证会更稳。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/76-toolUseConfirmQueue、promptQueue、sandbox、worker、elicitation 与 focusedInputDialog：为什么 REPL 的本地阻塞容器不共享同一治理闭环.md`
- `bluebook/userbook/03-参考索引/02-能力边界/65-Local modal shell family、toolUseConfirmQueue、promptQueue 与 worker、sandbox、elicitation 容器索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/76-2026-04-06-local modal shell family 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 导航策略

这轮只做最小改动：

- 继续挂在 68-76 连续阅读链尾部
- 补一张对应能力边界索引

不去大改别的总目录，避免导航噪音超过正文增量。

## 下一轮候选

1. 单写 tmux worker mailbox ask 与 leader-side rewrap 共用本地审批壳的专题。
2. 压缩 72-76 为一张“tool plane / approval shell / local modal family”总索引。
3. 继续拆 REPL 的 waiting family 与 spinner / survey / background tasks 的互斥关系。
