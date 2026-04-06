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

## 先按 continuation qualification，不按命令名

如果把这页压成用户侧最小顺序，只该先做四步：

1. 先确认现在要延续的仍是同一个工作对象。
2. 再确认当前 `decision window` 和 working set 还配不配继续，而不是默认免费续聊。
3. 再分清哪些是还能留下的 durable assets，哪些只是必须清空或外置的高波动对象与 transient authority。
4. 最后才决定该用 `Compact`、`Resume`、`Memory` 还是 `Export`。

这组顺序里，省 token 和安全并不是两个主题。它们都在回答同一件事：当前继续是否仍值得付费，哪些东西该留在当前世界，哪些东西必须移出、重绑或清空。

## 进入本页前的 first reject signal

看到下面迹象时，应先回到 continuation qualification，而不是直接选命令：

- 你把 `/compact` 理解成“省字数”，而不是把高波动对象移出当前世界、只保留还能继续裁决的 working set。
- 你把 `/resume` 理解成“翻回旧会话”，而不是恢复仍具继续资格的工作现场。
- 你把“继续”理解成默认免费续聊，而没有先确认同一工作对象、durable assets 和授权连续性是否都还成立。
- 你想把所有历史都沉进 memory，而不是只把长期稳定约束外置成可审查资产。

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

它真正省下的也不是“字数”，而是把高波动对象、旧推导和已完成结果移出当前世界，只留下还需要裁决的 working set。

## Resume：恢复的是工作现场，不只是文本

虽然 `resume` 命令表面像“打开旧会话”，但 Claude Code 周边大量状态结构说明它恢复的是更宽的对象：

- 会话历史。
- 标签和元信息。
- 某些任务或远程状态。
- 压缩边界后的继续工作面。

因此 resume 的正确使用方式不是“翻旧账”，而是“回到仍可行动的现场”。

更严格地说，resume 不是默认免费继续。只有同一工作对象、仍被承认的 durable assets 和未失效的授权连续性还在，它才值得继续。

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

因此 export 也不只是“拷出去”，而是把当前不该继续占住工作现场的结果，正式移到 `Outside`。

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

### 不确定该不该继续时

先问 continuation qualification 还在不在，不要把“还能看到旧内容”误当成“还该继续推进”。

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
