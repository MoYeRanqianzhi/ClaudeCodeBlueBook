# Prompt编译与稳定性支持面手册：request compiler 输入面、宿主观测面与 internal compiler surface

这一章回答五个问题：

1. Claude Code 当前到底通过哪些正式支持面暴露 Prompt 编译与稳定性相关能力。
2. 哪些属于宿主可写入口，哪些属于宿主可观测表面，哪些仍是 internal-only 编译面。
3. 为什么 Prompt 支持面不应被理解成“一个 system prompt 字符串参数”。
4. 为什么 cache break、message normalization 与 lawful forgetting 也属于 Prompt 支持面的重要部分。
5. 平台设计者该按什么顺序接入这套支持面。

## 0. 关键源码锚点

- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:57-72`
- `claude-code-source-code/src/constants/prompts.ts:491-557`
- `claude-code-source-code/src/utils/systemPrompt.ts:28-104`
- `claude-code-source-code/src/utils/messages.ts:1989-2148`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:243-520`
- `claude-code-source-code/src/services/compact/prompt.ts:1-260`
- `claude-code-source-code/src/services/compact/sessionMemoryCompact.ts:188-397`

## 1. 先说结论

Claude Code 当前并没有公开一份单独名为 `compiled_request_truth` 的正式 API 对象。

但 Prompt request compiler 的稳定支持面已经通过三层结构被暴露出来：

1. `可写入口`
   - 宿主和调用者能向 Prompt 编译链输入什么。
2. `可观测表面`
   - 宿主能知道当前 Prompt 世界发生了什么。
3. `internal compiler surface`
   - 真正把输入编译成协议真相的内部机制。

真正成熟的接入方式，不是把这三层混成一层，而是：

- 明确知道哪些能写、哪些能看、哪些只能依赖其效果

更短地说：

- 宿主写的是 request compiler 的输入面
- 宿主看的是 request compiler 的外化投影
- 宿主不直接绑定 request compiler 的内部实现

## 2. 宿主可写入口

当前最稳定的 Prompt 可写入口主要有：

1. `initialize.systemPrompt`
2. `initialize.appendSystemPrompt`
3. `initialize.agents`
4. `initialize.promptSuggestions`
5. CLI / Frontmatter / agent prompt 注入面

这说明 Claude Code 对 Prompt 的公开支持方式更接近：

- 输入面

而不是：

- 直接开放内部编译对象

正确理解是：

1. 宿主可以声明或追加 Prompt 输入。
2. 宿主可以决定是否启用某些 Prompt 相关功能。
3. 宿主不能直接声明“最终编译后的请求对象是什么”。

## 3. 宿主可观测表面

Prompt 编译链并非完全黑箱，宿主仍可通过这些支持面观察它的效果：

1. `Context Usage`
2. `session_state_changed`
3. `worker_status / external_metadata`
4. prompt cache break 相关观测与诊断

这些表面回答的不是：

- Prompt 原文是什么

而是：

1. 当前世界占了多少席位。
2. 哪些 section / tool / attachment 在吃成本。
3. 当前稳定性为什么变化。
4. 当前继续条件是否已被 Prompt 变化影响。

## 4. internal compiler surface

真正把 Prompt 输入编译成协议真相的关键支持面仍然是内部机制：

1. `prompts.ts`
2. `systemPrompt.ts`
3. `messages.ts`
4. `compact/prompt.ts`
5. `sessionMemoryCompact.ts`
6. `promptCacheBreakDetection.ts`

这些面共同负责：

1. section 组装
2. 主权顺序
3. protocol transcript 编译
4. lawful forgetting 边界
5. stable bytes 解释

对宿主开发者来说，最重要的判断不是“能不能直接调用这些函数”，而是：

- 当前正式支持面是否已经足够让我正确消费它们的结果

## 5. 三层支持矩阵

更稳的接入矩阵可以写成：

### 5.1 可写

1. `systemPrompt`
2. `appendSystemPrompt`
3. `agents`
4. Prompt 相关开关

### 5.2 可观测

1. `Context Usage`
2. session / worker 状态面
3. cache break 解释结果的外化投影

### 5.3 不应直接依赖为公共 ABI

1. section registry 内部细节
2. `normalizeMessagesForAPI` 的内部实现细节
3. compact prompt 的内部格式
4. prompt cache diff 的完整内部 trace

### 5.4 最短对照

| support layer | 宿主实际拿到什么 | 最常见误读 |
|---|---|---|
| `request compiler input surface` | `systemPrompt / appendSystemPrompt / agents / promptSuggestions` | 把输入面当成 request truth 本体 |
| `observable surface` | `Context Usage / session_state_changed / worker_status / external_metadata / cache break投影` | 把成本曲线或状态文案当成全部 Prompt 真相 |
| `internal compiler surface` | section assembly / message normalization / compact prompt / lawful forgetting / cache break detection | 把内部实现细节当公共 ABI |

## 6. 接入顺序建议

更稳的顺序是：

1. 先接 Prompt 输入面
2. 再接 Context Usage 与状态观测面
3. 再根据编译/稳定性现象回看内部机制

不要做的事：

1. 不要把 internal compiler surface 当公共稳定 ABI。
2. 不要用原文 prompt 代替 request compiler 的外化结果。
3. 不要把 cache 稳定性问题理解成偶发性能问题。

## 7. 一句话总结

Claude Code 的 Prompt 支持面，不是一个 prompt 字符串 API，而是“request compiler 输入面 + 宿主观测面 + internal compiler surface”共同组成的分层支持面。
