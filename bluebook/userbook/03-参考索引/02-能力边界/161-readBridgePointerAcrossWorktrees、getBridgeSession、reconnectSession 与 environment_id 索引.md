# `readBridgePointerAcrossWorktrees`、`getBridgeSession`、`reconnectSession` 与 `environment_id` 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/172-readBridgePointerAcrossWorktrees、getBridgeSession、reconnectSession 与 environment_id：为什么 remote-control --continue 与 remote-control --session-id 不是同一种 bridge authority.md`
- `05-控制面深挖/34-No recent session found、Session not found、environment_id 与 try running the same command again：为什么 bridge 的 stale pointer、过期环境与瞬态重试不是同一种恢复失败.md`
- `05-控制面深挖/169-resume、--continue、print --resume 与 remote-control --continue：为什么 stable conversation resume、headless remote hydrate 与 bridge continuity 不是同一种接续来源.md`

边界先说清：

- 这页不是更宽的 bridge continuity taxonomy 页。
- 这页不是 stale pointer / retry policy 总表页。
- 这页只抓 bridge reconnect family 内部的 authority 差异。

## 1. 两种 authority

| authority | 当前更像什么 | 关键对象 |
| --- | --- | --- |
| pointer-led continuity authority | 先读最近 crash-recovery pointer，再规范化进 resume flow | `remote-control --continue`、`readBridgePointerAcrossWorktrees()`、`resumePointerDir` |
| explicit original-session authority | 直接命中用户指定 session，再去 server 确认原 environment | `remote-control --session-id`、`getBridgeSession()`、`reuseEnvironmentId` |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `--continue` 只是 `--session-id` 的语法糖 | 它们共享 downstream reconnect machinery，但 upstream authority 不同 |
| 既然最后都变成 `resumeSessionId`，就已经没有本质差异 | normalized variable 相同，不等于 authority artifact 相同 |
| pointer 与 `session-id` 都指向旧 session，所以 cleanup 责任也一样 | 只有 pointer-led path 拥有 local pointer cleanup 责任 |
| pointer 里已有 `environmentId`，所以它就是完整恢复 truth | pointer 负责 continuity selection，server session record 仍保留 original-environment truth |

## 3. stable / conditional / gray

| 类型 | 对象 |
| --- | --- |
| 专题内稳定不变量 | original-environment resume 约束、single-session resume 约束、`getBridgeSession() -> registerBridgeEnvironment(reuseEnvironmentId) -> reconnectSession()` 主链 |
| 条件公开 | `remote-control --continue`、`remote-control --session-id` |
| 内部/灰度层 | worktree fanout pointer scan、fatal-only pointer cleanup、compat/infrastructure session id 双候选、env mismatch fallback |

## 4. 五个检查问题

- 当前 authority artifact 是 pointer，还是显式 `session-id`？
- 当前路径承诺的是最近 continuity，还是命中明确指定的原 session？
- 当前失败时应该清理 local pointer，还是根本没有 local artifact 可清？
- 当前共享的是同一种 authority，还是只是共享 target 已确定后的 attach protocol？
- 我是不是又把这页写回 34 的 failure taxonomy 或 169 的大类来源页？

## 5. 源码锚点

- `claude-code-source-code/src/bridge/bridgeMain.ts`
- `claude-code-source-code/src/bridge/bridgePointer.ts`
- `claude-code-source-code/src/bridge/createSession.ts`
- `claude-code-source-code/src/bridge/bridgeApi.ts`
