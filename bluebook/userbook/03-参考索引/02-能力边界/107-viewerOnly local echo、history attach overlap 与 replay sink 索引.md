# viewerOnly local echo、history attach overlap 与 replay sink 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/118-convertUserTextMessages、sentUUIDsRef、fetchLatestEvents(anchor_to_latest)、pageToMessages 与 source-blind append：为什么 viewerOnly 的本地 echo 去重、history attach overlap 与 transcript 追加不是同一种 replay dedup.md`
- `05-控制面深挖/117-buildSystemInitMessage、SDKSystemMessage(init)、useDirectConnect 去重、convertInitMessage 与 onInit：为什么 callback-visible init、transcript init 提示与 slash bootstrap 不是同一种初始化可见性.md`
- `05-控制面深挖/115-convertToolResults、convertUserTextMessages、useAssistantHistory、viewerOnly 与 success result ignored：为什么 tool_result 本地补画、user text 历史回放与成功结果静默不是同一种 UI consumer policy.md`

边界先说清：

- 这页不是 viewerOnly 总体工作流。
- 这页不替代 115 对 `convertUserTextMessages` 的 visibility 解释。
- 这页不替代 117 对 init visibility 的拆分。
- 这页只抓 local echo dedup、history/live overlap 与 transcript sink 为什么不是同一种 replay dedup。

## 1. 四层 replay-related surface

| 层级 | 当前回答什么 | 典型例子 |
| --- | --- | --- |
| visibility policy | 回放的 user text 要不要变成 `message` | `convertUserTextMessages` |
| local echo dedup | 本地先插入后 WS echo 的同 UUID user message 要不要丢 | `sentUUIDsRef` |
| cross-source overlap dedup | history latest page 与 live stream 重叠时要不要跨来源对账 | attach-time history-vs-live overlap |
| transcript sink behavior | 两个来源产出的 `Message` 最终怎样写入 transcript | prepend / append 的 source-blind sink |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `convertUserTextMessages` 打开了，所以 replay dedup 也一起解决了 | 这只回答 visibility，不回答 dedup |
| `sentUUIDsRef` 既然按 UUID 去重，就会处理 history/live overlap | history page 不会往 ring 播种 UUID |
| history/live 都过同一个 adapter，所以 transcript 自然不重复 | sink 仍是 source-blind prepend/append |
| viewer 里重复 user message 一定是 echo filter 失效 | 也可能是 latest page 与 live append 的来源重叠 |
| history 里的 init/banner 重复说明 init visibility 页面写错了 | 那是 replay overlap 问题，不是 init visibility 本体 |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | `sentUUIDsRef` 只由 `sendMessage(..., { uuid })` 写入；它明确只处理本地 POST echo；history path 和 live path 共用 adapter 但不共用跨来源 dedup 索引 |
| 条件公开 | attach-time history-vs-live overlap 是否出现取决于 latest page 和 live 流的事件窗口是否重叠 |
| 内部/灰度层 | `/subscribe` 是否含 backlog、未来是否新增跨来源 UUID/source guard、是否让 history replay 重跑更多 live 副作用 |

## 4. 五个检查问题

- 当前写的是 visibility、echo dedup，还是 cross-source overlap？
- 我是不是把 `sentUUIDsRef` 写成了通用 replay dedup？
- 我是不是把 history/live overlap 写成了 local echo？
- 我是不是把 source-blind append 的问题推给了 adapter？
- 我有没有把 attach-time overlap 的可能性写成了当前已完全被解决？

## 5. 源码锚点

- `claude-code-source-code/src/hooks/useRemoteSession.ts`
- `claude-code-source-code/src/hooks/useAssistantHistory.ts`
- `claude-code-source-code/src/assistant/sessionHistory.ts`
- `claude-code-source-code/src/screens/REPL.tsx`
