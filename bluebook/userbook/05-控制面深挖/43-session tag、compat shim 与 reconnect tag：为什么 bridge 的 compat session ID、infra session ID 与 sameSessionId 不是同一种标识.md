# `session tag`、compat shim 与 reconnect tag：为什么 bridge 的 compat session ID、infra session ID 与 `sameSessionId` 不是同一种标识

## 用户目标

不是只知道 remote-control / bridge 里“有时看到 `session_*`，有时源码里又冒出 `cse_*`，resume 时还会试两个 ID”，而是先分清五类不同对象：

- 哪些是给 compat surface 和前端路由看的 session 标识。
- 哪些是基础设施 / worker 层真正发下来的 session 标识。
- 哪些是在不同 tag 之间做 retag 的转换器。
- 哪些是在比较“是不是同一条 session”而不是保留原 tag。
- 哪些虽然都长得像 session ID，但作用面已经分别落在 title、archive、logger、reconnect 和 work poll 上。

如果这些对象不先拆开，读者最容易把下面这些东西压成同一种“session ID”：

- `session_*`
- `cse_*`
- `toCompatSessionId(...)`
- `toInfraSessionId(...)`
- `sameSessionId(...)`
- `sessionCompatIds`
- pointer 里存下来的 session ID
- `/bridge/reconnect` 里拿去查找的 session ID

## 第一性原理

bridge 的 session 标识至少沿着四条轴线分化：

1. `Tag Surface`：当前 tag 服务的是 client-facing compat surface，还是 infrastructure / worker surface。
2. `Operation`：当前是在展示、归档、改标题、resume/reconnect，还是在 worker 路径里继续跑 transport。
3. `Transformation`：当前需要的是保留原 tag、把 tag 改写，还是只比较底层 UUID 是否同一条。
4. `Stability`：这是用户表面稳定可见的对象，还是带 gate 的兼容层过渡物。

因此更稳的提问不是：

- “到底哪个才是真的 session ID？”

而是：

- “这次操作要的是 compat tag、infra tag，还是只需要判断两者是不是同一条 UUID；当前对象服务的是前端路由、session API，还是 reconnect / worker 层？”

只要这四条轴线没先拆开，正文就会把 `session_*`、`cse_*` 和比较函数写成同一种 session 标识。

## 第一层：`session_*` 与 `cse_*` 不是真假关系，而是两套 surface 的不同 costume

### `session_*` 属于 compat / client-facing surface

`sessionIdCompat.ts` 写得非常直接：

- client-facing compat endpoints
- `/v1/sessions/{id}`
- `/v1/sessions/{id}/archive`
- `/v1/sessions/{id}/events`

要的是：

- `session_*`

这说明 `session_*` 回答的问题不是：

- worker transport 当前内部用哪个 tag

而是：

- compat API / 前端路由这层应该认哪种 session costume

### `cse_*` 属于 infrastructure / worker surface

同一文件和 `workSecret.ts` 都说明：

- work poll 返回的是 `cse_*`
- worker endpoints 要的是 `cse_*`
- infrastructure layer 用的是 `cse_*`

这说明 `cse_*` 回答的问题是：

- worker / queue / infra 层到底在跟哪条 session 打交道

### 所以它们不是“旧 ID / 新 ID”，而是“同一 UUID 的不同制服”

更准确的理解应是：

- 同一个底层 UUID
- 在 compat / infra 两层穿不同 tag costume

只要这一层没拆开，正文就会把：

- `session_*`
- `cse_*`

误写成两个不同 session。

## 第二层：`toCompatSessionId(...)` 与 `toInfraSessionId(...)` 不是互换别名，而是面向不同操作的 retag

### `toCompatSessionId(...)` 服务的是 title、archive、session URL、logger 等 compat-facing 操作

`sessionIdCompat.ts` 明确说明：

- work poll 在 compat gate 下给的是 `cse_*`
- 但 archiveSession / fetchSessionTitle 需要 retag

`bridgeMain.ts` 在 spawn 后也会立刻：

- `const compatSessionId = toCompatSessionId(sessionId)`
- 用它做 `logger.setSessionTitle(...)`
- `updateBridgeSessionTitle(...)`
- `getRemoteSessionUrl(...)`
- `fetchSessionTitle(...)`
- `logger.setAttached(...)`

因此 `toCompatSessionId(...)` 回答的问题不是：

- reconnect 应该发哪个 ID

而是：

- 当前这个对象要进入 compat-facing session API / logger / URL surface 时，是否需要穿上 `session_*` 的衣服

### `toInfraSessionId(...)` 则主要服务 reconnect / infra lookup

`sessionIdCompat.ts` 同样明确说明：

- `/bridge/reconnect` 在 compat gate 打开时
- 会按 infra tag `cse_*` 查 session

`bridgeMain.ts` 在 resume 时也会：

- 先从 pointer 读到 `session_*`
- 再生成 `infraResumeId = toInfraSessionId(resumeSessionId)`
- 两个 candidate 都试

因此 `toInfraSessionId(...)` 回答的问题是：

- 当当前操作落在 infra lookup / reconnect 侧时，要不要换回 `cse_*`

### 所以这两个转换函数不是同义词

更准确的区分是：

- `toCompatSessionId`：把 infra-tag 对象带回 compat-facing surface
- `toInfraSessionId`：把 compat-tag 对象带回 infra-facing lookup

只要这一层没拆开，正文就会把两者写成“随便转一下”的无意义适配器。

## 第三层：`sameSessionId(...)` 不是 retag，而是跨 tag 比较“是不是同一条底层 UUID”

### 它不保留原 tag，只回答 identity equivalence

`workSecret.ts` 明确把 `sameSessionId(...)` 定义成：

- compare two session IDs regardless of their tagged-ID prefix

它取的是：

- 最后一个下划线后的 body

也就是：

- 不关心你现在穿的是 `session_*` 还是 `cse_*`
- 只关心底层 UUID body 是否相同

### 这使它和 retag helper 属于完全不同的问题

更稳的区分是：

- retag helper：为了让某个 API / route 接受当前对象
- `sameSessionId(...)`：为了判断两个不同 costume 其实是不是同一条 session

因此它回答的问题不是：

- “这次我要把 ID 转成什么样”

而是：

- “这两个不同 tag 的 ID，本质上是不是同一条 session”

### 这也解释了它为何常出现在 match / guard，而不是 URL / API 构造

比如源码里会在：

- work-received check
- initial session / current session 对比

这类 guard 上使用 `sameSessionId(...)`。

它属于：

- identity comparison

而不是：

- presentation retag

## 第四层：`sessionCompatIds` 是桥接运行时缓存，不是另一份权威 session registry

### 它缓存的是“当前 raw sessionId 对应的 compat costume”

`bridgeMain.ts` 在 spawn 成功后会：

- `sessionCompatIds.set(sessionId, compatSessionId)`

并在 logger / archive snapshot 等地方继续取它。

这说明 `sessionCompatIds` 回答的问题不是：

- 当前有哪些 session 存在

而是：

- 对这条 raw sessionId，我先前已经确定过哪一个 compat costume 应该用于 compat-facing surfaces

### 所以它是运行时桥接缓存，不是新的主键表

更准确的理解应是：

- 权威对象仍然是当前 session 自己
- 这张 map 只是为了避免各处重复重新判断 / 重新换衣服

只要这一层没拆开，正文就会把：

- raw sessionId
- compatSessionId cache

写成两个平级对象源。

## 第五层：resume / reconnect 正好暴露了 pointer tag、compat tag 与 infra tag 三层错位

### pointer 存下来的往往是 compat-facing `session_*`

源码注释明确说明：

- pointer stores a `session_*` ID

这和 reader 心智一致，因为：

- createBridgeSession 返回 compat-facing 的 session 形态

### 但 `/bridge/reconnect` 在 compat gate 下可能只认 infra tag

`bridgeMain.ts` 的 resume 分支同样写得很清楚：

- pointer stores `session_*`
- `/bridge/reconnect` looks up by `cse_*` when compat gate is on
- so try both

因此更稳的理解应是：

- pointer 里的 ID 不是“错了”
- 它只是服务的是 compat-facing session continuity
- 到 infra reconnect 这一步时，可能需要换回另一套 costume

### 这也解释了为什么 resume 不是“拿着一个 session ID 一路到底”

更准确的区分是：

- continuity hint / pointer surface
- reconnect lookup surface

它们虽然都在处理“恢复同一条 session”，但使用的 tag 不一定相同。

## 第六层：compat shim gate 说明这整层本来就是过渡结构，不该被误写成永恒稳定表面

### `isCseShimEnabled()` 本身就是 kill-switch

`bridgeEnabled.ts` 直接把它写成：

- kill-switch for the `cse_*` -> `session_*` client-side retag shim

并明确说明：

- 一旦前端直接接受 `cse_*`
- `toCompatSessionId` 可以变成 no-op

这说明这一整层的第一性原理是：

- 为了跨过 compat gap 的过渡结构

而不是：

- 永远稳定不变的最终产品模型

### 所以 userbook 里必须把它放在“条件公开 / 兼容层”而不是“稳定主线”

更稳的保护方式应是：

- 让读者知道这层存在、知道它影响哪些判断
- 但不要把它抬成“用户每天都要理解的稳定功能名词”

## 第七层：稳定、条件与内部三层要分开保护

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | session continuity 本身、session URL / title / archive 仍然围绕同一条 session 发生 |
| 条件公开 | `session_*` / `cse_*` 双 tag 并存、compat shim gate、resume 时双 candidate reconnect |
| 内部/实现层 | `toCompatSessionId`、`toInfraSessionId`、`sameSessionId`、`sessionCompatIds` |

这里尤其要避免两种写坏方式：

- 把兼容层 costume 直接写成用户稳定主线对象
- 把内部 retag / compare helper 写成用户可直接操作的入口概念

## 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `session_*` = 真 session，`cse_*` = 假 session | 它们是同一 UUID 在不同 surface 的不同 costume |
| `toCompatSessionId` = `sameSessionId` 的另一种写法 | 一个在换 tag，一个在比较底层 UUID |
| pointer 里存的是 `session_*`，说明 reconnect 也只该用它 | reconnect 在 compat gate 下可能要改回 `cse_*` |
| `sessionCompatIds` = 权威 session map | 它只是 raw sessionId 到 compat costume 的运行时缓存 |
| compat shim = 永久稳定产品层 | 它本质上是 kill-switch 控制的过渡层 |
| 有两个 tag = 有两条 session | 只是同一条 session 在不同 surface 的两套标识 |

## 六个高价值判断问题

- 当前操作要的是 compat-facing tag、infra-facing tag，还是只要比较底层 UUID？
- 这里在处理的是展示 / title / archive，还是 reconnect / worker lookup？
- 当前看到的是 retag helper，还是 identity compare helper？
- 我是不是又把 `session_*` 与 `cse_*` 写成了两条不同 session？
- 我是不是又把 `sameSessionId(...)` 写成了“转换函数”？
- 我是不是把 compat shim 误写成了永久稳定表面？

## 源码锚点

- `claude-code-source-code/src/bridge/sessionIdCompat.ts`
- `claude-code-source-code/src/bridge/bridgeEnabled.ts`
- `claude-code-source-code/src/bridge/workSecret.ts`
- `claude-code-source-code/src/bridge/bridgeMain.ts`
- `claude-code-source-code/src/bridge/createSession.ts`
