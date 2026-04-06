# Remote Control 状态词、恢复厚度与动作上限索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/31-Remote Control active、reconnecting、Connect URL、Session URL 与 outbound-only：为什么 bridge 的状态词、恢复厚度与动作上限不是同一个“已恢复”.md`
- `05-控制面深挖/25-Settings、remote-control 命令、Footer 状态 pill 与 Bridge Dialog：为什么 bridge 的默认配置、当前开关与连接展示不是同一个按钮.md`
- `05-控制面深挖/24-remoteControlAtStartup、CCR Mirror、Perpetual Session 与 --continue：为什么 bridge 的 auto、mirror、resume 不是同一种重连.md`
- `05-控制面深挖/29-Bridge Permission Callbacks、Control Request 与 Bridge-safe Commands：为什么远端的权限提示、会话控制与命令白名单不是同一种控制合同.md`

## 1. 四类对象总表

| 对象 | 回答的问题 | 典型例子 |
| --- | --- | --- |
| `Status Word` | 控制面现在用什么词总结桥的状态 | `Remote Control active`、`reconnecting`、`failed` |
| `Recovery Thickness` | 当前到底恢复到“可接入”、还是已有活动会话、还是只是薄恢复 | `replBridgeConnected`、`replBridgeSessionActive`、`Connect URL`、`Session URL` |
| `Action Ceiling` | 当前远端还能做什么、不能做什么 | outbound-only 拒绝 mutable control、`BRIDGE_SAFE_COMMANDS` |
| `Display Surface` | 这条状态现在通过哪里暴露 | footer pill、Bridge Dialog、notification |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `Remote Control active` = fully recovered | 它只是 coarse summary，至少会吃掉 `connected` 与 `sessionActive` 的厚度差异 |
| `connected` = `sessionActive` | 一个更像 ready / attached，另一个才是活动会话已附着 |
| `Connect URL` = `Session URL` | 一个回答“可接入”，一个回答“已有活动会话可继续” |
| outbound-only = 弱化版 full remote-control | 它收窄的是动作上限，mutable inbound control 会直接报错 |
| footer pill 可见 = bridge 全状态证明 | pill 是受条件约束的 coarse summary，不是完整状态树 |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | `active` / `reconnecting` / `failed`、`Connect URL` / `Session URL` 的厚度差异、outbound-only 的错误语义、bridge-safe 命令上限 |
| 条件公开 | implicit config-driven bridge 的 pill 抑制、mirror / outbound-only 路径、RemoteCallout、显式与默认开启的可见性差异 |
| 内部/实现层 | auto-disable 超时、poll/backoff、transport tags、security 文档里的原始作者术语 |

## 4. 六个高价值判断问题

- 现在这个词是展示层粗摘要，还是更细的状态节点？
- 当前 `active` 背后到底是 `connected`，还是 `sessionActive`？
- 当前只有 `Connect URL`，还是已经有 `Session URL`？
- 当前是 full remote-control，还是 outbound-only / mirror？
- 远端现在的动作上限是什么，能不能接收入站控制？
- 我是不是又把状态词、恢复厚度与动作上限写成了同一个“已恢复”？

## 5. 源码锚点

- `claude-code-source-code/src/bridge/bridgeStatusUtil.ts`
- `claude-code-source-code/src/hooks/useReplBridge.tsx`
- `claude-code-source-code/src/components/PromptInput/PromptInputFooter.tsx`
- `claude-code-source-code/src/components/PromptInput/PromptInput.tsx`
- `claude-code-source-code/src/components/BridgeDialog.tsx`
- `claude-code-source-code/src/commands/bridge/bridge.tsx`
- `claude-code-source-code/src/bridge/bridgeMessaging.ts`
- `claude-code-source-code/src/commands.ts`
- `claude-code-source-code/src/state/AppStateStore.ts`
