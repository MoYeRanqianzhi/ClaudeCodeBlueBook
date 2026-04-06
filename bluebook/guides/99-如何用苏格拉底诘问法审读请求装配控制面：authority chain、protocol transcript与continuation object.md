# 如何用苏格拉底诘问法审读请求装配控制面：message lineage、protocol transcript与continuation object

这一章不再解释 Prompt 为什么强，而是把 `architecture/82` 与 `philosophy/84` 继续压成一套 builder-facing 审读模板。

它主要回答五个问题：

1. 怎样避免把 Prompt 魔力重新写回 system prompt 咒语。
2. 怎样按固定顺序审读 `authority chain`、`section registry`、`dynamic boundary`、`protocol transcript`、`message lineage` 与 `continuation object`。
3. 怎样判断一个 runtime 是否真的先把世界编译进模型，而不是先把世界描述给模型。
4. 怎样识别那些看起来更聪明、实际更脆的坏改写。
5. 怎样用苏格拉底式追问避免把这份模板重新写成一份更长的 Prompt 规范。

## 0. 代表性源码锚点

- `claude-code-source-code/src/constants/systemPromptSections.ts:16-65`
- `claude-code-source-code/src/constants/prompts.ts:491-576`
- `claude-code-source-code/src/utils/systemPrompt.ts:28-123`
- `claude-code-source-code/src/utils/api.ts:321-405`
- `claude-code-source-code/src/utils/messages.ts:1989-2148`
- `claude-code-source-code/src/utils/messages.ts:5133-5458`
- `claude-code-source-code/src/types/logs.ts:221-223`
- `claude-code-source-code/src/utils/sessionStorage.ts:1028-1066`
- `claude-code-source-code/src/services/compact/sessionMemoryCompact.ts:188-327`
- `claude-code-source-code/src/query/stopHooks.ts:84-214`
- `claude-code-source-code/src/utils/forkedAgent.ts:46-126`
- `../architecture/82-请求装配流水线：authority chain、section registry、protocol transcript、lawful forgetting与cache-safe forks.md`
- `../philosophy/84-真正有魔力的Prompt，会先规定世界如何合法进入模型.md`

这些锚点共同说明：

- Prompt 魔力真正保护的更硬对象，不是单次 request 壳，而是同一条可被显示、协议与交接共同重建的 `message lineage`。

## 1. 第一性原理

成熟的 Prompt runtime 首先要回答的不是：

- 模型该怎么说

而是：

- 世界怎样合法进入模型

所以更高阶的审读顺序，不该从文案开始，而应从：

1. 谁能宣布当前世界
2. 哪些制度字节属于正式 Prompt 宪法
3. 哪条 transcript 配进入模型
4. 哪些 lineage key 在 compact / fork / resume 后仍保住同一身份

开始。

## 2. 苏格拉底诘问链

### 2.1 现在到底是谁在定义世界

判断标准：

- 如果 `override / coordinator / agent / custom / default / append` 这些主语位点并不清楚，Prompt 就还不是制度体。

### 2.2 你的 Prompt 是一段 blob，还是一组有生命周期的 section 宪法

判断标准：

- 如果 section 只负责排版，不负责职责、缓存与重置语义，那它们还不是 constitutional slots。

### 2.3 哪些内容是 stable prefix，哪些内容只是晚绑定 delta

判断标准：

- 如果高波动事实和一次性观测进入长期正文，或关键法条只能依赖动态尾部成立，边界就是错的。

### 2.4 display transcript、protocol transcript 与 continuation object 是否已被明确分层

判断标准：

- 如果人类看见的历史、模型消费的历史、compact 后仍能继续工作的对象被写成一层，或者三者已经脱离同一条 message lineage，系统迟早会出现 path drift。

### 2.5 compact 保住的是任务身份，还是只保住了更好读的摘要

判断标准：

- 如果 compact 后只能知道“发生过什么”，却不知道“下一步受什么约束”，那 lawful forgetting 还没成立。

### 2.6 旁路循环复用的是同一个世界，还是各自重建近似世界

判断标准：

- 如果 `/btw`、summary、memory extraction、worker findings、prompt suggestion 各自重述现场，而不是围绕同一 stable prefix fork，并沿同一条 message lineage 回流，就还在制造平行世界。

### 2.7 工具 ABI、cache break 与 continue qualification 有没有进入 Prompt 真相本体

判断标准：

- 如果工具 schema、配对合法性、continue gate 仍被视为“Prompt 外部细节”，那 Prompt 魔力就会退回咒语工程。

### 2.7.1 你的 lineage kernel 是一键、两键还是三键协同

判断标准：

- 如果 `parentUuid / message.id / tool_use_id` 的职责没有分开，后续一旦进入 compact、tool pairing 或 replay，系统就会开始错配是谁在继续同一个世界。

### 2.8 当 behavior drift 发生时，团队能否点名断的是哪一层边界

判断标准：

- 如果最后只能说“模型这次变笨了”，而不能说是 `authority chain / section registry / protocol transcript / lawful forgetting / continuation object` 哪一层失守，就还没有形成可解释 Prompt runtime。

## 3. 常见自欺

看到下面信号时，应提高警惕：

1. 以为 system prompt 更长就更强。
2. 以为 UI transcript 已经足够接近模型看到的 transcript。
3. 以为 summary 更完整就等于 lawful forgetting。
4. 以为 side loop 只是性能分支，不会制造第二真相。
5. 以为 cache、stable bytes 与 continue qualification 只是性能或产品体验问题。

## 4. 更好的迭代顺序

当这组问题里有任何一个答不清时，优先做下面四步：

1. 先回 `../philosophy/84` 与 `../architecture/82`，判断自己改坏的是主权链、section 宪法、历史分层还是继续对象。
2. 再回 `30`，用旧一层的 Prompt 审读模板确认是主语、共享前缀、边界还是合法遗忘先失真。
3. 再检查 `messages.ts`、`sessionMemoryCompact.ts`、`stopHooks.ts` 与 `forkedAgent.ts` 对应的对象边界是否被某条旁路绕开。
4. 最后才决定要不要重写文案；多数情况下，应该先修世界准入，而不是先修语气。

## 5. 审读记录卡

```text
审读对象:
当前 authority chain:
section registry 是否成立:
stable prefix / dynamic boundary 是否清楚:
display transcript 与 protocol transcript 是否分层:
continuation object 是否成立:
lineage kernel 是否清楚区分 `parentUuid / message.id / tool_use_id`:
display / protocol / handoff 是否仍沿同一条 message lineage 投影:
旁路循环是否复用同一世界:
当前最像哪类失真:
- authority drift / section drift / boundary leak / transcript conflation / unlawful forgetting / parallel-world fork
优先回修对象:
- 主权链 / section / boundary / transcript compiler / compact object / fork reuse
```

## 6. 苏格拉底式检查清单

在你准备继续改 Prompt 前，先问自己：

1. 我现在优化的是文案，还是世界准入方式。
2. 如果多份文本冲突，谁真正说了算。
3. compact 后留下的是对象身份，还是只有叙事残影。
4. worker、summary、memory、suggestion 是否仍复用同一编译世界。
5. 模型此刻消费的到底是哪条 transcript。
6. `parentUuid / message.id / tool_use_id` 这三类 lineage key 各自保什么不变量。
7. display / protocol / handoff 三种 truth 还是不是同一条 message lineage 的不同投影。
8. 继续资格是谁签发的，在哪失效。
9. 如果把著名措辞全部删掉，这套世界编译机制还会不会成立。

## 7. 一句话总结

要审读 Prompt 魔力，就不要只审 Prompt 文案；真正该审的是请求装配控制面是否先把世界合法编译进模型，并在遗忘、分叉与恢复后继续保住同一身份。
