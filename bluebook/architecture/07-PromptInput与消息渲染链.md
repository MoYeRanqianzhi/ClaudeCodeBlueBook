# PromptInput 与消息渲染链

## 1. 先说结论

Claude Code 的前台交互不是“一个输入框 + 一个消息列表”，而是两条互相咬合的链：

1. `PromptInput` 负责把用户意图、补全、模式切换、前台弹窗、权限模式操作转成 submit 行为。
2. `Messages` / `VirtualMessageList` / `messageActions` 负责把运行时事件流渲染成可导航、可搜索、可压缩、可交互的前台工作面。

如果说 REPL 是 orchestration layer，那么这章讲的就是它最直接的前台神经末梢。

## 2. `PromptInput` 的真正职责

`PromptInput` 入口参数已经说明它不是一个普通 text input：

- `toolPermissionContext`
- `commands`
- `agents`
- `messages`
- `mcpClients`
- `getToolUseContext`
- `onSubmit`
- `onAgentSubmit`
- `pastedContents`
- `vimMode`

证据：

- `claude-code-source-code/src/components/PromptInput/PromptInput.tsx:128-170`
- `claude-code-source-code/src/components/PromptInput/PromptInput.tsx:198-225`

这意味着输入框本身就是 runtime 控制端口，而不是只负责收集字符串。

## 3. 输入期就已经开始做“语义增强”

`PromptInput` 在用户真正 submit 前，已经开始并行做一堆解释工作：

- prompt suggestion
- think/ultraplan/ultrareview/btw/buddy trigger 检测
- slash command 高亮
- token budget trigger
- Slack channel trigger
- `@name` teammate mention 高亮

证据：

- `claude-code-source-code/src/components/PromptInput/PromptInput.tsx:508-538`
- `claude-code-source-code/src/components/PromptInput/PromptInput.tsx:540-580`

这说明 Claude Code 的输入框不是 passive buffer，而是主动语义前端。

## 4. submit 不是单一路径

`onSubmit` 前会先判断当前输入是发给 leader 还是发给 teammate。

如果当前激活对象不是 leader，就走 `onAgentSubmit(...)`；否则才走普通 `onSubmitProp(...)`。

证据：

- `claude-code-source-code/src/components/PromptInput/PromptInput.tsx:1088-1105`

这点很关键：  
同一个输入框在多 Agent 视角下其实已经是多路复用的。

## 5. typeahead 把“命令”和“代理”揉在一起

`useTypeahead(...)` 会同时拿到：

- `commands`
- `agents`
- `mode`
- `cursorOffset`
- `onSubmit`

证据：

- `claude-code-source-code/src/components/PromptInput/PromptInput.tsx:1106-1126`

这意味着对 Claude Code 来说，slash command、agent 选择、普通 prompt 补全，本来就是一个统一输入面。

## 6. mode 切换为什么属于输入层

`PromptInput` 直接参与 permission mode 切换，而且 auto mode 首次进入时不是立即全切，而是分两阶段：

1. 先只更新 UI 上的 mode 标签。
2. 等用户接受 opt-in 后，再调用 `transitionPermissionMode(...)` 真正激活 auto mode 并 strip dangerous rules。

证据：

- `claude-code-source-code/src/components/PromptInput/PromptInput.tsx:1458-1492`
- `claude-code-source-code/src/components/PromptInput/PromptInput.tsx:1515-1547`
- `claude-code-source-code/src/components/PromptInput/PromptInput.tsx:1558-1578`

这说明输入层不仅是“收集 prompt”，还承担权限模式的人机边界。

## 7. 输入层还托管大量前台控制弹窗

`PromptInput` 会直接 early-return 渲染这些对话框：

- `BackgroundTasksDialog`
- `TeamsDialog`
- `QuickOpenDialog`
- `GlobalSearchDialog`
- `HistorySearchDialog`

证据：

- `claude-code-source-code/src/components/PromptInput/PromptInput.tsx:2118-2148`

这进一步证明它不是一个单一组件，而是前台控制面总入口。

## 8. `Messages` 如何把 runtime 流变成前台消息墙

`Messages.tsx` 不是简单 map 消息数组，它会对消息做整套变换：

1. `normalizeMessages`
2. `reorderMessagesInUI`
3. brief-only 过滤
4. `applyGrouping`
5. `collapseBackgroundBashNotifications`
6. `collapseHookSummaries`
7. `collapseTeammateShutdowns`
8. `collapseReadSearchGroups`

证据：

- `claude-code-source-code/src/components/Messages.tsx:379-389`
- `claude-code-source-code/src/components/Messages.tsx:475-529`

也就是说，前台渲染看到的是“适合人类阅读的重排视图”，而不是 transcript 原始流。

## 9. brief mode 与 transcript mode 是两种完全不同的显示哲学

`Messages.tsx` 对 brief mode 做了专门处理：

- `filterForBriefTool(...)`
- `dropTextInBriefTurns(...)`

证据：

- `claude-code-source-code/src/components/Messages.tsx:87-158`
- `claude-code-source-code/src/components/Messages.tsx:160-206`

这表明 Claude Code 愿意为了不同 interaction mode 重写显示语义，而不是坚持“所有模式同一消息渲染”。

## 10. VirtualMessageList 说明 transcript 已经是“可导航 UI”，不是纯滚屏

`VirtualMessageList` 暴露了完整的 `JumpHandle`：

- `jumpToIndex`
- `setSearchQuery`
- `nextMatch`
- `prevMatch`
- `setAnchor`
- `warmSearchIndex`
- `disarmSearch`

证据：

- `claude-code-source-code/src/components/VirtualMessageList.tsx:45-68`

它还负责：

- `useVirtualScroll(...)`
- cursor navigation
- selected item visibility
- transcript search jump
- sticky prompt tracking

证据：

- `claude-code-source-code/src/components/VirtualMessageList.tsx:163-169`
- `claude-code-source-code/src/components/VirtualMessageList.tsx:332-381`
- `claude-code-source-code/src/components/VirtualMessageList.tsx:696-815`

这说明 transcript 在 Claude Code 里已经是二级交互界面，而不是只读历史。

## 11. messageActions 让“消息”本身变成操作对象

`messageActions.tsx` 的设计核心是：

- 哪些消息可导航
- 哪些消息可展开
- 哪些消息可复制
- 哪些用户消息可直接编辑
- 哪些 assistant tool_use 可以提取 primary input 复制

证据：

- `claude-code-source-code/src/components/messageActions.tsx:18-64`
- `claude-code-source-code/src/components/messageActions.tsx:121-141`
- `claude-code-source-code/src/components/messageActions.tsx:158-187`
- `claude-code-source-code/src/components/messageActions.tsx:217-270`

所以 Claude Code 的 transcript 不是“日志”，而是带操作语义的文档界面。

## 12. 从第一性原理看，这条前台链在解决什么

它解决的不是“让终端更好看”，而是：

1. 如何让用户在高并发、长会话、复杂任务下仍然能控制 runtime。
2. 如何把系统状态、建议、任务、权限、导航统一压到一个终端工作台里。
3. 如何让 transcript 从被动历史变成主动操作面。

这和传统 shell 的区别非常大：  
Claude Code 前台不是命令提示符，而是一个终端 IDE 式控制层。

## 13. 一句话总结

`PromptInput` 和 `Messages` 共同把 Claude Code 的前台做成了一套“可输入、可导航、可检索、可编辑、可切换模式”的工作台，而不是一条单向滚动的对话流。
