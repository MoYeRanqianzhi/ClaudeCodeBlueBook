# Headless print builder-callback-UI branch map 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/210-builder transport、callback surface、streamlined dual-entry 与 UI consumer policy：为什么 111、112、113、114、115 不是并列细页，而是先定四层可见性表，再分叉到 streamlined 与 adapter 两条后继线.md`
- `05-控制面深挖/111-controlSchemas、agentSdkTypes、directConnectManager、useDirectConnect 与 sdkMessageAdapter：为什么 builder transport、callback surface 与 UI consumer 不是同一张可见性表.md`
- `05-控制面深挖/112-shouldIncludeInStreamlined、assistant-result 双入口、streamlined_* 与 null：为什么 streamlined path 的纳入 gate、替换入口与抑制返回不是同一种消息简化.md`
- `05-控制面深挖/113-result、structured_output、permission_denials、lastMessage 与 gracefulShutdownSync：为什么 streamlined path 的 passthrough 不是 terminal semantic 主位保留.md`
- `05-控制面深挖/114-convertSDKMessage、useDirectConnect、stream_event 与 ignored：为什么 UI consumer 的三分法不是 callback surface 的镜像映射.md`
- `05-控制面深挖/115-convertToolResults、convertUserTextMessages、useAssistantHistory、viewerOnly 与 success result ignored：为什么 tool_result 本地补画、user text 历史回放与成功结果静默不是同一种 UI consumer policy.md`

边界先说清：

- 这页不是 111-115 的细节证明总集。
- 这页不替代 210 的分叉结构页。
- 这页只抓“111 是根页，`112→113` 是 streamlined 支线，`114→115` 是 adapter/UI consumer 支线”的阅读图。
- 这页保护的是层级收窄与 policy 分裂，不把 exact helper 名、exact chain 或当前 hook sink 直接提升成稳定公共合同。

## 1. 分叉图总表

| 节点 | 作用 | 在图上的位置 |
| --- | --- | --- |
| 111 | 先分 builder transport、public SDK、callback surface 与 UI consumer 不是同一张表 | 根页 |
| 210 | 解释 111-115 的分叉关系 | 结构收束页 |
| 112 | 先分 streamlined path 的 gate / replacement / suppression | streamlined 支线 |
| 113 | 解释 `result` passthrough 为什么不等于 terminal primacy | 112 的叶子 |
| 114 | 先分 callback-visible、adapter triad 与 hook sink | adapter 支线 |
| 115 | 解释 adapter 内三种 policy 为什么方向不同 | 114 的叶子 |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| 111-115 都在讲 callback/adapter/streamlined，所以可以按兴趣并列读 | 111 是根页；`112→113` 是 streamlined 支线；`114→115` 是 adapter/UI consumer 支线 |
| 112 只是 111 的 streamlined 附录 | 112 在分动作 taxonomy，不在补可见性表 |
| 113 只是 112 的 result 附录 | 113 在分 payload passthrough 与 terminal primacy 的 preservation reason |
| 114 只是 111 的 UI 版翻译 | 114 在分 callback-visible 与 UI classification |
| 115 只是 114 的细节补丁 | 115 在分 adapter 内三种不同方向的 consumer policy |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | 在当前切片里以 builder/control transport、public SDK、callback-visible surface 与前台 UI consumer 四层表来读最稳；更宽层可承载，不等于更窄层必消费；streamlined path 里同为纳入对象也不等于同一种动作；callback-visible 不等于 UI-visible；adapter 内至少有三种不同方向的 consumer policy |
| 条件公开 | 某些 policy 只在 direct connect、history replay、viewerOnly 或 gate 打开时成立 |
| 内部/灰度层 | exact helper 名、exact chain、dedup 细节、option 开关、host wiring 与具体顺序 |

## 4. 六个检查问题

- 我现在卡住的是 111 的四层表，还是 `112→113` 支线，还是 `114→115` 支线？
- 我现在在问对象属于哪一层，还是某个 consumer 如何对它做动作/分类？
- 我是不是把 callback-visible 误写成了 UI-visible？
- 我是不是把 same inclusion 写成了 same simplification？
- 我是不是把同在 adapter 里写成了同一种 policy？
- 我有没有把 111 的总表结论直接重讲，而没继续压到支线主语？

## 5. 源码锚点

- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts`
- `claude-code-source-code/src/entrypoints/agentSdkTypes.ts`
- `claude-code-source-code/src/server/directConnectManager.ts`
- `claude-code-source-code/src/hooks/useDirectConnect.ts`
- `claude-code-source-code/src/remote/sdkMessageAdapter.ts`
- `claude-code-source-code/src/utils/streamlinedTransform.ts`
