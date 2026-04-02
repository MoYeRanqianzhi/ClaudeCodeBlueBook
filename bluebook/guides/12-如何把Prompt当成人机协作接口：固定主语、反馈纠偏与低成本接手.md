# 如何把Prompt当成人机协作接口：固定主语、反馈纠偏与低成本接手

这一章回答五个问题：

1. 为什么 Claude Code 里的 prompt 不只是“给模型的提示词”，也是人类继续工作的接口。
2. 怎样利用 Sticky Prompt、Suggestion、Session Memory 与 task 视图，把“当前主语”和“下一步动作”维持清楚。
3. 为什么界面上看到的 transcript 不能直接等同于模型真正接收到的 protocol transcript。
4. 什么时候该继续补一句短反馈，什么时候该升级成 task / worktree / 新 session。
5. 怎样用苏格拉底式追问避免把“协作接口失效”误判成“模型能力不够”。

## 0. 代表性源码锚点

- `claude-code-source-code/src/components/VirtualMessageList.tsx:145-180`
- `claude-code-source-code/src/components/VirtualMessageList.tsx:946-1035`
- `claude-code-source-code/src/hooks/usePromptSuggestion.ts:15-176`
- `claude-code-source-code/src/services/PromptSuggestion/promptSuggestion.ts:184-270`
- `claude-code-source-code/src/services/SessionMemory/sessionMemory.ts:303-345`
- `claude-code-source-code/src/hooks/useBackgroundTaskNavigation.ts:24-240`
- `claude-code-source-code/src/utils/messages.ts:2078-2148`

这些锚点共同说明：

- Claude Code 在维护的不只是模型上下文，还有人类继续接手、纠偏、切换视角和恢复工作的接口成本。

## 1. 先说结论

更强的 prompt，不是：

- 一次性交给模型更多文字

而是同时完成三件事：

1. 固定当前主语。
2. 压短下一步动作。
3. 为未来接手保留低成本入口。

所以真正有魔力的 prompt，更像：

- 人类和模型共享的协作接口

## 2. 第一步：先固定“当前到底在回应什么”

`computeStickyPromptText(...)` 只会从真实用户消息和非 meta 的 `queued_command` 中提取可见主语，还会剥掉 system reminder，并把空字符串或 `<...>` 这类系统痕迹排除掉。

这说明 Sticky Prompt 不是装饰，而是在帮系统持续保留：

- 当前回合究竟在回应哪个人类意图

实践上：

1. 一轮尽量只保留一个主请求，不要把多个目标揉成一段大 prompt。
2. 如果目标切换，直接写“从现在开始只做 X，不做 Y”，不要让模型自己猜阶段切换。
3. 如果任务被拆成多条执行线，优先把新主语升级成 task / worktree，而不是继续在同一主线程堆叠。

## 3. 第二步：把“下一步最可能动作”压短，而不是把前情无限重讲

`usePromptSuggestion(...)` 只会在输入框为空、assistant 没在回应时显示 suggestion；`executePromptSuggestion(...)` 又明确把目标写成：

- 预测用户自然会输入什么，而不是替用户发明新的计划

这意味着 suggestion 的真正价值不是自动补全，而是把：

- 人类下一步最可能接上的动作

压成一个低成本入口。

实践上：

1. 当 suggestion 已经接近你本来想说的话时，优先在它后面补一条短边界，而不是重写整段背景。
2. 如果 suggestion 老是跑偏，先检查当前会话是不是已经混入多个主语，而不是先怪模型“不够懂你”。
3. 对长任务来说，“继续”“先跑测试”“先给 diff”这类短动作经常比长解释更有效，因为它们更像协作接口里的按钮，而不是重新开题。

## 4. 第三步：纠偏时优先补“新边界”，不要重写整段历史

`messages.ts` 里对消息的处理很说明问题：

1. 某些 system message 会被并入 user message，供后续回合引用。
2. 不可用的 `tool_reference` 会被剥离。
3. 为了避免模型误采样 stop sequence，系统还会在 API 准备阶段注入额外 sibling text，而这些内容并不会回到 REPL 原样展示。

这说明：

- 模型真正消费的是 protocol transcript，不是你眼睛看到的 UI transcript

因此纠偏时，最稳的做法不是“把我刚才说过的话再完整说一遍”，而是：

1. 直接补新的边界条件。
2. 显式指出不要继续哪条错误分支。
3. 只补当前回合真正缺失的约束。

更实用的纠偏句式通常是：

- 只改 `X`
- 不要动 `Y`
- 先给计划再执行
- 先验证再继续写

## 5. 第四步：把未来接手要用的语义外移

`sessionMemory.ts` 并不是简单“做个总结”。它会创建隔离上下文、读当前 memory 文件、生成更新 prompt，再通过 `runForkedAgent(...)` 用独立 fork 去提取可恢复语义。

这说明 Session Memory 的职责更接近：

- 把未来继续工作还需要的最小语义体外移出去

实践上：

1. 当任务跨阶段时，优先沉淀“当前状态 / 当前阻塞 / 下一步 / 不要重做什么”。
2. 不要把 session memory 当成聊天纪要；它更像给未来继续执行留下的 handoff stub。
3. 如果你发现每次恢复都要重新讲完整背景，问题通常不是窗口不够大，而是可恢复语义没有及时外移。

## 6. 第五步：当接手路径变复杂时，升级成正式对象

`useBackgroundTaskNavigation(...)` 明确区分了：

- leader
- teammate
- selecting-agent
- viewing-agent
- hide row

甚至连 `Escape` 都区分为：

- 中止正在运行的 teammate 当前工作
- 退出视图回到 leader

这说明 Claude Code 不是把“继续聊”当成唯一接手方式，而是在提供：

- 可切换、可终止、可观察的正式协作对象

实践上：

1. 只有一条主线时，继续当前 session。
2. 需要多个子问题并行时，用 task / subagent，而不是在主线程里手工记账。
3. 需要独立文件现场和提交节奏时，用 worktree。
4. 需要跨人或跨时间接手时，让 title、tag、memory、task 视图一起承担恢复责任。

## 7. 苏格拉底式检查清单

在继续补 prompt 之前，先问自己：

1. 我现在还能一句话说清当前主语吗。
2. 我缺的是更多背景，还是更明确的下一步动作。
3. 我现在看到的聊天历史，哪些其实不会原样进入模型的协议输入。
4. 我该补一条短纠偏，还是该把任务升级成新的承载对象。
5. 我现在遇到的是模型不会做，还是人类和模型都不知道该从哪里继续。

如果这五问答不清，继续加长 prompt 往往只会抬高协调成本。

## 8. 一句话总结

Claude Code 里真正强的 prompt，不只是组织模型思考，更在组织人类如何继续接手、如何低成本纠偏、以及如何在长任务里始终找得到下一步。
