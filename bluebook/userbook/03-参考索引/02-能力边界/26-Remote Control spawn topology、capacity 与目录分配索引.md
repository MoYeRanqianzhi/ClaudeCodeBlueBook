# Remote Control spawn topology、capacity 与目录分配索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/37-single-session、same-dir、worktree、capacity、create-session-in-dir 与 w：为什么 standalone remote-control 的 spawn topology、并发上限与前台 cwd 会话不是同一种调度.md`
- `05-控制面深挖/27-remote-control 命令、--remote-control、claude remote-control 与 Remote Callout：为什么 remote-control 的会内开桥、启动带桥与 standalone host 不是同一种入口.md`
- `05-控制面深挖/26-Connect URL、Session URL、Environment ID、Session ID 与 remoteSessionUrl：为什么 remote-control 的链接、二维码与 ID 不是同一种定位符.md`

## 1. 六类调度对象总表

| 对象 | 回答的问题 | 典型例子 |
| --- | --- | --- |
| `Host Topology` | 这台宿主是一条会话即退场，还是持续接受多会话 | `single-session` vs `same-dir/worktree` |
| `Directory Allocation` | 新会话共享 cwd 还是进入隔离 worktree | `same-dir` vs `worktree` |
| `Session Budget` | 同时允许挂多少条 active session | `--capacity` |
| `Foreground Anchor` | 启动时要不要先留一个 cwd 里的前台会话 | `--[no-]create-session-in-dir` |
| `Future Policy Toggle` | 以后新会话按哪种目录策略分配 | 运行时 `w` |
| `Resume Override` | 为恢复特定 session 而强制收窄的宿主形态 | `--continue` / `--session-id` -> `single-session` |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `single-session` = capacity 1 的 same-dir | 它是不同的 host lifecycle |
| `worktree` = 所有会话都在 worktree | 初始 cwd 会话可被保留下来 |
| `capacity` = 目录数 / worktree 数 | 它是 active session slot 上限 |
| `create-session-in-dir` = 另一种 spawn mode | 它改的是前台 cwd 锚点 |
| `w` = 迁移已有会话 | 它只切 future session policy |
| resume = multi-session host 的一种模式 | resume 会强制 single-session |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | `single-session`、`same-dir`、`worktree`、`capacity`、`create-session-in-dir`、`w` |
| 条件公开 | first-run spawn mode choice、saved pref 回退、worktree availability 前提 |
| 内部/实现层 | at-capacity 节流、create/remove worktree timing、poll interval 与 wake 细节 |

## 4. 六个高价值判断问题

- 现在改的是宿主拓扑、目录分配、并发槽位，还是启动时的前台锚点？
- 这条设置影响的是 future sessions，还是当前正在跑的会话？
- 当前 host 是 single-session 还是 multi-session？
- 这条设置是在说 cwd anchor，还是在说 on-demand session placement？
- 当前是 fresh host policy，还是 resume one specific session？
- 我是不是又把 spawn mode、capacity 与 create-session-in-dir 写成同一种调度？

## 5. 源码锚点

- `claude-code-source-code/src/bridge/types.ts`
- `claude-code-source-code/src/bridge/bridgeMain.ts`
- `claude-code-source-code/src/bridge/bridgeUI.ts`
