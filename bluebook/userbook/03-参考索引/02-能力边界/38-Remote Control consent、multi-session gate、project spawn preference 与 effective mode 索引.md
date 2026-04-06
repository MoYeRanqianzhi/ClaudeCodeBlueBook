# Remote Control consent、multi-session gate、project spawn preference 与 effective mode 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/49-remoteDialogSeen、multi-session gate、ProjectConfig.remoteControlSpawnMode 与 effective spawnMode：为什么 standalone remote-control 的一次性说明、账号资格、项目偏好与当前模式不是同一个默认.md`
- `05-控制面深挖/27-remote-control 命令、--remote-control、claude remote-control 与 Remote Callout：为什么 remote-control 的会内开桥、启动带桥与 standalone host 不是同一种入口.md`
- `05-控制面深挖/37-single-session、same-dir、worktree、capacity、create-session-in-dir 与 w：为什么 standalone remote-control 的 spawn topology、并发上限与前台 cwd 会话不是同一种调度.md`

## 1. 六类 consent / gate / preference / mode 对象总表

| 对象 | 回答的问题 | 典型例子 |
| --- | --- | --- |
| `One-time Consent` | 我是否已经看过 standalone remote-control 的一次性说明 | `remoteDialogSeen` |
| `Eligibility Gate` | 当前账号能不能进入 multi-session decision tree | `multiSessionEnabled`、gate denial |
| `Project Preference` | 这个项目此前记住了哪种 spawn 偏好 | `remoteControlSpawnMode` |
| `Preference Validation` | 这份偏好在当前目录还能不能兑现 | saved worktree pref fallback |
| `Preference Creation` | 当前是否需要首次生成 same-dir / worktree 偏好 | first-run chooser |
| `Effective Mode` | 本次真正生效的启动模式是什么 | `resume > flag > saved > gate_default` |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `remoteDialogSeen` = `remoteControlSpawnMode` | 一个记说明是否看过，一个记项目 spawn 偏好 |
| multi-session gate = 项目默认 mode | gate 只是决定你能不能进入 multi-session tree |
| saved worktree pref = 本次一定 worktree | preference 还要过 substrate 校验与 precedence |
| chooser 弹过 = effective mode 已确定 | chooser 只负责生成 project preference |
| gate default `same-dir` = 用户主动选了 same-dir | 一个是资格层默认，一个是显式 / 保存偏好 |
| 项目默认 worktree = resume 也该 worktree | resume 会强制收窄到 `single-session` |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | first-run standalone consent、multi-session gate denial、saved worktree pref warning + fallback、same-dir / worktree chooser、effective mode 的用户结果 |
| 条件公开 | `ProjectConfig.remoteControlSpawnMode`、gate on/off default、resume 优先级高于 saved pref |
| 内部/实现层 | `spawnModeSource`、analytics 事件名、flush logging 细节、TTY / readline 细节 |

## 4. 六个高价值判断问题

- 我现在看到的是 consent、eligibility、project preference，还是 final mode？
- 这层东西是在解释、筛选、记忆偏好，还是在真正签字当前模式？
- 当前项目偏好是不是已经被 substrate reality 或当前命令覆盖了？
- 现在的 `same-dir` 是用户选的、saved pref，还是 gate default？
- 我是不是又把 resume 写成了 host default？
- 我是不是又把多个 remembered state 混成了一个“remote-control 默认设置”？

## 5. 源码锚点

- `claude-code-source-code/src/bridge/bridgeMain.ts`
- `claude-code-source-code/src/utils/config.ts`
- `claude-code-source-code/src/components/RemoteCallout.tsx`
