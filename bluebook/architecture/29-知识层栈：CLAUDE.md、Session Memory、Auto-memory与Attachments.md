# 知识层栈：CLAUDE.md、Session Memory、Auto-memory与Attachments

> Evidence mode
> - 当前 worktree 仍是 `mirror absent / public-evidence only`。
> - 更稳的默认口径，不是把本页写成一张“四层同级 canonical memory stack”，而是把这些对象先区分成 `rule artifact`、`durable context artifact`、`continuation carrier` 与 `relevance projection`。
> - 机器本地记忆、session notes、nested attachments 与 relevant memories 在这一口径下都不自动构成 `witness`、更不自动构成 `single-writer hierarchy`。

这一章回答五个问题：

1. Claude Code 的“知识”到底分成哪些层。
2. `CLAUDE.md`、typed memory、session memory、auto-memory 各自负责什么。
3. 为什么这些层不能被混写成一种“记忆”。
4. 它如何在长会话里兼顾持久化、相关性和 token 预算。
5. 这套结构对使用者有什么直接启发。

## 1. 先说结论

Claude Code 更稳的上下文结构，不是“四层同级记忆栈”，而是四种不同职责的 context surface：

1. `rule artifact`
   - `CLAUDE.md`
   - `CLAUDE.local.md`
   - managed/user/project/local rules
2. `durable context artifact`
   - typed memory
   - `MEMORY.md` 入口索引
   - 记忆文件目录
3. `continuation carrier`
   - session memory
   - 当前会话的结构化总结
4. `relevance projection`
   - nested memory attachments
   - relevant memories prefetch

这四层的职责分别是：

- 规则层回答“应该怎么协作”
- 持久记忆层回答“跨会话应长期记住什么”
- 会话连续性层回答“当前这次工作已经推进到了哪里”
- 相关性层回答“这一轮最值得再提醒什么”

如果继续把这四种 surface 再压成 later maintainer 可直接复查的一张最小表，也只先看下面五格：

| object | 更稳的默认读法 | 不能偷升成什么 |
|---|---|---|
| `CLAUDE.md` | rule artifact | 通用工作日志或 host-facing signer |
| typed memory / `MEMORY.md` | durable context artifact | 当前任务 plan / execution ledger |
| session memory | continuation carrier | 跨会话长期事实库或 admissible witness |
| nested memory attachment | path-conditioned context projection | 第二份全局 prompt |
| relevant memories | relevance projection | 永久常驻前缀或稳定 ABI |

代表性证据：

- `claude-code-source-code/src/utils/claudemd.ts:1-26`
- `claude-code-source-code/src/context.ts:155-188`
- `claude-code-source-code/src/memdir/memdir.ts:34-39`
- `claude-code-source-code/src/memdir/memdir.ts:187-260`
- `claude-code-source-code/src/services/SessionMemory/prompts.ts:8-80`
- `claude-code-source-code/src/services/SessionMemory/sessionMemory.ts:134-181`
- `claude-code-source-code/src/utils/attachments.ts:1710-1861`
- `claude-code-source-code/src/utils/attachments.ts:2245-2424`

## 2. 第一层：规则层先定义协作方式

`claudemd.ts` 开头已经把加载顺序写得很清楚：

1. managed memory
2. user memory
3. project memory
4. local memory

而且目录遍历并不是无限向上爬，而是会受到 git root 与 home 边界控制。

证据：

- `claude-code-source-code/src/utils/claudemd.ts:1-26`
- `claude-code-source-code/src/utils/markdownConfigLoader.ts:174-240`

这说明 `CLAUDE.md` 的本质不是“又一个 prompt 文件”，而是：

- 有优先级
- 有作用域
- 有停止边界

也就是说，它更接近：

- 分层规则系统

而不是：

- 任意拼接的说明文

## 3. 第二层：typed memory 解决跨会话持久化

`memdir.ts` 展示了 Claude Code 对持久记忆的定义方式：

- 记忆有固定 taxonomy
- `MEMORY.md` 是索引，不是正文
- 每条记忆应该单独成文件
- 索引有行数和字节上限

证据：

- `claude-code-source-code/src/memdir/memdir.ts:34-39`
- `claude-code-source-code/src/memdir/memdir.ts:49-102`
- `claude-code-source-code/src/memdir/memdir.ts:199-260`

最关键的思想有两个：

### 3.1 `MEMORY.md` 是入口，不是内容堆场

源码明确要求：

- 正文写进独立 memory file
- `MEMORY.md` 只放一行式索引项

这避免了入口文件不断膨胀，最后反而把整个记忆系统拖垮。

### 3.2 memory 不是 task / plan 的替代物

源码还显式写了：

- 当前任务分解要用 plan 或 tasks
- memory 留给未来会再次有价值的信息

这就是为什么 Claude Code 没把所有持久化都叫 memory。

## 4. 第三层：session memory 解决“这次会话”连续性

`SessionMemory` 模块的目标不是长期记忆，而是：

- 在当前长会话中，持续生成一份结构化 session notes

它的模板包括：

- Current State
- Task specification
- Files and Functions
- Workflow
- Errors & Corrections
- Learnings
- Key results
- Worklog

证据：

- `claude-code-source-code/src/services/SessionMemory/prompts.ts:8-41`
- `claude-code-source-code/src/services/SessionMemory/prompts.ts:43-80`

同时，它的触发也不是每 turn 都做，而是要过两道阈值：

- token 增长阈值
- tool calls 阈值

并优先在“最后 assistant turn 没有 tool calls”这种自然停顿点触发。

证据：

- `claude-code-source-code/src/services/SessionMemory/sessionMemory.ts:134-181`
- `claude-code-source-code/src/services/SessionMemory/sessionMemoryUtils.ts:18-36`
- `claude-code-source-code/src/services/SessionMemory/sessionMemoryUtils.ts:170-196`

所以 session memory 不是通用记忆库，而是：

- 面向当前 session 的压缩连续性装置

## 5. 第四层：nested memory 解决“当前文件现场”的规则投影

当用户打开文件、读取文件、修改文件时，Claude Code 不会把全项目所有规则都重复注入；它会按目标文件路径去计算：

1. managed/user conditional rules
2. CWD 到目标路径之间的 nested directories
3. root 到 CWD 的 cwd-level conditional rules

证据：

- `claude-code-source-code/src/utils/attachments.ts:1710-1774`
- `claude-code-source-code/src/utils/attachments.ts:1778-1861`

这说明 nested memory 的本质是：

- 以文件路径为索引的局部规则注入

而不是：

- 再复制一份全局 prompt

更硬一点说，它更像 `path-conditioned context projection`，而不是一层独立“记忆主权”。

## 6. 第五层：relevant memories 解决“当前问题与过去经验”的相关性匹配

`relevant_memories` 是另一种完全不同的机制：

- 它不是规则层
- 不是 session notes
- 而是基于当前用户输入做相关性预取

更关键的是，它是：

- async prefetch
- 不阻塞主 turn
- 有 session 总字节上限
- 会过滤已经在 `readFileState` 里出现过的内容

证据：

- `claude-code-source-code/src/utils/attachments.ts:2245-2424`
- `claude-code-source-code/src/utils/attachments.ts:2520-2540`

这背后的设计思路很重要：

1. 不是所有记忆都该常驻前缀
2. 只有当前问题相关的记忆才应该被拉进来
3. 拉进来也必须受预算约束

所以这一层与其叫“auto-memory”，不如更稳地叫 `relevance projection`：它解决的是“此刻拉什么进来最划算”，不是“再发一层 canonical memory truth”。

## 7. 为什么这些层不能混成一种“记忆”

如果把这些层混成一个概念，会立刻失真：

1. `CLAUDE.md` 会被误用成工作日志。
2. `MEMORY.md` 会被写成超长正文。
3. session memory 会被拿去保存长期团队知识。
4. relevant memories 会变成“什么都提醒一点”的噪音。

Claude Code 刻意把它们拆开，是因为它解决的是四种不同问题：

- 规则
- 长期记忆
- 会话连续性
- 当前相关性

这四个问题不该被一个文件或一个 prompt 一起承担。

从第一性原理看，这里真正被优化的不是“记得更多”，而是“谁应该常驻、谁应该索引、谁应该压缩、谁只应该按需浮现”。一旦把这四种职责重新混平，token 会先失控，authority 也会跟着变脏。

## 8. 对使用者的直接启发

更符合 Claude Code 设计的做法是：

1. 把协作规则写进 `CLAUDE.md` / `CLAUDE.local.md`。
2. 把跨会话长期信息写进 typed memory，而不是 session notes。
3. 把当前工作分解留给 plan/tasks，而不是记忆层。
4. 接受某些记忆是按需浮现的，而不是永远常驻。

如果这样使用，Claude Code 的“记忆系统”会表现得像一套分层知识栈。  
如果不这样使用，它就会迅速退化成：

- 很长的 prompt
- 很乱的持久化目录
- 很差的相关性

## 9. 苏格拉底式自检：怎样避免把 carrier 写成 witness

如果继续自问，这页最该反复问的只有三句：

1. 这个 surface 被拿走后，系统失去的是“规则 / durable fact / continuity / relevance”中的哪一种，而不是笼统地失去“记忆”。
2. later consumer 只拿到它时，是否还得重开 `world-definition / tool-legality / next-action search`；若还得重开，它就更像 carrier，不像 witness。
3. 这层对象是在签事实，还是只在搬运、压缩、筛选已存在的上下文；若只是后者，就不该被写成 canonical authority stack。

## 10. 一句话总结

Claude Code 的知识能力强，不是因为它“更会记”，而是因为它把规则、durable fact、continuity 与 relevance 拆成了不同类型的 context surface，并拒绝让 carrier / projection 越级冒充 witness。
