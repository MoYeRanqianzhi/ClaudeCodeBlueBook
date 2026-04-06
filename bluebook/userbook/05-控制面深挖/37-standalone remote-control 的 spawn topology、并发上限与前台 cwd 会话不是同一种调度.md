# `single-session`、`same-dir`、`worktree`、`capacity`、`create-session-in-dir` 与 `w`：为什么 standalone remote-control 的 spawn topology、并发上限与前台 cwd 会话不是同一种调度

## 用户目标

不是只知道 Claude Code 里 `claude remote-control` 会谈 `same-dir`、`worktree`、`session`、`capacity`、`create-session-in-dir`，甚至运行中还能按 `w`，而是先分清六类不同对象：

- 哪些是在定义 standalone host 究竟是一条桥还是一台多会话宿主。
- 哪些是在定义新会话该落到当前目录还是隔离 worktree。
- 哪些是在定义同时允许挂多少条 active session。
- 哪些是在定义启动时要不要先留一个当前目录里的前台会话。
- 哪些只是 future session 的分配策略切换，而不是把已有会话搬家。
- 哪些在 resume 语义下会被强制收窄成 single-session。

如果这些对象不先拆开，读者最容易把下面这些东西压成同一种“spawn 设置”：

- `--spawn=session`
- `--spawn=same-dir`
- `--spawn=worktree`
- `--capacity`
- `--[no-]create-session-in-dir`
- first-run spawn mode choice
- 运行时 `w` toggle

## 第一性原理

standalone `claude remote-control` 的 host 调度至少沿着四条轴线分化：

1. `Host Topology`：这条 bridge 是一条会话即宿主，还是一个可持续接受多条会话的 server。
2. `Directory Allocation`：新会话是共享当前目录，还是为每条按需会话分配隔离 worktree。
3. `Session Budget`：系统允许同时保有多少条 active session。
4. `Foreground Anchor`：启动时是否先在当前 cwd 里留下一个可立即进入的前台会话。

因此更稳的提问不是：

- “这些不都是 remote-control 的 spawn mode 吗？”

而是：

- “这次改的是宿主拓扑、目录分配、并发槽位，还是启动时的前台锚点；源码因此决定影响未来新会话，还是影响当前整台 host 的生命周期？”

只要这四条轴线没先拆开，正文就会把 `single-session`、`same-dir`、`worktree`、`capacity` 与 `create-session-in-dir` 写成同一种设置。

## 第一层：`single-session`、`same-dir`、`worktree` 先定义的是 host topology

### `SpawnMode` 的正式对象不是“目录选项”，而是 host 如何承载会话

`types.ts` 对 `SpawnMode` 的定义写得很硬：

- `single-session`: one session in cwd, bridge tears down when it ends
- `worktree`: persistent server, every session gets an isolated git worktree
- `same-dir`: persistent server, every session shares cwd

这说明这里先回答的问题不是：

- 文件该写在哪个目录

而是：

- 这台 standalone remote-control host 是单会话即退场，还是多会话持续运行

### `single-session` 与另外两种模式的分水岭，是 host 会不会在会话完成后继续活着

`bridgeMain.ts` 在会话完成后的 lifecycle decision 里明确写出：

- multi-session mode：bridge 继续运行
- single-session mode：abort poll loop，bridge clean exit

因此更稳的理解应是：

- `single-session` 不是 “same-dir 的容量等于 1”
- 它是不同的 host lifecycle

只要这一层没拆开，正文就会把：

- 单会话宿主
- 多会话宿主

误写成只是“并发数不同”。

## 第二层：`same-dir` 与 `worktree` 才是在多会话宿主内部决定目录分配

### 它们都属于 persistent server，只是给新会话的目录政策不同

`bridgeMain.ts` 在真正 spawn 新会话时写得非常直接：

- `worktree` 模式下，按需新会话创建 isolated git worktree
- `same-dir` 与 `single-session` 模式下，session 共享 `config.dir`

这说明 `same-dir` 和 `worktree` 的共同前提是：

- 你已经在 multi-session host 里

真正被它们区分开的，是：

- 新会话共享当前目录
- 还是每条新会话拿到独立 worktree

### 因而它们不能被写成“会不会多会话”的开关

更准确的区分是：

- `single-session`：宿主拓扑
- `same-dir` / `worktree`：多会话宿主内部的目录分配策略

只要这一层没拆开，正文就会把：

- host topology
- directory allocation

压成同一种 “spawn mode 选择”。

## 第三层：`capacity` 改的是 active session budget，不是目录策略

### 源码只在 multi-session 模式下承认 `--capacity`

`parseArgs()` 里明确拒绝：

- `--capacity` 搭配 `--spawn=session`

并直接报：

- single-session mode has fixed capacity 1

这说明 `capacity` 先回答的问题不是：

- 用 worktree 还是 same-dir

而是：

- 这台多会话宿主最多同时挂几条 active session

### work loop 在 `activeSessions.size >= maxSessions` 时只是停止接新会话

`bridgeMain.ts` 的 work poll loop 里也写得很直接：

- at capacity 时不能 spawn new session
- 后续通过 capacity sleep / wake 节流

这说明 `capacity` 的对象不是：

- 创建几个 worktree
- 同时显示几个二维码

而是：

- session budget slot

### 因而 `capacity` 不应被偷写成“并发目录数”或“spawn mode 的别名”

更稳的理解是：

- `same-dir` / `worktree` 负责目录政策
- `capacity` 负责可并存会话数

## 第四层：`create-session-in-dir` 改的是前台 cwd 会话锚点，不是 spawn mode

### 启动时先留一个当前目录里的会话，是独立于 spawn mode 的另一层政策

`bridgeMain.ts` 把：

- `preCreateSession`

默认设为 `true`，并明确说明：

- 先在当前目录预创建一个 empty session
- 用户一启动就有地方可输入
- `--no-create-session-in-dir` 可以关闭

这说明 `create-session-in-dir` 解决的问题不是：

- 后续新会话落在 same-dir 还是 worktree

而是：

- 宿主启动时，要不要先保留一个当前 cwd 的前台锚点

### 即使在 worktree 模式下，这个初始会话也故意留在当前目录

同一段 spawn 逻辑里写得很清楚：

- worktree mode 下，按需新会话隔离到 worktree
- pre-created initial session 仍运行在 `config.dir`
- 目的是匹配用户从当前目录启动 host 的 first-session UX

因此更准确的理解应是：

- `worktree` 不等于 “所有会话都进 worktree”
- `create-session-in-dir` 允许在 worktree host 里仍保留一个 cwd anchor session

只要这一层没拆开，正文就会把：

- worktree host
- cwd 初始会话

写成互相矛盾。

## 第五层：运行时 `w` 改的是 future allocation policy，不会把已有会话迁走

### `w` 只在 multi-session 且 worktree 可选时出现

`bridgeMain.ts` 对 `toggleAvailable` 的条件写得非常硬：

- 当前不是 `single-session`
- `worktreeAvailable`

`bridgeUI.ts` 也只在有 `spawnModeDisplay` 时才显示：

- `w to toggle spawn mode`

这说明 `w` 不是一条通用全局热键，而是：

- 多会话宿主里、且 worktree 真可用时，允许切换 future spawn policy

### 它改的是 `config.spawnMode` 和持久化项目偏好，不会搬迁现有会话

`w` handler 只做了：

- `config.spawnMode = newMode`
- `logger.setSpawnModeDisplay(newMode)`
- `saveCurrentProjectConfig(...remoteControlSpawnMode...)`

它没有：

- 重建已有 session
- 把 same-dir 会话搬进 worktree
- 把 worktree 会话迁回 cwd

因此更稳的写法应是：

- `w` 切的是未来新会话的目录分配政策
- 不是当前活跃会话的迁移命令

## 第六层：resume 流会强制回到 `single-session`

### `--session-id` / `--continue` 与 spawn 相关 flags 互斥

`parseArgs()` 里明确规定：

- `--session-id` 和 `--continue` 不能与 `--spawn`、`--capacity`、`--create-session-in-dir` 同用

而 `bridgeMain.ts` 在决定 effective spawn mode 时也写得很直白：

- resuming via `--continue` / `--session-id`: always single-session

这说明 resume 回答的问题不是：

- 新会话以后如何分配

而是：

- 恢复某一个已知 session 在原目录 / 原环境上的连续性

### 因而 resume 不应被写成“multi-session host 的一种子模式”

更准确的区分是：

- spawn topology：为 future sessions 设计宿主
- resume flow：为 one specific session 恢复 continuity

只要这一层没拆开，正文就会把：

- host policy
- continuity recovery

再次揉成一层。

## 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `single-session` = `same-dir` 只是 capacity=1 | `single-session` 是不同的 host lifecycle |
| `worktree` = 所有会话都进 worktree | 初始 cwd 会话可以被 `create-session-in-dir` 保留下来 |
| `capacity` = 能创建几个 worktree | 它是 active session budget |
| `create-session-in-dir` = spawn mode 的另一种写法 | 它改的是前台 cwd 会话锚点 |
| `w` = 把现有会话从 same-dir 切到 worktree | 它只改变 future session 的分配策略 |
| resume = multi-session host 的一种子模式 | resume 强制收窄为 `single-session` |

## stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | `single-session`、`same-dir`、`worktree`、`capacity`、`create-session-in-dir`、运行时 `w` |
| 条件公开 | first-run spawn mode choice、saved worktree pref 回退、worktree mode 依赖 git repo 或 hooks |
| 内部/实现层 | at-capacity sleep / wake、worktree create timing、analytics / diagnostics 事件、poll interval 细节 |

## 源码锚点

- `claude-code-source-code/src/bridge/types.ts`
- `claude-code-source-code/src/bridge/bridgeMain.ts`
- `claude-code-source-code/src/bridge/bridgeUI.ts`
