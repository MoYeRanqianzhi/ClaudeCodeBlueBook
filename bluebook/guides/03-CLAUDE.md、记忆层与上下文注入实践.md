# CLAUDE.md、记忆层与上下文注入实践

本章回答一个很实际的问题：

- 怎样把 Claude Code 的规则、记忆和上下文注入用对，而不是互相污染。

## 1. 先说结论

更接近 Claude Code 设计本意的分层方式是：

1. `CLAUDE.md`：
   - 项目级长期协作规则
2. `CLAUDE.local.md`：
   - 私有项目级规则
3. typed memory / `MEMORY.md`：
   - 跨会话长期知识
4. session memory：
   - 当前长会话连续性
5. plan / tasks：
   - 当前任务步骤与执行状态
6. `--append-system-prompt`：
   - 本轮临时补充约束

如果把这些层用反了，最常见的结果是：

- prompt 越来越长
- 规则和任务日志混在一起
- 长期记忆难以维护
- 相关信息难以被正确召回

## 2. 什么时候写 `CLAUDE.md`

适合写进 `CLAUDE.md` 的内容：

- 代码风格与工程约束
- 常用命令与验证方式
- 团队协作规则
- 项目长期边界

不适合写进 `CLAUDE.md` 的内容：

- 本周临时待办
- 某次会话的工作日志
- 一次性的 bug 调试过程

源码依据：

- `claude-code-source-code/src/utils/claudemd.ts:1-26`
- `claude-code-source-code/src/context.ts:155-188`

## 3. 什么时候用 typed memory

适合放入 typed memory 的内容：

- 跨会话仍然会用到的事实
- 用户偏好
- 项目长期知识
- 稳定参考资料入口

不适合放入 typed memory 的内容：

- 当前会话的具体推进步骤
- 尚未确认的临时猜测
- 本轮 plan 的细碎状态

源码依据：

- `claude-code-source-code/src/memdir/memdir.ts:199-260`

实践建议：

1. 保持 `MEMORY.md` 只做索引。
2. 每条记忆写进单独文件。
3. 让索引项短、可扫、可维护。

## 4. 什么时候依赖 session memory

如果任务：

- 很长
- 中间会 compact
- 会跨多轮实现、验证和修正

就让 session memory 去维持当前会话连续性，而不是自己反复贴长摘要。

源码依据：

- `claude-code-source-code/src/services/SessionMemory/prompts.ts:8-80`
- `claude-code-source-code/src/services/SessionMemory/sessionMemory.ts:134-181`

实践建议：

- 不要把 session memory 当长期知识库
- 它更像当前会话的结构化摘要

## 5. 什么时候用 `--append-system-prompt`

适合：

- 本轮临时增加约束
- 让当前会话改用某种输出格式
- 明确一次性的验收标准

不适合：

- 代替项目长期规则
- 重复写已经在 `CLAUDE.md` 中的内容

源码依据：

- `claude-code-source-code/src/main.tsx:1343-1387`
- `claude-code-source-code/src/utils/systemPrompt.ts:41-122`

## 6. 一个推荐目录

项目里更稳的实践通常是：

```text
repo/
  CLAUDE.md
  CLAUDE.local.md         # 私有，不进版本库
  .claude/
    rules/
    commands/
    skills/
    agents/
```

其中：

- `CLAUDE.md` 放长期协作规则
- `.claude/rules/` 放更细的路径条件规则
- `skills/` 放高频工作流
- `agents/` 放稳定角色

## 7. 多 Agent 场景下怎么写上下文

如果你要让 worker 工作得更像 Claude Code 源码设计的方式：

1. 长期规则放 `CLAUDE.md`
2. 任务背景放自包含 worker prompt
3. 当前阶段性状态放 plan/tasks
4. 不要把“based on your findings”当上下文传递方式

源码依据：

- `claude-code-source-code/src/coordinator/coordinatorMode.ts:251-280`

## 8. 最常见的错误

1. 用 `CLAUDE.md` 记录当前任务进度。
2. 用 typed memory 记录当前会话待办。
3. 用很长的 `system-prompt` 代替分层规则。
4. 在多个层里重复同一条规则。

如果你发现上下文越来越重，优先检查的不是模型，而是：

- 你是不是把错误的信息放进了错误的层。

## 9. 一句话总结

Claude Code 的上下文注入最好按“长期规则、长期记忆、会话连续性、当前任务状态、临时约束”五层分开使用，而不是靠一份越来越长的 prompt 硬扛。
