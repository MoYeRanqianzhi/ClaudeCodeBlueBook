# 安全失效边界复活禁令速查表：stale object、revival path、current guard与boundary consequence

## 用途

这张表把 `84-安全失效边界复活禁令` 压成工程评审可直接使用的矩阵。  
核心不是问“现在是不是有旧状态”，而是问：

`这个旧对象有没有机会被重新认证成 current boundary。`

## 速查矩阵

| stale object | revival path | current guard | why guard exists | boundary consequence if missed | evidence |
| --- | --- | --- | --- | --- | --- |
| in-flight stale v2 transport / handshake | reconnect 后晚到接入 | `v2Generation++` 使旧世代失效 | 防止旧 transport 继续指向 dead session | 旧通道重新挂回当前控制面 | `src/bridge/replBridge.ts:617-623` |
| `stopWork` 前持有的旧 `currentWorkId` | await 期间 poll loop 已恢复却继续 archive | 比对 `currentWorkId !== workIdBeingCleared` 后直接 return | 避免把新 transport 正连接的 session 销毁 | 新边界被旧修复流程误杀 | `src/bridge/replBridge.ts:653-673` |
| 重新注册环境前的旧 reconnect 分支 | `registerBridgeEnvironment` 后仍继续走 reconnect/archive | 若 `transport !== null` 则直接让位 | 新边界已形成时，旧流程不再配处理它 | 新边界被旧 cleanup 分支杀死 | `src/bridge/replBridge.ts:718-727` |
| orphaned old session | fresh session fallback 后仍被当 current | `archiveSession(currentSessionId)` | 明确宣布旧 session 已撤销当前资格 | 旧 session 悬空却继续像当前对象存在 | `src/bridge/replBridge.ts:743-748` |
| crash-recovery pointer 的旧 `{sessionId, environmentId}` | hourly timer 与 reconnect 并发写回旧 pointer | `if (reconnectPromise) return` | 防止 old pointer 覆盖 new pointer | 已归档旧 session 被重新写成当前恢复入口 | `src/bridge/replBridge.ts:1512-1524` |
| server 已不存在的 resumed session | next launch 继续拿 stale pointer 做 resume | `clearBridgePointer(resumePointerDir)` | 不让不存在的 session 被再次承诺可恢复 | 用户被重复导向失效边界 | `src/bridge/bridgeMain.ts:2385-2398` |
| fatal reconnect failure 后的旧 pointer | fatal 后仍保留 resume 入口 | fatal 时清 pointer，transient 时保留 | 区分 retryable boundary 与 dead boundary | 死边界保留成“可恢复”入口 | `src/bridge/bridgeMain.ts:2524-2534` |
| shutdown 后的旧 session / env | 先打印 resume，再 archive+deregister | resumable single-session path 直接 return；否则 archive+deregister 并清 pointer | 恢复入口必须与真实可恢复性一致 | resume command 变成 lie，错误授权继续存在 | `src/bridge/bridgeMain.ts:1515-1577` |

## 最短规则

1. stale object 不等于安全风险，stale object 被重新写成 current 才是。
2. archive / revoke / expire 之后的对象，默认应被视为不可逆失效对象。
3. 每个 await 后都要重新确认“我要处理的还是不是当前边界”。
4. pointer、resume token、retry handle 都是资格对象，不只是缓存。
5. 任何恢复入口如果已不再真实，就必须被清除，否则它本身就是错误授权。
