# `can_use_tool`、`SandboxNetworkAccess`、hook/classifier 与 `control_cancel_request`：为什么 remote-control 的工具审批、网络放行、自动批准与提示撤销不是同一种批准

## 用户目标

不是只知道 Claude Code 的 remote-control 里会出现：

- 工具权限提示
- 远端 allow / deny
- sandbox 网络连接提示
- hook / classifier 自动批准
- 某些提示又会自己消失

而是先分清五类不同对象：

- 哪些是在决定某一次真实工具调用能不能执行。
- 哪些是在决定 sandbox 运行时能不能连出某个 host。
- 哪些是在争夺“谁先给出批准结果”。
- 哪些是在给已经输掉竞态的提示做收口。
- 哪些虽然也走 `control_request`，但其实属于 session control，不属于这页的批准面。

如果这些对象不先拆开，读者最容易把下面这些东西压成同一种“remote-control 批准”：

- `can_use_tool`
- `SandboxNetworkAccess`
- 本地确认框
- bridge 远端允许 / 拒绝
- channel reply
- hook decision
- classifier auto-allow
- `cancelRequest(...)`
- `control_cancel_request`
- `set_permission_mode`

## 第一性原理

remote-control 的“批准”至少沿着四条轴线分化：

1. `Decision Object`：当前在批准的，是某次工具调用，还是某次网络连接。
2. `Decider`：当前是谁给出结论，是本地用户、bridge 远端、channel、hook，还是 classifier。
3. `Race Model`：这些结论是单线串行，还是多方并行竞争、谁先赢谁生效。
4. `Prompt Teardown`：当前动作是在给出 allow / deny，还是只是在收掉已经过时的提示。

因此更稳的提问不是：

- “remote-control 现在是不是在批准这件事？”

而是：

- “这次在批准的是工具还是网络连接；谁在和谁竞争；当前动作是给结论，还是在收掉输掉的 prompt？”

只要这四条轴线没先拆开，正文就会把 allow、deny、auto-approve 与 cancel 写成同一种批准。

## 第一层：普通 `can_use_tool` 首先是某次工具调用的逐次批准

### 它问的不是“你有没有这个能力”，而是“这次调用能不能过”

`structuredIO.ts` 在工具权限进入 `ask` 分支后，会为当前工具调用立刻发一个：

- `subtype: 'can_use_tool'`
- `tool_name`
- `input`
- `tool_use_id`

这说明它回答的问题不是：

- 这条 session 总体有没有工具权限

而是：

- 这一次具体工具调用，带着这份输入，能不能执行

### 它天然就不是 remote-control 独占的单线审批

同一段代码会先启动：

- hook 的后台判断

再并行发起：

- SDK / remote consumer 的权限提示

并用 `Promise.race(...)` 等谁先返回。

因此更准确的理解应是：

- `can_use_tool` 是逐次调用级别的权限问题
- remote-control 只是可能参与回答它的一方
- 它不是“只要 remote-control 开着，所有批准都由远端独占”

### 所以工具批准和 session control 不是同一种对象

这也是为什么：

- `set_model`
- `set_permission_mode`
- `set_max_thinking_tokens`

不该被写进这一页的同一层。

它们改的是 session 参数，不是在回答某一次工具调用能不能执行。那条边界应回到第 29 页去看。

## 第二层：`SandboxNetworkAccess` 复用了 `can_use_tool` 协议，但批准对象已经变了

### sandbox 初始化时会专门挂一个 network ask callback

`print.ts` 在 sandbox 真正启用时，会调用：

- `SandboxManager.initialize(structuredIO.createSandboxAskCallback())`

这说明 sandbox 网络访问不是普通工具调用顺手带出来的副作用，而是一条专门的运行时放行回路。

### 这条回路复用的是 `can_use_tool`，但 tool name 是合成的

`structuredIO.ts` 里明确把：

- `SandboxNetworkAccess`

定义成一个 synthetic tool name，并在 `createSandboxAskCallback()` 里发送：

- `subtype: 'can_use_tool'`
- `tool_name: 'SandboxNetworkAccess'`
- `input: { host }`
- `description: Allow network connection to ...`

因此更稳的理解应是：

- transport 一样，还是 `can_use_tool`
- decision object 已经变了，不再是某个真实工具调用
- 当前批准的是 sandbox 运行时能否连出某个 host

### 所以“工具审批”和“网络放行”不能因为共用协议就写成同一种批准

更准确的区分是：

- tool approval：批准某个真实工具 use
- sandbox network ask：批准某个网络连接目标

只要这一层没拆开，正文就会把：

- `Read` / `Bash` / `Edit`
- `SandboxNetworkAccess`

压成同一种“工具权限提示”。

## 第三层：真正参与批准竞态的，不只 bridge 远端一个人

### 本地确认框仍然是地板，不是 bridge 的附属 UI

`interactiveHandler.ts` 会先把当前权限提示推进本地队列，并提供：

- `onAllow`
- `onReject`
- `onAbort`
- `recheckPermission`

这说明 remote-control 开着的时候，本地确认框并没有消失。

### bridge 远端只是竞态中的一名参与者

同一文件会在 bridge 存在时：

- `sendRequest(...)`
- `onResponse(...)`

并明确写出：

- whichever side responds first wins via `claim()`

因此 remote-control 的远端批准不是总控台，而是竞态参与者之一。

### channel relay、hook、classifier 也都可能赢

同一条交互权限链还会并行启动：

- channel permission relay
- PermissionRequest hooks
- bash classifier auto-allow

并且每条支路在真正落地前都会先做：

- `claim()`

`PermissionContext.ts` 里把 `claim()` 定义成原子 check-and-mark。谁先 claim，谁赢；后来的支路即使也算出了结果，也不再生效。

### 因而“批准者”至少分成五类

| 批准者 | 回答的问题 | 常见结果 |
| --- | --- | --- |
| 本地用户 | 我现在手动允许还是拒绝 | allow / deny / abort |
| bridge 远端 | 远端 UI 要不要放行 | allow / deny，且可能带 `updatedInput` / `updatedPermissions` |
| channel | 外部消息入口要不要放行 | allow / deny |
| hook | 本地规则脚本有没有先给结论 | allow / deny |
| classifier | 自动模式 / bash classifier 能否直接放行 | allow |

因此更稳的理解应是：

- remote-control 的批准面不是“一个远端按钮”
- 而是一组并行竞争的批准者

## 第四层：`cancelRequest` 与 `control_cancel_request` 解决的是 prompt 收口，不是 deny

### bridge prompt 的收口，和最终结论不是一回事

`bridgePermissionCallbacks.ts` 给 bridge permission callbacks 单独定义了：

- `cancelRequest(requestId)`

注释写得很清楚：

- 这是为了让 web app dismiss pending prompt

这说明它回答的问题不是：

- 最终结果是 allow 还是 deny

而是：

- 这张已经没有必要继续显示的 prompt，该不该收掉

### 当本地 / hook / classifier 赢时，会主动取消 bridge 那边的旧 prompt

`interactiveHandler.ts` 里：

- 本地 allow / reject / abort
- hook 先返回
- classifier 先返回
- channel 先返回

这些路径都会调用：

- `bridgeCallbacks.cancelRequest(bridgeRequestId)`

因此 `cancelRequest` 更像：

- loser prompt teardown

而不是：

- 一次新的拒绝决定

### 当 bridge 赢时，又会反向给 SDK consumer 发 `control_cancel_request`

`structuredIO.ts` 的 `injectControlResponse(...)` 明确写着：

- bridge 把来自 claude.ai 的 `control_response` 注入本地 SDK flow
- 同时写一个 `control_cancel_request`
- 否则 SDK consumer 那边的 `canUseTool` callback 会一直挂着

这说明另一侧也有独立的提示收口：

- bridge 赢了
- SDK / 本地等待方必须被 abort

### `print.ts` 还会把“本地赢了”同步回 bridge 侧做反向收口

bridge 初始化成功后，`print.ts` 会注册：

- `setOnControlRequestSent(...)`
- `setOnControlRequestResolved(...)`

其中后者的作用就是：

- 当 SDK consumer 先解决 `can_use_tool`
- 立刻通知 bridge 发送 `control_cancel_request`

因此更准确的理解是：

- allow / deny 解决的是最终结论
- `cancelRequest` / `control_cancel_request` 解决的是输掉竞态的一方如何闭嘴

只要这一层没拆开，正文就会把：

- “用户拒绝了”
- “旧 prompt 被撤掉了”

写成同一种 `deny`。

## 第五层：稳定、条件与内部三层要分开保护

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | 本地权限确认框、bridge 远端 allow / deny、sandbox 网络访问提示 |
| 条件公开 | channel permission relay、classifier auto-approve、远端返回 `updatedPermissions` 的持久化 |
| 内部/实现层 | `claim()`、`cancelRequest(...)`、`control_cancel_request`、synthetic tool name、pending callback 清理 |

这里尤其要避免两种写坏方式：

- 把条件能力写成永远可见的主线批准面
- 把内部收口机制写成用户能直接操作的“拒绝按钮”

## 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `can_use_tool` = 只有真实工具审批 | 它也能承载 `SandboxNetworkAccess` 这类合成网络放行请求 |
| remote-control = 唯一批准者 | 本地 UI、bridge、channel、hook、classifier 都可能先赢 |
| auto-approve = 没有 prompt | prompt 可能已出现，也可能只是被更快的结论收掉 |
| `cancelRequest` = deny | 它解决的是 stale prompt teardown，不是新的拒绝结论 |
| `control_cancel_request` = 用户点击拒绝 | 它只是把输掉竞态的一侧 abort 掉 |
| 网络放行 = 某个工具自己申请权限 | 它是 sandbox runtime 的独立 host-level 连接判断 |
| 这页 = session 改参说明 | `set_permission_mode` / `set_model` 属于第 29 页那条 control contract 边界 |

## 六个高价值判断问题

- 当前批准的是某次工具调用，还是某个网络连接目标？
- 这次结论来自本地用户、bridge、channel、hook，还是 classifier？
- 这是单线审批，还是多方并行竞态？
- 当前动作是在给 allow / deny，还是只是在收掉已经过时的 prompt？
- 我是不是把 `SandboxNetworkAccess` 写成了普通工具？
- 我是不是又把 `cancelRequest` / `control_cancel_request` 写成了“拒绝”本身？

## 源码锚点

- `claude-code-source-code/src/cli/structuredIO.ts`
- `claude-code-source-code/src/cli/print.ts`
- `claude-code-source-code/src/hooks/toolPermission/handlers/interactiveHandler.ts`
- `claude-code-source-code/src/hooks/toolPermission/PermissionContext.ts`
- `claude-code-source-code/src/bridge/bridgePermissionCallbacks.ts`
