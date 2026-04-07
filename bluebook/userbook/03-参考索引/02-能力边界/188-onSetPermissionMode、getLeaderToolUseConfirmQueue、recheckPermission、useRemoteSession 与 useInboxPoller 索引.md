# `onSetPermissionMode`、`getLeaderToolUseConfirmQueue`、`recheckPermission`、`useRemoteSession` 与 `useInboxPoller` 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/199-onSetPermissionMode、getLeaderToolUseConfirmQueue、recheckPermission、useRemoteSession 与 useInboxPoller：为什么 permission context 变更后的本地重判广播不是同一种 permission re-evaluation surface.md`
- `05-控制面深挖/198-cancelRequest、onResponse unsubscribe、pendingPermissionHandlers.delete 与 leader queue recheck：为什么 bridge permission race 的 prompt 撤场、订阅退役、响应消费与策略重判不是同一种收口合同.md`

边界先说清：

- 这页不是 permission closeout 总页。
- 这页不是 pending verdict ledger 总页。
- 这页只抓 permission context 变更后哪些 ask 面会被本地 recheck 广播触达、哪些明确不会。

## 1. 五层对象

| 对象 | 当前更像什么 | 关键位置 |
| --- | --- | --- |
| `onSetPermissionMode(...)` | CCR 改 mode 的本地权限上下文写入口 | `useReplBridge.tsx` |
| `getLeaderToolUseConfirmQueue()` | leader queue fanout bridge | `leaderPermissionBridge.ts` |
| `item.recheckPermission()` | 本地 queued ask 的重判 hook | `useReplBridge.tsx` / `interactiveHandler.ts` |
| `useRemoteSession` 的 `recheckPermission()` | remote ask 的 no-op surface | `useRemoteSession.ts` |
| `useInboxPoller` 的 `recheckPermission()` | tmux worker ask 的 no-op surface | `useInboxPoller.ts` |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| mode change = 所有 pending ask 一起自动重判 | 只有 leader queue 上的本地 ask 被 fanout 到 `recheckPermission()` |
| `recheckPermission()` = generic permission API | 这只是某些 ask surface 提供的可选本地重判 hook |
| remote / inbox ask 也会跟着本地 mode 变化重判 | 这两条 surface 明确是 no-op |
| queue recheck = closeout | 它关的是 re-evaluation surface，不是 198 的 closeout 主语 |

## 3. stable / conditional / gray

| 类型 | 对象 |
| --- | --- |
| 专题内稳定不变量 | leader queue mode-change fanout 与 remote/inbox no-op surface 不是同一种重判面 |
| 条件公开 | 只有通过 leader queue 挂起、且实现了本地 `recheckPermission()` 的 ask 才能被 mode-change 触达 |
| 内部/灰度层 | CCR 改 mode 的 inbound control 请求、worker/container 侧权限状态细节 |

## 4. 五个检查问题

- 我现在写的是 closeout，还是 re-evaluation surface？
- 我是不是把 leader queue fanout 和 generic permission API 压成一件事了？
- 我是不是忽略了 remote/inbox 的 no-op `recheckPermission()`？
- 我是不是把 `onSetPermissionMode(...)` 误写成直接替 pending ask 出 verdict？
- 我是不是又回卷到 198 的主语了？

## 5. 源码锚点

- `claude-code-source-code/src/hooks/useReplBridge.tsx`
- `claude-code-source-code/src/hooks/toolPermission/handlers/interactiveHandler.ts`
- `claude-code-source-code/src/hooks/useRemoteSession.ts`
- `claude-code-source-code/src/hooks/useInboxPoller.ts`
- `claude-code-source-code/src/utils/swarm/leaderPermissionBridge.ts`
