# CLI 旗标与根命令索引

这页只整理进程启动层的 CLI 入口：

- root flags
- root commands
- fast-path 启动模式

不重复 slash commands；斜杠命令请看 `01-命令索引.md`。

如果你真正卡住的不是：

- 启动时决定什么形态
- root flags / root commands / fast-path 怎么分

而是：

- `claude auth` 与 `/login`
- `claude mcp` 与 `/mcp`
- `claude plugin` 与 `/plugin`
- `claude doctor` 与 `/doctor` `/status`

这些同名入口为什么不在一层，

改看 [04-根命令与斜杠命令对照索引.md](./04-%E6%A0%B9%E5%91%BD%E4%BB%A4%E4%B8%8E%E6%96%9C%E6%9D%A0%E5%91%BD%E4%BB%A4%E5%AF%B9%E7%85%A7%E7%B4%A2%E5%BC%95.md)。

## 速读标签

- `稳定公开`：默认帮助文本可见，适合写进普通用户主线
- `条件/高级`：这里只是速读简写，核心仍是“条件公开”；“高级”描述的是使用语境，不是正式能力层级
- `隐藏/灰度`：这里只是把 help 可见性受限和条件暴露并排提醒；“隐藏”是展示属性，不等于正式 taxonomy 里的能力层级
- `内部/托管`：更偏内部、runner、daemon、ant-only 或托管宿主；若只剩 help-only stub 或公开接近面，应再单独按影子能力处理

## root flags

### 启动与 I/O

- `-p, --print`
  可见性：`稳定公开`
  用途：非交互输出并退出
  关键约束：会跳过 workspace trust dialog，并跳过 root subcommand 注册；很多格式与恢复旗标都围绕它工作
- `--bare`
  可见性：`稳定公开`
  用途：最小副作用模式
  关键约束：在完整 CLI 加载前就设置 `CLAUDE_CODE_SIMPLE=1`，跳过 hooks、LSP、plugin sync、auto-memory、`CLAUDE.md` 自动发现等
- `--output-format <text|json|stream-json>`
  可见性：`稳定公开`
  用途：控制 print 输出格式
  关键约束：只和 `--print` 配合才有意义
- `--input-format <text|stream-json>`
  可见性：`稳定公开`
  用途：控制 print 输入格式
  关键约束：`stream-json` 需要 `--output-format=stream-json`
- `--json-schema <schema>`
  可见性：`稳定公开`
  用途：结构化输出校验
  关键约束：服务于 print/JSON 路径
- `--include-hook-events`
  可见性：`稳定公开`
  用途：把 hook 生命周期事件放进输出流
  关键约束：主要与 `stream-json` 搭配
- `--include-partial-messages`
  可见性：`稳定公开`
  用途：输出增量消息分片
  关键约束：必须配 `--print` 和 `--output-format=stream-json`
- `--replay-user-messages`
  可见性：`稳定公开`
  用途：把 stdin 里的用户消息重新发回 stdout
  关键约束：要求输入和输出都为 `stream-json`
- `--debug [filter]`
  可见性：`稳定公开`
  用途：调试日志
  关键约束：更偏宿主诊断，不是工作流入口
- `--debug-file <path>`
  可见性：`稳定公开`
  用途：把 debug 日志写入文件
  关键约束：会隐式开启 debug
- `--verbose`
  可见性：`稳定公开`
  用途：覆盖 config 里的 verbose 设置
  关键约束：也会被 `--sdk-url` 自动打开
- `--mcp-debug`
  可见性：`稳定公开`
  用途：旧 MCP debug 开关
  关键约束：已标 `DEPRECATED`

### 会话接续与会话身份

- `-c, --continue`
  可见性：`稳定公开`
  用途：接当前目录最近一次会话
  关键约束：语义偏“沿着当前目录最近现场继续”
- `-r, --resume [value]`
  可见性：`稳定公开`
  用途：按 session ID 恢复，或打开交互式 picker
  关键约束：语义偏“去找某条历史”；在 print 路径下要求合法 session ID
- `--fork-session`
  可见性：`稳定公开`
  用途：恢复时分叉新 session ID，而不是复用原 ID
  关键约束：它是 `--continue` / `--resume` 的修饰符，不是独立启动模式
- `--from-pr [value]`
  可见性：`稳定公开`
  用途：按 PR 号或 URL 恢复相关会话，或打开 picker
- `--no-session-persistence`
  可见性：`稳定公开`
  用途：禁用会话落盘
  关键约束：只能用于 `--print`
- `--session-id <uuid>`
  可见性：`稳定公开`
  用途：显式指定本次会话 ID
- `-n, --name <name>`
  可见性：`稳定公开`
  用途：设置会话展示名

### 权限、工具与上下文装配

- `--permission-mode <mode>`
  可见性：`稳定公开`
  用途：设置本次会话的权限模式
- `--dangerously-skip-permissions`
  可见性：`稳定公开`
  用途：直接绕过权限检查
  关键约束：只适合强隔离环境
- `--allow-dangerously-skip-permissions`
  可见性：`稳定公开`
  用途：允许会话以后切到 bypass，但默认不直接开启
- `--allowed-tools <tools...>`
  可见性：`稳定公开`
  用途：白名单工具集
- `--tools <tools...>`
  可见性：`稳定公开`
  用途：声明本轮可见的 built-in 工具集合
- `--disallowed-tools <tools...>`
  可见性：`稳定公开`
  用途：黑名单工具集
- `--mcp-config <configs...>`
  可见性：`稳定公开`
  用途：加载指定 MCP 配置
- `--strict-mcp-config`
  可见性：`稳定公开`
  用途：只用 `--mcp-config` 提供的 MCP，忽略其他来源
- `--system-prompt <prompt>`
  可见性：`稳定公开`
  用途：覆盖本次会话系统提示词
- `--append-system-prompt <prompt>`
  可见性：`稳定公开`
  用途：在默认系统提示词后追加
- `--settings <file-or-json>`
  可见性：`稳定公开`
  用途：加载额外 settings
- `--add-dir <directories...>`
  可见性：`稳定公开`
  用途：扩张本次工作目录集合
- `--agents <json>`
  可见性：`稳定公开`
  用途：注入自定义 agents 定义
- `--setting-sources <sources>`
  可见性：`稳定公开`
  用途：限制从哪些设置源读取配置
- `--plugin-dir <path>`
  可见性：`稳定公开`
  用途：为本次会话附加插件目录
  关键约束：可重复
- `--file <specs...>`
  可见性：`稳定公开`
  用途：启动时下载文件资源
- `--ide`
  可见性：`稳定公开`
  用途：若恰好只有一个可用 IDE，则自动连接
- `-w, --worktree [name]`
  可见性：`稳定公开`
  用途：为本次会话创建新的 git worktree
- `--tmux`
  可见性：`稳定公开`
  用途：为 worktree 创建 tmux session
  关键约束：必须配 `--worktree`
- `--disable-slash-commands`
  可见性：`条件/高级`
  用途：关闭 slash command/skills 暴露面
  关键约束：适合宿主控制，不适合普通主线
- `--chrome` / `--no-chrome`
  可见性：`条件/高级`
  用途：显式开启或关闭 Claude in Chrome 集成
  关键约束：集成能力本身仍受产品边界影响

### 模型、预算与执行力度

- `--model <model>`
  可见性：`稳定公开`
  用途：指定本次会话模型
- `--effort <level>`
  可见性：`稳定公开`
  用途：指定 effort 等级
- `--agent <agent>`
  可见性：`稳定公开`
  用途：覆盖默认 agent 设置
- `--betas <betas...>`
  可见性：`稳定公开`
  用途：为 API key 用户附加 beta headers
- `--fallback-model <model>`
  可见性：`稳定公开`
  用途：print 模式下默认模型拥塞时的回退模型
- `--max-budget-usd <amount>`
  可见性：`稳定公开`
  用途：限制 API 花费上限

## 隐藏、灰度或内部 flags

### 对用户边界最重要的一组

- `--sdk-url <url>`
  可见性：`内部/托管`
  用途：远程 WebSocket SDK I/O 流
  关键约束：会自动推到 `--print`、`input-format=stream-json`、`output-format=stream-json`、`verbose`
- `--teleport [session]`
  可见性：`隐藏/灰度`
  用途：teleport 会话恢复
- `--remote [description]`
  可见性：`隐藏/灰度`
  用途：创建 remote session
- `--remote-control [name]` / `--rc [name]`
  可见性：`条件/高级`
  用途：启动 bridge host
  关键约束：不仅隐藏，还受 `BRIDGE_MODE`、OAuth、版本和组织策略限制

### 条件公开但默认不应承诺的一组

- `--advisor <model>`
  可见性：`条件/高级`
  用途：启用 server-side advisor tool
- `--enable-auto-mode`
  可见性：`条件/高级`
  用途：显式 opt in auto mode
- `--assistant`
  可见性：`内部/托管`
  用途：强制 assistant mode
  关键约束：help 文案已写明更偏 Agent SDK daemon use
- `--channels <servers...>`
  可见性：`条件/高级`
  用途：注册 MCP channel notifications
- `--dangerously-load-development-channels <servers...>`
  可见性：`条件/高级`
  用途：加载非 allowlist 的 development channels

### 隐藏但仍能说明运行时合同的一组

- `--max-turns <turns>`
  可见性：`隐藏/灰度`
  用途：限制非交互 agentic turns
- `--task-budget <tokens>`
  可见性：`隐藏/灰度`
  用途：API 侧 task budget
- `--thinking <mode>`
  可见性：`隐藏/灰度`
  用途：thinking 模式
- `--max-thinking-tokens <tokens>`
  可见性：`隐藏/灰度`
  用途：旧 thinking token 上限
  关键约束：已标 `DEPRECATED`
- `--permission-prompt-tool <tool>`
  可见性：`隐藏/灰度`
  用途：在 print 模式里用 MCP 工具承接权限提示
- `--system-prompt-file <file>`
  可见性：`隐藏/灰度`
  用途：从文件读 system prompt
- `--append-system-prompt-file <file>`
  可见性：`隐藏/灰度`
  用途：从文件追加 system prompt
- `--resume-session-at <message id>`
  可见性：`隐藏/灰度`
  用途：print 恢复时只恢复到某条 assistant message
- `--rewind-files <user-message-id>`
  可见性：`隐藏/灰度`
  用途：按某个 user message 回退文件并退出
- `--init`
  可见性：`隐藏/灰度`
  用途：以 init trigger 运行 Setup hooks 后继续
- `--init-only`
  可见性：`隐藏/灰度`
  用途：只运行 Setup 和 SessionStart:startup hooks 后退出
- `--maintenance`
  可见性：`隐藏/灰度`
  用途：以 maintenance trigger 运行 Setup hooks

### 更偏内部协作、深链或运行支撑

- `--prefill`
- `--deep-link-origin`
- `--deep-link-repo`
- `--deep-link-last-fetch`
- `--enable-auth-status`
- `--workload`
- `--agent-color`
- `--plan-mode-required`
- `--parent-session-id`
- `--teammate-mode`
- `--agent-type`
- `--hard-fail`

这些更适合作为实现边界证据，不适合写成普通用户建议。

## root commands

### 稳定公开

- `auth login`
- `auth status`
- `auth logout`
- `mcp serve`
- `mcp add`
- `mcp remove`
- `mcp list`
- `mcp get`
- `mcp add-json`
- `mcp add-from-claude-desktop`
- `mcp reset-project-choices`
- `plugin validate`
- `plugin list`
- `plugin marketplace add`
- `plugin marketplace list`
- `plugin marketplace remove`
- `plugin marketplace update`
- `plugin install`
- `plugin uninstall`
- `plugin enable`
- `plugin disable`
- `plugin update`
- `setup-token`
- `agents`
- `doctor`
- `update`
- `upgrade`
- `install [target]`

### 条件、隐藏或宿主导向

- `server`
  可见性：`条件/高级`
  说明：DIRECT_CONNECT server
- `ssh <host> [dir]`
  可见性：`条件/高级`
  说明：SSH remote 入口
- `open <cc-url>`
  可见性：`隐藏/灰度`
  说明：internal cc:// 连接入口
- `remote-control`
  可见性：`隐藏/灰度`
  说明：help-only 注册；真实实现由 `cli.tsx` fast-path 截走
- `assistant [sessionId]`
  可见性：`条件/高级`
  说明：bridge session viewer/client
- `auto-mode defaults/config/critique`
  可见性：`条件/高级`
  说明：classifier 配置检查与评审
- `completion <shell>`
  可见性：`隐藏/灰度`
  说明：shell completion 生成器

### 内部或 ant-only

- `up`
- `rollback`
- `log`
- `error`
- `export`
- `task`

这几类不应写进普通用户主线。

## 不是 root commands，而是 fast-path 启动模式

以下入口更适合放在“启动模式”而不是“命令树”里理解：

- `--version` / `-v` / `-V`
- `--daemon-worker`
- `remote-control` / `rc` / `remote` / `sync` / `bridge`
- `daemon`
- `ps`
- `logs`
- `attach`
- `kill`
- `--bg` / `--background`
- `new`
- `list`
- `reply`
- `environment-runner`
- `self-hosted-runner`
- `--worktree` 配合 `--tmux`

其中：

- `ps/logs/attach/kill` 和 `--bg` 解决的是后台会话存活与附着
- `daemon`、`--daemon-worker` 更偏内部 supervisor/worker 体系
- `environment-runner`、`self-hosted-runner` 更偏 headless 托管执行
- `--worktree --tmux` 是稳定公开组合，fast-path 只是 bootstrap 优化

## 交叉阅读

- slash commands：`01-命令索引.md`
- 自动化与后台：`../../04-专题深潜/13-非交互、后台会话与自动化专题.md`
- 初始化、安装与 setup：`../../04-专题深潜/14-初始化、安装与开工环境搭建专题.md`
- 多前端与 remote：`../../04-专题深潜/16-IDE、Desktop、Mobile 与会话接续专题.md`
- CLI 根入口深潜：`../../04-专题深潜/18-CLI 根入口、旗标与启动模式专题.md`

## 源码锚点

- `src/main.tsx`
- `src/entrypoints/cli.tsx`
- `src/commands/mcp/addCommand.ts`
