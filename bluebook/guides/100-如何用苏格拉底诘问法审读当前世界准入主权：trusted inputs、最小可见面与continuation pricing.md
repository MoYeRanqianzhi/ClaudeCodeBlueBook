# 如何用苏格拉底诘问法审读当前世界准入主权：governance key、externalized truth chain、typed ask、decision window与continuation pricing

这篇把 `architecture/83` 与 `philosophy/85` 压成一组失稳前审读问题。

## 0. 代表性源码锚点

- `claude-code-source-code/src/utils/managedEnv.ts:93-220`
- `claude-code-source-code/src/utils/settings/settings.ts:319-520`
- `claude-code-source-code/src/utils/permissions/permissionSetup.ts:472-716`
- `claude-code-source-code/src/utils/permissions/permissions.ts:1158-1318`
- `claude-code-source-code/src/hooks/toolPermission/handlers/interactiveHandler.ts:44-380`
- `claude-code-source-code/src/utils/toolSearch.ts:385-704`
- `claude-code-source-code/src/utils/toolResultStorage.ts:740-860`
- `claude-code-source-code/src/query/tokenBudget.ts:45-92`
- `claude-code-source-code/src/services/remoteManagedSettings/index.ts:413-610`
- `../architecture/83-反扩张治理流水线：governance key、typed ask、decision window与continuation pricing.md`
- `../philosophy/85-真正成熟的治理，不是更会拦截，而是更会为扩张定价.md`

这些锚点共同说明：

- 安全设计与省 Token 设计真正共享的是“当前世界的准入主权”，而不是同一组 UI 或同一个预算器名字。
- 更硬一点说，`governance key` 才是这张控制面的实现主键；source slot 只是它的最前沿证据位，而 ask、visibility、externalization 与 continuation 都只是这张主键向下游派生出的受价结果。

如果你只缺治理收费链的一屏速记，而不是苏格拉底诘问链本身，先回 [../10-治理收费链入口卡：最早 unpaid expansion、reject trio 与弱读回面](../10-%E6%B2%BB%E7%90%86%E6%94%B6%E8%B4%B9%E9%93%BE%E5%85%A5%E5%8F%A3%E5%8D%A1%EF%BC%9A%E6%9C%80%E6%97%A9%20unpaid%20expansion%E3%80%81reject%20trio%20%E4%B8%8E%E5%BC%B1%E8%AF%BB%E5%9B%9E%E9%9D%A2.md)；本页尽快进入问题链，不第二次承担入口卡职责。

如果只先做一轮最短的治理审读，也只按这条 canonical chain 问：

- `governance key -> externalized truth chain -> typed ask -> decision window -> continuation pricing -> durable-transient cleanup`

这组问题最短的 reject trio 也只认：

1. `decision-window collapse`
2. `projection usurpation`
3. `free-expansion relapse`

这里还应再多记一句：

- `compact / resume / re-entry` 不构成第四条治理对象线；它们只是 `continuation pricing`、`durable-transient cleanup` 与 authority re-qualification 在时间轴上的不同消费点。

## 1. 第一性原理

成熟治理首先处理的不是：

- 更多 deny

而是：

- 哪些扩张配进入当前世界

所以更高阶的审读顺序，不该从 dialog 开始，而应从：

1. 谁能扩边界
2. 宿主此刻承认哪条当前真相
3. 哪些动作此刻配执行
4. 哪些能力当前可见
5. 哪些结果值得继续占据主席位
6. 这轮继续是否仍有决策增益

开始。

## 2. 苏格拉底诘问链

### 2.1 低信任来源能不能自我扩权

判断标准：

- 如果 project/local inputs 也能像 managed authority 一样扩边界，那当前世界的准入主权已经被外包。
- 更具体地说，若 project/local settings 还能静默开启高风险自动化，或 repo-authored allow rules 还能替 managed deny / policy ceiling 改价，那么低信任来源已经在偷签 `governance key`；这时应先判 `authority leak`，而不是继续讨论 ask 体验。

### 2.1.1 governance key 有没有先于动作被确认

判断标准：

- 如果系统先讨论 ask/deny，再讨论谁有资格改 provider、policy、mode 或 trust 前环境，那么收费顺序已经反了。

### 2.1.2 source slot 是普通 provenance，还是真正的收费主键

判断标准：

- 如果 `source` 只是事后标签，而不是决定 rule、visibility、resume 资格的主键，那当前世界的准入主权仍然没有被 runtime 真正持有。

### 2.2 permission 在这里是 modal，还是 typed decision transaction

判断标准：

- 如果 ask 只是“弹个框等人点”，而不是围绕同一请求做分布式仲裁，它就还不是正式治理控制面。

### 2.2.1 `Context Usage` 在我这里是 `decision window` 证据面，还是成本仪表

判断标准：

- 如果 `Context Usage` 只剩百分比、颜色与趋势，而不再和 `pending action / current state / continuation condition` 一起解释窗口，它就已经退回成本看板。

### 2.3 工具存在与工具当前可见，我有没有分开

判断标准：

- 如果所有工具默认都该进入模型视野，这不是开放，而是免费暴露。

### 2.4 哪些对象必须留在主 prompt，哪些对象应被 deferred 或 externalize

判断标准：

- 高波动、高体积、只需引用的对象不应继续霸占最昂贵的上下文席位。

### 2.5 continuation 在我这里是默认继续，还是受条件约束的租约

判断标准：

- 如果没有显式 stop condition、边际决策增益与 rented continuation 意识，系统只是在以“继续”名义免费烧时间。
- 更硬一点说，continuity 审的不是“还能不能继续用”，而是“这次继续是否仍值得付费、仍只续 durable assets、而没有把 transient authority 也一起续租”。

### 2.5.1 resume 恢复的是 durable assets，还是把 transient authority 一并续租

判断标准：

- 如果恢复流程不重新审 authority，只把旧 mode、旧 grant、旧可见集整包续上，那 continuation 还不是正式收费，而只是延长旧世界的错觉。

### 2.6 fail-open / fail-closed 的选择是否按资产类型区分

判断标准：

- 如果所有失败都被写成同一种情绪，那治理还没有资产类型化。

### 2.7 cache 与 stable bytes 在我这里只是性能细节吗

判断标准：

- 如果不能说明哪些字节是 governance asset、为何必须稳定，那 prompt 稳定性仍未进入治理本体。

### 2.8 automation 何时应合法退场

判断标准：

- 如果自动化只有开启路径，没有撤销路径，它迟早会从高行动力通道变成失控通道。

### 2.9 host 消费的是 authority/status，还是自己回放拼当前真相

判断标准：

- 如果 host 需要自己从事件流回放 `mode / pending action / context truth`，那 runtime 主权已经泄露到外围消费者。

### 2.9.1 host 消费的是 `externalized truth chain`，还是 mode 条、token 条与文案替身

判断标准：

- 如果 host 主要依赖 mode 条、token 条、spinner 或 `pending_action` 文案，而不是直接消费 `sources / effective / applied / session_state_changed / worker_status / get_context_usage`，那外化真相链已经被投影层替身劫持。

## 3. 常见自欺

看到下面信号时，应提高警惕：

1. 以为 permission dialog 就是治理本体。
2. 以为 bypass 等于 unlimited freedom。
3. 以为字更短就等于省 Token。
4. 以为看见更多工具就等于系统更强。
5. 以为 fail-closed 一定比资产分型更成熟。

## 3.1 失败语义与升级阈值矩阵

如果这条控制面已经成熟，它最终必须能被压成一张治理矩阵，而不是只剩抽象解释：

| 控制对象 | 默认失败语义 | threshold trigger | escalation target | surface divergence | minimum legal degraded shape | re-entry / rollback requirement | durable assets kept | transient authority cleared |
|---|---|---|---|---|---|---|---|---|
| `governance key` | `reject` | 低信任来源试图扩边界 | human / managed authority | host/headless 都直接拒收，不允许本地猜测补边界 | 只保 trusted source chain | rollback 到 trusted source 后才可重新进入 | managed config / trusted env | project-scoped expansion |
| `typed ask` | `ask` | cheap path 不足以定案 | human reviewer / host | interactive 允许 ask；headless / async 退 `deny` 或 `abort` | 只保 request identity 与 winner evidence | 重新建立 ask path 后才允许 re-entry | request identity / evidence refs | implicit auto-allow |
| `visibility / externalization` | `degrade` 或 `persist+preview` | 高体积对象继续霸占主席位 | runtime-controlled externalization | host 可消费 preview；headless 只保最小 preview 与 stable ref | preview + stable ref，而不是 raw payload | rollback 到 preview marker 后才可继续 | durable refs / preview marker | raw bulky payload |
| `continuation pricing` | `halt` 或对象升级 | decision gain 继续下降 | human handoff / object upgrade | interactive 可升级给人；headless 更早停机或升级对象 | compact summary + next-step object | 只有重新获得 decision window 后才允许 re-entry | compact summary / next-step object | default-continue illusion |
| `durable / transient cleanup` | `cleanup-before-resume` | resume 试图续租旧 mode、旧 grant、旧可见集 | runtime cleanup gate | host 只消费 cleanup 后的 truth；headless 不做情绪化续租 | durable assets only | cleanup 完成后才能 resume / rollback | durable assets / stable refs | transient authority bundle |

更短地说，治理成熟度最终要能回答：

1. 哪类 drift 默认拒收。
2. 哪类 drift 允许降级而不允许扩权。
3. 哪类 drift 必须升级给人。
4. 哪些 durable assets 可以带过下一轮。
5. 哪些 transient authority 必须在升级或恢复前先清掉。

## 4. 失稳时的回修顺序

当这组问题里有任何一个答不清时，优先做下面四步：

1. 先回 `../philosophy/85` 与 `../architecture/83`，判断自己放掉的是准入主权、可见性价格、对象外置还是 continuation 价格。
2. 再回 `31`，用旧一层治理审读模板确认是输入边界、决策增益、可撤销自动化还是失败语义先失真。
3. 再检查 `managedEnv`、`permissionSetup`、`interactiveHandler`、`toolSearch`、`toolResultStorage` 与 `tokenBudget` 的真实边界。
4. 最后才决定是否要补规则；多数时候，先修收费逻辑比先修 UI 更重要。

## 5. 最小判据

```text
审读对象:
当前 governance key 证据链:
governance_key_ref:
governance_evidence_slot:
externalized_truth_chain_ref:
governance key 是否先于动作、可见性和 continuation:
source slot 是否真是规则主键:
typed_ask_ref:
typed ask arbitration 是否成立:
能力存在 / 当前可见是否分层:
哪些对象应 externalize:
decision_window_ref:
continuation 是否按条件出租:
continuation_pricing_ref:
surface_divergence:
minimum_legal_degraded_shape:
escalation_target:
rollback_action:
re_entry_condition:
resume 是否只恢复 durable assets:
durable_assets_after:
transient_authority_cleared:
失败语义是否按资产类型分型:
host 是否只消费 runtime 外化的 governance truth/status:
当前最像哪类失真:
- authority leak / free visibility / free context / free continuation / flattened failure semantics
优先回修对象:
- governance key / typed ask / visibility / externalization / continuation / failure typing
```

任一 `*_ref` 无法点名时，都应直接判定：

- `not same control plane`

## 6. 否证问句

准备继续给系统加治理规则前，先问：

1. 我在收回免费扩张，还是只在增加表层摩擦。
2. 当前世界的准入主权是不是仍在 runtime 手里。
3. `governance_key_ref -> externalized_truth_chain_ref -> typed_ask_ref -> decision_window_ref -> continuation_pricing_ref` 这条链我能不能逐一指出。
4. 模型此刻看见的世界是否已经足够小。
5. 大对象有没有迁出最昂贵的上下文主席位。
6. 继续执行是否仍有正式价格和停止条件。
7. 自动化还能不能合法退场。
8. resume 恢复的是 durable assets，还是把 transient authority 也免费续租了。
9. interactive / host / headless / async 这些执行面现在是否仍共享同一治理主键，只在合法分叉点分叉。
10. 当前 drift 的最小合法降级形态到底是什么，而不是只剩一个 `degrade` verdict。
11. rollback 之后要满足什么条件才配 re-entry。
12. 如果把所有 UI 都删掉，这套治理秩序是否仍然成立。

## 7. 一句话总结

要审读安全与省 Token 的统一设计，就不要只审 deny 或压缩技巧；真正该审的是当前世界的准入主权是否仍由 runtime 持有，以及一切扩张是否都已被正式定价。
