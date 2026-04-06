# `worker epoch`、state restore、worker heartbeat、`keep_alive` 与 `self-exit`：为什么 CCR v2 worker 的初始化、保活与代际退场不是同一种存活合同

## 用户目标

不是只知道 CCR v2 worker 里“有 epoch、有 `/worker`、会 heartbeat、还会发 `keep_alive`，偶尔又自己退出”，而是先分清六类不同对象：

- 哪些是在 worker 刚启动时向服务端登记“我是哪一代 worker”。
- 哪些是在登记同时把上一代留下的外部状态读回来。
- 哪些是在 worker 存活期间定期向服务端证明“我还活着”。
- 哪些是在空闲时向 session-ingress 维持链路不被代理层回收。
- 哪些是在检测到 epoch 被新代 supersede 时主动自退。
- 哪些是在 token 过期或 auth failure 持续耗尽后，宁可自退也不继续假活。

如果这些对象不先拆开，读者最容易把下面这些东西压成同一种“CCR v2 worker 还活着”：

- `initialize()`
- `PUT /worker`
- `GET /worker`
- `workerEpoch`
- `POST /worker/heartbeat`
- `keep_alive`
- `state_restored`
- `epoch mismatch`
- token expired with no refresh
- auth failures exhausted

## 第一性原理

CCR v2 worker 的“还在工作”至少沿着四条轴线分化：

1. `Generation Claim`：当前这代 worker 有没有先向服务端登记自己是合法写入者。
2. `State Continuity`：当前 worker 启动时有没有成功读回上一代留下的外部状态。
3. `Liveness Channel`：当前保活打在 worker API heartbeat，还是打在 session-ingress `keep_alive`。
4. `Exit Verdict`：当前退出是因为被新 epoch 取代、auth 已不可信，还是只是在某次请求上暂时失败。

因此更稳的提问不是：

- “CCR v2 worker 不是已经初始化并在发 heartbeat 了吗？”

而是：

- “它现在是在登记代际、恢复旧状态、保 worker 存活、保 ingress 链路，还是已经进入应主动退场的 verdict？”

只要这四条轴线没先拆开，正文就会把 init、state restore、heartbeat、`keep_alive` 与 self-exit 写成同一种 liveness。

这里也要主动卡住一个边界：

- 这页只讲 CCR v2 worker 的生命周期合同
- 不重复 41 页对 `workerEpoch` 对象身份的分类
- 不重复 20 页对 `RemoteIO` 作为宿主 I/O 合同的说明

同时还要再压一层 reader-facing 主次：

- 真正该进入用户主叙事的，是 `state restore` 与 `self-exit / graceful handoff`
- `worker heartbeat` 与 `keep_alive` 主要作为解释这些主现象为何能成立的支撑机制

## 第一层：`initialize()` 先做的是 generation claim，不是单纯“连上了”

### worker 初始化先要声明“我是哪一代”

`CCRClient.initialize()` 的顺序很硬：

1. 拿 auth headers
2. 读取传入 epoch，或回退到 `CLAUDE_CODE_WORKER_EPOCH`
3. 并发发起：
   - `GET /worker` 读取上一代外部状态
   - `PUT /worker` 把当前 `worker_epoch` 和 `worker_status: idle` 登记上去
4. 成功后才启动 heartbeat

这说明这里回答的问题不是：

- 传输层是不是已经连上 SSE

而是：

- 当前这代 worker 有没有先在服务端完成合法登记

### `worker_register_failed` 也说明 init 不是可有可无的附带动作

`CCRInitError` 的枚举里明确把：

- `worker_register_failed`

作为独立初始化失败原因。

这说明 generation claim 回答的问题不是：

- “先发着看，后面再补”

而是：

- init 阶段本身就必须先拿到服务端承认

只要这一层没拆开，正文就会把：

- transport connected
- worker registered

写成同一种“已连上”。

## 第二层：state restore 与 init 并发，但语义不同

### `GET /worker` 读的是上一代留下的外部状态，不是再次证明当前代合法

`CCRClient.initialize()` 在 `PUT /worker` 的同时会并发调用：

- `getWorkerState()`

读回的是：

- `worker.external_metadata`

随后才在 init 成功后记录：

- `cli_worker_state_restored`

这说明 state restore 回答的问题不是：

- 当前这代 worker 合不合法

而是：

- 上一代有没有留下可恢复的外部状态，让这代 worker 启动时接上上下文

### 所以 state restore 与 generation claim 不能写成同一种初始化动作

更准确的区分是：

- `PUT /worker`：当前代登记
- `GET /worker`：上一代状态回读

只要这一层没拆开，正文就会把：

- “初始化成功”
- “状态恢复成功”

压成同一个结果。

## 第三层：worker heartbeat 保的是 worker verdict，不是 session-ingress 链路

### `POST /worker/heartbeat` 的对象是 worker epoch

`CCRClient` 的 heartbeat 定时器会周期性发：

- `POST /worker/heartbeat`
- body 里带 `session_id` 和 `worker_epoch`

源码注释也直接写了：

- 这是 worker liveness detection

这说明 heartbeat 回答的问题不是：

- 前端消息流还能不能穿过代理层

而是：

- 当前这代 worker 在服务端看来还算不算活着

### 所以 worker heartbeat 与 bridge 页里的 work heartbeat 不是一回事

更准确的区分是：

- bridge 页里的 `heartbeatWork(...)`：保 work lease
- CCR worker 的 `/worker/heartbeat`：保 worker generation liveness

只要这一层没拆开，正文就会把不同层级的 heartbeat 再次写平。

## 第四层：`keep_alive` 保的是 session-ingress 链路，不是 worker generation

### `keep_alive` 走的是输出流，不是 `/worker/heartbeat`

`remoteIO.ts` 在 bridge topology 下会按固定间隔：

- `write({ type: 'keep_alive' })`

源码注释写得也很清楚：

- 它是为了避免上游代理层和 session-ingress 把 idle remote-control session 回收
- 这种消息在各类客户端 UI 前都会被过滤掉

同时，`CCRClient.initialize()` 还会注册：

- `registerSessionActivityCallback(() => this.writeEvent({ type: 'keep_alive' }))`

说明即使没有显式 heartbeat timer，API call / tool in-flight 期间也要把 ingress 侧 keep-alive 补上。

这说明 `keep_alive` 回答的问题不是：

- 当前这代 worker 还被不被服务端承认

而是：

- 当前 ingress 链路在空闲或长工具执行期间会不会先被网络路径回收

### 所以 `keep_alive` 与 worker heartbeat 是两条不同的存活合同

更准确的理解应是：

- worker heartbeat：向 worker API 证明这代还活着
- `keep_alive`：向 ingress / 代理路径证明这条链还值得保持

只要这一层没拆开，正文就会把：

- `POST /worker/heartbeat`
- `type: keep_alive`

写成同一种保活。

## 第五层：epoch mismatch 的核心是“新代赢了”，不是“这条 session 不存在了”

### `409` 表示这一代已经被更新的 worker supersede

`CCRClient.request()` 只要遇到：

- `409`

就会调用：

- `handleEpochMismatch()`

而 `handleEpochMismatch()` 的语义写得很直接：

- newer CC instance has replaced this one
- exit immediately

这说明 epoch mismatch 回答的问题不是：

- 这条 session 已经找不到

而是：

- 同一条 session 还在，但更高 epoch 的 worker 已经接管写入资格

### 所以它和 page 41 的对象分类不同

page 41 解决的是：

- `workerEpoch` 不是 ID，也不是 token

而这页要继续下钻的是：

- 一旦 epoch 被 supersede，旧代为什么必须主动退场

只要这一层没拆开，正文就会把：

- `workerEpoch` 是什么对象
- epoch mismatch 后为什么自退

写成同一个问题。

## 第六层：token expired / auth failures exhausted 是另一条 self-exit verdict，不等于 epoch mismatch

### expired token 是 deterministic self-exit

`CCRClient.request()` 在 `401/403` 时，会先检查：

- 当前 session token 自己的 `exp`

若 token 已经过期，就直接记：

- `cli_worker_token_expired_no_refresh`

然后调用：

- `onEpochMismatch()`

这说明这里最关键的语义不是：

- 服务端暂时抖了一下

而是：

- 这代 worker 已经拿着确定过期的 credential，不该继续假活

### valid-looking token 连续 auth failure 则走另一条阈值退出

如果 token 看起来还没过期，但连续 `401/403` 达到阈值，就会记：

- `cli_worker_auth_failures_exhausted`

然后同样触发：

- `onEpochMismatch()`

这说明源码明确区分了两种退出语义：

- expired token：deterministic no-refresh exit
- auth failures exhausted：uncertain-but-unrecoverable enough，达到阈值后退出

### 所以 auth-triggered self-exit 与 epoch mismatch 不是同一种退场原因

更准确的区分是：

- epoch mismatch：新代 supersede
- token expired：当前代 credential 已死
- auth failures exhausted：当前代虽未证明确认过期，但服务端认证已连续不可用到不值得继续撑

只要这一层没拆开，正文就会把所有 self-exit 都写成“epoch mismatch 退出”。

## 第七层：请求失败不总等于退场，很多失败只是 best-effort failure

### 普通 request failure 与 GET retry exhausted 不会立刻杀 worker

`CCRClient.request()` 对多数非 2xx 只会：

- 记 diagnostics
- 返回 `{ ok: false }`

`getWithRetry(...)` 的 GET 在重试耗尽后，也只是：

- 记 `cli_worker_get_retries_exhausted`
- 返回 `null`

而不会直接退出 worker。

这说明源码在 worker lifecycle 上至少分三类结果：

- continue
- best-effort failure
- self-exit

### 所以 “请求失败了” 不等于 “这一代 worker 该退场了”

更准确的理解应是：

- 只有 epoch mismatch 与 auth 相关那几类 verdict，才触发主动退场
- 其他 request / GET 失败仍可能只是保留运行、等待下一次成功

只要这一层没拆开，正文就会把：

- 一个 warn 级 request 失败
- 这一代 worker 应该退出

写成同一种故障。

## 第八层：稳定、条件与内部三层要分开保护

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | 无；本页主对象主要属于 CCR v2 条件路径，不应误写成所有 remote-control 的稳定主线 |
| 条件公开 | partial state restore、epoch mismatch self-exit、token expired / auth failures exhausted self-exit |
| 内部/实现层 | `workerEpoch` 作为所有权令牌、worker heartbeat、`keep_alive`、uploader batching、回调 wiring 顺序、具体 heartbeat / keep_alive 毫秒数、GET retry 常数、diagnostic 事件名 |

这里尤其要避免两种写坏方式：

- 把 `workerEpoch` 的对象分类和 worker lifecycle 合同写成同一页
- 把所有 request failure 都抬成一条“worker 退场”主线

## 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `initialize()` = transport connected | 它先做的是 worker generation claim |
| state restore = worker register | 一个读旧状态，一个登记当前代 |
| worker heartbeat = `keep_alive` | 一个保 worker generation，一个保 ingress 链路 |
| epoch mismatch = session not found | 一个是同 session 下新代 supersede，另一个是对象不存在 |
| token expired exit = epoch mismatch | 一个是 credential 死亡，一个是 generation supersede |
| 任意 request failure = worker 应该退出 | 多数失败仍然只是 best-effort failure |

## 六个高价值判断问题

- 当前动作是在登记当前代、恢复旧状态、保 worker 存活，还是保 ingress 链路？
- 现在发生的是 best-effort failure，还是已经进入 self-exit verdict？
- 当前退出是因为 epoch 被新代顶掉，还是因为 auth / token 已经不可信？
- 我是不是又把 `keep_alive` 和 `/worker/heartbeat` 写成了同一种保活？
- 我是不是又把 41 页的对象分类问题和这页的生命周期合同混写了？
- 我是不是又把所有 request failure 抬成了“worker 死亡”？

## 源码锚点

- `claude-code-source-code/src/cli/remoteIO.ts`
- `claude-code-source-code/src/cli/transports/ccrClient.ts`
- `claude-code-source-code/src/bridge/replBridge.ts`
