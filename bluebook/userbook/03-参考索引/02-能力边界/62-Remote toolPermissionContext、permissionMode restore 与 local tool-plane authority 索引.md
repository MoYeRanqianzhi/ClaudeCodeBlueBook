# Remote `toolPermissionContext`、`permissionMode` restore 与 local tool-plane authority 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/73-toolPermissionContext、initialMsg.mode、message.permissionMode、applyPermissionUpdate 与 computeTools：为什么 remote session 的本地 tool plane 主权不等于远端命令面主权.md`
- `05-控制面深挖/72-getTools、useMergedTools、mcp.tools 与 toolPermissionContext：为什么 remote session 的 tool plane 不会像 command plane 一样一起变薄.md`
- `05-控制面深挖/68-slash_commands、REMOTE_SAFE_COMMANDS、local-jsx fallthrough 与 remote send：为什么 remote session 的远端发布命令面、本地保留命令面与实际执行路由不是同一张命令表.md`

边界先说清：

- 这页不是权限系统总索引。
- 这页不是审批交互总索引。
- 这页只抓 remote session 下本地 tool plane 的主权来源。

## 1. 四类来源总表

| 来源 | 回答的问题 | 典型对象 |
| --- | --- | --- |
| `Initial Restore` | 会话初始化后先按什么 mode/rules 建立工具面 | `initialMsg.mode`、`allowedPrompts` |
| `Transcript Restore` | 历史回放会不会改当前工具面 mode | `message.permissionMode` |
| `Local Rule Update` | 本地用户批准会不会继续改工具面 | `applyPermissionUpdate`、`persistPermissionUpdate` |
| `Pool Reassembly` | 最终工具池怎样据此重算 | `computeTools`、`toolPermissionContext` |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| 远端命令面决定本地工具面 | 工具面主轴是本地 `toolPermissionContext` |
| 工具池只是启动默认值 | 会被初始化恢复、历史恢复、本地规则更新持续改写 |
| 本地权限弹层只影响单次批准 | 持久化更新会回写 `toolPermissionContext` |
| transcript 恢复只影响消息，不影响工具面 | `message.permissionMode` 也会回写 mode |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | 本地 tool plane 装配权在 REPL；`toolPermissionContext` 是主轴 |
| 条件公开 | `initialMsg.mode`、`allowedPrompts`、`message.permissionMode`、本地持久化选择 |
| 内部/实现层 | permission update 构造细节、auto mode 危险规则剥离、deny-rule 命中细节 |

## 4. 七个检查问题

- 我现在讨论的是命令面还是工具面？
- 这次变化来自初始化恢复、历史恢复，还是本地规则更新？
- `toolPermissionContext.mode` 有没有被重写？
- `allowedPrompts` 有没有被转成 permission updates？
- 本地用户是否把规则持久化了？
- 我是不是把 `slash_commands` 写成工具面主轴了？
- 我是不是把本地 tool plane 写成启动时死值了？

## 5. 源码锚点

- `claude-code-source-code/src/screens/REPL.tsx`
- `claude-code-source-code/src/hooks/useMergedTools.ts`
- `claude-code-source-code/src/tools.ts`
- `claude-code-source-code/src/utils/toolPool.ts`
- `claude-code-source-code/src/utils/permissions/PermissionUpdate.ts`
