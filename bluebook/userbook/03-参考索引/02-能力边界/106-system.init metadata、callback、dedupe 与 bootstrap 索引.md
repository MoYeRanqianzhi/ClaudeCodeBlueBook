# system.init metadata、callback、dedupe 与 bootstrap 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/117-buildSystemInitMessage、SDKSystemMessage(init)、useDirectConnect 去重、convertInitMessage 与 onInit：为什么 callback-visible init、transcript init 提示与 slash bootstrap 不是同一种初始化可见性.md`
- `05-控制面深挖/116-success result ignored、error result visible、isSessionEndMessage、setIsLoading(false) 与 permission pause：为什么 direct connect 的 visible result、turn-end 判定与 busy state 不是同一种 completion signal.md`
- `05-控制面深挖/111-controlSchemas、agentSdkTypes、directConnectManager、useDirectConnect 与 sdkMessageAdapter：为什么 builder transport、callback surface 与 UI consumer 不是同一张可见性表.md`

边界先说清：

- 这页不是 init metadata 字段总表。
- 这页不替代 111 的 visibility table 总论。
- 这页不替代后续 replay/dedup 专题。
- 这页只抓 raw init object、callback-visible init、host dedupe、transcript prompt 与 slash bootstrap 为什么不是同一种初始化可见性。

## 1. 五层 init visibility

| 层级 | 当前回答什么 | 典型例子 |
| --- | --- | --- |
| SDK metadata visibility | init object 本来带什么 session metadata | `SDKSystemMessage(init)` / `buildSystemInitMessage(...)` |
| host-projected payload visibility | 不同宿主是否发同样厚度的 init payload | `useReplBridge` gate + redaction |
| callback visibility | 哪些 hook 能先拿到 raw init | direct-connect manager `onMessage(parsed)` |
| transcript visibility | 用户在正文里看到什么 init 提示 | `convertInitMessage(...)` |
| capability bootstrap visibility | 哪些 consumer 直接吃 raw init 做 UI 初始化 | `onInit(sdkMessage.slash_commands)` |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `system.init` 在 direct connect 里只出现一次 | 当前 hook 只消费第一次；server 注释说明 one per turn |
| init prompt 就是 init metadata 的普通显示 | `convertInitMessage(...)` 只保留 model 提示 |
| 历史里能看到 init message，就等于 bootstrap 也恢复了 | replay transcript 和 raw init bootstrap 是不同 consumer |
| public SDK init 在所有宿主里天然同宽 | bridge init 还会受 feature gate 和 redaction 影响 |
| callback-visible init 就等于用户看到了初始化内容 | callback 后还有 dedupe、adapter、sink 收窄 |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | `system.init` 是 public SDK schema 成员；direct connect callback 当前会收到它；`convertInitMessage(...)` 当前只投影 model；`useRemoteSession` 当前会从 raw init 提取 `slash_commands` |
| 条件公开 | bridge 是否发 init 受 `tengu_bridge_system_init` gate 控制；bridge payload 是否 redacted 取决于宿主路径 |
| 内部/灰度层 | 后续是否扩大 transcript prompt 保留字段、viewer/history 是否补做 bootstrap、副通道是否继续复用同一 init contract |

## 4. 五个检查问题

- 当前写的是 metadata object、callback、transcript，还是 bootstrap？
- 我是不是把 dedupe 写成了对象本体只出现一次？
- 我是不是把 init prompt 写成了 full metadata projection？
- 我是不是把 bootstrap 当成 transcript 副作用？
- 我有没有把 host-specific init payload 宽度写成 universal rule？

## 5. 源码锚点

- `claude-code-source-code/src/utils/messages/systemInit.ts`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts`
- `claude-code-source-code/src/server/directConnectManager.ts`
- `claude-code-source-code/src/hooks/useDirectConnect.ts`
- `claude-code-source-code/src/hooks/useRemoteSession.ts`
- `claude-code-source-code/src/hooks/useReplBridge.tsx`
