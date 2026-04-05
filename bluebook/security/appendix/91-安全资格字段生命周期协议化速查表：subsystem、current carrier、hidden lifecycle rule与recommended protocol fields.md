# 安全资格字段生命周期协议化速查表：subsystem、current carrier、hidden lifecycle rule与recommended protocol fields

## 1. 这一页服务于什么

这一页服务于 [107-安全资格字段生命周期协议化：为什么upgrade-threshold与retire-trigger不应散落在局部if里，而应升级成统一field-lifecycle protocol](../107-%E5%AE%89%E5%85%A8%E8%B5%84%E6%A0%BC%E5%AD%97%E6%AE%B5%E7%94%9F%E5%91%BD%E5%91%A8%E6%9C%9F%E5%8D%8F%E8%AE%AE%E5%8C%96%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88upgrade-threshold%E4%B8%8Eretire-trigger%E4%B8%8D%E5%BA%94%E6%95%A3%E8%90%BD%E5%9C%A8%E5%B1%80%E9%83%A8if%E9%87%8C%EF%BC%8C%E8%80%8C%E5%BA%94%E5%8D%87%E7%BA%A7%E6%88%90%E7%BB%9F%E4%B8%80field-lifecycle%20protocol.md)。

如果 `107` 的长文解释的是：

`当前生命周期规则已成熟，但仍分裂在多处实现里，`

那么这一页只做一件事：

`把各 subsystem 当前用什么载体承载 lifecycle rule、它隐藏了什么规则、以及最该补什么协议字段压成一张矩阵。`

## 2. 字段生命周期协议化矩阵

| subsystem | current carrier | hidden lifecycle rule | recommended protocol fields | 立即收益 | 关键证据 |
| --- | --- | --- | --- | --- | --- |
| notifications queue | `priority/invalidates/timeoutMs/fold` | 谁先说、谁让位、多久退场已半字段化，但缺语义级 threshold/owner | `upgrade_threshold`、`stay_condition`、`retire_owner`、`evidence_basis` | 让所有 surface 都能解释通知为何出现与消失 | `notifications.tsx:5-33,45-68,78-116,121-212` |
| AppState notifications | `current/queue` | 只存显示结果，不存生命周期法理 | `current_reason`、`retire_trigger_kind`、`retire_owner` | 统一控制台可直接解释“为什么现在是这条” | `AppStateStore.ts:222-225` |
| bridge status | `label/color` | 结论被压缩，阈值、留场依据与撤场语义都被藏起 | `threshold_kind`、`freshness_basis`、`retire_semantics`、`hidden_truth_hint` | footer/dialog/status 可共享同一 bridge lifecycle truth | `bridgeStatusUtil.ts:113-140` |
| plugin refresh | `needsRefresh` + hook comment + refresh consumer | 只有 full refresh 才能退场，但规则分裂在三处 | `retire_owner`、`completion_verifier`、`retire_trigger=full_swap_complete` | 防止未来新增入口误清 `needsRefresh` | `AppStateStore.ts:209-215`; `useManagePlugins.ts:287-303`; `refresh.ts:59-67,123-138` |
| bridge pointer | freshness reader + bridge main branch logic | stale/fatal/transient/clean-shutdown/resumable-shutdown 的留场策略被分散编码 | `freshness_basis`、`resume_eligibility`、`retire_owner`、`retire_reason` | resume 系统可统一解释为何保留/清理 pointer | `bridgePointer.ts:77-112`; `bridgeMain.ts:1515-1577,2316-2325,2384-2403,2473-2534` |
| MCP stale cleanup | connection manager closure + timers | retire sequence 与 owner 很清楚，但只存在于局部实现 | `retire_sequence`、`stale_basis`、`retire_owner`、`replacement_mode` | 避免旧 closure 复活规则只能靠维护者记忆 | `useManageMCPConnections.ts:791-825` |
| `/status` summary projection | counts-by-state + `/mcp` hint | aggregate-only 规则存在于注释，不在数据里 | `projection_scope`、`overclaim_ceiling`、`hidden_truth_hint` | 防止弱 surface 被误读成 full control plane | `status.tsx:95-114` |

## 3. 最短判断公式

当某个 subsystem 已经拥有复杂生命周期规则时，先问五句：

1. 这些规则现在是存在于字段里，还是存在于实现里
2. 别的 surface 能不能直接消费这些规则
3. reviewer 能不能不读完整实现就审查其生命周期语义
4. 用户侧能不能知道字段为何出现与退场
5. 这些规则值不值得被提升成统一 protocol

## 4. 最常见的五类未协议化风险

| 风险方式 | 会造成什么问题 |
| --- | --- |
| 规则只在注释里 | 改实现时语义容易漂移 |
| 规则只在局部 if 里 | 其他 surface 无法复用 |
| 只存结论不存依据 | 系统无法自解释 |
| 多文件拼接才能读懂生命周期 | review 成本高，遗漏率高 |
| 高风险对象没有 `retire_owner` | 错主语清理边界对象 |

## 5. 一条硬结论

对安全控制面来说，  
真正的协议化不是：

`把现有字段搬进一个新 type，`

而是：

`把当前散落在实现、注释与作者脑内模型里的生命周期规则提升成所有 subsystem 都能消费的统一字段协议。`
