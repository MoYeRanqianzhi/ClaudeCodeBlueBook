# 安全执行诚实性与清理隔离分层：为什么retention-enforcement-honesty signer不能越级冒充cleanup-isolation signer

## 1. 为什么在 `156` 之后还必须继续写 `157`

`156-安全保留期治理与执行诚实性分层` 已经回答了：

`retention-governor signer 最多只能定义 policy；retention-enforcement-honesty signer 才配宣布这条 policy 在当前 runtime 中到底执行了没有。`

但如果继续追问，  
还会碰到另一层更尖锐的错觉：

`即使系统现在已经诚实地承认某次 cleanup 确实执行了，这是否已经等于它也能宣布“这次 cleanup 没有误伤同项目里仍在运行的其他对象”？`

Claude Code 当前源码给出的答案仍然是否定的。

因为继续往下看会发现，  
执行诚实性和清理隔离性，  
也不是同一层：

1. `TaskOutput.ts` 明确记录了历史伤痕：另一个同项目 Claude Code 进程的 startup cleanup 曾删除正在运行任务的 output file  
   `src/utils/task/TaskOutput.ts:313-325`
2. `diskOutput.ts` 又说明任务输出层后来通过  
   `project temp dir + sessionId + tasks/`
   这一新布局专门修过这个问题  
   `src/utils/task/diskOutput.ts:33-55`
3. 但 `cleanup.ts` 对持久化 session artifacts 的清理，仍然按  
   `~/.claude/projects/<project>/<session>/...`
   做项目目录级遍历与 mtime 判断  
   `src/utils/cleanup.ts:155-257`
4. `concurrentSessions.ts` 明明维护了 `~/.claude/sessions/<pid>.json` 这套活跃会话账本，`cleanup.ts` 却没有显式接入它来证明“当前待删对象没有 live peer 仍依赖它”  
   `src/utils/concurrentSessions.ts:49-109,163-204`

这说明：

`cleanup executed`

和

`cleanup is isolated from live peers`

仍然不是一回事。

所以 `156` 之后必须继续补的一层就是：

`安全执行诚实性与清理隔离分层`

也就是：

`retention-enforcement-honesty signer 最多只能说“这次 cleanup 确实执行了”；cleanup-isolation signer 才配说“这次 cleanup 不会错误地伤到同项目里仍在运行、仍在读取或仍在写入的其他对象”。`

## 2. 先做一条谨慎声明：`cleanup-isolation signer` 仍是研究命名，不是源码现成类型

和 `147-156` 一样，  
这里也要先讲清楚：

`Claude Code 当前源码里并没有一个字面存在的 signer 类型叫 cleanup-isolation signer。`

这里的 `cleanup-isolation signer` 仍然是研究命名。  
它不是在声称 Anthropic 已经把 cleanup noninterference 做成显式 signer object，  
而是在说：

1. 当前源码已经有 cleanup executor
2. 当前源码已经开始承认 cleanup side effect 可能伤及同项目其他会话
3. 当前源码又已经在 task output 这一层做过隔离修补
4. 所以下一层最自然的主权，就是谁配宣布 “这次 cleanup 对 live peers 是隔离的”

换句话说：

`157` 不是在虚构现有实现，
而是在把源码里已经暴露出来、但仍未被统一制度化的一条 noninterference 主权单独命名出来。

## 3. 最短结论

Claude Code 当前源码至少给出了五类“retention-enforcement-honesty signer 仍不等于 cleanup-isolation signer”证据：

1. `TaskOutput` 的诊断文案直接承认历史上发生过  
   `another Claude Code process in the same project deleted it during startup cleanup`  
   `src/utils/task/TaskOutput.ts:313-325`
2. `diskOutput.ts` 为 task outputs 引入 session-scoped `getTaskOutputDir()`，目的正是避免同项目并发 session 互相 clobber  
   `src/utils/task/diskOutput.ts:33-55`
3. 任务输出所在的 project temp dir 还被权限系统显式设置成  
   `Intentionally allows reading files from all sessions in this project`，说明这是一个有意共享、因此更需要隔离写删规则的空间  
   `src/utils/permissions/filesystem.ts:1688-1700`
4. 持久化 tool results 则仍落在  
   `projectDir/sessionId/tool-results`
   之下，属于 `cleanupOldSessionFiles()` 的项目目录级 sweep 范围  
   `src/utils/toolResultStorage.ts:94-118`  
   `src/utils/cleanup.ts:196-250`
5. `concurrentSessions` 已有 live session registry，但 `cleanup.ts` 的 sweep 路径没有可见的 active-session consultation  
   `src/utils/concurrentSessions.ts:49-109,163-204`  
   `src/utils/cleanup.ts:155-257`

因此这一章的最短结论是：

`retention-enforcement-honesty signer 最多只能说“cleanup 发生了”；它仍然不能越级说“cleanup 已被证明对 live peers 无害”。`

再压成一句：

`执行已发生，不等于隔离已证明。`

## 4. 第一性原理：为什么 execution honesty 仍不等于 cleanup isolation

从第一性原理看：

- execution honesty 回答的是  
  `cleanup 到底有没有执行、有没有被跳过、有没有被推迟`
- cleanup isolation 回答的是  
  `cleanup 执行时，有没有误伤仍活着的 peer、仍可读的 path、仍在写的 fd、仍在引用的 artifact`

所以两者处理的是两种完全不同的问题：

1. event visibility
2. noninterference proof

如果把两者压成同一句绿色话术，  
系统就会制造四类危险幻觉：

1. executed-means-safe illusion  
   只要执行了，就误以为执行是隔离的
2. scheduled-per-session-means-isolated illusion  
   只要路径里带 sessionId，就误以为所有 artifact 都天然隔离
3. cleanup-side-effect-known-means-side-effect-governed illusion  
   只要系统知道出过事，就误以为系统已正式把风险治理掉
4. live-session-registry-exists-means-cleanup-consults-it illusion  
   只要仓库里有 active session 账本，就误以为 cleanup 已接入它

所以从第一性原理看：

`honesty signer` 只陈述发生了什么；  
`isolation signer` 才陈述有没有伤到不该伤的对象。

## 5. `TaskOutput` 先把伤痕留下：cleanup 真可能伤到 live peer

`src/utils/task/TaskOutput.ts:313-325` 这一段极关键。  
这里对 `ENOENT` 的解释不是泛泛的 “file missing”，  
而是直接指出一种历史成因：

`another Claude Code process in the same project deleted it during startup cleanup`

而且前面的注释还解释了后果：

1. 写进程的 fd 还活着
2. 但按 path 读会 `ENOENT`
3. 过去 `getStdout()` 会返回空字符串

这说明源码作者已经明确认识到一件事：

`cleanup` 不只是一个本地 housekeeping 细节，`
它会跨进程、跨对象地改变别的 live consumer 看到的路径真相。

这就足以证明：

`execution honesty`

显然还不等于：

`isolation guarantee`

## 6. `diskOutput.ts` 说明任务输出层已经被提升到 isolation-aware 设计

`src/utils/task/diskOutput.ts:33-55` 又给出另一条非常强的证据：

1. task output dir 现在走 `getProjectTempDir()/sessionId/tasks`
2. 注释明确写出原因：
   concurrent sessions in the same project previously clobbered each other's output files
3. 这条修复专门把 session ID 加进路径

这说明 Claude Code 当前实现里至少已有一个 subsystem 被正式提升成：

`cleanup-isolation-aware`

也就是说，  
源码作者并不是不知道如何解决这个问题。  
他们已经用更强的目录作用域把 task outputs 从 “同项目共享路径” 提升成 “同项目但分 session 隔离路径”。

所以本章真正要问的不是：

`系统能不能做 isolation`

而是：

`这种 isolation 有没有被推广到 cleanup 所覆盖的其他 artifact 家族`

## 7. 共享可读 temp space 反而进一步说明：隔离不能只靠“大家都在同项目里”

`src/utils/permissions/filesystem.ts:1688-1700` 又让问题更尖锐了一层：

1. project temp directory 被权限系统设置为可读
2. 而且注释直写：
   `Intentionally allows reading files from all sessions in this project`

这说明同项目 temp space 在设计上本来就是：

`shared readable surface`

一旦一个 surface 被有意共享，  
它就更不能把 “同项目” 当成天然安全边界。  
因为共享读面与安全删面从来不是同一件事。

换句话说，  
这里的 `sessionId` 目录分层并不是多余；  
恰恰是因为：

`cross-session readability exists`

所以：

`cleanup isolation must be explicit`

## 8. `tool-results` 仍显示出另一种更脆弱的持久化形态

`src/utils/toolResultStorage.ts:94-118` 说明：

1. tool results 存在 `projectDir/sessionId/tool-results`
2. Bash / PowerShell 大输出会把 output file copy/link 到这里  
   `src/tools/BashTool/BashTool.tsx:728-749`  
   `src/tools/PowerShellTool/PowerShellTool.tsx:587-614`

而 `src/utils/cleanup.ts:196-250` 又明确说明：

1. `cleanupOldSessionFiles()` 会进入每个 projectDir 下的 sessionDir
2. 然后继续深入 `tool-results`
3. 依据 mtime 删除内部文件
4. 再尝试删空目录

这就和 `diskOutput.ts` 的修补形成鲜明对照：

- task outputs 已迁到 project temp dir / sessionId / tasks，并显式以避免 cross-session clobber 为目标
- tool-results 仍留在 projects tree 的 session sweep 世界里，当前可见路径没有同等级的 live-session dependency gate

这里我不需要直接宣判 bug。  
更稳妥的判断已经足够强：

`源码已展示出 partial isolation upgrade，但尚未展示 generalized cleanup isolation signer。`

## 9. `concurrentSessions` 的存在反而让缺口更清楚：live-session ledger 并没有进入 cleanup 判定

`src/utils/concurrentSessions.ts:49-109,163-204` 已经维护了一整套 live session registry：

1. `registerSession()` 在 `~/.claude/sessions/<pid>.json` 写 PID file
2. 记录 sessionId、cwd、startedAt 等信息
3. `countConcurrentSessions()` 还能判断哪些 PID 仍活着，并清理 stale files

`src/main.tsx:2526-2542` 还会在 startup 路径里调用它做 concurrent-session detection。

但回到 `src/utils/cleanup.ts:155-257`，  
当前可见的 session sweep 路径里并没有：

- 查 concurrent session registry
- 校验某个 sessionDir 是否仍有 live PID 关联
- 校验某个待删 tool-results / transcript 是否仍被 live peer 引用

这正是本章最重要的结构判断：

`live-session ledger exists, but cleanup isolation does not visibly consult it.`

有账本，  
不等于账本已经进入删除宪法。

## 10. 技术先进性与哲学本质：Claude Code 真正先进的地方是它让“隔离”从事故后诊断升级成局部架构修补

从技术上看，Claude Code 这里最先进的地方不是：

`已经彻底解决同项目 cleanup 误伤`

而是它已经显示出一个成熟系统常见的进化轨迹：

1. 先从事故里留下诊断字符串  
   `TaskOutput`
2. 再在最痛的 artifact 家族上做路径级隔离修补  
   `diskOutput.ts`
3. 然后逼出一个更高阶的问题：  
   这种 isolation 能否从局部补丁升级成统一 cleanup constitution

这背后的哲学本质是：

`真正强的安全设计，不把“会删”当成功，而把“删了也不误伤不该伤的人”当更高阶目标。`

也就是说，  
cleanup 不只是：

`can we delete`

而是：

`can we delete without violating live-peer boundaries`

## 11. 苏格拉底式反思：如果这章还可能写错，最容易错在哪里

### 反思一

既然 `diskOutput.ts` 已经修了 task outputs，我能不能直接说 cleanup isolation 已经解决？

不能。  
它最多证明：

`task output family has an explicit isolation repair`

还不能推出：

`all cleanup-covered artifacts now have equivalent noninterference proof`

### 反思二

既然 `cleanup.ts` 没有显式 consult `concurrentSessions`，能不能直接说它一定会误删 live peer 文件？

也不能。  
更稳妥的判断是：

`在当前可见源码里，没有看到 formal live-session isolation gate。`

这比直接宣判 bug 更严谨。

### 反思三

既然 `tool-results` 本身带 sessionId，为什么还不够？

因为 sessionId 只说明路径分桶，  
不说明 cleanup 执行时有没有确认这个桶当前仍被 live peer 依赖。

### 反思四

`我是不是把 session-scoped path bucketing，偷写成 live-peer noninterference proof 已经成立？`

不能这样写。
路径分桶只能说明对象分布方式，
不能单独证明 cleanup 执行前已经 consult 了 live peer、dependency proof 与 cross-session side effect。

所以这一章最该继续约束自己的，
不是去假装 isolation protocol 已经闭合，
而是始终把：

`artifact placement`
`cleanup preflight`
`live-peer noninterference`

当成三层不同事实。

## 12. 一条硬结论

Claude Code 当前源码真正说明的不是：

`cleanup 执行一旦被诚实宣布，就自动等于 cleanup 已隔离`

而是：

`task-output isolation、project-dir cleanup sweep、live-session ledger 与 cross-session side-effect explanation 仍然是不同层。`

因此：

`retention-enforcement-honesty signer 不能越级冒充 cleanup-isolation signer。`
