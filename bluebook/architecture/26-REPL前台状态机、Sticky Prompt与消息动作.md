# REPL 前台状态机、Sticky Prompt 与消息动作

这一章回答六个问题：

1. REPL 前台为什么不能只被看成消息列表。
2. transcript mode 是什么状态机，而不只是一个“查看历史”的模式。
3. sticky prompt、搜索、message actions 如何共同组成认知控制面。
4. queued commands、teammate view、modal/overlay 为什么都影响前台状态。
5. 为什么这些前台机制会直接反过来约束运行时设计。
6. 这对 Agent IDE 的前台交互意味着什么。

## 1. 先说结论

Claude Code 的 REPL 前台至少有三层状态机同时在跑：

1. 屏幕模式：
   - normal
   - transcript
2. 前台 chrome：
   - sticky prompt
   - unseen divider / new-message pill
   - modal / overlay
3. 操作模式：
   - prompt input
   - transcript search
   - cursor/message actions
   - teammate view
   - queued commands

也就是说，REPL 前台并不是“把消息渲染出来”，而是在维持：

- 用户当前看哪里
- 当前在输入、搜索、滚动还是选择
- 当前应该把什么优先呈现给人

关键证据：

- `claude-code-source-code/src/screens/REPL.tsx:4183-4595`
- `claude-code-source-code/src/components/Messages.tsx:229-320`
- `claude-code-source-code/src/components/FullscreenLayout.tsx:1-120`
- `claude-code-source-code/src/components/VirtualMessageList.tsx:43-99`
- `claude-code-source-code/src/components/VirtualMessageList.tsx:289-767`
- `claude-code-source-code/src/components/messageActions.tsx:1-176`
- `claude-code-source-code/src/state/AppStateStore.ts:88-180`

## 2. 第一层：normal / transcript 不是视图切换，而是交互语义切换

`REPL.tsx` 在 `screen === 'transcript'` 时会直接走一条专门分支。

这条分支不是简单换个 UI，而是同时切换：

- 虚拟滚动逻辑
- transcript search
- dump mode
- 外部编辑器打开
- sticky 行为
- transcript footer
- 搜索栏与 `n/N` 语义

所以 transcript mode 的本质更接近：

- pager/runtime

而不是：

- 普通历史面板

## 3. 第二层：sticky prompt 是认知锚点，不是装饰

`VirtualMessageList` 和 `FullscreenLayout` 说明 sticky prompt 的用途不是“更好看”，而是：

- 当用户向上滚动时，仍保留当前正在围绕哪条 prompt 阅读
- 点击 sticky 可跳回原 prompt
- 配合 unseen divider / new-message pill 管理“你离当前执行现场有多远”

这让终端 REPL 拥有了一个很重要的认知能力：

- 用户可以离开底部去看旧内容
- 但不会完全丢失当前任务锚点

如果没有这一层，长会话的终端体验会迅速退化成：

- 要么一直盯底部
- 要么一旦上翻就失去现场感

## 4. 第三层：transcript search 不是 grep，而是 pager 内部导航

这一组逻辑很像 `less` / `vim` 的增量搜索，而不是普通搜索框：

- `/` 打开 search bar
- `n/N` 在当前结果集里移动
- search anchor 记录打开搜索时的 scrollTop
- 0 匹配会回弹到 anchor
- resize 会强制清空 positions cache 与 query

这说明设计目标不是“给 transcript 加个搜索功能”，而是：

- 把 transcript mode 做成真正可导航的终端阅读器

## 5. 第四层：message actions 说明前台不只是阅读器

`messageActions.tsx` 把可导航消息单独挑出来，并给它们定义了：

- expand / collapse
- edit
- copy
- copy primary input

同时它显式区分：

- 哪些消息可导航
- 哪些虽然渲染了但不值得操作

这说明 REPL 前台不是单纯展示层，而是：

- 带结构化操作 affordance 的现场工作台

尤其是 `copy primary input` 这类动作，直接把 tool call 从“显示内容”提升成“可复用工件”。

## 6. 第五层：queued commands 与 teammate view 改变的是前台主语

Claude Code 前台还有两类很容易被低估的模式切换。

### 6.1 queued commands

当 query 正忙时，新 prompt / task-notification 不会直接消失，而会进入 queued command 流。

这意味着前台必须同时处理两种时间：

- 当前执行时间
- 待消费命令时间

### 6.2 teammate view

当用户切到 teammate transcript，前台主语会从 leader 变成某个 agent/task。

这时会同步影响：

- sticky prompt 可见性
- new-message pill
- in-progress tool IDs
- 输入面与可见消息源

所以 teammate view 不是“打开一个子窗口”，而是主语切换。

## 7. modal / overlay 为什么也属于前台状态机

`FullscreenLayout` 明确支持：

- scrollable transcript
- bottom prompt
- overlay
- centered modal
- bottom float

再加上 REPL 里的：

- permission request
- local-jsx command
- background task dialog
- focused input dialog

会发现前台不是“页面 + 对话框”，而是一个优先级调度系统：

1. 当前 transcript
2. 当前 prompt / spinner
3. 当前 modal / overlay
4. 当前队列化事件

这进一步说明：

- 前台状态不是 React 组件树的 incidental state
- 而是 runtime 的一部分

## 8. 从第一性原理看，为什么 Agent IDE 必须这样设计

一个真正可工作的 Agent IDE 前台，至少要解决四个不可约问题：

1. 用户如何不丢失当前任务锚点。
2. 用户如何在长历史里局部搜索与操作。
3. 用户如何在“看 transcript”和“控制执行”之间切换。
4. 用户如何感知并行 agent、queued command、permission ask 对当前现场的影响。

Claude Code 的 REPL 前台正是在这四个问题上做工程化回答。

## 9. 对使用和设计的启发

对使用者来说：

- transcript mode 更像 pager，不只是历史回看
- sticky prompt / search / message actions 是长会话生产力工具，不是 UI 点缀

对设计者来说：

- Agent IDE 的前台设计，不能只围绕“输入框 + 消息流”
- 一旦进入长会话、多 Agent、后台任务，就必须显式建模：
  - 锚点
  - 模式
  - 队列
  - 主语切换

## 10. 一句话总结

Claude Code 的 REPL 前台之所以强，不是因为终端 UI 做得花，而是因为它把 sticky prompt、搜索、消息动作、队列和主语切换写成了一台真正的前台状态机。
