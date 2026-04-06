# tool_result 本地补画、history user replay 与 success result 静默索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/115-convertToolResults、convertUserTextMessages、useAssistantHistory、viewerOnly 与 success result ignored：为什么 tool_result 本地补画、user text 历史回放与成功结果静默不是同一种 UI consumer policy.md`
- `05-控制面深挖/114-convertSDKMessage、useDirectConnect、stream_event 与 ignored：为什么 UI consumer 的三分法不是 callback surface 的镜像映射.md`
- `05-控制面深挖/111-controlSchemas、agentSdkTypes、directConnectManager、useDirectConnect 与 sdkMessageAdapter：为什么 builder transport、callback surface 与 UI consumer 不是同一张可见性表.md`

边界先说清：

- 这页不是 `sdkMessageAdapter` 全景总论。
- 这页不替代 114 对 callback-visible / triad / sink 的拆分。
- 这页不替代后续对 completion signal 的拆分。
- 这页只抓 adapter 内三种最容易被误并的 consumer policy。

## 1. 三种 policy 对照表

| policy | 主要对象 | 典型宿主/时机 | 真正解决的问题 |
| --- | --- | --- | --- |
| `convertToolResults` | remote `user` 里的 `tool_result` blocks | direct connect、viewerOnly、history replay | 把远端 tool result 补成本地可渲染、可折叠的 tool result message |
| `convertUserTextMessages` | 历史/回放中的普通 user text | assistant history、viewerOnly attach | 把本地没创建过的 user text 补回消息面，同时处理 echo duplicate 风险 |
| success `result -> ignored` | `result` subtype=`success` | multi-turn transcript consumer | 压掉冗余成功收口噪音，不再额外写一条正文消息 |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `convertToolResults` 和 `convertUserTextMessages` 只是同一个“打开 user 消息”的开关 | 前者补 tool result render parity，后者补 history user replay |
| `convertUserTextMessages` 既然存在，live direct connect 也应默认开启 | live path 本地已创建 user text，打开会引入 echo duplicate 风险 |
| success `result` 既然 `ignored`，就说明它没有消费价值 | 它仍可先参与 session-end / loading 收口，只是 transcript 被静默 |
| 这三者都在 adapter 里，所以属于同一种过滤 | 两个在补缺口，一个在压噪音，方向不同 |
| viewerOnly 同时开两项 option，所以两项 option 没有边界 | viewerOnly 同时面对 tool result 缺口和 user text 缺口，是并列问题，不是同一问题 |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | direct connect 当前只开 `convertToolResults`；assistant history / viewerOnly 当前会同时开两项 option；success `result` transcript 静默不等于状态层不用它 |
| 条件公开 | `convertUserTextMessages` 何时开启取决于 host 是 live 还是 replay/viewer；success result 是否静默属于当前 transcript policy |
| 内部/灰度层 | 未来是否增加新的 consumer 分类、是否调整 success noise 策略、其他宿主是否复用同样组合 |

## 4. 五个检查问题

- 当前说的是 render parity、replay completeness，还是 noise suppression？
- 我是不是把 history replay 写成了 live prompt echo？
- 我是不是把 success `result` 的静默写成了“整体不重要”？
- 我是不是忘了 direct connect 当前只开了 `convertToolResults`？
- 我有没有把 adapter 内的 host-specific policy 写成 universal rule？

## 5. 源码锚点

- `claude-code-source-code/src/remote/sdkMessageAdapter.ts`
- `claude-code-source-code/src/hooks/useDirectConnect.ts`
- `claude-code-source-code/src/hooks/useAssistantHistory.ts`
- `claude-code-source-code/src/hooks/useRemoteSession.ts`
