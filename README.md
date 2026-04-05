# Claude Code Blue Book

面向 `claude-code-source-code/` 的 Claude Code 蓝皮书工程。

仓库把源码研究拆成主线章节、专题目录和开发文档，避免把所有内容继续堆成一篇持续膨胀的长文。

## 仓库结构

- [bluebook/README.md](<bluebook/README.md>): 蓝皮书总索引。包含 `00-08` 主线、兼容别名页，以及 `api`、`architecture`、`casebooks`、`guides`、`navigation`、`philosophy`、`playbooks`、`risk`、`security` 九个专题目录。
- [docs/README.md](<docs/README.md>): 研究方法、证据索引、长期记忆、研究日志和变更记录。
- `claude-code-source-code/`: 本地源码镜像，仅作对照分析，不承担本仓库正文。
- [Agents.md](<Agents.md>): 协作约束与 agent 工作说明。
- [LICENSE](<LICENSE>): 项目许可证。

## 从哪里开始读

- 想先建立整体判断：从 [bluebook/00-导读.md](<bluebook/00-导读.md>) 开始，再读 [bluebook/01-源码结构地图.md](<bluebook/01-源码结构地图.md>)、[bluebook/03-设计哲学.md](<bluebook/03-设计哲学.md>)、[bluebook/07-运行时契约、知识层与生态边界.md](<bluebook/07-运行时契约、知识层与生态边界.md>)。
- 想按专题深入：直接进入 [bluebook/README.md](<bluebook/README.md>)，再选择 `api`、`architecture`、`guides`、`security` 或 `risk`。
- 想核对研究依据和写作过程：看 [docs/development/02-证据索引.md](<docs/development/02-证据索引.md>)、[docs/development/research-log.md](<docs/development/research-log.md>)。

## 当前约定

- 正式蓝皮书正文只写入 `bluebook/`。
- `docs/` 只保留研究方法、开发文档和记忆材料。
- `claude-code-source-code/` 作为对照镜像使用，不在正文里重复抄录。
