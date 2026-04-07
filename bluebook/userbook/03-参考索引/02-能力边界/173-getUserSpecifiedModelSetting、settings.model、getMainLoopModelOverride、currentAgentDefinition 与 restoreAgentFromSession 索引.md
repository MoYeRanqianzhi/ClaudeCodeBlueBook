# `getUserSpecifiedModelSetting`、`settings.model`、`getMainLoopModelOverride`、`currentAgentDefinition` 与 `restoreAgentFromSession` 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/184-getUserSpecifiedModelSetting、settings.model、getMainLoopModelOverride、currentAgentDefinition 与 restoreAgentFromSession：为什么 persisted model preference、live override 与 resumed-agent fallback 不是同一种 model authority.md`
- `05-控制面深挖/182-session_context.model、metadata.model、lastModelUsage、modelUsage 与 restoreAgentFromSession：为什么 create-time model stamp、live override shadow、durable usage ledger 与 resumed-agent fallback 不是同一种 model ledger.md`
- `05-控制面深挖/107-model、externalMetadataToAppState、setMainLoopModelOverride 与 restoredWorkerState：为什么 metadata 里的 model 不是普通 AppState 回填项.md`

边界先说清：

- 这页不是 model ledger 总页。
- 这页不是 metadata readback 总页。
- 这页只抓 persisted preference、live override 与 resumed-agent fallback 的主权顺序。

## 1. 三层 authority

| 对象 | 当前更像什么 | 关键消费面 |
| --- | --- | --- |
| `settings.model` | persisted preference | settings 存储 |
| `getMainLoopModelOverride()` | live runtime authority | `getUserSpecifiedModelSetting()` |
| `restoreAgentFromSession(...).model` | resumed-agent fallback | resume path |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `settings.model` 就是当前 runtime model | 它只是 persisted preference |
| override 只是 settings 的内存镜像 | override 拥有更高 runtime 主权 |
| resumed agent model 会无条件恢复旧 session 的 model | 它先被 `currentAgentDefinition` 和现有 override 短路 |
| 三者都能影响 `getMainLoopModel()`，所以属于同一 authority | preference / authority / fallback 分属不同优先级层 |

## 3. stable / conditional / gray

| 类型 | 对象 |
| --- | --- |
| 专题内稳定不变量 | settings = persisted preference；override = live authority；agent restore = fallback |
| 条件公开 | `currentAgentDefinition` 存在时直接短路；无 override 且 agent model 非 `inherit` 时才补位 |
| 内部/灰度层 | env var / provider 默认分支、UI 胶水、未来 resume precedence 细节 |

## 4. 五个检查问题

- 当前值是在持久化偏好、夺取当前主权，还是在更强主权缺席时兜底？
- 当前路径会不会被 `currentAgentDefinition` 直接短路？
- 我是不是把 182 的多账本页误写成一张 authority 顺序表？
- 我是不是又把 107 的 metadata sink 问题带回来了？
- 我是不是把 resumed-agent model 写成“同义恢复”，而不是 fallback？

## 5. 源码锚点

- `claude-code-source-code/src/utils/model/model.ts`
- `claude-code-source-code/src/state/onChangeAppState.ts`
- `claude-code-source-code/src/bootstrap/state.ts`
- `claude-code-source-code/src/utils/sessionRestore.ts`
- `claude-code-source-code/src/screens/ResumeConversation.tsx`
- `claude-code-source-code/src/screens/REPL.tsx`
