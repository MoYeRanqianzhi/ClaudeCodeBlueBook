# Remote Control headless startup `permanent error` 与 `transient retry` 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/48-Workspace not trusted、login token、HTTP base URL、worktree availability 与 registration failure：为什么 headless remote-control 的 permanent error 与 transient retry 不是同一种开桥失败.md`
- `05-控制面深挖/20-Headless 启动链、首问就绪与 StructuredIO：为什么 print 不是没有 UI 的 REPL.md`
- `05-控制面深挖/35-Workspace Trust、login、restart remote-control、fresh session fallback 与 retry：为什么 bridge 的补救动作不是同一种恢复建议.md`

## 1. 六类 startup failure / verdict 对象总表

| 对象 | 坏掉的是哪层 | headless worker 语义 | interactive standalone 语义 |
| --- | --- | --- | --- |
| `Workspace not trusted` | 目录 trust 前提 | `permanent` | 直接报错退出 |
| `BRIDGE_LOGIN_ERROR` | token / AuthManager 来源 | `transient` | 直接报错退出 |
| HTTP-only base URL | 传输安全前提 | `permanent` | 直接报错退出 |
| worktree unavailable | spawn substrate | `permanent` | 显式 worktree 时报错；saved pref 可 warning + fallback |
| registration failure | backend startup 阶段 | `transient` | 打印失败文案并退出 |
| session pre-creation failure | 初始会话 seed | `non-fatal continue` | 不适用 |
| supervisor park / backoff | worker retryability 契约 | 基于注释可推断 | interactive 不存在这一层 |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `Workspace not trusted` = `BRIDGE_LOGIN_ERROR` | 一个是目录前提，一个是 token source |
| HTTP-only base URL = registration failure | 一个是配置前提，一个是注册阶段失败 |
| worktree unavailable = saved worktree pref warning | 一个可能是 permanent / hard fail，一个只是 fallback |
| 本次命令失败 = worker 不该再试 | interactive 失败与 worker retryability verdict 不是同一层 |
| headless transient retry = continuity retry | 一个是 worker startup retry，一个是旧会话恢复 retry |
| registration failure = session pre-creation failed | 一个阻止起桥，一个只是初始会话 seed 失败 |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | `Workspace not trusted`、`BRIDGE_LOGIN_ERROR`、HTTP-only base URL 被拒绝、worktree mode unavailable、interactive 注册失败文案 |
| 条件公开 | saved worktree 偏好 fallback、multi-session gate denied、headless token / registration transient retry、session pre-create non-fatal continue、基于注释的 park / backoff 契约 |
| 内部/实现层 | `BridgeHeadlessPermanentError`、`AuthManager` IPC、bootstrap `chdir` / `initSinks`、exit code 细节 |

## 4. 六个高价值判断问题

- 这次坏掉的是 trust、token、URL 安全、worktree substrate，还是 registration？
- 当前宿主是 interactive host，还是 headless worker？
- 这类问题改配置之前会不会自己恢复？
- 当前是 warning + fallback、hard fail、permanent / transient，还是 non-fatal continue？
- 我是不是又把 page 35 的修复建议写成了 worker retryability？
- 我是不是又把本次命令失败和 worker 不该重试写成了同一个结论？

## 5. 源码锚点

- `claude-code-source-code/src/bridge/bridgeMain.ts`
- `claude-code-source-code/src/bridge/bridgeConfig.ts`
- `claude-code-source-code/src/utils/config.ts`
- `claude-code-source-code/src/utils/hooks.ts`
- `claude-code-source-code/src/utils/git.ts`
