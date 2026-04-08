# `hostPattern.host`、`sandboxBridgeCleanupRef`、`sandboxPermissionRequestQueue filter`、`onResponse` unsubscribe 与 `cancelRequest` 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/201-hostPattern.host、sandboxBridgeCleanupRef、sandboxPermissionRequestQueue filter、onResponse unsubscribe 与 cancelRequest：为什么 sandbox network bridge 的同 host sibling cleanup 不是同一种 tool-level permission closeout.md`
- `05-控制面深挖/198-cancelRequest、onResponse unsubscribe、pendingPermissionHandlers.delete 与 leader queue recheck：为什么 bridge permission race 的 prompt 撤场、订阅退役、响应消费与策略重判不是同一种收口合同.md`

边界先说清：

- 这页不是 request-level permission closeout 总页。
- 这页不是 worker sandbox ask 总页。
- 这页只抓本地 sandbox network bridge 里按 `hostPattern.host` 聚合的 sibling sweep。

## 1. 五层对象

| 对象 | 当前更像什么 | 关键位置 |
| --- | --- | --- |
| `SANDBOX_NETWORK_ACCESS_TOOL_NAME` | synthetic transport shell | `structuredIO.ts` |
| `sandboxPermissionRequestQueue` | host-level pending queue | `REPL.tsx` |
| `hostPattern.host` | sibling grouping key | `REPL.tsx` |
| `sandboxBridgeCleanupRef` | host-keyed cleanup map | `REPL.tsx` |
| `unsubscribe()` + `cancelRequest(...)` | sibling sweep 的局部动作 | `REPL.tsx` |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `SandboxNetworkAccess` = 普通 tool ask | 它只是把 host verdict 装进 tool permission transport 的壳 |
| sandbox bridge cleanup = 198 的 request-level closeout | 这里是按 host 聚合的 sibling sweep |
| 一次 approve 只会 settle 一个 request | same-host pending asks 会被批量 resolve/remove |
| `unsubscribe()` / `cancelRequest(...)` 的主语还是单 ask | 它们在这条线上只是 host sweep 的部件 |

## 3. stable / conditional / gray

| 类型 | 对象 |
| --- | --- |
| 专题内稳定不变量 | same-host verdict 会触发 queue/filter/cleanup 的批量 sweep |
| 条件公开 | 只有 `BRIDGE_MODE` 且 bridgeCallbacks 存在时才会登记 `sandboxBridgeCleanupRef` |
| 内部/灰度层 | worker mailbox sandbox ask、focused dialog 展现、persist-to-settings 分支 |

## 4. 五个检查问题

- 我现在写的是单 ask closeout，还是 same-host sibling sweep？
- 我是不是把 `hostPattern.host` 当成了普通展示字段？
- 我是不是把 `sandboxBridgeCleanupRef` 误写成 request-id map？
- 我是不是把 `SandboxNetworkAccess` 误当成这条线的真正主语？
- 我是不是又回卷到 78 或 198 的主语了？

## 5. 源码锚点

- `claude-code-source-code/src/screens/REPL.tsx`
- `claude-code-source-code/src/cli/structuredIO.ts`
- `claude-code-source-code/src/hooks/toolPermission/handlers/interactiveHandler.ts`
