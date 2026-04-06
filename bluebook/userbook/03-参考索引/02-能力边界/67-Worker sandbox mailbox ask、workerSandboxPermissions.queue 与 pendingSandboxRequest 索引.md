# Worker sandbox mailbox ask、`workerSandboxPermissions.queue` 与 `pendingSandboxRequest` 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/78-sendSandboxPermissionRequestViaMailbox、workerSandboxPermissions、pendingSandboxRequest 与 sandbox callback：为什么 worker sandbox ask 不等于 leader 本地 network prompt.md`
- `05-控制面深挖/77-swarmWorkerHandler、useInboxPoller、permissionSync、useSwarmPermissionPoller 与 workerBadge：为什么 tmux worker 的 mailbox ask 会在 leader 侧重包成 ToolUseConfirm，却不等于 leader 自己的本地审批.md`
- `05-控制面深挖/76-toolUseConfirmQueue、promptQueue、sandbox、worker、elicitation 与 focusedInputDialog：为什么 REPL 的本地阻塞容器不共享同一治理闭环.md`

边界先说清：

- 这页不是所有 sandbox 权限逻辑的总索引。
- 这页不替代本地主线程 `sandboxPermissionRequestQueue` 专题。
- 这页只抓 worker sandbox mailbox ask 的 worker/leader 分工。

## 1. 五类对象总表

| 对象 | 回答的问题 | 典型对象 |
| --- | --- | --- |
| `Ask Origin` | sandbox ask 从哪边发起 | worker REPL network path |
| `Worker Waiting Surface` | worker 自己看到什么 | `pendingSandboxRequest`、`WorkerPendingPermission` |
| `Leader Host Queue` | leader 用什么对象承接 | `workerSandboxPermissions.queue` |
| `Mailbox Return Path` | 结果如何回流 worker | `sendSandboxPermissionResponseViaMailbox(...)` |
| `Worker Continuation` | 谁真正 resolve 原 promise | `registerSandboxPermissionCallback(...)`、`processSandboxPermissionResponse(...)` |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| worker sandbox ask = leader 本地 `sandboxPermissionRequestQueue` 条目 | 它进入的是 `workerSandboxPermissions.queue` |
| worker 自己也先弹本地 network prompt | 上报成功后只有 `pendingSandboxRequest` |
| leader 允许后就地解决原 promise | 原 promise 在 worker callback resolve |
| 这条线和 77 页完全一样 | 本页是 host approval queue，不是 `ToolUseConfirm` rewrap |
| leader 的 allow 只影响 worker | 允许并持久化时还会修改 leader 本地 host 规则 |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | worker sandbox ask 上报后，worker 只看到 pending；leader 看到 host approval queue；结果再回到 worker |
| 条件公开 | 仅在 swarm worker 场景走 mailbox；发送失败会本地 fallback；persistToSettings 可能修改 leader 本地规则 |
| 内部/实现层 | mailbox JSON 形状、callback registry、desktop notification、selectedIndex / workerColor / createdAt 等辅助字段 |

## 4. 七个检查问题

- ask 起点在 worker，还是在 leader？
- worker 自己拿到的是等待态，还是本地 network prompt？
- leader 这边装的是 `sandboxPermissionRequestQueue`，还是 `workerSandboxPermissions.queue`？
- allow/deny 最终在哪边 resolve 原 promise？
- 这里是同款组件复用，还是同款 ask ownership？
- 允许时会不会顺带改写 leader 本地 host 规则？
- 我是不是把 leader-visible host queue 写成 leader-owned local prompt 了？

## 5. 源码锚点

- `claude-code-source-code/src/screens/REPL.tsx`
- `claude-code-source-code/src/hooks/useInboxPoller.ts`
- `claude-code-source-code/src/hooks/useSwarmPermissionPoller.ts`
- `claude-code-source-code/src/utils/swarm/permissionSync.ts`
- `claude-code-source-code/src/utils/teammateMailbox.ts`
- `claude-code-source-code/src/state/AppStateStore.ts`
