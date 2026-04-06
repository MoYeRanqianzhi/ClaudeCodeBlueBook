# 如何用苏格拉底诘问法审读Prompt魔力：message lineage、projection boundary与lawful forgetting

这一章不再解释 Prompt 为什么强，而是把“怎么审它是否真的强”压成一套 builder-facing 审读框架。

它主要回答五个问题：

1. 怎样避免把 Prompt 魔力重新写回措辞崇拜。
2. 怎样用递进式问题审读 `message lineage`、共享前缀、section 宪法、projection boundary 与 lawful forgetting。
3. 怎样判断一个 Prompt Constitution 是制度体，还是长文案。
4. 怎样在设计、排障与迁移时用同一组问题自我校准。
5. 怎样用苏格拉底式追问避免把审读模板写成另一份长 prompt。

## 0. 代表性源码锚点

- `claude-code-source-code/src/utils/systemPrompt.ts:28-127`
- `claude-code-source-code/src/constants/prompts.ts:105-560`
- `claude-code-source-code/src/constants/systemPromptSections.ts:17-43`
- `claude-code-source-code/src/query/stopHooks.ts:84-120`
- `claude-code-source-code/src/services/PromptSuggestion/promptSuggestion.ts:184-270`
- `claude-code-source-code/src/services/compact/sessionMemoryCompact.ts:188-397`
- `claude-code-source-code/src/utils/messages.ts:1989-2148`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:28-520`

这些锚点共同说明：

- Claude Code 的 Prompt 魔力不是某段文案写得更凶，而是 `message lineage`、共享前缀、边界、合法遗忘与 continuation qualification 被共同治理。

## 1. 对象对照：旧词汇与当前审读对象

这篇沿用的是较早一层词汇，但它审的仍是同一批正式对象。

1. `主语`
   - 现在更接近 `authority chain + message lineage owner`
2. `共享前缀`
   - 现在更接近 `section registry + stable prefix + cache-safe fork reuse`
3. `边界`
   - 现在更接近 `dynamic boundary + protocol transcript legality + projection boundary`
4. `合法遗忘`
   - 现在更接近 `lawful forgetting + continuation object continuity`
5. `接手连续性`
   - 现在更接近 `projection consumer + continuation qualification`

所以真正要审的不是一组旧词，而是：

- 当前 compiled request truth 挂在哪条 authority chain / message lineage 上
- 哪些 consumer 只是在消费投影
- 哪些 forgetting / handoff 之后仍保有合法 continuation

## 2. 第一性原理

更强的 prompt 不是：

- 让模型这一轮更听话

而是：

- 让当前、下一步、接手后仍消费同一条 `message lineage` 与同一份 compiled request truth

所以审读 Prompt 魔力时，最该反问的不是：

- 这段话够不够厉害

而是：

- 这套 prompt 是否已经把 continuation qualification、projection boundary 与 lawful forgetting 组织成同一条制度链

## 3. 苏格拉底诘问链

### 3.1 当前 compiled request truth 挂在哪条 authority chain / message lineage 上

判断标准：

- 如果说不清谁在续写这条 truth、谁只是在消费它、谁只是在显示它，这就不是制度，只是文案堆叠。

### 3.2 不同入口、不同宿主、不同回合消费的还是同一条 truth 吗

判断标准：

- 如果 REPL、SDK、bridge、resume 各自消费的是不同 projection，而不是同一条 compiled truth 的不同视图，后面所有“魔力”都会退化成路径偶然性。

### 3.3 哪些内容是共享前缀资产，谁是唯一合法生产者

判断标准：

- 如果主线程不是唯一稳定前缀生产者，而是多个旁路各自拼接“差不多的世界”，那得到的是多份世界模型，不是共享前缀。

### 3.4 你的 section 是宪法槽位，还是随手可换的段落分块

判断标准：

- 如果每个 section 没有明确职责、边界、优先级和变更理由，它就不是 constitutional slot，只是方便阅读的排版。

### 3.5 稳定前缀、动态边界与 projection boundary 到底画在了哪里

判断标准：

- 如果临时事实、局部状态、一次性观测漂进稳定前缀，或 display truth / protocol truth / handoff truth 的边界互相侵入，边界就是错的。

### 3.6 同一现场经过不同 assembly path，会被编译成同一份 prompt 真相吗

判断标准：

- 如果同一任务在不同组装路径下得到不同的制度字节、section 顺序或头部开关，那不是 cache-aware assembly，而是 path parity split。

### 3.7 什么变化会触发 invalidation，什么变化不该触发

判断标准：

- 如果失效条件靠“感觉这次改得挺大”，而不是由 section、边界、模型、工具面与状态事件显式触发，缓存稳定性只是运气。

### 3.8 哪些内容允许被忘掉，忘掉以后仍保住的是摘要还是 continuation object

判断标准：

- 如果 compact、summary、resume 之后只能留下“发生过什么”，却保不住 `continuation object`、`lineage ref` 或继续资格，那就是不合法的遗忘。

### 3.9 接手方不重读全量 transcript，也能判断这是 continuation、reopen 还是 new task 吗

判断标准：

- 如果接手仍必须扫描长历史才能知道当前约束、继续资格与下一步动作，这条 prompt 就没有形成可点名的 continuation qualification。

### 3.10 旁路查询、摘要、外置输出、恢复链会不会偷偷生成第二套 prompt 真相

判断标准：

- 如果 side query、summary、tool externalization、resume 结果不是在向不同 consumer 投影同一份 protocol truth，它们就在制造第二现场，而不是辅助主线。

### 3.11 当再增加上下文已不可能改变结论时，系统会停止扩张 prompt 吗

判断标准：

- 如果没有“何时不再值得继续加字节”的意识，只会不断追加、重放、重试，那追求的不是魔力，而是失控膨胀。

### 3.12 一旦 prompt 失灵，你能否用 section、边界、assembly、遗忘、接手这些词解释它

判断标准：

- 如果最后只能说“感觉变笨了”或“这次味道不对”，说明还没有把 prompt 做成可审读、可诊断的制度对象。

## 4. 常见自欺

看到下面信号时，应提高警惕：

1. 把 prompt 优化理解成继续堆 instruction。
2. 把共享前缀网络退回成每个旁路各自补背景。
3. 把 compact 理解成少留一点历史，而不是保住合法继续的 ABI。
4. 把 handoff 理解成“再写一段总结”，而不是延续同一工作主语。
5. 把 projection consumer 的分工写坏后，还以为只是展示差异，而不是制度分叉。
6. 把 cache break 理解成性能问题，而不是制度边界问题。

## 5. 更好的迭代顺序

当这组问题里有任何一个答不清时，优先做下面四步，而不是继续微调 prompt 文案：

1. 先回 `../philosophy/84`，判断自己改坏的是 authority、registry、boundary、protocol 还是 lawful forgetting。
2. 再回 `../architecture/82` 与 `../guides/99`，检查请求装配控制面和苏格拉底审读链哪里被重新拆散。
3. 再回 `../playbooks/77`，把 drift 写成正式的 verification 字段、reject 条件与 rollback object。
4. 最后才决定是修正文案、重画 boundary，还是修改 compact / recovery / fork 协议。

## 6. 审读记录卡

```text
审读对象:
compiled request truth:
message lineage ref:
当前主语:
projection consumers 是否对齐:
共享前缀生产者:
section 宪法是否明确:
dynamic boundary 是否稳定:
invalidation 触发器是否明确:
continuation qualification 是否可点名:
lawful forgetting ABI 是否成立:
当前最像哪类失效:
- section drift / boundary drift / projection-consumer split / transcript conflation / continuation-unqualified / lawful-forgetting failure / invalidation drift
下一步该重写的是:
- 主语 / lineage / 前缀 / 边界 / consumer / continuation / 恢复
```

## 7. 苏格拉底式检查清单

在你准备继续改 prompt 前，先问自己：

1. 我是在增强制度，还是在堆更长的文本。
2. 我改的是当前回合效果，还是跨回合继续工作的条件。
3. 我保住的是共享前缀和同一条 `message lineage`，还是只是保住了一段看起来熟悉的话。
4. 我是在减少 projection consumer 的分叉，还是在把接手代价推给未来的人。
5. 我能否解释这次强或弱是由哪类制度字节、哪条 continuation qualification 决定的。
