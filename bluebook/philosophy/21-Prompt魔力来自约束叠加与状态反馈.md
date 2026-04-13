# Prompt 魔力来自约束叠加与状态反馈

这一章回答四个问题：

1. Claude Code 的 prompt 为什么会显得“比普通 prompt 更有魔力”。
2. 这种魔力为什么不是文案技巧，而是 runtime 约束叠加。
3. 缓存稳定性与状态晚绑定为什么会反过来塑造 prompt 结构。
4. 从第一性原理看，什么才是最难被抄走的 prompt 能力。

## 0. 代表性源码锚点

- `claude-code-source-code/src/utils/systemPrompt.ts:29-123`
- `claude-code-source-code/src/constants/prompts.ts:226-394`
- `claude-code-source-code/src/constants/prompts.ts:467-549`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:24-260`
- `claude-code-source-code/src/utils/attachments.ts:3521-3685`
- `claude-code-source-code/src/coordinator/coordinatorMode.ts:120-300`
- `claude-code-source-code/src/tools/AgentTool/prompt.ts:48-272`

## 1. 先说结论

Claude Code 的 prompt 魔力，如果从第一性原理收束，首先不是把模型说服得更彻底，而是把 later consumer 本来要重做的世界重判、动作搜索与排除理由重写提前退休。

强 Prompt 因而首先是一个 `decision-retirement system`：`verify / delegate / tool choice / resume / handoff` 之后，接手者继承的必须是同一份工作对象、同一批仍被排除的分支，以及同一条 `continue-or-reject verdict`。

“约束叠加与状态反馈”仍然成立，但它现在只是这套退休机制的 runtime 现象，而不是另一套 frontdoor。

如果再把这套退休机制拆回旧的六个 nouns，大致对应成：

1. 装配顺序：
   - `Authority`
   - override、coordinator、agent、custom、default、append 先决定谁有资格写这轮 system contract。
2. 角色约束与工具 ABI：
   - `Boundary`
   - coordinator、主线程 agent、forked worker、teammate 各自拿到不同边界；模型看到的是被裁剪后的行动空间，而不是抽象能力想象。
3. 缓存结构：
   - `Boundary`
   - stable prefix、dynamic boundary、attachments 的分层，本质是在保护“同一世界怎样合法进入模型”。
4. 状态反馈：
   - `Transcript`
   - date change、relevant memories、mailbox、task notification、channel input 不是随手补文案，而是在补这一轮协议 transcript。
5. 协作语法：
   - `Lineage -> Continuation`
   - task、mailbox、sticky prompt、worker 汇报格式共同决定当前工作主语怎样沿同一 lineage 继续。
6. 可观测性：
   - `Explainability`
   - context usage、cache break detection、section 预算让系统能解释自己为什么稳定，以及为什么突然失稳。

所以 Claude Code 的 prompt 强，不是某段 system prompt 单独强，而是因为 prompt 已经被写成同一世界编译器。

## 2. Prompt 首先在编译同一世界，而不是润色一句话

从第一性原理看，一个长期可用的 agent prompt 至少要先回答六件事：

1. 谁在合法发言。
2. 当前边界是什么。
3. 哪些对象算这轮 transcript。
4. 当前工作怎样沿 lineage 持续。
5. 什么条件下才配继续。
6. 系统为什么能解释自己何时失稳。

Claude Code 的强点在于，这六个问题并不都由静态文本承担：

- `Authority` 与 `Boundary` 来自角色化 prompt、tool pool、deny 规则和缓存边界。
- `Transcript` 来自 protocol transcript、attachments 与 lawful forgetting。
- `Lineage` 与 `Continuation` 来自 task 对象、mailbox、sticky prompt、summary 与 session memory。
- `Explainability` 来自 context usage 与 prompt cache break naming。

也就是说，这里的 prompt 更像：

- 同一世界的合同编译顺序

而不是：

- 一次性说服模型的文案

`buildEffectiveSystemPrompt(...)` 先决定 authority，再决定 boundary，最后才把文本装出来。真正难抄走的不是哪一句写得更顺，而是：

- 哪些角色在什么前提下拿到哪一层合同
- 哪些状态必须晚绑定
- 哪些 fork 还能继续复用主线程 prefix
- 系统怎样解释这条编译链什么时候断了

## 3. 为什么 cache 稳定性会反过来塑造 Boundary 与 Continuation

如果只站在文案作者视角，会觉得 prompt 先写完，再做性能优化。

Claude Code 的源码更接近相反顺序：

1. 先分 stable prefix 与 dynamic boundary。
2. 再决定哪些对象必须晚绑定进入 transcript。
3. 最后才得到最终 prompt 形态。

这会直接带来三件事：

1. 高频抖动状态不轻易打爆 stable prefix。
2. 旁路循环不必从零重建世界。
3. continuation 继承的是同一世界，而不是一份“像主线程”的故事。

`filterToolsByDenyRules(...)` 与 `assembleToolPool(...)` 甚至连工具 ABI 都先做了 cache-safe shaping。模型看到的不是“系统本来能做什么”，而是：

- 这一角色在这一世界里当前被允许看到什么

`stopHooks` 保存 `CacheSafeParams`，让 `/btw` 和 post-turn forks 复用同一前缀，也进一步说明：

- prompt 不是单轮文本，而是可继续的 prefix contract

## 4. 为什么状态反馈比文案更像 Transcript

Claude Code 很少让静态 prompt 独自承担“理解现场”的任务。

更常见的做法是：

1. static contract 负责规则。
2. attachment 与外化状态负责当前现场。
3. protocol transcript 负责把当前轮对象编进模型。

这样做的价值是：

- 规则和现场不会互相污染。
- 显示层消息不会直接污染执行层语义。
- 当前轮进入模型的是“规则 + 当前对象”，而不是不断膨胀的聊天残片。

这也是为什么 Claude Code 看起来更像“理解现场”，却又没有把所有现场都写进同一段 system prompt。

它不是猜得更准，而是把现场以更低噪音的 transcript 形态交给了模型。

## 5. 真正该防的三种失真

Prompt 母线在这一页真正该守住的 reject trio 是：

1. `authority_blur`
   - override、role、tool boundary 和 cache-safe prefix 混成一段“总提示词”。
2. `transcript_conflation`
   - UI display、protocol transcript、mailbox 事件和 attachments 被误写成同一种聊天文本。
3. `continuation_story_only`
   - `/btw`、summary、memory、fork 看起来像“接着聊”，却没有同一 continuation object 与 prefix contract。

只要这三种失真还在，所谓“七层叠加”就仍然会退回 feature list，而不是同一世界编译链。

## 6. 苏格拉底式追问

### 6.1 如果直接抄 system prompt，能复制这套魔力吗

不能。

因为被抄走的只是文本，没有被抄走的是：

- authority 顺序
- boundary 裁剪
- transcript 编译
- lineage 对象
- continuation 资格
- explainability 命名

### 6.2 如果 prompt 已经很强，为什么还需要 attachment

因为动态状态太多，直接塞进静态前缀只会导致：

- cache 抖动
- token 膨胀
- transcript 污染

### 6.3 如果多 Agent prompt 已经写得很细，为什么还需要 task / mailbox

因为没有 lineage object，所谓协作 prompt 最终只会退化成：

- 多个会说话的副本

而不是：

- 多个沿同一工作主语继续的协作单元

### 6.4 如果把权限、channel、worker 协议都当普通聊天文本，可不可以

不可以。

一旦结构化对象也退回普通文本：

- authority 会模糊
- transcript 会混层
- continuation 会退回故事感

## 7. 一句话总结

Claude Code 的 prompt 魔力，不是神秘文案，而是系统把 exclusion discipline、lawful inheritance 与 later-consumer 的拒收权一起保住，从而持续退休掉没有新增决策增益的世界重判。
