# `applyPermissionUpdate`、`persistPermissionUpdate`、`SandboxManager.refreshConfig` 与 `localSettings`：为什么 sandbox permission 的 `persist-to-settings` 不是一次单层 permission 写入

## 用户目标

201 已经把 sandbox network bridge 的同 host sibling sweep 拆开了：

- same-host queue settle
- sibling cleanup

但如果正文停在这里，读者还是很容易把“允许并持久化”这条线继续写平：

- 用户点了 `persistToSettings`，不就是把规则写进 `localSettings` 吗？
- `applyPermissionUpdate(...)` 已经改了本地 state，为什么还要 `persistPermissionUpdate(...)`？
- 既然 sandbox 自己会订阅 settings change，为什么这里还要显式 `SandboxManager.refreshConfig()`？
- local sandbox prompt 和 worker sandbox prompt 不也都长得像 “allow + persist”？
- bridge / SDK 里叫 `SandboxNetworkAccess`，为什么最终落盘时却写成 `WEB_FETCH_TOOL_NAME` 的 `domain:host` 规则？

这句还不稳。

从当前源码看，还得继续拆开三种不同写面：

1. leader 本地 in-memory permission context mutation
2. durable settings persistence
3. live sandbox runtime refresh

如果这三层不先拆开，后面就会把：

- `applyPermissionUpdate(...)`
- `persistPermissionUpdate(...)`
- `SandboxManager.refreshConfig()`

重新压成一句模糊的“持久化权限设置”。

## 第一性原理

更稳的提问不是：

- “为什么这里要连写三次？”

而是先问七个更底层的问题：

1. 用户点击 `persistToSettings` 后，谁需要立刻看到这条规则，是本地 REPL store、设置文件，还是当前正在运行的 sandbox？
2. synthetic `SandboxNetworkAccess` ask 和最终写进 `WEB_FETCH_TOOL_NAME` / `domain:host` 的本地规则，是不是同一张 permission ledger？
3. `applyPermissionUpdate(...)` 改的是磁盘文件，还是 leader 本地的 permission context？
4. `persistPermissionUpdate(...)` 写完之后，当前活跃 sandbox runtime 会不会自动同步到最新规则？
5. 既然 sandbox 已经订阅 settings change，为什么源码还要强调 `refreshConfig()` 必须同步执行？
6. local sandbox prompt 和 worker sandbox prompt 的 persist 分支，在 allow / deny 语义上真的完全一致吗？
7. 我现在分析的是 201 的 host-level sibling sweep，还是 persist 手势的多层状态传播？

只要这七轴不先拆开，后面就会把：

- context mutation
- settings write
- runtime refresh

混成一张“permission persistence 表”。

## 第一层：synthetic `SandboxNetworkAccess` transport shell 不等于最终落盘的本地规则

`structuredIO.ts` 把 sandbox network ask 发给 SDK host 时，用的是：

- `tool_name: SANDBOX_NETWORK_ACCESS_TOOL_NAME`

也就是：

- synthetic `SandboxNetworkAccess`

但 `REPL.tsx` 在本地 / worker 两条 persist 分支里真正构造的更新对象却是：

- `toolName: WEB_FETCH_TOOL_NAME`
- `ruleContent: domain:${approvedHost}`

这说明这里先要拆开两张不同 ledger：

- transport 壳里展示给 bridge / SDK host 的 synthetic network ask
- leader 本地真正落盘的 web-fetch domain rule

所以更准确的理解不是：

- synthetic `SandboxNetworkAccess` = 最终写进设置的规则本体

而是：

- 前者是 permission transport shell
- 后者才是本地持久化规则对象

## 第二层：`applyPermissionUpdate(...)` 先改的是 leader 本地 permission context，不是磁盘

`REPL.tsx` 里，无论是本地 sandbox prompt，还是 worker sandbox prompt 的“允许并持久化”分支，第一步都先做：

- `toolPermissionContext: applyPermissionUpdate(prev.toolPermissionContext, update)`

而 `PermissionUpdate.ts` 里 `applyPermissionUpdate(...)` 的职责也很窄：

- 它按 `setMode` / `addRules` / `replaceRules` / `removeRules` 等类型
- 返回新的 `ToolPermissionContext`

这说明它回答的问题不是：

- “设置文件写好了没有？”

而是：

- “leader 本地现在应当把这条规则视为已经存在吗？”

所以更准确的理解不是：

- `applyPermissionUpdate(...)` = persist

而是：

- `applyPermissionUpdate(...)` = 当前 REPL 治理状态的即时改写

## 第三层：`persistPermissionUpdate(...)` 负责 durable settings write，不负责 live runtime

同一段 `REPL.tsx` 代码在更新本地 context 之后，会继续调用：

- `persistPermissionUpdate(update)`

`PermissionUpdate.ts` 里进一步把这件事拆得很明白：

- 只有 `supportsPersistence(update.destination)` 为真时才会继续
- `localSettings`、`userSettings`、`projectSettings` 才是 persistable destination
- 对 `addRules` 分支，它会走 `addPermissionRulesToSettings(...)`

这说明 `persistPermissionUpdate(...)` 回答的问题不是：

- “当前 sandbox 现在按什么规则运行？”

而是：

- “这条规则该不该写进可持久化设置源，供后续会话和设置读取流程继续看到？”

所以更准确的理解不是：

- `persistPermissionUpdate(...)` = 当前 sandbox 已即时变更

而是：

- `persistPermissionUpdate(...)` = durable settings writer

## 第四层：`SandboxManager.refreshConfig()` 关的是 live sandbox runtime 的即时追平，不是重复持久化

本地 sandbox prompt 分支里，`persistPermissionUpdate(update)` 后面紧接着有注释：

- immediately update sandbox in-memory config
- to prevent race conditions
- where pending requests slip through before settings change is detected

而 `sandbox-adapter.ts` 更直接：

- 初始化时确实注册了 `settingsChangeDetector.subscribe(...)`
- 订阅回调会 `BaseSandboxManager.updateConfig(newConfig)`
- 但 `refreshConfig()` 自己也被注释为
  - Refresh sandbox config from current settings immediately
  - Call this after updating permissions to avoid race conditions

这说明这里回答的问题不是：

- “设置源最终会不会被监听到？”

而是：

- “在监听器稍后探测到变化之前，当前活跃 sandbox runtime 会不会先漏掉一个 stale window？”

所以更准确的理解不是：

- `refreshConfig()` 只是重复写一次同样的设置

而是：

- durable settings change 是一条最终一致的路径
- `refreshConfig()` 则是为当前运行时补上同步追平

## 第五层：local sandbox 与 worker sandbox 的 persist 分支不是同一条合同

同样叫 `persistToSettings`，两条入口并不完全对称。

本地 sandbox prompt 分支里：

- 只要 `persistToSettings`
- 就会构造 `behavior: (allow ? 'allow' : 'deny')`

也就是说：

- allow 可以持久化
- deny 也可以持久化

但 worker sandbox prompt 分支里，代码条件是：

- `if (persistToSettings && allow)`

并且写死：

- `behavior: 'allow'`

这说明这两条线回答的问题并不一样：

- 本地 host prompt 在处理 “要不要把 allow / deny 规则写进 leader 本地设置”
- worker sandbox prompt 则只处理 “allow 是否要顺手扩进 leader 本地规则”

所以更准确地理解不是：

- 两条 persist 分支只是同一逻辑复制两遍

而是：

- 它们共享三层写面模型
- 但不共享完全相同的行为边界

## 第六层：稳定层、条件层与灰度层

### 稳定可见

- persist 手势会同时牵动本地 context、durable settings 与 live sandbox runtime 三层对象。
- `persistPermissionUpdate(...)` 与 `refreshConfig()` 不是替代关系。

### 条件公开

- worker sandbox 那条线只有 allow 时才会把规则写进 `localSettings`。
- `SandboxManager.refreshConfig()` 只有 sandbox 真正启用时才会生效；函数自身也会先检查 `isSandboxingEnabled()`。

### 内部/灰度层

- `settingsChangeDetector.subscribe(...)` 的异步追平节奏
- `BaseSandboxManager.updateConfig(...)` 的内部实现
- local sandbox 与 worker sandbox persist 分支的 exact wiring 与 helper 顺序

这些都说明这里不是单纯的“写规则”动作，

而是一组跨 store / settings / runtime 的同步合同。

所以这页最稳的结论必须停在：

- persist 手势会跨 context / settings / runtime 三层传播
- `persistPermissionUpdate(...)` 与 `refreshConfig()` 不是替代关系

而不能滑到：

- sandbox permission persist = 一次单层 settings write

## 第七层：这页不是 201，也不是 73 / 78

先和 201 划清：

- 201 讲的是同 host sibling sweep
- 202 讲的是 persist 手势把规则传播到哪几层写面

201 的主语是：

- host-level settle / cleanup

202 的主语是：

- state propagation across context / settings / runtime

再和 73 划清：

- 73 讲 remote session 里本地 tool plane 的主权
- 202 讲一次 sandbox persist 手势如何同时落到这张本地主权图的多个层次

最后和 78 划清：

- 78 讲 worker sandbox ask 不等于 leader 本地 network prompt
- 202 只抓它们在 persist 分支上共享但不完全对称的三层写面

## 结论

所以这页能安全落下的结论应停在：

- sandbox permission 的 `persist-to-settings` 不是一次单层写入
- `applyPermissionUpdate(...)` 改的是 leader 本地 permission context
- `persistPermissionUpdate(...)` 写的是 durable settings source
- `SandboxManager.refreshConfig()` 追的是当前 live sandbox runtime
- local sandbox 与 worker sandbox 还共享同一模型、但不共享完全相同的 allow / deny 边界

一旦这句成立，

就不会再把：

- 本地 state 改写
- 设置持久化
- 运行时刷新

写成同一种 side effect。
