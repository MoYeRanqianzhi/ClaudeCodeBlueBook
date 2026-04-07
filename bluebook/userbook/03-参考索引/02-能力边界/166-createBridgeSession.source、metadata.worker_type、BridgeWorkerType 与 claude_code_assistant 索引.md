# `createBridgeSession.source`、`metadata.worker_type`、`BridgeWorkerType` 与 `claude_code_assistant` 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/177-createBridgeSession.source、metadata.worker_type、BridgeWorkerType 与 claude_code_assistant：为什么 session origin declaration 与 environment origin label 不是同一种 remote provenance.md`
- `05-控制面深挖/175-BridgeWorkerType、metadata.worker_type、BridgePointer.source 与 environment_id：为什么环境来源标签、prior-state 域与环境身份不是同一种 provenance.md`
- `05-控制面深挖/176-createBridgeSession.environment_id、source、session_context 与 permission_mode：为什么 session attach target、来源声明、上下文载荷与默认策略不是同一种会话归属.md`

边界先说清：

- 这页不是 environment identity 页。
- 这页不是 session create field authority 页。
- 这页只抓 session family 与 environment origin label 的错位。

## 1. 两层 provenance

| 层次 | 当前更像什么 | 关键对象 |
| --- | --- | --- |
| session provenance family | 这条 session 属于哪类创建来源家族 | `createBridgeSession(... source: 'remote-control')` |
| environment origin label | 承载环境在 web/client 过滤中属于哪类来源标签 | `BridgeWorkerType`、`metadata.worker_type`、`claude_code_assistant` |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `source:'remote-control'` 与 `worker_type` 都是在说同一种 remote 来源 | 一个标 session family，一个标 environment label |
| `claude_code_assistant` 是另一种 session source | 它是 environment origin label |
| 既然都在 remote-control 体系里，就只差字段位置不同 | 它们服务的对象层不同：session vs environment |
| `worker_type` 只是 `source` 的更细版本 | 它不是 session source 的子枚举，而是环境过滤标签 |

## 3. stable / conditional / gray

| 类型 | 对象 |
| --- | --- |
| 专题内稳定不变量 | session source 与 environment label 分属不同对象层；同一 remote-control family 可对应多种 environment labels |
| 条件公开 | `claude_code_assistant`、assistant picker、opaque `"cowork"` 字符串 |
| 内部/灰度层 | typed SessionResource 当前不显式暴露 source、前端 picker 具体实现、KAIROS guard |

## 4. 五个检查问题

- 当前来源字段是在标 session family，还是 environment label？
- 当前字段变化后，影响的是 session provenance，还是 environment filtering？
- 我是不是把 `claude_code_assistant` 错写成另一种 session source？
- 我是不是把 `source:'remote-control'` 错写成 environment origin label？
- 我是不是又把这页写回 175 的 provenance taxonomy 或 176 的 create body 字段页？

## 5. 源码锚点

- `claude-code-source-code/src/bridge/createSession.ts`
- `claude-code-source-code/src/bridge/bridgeApi.ts`
- `claude-code-source-code/src/bridge/types.ts`
- `claude-code-source-code/src/bridge/initReplBridge.ts`
- `claude-code-source-code/src/utils/teleport/api.ts`
