# 如何用苏格拉底诘问法审读安全与省Token：governance key、decision window、continuation pricing与durable-transient cleanup

这一章不再解释安全与省 token 为什么要一起看，而是把“怎么审它是否真的成立”压成一组失稳前问题。

它主要回答五个问题：

1. 怎样避免把安全写回“更多拦截器”，把省 token 写回“更短文本”。
2. 怎样用递进式问题审读治理主键、外化真相链、失败语义、continuation pricing 与 durable-transient cleanup。
3. 怎样判断一套治理系统是否仍在免费扩张。
4. 怎样在设计、回归和事故复盘中使用同一组问题自我校准。
5. 怎样用苏格拉底式追问避免把安全审读模板退回空洞口号。

## 0. 代表性源码锚点

- `claude-code-source-code/src/utils/permissions/permissionSetup.ts:235-1283`
- `claude-code-source-code/src/utils/permissions/permissions.ts:593-984`
- `claude-code-source-code/src/query/tokenBudget.ts:1-93`
- `claude-code-source-code/src/utils/toolResultStorage.ts:367-860`
- `claude-code-source-code/src/utils/toolSearch.ts:712-760`
- `claude-code-source-code/src/services/compact/autoCompact.ts:257-338`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:224-520`
- `claude-code-source-code/src/hooks/toolPermission/handlers/interactiveHandler.ts:244-300`

这些锚点共同说明：

- Claude Code 的安全与省 token 真正共享的不是一个抽象口号，而是一套对免费扩张零容忍的运行时制度。

## 1. 第一性原理

更成熟的安全与省 token 系统，不是：

- 让动作更难发生

而是：

- 拒绝让未定价的动作、能力、上下文与时间偷偷进入系统

所以审读这条主线时，最该反问的不是：

- 有没有更多规则

而是：

- 哪些免费扩张仍然被系统默许，以及哪些 `source -> effective -> applied -> externalized` 对象链还没有被正式写成治理主键

## 2. 苏格拉底诘问链

### 2.1 你现在保护的，到底是动作结果，还是进入模型之前的输入边界

判断标准：

- 如果系统主要在输出后补救，而不是在输入前做 `deny / strip / defer / externalize`，边界设计还不成熟。

### 2.2 这条信息为什么必须进入主 prompt，而不是进入 delta、attachment、deferred surface 或对象外部状态

判断标准：

- 高波动信息不应污染稳定前缀；放错位置会同时伤害安全、缓存和成本。

### 2.3 当前运行时边界的治理主键到底是什么

判断标准：

- 如果答不出 `sources -> effective -> applied -> externalized` 这条对象链，或把 `permission_mode` 这种投影字段误当主键，治理仍停在抽象口号层。

### 2.4 当系统失败时，它应该显式失败、回退人工，还是继续假装还能判断

判断标准：

- 失败语义必须按资产分类；不能把所有失败都粗暴写成同一种 fail-open 或 fail-closed。

### 2.5 这一轮继续消耗 token，还会改变决策吗

判断标准：

- 如果检查、分类、重试已不再带来新的决策增益，就应立即停止，而不是“为了更稳再算一遍”。

### 2.6 哪些是 durable assets，哪些只是 transient authority

判断标准：

- 系统必须能明确点名哪些对象可重放、可恢复、可继续引用，哪些 authority 痕迹在 `idle / init / resume` 时必须被清空；否则它还在把资产和租约混写。

### 2.7 模型当前看到的世界，是由单一 capability surface 定义的最小可见面吗

判断标准：

- 先缩小可见面，再要求模型聪明；如果 capability truth 不是由单一工具池 / deny rules / deferred visibility 统一给出，而是靠 prompt 文案感觉拼接，通常同时更贵也更不安全。

### 2.8 continuation 是默认权利，还是受条件约束的临时租约

判断标准：

- 继续执行必须有明确的停止条件、对象升级条件和回退条件；如果它脱离当前 decision window、settled state 与 externalized truth chain 仍能继续，就不是租约，而是偷渡主权。

### 2.9 自动化是可撤销的吗，人类和 runtime 何时能把它收回

判断标准：

- 成熟自动化必须带撤销路径；不能只有“自动化开启”，没有“自动化合法退场”。

### 2.10 当历史被压缩、恢复、重放之后，restore order 与 writeback seam 还守住了吗

判断标准：

- 如果 compact、resume、fork 之后不能保证治理主键、当前状态写回面、配对和顺序，系统省下来的不是 token，而是正确性。

### 2.11 当前症状能直接反查到制度层吗，还是宿主还在猜当前真相

判断标准：

- 团队应能从 `cache break / wrong allow / split truth / stale state` 这类症状直接定位到治理主键、外化状态或 capability surface；如果宿主仍靠 `lastMessage`、spinner 或事件流猜当前真相，制度尚未闭环。

### 2.12 你写下的是设计建议，还是可观测、可回归、可复盘的制度

判断标准：

- 每条规则都应能回答四件事：如何观测、如何失效、如何回归、如何回滚；否则它还只是意见，不是 runtime 制度。

## 3. 常见自欺

看到下面信号时，应提高警惕：

1. 以为多一层检查就等于更安全。
2. 以为少一点输出就等于更省 token。
3. 以为 `permission_mode` 这样的投影字段就等于治理主键。
4. 以为宿主可以靠事件流、modal heuristic 或 spinner 自己猜当前真相。
5. 以为自动化一旦开启就应该尽量别退回人工。
6. 以为 visibility 只是产品体验问题，而不是治理问题。
7. 以为只要结果没出错，输入边界如何扩张都无所谓。

## 4. 更好的迭代顺序

当这组问题里有任何一个答不清时，优先做下面四步：

1. 先回 `../philosophy/64` 与 `../philosophy/61`，判断自己放任的是免费动作、免费能力、免费上下文还是免费 continuation。
2. 再回 `25` 与 `28`，检查治理顺序、失败语义、automation lease 与 stable bytes ledger 是否已经失真。
3. 再回 `../navigation/14` 与 `../casebooks/07-09`，确认当前症状是否已经能被制度化反查。
4. 最后才决定该增删规则、修改 stop logic、收紧 visibility，还是重写 externalization / compact 策略。

## 5. 审读记录卡

```text
审读对象:
受保护的边界:
governance key:
sovereign writer / choke point:
effective / applied / externalized 是否对齐:
失败语义是否分型:
durable assets / transient authority 是否可点名:
transient authority 是否有清空规则:
当前可见 capability surface 是否单源:
decision gain 是否仍存在:
host 是否只消费 externalized truth:
continuation 是否受条件约束:
自动化是否可撤销:
当前最像哪类扩张:
- 动作 / 能力 / 上下文 / 时间
下一步该重写的是:
- 治理主键 / 输入边界 / 写回顺序 / 失败语义 / visibility / continuation / externalization
```

## 6. 苏格拉底式检查清单

在你准备继续给系统加规则前，先问自己：

1. 我是在减少免费扩张，还是只是在增加表层摩擦。
2. 我保住的是治理主键和 externalized truth，还是只是暂时拦住了某个动作。
3. 我是在提高决策质量，还是在无增益地继续烧 token。
4. 自动化是租约，还是已经偷偷变成永久主权。
5. 这套东西出事故时，团队能否沿着治理主键、外化真相链、durable assets 与 writeback seam，而不是个人经验复盘。
