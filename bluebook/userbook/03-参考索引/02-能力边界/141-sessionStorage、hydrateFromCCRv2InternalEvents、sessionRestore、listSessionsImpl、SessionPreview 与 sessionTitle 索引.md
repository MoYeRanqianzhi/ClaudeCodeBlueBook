# `sessionStorage`、`hydrateFromCCRv2InternalEvents`、`sessionRestore`、`listSessionsImpl`、`SessionPreview` 与 `sessionTitle` 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/152-sessionStorage、hydrateFromCCRv2InternalEvents、sessionRestore、listSessionsImpl、SessionPreview 与 sessionTitle：为什么 durable session metadata 不是 live system-init，也不是 foreground external-metadata.md`
- `05-控制面深挖/117-buildSystemInitMessage、SDKSystemMessage(init)、useDirectConnect 去重、convertInitMessage 与 onInit：为什么 callback-visible init、transcript init 提示与 slash bootstrap 不是同一种初始化可见性.md`
- `05-控制面深挖/120-buildSystemInitMessage、QueryEngine、useReplBridge、convertInitMessage 与 redaction：为什么 full init payload、bridge redacted init 与 transcript model-only banner 不是同一种 init payload thickness.md`
- `05-控制面深挖/133-pending_action、post_turn_summary、task_summary 与 externalMetadataToAppState：为什么 schema-store 里有账，不等于当前前台已经消费.md`

边界先说清：

- 这页不是 session metadata 字段总表。
- 这页不是 init 可见性或 payload 厚度的改写版。
- 这页只抓 durable session metadata 为什么是一张独立于 `system/init` 与 `external_metadata` 的 ledger。

## 1. 三张 metadata 账

| 账 | 当前更像什么 | 关键对象 |
| --- | --- | --- |
| startup publish 账 | 启动时愿意公开什么 | `system/init` |
| live runtime 账 | 当前运行态在说什么 | `external_metadata`、`SessionExternalMetadata` |
| durable session 账 | EOF / history / resume 后仍要被读回什么 | `sessionStorage`、`reAppendSessionMetadata()`、tail metadata |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| 三者都叫 metadata，所以本质是一张表 | 三者分别对应 publish、runtime、durable 三种合同 |
| `reAppendSessionMetadata()` 只是重复写一次 | 它是在保全 tail-window durable ledger |
| foreground 没消费，就说明这张 metadata 没意义 | session list / preview / resume 仍可能读它 |
| `system/init.session_id` / `external_metadata` 足以代表会话后续信息 | durable session ledger 负责 EOF 后还可回读的会话身份与摘要面 |

## 3. post-session consumer 速查

| consumer | 当前主要读哪张账 |
| --- | --- |
| `resume` / `sessionRestore` | durable session ledger |
| `listSessionsImpl` | durable tail metadata + head/tail lite read |
| `SessionPreview` | transcript / durable log |
| foreground runtime UI | `system/init` + `external_metadata` + local app state |

## 4. stable / conditional / gray

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | `system/init`、`external_metadata`、durable session ledger 是三张不同账 |
| 条件公开 | 某些字段是否被 durable re-append，取决于缓存与写盘路径 |
| 内部/灰度层 | CCR v2 internal-event hydrate 将来还会把哪些 metadata 纳入 durable restore，仍可能调整 |

## 5. 五个检查问题

- 我现在写的是 startup publish、live runtime，还是 durable ledger？
- 我是不是把 `reAppendSessionMetadata()` 误写成重复写盘？
- 我是不是忽略了 session list / preview / resume 这些后读 consumer？
- 我是不是把 `external_metadata` 和 durable session metadata 混成一张账？
- 我是不是又把这页写回 117/120/133 的变体？

## 6. 源码锚点

- `claude-code-source-code/src/utils/sessionStorage.ts`
- `claude-code-source-code/src/utils/sessionRestore.ts`
- `claude-code-source-code/src/utils/listSessionsImpl.ts`
- `claude-code-source-code/src/components/SessionPreview.tsx`
- `claude-code-source-code/src/utils/sessionTitle.ts`
- `claude-code-source-code/src/utils/sessionState.ts`
