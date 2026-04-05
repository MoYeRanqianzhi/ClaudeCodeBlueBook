# Claude Code Userbook

基于 `@anthropic-ai/claude-code` `v2.1.88` 反编译源码整理的用户手册。目标不是再写一套“架构蓝皮书”，而是回答三个用户问题：

1. Claude Code 实际能做什么。
2. 这些能力分别通过什么入口暴露。
3. 什么时候该用普通提示词、斜杠命令、技能、工具、计划模式、子代理、worktree、MCP 或插件。

## 阅读原则

- 本手册优先写“用户能做什么”和“为什么这样设计”。
- 所有关键结论尽量挂到源码注册点，而不是只挂到 UI 现象。
- 功能按“稳定公开能力、灰度能力、内部能力”分层，不混写。
- 源码锚点默认相对源码根 `../../claude-code-source-code/` 描述。该目录被主仓库 `.gitignore` 排除，不会跟随 worktree 一起复制。

## 导航

- [00-导读.md](./00-%E5%AF%BC%E8%AF%BB.md)
- [00-阅读路径.md](./00-%E9%98%85%E8%AF%BB%E8%B7%AF%E5%BE%84.md)
- [01-主线使用/README.md](./01-%E4%B8%BB%E7%BA%BF%E4%BD%BF%E7%94%A8/README.md)
- [02-能力地图/README.md](./02-%E8%83%BD%E5%8A%9B%E5%9C%B0%E5%9B%BE/README.md)
- [03-参考索引/README.md](./03-%E5%8F%82%E8%80%83%E7%B4%A2%E5%BC%95/README.md)
- [05-专题深潜/README.md](./05-%E4%B8%93%E9%A2%98%E6%B7%B1%E6%BD%9C/README.md)
- [06-控制面深挖/README.md](./06-%E6%8E%A7%E5%88%B6%E9%9D%A2%E6%B7%B1%E6%8C%96/README.md)

## 这本 Userbook 的边界

这本手册覆盖的是“发布构建中可见或可从源码恢复”的 Claude Code 能力，包括：

- CLI 启动链、REPL、会话恢复、上下文装配。
- 斜杠命令系统、技能系统、工具系统。
- 文件、Shell、Web、Notebook、LSP、MCP 等工作能力。
- 权限、沙箱、计划模式、worktree、任务、子代理、团队。
- 模型、努力等级、输出风格、成本、限额、统计。
- IDE、终端、Vim、语音、桌面、移动端、远程控制。
- 发布构建中灰度暴露、feature gate 包裹、内部专用的能力边界。

不覆盖的部分：

- Anthropic 内部 monorepo 中被 Bun `feature()` 死代码消除后完全缺失的实现细节。
- 未发布模块的运行时行为重建，只做“可从现有源码推断到的边界”说明。

## 两类专题的分工

### `05-专题深潜`

按真实工作目标组织：

- 代码工作流
- 连续性与记忆
- 治理与安全
- 扩展与集成
- 并行执行与隔离
- 前端与远程

适合想建立稳定使用方法的读者。

### `06-控制面深挖`

按高价值控制面组织：

- 权限、计划模式与 worktree
- MCP、插件、技能与 hooks 的边界
- compact / resume / memory 的控制面
- agent / task / team / cron 的控制面
- 入口决策树

适合想判断“为什么系统这样设计、哪里不能混写”的读者。
