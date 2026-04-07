# `worker_status`、`external_metadata`、`AppState shadow` 与 SDK event projection 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/132-worker_status、external_metadata、AppState shadow 与 SDK event projection：为什么 bridge 能形成 transcript-footer-dialog-store 对齐，而 direct connect、remote session 更多只是前台事件投影.md`
- `05-控制面深挖/28-remote 会话、session 命令、assistant viewer 与 remote-safe commands：为什么远端会话 client、viewer 与 bridge host 不是同一种远程工作流.md`
- `05-控制面深挖/130-remoteSessionUrl、brief line、bridge pill、bridge dialog 与 attached viewer：为什么它们不是同一种 surface presence.md`
- `05-控制面深挖/131-warning transcript、remoteConnectionStatus、remoteBackgroundTaskCount 与 brief line：为什么 remote session 的四类可见信号分属四张账，而不是同一张 remote status table.md`

边界先说清：

- 这页不是 workflow shape 页。
- 这页不是 surface presence 页。
- 这页不是 remote status ledger 页。
- 这页只抓三条链路为什么不是同一种 front-state consumer。

## 1. 三种前台消费形态

| 链路 | 当前最像什么 | 典型消费面 |
| --- | --- | --- |
| direct connect | transcript projection + permission queue | transcript、审批队列、stderr 断线退出 |
| remote session | event projection + partial `AppState` shadow | transcript、`remoteConnectionStatus`、`remoteBackgroundTaskCount`、少量 footer |
| bridge | authoritative state + local shadow + multi-surface alignment | transcript、footer pill、dialog、worker-side store |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| 有 transcript banner / status line 就说明这条链路已经消费了正式运行态 | transcript 可能只是 event projection |
| remote session 有几个 `AppState` 字段，就说明它和 bridge 一样完整 | remote session 当前只是 partial shadow |
| direct connect 没有 dedicated footer / dialog 就说明它没有状态 | 它仍有 transcript projection 和 permission queue，只是 topology 更薄 |
| bridge 一定无条件具备 transcript/footer/dialog/store 四面对齐 | v1 / v2 在 `reportState/reportMetadata` 上有条件差异 |
| `post_turn_summary` / `task_summary` 出现在 schema/store，就说明前台一定已经消费 | producer 存在不等于 consumer 已接上 |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | `SessionState` / `SessionExternalMetadata` 是正式运行态；direct connect 主要是 transcript + permission queue；remote session 主要是 event projection + partial shadow；bridge 最接近 multi-surface alignment |
| 条件公开 | bridge 的 worker-side state upload 依赖 v2；remote session transcript 厚度受 `viewerOnly` 与 adapter 过滤影响；direct connect 当前显式过滤 `post_turn_summary` |
| 内部/灰度层 | `post_turn_summary` / `task_summary` 哪些前台 consumer 还没接上；direct connect 缺少 dedicated local store 的强推断；bridge 一些产品策略细节 |

## 4. 五个检查问题

- 我现在写的是 authoritative state，还是 event projection？
- 我是不是把 partial shadow 写成了完整前台状态体系？
- 我是不是把 v2 的完整链路偷换成了 bridge 的全时稳定合同？
- 我是不是把 schema/store 里存在的字段自动当成前台已消费？
- 我是不是把 130 的 surface 或 131 的 ledger 误写成这页的主结论？

## 5. 源码锚点

- `claude-code-source-code/src/utils/sessionState.ts`
- `claude-code-source-code/src/cli/remoteIO.ts`
- `claude-code-source-code/src/cli/transports/ccrClient.ts`
- `claude-code-source-code/src/cli/transports/WorkerStateUploader.ts`
- `claude-code-source-code/src/server/directConnectManager.ts`
- `claude-code-source-code/src/hooks/useDirectConnect.ts`
- `claude-code-source-code/src/remote/sdkMessageAdapter.ts`
- `claude-code-source-code/src/hooks/useRemoteSession.ts`
- `claude-code-source-code/src/bridge/replBridgeTransport.ts`
- `claude-code-source-code/src/bridge/remoteBridgeCore.ts`
- `claude-code-source-code/src/hooks/useReplBridge.tsx`
- `claude-code-source-code/src/state/onChangeAppState.ts`
