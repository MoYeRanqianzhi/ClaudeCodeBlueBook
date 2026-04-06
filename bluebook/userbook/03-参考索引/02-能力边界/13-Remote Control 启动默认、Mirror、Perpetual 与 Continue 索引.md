# Remote Control 启动默认、Mirror、Perpetual 与 Continue 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/24-remoteControlAtStartup、CCR Mirror、Perpetual Session 与 --continue：为什么 bridge 的 auto、mirror、resume 不是同一种重连.md`
- `05-控制面深挖/23-Workspace Trust、Bridge Eligibility 与 Trusted Device：为什么 remote-control 的 trust、auth、policy 不是同一把钥匙.md`
- `05-控制面深挖/21-Host、Viewer 与 Health Check：为什么 server、remote-control、assistant、doctor 不能写成同一类会外入口.md`

## 1. 四条轴线总表

| 轴线 | 回答的问题 | 典型对象 |
| --- | --- | --- |
| `Enable Source` | bridge 是谁带起来的 | `/remote-control`、`remoteControlAtStartup`、CCR auto-connect |
| `Control Direction` | 远端能不能真正控制本地 | full remote-control、outbound-only mirror |
| `Continuity Model` | session 是 crash-recovery 还是跨重启连续存在 | 普通 bridge、assistant/perpetual |
| `Resume Source` | 这次恢复读的是哪张状态表 | generic `--continue`、bridge pointer `--continue` |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `remoteControlAtStartup` = 用户刚刚手动开了 `/remote-control` | 一个是默认带起，一个是显式启动 |
| mirror = remote-control 的弱化版 | mirror 改的是控制方向，不只是能力强弱 |
| connected = sessionActive | transport 就绪与 session 活动态不是同一层 |
| perpetual = 普通断线重连 | perpetual 是 continuity model，不是临时重连 |
| `remote-control --continue` = 普通 `--continue` | 前者读 bridge pointer，后者读普通会话历史 |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | `/remote-control`、`remoteControlAtStartup` 配置面 |
| 条件公开 | CCR auto-connect、CCR Mirror、assistant/perpetual、`remote-control --continue` |
| 内部/实现层 | pointer 文件格式、bridge v1/v2 协议细节、TTL/lease 回收 |

## 4. 六个高价值判断问题

- 这次 bridge 是显式开、默认开，还是 mirror 带起？
- 当前模式允许 inbound control，还是只是 outbound-only？
- 当前状态只是 connected，还是 sessionActive？
- 这条 continuity 是普通 crash-recovery，还是 perpetual？
- 这次 continue 读的是普通 conversation 历史，还是 bridge pointer？
- 我是不是把 auto、mirror、perpetual、continue 都写成了一种“重连”？

## 5. 源码锚点

- `claude-code-source-code/src/utils/config.ts`
- `claude-code-source-code/src/bridge/bridgeEnabled.ts`
- `claude-code-source-code/src/main.tsx`
- `claude-code-source-code/src/commands/bridge/bridge.tsx`
- `claude-code-source-code/src/hooks/useReplBridge.tsx`
- `claude-code-source-code/src/bridge/bridgeMessaging.ts`
- `claude-code-source-code/src/bridge/bridgeMain.ts`
- `claude-code-source-code/src/bridge/bridgePointer.ts`
- `claude-code-source-code/src/bridge/replBridge.ts`
