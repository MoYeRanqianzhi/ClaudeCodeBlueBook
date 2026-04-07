# `BridgeWorkerType`、`metadata.worker_type`、`BridgePointer.source` 与 `environment_id` 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/175-BridgeWorkerType、metadata.worker_type、BridgePointer.source 与 environment_id：为什么环境来源标签、prior-state 域与环境身份不是同一种 provenance.md`
- `05-控制面深挖/173-BridgePointer.environmentId、getBridgeSession.environment_id、reuseEnvironmentId 与 registerBridgeEnvironment：为什么 pointer 里的 env hint、server session env 与 registered env 不是同一种 truth.md`
- `05-控制面深挖/174-BridgeConfig.environmentId、reuseEnvironmentId、registerBridgeEnvironment.environment_id 与 createBridgeSession：为什么本地 env key、reuse claim、live env 与 session attach target 不是同一种环境主权.md`

边界先说清：

- 这页不是 continuity / pointer fate 页。
- 这页不是 environment truth layering 页。
- 这页只抓 provenance label、trust-domain 与 identity 的错位。

## 1. 三种 provenance

| 类别 | 当前更像什么 | 关键对象 |
| --- | --- | --- |
| origin label | 给 web/client 过滤环境来源 | `BridgeWorkerType`、`metadata.worker_type` |
| prior-state trust domain | 给本地宿主判断 prior pointer 是否可复用 | `BridgePointer.source` |
| environment identity | 给 runtime lifecycle 继续 lookup / poll / attach | `environment_id` |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `workerType` 就是环境身份 | 它是 origin label，不是 identity |
| `metadata.worker_type` 是 environment 的另一种主键 | 它是 filter/classification metadata |
| `BridgePointer.source` 只是 `workerType` 的本地写法 | 它服务的是 local prior-state trust domain |
| assistant worker 与普通 worker 是不同的环境身份空间 | assistant mode 改的是来源标签，不是 identity space |

## 3. stable / conditional / gray

| 类型 | 对象 |
| --- | --- |
| 专题内稳定不变量 | label 不等于 identity；pointer source 不等于 picker filter；`environment_id` 继续承担 lifecycle identity |
| 条件公开 | assistant-mode worker label、perpetual REPL prior-pointer filtering |
| 内部/灰度层 | `"cowork"` 等外部 producer 字符串、KAIROS guard、前端 picker 具体实现 |

## 4. 五个检查问题

- 当前字段服务的是 web/client filter、本地 prior reuse，还是 runtime identity？
- 当前字段活在 metadata、pointer，还是 environment lifecycle 主链？
- 我是不是把 label 错写成 identity？
- 我是不是把 `source:'repl'` / `source:'standalone'` 错写成 `workerType` 的本地镜像？
- 我是不是又把这页写回 24/33 的 continuity 或 173/174 的 env authority 页面？

## 5. 源码锚点

- `claude-code-source-code/src/bridge/types.ts`
- `claude-code-source-code/src/bridge/bridgeApi.ts`
- `claude-code-source-code/src/bridge/initReplBridge.ts`
- `claude-code-source-code/src/bridge/replBridge.ts`
- `claude-code-source-code/src/bridge/bridgePointer.ts`
