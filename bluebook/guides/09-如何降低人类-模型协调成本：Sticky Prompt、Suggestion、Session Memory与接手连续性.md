# 如何降低人类-模型协调成本：Sticky Prompt、Suggestion、Session Memory与接手连续性

这一章回答五个问题：

1. 为什么很多长任务失败，不是模型不够强，而是人类和模型接手成本太高。
2. 怎样利用 Claude Code 已有机制，把“下一步从哪里继续”维持清楚。
3. Sticky Prompt、Suggestion、Session Memory、Task 视图分别该怎么用。
4. 什么时候该继续当前会话，什么时候该升级成 task / worktree / 新 session。
5. 怎样用苏格拉底式追问避免把协调成本误判成“prompt 不够长”。

## 0. 代表性源码锚点

- `claude-code-source-code/src/screens/REPL.tsx:1188-1249`
- `claude-code-source-code/src/components/VirtualMessageList.tsx:145-180`
- `claude-code-source-code/src/components/VirtualMessageList.tsx:946-1020`
- `claude-code-source-code/src/services/PromptSuggestion/promptSuggestion.ts:184-240`
- `claude-code-source-code/src/hooks/usePromptSuggestion.ts:1-140`
- `claude-code-source-code/src/services/SessionMemory/sessionMemory.ts:303-345`
- `claude-code-source-code/src/query/stopHooks.ts:84-120`
- `claude-code-source-code/src/hooks/useBackgroundTaskNavigation.ts:24-220`

这些锚点共同说明：

- Claude Code 不只在优化模型上下文，也在优化“人类下一步怎样低成本接手”。

## 1. 先说结论

更稳的长任务使用法，不是：

- 一直把所有上下文都保留在聊天里

而是：

1. 把当前主语固定住。
2. 把下一步动作压短。
3. 把可恢复语义外移。
4. 把接手路径做成正式对象。

所以真正要压低的，不只是 token 成本，还有：

- 人类-模型协调成本

## 2. 第一层：始终让“当前在回应什么”保持可见

Sticky Prompt 的价值，不是视觉效果，而是让人类在长历史里持续知道：

- 当前到底在回应哪一个用户意图

实践上：

1. 一轮里只保留一个清晰主请求，不要把多个独立目标揉成一段长 prompt。
2. 如果目标变了，明确写“从现在开始改做什么”，不要靠上下文暗示。
3. 当会话已经跨多个阶段时，优先用 task 标题、session tag 或小结重置主语。

如果你经常需要回滚很久才能确认“这轮到底在干嘛”，问题通常不是模型，而是主语锚点已经丢了。

## 3. 第二层：把“下一步最可能动作”压短

Suggestion 不是玩具功能。

它的真正价值是把：

- 人类下一步最可能会说的话

压成一个更低成本的接手入口。

实践上：

1. 当 suggestion 稳定出现时，先判断它是不是比你手写新 prompt 更接近当前工作线。
2. 如果 suggestion 经常不对，不要先怪模型，先看当前会话是不是混入了多个并行目标。
3. 不要在 suggestion 已经把下一步压短时，再额外复制一大段前情提要。

更好的做法是：

- 接 suggestion 的方向，再补一条短而精确的边界或验收条件。

## 4. 第三层：把“未来接手还需要的语义”外移

Session Memory 的价值不在“总结历史”，而在：

- 保留未来继续工作时还需要的最小语义体

实践上：

1. 长任务跨阶段时，优先让系统沉淀 session memory，而不是把每轮都写成长总结。
2. 需要 handoff 时，把“当前状态 / 当前阻塞 / 下一步 / 不要重做什么”写清楚，比复述全部过程更重要。
3. 如果你发现每次恢复都要自己重新讲一遍现场，说明应该更早外移记忆，而不是继续堆会话。

## 5. 第四层：把接手路径升级成正式对象

当协调成本继续升高时，继续聊天通常不是答案。

应按对象升级：

1. 同一目标但历史太长：
   - `compact` 或 session memory
2. 多个子目标需要跟踪：
   - task
3. 多条并行执行链需要切换：
   - background tasks / teammate view
4. 高风险改动需要独立现场：
   - worktree

换句话说：

- 压低协调成本，很多时候靠的不是更好 prompt，而是换对承载对象

## 6. 多 Agent 时，先优化接手协议，再谈并行数量

如果有多个 agent，真正先要设计的是：

1. 谁负责综合。
2. 谁负责写入。
3. 何时汇报。
4. 汇报格式是什么。

建议至少写清：

- 目标
- ownership
- 输出格式
- 不能做什么
- 卡住时怎样回报

否则并行 agent 只会把协调成本倍增。

## 7. 苏格拉底式检查清单

在继续当前会话前，先问自己：

1. 我现在还能一句话说清当前主语吗。
2. 下一步到底该由模型继续，还是该由我明确纠偏。
3. 这段历史里真正还需要保留的，是原文，还是行动语义。
4. 我现在的问题是模型不会做，还是人类和模型都不知道该从哪里继续。
5. 这个任务是不是已经该升级成 task / worktree / 新 session。

如果这五问答不清，继续加 prompt 往往只会继续抬高协调成本。

## 8. 一句话总结

Claude Code 的长任务强项，不在于它总能记得更多原文，而在于它能把“当前主语、下一步动作、未来接手所需语义”和“接手对象”一起整理出来，让人类和模型都更容易继续。
