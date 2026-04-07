# `pending_action`、`post_turn_summary`、`task_summary` 与 `externalMetadataToAppState` 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/133-pending_action、post_turn_summary、task_summary 与 externalMetadataToAppState：为什么 schema-store 里有账，不等于当前前台已经消费.md`
- `05-控制面深挖/132-worker_status、external_metadata、AppState shadow 与 SDK event projection：为什么 bridge 能形成 transcript-footer-dialog-store 对齐，而 direct connect、remote session 更多只是前台事件投影.md`

边界先说清：

- 这页不是三条链路的总对比页。
- 这页不替代 132。
- 这页只抓字段级 producer/store/restore/consumer 为什么不是同一层。

## 1. 四层问题

| 层 | 当前问题 |
| --- | --- |
| schema/type | 这些字段有没有正式定义 |
| worker store | 这些字段有没有真的被写进 `external_metadata` |
| local restore | 这些字段有没有被恢复进本地 `AppState` |
| foreground consumer | 当前 CLI 前台有没有真的消费这些字段 |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| schema 里有，就说明 CLI 前台已支持 | schema/type contract 不等于 foreground consumer contract |
| 写进 `external_metadata`，就说明本地 `AppState` 已恢复 | `externalMetadataToAppState()` 当前只恢复少数 key |
| restore 读回 metadata，就说明 transcript/footer/dialog 会显示 | restore、state shadow、UI consumer 是三层问题 |
| `post_turn_summary` 只是“没做 UI” | 当前若干前台链路已显式过滤 / 忽略它 |
| 注释里说 frontend 会读，所以当前 CLI 一定已读 | 注释没有保证 frontend = 当前 CLI |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | `SessionExternalMetadata` 定义了这些 key；`pending_action/task_summary` 当前会进 worker-side store；`externalMetadataToAppState()` 当前只恢复 `permission_mode/is_ultraplan_mode`，`model` 走单独恢复 |
| 条件公开 | `post_turn_summary` 的前台可见性取决于各自过滤链；bridge v2 才真正上传 metadata state；restore 只在特定 hydrate/readback 条件下运行 |
| 内部/灰度层 | 哪个 frontend 会读 `pending_action.input/task_summary` 当前在本仓 CLI 里不清楚；未来是否接上 CLI consumer 仍属演化空间 |

## 4. 五个检查问题

- 我现在写的是 schema contract，还是 current CLI contract？
- 我是不是把 store persistence 偷换成了 local restore？
- 我是不是把 local restore 又偷换成了 foreground rendering？
- 我是不是把“当前没看到 consumer”写成了“永远不会有 consumer”？
- 我是不是又回到 132 的三链路大对比，而没有把边界压到字段级？

## 5. 源码锚点

- `claude-code-source-code/src/utils/sessionState.ts`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts`
- `claude-code-source-code/src/cli/remoteIO.ts`
- `claude-code-source-code/src/cli/transports/ccrClient.ts`
- `claude-code-source-code/src/cli/transports/WorkerStateUploader.ts`
- `claude-code-source-code/src/state/onChangeAppState.ts`
- `claude-code-source-code/src/cli/print.ts`
- `claude-code-source-code/src/server/directConnectManager.ts`
- `claude-code-source-code/src/remote/sdkMessageAdapter.ts`
