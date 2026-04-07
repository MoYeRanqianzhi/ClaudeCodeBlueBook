# `cancelRequest`、`onResponse` unsubscribe、`pendingPermissionHandlers.delete` 与 leader queue recheck 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/198-cancelRequest、onResponse unsubscribe、pendingPermissionHandlers.delete 与 leader queue recheck：为什么 bridge permission race 的 prompt 撤场、订阅退役、响应消费与策略重判不是同一种收口合同.md`
- `05-控制面深挖/196-pendingPermissionHandlers、BridgePermissionCallbacks、request_id、handlePermissionResponse 与 isBridgePermissionResponse：为什么 bridge permission race 的 verdict ledger 不是 generic control callback ownership.md`

边界先说清：

- 这页不是 pending verdict ledger 总页。
- 这页不是 generic control closeout 总页。
- 这页只抓 permission race 判完之后的四层 closeout contract。

## 1. 四层收口

| 对象 | 当前更像什么 | 关键位置 |
| --- | --- | --- |
| `cancelRequest(...)` | 远端 stale prompt 撤场 | `interactiveHandler.ts` / `REPL.tsx` |
| `onResponse(...)` unsubscribe | 本地 subscription 退役 | `interactiveHandler.ts` / `bridgePermissionCallbacks.ts` |
| `pendingPermissionHandlers.delete(...)` | late response 到场后的本地账出清 | `useReplBridge.tsx` |
| leader queue recheck | 策略变化后的旧等待窗重判 | `useReplBridge.tsx` |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `claim()` = 所有 closeout 一起完成 | `claim()` 只关 verdict 主权 |
| `cancelRequest` = unsubscribe | 一个关远端 prompt，一个退本地订阅 |
| `pendingPermissionHandlers.delete` = 本地赢时立刻发生 | 常见本地赢路径下它往往要等晚到 `control_response` 才发生 |
| queue recheck = callback cleanup | 它关的是旧策略等待窗，不是 transport subscription |

## 3. stable / conditional / gray

| 类型 | 对象 |
| --- | --- |
| 专题内稳定不变量 | prompt 撤场、订阅退役、响应消费、策略重判是四种不同收口 |
| 条件公开 | `cancelRequest(...)` 只有 bridgeCallbacks + requestId 存在时才会触发 |
| 内部/灰度层 | remote worker / inbox poller 的 `recheckPermission()` 为 no-op，不共享这套 closeout |

## 4. 五个检查问题

- 我现在写的是 verdict 主权，还是判完之后的收口动作？
- 我是不是把 `cancelRequest(...)` 和 unsubscribe 写成了一件事？
- 我是不是误以为 `pendingPermissionHandlers.delete(...)` 会在本地赢时同步发生？
- 我是不是把 leader queue recheck 误写成 callback cleanup？
- 我是不是又回卷到 196 的主语了？

## 5. 源码锚点

- `claude-code-source-code/src/hooks/toolPermission/PermissionContext.ts`
- `claude-code-source-code/src/hooks/toolPermission/handlers/interactiveHandler.ts`
- `claude-code-source-code/src/hooks/useReplBridge.tsx`
- `claude-code-source-code/src/bridge/bridgePermissionCallbacks.ts`
- `claude-code-source-code/src/screens/REPL.tsx`
