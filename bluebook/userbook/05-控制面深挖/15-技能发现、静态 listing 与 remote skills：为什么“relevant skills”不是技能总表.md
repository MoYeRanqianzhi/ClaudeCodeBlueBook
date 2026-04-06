# 技能发现、静态 listing 与 remote skills：为什么“relevant skills”不是技能总表

## 用户目标

不是只知道 Claude Code “会提示 relevant skills”，而是先看清四件事：

- turn-0、后续回合、fresh subagent、fork subagent 为什么会看到不同技能线索。
- `skill_listing`、`skill_discovery`、DiscoverSkills guidance 到底谁是 system prompt，谁其实只是 attachment 渲染出来的提醒。
- 为什么 static listing、relevant skills、remote skills 不是同一条公开主线。
- `shortId`、`/skill-feedback`、`/feedback`、`/issue` 这些反馈面到底谁对外稳定，谁只是内部或条件能力。

如果这四件事不先拆开，读者最容易把下面这些对象混成一锅“Claude 看见的技能表”：

- system prompt 里的 DiscoverSkills guidance
- `skill_listing`
- `skill_discovery`
- turn-0 阻塞发现
- 后续回合 prefetch 发现
- fresh subagent 的 DiscoverSkills framing
- fork subagent 继承父线程 prompt
- remote skills
- `shortId` 与 `/skill-feedback`

## 第一性原理

Claude Code 治理的不是“把全部技能一次性摊给模型”，而是：

1. 先给一层 broad inventory。
2. 再按当前任务推一层 relevant subset。
3. 再在需要时允许继续 discover。
4. 真正执行时再做一层 runtime 校验或按需加载。

因此更稳的提问不是：

- “Claude 到底看见了哪些技能？”

而是：

- 这条线索是 broad inventory，还是 relevant reminder？
- 它来自主线程、subagent，还是 fork subagent？
- 它是本地静态技能，还是 discover 后才可调用的 remote skill？
- 它是对外稳定面，还是条件公开 / 内部反馈面？

只要不先分清这四问，`relevant skills` 就会被误写成“技能总表”。

如果把这一页压成用户侧最小顺序，只该先做五步：

1. 先认这是 broad inventory，还是 relevant subset。
2. 再认它来自主线程、fresh subagent，还是 fork subagent。
3. 再认它是本地静态技能，还是 discover 后才可调用的 remote skill。
4. 再认这条线是稳定主线，还是实验 / 内部反馈面。
5. 最后才判断当前是否真的该继续 discover 或调用 SkillTool。

这组顺序本质上是在防一件事：把“当前被提醒的技能”误写成“Claude 的全部技能宇宙”。

更短的三分法就是：

- `skill_listing` 是库存。
- `relevant skills` 是相关性子集。
- `remote skills` 是 discover 之后才进入准入与加载链的能力。

## 进入本页前的 first reject signal

看到下面迹象时，应先回到技能发现链，而不是继续把提醒当总表：

- 你把 relevant skills 当成完整技能表。
- 你把 turn-0、后续回合、fresh subagent、fork subagent 看成同一条发现链。
- 你把 remote skills 当成本地 skills 的另一种显示方式。
- 你把 `shortId`、`/skill-feedback` 当成普通用户稳定主线，而不是条件公开或内部反馈面。

## 第一层：`skill_listing` 与 `skill_discovery` 不是 system prompt 本体

### system prompt 里更多是在教 Claude 何时继续 discover

`constants/prompts.ts` 里真正写进 prompt 的，是 DiscoverSkills guidance：

- relevant skills 会自动每回合被 surfaced
- 如果下一步动作不在这些提醒覆盖范围内，再调用 DiscoverSkills
- 已可见或已加载的技能会被过滤

这说明 system prompt 主要承担的是：

- 解释“何时继续查”

而不是：

- 直接塞一张完整技能表

### 真正给模型的 `skill_listing` / `skill_discovery` 是 attachment 变成的 `system-reminder`

`messages.ts` 对这两类 attachment 的处理都很明确：

- `skill_discovery` 会被包装成 `Skills relevant to your task: ...`
- `skill_listing` 会被包装成 `The following skills are available for use with the Skill tool: ...`
- 两者都通过 `wrapMessagesInSystemReminder(...)` 进入模型上下文

所以更准确的写法应是：

- Claude 看见的 relevant skills / skill listing，主要来自 meta attachment reminder

而不是：

- “system prompt 本身就列出了这些技能”

### UI 上看见的只是压缩后的短提示

`AttachmentMessage.tsx` 给用户看的不是完整 reminder 文本，而是：

- `N relevant skills: ...`
- `N skills available`

这意味着：

- 用户 transcript 中的短行
- 模型真正收到的 `system-reminder`

不是同一层对象。

## 第二层：主线程 turn-0、后续回合与 subagent 的发现链本来就不同

### turn-0 发现是阻塞式的

主线程在 `processUserInput -> getAttachmentMessages()` 这条链里，会把用户输入当作 turn-0 signal：

- 先做 attachment 提取
- 再在 attachment 期同步尝试 `getTurnZeroSkillDiscovery(...)`

这说明 turn-0 relevant skills 的语义是：

- 在第一轮真正发给模型前，先用用户刚输入的任务信号做一次阻塞发现

### 后续回合 discovery 改走 prefetch

`query.ts` 里后续回合不再走同一条阻塞链，而是：

- 先 `startSkillDiscoveryPrefetch(...)`
- 再在工具执行后 `collectSkillDiscoveryPrefetch(...)`
- 最后把结果作为 attachment 注入

所以：

- turn-0 和 inter-turn discovery 不是同一种调度策略

对 userbook 来说更稳的写法是：

- 首轮与后续回合的相关技能发现，本来就是两条不同注入链

而不应写成：

- “每回合都是同一种实时搜索”

### fresh subagent 不走主线程的 turn-0 user-input discovery

fresh subagent 的常规路径是：

- `AgentTool.tsx` 为它构造独立 agent prompt
- 再用 `enhanceSystemPromptWithEnvDetails(...)` 补充 env notes 与 DiscoverSkills framing
- 然后直接进入 `runAgent -> query`

它并不会复用主线程那条：

- `processUserInput -> getAttachmentMessages -> getTurnZeroSkillDiscovery`

这意味着：

- fresh subagent 有自己的 DiscoverSkills framing
- 但它的首轮发现链并不是主线程 turn-0 的简单复制

### fork subagent 又是另一条链

fork subagent 的目标是：

- 尽量复用父线程已经渲染好的 system prompt 与 forked messages
- 以保持 prompt cache 命中和上下文连续性

所以它和 fresh subagent 也不一样：

- 不是重新从零构建一套主线程同款曝光面
- 更接近“继承父线程已成形的提示环境”

因此 userbook 里最稳的说法应是：

- 主线程、fresh subagent、fork subagent 各有不同的技能曝光与发现路径

而不是：

- “子代理天然继承主线程同一套技能表”

## 第三层：static listing 是 broad inventory，不是长期承诺的技能全景

### `skill_listing` 先组 broad inventory，再按实现策略裁剪

`getSkillListingAttachments()` 的基础装配是：

- `getSkillToolCommands(cwd)` 提供 local / bundled 等可模型调用技能
- `getMcpSkillCommands(...)` 并入 MCP skills

这说明 `skill_listing` 的本质是：

- broad inventory

而不是：

- “当前产品支持的全部技能总表”

### 搜索链开启后，static listing 会被故意压缩

当 skill search 开启，`attachments.ts` 当前会把 broad listing 先裁到：

- bundled + MCP

如果还太大，再进一步退到：

- bundled-only

这条策略能解释很多源码现象：

- 为什么某些场景里 Claude 起步先看到官方或外部 server 技能
- 而长尾 project / user / plugin skills 更依赖 discovery

但 userbook 应把它写成：

- 当前实现下的上下文预算策略

而不是：

- 永久稳定的公开合同

### `relevant skills` 不是另一份 static listing

`skill_discovery` 交给模型的是：

- 和当前任务相关的技能子集

而不是：

- 又一份全量或广义库存

所以这两层应明确分开：

- `skill_listing` 回答“有哪些技能可供 SkillTool 使用”
- `skill_discovery` 回答“当前任务更该优先考虑哪部分技能”

更直接地说，`relevant skills` 不是技能总表，而是当前任务最值得先看的那一层。

## 第四层：remote skills 不是普通本地技能，必须先 discover 再加载

### remote skills 不在普通本地命令注册表里

`SkillTool.ts` 对 remote skills 的处理很直接：

- 在本地 command lookup 之前，先拦截 remote canonical skill 名
- 如果这条 remote skill 没有在本 session 的 discovered state 里出现，就直接报错
- 通过后再按需 `loadRemoteSkill(...)`

这说明 remote skills 的语义不是：

- 本地技能列表里本来就有、只是没显示出来

而是：

- discover 成功后，SkillTool 才能凭 session state 去按需加载

### 所以 remote skill 和 static listing 不是同一对象

源码里的注释已经很明确：

- remote skills 不在 static `skill_listing` 里
- 它们属于 model-discovered / on-demand load 的另一条链

因此 userbook 不应写成：

- “remote skills 也会像本地 skills 一样出现在 listing 里”

更稳的写法是：

- remote skills 必须先经过 discover，再由 SkillTool 按需加载

### 这条 remote 链应被降级成条件公开 / 实验面

从当前源码快照可直接看见的，是：

- SkillTool 的拦截、校验和按需加载消费链
- prompts / attachments / README 对 `EXPERIMENTAL_SKILL_SEARCH` 的 feature gate
- `USER_TYPE === 'ant'` 对 remote canonical skills 的条件限制

因此用户手册里更稳的结论是：

- remote skills 属于条件公开、实验搜索链与内部能力相交的区域
- 不应默认所有 build、所有用户、所有线程都拥有它

## 第五层：`shortId` 与 `/skill-feedback` 属于 UI / 内部反馈面，不是模型合同

### `shortId` 只在 UI 侧出现，不进模型的 reminder 文本

`AttachmentMessage.tsx` 会在 `skill_discovery` UI 行里把 `shortId` 渲染成：

- `name [shortId]`

并在 ant 条件下追加：

- `/skill-feedback ...`

但 `messages.ts` 生成的 `skill_discovery` system reminder 只包含：

- 技能名
- 描述

这说明：

- `shortId` 是 UI / 人类反馈回路的一部分
- 不是模型上下文里的稳定字段

### `/skill-feedback` 不应写成普通用户主线

结合当前可见源码，更稳的落笔方式是：

- `/skill-feedback` 与 `shortId` 属于内部或条件反馈面
- 外部用户可稳定依赖的反馈主线仍是 `/feedback` 与 `/issue`

因此 userbook 不应把：

- `shortId`
- `/skill-feedback`
- remote skill 反馈回路

写成普通用户稳定主线。

## 最容易误写的七件事

### 误写 1

“skills 主要靠 system prompt 暴露给 Claude。”

更准确的写法：system prompt 主要给 DiscoverSkills framing；真正的 listing / discovery 多数是 attachment 变成的 `system-reminder`。

### 误写 2

“`relevant skills` 就是 Claude 看到的完整技能表。”

更准确的写法：它只是和当前任务相关的一层子集提醒。

### 误写 3

“主线程首轮、后续回合和 subagent 的发现链完全一样。”

更准确的写法：turn-0、inter-turn、fresh subagent、fork subagent 都有不同的装配路径。

### 误写 4

“搜索链开启后，static listing 仍覆盖 project / user / plugin 长尾技能。”

更准确的写法：当前实现会把 listing 压缩到 bundled + MCP，甚至 bundled-only；长尾技能更依赖 discovery。

### 误写 5

“remote skills 也只是普通本地 skill 的另一种显示方式。”

更准确的写法：它们必须先 discover，再由 SkillTool 按需加载。

### 误写 6

“`shortId` 会进模型上下文，所以 Claude 会记住它。”

更准确的写法：`shortId` 是 UI 提示字段，不是 `skill_discovery` reminder 的正文。

### 误写 7

“`/skill-feedback` 是普通用户默认的技能反馈入口。”

更准确的写法：它属于内部或条件能力；外部稳定反馈面仍是 `/feedback` 与 `/issue`。

## 稳定事实与降级写法

### 可以写成稳定 userbook 事实的

- Claude 看到的技能线索来自多条不同链，而不是单一技能表
- `skill_listing` 与 `skill_discovery` 主要是 attachment 变成的 `system-reminder`
- 主线程、fresh subagent、fork subagent 会走不同的技能发现与提示路径
- remote skills 不是普通本地 skills，必须先 discover 再按需加载
- `shortId` / `/skill-feedback` 不应被写成普通用户稳定主线
- `relevant skills` 是 reminder，不是总表；真正能不能调还要过 runtime gate

### 应降级为条件公开、内部或实现细节的

- `EXPERIMENTAL_SKILL_SEARCH`
- `_canonical_<slug>` 这类内部 wire naming
- bundled + MCP / bundled-only 的裁剪阈值
- remote skill state 的内部生命周期
- `shortId` 与 `/skill-feedback` 的完整回路

这些都很适合作为源码证据，但不应写成无条件产品承诺。

## 源码锚点

- `claude-code-source-code/src/constants/prompts.ts`
- `claude-code-source-code/src/utils/processUserInput/processUserInput.ts`
- `claude-code-source-code/src/query.ts`
- `claude-code-source-code/src/utils/attachments.ts`
- `claude-code-source-code/src/utils/messages.ts`
- `claude-code-source-code/src/components/messages/AttachmentMessage.tsx`
- `claude-code-source-code/src/tools/SkillTool/SkillTool.ts`
- `claude-code-source-code/src/tools/AgentTool/AgentTool.tsx`
- `claude-code-source-code/README.md`
