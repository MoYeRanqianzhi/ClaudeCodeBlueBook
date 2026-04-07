# `BridgeConfig.environmentId`、`reuseEnvironmentId`、`registerBridgeEnvironment.environment_id` 与 `createBridgeSession` 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/174-BridgeConfig.environmentId、reuseEnvironmentId、registerBridgeEnvironment.environment_id 与 createBridgeSession：为什么本地 env key、reuse claim、live env 与 session attach target 不是同一种环境主权.md`
- `05-控制面深挖/173-BridgePointer.environmentId、getBridgeSession.environment_id、reuseEnvironmentId 与 registerBridgeEnvironment：为什么 pointer 里的 env hint、server session env 与 registered env 不是同一种 truth.md`
- `05-控制面深挖/42-register、poll、ack、heartbeat、stop、archive 与 deregister：为什么 standalone remote-control 的环境、work 与 session 生命周期不是同一种收口.md`

边界先说清：

- 这页不是更宽的 environment truth layering 页。
- 这页不是 environment/work/session lifecycle 页。
- 这页只抓 register chain 内部的 environment authority split。

## 1. 四层主权

| 层次 | 当前更像什么 | 关键对象 |
| --- | --- | --- |
| local config key | 本地 config 对象里先占的 env 槽位 | `BridgeConfig.environmentId` |
| request-side reuse claim | 向 backend 请求“请把我接回这条 env” | `reuseEnvironmentId` |
| live registered env | 当前这次注册真正落成的 env | `registerBridgeEnvironment(...).environment_id` |
| session attach target | 新 session 真正附着的 live env | `createBridgeSession({ environmentId })` |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `BridgeConfig.environmentId` 就是当前 live env | 它先是 local config key，不自动等于 live env |
| `reuseEnvironmentId` 与 live env 只是同一个值在请求与响应里回流 | request-side claim 可能被 backend 否定并替换 |
| 注册返回值只是把原环境 ID 回显一遍 | response-side `environment_id` 才是 runtime 承认的 live env |
| `createBridgeSession({ environmentId })` 继续消费的是 reuse claim | 它消费的是注册后已经落成的 live env |

## 3. stable / conditional / gray

| 类型 | 对象 |
| --- | --- |
| 专题内稳定不变量 | request claim 与 live env 可分裂；runtime 围绕 response-side env 运转；session attach 使用 live env |
| 条件公开 | standalone resume、perpetual REPL reconnect、idempotent re-register |
| 内部/灰度层 | pointer source、spawn mode、compat tag、OAuth refresh、fault injection |

## 4. 五个检查问题

- 当前环境字段活在 local config、request claim、response result，还是 session attach 面？
- 当前字段是 client-generated，还是 backend-issued？
- 当前 register request 真正发送的是哪一个 env 字段？
- 我是不是把 env mismatch 错写成 request claim 自动成功？
- 我是不是又把这页写回 173 的 truth layering 而不是 register contract authority？

## 5. 源码锚点

- `claude-code-source-code/src/bridge/types.ts`
- `claude-code-source-code/src/bridge/bridgeApi.ts`
- `claude-code-source-code/src/bridge/bridgeMain.ts`
- `claude-code-source-code/src/bridge/replBridge.ts`
- `claude-code-source-code/src/bridge/createSession.ts`
