# Remote Control stale pointer、过期环境与重试语义索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/34-No recent session found、Session not found、environment_id 与 try running the same command again：为什么 bridge 的 stale pointer、过期环境与瞬态重试不是同一种恢复失败.md`
- `05-控制面深挖/33-Disconnect Dialog、Perpetual Teardown、bridge pointer 与 --continue：为什么 bridge 的断开、退出与恢复轨迹不是同一种收口.md`
- `05-控制面深挖/24-remoteControlAtStartup、CCR Mirror、Perpetual Session 与 --continue：为什么 bridge 的 auto、mirror、resume 不是同一种重连.md`

## 1. 四类恢复失败对象总表

| 对象 | 回答的问题 | 典型例子 |
| --- | --- | --- |
| `Artifact Missing` | 本地还有没有可消费的恢复轨迹 | `No recent session found` |
| `Deterministic Invalid Source` | pointer 指向的恢复源是否已确定无效 | `Session not found`、`has no environment_id` |
| `Fallback Instead of Resume` | continuity 是否断了，但当前命令还能 fresh start | env mismatch warning |
| `Transient Retry` | 当前轨迹是否应保留给下一次 retry | `try running the same command again` |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `No recent session found` = server 上 session 没了 | 它首先说明本地恢复轨迹不存在或已失效 |
| `Session not found` = 再试一次也许就好 | 这是确定性无效恢复源，pointer 会被清掉 |
| env mismatch = resume success | 它表示 continuity 断了，只能回退到 fresh session |
| `try running the same command again` = 安慰文案 | 它意味着系统故意保留 pointer 作为 retry 机制 |
| perpetual 与 `--continue` = 同一套 pointer 读取 | 一个只复用 `source:'repl'`，一个消费统一 bridge pointer 入口 |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | `No recent session found`、`Session not found`、`has no environment_id`、env mismatch fallback、transient retry 保留 pointer |
| 条件公开 | worktree-aware freshest 选择、perpetual 的 `source:'repl'` 过滤、OAuth 预刷新对错误体验的影响 |
| 内部/实现层 | pointer TTL / mtime、fanout cap、`session_*`/`cse_*` 兼容细节、错误类型实现 |

## 4. 六个高价值判断问题

- 这次失败是 pointer 没了，还是 pointer 指向的 server-side 资产没了？
- 当前是 deterministic invalid source，还是 transient retry？
- 系统这次是在清理旧轨迹，还是故意保留旧轨迹？
- continuity 只是断了，还是连 fresh fallback 也不成立？
- 当前应该新开 bridge、重新登录，还是简单再试一次？
- 我是不是又把 stale pointer、过期环境与瞬态重试写成了同一种恢复失败？

## 5. 源码锚点

- `claude-code-source-code/src/bridge/bridgeMain.ts`
- `claude-code-source-code/src/bridge/bridgePointer.ts`
- `claude-code-source-code/src/bridge/bridgeApi.ts`
- `claude-code-source-code/src/bridge/replBridge.ts`
