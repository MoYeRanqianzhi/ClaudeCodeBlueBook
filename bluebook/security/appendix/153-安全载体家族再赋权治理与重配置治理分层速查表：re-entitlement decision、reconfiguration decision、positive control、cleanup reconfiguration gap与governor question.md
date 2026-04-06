# 安全载体家族再赋权治理与重配置治理分层速查表：re-entitlement decision、reconfiguration decision、positive control、cleanup reconfiguration gap与governor question

## 1. 这一页服务于什么

这一页服务于 [169-安全载体家族再赋权治理与重配置治理分层：为什么artifact-family cleanup re-entitlement-governor signer不能越级冒充artifact-family cleanup reconfiguration-governor signer](../169-%E5%AE%89%E5%85%A8%E8%BD%BD%E4%BD%93%E5%AE%B6%E6%97%8F%E5%86%8D%E8%B5%8B%E6%9D%83%E6%B2%BB%E7%90%86%E4%B8%8E%E9%87%8D%E9%85%8D%E7%BD%AE%E6%B2%BB%E7%90%86%E5%88%86%E5%B1%82%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88artifact-family%20cleanup%20re-entitlement-governor%20signer%E4%B8%8D%E8%83%BD%E8%B6%8A%E7%BA%A7%E5%86%92%E5%85%85artifact-family%20cleanup%20reconfiguration-governor%20signer.md)。

如果 `169` 的长文解释的是：

`为什么决定对象回来后还配不配拿 seat，与决定它拿回 seat 后按哪组 current config truth 重新工作，仍然是两层治理主权，`

那么这一页只做一件事：

`把 repo 里现成的 re-entitlement decision / reconfiguration decision 正例，与 cleanup 线当前仍缺的 reconfiguration grammar，压成一张矩阵。`

## 2. 再赋权治理与重配置治理分层矩阵

| line | re-entitlement decision | reconfiguration decision | positive control | cleanup reconfiguration gap | governor question | 关键证据 |
| --- | --- | --- | --- | --- | --- | --- |
| top-level plugin options | decide whether plugin regains enabled seat and may keep existing identity/scope | decide which option keys remain missing, which secrets stay in secureStorage, and which plaintext keys must be scrubbed | `savePluginOptions()` + `getUnconfiguredOptions()` | cleanup line has no explicit rule for which restored cleanup claims must be re-declared or re-keyed before reuse | who decides which restored cleanup config truths remain valid vs must be re-entered | `pluginOptionsStorage.ts:90-193,282-309` |
| per-server / per-channel MCP config | object may be enabled or rediscovered as a valid plugin/server carrier | decide which channel config is incomplete, where secrets live, and whether schema-flipped values must migrate stores | `loadMcpServerUserConfig()` + `saveMcpServerUserConfig()` + `needs-config` | cleanup line has no explicit rule for restored per-surface payload/config truth | who decides how restored cleanup objects regain per-surface configuration | `mcpbHandler.ts:141-339,742-757,894-902`; `mcpPluginIntegration.ts:290-317` |
| post-enable UI flow | plugin can already be enabled and counted as changed | decide whether config prompt is skipped, completed, or still incomplete | `PluginOptionsFlow` outcome grammar + `ManagePlugins` result grammar | cleanup line has no explicit surface for “authority restored but configuration still unresolved” | who signs the difference between restored authority and restored operability | `PluginOptionsFlow.tsx:53-133`; `ManagePlugins.tsx:1645-1668` |
| saved config vs active runtime effect | object already has seat and config may already be persisted | decide when saved config actually takes effect in the running session | `Configuration saved. Run /reload-plugins...` | cleanup line has no explicit rule for persisted restored config vs active applied truth | who decides when a restored cleanup configuration is merely saved vs truly active | `ManagePlugins.tsx:1663-1668,1700-1707` |
| cleanup line overall | may eventually decide restored cleanup object regains some authority seat | no explicit reconfiguration authority for restored cleanup options/secrets/payloads is visible yet | reconfiguration governance exists elsewhere in repo | restored cleanup worlds still lack a formal config-restoration grammar | who governs which current config truth a restored cleanup object may speak with | cleanup source cluster + positive controls above |

## 3. 三个最重要的判断问题

判断一句“cleanup re-entitlement 已经完整”有没有越级，先问三句：

1. 这只是 re-entitlement decision，还是已经明确对象拿回 seat 后按哪组 config truth 重新工作
2. 对象回来后，是只恢复 enabled/identity/scope，还是连 options、secrets、channel payload 都已经被重新声明
3. 如果配置真相不是自动恢复，那么哪些字段要重填、哪些旧值继续有效、哪些需要 scrub，由谁决定

## 4. 最常见的五类误读

| 误读 | 实际问题 |
| --- | --- |
| “重新 enable 了，所以当然已经配好” | re-entitlement != reconfiguration |
| “旧对象回来后，旧 secrets 自然继续有效” | seat return != secret truth restoration |
| “刚保存过一次，所以整套 schema 一定满足” | partial save != full config validity |
| “配置写进 store 了，所以运行时已经在用” | persistence != active application |
| “channel/server 只是配置细节，不算治理层” | per-surface payload truth also needs its own governor |

## 5. 一条硬结论

真正成熟的 comeback grammar 不是：

`authority seat returns -> current config truth is assumed`

而是：

`authority seat returns -> assign reconfiguration authority -> validate options/secrets/payload -> persist the permitted config subset -> apply it to active world only through the proper chokepoint`

只有中间三层被补上，  
cleanup re-entitlement governance 才不会继续停留在“知道对象又被允许存在，却没人正式决定它现在该按哪组 current config 重新工作”的半治理状态。
