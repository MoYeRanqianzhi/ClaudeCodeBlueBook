# callback visible vs adapter triad vs hook sink 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/114-convertSDKMessage、useDirectConnect、stream_event 与 ignored：为什么 UI consumer 的三分法不是 callback surface 的镜像映射.md`
- `05-控制面深挖/111-controlSchemas、agentSdkTypes、directConnectManager、useDirectConnect 与 sdkMessageAdapter：为什么 builder transport、callback surface 与 UI consumer 不是同一张可见性表.md`
- `05-控制面深挖/113-result、structured_output、permission_denials、lastMessage 与 gracefulShutdownSync：为什么 streamlined path 的 passthrough 不是 terminal semantic 主位保留.md`

边界先说清：

- 这页不是 sdkMessageAdapter 总论。
- 这页不替代 111 对多层 visibility table 的拆分。
- 这页不替代 113 对 result 语义差异的拆分。
- 这页只抓 callback-visible、adapter triad 与 hook sink 为什么不是同一层。

## 1. 四层对象总表

| 层级 | 在这里回答什么 | 更接近什么 |
| --- | --- | --- |
| `onMessage(sdkMessage)` | 哪些对象进入 direct-connect callback | callback-visible surface |
| `convertSDKMessage(...)` | callback 对象该怎么给 UI 分类 | adapter triad |
| `converted.type === 'message'` | 当前 hook 真正喂进正文什么 | hook sink |
| 其余结果 | 是否走 stream side-channel 或被忽略 | non-transcript consumer result |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| adapter triad 只是 callback surface 的换名显示 | triad 是 consumer classification，不是 membership mirror |
| `ignored` 就说明对象不属于 callback surface | success `result` 就是 callback-visible 但 adapter-ignored |
| `stream_event` 进入 triad，就等于当前 hook 会消费它 | `useDirectConnect` 当前只把 `message` 喂进正文 |
| `user` / `system` 的条件映射说明 callback union 本身不稳定 | 条件性体现在 UI policy，不在 callback membership |
| triad 已经等于最终 UI 全部可见性 | triad 后还有 hook-specific sink decision |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | callback 先于 adapter；adapter 先于 hook sink；success `result` callback-visible 但 adapter-ignored |
| 条件公开 | 某些 `user` / `system` subtype 是否进 `message` 取决于 adapter options 和 host policy；`stream_event` 是否被后续消费也取决于具体 hook |
| 内部/灰度层 | triad 是否被其他宿主复用、更多 consumer 分类是否存在、忽略某些 subtype 的更深产品理由 |

## 4. 六个检查问题

- 当前说的是 callback-visible，还是 UI-visible？
- 我是不是把 triad 写成了 callback union 的镜像？
- 我是不是把 `ignored` 写成了“不属于 callback”？
- 我是不是忘了当前 hook 只消费 `message`？
- 我有没有把 111 的表栈重讲，而没继续压到 triad 这一层？
- 我是不是又把 host-specific policy 写成了 universal rule？

## 5. 源码锚点

- `claude-code-source-code/src/hooks/useDirectConnect.ts`
- `claude-code-source-code/src/remote/sdkMessageAdapter.ts`
- `claude-code-source-code/src/server/directConnectManager.ts`
