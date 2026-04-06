# Remote Control 工具审批、网络放行、自动批准与提示撤销索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/40-can_use_tool、SandboxNetworkAccess、hook-classifier 与 control_cancel_request：为什么 remote-control 的工具审批、网络放行、自动批准与提示撤销不是同一种批准.md`
- `05-控制面深挖/29-Bridge Permission Callbacks、Control Request 与 Bridge-safe Commands：为什么远端的权限提示、会话控制与命令白名单不是同一种控制合同.md`

## 1. 五类批准对象总表

| 对象 | 回答的问题 | 典型例子 |
| --- | --- | --- |
| `Per-invocation Tool Approval` | 这次真实工具调用能不能跑 | `can_use_tool` |
| `Sandbox Network Ask` | 这次网络连接能不能连出 | `SandboxNetworkAccess` |
| `Approval Race` | 谁先给出有效结论 | local UI、bridge、channel、hook、classifier |
| `Prompt Teardown` | 输掉竞态的旧提示怎么收口 | `cancelRequest`、`control_cancel_request` |
| `Session Control` | 整条 session 参数要不要改 | `set_permission_mode`、`set_model` |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `can_use_tool` = 只有工具审批 | 它也能承载 sandbox 网络放行 |
| remote-control = 唯一批准者 | 它只是多方竞态中的一方 |
| auto-approve = 没出现过 prompt | prompt 也可能只是被更快的赢家收掉 |
| `cancelRequest` = deny | 它解决的是旧 prompt teardown |
| `control_cancel_request` = 用户拒绝 | 它只是让输掉的一侧停止等待 |
| 这页 = session control | session control 应回看第 29 页 |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | 本地权限确认框、bridge allow / deny、sandbox 网络提示 |
| 条件公开 | channel relay、classifier auto-approve、远端持久化批准更新 |
| 内部/实现层 | `claim()`、`cancelRequest`、`control_cancel_request`、synthetic tool name |

## 4. 六个高价值判断问题

- 当前批准的是工具调用，还是网络连接？
- 当前真正的决策者是谁？
- 这里是串行审批，还是谁先响应谁赢？
- 当前动作是在给最终结论，还是只是在收掉旧 prompt？
- 我是不是把自动批准写成了 remote-control 的远端批准？
- 我是不是把 session control 又写回了批准面？

## 5. 源码锚点

- `claude-code-source-code/src/cli/structuredIO.ts`
- `claude-code-source-code/src/cli/print.ts`
- `claude-code-source-code/src/hooks/toolPermission/handlers/interactiveHandler.ts`
- `claude-code-source-code/src/hooks/toolPermission/PermissionContext.ts`
- `claude-code-source-code/src/bridge/bridgePermissionCallbacks.ts`
