# remoteControlAtStartup、CCR Mirror、Perpetual Session 与 --continue：为什么 bridge 的 auto、mirror、resume 不是同一种重连

## 用户目标

不是只知道 Claude Code “有 `/remote-control`、有 startup default、好像还能自动镜像或继续上次 bridge”，而是先分清四件事：

- 手动 `/remote-control`、`--remote-control` 与 `remoteControlAtStartup`，为什么不是同一种启动。
- `CCR Mirror` 的 outbound-only 模式，为什么不是“缩弱版 remote-control”。
- assistant 模式下的 perpetual bridge session，为什么不是普通断线重连。
- `claude remote-control --continue`，为什么也不是通用 `--continue` 的另一个语法糖。

如果这四件事不先拆开，读者最容易把下面这些对象混成一锅“bridge 重连”：

- 显式 `/remote-control`
- `remoteControlAtStartup`
- CCR auto-connect default
- `replBridgeExplicit`
- `replBridgeOutboundOnly`
- `replBridgeConnected`
- `replBridgeSessionActive`
- assistant / perpetual session
- `remote-control --continue`
- bridge pointer

## 第一性原理

bridge 在 Claude Code 里不是只有“开”与“关”，而是至少四条不同轴线：

1. `Enable Source`：这次 bridge 是手动开启、配置默认开启，还是镜像模式带起来的。
2. `Control Direction`：当前是双向 remote-control，还是 outbound-only mirror。
3. `Continuity Model`：当前 session 是普通 crash-recovery，还是 assistant/perpetual continuity。
4. `Resume Source`：这次恢复是 generic conversation resume，还是 bridge pointer resume。

因此更稳的提问不是：

- “现在 bridge 是不是已经连上了？”

而是：

- “它是被谁开启的、能不能被远端控制、要不要跨 CLI 重启保活、这次又是从哪条状态源恢复的？”

只要不先拆开这四条轴线，auto、mirror、resume 就会被误写成同一种“自动重连”。

## 第一层：`remoteControlAtStartup` 与显式 `/remote-control` 不是同一个启动源

### 手动 `/remote-control` 是显式 bridge 启动

`commands/bridge/bridge.tsx` 的逻辑很清楚：

- 若当前已经 `replBridgeConnected || replBridgeEnabled`
- 且不是 outbound-only
- 就弹 disconnect / continue 对话

否则：

- 先做 `checkBridgePrerequisites()`
- 然后把 `replBridgeEnabled: true`
- `replBridgeExplicit: true`
- `replBridgeOutboundOnly: false`

这说明显式 `/remote-control` 的真实语义是：

- 当前用户明确要求把本会话升级成双向 remote-control

### `remoteControlAtStartup` 是全局默认，不等于“用户刚刚点了 `/remote-control`”

`getRemoteControlAtStartup()` 的优先级写得非常清楚：

1. 用户显式 config 值
2. CCR auto-connect default
3. 否则 `false`

并且 `Settings/Config` 与 `ConfigTool` 都会把：

- `remoteControlAtStartup`

同步回当前 `AppState`，让 `useReplBridge` 立即响应。

因此更准确的理解是：

- `/remote-control` 解决的是“这次我主动要开”
- `remoteControlAtStartup` 解决的是“以后默认要不要开”

### `replBridgeExplicit` 就是为了区分“显式开启”与“默认带起”

`main.tsx` 初始化 `AppState` 时：

- `replBridgeEnabled = fullRemoteControl || ccrMirrorEnabled`
- `replBridgeExplicit = remoteControl`

这里最关键的一点是：

- startup default 会让 bridge enabled
- 但不会把它标成 explicit

这说明系统一开始就承认：

- “桥已经在跑”
- 与
- “用户这次明确打开了远控”

不是同一状态。

### 所以“bridge 已启用”不等于“用户刚刚开启了 remote-control”

这是本页最先要抓住的错位。

更稳的判断应是：

- `enabled` 说明 bridge 现在在这条 session 里工作
- `explicit` 说明它是不是由用户本轮显式触发

二者不能互相替代。

## 第二层：`CCR Mirror` 的 outbound-only 模式不是缩弱版 remote-control

### outbound-only mirror 只在没进入 full remote-control 时带起

`main.tsx` 的逻辑是：

- 先算 `fullRemoteControl = remoteControl || getRemoteControlAtStartup() || kairosEnabled`
- 只有在 `!fullRemoteControl` 时，才继续看 `CCR_MIRROR`

这说明 mirror 不是 full remote-control 的同义入口，而是：

- 一条与 full remote-control 并列、且互斥的带起路径

### outbound-only 的对象是“向远端送出镜像”，不是“允许远端反控”

`bridgeMessaging.ts` 对 outbound-only 说得非常直白：

- 会拒绝除 `initialize` 之外的 mutable control requests
- 并返回固定错误：
  `This session is outbound-only. Enable Remote Control locally to allow inbound control.`

这说明 outbound-only 模式的真实语义是：

- 远端能看见镜像与事件
- 但不能对本地进行完整 inbound control

因此它不是：

- “有点弱的 remote-control”

而是：

- 控制方向已经不同的另一种 bridge 模式

### `/remote-control` 的一个重要作用，就是把 outbound-only 升级成双向控制

`commands/bridge/bridge.tsx` 里还有一条很关键：

- 已经 `enabled` 但 `outboundOnly === true` 时
- `/remote-control` 不会走普通断开对话
- 而会继续把状态改成
  `replBridgeExplicit: true`
  `replBridgeOutboundOnly: false`

这说明用户动作的真实含义是：

- 不是“重复打开已开的 bridge”
- 而是“把 mirror 升级成 full remote-control”

### 所以 mirror 与 remote-control 连“控制方向”都不一样

更稳的区分是：

- `CCR Mirror`：向外镜像，拒绝可变控制
- `Remote Control`：允许远端真正控制本地 session

只要这一层没写清，正文就会把 mirror 错写成：

- 一个只差 UX 的半成品远控

## 第三层：`connected` 与 `sessionActive` 也不是同一个“已连上”

### `ready` 与 `connected` 是两段不同状态

`useReplBridge.tsx` 里：

- `state === 'ready'` 时，会把
  `replBridgeConnected: true`
  `replBridgeSessionActive: false`
  同时填上 connect/session URL 与 env/session id
- `state === 'connected'` 时，才继续把
  `replBridgeSessionActive: true`

所以更准确的理解是：

- `connected` 可以只是 transport / environment 已就绪
- `sessionActive` 才表示 bridge session 真正进入活动态

### footer 也刻意不把所有 enabled bridge 一视同仁

`PromptInputFooter.tsx` 和 `PromptInput.tsx` 还明确区分：

- footer pill 依赖 `connected`
- 同时还要求 `explicit || reconnecting`

这意味着：

- 即使 bridge 已经在后台带起
- 也不等于一定要把它当作显式控制面展示给用户

因此用户视角里的“桥在不在”与系统内部的：

- enabled
- connected
- sessionActive
- explicit

本来就是四张不同的状态表。

## 第四层：assistant/perpetual session 不是普通 crash-recovery

### assistant 模式会把 bridge continuity 改成 perpetual

`useReplBridge.tsx` 明确写了：

- assistant mode 下 `perpetual = true`

并且注释已经把意图说透：

- claude.ai 看到的是一条跨 CLI 重启连续存在的会话
- 而不是每次启动都新开一个 session

### perpetual 会在初始化时读 pointer，重用 env/session

`replBridge.ts` 里：

- perpetual 模式会先 `readBridgePointer(dir)`
- 只重用 `source: 'repl'` 的 prior pointer

而且：

- `initReplBridge.ts` 还明确写了 env-less bridge v2 只在 `!perpetual` 时使用

这说明 perpetual 不是：

- 一般远控桥在断线后再连上

而是：

- 初始化策略都已经不同的 continuity 模式

### perpetual teardown 会故意把远端 session 留活

`replBridge.ts` 的 teardown 对 perpetual 写得非常硬：

- 不发 result
- 不 `stopWork`
- 不关 transport 给服务器“要结束了”的信号
- 只做本地 teardown
- 并刷新 pointer

注释里的结论已经很清楚：

- 下次 daemon 启动时，通过 pointer + reconnectSession 继续

这说明 perpetual 的真实心智是：

- “会话跨本地进程重启继续活着”

而不是：

- “普通 session 崩了以后补一个 crash recovery”

## 第五层：`claude remote-control --continue` 不是 generic `--continue`

### 这条 `--continue` 读取的不是普通 conversation history，而是 bridge pointer

`bridgeMain.ts` 对 `continueSession` 的注释很清楚：

- 走 crash-recovery pointer
- 再链进 `--session-id` 恢复流

如果没找到 pointer，会报：

- 当前目录或其 worktrees 没有 recent bridge session
- 先跑 `claude remote-control`

因此它解决的问题不是：

- 恢复最近一条普通 Claude 对话

而是：

- 恢复最近一条 bridge session 轨迹

### 它还是 worktree-aware 的 bridge resume

`bridgePointer.ts` 里：

- 先查当前目录
- 没找到时才 fan out 到 git worktree siblings
- 选 freshest pointer

这说明它的对象也不是 generic conversation store，而是：

- worktree-aware bridge pointer

### pointer 在不同模式下的用途也不一样

同样是 pointer：

- standalone single-session bridge 会立即写 pointer，并按小时 refresh
- 普通 REPL bridge 把它当 crash-recovery 轨迹，clean teardown 后会清掉
- perpetual mode 则故意不清，让它跨 clean exit 继续存在

所以更准确的理解是：

- `remote-control --continue` 不是一个简单的“继续”
- 它读取的是 bridge lifecycle 专用状态源

### 因而 `remote-control --continue` 与普通 `--continue` 不是并列别名

更稳的区分是：

- generic `--continue`：继续最近一条 conversation
- bridge `--continue`：继续最近一条 bridge pointer 恢复轨迹

两者虽然词面接近，但状态来源与目标对象都不同。

## 第六层：稳定公开面、条件面与内部面要继续保护

### 稳定公开或相对稳定可见的

- `/remote-control`
- `remoteControlAtStartup` 设置面/配置键

### 条件公开或灰度较重的

- CCR auto-connect default
- CCR Mirror / outbound-only
- assistant/perpetual continuity
- `remote-control --continue`

这些都真实存在，但正文必须继续提醒：

- 它们受 build gate、账号态、模式和 rollout 影响

### 更应留在实现边界说明的

- pointer 文件格式细节
- env-less bridge v1/v2 协议分叉细节
- 服务端 TTL 与 lease 回收细节
- test hook / ant-only rollout 细节

这些不该直接抬成：

- 用户主线功能说明

## 最后的判断公式

遇到 bridge “为什么这次行为不一样”时，先问六个问题：

1. 这次 bridge 是显式开启、startup default，还是 mirror 带起？
2. 当前模式是双向控制，还是 outbound-only？
3. 现在只是 connected，还是 sessionActive？
4. 这条 continuity 是普通 crash-recovery，还是 assistant/perpetual？
5. 这次 resume 读的是 generic history，还是 bridge pointer？
6. 我是不是把 auto、mirror、perpetual、continue 都写成了一种“重连”？

只有这六问先答清，才不会把：

- auto-connect
- mirror
- explicit remote-control
- perpetual continuity
- bridge pointer resume

误写成同一套 bridge 行为。

## 源码锚点

- `claude-code-source-code/src/utils/config.ts`
- `claude-code-source-code/src/bridge/bridgeEnabled.ts`
- `claude-code-source-code/src/main.tsx`
- `claude-code-source-code/src/commands/bridge/bridge.tsx`
- `claude-code-source-code/src/hooks/useReplBridge.tsx`
- `claude-code-source-code/src/bridge/bridgeMessaging.ts`
- `claude-code-source-code/src/bridge/bridgeMain.ts`
- `claude-code-source-code/src/bridge/bridgePointer.ts`
- `claude-code-source-code/src/bridge/replBridge.ts`
