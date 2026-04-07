# `getIsRemoteMode`、`remoteSessionUrl`、`useRemoteSession`、`StatusLine`、`PromptInputFooterLeftSide`、`SessionInfo` 与 `assistantInitialState`：为什么 remote bit 为真但 URL 缺席时，CCR 本体仍可继续，而 link 与 QR affordance 会停摆

## 用户目标

144 已经把 `/session` 的双门控拆开了：

- 命令显隐看 `getIsRemoteMode()`
- pane 内容看 `remoteSessionUrl`

但如果停在这里，正文还是会留下一个更贴近实际使用的问题：

- 当 `getIsRemoteMode()` 为真、但 `remoteSessionUrl` 缺席时，系统到底坏到哪一层？
- 这是“remote runtime 失效”，还是只是“URL/QR affordance 停摆”？

这轮要补的不是：

- 再解释一次 `/session` 为什么有双门控

而是：

- 把这种分叉态的幸存面、停摆面、误导面真正列成一张运行时影响表

## 第一性原理

更稳的提问不是：

- “没有 `remoteSessionUrl`，那是不是就不在 remote 里了？”

而是先问四个更底层的问题：

1. 当前 consumer 需要的是“远端运行语义已经成立”，还是“一个可展示的远端 URL”？
2. 缺 URL 会先打掉 runtime engine，还是先打掉 display affordance？
3. 仓库里到底有多少 runtime consumer 直接读 `remoteSessionUrl`？
4. 如果大多数 consumer 只看 `getIsRemoteMode()`，那我们是不是该把这类分叉态写成“affordance failure”，而不是“runtime failure”？

这四问一拆开，本轮最重要的判断就会更稳：

- `remote bit = true, URL = absent`

首先意味着：

- coarse remote runtime 仍可能继续

而不是立刻意味着：

- remote execution 已经失效

## 第一层：代码先天允许 `remote bit` 与 `remoteSessionUrl` 脱钩

`bootstrap/state.ts` 里的 `getIsRemoteMode()` / `setIsRemoteMode()` 只是 bootstrap 布尔位。

`AppStateStore.ts` 里的 `remoteSessionUrl` 则被单独定义，而且注释已经写得很具体：

- `Remote session URL for --remote mode (shown in footer indicator)`

默认值也是：

- `remoteSessionUrl: undefined`

这一步最关键的不是“字段分开定义”，

而是它已经把 `remoteSessionUrl` 的角色压得很窄：

- 它不是所有 remote mode 的总 presence truth
- 它更像 `--remote` path 注入的展示型 URL 字段

所以从状态定义上看，

`remote bit` 与 `remoteSessionUrl` 本来就不是同一个 invariant。

## 第二层：assistant viewer 路径就是官方提供的“remote bit 真，但 URL 缺席”样本

`main.tsx` 里两条启动路径把这件事写得很硬。

### `claude assistant` attach / viewer

这里会：

- `setIsRemoteMode(true)`
- 创建 `remoteSessionConfig(..., viewerOnly = true)`
- 把这份 config 直接交给 `launchRepl(...)`

但它复用的 `assistantInitialState` 并没有显式种下：

- `remoteSessionUrl`

### `claude --remote` TUI

这里也会：

- `setIsRemoteMode(true)`
- 创建 `remoteSessionConfig(...)`

但它额外又会：

- 构造 `remoteSessionUrl`
- 写入 `remoteInitialState`

也就是说，系统自己已经正式承认两种不同厚度的 remote 初始态：

1. remote runtime 已经成立
2. URL 型 display affordance 是否成立，要另看

这不是推测，

而是启动路径本身写出来的结构事实。

## 第三层：CCR 本体继续工作的关键链路根本不依赖 `remoteSessionUrl`

这一层是本轮最关键的“幸存面”。

`REPL.tsx` 真正用于远端交互的是：

- `activeRemote`

而 `activeRemote` 的 remote-session 分支来自：

- `useRemoteSession`

`useRemoteSession.ts` 本身把 remote-mode 判定写成：

- `const isRemoteMode = !!config`

后续连接 `RemoteSessionManager` 也只依赖：

- `config`

`RemoteSessionManager.ts` 的 `createRemoteSessionConfig(...)` 构造内容也围绕：

- `sessionId`
- `getAccessToken`
- `orgUuid`
- `viewerOnly`

而不是围绕：

- `remoteSessionUrl`

再看 `REPL.tsx` 的发送路径：

- `activeRemote.sendMessage(...)`

说明真正让 CCR 本体活起来的，是：

- remote config
- active remote shell
- remote session manager

不是：

- URL 字段本身

所以当 `remote bit` 为真但 URL 缺席时，

更准确的说法应该是：

- CCR engine 仍然能活
- URL/QR affordance 会受伤

而不是：

- 远端本体已经停摆

## 第四层：幸存 consumer 大多只认 `getIsRemoteMode()`，不认 URL

这一层把“继续工作”的对象列平。

### 1. `StatusLine` 继续工作

`StatusLine.tsx` 只要 `getIsRemoteMode()` 为真，就会导出：

- `remote.session_id`

它要回答的是：

- 当前 status line schema 要不要声明 remote 环境

它不要求：

- `remoteSessionUrl`

### 2. footer 的本地 mode 抑制继续工作

`PromptInputFooterLeftSide.tsx` 用：

- `!getIsRemoteMode()`

来决定本地 permission mode part 还该不该显示。

所以即使没有 URL，

- 本地 mode 仍会被压掉

这说明它关心的是：

- UI 防误导

不是：

- URL presence

### 3. 启动通知抑制继续工作

`useStartupNotification.ts` 里：

- `if (getIsRemoteMode() || hasRunRef.current) return`

所以本地 startup notification 会继续被抑制。

### 4. 其他“本地行为停用器”继续工作

同类分支还包括：

- `Messages.tsx` 里的 terminal progress bar 抑制
- `sessionMemory.ts` 里的 session memory 初始化跳过
- `settings/changeDetector.ts` 里的 file watching 初始化跳过
- `/reload-plugins` 与 `print.ts` 里围绕 remote 条件的 user settings 下载分支

这些分支共同说明一件事：

- 大量 consumer 只需要知道“当前已处于 remote 执行语义”，并不需要知道一个可展示 URL

所以在这类分叉态里，

真正稳定幸存的是：

- remote behavior branches

## 第五层：真正停摆的，其实只是 URL 型 affordance

全仓搜 `remoteSessionUrl` 可以看到，运行时直接消费它的对象非常少。

最关键的只有两类：

### 1. `/session` pane

`SessionInfo` 直接读 `remoteSessionUrl`。

没有 URL 时，它不会降级成“展示别的 remote 信息”，

而是直接走 warning pane：

- `Not in remote mode. Start with \`claude --remote\` to use this command.`

这意味着它停摆的不是：

- CCR runtime

而是：

- QR / browser URL affordance

### 2. footer remote pill

footer 的 remote indicator 只在：

- `remoteSessionUrl ? ... : []`

时渲染。

没有 URL，就没有 remote link pill。

更关键的是，这里还不是订阅式消费，

而是：

- mount-time snapshot

所以它当前的语义更接近：

- “如果初始态自带 `--remote` URL，就显示这个 link”

而不是：

- “只要处于任意 remote mode，我都会持续订阅并展示一个远端链接”

因此这里停摆的也是：

- link affordance

不是：

- remote engine

## 第六层：为什么这页必须把它叫作 `affordance failure`，而不是 `runtime failure`

把上面两层合起来，就会得到一个更稳的措辞。

### 如果是 runtime failure

我们预期会看到：

- `useRemoteSession` 无法成立
- `activeRemote` 无法发送
- REPL 无法进入 remote transcript / remote interaction

但当前源码并不是这样。

### 当前真实发生的，是 affordance failure

即：

- remote behavior bit 已成立
- remote config / remote manager / activeRemote 继续工作
- 但 URL 型展示 affordance 缺席

所以最准确的写法不是：

- “没有 URL，所以 remote 不成立”

而是：

- “没有 URL，所以依赖 URL 的 link/QR display surface 会停摆”

这会把系统真实坏掉的地方描述得更精确。

## 第七层：最容易误导用户的，是“误报式失效”而不是“真实停机”

这轮还要再补一个更细的判断。

`SessionInfo` 的 fallback 文案写的是：

- `Not in remote mode`

但从启动路径和 runtime 链路看，

assistant viewer 路径完全可能同时满足：

- `getIsRemoteMode() === true`
- remoteSessionConfig 活着
- activeRemote 可用
- `remoteSessionUrl === undefined`

所以这里更像：

- URL affordance 缺席时的误报式用户解释

而不是：

- 真实的 remote runtime verdict

这也是为什么本页要把稳定功能和灰度文案分开写：

- 结构事实很稳
- 文案口径未必精确

## stable / conditional / gray

| 类型 | 结论 |
| --- | --- |
| 稳定可见 | `remote bit` 与 `remoteSessionUrl` 先天分离；assistant viewer 路径会稳定产生 `getIsRemoteMode() = true` 且 URL 缺席的初始态；`useRemoteSession` / `activeRemote` 的运行链路不依赖 URL；`StatusLine`、startup-notification gate、terminal progress 抑制、session memory gate、settings watcher gate 等只认 remote bit，因此会继续工作 |
| 条件公开 | `/session` pane 与 footer remote pill 是 URL 依赖面；URL 缺席时，它们会失去 QR/link affordance；footer 又只拿 mount-time snapshot，因此后续就算别处补写 store，也不自动承诺恢复 |
| 灰度/实现层 | `SessionInfo` 的 “Not in remote mode” 文案会把“URL 缺席”说成“remote 不成立”；从当前代码能证明它在某些路径上会误报，但仅凭这些文件还不能断言这是产品刻意设计还是 UX 欠账 |

## 苏格拉底式自审

### 问：为什么这一页不继续写 `/session` 双门控？

答：因为 144 已经回答“命令 gate 不等于内容 gate”；145 进一步回答“内容 gate 失败时，系统其他层到底会不会一起塌”。

### 问：为什么一定要把 `useRemoteSession` / `activeRemote` 拉进来？

答：因为只有把真正的运行链路摆出来，才能证明坏掉的是 affordance，不是 CCR 本体。

### 问：为什么一定要做 `remoteSessionUrl` 的全仓搜？

答：因为只有这样才能说明 URL 依赖面其实非常窄，不该把局部停摆误写成全局 runtime failure。

### 问：为什么要把 `Messages.tsx`、`sessionMemory.ts`、`changeDetector.ts` 这类本地行为 gate 也写进来？

答：因为用户真正关心的是“系统还剩下哪些行为继续按 remote 语义运行”，而不只是 `/session` 这一个面板。

### 问：这页的最小一句话 thesis 是什么？

答：`remote bit` 为真但 URL 缺席时，坏掉的是 link/QR affordance，不是 CCR runtime 本体。

## 结论

当前源码更准确的分层应该写成：

1. `getIsRemoteMode()` 负责 coarse remote behavior
2. `remoteSessionConfig` / `useRemoteSession` / `activeRemote` 负责 CCR runtime
3. `remoteSessionUrl` 负责 `--remote` path 的 display affordance

所以当：

- `getIsRemoteMode() === true`
- `remoteSessionUrl === undefined`

时，更准确的结论是：

- remote runtime 仍可继续
- 但 `/session` 的 QR/URL 展示与 footer remote pill 会停摆

## 源码锚点

- `claude-code-source-code/src/bootstrap/state.ts`
- `claude-code-source-code/src/state/AppStateStore.ts`
- `claude-code-source-code/src/main.tsx`
- `claude-code-source-code/src/hooks/useRemoteSession.ts`
- `claude-code-source-code/src/remote/RemoteSessionManager.ts`
- `claude-code-source-code/src/screens/REPL.tsx`
- `claude-code-source-code/src/components/StatusLine.tsx`
- `claude-code-source-code/src/components/PromptInput/PromptInputFooterLeftSide.tsx`
- `claude-code-source-code/src/commands/session/index.ts`
- `claude-code-source-code/src/commands/session/session.tsx`
- `claude-code-source-code/src/hooks/notifs/useStartupNotification.ts`
- `claude-code-source-code/src/components/Messages.tsx`
- `claude-code-source-code/src/services/SessionMemory/sessionMemory.ts`
- `claude-code-source-code/src/utils/settings/changeDetector.ts`
- `claude-code-source-code/src/commands/reload-plugins/reload-plugins.ts`
- `claude-code-source-code/src/cli/print.ts`
