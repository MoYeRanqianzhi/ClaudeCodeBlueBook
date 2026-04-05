# sessionStorage、sessionRestore 与 fileHistory 的审计关闭边界

## 1. 为什么单开这一篇源码剖面

安全主线推进到 `153` 时，  
真正需要被单独拆开的已经不是：

`谁能把对象从活跃表面移走，`

而是：

`对象退出 active surface 之后，哪些 transcript / metadata / history / snapshot 仍继续存在于 audit world？`

如果这个问题只停在主线长文里，  
很容易被说成抽象的“证据保留”。  
所以这里单开一篇，只盯住：

- `src/utils/sessionStorage.ts`
- `src/utils/sessionRestore.ts`
- `src/utils/conversationRecovery.ts`
- `src/utils/fileHistory.ts`

把 transcript、metadata、file history、content replacement 与 context-collapse 这些审计材料到底怎样被保留下来、重建出来、重新接回运行时，拆给源码本身说话。

## 2. 先给最短判断

这组代码最重要的技术事实不是：

`Claude Code 可以 resume old session。`

而是：

`Claude Code 明确拒绝把“对象退出活跃表面”压成“相关审计材料也一起关闭”。`

因为它做了五件很硬的事：

1. session exit 时会 re-append metadata 到 transcript EOF
2. resume 会 adopt 已存在 transcript file，而不是重开空白历史
3. `loadFullLog()` 会从 `fullPath` 重建 transcript、metadata 与 snapshots
4. `copyFileHistoryForResume()` 会把旧 session backup chain 迁移到新 session
5. context-collapse commits / snapshot 会被 restore 回运行时

这意味着它治理的不是单一 archive 动作，  
而是一套：

`evidence-retaining session audit world`

## 3. 关键源码锚点

| 主题 | 关键源码 | 这里回答的问题 |
| --- | --- | --- |
| metadata re-append | `src/utils/sessionStorage.ts:721-839` | 为什么退出时还要继续保全审计上下文 |
| adopt resumed transcript | `src/utils/sessionStorage.ts:1509-1534` | 为什么 resume 不是重新开一份空白文件 |
| transcript → log reconstruction | `src/utils/sessionStorage.ts:2300-2352` | 为什么 transcript 仍被正式读回成完整 LogOption |
| full log enrichment | `src/utils/sessionStorage.ts:2955-3050` | 为什么 archive close 后 metadata / snapshots 仍继续存活 |
| same-session restore | `src/utils/sessionRestore.ts:435-503` | 为什么 resume 会恢复 cost/mode/worktree/context-collapse |
| resume load handoff | `src/utils/conversationRecovery.ts:540-590` | 为什么 cross-directory resume 仍携带 fullPath 与审计材料 |
| file history migration | `src/utils/fileHistory.ts:922-1045` | 为什么 backup chain 仍被当作正式恢复资产 |

## 4. `reAppendSessionMetadata()` 说明退出并不等于“证据冻结”

`src/utils/sessionStorage.ts:721-839` 明确做了这样几件事：

1. 从 transcript tail 刷新 title/tag cache
2. 重新 append `last-prompt`
3. 重新 append `custom-title`
4. 重新 append `tag`
5. 重新 append agent 信息、mode、worktree、PR link

这说明系统面对 session exit 时的默认立场不是：

`结束了，别再写了`

而是：

`让后续 audit / resume / compaction 仍能在 EOF 附近读到关键上下文`

所以从源码作者的心智模型看：

`退出动作之后，evidence world 仍要继续被主动维护。`

## 5. `adoptResumedSessionFile()` 说明 resume 默认接回旧证据世界

`src/utils/sessionStorage.ts:1509-1534` 非常关键：

1. switchSession 后不等第一次消息再 materialize
2. 直接把 `sessionFile` 指到 resumed transcript
3. 立刻 `reAppendSessionMetadata(true)`

这说明 resume 的本质不是：

`开一份新会话，然后“参考一下”旧历史`

而是：

`直接接管那份仍然活着的 transcript 审计世界`

所以只要这一步存在，  
archive close 就不可能等于 audit close。

## 6. `loadFullLog()` 说明 transcript 仍被当作正式可重建对象

`src/utils/sessionStorage.ts:2955-3050` 展示得更彻底：

1. 通过 `fullPath` 读取 session file
2. `loadTranscriptFile()` 读出 messages、customTitles、agentSettings、PR links、fileHistorySnapshots、contentReplacements、contextCollapseSnapshot
3. 再把它们重新组装成 enriched `LogOption`

这表明 transcript 不只是：

`归档后偶尔看看`

而是：

`正式的、可被程序继续重建成完整会话对象的审计材料`

从审计角度说，  
只要一个系统还在这样重建旧会话，  
它就还没有给出 audit close。

## 7. `processResumedConversation()` 让运行时重新消费这些审计材料

`src/utils/sessionRestore.ts:435-503` 又把这条边界从“可读取”推进到“可消费”：

1. 恢复原 session ID
2. 恢复 recording / cost state
3. 恢复 session metadata
4. 采用 resumed transcript file
5. restore context-collapse commits / snapshot

也就是说，  
audit material 不只是静态留档，  
还会被重新灌回 live runtime。

这证明这些材料的地位不是死档案，  
而是：

`可再进入运行时的证据基础设施`

## 8. `loadConversationForResume()` 说明 cross-directory resume 也继续承认旧证据世界

`src/utils/conversationRecovery.ts:540-590` 的价值在于：

1. 它会继续带回 `fileHistorySnapshots`
2. 带回 `attributionSnapshots`
3. 带回 `contentReplacements`
4. 带回 `contextCollapseSnapshot`
5. 带回 `fullPath`

这说明 even after archive / path switch / cross-directory resume，  
系统仍在正式承认：

`旧证据世界与新恢复动作之间存在合法连续性。`

换句话说：

`audit world` 并没有因为表面关闭而被撤销。

## 9. `copyFileHistoryForResume()` 直接把 backup chain 当成继续履责的资产

`src/utils/fileHistory.ts:922-1045` 几乎把话说死了：

1. 若 previous session id 不等于 current session id
2. 就迁移所有 backup files
3. 优先 hard link，失败则 copy
4. 成功后重新 record snapshot

这说明 file history backups 的制度地位绝不是：

`历史附件`

而是：

`下一次 resume 仍要继承的恢复与审计资产`

只要系统还在主动迁移、重记它们，  
archive close 就显然没有走到 audit close。

## 10. 这篇源码剖面给主线带来的三条技术启示

### 启示一

Claude Code 的 close grammar 至少已经暗含三层对象：

- active surface
- evidence world
- irreversible destruction

### 启示二

真正强的 resume 系统，不是“还能接着聊”，  
而是 transcript、metadata、history、collapse snapshot 都仍然可被正式重建。

### 启示三

如果一个系统在退出时优先做 re-append、在恢复时优先做 adopt、在换 session 时优先做 copy-history，  
那它本质上就是在说：

`证据世界仍活着。`

## 11. 一条硬结论

这组源码真正先进的地方不是“记录很多”，  
而是它在最关键的地方坚持了一条很难得的边界：

`对象退出活跃表面，不等于它的审计材料退出历史世界。`
