# `--name`、`--permission-mode`、`--sandbox` 与 session title：为什么 standalone remote-control 的 host flags、session 默认策略与标题回填不是同一种继承

## 用户目标

不是只知道 `claude remote-control` 支持：

- `--name`
- `--permission-mode`
- `--sandbox`

并且远端 session 最后还会显示某个 title，而是先分清五类不同对象：

- 哪些是在给初始 session object 命名。
- 哪些是在给 host 创建出来的 session 默认权限策略。
- 哪些是在给 child CLI 进程施加执行约束。
- 哪些会被带进每条 spawned session。
- 哪些只是 title 的后续回填 / 覆盖链，而不是启动 flag 本身。

如果这些对象不先拆开，读者最容易把下面这些东西压成同一种“host setting”：

- `--name`
- `--permission-mode`
- `--sandbox`
- `createBridgeSession(... title, permissionMode ...)`
- `createSessionSpawner(... sandbox, permissionMode ...)`
- `fetchSessionTitle(...)`
- `deriveSessionTitle(...)`

## 第一性原理

standalone `claude remote-control` 的 host-level flags 至少沿着四条轴线分化：

1. `Session Object`：这个 flag 改的是会话对象在服务端如何创建、如何被命名、带什么默认策略。
2. `Child Runtime`：这个 flag 改的是被 spawn 出来的 CLI child 进程以什么执行约束启动。
3. `Scope of Inheritance`：它影响的是启动时预创建的初始 session、后续按需新会话，还是整个 host 的每个 child。
4. `Post-create Override`：这个字段是在创建时就定下来，还是可以被服务端 title / 首条用户消息补写或覆盖。

因此更稳的提问不是：

- “这些不都是 remote-control 的启动参数吗？”

而是：

- “这次 flag 改的是服务端 session object、child runtime，还是后续标题回填链；它影响的是初始 session，还是以后所有 spawned session？”

只要这四条轴线没先拆开，正文就会把 `--name`、`--permission-mode`、`--sandbox` 写成同一种 host setting。

## 第一层：`--name` 主要命名的是初始 session object，不是整台 host

### help 文案已经把它写成 session name，而不是 host name

`bridgeMain.ts` 的 help 明确写的是：

- `--name <name>                    Name for the session (shown in claude.ai/code)`

这说明它先回答的问题不是：

- 这台 standalone host 在终端里叫什么

而是：

- 启动时创建出来的 session object 在 claude.ai/code 里叫什么

### 预创建初始 session 时，`--name` 确实只被传到 `createBridgeSession(... title: name ...)`

`bridgeMain.ts` 在 pre-create initial session 的路径里，把：

- `title: name`

传进了 `createBridgeSession(...)`。

这意味着：

- `--name` 直接作用在 session create request
- 它首先命名的是启动时那个 initial session

### 但它不是 future sessions 的全局默认标题

后续按需会话的 spawn 流里，并没有再次把 host-level `name` 注入每条新 session。

相反，spawned session 的 title 走的是：

- 先看 server 已有 title
- 没有再从 first user message 派生

因此更稳的理解应是：

- `--name` 主要命名 initial session
- 不是一条 “以后所有 remote-control 会话都叫这个名字” 的 host-wide default

只要这一层没拆开，正文就会把 `--name` 写成整台 host 的 display name。

## 第二层：`--permission-mode` 是 session 默认权限策略，不是标题或宿主形态

### 它既进入 session create request，也进入 child CLI spawn args

`createBridgeSession.ts` 会把：

- `permission_mode`

写进 POST `/v1/sessions` 的 request body。

同时 `sessionRunner.ts` 在 spawn child CLI 时，也会把：

- `--permission-mode <mode>`

附加到 child args 上。

这说明 `--permission-mode` 同时作用在两层：

- 服务端 session object 的默认权限策略
- 本地 child runtime 的权限模式启动参数

### 因而它比 `--name` 更接近“每条 session 的默认策略”

更准确的区分是：

- `--name`：session title metadata
- `--permission-mode`：session permission default

它们都进入 session create，但改的不是同一种字段。

### 这也解释了为什么源码会先对 `permissionMode` 做早期校验

`bridgeMain.ts` 会在 bridge 开始 poll work 之前先验证：

- 当前 permission mode 是否属于合法值

这说明它被当成真正会影响所有 spawned sessions 的 host policy，而不是一个展示性字段。

## 第三层：`--sandbox` 改的是 child runtime 约束，不是 session metadata

### 它不会进入 `createBridgeSession()` 的 request body

和 `permissionMode` 不同，`createBridgeSession.ts` 的 request body 里没有 sandbox 字段。

它只携带：

- title
- permission_mode
- session_context

这说明 sandbox 并不属于服务端 session object 元数据。

### 它真正落到的是 child 进程环境

`sessionRunner.ts` 在 spawn child CLI 时，如果 host-level `sandbox` 为真，就注入：

- `CLAUDE_CODE_FORCE_SANDBOX=1`

因此更稳的理解应是：

- `--sandbox` 改的是每条 child session process 的执行约束
- 不是 claude.ai/code 那边看到的 session object 属性

### 所以它也不该和 `--permission-mode` 混写成同一种安全策略

更准确的区分是：

- `permission-mode`：审批 / 许可策略
- `sandbox`：执行约束 / 运行环境边界

只要这一层没拆开，正文就会把：

- 谁来批准
- 在哪里执行

压成同一种“权限设置”。

## 第四层：session title 还有独立的回填链，不等于 `--name`

### spawn 后会先去服务端拉一次 title

`bridgeMain.ts` 在 session attach 之后会执行：

- `fetchSessionTitle(...)`

并明确说明：

- 如果 server 上已经有 title
- 它可能来自 `--name`、web rename、或 `/remote-control`

这说明 title surface 的主语不是：

- 只有 CLI 启动参数

而是：

- session object 当前在服务端持久化着什么 title

### 如果服务端没 title，才会从 first user message 派生

同一份源码在 spawn child 时又提供了：

- `onFirstUserMessage`

它会：

- `deriveSessionTitle(text)`
- `logger.setSessionTitle(...)`
- `updateBridgeSessionTitle(...)`

这说明标题链的顺序是：

- server-set title 优先
- 没有时再从首条用户消息补写

### 因而 `--name`、server rename、first-user-message derived title 不是同一种命名动作

更稳的区分是：

- `--name`：启动时给 initial session 一个 title
- web rename / 其他 session-side title：服务端已存在 title
- first user message：缺 title 时的 fallback derivation

## 第五层：这些 flag 的作用域并不相同

### `--name` 更像 initial-session seed

从 `bridgeMain.ts` 的调用路径看：

- 初始 session create 会带 `title: name`

但后续 on-demand session 的标题主要靠服务端已有 title 或 first user message 回填。

所以 `--name` 的作用域并不是：

- host 里每一条未来 session

### `--permission-mode` 与 `--sandbox` 则更像 host-wide child defaults

它们被传给：

- `createSessionSpawner(...)`

因此后续 child spawn 都会继承：

- `--permission-mode`
- `CLAUDE_CODE_FORCE_SANDBOX`

这说明它们更接近：

- host-wide defaults for spawned sessions

### 所以三者不能被写成一组对等的“启动参数”

更准确的理解是：

- `name`：偏 session object seed
- `permission-mode`：偏 session default policy
- `sandbox`：偏 child runtime constraint

## 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `--name` = 这台 host 的名字 | 它首先命名的是 initial session object |
| `--name` = 以后所有新 session 的默认标题 | 后续会话还有 server title / first-user-message 回填链 |
| `--permission-mode` = `--sandbox` 的另一种写法 | 一个改审批策略，一个改执行约束 |
| sandbox = session metadata | sandbox 不进 create-session request body |
| title 回填 = `--name` 生效过程 | title 回填是独立的 post-create 链 |
| 这三者都是同一层 host setting | 它们分别落在 session object、child runtime、title fallback 上 |

## stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | `--name`、`--permission-mode`、`--sandbox`、session title 在远端显示、server title 优先于派生 title |
| 条件公开 | `--name` 主要影响 initial session、first-user-message fallback、headless 与 REPL 侧 title 来源不同 |
| 内部/实现层 | `titledSessions` 去重、`updateBridgeSessionTitle(...)` 的回写时机、debug log、env var 细节 |

## 源码锚点

- `claude-code-source-code/src/bridge/bridgeMain.ts`
- `claude-code-source-code/src/bridge/createSession.ts`
- `claude-code-source-code/src/bridge/sessionRunner.ts`
- `claude-code-source-code/src/bridge/bridgeUI.ts`
