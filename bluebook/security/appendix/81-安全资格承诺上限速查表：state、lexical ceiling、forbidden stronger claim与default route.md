# 安全资格承诺上限速查表：state、lexical ceiling、forbidden stronger claim与default route

## 1. 这一页服务于什么

这一页服务于 [97-安全资格承诺上限：为什么每一种中间态都只能说到自己的ceiling，不能把pending说成active](../97-%E5%AE%89%E5%85%A8%E8%B5%84%E6%A0%BC%E6%89%BF%E8%AF%BA%E4%B8%8A%E9%99%90%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%E6%AF%8F%E4%B8%80%E7%A7%8D%E4%B8%AD%E9%97%B4%E6%80%81%E9%83%BD%E5%8F%AA%E8%83%BD%E8%AF%B4%E5%88%B0%E8%87%AA%E5%B7%B1%E7%9A%84ceiling%EF%BC%8C%E4%B8%8D%E8%83%BD%E6%8A%8Apending%E8%AF%B4%E6%88%90active.md)。

如果 `97` 的长文解释的是：

`为什么每种资格状态都只能说到自己的语言上限，`

那么这一页只做一件事：

`把不同 state 的 lexical ceiling、禁止更强说法与默认动作压成一张承诺矩阵。`

## 2. 安全资格承诺上限矩阵

| state | lexical ceiling | forbidden stronger claim | default route | 关键证据 |
| --- | --- | --- | --- | --- |
| `Remote Control active` | 可以说 active / continue coding | 不能在 reconnecting/failed 时说 active | 保持当前会话 | `bridgeStatusUtil.ts:135-140,148-150` |
| `Remote Control reconnecting` | 只能说 reconnecting | 不能说 active / recovered | 等待回连或提示相关恢复动作 | `bridgeStatusUtil.ts:135-139` |
| `Remote Control failed` | 只能说 failed | 不能说 reconnecting / active | 退出当前路径，进入诊断/重试 | `bridgeStatusUtil.ts:135-137` |
| `fresh-session-fallback` | 只能说 creating a fresh session instead | 不能说 resumed original session | 转 fresh session path | `bridgeMain.ts:2484-2487` |
| `retryable resumable` | 只能说 may still be resumable | 不能说 resumable for sure / already restored | 再次运行同一路径重试 | `bridgeMain.ts:2536-2539` |
| `needsRefresh` | 只能说 changed, run `/reload-plugins` to activate | 不能说 activated / active now | `/reload-plugins` | `useManagePlugins.ts:295-301` |
| MCP `connecting...` | 只能说 connecting | 不能说 connected | 等待 connect | `MCPListPanel.tsx:315-325` |
| MCP `reconnecting (...)...` | 只能说 reconnecting | 不能说 connected | 等待 reconnect budget 继续推进 | `MCPListPanel.tsx:315-323` |
| MCP `disabled` | 只能说 disabled | 不能说 pending / connecting | 先解除禁用 | `MCPListPanel.tsx:307-310`; `useManageMCPConnections.ts:821-823` |
| MCP `needs authentication` | 只能说 needs authentication | 不能说 connecting / available soon | 完成认证 | `MCPListPanel.tsx:327-329` |

## 3. 最短判断公式

看到一个状态文案时，先问五句：

1. 这个词是否超过了当前状态的 lexical ceiling
2. 它说的是 current fact，还是 future action
3. 它有没有把新资格伪装成旧资格
4. 它有没有把 blocked state 伪装成 waiting state
5. 它有没有把用户送向唯一默认动作

## 4. 最常见的五类越权文案

| 越权方式 | 会造成什么问题 |
| --- | --- |
| 把 reconnecting 说成 active | 用户在未恢复时按已恢复行动 |
| 把 fresh-session-fallback 说成 resume success | 新资格冒充旧资格 |
| 把 needsRefresh 说成 activated | 用户误判 plugin 已生效 |
| 把 disabled 说成 connecting | 用户错误等待系统自动恢复 |
| 把 may still be resumable 说成 resumable | 提前宣布未经验证的资格结论 |

## 5. 一条硬结论

对 Claude Code 这类安全控制面来说，  
真正成熟的不是：

`写出看起来顺滑的文案，`

而是：

`让每一条文案只说到当前状态真正配说的上限。`
