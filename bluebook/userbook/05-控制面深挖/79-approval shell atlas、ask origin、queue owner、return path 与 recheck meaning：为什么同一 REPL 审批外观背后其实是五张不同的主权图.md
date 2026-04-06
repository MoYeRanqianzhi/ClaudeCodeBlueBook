# approval shell atlas、`ask origin`、`queue owner`、`return path` 与 `recheck meaning`：为什么同一 REPL 审批外观背后其实是五张不同的主权图

## 用户目标

不是只知道这几页已经分别讲过：

- remote session 的远端 `can_use_tool`
- direct connect / ssh / bridge 的 approval topology
- REPL 本地阻塞容器家族
- worker mailbox tool ask
- worker sandbox mailbox ask

而是继续追问一个更高一层的问题：

- 为什么这些对象在 UI 上都长得像“本地审批框”，但源码上其实落在五张不同的主权图里？
- 如果以后再碰到一个新的 approval shell，我应该优先问哪几个问题，才能不再误判？
- 74-78 这些页之间最核心的统一坐标系到底是什么？

如果这些问题不先统一，前面的五页虽然都成立，但读者仍然容易在脑中把它们重新压回一句错误总论：

- “凡是进了 REPL 的审批框，本质上都属于同一种本地权限系统。”

源码并不是这样工作的。

## 第一性原理

把所有 approval shell 压到同一坐标系里，最稳的不是问：

- “它是不是一个 `PermissionRequest`？”

而是四个更底层的问题：

1. `ask origin`：这条 ask 最初在哪一侧生成？
2. `queue owner`：它最终住进哪一类本地队列或等待态对象？
3. `return path`：用户答案回到哪里继续执行？
4. `recheck meaning`：本地 `recheckPermission()` 对它到底有没有真实治理意义？

只要这四轴先立住，后续就很难再把：

- local shell reuse

误写成：

- local authority ownership

## 第二层：五张主权图总表

| 图谱 | ask origin | queue owner | return path | `recheck` meaning |
| --- | --- | --- | --- | --- |
| remote session imported ask | 远端 container `can_use_tool` | 本地 `ToolUseConfirmQueue` 壳 | `RemoteSessionManager.respondToPermissionRequest(...)` | 无，本地只是壳 |
| remote/direct/ssh/bridge topology | 远端 ask 导入，或本地 ask 外发 | 取决于路径：remote 壳、本地 `ToolUseConfirm`、bridge relay | 回远端 manager，或回本地 `PermissionContext` 闭环 | 只有本地 ask / bridge relay 有真实意义 |
| local modal family | 各种本地 REPL 阻塞对象 | `toolUseConfirmQueue` / `promptQueue` / `sandboxPermissionRequestQueue` / `workerSandboxPermissions.queue` / `elicitation.queue` / pending states | 各自不同：permission、prompt、host promise、server-driven response | 只有治理型容器真实拥有重检语义 |
| worker mailbox tool ask | worker 本地 `PermissionContext` | leader 侧 `ToolUseConfirmQueue` rewrap + worker 侧 `pendingWorkerRequest` | mailbox 回 worker callback，再 `ctx.handleUserAllow(...)` | leader 侧无意义，worker 侧 continuation 才是真的 |
| worker sandbox host ask | worker 本地 sandbox runtime | leader 侧 `workerSandboxPermissions.queue` + worker 侧 `pendingSandboxRequest` | mailbox 回 worker sandbox callback，resolve 原 host promise | leader 侧没有同款 `recheckPermission()`；本地 worker callback 才是 continuation |

这张表的意义不是替代细节，而是先把：

- 所有“看起来像本地审批框”的对象

放回：

- 五张不同的 authority map

## 第三层：第一张图是“远端 ask 借本地 `ToolUseConfirm` 壳”

74 页给出的最核心结论是：

- `remote authority, local approval shell`

这张图里最关键的点是：

- ask 由远端发起
- 壳在本地 `toolUseConfirmQueue`
- `onUserInteraction()` / `recheckPermission()` 对 remote ask 是 no-op
- 最终答案回 `manager.respondToPermissionRequest(...)`

所以这张图必须记成：

- imported remote ask over local shell

而不是：

- local permission system owns the ask

## 第四层：第二张图拆的是 imported ask 与 exported ask 的大拓扑

75 页把这一层拆得更宽：

- remote session / direct connect / ssh session 都是 imported remote ask
- bridge 是 exported local ask with remote relay

这张图最关键的价值在于：

- 它把“都长得像本地审批框”的路径，先分成正向导入和反向外发两族

所以如果以后再见到一个新 approval shell，最该先问的不是：

- “它复用了哪个组件？”

而是：

- “这是 imported ask 还是 exported ask？”

## 第五层：第三张图回到单个 REPL 宿主，拆的是 modal family，不是 remote topology

76 页告诉我们：

- 即使都住在同一个 REPL 宿主里
- 也不能把所有阻塞式对象写成同一治理家族

它把对象拆成：

- `toolUseConfirmQueue`
- `promptQueue`
- `sandboxPermissionRequestQueue`
- `workerSandboxPermissions.queue`
- `elicitation.queue`
- `pendingWorkerRequest` / `pendingSandboxRequest`

所以第三张图回答的是：

- 同一个 host 里，谁是真正的治理型 queue，谁只是 prompt queue，谁只是 waiting indicator

它不是在讲 remote/container 主权，而是在讲：

- same host, divergent local container roles

## 第六层：第四张图是“worker-originated tool ask, leader-visible shell, worker-owned continuation”

77 页把 swarm 多进程的 tool permission 线补齐后，这张图就清楚了：

- ask 起点在 worker 的 `PermissionContext`
- worker 只保留 `pendingWorkerRequest` 和 callback
- leader 侧用 `useInboxPoller` 重包成带 `workerBadge` 的 `ToolUseConfirm`
- 用户答案经 mailbox 回到 worker callback
- continuation 真正在 worker 恢复

这张图最关键的误判纠正是：

- leader-visible `ToolUseConfirm` 不等于 leader-owned local ask

## 第七层：第五张图则是 host approval queue 版的 worker mailbox

78 页进一步告诉我们：

- worker sandbox ask 不是 leader 本地 `sandboxPermissionRequestQueue`
- 上报成功后，worker 只保留 `pendingSandboxRequest` 和 sandbox callback
- leader 侧排进的是 `workerSandboxPermissions.queue`
- 显示的是同款 `SandboxPermissionRequest` 壳
- mailbox response 回流 worker，worker resolve 原 host promise
- leader 还可能顺手更新自己本地 `domain:` 规则

所以这张图要记成：

- worker-originated host ask
- leader-visible host queue
- worker-owned host continuation

它和第四张图相似，但不能混成一张，因为：

- queue 类型不同
- continuation 类型不同
- leader 本地副作用也不同

## 第八层：五张图里最容易混掉的假等式

### 假等式一：进了本地 queue = 本地主权接管

错在漏掉：

- imported remote ask 仍然只是壳层借用

### 假等式二：同款 `PermissionRequest` / `SandboxPermissionRequest` = 同一个 ask owner

错在漏掉：

- 同款组件只证明 shell reuse，不证明 ask ownership 相同

### 假等式三：waiting indicator = decision container

错在漏掉：

- `pendingWorkerRequest`
- `pendingSandboxRequest`

都只是等待态，不是决策协议本体

### 假等式四：本地 `recheckPermission()` 到处都有治理意义

错在漏掉：

- remote imported ask
- worker mailbox rewrap

这些路径里的 leader-side shell 都没有同样的重检主权

### 假等式五：bridge / worker mailbox / remote session 只是 transport 不同

错在漏掉：

- ask origin
- queue owner
- continuation owner

都可能完全不同

## 第九层：如何用同一套问题快速判断新 approval shell

遇到新 shell 时，优先问：

1. ask 最初在哪边生成？
2. UI 壳住在哪个 queue / waiting object 里？
3. 本地有没有真实的 `recheck` / permission context 主权？
4. 用户答案最终回到哪边继续执行？
5. 当前看到的是 decision container，还是 waiting indicator？

只要这五问先跑一遍，绝大多数“长得像本地审批框”的对象都不会再被误判。

## 第十层：稳定、条件与内部边界

### 稳定可见

- approval shell 不能只按 UI 组件命名，而应该按 `ask origin / queue owner / return path / recheck meaning` 命名。
- 74-78 至少覆盖了五张互不相同的主权图。
- 同一 REPL 审批外观，不等于同一主权位置。

### 条件公开

- bridge relay、worker mailbox ask、worker sandbox ask 都依赖对应运行模式是否开启。
- mailbox 发送失败、tool 是否能识别、host rule 是否持久化，都会改变局部行为。
- 某些图里只复用壳，有些图里既复用壳又带本地副作用。

### 内部 / 实现层

- synthetic assistant / tool stub / workerBadge / callback registry / mailbox JSON。
- queue 去重、notification、lockfile、selectedIndex 等调度细节。
- 哪些具体组件挂 overlay、哪些挂 bottom，这些更适合作为支撑证据而非总图主轴。

## 第十一层：最稳的记忆法

先记一句总纲：

- `same approval shell does not imply same authority map`

再记四条轴：

- `ask origin`
- `queue owner`
- `return path`
- `recheck meaning`

只要这五句一起记住，74-78 这组页就不会再在脑中塌成一张模糊的“本地审批系统”。

## 源码锚点

- `claude-code-source-code/src/hooks/useRemoteSession.ts`
- `claude-code-source-code/src/remote/RemoteSessionManager.ts`
- `claude-code-source-code/src/hooks/useDirectConnect.ts`
- `claude-code-source-code/src/server/directConnectManager.ts`
- `claude-code-source-code/src/hooks/useSSHSession.ts`
- `claude-code-source-code/src/hooks/useCanUseTool.tsx`
- `claude-code-source-code/src/screens/REPL.tsx`
- `claude-code-source-code/src/hooks/toolPermission/handlers/swarmWorkerHandler.ts`
- `claude-code-source-code/src/hooks/useInboxPoller.ts`
- `claude-code-source-code/src/hooks/useSwarmPermissionPoller.ts`
- `claude-code-source-code/src/utils/swarm/permissionSync.ts`
