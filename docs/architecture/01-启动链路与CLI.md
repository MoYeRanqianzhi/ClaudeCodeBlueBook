# 启动链路与 CLI

## 1. 结论先行

Claude Code 的入口设计不是“先把全部系统载入，再解析参数”，而是相反：

- 先做极轻量参数分流
- 命中快路径就直接退出
- 只有确实需要完整能力时，才加载主程序

这套设计直接服务于两个目标：

1. 降低冷启动成本
2. 让同一个二进制承载多种运行形态

## 2. 最小入口：`src/entrypoints/cli.tsx`

`src/entrypoints/cli.tsx` 做的事非常克制：

- 顶层先修正少量进程级环境变量，例如 `COREPACK_ENABLE_AUTO_PIN` 与远程场景的 `NODE_OPTIONS`
- `main()` 中优先检查 `--version`
- 再依次检查一系列快路径
- 最后才 `import('../main.js')`

关键证据：

- `--version` 零额外导入：`src/entrypoints/cli.tsx`
- Chrome/MCP/daemon/bridge/bg/template/self-hosted/worktree 都有独立快路径：`src/entrypoints/cli.tsx`
- 真正的完整程序在最后才进入：`src/entrypoints/cli.tsx`

这意味着 Claude Code 的 CLI 不是一个单体命令处理器，而是一个“分发器”。

## 3. 为什么快路径这么多

从代码看，Claude Code 至少试图同时支持这些形态：

- 普通交互式 CLI
- 非交互脚本调用
- MCP 相关子进程
- bridge / remote-control
- daemon worker
- background session 管理
- self-hosted runner
- worktree + tmux

也就是说，`claude` 不是单一产品界面，而是统一入口。

## 4. 完整主程序：`src/main.tsx`

`src/main.tsx` 的风格很明显：重视启动阶段的并发预取。

它在最前面就启动：

- MDM 原始读取
- macOS keychain 预取
- startup profiler

然后才导入大批业务模块。

关键证据：

- 顶层注释明确写出这些副作用必须最先执行：`src/main.tsx`
- `startMdmRawRead()` 与 `startKeychainPrefetch()` 在其他重模块之前启动：`src/main.tsx`

这说明作者把“几十毫秒级的启动优化”当成一等问题，而不是事后优化。

## 5. 初始化：`src/entrypoints/init.ts`

`init()` 的职责不是 UI，而是运行时底座。

它负责：

- 启用配置系统
- 先应用安全环境变量，再在信任建立后补全
- 配置 CA 证书、mTLS、代理
- 预连接 API
- 初始化遥测与远程设置加载 Promise
- 注册清理逻辑
- 初始化 scratchpad

关键证据：

- 配置与安全环境变量：`src/entrypoints/init.ts`
- 遥测延迟初始化与 1P logging：`src/entrypoints/init.ts`
- 代理、mTLS、upstream proxy：`src/entrypoints/init.ts`
- graceful shutdown 与 cleanup：`src/entrypoints/init.ts`

这个分层很关键：

- `cli.tsx` 决定走哪条路
- `main.tsx` 负责载入完整运行时
- `init.ts` 负责把运行时变成“可信、可联网、可观测、可恢复”的系统

## 6. 命令系统：`src/commands.ts`

`src/commands.ts` 是命令注册中心，不只是几个 slash command 的数组。

它有三个显著特征：

1. 命令数量很大，覆盖工作流、配置、恢复、插件、技能、模型、权限、审查等多个面
2. 大量命令受 `feature()` 或 `USER_TYPE` 控制
3. 某些大模块采用延迟导入，例如 `insights`

这说明 slash command 在 Claude Code 里不是补充功能，而是产品表面的一部分。

## 7. 对使用方式的直接影响

从启动层可以反推三条使用原则：

1. 简单查询优先用快路径或非交互模式，没必要每次都进入重 UI。
2. 复杂会话、长任务、恢复、后台执行，都依赖完整主程序和会话基础设施。
3. Claude Code 的“命令”与“对话”不是对立关系，命令本身就是工作流控制面。

## 8. 一句话总结

Claude Code 的启动设计核心不是“把程序跑起来”，而是“尽快进入最合适的运行模式”。
