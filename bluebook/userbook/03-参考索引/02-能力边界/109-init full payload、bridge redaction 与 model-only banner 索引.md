# init full payload、bridge redaction 与 model-only banner 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/120-buildSystemInitMessage、QueryEngine、useReplBridge、convertInitMessage 与 redaction：为什么 full init payload、bridge redacted init 与 transcript model-only banner 不是同一种 init payload thickness.md`
- `05-控制面深挖/117-buildSystemInitMessage、SDKSystemMessage(init)、useDirectConnect 去重、convertInitMessage 与 onInit：为什么 callback-visible init、transcript init 提示与 slash bootstrap 不是同一种初始化可见性.md`
- `05-控制面深挖/119-sendMessage、onPermissionRequest、onAllow、result、cancelRequest 与 onDisconnected：为什么 direct connect 的 setIsLoading(true_false) 不是同一种 loading lifecycle.md`

边界先说清：

- 这页不是 init 字段总表。
- 这页不替代 117 的 init visibility 拆分。
- 这页不替代后续 attach 恢复语义专题。
- 这页只抓 full payload、bridge redaction、internal hidden field 与 transcript banner 为什么不是同一种 init payload thickness。

## 1. 四种厚度

| 厚度层 | 当前回答什么 | 典型例子 |
| --- | --- | --- |
| public full payload | 标准 SDK consumer 能拿到哪些 init metadata | `QueryEngine -> buildSystemInitMessage(full inputs)` |
| host-redacted payload | 某类宿主可安全拿到哪些字段 | `useReplBridge` redacted init |
| internal extra thickness | feature-gated 内部字段是否附着在同一对象上 | `messaging_socket_path` |
| transcript banner | 用户在正文里最终看到什么 | `convertInitMessage(...)` |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| bridge init 只是 full init 的转发副本 | bridge init 受 gate 控制且输入被 redaction |
| transcript 里有 init 提示，就等于看见了 init payload | banner 只保留 model，不是 full metadata |
| 同一个 builder 说明 payload 厚度一致 | 同一个 builder 也能因 inputs 不同而产出不同厚度 |
| public schema 就是 init 的全部厚度 | feature 下还可能附着 hidden field |
| bridge redaction 和 transcript 压缩只是同一种“少一点” | 一个是 object-level thinning，一个是 prompt-level collapsing |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | builder 定义的是厚 metadata contract；QueryEngine 当前走 full inputs；transcript 当前只保留 model |
| 条件公开 | bridge init 受 `tengu_bridge_system_init` gate 控制；bridge fields 被 redaction 的宽度依宿主策略而定 |
| 内部/灰度层 | `UDS_INBOX` hidden field、未来是否扩大 banner 字段、bridge redaction 是否继续调整 |

## 4. 五个检查问题

- 当前写的是 full object、redacted object，还是 transcript banner？
- 我是不是把 bridge init 写成了 full payload 副本？
- 我是不是把 banner 写成了 metadata 可见性？
- 我是不是把 public schema 当成了全部厚度？
- 我有没有把宿主输入裁剪写成 universal contract？

## 5. 源码锚点

- `claude-code-source-code/src/utils/messages/systemInit.ts`
- `claude-code-source-code/src/QueryEngine.ts`
- `claude-code-source-code/src/hooks/useReplBridge.tsx`
- `claude-code-source-code/src/remote/sdkMessageAdapter.ts`
