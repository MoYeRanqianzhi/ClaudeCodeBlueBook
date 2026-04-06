# Host、Viewer 与 Health Check：为什么 server、remote-control、assistant、doctor 不能写成同一类会外入口

## 用户目标

不是只知道几个会外 root command 的名字，而是先分清 Claude Code 在“会外宿主层”到底有哪些不同对象：

- 哪些入口是在把本机或当前进程接成 host。
- 哪些入口是在把当前 REPL 变成 viewer client。
- 哪些入口是在做宿主健康检查，而不是继续当前工作线程。
- 为什么 `server`、`remote-control`、`assistant [sessionId]`、`doctor`、`mcp list|get` 看起来都像 CLI 根入口，却不该写成一类。

如果这些对象不先拆开，最常见的误判有四种：

- 把 host 入口写成普通用户工作流入口。
- 把 viewer client 写成 daemon 本身。
- 把 health check 写成“纯只读命令”。
- 把 hidden / gated / fast-path 对象抬成稳定主线。

## 第一性原理

Claude Code 的会外入口至少有三种不同对象：

- `Host`：把本机、当前进程或某个 server 接成会话宿主。
- `Viewer`：把当前 REPL 附着到一个已经存在的远端会话。
- `Health Check`：对安装、MCP、配置和宿主状态做诊断或探测。

因此更稳的判断方式不是：

- “它是不是一个 root command”

而是：

- “它操作的对象是谁”

只要对象不同，就不该写成同一条会外主线。

## 第一层：`server`、`remote-control`、`open` 更接近 Host

### `server` 与 `cc://` 是 direct-connect 公共面，但仍属于高级宿主对象

`main.tsx` 中的 `server` 会：

- 启动 Claude Code session server
- 创建 `SessionManager`
- 使用 `DangerousBackend`
- 维护 lock / idle timeout / max sessions

而 `cc://` / `cc+unix://` 又是这套 direct-connect 的连接对象。

这意味着它们回答的不是：

- “这次 Claude 要帮我做什么”

而是：

- “本机要不要变成一个承载 session 的 host”
- “当前进程要不要接到一个现成 session server”

因此它更像：

- 公开可见、但明显偏高级的宿主入口

而不是：

- 普通用户默认 CLI 主线

### `remote-control` 首先是 host fast-path，不是普通 command leaf

`entrypoints/cli.tsx` 对：

- `remote-control`
- `rc`
- legacy `remote` / `sync` / `bridge`

都做了 fast-path 截流，直接进入 `bridgeMain()`。

并且它在真正进入 `bridgeMain()` 之前还要先过：

- OAuth 登录
- bridge 最低版本
- 组织策略

这说明它首先决定的是：

- 进程形态
- 本机是否作为 bridge environment 暴露出去

而不是：

- 在完整 commander 命令树里执行一个普通根命令

`main.tsx` 里的 `remote-control` 注册，更像 help/stub 和兜底入口，不是主执行链。

### `open <cc-url>` 是 internal transport shim

`cc://` / `cc+unix://` 的处理同样说明：

- 交互模式下，URL 会被改写回主命令，给出完整 TUI。
- headless `-p` 下，URL 会被改写成 internal `open <cc-url>`。

`open` 的职责是：

- 解析 connect URL
- 创建 direct-connect session
- 再交给 connect runner

因此它应被写成：

- internal host plumbing

而不是：

- 用户公开推荐命令

## 第二层：`assistant [sessionId]` 是 Viewer，不是 Host

### `assistant [sessionId]` 的对象是“附着现有 bridge session”

`main.tsx` 对 `claude assistant [sessionId]` 的注释非常直白：

- REPL as a pure viewer client
- attach to a running bridge session

这说明它不是在：

- 启动新的 daemon
- 启动新的主 agent loop

而是在：

- 把当前 REPL 变成一个附着到远端 bridge session 的 viewer client

### 没给 `sessionId` 时，走的是发现与选择，而不是新建主线

如果没给 `sessionId`，调用点会：

- discover sessions
- 只有一个时自动附着
- 多个时弹 chooser
- 没有会话时弹 install wizard，并提示稍后再连

因此它的用户心智是：

- “接到已有现场”

而不是：

- “像普通 `claude` 一样新开一个本地工作线程”

### viewer client 的能力面已经被主动压缩

附着前，当前分支会设置：

- `viewerOnly: true`
- `remoteCommands = filterCommandsForRemoteMode(commands)`
- `initialTools: []`
- `isBriefOnly: true`
- `kairosEnabled: false`
- `replBridgeEnabled: false`

并且远端历史分页也明确 gated on `viewerOnly`。

所以更稳的结论是：

- `assistant [sessionId]` 属于条件公开 viewer 面
- 它不是 host，也不是 daemon

### `--assistant` 是另一层隐藏宿主开关

与 `assistant [sessionId]` 不同，`--assistant` 被注册为：

- `Force assistant mode (Agent SDK daemon use)`
- `hideHelp()`

因此：

- `assistant [sessionId]` 可以写成 viewer client
- `--assistant` 只能写成内部/托管宿主开关

两者绝不能合并成“assistant 功能”。

## 第三层：`doctor` 与 `mcp list|get` 更接近 Health Check

### `doctor` 检查的是宿主 runtime，不只是 updater

帮助文本把 `doctor` 说成：

- 检查 Claude Code auto-updater 健康

但运行时对象明显更宽。

`doctorHandler()` 会：

- 创建独立 root
- 包上 `AppStateProvider`
- 包上 `MCPConnectionManager`
- 在 `DoctorWithPlugins` 里触发 `useManagePlugins()`
- 渲染 `Doctor` screen

而 `Doctor` screen 又会继续检查：

- 安装方式
- 版本与路径
- 自动更新权限
- ripgrep
- context warnings
- plugin errors
- MCP 相关状态
- sandbox / keybinding / settings 错误

所以更稳的写法应是：

- `claude doctor` 是宿主健康检查入口

而不是：

- “更新器命令”

### `mcp list|get` 不是静态配置读取，而是 live health check

`mcpListHandler()` 会：

- `getAllMcpConfigs()`
- 输出 `Checking MCP server health...`
- 对每个 server 调 `checkMcpServerHealth()`
- 而 `checkMcpServerHealth()` 继续调 `connectToServer()`

`mcpGetHandler()` 也会：

- 先按名取 config
- 再立刻做 health check
- 再打印 status 和 transport 细节

因此它们的真实对象是：

- 宿主上的 MCP 实体
- 不是配置文件文本本身

### 对 `stdio` server，health check 就是实际拉起宿主子进程

`connectToServer()` 的 `stdio` 分支会：

- 构造 `StdioClientTransport`
- 把 `command / args / env` 注入 transport
- 实际发起 `client.connect(transport)`

这意味着：

- 对 `stdio` server 的“健康检查”
- 就是实际拉起本地子进程并做 MCP 握手

更不能把它写成纯只读。

### 退出时还要显式 cleanup

`mcp list|get` 在尾部调用：

- `gracefulShutdown(0)`

源码注释直接说明：

- 这是为了避免 orphan child processes

也就是说，它们确实操作过活对象，而不是只做文本读取。

## 第四层：为什么这些入口都不能直接进普通用户主线

### 一类入口在改进程形态

- `server`
- `remote-control`
- `open`

这些都更像 host 或 transport 入口。

### 一类入口在附着现有会话

- `assistant [sessionId]`

它是 viewer client，不是新建任务主线。

### 一类入口在做宿主探测

- `doctor`
- `mcp list`
- `mcp get`

它们是 health-check 型读取，不是继续当前工作线程。

所以更稳的写法是：

- 普通用户主线优先写 `claude`、REPL、`--print`
- host / viewer / health-check 只在边界专题里单独解释

## 稳定面、条件面与内部面

### 公开可见、但偏高级宿主面

- `server`
- `cc://` / `cc+unix://`

这一层可以明确写出来，但不应包装成普通用户默认主线。

### 稳定公开，但必须带副作用说明

- `claude doctor`
- `claude mcp list`
- `claude mcp get`

写进 userbook 时必须同时写明：

- 这些入口会 skip trust dialog
- 对 `.mcp.json` 的 `stdio` server 可能触发实际 health check

### 条件公开或高级宿主面

- `server`
- `remote-control`
- `assistant [sessionId]`
- `cc://` 连接语义

这些对象对理解边界很重要，但默认不应写成首选主线。

### 隐藏、灰度或内部面

- internal `open <cc-url>`
- `--assistant`
- `--sdk-url`
- `daemon`
- `--daemon-worker`

这一层只应写成：

- 宿主边界
- feature gate 线索
- 实现层对象

## 最容易误用的点

- 把 `remote-control` 写成普通 commander 子命令，而忽略它首先是 fast-path host。
- 把 `assistant [sessionId]` 写成 daemon，而不是 viewer client。
- 把 `doctor` 写成 updater 命令，而忽略它实际会挂 MCP 与 plugin 诊断面。
- 把 `mcp list|get` 写成“只看配置”，而忽略实际 `connectToServer()`。
- 把 `open` 当成公开 CLI 入口，而不是 internal direct-connect shim。
- 把 `skip trust dialog` 当成“所以这命令没副作用”，而不是“所以你只能在可信目录里跑它”。

## 用户策略

更稳的判断顺序通常是：

1. 如果你的目标是完成任务，先回到普通 REPL 或 `--print` 主线。
2. 只有当你真的要把本机接成宿主时，才考虑 `server` 或 `remote-control` 一类 host 入口。
3. 只有当你真的要附着已有 bridge session 时，才考虑 `assistant [sessionId]`。
4. 只有当你要诊断宿主安装、MCP 和配置健康时，才运行 `doctor` 或 `mcp list|get`。
5. 看到 `open`、`--assistant`、`--sdk-url` 一类入口时，先把它们当边界证据，而不是默认工作流建议。

## 源码锚点

- `claude-code-source-code/src/entrypoints/cli.tsx`
- `claude-code-source-code/src/main.tsx`
- `claude-code-source-code/src/server/createDirectConnectSession.ts`
- `claude-code-source-code/src/remote/RemoteSessionManager.ts`
- `claude-code-source-code/src/commands.ts`
- `claude-code-source-code/src/cli/handlers/mcp.tsx`
- `claude-code-source-code/src/cli/handlers/util.tsx`
- `claude-code-source-code/src/screens/Doctor.tsx`
- `claude-code-source-code/src/hooks/useAssistantHistory.ts`
- `claude-code-source-code/src/hooks/useRemoteSession.ts`
- `claude-code-source-code/src/dialogLaunchers.tsx`
