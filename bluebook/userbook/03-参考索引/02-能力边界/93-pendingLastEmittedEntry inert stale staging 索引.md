# `pendingLastEmittedEntry` inert stale staging 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/104-pendingLastEmittedEntry、pendingSuggestion、lastEmitted、interrupt 与 end_session：为什么 headless print 的 deferred suggestion staging 会留下 inert stale slot.md`
- `05-控制面深挖/99-pendingSuggestion、pendingLastEmittedEntry、lastEmitted、logSuggestionOutcome 与 heldBackResult：为什么 headless print 的 suggestion 不是生成即交付.md`
- `05-控制面深挖/102-lastEmitted、logSuggestionOutcome、interrupt、end_session 与 output.done：为什么 headless print 的已交付 suggestion 不一定留下 accepted、ignored telemetry.md`

边界先说清：

- 这页不是 suggestion 总论。
- 这页不替代 99 对 staging creation / promotion 的拆分。
- 这页不替代 102 对 telemetry settlement gap 的拆分。
- 这页只抓 `pendingLastEmittedEntry` 在部分 cleanup 分支里的不对称残留，为什么更像 inert stale staging。

## 1. 三层对象总表

| 对象 | 它在回答什么 | 更接近什么 |
| --- | --- | --- |
| `pendingSuggestion` | 还有没有待真实交付的 suggestion | outer promotion gate |
| `pendingLastEmittedEntry` | 与 deferred suggestion 配套的待升级 tracking metadata | incomplete staging record |
| `lastEmitted` | 已真实交付的 suggestion 账本 | delivered ledger |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `pendingLastEmittedEntry` 留着，就等于还残留一条待发 suggestion | 真正的外层 gate 是 `pendingSuggestion` |
| 它没被一起清掉，所以以后一定会错误 promote | 当前 promote 路径要求 `pendingSuggestion` 仍存在 |
| 这和 99 完全一样 | 99 讲 creation/promotion；104 讲 cleanup asymmetry 后的 inertness |
| 这已经足以证明 visible protocol bug | 从当前控制流推断，更接近 internal stale staging |
| 只是内部细节，不值得写 | 不单列就会把内部残影夸大成外部协议缺陷 |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | `pendingLastEmittedEntry` 是 incomplete staging；它只在 deferred path 创建；promotion 外层 gate 是 `pendingSuggestion` |
| 条件公开 | cleanup 非对称只在先 deferred、后走特定 control/teardown 分支时出现 |
| 内部/灰度层 | `interrupt` / `end_session` 未同步清该 slot；“更像 inert stale staging”属于基于当前控制流的推断 |

## 4. 六个检查问题

- 这里残留的是完整已交付记录，还是 incomplete staging record？
- 当前还有没有 `pendingSuggestion` 作为外层 promote gate？
- 这条路径是在做 deferred promotion，还是在做 cleanup？
- 我是不是把内部残影直接写成了外部协议 bug？
- 我是不是把 99 的 creation/promotion 问题和 104 的 cleanup inertness 问题写回一页？
- 我有没有明确标出哪些结论是当前控制流下的推断？

## 5. 源码锚点

- `claude-code-source-code/src/cli/print.ts`
- `claude-code-source-code/src/services/PromptSuggestion/promptSuggestion.ts`
