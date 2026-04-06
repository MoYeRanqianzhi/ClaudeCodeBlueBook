# debug.ts、diagLogs、cleanup、sessionStorage与fileHistory的强请求不可逆擦除治理边界

## 1. 为什么单开这一篇源码剖面

安全主线推进到 `186` 时，
真正需要被单独钉住的已经不是：

`谁来决定 old echo 何时离开 replay / debug / diagnostics 这些当前 audit surface，`

而是：

`即便它未来已经离开这些 audit surface，谁来决定那些已经写进 debug log、diagnostic logfile、transcript 或 workspace 的 stronger-request trace 什么时候也被 destroy 到不再继续作为证据载体存在。`

如果这个问题只停在主线长文里，
最容易又被压成一句抽象判断：

`stronger-request audit-close governor 不等于 stronger-request irreversible-erasure governor。`

这句话还不够硬。
所以这里单开一篇，只盯住：

- `src/utils/debug.ts`
- `src/utils/diagLogs.ts`
- `src/utils/cleanup.ts`
- `src/utils/sessionStorage.ts`
- `src/utils/fileHistory.ts`

把 stronger-request old echo 的 debug/diag carrier materialization，
generic retention cleanup，
以及 transcript/workspace destructive operator 并排，
逼出一句更硬的结论：

`Claude Code 已经明确展示：退出当前 audit surface 只解决 current observability；只要 old echo 的 trace 已经落进具体 carrier，而 carrier deletion 仍由别的模块和别的主权控制，这条 old echo 就还没有到 stronger-request irreversible-erasure。`

## 2. 最短判断

这组代码最重要的技术事实不是：

`Claude Code 有 debug log、diagnostics log 和一些 delete 操作。`

而是：

`Claude Code 明确把 stronger-request old echo 的 audit visibility 与 carrier destruction 分成两层：前者决定它还会不会继续被 replay/debug/diagnostics 观察，后者才决定已经物化出来的 trace 是否也被 destroy。`

## 3. 关键源码锚点

| 主题 | 关键源码 | 这里回答的问题 |
| --- | --- | --- |
| debug trace producer | `src/cli/structuredIO.ts:390-392`; `src/cli/print.ts:5263-5289` | 为什么 stronger-request duplicate/orphan old echo 会留下 debug trace |
| debug trace materialization | `src/utils/debug.ts:155-176,230-249` | 为什么 trace 一旦发出就会落成 session-scoped debug file carrier |
| diagnostics materialization | `src/utils/diagLogs.ts:27-60`; `src/cli/structuredIO.ts:232-236` | 为什么 diagnostics event 也是一个 logfile carrier，而不只是瞬时观察 |
| generic debug retention cleanup | `src/utils/cleanup.ts:396-428,575-593` | 为什么 debug log 的删除权属于 age-based background cleanup，而不是 request-scoped audit close |
| local transcript destructive rewrite | `src/utils/sessionStorage.ts:914-945,1472-1484` | 为什么 transcript carrier 的 destroy operator 独立存在 |
| workspace destructive rewind | `src/utils/fileHistory.ts:537-582` | 为什么 workspace carrier 的 destroy operator 也独立存在 |

## 4. stronger-request old echo 的 debug trace 先证明：audit event 一旦发出，就会继续落成 `~/.claude/debug/<sessionId>.txt`

`185` 已经证明：

1. duplicate `control_response` 会留下 `Ignoring duplicate ...`
2. orphaned permission path 会留下 `received / skipping / already resolved / enqueuing ...`

但 `186` 需要继续追问：

`这些 trace 只是当前 audit surface 上的瞬时现象，还是已经进一步落成 carrier？`

`src/utils/debug.ts:155-176,230-249` 的答案很硬。

这里 `logForDebugging()` 并不会只把 message 留在内存里，
而是：

1. 通过 `getDebugWriter()` 获取 writer
2. 用 `appendFileSync()` 或 buffered `appendFile()` 把 line 写到 `getDebugLogPath()`
3. 默认路径落在 `~/.claude/debug/<sessionId>.txt`
4. 另行维护 `~/.claude/debug/latest` 指针

这条证据的技术意义非常深。

因为它说明 stronger-request old echo 的 debug trace 一旦被发出，
就不再只是：

`current audit surface上的可见解释`

而会进一步变成：

`a persisted file carrier`

所以 stronger-request audit close 最多只能回答：

`现在还要不要继续往 debug surface 新写 trace`

却不能直接回答：

`已经写进 debug file 的旧 trace 现在是否已经被 destroy`

## 5. `cleanupOldDebugLogs()` 再证明：debug file 的删除权是 generic retention cleanup，不是 stronger-request audit-close 主权

`src/utils/cleanup.ts:396-428,575-593` 把这层写得很清楚。

这里 repo 展示的不是：

`当某条 stronger-request old echo audit-close 时，立刻按 request_id 删除对应 trace`

而是：

1. 扫描 `~/.claude/debug`
2. 只处理 `.txt`
3. 保留 `latest`
4. 按 `cutoffDate` 删除旧文件
5. 由 `cleanupOldMessageFilesInBackground()` 统一调度

这说明 debug carrier 当然有 destructive path。

但这条 destructive path 的制度含义是：

`retention cleanup`

不是：

`stronger-request per-echo erasure verdict`

所以从源码结构本身就能看出：

1. stronger-request audit-close 回答的是 `current audit visibility`
2. debug carrier delete 回答的是 `age-based retention horizon`

两者显然不是一个 signer。

## 6. `diagLogs.ts` 继续证明：diagnostics 也是 carrier，而且 repo 当前公开的是 writer，不是同层 eraser

`src/cli/structuredIO.ts:232-236` 说明：

只要 `processLine()` 返回了 message，
系统就会记录：

`cli_stdin_message_parsed`

但真正让 `186` 成立的，
不是“有这个 event”，
而是：

`src/utils/diagLogs.ts:27-60` 会把它追加写进 `CLAUDE_CODE_DIAGNOSTICS_FILE`。

这里尤其要做一条谨慎但很关键的判断：

diagnostics 禁止 PII，
不等于 diagnostics 不构成 carrier。

只要 event 被写进 logfile，
它就已经从：

`current observability surface`

变成：

`persisted diagnostics carrier`

更重要的是，
当前 repo 内部可见代码里，
我们已经看到：

1. `logForDiagnosticsNoPII()` 的 append writer
2. `getDiagnosticLogFile()` 的 env getter

但在同一条 repo-local 证据链里，
没有看到与 `CLAUDE_CODE_DIAGNOSTICS_FILE` 对称的 stronger-request per-entry eraser。

这不支持我们说：

`diagnostics file 永远不删`

却足以支持我们说：

`repo 当前公开展示的是 diagnostics carrier 的 writer，而不是 stronger-request irreversible erasure 主权。`

## 7. `sessionStorage.ts` 与 `fileHistory.ts` 再证明：destructive operator 当然存在，但它们活在别的 carrier family

这一步非常重要。

因为如果 repo 完全没有 destructive operator，
我们只能保守地说：

`stronger-request erasure signer 还完全看不见。`

但当前 repo 不是这样。

`src/utils/sessionStorage.ts:914-945,1472-1484` 明确展示：

1. transcript tombstone 会 `truncate`
2. slow path 会 `writeFile()` 重写 session file
3. `removeTranscriptMessage()` 是显式 transcript destructive operator

`src/utils/fileHistory.ts:537-582` 又明确展示：

1. `applySnapshot()` 在目标版本不存在文件时会 `unlink(filePath)`
2. 这是显式 workspace destructive operator

这两组代码的真正技术启示不是：

`所以 stronger-request audit-close 已经足够强。`

相反，
它们真正说明的是：

`repo 明明知道怎样 destroy carrier，但把 destroy authority 分配给 transcript、workspace 与 retention cleanup 等不同模块，而不是让 stronger-request audit-close path 自己越级接管。`

因此更硬的结论反而是：

`destructive ability exists, but carrier destruction remains carrier-specific`

## 8. 为什么这一层不等于 `185` 的 audit-close gate

这里必须单独讲清楚，
否则最容易把 `186` 误读成 `185` 的尾注。

`185` 问的是：

`即便 old echo 已经离开 active operational surface，它是否还活在 replay / debug / diagnostics 这些 current audit surface。`

`186` 问的是：

`即便 old echo 将来已经离开这些 current audit surface，那些已经写进 debug/diag/transcript/workspace 的 carrier 是否也已经被 destroy。`

所以：

1. `185` 的典型形态是 replay propagation、debug trace、diagnostics parse
2. `186` 的典型形态是 debug logfile materialization、generic retention delete、transcript truncate、workspace unlink

前者 guarding audit visibility，
后者 guarding carrier destruction。

两者都很重要，
但不是同一个 signer。

## 9. 这篇源码剖面给主线带来的四条技术启示

### 启示一

repo 已经明确展示：

`debug trace emission can happen before debug carrier deletion`

### 启示二

repo 已经明确展示：

`diagnostics non-PII still counts as a persisted carrier once it is appended to a logfile`

### 启示三

repo 已经明确展示：

`generic retention cleanup is stronger than current audit close, but weaker than a request-scoped erasure verdict`

### 启示四

repo 已经明确展示：

`carrier-specific destructive operators exist, so stronger-request erasure cannot be honestly compressed into “it is no longer visible now”`

这四句合起来，
正好说明为什么 cleanup 线未来不能把 stronger-request audit close 直接偷写成 stronger-request irreversible erasure。

## 10. 一条硬结论

这组源码真正说明的不是：

`只要 stronger-request old echo 已经离开 replay/debug/diagnostic 的当前审计面，cleanup 线就已经知道何时把它不可逆擦除。`

而是：

`repo 已经在 debug carrier materialization、diagnostics carrier materialization、generic debug-log retention cleanup、local transcript tombstone 与 workspace rewind delete 上，清楚展示了 stronger-request carrier destruction 的独立存在；因此 artifact-family cleanup stronger-request audit-close-governor signer 仍不能越级冒充 artifact-family cleanup stronger-request irreversible-erasure-governor signer。`

因此：

`cleanup 线真正缺的，不只是“谁来宣布 old echo 现在已离开 current audit surface”，还包括“谁来宣布那些已经落地成 debug/diag/transcript/workspace trace 的 stronger-request carriers 现在也已被 destroy 到不再继续构成证据载体”。`
