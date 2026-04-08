# addToolResult、print 与 CCRClient 的强请求清理终局治理边界

## 1. 为什么单开这一篇源码剖面

安全主线推进到 `309` 时，
真正需要被单独钉住的已经不是：

`stronger-request cleanup 线未来谁来决定 continued stronger cleanup request 当前是否已经完成，`

而是：

`stronger-request cleanup 线如果未来已经宣布 continued stronger cleanup request 当前完成，谁来决定这份完成以后回来时是否仍然成立。`

如果这个问题只停在主线长文里，
最容易又被压成一句抽象判断：

`completion governor 不等于 finality governor。`

这句话还不够硬。
所以这里单开一篇，
只盯住：

- `src/services/tools/toolExecution.ts`
- `src/cli/print.ts`
- `src/entrypoints/sdk/coreSchemas.ts`
- `src/utils/sdkEventQueue.ts`
- `src/cli/transports/ccrClient.ts`

把 current `tool_result` completion、bridge result forwarding、`files_persisted`、`idle`、`flush()` disclaimer 与 `state_restored` 并排，
逼出一句更硬的结论：

`Claude Code 已经在 continued stronger-cleanup world 里明确展示：当前完成只说明结果进入当前消息流并可能被当前 reader 收到；更强终局要等到 effect persistence、authoritative turn-over、delivery-illusion refusal 与 future-readable restoration 之后才成立。`

## 2. 最短判断

这组代码最重要的技术事实不是：

`Claude Code 会在完成之后再发一些 system event。`

而是：

`Claude Code 明确拒绝把 continued stronger-cleanup 的 current completion、reader-local delivery、effect persistence、turn-over、delivery drain 与 future-readable restoration 压成同一个 completed。`

## 3. 关键源码锚点

| 主题 | 关键源码 | 这里回答的问题 |
| --- | --- | --- |
| current message completion | `src/services/tools/toolExecution.ts:1403-1475` | 为什么 `addToolResult` 只把 continued stronger-cleanup result 放进当前消息流 |
| bridge-visible current result | `src/cli/print.ts:2252-2254` | 为什么 result 可以先被当前 reader 收到，却仍不等于 finality |
| effect persistence emit | `src/cli/print.ts:2256-2272` | 为什么 effect persistence 要单独建成 `files_persisted` |
| idle choreography | `src/cli/print.ts:2455-2468` | 为什么 going idle 前要先 flush internal events |
| finality schemas | `src/entrypoints/sdk/coreSchemas.ts:1672-1690,1739-1746` | 为什么 `files_persisted` 与 `idle` 是不同强度的 system signals |
| authoritative turn-over queue semantics | `src/utils/sdkEventQueue.ts:60-90` | 为什么 `idle` 只签 authoritative turn-over，而不是更强世界终局 |
| transport drain disclaimer | `src/cli/transports/ccrClient.ts:826-838` | 为什么 `flush` 只配签 delivery confirmation |
| future-readable readback | `src/cli/transports/ccrClient.ts:514-523` | 为什么更强终局来自未来还能把状态读回来 |

## 4. `addToolResult()` 先证明：continued stronger cleanup request 的 completion 首先只是 current message truth

`toolExecution.ts:1403-1475`
很值钱。

`addToolResult()` 的职责非常干净：

1. 映射 `toolResultBlock`
2. 组装 `contentBlocks`
3. 调 `createUserMessage(...)`
4. push 进 `resultingMessages`

这条路径说明：

当前 completion 的第一层含义只是：

`当前消息流里已经出现 continued stronger-cleanup 的 result`

但这里并没有回答：

1. transcript 是否已经持久化
2. effect 是否已经落地
3. 这轮 turn 是否已 authoritative 地 over
4. 以后回来时是否还能读回

所以 `addToolResult()` 的 ceiling 很明确：

`current message completion`

不是

`future-readable finality`

## 5. `sendResult()` 再证明：连“当前 reader 已经看见结果”都不是终局

`print.ts:2252-2254`
很值钱。

在 turn 尾部，
系统会先：

1. `forwardMessagesToBridge()`
2. `bridgeHandle?.sendResult()`

然后才继续处理后面的 file persistence path。

这条顺序非常关键。

因为它说明：

1. 某个当前 reader 已经拿到结果
2. 并不等于 effect persistence 已成立
3. 更不等于 authoritative turn-over 与 future-readable readback 已成立

换句话说，
repo 连：

`reader-local delivery`

和

`world-level finality`

都继续拆开。

这正是它在安全设计上真正成熟的地方。

## 6. `files_persisted` 与 `idle` 再证明：print 会在 current completion 之后继续追问更强的 persistence / turn-over truth

`print.ts:2256-2272`
很硬。

当 turn 结束后，
系统不会把 effect persistence 偷写进 generic completion，
而是单独：

1. 跑 `executeFilePersistence(...)`
2. enqueue 一个 `system/files_persisted`

配合
`coreSchemas.ts:1672-1690`
可以看得更清楚：

`files_persisted`

单独携带：

1. `files`
2. `failed`
3. `processed_at`

这说明 effect persistence 是一条值得单独签字的真相。

`print.ts:2455-2468`
更值钱。

系统在 finally 中不是先说 idle，
而是先：

`await structuredIO.flushInternalEvents()`

再：

`notifySessionStateChanged('idle')`

而
`coreSchemas.ts:1739-1746`
与
`sdkEventQueue.ts:60-90`
又把：

`session_state_changed(idle)`

明确描述成：

`heldBackResult flushes and the bg-agent do-while exits` 之后的
`authoritative turn-over signal`

这条顺序直接说明：

continued stronger-cleanup 的 current completion

仍然在

`turn-over finality`

之前。

## 7. `flush()` 与 `state_restored` 再证明：future-readable finality 比 current completion、reader delivery 与 delivery drain 都更强

`ccrClient.ts:826-838`
的注释几乎就是一条反伪终局宪法。

它明确说：

1. `flush()` 用于 caller 需要 delivery confirmation 时
2. 它不负责替 individual POST success / server state finality 签字
3. 若真关心 server truth，必须 separately check server state

这条证据非常硬。

因为它把一个常见幻觉直接打碎了：

`delivered == final`

源码作者显然不接受这个等号。

`ccrClient.ts:514-523`
的 `state_restored`
更值钱。

它把更强证据放在：

1. PUT 成功之后
2. 再 await concurrent GET
3. 只有读回完成后才记录 `cli_worker_state_restored`

这说明 repo 对更强终局的哲学不是：

`我现在说自己已经写好了`

而是：

`以后回来时真的还能把它读回来`

因此，
future-readable restoration 在这条链上的地位不是一般日志，
而是：

`post-completion finality evidence`

## 8. 为什么这层不等于 `159` 的 current completion gate

这里必须单独讲清楚，
否则容易把 `160` 误读成 `159` 的尾注。

`159` 问的是：

`continued stronger cleanup request 当前是否已经完成。`

`160` 问的是：

`这份当前完成以后回来时是否仍然成立。`

所以：

1. `159` 的典型形态是 `tool_result`、`completed progress`、`completed successfully`
2. `160` 的典型形态是 `sendResult()`、`files_persisted`、`idle`、`flush()` disclaimer、`state_restored`

前者 guarding current request completion，
后者 guarding future-readable finality。

两者都很重要，
但不是同一个 signer。

## 9. 从技术先进性看：Claude Code 不只把“做完了”做成结果语法，还把“以后回来仍真”做成世界语法

从技术角度看，
Claude Code 在这里最先进的地方，
不是它“在完成后再发一些 system event”，
而是它明确拒绝把：

`current completion`

偷写成：

`future-readable settled truth`

这套设计至少体现了六个成熟点：

1. `reader-local delivery is not world finality`
2. `effect persistence is separately receipted`
3. `turn-over is explicitly staged after internal-event flush`
4. `authoritative idle is stronger than completed progress`
5. `transport drain is explicitly demoted below server truth`
6. `future readback outranks present-tense self-report`

它的哲学本质是：

`安全不只问“这次有没有做完”，还问“以后回来时这份做完能不能继续被当真”。`

## 10. 苏格拉底式自我反思：如果我把这一篇写得更强，我会在哪些地方越级

可以先问六个问题：

1. 如果 `tool_result` 已经等于终局，为什么 `print.ts` 还要单独发 `files_persisted`？
2. 如果当前 reader 已经收到结果就等于世界已经 final，为什么 persistence receipt 还要在后面单独出现？
3. 如果 current completion 已经等于 authoritative turn-over，为什么 going idle 前还要先 `flushInternalEvents()`？
4. 如果 `idle` 只是在说“现在没在跑”，为什么 schema 描述要把它写成 authoritative turn-over signal？
5. 如果 `flush()` 已经等于 finality，为什么注释还要明确说 server truth 要 separately check？
6. 如果这次 stronger cleanup request 的结果已经 future-final，为什么还要等 `state_restored` 这种 future readback evidence？

这些反问共同逼出同一个结论：

`Claude Code 不只在治理 old request 当前有没有完成，也在治理这份完成以后回来时究竟还能不能继续当真。`

## 11. 一条硬结论

这组源码真正说明的不是：

`只要补出 continued stronger-cleanup 的 current completion grammar，stronger-request cleanup 线就已经拥有了足够强的终局语义。`

而是：

repo 已经在 `addToolResult()` 的 current message completion、`print.ts` 的 bridge result forwarding 与 `files_persisted`、`flushInternalEvents() -> idle` 的 authoritative turn-over choreography、`coreSchemas.ts` / `sdkEventQueue.ts` 的更强 system signal schema、`CCRClient.flush()` 对 delivery-only ceiling 的免责声明，以及 `state_restored` 的 future-readback evidence 上，清楚展示了 stronger-request finality governance 的独立存在；因此 `artifact-family cleanup stronger-request completion-governor signer` 仍不能越级冒充 `artifact-family cleanup stronger-request finality-governor signer`。
