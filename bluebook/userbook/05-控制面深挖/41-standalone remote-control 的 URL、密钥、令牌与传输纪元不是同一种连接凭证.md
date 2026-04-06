# `sdkUrl`、`sessionIngressUrl`、`environmentSecret`、session access token 与 `workerEpoch`：为什么 standalone remote-control 的 URL、密钥、令牌与传输纪元不是同一种连接凭证

## 用户目标

不是只知道 standalone `claude remote-control` 里“有 connect URL、session URL、environment ID，源码里又冒出 `sdkUrl`、`environmentSecret`、token 和 `workerEpoch`”，而是先分清六类不同对象：

- 哪些是在定位 child 应该连哪个 session transport endpoint。
- 哪些是在给 host 轮询 environment work 时做环境级认证。
- 哪些是在给 child / heartbeat 做 session 级认证。
- 哪些只在 CCR v2 worker 模式下才存在。
- 哪些是用户可见定位符，哪些只是内部连接凭证。
- 哪些虽然都像“连接信息”，但实际上一个是 URL、一个是 secret、一个是 token、一个是 generation marker。

如果这些对象不先拆开，读者最容易把下面这些东西压成同一种“remote-control 连接信息”：

- `apiBaseUrl`
- `sessionIngressUrl`
- `sdkUrl`
- `environmentId`
- `environmentSecret`
- `session_ingress_token`
- `CLAUDE_CODE_SESSION_ACCESS_TOKEN`
- `workerEpoch`
- `sessionId`

## 第一性原理

standalone remote-control 的连接面至少沿着四条轴线分化：

1. `Scope`：它属于 environment、session，还是某个 v2 worker generation。
2. `Function`：它是在定位 endpoint、做认证，还是标识当前 worker 纪元。
3. `Transport Version`：它服务的是 v1 session-ingress，还是 v2 CCR worker path。
4. `Visibility`：它是给用户看的定位符，还是只该留在 host / child 内部。

因此更稳的提问不是：

- “这些不都是 bridge 的连接参数吗？”

而是：

- “这次对象到底是 environment 级还是 session 级；它是在告诉我连哪里、拿什么认证，还是告诉服务器当前 worker 是第几代？”

只要这四条轴线没先拆开，正文就会把 URL、secret、token 与 epoch 写成同一种凭证。

## 第一层：`sessionIngressUrl` 与 `sdkUrl` 不是同一种 URL

### `sessionIngressUrl` 是 host 侧保留的 ingress base，不是 child 当前会话的最终 transport target

`bridgeMain.ts` 初始化 config 时会同时保留：

- `apiBaseUrl`
- `sessionIngressUrl`

`types.ts` 还专门注释：

- `sessionIngressUrl` 是给 WebSocket connections 用的 session ingress base
- 它在本地环境下可能和 `apiBaseUrl` 不同

这说明 `sessionIngressUrl` 回答的问题不是：

- child 最终要把 SDK 流量发到哪一个具体 session URL

而是：

- host 在 v1 session-ingress 路径里，应该从哪一块 ingress base 拼出 per-session endpoint

### `sdkUrl` 才是 child 真正被喂进去的 per-session transport target

`bridgeMain.ts` 在 work 派发后，会按 transport 版本生成：

- v1：`sdkUrl = buildSdkUrl(config.sessionIngressUrl, sessionId)`
- v2：`sdkUrl = buildCCRv2SdkUrl(config.apiBaseUrl, sessionId)`

随后 `sessionRunner.ts` 会把它作为：

- `--sdk-url <opts.sdkUrl>`

喂给 child CLI。

因此更准确的区分是：

- `sessionIngressUrl`：host 侧保留的 ingress base
- `sdkUrl`：child 当前这条 session 真实要连的 endpoint

### 这也解释了为什么 v1 和 v2 的 `sdkUrl` 长相不同

`workSecret.ts` 写得很清楚：

- `buildSdkUrl(...)` 产出的是 `ws(s)://.../session_ingress/ws/{sessionId}`
- `buildCCRv2SdkUrl(...)` 产出的是 `https://.../v1/code/sessions/{sessionId}`

这说明：

- 即使都叫 `sdkUrl`
- 它在 v1 / v2 里也不是同一种 transport 形态

只要这一层没拆开，正文就会把：

- connect URL
- session URL
- sessionIngressUrl
- sdkUrl

又写回同一种“会话链接”。

## 第二层：`environmentId` / `environmentSecret` 是 environment 级配对，不是 session child 的登录凭证

### register bridge environment 返回的是一对 environment credentials

`bridgeApi.ts` 的 `registerBridgeEnvironment(...)` 返回：

- `environment_id`
- `environment_secret`

`bridgeMain.ts` 也在启动时把这两个值一起拿回来。

这说明 environment 层的对象不是一个裸 ID，而是：

- 可显示的 environment ID
- 只给 host 内部使用的 environment secret

### 这对凭证主要服务的是 work poll，而不是 child session I/O

`types.ts` 里 `pollForWork(...)` 的签名明确要求：

- `environmentId`
- `environmentSecret`

而 `bridgeMain.ts` 的主 poll loop 也是拿这两个对象去：

- `api.pollForWork(environmentId, environmentSecret, ...)`

因此更稳的理解应是：

- `environmentId` / `environmentSecret` 属于 host 对 environment queue 的占有关系
- 它们不是 child 直接拿去跑 session transport 的凭证

### 所以 `environmentId` 能展示，不代表 `environmentSecret` 也属于同一层

第 26 页已经解释过：

- `environmentId` 可以作为 verbose / 定位符出现

但这里必须继续下钻一层：

- `environmentSecret` 是 environment poll credential
- 它不属于用户可见定位符

只要这一层没拆开，正文就会把：

- “环境 ID”
- “环境 secret”

错写成同一种环境标识。

## 第三层：session access token 是 session 级认证，不等于 environment secret

### work secret 给的是 per-session `session_ingress_token`

`bridge/types.ts` 的 work secret 结构里直接包含：

- `session_ingress_token`

`bridgeMain.ts` 在 spawn child 时，也明确把：

- `accessToken: secret.session_ingress_token`

传给 `sessionRunner`。

### child 真正吃进去的是 `CLAUDE_CODE_SESSION_ACCESS_TOKEN`

`sessionRunner.ts` 在构造 child env 时会：

- 清掉 `CLAUDE_CODE_OAUTH_TOKEN`
- 写入 `CLAUDE_CODE_SESSION_ACCESS_TOKEN = opts.accessToken`

注释还明确说：

- child CC process 应该用 session access token 做 inference

这说明 child session 的认证对象不是：

- environment secret

而是：

- 当前 session 自己的 access token

### heartbeat 也优先走 session token，不走 environment secret

`types.ts` 对 `heartbeatWork(...)` 的注释写得很清楚：

- heartbeat uses SessionIngressAuth (JWT)
- not EnvironmentSecretAuth

`bridgeMain.ts` 也为此单独维护：

- `sessionIngressTokens`

并在 heartbeat 时按 sessionId 取对应 token。

因此更准确的区分是：

- `environmentSecret`：host 轮询 environment work 用
- session access token：child inference、session ingress、heartbeat 等 session 级路径用

只要这一层没拆开，正文就会把“谁在认证 environment queue”和“谁在认证具体 session I/O”写成同一种 secret。

## 第四层：`workerEpoch` 不是 ID，也不是 token，而是 v2 worker generation marker

### 它只在 CCR v2 路径里才出现

`bridgeMain.ts` 只有在：

- `use_code_sessions === true`
- 或强制启用 CCR v2

时，才会：

- `registerWorker(sdkUrl, secret.session_ingress_token)`
- 拿到 `workerEpoch`

v1 分支没有这一步。

这说明 `workerEpoch` 回答的问题不是：

- 当前 session 是谁

而是：

- 当前这条 v2 worker 注册是不是最新那一代

### 它会被显式下发给 child CCRClient

`sessionRunner.ts` 在 `useCcrV2` 时写入：

- `CLAUDE_CODE_WORKER_EPOCH`

`ccrClient.ts` 初始化时又会：

- 读取 epoch
- 缺失就 `missing_epoch`
- 后续把 `worker_epoch` 带进 `/worker` init 和 event requests

因此更稳的理解应是：

- `workerEpoch` 不是一个定位符
- 也不是一个认证 token
- 它是服务器用来判断“这一代 worker 还算不算当前有效写入者”的 generation marker

### epoch mismatch 的语义也说明它不是另一个 session ID

`replBridgeTransport.ts` 在 v2 path 里明确把：

- epoch superseded

当成需要关闭 transport、让 poll loop 恢复的条件。

如果它只是另一个 session ID，就不会有：

- “同一 session，但 worker generation 已经被更新”

这层语义。

## 第五层：`apiBaseUrl` 也不能和 `sessionIngressUrl` 写成同一种 base

### v2 `sdkUrl` 明确从 `apiBaseUrl` 构造

`buildCCRv2SdkUrl(...)` 直接基于：

- `apiBaseUrl`

生成：

- `/v1/code/sessions/{id}`

### v1 `sdkUrl` 则明确从 `sessionIngressUrl` 构造

`bridgeMain.ts` 甚至专门注释：

- v1 uses `config.sessionIngressUrl`
- not `secret.api_base_url`

原因是某些本地 / 代理场景下：

- `apiBaseUrl` 指向远程 proxy tunnel
- 但 locally-created session 的 ingress endpoint 并不在那里

因此更准确的区分是：

- `apiBaseUrl`：API / CCR v2 session URL 的基底
- `sessionIngressUrl`：v1 session-ingress transport 的基底

只要这一层没拆开，正文就会把：

- bridge API base
- session ingress base

压成同一个“服务器地址”。

## 第六层：稳定、条件与内部三层要分开保护

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | connect URL、session URL、environment ID、session ID |
| 条件公开 | CCR v2 path、`workerEpoch`、`sessionIngressUrl` 与 `apiBaseUrl` 分离的本地场景 |
| 内部/实现层 | `sdkUrl`、`environmentSecret`、session access token、`CLAUDE_CODE_WORKER_EPOCH`、`registerWorker(...)` |

这里尤其要防两种写坏方式：

- 把用户可见定位符和内部连接凭证混成一组“链接”
- 把 v2 专属纪元对象写成所有 remote-control 都必有的稳定字段

## 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `sdkUrl` = connect URL / session URL | `sdkUrl` 是 child transport target，不是用户入口链接 |
| `sessionIngressUrl` = `apiBaseUrl` | v1 / v2 用途不同，某些本地场景还会显式分离 |
| `environmentSecret` = session access token | 一个认证 environment poll，一个认证具体 session |
| `workerEpoch` = session ID | 它标记的是 v2 worker generation，不是对象身份 |
| `environmentId` 可见，所以 `environmentSecret` 也算定位符 | secret 只属于 host 内部连接面 |
| `workerEpoch` 在所有 remote-control 路径都存在 | 它只在 CCR v2 worker 路径里成立 |
| heartbeats 一直靠 environment secret | heartbeat 明确走 session token |

## 六个高价值判断问题

- 当前对象属于 environment、session，还是 worker generation？
- 这是在定位 endpoint、做认证，还是在标记当前 worker 纪元？
- 现在走的是 v1 session-ingress，还是 v2 CCR worker path？
- 这个字段是给用户看的，还是只该存在于 host / child 内部？
- 我是不是把 `environmentSecret` 和 session access token 写成了同一种密钥？
- 我是不是又把 `sdkUrl` 写成了用户能直接打开的链接？

## 源码锚点

- `claude-code-source-code/src/bridge/bridgeMain.ts`
- `claude-code-source-code/src/bridge/workSecret.ts`
- `claude-code-source-code/src/bridge/bridgeApi.ts`
- `claude-code-source-code/src/bridge/sessionRunner.ts`
- `claude-code-source-code/src/bridge/types.ts`
- `claude-code-source-code/src/cli/transports/transportUtils.ts`
- `claude-code-source-code/src/cli/transports/ccrClient.ts`
- `claude-code-source-code/src/bridge/replBridgeTransport.ts`
