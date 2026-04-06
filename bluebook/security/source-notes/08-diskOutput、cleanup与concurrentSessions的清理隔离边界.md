# diskOutput、cleanup 与 concurrentSessions 的清理隔离边界

## 1. 为什么单开这一篇源码剖面

安全主线推进到 `157` 时，  
真正需要被单独拆开的已经不是：

`cleanup 有没有发生，`

而是：

`cleanup 发生时，系统到底有没有证明自己没有误伤同项目里仍在运行的其他对象？`

如果这个问题只停在主线长文里，  
很容易被压成一句抽象的 “cross-session risk”。  
所以这里单开一篇，只盯住：

- `src/utils/task/TaskOutput.ts`
- `src/utils/task/diskOutput.ts`
- `src/utils/toolResultStorage.ts`
- `src/utils/cleanup.ts`
- `src/utils/concurrentSessions.ts`
- `src/utils/permissions/filesystem.ts`

把历史误伤、局部修补、当前 sweep 逻辑与缺失的 live-session gate 拆给源码本身说话。

## 2. 先给最短判断

这组代码最重要的技术事实不是：

`Claude Code 有没有 cleanup。`

而是：

`Claude Code 已经在 task output family 上做过 cleanup-isolation 修补，但当前可见持久化 session/tool-results cleanup 还没有展示出同等级的 live-peer noninterference proof。`

因为它同时做了四件很硬的事：

1. `TaskOutput` 留下历史事故诊断
2. `diskOutput.ts` 用 session-scoped task dir 修补了这个事故
3. `cleanup.ts` 仍按项目目录和 mtime sweep session artifacts
4. `concurrentSessions` 明明已有 live peer ledger，但 cleanup 没有可见接线

这意味着当前系统至少已经把：

`cleanup happened`

和

`cleanup was isolated from live peers`

拆成两层。

## 3. 关键源码锚点

| 主题 | 关键源码 | 这里回答的问题 |
| --- | --- | --- |
| historical side effect | `src/utils/task/TaskOutput.ts:313-325` | cleanup 过去怎样伤到同项目 live peer |
| repaired task-output isolation | `src/utils/task/diskOutput.ts:33-55` | 哪个 artifact family 已被提升成 session-scoped isolation |
| shared temp-space readability | `src/utils/permissions/filesystem.ts:1688-1700` | 为什么即使 temp space 共享可读，删除也仍需更强隔离 |
| persisted tool-results layout | `src/utils/toolResultStorage.ts:94-118` | persisted outputs 现在放在哪个 cleanup world |
| project-dir cleanup sweep | `src/utils/cleanup.ts:155-257` | cleanup 怎样进入所有 sessionDir 并清扫 transcripts/tool-results |
| live-session ledger | `src/utils/concurrentSessions.ts:49-109,163-204` | 系统其实已经有哪些 “谁还活着” 的账本 |

## 4. `TaskOutput` 先把事故明写出来：cleanup side effect 曾经是真的

`src/utils/task/TaskOutput.ts:313-325` 不是模糊猜测，  
而是直接告诉我们：

1. 输出文件在读时可能 `ENOENT`
2. 一个已知历史解释是  
   `another Claude Code process in the same project deleted it during startup cleanup`
3. 以前这种情况下 `getStdout()` 甚至会返回空字符串

这说明 cleanup side effect 在源码作者心里不是理论风险，  
而是已经被实际踩中过的一类 failure mode。

这也意味着后续任何 “cleanup 已经执行” 的说法，  
如果不同时回答 noninterference，  
都天然是不完整的。

## 5. `diskOutput.ts` 说明 task output family 已被专门修补

`src/utils/task/diskOutput.ts:33-55` 说得非常清楚：

1. task output dir 现在走 `getProjectTempDir()/sessionId/tasks`
2. 为什么要带 `sessionId`
3. 因为 startup cleanup 曾经删掉同项目其他 session 的 in-flight output files

这是一条非常重要的设计信号。

它说明源码作者面对 side effect 的回应不是：

`以后少碰这个问题`

而是：

`直接给这类 artifact family 换一套更强的路径作用域`

也就是说，  
task outputs 这一层已经拥有了某种：

`artifact-family-specific cleanup isolation repair`

## 6. 共享可读 temp space 反而证明隔离不能靠“默认善意”

`src/utils/permissions/filesystem.ts:1688-1700` 又把问题推进了一层。

这里 project temp directory 被显式设定为：

`Intentionally allows reading files from all sessions in this project`

这意味着：

1. 同项目跨 session 可读，本来就是设计目标
2. 既然读面是共享的，删面就更不能靠模糊边界

换句话说，  
正因为这个空间本来允许 cross-session reads，  
`diskOutput.ts` 才更需要把路径继续细化到 `sessionId/tasks`。

所以 `sessionId` 目录分桶不是多余复杂度，  
而是共享可读世界里的隔离护栏。

## 7. `tool-results` 仍活在更旧的 cleanup 世界里

`src/utils/toolResultStorage.ts:94-118` 说明：

1. tool results 仍落在 `projectDir/sessionId/tool-results`
2. Bash / PowerShell 大输出会把 output file copy/link 到这里

而 `src/utils/cleanup.ts:196-250` 又说明：

1. `cleanupOldSessionFiles()` 进入每个 projectDir
2. 然后继续进入每个 sessionDir 的 `tool-results`
3. 依据 mtime 删除里面的文件
4. 再尝试删空目录

这和 `diskOutput.ts` 的专门修补形成了清晰对照：

- task outputs：已经显式因历史 side effect 被升级
- persisted tool-results：当前可见实现里仍主要服从项目目录级 mtime sweep

这里我不需要直接说 “tool-results 一定还会误删 live peer”。  
更稳妥的判断已经足够强：

`当前源码没有展示出与 task outputs 对等强度的 visible isolation proof。`

## 8. `concurrentSessions` 让缺口更具体：系统知道谁活着，但 cleanup 没把这份知识用起来

`src/utils/concurrentSessions.ts:49-109,163-204` 已经把 live peer ledger 搭好了：

1. 会写 `~/.claude/sessions/<pid>.json`
2. 记录 sessionId、cwd、startedAt
3. 能判断哪些 PID 仍活着
4. 还能清掉 stale PID files

`src/main.tsx:2526-2542` 也会在 startup 路径里注册并统计 concurrent sessions。

所以当前系统并不是：

`完全不知道别的 live session 存不存在`

问题恰恰在于：

`cleanup.ts` 的项目目录 sweep 没有可见地 consult 这份活跃账本。`

这意味着缺的不是基础设施，  
而是：

`ledger-to-cleanup constitution`

## 9. 这篇源码剖面给主线带来的三条技术启示

### 启示一

清理隔离不是一句抽象的 “别误删”，  
而是要按 artifact family 分别建立路径作用域、依赖证明与 live-peer gate。

### 启示二

一套系统最危险的时候，不是它完全不知道风险，  
而是它已经局部修过一个 family，却让别的 family 继续活在旧治理模型里。

### 启示三

Claude Code 当前实现最值得学习的，不是它已经完全统一 cleanup isolation，  
而是它已经把：

- 历史 side effect
- 局部修补
- 可用账本
- 尚未接线的制度缺口

全都暴露出来，  
因而非常适合继续升级成统一 signer 层。

## 10. 一条硬结论

这组源码真正说明的不是：

`cleanup 既然能执行，也就自然是隔离的`

而是：

`task-output isolation repair、persisted tool-results sweep、live-session ledger 与 cleanup constitution 仍然是不同层。`

因此：

`retention-enforcement-honesty signer 仍不能越级冒充 cleanup-isolation signer。`
