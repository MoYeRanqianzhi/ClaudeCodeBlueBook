# 安全完成差异清除纪律速查表：旧结论类型、允许清除的fresh证据与禁止抢先恢复的动作

## 1. 这一页服务于什么

这一页服务于 [49-安全完成差异清除纪律：为什么宿主盲区恢复时不能先删告警，必须等fresh回读撤销旧结论](../49-%E5%AE%89%E5%85%A8%E5%AE%8C%E6%88%90%E5%B7%AE%E5%BC%82%E6%B8%85%E9%99%A4%E7%BA%AA%E5%BE%8B%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%E5%AE%BF%E4%B8%BB%E7%9B%B2%E5%8C%BA%E6%81%A2%E5%A4%8D%E6%97%B6%E4%B8%8D%E8%83%BD%E5%85%88%E5%88%A0%E5%91%8A%E8%AD%A6%EF%BC%8C%E5%BF%85%E9%A1%BB%E7%AD%89fresh%E5%9B%9E%E8%AF%BB%E6%92%A4%E9%94%80%E6%97%A7%E7%BB%93%E8%AE%BA.md)。

如果 `49` 的长文解释的是：

`为什么宿主盲区恢复时不能先删旧告警，而必须等待足够强的fresh证据，`

那么这一页只做一件事：

`把旧结论类型、允许清除的fresh证据、允许恢复的对象层级和禁止抢先恢复的动作压成一张矩阵。`

## 2. 清除纪律矩阵

| 旧结论 / 旧告警 | 禁止依赖的弱信号 | 允许清除的 fresh 证据 | 允许先恢复什么 | 绝不能先恢复什么 | 关键证据 |
| --- | --- | --- | --- | --- | --- |
| recovery window 打开 | transport 看起来已连上、局部 UI 又能刷新 | recovery 窗口关闭且完成一次 fresh 回读 / authoritative state 同步 | 次级说明文本 | 主卡“已恢复”结论、依赖完整回读的动作 | `remoteBridgeCore.ts:824-879`、`sdkEventQueue.ts:56-66` |
| bridge fail / remote control failed | status label 从 failed 变成 connecting/connected | 相关 bridge state 稳定、必要回读完成、旧 error 不再存在 | 非关键说明、调试字段 | 远程控制主动作、完整完成结论 | `useReplBridge.tsx:102-111`、`BridgeDialog.tsx:137-256` |
| `completion_claim_ceiling` 已下调 | “当前没再报错了”、某个局部 host label 变绿 | ceiling 回升且其所依赖的缺失账本 / signer 真正恢复 | 局部提示文本 | 主卡完成结论、被下调时关掉的动作入口 | `49` 主线归纳 |
| `missing_ledgers[]` 已声明 | connected、active、ready 这类表面连接词 | 对应账本重新可见，且解释链 fresh 验证通过 | 次级帮助文案 | 任何依赖该账本解释权的动作 | `structuredIO.ts:140-141`、`print.ts:5048-5055`、`49` 主线归纳 |
| stale `pending_action` / `task_summary` | 旧进程退出、新进程启动 | 新 worker init 成功且 stale metadata 被显式清空 | 旧 crash 残留告警 | 基于旧 metadata 推导出的恢复结论 | `ccrClient.ts:474-522` |
| “会话已结束 / 已空闲”相关旧结论 | result 已到、某个局部队列已空 | `session_state_changed(idle)` authoritative 到达；必要时 `files_persisted` 已到 | 低风险提示 | turn-over 结论、依赖完整结束的动作切换 | `sdkEventQueue.ts:56-66`、`print.ts:2261-2267` |
| IDE disconnected | 旧 selection 仍在界面缓存、IDE 名称仍可见 | IDE 状态回到 connected，selection/host state fresh 回读成功 | selection 辅助提示 | 强依赖 IDE selection 的动作 | `useIdeConnectionStatus.ts:11-32`、`IdeStatusIndicator.tsx:18-55`、`useIDEStatusIndicator.tsx:87-92` |
| MCP failed / needs-auth | 某些 server 数量减少、提示暂时消失 | 对应 server 真正回到 connected，且当前动作链重新成立 | 总览计数文案 | 依赖该 MCP server 的默认动作路径 | `useMcpConnectivityStatus.tsx:36-63`、`status.tsx:89-114` |
| channels blocked / policy gate | 本地 UI 重新可点击、某个缓存状态未更新 | gate 消失且认证 / org policy / managed settings fresh 生效 | 次级解释文本 | 相关 channels 动作入口 | `useManageMCPConnections.ts:596-610` |
| flagged plugins | 旧 toast 超时消失 | flagged 状态被处理、插件刷新完成、相关能力 fresh 装载 | 维护提示 | 默认继续使用原插件路径 | `useManagePlugins.ts:59-67,294-300` |

## 3. 三条最短判断句

做清除评审时，先问三句：

1. 这是不是只是“表面恢复”，而不是“原因链恢复”
2. 这条旧结论依赖的 signer / ledger / persist 层有没有真的回来
3. 如果现在先把动作放开，最先会误导哪一步

## 4. 最常见的四类抢先恢复错误

| 抢先恢复错误 | 后果 |
| --- | --- |
| 连接一恢复就删掉 recovery 告警 | 用户会把 transport 恢复误读成解释权恢复 |
| result 一到就恢复 completed 文案 | 用户看不到 `files_persisted` 和 authoritative idle 仍未到 |
| 旧 toast 超时后默认当问题已消失 | 时间流逝替代了真正恢复证据 |
| 卡片先改口、动作先放开，回读最后才来 | 控制面会先说乐观谎言，证据反而落后 |

## 5. 一条硬结论

对 Claude Code 这类多账本、多宿主控制面来说，  
最危险的不是恢复太慢，  
而是：

`本该由fresh回读、fresh hydrate、authoritative idle 或账本补齐来签字的恢复，却被一个更弱的表面信号提前签了字。`
