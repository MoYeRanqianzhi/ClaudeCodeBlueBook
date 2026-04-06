# Remote Control `permission_mode`、`is_ultraplan_mode` 与 `model` restore 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/52-permission_mode、is_ultraplan_mode 与 model：为什么远端恢复回填、当前本地状态与 session control request 不是同一种会话参数.md`
- `05-控制面深挖/29-Bridge Permission Callbacks、Control Request 与 Bridge-safe Commands：为什么远端的权限提示、会话控制与命令白名单不是同一种控制合同.md`
- `05-控制面深挖/51-worker_status、requires_action_details、pending_action、task_summary、post_turn_summary 与 session_state_changed：为什么远端看到的运行态不是同一张面.md`

## 1. 五类 parameter / metadata / restore 对象总表

| 对象 | 回答的问题 | 典型例子 |
| --- | --- | --- |
| `Local Runtime State` | 本地当前真实生效的参数是什么 | `toolPermissionContext.mode`、`mainLoopModel` |
| `Externalized Session Parameter` | 哪些参数会被镜像成远端可恢复 metadata | `permission_mode`、`model` |
| `Stage Flag` | 哪些只在某个阶段短暂成立 | `is_ultraplan_mode` |
| `Writeback Path` | 这些参数通过哪条链写回远端 | 中心 mode diff / 显式 notify |
| `Restore Path` | 这些参数如何从远端 metadata 回填本地 | `externalMetadataToAppState(...)` / `setMainLoopModelOverride(...)` |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `toolPermissionContext.mode` = `permission_mode` | 一个是本地运行态，一个是去噪后的远端镜像 |
| `permission_mode` = `is_ultraplan_mode` | 一个是长期参数，一个是阶段标记 |
| `model` 和 `permission_mode` 共享同一条自动写回路径 | `model` 走显式 notify，`permission_mode` 走中心 diff |
| 都能恢复 = 都走同一条 mapper | `model` 走单独 override 回填 |
| `set_model` = 全局设置默认值被改了 | 这里讲的是 session override 与远端恢复 |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | 远端可保持的 permission mode、恢复时带回的 model override、一轮 Ultraplan 的阶段标记 |
| 条件公开 | `permission_mode` 的外化去噪、`is_ultraplan_mode` 的一次性真值、CCR v2 resume metadata 回填 |
| 内部/实现层 | `externalMetadataToAppState(...)`、`toExternalPermissionMode(...)`、SDK status stream 旁支、override 胶水细节 |

## 4. 六个高价值判断问题

- 当前说的是本地运行态、远端镜像态，还是恢复回填态？
- 这是长期 session parameter，还是一次性阶段标记？
- 它通过中心 diff 自动写回，还是显式 notify？
- 它恢复时走统一 mapper，还是单独 override？
- 我是不是又把 control authority 和 restore path 写成同一层？
- 我是不是又把 mode、stage flag 和 model override 写成了一张设置表？

## 5. 源码锚点

- `claude-code-source-code/src/state/onChangeAppState.ts`
- `claude-code-source-code/src/utils/sessionState.ts`
- `claude-code-source-code/src/cli/print.ts`
