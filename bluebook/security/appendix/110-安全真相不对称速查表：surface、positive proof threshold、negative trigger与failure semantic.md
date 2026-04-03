# 安全真相不对称速查表：surface、positive proof threshold、negative trigger与failure semantic

## 1. 这一页服务于什么

这一页服务于 [126-安全真相的不对称性：为什么Claude Code对高风险放行要求更强证明，而对阻断与降级允许更早触发](../126-%E5%AE%89%E5%85%A8%E7%9C%9F%E7%9B%B8%E7%9A%84%E4%B8%8D%E5%AF%B9%E7%A7%B0%E6%80%A7%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88Claude%20Code%E5%AF%B9%E9%AB%98%E9%A3%8E%E9%99%A9%E6%94%BE%E8%A1%8C%E8%A6%81%E6%B1%82%E6%9B%B4%E5%BC%BA%E8%AF%81%E6%98%8E%EF%BC%8C%E8%80%8C%E5%AF%B9%E9%98%BB%E6%96%AD%E4%B8%8E%E9%99%8D%E7%BA%A7%E5%85%81%E8%AE%B8%E6%9B%B4%E6%97%A9%E8%A7%A6%E5%8F%91.md)。

如果 `126` 的长文解释的是：

`为什么 Claude Code 对高风险 allow 与 deny 采用不对称的证明门槛，`

那么这一页只做一件事：

`把主要安全 surface 的 positive proof threshold、negative trigger 与 failure semantic 压成一张矩阵。`

## 2. 安全真相不对称矩阵

| surface | positive proof threshold | negative trigger | failure semantic | 关键证据 |
| --- | --- | --- | --- | --- |
| auto mode | gate enabled + classifier-compatible permission context | dangerous allow 规则会绕过 classifier | strip dangerous rules before enable | `permissionSetup.ts:510-553,627-636` |
| forceLoginOrg | authoritative profile org matches required org | 无法取回 profile / org mismatch | fail-closed | `auth.ts:1916-1969` |
| remote managed settings fetch | remote settings fetch 或 stale cache 可用 | fetch error with no cache | fail-open / graceful degrade | `remoteManagedSettings/index.ts:413-442,492-501` |
| dangerous managed settings apply | dangerous delta 经用户批准 | dangerous shell/env/hooks 变更被拒绝 | blocking dialog + shutdown | `remoteManagedSettings/index.ts:456-467`; `securityCheck.tsx:15-20,38-70`; `ManagedSettingsSecurityDialog/utils.ts:20-23,44-62,87-117` |
| Remote Control / bridge | auth + GB gate + min version + org policy + optional trusted device for elevated tier | 任一 prerequisite 缺失 | early deny / no remote control | `cli.tsx:132-159`; `bridgeApi.ts:27-35`; `trustedDevice.ts:15-31,54-59,89-97` |
| MCP OAuth | token freshness or explicit step-up completion | `403 insufficient_scope` | step-up auth replaces refresh path | `mcp/auth.ts:1345-1353,1461-1470,1625-1650` |

## 3. 最短判断公式

判断某个安全 surface 是否采用了不对称真相管理时，先问四句：

1. allow 需要哪些正证明
2. deny / downgrade 由哪些负触发器启动
3. 两者门槛是否明显不同
4. 失败后走的是 fail-open、fail-closed 还是 step-up

## 4. 最常见的三类误读

| 误读 | 实际问题 |
| --- | --- |
| “它只是保守” | 忽略了不同 surface 的 failure semantics 是分层设计 |
| “它只是在做阻断” | 忽略了 allow 侧其实要求更强证明链 |
| “所有失败都是同一种失败” | 忽略了 stale degrade、hard deny、step-up 的区别 |

## 5. 一条硬结论

Claude Code 的安全先进性不是：

`多一个拦截器，`

而是：

`对不同 risk surface 明确规定 allow 要多强证明，deny 又能在什么条件下更早触发。`

