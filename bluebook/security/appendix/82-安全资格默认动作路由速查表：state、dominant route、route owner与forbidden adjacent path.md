# 安全资格默认动作路由速查表：state、dominant route、route owner与forbidden adjacent path

## 1. 这一页服务于什么

这一页服务于 [98-安全资格默认动作路由：为什么每一种资格状态都必须绑定唯一dominant-route，而不能把修复选择权外包给用户](../98-%E5%AE%89%E5%85%A8%E8%B5%84%E6%A0%BC%E9%BB%98%E8%AE%A4%E5%8A%A8%E4%BD%9C%E8%B7%AF%E7%94%B1%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%E6%AF%8F%E4%B8%80%E7%A7%8D%E8%B5%84%E6%A0%BC%E7%8A%B6%E6%80%81%E9%83%BD%E5%BF%85%E9%A1%BB%E7%BB%91%E5%AE%9A%E5%94%AF%E4%B8%80dominant-route%EF%BC%8C%E8%80%8C%E4%B8%8D%E8%83%BD%E6%8A%8A%E4%BF%AE%E5%A4%8D%E9%80%89%E6%8B%A9%E6%9D%83%E5%A4%96%E5%8C%85%E7%BB%99%E7%94%A8%E6%88%B7.md)。

如果 `98` 的长文解释的是：

`为什么每种资格状态都应绑定唯一默认动作，`

那么这一页只做一件事：

`把不同 state 的 dominant route、所属控制域与禁止近邻错路压成一张路由矩阵。`

## 2. 安全资格默认动作路由矩阵

| state | dominant route | route owner | forbidden adjacent path | 关键证据 |
| --- | --- | --- | --- | --- |
| plugin `needsRefresh` | `/reload-plugins` | plugin activation control plane | 等待系统自动生效 / 误判已激活 | `useManagePlugins.ts:293-301`; `usePluginAutoupdateNotification.tsx:60-63` |
| MCP `failed` | `/mcp` | MCP control plane | 盲等自动恢复 / 直接改无关设置 | `useMcpConnectivityStatus.tsx:36-47` |
| MCP `needs-auth` | `/mcp` | MCP auth control plane | 等待连接自己恢复 / 跳去别的 auth 命令 | `useMcpConnectivityStatus.tsx:50-60`; `MCPReconnect.tsx:48-53` |
| bridge no OAuth | `/login` | auth control plane | 反复 `/remote-control` | `initReplBridge.ts:144-150` |
| bridge session expired | `/remote-control` / `claude remote-control` | bridge session control plane | 继续沿旧 expired session 路径重试 | `replBridge.ts:2293-2297`; `bridgeApi.ts:472-490` |
| retryable resume | retry same command | current resume path owner | 提前切去 fresh session 或无关控制域 | `bridgeMain.ts:2524-2539` |
| env mismatch fallback | fresh session path | new session issuance path | 继续坚持 old resume path | `bridgeMain.ts:2484-2489` |

## 3. 最短判断公式

看到一个资格问题时，先问五句：

1. 当前哪一个控制域真正拥有处置权
2. 这条默认路由是否唯一
3. 它是不是沿着仍有价值的旧路径走，还是切入新资格路径
4. 有哪些近邻动作看似合理但实际上是错路
5. 当前文案是否已经把 dominant route 明示给用户

## 4. 最常见的五类路由错误

| 错误方式 | 会造成什么问题 |
| --- | --- |
| auth 缺口时把用户送去 `/remote-control` | 错把前提缺失当会话问题 |
| session expiry 时只让用户 `/login` | 错把 session 重建问题当纯认证问题 |
| plugin `needsRefresh` 时不给 `/reload-plugins` | 用户不知道 activation 的唯一入口 |
| MCP failed 时不指向 `/mcp` | 用户失去拥有处置权的控制面 |
| retryable resume 时过早切 fresh session | 仍有价值的旧资格被过早放弃 |

## 5. 一条硬结论

对 Claude Code 这类安全控制面来说，  
真正成熟的不是：

`给用户很多可能动作，`

而是：

`让每一种资格状态直接收口到拥有处置权的唯一正确路径。`
