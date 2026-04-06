# Headless print prompt batching and per-uuid replay 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/89-canBatchWith、joinPromptValues、batchUuids、replayUserMessages、task-notification 与 orphaned-permission：为什么 headless print 的 prompt batching 不是普通批量出队.md`
- `05-控制面深挖/88-running、peek(isMainThread)、drainCommandQueue、setOnEnqueue、cron onFire 与 post-finally recheck：为什么 headless print 的 queue re-entry 不是普通事件订阅器.md`

边界先说清：

- 这页不是 headless `print` queue 总论。
- 这页不替代 88 对 single-consumer pump / re-entry 的拆分。
- 这页只抓 prompt batching、workload/meta 边界，以及 per-uuid replay/lifecycle 补偿。

## 1. 五个关键对象总表

| 对象 | 作用 | 更接近什么 |
| --- | --- | --- |
| `joinPromptValues()` | 合并 prompt payload | payload merge |
| `canBatchWith()` | 划定 prompt batching 边界 | batch gate |
| `task-notification` / `orphaned-permission` | 明确单发，不混批 | singleton side-effect carrier |
| `batchUuids` + `notifyCommandLifecycle(...)` | 保住每条命令的 started/completed 账本 | identity repair |
| `replayUserMessages` | 为被吞进 batch 的其余 `uuid` 补 replay | per-uuid delivery repair |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| batching 就是把主线程队列多 dequeue 几次 | 这里做的是 prompt turn 合批，不是普通批量出队 |
| 只要都是 prompt，就都能合批 | 还必须 workload 一致、`isMeta` 一致 |
| 合批以后只有最后一个 `uuid` 还重要 | 其余 `uuid` 仍会补 replay 和 lifecycle |
| `task-notification` 只是文本不同的 prompt | 它先承担 SDK 事件副作用，再进入模型 turn |
| REPL 和 headless `print` 的 batching 一样 | REPL 更像 same-mode dispatch；`print` 更像 prompt-only coalescing |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | headless `print` 的 batching 是受 workload/meta/side-effect 约束的 prompt 合批；非 prompt 特殊命令单发；per-uuid 身份不会因合批被抹掉 |
| 条件公开 | 只有 `prompt` 才尝试 `canBatchWith(...)`；replay 补偿受 `replayUserMessages` 控制；真正继续合批的是当前 `peek(isMainThread)` 看到的下一条主线程 prompt |
| 内部/实现层 | string/block 拼接细节；最后一个 `uuid` 代表 ask 的实现选择；priority 与 `peek(...)` 的先后关系；SDK replay/lifecycle 的具体落点 |

## 4. 六个检查问题

- 这里合并的是 prompt payload，还是命令治理语义？
- 这条命令为什么能批进去，凭的是 mode，还是 workload / `isMeta`？
- 这次 batching 减少的是 turn 数，还是命令身份？
- 为什么这条非 prompt 命令必须单发？
- REPL 这里做的是同一种 batching，还是只是表面相似？
- 我是不是把 bounded turn coalescing 写成 generic bulk dequeue 了？

## 5. 源码锚点

- `claude-code-source-code/src/cli/print.ts`
- `claude-code-source-code/src/utils/queueProcessor.ts`
- `claude-code-source-code/src/hooks/useQueueProcessor.ts`
- `claude-code-source-code/src/screens/REPL.tsx`
