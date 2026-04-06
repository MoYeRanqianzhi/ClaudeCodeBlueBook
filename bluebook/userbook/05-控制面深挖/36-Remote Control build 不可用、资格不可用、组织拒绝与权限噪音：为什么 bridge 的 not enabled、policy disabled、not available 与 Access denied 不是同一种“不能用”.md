# `Remote Control` build 不可用、资格不可用、组织拒绝与权限噪音：为什么 bridge 的 `not enabled`、`policy disabled`、`not available` 与 `Access denied` 不是同一种“不能用”

## 用户目标

不是只知道 Claude Code 里“有时 `/remote-control` 根本不能开，有时 `claude remote-control` 说 `Remote Control is not available in this build`，有时说 `not yet enabled for your account`，有时又是 `disabled by your organization's policy`，还有时运行中突然冒出 `Access denied (403)`”，而是先分清六类不同对象：

- 哪些属于 build 根本没带 bridge。
- 哪些属于账号 / 产品资格还没开到你这里。
- 哪些属于组织策略明确禁用了 remote-control。
- 哪些属于运行时去注册或访问 remote-control 环境时，发现这项能力对你的账户或组织根本不可用。
- 哪些属于核心能力真的被权限拒绝。
- 哪些只是附属操作缺权限，但源码故意不打扰用户。

如果这些对象不先拆开，读者最容易把下面这些文案压成同一种“不能用”：

- `Remote Control is not available in this build.`
- `Remote Control is not yet enabled for your account.`
- `Remote Control is disabled by your organization's policy.`
- `Remote Control environments are not available for your account.`
- `Access denied (403) ... Check your organization permissions.`
- suppressible `403`

## 第一性原理

remote-control 的“不能用”至少沿着四条轴线分化：

1. `Capability Plane`：坏掉的是 build 能力、账号资格、组织策略、运行时环境可用性，还是附属操作权限。
2. `Failure Timing`：这是启动前 preflight 就能判定的拒绝，还是启动后 API 才暴露出来的拒绝。
3. `User Action`：当前更合理的动作是换构建、重新登录、等开通、找管理员、接受当前账户不可用，还是忽略一条不影响主能力的噪音。
4. `Visibility Policy`：源码这次应该公开报错，还是应当静默压制，避免把非核心权限噪音冒充成主能力不可用。

因此更稳的提问不是：

- “为什么 Remote Control 又不能用了？”

而是：

- “这次卡住的是 build、账号资格、组织策略、运行时环境，还是一条不影响核心能力的附属权限；源码因此决定公开报错还是静默压制？”

只要这四条轴线没先拆开，正文就会把 build 不带、资格未开、组织禁用、运行时拒绝与 suppressible 403 写成同一种“不能用”。

## 第一层：`not available in this build` 说明这份构建根本不带这项能力

### 这不是登录问题，也不是组织策略问题

`bridgeEnabled.ts` 的 `getBridgeDisabledReason()` 最后直接返回：

- `Remote Control is not available in this build.`

这里先回答的问题不是：

- 你有没有登录
- 组织有没有允许
- 当前账户有没有开通

而是：

- 当前这份 build 根本没有 bridge mode 可供使用

### 所以它属于 build-plane refusal

更稳的理解应是：

- 这不是再试一次会变好的问题
- 也不是找管理员就能解决的策略问题
- 它说明你当前用的构建本身不包含这项能力

只要这一层没拆开，正文就会把 build 缺失偷写成：

- “只是当前没给你权限”

## 第二层：`not yet enabled for your account` 说明能力存在，但资格还没落到你

### 账号资格门与 build 能力门不是一回事

同一个 `getBridgeDisabledReason()` 里，如果：

- 你不是 claude.ai 订阅用户
- token 不具备 full-scope profile 能力
- 账号信息里拿不到 organization
- `tengu_ccr_bridge` gate 还没开到你

系统会给出四种不同的资格门提示：

- `requires a claude.ai subscription`
- `requires a full-scope login token`
- `Unable to determine your organization`
- `Remote Control is not yet enabled for your account`

这说明这里坏掉的不是：

- build 根本没有 bridge

而是：

- build 有这项能力
- 但你的账号 / 登录材料 / rollout 资格还不满足进入条件

### 因而这是 account-entitlement plane

更准确的写法应是：

- `not available in this build` = 能力不存在
- `not yet enabled for your account` = 能力存在，但资格没落到你

只要这一层没拆开，`build unavailable` 与 `entitlement unavailable` 就会继续被写成同一种“没开通”。

## 第三层：`disabled by policy` 说明组织主动拒绝，而不是产品面没给你

### `/remote-control` 与 `claude remote-control` 都会先过 policy limit

`commands/bridge/bridge.tsx` 的 `checkBridgePrerequisites()` 和 `entrypoints/cli.tsx` 的 standalone fast-path 都会先等待：

- `waitForPolicyLimitsToLoad()`

然后检查：

- `isPolicyAllowed('allow_remote_control')`

没通过时直接报：

- `Remote Control is disabled by your organization's policy.`

这说明这里回答的问题不是：

- 当前 build 有没有这项能力
- 当前账号是不是 rollout 命中的用户

而是：

- 组织层明确说这项能力当前不允许使用

### 所以组织策略禁用不应被偷写成“账号没资格”

更稳的区分是：

- 资格门：产品面还没开给你
- 组织策略：产品可用，但你的组织主动不允许

只要这一层没拆开，正文就会把：

- gate false
- policy false

压成同一种“没开通”。

## 第四层：`not available for your account` 与 `not available for this organization` 是运行时环境可用性问题

### preflight 通过以后，运行时仍可能发现 remote-control 环境根本不可注册

`bridgeApi.ts` 对 `404` 的通用翻译是：

- `Remote Control may not be available for this organization.`

而 `bridgeMain.ts` 在注册 bridge environment 的具体上下文里，又把 `404` 收窄成：

- `Remote Control environments are not available for your account.`

这说明这里坏掉的对象已经不是：

- 入口前的 build/gate/policy

而是：

- 真正去注册 remote-control environment 时，后端告诉你这个环境面根本不给你

### 这和“组织策略禁用”也不是一回事

更准确的理解是：

- `disabled by policy`：本地 preflight 就知道组织不允许
- `not available for your account` / `organization`：直到运行时调用环境 API，才发现后端根本不提供这项环境能力

因此更稳的写法应是：

- 一个是 local preflight denial
- 一个是 runtime availability denial

## 第五层：`Access denied (403)` 是核心权限真的被拒，不是所有 `403` 都值得展示

### 非 expiry 的 `403` 明确指向组织权限检查

`bridgeApi.ts` 对非 expiry 的 `403` 会抛出：

- `Access denied (403) ... Check your organization permissions.`

`bridgeMain.ts` 与 `replBridge.ts` 都把这类 fatal error 当作真正的用户面处理：

- root host 会报错退出
- REPL 会把状态打成 failed 并展示错误

这说明这里坏掉的是：

- 核心 remote-control 能力所依赖的权限真的被拒

而不是：

- 一条可以忽略的附属权限噪音

### 所以用户正文应该写“核心权限被拒绝”，而不是“HTTP 403”

更稳的用户心智是：

- 这里的动作面是检查组织权限 / 管理员配置
- 不是简单把所有 `403` 都理解成“桥断了”

## 第六层：suppressible `403` 属于附属权限噪音，源码故意不让它冒充主能力不可用

### 不是所有权限拒绝都值得打到用户面

`bridgeApi.ts` 里专门定义了：

- `isSuppressible403(err)`

它只针对：

- `external_poll_sessions`
- `environments:manage`

这类 scope / side-operation 权限缺口。

注释写得很直白：

- 它们不影响 core functionality
- 不应该展示给用户

### root host 与 REPL 都执行同一条“降噪政策”

`bridgeMain.ts` 的 fatal loop 里，如果命中 suppressible `403`：

- 只写 debug，不展示给用户

`replBridge.ts` 里也一样：

- suppress user-visible error
- 但 cleanup / teardown 仍然照跑

这说明这里最关键的系统政策不是：

- “也是 403，所以也该告诉用户”

而是：

- 这是附属权限噪音
- 不该冒充成主能力不可用

### 因而 suppressible `403` 应进入 memory，不应成为 reader 正文主角

只要这一层没拆开，正文就会把：

- 核心权限被拒
- 附属权限缺口

继续写成同一种“Remote Control 不能用”。

## 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `not available in this build` = 当前账号没资格 | 一个是 build 缺失，一个是 entitlement 未开 |
| `not yet enabled for your account` = 组织策略禁用 | 一个是产品资格，一个是组织显式禁止 |
| `disabled by policy` = 运行时环境不可用 | 一个是 preflight denial，一个是 runtime availability denial |
| `Access denied (403)` = 所有 403 都该展示 | 只有核心权限拒绝应该进入用户面 |
| suppressible `403` = Remote Control 主能力不可用 | 它是附属权限噪音，源码故意压制 |

## stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | build 不可用、账号资格未开、组织策略禁用、运行时环境不可用、核心权限拒绝 |
| 条件公开 | full-scope token、organization eligibility、runtime 404 在不同上下文里的收窄文案 |
| 内部/实现层 | `isSuppressible403`、`external_poll_sessions` / `environments:manage`、fatal loop 的降噪策略 |

## 源码锚点

- `claude-code-source-code/src/bridge/bridgeEnabled.ts`
- `claude-code-source-code/src/commands/bridge/bridge.tsx`
- `claude-code-source-code/src/entrypoints/cli.tsx`
- `claude-code-source-code/src/bridge/bridgeApi.ts`
- `claude-code-source-code/src/bridge/bridgeMain.ts`
- `claude-code-source-code/src/bridge/replBridge.ts`
