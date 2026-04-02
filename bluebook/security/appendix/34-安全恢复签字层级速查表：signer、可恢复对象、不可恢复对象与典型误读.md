# 安全恢复签字层级速查表：signer、可恢复对象、不可恢复对象与典型误读

## 1. 这一页服务于什么

这一页服务于 [50-安全恢复签字层级：哪些证据只够清通知，哪些才够恢复动作、卡片与主结论](../50-%E5%AE%89%E5%85%A8%E6%81%A2%E5%A4%8D%E7%AD%BE%E5%AD%97%E5%B1%82%E7%BA%A7%EF%BC%9A%E5%93%AA%E4%BA%9B%E8%AF%81%E6%8D%AE%E5%8F%AA%E5%A4%9F%E6%B8%85%E9%80%9A%E7%9F%A5%EF%BC%8C%E5%93%AA%E4%BA%9B%E6%89%8D%E5%A4%9F%E6%81%A2%E5%A4%8D%E5%8A%A8%E4%BD%9C%E3%80%81%E5%8D%A1%E7%89%87%E4%B8%8E%E4%B8%BB%E7%BB%93%E8%AE%BA.md)。

如果 `50` 的长文解释的是：

`为什么恢复证据必须分层签字，低层 signal 不能越级恢复高层结论，`

那么这一页只做一件事：

`把 signer、可恢复对象、不可恢复对象和典型误读压成一张可直接拿去做产品评审和宿主对齐的矩阵。`

## 2. 恢复签字层级矩阵

| signer 层级 | 典型来源 | 可恢复对象 | 不可恢复对象 | 最危险误读 | 关键证据 |
| --- | --- | --- | --- | --- | --- |
| L0 活性 signer | `connected`、`active`、`stateLabel`、`no error` | 表层存活提示、部分 transport 类通知 | 主卡乐观文案、依赖读回的动作、主结论 | “connected = 一切恢复” | `replBridgeTransport.ts:289-299`、`BridgeDialog.tsx:137-156`、`bridgeStatusUtil.ts:123-144` |
| L1 restore signer | `state_restored`、`restoredWorkerState`、restore+hydrate 正确排序 | stale residue 告警、某些“旧状态已接回”的卡片 | 完整动作集、最高层完成结论 | “旧状态接回 = 当前已 fresh” | `ccrClient.ts:474-522`、`remoteIO.ts:126-167`、`structuredIO.ts:139-142`、`print.ts:5050-5055` |
| L2 state signer | `reportState(...)`、`session_state_changed(running/requires_action/idle)` | 会话阶段卡片、阶段相关动作、某些 requires_action/idle 提示 | 持久化副作用结论、宿主盲区完全撤销 | “idle = 所有后效应都已完成” | `remoteIO.ts:159-167`、`sdkEventQueue.ts:56-66`、`print.ts:818` |
| L3 effect signer | `files_persisted` 等独立副作用完成信号 | 文件落盘类文案、依赖副作用完成的动作 | 解释权限最高层结论、宿主盲区总告警 | “副作用完成 = 解释账本完整” | `print.ts:2261-2267` |
| L4 explanation signer | 账本补齐、blindspot 缩小、`completion_claim_ceiling` 回升、读写链满足当前结论所需强度 | 主结论、完整动作集、最高层宿主盲区告警撤销 | 无；这是最高恢复签字层 | “任何低层绿灯都能替它签字” | `47`、`48`、`49`、`50` 主线归纳 |

## 3. 最短判断公式

评审任一“恢复”文案或动作放开时，先问四句：

1. 这个恢复对象属于通知、卡片、动作，还是主结论
2. 当前 signer 属于活性、restore、state、effect，还是 explanation
3. 这个 signer 是否与被恢复对象同阶
4. 如果把它越级使用，最先误导的动作是什么

## 4. 最常见的四类 signer 越级错误

| 越级错误 | 会造成什么问题 |
| --- | --- |
| 用 `connected/active` 恢复主结论 | 用户把写通路恢复误读成解释权恢复 |
| 用 `state_restored` 恢复完整动作集 | 用户把旧状态接回误读成当前状态已 fresh |
| 用 `idle` 恢复落盘/持久层结论 | 用户看不到 result 与副作用仍可分离 |
| 用 `files_persisted` 撤销全部宿主盲区告警 | 用户把副作用完成误读成账本完整、读链完整 |

## 5. 一条硬结论

对 Claude Code 这类多账本、多宿主控制面来说，  
最危险的不是 signer 太少，  
而是：

`明明已有多层 signer，却仍让最弱的绿色信号越级替最高层恢复结论签字。`
