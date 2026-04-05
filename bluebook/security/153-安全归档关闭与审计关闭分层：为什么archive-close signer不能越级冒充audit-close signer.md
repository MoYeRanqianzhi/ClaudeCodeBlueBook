# 安全归档关闭与审计关闭分层：为什么archive-close signer不能越级冒充audit-close signer

## 1. 为什么在 `152` 之后还必须继续写 `153`

`152-安全免责释放与归档关闭分层` 已经回答了：

`liability-release signer 只能决定责任线程是否还要求继续履行；archive-close signer 才配决定对象是否退出活跃操作表面。`

但如果继续追问，  
还会碰到更深的一层关闭错觉：

`如果对象已经 archive close，并且连 environment 都 offline 了，这是否已经等于系统对它完成了 audit close？`

Claude Code 当前源码给出的答案仍然是否定的。

因为在 bridge lifecycle 外，  
它还同时维护着一整套持久化审计材料：

1. transcript JSONL
2. re-appended session metadata
3. file history snapshots
4. attribution snapshots
5. content replacements
6. context-collapse commits / snapshot
7. worktree / PR / agent setting / mode 等会话元信息

而这些材料即使对象已经 archive close，  
仍会继续被：

1. `loadTranscriptFile()`
2. `loadFullLog()`
3. `processResumedConversation()`
4. `loadConversationForResume()`
5. `copyFileHistoryForResume()`

读取、重建、继承与恢复。

这说明在 Claude Code 当前设计里：

`archive close`

和

`audit close`

仍然回答的不是同一个问题。

所以 `152` 之后必须继续补的一层就是：

`安全归档关闭与审计关闭分层`

也就是：

`archive-close signer 最多只能说“对象现在不再占据活跃操作表面”；audit-close signer 才配决定相关 transcript、history、metadata 与恢复证据是否已经正式退出审计世界。`

## 2. 先做一条谨慎声明：`audit-close signer` 仍是研究命名，不是源码现成类型

和 `151/152` 一样，这里也要先讲清楚：

`Claude Code 当前源码里并没有一个字面存在的 signer 类型叫 audit-close signer。`

这里的 `audit-close signer` 仍是本研究为了描述更强 close gate 而引入的分析命名。  
它不是在声称 Anthropic 已经把 audit close 做成显式对象，  
而是在说：

1. 当前源码已经把 `liability release` 与 `archive close` 拆开
2. 当前源码又同时显式保留 transcript、metadata、file history 与 context-collapse 等可恢复审计材料
3. 所以下一层最自然的分析主权，就是谁配宣布“这些审计材料现在也正式关闭，不再服务恢复、回读、重建与追索”

换句话说：

`153` 不是虚构现有实现，  
而是从当前 session persistence / resume 设计里继续抽出一个更强的审计关闭主权。

## 3. 最短结论

Claude Code 当前源码至少展示了四类“archive close 仍不等于 audit close”证据：

1. `archiveSession()` 与 `deregisterEnvironment()` 只治理 server/UI/offline projection，不触碰本地 transcript 与审计材料  
   `src/bridge/bridgeMain.ts:1540-1577`
2. `reAppendSessionMetadata()` 会把 title、tag、agent、mode、worktree、PR 等元信息持续写回 transcript EOF，说明退出时仍在积极保全审计上下文  
   `src/utils/sessionStorage.ts:721-839`
3. `adoptResumedSessionFile()` 与 `processResumedConversation()` 会重新接管已存在 transcript，并恢复 metadata / cost / mode / worktree / context-collapse  
   `src/utils/sessionStorage.ts:1509-1534`  
   `src/utils/sessionRestore.ts:435-503`
4. `loadFullLog()`、`loadConversationForResume()` 与 `copyFileHistoryForResume()` 会继续从 `fullPath`、file history snapshots、content replacements、contextCollapseSnapshot 中重建历史  
   `src/utils/sessionStorage.ts:2300-2352,2955-3050`  
   `src/utils/conversationRecovery.ts:540-590`  
   `src/utils/fileHistory.ts:922-1045`

因此这一章的最短结论是：

`archive-close signer 最多只能说“对象退出了活跃表面”；它仍然不能越级说“相关审计材料已经正式关闭，不再可被恢复、回读、重建或继续引用”。`

再压成一句：

`表面可封，不等于证据可封。`

## 4. 第一性原理：为什么“退出活跃表面”仍不等于“退出审计世界”

从第一性原理看：

- archive close 回答的是  
  `对象现在是否还该留在当前在线/活跃操作表面？`
- audit close 回答的是  
  `与该对象相关的历史、证据、上下文、恢复材料与审计链是否已经正式结束其可读、可追、可重建地位？`

所以两者处理的是两种完全不同的关闭：

1. operational surface closure
2. evidence-world closure

如果把两者压成同一个 green state，  
系统就会制造三类危险幻觉：

1. archived-means-forgotten illusion  
   只要对象从活跃表面消失，就误以为相关证据世界也已经封存
2. offline-means-unrecoverable illusion  
   只要 environment offline，就误以为 transcript / history 不再可恢复
3. closed-surface-means-closed-audit illusion  
   只要前台关闭，就误以为系统不再对后续回读、恢复、追索负责

所以从第一性原理看：

`archive 决定当前表面，audit 决定历史世界；前者不能自然推出后者。`

## 5. `archive+deregister` 只关在线表面，不关本地审计材料

`src/bridge/bridgeMain.ts:1540-1577` 的语义非常清楚：

1. archive all known sessions
2. deregister environment
3. 让 web UI shows bridge as offline
4. 清理 Redis stream

这条路径回答的是：

`这个 bridge / session 还应不应该继续被当成在线运行对象看待？`

但它并没有碰下面这些东西：

1. transcript JSONL
2. file history backups
3. content replacements
4. context-collapse snapshot
5. PR / worktree / mode / agent metadata

因此 archive+deregister 在这里首先只是：

`online surface close`

而不是：

`audit material destruction`

## 6. `reAppendSessionMetadata()` 说明退出时系统仍在主动保全审计线索

`src/utils/sessionStorage.ts:721-839` 其实已经把 audit persistence 的哲学写出来了：

1. session exit 时会重新 append `last-prompt`
2. 会重新 append `custom-title`
3. 会重新 append `tag`
4. 会重新 append `agent-name / color / setting`
5. 会重新 append `mode`
6. 会重新 append `worktree-state`
7. 会重新 append `pr-link`

而且注释写得很明确：

`re-append keeps the entry at EOF`

这说明源码作者担心的不是：

`怎么尽快把旧东西关掉`

而是：

`在 compaction、退出与后续读取之后，关键 audit metadata 还能不能稳定留在可被重建的位置`

所以从审计视角看，  
退出动作之后系统做的不是关闭，  
反而是：

`persist audit-adjacent context`

## 7. `adoptResumedSessionFile()` 说明已归档对象仍可重新进入恢复世界

`src/utils/sessionStorage.ts:1509-1534` 与 `src/utils/sessionRestore.ts:435-503` 一起说明：

1. `adoptResumedSessionFile()` 会重新接管已有 transcript
2. `processResumedConversation()` 默认复用原 session ID
3. 恢复 cost state
4. 恢复 mode / agent setting
5. 恢复 worktree state
6. 恢复 context-collapse commits / snapshot

这意味着 archive close 之后，  
只要 transcript 与相关材料还在，  
系统依然把它们当作：

`可重新进入恢复链的审计基础设施`

而不是：

`仅供旁观的死档案`

这就是为什么：

`archive close`

显然还不等于：

`audit close`

## 8. `loadFullLog()` 与 `loadConversationForResume()` 说明“旧会话仍能被读回”

`src/utils/sessionStorage.ts:2300-2352,2955-3050` 与 `src/utils/conversationRecovery.ts:540-590` 展示了更强的事实：

1. 系统会从 `fullPath` 读取 transcript
2. 会重建 conversation chain
3. 会连同 `customTitle / tag / agentSetting / PR / worktreeState`
   一起恢复
4. 会重建 `fileHistorySnapshots`
5. 会带回 `contentReplacements`
6. 会继续带回 `contextCollapseSnapshot`
7. `loadConversationForResume()` 甚至显式把 `fullPath` 带给 cross-directory resume

这说明 Claude Code 当前的会话世界里：

`archive`

从来不是“历史不可再读”的信号，  
恰恰相反，  
它仍然允许历史被正式读回、重组和继续消费。

因此如果没有更强 gate，  
你最多只能说：

`它退出了活跃表面`

却不能说：

`它退出了审计宇宙`

## 9. `copyFileHistoryForResume()` 说明 backup chain 仍被视作恢复资产，而不是死档案

`src/utils/fileHistory.ts:922-1045` 再次把这条边界写得很硬：

1. resume 时会复制旧 session 的 file history backups
2. 优先 hard link
3. 失败再 copy
4. 成功后重新记录 snapshot

这意味着 file history backups 的地位不是：

`archive close 之后顺手留下的废墟`

而是：

`下一次 resume / restore 仍会继续引用的审计与恢复资产`

所以只要这条 backup chain 仍被主动迁移、记录和复用，  
系统就根本没有给出 audit close。

## 10. 技术先进性：Claude Code 先进在把“关闭在线对象”与“保留可审计历史”同时做到

从技术角度看，  
这套设计真正先进的地方不在于“它会 archive”，  
而在于它同时做对了两件经常被别的系统混掉的事：

1. 让对象退出当前活跃表面
2. 让 audit material 继续留在可恢复、可重建、可追索的世界

很多系统只能二选一：

1. 要么不 archive，导致活跃表面被 stale object 污染
2. 要么一 archive 就把历史世界一起做薄，导致后续恢复、解释与审计能力被提前掏空

Claude Code 这组源码反而说明：

`surface hygiene`

和

`evidence retention`

是可以同时成立的，  
前提是你必须显式接受两层 close grammar：

1. archive close
2. audit close

## 11. 对下一代安全控制面的技术启示

如果沿着 Claude Code 当前 session persistence 往前推，  
下一代 close grammar 至少还要继续结构化成：

1. `archive_close_allowed`
   对象可以退出活跃表面
2. `audit_material_retained`
   transcript / history / metadata 仍继续保留
3. `resume_reconstructable`
   历史仍可被恢复世界重建
4. `audit_close_granted`
   更强 gate 才能宣布审计关闭

必要时还应补：

5. `evidence_retention_reason`
   为什么它仍被保留：resume、history、compliance、replay、diff reconstruction
6. `audit_scope`
   transcript、file history、content replacement、context collapse、metadata 应分别建模

否则系统很容易再次退回：

`一个 archive 吃掉 online close、history retention 与 audit close`

这会让控制面重新滑回伪关闭。

## 12. 用苏格拉底诘问法再追问一次

### 问：如果对象已经 archive 了，为什么还不算 audit close？

答：因为源码仍然在用 transcript、metadata、file history、content replacements 与 context-collapse 继续支撑 resume / load / reconstruct。只要这些材料还在被正式消费，audit 世界就没关。

### 问：那 archive 到底有什么价值？

答：它治理 active surface hygiene，很重要；但它治理的是“前台不再活着”，不是“历史不再可读”。

### 问：为什么 `reAppendSessionMetadata()` 这么关键？

答：因为它说明退出时系统优先做的仍是保全审计上下文，而不是尽快把上下文薄化。

### 问：`copyFileHistoryForResume()` 为什么能说明 audit close 还没发生？

答：因为系统只有把某物仍视作恢复资产时，才会主动迁移并重新记录它；这和“已经正式封存关闭”是相反方向。

### 问：这章之后最值得继续追问什么？

答：不是在正文里继续布置未来目录，而是记到隔离记忆层里：如果 archive close 仍不等于 audit close，那么再下一层就应回答“audit close 是否仍不等于 irreversible erasure / evidence destruction”。

## 13. 一条硬结论

Claude Code 当前源码再次展示出一条更深的安全哲学：

`退出在线表面，不等于退出历史世界。`

因此沿着当前源码设计思路往前推，  
真正成熟的关闭体系至少还要继续分离：

1. liability release
2. archive close
3. audit close
4. irreversible erasure

所以：

`archive-close signer 不能越级冒充 audit-close signer。`
