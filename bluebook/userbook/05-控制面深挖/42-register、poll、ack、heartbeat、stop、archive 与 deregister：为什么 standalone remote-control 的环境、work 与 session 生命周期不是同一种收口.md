# `registerBridgeEnvironment`、`pollForWork`、`acknowledgeWork`、`heartbeatWork`、`stopWork`、`archiveSession` 与 `deregisterEnvironment`：为什么 standalone remote-control 的环境注册、work 租约、session 归档与环境销毁不是同一种生命周期操作

## 用户目标

不是只知道 standalone `claude remote-control` “启动后会连上、运行中会保活、退出时会清理”，而是先分清七类不同生命周期动作：

- 哪些是在创建 / 注册一个 bridge environment。
- 哪些是在已有 environment 上轮询并领取新的 work item。
- 哪些是在真正承诺“这条 work 由我来处理”。
- 哪些是在 work 处理中持续续租。
- 哪些是在告诉服务端这条 work 已经结束。
- 哪些是在把 session 从服务端 active surface 归档掉。
- 哪些是在把整个 environment 从服务端下线。

如果这些对象不先拆开，读者最容易把下面这些东西压成同一种“bridge 生命周期”：

- `registerBridgeEnvironment(...)`
- `pollForWork(...)`
- `acknowledgeWork(...)`
- `heartbeatWork(...)`
- `stopWork(...)`
- `archiveSession(...)`
- `deregisterEnvironment(...)`
- `reconnectSession(...)`

## 第一性原理

standalone remote-control 的生命周期动词至少沿着四条轴线分化：

1. `Lifecycle Object`：当前动作落在 environment、work item，还是 session record。
2. `Intent`：当前是在创建存在、领取任务、续租、停止执行、归档历史，还是销毁环境。
3. `Timing`：它发生在启动前、中途运行、会后收尾，还是异常恢复路径。
4. `Auth Plane`：它使用 environment credential、session token，还是 OAuth 路径。

因此更稳的提问不是：

- “bridge 现在是不是在做生命周期管理？”

而是：

- “它现在是在操作 environment、work，还是 session；是在声明存在、领取、续租、收尾，还是在做异常恢复？”

只要这四条轴线没先拆开，正文就会把所有 API 动词写成同一种“连接/断开”。

## 第一层：`registerBridgeEnvironment` 与 `pollForWork` 不是同一种启动动作

### `registerBridgeEnvironment` 解决的是“这台 host 先以什么 environment 存在”

`bridgeApi.ts` 里，`registerBridgeEnvironment(...)` 会创建并返回：

- `environment_id`
- `environment_secret`

`bridgeMain.ts` 也在进入 poll loop 之前先完成这一步。

这说明它回答的问题不是：

- 现在有没有具体 work 要做

而是：

- 这台 standalone host 先以哪个 environment 身份上线

### `pollForWork` 解决的则是“这个 environment 目前有没有新的 work item”

`types.ts` 与 `bridgeApi.ts` 都把 `pollForWork(...)` 写成：

- 用 `environmentId`
- 加 `environmentSecret`
- 在 `/work/poll` 上反复获取 `WorkResponse | null`

这说明 `pollForWork` 的对象已经从：

- environment 注册

切到了：

- 这个 environment 挂着的 work queue

### 所以“启动 bridge”至少分成两步

更准确的理解应是：

- register：把 host 先注册成一个 environment
- poll：在这个 environment 上持续轮询 work

只要这一层没拆开，正文就会把：

- “环境上线”
- “拿到第一条 work”

写成同一个启动动作。

## 第二层：`acknowledgeWork` 与 `heartbeatWork` 不是同一种 work 占有语义

### `acknowledgeWork` 是“我承诺接这条 work”，不是“我还活着”

`bridgeMain.ts` 在 decode work secret 之后专门定义：

- `ackWork()`

并明确注释：

- 只有在真正决定 handle 这条 work 后才 ack
- 不能过早 ack，否则 at-capacity 分支可能直接丢 work

这说明 ack 回答的问题不是：

- 这条 work 还在不在 lease 内

而是：

- 这条 work 现在由我正式接手

### `heartbeatWork` 是“这条已在处理中的 work 继续续租”

`types.ts` 把 `heartbeatWork(...)` 注释成：

- extending its lease

`bridgeMain.ts` 还会在 at-capacity 场景进入 heartbeat loop，只做：

- `heartbeatActiveWorkItems()`

而暂时不再 `pollForWork()`。

这说明 heartbeat 回答的问题是：

- 已经在跑的 work 还要不要继续保活

而不是：

- 我要不要第一次领取它

### 所以 ack 与 heartbeat 是 claim 和 lease 的区别

更准确的区分是：

- acknowledge：首次确认占有这条 work
- heartbeat：已占有 work 的续租信号

只要这一层没拆开，正文就会把：

- “我来处理它”
- “我还在处理它”

写成同一种保活。

## 第三层：`stopWork` 与 `archiveSession` 不是同一种收尾

### `stopWork` 解决的是 work item 结束，不是 session 展示面的归档

`types.ts` 直接写了：

- `stopWork` 通过 environments API 停止 work item

`bridgeMain.ts` 在 session 完成或 shutdown 时，也会优先确保：

- 服务端知道 work 已结束

甚至还为此写了：

- `stopWorkWithRetry(...)`

注释强调：

- 避免 server-side zombies

这说明 `stopWork` 解决的问题是：

- work lease / worker 执行单元要不要结束

而不是：

- session 在 web UI 里还显不显示

### `archiveSession` 解决的是 session record 不再继续以 active / idle 形式悬挂

`types.ts` 与 `bridgeApi.ts` 对 `archiveSession(...)` 写得很明确：

- archive a session so it no longer appears as active on the server
- 409 already archived 算 idempotent，不是错误

`bridgeMain.ts` 也把它描述成：

- 避免 session linger as stale in the web UI

因此 `archiveSession` 回答的问题是：

- 这条 session record 是否还应留在 active surface

而不是：

- 当前 work item 是否已经结束

### 所以“桥接结束了”至少包含两层不同收尾

更准确的区分是：

- `stopWork`：结束 work 执行单元
- `archiveSession`：归档 session 展示对象

只要这一层没拆开，正文就会把：

- worker 结束
- session 归档

写成同一种“断开”。

## 第四层：`deregisterEnvironment` 处理的是整个 environment 下线，不等于 stop / archive

### `deregisterEnvironment` 的对象是整个 bridge environment

`types.ts` 与 `bridgeApi.ts` 都把它写成：

- delete / deregister environment

`bridgeMain.ts` 在 shutdown 末尾还明确说明：

- deregister the environment so the web UI shows the bridge as offline

这说明它回答的问题不是：

- 某条 work 结束了没有
- 某条 session 归档了没有

而是：

- 整个 environment 还要不要继续存在

### 所以它必须发生在 stop / archive 之后

`bridgeMain.ts` 先：

- stop all active work
- 等待 pending cleanups
- archive all known sessions

最后才：

- `deregisterEnvironment(environmentId)`

这说明 environment 下线是最外层收口，而不是收尾动词的同义词。

## 第五层：`reconnectSession` 是恢复动词，不是正常生命周期里的 claim / lease / cleanup

### 它解决的是 stale worker 或 resume，不是常规执行流程

`types.ts` 把 `reconnectSession(...)` 注释成：

- force-stop stale worker instances
- re-queue a session on an environment

`bridgeMain.ts` 里它主要出现在：

- heartbeat auth failed
- `--session-id` resume / continue

这些都是异常恢复或接续路径。

### 所以不该把它写进“正常的一条 work 从开始到结束”的主线

更稳的理解应是：

- register / poll / ack / heartbeat / stop / archive / deregister
  这是主生命周期
- reconnect
  这是恢复性旁路

只要这一层没拆开，正文就会把：

- 正常领取执行
- 异常重排重连

写成同一个生命周期阶段。

## 第六层：single-session resume 进一步证明 archive / deregister 不是总要做

### 为了 `--continue`，single-session 会故意跳过 archive + deregister

`bridgeMain.ts` 在特定条件下会直接：

- 打印 resume 提示
- skip archive + deregister

原因写得很清楚：

- 否则 printed resume command would be a lie

这说明：

- archive / deregister 不是机械收尾
- 它们还受“是否保留 resumable environment/session”这个更高层策略影响

### 这再次证明“退出 bridge”不等于“把所有对象都删掉”

更准确的区分是：

- bridge 进程结束
- work item 结束
- session record 归档
- environment 下线

这四件事并不总是同一时刻发生。

## 第七层：稳定、条件与内部三层要分开保护

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | bridge 上线 / 离线、session 完成后的归档效果、single-session `--continue` 提示 |
| 条件公开 | at-capacity heartbeat mode、resume 时跳过 archive + deregister、`reconnectSession` 的恢复语义 |
| 内部/实现层 | `registerBridgeEnvironment`、`acknowledgeWork`、`heartbeatWork`、`stopWorkWithRetry`、`deregisterEnvironment` 的调用编排 |

这里尤其要避免两种写坏方式：

- 把内部 API 动词直接翻译成用户界面的单个按钮
- 把恢复路径的条件行为写成所有 bridge 都必然发生的稳定主线

## 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| register = poll | 一个让 environment 上线，一个在其上取 work |
| ack = heartbeat | 一个是首次 claim，一个是后续 lease keepalive |
| stopWork = archiveSession | 一个结束 work 执行单元，一个归档 session record |
| archiveSession = deregisterEnvironment | 一个收 session surface，一个让整个 environment 下线 |
| reconnectSession = 正常领取 work | 它是异常恢复 / resume 动词 |
| bridge 进程结束 = 一定 archive + deregister | single-session resume 会故意跳过 |
| 生命周期只有“连接”和“断开”两步 | 实际至少有 register、poll、ack、heartbeat、stop、archive、deregister 七层 |

## 六个高价值判断问题

- 当前动作落在 environment、work，还是 session？
- 当前是在注册存在、领取任务、续租、停止执行、归档历史，还是销毁环境？
- 这是主生命周期，还是恢复性旁路？
- 当前动作发生在启动、中途运行、会后收尾，还是异常恢复？
- 我是不是又把 `acknowledgeWork` 与 `heartbeatWork` 写成了同一种保活？
- 我是不是又把 `stopWork`、`archiveSession` 与 `deregisterEnvironment` 写成了同一种关闭？

## 源码锚点

- `claude-code-source-code/src/bridge/types.ts`
- `claude-code-source-code/src/bridge/bridgeApi.ts`
- `claude-code-source-code/src/bridge/bridgeMain.ts`
