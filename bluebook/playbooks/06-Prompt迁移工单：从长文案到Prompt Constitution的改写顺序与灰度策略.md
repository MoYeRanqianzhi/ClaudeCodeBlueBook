# Prompt迁移工单：从长文案到Prompt Constitution的改写顺序与灰度策略

这一章把 `guides/30` 和 `casebooks/10` 继续推进到迁移执行层。

它主要回答五个问题：

1. 怎样把旧式长文案 prompt 系统迁成 Claude Code 式 Prompt Constitution。
2. 为什么这类迁移不该从文案重写开始，而应从制度盘点开始。
3. 怎样安排 section、边界、共享前缀、合法遗忘与接手连续性的渐进改写顺序。
4. 灰度、停机与回退条件分别该如何定义。
5. 怎样用苏格拉底式追问避免把 Prompt 迁移写成一场无序重写。

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

- Prompt 迁移的关键不是把旧文案写得更好，而是把主语、共享前缀、边界与恢复 ABI 一起制度化。

## 1. 第一性原理

这类迁移真正昂贵的，不是：

- 改掉一段 prompt

而是：

- 在迁移期间仍保住主语稳定、路径一致、合法遗忘与低成本接手

所以迁移的第一原则不是：

- 先求新 prompt 更强

而是：

- 先让系统更不容易在迁移过程中失去同一份制度真相

## 2. 迁移步骤

### 步骤 1：先做制度盘点，不先改文案

目标：

- 把现有 prompt 拆成制度成分，识别谁在说话、谁能覆盖谁、哪些内容其实是状态而不是 prompt。

不要做什么：

- 不要一上来重写整段提示词。
- 不要先讨论措辞优雅。
- 不要把宿主状态、工具结果、用户偏好继续混在一个文本块里。

验收信号：

- 团队能给现有 prompt 打出最小清单：`主语来源`、`规则段`、`动态事实`、`工具可见性`、`恢复所需 ABI`、`明显重复段`。

### 步骤 2：固定主语与主权链

目标：

- 把系统、宿主、用户、任务对象、子代理的发言权拆开，建立谁先说、谁可覆盖谁的主权顺序。

不要做什么：

- 不要再保留“看上下文理解是谁说的”的句子。
- 不要让用户偏好和系统安全边界处于同一层。
- 不要把工具说明伪装成任务目标。

验收信号：

- 任意一条规则都能回答三个问题：`谁说的`、`对谁生效`、`能否覆盖上一层`。

### 步骤 3：把长文案拆成 Section 宪法

目标：

- 把 prompt 重写成稳定 section 槽位，而不是一整段叙述；每个 section 只承担一种制度职责。

不要做什么：

- 不要按“阅读舒服”随意分段。
- 不要让一个 section 同时承担角色定义、边界约束、动态状态和接手说明。
- 不要把 section 命名成修辞标题。

验收信号：

- 每个 section 都有明确的 `职责`、`输入来源`、`是否稳定缓存`、`失效条件`、`变更理由`。

### 步骤 4：划清稳定前缀与动态边界

目标：

- 把共享前缀资产和本轮动态事实分开，建立 cache-aware assembly 的边界。

不要做什么：

- 不要把临时状态、观测、一次性工具结果塞回稳定头部。
- 不要把核心法条放在动态尾部临时补写。
- 不要让不同入口自己拼“差不多版本”的上下文。

验收信号：

- 团队能把每项内容稳定归类为 `stable prefix`、`dynamic boundary`、`externalized result`、`不应进入 prompt` 四类之一。

### 步骤 5：收敛共享前缀生产权

目标：

- 确保主线程是共享前缀的唯一合法生产者，旁路查询、summary、subagent 只读取前缀并追加窄差异。

不要做什么：

- 不要让 suggestion、summary、resume、子代理各自复制一份完整世界说明。
- 不要为了局部方便制造第二套 prompt 真相。

验收信号：

- 旁路路径不再生成独立大 prompt，只保留“共享前缀 + 局部 delta + 独立副作用回传”的结构。

### 步骤 6：定义合法遗忘与恢复 ABI

目标：

- 明确 compact、summary、resume 后哪些叙事可以忘，哪些继续行动所需 ABI 绝不能丢。

不要做什么：

- 不要把“有摘要”当成“可恢复”。
- 不要只保留故事，不保留 mode、pending action、关键对象状态、外置结果命运。

验收信号：

- 团队能列出 compact / resume 后仍必须存在的最小字段，并能证明接手者不读全量 transcript 也能继续工作。

### 步骤 7：补齐接手连续性与状态外化

目标：

- 让 prompt 同时服务模型行动与人类/宿主接手，把当前真相外化成可恢复状态，而不是藏在措辞里。

不要做什么：

- 不要把 handoff 需求留给日志搜索。
- 不要让“当前 mode / pending action / 下一步约束”只能从历史对话反推。

验收信号：

- 出现审批、中断、远程恢复、resume 时，接手者可直接从快照、metadata、summary 知道当前真相。

### 步骤 8：补齐 diff、观测与灰度切换

目标：

- 把新 Prompt Constitution 变成可比对、可回滚、可灰度的 assembly 制度。

不要做什么：

- 不要一次性全量切换。
- 不要只看主观回答质量。
- 不要在没有 diff、cache、cost、handoff 信号时宣布迁移完成。

验收信号：

- 你能稳定观测 `section diff`、`cache break`、`成本/延迟变化`、`路径一致性`、`resume/handoff 成功率`，并能将异常定位到具体 section 或边界。

## 3. Rollout 顺序

```text
1. 只做盘点，不改线上 prompt
2. 新旧 assembly 并行 shadow，对比 section diff、边界归类与 cache 行为
3. 先切 suggestion / summary / side query 这类只读旁路路径
4. 再切主线程稳定前缀，但保留旧动态尾部
5. 再切动态边界与状态外化
6. 最后切 compact / resume / handoff 路径
7. 全量后再清理旧长文案 fallback 和重复 assembly 逻辑
```

## 4. 回退条件

```text
[ ] 出现无法解释的 path parity split
[ ] cache break、成本或延迟连续异常升高，且无法定位到具体 section
[ ] compact / resume 后无法继续工作，只能重读全量历史
[ ] 审批、mode、pending action 等当前真相无法稳定外化
[ ] 人类接手成功率显著下降
[ ] 新旧并行对比中，同一现场得到不同制度结论
```

## 5. 回退动作

更稳的回退顺序是：

1. 先回退动态边界与外化路径。
2. 再回退主线程新 assembly，仅保留 section 盘点成果。
3. 不回退标签、diff、观测和最小 ABI 清单，因为这些本身就是迁移资产。

## 6. 迁移记录卡

```text
迁移对象:
当前主语链是否清楚:
section 宪法是否完成:
stable prefix / dynamic boundary 是否已分离:
共享前缀生产权是否单一:
lawful forgetting ABI 是否成立:
handoff continuity 是否成立:
当前 rollout 阶段:
当前最像哪类风险:
- section drift / boundary drift / path parity split / lawful-forgetting failure / invalidation drift
如果回退，先回退哪一层:
```

## 7. 苏格拉底式追问

在你准备宣布“新 prompt 系统已上线”前，先问自己：

1. 我是在迁移 prompt，还是在迁移 prompt 的制度体。
2. 我现在改变的是文案，还是改变了主语、前缀、边界与恢复协议。
3. 这次 rollout 里最容易打碎的是 cache、handoff，还是 resume。
4. 我是否知道该先 shadow 哪一层、最后再切哪一层。
5. 如果今天必须回退，我是否知道回退的是 assembly 哪一层，而不是把全部工作一起撤销。
