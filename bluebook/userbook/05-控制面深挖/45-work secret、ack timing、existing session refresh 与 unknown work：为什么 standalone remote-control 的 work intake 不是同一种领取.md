# `work secret`、`ack timing`、existing session refresh 与 `unknown work`：为什么 standalone remote-control 的 work intake 不是同一种领取

## 用户目标

不是只知道 standalone `claude remote-control` 会不断 poll work，然后“有的会启动 session，有的会跳过”，而是先分清六类不同 intake 对象：

- 哪些是在验证这条 work 本身是不是一条可解码、可领取的 work。
- 哪些是在承诺“这条 work 现在由我接手”。
- 哪些是在把已存在 session 的 fresh token 送回去，而不是新建 session。
- 哪些是在 capacity 已满时故意不 ack、让 work 保持可重投。
- 哪些是 poisoned work，应该直接 stop 掉而不是重试 ack。
- 哪些是未知 work type，应该宽容 ack 后跳过，而不是当成 fatal。

如果这些对象不先拆开，读者最容易把下面这些东西压成同一种“bridge 收到 work 后的处理”：

- `decodeWorkSecret(...)`
- `ackWork()`
- `healthcheck`
- `session`
- `existingHandle`
- invalid `session_id`
- at-capacity break
- unknown work type
- `stopWorkWithRetry(...)`

## 第一性原理

standalone remote-control 的 work intake 至少沿着四条轴线分化：

1. `Intake Validity`：这条 work 是有效、可解码、可承诺处理，还是已经是 poisoned item。
2. `Commitment`：当前动作是在真正 claim 这条 work，还是故意不 claim 让它继续留在队列里。
3. `Routing`：当前 work 应该被当成 healthcheck、existing session refresh、new session spawn，还是 unknown type。
4. `Failure Containment`：当前遇到错误时，是 ack 后放弃、stop work、还是保持可重投。

因此更稳的提问不是：

- “bridge 收到 work 后不就是 ack 然后处理吗？”

而是：

- “这条 work 先要不要通过 secret/ID 校验；我现在是在正式 claim 它、只给现有 session 送 fresh token，还是应该故意不 ack 让它保留；遇到坏 work 时又该怎样止血？”

只要这四条轴线没先拆开，正文就会把 ack、refresh、capacity skip 和 poisoned cleanup 写成同一种领取动作。

## 第一层：`decodeWorkSecret(...)` 先回答“这条 work 能不能被安全接住”，不是“该不该 ack”

### work secret 解不开时，问题还没进入 session 逻辑

`workSecret.ts` 对 `decodeWorkSecret(...)` 的要求非常严格：

- version 必须正确
- `session_ingress_token` 不能缺
- `api_base_url` 不能缺

这说明它回答的问题不是：

- 当前要不要 spawn child

而是：

- 这条 work 的 secret 本身是不是一条可被 bridge 安全消费的输入

### poisoned work 的处理是 stop，不是 ack

`bridgeMain.ts` 在 decode 失败后明确写了：

- 不能 ack，因为 ack 需要 JWT
- 但可以 `stopWorkWithRetry(...)`
- 这样能避免 poisoned item 每个 reclaim 周期都反复重投

因此更准确的理解应是：

- decode failure 不是普通 session failure
- 它属于 intake validity failure
- 收口策略是 stop poisoned work，而不是先 ack 再报错

只要这一层没拆开，正文就会把：

- “work 处理失败”
- “work 根本不该被处理”

写成同一种失败。

## 第二层：`ackWork()` 是 commit-to-handle 的动作，不是 poll 后自动发生的副作用

### 源码明确要求“先 commit，再 ack”

`bridgeMain.ts` 对 `ackWork()` 的注释非常强：

- explicitly acknowledge after committing to handle the work
- not before

这说明 ack 回答的问题不是：

- 我是不是看见了这条 work

而是：

- 我现在是否正式承诺让这条 work 进入本 bridge 的处理路径

### 所以 ack 时机本身就是 intake contract 的一部分

更稳的理解应是：

- poll 到 work != 自动 ack
- 只有确定不会因为 capacity / invalidity / routing 决策而立刻放弃时，才应 ack

只要这一层没拆开，正文就会把 ack 写成“收到 work 后的固定第一步”。

## 第三层：`healthcheck`、`session` 与 `unknown work type` 不是同一种路由目标

### `healthcheck` 只需要 ack 和记录，不进入 session 路径

`bridgeMain.ts` 对 `healthcheck` 分支做的事情非常窄：

- `await ackWork()`
- log healthcheck received

这说明它回答的问题不是：

- 这条 work 对应哪条 session

而是：

- host 当前是否仍然活着、可被环境探测到

### `session` 才会继续进入 sessionId 校验、existingHandle 判断与 spawn

同一个 switch 里，只有 `case 'session'` 才会继续：

- 校验 `session_id`
- existing session refresh
- capacity 判断
- spawn decision

### `unknown work type` 则是 ack 后宽容跳过

default 分支会：

- `await ackWork()`
- 记录 unknown work type
- 跳过，不把它当 fatal

因此更准确的区分是：

- `healthcheck`：环境探针式 work
- `session`：真正的会话工作
- `unknown`：向前兼容时的宽容吸收

只要这一层没拆开，正文就会把：

- protocol type routing
- session spawn logic

写成同一种处理链。

## 第四层：existing session refresh 不是 new session spawn 的弱化版

### 如果 `existingHandle` 已存在，bridge 走的是 refresh path，不是 spawn path

`bridgeMain.ts` 在 `case 'session'` 里先检查：

- `const existingHandle = activeSessions.get(sessionId)`

若存在，就直接：

- `existingHandle.updateAccessToken(secret.session_ingress_token)`
- `sessionIngressTokens.set(...)`
- `sessionWorkIds.set(...)`
- `tokenRefresh.schedule(...)`
- `await ackWork()`
- `break`

这说明它回答的问题不是：

- 现在要不要再起一个 child

而是：

- 这条 work 是不是只是给已在运行的 session 送 fresh token / fresh work ownership

### 所以 refresh path 是 session continuity，不是 spawn retry

更稳的理解应是：

- existing-handle path 仍然属于 intake
- 但它 intake 的对象是“已有 session 的续接工作”，不是“新 session 创建请求”

只要这一层没拆开，正文就会把：

- fresh token delivery
- new session spawn

压成同一种 session work。

## 第五层：capacity 满时故意不 ack，是为了保持 work 可重投，不是“处理失败”

### at-capacity break 的关键不是 sleep，而是不 claim

`bridgeMain.ts` 在 existing session refresh 之后，如果：

- `activeSessions.size >= config.maxSessions`

就会：

- 记录 at capacity
- 直接 `break`
- 不 `ackWork()`

这说明当前动作不是：

- “bridge 处理失败”

而是：

- “bridge 故意不接这条新 session work，让它继续留在队列里，等容量回来再说”

### 所以 capacity gate 是 intake commitment gate，不是 runtime error

更准确的区分是：

- invalid / poisoned item：stop
- at capacity：不 ack，保留可重投

只要这一层没拆开，正文就会把：

- capacity gate
- error path

写成同一种“没成功”。

## 第六层：invalid `session_id` 与 unknown work type 的收口也不是同一种宽容

### invalid `session_id` 是已知协议里的坏数据

`bridgeMain.ts` 对 invalid `session_id` 的处理是：

- `await ackWork()`
- 记录 error

这说明它不是：

- 我不认识这个 work type

而是：

- 我认识这是 session work，但它带的关键 ID 不合法，所以这次 work 不能继续

### unknown work type 则是面向未来协议扩展的宽容

default 分支的注释明确说：

- backend may send new types before bridge client is updated

这说明它的主语不是坏数据，而是：

- 新版本后端先行

因此更准确的区分是：

- invalid session_id：已知 schema 里的坏 work
- unknown work type：未知 schema 的宽容跳过

## 第七层：稳定、条件与内部三层要分开保护

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | bridge 只在真正接手时 ack、新 session work 会受 capacity 限制、已有 session 可走 refresh path |
| 条件公开 | healthcheck work、unknown work type 宽容处理、poisoned work stop、existing session fresh-token intake |
| 内部/实现层 | `decodeWorkSecret`、`ackWork`、`sessionIngressTokens.set(...)`、`stopWorkWithRetry(...)` |

这里尤其要避免两种写坏方式：

- 把 intake contract 直接简化成“poll 到 work 就 ack + spawn”
- 把 poisoned / capacity / unknown 这几种不同不进入 spawn 的原因写成同一种“跳过”

## 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| poll 到 work = 自动 ack | ack 只有在 commit-to-handle 后才发生 |
| decode failure = 普通 session 执行失败 | 它是 poisoned intake，收口策略是 stop |
| existing session refresh = 新 session spawn 的轻量版 | 它是续接已存在 session 的 intake 路径 |
| at capacity = 处理失败 | 它是故意不 ack，保留 work 可重投 |
| invalid session_id = unknown work type | 一个是已知 schema 的坏数据，一个是未知 schema 的宽容兼容 |
| healthcheck = session work 的空 prompt 版本 | 它属于不同的 work type 和不同的 routing 语义 |

## 六个高价值判断问题

- 这条 work 先要通过 intake validity，还是已经进入 session routing？
- 我现在是在 commit-to-handle，还是故意不 claim？
- 当前路径是在给 existing session 送 fresh token，还是要 spawn 新 child？
- 这是 poisoned work、invalid session data，还是只是 unknown future type？
- 我是不是又把 capacity gate 写成了 error？
- 我是不是又把 ack 写成了 poll 后固定第一步？

## 源码锚点

- `claude-code-source-code/src/bridge/workSecret.ts`
- `claude-code-source-code/src/bridge/types.ts`
- `claude-code-source-code/src/bridge/bridgeMain.ts`
