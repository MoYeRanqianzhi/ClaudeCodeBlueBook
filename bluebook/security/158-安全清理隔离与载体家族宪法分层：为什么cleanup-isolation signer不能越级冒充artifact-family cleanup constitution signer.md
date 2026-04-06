# 安全清理隔离与载体家族宪法分层：为什么cleanup-isolation signer不能越级冒充artifact-family cleanup constitution signer

## 1. 为什么在 `157` 之后还必须继续写 `158`

`157-安全执行诚实性与清理隔离分层` 已经回答了：

`retention-enforcement-honesty signer 最多只能说 cleanup 发生了；cleanup-isolation signer 才配说这次 cleanup 没有误伤 live peers。`

但如果继续追问，  
还会碰到下一层更结构化的错觉：

`既然系统已经开始关心 cleanup isolation，这是否就等于所有 artifact family 都受同一套 cleanup constitution 保护？`

Claude Code 当前源码给出的答案仍然是否定的。

因为继续往下看会发现，  
不同 artifact family 当前明显活在不同的 cleanup constitution 里：

1. task outputs  
   走 `project temp dir / sessionId / tasks` 的 session-scoped temp constitution  
   `src/utils/task/diskOutput.ts:33-55`
2. scratchpad  
   也走 `project temp dir / sessionId / scratchpad` 的 session-scoped temp constitution  
   `src/utils/permissions/filesystem.ts:381-406`
3. persisted tool-results / session transcripts  
   走 `~/.claude/projects/<project>/<session>/...` 的 project-session sweep constitution  
   `src/utils/toolResultStorage.ts:94-118`  
   `src/utils/sessionStorage.ts:198-215`  
   `src/utils/cleanup.ts:155-257`
4. plans / file-history backups / session-env dirs  
   进一步走 `~/.claude/plans`、`~/.claude/file-history`、`~/.claude/session-env` 这类 home-root retention constitution  
   `src/utils/plans.ts:79-110`  
   `src/utils/cleanup.ts:300-387`

这说明：

`cleanup isolation exists somewhere`

和

`the repo has one unified artifact-family cleanup constitution`

仍然不是一回事。

所以 `157` 之后必须继续补的一层就是：

`安全清理隔离与载体家族宪法分层`

也就是：

`cleanup-isolation signer 最多只能说“某个 cleanup family 当前看起来相对隔离”；artifact-family cleanup constitution signer 才配回答“为什么 task outputs、tool-results、transcripts、plans、file-history、session-env 分别服从不同 preflight gate，以及这些差异是否是刻意设计而不是历史堆积。”`

## 2. 先做一条谨慎声明：`artifact-family cleanup constitution signer` 仍是研究命名，不是源码现成类型

和 `147-157` 一样，  
这里也要先讲清楚：

`Claude Code 当前源码里并没有一个字面存在的 signer 类型叫 artifact-family cleanup constitution signer。`

这里的 `artifact-family cleanup constitution signer` 仍然是研究命名。  
它不是在声称 Anthropic 已经把 cleanup family policy 做成显式对象，  
而是在说：

1. 当前源码已经显露出不同 artifact family 的路径作用域与 cleanup path 并不一致
2. 这些差异有的显然是刻意修补，有的则仍未见统一宪法
3. 所以下一层最自然的主权，就是谁配解释 “为什么不同载体家族可以拥有不同删除前提”

换句话说：

`158` 不是在虚构现有实现，
而是在给当前多种 cleanup constitution 并存的事实命名。

## 3. 最短结论

Claude Code 当前源码至少给出了五类“cleanup-isolation signer 仍不等于 artifact-family cleanup constitution signer”证据：

1. task outputs 已被提升到 session-scoped temp constitution  
   `src/utils/task/diskOutput.ts:33-55`
2. scratchpad 也服从当前 session 的 temp-dir constitution，并且读写权限都被限定在当前 session path  
   `src/utils/permissions/filesystem.ts:381-423,1499-1506,1676-1684`
3. tool-results 与 transcripts 仍主要服从 project-session sweep constitution  
   `src/utils/toolResultStorage.ts:94-118`  
   `src/utils/sessionStorage.ts:198-215`  
   `src/utils/cleanup.ts:155-257`
4. plans 不在 project/session tree 内，默认走 `~/.claude/plans`，只由单独的 `cleanupOldPlanFiles()` 做扩展名级 cleanup  
   `src/utils/plans.ts:79-110`  
   `src/utils/cleanup.ts:300-303`
5. file-history backups 与 session-env dirs 又是另一套 home-root per-session-dir retention constitution  
   `src/utils/fileHistory.ts:951-957`  
   `src/utils/cleanup.ts:305-387`

因此这一章的最短结论是：

`cleanup-isolation signer 最多只能对局部 family 说“这里相对安全”；它仍然不能越级说“全仓库不同载体家族已经服从同一套 cleanup constitution”。`

再压成一句：

`局部隔离，不等于全局同宪。`

## 4. 第一性原理：为什么 cleanup isolation 仍不等于 artifact-family constitution

从第一性原理看：

- cleanup isolation 回答的是  
  `这次删动作有没有明显干扰 live peer`
- artifact-family constitution 回答的是  
  `不同载体为什么拥有不同路径作用域、可读边界、可删边界与 preflight gate`

所以两者处理的是两种完全不同的问题：

1. local noninterference
2. constitutional pluralism

如果把两者压成同一句绿色话术，  
系统就会制造四类危险幻觉：

1. one-fix-means-one-law illusion  
   只要 task outputs 修好了，就误以为全体 artifact family 都共享同一 law
2. same-session-path-means-same-governance illusion  
   只要路径里看见 sessionId，就误以为其 cleanup gate 必然相同
3. readable-internal-path-means-delete-constitution-known illusion  
   只要权限系统允许读，就误以为删前提也已经被同样清楚地定义
4. home-root-storage-means-safe-default illusion  
   只要某些东西落在 `~/.claude/*` 下，就误以为它们天然有更成熟的 cleanup constitution

所以从第一性原理看：

`isolation signer` 只判断局部干扰；  
`constitution signer` 才解释为什么不同载体家族可以有不同删除宪法。

## 5. task outputs 与 scratchpad 说明 session-scoped temp constitution 已经存在

`src/utils/task/diskOutput.ts:33-55` 已经把 task outputs 提升到：

`getProjectTempDir()/sessionId/tasks`

`src/utils/permissions/filesystem.ts:381-406` 则把 scratchpad 定义成：

`getProjectTempDir()/sessionId/scratchpad`

而且 `isScratchpadPath()` 明确只承认当前 session 的 scratchpad path；  
读权限与写权限也分别在：

- `1499-1506`
- `1676-1684`

里被固定到当前 session。

这说明至少有两类 artifact family 已经共享同一种宪法：

`session-scoped temp-dir constitution`

其特点是：

1. project temp dir
2. sessionId 下沉到路径
3. internal read/write permission 都围绕当前 session path 建模

这是一种相对强的、显式的 cleanup constitution。

## 6. tool-results 与 transcripts 说明另一种 constitution：project-session sweep

`src/utils/toolResultStorage.ts:94-118` 说明 tool-results 落在：

`projectDir/sessionId/tool-results`

`src/utils/sessionStorage.ts:198-215` 则说明 transcript 落在：

- `projectDir/<sessionId>.jsonl`
- 或经 `getTranscriptPathForSession(sessionId)` 指向同一 projects tree

而 `src/utils/cleanup.ts:155-257` 会：

1. 遍历 `~/.claude/projects/<project>`
2. 清理顶层 `.jsonl/.cast`
3. 再下钻每个 `sessionDir`
4. 再清 `tool-results`

这说明 tool-results/transcripts 当前共享的是另一套宪法：

`project-session sweep constitution`

其特点不是 temp-dir session scoping，  
而是：

1. 以 `projects/<project>` 为 sweep 根
2. 以 mtime 为主要删除门槛
3. 当前可见实现里没有与 task outputs 对等强度的 live-peer preflight

这与上面的 temp-dir constitution 已经明显不同。

## 7. plans 展示出第三种 constitution：global home-root single-directory cleanup

`src/utils/plans.ts:79-110` 说明：

1. plans 默认落在 `~/.claude/plans`
2. 也可通过 `plansDirectory` 定到 project root 内
3. 但默认并不是 project/session tree

`src/utils/cleanup.ts:300-303` 又说明：

1. `cleanupOldPlanFiles()` 只是对 `~/.claude/plans` 跑 `cleanupSingleDirectory('.md')`
2. 它不 consult project/session tree

这说明 plans family 的 constitution 既不是：

- session-scoped temp constitution

也不是：

- project-session sweep constitution

而是更接近：

`global home-root markdown cleanup constitution`

而且 `permissions/filesystem.ts:1644-1653` 还只为当前 session 的 plan files 提供明确 read rule。  
这进一步说明 plans 的读取、存放与清理也是单独成章的一套家法。

## 8. file-history 与 session-env 再展示第四种 constitution：home-root per-session-dir retention

`src/utils/fileHistory.ts:951-957` 说明 file-history backups 存在：

`~/.claude/file-history/<sessionId>/`

`src/utils/cleanup.ts:305-347` 对它做的是：

1. 扫 `file-history` 根目录
2. 按 session dir 的 mtime 递归 `rm`

`src/utils/cleanup.ts:350-387` 对 `session-env` 目录也是类似模式：

`~/.claude/session-env/<session>/`

所以这里又出现第四种 constitution：

`home-root per-session-dir retention constitution`

它和 plans 的 global single-dir cleanup 不同，  
也和 project-session sweep 不同。

这进一步证明：

`Claude Code 当前 cleanup world is constitutionally plural, not monolithic.`

## 9. 技术先进性与哲学本质：Claude Code 真正先进的不是“宪法统一”，而是允许不同载体长出不同宪法

从技术上看，Claude Code 当前实现最先进的地方，并不是它已经把所有 cleanup family 统一成一条完美法律。  
相反，它真正先进的地方是：

1. 它允许 task outputs 因历史 side effect 被单独提升
2. 允许 scratchpad 因当前-session write boundary 拥有单独规则
3. 允许 tool-results/transcripts 继续留在 projects tree 的另一条制度线上
4. 允许 plans、file-history、session-env 再各自使用 home-root retention constitution

这背后的哲学本质是：

`真正成熟的安全系统，不追求表面上的“一刀切一致”，而追求“每个载体家族用最匹配它风险和用途的宪法”。`

所以 `158` 不是在批评 “为什么不统一”，  
而是在把：

`why these constitutions differ`

本身升级成一个值得被正式签字的问题。

## 10. 苏格拉底式反思：如果这章还可能写错，最容易错在哪里

### 反思一

既然不同 artifact family 的清理规则不同，我能不能直接说系统设计混乱？

不能。  
差异本身不等于混乱。  
真正的问题是：

`这些差异是否被清楚建模、清楚签字、清楚解释。`

### 反思二

既然 task outputs 和 scratchpad 都是 session-scoped temp-dir，我能不能直接把其他 family 都要求迁过去？

也不能。  
tool-results、transcripts、plans、file-history 各自的读取者、寿命与恢复职责都不同。  
宪法不必相同，  
但必须被解释。

### 反思三

既然我没有找到统一 constitution，能不能直接说 repo 缺少设计？

更稳妥的说法是：

`当前可见源码展示出多种 constitution 并存，但尚未看到一个统一的 artifact-family cleanup constitution signer 来显式解释这些差异。`

### 反思四

`我是不是把多种 family 差异都看见了，就误写成 repo 已经有统一 constitution signer？`

不能这样写。
更稳妥的说法仍然是：

`当前可见源码展示出多种 constitution 并存，`

但这不自动等于：

`系统已经有一个显式、统一、自我复述的 artifact-family cleanup constitution plane。`

所以本章能成立的是多宪法并存本身，
不能偷加的 stronger claim，则是“统一宪法已经存在，只是我还没找到对象名”。

## 11. 一条硬结论

Claude Code 当前源码真正说明的不是：

`cleanup isolation 一旦成立，就意味着所有载体家族共享同一套删除宪法`

而是：

`task outputs、scratchpad、tool-results、transcripts、plans、file-history 与 session-env 当前处在多种 cleanup constitution 并存的世界里。`

因此：

`cleanup-isolation signer 不能越级冒充 artifact-family cleanup constitution signer。`
