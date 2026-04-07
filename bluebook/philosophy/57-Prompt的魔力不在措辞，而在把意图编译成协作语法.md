# Transcript、Lineage 与 Continuation 如何组成协作接口

这一章回答四个问题：

1. 为什么 Claude Code 的协作接口不该被理解成“提示词更会写”。
2. 为什么 UI transcript 与 protocol transcript 的分离是这套协作接口的前提。
3. 为什么 sticky prompt、suggestion、session memory 其实是同一协作接口在不同时间尺度上的投影。
4. 这对 agent runtime 设计者意味着什么。

## 1. 先说结论

“协作语法”现在不再作为 Prompt 的总解释，而只解释六个 nouns 里的三段：

- `Transcript -> Lineage -> Continuation`

本页也不再承担 Prompt 首答，而只解释这三段如何组成协作接口。Claude Code 的 prompt 真正强，不在于：

- 它更会措辞

而在于：

- 它把人类意图编译成一套可持续协作的 transcript、lineage 与 continuation 语法

也就是说，它优先组织的是：

1. 谁在代表谁发言。
2. 哪些消息属于人类可见真相。
3. 哪些消息属于模型可执行真相。
4. 当前、下一步、接手后如何共享同一工作主语。

## 2. 为什么这不是“文案优化”

如果 prompt 只是更好的文案，那么更强模型理应自动复制这套协作接口。

但 Claude Code 的源码反复说明，真正起作用的不是几句 instruction，而是：

- protocol transcript 改写
- task / mailbox / notification 对象
- stop hook 后保存的 cache-safe 协作上下文
- sticky prompt 对当前主语的维持
- suggestion 对下一步输入的外化
- session memory 对压缩后 handoff continuity 的维持

所以这页真正想说的不是“Prompt 其实像协作文法书”，而是：

- `Transcript` 把当前轮编成合法执行对象
- `Lineage` 让当前工作主语持续可追踪
- `Continuation` 让 sticky / suggestion / memory 在不同时间尺度上继续消费同一工作对象

## 3. 为什么 UI transcript 不能直接冒充 protocol transcript

人类可见真相和模型可执行真相不是同一种对象。

前台需要：

- progress
- 交互提示
- 某些展示性消息

模型需要的则是：

- 结构合法
- 可继续推理
- 协议不变量仍成立的 transcript

如果两者不分，显示层噪声就会直接污染执行层语义。

所以这页的第一条硬判断不是“Prompt 该怎么写”，而是：

- `display truth != protocol transcript`

## 4. 为什么 sticky、suggestion、session memory 应一起理解

这三者都在回答同一个 continuation 问题：

- 人类和模型接下来怎样继续同一项工作

只不过时间尺度不同：

1. sticky prompt 维护“现在正在回应什么”。
2. suggestion 维护“下一步最可能怎么接”。
3. session memory 维护“压缩或恢复后还能从哪里继续”。

把这三者放在一起看，真正稳定的写法就不是“协作语法很强”，而是“同一协作接口在不同时间尺度上继续成立”：

- 它们都是同一 continuation interface 的投影

## 5. 多 Agent 真正强在哪里

多 Agent prompt 最容易被误写成：

- 给 worker 的几句 instruction

但 `coordinatorMode.ts` 和 `AgentTool/prompt.ts` 说明，真正起作用的是：

1. coordinator 先综合，再下发。
2. worker prompt 必须自包含，不能把理解责任继续甩给下游。
3. mailbox / task / notification 把 lineage object 接进运行时。
4. handoff 结果必须能回写到主线程 continuation。

所以所谓“协作接口已经成立”，真正的本体不是句式，而是：

- transcript grammar
- lineage object
- continuation contract

## 6. 苏格拉底式追问

### 6.1 prompt 只要组织模型思考就够了吗

不够。

长期任务里真正稀缺的，不只是模型推理质量，还有：

- 人类能否继续接手
- 当前主语能否持续稳定
- 压缩与恢复后是否仍能继续工作

### 6.2 如果把 sticky、suggestion、memory 分别写成三个“体验功能”，会怎样

它们就会失去同一 continuation object，只剩下三个互相近似的投影功能。

### 6.3 这一页最该防的失真是什么

最该防的仍然是：

1. `transcript_conflation`
2. `continuation_story_only`

因为只要 transcript 和 continuation 混掉，所谓“协作语法”立刻又会退回模糊的人机对话体感。

## 7. 一句话总结

Claude Code 的 prompt 之所以能稳定协作，不是因为它更会组织措辞，而是因为它把意图写成了 `Transcript -> Lineage -> Continuation` 可持续协作接口，再让模型沿着这套接口继续行动。
