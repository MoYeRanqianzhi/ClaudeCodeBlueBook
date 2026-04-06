# Headless 启动链、首问就绪与 StructuredIO 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/20-Headless 启动链、首问就绪与 StructuredIO：为什么 print 不是没有 UI 的 REPL.md`
- `04-专题深潜/13-非交互、后台会话与自动化专题.md`
- `04-专题深潜/18-CLI 根入口、旗标与启动模式专题.md`

## 1. 为什么 print 不是“去掉 UI 的 REPL”

| 维度 | 交互 REPL | headless / print |
| --- | --- | --- |
| 入口分流 | 启动后进入完整前台会话 | 启动早期就判定 non-interactive |
| 根命令树 | 注册完整 subcommands | 跳过 root subcommands 注册，走默认 action |
| I/O | 终端 UI / 面板 / 输入框 | `StructuredIO` / `RemoteIO` 控制流 |
| 首问策略 | 先 render，再逐步补对象 | 为首问选择性 await 关键对象 |
| 命令面 | REPL 全量 slash 面 | 只保留支持 non-interactive 的命令对象 |

## 2. 首问前通常会等待什么

| 对象 | headless 默认语义 |
| --- | --- |
| regular MCP configs | await 连接批次，保证首问尽量看见工具 |
| `claude.ai` connectors | bounded wait，超时后后台继续连 |
| `SessionStart` startup hooks | 早启动，后 join |
| versioned plugins init | await |
| sync plugin install | 打开同步环境变量时首问前等待，并在后面 refresh |
| org restriction 校验 | 首问前校验 |

## 3. 首问前不会被无条件保证的对象

| 对象 | 更准确的理解 |
| --- | --- |
| skills / plugins 新鲜源 | `QueryEngine` 默认只读 cache-only |
| deferred prefetch | 后台 warmup，不是首问硬前置 |
| housekeeping | 后台整理，不是首问合同 |
| claude.ai connectors 全量完成 | 只给 bounded wait，不保证全到齐 |
| hooks / LSP / plugin sync in `--bare` | 最小模式直接跳过 |

## 4. 三个最容易混写的宿主对象

| 对象 | 实际语义 | 最容易误判 |
| --- | --- | --- |
| `-p/--print` | 非交互执行主线 | 误写成 REPL 去 UI |
| `--sdk-url` | 远端结构化宿主切换器 | 误写成普通远端输出参数 |
| `--bare` | 最小宿主模式 | 误写成更快的 print 默认值 |

## 5. print-only 或 headless 更硬的合同

| 能力 | 约束 |
| --- | --- |
| `--no-session-persistence` | 只允许在 print |
| `--resume-session-at` | 依赖 `--resume` |
| `--rewind-files` | 依赖 `--resume`，且不能再给 prompt |
| `--resume` in print | 需要合法 session ID / JSONL / URL |
| `stream-json` input | 必须搭配 `stream-json` output |
| `--include-partial-messages` | 需要 print + `stream-json` output |

## 6. 稳定、条件、内部三分

| 层 | 典型对象 |
| --- | --- |
| 稳定公开 | `-p/--print`、`--output-format`、`--input-format`、`--continue`、`--resume`、`--fork-session`、`--no-session-persistence`、`--bare` |
| 条件公开 / 灰度 | `--sdk-url`、`stream-json` 双向宿主流、`--include-partial-messages`、`--replay-user-messages`、同步插件安装环境变量、bounded connector wait |
| 内部 / 影子 | 内部 `open <cc-url>`、CCR internal event 恢复、直接连接 server / daemon worker 细节 |

## 7. 七个高价值判断问题

- 我现在讨论的是 REPL，会话协议宿主，还是最小宿主模式？
- 当前差异出现在入口分流、I/O、首问 ready，还是命令暴露面？
- 这里看到的是 cache-only 投影，还是首问前明确等待过的对象？
- 我是不是把 `--sdk-url` 错当成普通参数，而不是宿主切换器？
- 我是不是把 `stream-json` 错当成普通 JSON 输出格式？
- 我是不是把 headless 的插件物化写成当前会话已经 refresh？
- 我是不是把内部 `open` / CCR 细节写成普通用户主线？

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
