# 安全缩域语义速查表：surface、trimmed capability、retained subset与governing boundary

## 1. 这一页服务于什么

这一页服务于 [128-安全缩域语义：为什么Claude Code不总是直接拒绝，而是主动裁剪能力面，只保留仍可证明安全的子集](../128-%E5%AE%89%E5%85%A8%E7%BC%A9%E5%9F%9F%E8%AF%AD%E4%B9%89%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88Claude%20Code%E4%B8%8D%E6%80%BB%E6%98%AF%E7%9B%B4%E6%8E%A5%E6%8B%92%E7%BB%9D%EF%BC%8C%E8%80%8C%E6%98%AF%E4%B8%BB%E5%8A%A8%E8%A3%81%E5%89%AA%E8%83%BD%E5%8A%9B%E9%9D%A2%EF%BC%8C%E5%8F%AA%E4%BF%9D%E7%95%99%E4%BB%8D%E5%8F%AF%E8%AF%81%E6%98%8E%E5%AE%89%E5%85%A8%E7%9A%84%E5%AD%90%E9%9B%86.md)。

如果 `128` 的长文解释的是：

`为什么 Claude Code 会主动把系统压回更窄但更可证明安全的能力子集，`

那么这一页只做一件事：

`把主要 surface 的 trimmed capability、retained subset 与 governing boundary 压成一张矩阵。`

## 2. 缩域语义矩阵

| surface | trimmed capability | retained subset | governing boundary | 关键证据 |
| --- | --- | --- | --- | --- |
| auto mode permissions | dangerous allow rules | classifier-compatible permissions | auto-mode classifier boundary | `permissionSetup.ts:510-579` |
| sandbox network | user/project/local/flag allow domains | managed `allowedDomains` + deny rules | managed network boundary | `sandboxTypes.ts:18-24` |
| sandbox filesystem | non-managed allowRead flexibility | `policySettings.allowRead` subset | managed filesystem boundary | `sandboxTypes.ts:78-83` |
| sandbox escape path | unsandboxed fallback | sandboxed execution only | sandbox hard gate | `sandboxTypes.ts:113-119` |
| MCP project/plugin config | unapproved / disabled / policy-blocked / duplicate servers | approved + enabled + policy-allowed subset | MCP approval/policy boundary | `mcp/config.ts:1164-1245` |
| plugin agent frontmatter | `permissionMode/hooks/mcpServers` declarations | safer agent subset under install-time trust | plugin install-time trust boundary | `loadPluginAgents.ts:153-165` |
| managed-settings locked plugins | `--plugin-dir` copy override | managed-approved plugin set | managed settings boundary | `pluginLoader.ts:3030-3043` |

## 3. 最短判断公式

判断某条控制逻辑是否属于 de-scope 时，先问四句：

1. 系统有没有完全拒绝这项能力
2. 如果没有，它裁掉了哪一部分
3. 保留下来的子集由哪条边界签字
4. 这个 retained subset 是否仍可继续运行

## 4. 最常见的三类误读

| 误读 | 实际问题 |
| --- | --- |
| “这只是功能缺失” | 忽略了这是主动能力裁剪 |
| “这就是 deny” | 忽略了仍保留了较窄的安全子集 |
| “这只是兼容性处理” | 忽略了 governing boundary 在主动收口 |

## 5. 一条硬结论

Claude Code 的安全先进性，不只是：

`知道何时拦，`

还在于：

`知道何时把系统缩回一个仍可证明安全的最小能力面。`

