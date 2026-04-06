# Suggestion cleanup and telemetry gap 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/102-lastEmitted、logSuggestionOutcome、interrupt、end_session 与 output.done：为什么 headless print 的已交付 suggestion 不一定留下 accepted、ignored telemetry.md`
- `05-控制面深挖/99-pendingSuggestion、pendingLastEmittedEntry、lastEmitted、logSuggestionOutcome 与 heldBackResult：为什么 headless print 的 suggestion 不是生成即交付.md`
- `05-控制面深挖/101-lastMessage、outputFormat switch、gracefulShutdownSync、prompt_suggestion 与 session_state_changed(idle)：为什么 headless print 的 result 是最终输出语义，却不是流读取终点.md`

边界先说清：

- 这页不是 suggestion 总论。
- 这页不替代 99 对 delivery / delayed accounting 的拆分。
- 这页不替代 101 对 terminal contract 的拆分。
- 这页只抓已交付 suggestion 在 `interrupt` / `end_session` / output close 下为什么可能没有 accepted / ignored settlement。

## 1. 三层对象总表

| 对象 | 它在回答什么 | 更接近什么 |
| --- | --- | --- |
| `lastEmitted` | 哪条 suggestion 已真实交付 | delivered suggestion ledger |
| `logSuggestionOutcome(...)` | 何时把它结算成 accepted / ignored | telemetry settlement gate |
| `interrupt` / `end_session` / `output.done()` | 收口路径是否还保留结算机会 | cleanup without guaranteed settlement |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| suggestion 只要显示过，最终一定会记 accepted / ignored | 只有下一次 prompt 到来时才会触发 `logSuggestionOutcome(...)` |
| `interrupt` 就等于 ignored | `interrupt` 会清状态，但不会补记 ignored |
| `end_session` 只是更温和的 ignored | 它同样直接放弃 settlement |
| output close 会兜底补记 outcome | close 路径会等 generation / delivery，但不会主动做 settlement |
| 99 已经解释完 suggestion accounting | 99 讲 delivery；102 讲 post-delivery cleanup 与 missing settlement |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | `lastEmitted` 表示已交付；outcome 只在 next prompt 结算；`interrupt` / `end_session` / close 都可能让已交付 suggestion 没有 settled outcome |
| 条件公开 | 是否已进入 `lastEmitted`、后续动作是 prompt 还是 cleanup path，会决定这条 suggestion 是否最终落账 |
| 内部/灰度层 | `pendingLastEmittedEntry` staging 细节、内部 telemetry 字段、ant-only payload |

## 4. 六个检查问题

- 我当前说的是“已交付”，还是“已结算”？
- 这里有没有真正发生下一次 prompt？
- 当前收口路径是在做 prompt settlement，还是在做 cleanup？
- 我是不是把 `interrupt` / `end_session` 误写成自动 ignored？
- output close 当前保的是 generation / delivery，还是 outcome settlement？
- 我是不是把 99 的 delivery 边界和这页的 settlement 边界又写回同一层？

## 5. 源码锚点

- `claude-code-source-code/src/cli/print.ts`
- `claude-code-source-code/src/services/PromptSuggestion/promptSuggestion.ts`
