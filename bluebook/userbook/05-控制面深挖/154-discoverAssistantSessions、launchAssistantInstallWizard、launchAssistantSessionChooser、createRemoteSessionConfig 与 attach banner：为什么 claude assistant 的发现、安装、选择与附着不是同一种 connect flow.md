# `discoverAssistantSessions`、`launchAssistantInstallWizard`、`launchAssistantSessionChooser`、`createRemoteSessionConfig` 与 attach banner：为什么 `claude assistant` 的发现、安装、选择与附着不是同一种 connect flow

## 用户目标

58、123、145、146、151 已经把 attached viewer 这条线拆得很细了：

- history / loading / title ownership
- non-owning client contract
- URL affordance
- coarse remote bit
- session identity ledger

但如果正文停在这里，读者仍然很容易把 `claude assistant` 入口压成一句：

- “运行 `claude assistant`，如果找不到就装一下，找到了就选一条，然后 attach 上去。”

这句太平了。

从当前源码看，这里至少有四段完全不同的 connect flow：

1. discovery：先去找当前可 attach 的 assistant sessions
2. install：一条“当前没有 session，所以转向安装/启动 daemon”的分支
3. chooser：多条 session 时的人机选择分支
4. attach：拿到 target session 后，才真正进入 viewerOnly remote attach 合同

这四段都和“连接 assistant”有关，但不是同一种 connect flow。

## 第一性原理

比起直接问：

- “`claude assistant` 到底怎么连上远端？”

更稳的提问是先拆五个更底层的问题：

1. 当前是在做 session discovery、daemon bootstrap，还是已经进入 remote attach？
2. 当前失败代表的是“没有可见 session”“安装失败”“用户取消选择”，还是“attach/auth 失败”？
3. 当前界面是 setup dialog，还是 remote REPL？
4. 当前拿到的是 install directory、picked session id，还是最终的 `RemoteSessionConfig`？
5. 如果 wizard/chooser 实现体在当前源码快照里缺席，我们还能从哪些调用点稳地证明入口链结构？

这五问不先拆开，`claude assistant` 很容易被写成：

- “同一种连接动作的不同 UI 皮肤”

而当前源码更接近：

- 一条分叉式入口管线

## 第一层：`claude assistant` 的入口先走 discovery，不是直接 attach

`main.tsx` 在 assistant 分支一开始就写得很清楚：

- `claude assistant [sessionId]`
- REPL as a pure viewer client
- loop runs remotely
- history lazy-loaded on scroll-up

但真正值得注意的是，attach 并不是这个分支的第一步。

代码先做的是：

- `await import('./assistant/sessionDiscovery.js')`
- `discoverAssistantSessions()`

而且只有在：

- 用户没直接传 `sessionId`

时才进入这条 discovery flow。

这说明 `claude assistant` 入口的第一性原理不是：

- “默认 attach 到某条现成 session”

而是：

- “先问当前有哪些可 attach 的 assistant sessions”

所以 discovery 本身就是独立一段，不该被写成 attach 的前置小步骤。

## 第二层：zero-session 分支会转向 install / daemon bootstrap，不是 attach failure

`discoverAssistantSessions()` 返回空数组时，`main.tsx` 并没有：

- 直接报 connect failed
- 或者弹一个重试 attach 的错误

而是转向：

- `launchAssistantInstallWizard(root)`

而 `dialogLaunchers.tsx` 对这条 launcher 的注释又写得更直接：

- `claude assistant` found zero sessions
- show the same install wizard as `/assistant`
- daemon.json is empty

这里的返回值也不是：

- sessionId

而是：

- `installedDir: string | null`

调用点后续的处理也进一步证明这不是 attach：

### 用户取消

- 直接优雅退出

### 安装成功

- 输出 “The daemon is starting up”
- 提示过几秒再运行一次 `claude assistant`
- 当前进程直接结束

也就是说 zero-session 分支回答的问题其实是：

- “当前本机还没有可发现的 assistant daemon/session，要不要先去安装/启动”

这不是：

- “attach 某条 session 失败”

所以 install 分支必须单列。

## 第三层：chooser 分支是人机决策，不是 attach 本体

当 discovery 拿到多条 session 时，代码并不是：

- 自动 attach 最新那条

而是转向：

- `launchAssistantSessionChooser(root, { sessions })`

`dialogLaunchers.tsx` 对这条 launcher 的注释也写得很明确：

- pick a bridge session to attach to

这里返回值依然不是：

- connected manager
- opened REPL

而只是：

- `string | null`

也就是：

- 选中的 session id
- 或用户取消

所以 chooser 分支回答的问题是：

- “多条候选 session 里，用户选哪一条”

它仍然不是 attach 本体。

这也是为什么 `discoverAssistantSessions -> chooser -> picked id` 这段最好单独写成：

- candidate resolution flow

而不是：

- attach flow

## 第四层：只有拿到 target session 之后，才进入真正的 attach 合同

当前分支一直到：

- `targetSessionId` 确定

之后，才开始真正的 attach 准备：

- OAuth refresh / `prepareApiRequest()`
- `setKairosActive(true)`
- `setUserMsgOptIn(true)`
- `setIsRemoteMode(true)`
- `createRemoteSessionConfig(targetSessionId, ..., viewerOnly=true)`
- attach banner：`Attached to assistant session ${targetSessionId.slice(0, 8)}…`

这一步才回答：

- 当前 REPL 要附着到哪条远端 assistant session
- 它会以什么 remote contract 跑起来

也就是说 attach 本体的最小签名对象是：

- `RemoteSessionConfig(sessionId, ..., viewerOnly=true)`

不是：

- install directory
- chooser result
- discovery sessions 列表

所以 attach 必须和前面三段分开写。

## 第五层：setup dialog 宿主和 attached REPL 宿主不是同一类前端

`interactiveHelpers.tsx` 里的 `showSetupDialog(...)` 给这页再补了一刀非常关键的边界。

它明确说：

- setup dialog 会包上 `AppStateProvider`
- `KeybindingSetup`

这说明 install wizard 和 session chooser 都属于：

- setup-dialog host

而 attach 后的 assistant REPL 则走：

- `launchRepl(...)`

这两类宿主的目标完全不同：

### setup dialog 宿主

- 做安装、选择、取消、确认

### attached REPL 宿主

- 开 viewerOnly remote session client
- stream live events
- POST messages
- lazy-load history

这也再次证明：

- install / chooser

不能被写成：

- attach REPL 的前几步 UI

## 第六层：当前源码快照里，wizard / chooser / discovery 实现体是灰度层，但调用点合同已足够稳定

这页还需要主动防止另一种误写：

- “既然 `sessionDiscovery.js`、`AssistantSessionChooser.js`、`commands/assistant/assistant.js` 的实现体在当前反编译树里不全，那这页就没法讲。”

这也不稳。

因为当前源码快照里已经有三类足够稳定的证据：

1. `main.tsx` 的分支结构与返回处理
2. `dialogLaunchers.tsx` 对 chooser / wizard 的调用合同与注释
3. `interactiveHelpers.tsx` 对 setup dialog 宿主的统一包装

所以更准确的写法应该是：

### 稳定可证

- 四段入口链的顺序
- 各段的输入输出对象
- 哪些分支直接结束当前进程
- 哪些分支最终进入 viewerOnly attach

### 灰度层

- `discoverAssistantSessions()` 内部如何列 bridge environments / filter sessions
- chooser UI 内部怎样排序/展示 sessions
- install wizard 内部如何物化 daemon 配置与安装目录

这正是“保护稳定功能和灰度功能”的正确写法。

## 稳定面与灰度面

### 稳定面

- `claude assistant` 未传 `sessionId` 时先走 discovery
- zero-session 会转 install / daemon bootstrap，而不是 attach failed
- 多 session 会走 chooser，返回 picked id 或 cancel
- 拿到 `targetSessionId` 后才真正 `createRemoteSessionConfig(..., viewerOnly=true)` 并 attach
- install / chooser 属于 setup-dialog host，不是 attached REPL host

### 灰度面

- `discoverAssistantSessions()` 的内部发现算法
- chooser UI 的内部排序和展示细节
- install wizard 的内部步骤与 daemon 配置物化

## 为什么这页不是 58、123、145、146、151、153

### 不是 58

58 讲的是 attach 之后：

- history / loading / title ownership

154 讲的是 attach 之前和 attach 当下：

- discovery / install / chooser / attach pipeline

### 不是 123

123 讲的是：

- viewerOnly non-owning client 合同

154 讲的是：

- 进入 viewerOnly attach 之前，入口链怎么分叉

### 不是 145

145 讲的是：

- remote bit 为真但 `remoteSessionUrl` 缺席

154 讲的是：

- `claude assistant` 甚至在 attach 之前就可能停在 discovery/install/chooser 任一段

### 不是 146

146 讲的是：

- assistant viewer vs `--remote` TUI 的合同厚度差异

154 讲的是：

- assistant viewer 自己内部的入口链分段

### 不是 151

151 讲的是：

- `remote.session_id` 身份账与主权账

154 讲的是：

- 如何得到 `targetSessionId`

### 不是 153

153 讲的是：

- attached viewer 内部的 history paging sentinel vs presence surface

154 还停在更上游的：

- 发现 / 安装 / 选择 / 附着

## 苏格拉底式自审

### 问：为什么 zero-session 不能写成 attach failure？

答：因为代码明确转向 install wizard，并在安装成功后提示“daemon is starting up”，然后结束当前进程。这是 bootstrap flow，不是 attach error flow。

### 问：为什么 chooser 不能被写成 attach UI？

答：因为 chooser 的返回值只是 `picked session id` 或 `null`，attach 本体还在后面。

### 问：为什么一定要把 `showSetupDialog(...)` 写进来？

答：因为它证明 install/chooser 的宿主就是 setup-dialog，而不是附着后的 REPL 本体。

### 问：当前源码里实现体缺席，会不会让这页不稳？

答：不会。调用点合同和分支结构已经足以证明四段入口链。缺席的内部实现只应被标成灰度层，而不是阻止切分。

### 问：这页的一句话 thesis 是什么？

答：`claude assistant` 的关键不是“找到 session 然后连上去”，而是它先后经过 discovery、install bootstrap、chooser 和 viewerOnly attach 四段不同入口链；这些段落共享目标，但不共享同一类 connect flow。

## 结论

对当前源码来说，更准确的写法应该是：

1. `claude assistant` 未传 `sessionId` 时先走 discovery
2. zero-session 会转 install / daemon bootstrap，不是 attach failed
3. 多 session 会走 chooser，解决的是 candidate selection
4. 只有拿到 `targetSessionId` 后，才真正进入 viewerOnly attach 合同
5. install / chooser 是 setup-dialog host，attach 是 attached REPL host

所以：

- `claude assistant` 的发现、安装、选择与附着不是同一种 connect flow

## 源码锚点

- `claude-code-source-code/src/main.tsx`
- `claude-code-source-code/src/dialogLaunchers.tsx`
- `claude-code-source-code/src/interactiveHelpers.tsx`
- `claude-code-source-code/README.md`
- `claude-code-source-code/README_CN.md`
