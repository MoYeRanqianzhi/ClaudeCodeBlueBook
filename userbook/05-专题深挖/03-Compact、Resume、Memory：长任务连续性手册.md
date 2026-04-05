# Compact、Resume、Memory：长任务连续性手册

## 第一性原理

Claude Code 不是为“一问一答”设计的。它服务的是长时间、可中断、可恢复的软件工作。

一旦任务拉长，系统就必须处理三个问题：

1. 上下文窗口会满。
2. 用户会中断又回来。
3. 某些约束会跨很多回合反复出现。

于是形成了三类连续性机制：

- `Compact`
- `Resume`
- `Memory`

如果把用户对外交付也算进连续性管理，还应再加一类：

- `Export`

## Compact：把历史换成更小但可行动的表示

`/compact` 的实现清楚说明它不是简单删历史：

- 会先过滤 compact boundary 后的有效消息。
- 没有自定义说明时，优先尝试 session memory compaction。
- 某些模式下会进入 reactive compact 路径。
- 还会先跑 microcompact 降 token，再跑总结压缩。
- 压缩后会做 post-compact cleanup，并重置若干缓存/观测状态。

对用户的实际意义是：

- Compact 是“继续工作”的手段，不是“清理聊天”的手段。
- 当任务仍在继续时，优先 compact 而不是重开会话。
- 它还承担“继续资格维护器”的角色，尽量保住后续还能行动的最小工作面。

## Resume：恢复的是工作现场，不只是文本

虽然 `resume` 命令表面像“打开旧会话”，但 Claude Code 周边大量状态结构说明它恢复的是更宽的对象：

- 会话历史。
- 标签和元信息。
- 某些任务或远程状态。
- 压缩边界后的继续工作面。

因此 resume 的正确使用方式不是“翻旧账”，而是“回到仍可行动的现场”。

## Memory：把重复约束从短上下文中拿出去

`/memory` 命令的 UX 很简单，但它背后做的是一件很重要的事：

- 让长期稳定偏好不再反复占用主上下文。
- 通过文件方式把偏好变成可编辑、可审查、可共享对象。

Bundled `remember` skill 则进一步说明，Claude Code 甚至在试图把自动记忆、项目记忆和更稳定记忆层之间的晋升流程产品化。

## Export：把内部连续性翻译给外部世界

`/export` 不是单纯拷文本，而是把当前工作对象转成会话外可消费的表示。

它和前面三者的关系是：

- `Compact` 保住当前会话还能继续。
- `Resume` 让你回来继续。
- `Memory` 让长期约束留下来。
- `Export` 让当前结果被会话外的人、流程或系统消费。

## 什么时候用哪个

### 用 Compact

任务没结束，但对话过长。

### 用 Resume

你离开过，现在要回来继续同一工作。

### 用 Memory

某条约束会跨很多任务长期存在。

### 用 Export

当前结果已经要离开 Claude Code，交给外部读者或外部流程。

## 用户工作流建议

### 长重构任务

一开始正常推进，中途快满时 compact，第二天回来 resume，结束后把通用约束沉到 memory。

### 高复用项目习惯

直接写进 memory，不要在每个 prompt 中重复。

### 经常卡在长历史里

优先检查是不是应该 compact，而不是继续向已拥挤的上下文塞更多描述。

### 需要把阶段成果交付给会话外部

优先 export，而不是寄希望于别人去 resume 你的内部会话。

## 稳定面与灰度面

### 相对稳定

- `/compact`
- `/resume`
- `/memory`
- 基础 session memory 机制

### 有条件或更深层

- session memory compaction 的具体路径
- reactive compact
- 某些 transcript / sessionTranscript 相关能力
- 自动记忆晋升与 dream 类后台整理

## 苏格拉底反诘

### 问：为什么不能只靠更大上下文窗口

答：因为连续性问题不只来自 token 上限，还来自用户中断、任务切分、信息层次和可恢复性。

### 问：为什么 memory 不能由 prompt 代替

答：prompt 每次都要重新付出输入成本，而且更容易漂移；memory 是长期对象。

### 问：为什么 compact 不是危险操作

答：危险在于误用。只要它服务的是“保留可行动摘要”，它比无限堆历史更稳。

## 源码锚点

- `src/commands/compact/compact.ts`
- `src/services/compact/compact.ts`
- `src/services/compact/microCompact.ts`
- `src/services/compact/postCompactCleanup.ts`
- `src/commands/memory/memory.tsx`
- `src/services/SessionMemory/*`
- `src/commands/resume/index.ts`
- `src/commands/export/index.ts`
- `src/utils/sessionStorage.js`
