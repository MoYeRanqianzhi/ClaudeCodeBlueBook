# print 与 CCRClient 的终局签字边界

## 1. 为什么单开这一篇源码剖面

安全主线推进到 `149` 时，  
一个越来越清楚的问题浮出来了：

`Claude Code 到底在哪里把“完成”继续拆成“终局”？`

这个问题如果只停在主线长文里，  
很容易被说成抽象词法。  
所以这里单开一篇，只盯住：

- `src/cli/print.ts`
- `src/cli/transports/ccrClient.ts`
- `src/utils/sdkEventQueue.ts`
- `src/entrypoints/sdk/coreSchemas.ts`

把 `idle`、`flushInternalEvents()`、`files_persisted`、`flush()`、`state_restored` 这几层信号拆给源码本身说话。

## 2. 先给最短判断

这组代码最重要的技术事实不是：

`Claude Code 会在流程结束时发一些 system event。`

而是：

`Claude Code 明确拒绝把“当前 run 结束”“事件已发出”“文件已持久化”“下次还能读回”压成同一个 completed。`

这意味着它治理的不是单一完成词，  
而是一套：

`多层终局签字协议`

## 3. 关键源码锚点

| 主题 | 关键源码 | 这里回答的问题 |
| --- | --- | --- |
| `files_persisted` schema | `src/entrypoints/sdk/coreSchemas.ts:1671-1689` | effect persistence 为什么单独成一类 system event |
| `session_state_changed(idle)` schema | `src/entrypoints/sdk/coreSchemas.ts:1739-1748` | why idle 只签 authoritative turn-over |
| idle 前 flush | `src/cli/print.ts:2456-2468` | 为什么 going idle 前要先 flush internal events |
| effect persistence emit | `src/cli/print.ts:2248-2270` | 为什么文件落定不混进 generic completion |
| queue semantics | `src/utils/sdkEventQueue.ts:60-90` | why idle 是 turn-over，不是更强终局 |
| restore readback | `src/cli/transports/ccrClient.ts:514-523` | 为什么 future readback 比当前自说自话更强 |
| transport drain disclaimer | `src/cli/transports/ccrClient.ts:826-838` | 为什么 flush 成功不等于 server-state finality |

## 4. `idle` 真正签的是 turn-over，不是世界终局

`session_state_changed(idle)` 的 schema 注释已经写得非常直白：

`authoritative turn-over signal`

配合 `sdkEventQueue.ts` 的注释可以看得更清楚：

1. 它发生在 heldBackResult flush 之后
2. 也发生在 bg-agent loop 退出之后
3. 所以 SDK consumer 可以把它当作“这轮 turn 结束”的 authoritative signal

但这条信号的强度到这里就停了。  
它证明的是：

`这轮 turn 现在不再 running`

却不自动证明：

1. 文件效果已落地
2. 远端状态已正式落定
3. 下次会话一定能读回同一真相

所以 `idle` 在这里代表的是：

`turn finality`

而不是：

`world finality`

## 5. `flushInternalEvents()` 说明 idle 之前还要先过一层 transcript persistence gate

`print.ts` 在 finally 里不是先发 idle，  
而是先：

`await structuredIO.flushInternalEvents()`

然后才：

`notifySessionStateChanged('idle')`

这条顺序非常硬，  
因为它证明源码作者明确接受一条边界：

`没有先持久化的 internal events，不配被 idle 之后的世界当成既成事实。`

也就是说：

- lifecycle 结束
- turn-over 发出

这两件事之间还隔着一层：

`transcript persistence gate`

## 6. `files_persisted` 进一步说明 effect finality 被单独建模

在 `print.ts` 里，  
文件持久化并没有被压进 generic result success。

系统会：

1. 调 `executeFilePersistence(...)`
2. 完成后单独 enqueue 一个 `system/files_persisted`

对应 schema 里也有：

- `files`
- `failed`
- `processed_at`

这说明从源码作者视角看：

`文件效果是否真正落地`

是一条值得单独签字的真相，  
它不应被 generic completion 吃掉。

## 7. `ccrClient.flush()` 的注释几乎就是“反伪终局宪法”

`ccrClient.flush()` 最重要的不是代码本身，  
而是注释。

它明确说：

1. 这里只给 delivery confirmation
2. close() 会丢队列，所以必要时要先 flush
3. 但 individual POST 是否成功，不能仅靠 flush 断言
4. 如果你关心 server truth，要 separately check server state

这条注释直接把一个常见伪终局打碎了：

`queue drained == state final`

源码作者显然不接受这个等号。

## 8. `state_restored` 说明更强终局来自“未来还能读回”

`ccrClient.ts:514-523` 最值得反复读的地方在于：

作者故意把 `state_restored` 放在：

1. PUT 成功之后
2. concurrent GET await 之后

原因是要避免：

`同一 session 同时出现 init_failed 和 state_restored`

这说明源码作者知道：

`我现在说自己存好了`

不如：

`下一个读者回来时真的把它读出来了`

更强。

因此 `state_restored` 在这条链上的地位不是普通日志，  
而是：

`future-readable finality evidence`

## 9. 这篇源码剖面给主线带来的三条技术启示

### 启示一

Claude Code 的完成语义至少分成：

- turn-over
- transcript persistence
- effect persistence
- future-readable restoration

### 启示二

`flush()` 被明确压回 delivery confirmation，  
说明系统在主动拒绝 transport illusion 冒充 state finality。

### 启示三

最强终局不是“现在看起来已经好了”，  
而是“以后回来还能把它读回”。

## 10. 一条硬结论

这组源码真正先进的地方不是“信号很多”，  
而是它在最关键的地方坚持了一条很难得的边界：

`当前结束，不等于未来仍真。`
