# Delayed suggestion delivery and accounting 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/99-pendingSuggestion、pendingLastEmittedEntry、lastEmitted、logSuggestionOutcome 与 heldBackResult：为什么 headless print 的 suggestion 不是生成即交付.md`
- `05-控制面深挖/98-lastMessage stays at the result、SDK-only system events、pendingSuggestion、heldBackResult 与 post_turn_summary：为什么 headless print 的主结果语义不会让给晚到系统事件.md`

边界先说清：

- 这页不是 suggestion 功能总论。
- 这页不替代 98 对 semantic last result 的拆分。
- 这页只抓 suggestion 的生成、交付、接受追踪记账三层错位。

## 1. 五个关键对象总表

| 对象 | 作用 | 更接近什么 |
| --- | --- | --- |
| `pendingSuggestion` | suggestion 已生成但未交付 | pending delivery |
| `pendingLastEmittedEntry` | 等待升级的 tracking 元数据 | pending accounting |
| `lastEmitted` | 已真正交付的 suggestion 账本 | delivered suggestion ledger |
| `heldBackResult` | 决定 suggestion 是否必须延后 | result-first delivery gate |
| `logSuggestionOutcome(...)` | 只对已交付 suggestion 记接受结果 | acceptance tracking gate |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| suggestion 一生成就算已交付 | `heldBackResult` 存在时，它会先进入 `pendingSuggestion` |
| `lastEmitted` 记录的是最近生成的 suggestion | 它只记录最近真正交付过的 suggestion |
| `pendingLastEmittedEntry` 只是多余缓存 | 它保护 tracking 元数据只在真实交付后升级 |
| 新命令来了，最好把 pending suggestion 也发掉 | 系统宁可丢弃未交付 suggestion，也不伪造交付 |
| acceptance tracking 只需要 suggestion 文本 | `logSuggestionOutcome(...)` 只接受 `lastEmitted`，不接受 pending/generated suggestion |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | suggestion 有待交付与已交付边界；`heldBackResult` 会同时延后 suggestion 输出与记账；未交付 suggestion 可被丢弃 |
| 条件公开 | `heldBackResult`、新命令、abort/shutdown、当前 command 是否为 `prompt` 都会改变交付/记账时机 |
| 内部/实现层 | 字段布局、inflightPromise/abort 细节、acceptance tracking 上报细节 |

## 4. 六个检查问题

- 这里的 suggestion 是已生成，还是已真实交付？
- 这笔 tracking 元数据已经升级成 `lastEmitted` 了吗？
- `heldBackResult` 当前是否在拖后 suggestion？
- 新命令来了以后，这条 pending suggestion 还应该保留吗？
- 这里讨论的是 semantic last result，还是 suggestion delivery ledger？
- 我是不是把 delayed delivery 写成了 immediate suggestion delivery？

## 5. 源码锚点

- `claude-code-source-code/src/cli/print.ts`
