# addToolResult、print与CCRClient的强请求清理终局治理边界

## 1. 为什么单开这一篇源码剖面

安全主线推进到 `468` 时，
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

把 current `tool_result` completion、bridge-visible current result、`files_persisted`、`idle`、`flush()` disclaimer 与 `state_restored` 并排，
逼出一句更硬的结论：

`Claude Code 已经在 continued stronger-cleanup world 里明确展示：当前完成只说明结果进入当前消息流并可能被当前 reader 收到；更强终局要等到 effect persistence、authoritative turn-over、delivery-illusion refusal 与 future-readable restoration 之后才成立。`

## 2. 最短判断

这组代码最重要的技术事实不是：

`Claude Code 会在完成之后再发一些 system event。`

而是：

`Claude Code 明确拒绝把 continued stronger-cleanup 的 current completion、current reader delivery、effect persistence、turn-over、delivery drain 与 future-readable restoration 压成同一个 completed。`

## 3. 关键源码锚点

| 主题 | 关键源码 | 这里回答的问题 |
| --- | --- | --- |
| current message completion | `src/services/tools/toolExecution.ts:1403-1475` | 为什么 `addToolResult` 只把 continued stronger-cleanup result 放进当前消息流 |
| bridge-visible current result | `src/cli/print.ts:2252-2254` | 为什么当前 reader 可以先收到结果，却仍不等于 finality |
| effect persistence emit | `src/cli/print.ts:2256-2272` | 为什么 effect persistence 要单独建成 `files_persisted` |
| idle choreography | `src/cli/print.ts:2455-2468` | 为什么 going idle 前要先 flush internal events |
| finality schemas | `src/entrypoints/sdk/coreSchemas.ts:1672-1692,1739-1746` | 为什么 `files_persisted` 与 `idle` 是不同强度的 system signals |
| authoritative turn-over queue semantics | `src/utils/sdkEventQueue.ts:60-90` | 为什么 `idle` 只签 authoritative turn-over，而不是更强世界终局 |
| transport drain disclaimer | `src/cli/transports/ccrClient.ts:826-833` | 为什么 `flush` 只配签 delivery confirmation |
| future-readable readback | `src/cli/transports/ccrClient.ts:514-523` | 为什么更强终局来自未来还能把状态读回来 |

## 4. `addToolResult()` 先证明：continued stronger cleanup request 的 completion 首先只是 current message truth

`src/services/tools/toolExecution.ts:1403-1475`
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

1. 当前 reader 是否已收到
2. effect 是否已经落地
3. 这轮 turn 是否已 authoritative 地 over
4. 以后回来时是否还能读回

所以 `addToolResult()` 的 ceiling 很明确：

`current message completion`

不是

`future-readable finality`

## 5. `sendResult()`、`files_persisted` 与 `idle` 再证明：print 会在 current completion 之后继续追问更强的 finality truth

`src/cli/print.ts:2252-2254`
很值钱。

当一轮 turn 结束后，
系统会先：

1. `forwardMessagesToBridge()`
2. `bridgeHandle?.sendResult()`

这条顺序直接说明：

1. 当前 reader 可能已经拿到结果
2. 但 effect persistence 还没开始单独签字
3. 更不等于 authoritative turn-over 或 future readback 已成立

换句话说，
repo 连

`reader-local delivery`

和

`future-readable finality`

都继续拆开。

`src/cli/print.ts:2256-2272`
更硬。

当 turn 结束后，
系统不会把 effect persistence 偷写进 generic completion，
而是单独：

1. 跑 `executeFilePersistence(...)`
2. enqueue 一个 `system/files_persisted`

配合 `coreSchemas.ts:1672-1692` 可以看得更清楚：

`files_persisted`

单独携带：

1. `files`
2. `failed`
3. `processed_at`

这说明 effect persistence 是一条值得单独签字的真相。

`src/cli/print.ts:2455-2468`
又更值钱。

系统在 finally 中不是先说 idle，
而是先：

`await structuredIO.flushInternalEvents()`

再：

`notifySessionStateChanged('idle')`

而 `coreSchemas.ts:1739-1746` 与 `sdkEventQueue.ts:60-90` 又把：

`session_state_changed(idle)`

写成：

`authoritative turn-over signal`

这条顺序直接说明：

continued stronger-cleanup 的 current completion

仍然在

`turn-over finality`

之前。

## 6. `flush()` 与 `state_restored` 再证明：future-readable finality 比 current completion、reader delivery 与 delivery drain 都更强

`src/cli/transports/ccrClient.ts:826-833`
的注释几乎就是一条反伪终局宪法。

它明确说：

1. `flush()` 用于 caller 需要 delivery confirmation 时
2. 它不负责替 individual POST success / server state finality 签字
3. 若真关心 server truth，必须 separately check server state

这条证据非常硬。

因为它把一个常见幻觉直接打碎了：

`delivered == final`

源码作者显然不接受这个等号。

`src/cli/transports/ccrClient.ts:514-523`
的 `state_restored` 更值钱。

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

## 7. 为什么这层不等于 `318` 的 current completion gate

这里必须单独讲清楚，
否则容易把 `319` 误读成 `318` 的尾注。

`318` 问的是：

`continued stronger cleanup request 当前是否已经完成。`

`319` 问的是：

`这份当前完成以后回来时是否仍然成立。`

所以：

1. `318` 的典型形态是 `tool_result`、`completed progress`、`completed successfully`
2. `319` 的典型形态是 `sendResult()`、`files_persisted`、`idle`、`flush()` disclaimer、`state_restored`

前者 guarding current request completion，
后者 guarding future-readable finality。

两者都很重要，
但不是同一个 signer。

## 8. 更深一层的技术先进性：Claude Code 真正谨慎的地方，不是“这次看起来做完了就算终局”，而是“没有更强读回证据，就绝不让当前完成语法冒充终局语法”

这组源码给出的技术启示至少有六条：

1. current completion 之外，还必须再长一层 future-readable finality grammar。
2. reader-local delivery 只能说明当前读者已见，不能越级冒充终局。
3. effect persistence 和 authoritative turn-over 必须各自单列签字层。
4. delivery confirmation 必须被制度性降格，防止 `flush()` 抢终局主权。
5. future-readable readback 应成为 stronger finality 的核心证据。
6. 真正成熟的安全系统宁可把“这次做完了”和“以后还真”拆成多层，也不让 present-tense success 越级占领 future truth。

## 9. 苏格拉底式自反诘问：我是不是又把“它这次已经完成”误认成了“它以后回来时仍然成立”

如果对这组代码做更严格的自我审查，
至少要追问七句：

1. 如果当前 `tool_result` 已经等于终局，为什么 `print.ts` 还要单独发 `files_persisted`？
   因为 current result 不等于 effect persistence。
2. 如果 bridge 已经收到结果，为什么这份结果还不能直接叫 final？
   因为 reader-local delivery 不等于 world-level settled truth。
3. 如果 continued stronger cleanup request 的 current completion 已经等于 authoritative turn-over，为什么 going idle 前还要先 `flushInternalEvents()`？
   因为当前完成还没自动跨过 held-back/internal event flush。
4. 如果 `idle` 已经说明 everything is over，为什么 `files_persisted` 与 `idle` 还要各自单独建 schema？
   因为 persistence 与 turn-over 是两层不同真相。
5. 如果 `flush()` 已经等于 finality，为什么注释还要明确说 server truth 要 separately check？
   因为 delivery confirmation 不等于 settled state truth。
6. 如果这次 stronger cleanup request 的结果已经 future-final，为什么还要等 `state_restored` 这种 future readback evidence？
   因为“现在说自己已经写好了”不如“以后回来还能把它读回来”更强。
7. 如果 cleanup 线还没正式长出 finality grammar，是不是说明这层只是事件顺序细节？
   恰恰相反。越是把它当顺序细节，越容易让“当前完成”偷签“未来仍真”。

这一串反问最终逼出一句更稳的判断：

`finality 的关键，不在当前结果有没有出现，而在系统能不能正式决定这份当前结果以后回来时是否仍然成立。`

## 10. 一条硬结论

这组源码真正说明的不是：

`只要补出 continued stronger-cleanup 的 current completion grammar，stronger-request cleanup 线就已经拥有了足够强的终局语义。`

而是：

repo 已经在 `addToolResult()` 的 current message completion、`print.ts` 的 bridge-visible current result、`files_persisted` 与 `idle` choreography、`coreSchemas.ts` / `sdkEventQueue.ts` 对 authoritative turn-over 的单独 schema、`ccrClient.flush()` 对 delivery-only ceiling 的免责声明，以及 `state_restored` 的 future-readback evidence 上，清楚展示了 stronger-request finality governance 的独立存在；因此 `artifact-family cleanup stronger-request completion-governor signer` 仍不能越级冒充 `artifact-family cleanup stronger-request finality-governor signer`。

因此：

`这次完成了`

不等于

`以后回来时仍然成立`

而真正成熟的 stronger-request cleanup control plane，
必须在这两者之间再长出一层正式 finality signer。
