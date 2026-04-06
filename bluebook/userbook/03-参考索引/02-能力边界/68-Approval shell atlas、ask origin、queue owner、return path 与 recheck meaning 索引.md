# Approval shell atlas、`ask origin`、`queue owner`、`return path` 与 `recheck meaning` 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/79-approval shell atlas、ask origin、queue owner、return path 与 recheck meaning：为什么同一 REPL 审批外观背后其实是五张不同的主权图.md`
- `05-控制面深挖/74-can_use_tool、ToolUseConfirm、createToolStub、recheckPermission 与 manager.respondToPermissionRequest：为什么 remote session 的远端工具审批会借用本地权限队列 UI，却不会直接接管本地 tool plane.md`
- `05-控制面深挖/75-useRemoteSession、useDirectConnect、useSSHSession、handleInteractivePermission 与 bridgeCallbacks：为什么 remote session、direct connect、ssh session 都会借本地审批壳，而 bridge 只是把本地 permission prompt 外发竞速.md`
- `05-控制面深挖/76-toolUseConfirmQueue、promptQueue、sandbox、worker、elicitation 与 focusedInputDialog：为什么 REPL 的本地阻塞容器不共享同一治理闭环.md`
- `05-控制面深挖/77-swarmWorkerHandler、useInboxPoller、permissionSync、useSwarmPermissionPoller 与 workerBadge：为什么 tmux worker 的 mailbox ask 会在 leader 侧重包成 ToolUseConfirm，却不等于 leader 自己的本地审批.md`
- `05-控制面深挖/78-sendSandboxPermissionRequestViaMailbox、workerSandboxPermissions、pendingSandboxRequest 与 sandbox callback：为什么 worker sandbox ask 不等于 leader 本地 network prompt.md`

边界先说清：

- 这页不是所有权限规则的总索引。
- 这页不替代任一单页的源码细节。
- 这页只负责把 74-78 拉回同一张坐标系。

## 1. 五张主权图总表

| 图谱 | ask 起点 | queue owner | return path | 本地 `recheck` 意义 |
| --- | --- | --- | --- | --- |
| remote session imported ask | 远端 container | 本地 `ToolUseConfirmQueue` 壳 | 回 remote manager | 无 |
| remote/direct/ssh/bridge topology | 远端导入或本地外发 | remote 壳 / 本地 `ToolUseConfirm` / bridge relay | 回远端 manager 或本地闭环 | 仅本地 ask / bridge 有 |
| local modal family | 本地宿主多源对象 | 各种 queue / pending object | 各自不同 | 仅治理型容器有 |
| worker mailbox tool ask | worker 本地 `PermissionContext` | leader `ToolUseConfirmQueue` rewrap + worker pending | 回 worker callback | leader 侧无 |
| worker sandbox host ask | worker 本地 sandbox runtime | leader `workerSandboxPermissions.queue` + worker pending | 回 worker sandbox callback | leader 侧不以同款 `recheck` 存在 |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| 进了本地审批 UI = 本地主权接管 | 可能只是壳层借用 |
| 同款组件 = 同一个 ask owner | 只证明 shell reuse |
| waiting indicator = decision container | 等待态不等于治理协议 |
| 所有 `recheckPermission()` 都等价 | 只有部分图谱真的有治理意义 |
| bridge / worker mailbox / remote session 只是 transport 不同 | ask origin、queue owner、continuation owner 都可能不同 |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | 应按 `ask origin / queue owner / return path / recheck meaning` 命名 approval shell；74-78 至少覆盖五张不同主权图 |
| 条件公开 | bridge relay、worker mailbox、worker sandbox 依赖对应运行模式；mailbox 失败、host rule 持久化、tool 识别情况会改变局部行为 |
| 内部/实现层 | synthetic assistant、tool stub、workerBadge、mailbox JSON、callback registry、dedupe/lockfile/selectedIndex 等调度细节 |

## 4. 八个检查问题

- 这条 ask 最初在哪边生成？
- 它最终住在哪个 queue / waiting object 里？
- 当前看到的是 decision container 还是 waiting indicator？
- 用户答案回到哪边继续执行？
- 本地 `recheck` 对它有没有真实治理意义？
- 这里复用的是 shell、queue，还是完整 permission context？
- 这里是否存在 worker/leader 或 local/remote 的 continuation 分裂？
- 我是不是把 same shell 写成 same authority map 了？

## 5. 源码锚点

- `claude-code-source-code/src/hooks/useRemoteSession.ts`
- `claude-code-source-code/src/remote/RemoteSessionManager.ts`
- `claude-code-source-code/src/hooks/useDirectConnect.ts`
- `claude-code-source-code/src/server/directConnectManager.ts`
- `claude-code-source-code/src/hooks/useCanUseTool.tsx`
- `claude-code-source-code/src/screens/REPL.tsx`
- `claude-code-source-code/src/hooks/toolPermission/handlers/swarmWorkerHandler.ts`
- `claude-code-source-code/src/hooks/useInboxPoller.ts`
- `claude-code-source-code/src/hooks/useSwarmPermissionPoller.ts`
- `claude-code-source-code/src/utils/swarm/permissionSync.ts`
