# Remote Control 断开、退出与恢复轨迹索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/33-Disconnect Dialog、Perpetual Teardown、bridge pointer 与 --continue：为什么 bridge 的断开、退出与恢复轨迹不是同一种收口.md`
- `05-控制面深挖/32-Remote Control failed、disconnect、replBridgeEnabled=false 与 remoteControlAtStartup=false：为什么 bridge 的故障提示、当前会话停机与默认策略回退不是同一种关闭.md`
- `05-控制面深挖/24-remoteControlAtStartup、CCR Mirror、Perpetual Session 与 --continue：为什么 bridge 的 auto、mirror、resume 不是同一种重连.md`

## 1. 四类收口对象总表

| 对象 | 回答的问题 | 典型例子 |
| --- | --- | --- |
| `Current Session Stop` | 当前 bridge 现在停不停 | Disconnect Dialog 的 `Disconnect this session` |
| `Local Runtime Teardown` | 当前本地进程 / hook cleanup 会怎样收口 | `useReplBridge` cleanup |
| `Recovery Artifact Fate` | pointer 这次是清掉、刷新还是被继续消费 | `clearBridgePointer`、`writeBridgePointer` |
| `Resume Entry` | 下次从哪条入口恢复 | `remote-control --continue` |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| Disconnect Dialog 的 `Continue` = 再开一次 bridge | 它只是 dismiss，保持当前桥不变 |
| 手动 disconnect = 所有 closeout 都一样 | 还要看是不是 non-perpetual teardown、perpetual local-only closeout |
| clean exit = pointer 一定保留 | non-perpetual clean exit 会清 pointer，perpetual 会刷新并保留 |
| `remote-control --continue` = generic `--continue` | 它读取的是 bridge pointer 恢复轨迹 |
| fresh start = 不碰 pointer | 不带 `--continue` 的 fresh start 会主动清 leftover pointer |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | Disconnect Dialog 的 stop/continue 语义、perpetual teardown 会保留 continuity、pointer 在不同 closeout 路径下 fate 不同、`remote-control --continue` 是 bridge 恢复入口 |
| 条件公开 | worktree-aware pointer fanout、standalone vs repl pointer source、fatal 与 transient reconnect failure 的清理差异 |
| 内部/实现层 | pointer JSON、TTL / mtime 细节、fanout 上限、transport drain 顺序 |

## 4. 六个高价值判断问题

- 这次收口是谁触发的，是显式断开、进程退出，还是下一次启动的清理决策？
- 当前只停了本地 bridge，还是远端 session / env 也被正式收尾了？
- pointer 这次是被清掉、被刷新，还是被 `--continue` 继续消费？
- 当前是 non-perpetual teardown，还是 perpetual local-only closeout？
- Disconnect Dialog 的 `Continue` 是重新连接，还是保持现状？
- 我是不是又把 disconnect、clean exit、perpetual teardown 与 pointer recovery 压成了同一种收口？

## 5. 源码锚点

- `claude-code-source-code/src/commands/bridge/bridge.tsx`
- `claude-code-source-code/src/hooks/useReplBridge.tsx`
- `claude-code-source-code/src/bridge/replBridge.ts`
- `claude-code-source-code/src/bridge/bridgePointer.ts`
- `claude-code-source-code/src/bridge/bridgeMain.ts`
