# `handleIngressMessage`、`isSDKControlResponse`、`isSDKControlRequest`、`onPermissionResponse` 与 `onControlRequest` 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/193-handleIngressMessage、isSDKControlResponse、isSDKControlRequest、onPermissionResponse 与 onControlRequest：为什么 bridge ingress 的 control side-channel 不是对称的通用 control 总线.md`
- `05-控制面深挖/29-Bridge Permission Callbacks、Control Request 与 Bridge-safe Commands：为什么远端的权限提示、会话控制与命令白名单不是同一种控制合同.md`
- `05-控制面深挖/191-handleIngressMessage、recentPostedUUIDs、recentInboundUUIDs 与 onInboundMessage：为什么 outbound echo drop、inbound replay guard 与 non-user ignore 不是同一种 ingress consumer contract.md`

边界先说清：

- 这页不是 control taxonomy 总页。
- 这页不是 gray runtime wiring 总页。
- 这页只抓 ingress control side-channel 进来之后的 callback 落点非对称。

## 1. 五层对象

| 对象 | 当前更像什么 | 关键位置 |
| --- | --- | --- |
| `isSDKControlResponse(...)` | permission verdict 返回腿的 type gate | `bridgeMessaging.ts` |
| `onPermissionResponse` | pending permission handler dispatcher | `useReplBridge.tsx` |
| `isSDKControlRequest(...)` | session-control 请求腿的 type gate | `bridgeMessaging.ts` |
| `onControlRequest` | generic control callback bus | `replBridge.ts` / `remoteBridgeCore.ts` |
| `handleServerControlRequest(...)` | `initialize`/`interrupt`/`set_*` 的 server-control executor | `bridgeMessaging.ts` |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `control_response` = `control_request` 的对称回腿 | ingress 里它只被落成 permission verdict 返回腿 |
| `onPermissionResponse` = 通用 control callback | 它只认带 `request_id` 的 pending permission 响应 |
| `onControlRequest` = 单纯 permission handler | 它是 session-control 请求腿，最后落到 `handleServerControlRequest(...)` |
| env-less 只是 v1 同款 wiring | env-less 还给 permission leg 套了 `reportState('running')` 修复壳 |

## 3. stable / conditional / gray

| 类型 | 对象 |
| --- | --- |
| 专题内稳定不变量 | `control_response -> onPermissionResponse` 与 `control_request -> onControlRequest` 两腿不对称 |
| 条件公开 | `onPermissionResponse` 只在 hook 注册了 pending permission handlers 时才有实际消费者 |
| 内部/灰度层 | env-less permission leg 额外 `reportState('running')`，`outboundOnly` 只影响 control-request executor |

## 4. 五个检查问题

- 我现在写的是 control object taxonomy，还是 ingress callback 落点？
- 我是不是把 `control_response` 误写成 generic control reply bus？
- 我是不是把 `onPermissionResponse` 和 `onControlRequest` 压成一条 callback 通道？
- 我是不是把 env-less 的 `running` wrapper 忽略掉了？
- 我是不是又回卷到 29、142 或 191 的主语了？

## 5. 源码锚点

- `claude-code-source-code/src/bridge/bridgeMessaging.ts`
- `claude-code-source-code/src/bridge/replBridge.ts`
- `claude-code-source-code/src/bridge/remoteBridgeCore.ts`
- `claude-code-source-code/src/bridge/initReplBridge.ts`
- `claude-code-source-code/src/hooks/useReplBridge.tsx`
