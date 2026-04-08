# Headless print completion-init-attach pair map 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/211-completion signal、system.init dual-axis、history attach restore 与 loading edge：为什么 116、117、118、119、120、121 不是线性后续页，而是三组相邻配对分叉.md`
- `05-控制面深挖/116-success result ignored、error result visible、isSessionEndMessage、setIsLoading(false) 与 permission pause：为什么 direct connect 的 visible result、turn-end 判定与 busy state 不是同一种 completion signal.md`
- `05-控制面深挖/119-sendMessage、onPermissionRequest、onAllow、result、cancelRequest 与 onDisconnected：为什么 direct connect 的 setIsLoading(true_false) 不是同一种 loading lifecycle.md`
- `05-控制面深挖/117-buildSystemInitMessage、SDKSystemMessage(init)、useDirectConnect 去重、convertInitMessage 与 onInit：为什么 callback-visible init、transcript init 提示与 slash bootstrap 不是同一种初始化可见性.md`
- `05-控制面深挖/120-buildSystemInitMessage、QueryEngine、useReplBridge、convertInitMessage 与 redaction：为什么 full init payload、bridge redacted init 与 transcript model-only banner 不是同一种 init payload thickness.md`
- `05-控制面深挖/118-convertUserTextMessages、sentUUIDsRef、fetchLatestEvents(anchor_to_latest)、pageToMessages 与 source-blind append：为什么 viewerOnly 的本地 echo 去重、history attach overlap 与 transcript 追加不是同一种 replay dedup.md`
- `05-控制面深挖/121-useAssistantHistory、fetchLatestEvents(anchor_to_latest)、pageToMessages、useRemoteSession onInit 与 handleRemoteInit：为什么 history init banner 回放与 live slash 恢复不是同一种 attach 恢复语义.md`

边界先说清：

- 这页不是 116-121 的细节证明总集。
- 这页不替代 211 的结构长文。
- 这页只抓“116/119、117/120、118/121 是三组相邻配对，不是一条线”的阅读图。
- 这页保护的是 completion、`system.init`、attach/replay 三个主语的分裂，不把 exact helper 名、feature gate 或当前 hook 顺序直接升级成稳定公共合同。

## 1. 配对图总表

| 节点 | 作用 | 在图上的位置 |
| --- | --- | --- |
| 211 | 解释 116-121 的三组相邻配对分叉 | 结构收束页 |
| 116 | 先分 visible outcome、turn-end classifier 与 busy-state 不是同一种 completion signal | completion / waiting 配对页 |
| 119 | 继续把 loading 本身拆成 start / pause / resume / release / teardown 多 edge | completion / waiting 配对页 |
| 117 | 先分 raw init、callback-visible、transcript-visible 与 bootstrap-visible | `system.init` 双轴配对页 |
| 120 | 继续分 full payload、redacted payload、hidden thickness 与 transcript banner | `system.init` 双轴配对页 |
| 118 | 先分 visibility、local echo dedup、history/live overlap 与 sink append/prepend | attach / replay 配对页 |
| 121 | 继续分 transcript replay 与 live bootstrap restore | attach / replay 配对页 |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| 116-121 都在讲远端后续状态，所以顺着编号一路读就行 | 它们更稳的是三组配对：`116/119`、`117/120`、`118/121` |
| 119 只是 116 的 loading 附录 | 116 在拆跨层 completion，119 在拆 busy-state 自己的 edge 语义 |
| 120 只是 117 的 init 附录 | 117 在问谁看见 init，120 在问 init 有多厚 |
| 121 只是 118 的 replay 附录 | 118 在问 attach wiring 与 dedup，121 在问 transcript restore 与 bootstrap restore |
| attach 后看见 init banner，就等于 slash/bootstrap 已恢复 | banner 只证明 transcript replay；bootstrap 要看 live `onInit(...)` |
| success `result` ignored，所以它不算 completion | transcript 静默不影响它参与 turn-end / busy-state 收口 |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | `result` 先进入 callback，再被 adapter 做 transcript policy；同一 loading flag 可承载多 edge；`system.init` 首先是 public SDK object；history hook 当前只做 replay，live hook 才做 raw init bootstrap；同一 adapter 不等于同一 restore 语义 |
| 条件公开 | success `result` 当前是否静默、bridge 是否发 init、bridge redaction 宽度、history/live 是否真的重叠、attach 后 live init 是否一定再到 |
| 内部/灰度层 | `tengu_bridge_system_init`、`messaging_socket_path`、`plugins[].source`、`hasReceivedInitRef`、`sentUUIDsRef` ring、大多数 exact helper 顺序与 backlog 细节 |

## 4. 六个检查问题

- 我现在写的是 completion / waiting、`system.init`，还是 attach / replay？
- 我是不是把同一个 bool、同一个 object、同一个 adapter 偷换成了同一种控制语义？
- 我现在说的是谁看见它，还是它有多厚？
- 我是不是把 transcript-visible 痕迹偷换成了 bootstrap / command-surface 已恢复？
- 我是不是把 host-local dedupe、bridge gate、history/live 重叠这些当前实现证据抬成了稳定合同？
- 我有没有把 `116/119`、`117/120`、`118/121` 又写回成一条线性后继链？

## 5. 源码锚点

- `claude-code-source-code/src/hooks/useDirectConnect.ts`
- `claude-code-source-code/src/hooks/useSSHSession.ts`
- `claude-code-source-code/src/remote/sdkMessageAdapter.ts`
- `claude-code-source-code/src/utils/messages/systemInit.ts`
- `claude-code-source-code/src/hooks/useReplBridge.tsx`
- `claude-code-source-code/src/hooks/useRemoteSession.ts`
- `claude-code-source-code/src/hooks/useAssistantHistory.ts`
- `claude-code-source-code/src/assistant/sessionHistory.ts`
