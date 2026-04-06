# Workspace Trust、Bridge Eligibility 与 Trusted Device：为什么 remote-control 的 trust、auth、policy 不是同一把钥匙

## 用户目标

不是只知道 Claude Code “要先 trust、要先 login、还可能受组织策略限制”，而是先分清四件事：

- `remote-control` 为什么要求你先在该目录跑一次普通 `claude`。
- `/login` 之后为什么又会多出一层 trusted-device 认证，而它并不等于 workspace trust。
- bridge 的 feature gate、最小版本、订阅资格和组织策略，为什么也不是 trust 的别名。
- 为什么同样都像“远程控制前提”，它们却分属三个不同对象层。

如果这四件事不先拆开，读者最容易把下面这些对象混成一锅“remote-control 已被信任”：

- workspace trust / Trust Dialog
- `checkHasTrustDialogAccepted()`
- `remote-control` 的 OAuth 登录前提
- `allow_remote_control` 组织策略
- bridge entitlement / 最低版本检查
- `X-Trusted-Device-Token`
- `/login` 后的 trusted-device enrollment

## 第一性原理

`remote-control` 不是只有一道“能不能用”的门，而是至少三道不同的门：

1. `Workspace Trust`：当前目录能不能成为受信任的 bridge host 工作区。
2. `Bridge Eligibility`：当前账号、版本、策略、产品开关能不能进入 remote-control。
3. `Trusted Device Auth`：这台设备在 bridge / code-session API 上要不要附带更高安全级别的设备令牌。

因此更稳的提问不是：

- “为什么 remote-control 还没通过信任？”

而是：

- “我现在卡住的是工作区 trust、bridge 资格门，还是 trusted-device 认证层？”

只要不先拆开这三层，`trusted`、`login`、`allow_remote_control` 就会被误写成同一把钥匙。

## 第一层：Workspace Trust 是 bridge host 的目录前提

### standalone `claude remote-control` 不会替你弹 trust dialog

`bridgeMain.ts` 的帮助文本和错误提示都很直接：

- Remote Control 允许你从 `claude.ai/code` 或 Claude app 控制本地会话
- 但先决条件之一是：先在目标目录运行普通 `claude`
- 接受 workspace trust dialog

真正进入 `bridgeMain(...)` 之后，它也会立刻做：

- `enableConfigs()`
- `setOriginalCwd(dir)` / `setCwdState(dir)`
- `checkHasTrustDialogAccepted()`

如果没过，就直接报错：

- 先在该目录运行 `claude`
- review 并 accept workspace trust dialog

所以 standalone bridge fast-path 的真实语义是：

- 不负责显示 trust UI
- 只负责验证“此前是否已经建立 trust”

### headless bridge 也继承同一条 prior-trust 规则

`runBridgeHeadless(...)` 里也有同样的判断：

- `enableConfigs()`
- `checkHasTrustDialogAccepted()`
- 未通过时抛出 `Workspace not trusted`

这说明：

- headless bridge worker 不是“绕过 trust 的内部捷径”
- 它只是另一条不弹 UI 的 bridge 宿主路径

### 交互 `/remote-control` 则建立在当前 REPL 的 trust 链之后

交互会话里，顺序不同。

普通交互启动会先走：

- `showSetupScreens(...)`

而 `showSetupScreens(...)` 会：

- 必要时渲染 `TrustDialog`
- trust 通过后标记 `setSessionTrustAccepted(true)`

只有这条链完成之后，`main.tsx` 才继续解析：

- `--remote-control`
- `remoteControlAtStartup`

因此更准确的说法是：

- standalone / headless bridge 需要 prior trust
- 交互 REPL 下的 `/remote-control` 建立在 current-session trust 之后

### “此前已 trust” 也不只是一条固定路径记录

`computeTrustDialogAccepted()` 的逻辑还说明：

- home directory 情况下可能只有 session-level trust
- 持久 trust 会先看项目保存路径
- 然后再沿当前工作目录向上检查父目录链

所以更稳的用户心智是：

- bridge 要求的是“当前目标目录已在 trust 语义上被覆盖”

而不是：

- “某个单一 JSON 字段必须在当前目录这一层精确命中”

## 第二层：Bridge Eligibility / OAuth / Policy 是产品资格门，不是 trust 的另一张脸

### CLI fast-path 先过 auth、entitlement、版本和组织策略

`entrypoints/cli.tsx` 对 `claude remote-control` 的 fast-path 顺序很清楚：

1. 检查 Claude OAuth token
2. `getBridgeDisabledReason()`
3. `checkBridgeMinVersion()`
4. 等待 policy limits 并检查 `allow_remote_control`
5. 通过后才进入 `bridgeMain(...)`

这说明 `remote-control` 在产品层至少还有四道资格门：

- 是否已登录
- bridge gate 是否开放
- 当前版本是否达标
- 组织策略是否允许

它们回答的都不是：

- 这个目录是否可信

而是：

- 这个账号/组织/版本/产品面，当前能不能进入 remote-control

### REPL `/remote-control` 也有自己的 preflight，但对象仍不是 workspace trust

`commands/bridge/bridge.tsx` 的 `checkBridgePrerequisites()` 会检查：

- `allow_remote_control`
- `getBridgeDisabledReason()`
- bridge 最低版本
- bridge access token

如果失败，就返回：

- policy disabled
- not enabled
- version mismatch
- login instruction

这条链同样说明：

- `/remote-control` preflight 解决的是 bridge 资格问题
- 不是 workspace trust UI 的替代实现

更直接地说：

- trust 决定“这块目录能不能成为受信任工作区”
- bridge preflight 决定“这个账号/产品面现在能不能远控”

### `isBridgeEnabled()` 自身就说明它是条件公开能力

`isBridgeEnabled()` 的实现把它写得很清楚：

- `feature('BRIDGE_MODE')`
- `isClaudeAISubscriber()`
- `getFeatureValue_CACHED_MAY_BE_STALE('tengu_ccr_bridge', false)`

因此 bridge/remote-control 从一开始就不应写成：

- 无条件稳定主线

更稳的写法是：

- 条件公开能力
- 既受 build-time feature gate，也受订阅/产品 gate 影响

## 第三层：Trusted Device 是 bridge/code-session 的设备认证层，不是 workspace trust

### `trusted-device` 的对象不是目录，而是设备与账号会话

`trustedDevice.ts` 的注释写得非常硬：

- bridge sessions 在服务端属于 `SecurityTier=ELEVATED`
- 当服务端 enforcement 打开时，需要 trusted device
- CLI 侧的 gate 决定是否发送 `X-Trusted-Device-Token`

这说明 trusted-device 回答的问题不是：

- “这块工作区信不信”

而是：

- “这台设备有没有为当前账号会话拿到更高安全级别的设备令牌”

### enrollment 必须发生在 `/login` 之后的新鲜会话窗口

同一个文件还写清楚：

- enrollment 走 `POST /auth/trusted_devices`
- 服务端要求 `account_session.created_at < 10min`
- 所以它必须在 `/login` 期间完成

`commands/login/login.tsx` 也明确做了这件事：

- 清掉旧账号残留的 trusted-device token
- 然后异步 `enrollTrustedDevice()`

因此更准确的理解是：

- `/login` 不只是拿 OAuth token
- 还可能顺手把当前设备注册成 trusted device

但这仍不等于：

- 工作区 trust 已经通过

### token 是持久设备令牌，不是目录级 accept 记录

`trustedDevice.ts` 还写了两条关键事实：

- token 持久化到 secure storage / keychain
- 默认 90 天滚动过期

并且：

- env var 可覆盖
- gate 关闭时可完全不发送

所以 trusted-device 的真实心智应是：

- 账号/设备认证材料

而不是：

- repo trust 记录

### header 的使用面也不是普通会话 UI

`bridgeApi.ts` 和 `codeSessionApi.ts` 都明确说明：

- bridge API / code session API 会在可用时附带 `X-Trusted-Device-Token`

这再次说明 trusted-device 的位置是：

- bridge/code-session 网络调用层

不是：

- 交互 trust dialog
- slash 命令设置页
- 项目配置批准层

## 第四层：所以 `trusted` 这个词在 bridge 语境里至少有三种不同含义

这是本页最重要的收敛结论。

更稳的区分是：

- `workspace trusted`：目录已通过 Trust Dialog 语义
- `bridge allowed`：账号/版本/策略/产品 gate 允许 remote-control
- `trusted device`：设备在 bridge/code-session API 上具备 elevated auth 材料

它们可以同时成立，也可以分别失败。

例如：

- 目录已 trust，但组织策略禁了 `allow_remote_control`
- 账号已登录且 bridge gate 开着，但目录还没 trust
- 目录已 trust、bridge 也可用，但 trusted-device gate 没开或 token 还没 enrollment

所以 userbook 里不应再出现这种写法：

- “remote-control 已经 trusted”

更稳的写法必须写全对象：

- “该目录已通过 workspace trust”
- “当前账号满足 remote-control 资格门”
- “当前设备具备 trusted-device token”

## 第五层：稳定公开面、条件面与内部面也要继续分层

### 稳定公开的

- Trust Dialog / workspace trust
- `/login`
- `allow_remote_control` 这类明确的组织策略效果

这些都是用户能稳定感知到的对象。

### 条件公开的

- `remote-control`
- `/remote-control`
- bridge entitlement / subscriber gate
- trusted-device header 是否实际发送

这些对象真实存在，但语气应保持：

- 条件公开
- 受 build gate / 订阅 / 账号态 / 服务端 enforcement 影响

### 内部或不应抬高的

- headless bridge worker 细节
- SDK 预先授权路径
- rollout 先后顺序与 Anthropic 内部 gate 注释

这些对作者判断很重要，但不应直接抬成：

- 用户主线能力说明

## 最后的判断公式

遇到 bridge / remote-control 一类问题时，先问五个问题：

1. 我现在卡的是 workspace trust，还是 bridge 资格门？
2. 当前问题是目录级 trust，还是账号级 login？
3. 这里说的是 trusted device，还是 trusted workspace？
4. 当前入口是在做交互 trust，还是在验证 prior trust？
5. 我是不是把 `allow_remote_control`、OAuth、trusted-device token 和 trust dialog 写成了同一种前提？

只有这五问先答清，才不会把：

- trust
- login
- policy
- gate
- trusted-device

误写成同一个“远程控制已被信任”的状态。

## 源码锚点

- `claude-code-source-code/src/bridge/bridgeMain.ts`
- `claude-code-source-code/src/entrypoints/cli.tsx`
- `claude-code-source-code/src/commands/bridge/bridge.tsx`
- `claude-code-source-code/src/bridge/bridgeEnabled.ts`
- `claude-code-source-code/src/commands/login/login.tsx`
- `claude-code-source-code/src/bridge/trustedDevice.ts`
- `claude-code-source-code/src/bridge/bridgeApi.ts`
- `claude-code-source-code/src/bridge/codeSessionApi.ts`
- `claude-code-source-code/src/interactiveHelpers.tsx`
- `claude-code-source-code/src/utils/config.ts`
