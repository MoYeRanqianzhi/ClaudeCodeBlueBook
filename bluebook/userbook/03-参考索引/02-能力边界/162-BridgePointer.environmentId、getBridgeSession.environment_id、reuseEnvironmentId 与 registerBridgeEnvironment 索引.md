# `BridgePointer.environmentId`、`getBridgeSession.environment_id`、`reuseEnvironmentId` 与 `registerBridgeEnvironment` 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/173-BridgePointer.environmentId、getBridgeSession.environment_id、reuseEnvironmentId 与 registerBridgeEnvironment：为什么 pointer 里的 env hint、server session env 与 registered env 不是同一种 truth.md`
- `05-控制面深挖/172-readBridgePointerAcrossWorktrees、getBridgeSession、reconnectSession 与 environment_id：为什么 remote-control --continue 与 remote-control --session-id 不是同一种 bridge authority.md`
- `05-控制面深挖/34-No recent session found、Session not found、environment_id 与 try running the same command again：为什么 bridge 的 stale pointer、过期环境与瞬态重试不是同一种恢复失败.md`

边界先说清：

- 这页不是更宽的 bridge authority 页。
- 这页不是 failure taxonomy 页。
- 这页只抓 environment truth layering。

## 1. 三层 truth

| thickness | 当前更像什么 | 关键对象 |
| --- | --- | --- |
| local continuity hint | pointer 里当时写下的 env breadcrumb | `BridgePointer.environmentId` |
| requested original-env truth | 从 server session record 升级出的 re-register target | `getBridgeSession(...).environment_id`、`reuseEnvironmentId` |
| current live env result | 当前这次注册真正落成的 environment | `registerBridgeEnvironment(...).environment_id` |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| pointer 里已有 env，所以已经足够恢复 | pointer env 先是 continuity hint，不是任何宿主都无条件信的 final truth |
| `reuseEnvironmentId` 就是当前 live environment | 它是 request-side original-env claim，不是 response-side live result |
| 注册返回的新 env 只是把旧 env 回显一遍 | 后端可能否定旧 env 并返回 fresh env |
| 同一个 `environmentId` 字段在不同 host 里厚度一样 | perpetual REPL 与 standalone `--continue` 对 pointer env 的信任级别不同 |

## 3. stable / conditional / gray

| 类型 | 对象 |
| --- | --- |
| 专题内稳定不变量 | standalone `--continue` 先向 server session env 升级；注册返回值才是 live env；env mismatch 意味着 truth replacement |
| 条件公开 | `remote-control --continue`、`remote-control --session-id`、perpetual REPL reconnect |
| 内部/灰度层 | pointer `source` 区分、worktree fanout、TTL/mtime、compat tag shim、OAuth refresh |

## 4. 五个检查问题

- 当前 env 字段来自 pointer、本地 prior、server session record，还是注册响应？
- 当前字段服务的是 breadcrumb、requested target，还是 live result？
- 当前 host 是 perpetual REPL，还是 standalone `remote-control --continue`？
- 我是不是把 env mismatch 错写成 reconnect success？
- 我是不是又把这页写回 172 的 authority split 或 34 的失败分类？

## 5. 源码锚点

- `claude-code-source-code/src/bridge/bridgePointer.ts`
- `claude-code-source-code/src/bridge/bridgeMain.ts`
- `claude-code-source-code/src/bridge/replBridge.ts`
- `claude-code-source-code/src/bridge/createSession.ts`
- `claude-code-source-code/src/bridge/bridgeApi.ts`
