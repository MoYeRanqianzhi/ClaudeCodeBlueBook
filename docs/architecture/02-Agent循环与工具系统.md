# Agent 循环与工具系统

## 1. 结论先行

Claude Code 的核心不是一个大 prompt，而是一个被工程化的循环：

```text
输入 -> 系统提示词组装 -> query() -> 流式模型输出
    -> 工具判权与执行 -> 结果回填 -> 压缩/持久化/恢复
    -> 下一轮
```

真正让它“像工程代理”而不是“像聊天机器人”的，是这个循环外面那一整套工具、权限、状态和压缩机制。

## 2. `QueryEngine`：面向会话的生命周期封装

`src/QueryEngine.ts` 明确写着“一次会话一个 QueryEngine”。它保存：

- `mutableMessages`
- `permissionDenials`
- `readFileState`
- `totalUsage`
- 发现过的技能名
- 已加载的 memory 路径

这意味着它不是一次性请求对象，而是“会话对象”。

关键证据：

- 类注释与成员定义：`src/QueryEngine.ts`
- `submitMessage()` 先构造 `systemPrompt`、再处理用户输入、再进入 `query()`：`src/QueryEngine.ts`

## 3. `processUserInput()`：先处理输入，再决定是否真正问模型

在 `submitMessage()` 里，用户输入先经过 `processUserInput()`。

它会做这些事：

- slash command 解析
- pasted contents / image / attachments 处理
- hooks 执行
- 本地命令结果转消息
- 决定 `shouldQuery`

所以并不是每次用户发一行文本，都会直接进入模型调用。

这很重要，因为 Claude Code 的输入层本身就具备“工作流编排能力”。

## 4. `query()`：真正的主循环

`src/query.ts` 才是最核心的 Agent Loop。

从可见代码看，它至少承担这些职责：

- 构建 query state
- 维护 query chain tracking
- 处理 tool result budget
- 执行 snip / microcompact / autocompact / context collapse
- 调模型并处理流式返回
- 收集 `tool_use`
- 借助 `StreamingToolExecutor` 并发执行工具
- 处理 fallback model、错误恢复、重试

关键证据：

- `export async function* query(...)`：`src/query.ts`
- compaction 与 collapse 在 API 调用前执行：`src/query.ts`
- 流式 tool execution 与 fallback 逻辑：`src/query.ts`

这说明 Claude Code 的主循环不是“模型一轮、工具一轮”的简陋串行器，而是一个有多重恢复路径的调度器。

## 5. 工具接口：`Tool.ts`

`src/Tool.ts` 定义的不是简单的 `call()` 接口，而是一整套统一契约。

一个工具可以定义：

- 输入/输出 schema
- `validateInput`
- `checkPermissions`
- `preparePermissionMatcher`
- `isReadOnly`
- `isConcurrencySafe`
- `toAutoClassifierInput`
- 多种 UI 渲染函数
- 结果搜索文本
- tool summary

而 `buildTool()` 会给关键方法补默认值。

这意味着 Claude Code 的工具不是“函数集合”，而是统一协议下的能力单元。

## 6. 工具池不是固定表，而是动态装配

`src/tools.ts` 说明工具池由三步构成：

1. 先得到内置工具
2. 再按 deny rules 过滤
3. 再和 MCP 工具装配、排序、去重

关键点：

- `getTools()` 会根据 simple mode、REPL mode、coordinator mode 等上下文改变暴露面
- `assembleToolPool()` 会把内置工具和 MCP 工具组合成完整池
- 排序稳定性还被拿来服务 prompt cache 稳定

这套设计很“工程”：连工具顺序都不是随意的，而是和缓存命中率绑定。

## 7. `BashTool`：为什么 shell 是能力中心

从 `src/tools/BashTool/BashTool.tsx` 可见，BashTool 远不只是“执行命令”：

- 能识别 search/read/list 类命令
- 有输入校验
- 有权限匹配
- 可选择 sandbox
- 支持前台、显式后台、自动后台
- 对长任务支持进度轮询和任务输出落盘
- 对图像输出、超大输出、sed edit 都有专门处理

尤其重要的两个信号：

1. assistant mode 下，阻塞太久的命令会自动后台化
2. 用户也可以显式 `run_in_background`

这说明 Claude Code 的 shell 能力不是一次性调用，而是任务系统的一部分。

## 8. `AgentTool`：多代理不是外挂，是内建能力

`src/tools/AgentTool/AgentTool.tsx` 直接证明多代理是内建能力：

- 支持子代理类型选择
- 支持后台代理
- 支持 team / teammate
- 支持 worktree 隔离
- 支持 remote 隔离
- worker 的工具池单独装配
- fork path 与普通 path 分开处理

这里最重要的一点是：

父代理不会把自己的工具池原样传给所有子代理，而是根据 worker 的权限上下文重建工具池。

这是强系统感的来源之一：每个代理是受约束的工作单元，不是简单复制父上下文。

## 9. 权限系统不是附加层，而是循环的一部分

`src/utils/permissions/permissionSetup.ts` 显示：

- permission mode 会影响工具权限上下文
- 磁盘规则、CLI 规则、额外目录会共同进入上下文
- auto mode 下还会检查危险权限，避免绕过 classifier
- bypass 权限是否可用还受 gate 和 settings 影响

因此 Claude Code 不是“先决定做什么，再临时弹权限框”，而是从一开始就在构造受约束的行动空间。

## 10. 对使用方式的直接影响

从源码反推，正确用法应该是：

1. 把 Claude Code 当成带工具和任务系统的操作环境，而不是纯聊天。
2. 长任务优先后台化，复杂任务优先子代理化。
3. 使用权限模式、worktree、remote 等机制来控制风险边界。
4. 当上下文变长时，理解它会压缩、折叠、持久化，而不是无限堆积。

## 11. 一句话总结

Claude Code 的本质不是“会写代码的模型”，而是“把模型包进了一个可持续执行的软件系统”。
