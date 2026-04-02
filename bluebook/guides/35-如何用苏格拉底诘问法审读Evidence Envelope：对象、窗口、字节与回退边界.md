# 如何用苏格拉底诘问法审读Evidence Envelope：对象、窗口、字节与回退边界

这一章不再解释 evidence envelope 为什么要共享，而是把“怎么审它是否真的成立”压成一套 builder-facing 框架。

它主要回答五个问题：

1. 怎样避免把 shared evidence envelope 退回更多 dashboard、更多表单或更多日志。
2. 怎样用递进式问题审读对象、窗口、字节与回退边界。
3. 怎样判断宿主、CI、评审与交接是否真的共享同一套升级真相。
4. 怎样在 rollout、复盘、交接与宿主接入时复用同一组问题。
5. 怎样用苏格拉底式追问避免把 evidence envelope 写成新一轮流程主义。

## 0. 代表性源码锚点

- `claude-code-source-code/src/utils/sessionState.ts:92-146`
- `claude-code-source-code/src/state/onChangeAppState.ts:43-90`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:243-360`
- `claude-code-source-code/src/utils/messages.ts:1989-2075`
- `claude-code-source-code/src/query/tokenBudget.ts:1-82`
- `claude-code-source-code/src/utils/QueryGuard.ts:1-83`
- `claude-code-source-code/src/services/api/sessionIngress.ts:57-170`
- `claude-code-source-code/src/utils/task/framework.ts:160-248`

这些锚点共同说明：

- 共享 evidence envelope 的核心，不是所有人看到同样多的细节，而是所有人围绕同一对象、同一窗口、同一字节与同一回退边界继续判断。

## 1. 第一性原理

更强的 evidence envelope 不是：

- 更多记录

而是：

- 让不同消费者在不同时间点，仍然依赖同一套判断条件

所以审读 evidence envelope 时，最该反问的不是：

- 这份材料看起来够不够完整

而是：

- 它是否已经足以约束未来判断，而不只是解释过去发生了什么

## 2. 苏格拉底诘问链

### 2.1 这份 evidence 到底在描述哪个对象

判断标准：

- 如果对象还需要靠阅读者自己猜，它就不是 envelope，只是松散材料集合。

### 2.2 这个对象的 authority surface 是否能被一口指出

判断标准：

- 如果说不清是谁在宣布当前真相，后面的 status、diff、rollback 都会漂。

### 2.3 当前状态来自 authoritative signal，还是来自事后推断

判断标准：

- 如果还要从 transcript 猜“现在可能在等审批”，就说明 envelope 还没成立。

### 2.4 这里的 diff 是编译后 request truth 的 diff，还是原始文案/文件的 diff

判断标准：

- 如果只看原文 prompt 或文件改动，而不看 normalized request truth、tool pairing、stable bytes，diff 就不够制度化。

### 2.5 observed window 是否明确

判断标准：

- 如果说不清这次 judgement 是基于哪一段时间、哪一组对象、哪一类 cohort 作出的，结论就无法复核。

### 2.6 当前继续、停止、升级对象或回退的判断窗口是否已经写明

判断标准：

- 如果 evidence 只能解释“发生了什么”，不能解释“为什么现在该继续或停下”，它还不是成熟 envelope。

### 2.7 control evidence 是否能说明谁赢下了仲裁

判断标准：

- 如果审批相关证据里没有 request / response / cancel / pending_action 的结构化链路，就只能得到情绪化解释，而不是治理判断。

### 2.8 这套 evidence 对宿主、CI、评审与交接而言，骨架是否相同

判断标准：

- 如果每一类消费者都要重新拼字段，说明 shared envelope 只是口号。

### 2.9 哪些字段是正式公共表面，哪些只是 internal hint

判断标准：

- 如果把 internal hint 误写成稳定 schema，后面会陷入另一种半真相。

### 2.10 rollback boundary 是否按对象写清，而不是按文件写清

判断标准：

- 如果一到回退就只剩文件和 commit，说明 envelope 还没有真正保护对象真相。

### 2.11 retained assets 是否已经点名

判断标准：

- 如果回退只说“恢复旧版本”，却说不清保留了哪些资产、拦住了哪些 stale writer，这份证据还不够支撑接手。

### 2.12 原作者离开后，这份 envelope 还能继续约束未来判断吗

判断标准：

- 如果答案是否定的，那它仍只是作者的说明，不是系统的证据面。

## 3. 常见自欺

看到下面信号时，应提高警惕：

1. 用更多图表替代 authority surface。
2. 用更多日志替代 observed window。
3. 用更多结论替代 decision window。
4. 用更多文件列表替代 rollback object boundary。
5. 用“大家都有各自视图”掩盖 shared envelope 实际并不存在。

## 4. 更好的迭代顺序

当这组问题里有任何一个答不清时，优先做下面四步：

1. 先回 `../philosophy/68` 与 `../philosophy/67`，判断自己缺的是对象、窗口、字节，还是回退边界。
2. 再回 `../architecture/77` 与 `../architecture/76`，检查 shared evidence envelope 和 upgrade evidence surface 是否已分裂。
3. 再回 `../api/35` 与 `../api/36`，确认正式公共表面、宿主 envelope 与 internal hint 三层边界是否还清楚。
4. 最后才决定是补字段、调消费顺序、补 rollback object，还是补 diff summary。

## 5. 审读记录卡

```text
审读对象:
authority surface:
current status signals:
compiled diff signals:
observed window:
decision window:
rollback object boundary:
shared envelope 是否被四类消费者共同消费:
当前最像哪类失效:
- 对象漂移 / 窗口缺失 / 字节失真 / 回退边界错误 / 消费骨架不一致
下一步该重写的是:
- object / status / diff / window / rollback / consumer matrix
```

## 6. 苏格拉底式检查清单

在你准备宣布“我们已经有 shared evidence envelope”前，先问自己：

1. 我统一的是判断条件，还是只统一了材料格式。
2. 我保住的是对象真相，还是只保住了一份解释文本。
3. 我让不同消费者共享的是同一骨架，还是同一堆原始日志。
4. 我是在减少未来判断分歧，还是在增加另一层流程负担。
5. 如果今天换一批维护者，他们还能沿这份 envelope 做出同样判断吗。
