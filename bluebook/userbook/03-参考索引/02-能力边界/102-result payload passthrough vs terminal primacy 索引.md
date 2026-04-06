# result payload passthrough vs terminal primacy 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/113-result、structured_output、permission_denials、lastMessage 与 gracefulShutdownSync：为什么 streamlined path 的 passthrough 不是 terminal semantic 主位保留.md`
- `05-控制面深挖/101-lastMessage、outputFormat switch、gracefulShutdownSync、prompt_suggestion 与 session_state_changed(idle)：为什么 headless print 的 result 是最终输出语义，却不是流读取终点.md`
- `05-控制面深挖/112-shouldIncludeInStreamlined、assistant-result 双入口、streamlined_* 与 null：为什么 streamlined path 的纳入 gate、替换入口与抑制返回不是同一种消息简化.md`

边界先说清：

- 这页不是 result 总论。
- 这页不替代 101 对 terminal semantic primacy 的拆分。
- 这页不替代 112 对 streamlined action taxonomy 的拆分。
- 这页只抓 result 在 streamlined path 里的 payload passthrough，为什么不等于 terminal semantic 主位保留。

## 1. 四层对象总表

| 层级 | 在这里回答什么 | 更接近什么 |
| --- | --- | --- |
| transformer `case 'result'` | 当前 payload 要不要改写 | payload passthrough |
| `lastMessage` filtering | 最后谁保持终态主位 | terminal primacy |
| `outputFormat` 收尾 | 最终怎么输出 result | final contract |
| `gracefulShutdownSync` | 最终退出码怎么决定 | terminal result consumer |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `return message` 就等于 terminal contract 在保 `result` | transformer 与 terminal cursor 不是一层 |
| payload 原样保留和终态主位保留只是同一件事 | 一个保载荷，一个保解释权 |
| 只要 passthrough 了，退出码和收尾就自然正确 | `gracefulShutdownSync` 看的是 terminal `lastMessage` |
| `structured_output` / `permission_denials` 与 final text/json 收尾属于同一种理由 | 前者是 payload，后者是 final semantics |
| `stream-json`、`json`、default 只是 result 外观不同 | 它们消费的层级不同 |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | transformer 对 result passthrough；`lastMessage` 保 result 主位；`json/default/gracefulShutdownSync` 继续围绕 terminal result 工作 |
| 条件公开 | stream-json 是否在 loop 内已写出、最终走哪种 outputFormat、result 是否 error 会影响最终消费方式 |
| 内部/灰度层 | passthrough 的全部设计理由、不同宿主是否完全复用这套终态合同 |

## 4. 六个检查问题

- 当前问的是 payload，还是终态主位？
- 我是不是把 passthrough 直接写成了 semantic primacy？
- 我是不是把 stream already logged above 和 final output switch 混成一层？
- 我是不是把 graceful shutdown 的退出语义误写成 transformer 直接负责？
- 我有没有把 101 的结论重讲，而没继续压到 preservation-reason split？
- 我是不是又把“keep unchanged”写成了单义词？

## 5. 源码锚点

- `claude-code-source-code/src/utils/streamlinedTransform.ts`
- `claude-code-source-code/src/cli/print.ts`
