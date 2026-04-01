# query turn 状态机、继续语义与恢复链

这一章回答六个问题：

1. `query.ts` 为什么不能被理解成“一次模型请求”。
2. turn runtime 的状态到底存在哪里。
3. `continue` 在 Claude Code 里到底是什么意思。
4. recovery、stop hook、token budget、tool follow-up 为什么都走同一条链。
5. abort 为什么也必须被当成状态机分支。
6. `/resume`、`--continue` 与内部 self-loop 是什么关系。

## 1. 先说结论

`query.ts` 本质上不是 loop wrapper，而是一个 open-coded turn runtime：

1. 它先把 `messages`、`ToolUseContext`、recovery 计数器、`transition`、`turnCount` 收进 `State`。
2. 然后在 `while (true)` 里不断重建“本轮有效上下文窗口”。
3. 每个 `continue` 站点都不是简单重试，而是明确替换下一轮状态。
4. 可恢复失败不会立刻出栈，而是尽可能重新规约成下一次 turn。
5. terminal 退出也不是单值，而是带 `reason` 的结束语义。

所以 Claude Code 的 turn 真相是：

- 一次用户提交
- 展开成多个内部 turn
- 在同一个 `query()` 调用里自我重入
- 直到工具链、恢复链、策略链都收敛

关键证据：

- `claude-code-source-code/src/query.ts:203-235`
- `claude-code-source-code/src/query.ts:251-340`
- `claude-code-source-code/src/query.ts:365-540`
- `claude-code-source-code/src/query.ts:652-950`
- `claude-code-source-code/src/query.ts:1065-1305`
- `claude-code-source-code/src/query.ts:1363-1714`
- `claude-code-source-code/src/QueryEngine.ts:175-183`
- `claude-code-source-code/src/QueryEngine.ts:436-463`
- `claude-code-source-code/src/utils/QueryGuard.ts:1-99`
- `claude-code-source-code/src/utils/conversationRecovery.ts:159-273`

## 2. turn runtime 与 conversation runtime 不是一层

`QueryEngine` 管的是 conversation-scope 状态：

- `mutableMessages`
- transcript 记录
- usage 聚合
- abort controller
- query 前后的外层 orchestration

而 `query.ts` 管的是一次 submit 内部的 turn-scope runtime：

- 当前有效 `messages`
- 本轮 `ToolUseContext`
- auto compact 跟踪
- `max_output_tokens` 恢复计数
- `transition`
- `pendingToolUseSummary`

再往前一层，`QueryGuard` 还在 REPL/队列入口守住：

- `idle`
- `dispatching`
- `running`

这说明 Claude Code 明确把“当前任务是否活着”拆成三层：

1. 会话层有没有 active query
2. 当前 submit 的内部 turn 正跑到哪
3. UI / queue 入口能否继续派发

## 3. `State` 就是 continue 语义的载体

`State` 字段本身已经写出了作者对 continue 的理解：

- `messages`
- `toolUseContext`
- `autoCompactTracking`
- `maxOutputTokensRecoveryCount`
- `hasAttemptedReactiveCompact`
- `maxOutputTokensOverride`
- `pendingToolUseSummary`
- `stopHookActive`
- `turnCount`
- `transition`

这里最重要的不是字段数量，而是两个设计点：

### 3.1 `transition` 显式记录“为什么继续”

代码不是靠“当前多了一条 meta user message”去倒推恢复链是否发生过，而是直接写进：

- `collapse_drain_retry`
- `reactive_compact_retry`
- `max_output_tokens_escalate`
- `max_output_tokens_recovery`
- `stop_hook_blocking`
- `token_budget_continuation`
- `next_turn`

这说明 continue 不是 incidental control flow，而是正式 runtime state。

### 3.2 continue 站点统一用“替换下一个 State”

代码没有维护一堆散落的局部变量回填，而是在每个 continue 站点显式写：

- 下一轮 `messages` 是什么
- recovery 计数器是否递增/清零
- `ToolUseContext` 是否更新
- `transition` 设成什么

这让每一种恢复路径都能被单独验证，也降低了“上个分支漏清理一个 flag”导致状态脏写的风险。

## 4. 送进模型前，runtime 会先重写上下文窗口

真正进入采样之前，Claude Code 会先做一条完整的 preflight shaping pipeline：

1. `applyToolResultBudget(...)`
2. `snipCompactIfNeeded(...)`
3. `microcompact(...)`
4. `contextCollapse.applyCollapsesIfNeeded(...)`
5. `autocompact(...)`

这条链很关键，因为它决定了：

- 模型看到的不是 transcript 原文
- 而是当前 turn 的“有效上下文工作集”

因此 recovery 也不能简单理解成“出错后再补救”。
很多所谓恢复，其实早在 sampling 前就已经通过上下文重排把风险降掉了。

## 5. sampling 阶段本身也是子状态机

流式采样阶段不只是“等模型吐 token”。
它至少还承担了六件事：

1. 累积 assistant message
2. 捕捉 `tool_use`
3. 给 streaming tool executor 喂工具
4. 对 `message_delta` / `tool_use` 做 transcript 兼容处理
5. 对可恢复错误先 withholding
6. 在 fallback model 条件下做 request-level retry

尤其需要注意的是 recoverable error withholding：

- `prompt_too_long`
- media-size error
- `max_output_tokens`

这些错误不会第一时间向外暴露，因为一旦太早吐给 SDK/宿主，外层 consumer 可能直接把会话判死。
所以代码先把错误压住，等 recovery 逻辑决定“还能不能继续”，再决定是否真正对外发出。

## 6. continue 其实有三类

如果只看代码表面，会觉得所有 `continue` 都一样。
但从语义上至少有三类。

### 6.1 tool follow-up continuation

最常见的一类：

- assistant 产生 `tool_use`
- runtime 执行工具
- 拼上 `tool_result` / attachment
- 进入下一内部 turn

这是 agentic turn 的主路径，对应的 `transition` 往往是 `next_turn`。

### 6.2 recovery continuation

这类 continue 的目的不是“继续做任务”，而是“先修复执行条件”：

- `collapse_drain_retry`
- `reactive_compact_retry`
- `max_output_tokens_escalate`
- `max_output_tokens_recovery`

换句话说，它先修运行环境，再让任务继续。

### 6.3 policy continuation

还有一类 continue 来自策略层，而不是模型层：

- stop hook blocking error
- token budget continuation nudge

这说明 stop hook 和 token budget 也不是外层附加功能，而是会回写 turn runtime 的正式控制器。

## 7. recovery 链条的顺序非常有讲究

### 7.1 `prompt_too_long`

顺序是：

1. 先尝试 collapse drain
2. 再尝试 reactive compact
3. 还不行才真正 surface error

这表明作者偏向：

- 先保留颗粒度
- 再做摘要化压缩

### 7.2 media-size error

media 错误不走 collapse drain，而直接交给 reactive compact 的 strip-retry。
原因很清楚：

- collapse 不会剥离媒体
- 只有 reactive compact 真正能把大媒体从窗口里拿掉

### 7.3 `max_output_tokens`

顺序又不同：

1. 如果命中了默认上限，先把上限提高到更大值
2. 再不行就注入一条 meta user message，要求模型直接从中断处继续
3. 达到恢复上限才真正吐错

这说明 Claude Code 把“输出截断”看成可分段续写问题，而不是纯错误。

## 8. abort 的首要目标不是“快停”，而是“一致停”

abort 路径是这份源码最容易被低估的地方之一。

代码在 streaming abort 和 tool abort 上都不是直接 `return`，而是先尽量做几件事：

1. 补齐 missing `tool_result`
2. 清理 streaming executor
3. 决定要不要发 interruption message
4. 检查 `maxTurns`
5. 再返回 `aborted_streaming` 或 `aborted_tools`

这背后的 invariant 很明确：

- transcript 不能留下孤儿 `tool_use`
- 工具配对不能坏
- 终止原因要可恢复、可解释

所以 abort 也是状态一致性机制，而不只是中断控制。

## 9. transcript 不是日志，而是 runtime contract

这一章必须和 session/restore 章节一起看。

`recordTranscript(...)`、`conversationRecovery.ts`、`sessionRestore.ts` 共同说明：

1. transcript 要足够完整，才能知道中断前内部 turn 走到哪
2. compact / content replacement / collapse 都必须留下可恢复痕迹
3. resume 不只是“读回消息”，还要把 worktree、agent、collapse 状态重新接起来

所以 `query.ts` 的 continue 语义与 `/resume`、`--continue` 不是割裂的两套系统：

- 前者负责把一次 turn 维持成可继续执行轨迹
- 后者负责把这条轨迹从磁盘重新还原成 runtime

## 10. 对蓝皮书的启发

理解这一章后，后续写作应该遵守四条约束：

1. 不要把 `query.ts` 写成“模型调用 + 工具执行”的两步法。
2. 写 recovery 时，必须标出它属于 context repair、output continuation 还是 policy continuation。
3. 写 abort 时，必须同时写一致性约束，而不是只写中断入口。
4. 写 `/resume` 时，必须明确它恢复的是 runtime contract，而不是聊天记录快照。

## 11. 一句话总结

Claude Code 的 turn 真相不是一次请求，而是一台会把工具、压缩、恢复、策略和中断都规约进同一 `State` 的可继续 runtime。
