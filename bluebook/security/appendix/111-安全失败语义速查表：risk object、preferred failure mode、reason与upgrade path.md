# 安全失败语义速查表：risk object、preferred failure mode、reason与upgrade path

## 1. 这一页服务于什么

这一页服务于 [127-安全失败语义三分法：为什么Claude Code不把所有失败都压成deny，而是按风险对象选择fail-open、fail-closed与step-up](../127-%E5%AE%89%E5%85%A8%E5%A4%B1%E8%B4%A5%E8%AF%AD%E4%B9%89%E4%B8%89%E5%88%86%E6%B3%95%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88Claude%20Code%E4%B8%8D%E6%8A%8A%E6%89%80%E6%9C%89%E5%A4%B1%E8%B4%A5%E9%83%BD%E5%8E%8B%E6%88%90deny%EF%BC%8C%E8%80%8C%E6%98%AF%E6%8C%89%E9%A3%8E%E9%99%A9%E5%AF%B9%E8%B1%A1%E9%80%89%E6%8B%A9fail-open%E3%80%81fail-closed%E4%B8%8Estep-up.md)。

如果 `127` 的长文解释的是：

`为什么 Claude Code 会按风险对象选择不同失败语义，`

那么这一页只做一件事：

`把主要 risk object 的 preferred failure mode、reason 与 upgrade path 压成一张矩阵。`

## 2. 失败语义矩阵

| risk object | preferred failure mode | reason | upgrade path | 关键证据 |
| --- | --- | --- | --- | --- |
| remote managed settings fetch | fail-open / stale degrade | 守的是配置分发可用性 | cache / background polling | `remoteManagedSettings/index.ts:413-442,492-501` |
| forceLoginOrg org validation | fail-closed | 守的是组织主权与 authoritative identity | 重新获取可验证 profile / full-scope auth | `auth.ts:1916-1969` |
| dangerous managed settings delta | fail-closed | 守的是高危 shell/env/hooks 变更 | interactive approval only | `remoteManagedSettings/index.ts:456-467`; `securityCheck.tsx:15-20,38-70`; `ManagedSettingsSecurityDialog/utils.ts:20-23,44-62,87-117` |
| Remote Control policy / bridge prerequisites | fail-closed | 守的是高安全远程能力 | 补齐 auth、policy、version、trusted device | `cli.tsx:132-159`; `bridgeApi.ts:27-35`; `trustedDevice.ts:15-31,54-59,89-97` |
| MCP insufficient_scope | step-up | 缺的是 authority level，不是 freshness | PKCE / step-up auth flow | `mcp/auth.ts:1345-1353,1461-1470,1625-1650` |
| auto mode dangerous allow rules | de-scope before allow | 守的是 classifier not being bypassed | leave auto mode or restore on exit | `permissionSetup.ts:510-553,627-636` |

## 3. 最短判断公式

判断某条失败路径应落在哪一类 failure semantic 时，先问四句：

1. 当前守的是可用性、主权，还是权限层级
2. 错误放行的代价是否大于错误阻断
3. 是否存在明确更高证明路径
4. 系统应继续跑、立刻关，还是升级认证

## 4. 最常见的三类错配

| 错配 | 实际问题 |
| --- | --- |
| availability 问题被 fail-closed | 误伤过高 |
| sovereignty 问题被 fail-open | 边界被掏空 |
| authority-level 问题被压成 generic failed | step-up 路径被丢失 |

## 5. 一条硬结论

Claude Code 的安全先进性，不只是：

`遇到风险时会拦，`

而是：

`它知道该用哪一种失败方式去拦。`

