# 来源主权总表：settings、permissions、hooks、MCP、plugins、sandbox、gateway 到底谁能覆盖谁

## 1. 为什么还要再写一张“来源主权总表”

前面的 `08` 章已经把：

- setting sources
- trust 前后 env
- host-managed provider vars
- managed-only 安全面

拆得比较清楚了。

但如果站在真正要维护系统的人角度，  
还会剩下一个很实际的问题：

`Claude Code 这么多安全面，最终到底是谁拥有定义权、覆盖权和收口权？`

这一章的目标，就是把这个问题压成一张总表。

## 2. 先说结论

Claude Code 在安全主权上的整体策略，不是“一切都由管理员说了算”，  
也不是“一切都让用户自由覆盖”，  
而是：

`默认承认多来源灵活性，但在高风险面上把最终收口权逐步推回 host、managed settings 或第一方 entitlement。`

因此最重要的不是某一条规则，  
而是这条总原则：

`越接近运行时主链、执行主链、外部入口主链和身份主链，用户侧覆盖权就越容易被重新收口。`

## 3. 一张压缩后的来源主权总表

| 安全面 | 默认来源结构 | 用户可覆盖程度 | managed / host 可再收口程度 | 最终主权更偏向谁 |
| --- | --- | --- | --- | --- |
| 基础 settings | user -> project -> local -> flag -> policy | 高 | `policySettings` 最后覆盖 | 混合，最终偏 managed |
| env 注入 | trust 前受限、trust 后扩大 | 中 | host-managed vars / safe env / policy env 可收口 | 偏 host + managed |
| permission rules | 多来源 allow/deny/ask | 高 | `allowManagedPermissionRulesOnly` 可收口 | 默认混合，收口后偏 managed |
| hooks | merged hooks | 中 | `allowManagedHooksOnly` / `disableAllHooks` 可收口 | 默认混合，收口后偏 managed |
| MCP servers | user/project/local/plugin/enterprise | 中到高 | enterprise-exclusive / managed allowlist / plugin-only 可收口 | 默认混合，关键面偏 enterprise/managed |
| plugins / marketplaces | user + marketplace | 中 | strictKnownMarketplaces / managed plugins / plugin-only 政策可收口 | 默认混合，收口后偏 managed |
| sandbox 域与路径 | settings + permission-derived rules | 中 | `allowManagedDomainsOnly` / `allowManagedReadPathsOnly` 可收口 | 默认混合，收口后偏 managed |
| gateway / provider routing | env + settings | 中 | `CLAUDE_CODE_PROVIDER_MANAGED_BY_HOST` 可直接剥离用户覆盖 | 偏 host |
| bridge / Remote Control entitlement | 身份与 gate 决定 | 低 | 非用户可写规则，而是第一方资格面 | 偏第一方 entitlement |

这张表最重要的意义是：

`Claude Code 没有用一种统一的“谁说了算”规则治理所有面，而是按风险等级分配主权。`

## 4. settings 面：默认多来源，但 `policySettings` 最后收口

`settings/constants.ts` 明确了 later-overrides-earlier 的顺序，  
而 `settings/settings.ts` 又说明：

- `policySettings` 不只是其中一个普通来源
- 它在内部还存在自己的“first source wins”优先级：remote > MDM/HKLM/plist > file > HKCU

这说明 managed 层本身内部也有一条主权链。  
从平台角度看，这很成熟，因为它不是简单说：

- 只要是 policy 都一样

而是进一步区分：

- 哪一种 managed origin 更有主权

## 5. env 面：看似只是配置，其实是运行时主链

`managedEnv.ts` 与 `managedEnvConstants.ts` 已经说明：

- trust 前只给受信来源和 safe env 一部分作用范围
- trust 后才允许完整 merged settings.env 生效
- host-managed provider vars 会从 settings-sourced env 里被剥离

从主权角度看，这意味着：

- 用户可以在局部配置 env
- 但只要 env 涉及 provider / auth / routing 主链，host 可以把这层主权收回

也就是说：

`env 面不是“谁写了就算”，而是“谁碰到主链谁就更容易被收口”。`

## 6. permission rules 面：默认开放写入，但最终可切成 managed-only

`permissionsLoader.ts` 表明：

- 默认情况下，permission rules 从多个来源读入
- 但 `allowManagedPermissionRulesOnly` 开启后，只有 `policySettings` 的规则被尊重
- 同时 UI 上 “always allow” 选项还会被隐藏

这说明权限规则主权分成两层：

1. 默认时，用户有较大自治空间
2. 一旦进入 managed-only，平台明确把“谁有资格永久放行”改回管理员主权

## 7. hooks 面：不仅能收口，还能彻底关停

`hooksConfigSnapshot.ts` 进一步说明：

- `allowManagedHooksOnly` 可以只允许 managed hooks
- `disableAllHooks` 甚至可彻底禁用 hooks

所以 hooks 面的主权比 permission rules 还更集中。  
原因也很合理：

- hooks 直接带执行点

因此在高风险组织环境下，  
平台更愿意把 hooks 主权收回管理员。

## 8. MCP 面：默认最复杂，因此主权层次也最多

MCP 是整个系统里主权结构最复杂的一面之一。  
从 `mcp/config.ts`、`pluginOnlyPolicy.ts`、`settings/types.ts` 可以看到：

- 有 user/project/local 范围
- 有 enterprise MCP config
- 有 `allowManagedMcpServersOnly`
- 还有 `strictPluginOnlyCustomization` 对 MCP 的 plugin-only 收口
- 如果 enterprise MCP config 存在，甚至可以直接排除其他来源

这说明 MCP 并不是“用户自定义扩展目录”那么简单。  
它更像：

`一个会在不同部署层级间不断被重新收口的高权限接入面。`

## 9. plugins / marketplaces 面：平台在防的是供应链主权漂移

从 `managedPlugins.ts`、`marketplaceHelpers.ts`、`pluginOnlyPolicy.ts` 可以看出：

- managed settings 可以锁定某些插件
- strictKnownMarketplaces 可以限制来源
- blockedMarketplaces 可以直接封禁来源
- pluginTrustMessage 可以由 policySettings 注入信任文案

这里的核心不是“装不装插件”，  
而是：

`插件供应链的信任主权归谁。`

因此 plugins 面虽然看起来偏扩展，  
本质上其实是供应链安全面。

## 10. sandbox 面：看似环境边界，实则也有主权分层

`sandbox-adapter.ts` 和 `sandboxTypes.ts` 说明：

- 默认沙箱配置可来自 settings 与 permission-derived rules
- 但 network domains 和 read paths 又可以被 managed-only 收口

所以 sandbox 不是一个孤立的“环境模块”，  
它同样服从主权分配逻辑：

- 低风险灵活性可以保留给用户
- 高风险网络 / 读路径边界可以被管理员重新锁定

## 11. gateway / provider routing 面：最明显的 host 主权面

这一面其实是整张总表里最清晰的一行。

只要宿主声明：

- `CLAUDE_CODE_PROVIDER_MANAGED_BY_HOST`

那么 provider-routing env 就可以从 settings-sourced env 中被剥离。

这说明在 Claude Code 的主权模型里：

`只要某一面已经足够接近推理主链，host 就有非常强的最终否决权。`

## 12. entitlement 面：用户几乎没有“覆盖权”

bridge / Remote Control 一类能力是这张表里最特殊的一面。

因为这里几乎不是“谁来写配置”的问题，  
而是：

- 第一方身份是否成立
- organization 是否成立
- gate 是否放行

也就是说，到了 entitlement 层，  
主权已经几乎不再属于本地配置系统，  
而属于：

`第一方身份与资格系统。`

这就是为什么这一层和前面的 settings / hooks / MCP 不能混看。

## 13. 从第一性原理看，这张总表真正揭示了什么

如果从第一性原理压缩，这张表其实揭示的是三条更深的规律。

### 13.1 离风险越近，主权越集中

越接近：

- 认证主链
- 推理路由主链
- 执行点
- 外部高权限入口

系统越不愿意把最终主权完全留给用户侧局部配置。

### 13.2 灵活性不是平等分配，而是条件分配

用户并不是“没有主权”，  
而是：

- 在低风险层主权更大
- 在高风险层主权更容易被 host / managed / entitlement 收口

### 13.3 安全系统本质上也是一套主权编排系统

很多人把安全理解成：

- deny
- block
- sandbox

但 Claude Code 更深的一点在于：

`安全其实也是在持续回答“谁有资格定义这一层”。`

## 14. 对平台构建者的技术启示

如果要借鉴 Claude Code，这张总表最值得抄的不是某个字段名，  
而是这四条方法：

1. 把每个安全面单独问一遍“谁有定义权”
2. 不要把所有面都用同一种覆盖规则治理
3. 对接近主链的高风险面，允许 host / managed 重新收口
4. 对 entitlement 面，不要伪装成“本地配置问题”

## 15. 一句话总结

Claude Code 的主权设计之所以成熟，不在于它简单地把所有权力交给管理员或用户，而在于它按风险把主权分层分配：低风险面保留灵活性，高风险面逐步把最终收口权推回 host、managed settings 或第一方 entitlement；理解这张来源主权总表，等于真正理解了这套安全控制面里“到底谁说了算”。 
