# Remote Control `sdk-url`、session ingress、environment secret、access token 与 worker epoch 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/41-sdk-url、sessionIngressUrl、environmentSecret、session access token 与 workerEpoch：为什么 standalone remote-control 的 URL、密钥、令牌与传输纪元不是同一种连接凭证.md`
- `05-控制面深挖/26-Connect URL、Session URL、Environment ID、Session ID 与 remoteSessionUrl：为什么 remote-control 的链接、二维码与 ID 不是同一种定位符.md`

## 1. 六类连接对象总表

| 对象 | 回答的问题 | 典型例子 |
| --- | --- | --- |
| `User-facing Locator` | 用户该打开哪条链接 / 看哪个 ID | connect URL、session URL、environment ID |
| `Session Transport Target` | child 当前这条 session 应该连哪里 | `sdkUrl` |
| `Ingress Base` | host 用哪块 base 拼 v1 ingress endpoint | `sessionIngressUrl` |
| `Environment Credential` | host 如何轮询 / 占有 environment work | `environmentSecret` |
| `Session Credential` | child / heartbeat 如何认证当前 session | session access token |
| `Worker Generation` | 当前 v2 worker 还是不是最新那一代 | `workerEpoch` |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `sdkUrl` = 用户会打开的链接 | 它是 child transport target |
| `sessionIngressUrl` = `apiBaseUrl` | v1 / v2 用途不同 |
| `environmentSecret` = session token | 一个给 environment，一个给 session |
| `workerEpoch` = session ID | 它是 v2 worker generation marker |
| `environmentId` 可见 = environment secret 也可见 | secret 属于内部连接面 |
| heartbeats 靠 environment secret | heartbeat 明确走 session token |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | connect URL、session URL、environment ID、session ID |
| 条件公开 | CCR v2、`workerEpoch`、本地场景下 `sessionIngressUrl` 与 `apiBaseUrl` 分离 |
| 内部/实现层 | `sdkUrl`、`environmentSecret`、session access token、`CLAUDE_CODE_WORKER_EPOCH` |

## 4. 六个高价值判断问题

- 当前对象属于 environment、session，还是 worker generation？
- 这是定位 endpoint、认证凭证，还是纪元标记？
- 走的是 v1 session-ingress 还是 v2 CCR？
- 这是用户要看见的，还是 host / child 内部才该持有的？
- 我是不是把 environment secret 和 session token 混成了同一种密钥？
- 我是不是又把 `sdkUrl` 写成了用户入口链接？

## 5. 源码锚点

- `claude-code-source-code/src/bridge/bridgeMain.ts`
- `claude-code-source-code/src/bridge/workSecret.ts`
- `claude-code-source-code/src/bridge/bridgeApi.ts`
- `claude-code-source-code/src/bridge/sessionRunner.ts`
- `claude-code-source-code/src/bridge/types.ts`
- `claude-code-source-code/src/cli/transports/transportUtils.ts`
- `claude-code-source-code/src/cli/transports/ccrClient.ts`
- `claude-code-source-code/src/bridge/replBridgeTransport.ts`
