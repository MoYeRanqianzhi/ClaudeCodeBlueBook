# `pendingPermissionHandlers`、`BridgePermissionCallbacks`、`request_id`、`handlePermissionResponse` 与 `isBridgePermissionResponse` 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/196-pendingPermissionHandlers、BridgePermissionCallbacks、request_id、handlePermissionResponse 与 isBridgePermissionResponse：为什么 bridge permission race 的 verdict ledger 不是 generic control callback ownership.md`
- `05-控制面深挖/29-Bridge Permission Callbacks、Control Request 与 Bridge-safe Commands：为什么远端的权限提示、会话控制与命令白名单不是同一种控制合同.md`
- `05-控制面深挖/193-handleIngressMessage、isSDKControlResponse、isSDKControlRequest、onPermissionResponse 与 onControlRequest：为什么 bridge ingress 的 control side-channel 不是对称的通用 control 总线.md`

边界先说清：

- 这页不是 control taxonomy 总页。
- 这页不是 control side-channel 总页。
- 这页只抓 permission race 内部的本地 verdict ledger 与 `request_id` ownership。

## 1. 五层对象

| 对象 | 当前更像什么 | 关键位置 |
| --- | --- | --- |
| `BridgePermissionCallbacks` | permission race 的 RPC-like surface | `bridgePermissionCallbacks.ts` |
| `pendingPermissionHandlers` | 本地挂起 verdict ledger | `useReplBridge.tsx` |
| `request_id` | race request 的 correlation key | `useReplBridge.tsx` |
| `handlePermissionResponse(...)` | verdict ledger drain 点 | `useReplBridge.tsx` |
| `isBridgePermissionResponse(...)` | permission verdict payload gate | `bridgePermissionCallbacks.ts` |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `pendingPermissionHandlers` = generic control callback registry | 它只服务 bridge permission race 的挂起 verdict |
| `request_id` = 任意 control frame 的统一标识 | 在这里它是 permission request/response 的相关键 |
| `handlePermissionResponse(...)` = 通用 `control_response` dispatcher | 它只认已挂起的 permission handler，且只吃合法 permission verdict |
| `onResponse(...)` = 永久订阅 | 它注册的是一次性 race handler，并返回 unsubscribe |

## 3. stable / conditional / gray

| 类型 | 对象 |
| --- | --- |
| 专题内稳定不变量 | `pendingPermissionHandlers` 是 bridge permission race 的本地 ledger，而非 generic registry |
| 条件公开 | 只有 non-outboundOnly 且 hook 建立了 `replBridgePermissionCallbacks` 时这张 ledger 才存在 |
| 内部/灰度层 | bridge prompt UI、leader queue、race cancel/timeout 的更宽交互面不在本页主语内 |

## 4. 五个检查问题

- 我现在写的是 control callback 总面，还是 permission race 的本地 ledger？
- 我是不是把 `request_id` 写成 generic control correlation id？
- 我是不是把 `handlePermissionResponse(...)` 误写成通用 `control_response` 分发器？
- 我是不是忽略了 `isBridgePermissionResponse(...)` 的 payload gate？
- 我是不是又回卷到 29 或 193 的主语了？

## 5. 源码锚点

- `claude-code-source-code/src/hooks/useReplBridge.tsx`
- `claude-code-source-code/src/bridge/bridgePermissionCallbacks.ts`
