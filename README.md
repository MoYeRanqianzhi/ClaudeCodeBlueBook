# Claude Code Blue Book

面向 `claude-code-source-code/` 的 Claude Code 蓝皮书工程。这个仓库把源码研究拆成主线章节、专题索引、失败样本、运行手册和开发记忆，而不是维护一篇持续膨胀的长文。

## 仓库结构

- [bluebook/README.md](bluebook/README.md): 蓝皮书总索引。根目录含 `00-08` 主线 9 篇和 3 个兼容别名页；专题目录包括 `api/` 92 篇、`architecture/` 81 篇、`navigation/` 99 篇、`guides/` 95 篇、`philosophy/` 83 篇、`casebooks/` 66 篇、`playbooks/` 73 篇、`risk/` 65 篇、`security/` 139 篇正文与 `security/appendix/` 122 篇速查表。
- [docs/README.md](docs/README.md): 开发与记忆文档。`docs/` 根目录 2 篇，`development/` 下 6 篇研究方法、证据索引与研究日志。
- `claude-code-source-code/`: 反编译/镜像源码参考，不是蓝皮书正文。
- 根目录辅助文档：`Agents.md`、`cgit.md`、`cmainloop.md`、`crisk.md`、`cuserbook.md` 是协作或专题备忘，不替代主线索引。

## 主线入口

- [bluebook/README.md](bluebook/README.md)
- [bluebook/00-导读.md](bluebook/00-导读.md)
- [bluebook/01-源码结构地图.md](bluebook/01-源码结构地图.md)
- [bluebook/02-使用指南.md](bluebook/02-使用指南.md)
- [bluebook/03-设计哲学.md](bluebook/03-设计哲学.md)
- [bluebook/04-公开能力与隐藏能力.md](bluebook/04-公开能力与隐藏能力.md)
- [bluebook/05-功能全景与API支持.md](bluebook/05-功能全景与API支持.md)
- [bluebook/06-第一性原理与苏格拉底反思.md](bluebook/06-第一性原理与苏格拉底反思.md)
- [bluebook/07-运行时契约、知识层与生态边界.md](bluebook/07-运行时契约、知识层与生态边界.md)
- [bluebook/08-能力全集、公开度与成熟度矩阵.md](bluebook/08-能力全集、公开度与成熟度矩阵.md)

## 专题入口

- [bluebook/navigation/README.md](bluebook/navigation/README.md): 阅读地图、交叉反查与机制回灌导航
- [bluebook/architecture/README.md](bluebook/architecture/README.md): 运行时结构、状态机与控制面
- [bluebook/api/README.md](bluebook/api/README.md): 命令、工具、状态、宿主与扩展协议
- [bluebook/guides/README.md](bluebook/guides/README.md): 使用方法、模板、审读清单与构建手册
- [bluebook/philosophy/README.md](bluebook/philosophy/README.md): 第一性原理与源码先进性解释
- [bluebook/casebooks/README.md](bluebook/casebooks/README.md): 失败样本、反例与失真原型
- [bluebook/playbooks/README.md](bluebook/playbooks/README.md): 回归、演练、rollout 与运行手册
- [bluebook/risk/README.md](bluebook/risk/README.md): 风控、账号治理、恢复与入口语义差
- [bluebook/security/README.md](bluebook/security/README.md): 安全控制面正文
- [bluebook/security/appendix/README.md](bluebook/security/appendix/README.md): 安全速查表与证据附录

## 推荐阅读

- 初次进入：`README -> bluebook/README -> 00 -> 01 -> 03 -> 08`
- 想高效使用 Claude Code：`02 -> guides/README`
- 想接宿主或控制协议：`05 -> api/README -> architecture/README`
- 想看安全与风控：`security/README -> risk/README`
- 想看失败样本和演练：`casebooks/README -> playbooks/README`

## 工作原则

- 结论尽量回到具体源码文件、运行时对象和可复查证据。
- `bluebook/` 负责正式主线与专题结论，`docs/` 只负责开发与记忆。
- 总 README 只保留一级路由；深层交叉索引下沉到各目录 README 和 `bluebook/navigation/`。
