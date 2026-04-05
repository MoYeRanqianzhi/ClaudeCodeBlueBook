# 用Context Usage与状态回写调优Prompt和预算

这一章回答五个问题：

1. 为什么真正的 prompt 调优不能只靠感觉。
2. 怎样用 `get_context_usage` 判断 Claude Code 现在是“规则太胖”还是“日志太吵”。
3. 怎样结合 `pending_action`、`permission_mode`、`session_state_changed` 判断当前到底卡在哪里。
4. 怎样把这些观测结果转成下一轮更稳的 prompt / object / worktree / session 策略。
5. 如何用苏格拉底式追问避免把预算问题误判成模型问题。

## 0. 代表性源码锚点

- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:175-305`
- `claude-code-source-code/src/components/ContextVisualization.tsx:110-220`
- `claude-code-source-code/src/utils/sessionState.ts:92-130`
- `claude-code-source-code/src/state/onChangeAppState.ts:50-92`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:332-460`

这些锚点共同说明：

- Claude Code 已经给出了足够多的观测面，真正的问题往往不是“看不到”，而是“没拿这些信号来改用法”

## 1. 先说结论

更稳的调优方法，不是：

- 再写一版更长的 prompt

而是：

1. 先看预算花在哪里。
2. 再看系统现在卡在什么状态。
3. 最后才决定该改 prompt、改对象、改工具面，还是改治理边界。

## 2. 第一步：先判断胖的是哪一层

拿到 context usage 后，先问三个问题：

### 2.1 是系统层太胖吗

如果这些字段偏大：

- `systemPromptSections`
- `systemTools`
- `skills`
- `slashCommands`

更可能的问题是：

- 规则层太厚
- 工具面太宽
- 过多稳定信息被反复注入

### 2.2 是消息层太吵吗

如果这些字段偏大：

- `toolResultTokens`
- `attachmentTokens`
- `assistantMessageTokens`

更可能的问题是：

- 工具输出没有外置
- 附件太多
- 主线程承担了本应下沉到 task/worktree 的长日志

### 2.3 是扩展层太宽吗

如果这些字段偏大：

- `mcpTools`
- `deferredBuiltinTools`
- `agents`

更可能的问题是：

- 当前会话暴露了不必要的能力空间

## 3. 第二步：再判断卡的是哪一种状态

只看 token 占比，不足以判断现在该怎么做。

还要看：

- `pending_action`
- `permission_mode`
- `session_state_changed`

因为“卡住”至少可能有三种完全不同的原因：

1. 预算快爆了
2. 系统在等批准
3. 模式刚变，宿主还没同步真相

如果把这三种情况都当成“模型变慢了”，后续动作就会全错。

## 4. 第三步：把观测结果转成下一轮动作

### 4.1 系统层太胖

优先动作：

1. 把稳定规则外移到 `CLAUDE.md`、skill 或固定模板
2. 收紧工具面
3. 减少每轮都重述的约束

### 4.2 消息层太吵

优先动作：

1. 把大块输出外置
2. 让 review / verify / extract 下沉到独立 task
3. 接受 compact / reactive compact 是主路径

### 4.3 扩展层太宽

优先动作：

1. 暂时关掉不必要的 MCP / channel / agent 暴露面
2. 推迟冷门工具到 deferred 状态
3. 把当前任务目标写得更窄

### 4.4 当前在等批准

优先动作：

1. 不要继续扩 prompt
2. 先处理 `pending_action`
3. 必要时收紧动作预算，避免再次撞到同类阻塞

## 5. 苏格拉底式调优清单

在准备改 prompt 前，先问自己：

1. 我是真的缺规则，还是只是让太多能力进了当前会话。
2. 我是真的缺上下文，还是只是工具结果和附件太吵。
3. 我是真的该换模型，还是只是系统前缀太不稳定。
4. 我是真的需要继续对话，还是该升级成 task / workflow / worktree。
5. 当前卡住是 token 问题，还是 requires_action 问题。

如果这些问题没先答清，就很容易把：

- 预算问题
- 对象问题
- 治理问题

误判成：

- prompt 不够长

## 6. 一句话总结

Claude Code 更稳的调优方式，不是凭感觉改 prompt，而是先看 context usage 和状态回写，再决定该收规则、收工具、收日志，还是改对象与边界。
