# 如何用苏格拉底诘问法审读当前世界准入主权：trusted inputs、最小可见面与continuation pricing

这一章不再解释安全与省 Token 为什么同构，而是把 `architecture/83` 与 `philosophy/85` 继续压成一套 builder-facing 审读模板。

它主要回答五个问题：

1. 怎样避免把治理重新写回“更严的拦截器”。
2. 怎样按固定顺序审读 `authority source`、`typed ask arbitration`、`deferred visibility`、`externalization` 与 `continuation pricing`。
3. 怎样判断一个 runtime 是否真的把“当前世界的准入主权”保留在 runtime，而不是外包给模型或低信任输入。
4. 怎样识别那些看起来更保守、实际更脆的坏改写。
5. 怎样用苏格拉底式追问避免把这份模板重新写成设置页说明书。

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
- `../architecture/83-反扩张治理流水线：trusted inputs、distributed ask arbitration、deferred visibility与continuation pricing.md`
- `../philosophy/85-真正成熟的治理，不是更会拦截，而是更会为扩张定价.md`

这些锚点共同说明：

- 安全设计与省 Token 设计真正共享的是“当前世界的准入主权”，而不是同一组 UI 或同一个预算器名字。

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

### 2.1.1 authority source 有没有被放到动作之前

判断标准：

- 如果系统先讨论 ask/deny，再讨论谁有资格改 provider、policy、mode 或 trust 前环境，那么收费顺序已经反了。

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

## 4. 更好的迭代顺序

当这组问题里有任何一个答不清时，优先做下面四步：

1. 先回 `../philosophy/85` 与 `../architecture/83`，判断自己放掉的是准入主权、可见性价格、对象外置还是 continuation 价格。
2. 再回 `31`，用旧一层治理审读模板确认是输入边界、决策增益、可撤销自动化还是失败语义先失真。
3. 再检查 `managedEnv`、`permissionSetup`、`interactiveHandler`、`toolSearch`、`toolResultStorage` 与 `tokenBudget` 的真实边界。
4. 最后才决定是否要补规则；多数时候，先修收费逻辑比先修 UI 更重要。

## 5. 审读记录卡

```text
审读对象:
当前 trusted input 链:
authority source 是否先于动作、可见性和 continuation:
typed ask arbitration 是否成立:
能力存在 / 当前可见是否分层:
哪些对象应 externalize:
continuation 是否按条件出租:
失败语义是否按资产类型分型:
host 是否只消费 runtime 外化的 authority/status:
当前最像哪类失真:
- authority leak / free visibility / free context / free continuation / flattened failure semantics
优先回修对象:
- trusted input / ask arbitration / visibility / externalization / continuation / failure typing
```

## 6. 苏格拉底式检查清单

在你准备继续给系统加治理规则前，先问自己：

1. 我在收回免费扩张，还是只在增加表层摩擦。
2. 当前世界的准入主权是不是仍在 runtime 手里。
3. 模型此刻看见的世界是否已经足够小。
4. 大对象有没有迁出最昂贵的上下文主席位。
5. 继续执行是否仍有正式价格和停止条件。
6. 自动化还能不能合法退场。
7. host 是在消费 runtime 已外化的真相，还是在自己猜当前真相。
8. 如果把所有 UI 都删掉，这套治理秩序是否仍然成立。

## 7. 一句话总结

要审读安全与省 Token 的统一设计，就不要只审 deny 或压缩技巧；真正该审的是当前世界的准入主权是否仍由 runtime 持有，以及一切扩张是否都已被正式定价。
