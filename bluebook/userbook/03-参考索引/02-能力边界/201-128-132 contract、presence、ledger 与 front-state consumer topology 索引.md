# 128-132 contract、presence、ledger 与 front-state consumer topology 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/214-4001 contract、surface presence、status ledger 与 front-state consumer topology：为什么 128、129、130、131、132 不是线性五连，而是两段延伸加一个后继根页.md`
- `05-控制面深挖/128-SessionsWebSocket 4001、WebSocketTransport 4001 与 session not found：为什么它们不是同一种合同.md`
- `05-控制面深挖/129-headersRefreshed、autoReconnect、sleep detection 与 4003 refresh path：为什么 WebSocketTransport 的恢复主权不是 SessionsWebSocket 的镜像.md`
- `05-控制面深挖/130-remoteSessionUrl、brief line、bridge pill、bridge dialog 与 attached viewer：为什么它们不是同一种 surface presence.md`
- `05-控制面深挖/131-warning transcript、remoteConnectionStatus、remoteBackgroundTaskCount 与 brief line：为什么 remote session 的四类可见信号分属四张账，而不是同一张 remote status table.md`
- `05-控制面深挖/132-worker_status、external_metadata、AppState shadow 与 SDK event projection：为什么 bridge 能形成 transcript-footer-dialog-store 对齐，而 direct connect、remote session 更多只是前台事件投影.md`

边界先说清：

- 这页不是 `128-132` 的细节证明总集。
- 这页不替代 214 的结构长文。
- 这页只抓“`128/129` 是 contract/authority 一段，`130/131` 是 presence/ledger 一段，`132` 是后继根页”的阅读图。
- 这页保护的是 contract owner、presence signer、ledger writer 与 consumer topology 的主语切换，不把某条文案、某个 render condition 或某个 helper 名直接升级成稳定公共合同。

## 1. 结构图总表

| 节点 | 作用 | 在图上的位置 |
| --- | --- | --- |
| 214 | 解释 `128-132` 的“两段延伸 + 一个后继根页” | 结构收束页 |
| 128 | 先分 same `4001` 不等于 same contract owner | transport contract 根页 |
| 129 | 继续分 `refreshHeaders`、`autoReconnect`、sleep detection 与 caller handoff | recovery ownership zoom |
| 130 | 先分 `remoteSessionUrl`、brief、bridge、attach 为什么不是同一种 presence | surface presence 根页 |
| 131 | 继续分 warning、`remoteConnectionStatus`、`remoteBackgroundTaskCount` 与 brief line | status-ledger zoom |
| 132 | 把主语换成 formal runtime state 的前台消费结构 | front-state consumer topology 后继根页 |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `128-132` 都在讲 remote，所以顺着编号一路读就行 | 更稳的是：`128/129` 一段，`130/131` 一段，`132` 再换成后继根页 |
| same `4001` 只是在不同组件里开了不同 retry | `128` 先问的是 contract owner，不是 retry 数 |
| `129` 只是 `128` 的 header 补丁页 | `129` 在问 recovery authority 如何分层 |
| `130` 只是 remote surface 总览 | `130` 在问谁给 presence 签字 |
| warning、`remoteConnectionStatus`、`remoteBackgroundTaskCount` 与 brief line 是一张 remote status table | `131` 更稳的是三张账加一层 lossy projection |
| `132` 只是 bridge 比 remote session 多一个 dialog | `132` 在问谁真正消费 formal runtime state |
| pill / brief / warning 缺席就能直接推出 authority 缺席 | 先要问这条面是不是本来就只是 projection / summary / lazy capture |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | same `4001` 仍必须按 component-scoped contract 来读；recovery ownership 不等于 transport 自治；surface presence 必须先分 signer；warning / lifecycle / task count / brief 必须先分账；formal runtime state 与 front-state consumer topology 不是一回事 |
| 条件公开 | footer `remote` 的 lazy capture、brief line 的 gate 与本地远端计数合并、warning 的 non-`viewerOnly` 条件、bridge 的 transcript / footer / dialog 对齐条件 |
| 内部/灰度层 | exact timeout / retry 常量、`4003` refresh sequencing、bridge failure dismiss timer、`session_state_changed` env gate、exact render condition 与 upgrade nudge |

## 4. 六个检查问题

- 我现在写的是 contract、authority、presence signer、ledger writer，还是 consumer topology？
- 我现在看到的是 same wording，还是 same write path？
- 这条信号写进的是 close path、`AppState`、transcript，还是 formal runtime state？
- 我是不是把 `128/129` 的 contract 问题偷换成了 `130/131` 的 surface / ledger 问题？
- 我是不是把 `132` 重新写回“UI 更厚”的尾页，而没有先回答谁在消费 formal runtime state？
- 我有没有把某条 surface 的缺席直接写成 authority 的 opposite？

## 5. 源码锚点

- `claude-code-source-code/src/remote/SessionsWebSocket.ts`
- `claude-code-source-code/src/cli/transports/WebSocketTransport.ts`
- `claude-code-source-code/src/main.tsx`
- `claude-code-source-code/src/state/AppStateStore.ts`
- `claude-code-source-code/src/hooks/useRemoteSession.ts`
- `claude-code-source-code/src/hooks/useReplBridge.tsx`
- `claude-code-source-code/src/components/PromptInput/PromptInputFooterLeftSide.tsx`
- `claude-code-source-code/src/components/Spinner.tsx`
- `claude-code-source-code/src/utils/sessionState.ts`
- `claude-code-source-code/src/cli/remoteIO.ts`
- `claude-code-source-code/src/bridge/replBridgeTransport.ts`
