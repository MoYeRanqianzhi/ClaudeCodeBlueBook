# `Workspace not trusted`、`login token`、`HTTP base URL`、`worktree availability` 与 `registration failure`：为什么 headless remote-control 的 `permanent error` 与 `transient retry` 不是同一种开桥失败

## 用户目标

不是只知道 headless / daemon worker 里“有时提示工作区不可信、有时像没登录、有时说 HTTP 不允许、有时 worktree 不可用、有时又只是注册失败”，而是先分清六类不同对象：

- 哪些问题发生在 workspace trust 这种目录前提层。
- 哪些问题发生在 token / AuthManager 这种身份来源层。
- 哪些问题发生在 base URL / HTTPS 这种传输安全前提层。
- 哪些问题发生在 worktree substrate 这种宿主调度前提层。
- 哪些问题发生在真正向后端注册 bridge environment 的启动阶段。
- 哪些在 headless worker 语义里应该被判成 `permanent`、`transient`，哪些只是记一条日志后继续跑。

如果这些对象不先拆开，读者最容易把下面这些东西压成同一种“headless remote-control 开不了”：

- `Workspace not trusted`
- `BRIDGE_LOGIN_ERROR`
- `Remote Control base URL uses HTTP`
- `Worktree mode requires a git repository or WorktreeCreate hooks`
- `Bridge registration failed`
- `BridgeHeadlessPermanentError`
- “supervisor parks the worker”
- “backoff-retry”

## 第一性原理

headless remote-control 的启动失败至少沿着四条轴线分化：

1. `Broken Plane`：当前坏掉的是目录前提、身份来源、传输安全、spawn substrate，还是后端注册阶段。
2. `Host Contract`：当前宿主是 standalone interactive host 直接打印后退出，还是 headless worker 需要把 retryability verdict 交给上层 supervisor。
3. `Repair Scope`：当前应该接受 trust、补 token、改 URL、换 spawn mode / repo，还是只是等后端下一轮可用。
4. `Retryability Verdict`：当前失败在 worker 这一层应被判成 permanent park、transient retry，还是单纯 warning + fallback。

因此更稳的提问不是：

- “为什么这次 headless remote-control 又没起来？”

而是：

- “这次坏掉的是哪一层前提；interactive host 和 headless worker 分别怎样处理；worker 应该告诉 supervisor 永久停车，还是继续按 backoff 重试？”
- “这次坏掉的是哪一层前提；interactive host 和 headless worker 分别怎样处理；worker 应该告诉 supervisor 永久停车、继续 backoff，还是仅仅记错后继续运行？”

只要这四条轴线没先拆开，正文就会把 trust、login、HTTP-only、worktree 不可用与 registration failure 写成同一种 startup failure。

## 第二层：interactive host 与 headless worker 的失败合同本来就不同

### standalone `bridgeMain(...)` 遇到前置条件失败，会直接打印并退出

interactive standalone `claude remote-control` 在进入 poll loop 之前，会顺次做：

- multi-session gate 检查
- workspace trust 检查
- bridge token 检查
- base URL 的 HTTPS 检查
- worktree availability 检查
- registerBridgeEnvironment(...)

这些路径在 `bridgeMain.ts` 里几乎都走同一类动作：

- `console.error(...)`
- `process.exit(1)`

这说明 interactive host 回答的问题不是：

- 该不该把失败继续上抛给另一层 supervisor

而是：

- 当前命令本次能不能继续，不能就直接结束

### `runBridgeHeadless(...)` 的合同则是“把 retryability 交给上层”

`bridgeMain.ts` 给 `runBridgeHeadless(...)` 的注释写得很硬：

- 这是 `remoteControl` daemon worker 的 non-interactive bridge entrypoint
- 不走 TUI，不自己 `process.exit()`
- fatal errors 会抛出
- worker 再把 permanent vs transient 映射成正确 exit code

同一段注释还明确说：

- `BridgeHeadlessPermanentError` 用于 supervisor 不应重试的配置问题
- 这种情况下 supervisor 应 park worker，而不是 respawn on backoff
- 另一些启动期错误则只是记录为 non-fatal，worker 继续进入 `runBridgeLoop(...)`

这里有一层需要明确标注的边界：

- 当前源码里直接能看到的是 worker 侧注释与抛错契约
- “supervisor park / backoff”的更细实现并不在这组源码里展开

所以本页关于：

- permanent -> park
- transient -> retry

属于依据注释做的宿主契约推断，而不是来自 supervisor 具体实现文件的逐行复述。

## 第三层：`Workspace not trusted` 是 permanent preflight failure，不是 token 失败

### headless worker 把 trust 缺失直接判成 `BridgeHeadlessPermanentError`

`runBridgeHeadless(...)` 在完成 bootstrap state 与 config 初始化后，先做：

- `checkHasTrustDialogAccepted()`

未通过时抛出：

- `Workspace not trusted: ... Run \`claude\` in that directory first to accept the trust dialog.`

而且它抛出的不是普通 `Error`，而是：

- `BridgeHeadlessPermanentError`

这说明在 worker 语义里，这里回答的问题不是：

- AuthManager 下一轮会不会捞到 token
- 后端等会儿会不会恢复

而是：

- 这个目录的 trust 前提根本还没建立

### 这也和 page 23 / 35 的重点不同

更准确的区分是：

- page 23：trust、eligibility、trusted-device 不是同一把钥匙
- page 35：用户应该先跑 `claude` 还是 `/login`
- 本页：worker 为什么把 trust 缺失直接定性为 permanent startup failure

只要这一层没拆开，正文就会把：

- workspace plane
- token plane

压成同一种“重新登录试试”。

## 第四层：缺 `login token` 是 transient source failure，不是 permanent config failure

### worker 源码明确把“当前拿不到 token”写成可重试

`runBridgeHeadless(...)` 在 trust 之后立即检查：

- `opts.getAccessToken()`

如果当前拿不到 token，它抛出的不是 `BridgeHeadlessPermanentError`，而是普通：

- `Error(BRIDGE_LOGIN_ERROR)`

而源码旁注直接写着：

- `Transient — supervisor's AuthManager may pick up a token on next cycle.`

这说明 worker 在这里回答的问题不是：

- 用户永远没资格跑 bridge

而是：

- 这一轮 worker 还没拿到 token source，但上层 token provider 下一轮可能补上

### 所以 `/login` 在 worker 语义里是“可恢复来源”，不是永久断言

更准确的理解应是：

- trust 缺失：当前目录前提没建立，worker 不该继续白跑
- token 缺失：当前 source 暂时没供给到，worker 允许 supervisor 继续等

只要这一层没拆开，正文就会把：

- `Workspace not trusted`
- `BRIDGE_LOGIN_ERROR`

写成同一种 permanent 失败。

## 第五层：`HTTP base URL` 与 `worktree availability` 都是 permanent substrate failure

### 非 localhost 的 HTTP base URL 在 worker 里被直接判死

`runBridgeHeadless(...)` 对 base URL 做了明确检查：

- `http://`
- 且不是 `localhost`
- 且不是 `127.0.0.1`

满足时直接抛：

- `Remote Control base URL uses HTTP. Only HTTPS or localhost HTTP is allowed.`

而且同样是：

- `BridgeHeadlessPermanentError`

这说明这里坏掉的不是：

- token
- 后端短时不可用

而是：

- 当前 worker 配置出来的传输安全前提本身就不被接受

### `worktree` 模式没有 git / hooks 也属于 substrate 缺失

当：

- `opts.spawnMode === 'worktree'`

时，worker 还会检查：

- `hasWorktreeCreateHook() || findGitRoot(dir) !== null`

若都没有，则抛：

- `Worktree mode requires a git repository or WorktreeCreate hooks. Directory ... has neither.`

同样属于：

- `BridgeHeadlessPermanentError`

这说明这里回答的问题不是：

- 桥接服务端短期是否健康

而是：

- 当前宿主连选择的 spawn substrate 都不存在

### 因而 HTTP-only 与 worktree-unavailable 都不该写成“再试一次也许会好”

更准确的区分是：

- token / registration：可能等下一轮
- HTTP-only / worktree-unavailable：不改配置就不会自己变好

## 第六层：saved worktree 偏好、explicit worktree 与 headless worktree permanent 不是同一层反应

### interactive standalone 对 stale saved worktree pref 会 warning + fallback

`bridgeMain.ts` 在 interactive standalone path 里，如果发现：

- saved spawn mode 是 `worktree`
- 但当前目录已经不再支持 worktree

它不会直接报 fatal，而是：

- 打 warning
- 清掉保存的 `remoteControlSpawnMode`
- fallback 到 `same-dir`

### interactive explicit `--spawn=worktree` 则会 hard fail

同一份 interactive 代码里，如果最终有效 `spawnMode === 'worktree'`，但：

- `!worktreeAvailable`

则直接：

- `Error: Worktree mode requires a git repository or WorktreeCreate hooks configured.`
- `process.exit(1)`

### headless `worktree` 则更进一步，直接变成 permanent worker verdict

到了 `runBridgeHeadless(...)`，同样的 substrate 缺失会被进一步定性成：

- `BridgeHeadlessPermanentError`

所以更稳的理解应是：

- saved stale pref：warning + fallback
- explicit standalone worktree：本次命令 hard fail
- headless worktree：告诉 supervisor 这不是该继续 backoff 的问题

只要这一层没拆开，正文就会把：

- 用户偏好回退
- 当前命令失败
- worker permanent park

写成同一种 worktree error。

## 第七层：`registration failure` 是启动阶段失败，但在 worker 里被刻意留在 transient bucket

### headless worker 对 register 失败的注释是“让 supervisor backoff-retry”

`runBridgeHeadless(...)` 在完成 config / api / spawner 准备后，进入：

- `api.registerBridgeEnvironment(config)`

这里一旦失败，它抛的是普通：

- `Error: Bridge registration failed: ...`

旁注写得也很明确：

- `Transient — let supervisor backoff-retry.`

这说明在 worker 这一层，register 失败回答的问题不是：

- 永久配置不成立

而是：

- 当前还没注册成功，交给上层按 backoff 再试

### interactive standalone 对同一阶段则直接打印并退出

而在 interactive standalone path 里，同一个注册动作失败时，会：

- 记 `tengu_bridge_registration_failed`
- `console.error(...)`
- `process.exit(1)`

甚至对 `404` 还会直接打印：

- `Remote Control environments are not available for your account.`

这说明两条宿主路径在这里的设计重点不同：

- interactive：本次命令失败就结束，并尽量给出直接文案
- headless：把这一步保留在 transient startup bucket，让上层继续判定

### 所以 “用户看到本次失败了” 与 “worker 认为不应再试” 不是同一判断

更准确的区分是：

- 交互宿主：关心本次 CLI 命令能否继续
- headless worker：关心这次失败要不要交给 supervisor 再来一轮

只要这一层没拆开，正文就会把：

- 本次命令失败
- permanent worker failure

写成同一种 verdict。

## 第八层：`session pre-creation failed` 只是 non-fatal continue，不进入 permanent / transient verdict

### headless worker 允许“初始会话建不出来，但整台桥继续活着”

`runBridgeHeadless(...)` 在注册成功后，如果：

- `opts.createSessionOnStart`

会尝试：

- `createBridgeSession(...)`

但这段失败时并不会抛出，也不会终止 worker，而只是：

- `log('session pre-creation failed (non-fatal): ...')`

随后仍然继续：

- `runBridgeLoop(...)`

这说明源码在启动期实际划的是三桶，而不是两桶：

- `permanent`：不该继续拉起
- `transient`：交给 supervisor 再试
- `non-fatal continue`：记日志，但 bridge host 继续运行

### 所以“启动期报错”也不等于“worker 启动失败”

更准确的区分是：

- register 失败：worker 没有成功起桥，交给上层 retry
- session pre-create 失败：桥已经起来了，只是前台 seed session 没种出来

只要这一层没拆开，正文就会把：

- `Bridge registration failed`
- `session pre-creation failed (non-fatal)`

写成同一种 startup failure。

## 第九层：稳定、条件与内部三层要分开保护

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | `Workspace not trusted`、`BRIDGE_LOGIN_ERROR`、HTTP-only base URL 被拒绝、worktree mode unavailable、interactive 注册失败文案 |
| 条件公开 | saved worktree 偏好 warning + fallback、multi-session gate denied、headless worker 对 token / registration 走 transient retry bucket、session pre-create 的 non-fatal continue、基于注释可见的 park / backoff 契约 |
| 内部/实现层 | `BridgeHeadlessPermanentError` 类型名、`AuthManager` IPC 来源、bootstrap `chdir` / `initSinks` 细节、exit code 映射细节、trusted-device token plumbing |

这里尤其要避免两种写坏方式：

- 把所有 startup failure 写成一页“错误文案总表”
- 把 interactive `process.exit(1)` 与 headless `permanent/transient` verdict 写成同一种失败处理

## 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `Workspace not trusted` = `BRIDGE_LOGIN_ERROR` | 一个是目录前提，一个是 token source |
| HTTP-only base URL = registration failure | 一个是配置前提，一个是后端启动阶段失败 |
| worktree unavailable = saved worktree pref warning | 一个可能是 hard fail / permanent，另一个只是 fallback |
| 本次命令报错了 = worker 不该再试 | interactive 失败与 headless retryability verdict 不是同一层 |
| headless transient retry = page 35 的 retry same command | 一个是 worker startup retry，一个是 continuity retry |
| `Bridge registration failed` = `session pre-creation failed (non-fatal)` | 一个阻止起桥，另一个只阻止初始会话 seed |
| `BridgeHeadlessPermanentError` = 用户直接可见能力名 | 它只是内部类型，用来表达 non-retry startup verdict |

## 六个高价值判断问题

- 当前坏掉的是 trust、token、transport safety、spawn substrate，还是 registration 阶段？
- 当前宿主是 interactive host，还是需要把 verdict 上交给 supervisor 的 headless worker？
- 这个问题不改配置会不会自己变好？
- 这是 warning + fallback、hard fail、permanent / transient，还是 non-fatal continue？
- 我是不是又把 page 35 的“用户修复建议”写成了 worker retryability？
- 我是不是又把本次命令失败和 worker 不该重试写成了同一个结论？

## 源码锚点

- `claude-code-source-code/src/bridge/bridgeMain.ts`
- `claude-code-source-code/src/bridge/bridgeConfig.ts`
- `claude-code-source-code/src/utils/config.ts`
- `claude-code-source-code/src/utils/hooks.ts`
- `claude-code-source-code/src/utils/git.ts`
