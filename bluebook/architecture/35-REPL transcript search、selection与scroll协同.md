# REPL transcript search、selection 与 scroll 协同

这一章回答五个问题：

1. Claude Code 的 REPL 为什么不只是“会滚动的消息列表”。
2. transcript search、text selection、sticky scroll 三套机制如何互相配合。
3. 为什么这些前台机制会直接反过来约束 REPL runtime 和消息结构。
4. 哪些设计细节体现出作者在认真处理终端长会话的人机摩擦。
5. 这对 Agent IDE 的前台设计意味着什么。

## 0. 代表性源码锚点

- `claude-code-source-code/src/screens/REPL.tsx:879-910`
- `claude-code-source-code/src/screens/REPL.tsx:1248-1374`
- `claude-code-source-code/src/screens/REPL.tsx:2068-2140`
- `claude-code-source-code/src/screens/REPL.tsx:3728-3770`
- `claude-code-source-code/src/utils/transcriptSearch.ts:1-166`
- `claude-code-source-code/src/ink/selection.ts:1-220`
- `claude-code-source-code/src/ink/components/ScrollBox.tsx:1-210`
- `claude-code-source-code/src/components/PromptInput/PromptInputFooterLeftSide.tsx:417-462`

## 1. 先说结论

Claude Code 的 REPL 前台至少有三台互相咬合的小状态机：

1. 搜索状态机：
   - 决定 transcript 中什么文字可被索引、如何导航、如何回到锚点。
2. 选择状态机：
   - 决定鼠标拖拽、自动滚动、跨行复制、复制提示和清空时机。
3. 滚动状态机：
   - 决定 sticky、repin、overlay 出现/消失时如何回到底部，以及用户滚动和程序滚动如何区分。

这三者共同解释了为什么 Claude Code 的终端前台看起来“没有很花”，但长会话体验却比普通聊天壳强很多。

## 2. transcript search 不是 grep，而是“对可见语义做再渲染”

`transcriptSearch.ts` 最关键的判断不是搜索本身，而是：

- 并非所有底层文本都应该被索引

代码里明确跳过或改写了几类内容：

1. 被 UI 替换成中断标记的 sentinel 文本
2. tool result 的模型侧序列化内容
3. 只存在于模型上下文、不属于用户可见层的 `<system-reminder>`
4. `task-notification` 模式的 queued command

这说明 Claude Code 的搜索不是“把原始消息全部 lower-case 后做全文检索”，而是：

- 先决定什么才算前台可见真相
- 再对这个真相建立索引

换句话说，search 追的是：

- render truth

而不是：

- raw transcript truth

## 3. selection 不是小插件，而是终端级子系统

`ink/selection.ts` 的实现厚度说明，作者把 selection 当成了真正的终端行为模拟问题。

它至少处理了：

1. anchor / focus / anchorSpan
2. word / line selection
3. 拖拽时的自动滚动
4. 被滚出 viewport 的文本回收
5. reverse scroll 后的虚拟锚点恢复
6. copy text 时按 soft-wrap 重新拼逻辑行

这意味着 selection 不只是“标几行高亮”，而是：

- 把用户拖拽时眼里看到的文本连续性，尽量和最终复制结果对齐

这就是终端长会话里最容易被低估、但最影响质感的一类细节。

## 4. ScrollBox 的本质不是容器，而是滚动语义路由器

`ScrollBox.tsx` 里最值得注意的是三点：

1. 手动滚动会显式打破 sticky
2. 程序性滚动与用户滚动被严格区分
3. pending delta 会累积，由 renderer 按节流节拍消化

它还提供了：

- `scrollToElement`
- `getPendingDelta`
- `isSticky`
- `setClampBounds`

这意味着 ScrollBox 不只是布局组件，而是：

- 前台滚动语义的统一宿主

如果没有这一层，REPL.tsx 就会被迫在各处散落处理“当前到底是不是用户主动滚走了”这种状态。

## 5. REPL 如何把三台状态机编进主循环

`REPL.tsx` 最关键的几处协同逻辑是：

### 5.1 用户滚动与程序滚动分离

- `lastUserScrollTsRef` 只在用户滚动路径更新
- `repinScroll()` 不会污染这个时间戳

这使得系统能区分：

- 用户正在主动阅读旧内容
- 程序只是为了恢复可见性而回到底部

### 5.2 输入空到非空时，只有在“不是刚滚上去阅读”的情况下才 repin

这条规则看起来小，但非常重要：

- 想输入时能快速回到现场
- 又不会在用户刚上翻看历史时，因为敲一个字就被硬拽回底部

### 5.3 tool-permission overlay 的出现与消失都会强制 repin

这说明作者把 permission overlay 当成：

- 阻断性前台事件

而不是普通浮层。  
在这种事件上，“可见性优先于用户当前滚动位置”。

## 6. 为什么 selection / search / scroll 会反过来约束消息结构

这些前台机制迫使消息系统必须保持几件事：

1. 哪些内容是用户真正看到的，必须可枚举。
2. 模型侧辅助文本不能随便混进前台索引。
3. 复制结果必须尽量和用户看到的一致。
4. 队列化消息、`task-notification`、channel message 这类“特殊来源”要在前台有不同语义。

这说明前台不是下游消费者，而是：

- 反过来给消息塑形提出约束的一层 runtime

## 7. 从第一性原理看，这一层到底解决什么问题

一个真正可用的 Agent IDE 前台，至少要解决四个不可约问题：

1. 用户如何在长会话里局部找东西。
2. 用户如何在滚动阅读时不丢失当前现场。
3. 用户如何在选择/复制时拿到符合直觉的文本。
4. 用户如何分辨是“我滚走了”还是“系统把我带走了”。

Claude Code 在终端环境里，正是靠 search / selection / scroll 的协同把这四个问题工程化。

## 8. 苏格拉底式追问

### 8.1 为什么普通聊天壳往往做不好这层

因为它们把前台看成：

- 一串消息 + 一个输入框

而不是：

- 一套注意力管理系统

### 8.2 为什么这里的很多细节不是“洁癖优化”

因为终端长会话里，任何一处错位都会被立刻放大：

- 搜索命中看不见的文本
- 复制结果和高亮不一致
- 一滚上去就再也找不到现场
- 输入一个字就被强拉到底部

这些都不是小问题，而是直接破坏人机协作。

### 8.3 最值得迁移的是什么

不是具体按键绑定，而是这条设计观：

- 先定义“用户可见真相”
- 再让搜索、复制、滚动都围绕这个真相工作

## 9. 一句话总结

Claude Code 的 REPL 之所以比普通终端聊天壳强，不在 UI 漂亮，而在它把 search、selection、scroll 当成协同的前台状态机，而不是三个零散小功能。
