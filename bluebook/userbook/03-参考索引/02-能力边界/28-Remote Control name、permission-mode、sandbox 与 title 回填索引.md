# Remote Control `name`、`permission-mode`、`sandbox` 与 title 回填索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/39-name、permission-mode、sandbox 与 session title：为什么 standalone remote-control 的 host flags、session 默认策略与标题回填不是同一种继承.md`
- `05-控制面深挖/37-single-session、same-dir、worktree、capacity、create-session-in-dir 与 w：为什么 standalone remote-control 的 spawn topology、并发上限与前台 cwd 会话不是同一种调度.md`
- `05-控制面深挖/38-Bridge Banner、QR、footer、session count 与 session list：为什么 standalone remote-control 的 banner、状态行与会话列表不是同一种显示面.md`

## 1. 五类继承对象总表

| 对象 | 回答的问题 | 典型例子 |
| --- | --- | --- |
| `Initial Session Seed` | 启动时预创建的 session 叫什么 | `--name` |
| `Session Default Policy` | 新建 session 带什么默认权限模式 | `--permission-mode` |
| `Child Runtime Constraint` | spawned child 以什么执行约束启动 | `--sandbox` |
| `Server Title` | 服务端当前已经保存了什么标题 | web rename、已有 title |
| `Fallback Title Derivation` | 没有 title 时怎样补写 | first user message |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `--name` = host 名字 | 它主要命名 initial session object |
| `--name` = future session 默认标题 | 后续会话还有 server / first-message 回填链 |
| `permission-mode` = `sandbox` | 一个改审批策略，一个改执行约束 |
| sandbox = session metadata | sandbox 不进 create-session request body |
| title 回填 = `--name` 生效流程 | 它是独立的 post-create 链 |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | `--name`、`--permission-mode`、`--sandbox`、远端 title 显示 |
| 条件公开 | initial session only、server title 优先、first-message fallback |
| 内部/实现层 | `titledSessions`、title 回写 timing、env var 注入细节 |

## 4. 六个高价值判断问题

- 当前 flag 改的是 session object、child runtime，还是 title fallback？
- 这条设置影响的是 initial session，还是后续所有 spawned sessions？
- 这是审批策略，还是执行约束？
- 当前 title 来自 CLI 启动参数、服务端已有值，还是首条用户消息？
- 我是不是把 `--name` 写成了 host 级 display name？
- 我是不是又把 `permission-mode` 和 `sandbox` 写成同一种安全策略？

## 5. 源码锚点

- `claude-code-source-code/src/bridge/bridgeMain.ts`
- `claude-code-source-code/src/bridge/createSession.ts`
- `claude-code-source-code/src/bridge/sessionRunner.ts`
- `claude-code-source-code/src/bridge/bridgeUI.ts`
