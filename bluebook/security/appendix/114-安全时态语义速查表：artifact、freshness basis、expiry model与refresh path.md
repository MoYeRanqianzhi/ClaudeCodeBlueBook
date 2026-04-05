# 安全时态语义速查表：artifact、freshness basis、expiry model与refresh path

## 1. 这一页服务于什么

这一页服务于 [130-安全真相的时态性：为什么Claude Code把很多安全结论都建模成会过期、需续签、可失效的租约而不是永久事实](../130-%E5%AE%89%E5%85%A8%E7%9C%9F%E7%9B%B8%E7%9A%84%E6%97%B6%E6%80%81%E6%80%A7%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88Claude%20Code%E6%8A%8A%E5%BE%88%E5%A4%9A%E5%AE%89%E5%85%A8%E7%BB%93%E8%AE%BA%E9%83%BD%E5%BB%BA%E6%A8%A1%E6%88%90%E4%BC%9A%E8%BF%87%E6%9C%9F%E3%80%81%E9%9C%80%E7%BB%AD%E7%AD%BE%E3%80%81%E5%8F%AF%E5%A4%B1%E6%95%88%E7%9A%84%E7%A7%9F%E7%BA%A6%E8%80%8C%E4%B8%8D%E6%98%AF%E6%B0%B8%E4%B9%85%E4%BA%8B%E5%AE%9E.md)。

如果 `130` 的长文解释的是：

`为什么 Claude Code 把很多安全状态建模成 lease，而不是永久事实，`

那么这一页只做一件事：

`把主要 artifact 的 freshness basis、expiry model 与 refresh path 压成一张矩阵。`

## 2. 时态语义矩阵

| artifact | freshness basis | expiry model | refresh path | 关键证据 |
| --- | --- | --- | --- | --- |
| remote managed settings cache | HTTP checksum / 304 / fetch success | stale cache / no-remote-settings fallback | re-fetch + background polling | `remoteManagedSettings/index.ts:445-450,428-441,492-501` |
| trusted device token | fresh login session + keychain token | 90d rolling expiry | re-enroll during fresh /login | `trustedDevice.ts:24-30,94-97` |
| MCP step-up state | `_pendingStepUpScope` + scope diff | pending until stronger auth completes | PKCE step-up auth flow | `mcp/auth.ts:1388-1390,1625-1650` |
| bridge ingress JWT | token expiry timestamp | proactive refresh 5min before expiry | tokenRefresh / reconnectSession | `bridgeMain.ts:279-300,1195-1201` |
| bridge resume pointer / environment | file mtime + backend 4h TTL | stale pointer / expired environment | hourly pointer refresh | `bridgeMain.ts:1517-1521,2704-2728` |
| MCP needs-auth cache | cached auth failure | temporary suppression lease | auth resolution after cache window | `mcp/client.ts:337-360,2311-2318` |

## 3. 最短判断公式

判断一个安全状态是否应被理解成 lease 时，先问四句：

1. 它有没有 freshness basis
2. 它有没有明确 expiry model
3. 过期后系统是否会 downgrade / suppress / deny
4. 它是否存在对应 refresh 或 re-sign 路径

## 4. 最常见的三类误读

| 误读 | 实际问题 |
| --- | --- |
| “之前有效，所以现在也有效” | 把 lease 当产权 |
| “refresh 只是性能优化” | 忽略它其实在维持安全真相 |
| “stale cache 仍然等于真相” | 忽略 freshness debt |

## 5. 一条硬结论

Claude Code 的安全设计，不只是管理：

`资格有没有，`

更是在管理：

`资格现在还新不新、还活不活、还配不配继续说成有效。`

