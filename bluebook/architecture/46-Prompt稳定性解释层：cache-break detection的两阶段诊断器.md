# Prompt稳定性解释层：cache-break detection的两阶段诊断器

这一章回答五个问题：

1. 为什么 Claude Code 的 prompt 魔力不止来自稳定前缀，还来自“前缀失稳时系统能解释为什么失稳”。
2. `promptCacheBreakDetection` 为什么不是调试残留，而是正式运行时解释层。
3. 它如何把 pre-call snapshot 与 post-call token 观测拼成两阶段诊断器。
4. 为什么它会继续追踪 tool order、betas、effort、extra body、TTL 与 expected drop，而不是只盯 system prompt 文本。
5. 这对 Agent runtime 构建者意味着什么。

## 0. 代表性源码锚点

- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:28-119`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:220-433`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:437-706`
- `claude-code-source-code/src/services/api/claude.ts:1457-1486`
- `claude-code-source-code/src/services/api/claude.ts:2380-2391`
- `claude-code-source-code/src/utils/toolPool.ts:55-71`
- `claude-code-source-code/src/tools.ts:329-367`
- `claude-code-source-code/src/query/stopHooks.ts:92-99`

## 1. 先说结论

Claude Code 在 prompt 这一层已经不满足于：

- 让前缀稳定

它还继续做到：

- 当前缀不稳定时，系统要能解释为什么不稳定

这意味着它的 prompt 设计已经从：

1. 合同装配
2. 前缀共享
3. 预算观测

继续推进到第 4 层：

- 稳定性解释层

`promptCacheBreakDetection` 正是这一层最直接的证据。

## 2. 第一阶段：pre-call 先记录“所有可能影响 cache key 的客户端真相”

`recordPromptState(...)` 并不等 API 失败后才事后猜原因。

它在发请求之前就主动记录一份 `PromptStateSnapshot`，其中至少包括：

- `system`
- `toolSchemas`
- `querySource`
- `model`
- `fastMode`
- `globalCacheStrategy`
- `betas`
- `autoModeActive`
- `isUsingOverage`
- `cachedMCEnabled`
- `effortValue`
- `extraBodyParams`

这很关键，因为它说明 Claude Code 对 prompt 稳定性的理解不是：

- 看 system prompt 文本有没有变

而是：

- 看所有可能改变服务端 cache key 的客户端状态有没有变

### 2.1 它记录的不是“文本印象”，而是 diffable state

这里会维护：

- `systemHash`
- `toolsHash`
- `cacheControlHash`
- `perToolHashes`
- `toolNames`
- `systemCharCount`
- `betas`
- `effortValue`
- `extraBodyHash`

这意味着它并没有把 cache break 诊断写成：

- 一堆散乱 if 判断

而是写成：

- 一份权威 prompt state snapshot

### 2.2 defer-loading tools 被明确排除，避免假阳性

`claude.ts` 调用 `recordPromptState(...)` 前，会刻意过滤掉 `defer_loading` tools。

理由也写得很明白：

- API 并不会把它们放进真正 prompt
- 如果还把它们算进 hash，就会把“工具发现”误报成 cache break

这说明系统真正关心的不是：

- 当前代码里能看到哪些潜在工具

而是：

- 实际发给模型的 cache key 由什么构成

## 3. 第二阶段：post-call 不猜 break，而是看 usage 是否真的掉了

`checkResponseForCacheBreak(...)` 是第二阶段。

它不是简单看到 pending changes 就报警，而是继续看真正返回的：

- `cache_read_input_tokens`
- `cache_creation_input_tokens`

然后只在下面条件成立时才认定发生 break：

1. `cache_read_input_tokens` 相比上一轮明显下降
2. 绝对掉量超过最小阈值

这一步非常成熟，因为它说明 Claude Code 认定：

- 本地状态变化不等于真实 break

只有当服务端 usage 也证实 cache miss，系统才把变化升级成：

- break diagnosis

所以这不是“配置 diff 检测器”，而是：

- pre-call cause candidate
- post-call actual effect verification

组合成的两阶段诊断器。

## 4. 系统解释的不只是 system prompt，而是整条稳定性链

真正值得学的，是它解释的对象范围很宽。

### 4.1 文本层

它会解释：

- `systemPromptChanged`
- `systemCharDelta`

### 4.2 工具 ABI 层

它会解释：

- `toolSchemasChanged`
- `addedTools`
- `removedTools`
- `changedToolSchemas`

这说明作者明确知道：

- prompt 稳定性的一部分来自工具 ABI

而不只来自 system prompt 文本。

### 4.3 请求头 / 策略层

它会解释：

- `fastModeChanged`
- `betasChanged`
- `globalCacheStrategyChanged`
- `cacheControlChanged`
- `effortChanged`
- `extraBodyChanged`

这意味着 Claude Code 已经把 prompt 看成：

- 文本
- 工具
- 请求头
- provider body

共同组成的稳定性对象。

### 4.4 非 root cause 也会被谨慎降级

例如：

- `cacheControlChanged` 只有在没有更主要原因时才单独报告

这说明作者并不满足于“多报一些可能原因”，而是在尝试做：

- 更接近根因的解释

## 5. expected drop 与 TTL 说明它在解释“正常失稳”，而不是只解释异常

这部分尤其成熟。

### 5.1 cache deletion / compaction 不是 break

源码里明确提供了：

- `notifyCacheDeletion(...)`
- `notifyCompaction(...)`

前者表示 cached microcompact 删除导致的 cache read 下降是预期行为；
后者在 compaction 后直接重置 baseline，避免把后续正常下降误报成 break。

这说明系统已经知道：

- 有些“变少”不是故障，而是策略结果

### 5.2 TTL 过期与 server-side eviction 也被纳入解释模型

当本地没有明显变化时，它还会继续判断：

- 是否超过 5 分钟
- 是否超过 1 小时

然后把原因解释成：

- possible 5min TTL expiry
- possible 1h TTL expiry
- likely server-side

这一步很关键，因为它说明 Claude Code 的 prompt 哲学不是：

- 只要 cache 断了，就是本地 prompt 设计错了

而是：

- 先分清本地原因、TTL 原因、服务端原因

这已经超出“调试 prompt”的范畴，进入了：

- prompt reliability engineering

## 6. diff file 与 debug summary 说明它不只想报事件，还想让人类真正能排查

`writeCacheBreakDiff(...)` 会把前后 diffable content 写成 patch 文件。

而 summary log 里会继续带上：

- source
- call number
- cache read 变化
- creation tokens
- diff path

这说明系统不只是想把 break 记成 analytics 事件，还想给工程师留下：

- 真正可排查的证据

所以这套设计不是：

- 神秘地“感觉 prompt 变弱了”

而是：

- 给出可复盘的 prompt-state diff

## 7. 为什么这直接解释了“prompt 为什么有魔力”

很多系统的 prompt 一旦失效，团队只能说：

- 最近感觉不稳定
- 也许是 prompt 文字改坏了

Claude Code 的做法完全不同。

它在说：

1. prompt 强，不只因为结构稳定
2. prompt 更强，是因为结构失稳也可解释

这才是真正难抄的地方。

抄一段 system prompt，很容易。
抄一套：

- 前缀稳定性建模
- 两阶段 break 诊断
- expected drop 豁免
- TTL / server-side 分流
- diffable evidence

就难得多。

## 8. 苏格拉底式追问

### 8.1 如果 prompt 的魔力真的只是文案，为什么要在请求前后都记录状态

因为真正重要的不是文案，而是：

- 哪些运行时条件让这段文案仍然可复用

### 8.2 如果 cache 断了就简单归咎于 system prompt，为什么还要跟踪 tools、betas、effort、extra body

因为 Claude Code 早已把 prompt 看成整条 request surface，而不是一段文本。

### 8.3 如果系统只是想报错，为什么还要区分 compaction、cache deletion、TTL 与 server-side

因为成熟系统不该把所有失稳都描述成 bug。

### 8.4 为什么这比“再写一版更强的 prompt”更值得学

因为更强的文案只能提升成功时的效果；
可解释稳定性提升的是：

- 成功时的复用能力
- 失效时的诊断能力

## 9. 一句话总结

Claude Code 的 prompt 魔力不只来自稳定前缀，还来自 `promptCacheBreakDetection` 这类解释层把“为什么稳定、为什么失稳”都做成了可诊断对象。
