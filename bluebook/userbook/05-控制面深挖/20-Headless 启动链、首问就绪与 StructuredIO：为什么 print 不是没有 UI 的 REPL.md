# Headless 启动链、首问就绪与 StructuredIO：为什么 print 不是没有 UI 的 REPL

## 用户目标

不是只记住 `claude -p/--print`、`--sdk-url`、`--bare` 这些旗标，而是先看清五件事：

- 为什么 `print` 不是“把 REPL UI 去掉以后剩下的同一条路径”。
- 为什么 `--sdk-url` 一出现，Claude Code 会自动切到另一套 I/O 合同。
- 为什么 headless 会在首问前显式等待一部分对象，又故意把另一部分对象留到后台。
- 为什么 headless 的命令面、恢复面和中断面比交互 REPL 更窄、更硬。
- 哪些属于稳定公开合同，哪些只是条件宿主面，哪些是内部影子入口。

如果这几件事不先拆开，最容易把下面这些对象写成同一回事：

- `-p/--print`
- `--sdk-url`
- `stream-json`
- `StructuredIO` / `RemoteIO`
- 首问前的 MCP / plugin / hook / SessionStart 就绪链
- `--bare`
- 内部 `open <cc-url>` 子命令

## 第一性原理

Claude Code 至少有两种完全不同的宿主形态：

- 交互 REPL：目标是先把当前会话渲染出来，再让用户继续输入、浏览、切换面板。
- headless / print：目标是把一次非交互调用变成一条可消费、可恢复、可中断、可托管的执行流。

两边共享的是：

- `ask()` / `QueryEngine`
- tools / transcript / session storage 一类 core

真正分叉的是宿主层，而不是屏幕层。

所以真正的分界不是“有没有终端 UI”，而是：

- 入口在什么时候分流。
- 当前会话暴露哪些命令对象。
- I/O 是人类终端文本，还是结构化控制协议。
- 首问前到底保证什么 ready，什么只承诺尽快补上。

只要这四件事已经变了，`print` 就不是 REPL 去掉 UI，而是另一种宿主合同。

## 第一层：入口编译阶段就已经分叉

### `-p/--print` 不是 REPL 的显示开关

`main.tsx` 在启动很早期就把：

- `-p/--print`
- `--init-only`
- `--sdk-url`
- 非 TTY stdout

一起判定成 non-interactive，并立刻停止 early input capture。

这说明 headless 不是等 REPL 启动后再“换个输出样式”，而是从启动早期就走另一条模式判定链。

### print 模式直接跳过整套 root subcommands 注册

源码明确写着：

- print 模式下会跳过 `mcp`、`auth`、`plugin`、`doctor` 等 root subcommands 的注册路径。
- commander 会把 prompt 直接路由到默认 action。

所以 `claude -p ...` 不是“先进入完整 CLI，再不显示菜单”，而是：

- 连同根命令分发树一起换成 headless 主线。

### `cc://` 也不是一条统一入口

源码对 `cc://` / `cc+unix://` 明确分两种处理：

- 交互模式：重写回主命令，走完整 TUI。
- headless 模式：改写到内部 `open <cc-url>` 子命令。

这再次说明：

- 同一类目标对象
- 在交互宿主和 headless 宿主里
- 并不是走同一条运行时路径。

## 第二层：I/O 合同已经从终端文本改成结构化控制流

### `StructuredIO` 是 headless 的基础对象

`print.ts` 不是直接把回答 `console.log` 出去，而是先创建：

- `StructuredIO`
- 或在 `sdkUrl` 存在时创建 `RemoteIO`

`StructuredIO` 负责的不是“排版”，而是：

- 读取结构化 stdin 消息
- 处理 `control_response`
- 发送 `control_request`
- 转发 permission prompt、hook callback、elicitation、sandbox 网络授权

这已经不是普通 REPL 输入框的语义，而是控制协议。

源码还直接说明：

- `runHeadless()` 没有 React tree

这进一步说明 headless 不是“REPL 只是不渲染 UI”，而是：

- 连宿主运行骨架都已经换掉。

### `RemoteIO` 不是“多一个远端输出目标”

`RemoteIO` 在 `StructuredIO` 之上再接入：

- transport 连接
- session token / reconnect headers
- CCR v2 internal event 写回与恢复
- session state / metadata 上报
- keep_alive

因此 `--sdk-url` 代表的不是“把回答发到远端”，而是：

- 当前会话被放进一个可托管的远端结构化宿主里。

### `--sdk-url` 会自动改写模式本身

只要给出 `--sdk-url`，`main.tsx` 就会自动：

- 设成 `input-format=stream-json`
- 设成 `output-format=stream-json`
- 打开 `verbose`
- 打开 `print`

这说明 `--sdk-url` 不是普通附加参数，而是一个宿主切换器。

### `stream-json` 也不是普通“JSON 输出开关”

源码把它绑得很死：

- `--input-format=stream-json` 需要 `--output-format=stream-json`
- `--include-partial-messages` 需要 `--print` 且 `--output-format=stream-json`
- `--replay-user-messages` 也要求双向 `stream-json`
- `--output-format=stream-json` 还要求 `--verbose`

更稳的理解是：

- `stream-json` 表示你要进入持续协议流
- 不是“想看 JSON 时顺手打开的格式参数”

## 第三层：headless 的首问就绪链不是 REPL 的 render-before-query 模式

### 首问前明确会等待的东西

headless 为了保证第一问可用，会显式等待几类对象：

- 版本化插件初始化
- regular MCP configs 的连接批次
- 非交互 org restriction 校验
- `CLAUDE_CODE_SYNC_PLUGIN_INSTALL` 打开时的插件安装 promise
- `loadInitialMessages()` 里对 `SessionStart` startup hooks 的 join

这条链条的目标不是“先把屏幕画出来”，而是：

- 在第一轮 ask 前把最关键的执行面拼好。

### 首问前故意不保证全量 ready 的东西

但 headless 又不会等待一切：

- `QueryEngine` 对 skills / plugins 默认只做 cache-only 读取
- `claude.ai` connectors 只做 bounded wait，超时后继续在后台补连
- deferred prefetch / housekeeping 会在后面 fire-and-forget
- `--bare` 还会继续把 hooks、LSP、plugin sync、auto-discovery、prefetch 一并跳过

所以更准确的心智不是“headless 比 REPL 更完整”，而是：

- 它只对首问真正需要的对象做选择性阻塞
- 其他对象仍然允许渐进到位

### MCP 在 headless 与 interactive 下不是同一套 ready 策略

交互模式里：

- MCP prefetch 不阻塞 REPL render
- 慢 server 常常是 turn 2+ 才逐渐补上

headless 里：

- regular MCP batch 会在首问前 await
- 但 `claude.ai` connectors 又只给一个 bounded wait
- 结果继续写回 `headlessStore`

这意味着：

- print 的首问工具面比交互更强调 ready
- 但仍不是“一次性全量静态确定”

### plugin 在 headless 下也不是简单的“自动安装成功”

headless 的插件链至少分三步：

1. 安装 / 物化 promise
2. 必要时把 plugin MCP diff 应用回当前状态
3. 同步安装模式下再 `refreshPluginState()`，刷新 commands / agents / hooks

因此更稳的说法是：

- headless 可以为了首问显式等插件
- 但“插件已物化”和“当前会话已刷新”仍然不是同一层

## 第四层：headless 暴露的命令面更窄，不是 REPL 全量 slash 面

`main.tsx` 在进入 headless store 前就把命令过滤成：

- `prompt` 类型且未禁用 non-interactive
- 或 `local` 类型且 `supportsNonInteractive`

这意味着 headless 看到的不是 REPL 全量 slash commands，而是：

- 一组专门标注过可在非交互宿主运行的命令对象

所以不要把：

- REPL 里看得到的 slash 面
- headless 可执行的命令面

写成同一张表。

## 第五层：恢复、中断与持久化合同更硬

### print 恢复面比交互更窄

`print.ts` 对恢复参数有更强约束：

- `--resume-session-at` 必须依赖 `--resume`
- `--rewind-files` 必须依赖 `--resume`
- `--rewind-files` 不能再同时给 prompt
- `--resume` 在 print 路径里要求合法 session ID / JSONL / URL

这说明 headless 恢复不是交互 picker 的变体，而是一套更硬的参数合同。

### `--no-session-persistence` 也是 print-only

源码明确限制：

- `--no-session-persistence` 只能用于 `--print`

因此“无持久化一次性调用”是 headless 宿主特有能力，不应往交互主线外推。

### SIGINT 也不是同一套处理

`main.tsx` 在全局 `SIGINT` handler 里明确给 print 让路：

- print 模式下由 `print.ts` 注册自己的 abort / graceful shutdown 处理
- 交互主线则更接近直接退出当前前台会话

这又是一条典型证据：

- headless 不是 REPL 去 UI
- 而是另有自己的中断语义

## 第六层：`--bare` 不是“更快的 print”，而是最小宿主模式

`--bare` 有两个关键特点：

- 在 `entrypoints/cli.tsx` 就提前写入 `CLAUDE_CODE_SIMPLE=1`
- 让很多 gate 在 module eval / commander option building 阶段就生效

所以它不是：

- 在现成 headless 上再关几个功能

而是：

- 从启动更早的位置，把当前调用压缩成显式上下文宿主

更适合：

- 高可控脚本
- 明确自己要手动提供 `--system-prompt`、`--add-dir`、`--mcp-config`、`--settings`

不适合把它误写成：

- “print 模式的推荐默认值”

## 稳定面、条件面与内部面

### 稳定公开主线

- `-p/--print`
- `--output-format=text|json|stream-json`
- `--input-format=text|stream-json`
- `--continue`
- `--resume`
- `--fork-session`
- `--no-session-persistence`
- `--bare`

### 条件公开或灰度宿主面

- `--sdk-url`
- `stream-json` 双向协议流
- `--include-partial-messages`
- `--replay-user-messages`
- `--permission-prompt-tool`
- 同步插件安装与首问前 refresh 的环境变量控制
- `claude.ai` connectors 的 bounded wait 与后台补连

### 内部、影子或不宜写成普通主线

- 内部 `open <cc-url>` 子命令
- `cc://` 连接里的内部重写细节
- CCR v2 internal events 的恢复与写回
- 直接连接 server / daemon worker 一类宿主入口

## 最容易误用的点

- 把 `print` 当成“REPL 只是不显示 UI”。
- 把 `--sdk-url` 当成“额外多一个远端输出目的地”。
- 把 `stream-json` 当成普通 JSON 美化开关。
- 把 headless 首问工具面当成启动瞬间静态确定的全量对象。
- 把 “插件已物化” 误写成 “当前 headless 会话已刷新完毕”。
- 把 `--bare` 当成所有自动化场景的默认推荐。

## 源码锚点

- `claude-code-source-code/src/entrypoints/cli.tsx`
- `claude-code-source-code/src/main.tsx`
- `claude-code-source-code/src/cli/print.ts`
- `claude-code-source-code/src/cli/structuredIO.ts`
- `claude-code-source-code/src/cli/remoteIO.ts`
- `claude-code-source-code/src/QueryEngine.ts`
- `claude-code-source-code/src/utils/plugins/headlessPluginInstall.ts`
- `claude-code-source-code/src/utils/plugins/refresh.ts`
- `claude-code-source-code/src/utils/sessionStart.ts`
