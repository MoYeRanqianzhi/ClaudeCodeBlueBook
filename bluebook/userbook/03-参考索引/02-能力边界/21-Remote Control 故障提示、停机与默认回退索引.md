# Remote Control 故障提示、停机与默认回退索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/32-Remote Control failed、disconnect、replBridgeEnabled=false 与 remoteControlAtStartup=false：为什么 bridge 的故障提示、当前会话停机与默认策略回退不是同一种关闭.md`
- `05-控制面深挖/31-Remote Control active、reconnecting、Connect URL、Session URL 与 outbound-only：为什么 bridge 的状态词、恢复厚度与动作上限不是同一个“已恢复”.md`
- `05-控制面深挖/25-Settings、remote-control 命令、Footer 状态 pill 与 Bridge Dialog：为什么 bridge 的默认配置、当前开关与连接展示不是同一个按钮.md`

## 1. 四类关闭对象总表

| 对象 | 回答的问题 | 典型例子 |
| --- | --- | --- |
| `Failure Signal` | 系统是不是在告诉你桥出了故障 | `Remote Control failed`、`failed to connect` |
| `Current Session Stop` | 当前这一条 session 里的 bridge 现在要不要继续跑 | `/remote-control` disconnect、`replBridgeEnabled = false` |
| `Auto-disable Fuse` | 系统是不是因为失败而短暂熔断停机 | failed 后的 auto-clear |
| `Future Default Policy` | 以后新 session 默认还要不要自动带起 remote-control | `remoteControlAtStartup = false` |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `Remote Control failed` = 已按要求断开 | 一个是故障提示，一个是手动停机结果 |
| `replBridgeEnabled = false` = 用户刚刚按了 disconnect | 它只是结果字段，来源可能是手动断开、自动熔断或策略同步 |
| `Remote Control disconnected.` = failed | 一个确认手动动作，一个报告异常 |
| Bridge Dialog 的 `d` = 只断当前 session | explicit 路径下还可能把未来默认写成 `false` |
| `remoteControlAtStartup = false` = 当前 bridge 的失败原因 | 它是 future default policy，不是 failure explanation |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | `failed`、`failed to connect`、`disconnected`、当前停机与未来默认回退是不同对象 |
| 条件公开 | Bridge Dialog 的 explicit 路径持久化回退、settings 改动同步当前 AppState、implicit / outbound-only 路径差异 |
| 内部/实现层 | fuse 具体时长、连续失败计数、字段清理顺序、notification priority 等实现细节 |

## 4. 六个高价值判断问题

- 我现在看到的是故障提示，还是手动停机结果？
- 这次停机是用户主动发起，还是系统因为失败而熔断？
- 影响的是当前 session，还是连未来默认也改了？
- `replBridgeEnabled = false` 只是结果，还是能单独解释原因？
- 当前信息来自 notification、system message、dialog，还是 settings policy？
- 我是不是把 failed、disconnect 与 default rollback 写成了同一种关闭？

## 5. 源码锚点

- `claude-code-source-code/src/hooks/useReplBridge.tsx`
- `claude-code-source-code/src/components/PromptInput/PromptInputFooter.tsx`
- `claude-code-source-code/src/components/BridgeDialog.tsx`
- `claude-code-source-code/src/commands/bridge/bridge.tsx`
- `claude-code-source-code/src/components/Settings/Config.tsx`
- `claude-code-source-code/src/bridge/types.ts`
