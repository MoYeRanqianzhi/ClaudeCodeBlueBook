# Semantic last result vs late system tail 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/98-lastMessage stays at the result、SDK-only system events、pendingSuggestion、heldBackResult 与 post_turn_summary：为什么 headless print 的主结果语义不会让给晚到系统事件.md`
- `05-控制面深挖/97-heldBackResult、bg-agent do-while、notifySessionStateChanged(idle)、lastMessage 与 authoritative turn over：为什么 headless print 的 idle 不是普通 finally 状态切换.md`

边界先说清：

- 这页不是 idle semantics 总图。
- 这页不替代 97 对 authoritative idle 的拆分。
- 这页只抓 semantic last result 与 late system tail 的语义主位边界。

## 1. 五个关键对象总表

| 对象 | 作用 | 更接近什么 |
| --- | --- | --- |
| `lastMessage stays at the result` | 锚定主结果语义主位 | semantic result rank |
| SDK-only system tail | 及时落流但不篡位 | late system tail |
| `heldBackResult` | 让主结果可被压后但仍保持主位 | result delivery gate |
| `pendingSuggestion` / `lastEmitted` | 区分已生成与已交付 suggestion | suggestion delivery ledger |
| `post_turn_summary` | 辅助尾流，不是主结果层 | post-result auxiliary tail |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| 谁最后输出，谁就是这一轮最后主消息 | 系统明确要求 `lastMessage` 停在 result；不然 CLI 输出与退出语义都会被写坏 |
| SDK-only system events 不算主消息，就无所谓顺序 | 它们必须及时到达，只是不能篡位 |
| suggestion 一生成就算已交付 | held-back result 存在时 suggestion 会先 pending |
| `post_turn_summary` 属于最终主结论层 | 它也是 late system tail 的一员 |
| idle 可信，所以它理应成为 semantic last result | authoritative turn-over signal 和 semantic last result 不是同一层 |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | result 是 semantic last message，并直接驱动 CLI 输出/退出语义；SDK-only system events 属于 late tail；suggestion 交付也要让位于主结果落地 |
| 条件公开 | `heldBackResult` 会改变 suggestion 输出与记账时机；不同 consumer 会拿 late tail 做 heuristics |
| 内部/实现层 | 过滤名单、pendingSuggestion 细节、task_summary/post_turn_summary 的职责切分 |

## 4. 六个检查问题

- 这里讨论的是最后落流的事件，还是最后的主结果语义？
- 这条 system event 重要，但会不会篡位？
- suggestion 是已经生成，还是已经真正交付？
- `post_turn_summary` 在这里属于正文，还是尾流？
- 这里讨论的是 authoritative idle，还是 semantic result rank？
- 我是不是把 late system tail 写成了 final result layer？

## 5. 源码锚点

- `claude-code-source-code/src/cli/print.ts`
- `claude-code-source-code/src/utils/sessionState.ts`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts`
