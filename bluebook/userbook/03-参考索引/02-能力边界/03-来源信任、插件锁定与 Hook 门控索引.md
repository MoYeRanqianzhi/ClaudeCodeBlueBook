# 来源信任、插件锁定与 Hook 门控索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/14-来源信任、Trust Dialog 与 Plugin-only Policy：扩展面为何分级信任.md`
- `05-控制面深挖/12-技能来源、暴露面与触发：为什么 skills 菜单不是能力全集.md`

## 1. 三层不同的信任问题

| 层 | 核心问题 | 典型机制 | 最容易误判 |
| --- | --- | --- | --- |
| 工作区信任层 | 这块 workspace 能不能执行仓内可执行扩展 | Trust Dialog | 误写成普通功能开关 |
| 来源信任层 | 哪些来源有资格定义 skills/hooks/mcp/agents | `strictPluginOnlyCustomization` + `isSourceAdminTrusted()` | 误写成“只能用插件” |
| 执行门控层 | hooks / frontmatter 扩展现在到底还能不能注册/运行 | `allowManagedHooksOnly` `disableAllHooks` frontmatter gating | 误写成“对象存在就会生效” |

## 2. `strictPluginOnlyCustomization` 可锁的 surfaces

| surface | 被锁后会发生什么 |
| --- | --- |
| `skills` | user/project/`--add-dir`/legacy commands-as-skills 会被挡住，managed 与 plugin 来源继续 |
| `agents` | user/project/local agent 自定义面受限，admin-trusted 来源保留 |
| `hooks` | user/project/local settings hooks 被锁到 plugin/managed 来源 |
| `mcp` | user/project/local MCP 来源受限，admin-trusted 来源保留 |

## 3. admin-trusted sources

| source | 为什么被视为更高信任 |
| --- | --- |
| `plugin` | 已经过插件分发与市场治理链 |
| `policySettings` | 管理员托管来源 |
| `built-in` / `builtin` | CLI 内建来源 |
| `bundled` | 随 CLI 发布的 bundled 能力 |

这些 source 在 plugin-only policy 下，常能继续通过 frontmatter hook / MCP server 的注册判断。

## 4. Trust Dialog 真正在警惕什么

| 对象 | 重点条件 |
| --- | --- |
| 仓内或本地来源的 prompt 扩展 | 一旦可把提示流转化为 Bash 一类本地执行入口，就会成为工作区信任边界重点 |
| 旧式命令包装成的 prompt 扩展 | 只要同样能落到本地执行路径，也会被纳入同类风险判断 |

这说明 Trust Dialog 的重点是：

- 用户或仓内来源的 prompt 扩展一旦带本地执行能力，就会被当成工作区信任边界的重点风险

## 5. hooks 的两种更强总闸

| 设置 | 作用 | 注意点 |
| --- | --- | --- |
| `allowManagedHooksOnly` | 只保留 managed hooks | hooks UI 还会故意不显示可编辑 hooks |
| `disableAllHooks` from `policySettings` | 连 managed hooks 一起停掉 | 真正的 hooks 全停 |
| `disableAllHooks` from non-managed source | 非托管 hooks 停，managed hooks 继续 | 不是绝对总闸 |

## 6. “对象存在”不等于“附带能力还会生效”

| 对象 | 继续受哪层判断影响 |
| --- | --- |
| skill frontmatter hooks | `!isRestrictedToPluginOnly('hooks') || isSourceAdminTrusted(command.source)` |
| agent frontmatter hooks | 同上，但以 `agentDefinition.source` 判断 |
| agent frontmatter MCP servers | `mcp` surface 被锁且 agent source 非 admin-trusted 时跳过 |

## 7. 五个高价值判断问题

- 当前卡住的是 workspace trust、source trust，还是 execution gate？
- 这是“对象没加载”，还是“对象加载了但附带 hooks / MCP 不再注册”？
- 这条 policy 锁的是 surface，还是直接在运行时把所有能力停掉？
- 这里的 `disableAllHooks` 来自 managed 还是 non-managed source？
- 我是不是把 “plugin-only” 误写成了 “只能用插件、别的全关”？

## 源码锚点

- `claude-code-source-code/src/components/TrustDialog/TrustDialog.tsx`
- `claude-code-source-code/src/utils/settings/pluginOnlyPolicy.ts`
- `claude-code-source-code/src/utils/settings/types.ts`
- `claude-code-source-code/src/skills/loadSkillsDir.ts`
- `claude-code-source-code/src/utils/hooks/hooksConfigSnapshot.ts`
- `claude-code-source-code/src/utils/hooks/hooksSettings.ts`
- `claude-code-source-code/src/utils/sessionStart.ts`
- `claude-code-source-code/src/utils/processUserInput/processSlashCommand.tsx`
- `claude-code-source-code/src/tools/AgentTool/runAgent.ts`
