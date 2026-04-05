# Commands 二级目录 Atlas：会话控制、模式治理、扩展装配、交付诊断与内部命令边界

这一章回答五个问题：

1. `commands/` 往二级目录拆开后，到底分成了哪些控制面族群。
2. 哪些命令属于正式公开控制面，哪些命令属于 internal-only、feature-gated 或构建时剔除的命令面。
3. `commands.ts` 与各命令目录之间的真正权威关系是什么。
4. 哪些命令目录最容易被误读，从而把产品边界和工程边界混写。
5. 平台设计者该按什么顺序阅读 `commands/`。

## 0. 本地扫描与代表性锚点

本地扫描（`2026-04-02`，源码镜像）：

- `src/commands/` 可见 `86` 个一级子目录
- `src/commands/` 根目录可见 `15` 个根文件
- 文件数较高的目录包括：
  - `plugin`：约 `17` 个文件
  - `install-github-app`：约 `14` 个文件
  - `mcp`：约 `4` 个文件
  - `extra-usage`：约 `4` 个文件

代表性源码锚点：

- `claude-code-source-code/src/commands.ts:224-340`
- `claude-code-source-code/src/commands/plugin/index.tsx:1-10`
- `claude-code-source-code/src/commands/mcp/mcp.tsx:1-85`
- `claude-code-source-code/src/commands/context/context.tsx:1-120`
- `claude-code-source-code/src/commands/permissions/permissions.tsx:1-120`
- `claude-code-source-code/src/commands/resume/resume.tsx:1-120`

## 1. 先说结论

`commands/` 不是“一堆 slash 命令”目录。

更准确地说，它是 Claude Code 的显式控制平面，至少可以拆成六组：

1. 会话与状态控制命令
2. 模式与设置治理命令
3. 扩展与连接装配命令
4. 交付、诊断与运营命令
5. 协作、团队与工作流命令
6. internal-only / feature-gated / 构建剔除命令

这张 atlas 最关键的意义不是：

- 命令有多少

而是：

- 哪些命令代表正式 public control surface，哪些命令只是实验、内部或特定构建目标的命令面

## 2. 真正的权威入口是 `commands.ts`

阅读 `commands/` 最稳的入口不是随机打开某个目录，而是先看：

- `INTERNAL_ONLY_COMMANDS`
- `COMMANDS()`

因为这里统一处理了：

1. 哪些命令在外部构建中会被剔除
2. 哪些命令在运行时按 config / feature gate / user type 动态出现
3. 哪些命令是 local-jsx shell，哪些只是包装真实实现

这意味着：

- 命令目录只是定义层
- 真正的公开边界，要到 `commands.ts` 才能看清

## 3. 会话与状态控制命令

核心目录 / 文件：

- `clear/`
- `compact/`
- `context/`
- `memory/`
- `resume/`
- `rewind/`
- `session/`
- `status/`
- `rename/`
- `export/`

主要职责：

1. 控制会话生命周期
2. 查看 / 清理 / 恢复 / 压缩会话状态
3. 把“继续、恢复、导出”做成正式用户控制面

最容易误读的边界：

1. `resume` 不是便利命令，而是恢复控制面的一部分。
2. `compact` 不是摘要按钮，而是上下文对象升级控制面。
3. `context` 有交互式与非交互式两条路径，说明同一命令也可能有不同消费者。

## 4. 模式与设置治理命令

核心目录 / 文件：

- `permissions/`
- `plan/`
- `model/`
- `effort/`
- `output-style/`
- `privacy-settings/`
- `keybindings/`
- `sandbox-toggle/`
- `config/`
- `hooks/`

主要职责：

1. 切换 permission / plan / model / effort 等治理对象
2. 把原本容易散落在 UI 控件里的治理动作收口成正式命令
3. 让设置、hooks、privacy 成为显式控制面

最容易误读的边界：

1. `permissions` / `plan` / `model` 不只是设置页入口，而是对象升级与治理入口。
2. `sandbox-toggle` 这类命令虽然像小开关，但改的是安全控制平面。
3. `hooks` 与 `config` 更接近治理命令，而不是扩展命令。

## 5. 扩展与连接装配命令

核心目录 / 文件：

- `mcp/`
- `plugin/`
- `reload-plugins/`
- `remote-env/`
- `bridge/`
- `ide/`
- `desktop/`
- `mobile/`
- `install-github-app/`
- `install-slack-app/`

主要职责：

1. 安装 / 管理扩展、MCP、plugin、remote env
2. 把外部连接、host 集成和 app 装配做成正式控制面
3. 处理 redirect、wrapper、UI shell 与 transport 连接

最容易误读的边界：

1. `commands/mcp` 不是 MCP 控制真相本身，它是命令面，真正配置真相仍在 `services/mcp/`。
2. `commands/plugin` 也只是 control shell，插件生命周期真相还在 `services/plugins/`。
3. 某些命令目录如 `plugin/index.tsx` 本身只是懒加载壳层，真正重量级逻辑在 `plugin.tsx` 与服务层。

## 6. 交付、诊断与运营命令

核心目录 / 文件：

- `diff/`
- `review/`
- `security-review.ts`
- `cost/`
- `stats/`
- `doctor/`
- `feedback/`
- `release-notes/`
- `usage/` / `extra-usage/`

主要职责：

1. 提供 review、diff、security、cost、usage 等运营面
2. 把质量、诊断和用户反馈做成显式命令
3. 承担部分实验与商业化相关控制面

最容易误读的边界：

1. `review` / `security-review` 是控制面入口，不等于底层 reviewer runtime 真相。
2. `cost` / `stats` / `usage` 是消费者可见投影，不等于全部预算器真相。
3. `doctor` 是诊断入口，不等于所有真实故障都在此统一收口。

## 7. 协作、团队与工作流命令

核心目录 / 文件：

- `agents/`
- `tasks/`
- `files/`
- `btw/`
- `brief.ts`
- `branch/`
- `tag/`
- `passes/`

主要职责：

1. 暴露多 agent、tasks、文件与协作工作流
2. 提供 branch/tag 等开发交付动作
3. 提供 side question / brief 这类高价值协作入口

最容易误读的边界：

1. `btw` 不是普通快捷命令，而是共享 cache-safe prefix 的旁路协作面。
2. `agents` / `tasks` 不只是命令菜单，而是多 agent / task runtime 的外部控制面。
3. `brief` 这类根文件命令说明“重量级入口不一定都长在目录里”。

## 8. Internal-Only / Feature-Gated 命令面

`INTERNAL_ONLY_COMMANDS` 明确列出：

- `backfillSessions`
- `breakCache`
- `bughunter`
- `ctx_viz`
- `goodClaude`
- `autofixPr`
- `debugToolCall`
- `antTrace`
- `perfIssue`
- `oauthRefresh`
- `env`

这说明 Claude Code 的命令面至少分三层：

1. 正式公开命令面
2. feature-gated / user-type-gated 命令面
3. internal-only / external build eliminated 命令面

这也是为什么：

- “代码里有命令”不等于“产品承诺支持”

## 9. Commands 的三个目录信号

`commands/` 的形状暴露了三个很强的设计信号：

1. 入口壳层与真实实现分离
2. public / internal / gated surface 分层
3. 命令面负责控制，不负责持有全部底层真相

因此最危险的误读通常是：

1. 把命令目录当成唯一权威真相
2. 把 internal-only 命令当成公开能力
3. 把 UI 壳层当成底层控制平面

## 10. 推荐阅读顺序

更稳的 `commands/` 阅读顺序是：

1. `commands.ts`：先看 public / internal / gated 边界
2. `resume / compact / session / context`：再看会话控制面
3. `permissions / plan / model / config`：再看治理控制面
4. `mcp / plugin / remote-env / bridge`：再看扩展装配控制面
5. `review / cost / doctor / usage`：最后看诊断运营控制面

## 11. 一句话总结

`commands/` 二级目录 atlas 真正统一的，不是“有哪些 slash 命令”，而是“哪些显式控制动作被公开承诺、哪些只对特定消费者开放、哪些根本不该被误当公开能力”。
