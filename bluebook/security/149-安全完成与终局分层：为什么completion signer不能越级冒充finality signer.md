# 安全完成与终局分层：为什么completion signer不能越级冒充finality signer

## 1. 为什么在 `148` 之后还必须继续写“完成与终局分层”

`148-安全回执与完成分层` 已经回答了：

`receipt signer 只配宣布“这张单已被合法接住并关账”，completion signer 才配宣布“这件事已经真正完成”。`

但如果继续往前追问，  
还会碰到一个更硬、更偏运行时治理的问题：

`就算 completion signer 已经签字，这是否已经等于 finality？`

Claude Code 当前源码给出的答案依然是否定的。  
因为它同时保留了至少四类更强或不同向度的终局信号：

1. `session_state_changed(idle)`
2. `flushInternalEvents()`
3. `files_persisted`
4. 下一次初始化时的 `state_restored`

再叠加 `ccrClient.flush()` 的注释又明确提醒：

`delivery confirmation 与 server state 不是同一回事。`

这说明 Claude Code 不把“流程结束”直接压成：

`世界已经终局成立。`

所以 `148` 之后必须继续补的一层就是：

`安全完成与终局分层`

也就是：

`completion signer 只能对“语义流程完成”签字；finality signer 才配对“结果已经被持久化、可被未来世界重新读回”签字。`

## 2. 最短结论

Claude Code 当前源码至少把“终局”拆成了四层不同对象：

1. receipt finality  
   request 已被合法接单并关账  
   `src/cli/structuredIO.ts:362-429`
2. turn completion  
   当前 turn 已退出运行态，可发 `session_state_changed(idle)`  
   `src/cli/print.ts:2456-2468`  
   `src/utils/sdkEventQueue.ts:60-90`  
   `src/entrypoints/sdk/coreSchemas.ts:1739-1748`
3. effect persistence  
   文件效果是否真正落成单独的 `files_persisted` 事件  
   `src/cli/print.ts:2248-2270`  
   `src/entrypoints/sdk/coreSchemas.ts:1671-1689`
4. restoration finality  
   下一次初始化时，系统是否真的能读回先前 worker state  
   `src/cli/transports/ccrClient.ts:514-523`

同时：

5. transport drain 仍不是 server-state finality  
   `ccrClient.flush()` 明确只给 delivery confirmation，不替 server truth 签字  
   `src/cli/transports/ccrClient.ts:826-838`

这些证据合在一起说明：

`Claude Code 并不把 completion 当成终局本身，而是把终局继续拆成 turn turn-over、effect persistence 与 future restorable truth。`

因此这一章的最短结论是：

`cleanup future design 若继续推进，不只要区分 cleanup_receipted、cleanup_completed，还至少要继续区分 cleanup_persisted 与 cleanup_restorable；completion signer 不能越级冒充 finality signer。`

再压成一句：

`完成回答的是“现在这一步做完了”，终局回答的是“以后回来还能把它当真”。`

## 3. 第一性原理：为什么真正的终局必须回答“未来世界还能否重读”

从第一性原理看，  
一个安全控制面若要宣布某件事已经 final，就不只要回答：

1. 当前处理有没有结束
2. 当前消息有没有发出

它还必须回答：

3. 未来读者能否重新读到同一真相

因此终局至少有三问：

1. semantic closure  
   这次语义流程是否完成
2. persistence closure  
   它是否被持久化到应在的位置
3. restoration closure  
   下一次会话或另一表面是否真的能把它读回

如果这三问被压成同一句“完成了”，  
系统就会制造三类幻觉：

1. run-is-final illusion  
   当前 run 结束就误当世界终局
2. sent-is-stored illusion  
   消息发出或 queue drain 就误当状态已存活
3. stored-is-restorable illusion  
   某次本地写入成功就误当未来世界必然能读回

所以从第一性原理看：

`finality 不是 completion 的语气加强版，而是未来重读能力的署名。`

## 4. `session_state_changed(idle)` 证明 turn-over 不等于更强终局

`src/entrypoints/sdk/coreSchemas.ts:1739-1748` 明确描述：

`session_state_changed(idle)` 是 authoritative turn-over signal。

而 `src/utils/sdkEventQueue.ts:60-90` 也强调：

它之所以可信，  
是因为它发生在：

1. heldBackResult flush 之后
2. bg-agent do-while drain 退出之后

再结合 `src/cli/print.ts:2456-2468`：

1. 先 `await structuredIO.flushInternalEvents()`
2. 再 `notifySessionStateChanged('idle')`
3. 再 drain SDK events

这说明 `idle` 的 ceiling 很清楚：

`当前 turn 的 authoritative turn-over`

但它并不自动等于：

1. 文件效果已持久化
2. 外部存储已完成最终落定
3. 未来会话已确认可恢复

所以 `idle signer` 依旧不是 `finality signer`。

## 5. `flushInternalEvents()` 说明 even before idle，系统还要先守 transcript persistence

`src/cli/print.ts:2456-2468` 最值得注意的一点是：

Claude Code 在 going idle 前，  
先显式：

`await structuredIO.flushInternalEvents()`

而 `src/cli/transports/ccrClient.ts:816-823` 又把这件事定义得很硬：

`Flush pending internal events. Call between turns and on shutdown to ensure transcript entries are persisted.`

这说明系统自己也承认：

`语义完成` 和 `transcript persistence` 不是同一件事。

否则它根本不需要在 idle 前特地插入这一道 flush gate。

因此这条 flush gate 的哲学本质是：

`没有持久化过的内部事件，不配被 idle 之后的世界当成既成事实。`

## 6. `files_persisted` 说明 effect finality 被单独建模，而不是混进 generic completion

`src/cli/print.ts:2248-2270` 在 turn 完成后会异步：

`executeFilePersistence(...)`

只有完成后才发：

`system / files_persisted`

而 `src/entrypoints/sdk/coreSchemas.ts:1671-1689` 又给它单独 schema：

- `files`
- `failed`
- `processed_at`

这说明 Claude Code 不把“文件效果已经落地”压缩进：

1. generic result success
2. lifecycle completed
3. idle turn-over

而是给它单独的 effect persistence signer。

从安全哲学看，这非常关键。  
因为它说明系统承认：

`语义流程做完了` 不等于 `副作用世界已经落定了。`

## 7. `ccrClient.flush()` 明确证明 delivery confirmation 不是 server-state finality

`src/cli/transports/ccrClient.ts:826-838` 的注释几乎可以直接当成这章的核心锚点：

它明确说：

`flush()` 只在 caller 需要 delivery confirmation 时调用；
它返回 regardless of whether individual POSTs succeeded；
如果需要 server truth，要 separately check server state。

这等于源码作者直接把一条重要宪法写出来：

`transport drain != server truth`

也就是说：

1. queue drained
2. uploader finished
3. caller got confirmation

仍然不等于：

`远端世界已经把这份真相正式接纳为 final state。`

这条边界对任何 future cleanup design 都极其重要。  
否则系统极容易把：

`cleanup event 已发出`

误当成：

`cleanup state 已成为 server-side finality`

## 8. `state_restored` 说明更强终局来自未来读回，而不是当前自说自话

`src/cli/transports/ccrClient.ts:514-523` 还有一条更强的信号：

`state_restored`

源码之所以把它放在：

1. PUT succeeded 之后
2. concurrent GET awaited 之后

就是为了防止出现：

`同一会话既 init_failed 又 state_restored`

这种伪终局并存。

这里最重要的哲学不是日志顺序，  
而是：

`真正强的 finality 不是我现在说我存好了，而是下一个读者回来时真的还能把它读回。`

所以 `state_restored` 代表的不是普通 completion，  
而是：

`future-readable finality`

## 9. 技术启示：future cleanup protocol 至少要继续拆哪四层终局词法

如果沿着 Claude Code 当前的终局分层继续往前推，  
下一代 cleanup protocol 至少应拆成：

1. `cleanup_receipted`
   cleanup request 已被合法接单
2. `cleanup_completed`
   cleanup 语义流程已完成
3. `cleanup_persisted`
   cleanup 结果已被持久化到对应账本 / effect world
4. `cleanup_restorable`
   未来读者 / 后续会话真的能把 cleanup 结果重新读回

必要时还可继续拆：

5. `cleanup_transport_drained`
   只表示 delivery confirmation，严禁冒充 finality

否则系统极容易重新退回：

`一个 completed 吃掉五层终局语义`

这会让 cleanup 设计重新落回伪完成与伪遗忘。

## 10. 用苏格拉底诘问法再追问一次

### 问：为什么 `idle` 不够？

答：因为它首先签的是 turn-over，不是 effect persistence，更不是 future-readable finality。

### 问：为什么 `files_persisted` 还不够？

答：因为 effect persistence 仍不自动等于下一次会话一定能把同一真相读回。

### 问：为什么 `flush()` 不够？

答：因为 delivery confirmation 与 server state 不是同一回事，源码已经明确写死这条边界。

### 问：为什么 `state_restored` 更强？

答：因为它不只是“我说我存了”，而是未来读者回来时真的读到了。

### 问：如果要把这套 finality layering 再提高一倍，最该补什么？

答：不是再加更多绿色“已完成”文案，  
而是把 receipt、completion、persisted、restorable、transport-drained 的 ceiling 分别字段化，让每层 signer 只能说出自己配说到的终局上限。

## 11. 一条硬结论

真正成熟的终局签字不是：

`这一步已经跑完。`

而是：

`未来世界回来时，仍能把这一步当成真。`
