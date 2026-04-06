# 如何用苏格拉底诘问法审读one writable present：authority object、freshness gate与ghost capability

这一章不再解释源码先进性为什么成立，而是把 `architecture/84` 与 `philosophy/86` 沉成一套 builder-facing 审读问题序列。

它主要回答五个问题：

1. 怎样避免把源码先进性重新写回目录美学与小文件焦虑。
2. 怎样按固定顺序审读 `authority object / per-host authority width`、`event-stream-vs-state-writeback`、`freshness gate`、`recovery asset non-sovereignty` 与 `ghost capability eviction`。
3. 怎样判断一个 runtime 是否真的保住了 one writable present。
4. 怎样识别那些看起来更整齐、实际更会制造第二真相的坏改写。
5. 怎样用苏格拉底式追问避免把这些问题重新写成结构外观清单。

## 0. 代表性源码锚点

- `claude-code-source-code/src/entrypoints/cli.tsx:16-33`
- `claude-code-source-code/src/query/config.ts:8-45`
- `claude-code-source-code/src/query/deps.ts:8-40`
- `claude-code-source-code/src/utils/QueryGuard.ts:1-121`
- `claude-code-source-code/src/state/onChangeAppState.ts:43-92`
- `claude-code-source-code/src/services/api/sessionIngress.ts:60-211`
- `claude-code-source-code/src/cli/transports/WorkerStateUploader.ts:3-112`
- `claude-code-source-code/src/bridge/bridgePointer.ts:22-184`
- `claude-code-source-code/src/utils/task/framework.ts:158-269`
- `claude-code-source-code/src/tools/FileEditTool/FileEditTool.ts:427-519`
- `claude-code-source-code/src/tools/FileWriteTool/FileWriteTool.ts:250-331`
- `claude-code-source-code/src/tools/PowerShellTool/pathValidation.ts:1515-1614`
- `claude-code-source-code/src/services/remoteManagedSettings/securityCheck.tsx:15-69`
- `claude-code-source-code/src/services/mcp/utils.ts:171-200`
- `../architecture/84-权威面与反僵尸图谱：single-writer surfaces、409 adoption、bridge pointer freshness与release shaping.md`
- `../philosophy/86-真正先进的内核，不是更会分层，而是更会阻止过去写坏现在.md`

这些锚点共同说明：

- 源码先进性真正保护的不是“更好看的结构”，而是现在时态的写入权不被陈旧对象、错误恢复资产和错误边界重新夺走。

## 1. 第一性原理

成熟内核首先处理的不是：

- 目录怎么更优雅

而是：

- 过去怎样不得把自己重新写回现在

所以更高阶的审读顺序，不该从分层截图开始，而应从：

1. 当前谁配写当前真相
2. 恢复资产只能做什么、绝不能做什么
3. stale writer 是否已被正式拒绝
4. compile-time / runtime / artifact 三层边界有没有被混写

开始。

## 2. 苏格拉底诘问链

### 2.1 当前真相有没有单一写入面

判断标准：

- 如果 mode、session head、protocol truth 或 bridge control 仍能被多处并行宣布，那 one writable present 还没成立。

### 2.2 recovery asset 是在帮助恢复，还是已经开始篡位

判断标准：

- 如果 pointer、ledger、resume file 或 cache 也能直接宣布“我就是最新真相”，恢复系统就已经长成第二主权面。

### 2.3 stale finally、stale snapshot、stale pointer 会不会在未来某个时刻写坏现在

判断标准：

- 只要跨 `await`、跨 reconnect、跨 resume 之后旧对象仍可能回写 fresh state，或者 write path 在 freshness check 与落盘之间仍有可漂移窗口，anti-zombie 还没真正成立。

### 2.4 compile-time gate、runtime gate 与 artifact surface 是否已经分层

判断标准：

- 如果发布面边界、运行期开关和编译时裁剪被混成一层，后来者很难判断哪里才是真正的 authority boundary。

### 2.5 later maintainer 进入这里时，能否直接看出危险改动面

判断标准：

- 如果没有清楚的 single-writer surface、危险 seam、恢复资产说明和 anti-zombie 约束，后来者只能靠作者记忆。

### 2.6 host、worktree 或 transport 会不会制造第二真相

判断标准：

- 如果外围层也能偷偷声明状态、改写身份、重放过时头部，或者把 event stream 误当 present truth，结构先进性就已经被外围协议偷走。

### 2.7 新 feature 进来时，是哪个不变量在吸收增长

判断标准：

- 先进结构不会只说“这个功能加上了”，而会明确说明 authority、transition、boundary 或 dependency 是如何继续守住 present state 的。

## 3. 常见自欺

看到下面信号时，应提高警惕：

1. 以为更小文件就等于更成熟结构。
2. 以为 recovery asset 能恢复回来，就顺便可以当第二真相。
3. 以为 anti-zombie 只是并发角落的 race fix。
4. 以为 build / release shaping 只是打包尾巴。
5. 以为 later maintainer 的问题属于团队文化，不属于结构设计。

## 4. 更好的迭代顺序

当这组问题里有任何一个答不清时，优先做下面四步：

1. 先回 `../philosophy/86` 与 `../architecture/84`，判断自己破坏的是 single-writer surface、恢复资产边界、anti-zombie 约束还是 release shaping。
2. 再回 `32`，用旧一层源码先进性审读模板确认是权威面、恢复资产、未来维护者消费者还是 transport shell 先失真。
3. 再检查 `QueryGuard`、`sessionIngress`、`WorkerStateUploader`、`bridgePointer`、`FileEdit / FileWrite` freshness gate、PowerShell validator 与 MCP stale-capability 清理条件。
4. 最后才决定是否重构目录；多数时候，先修写入权与时态保护，比先修分层外观更重要。

## 5. 审读记录卡

```text
审读对象:
single-writer surface:
authoritative_writeback_path:
recovery asset 是否非主权:
anti-zombie invariant 是否成立:
compile/runtime/artifact 三层边界是否分层:
later maintainer 是否能直接识别危险改动面:
event stream / state writeback 是否分层:
event_stream_non_sovereignty:
fresh-read write gate 是否成立:
freshness_gate_location:
stale_worldview_downgrade:
ghost_capability_eviction_trigger:
fail_closed_branch:
当前最像哪类失真:
- multi-writer truth / recovery usurpation / stale overwrite / boundary conflation / release-surface leak
优先回修对象:
- authority surface / recovery asset contract / anti-zombie guard / boundary split / release shaping
```

上面六个新增槽位都应填写具体源码路径；任一槽位只能写“感觉这里有”时，就还不配宣布 `one writable present` 已成立。

## 6. 苏格拉底式检查清单

在你准备继续“整理结构”前，先问自己：

1. 我现在改善的是 present-state protection，还是只是分层截图。
2. 如果系统开始说谎，我能否点名哪条 authority surface 出了问题。
3. 哪些恢复资产被允许找真相，但不被允许宣布真相。
4. 旧对象是不是已经被正式剥夺写回现在的能力。
5. 写入边界是不是要求 fresh-read 才能写，还是旧快照仍能越权落盘。
6. 我现在读到的是时间线，还是当前真相；两者有没有被错误混成一层。
7. later maintainer 能不能不问作者就看出哪里最危险。
8. 如果删掉漂亮目录图，这套结构先进性还剩下什么。

## 7. 一句话总结

要审读源码先进性，就不要只审结构是否更好看；真正该审的是 one writable present 是否成立，也就是现在能不能继续免于被过去写坏。
