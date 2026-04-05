# 多 Agent 编排与 Prompt 模板

本章不谈“怎么把提示词写得好看”，而谈“怎么让 Claude Code 的多 Agent runtime 跑得稳”。

## 1. 先说结论

Claude Code 的多 Agent 能力不是“多开几个模型会话”，而是一套以隔离为前提的协作 runtime：

1. coordinator 负责综合，不负责把理解外包给 worker。
2. worker prompt 必须自包含，因为 worker 看不到你的对话上下文。
3. teammate 输出默认不会自动成为 leader 可见文本，必须走 `SendMessage` 或 `task-notification`。
4. team context、teammate mailbox、task list、permission bridge 共同构成协作控制面。
5. 并行只适合读操作或写集互斥的任务；共享写集必须收束 ownership。

关键证据：

- `claude-code-source-code/src/coordinator/coordinatorMode.ts:111-260`
- `claude-code-source-code/src/utils/swarm/inProcessRunner.ts:871-1043`
- `claude-code-source-code/src/utils/swarm/teammatePromptAddendum.ts:1-14`
- `claude-code-source-code/src/utils/messages.ts:3457-3490`
- `claude-code-source-code/src/utils/attachments.ts:720-731`
- `claude-code-source-code/src/tools/AgentTool/runAgent.ts:260-360`
- `claude-code-source-code/src/tools/TeamCreateTool/prompt.ts:37-166`

## 2. 第一原则：先隔离，再并行

从源码反推，多 Agent 的正确问题顺序是：

1. 这些任务是否真的彼此独立。
2. 它们是否需要不同上下文窗口。
3. 它们是否会碰同一组文件。
4. 它们是否需要不同权限或不同执行环境。

如果前三个问题都没回答清楚，先不要并行。

Claude Code 的设计明显偏向：

- 隔离上下文
- 隔离文件系统现场
- 隔离 transcript
- 必要时再并行

这也是为什么 worktree、sidechain transcript、team context 都比“并发数量”更重要。

## 3. coordinator 的职责：综合，而不是转发

`coordinatorMode.ts` 已经把 coordinator 规则写得非常直白：

- worker 看不到你的对话
- prompt 必须自包含
- research 结果回来后，coordinator 必须先综合，再下发实现 prompt
- 不要写“based on your findings”

所以 coordinator 真正的职责是三件事：

1. 拆任务
2. 综合理解
3. 指定 ownership 与验收

最常见的错误反而是：

- 收到 worker 研究结果后，原样转发给另一个 worker

这会把“理解责任”继续往下推，最后整套系统只是在传播局部视角。

## 4. 先分清五种协作形态

很多人把所有多 Agent 都叫 subagent，但源码里至少应区分五类：

1. coordinator：
   - 专门的 orchestrator 模式
   - 有独立 system prompt
2. fresh subagent：
   - 需要完整 briefing
   - 不共享主线程完整上下文
3. fork：
   - 继承上下文与 cache-safe 前缀
   - prompt 更适合 directive-style，而不是重复背景
4. team / swarm teammate：
   - 名字寻址
   - mailbox
   - task list
   - leader 审批
5. workflow：
   - 当前可见为正式 task / transcript 分组维度
   - 但实现边界仍需保守书写

如果不先分清这五类，就会把 prompt 模板写得过于笼统。

## 5. 最小可用 prompt 模板：研究 worker

适合用在：

- 代码结构摸底
- 风险点识别
- API / schema / 状态字段梳理

```text
你负责只读分析以下问题，不要改文件，也不要假设代码库是你独占的：

目标：
- <明确问题>

范围：
- 重点查看 <文件/目录>
- 如有必要，可扩展到 <相关目录>

输出要求：
- 1) 核心结论（3-6条）
- 2) 最关键的状态阶段/结构层次
- 3) 8-15 个源码锚点（文件+行号）
- 4) 可直接写进蓝皮书/设计文档的章节提纲

约束：
- 只做证据驱动结论
- 区分源码直接事实与保守推断
- 不要回退任何改动
```

这个模板的核心不是修辞，而是四个约束：

- 只读
- 范围
- 交付物
- 证据

## 6. 最小可用 prompt 模板：实现 worker

适合用在：

- 明确写集
- 已有设计结论
- 需要真正改代码

```text
你负责实现以下改动。你不独占代码库；不要回退他人的改动，并根据现状做兼容。

目标：
- <要实现的行为>

写入范围：
- 只改 <文件/模块>

背景与依据：
- 相关结论：<精炼结论>
- 关键锚点：<文件:行号>

实现要求：
- 保持现有模式/风格
- 必要时补测试
- 不要扩大写集

交付：
- 1) 改了什么
- 2) 改动文件路径
- 3) 验证结果
- 4) 剩余风险
```

这个模板最重要的字段是“写入范围”。
如果没有写集 ownership，多 Agent 写代码几乎必然演化成互相踩踏。

## 7. 最小可用 prompt 模板：验证 worker

适合用在：

- 改动已完成
- 需要独立证明
- 不希望实现者自证

```text
你负责验证以下改动是否真的成立，不要修改业务代码；除非为了补验证脚本或最小修复，否则不要扩大范围。

验证目标：
- <用户承诺/需求>

重点检查：
- 行为回归
- 边界条件
- 测试/类型/构建

上下文：
- 改动位置：<文件>
- 关键假设：<假设>

输出要求：
- 1) Findings first，按严重级排序
- 2) 证据（文件+行号 / 命令结果摘要）
- 3) 若无发现，明确写 no findings
```

验证 worker 的价值不是“再说一遍改对了”，而是独立破坏你的自我确认偏差。

## 8. fork prompt 与 fresh prompt 不该写成一样

对 fork 类型 worker，prompt 更适合写成：

- 继续做什么
- 不要改什么
- 输出什么

而不是重新灌一大段项目背景。

因为 fork 的价值本来就在于：

- 继承当前上下文
- 继承 cache-safe 前缀
- 避免重复 briefing

反过来，fresh subagent 才需要完整背景、范围和证据。

## 9. team / teammate 模式下要额外写清什么

如果不是普通 worker，而是 team teammate，还要补三类约束：

1. 你的名字是什么
2. 该向谁汇报
3. 任务列表和 team config 在哪里

源码里 `team_context` attachment 与 teammate addendum 已经在自动补这些东西：

- team name
- leader name
- team config path
- task list path
- “只写文本别人看不见，必须用 SendMessage”

所以 teammate prompt 的重点不在“再描述一遍团队协作”，而在：

- 明确当前任务范围
- 明确汇报频率
- 明确何时拆子任务、何时更新 task list

## 10. 一个更稳的多 Agent 编排顺序

更符合 Claude Code 源码设计的顺序通常是：

1. 主线程澄清目标、限制和验收。
2. 并行发出 2-4 个只读研究 worker。
3. 主线程综合结果，决定单写集实现方案。
4. 实现 worker 按 ownership 落地。
5. 独立验证 worker 做 review / 测试 / 回归。
6. 主线程把结论回写用户和文档。

这里最重要的不是步骤数，而是切换点：

- 研究结束后必须先综合
- 实现开始前必须先收束写集

## 11. Prompt 模板的真正来源不是“经验”，而是 runtime contract

当前提取树里，最值得长期复用的模板线索主要来自四处：

1. `coordinatorMode.ts`
2. `AgentTool/prompt.ts`
3. `TeamCreateTool/prompt.ts`
4. `messages.ts` 里的 `team_context` 注入模板

也就是说，多 Agent prompt 最好从源码里的角色合同反推，而不是从泛化 prompt 技巧倒推。

## 12. 反模式

下面这些做法通常会让多 Agent 效果明显变差：

- 把一个小问题机械拆成很多 worker，只为了“看起来并行”。
- 让一个 worker 去“检查另一个 worker 做了什么”。
- 让多个 worker 同时写同一批文件。
- coordinator 不综合，只转发结果。
- worker prompt 依赖主线程上下文记忆，缺少自包含背景。
- 让 teammate 直接写普通文本，期望 leader 自动看见。

## 13. 一句话总结

Claude Code 的多 Agent prompt 魔力不来自漂亮话术，而来自一个很硬的 runtime contract：自包含 prompt、显式 ownership、消息总线汇报、以及隔离优先于并行。
