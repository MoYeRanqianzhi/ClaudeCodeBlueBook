# 安全真相状态机速查表：state family、entry condition、stay condition、exit operator与authoritative signer

## 1. 这一页服务于什么

这一页服务于 [131-安全真相状态机：为什么Claude Code不是在维护一堆散点规则，而是在维护可进入、可续签、可降级、可恢复、可终止的安全状态机](../131-%E5%AE%89%E5%85%A8%E7%9C%9F%E7%9B%B8%E7%8A%B6%E6%80%81%E6%9C%BA%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88Claude%20Code%E4%B8%8D%E6%98%AF%E5%9C%A8%E7%BB%B4%E6%8A%A4%E4%B8%80%E5%A0%86%E6%95%A3%E7%82%B9%E8%A7%84%E5%88%99%EF%BC%8C%E8%80%8C%E6%98%AF%E5%9C%A8%E7%BB%B4%E6%8A%A4%E5%8F%AF%E8%BF%9B%E5%85%A5%E3%80%81%E5%8F%AF%E7%BB%AD%E7%AD%BE%E3%80%81%E5%8F%AF%E9%99%8D%E7%BA%A7%E3%80%81%E5%8F%AF%E6%81%A2%E5%A4%8D%E3%80%81%E5%8F%AF%E7%BB%88%E6%AD%A2%E7%9A%84%E5%AE%89%E5%85%A8%E7%8A%B6%E6%80%81%E6%9C%BA.md)。

如果 `131` 的长文解释的是：

`为什么 Claude Code 的安全控制面更接近多组安全状态机，`

那么这一页只做一件事：

`把主要 state family 的 entry condition、stay condition、exit operator 与 authoritative signer 压成一张矩阵。`

## 2. 状态机矩阵

| state family | entry condition | stay condition | exit operator | authoritative signer | 关键证据 |
| --- | --- | --- | --- | --- | --- |
| permission mode family | 合法 mode transition；进入 `auto` 前 gate 已开启 | classifier/auto active 仍成立；`plan` 上下文未被清理 | `de-scope` on auto entry；`restore` on auto exit | `transitionPermissionMode(...)` | `permissionSetup.ts:597-645` |
| managed settings review family | 检测到 dangerous settings 且发生变化；交互模式允许审查 | 等待用户批准/拒绝，或无须审查 | `approve` / `reject` / skip；`rejected` 触发 shutdown | `checkManagedSettingsSecurity(...)` + `handleSecurityCheckResult(...)` | `securityCheck.tsx:12-22,33-35,67-72` |
| MCP connection family | config 已启用且开始连接尝试 | auth freshness、连接健康、重连窗口与 policy 仍成立 | `needs-auth` / `failed` / `disabled` / reconnect | `connectToServer(...)` / `handleRemoteAuthFailure(...)` / connection dispatch | `coreSchemas.ts:167-173`; `mcp/types.ts:194-226`; `mcp/client.ts:337-360,2308-2333` |
| step-up authorization family | 观察到 `403 insufficient_scope`，且 scope 确实未覆盖 | `_pendingStepUpScope` 仍未被更高授权完成清除 | `step-up` 到 PKCE flow；禁止 refresh 假升级 | `wrapFetchWithStepUpDetection(...)` + `markStepUpPending(...)` + `tokens()` | `mcp/auth.ts:1345-1353,1388-1390,1461-1470,1625-1650` |
| remote settings freshness family | remote settings eligible；fetch/304/stale cache 任一成立 | freshness 仍被 304、成功 fetch 或允许的 stale cache 支撑 | `degrade` 到 stale；`fail-open` 到 null；新 fetch 覆写旧真相 | `fetchAndLoadRemoteManagedSettings()` | `remoteManagedSettings/index.ts:415-501` |
| bridge session lease family | auth、GB gate、min version、org policy 全部通过；会话成功启动 | JWT 被续签；environment 未过 TTL；pointer 定期刷新 | proactive refresh / reconnect；fatal expiry；resume 失效 | `cli.tsx` 入口链 + `bridgeMain.ts` token/pointer scheduler | `cli.tsx:132-159`; `bridgeMain.ts:279-300,1195-1201,1517-1521,2700-2728` |
| trusted device lease family | 设备 enrollment 发生在 fresh login 10 分钟窗口内 | gate 打开且 token 未过 rolling expiry | token 清理、重新 enrollment、过期失效 | `enrollTrustedDevice()` + secure storage gate | `trustedDevice.ts:15-31,54-59,65-97` |

## 3. 最短判断公式

判断一段安全逻辑是不是状态机，而不是散点规则，先问五句：

1. 它是不是存在一组稳定 state family
2. 这些状态有没有明确的 entry condition
3. 它们有没有 stay condition 或续签义务
4. 它们退出时用的是哪种 operator
5. 谁才是这组状态的 authoritative signer

## 4. 最常见的四类误读

| 误读 | 实际问题 |
| --- | --- |
| 把状态机误读成一堆 if/else | 看不见 family、transition 与 signer |
| 只看 entry，不看 stay | 看不见 lease 与续签义务 |
| 把退出都压成 generic fail | 看不见 `needs-auth`、`pending`、`degrade`、`restore` 的差异 |
| 认为任何 surface 都能解释当前状态 | 看不见状态解释权其实也是主权对象 |

## 5. 一条硬结论

Claude Code 的安全控制面真正先进的地方不是：

`状态很多，`

而是：

`它已经在多个关键模块里把安全真相做成了有进入门、驻留门、退出算子与签字者的运行时状态机。`

