# Settings、remote-control 命令、Footer 状态 pill 与 Bridge Dialog：为什么 bridge 的默认配置、当前开关与连接展示不是同一个按钮

## 用户目标

不是只知道 Claude Code 里“有个设置项、有个 `/remote-control`、底部还会出现 Remote Control 状态”，而是先分清四类不同对象：

- `remoteControlAtStartup` 的设置默认，回答的是以后默认怎么启动。
- `remote-control` 命令，回答的是这条当前 session 要不要显式进入 full remote-control。
- Footer 状态 pill，回答的是当前桥接状态有没有被粗粒度展示出来。
- Bridge Dialog，回答的是这条 bridge 现在连到哪里、可不可以从当前会话断开。

如果不先拆开，读者最容易把下面这些对象压扁成同一个“远控开关”：

- Settings 里的 `remoteControlAtStartup`
- `ConfigTool` 对 `remoteControlAtStartup` 的读写
- `/remote-control`
- `replBridgeEnabled`
- `replBridgeExplicit`
- `replBridgeConnected`
- `replBridgeSessionActive`
- Footer 的 `Remote Control active`
- Bridge Dialog 里的 disconnect

## 第一性原理

在 Claude Code 里，bridge 相关入口至少分成四张不同的面：

1. `Configuration Surface`：以后默认怎么启动。
2. `Control Surface`：当前这条 session 现在要不要显式切到 full remote-control。
3. `Status Surface`：系统现在愿不愿意把 bridge 状态展示给你看。
4. `Inspect / Disconnect Surface`：你当前看到的桥到底连到哪里，以及这次断开是只断本次，还是顺便持久化改默认。

因此更稳的提问不是：

- “Remote Control 开关在哪里？”

而是：

- “我现在要改的是默认策略、当前会话控制动作、状态展示，还是当前桥的查看/断开动作？”

只要这一问没先答清，正文就会把设置、命令、状态 pill 和 dialog 都写成同一个按钮。

## 第一层：`remoteControlAtStartup` 的设置面，回答的是默认策略，不是当前显式动作

### Settings 里的 `remoteControlAtStartup` 是“以后默认怎么启动”

`Settings/Config.tsx` 对这一项写得很明确：

- 只有 `feature('BRIDGE_MODE') && isBridgeEnabled()` 时才显示
- 标签是 `Enable Remote Control for all sessions`
- 选项是 `true`、`false`、`default`

这说明它回答的问题不是：

- “这一秒我要不要手动开 remote-control”

而是：

- “以后新 session 的默认 remote-control 策略是什么”

并且这项配置属于：

- global config

而不是：

- project 级设置
- 当前会话瞬时状态

### `default` 不是另一个布尔值，而是“把显式配置删掉，回退到有效默认值”

无论 Settings 还是 `ConfigTool`，当值是 `default` 时，都不是把配置写成第三种状态，而是：

- 删除 `remoteControlAtStartup`
- 然后重新调用 `getRemoteControlAtStartup()`

而 `getRemoteControlAtStartup()` 的 precedence 是：

1. 用户显式配置
2. CCR auto-connect default
3. 否则 `false`

所以 `default` 的真实语义不是：

- “等于 false”

而是：

- “不再强行指定，回到当前版本/构建/rollout 下的有效默认”

### `ConfigTool` 暴露的是同一张默认策略面，不是另一套远控命令

`supportedSettings.ts` 里，`remoteControlAtStartup` 只在 `feature('BRIDGE_MODE')` 时暴露，并且：

- `source: 'global'`
- `formatOnRead: () => getRemoteControlAtStartup()`

这说明 `ConfigTool` 读到的不是“原始键值有没有写死”，而是：

- 当前生效的默认 remote-control 结果

所以 Settings 与 `ConfigTool` 的关系更接近：

- 同一张“默认策略面”的两个入口

而不是：

- 一个改设置，一个直接替代 `/remote-control`

但二者也不是完全镜像：

- Settings UI 还要求 `isBridgeEnabled()` 才显示
- `ConfigTool` 只看 `BRIDGE_MODE` 编译开关
- `ConfigTool` 的 GET 返回的是 effective boolean
- `default` 在 `ConfigTool` 里只是 SET 时用来触发“删键并回退默认”的特殊 token

因此更稳的理解是：

- 它们都属于默认策略面
- 但用户在不同入口看到的可见性与读值语义不必完全一样

### 它会同步到当前 `AppState`，但这不把它变成显式控制动作

Settings 和 `ConfigTool` 在写完 `remoteControlAtStartup` 后，都会：

- 重新求 `resolved = getRemoteControlAtStartup()`
- 同步 `replBridgeEnabled = resolved`
- 同步 `replBridgeOutboundOnly = false`

代码这样做，是为了让 `useReplBridge` 立即响应当前配置变化。

但这不意味着：

- “设置项 = 当前用户显式执行了一次 `/remote-control`”

因为 `main.tsx` 初始化时已经把：

- `replBridgeEnabled`
- `replBridgeExplicit`

拆成了不同字段。

更准确的理解是：

- 设置项写的是默认策略
- 运行时同步只是让当前会话尽快跟上这张策略表
- 它并没有把本轮会话改写成“用户刚刚显式按了远控命令”

## 第二层：`remote-control` 命令回答的是“当前 session 现在要不要显式进入 full remote-control”

### `/remote-control` 不是“把设置项改成 true”

`commands/bridge/bridge.tsx` 的判断顺序是：

- 如果当前已经 `replBridgeConnected || replBridgeEnabled`
- 且不是 `replBridgeOutboundOnly`
- 就弹出 disconnect dialog

否则才会：

- 跑 `checkBridgePrerequisites()`
- 把 `replBridgeEnabled = true`
- 把 `replBridgeExplicit = true`
- 把 `replBridgeOutboundOnly = false`

所以 `/remote-control` 的对象不是：

- “修改以后所有 session 的默认”

而是：

- “把当前这条 session 显式升级成 full remote-control”

### 它与 mirror 的关系尤其能说明“命令面 != 设置面”

如果当前是 outbound-only mirror，`/remote-control` 不会把它当作“已经等价开启”，而是继续把它改成：

- `replBridgeExplicit = true`
- `replBridgeOutboundOnly = false`

这说明这个命令的真实动作是：

- 为当前 session 改控制方向并标记显式控制

而不是：

- 简单写一个默认配置值

### 所以命令面回答的是“现在这条会话要不要显式远控”

更稳的区分是：

- `remoteControlAtStartup`：以后默认怎么开
- `/remote-control`：现在这条 session 要不要显式变成 full remote-control

二者都可能让 bridge 变成 enabled，但它们写入的对象不是同一层。

## 第三层：Footer 状态 pill 回答的是“系统愿不愿意把当前桥状态展示给你看”

### Footer pill 不是 bridge 的存在证明，而是受条件约束的展示面

`PromptInputFooter.tsx` 里，pill 的出现有好几层门槛：

- 必须有 `feature('BRIDGE_MODE')`
- 必须 `isBridgeEnabled()`
- 必须 `replBridgeEnabled`

但即使这些都成立，若当前不是 `explicit`，又不是 `reconnecting`，仍然会：

- 直接 `return null`

因此“看不见 pill”并不自动等于：

- 当前没有 bridge

它也可能只是说明：

- 这条 bridge 是隐式带起的，而且当前不在 reconnecting

### PromptInput 连导航也刻意跟着这条展示规则

`PromptInput.tsx` 专门写了注释说明：

- navigation 必须匹配 `BridgeStatusIndicator` 的 render condition
- 否则 bridge 会变成 invisible selection stop

并把可见条件写成：

- `replBridgeConnected && (replBridgeExplicit || replBridgeReconnecting)`

这说明 Footer pill 的职责不是“暴露全部 bridge 真相”，而是：

- 只在合适的时候给用户一个可见、可进入的状态入口

### `Remote Control active` 也是有意压缩后的粗粒度状态

`bridgeStatusUtil.ts` 里：

- `reconnecting` => `Remote Control reconnecting`
- `sessionActive || connected` => `Remote Control active`
- 否则 => `Remote Control connecting…`

这里最关键的一点是：

- `connected`
- `sessionActive`

被故意压缩成同一个用户标签：

- `Remote Control active`

所以 Footer pill 的语义不是：

- “我现在准确告诉你内部状态机走到了哪一格”

而是：

- “我给你一个足够稳定、足够低噪音的用户可见状态摘要”

### 因而“看到 active”不等于“我已经知道全部内部状态”

更稳的判断是：

- pill 只是 coarse status
- 它既不等价于默认策略
- 也不等价于显式控制动作
- 更不等价于完整内部状态机

## 第四层：Bridge Dialog 是查看/断开面，它也不等于设置页

### Bridge Dialog 优先回答“当前桥连到哪里、现在是什么状态”

Bridge Dialog 会根据：

- `sessionActive`
- `connectUrl`
- `sessionUrl`
- `error`
- `reconnecting`

生成当前展示 URL 和状态文本。

这说明它首先是：

- 当前 bridge 的查看面

而不是：

- 通用设置中心

### Dialog 里的 disconnect 也不是统一的“改默认”

`BridgeDialog.tsx` 里按 `d` 断开时：

- 如果 `explicit`，才会把 `remoteControlAtStartup` 持久化写成 `false`
- 无论是否 `explicit`，都会把当前 `replBridgeEnabled` 置为 `false`

这说明同样是“断开”：

- 对显式远控，会顺便把默认策略持久化改成 opt-out
- 对隐式带起的远控，只做当前会话断开

因此 Dialog 回答的问题不是：

- “永远统一地改掉设置页默认”

而是：

- “当前这次断开，是否应该顺便把默认策略也一起改掉”

### 所以 Dialog 是当前桥的查看/断开面，不是设置页的替身

更稳的区分是：

- Settings / `ConfigTool`：改默认
- `/remote-control`：改当前显式控制状态
- Footer pill：展示粗粒度状态
- Bridge Dialog：查看当前桥，并按当前 enable source 决定断开是否持久化

## 第五层：稳定可见面、条件面与内部面要继续保护

### 稳定可见或相对稳定可见的

- Settings 里的 `remoteControlAtStartup`
- `ConfigTool` 的 `remoteControlAtStartup`
- `/remote-control`
- Footer 里的 Remote Control 状态 pill
- Bridge Dialog

这些都是真实用户入口，适合进入正文主线。

### 条件公开或需标注前提的

- Settings 项只在 `BRIDGE_MODE` 和 bridge eligibility 成立时显示
- `ConfigTool` 与 Settings UI 的可见性/读值语义并不完全一致
- `default` 背后仍受 CCR auto-connect default 影响
- 隐式带起的 bridge 平时可能不显示 footer pill
- mirror 模式下 `/remote-control` 会发生升级而不是简单重连

这些也该写进正文，但必须继续提醒：

- 它们受 build gate、资格、rollout 和 enable source 影响

### 更应留在实现边界说明的

- `AppState` 全字段清单
- `getBridgeStatus()` 的所有内部调用点
- invisible selection stop 这类 UI 内部协调细节
- Settings 与 `ConfigTool` 具体 state sync 的重复实现细枝末节

这些可以作为作者判断依据，但不应重新污染读者正文。

## 最后的判断公式

当你看到 Claude Code 里同时存在设置项、命令、状态 pill 和 dialog 时，先问七个问题：

1. 我现在改的是默认策略，还是当前 session 的显式控制动作？
2. 这个入口写入的是 global config，还是只改当前 `AppState`？
3. 我看到的是状态展示，还是实际控制动作？
4. 这个入口读给我的是 raw config，还是 effective value？
5. 这个状态标签是粗粒度摘要，还是完整内部状态机？
6. 这次 disconnect 只是断当前桥，还是顺便持久化改变默认？
7. 我是不是把设置面、控制面、状态面、查看/断开面重新写成了同一个“远控开关”？

只要这六问先答清，就不会把：

- `remoteControlAtStartup`
- `ConfigTool`
- `/remote-control`
- Footer pill
- Bridge Dialog

误写成同一类按钮。

## 源码锚点

- `claude-code-source-code/src/utils/config.ts`
- `claude-code-source-code/src/main.tsx`
- `claude-code-source-code/src/commands/bridge/bridge.tsx`
- `claude-code-source-code/src/components/Settings/Config.tsx`
- `claude-code-source-code/src/tools/ConfigTool/ConfigTool.ts`
- `claude-code-source-code/src/tools/ConfigTool/supportedSettings.ts`
- `claude-code-source-code/src/components/PromptInput/PromptInputFooter.tsx`
- `claude-code-source-code/src/components/PromptInput/PromptInput.tsx`
- `claude-code-source-code/src/components/BridgeDialog.tsx`
- `claude-code-source-code/src/bridge/bridgeStatusUtil.ts`
