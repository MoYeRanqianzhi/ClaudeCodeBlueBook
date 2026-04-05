# 安全资格字段升级阈值与撤场条件速查表：signal、upgrade threshold、stay condition与retire trigger

## 1. 这一页服务于什么

这一页服务于 [106-安全资格字段升级阈值与撤场条件：为什么字段不只要有优先级，还必须有明确的升级条件与退场条件](../106-%E5%AE%89%E5%85%A8%E8%B5%84%E6%A0%BC%E5%AD%97%E6%AE%B5%E5%8D%87%E7%BA%A7%E9%98%88%E5%80%BC%E4%B8%8E%E6%92%A4%E5%9C%BA%E6%9D%A1%E4%BB%B6%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%E5%AD%97%E6%AE%B5%E4%B8%8D%E5%8F%AA%E8%A6%81%E6%9C%89%E4%BC%98%E5%85%88%E7%BA%A7%EF%BC%8C%E8%BF%98%E5%BF%85%E9%A1%BB%E6%9C%89%E6%98%8E%E7%A1%AE%E7%9A%84%E5%8D%87%E7%BA%A7%E6%9D%A1%E4%BB%B6%E4%B8%8E%E9%80%80%E5%9C%BA%E6%9D%A1%E4%BB%B6.md)。

如果 `106` 的长文解释的是：

`字段治理本质上是生命周期协议，`

那么这一页只做一件事：

`把关键 signal 的升级门槛、在场条件、退场触发器与过早退场风险压成一张矩阵。`

## 2. 安全资格字段生命周期矩阵

| signal | upgrade threshold | stay condition | retire trigger | 若退场过早会怎样 | 关键证据 |
| --- | --- | --- | --- | --- | --- |
| immediate notification | 新 signal 被声明为 `priority: immediate` | timeout 未到，未被更强 invalidation 驱逐 | `timeoutMs` 到期，或被 `invalidates` 驱逐 | 高风险断点被提前静音 | `notifications.tsx:78-116,172-185,230-238` |
| folded notification | 同 key 新版本到来并满足 `fold` | 折叠后的新版本继续占位 | folded timeout 到期，或后续 invalidation/remove | 旧版本残留，形成重复真相 | `notifications.tsx:121-169` |
| bridge failed | 明确进入 failed 分支，或 init 异常成立 | 失败窗口仍在，replBridgeError 仍成立 | `BRIDGE_FAILURE_DISMISS_MS` 后 auto-disable，或更强成功信号覆盖 | 用户继续在错误世界里盲目重试 | `useReplBridge.tsx:28-40,102-127,339-362,623-644` |
| bridge failure fuse | 连续 init failure 达到 `MAX_CONSECUTIVE_INIT_FAILURES=3` | 会话仍停留在 unrecoverable path | 手动重启会话生命周期 | 持续制造无意义 401 / retry 风暴 | `useReplBridge.tsx:31-40,113-127` |
| bridge connected | `handle_0` 初始化成功，URL / session / env bundle 到位 | handle 仍有效，connected truth 未被 failed/reconnecting 覆盖 | 进入 reconnecting / failed，或 teardown | 用户把“尝试连接”误当“已连接” | `useReplBridge.tsx:518-614` |
| plugin-reload-pending | `needsRefresh` 成立，磁盘态与运行态分离 | full refresh 尚未完成 | `refreshActivePlugins()` 真正完成并置 `needsRefresh=false` | 运行态仍旧却假装已经同步 | `useManagePlugins.ts:287-303`; `refresh.ts:59-67,123-138` |
| crash-recovery pointer | pointer 写入成功且 freshness 仍在 TTL 内 | mtime 持续续保，schema 仍合法，fatal revocation 未发生 | schema invalid、TTL stale、fatal resume failure、fresh start without continue、archive+deregister clean shutdown | 旧边界继续假装可恢复，或真正可恢复边界被误删 | `bridgePointer.ts:57-60,77-112`; `bridgeMain.ts:1515-1577,2316-2325,2384-2403,2473-2534` |
| resumable shutdown hint | single-session + known session + `!fatalExit` | 环境仍故意保持可 resume | 后续 clean archive+deregister 或 fatal revocation | 把仍可恢复边界误杀成不可恢复 | `bridgeMain.ts:1515-1537` |
| transient reconnect failure pointer | reconnect 失败但未到 fatal | retry path 仍然成立 | 后续 fatal，或下一次成功 resume / clean shutdown | 用户失去重试入口 | `bridgeMain.ts:2524-2534` |
| MCP stale connected client | config hash changed / server removed 且该 client 当前为 stale connected | 旧 timer 已停，cleanup 正在进行，新 config 尚未 fully takeover | clear timer + `clearServerCache()` + 新 config client 入场 | 旧 closure 反向复活，和新连接打架 | `useManageMCPConnections.ts:791-825` |

## 3. 最短判断公式

看到某个字段正在“升级”或“消失”时，先问五句：

1. 它跨过了什么证据门槛才配升级
2. 它现在靠什么条件继续留场
3. 它的退场是因为 timeout、completion、invalidation 还是 revocation
4. 谁拥有它的退场权
5. 如果它现在退场，会不会把旧世界伪装成已解决

## 4. 最常见的五类生命周期错误

| 错误方式 | 会造成什么问题 |
| --- | --- |
| 只设计 priority，不设计 upgrade threshold | 弱证据过早升级成强断点 |
| 只设计出现，不设计 stay condition | 字段在场资格无法解释 |
| 只设计 timeout，不设计 invalidation 关系 | 新旧真相并排共存 |
| 让局部组件随手清掉全局控制字段 | 错主语撤销当前边界 |
| 把 transient failure 与 fatal failure 同样清理 | 可恢复路径被误杀 |

## 5. 一条硬结论

对安全控制面来说，  
真正成熟的不是：

`谁优先显示，`

而是：

`谁在什么门槛下升级、在什么条件下留场、以及在什么触发器下必须由正确主语撤场。`
