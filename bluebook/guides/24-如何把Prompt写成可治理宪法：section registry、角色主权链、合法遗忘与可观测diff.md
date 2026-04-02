# 如何把Prompt写成可治理宪法：section registry、角色主权链、合法遗忘与可观测diff

这一章回答五个问题：

1. 如果你在做自己的 agent runtime，怎样把 prompt 从“一段长文案”升级成可治理 Constitution。
2. 怎样把 section registry、dynamic boundary、角色主权链、合法遗忘和 prompt observability 一起落成工程动作。
3. 为什么 prompt 的“魔力”部分来自变更控制、删除策略和可解释性，而不只是写作技巧。
4. 怎样把 transport 差异收编进同一部 prompt 宪法，而不是让不同入口各写各的真相。
5. 怎样用苏格拉底式追问避免把 prompt 重新写回一段神秘文案。

## 0. 代表性源码锚点

- `claude-code-source-code/src/constants/prompts.ts:105-560`
- `claude-code-source-code/src/constants/systemPromptSections.ts:1-60`
- `claude-code-source-code/src/utils/systemPrompt.ts:28-115`
- `claude-code-source-code/src/utils/api.ts:321-388`
- `claude-code-source-code/src/utils/messages.ts:1989-2148`
- `claude-code-source-code/src/utils/conversationRecovery.ts:226-297`
- `claude-code-source-code/src/services/compact/prompt.ts:1-220`
- `claude-code-source-code/src/services/compact/sessionMemoryCompact.ts:188-397`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:28-520`
- `claude-code-source-code/src/utils/analyzeContext.ts:204-281`

这些锚点共同说明：

- Claude Code 不是“写了一段更强的 prompt”，而是先把 prompt 做成 section 宪法、角色主权链、合法遗忘法和可观测 diff 系统。

## 1. 先说结论

更成熟的 prompt 设计法，不是：

- 不断给 system prompt 加新段落

而是：

1. 先把 prompt 拆成 section registry。
2. 先明确 dynamic boundary，规定哪些条款有资格按回合重算。
3. 先建立角色主权链，决定谁能覆写当前身份。
4. 先建立准入法，定义哪些消息有资格进入 prompt 真相。
5. 先建立合法遗忘法，定义删掉什么之后系统仍然合法。
6. 先建立 diff 和 breakdown 机制，让 prompt 变成可解释基础设施。

如果你把这六件事都做了，prompt 才真的像一部：

- 可治理的宪法

## 2. 第一步：建立 section registry，而不是维护一团长字符串

Claude Code 的做法不是维护一个巨型 `SYSTEM_PROMPT` 常量，而是：

1. 先组织 static sections；
2. 再组织 dynamic sections；
3. 用 `systemPromptSection(...)` 声明普通条款；
4. 用 `DANGEROUS_uncachedSystemPromptSection(...)` 声明显式危险条款。

你在自己的 runtime 里可以直接照抄这一层动作：

```text
PromptRegistry:
- section name
- compute function
- cache scope
- 是否允许按回合重算
- 若会破坏稳定性，必须写明 reason
```

团队规则：

1. 新增 prompt 内容，优先以 section 进入 registry，而不是直接拼进正文。
2. 任何需要按回合重算的条款，都必须显式说明为什么值得打碎稳定性。
3. 任何无法命名的 prompt 片段，都说明它还没有被制度化。

这样做的第一收益不是“更漂亮”，而是：

- prompt 变更终于有了最小治理单位

## 3. 第二步：把 boundary 设计成可执行法律，而不是注释

Claude Code 用 `SYSTEM_PROMPT_DYNAMIC_BOUNDARY` 不是为了提醒读者，而是为了让 `splitSysPromptPrefix()` 和 `buildSystemPromptBlocks()` 真正按边界编译出不同 cache scope 的 block。

这给了一个非常直接的 builder 规则：

1. prompt 边界必须能被机器执行。
2. 边界必须决定缓存、重算、观测和归因行为。
3. 不要把“这里以后可能会动”写成注释，要把它做成编译期或发送期的正式语义。

可以落成一张团队表：

```text
Boundary Policy
- 边界前：共享前缀 / 稳定正文 / 尽量不漂移
- 边界后：动态修正案 / 按回合变化 / 必须可解释
- 任何跨边界移动都要视作架构变更，不是文案微调
```

## 4. 第三步：角色主权链先于 prompt 内容

`buildEffectiveSystemPrompt()` 先处理：

1. override；
2. coordinator；
3. agent；
4. custom；
5. default；
6. append。

这说明真正的 prompt 设计问题不是“写什么”，而是：

- 谁此刻有权定义“写什么”

如果你在做自己的系统，最稳的动作不是先写主 prompt，而是先画主权链：

```text
Role Sovereignty Chain
- 谁能完全覆盖
- 谁只能在默认之上追加
- 谁只能提供末尾补充
- 谁不得与谁并列
```

实践规则：

1. 协调者 prompt 与执行者 prompt 分离，不要混成一套。
2. domain agent prompt 要么明确替换默认，要么明确追加默认，不能隐式混写。
3. 用户 override 必须拥有正式上位权，而不是“最后再 append 一句”。

这样做的收益是：

- prompt 冲突从文案问题变成主权问题

## 5. 第四步：建立 prompt 准入法，而不是默认所有消息都算真相

`normalizeMessagesForAPI()` 的真正价值在于：

1. 它先判定哪些消息不配进入 prompt 真相；
2. 再把少数需要继续被模型引用的东西重编码成合法协议消息；
3. 最后修正会破坏推理或协议合法性的块。

这意味着你在做自己的 runtime 时，必须单独设计：

```text
Prompt Admission Law
- 哪些 UI 消息只为人类显示
- 哪些系统消息必须被重编码后才能给模型
- 哪些错误/进度/提示永远不能进入模型世界
- 哪些 tool-reference / attachment 需要在发送前被修复
```

没有这层法律，你的 prompt 很快会被：

- UI 簿记消息
- 进度消息
- 展示性补偿消息

污染成一团混合真相。

## 6. 第五步：把 compact、recovery、memory 统一进“合法遗忘法”

Claude Code 的 compact prompt、session memory compact 和 conversation recovery 共用一个更高阶的判断：

- 允许删除历史，但不允许破坏文法

你在自己的系统里也应这样设计：

1. 明确列出 compact 后必须保留的正式槽位。
2. 明确规定哪些引用链、thinking 归属、tool 配对绝不能被切断。
3. 对中断恢复，允许补合成边界，但必须保持后续协议合法。

可以直接沉淀成一张策略卡：

```text
Lawful Forgetting Policy
- 必保：intent / current work / next step / direct quote
- 必保：tool pairing / thinking ownership / chain continuity
- 可补：synthetic boundary / recovery sentinel
- 不保：单纯显示噪音 / 可再推导背景
```

真正成熟的 prompt 系统，不是最会记，而是：

- 最会合法地忘

## 7. 第六步：把 prompt 观测做成基础设施，而不是调试附属层

Claude Code 一边做：

1. promptCacheBreakDetection；
2. system/tool/beta/effort/extra-body diff；
3. per-section token breakdown；

一边继续维护 prompt 本体。

这给 builder 的启发非常直接：

1. prompt 本身必须可 hash。
2. section 级别的 token 分布必须可观测。
3. cache break 必须能说出是哪个输入源改了。
4. prompt 改动要像协议变更一样可以做回归分析。

最小可用落地版：

```text
Prompt Observability
- 每轮记录 effective prompt fingerprint
- 记录 section token breakdown
- 记录 tools/model/betas/extra-body 变化
- 出现 cache miss 时输出 diffable cause
```

如果没有这一层，你的团队最终会重新退回：

- “好像这周 prompt 变差了”

而不是：

- “是 section X 因为 late connect 改写了稳定前缀”

## 8. 第七步：让不同 transport 服从同一部宪法

Claude Code 的一个高明之处是：

- 不同 transport 可以变，但 prompt 语义不能散

所以 builder 侧要专门做一条规则：

1. transport adapter 先对齐 prompt admission law。
2. 不要让某个入口把 UI 消息直接送进模型。
3. 不要让某个入口绕开 lawful forgetting 和 recovery 补边。
4. attachment / delta / event stream 必须仍服从同一套 prompt Constitution。

如果做不到这一点，你最终会得到：

- REPL 一套 prompt 真相；
- SDK 一套 prompt 真相；
- remote / bridge 又是另一套。

这类系统短期也许能跑，长期一定会失控。

## 9. Prompt Constitution 落地清单

```text
[ ] prompt 已拆成 section registry
[ ] dynamic boundary 是可执行语义，不是注释
[ ] 角色主权链已明确
[ ] prompt admission law 已明确
[ ] lawful forgetting policy 已明确
[ ] prompt diff / token breakdown / cache-break diagnosis 已上线
[ ] transport adapter 服从同一部 prompt 宪法
```

## 10. 苏格拉底式检查清单

在你准备继续改 prompt 前，先问自己：

1. 我是在新增一条条款，还是继续往正文里堆匿名文本。
2. 我有权改这一层吗，还是我在越权覆盖更高位 prompt。
3. 这条变化应该进正文、动态修正案，还是 delta 附件。
4. 我删掉的东西是否仍然保住了协议文法和任务连续性。
5. 这次 prompt 变化能否被 diff、解释和追责。

如果这些问题答不清，你写的仍然是文案，不是 Constitution。

## 11. 一句话总结

Claude Code 值得学的不是一段更强的 system prompt，而是怎样把 prompt 写成一部可治理宪法：按 section 立法、按角色分配主权、按文法合法遗忘、按观测机制持续解释自己。
