# `assistant viewer`、`--remote` TUI、`viewerOnly`、`remoteSessionUrl` 与 `filterCommandsForRemoteMode`：为什么同一 coarse remote bit 不等于同样厚度的 remote 合同

## 用户目标

145 已经把一个运行时截面讲清楚了：

- `getIsRemoteMode()` 为真
- `remoteSessionUrl` 缺席

时，坏掉的是 link/QR affordance，不是 CCR runtime 本体。

但如果停在这一步，读者还会自然追问：

- assistant viewer 到底是不是“少一个 URL 的 `--remote` TUI”？
- 既然两条路径都 `setIsRemoteMode(true)`，又都走 `remoteSessionConfig`，为什么还不能写成同一种 remote mode？

这轮要补的不是：

- 再做一次“URL 缺席影响表”

而是：

- 把 assistant viewer 与 `--remote` TUI 写成两种不同厚度的 remote 合同

## 第一性原理

更稳的提问不是：

- “它们都 remote，那不就是同一种模式吗？”

而是先问五个更底层的问题：

1. 两条路径共享的到底是 coarse bit，还是完整合同？
2. 客户端当前是“纯 viewer”，还是“本地 TUI 控制远端会话”？
3. 当前初始态是否种下了 URL、prompt、session ownership 这些更厚的载荷？
4. 当前客户端有没有 title、timeout、interrupt、history paging 这些控制权？
5. 如果命令壳看起来一样薄，它能不能反推出合同厚度也一样？

只要这五问先拆开，assistant viewer 就不会再被误写成：

- “只是少一个 URL 的 `--remote` TUI”

## 第一层：两条路径确实共享同一个外壳

这一层必须先承认，不然后面会失真。

assistant viewer 与 `--remote` TUI 在启动骨架上确实很像：

- 都会 `setIsRemoteMode(true)`
- 都会 `createRemoteSessionConfig(...)`
- 都会先把本地命令面压成 `filterCommandsForRemoteMode(commands)`
- 都会用 `remoteCommands`、`remoteSessionConfig` 进入 `launchRepl(...)`
- `initialTools` 都是空
- `mcpClients` 都是空

也就是说，两条路径共享的是：

- coarse remote bit
- thin remote-safe local shell

这一层如果只看表面，非常容易让人误判成：

- “合同也一样，只是有的路径多了几个展示字段”

但这正是要往下拆的地方。

## 第二层：assistant viewer 的 `remoteSessionConfig` 从一开始就是 `viewerOnly`

两条路径都创建 `remoteSessionConfig(...)`，

但参数并不一样。

### assistant viewer

- `viewerOnly = true`
- `hasInitialPrompt = false`

而且 `main.tsx` 的注释直接把它定义成：

- `REPL as a pure viewer client of a remote assistant session`

### `--remote` TUI

- `viewerOnly` 不传，等价于 false
- `hasInitialPrompt` 取决于这次是否带了初始 prompt

这意味着两条路径虽然都叫 remote config，

但它们的合同从创建那一刻起就已经不同：

- 一个是 pure viewer client
- 一个是 local TUI controlling a CCR session

所以共享的不是：

- 完整 remote 合同

而只是：

- “远端链路已经建立”的最外层外壳

## 第三层：初始态厚度差异，比 URL 有没有还更大

145 已经讲了 URL。

这一页要继续往下走半步，看到更完整的厚度差异。

### assistant viewer 的 `assistantInitialState`

它会在 `initialState` 基础上覆盖：

- `isBriefOnly: true`
- `kairosEnabled: false`
- `replBridgeEnabled: false`

但不会显式种下：

- `remoteSessionUrl`

初始消息也只有：

- `Attached to assistant session ...`

### `--remote` TUI 的 `remoteInitialState`

它会显式种下：

- `remoteSessionUrl`

同时还会：

- `switchSession(asSessionId(createdSession.id))`

并且初始消息除了 remote info message 之外，

如果本次创建时带了 prompt，还会额外塞入：

- `initialUserMessage`

这说明两条路径的差别不只是“有没有 URL”，而是：

1. 有没有 URL affordance
2. 有没有明确 retag 到远端会话 id
3. 有没有本地 TUI 代远端持有这次初始 prompt

所以更稳的写法应该是：

- assistant viewer 的初始态更薄
- `--remote` TUI 的初始态更厚

## 第四层：同样的命令壳，不代表同样的控制权

这是这页最容易被忽略、但也最值钱的一层。

两条路径在 `main.tsx` 里都会先做：

- `filterCommandsForRemoteMode(commands)`

REPL 收到 remote init 之后，也会继续保留：

- `REMOTE_SAFE_COMMANDS`

所以从“本地 slash 壳”看，两条路径会长得很像：

- 都是薄的 remote-safe command shell

但这个相似只说明：

- 本地命令面被压成同一层 affordance

不说明：

- ownership 相同
- history 行为相同
- timeout / interrupt 语义相同
- URL/prompt/session identity 的厚度相同

换句话说：

- command surface sameness

并不是：

- contract thickness sameness

## 第五层：下游 hook 已经把 assistant viewer 明确收窄成“更薄合同”

真正能把这层讲死的，不是启动参数本身，

而是下游 hook 的行为分叉。

### 1. `useAssistantHistory` 只在 `viewerOnly` 时启用

`useAssistantHistory.ts` 明写：

- `enabled = config?.viewerOnly === true`

而注释也写得很直接：

- `No-op unless config.viewerOnly`

这说明 assistant viewer 的合同里有一条额外能力：

- lazy-loaded history paging

它不是普通 `--remote` TUI 的默认行为。

### 2. `useRemoteSession` 跳过 title rewrite

`useRemoteSession.ts` 里：

- `viewerOnly` 时不会更新 session title

注释写的是：

- `the remote agent owns the session title`

这说明 assistant viewer 的合同在 title ownership 上更薄：

- 本地 viewer 不拥有 title 改写权

### 3. `useRemoteSession` 跳过 stuck-session timeout

`viewerOnly` 时不会启动那条用于检测 stuck session 的响应超时逻辑。

这不是小优化，

而是合同差异：

- viewer path 不把自己当作 session operator

### 4. `useRemoteSession` 跳过 Ctrl+C interrupt

`cancelRequest()` 里：

- `viewerOnly` 时不会 `cancelSession()`

注释写得也很直接：

- `Ctrl+C should never interrupt the remote agent`

这一步已经足够说明 assistant viewer 不是：

- “完整 remote TUI 减掉一个 URL”

它更像：

- 只保留观察与发消息能力、但收走若干控制权的更薄合同

## 第六层：从用户提示词到 title/timeout/interrupt，`--remote` TUI 是更厚的 operator 合同

反过来看 `--remote` TUI，

它之所以更厚，不只是因为多了一个 URL。

它还同时具备：

- `switchSession(asSessionId(createdSession.id))`
- `remoteSessionUrl`
- 可能存在的 `initialUserMessage`
- 非 `viewerOnly` 的 title rewrite
- 非 `viewerOnly` 的 response timeout / reconnect warning
- 非 `viewerOnly` 的 interrupt 权

把这些放在一起看，更准确的说法不是：

- “`--remote` TUI 比 viewer 多几个 feature”

而是：

- “`--remote` TUI 本地端被允许承担更厚的 remote operator 责任”

所以这两条路径的差异，本质上是：

- 合同厚度差异

不是：

- 单字段差异

## 第七层：145 里那个“bit 真 URL 缺席”截面，在 assistant viewer 上更像合同本来就更薄

145 讲的是一个 runtime 截面。

146 要再补一句：

- 那个截面在 assistant viewer 上其实更像“合同本来就薄”，而不是“合同坏了一块”

当然，这里要保持克制：

- `SessionInfo` 的 warning 文案依旧可能误导
- footer remote pill 依旧可能显得信息不足

但从合同厚度角度看，

assistant viewer 缺的并不只是 URL，

它缺的是整组本地 operator 权限与显示载荷。

## stable / conditional / gray

| 类型 | 结论 |
| --- | --- |
| 稳定可见 | assistant viewer 与 `--remote` TUI 都共享 `setIsRemoteMode(true)`、`createRemoteSessionConfig(...)`、`filterCommandsForRemoteMode(commands)` 与 `launchRepl(...)` 这层外壳；assistant viewer 明确使用 `viewerOnly = true`；`useAssistantHistory`、`useRemoteSession` 的 title/timeout/interrupt 分支都明确围绕 `viewerOnly` 收窄；`--remote` TUI 显式种下 `remoteSessionUrl`、显式 `switchSession(...)`、且可能附带 `initialUserMessage` |
| 条件公开 | `--remote` TUI 只有在 remote TUI feature gate 打开时才真的进入这套本地 TUI 路径；否则旧行为是打印会话信息后退出；`initialUserMessage` 也只在创建时带 prompt 时成立 |
| 灰度/实现层 | 从 `remoteSessionUrl` 的状态注释、`viewerOnly` 的下游收窄和 assistant 注释看，assistant viewer 更像产品上刻意更薄的 remote 合同，但“刻意设计”的动机仍然属于代码推断，不是公开承诺；共享命令壳是否会误导用户把两者当成同一种模式，也是产品解释问题，不是结构事实本身 |

## 苏格拉底式自审

### 问：为什么这页不只写 `viewerOnly`？

答：因为只写 `viewerOnly` 会让人忽略两条路径共享的 coarse remote bit 与 remote-safe 命令壳；必须先承认同壳，再解释合同分叉。

### 问：为什么一定要把 `filterCommandsForRemoteMode` 拉进来？

答：因为用户最容易被相似的命令壳误导，以为两条路径只是“功能多少”不同，而不是合同厚度不同。

### 问：为什么一定要把 `switchSession`、`initialUserMessage` 一起写？

答：因为只有把 identity、prompt ownership、display affordance 一起摆出来，厚度差异才成立。

### 问：为什么 145 还不够？

答：145 回答“这个截面坏哪儿”；146 继续回答“为什么这个截面在 assistant viewer 上并不是完整合同的默认样子”。

### 问：这页的一句话 thesis 是什么？

答：assistant viewer 与 `--remote` TUI 共享 coarse remote bit 与薄命令壳，但前者是 pure viewer 合同，后者是更厚的 remote operator 合同。

## 结论

对当前源码来说，更准确的写法应该是：

1. assistant viewer 与 `--remote` TUI 共享同一层 coarse remote shell
2. 但 assistant viewer 从启动参数、初始态、history、title ownership、timeout、interrupt 到 URL affordance 都更薄
3. 因此它们不是“同一种 remote mode 的完整版与删减版”

而更像：

- 一个是 pure viewer client
- 一个是本地 TUI 驱动的 remote operator client

所以“共享 coarse remote bit”并不等于“共享同样厚度的 remote 合同”。

## 源码锚点

- `claude-code-source-code/src/main.tsx`
- `claude-code-source-code/src/commands.ts`
- `claude-code-source-code/src/hooks/useAssistantHistory.ts`
- `claude-code-source-code/src/hooks/useRemoteSession.ts`
- `claude-code-source-code/src/remote/RemoteSessionManager.ts`
- `claude-code-source-code/src/state/AppStateStore.ts`
