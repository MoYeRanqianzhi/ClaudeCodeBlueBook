# 如何用苏格拉底诘问法审读Prompt效力：lineage kernel、projection consumers与lawful forgetting

> Evidence mode
> - 当前 worktree 若仍缺 `claude-code-source-code/` 镜像，本页所有 `src/...` 路径都只按 archival anchors 读取。
> - 本页只负责 builder-facing 审读链，不把这些锚点单独写成 live runtime proof；owner law 继续回 `../philosophy/84`，canonical witness chain 继续回 `../philosophy/81`。

这一章不再解释 Prompt 为什么强，而是把“怎么审它是否具备稳定 Prompt效力”压成一套 builder-facing 审读框架。

它主要回答五个问题：

1. 怎样避免把 Prompt效力重新写回措辞崇拜。
2. 怎样用递进式问题审读 `message lineage`、共享前缀、section 宪法、projection consumers 与 lawful forgetting。
3. 怎样判断一个 Prompt Constitution 是制度体，还是长文案。
4. 怎样在设计、排障与迁移时用同一组问题自我校准。
5. 怎样把苏格拉底式追问落成可执行的判定与拒绝链，而不是另一份长 prompt。

## 0. 代表性源码锚点

- `claude-code-source-code/src/utils/systemPrompt.ts:28-127`
- `claude-code-source-code/src/constants/prompts.ts:105-560`
- `claude-code-source-code/src/constants/systemPromptSections.ts:17-43`
- `claude-code-source-code/src/query/stopHooks.ts:84-120`
- `claude-code-source-code/src/services/PromptSuggestion/promptSuggestion.ts:184-270`
- `claude-code-source-code/src/services/compact/sessionMemoryCompact.ts:188-397`
- `claude-code-source-code/src/utils/messages.ts:1989-2148`
- `claude-code-source-code/src/utils/sessionStorage.ts:1025-1034`
- `claude-code-source-code/src/utils/sessionStorage.ts:2069-2128`
- `claude-code-source-code/src/query/tokenBudget.ts:45-92`
- `claude-code-source-code/src/tools/AgentTool/resumeAgent.ts:70-130`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:28-520`

这些锚点共同说明：

- Claude Code 的 Prompt效力不是某段文案写得更凶，而是 later consumer 原本要重做的世界重判、动作搜索与排除理由重写被系统提前退休；`message lineage`、共享前缀、consumer 分层、合法遗忘与 continuation qualification 只是这套退休机制被保住的实现对象。

## 1. 对象对照：旧词汇与当前审读对象

这篇沿用的是较早一层词汇，但它审的仍是同一批正式对象。

1. `主语`
   - 现在更接近 `authority chain + message lineage owner`
2. `lineage kernel`
   - 现在更接近 `parentUuid / logicalParentUuid + message.id + tool_use_id / sourceToolAssistantUUID`
3. `共享前缀`
   - 现在更接近 `section registry + stable prefix + cache-safe fork reuse`
4. `边界`
   - 现在更接近 `dynamic boundary + protocol transcript legality + projection boundary`
5. `合法遗忘`
   - 现在更接近 `lawful forgetting + search-pruning preservation + decision-retirement preservation`
6. `接手连续性`
   - 现在更接近 `later-consumer lawful inheritance + admissibility-tested continuation qualification`
   - 更准确地说，这里保留旧词只是为了检索；若只有 continuity feeling、belonging 或 carrier，而没有 admissibility-tested witness，就还不算合法继承

所以真正要审的不是一组旧词，而是：

- 当前 request compile chain 挂在哪条 authority chain / `message lineage` 上
- 哪些 consumer 只是在消费投影
- 哪些 forgetting / handoff 之后仍保有合法 continuation

这也意味着，这篇允许保留旧助记词，但 Prompt 线真正唯一 canonical object chain 仍只认：

1. `message lineage`
2. `section registry / stable boundary`
3. `protocol transcript`
4. `continuation object`
5. `continuation qualification`

`compile -> protocolize -> preserve -> continue -> explain` 只是动作链；
`world entry / request assembly / six-stage assembly chain` 与 `request-surface constitution / cognitive contract / byte boundary / continuation truth` 只是 route shorthand。
它们首次出现时，都必须回绑到上面这条 canonical object chain。

## 2. 第一性原理

更强的 prompt 不是：

- 让模型这一轮更听话

而是：

- 让当前、下一步、接手后仍消费同一条 `message lineage` 与同一份 request compile chain

所以审读 Prompt效力时，最该反问的不是：

- 这段话够不够厉害

而是：

- 这套 prompt 是否已经把 lineage kernel、projection consumer、continuation qualification 与 lawful forgetting 组织成同一条制度链

凡声称“仍是同一世界”，都必须能点名 witness：authority owner、stable prefix ref、`protocol transcript` ref、`continuation object` ref、`continue-or-reject verdict`。没有 witness，就不是继承，只是叙述。更硬一点说，Prompt 审读最终也只在追三件事：`lawful inheritance` 有没有保住同一工作对象，`search-pruning` 有没有保住已排除分支，`decision-retirement` 有没有保住旧判断继续退役。

## 3. 苏格拉底可执行判定链

执行协议先固定为五步：

0. Gate-0：先写明这次系统试图退休的决策是什么、谁继承这项退休、哪一批分支继续保持被排除、以及没有新增 `decision delta` 时哪组旧判断必须继续退役，下一位 consumer 又凭什么拒绝重放。

1. 输入：`compiled request truth`、`witness chain`、consumer matrix、carrier surface inventory / effect ceiling、当前 continuation object。
2. 每个 gate 必须产出 `pass | provisional | reject | unknown`。
3. `provisional / reject / unknown` 一律视为当前不可继续，必须写出 `reject signal + rollback object + next action`；其中 `provisional` 默认表示 carrier-only 或 witness 尚未回绑，`reject` 则表示已出现明确越权或制度冲突。
4. 仅当关键 gate 全部 `pass`，才允许产出 `continuation qualification = continue`。

### 3.1 Gate-1：`message lineage` 还是三键内核吗

- 输入：`parentUuid / logicalParentUuid`、`message.id`、`tool_use_id / sourceToolAssistantUUID`
- 通过条件：三键都可点名且职责不冲突
- reject signal：任一键缺失或职责混淆
- 失败动作：冻结继续资格，先补 lineage witness

### 3.2 Gate-2：request compile chain 是否挂在明确 authority chain 上

- 输入：authority owner、writer、consumer、display actor
- 通过条件：谁续写 truth、谁消费 truth、谁展示 truth 可区分
- reject signal：角色混写或只能靠口头解释
- 失败动作：重写 authority map，再重新编译

### 3.3 Gate-3：多入口是否仍消费同一份 compiled request truth

- 输入：REPL / SDK / bridge / resume 的投影样本
- 通过条件：不同入口只显示差异，不改变 same-world truth
- reject signal：入口间出现 path parity split
- 失败动作：标记 projection-consumer split 并停止继续

### 3.3A Gate-3A：carrier 是否越权突破 `effect ceiling`

- 输入：summary / sticky prompt / session memory / handoff prose / display transcript 等 carrier surface
- 通过条件：这些 surface 只负责定位、提醒、展示或 receipt，不单独改判 `world-definition / boundary / continue qualification`
- reject signal：任一 carrier 在无 witness rebind 的前提下开始替 later consumer 代签 same-world continuation
- 失败动作：先记成 `effect-ceiling breach`，本地 verdict 至少落 `provisional`；若 carrier 已实际代签 continue 资格，则直接升格成 `reject`

### 3.4 Gate-4：`same-world witness` 是否可点名

- 输入：`message_lineage_ref / section_registry_ref / stable_prefix_ref / protocol_transcript_ref / continuation_object_ref / continue_qualification_verdict`
- 通过条件：六项 witness 可被独立验证且互相一致，并且能区分哪些只证明 belonging、哪些已经通过 admissibility gate；若对象只证明 belonging 而未过 admissibility，它仍不是 lawful inheritance
- reject signal：任一 witness 无法点名或互相冲突
- 失败动作：进入 rollback，禁止用总结 prose 代替 witness

### 3.5 Gate-5：projection consumer matrix 是否对齐

- 输入：display transcript、`protocol transcript`、SDK/control projection、`continuation object`
- 通过条件：每个 consumer 只消费其合法投影
- reject signal：把投影差异误当真相差异
- 失败动作：重画 consumer matrix 并回填边界

### 3.6 Gate-6：共享前缀是否仍由唯一合法生产者维护

- 输入：stable prefix producer 列表、fork/reuse 规则
- 通过条件：主线程是唯一稳定前缀生产者
- reject signal：多个旁路各自产生“差不多的世界”
- 失败动作：关闭旁路写入，回收到主线程重编译

### 3.7 Gate-7：section 是否是宪法槽位而非排版分块

- 输入：section 职责、优先级、边界、变更理由
- 通过条件：section 变更可追溯且具制度理由
- reject signal：section 仅剩阅读友好，不具约束力
- 失败动作：补 section registry 与 change reason

### 3.8 Gate-8：stable boundary / dynamic boundary / projection boundary 是否清晰

- 输入：边界定义与越界样本
- 通过条件：临时事实不漂进稳定前缀，三类 truth 不互侵
- reject signal：display truth / protocol truth / handoff truth 混叠
- 失败动作：触发 boundary drift reject，并生成回退对象

### 3.9 Gate-9：invalidation 触发器是否制度化

- 输入：失效规则、section/模型/工具/状态事件触发表
- 通过条件：触发器由显式规则决定，不靠“感觉变动大”
- reject signal：缓存失效依赖作者直觉
- 失败动作：补 invalidation rulebook 后再评估

### 3.10 Gate-10：lawful forgetting 后是否仍保留 continuation object

- 输入：compact / summary / resume 前后对象对照
- 通过条件：forgetting 后删掉的字节不改变 `continuation object`、已排除分支与 `continue-or-reject verdict`，且仍可点名 continuation object、lineage ref 与资格；没有新增 `decision delta` 时，旧判断也继续保持退役，不得因 `compact / summary / resume` 重新进入 candidate set
- reject signal：只剩“发生过什么”的摘要叙事
- 失败动作：回退至 forgetting 前版本并重做 compact；若只能压缩 display，而不能保住执行真相，就禁止把这次 compact 记成 lawful forgetting

### 3.11 Gate-11：handoff 是否无需重读全量 transcript 即可判定继续资格

- 输入：handoff 包、约束清单、next action
- 通过条件：接手方可直接判断 continuation / reopen / new task，而不必重做 `world-definition / tool-legality / next-action search`，且没有新增 `decision delta` 时，旧判断与已排除分支继续保持退役
- reject signal：必须扫长历史才能继续
- 失败动作：补 continuation qualification card

### 3.12 Gate-12：旁路流程是否在重绑 witness，而不是静默重造世界

- 输入：`compact / resume / fork / handoff` 的重绑记录
- 通过条件：旁路只重绑 witness，不新造第二套 truth；若旁路只搬运 carrier / summary / display convenience，而无 witness rebind，仍判 fail
- reject signal：旁路可在无 witness 重绑下继续行动
- 失败动作：标记 continuation-story-only，拒绝放行

### 3.13 Gate-13：当决策增益归零时，系统是否停止扩张 prompt

- 输入：decision gain 记录、token 增长与结论变化
- 通过条件：结论不再变化时停止追加字节
- reject signal：持续追加、重放、重试但无新增决策
- 失败动作：触发 continuation pricing gate，强制停机

### 3.14 Gate-14：失效解释是否落在制度对象而非感受词

- 输入：故障解释文本
- 通过条件：可明确归因到 section / lineage / consumer / forgetting / handoff
- reject signal：仅有“变笨了”“味道不对”
- 失败动作：故障报告退回重写，不得进入评审通过态

## 4. 常见自欺

看到下面信号时，应提高警惕：

1. 把 prompt 优化理解成继续堆 instruction。
2. 把 `message lineage` 退回成“历史大概还在”。
3. 把共享前缀网络退回成每个旁路各自补背景。
4. 把 compact 理解成少留一点历史，而不是保住合法继续的 ABI。
5. 把 handoff 理解成“再写一段总结”，而不是延续同一工作主语。
6. 把 projection consumer 的分工写坏后，还以为只是展示差异，而不是制度分叉。
7. 把 cache break 理解成性能问题，而不是制度边界问题。
8. 把 `systemPrompt` 截图、最后一条 assistant 消息或 summary prose 当成 Prompt效力主语。

## 5. 更好的迭代顺序

当这组问题里有任何一个答不清时，优先做下面四步，而不是继续微调 prompt 文案：

1. 先在本页把问题 typing 成 `lineage / consumer / boundary / forgetting / continuation` 哪一类 drift，而不是先跳页找答案。
2. 若 drift 落在 canonical witness chain，回 `../philosophy/81`；若 drift 落在 request assembly / object seam，再只选一个 `../architecture/82` 或 `../guides/99` 继续下钻。
3. 若怀疑自己已经把 witness 偷换成更会解释的替身，再回 `../casebooks/73` 做反例核对。
4. 只有 drift 类型与 owner page 都锁定后，才回 `../playbooks/77` 把它写成正式 verification 字段、reject 条件与 rollback object。

## 6. 审读记录卡

```text
审读对象:
compiled request truth:
message lineage ref:
carrier surface inventory:
effect ceiling 是否守住:
lineage kernel 是否完整:
当前主语:
projection consumer matrix 是否对齐:
same-world witness 是否完整:
共享前缀生产者:
section 宪法是否明确:
dynamic boundary 是否稳定:
continuation object 最小对象是否完整:
invalidation 触发器是否明确:
continuation qualification 是否可点名:
本地 verdict:
lawful forgetting ABI 是否成立:
当前最像哪类失效:
- effect-ceiling breach / carrier-only provisional / lineage-kernel shadow / section drift / boundary drift / projection-consumer split / transcript conflation / continuation-story-only / continuation-unqualified / lawful-forgetting failure / invalidation drift
下一步该重写的是:
- 主语 / effect ceiling / lineage kernel / 前缀 / 边界 / consumer matrix / continuation object / 恢复
```

## 7. 苏格拉底式检查清单

在你准备继续改 prompt 前，先问自己：

1. 我是在增强制度，还是在堆更长的文本。
2. 我改的是当前回合效果，还是跨回合继续工作的条件。
3. 我保住的是共享前缀和同一条 `message lineage`，还是只是保住了一段看起来熟悉的话。
4. 我现在依赖的是 witness，还是某个 carrier 已经在偷偷越权代签 `continue qualification`。
5. 我是在减少 projection consumer 的分叉，还是在把接手代价推给未来的人。
6. 我能否解释这次强或弱是由哪类制度字节、哪条 continuation qualification 决定的。
7. 我删掉 `systemPrompt` 截图、最后一条回复和 summary prose 后，这条 Prompt 论证还成立吗。
