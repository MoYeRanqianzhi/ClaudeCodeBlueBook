# 安全能力恢复主权速查表：surface、restoration authority、regrant path与forbidden premature return

## 1. 这一页服务于什么

这一页服务于 [73-安全能力恢复主权：为什么不是任何层都能把已撤回入口重新恢复为可见可用](../73-%E5%AE%89%E5%85%A8%E8%83%BD%E5%8A%9B%E6%81%A2%E5%A4%8D%E4%B8%BB%E6%9D%83%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%E4%B8%8D%E6%98%AF%E4%BB%BB%E4%BD%95%E5%B1%82%E9%83%BD%E8%83%BD%E6%8A%8A%E5%B7%B2%E6%92%A4%E5%9B%9E%E5%85%A5%E5%8F%A3%E9%87%8D%E6%96%B0%E6%81%A2%E5%A4%8D%E4%B8%BA%E5%8F%AF%E8%A7%81%E5%8F%AF%E7%94%A8.md)。

如果 `73` 的长文解释的是：

`为什么能力恢复本质上是重新授权，`

那么这一页只做一件事：

`把不同 surface 的 restoration authority、regrant path 与 forbidden premature return 压成一张恢复矩阵。`

## 2. 能力恢复主权矩阵

| surface | restoration authority | regrant path | 恢复前中间态 | forbidden premature return | 关键证据 |
| --- | --- | --- | --- | --- | --- |
| MCP server re-enable | config + reconnect authority | `setMcpServerEnabled(true)` -> `pending` -> `reconnectMcpServerImpl()` | `pending` | 仅因用户点击或局部状态变化就直接说 “available” | `useManageMCPConnections.ts:1073-1123` |
| 新 config / plugin / claude.ai server 回归 UI | config authority | 重新进入 `newClients`，先加入 `mcp.clients` 再走连接链 | `pending` / `disabled` | 未重新纳入有效配置集合就先恢复入口 | `useManageMCPConnections.ts:814-836,923-940` |
| project MCP server | approval authority + policy authority | 重新变成 `approved`，并通过 merged config 的 policy filter | `pending` / not in merged config | 仅因配置文件仍在就当成能力恢复 | `mcp/utils.ts:351-372`、`mcp/config.ts:1164-1188,1231-1248` |
| plugin commands / agents / MCP / LSP | plugin refresh authority | `/reload-plugins` -> `refreshActivePlugins()` -> full reload/rebuild | `needsRefresh` | 由通知层、自发 reset 或局部 cache 回暖直接宣布恢复 | `useManagePlugins.ts:287-303`、`refresh.ts:72-152` |
| channel capability / notifications | allowlist authority + `gateChannelServer` | append allowlist entry -> re-run gate -> success 才正式注册 | tentative allowlist append | gate 未通过前就让按钮/能力重新出现 | `print.ts:1666-1688,4708-4728` |

## 3. 最短判断公式

看到任一被撤回的入口准备回来时，先问四句：

1. 当前是谁有资格重新授予它
2. 这次恢复经过的是正式 regrant path，还是局部回暖错觉
3. 当前还处在 `pending / needsRefresh / tentative` 哪种中间态
4. 如果现在过早把它说成“已恢复”，会制造哪种错误承诺

## 4. 最常见的五类提前恢复

| 提前恢复 | 会造成什么问题 |
| --- | --- |
| MCP server 刚从 disabled 改回 enabled 就直接说可用 | 跳过 reconnect 成功这一正式恢复链 |
| config 刚回归就立即暴露完整入口 | 忽略 pending / disabled 中间态 |
| project config 文件仍在就视作 server 已恢复 | 把 approval 缺席误读成 capability 回归 |
| `needsRefresh` 还没消费就说 plugin 能力已恢复 | 用局部文件变更冒充正式重建 |
| allowlist 刚 append 但 gate 还没过就亮按钮 | 让恢复动作失去 rollback 余地 |

## 5. 一条硬结论

对 Claude Code 这类安全控制面来说，  
真正成熟的不是“入口又出现了”，  
而是：

`它是被哪条重新授权链正式放回来的。`
