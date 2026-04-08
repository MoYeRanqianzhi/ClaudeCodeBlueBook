# CLI 根入口、旗标与启动模式专题

## 用户目标

不是只知道几个命令名，而是先分清 Claude Code 在进程启动这一层到底有几种入口：

- `claude [prompt]` 这条默认主线到底能被哪些 flags 改写
- `claude doctor`、`claude install`、`claude setup-token` 这类 root commands 该在什么时候用
- 哪些入口只是隐藏、灰度、宿主或后台能力，不该混进普通用户主线
- 为什么 `/session`、`/remote-control`、`/resume` 和 `--resume` 看起来相近，却不在同一层

## 第一性原理

Claude Code 的入口至少分成两层：

- 进程启动层：在 REPL 还没出现前，就决定要不要走普通 CLI、后台路径、bridge、runner、tmux worktree 或非交互输出。
- 会话运行层：进入交互式会话后，才轮到 slash commands、工具、技能、计划模式和子代理继续分流。

所以：

- root flags 解决的是“这次启动成什么形态”
- root commands 解决的是“这次根本不进默认 REPL，而是直接执行一个管理或宿主动作”
- slash commands 解决的是“已经进会话以后，如何继续操作当前会话”

如果把三层混写，读者最容易出现两种误判：

- 把 `claude --resume` 写成 `/resume` 的语法糖
- 把 `claude remote-control`、`--remote-control`、`/remote-control` 当成一条完全相同的链

如果你真正卡住的不是启动 flags 本身，而是：

- `claude auth` 与 `/login`
- `claude mcp` 与 `/mcp`
- `claude plugin` 与 `/plugin`
- `claude doctor` 与 `/doctor` `/status`

这些同名入口为什么不在一层，

改读 [19-会外控制台与会内面板专题.md](./19-%E4%BC%9A%E5%A4%96%E6%8E%A7%E5%88%B6%E5%8F%B0%E4%B8%8E%E4%BC%9A%E5%86%85%E9%9D%A2%E6%9D%BF%E4%B8%93%E9%A2%98.md)。

## 先看真正的启动分流

`src/entrypoints/cli.tsx` 显示，Claude Code 在加载完整 `main.tsx` 之前就会先看一轮 argv。

这轮快路径不是“优化实现细节”，而是产品边界：

- `--daemon-worker` 直接走内部 worker 启动
- `remote-control` / `remote` / `sync` / `bridge` 直接走 bridge 宿主路径
- `daemon` 直接走 supervisor
- `ps`、`logs`、`attach`、`kill` 和 `--bg` / `--background` 直接走后台会话管理
- `environment-runner`、`self-hosted-runner` 直接走 headless runner
- `--worktree` 配合 `--tmux` 时先尝试 tmux worktree fast-path
- 单独的 `--update` / `--upgrade` 还会被重写成 `update` root command

这说明 Claude Code 不是“一套 CLI 帮助文本，再加几个命令”。

更准确地说，它先判断这次进程要成为什么宿主，再决定要不要加载完整交互式 CLI。

## 稳定公开的 root flags

### 启动形态与 I/O

最重要的一组，是直接改写这次会话的交互方式：

- `-p, --print`：非交互输出并退出，适合脚本、CI、管道和一次性调用。
- `--bare`：最小副作用宿主模式，主动跳过 hooks、LSP、plugin sync、auto-memory、`CLAUDE.md` 自动发现等默认行为。
- `--output-format`、`--input-format`、`--json-schema`：把非交互调用从“打印文本”推进到结构化 I/O 契约。
- `--include-hook-events`、`--include-partial-messages`、`--replay-user-messages`：让输出流更像协议，而不是终端文本。

这里最常见的误用是：

- 把 `--print` 当成“只是把 UI 隐藏一下”
- 把 `stream-json` 当成“随便开一个 JSON 模式”

`--print` 还会改变命令解析拓扑。

源码里明确写着：只要进入 print 路径，就直接跳过 root subcommand 注册，Commander 会把 argv 路由到默认 action，而不是再去分发 `doctor`、`mcp`、`plugin` 这类 root commands。

所以：

- `claude doctor` 是 root command
- `claude -p doctor` 不是“在 print 模式下运行 doctor”
- 它只是把 `doctor` 当成 prompt 文本交给默认 action

源码里其实把组合关系写得很死：

- `--input-format=stream-json` 需要 `--output-format=stream-json`
- `--include-partial-messages` 只能配 `--print` 和 `stream-json`
- `--no-session-persistence` 也只能配 print 路径

### 会话接续与会话身份

第二组解决的是“这次启动要不要接到既有会话”：

- `--continue`
- `--resume [value]`
- `--fork-session`
- `--from-pr [value]`
- `--session-id <uuid>`
- `-n, --name <name>`

这一组和 slash commands 最容易混写。

更稳的判断标准是：

- 你还没进入会话，想决定“这次启动接哪条历史”，用 root flags
- 你已经在当前会话里，想浏览、切换、恢复、分叉，用 slash commands

所以 `--resume` 不是 `/resume` 的别名，而是启动时恢复入口。

同时还要继续细分三件事：

- `--continue`：找当前目录最近一次会话，语义偏“沿着这条现场继续”
- `--resume [value]`：按 ID、标题搜索或 picker 恢复，语义偏“去找某条历史”
- `--fork-session`：不是独立模式，而是 `--continue` / `--resume` 的修饰符，决定这次是否复用原 session ID

### 权限、工具、上下文与宿主装配

第三组决定的是“这次启动给模型多大工作面、哪些工具、什么治理方式”：

- `--permission-mode`
- `--dangerously-skip-permissions`
- `--allow-dangerously-skip-permissions`
- `--allowed-tools`、`--tools`、`--disallowed-tools`
- `--mcp-config`、`--strict-mcp-config`
- `--system-prompt`、`--append-system-prompt`
- `--settings`
- `--add-dir`
- `--agents`
- `--plugin-dir`
- `--setting-sources`
- `--file`
- `--ide`
- `--worktree`
- `--tmux`

这些 flags 的关键特点是：它们不回答“模型这轮说什么”，而回答“本轮会话从一开始就在什么控制面里工作”。

其中 `--worktree` 和 `--tmux` 还要单独看：

- `--worktree` 是公开稳定的隔离开工入口
- `--tmux` 只能和 `--worktree` 配合，并且在 bootstrap 层还有专门的 fast-path 优化

所以这组组合应写成稳定公开的工作隔离能力，而不是隐藏技巧。

### 模型、预算与执行力度

第四组决定的是“这次会话用什么推理资源和节奏”：

- `--model`
- `--effort`
- `--agent`
- `--betas`
- `--fallback-model`
- `--max-budget-usd`

它们本质上属于运行时预算与策略控制，而不是内容提示词。

## root commands 不是 slash commands

`src/main.tsx` 注册的 root commands 有一批是稳定公开主线，但它们的对象是“宿主”或“配置”，不是当前对话线程。

### 稳定公开的 root commands

- `auth login/status/logout`：身份与登录态管理
- `mcp ...`：MCP server 配置与健康管理
- `plugin ...`：插件与 marketplace 管理
- `setup-token`：长期 token setup，要求 Claude subscription
- `agents`：列出配置好的 agents
- `doctor`：宿主健康诊断，高信任、强副作用提醒
- `update` / `upgrade`：检查并安装更新
- `install [target]`：安装 Claude Code native build

这些命令和 slash commands 的关键区别在于：

- root commands 多数是一口气执行完就退出
- slash commands 默认服务于当前活着的交互式会话

所以 `doctor`、`install`、`setup-token` 该写在“启动与宿主”层，不该混进“会话命令列表”。

### 条件、隐藏或宿主导向的 root commands

源码里还能看到一批不应直接写成普通主线的 root commands：

- `server`
- `ssh`
- `open <cc-url>`
- `remote-control`
- `assistant [sessionId]`
- `auto-mode ...`
- `completion <shell>`

其中要特别注意：

- `remote-control` root command 在 `main.tsx` 里只是为了 help 输出注册，真正实现被 `cli.tsx` fast-path 截走
- `open <cc-url>` 明确写着 internal
- `assistant`、`auto-mode` 受 feature gate 或运行条件限制

因此“源码里注册了命令”不等于“正文里就能把它写成稳定主线”。

## 隐藏、灰度与宿主型 flags

`main.tsx` 还注册了一批 `hideHelp()` 的 flags。

其中最值得用户理解边界的是：

- `--sdk-url`：隐藏且更偏宿主 plumbing 的协议流入口，会自动把会话推到 print + `stream-json` + verbose
- `--teleport [session]`：隐藏远程/teleport 会话恢复面
- `--remote [description]`：隐藏 remote session 创建面
- `--remote-control [name]` / `--rc [name]`：条件公开的 bridge host 启动面，隐藏只是外观，真正边界是 entitlement、版本和组织策略

更稳的写法不是把它们删掉不谈，而是承认三件事：

- 它们确实存在，且对理解产品边界很重要
- 它们不属于普通用户默认主线
- 它们的文档语气应是“边界说明”，不是“标准建议”

如果这次启动最终落在：

- `-p/--print`
- `--bg`
- `--sdk-url`

那么下一步不要直接散读 headless 叶子页。

更稳的接法是：

1. 先回 [13-非交互、后台会话与自动化专题.md](./13-%E9%9D%9E%E4%BA%A4%E4%BA%92%E3%80%81%E5%90%8E%E5%8F%B0%E4%BC%9A%E8%AF%9D%E4%B8%8E%E8%87%AA%E5%8A%A8%E5%8C%96%E4%B8%93%E9%A2%98.md)
2. 再进 [05-控制面深挖/非交互结果、summary 与协议流/README.md](../05-%E6%8E%A7%E5%88%B6%E9%9D%A2%E6%B7%B1%E6%8C%96/%E9%9D%9E%E4%BA%A4%E4%BA%92%E7%BB%93%E6%9E%9C%E3%80%81summary%20%E4%B8%8E%E5%8D%8F%E8%AE%AE%E6%B5%81/README.md)

## 最容易误用的地方

### 把启动层入口和会话层入口混成一层

最常见的误写包括：

- 把 `--resume`、`/resume`、`/session` 写成同一组
- 把 `claude remote-control`、`--remote-control`、`/remote-control` 写成同一个入口
- 把 `doctor`、`install`、`setup-token` 塞进 slash command 列表

### 把快路径入口误当成 Commander root commands

`ps`、`logs`、`attach`、`kill`、`daemon`、`environment-runner`、`self-hosted-runner` 这几类更适合作为“启动模式”来写。

因为它们首先决定的是进程形态，而不是“命令树上的一个叶子节点”。

### 把隐藏 flags 写成稳定建议

`--sdk-url`、`--remote`、`--teleport`、`--remote-control` 都应写成：

- 已成形
- 对理解系统重要
- 但属于隐藏、灰度或宿主面，其中 `--sdk-url` 尤其更像内部宿主 plumbing

而不是写成“CLI 还有这些高级常用参数”。

## 更稳的用户策略

如果你面对的是一次新的 Claude Code 使用场景，优先按这条顺序判断：

1. 我是要启动默认交互式会话，还是根本不进 REPL。
2. 如果不进 REPL，这是 root command、fast-path 宿主，还是 print/stream-json 协议流。
3. 如果进 REPL，我需要先用哪些 root flags 把会话身份、权限、上下文和模型预算定好。
4. 进入会话以后，再考虑 slash commands、技能、工具和计划模式。
5. 看到隐藏或条件入口时，先把它当成边界证据，而不是默认工作流建议。

## 交叉阅读

- 非交互、后台与协议流：`13-非交互、后台会话与自动化专题.md`
- 初始化、安装与 setup：`14-初始化、安装与开工环境搭建专题.md`
- 多前端接续与 remote 边界：`16-IDE、Desktop、Mobile 与会话接续专题.md`
- root flags / root commands 速查：`../03-参考索引/01-命令工具/03-CLI 旗标与根命令索引.md`

## 源码锚点

- `src/entrypoints/cli.tsx`
- `src/main.tsx`
- `src/cli/handlers/util.js`
- `src/cli/handlers/auth.js`
- `src/cli/handlers/mcp.js`
- `src/cli/handlers/plugins.js`
