# 如何用苏格拉底诘问法审读当前世界准入主权：governance key、decision window与continuation pricing

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

## 1. 第一性原理

成熟治理首先处理的不是：

- 更多 deny

而是：

- 哪些扩张配进入当前世界

所以更高阶的审读顺序，不该从 dialog 开始，而应从：

1. 谁能扩边界
2. 哪些动作此刻配执行
3. 哪些能力当前可见
4. 哪些结果值得继续占据主席位
5. 这轮继续是否仍有决策增益

开始。

## 2. 苏格拉底诘问链

### 2.1 低信任来源能不能自我扩权

判断标准：

- 如果 project/local inputs 也能像 managed authority 一样扩边界，那当前世界的准入主权已经被外包。

### 2.1.1 governance key 有没有先于动作被确认

判断标准：

- 如果系统先讨论 ask/deny，再讨论谁有资格改 provider、policy、mode 或 trust 前环境，那么收费顺序已经反了。

### 2.1.2 source slot 是普通 provenance，还是真正的收费主键

判断标准：

- 如果 `source` 只是事后标签，而不是决定 rule、visibility、resume 资格的主键，那当前世界的准入主权仍然没有被 runtime 真正持有。

### 2.2 permission 在这里是 modal，还是 typed decision transaction

判断标准：

- 如果 ask 只是“弹个框等人点”，而不是围绕同一请求做分布式仲裁，它就还不是正式治理控制面。

### 2.3 工具存在与工具当前可见，我有没有分开

判断标准：

- 如果所有工具默认都该进入模型视野，这不是开放，而是免费暴露。

### 2.4 哪些对象必须留在主 prompt，哪些对象应被 deferred 或 externalize

判断标准：

- 高波动、高体积、只需引用的对象不应继续霸占最昂贵的上下文席位。

### 2.5 continuation 在我这里是默认继续，还是受条件约束的租约

判断标准：

- 如果没有显式 stop condition、边际决策增益与 rented continuation 意识，系统只是在以“继续”名义免费烧时间。

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

## 3. 常见自欺

看到下面信号时，应提高警惕：

1. 以为 permission dialog 就是治理本体。
2. 以为 bypass 等于 unlimited freedom。
3. 以为字更短就等于省 Token。
4. 以为看见更多工具就等于系统更强。
5. 以为 fail-closed 一定比资产分型更成熟。

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
9. host 是在消费 runtime 已外化的真相，还是在自己猜当前真相。
10. 如果把所有 UI 都删掉，这套治理秩序是否仍然成立。

## 7. 一句话总结

要审读安全与省 Token 的统一设计，就不要只审 deny 或压缩技巧；真正该审的是当前世界的准入主权是否仍由 runtime 持有，以及一切扩张是否都已被正式定价。
