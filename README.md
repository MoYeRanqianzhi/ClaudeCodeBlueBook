# Claude Code Blue Book

面向 `claude-code-source-code/` 的 Claude Code 蓝皮书工程。仓库现在只先分清四类入口：蓝皮书正文、面向使用者的 userbook、研究与记忆层、源码镜像；根 README 只负责把这四类入口分开，不再承担深层阅读路线。

这里还应再多记一句：

- 安全与省 token 不是两道并列题，而是同一条治理收费链的两种外观；先定题，不先找页。

## 先选入口

- [bluebook/README.md](bluebook/README.md)
  想先理解 Claude Code 的设计内涵、三张控制面和证据梯度。
- [bluebook/userbook/README.md](bluebook/userbook/README.md)
  想从使用者视角理解 Claude Code 的入口、目标与运行时边界。
- [docs/README.md](docs/README.md)
  想看研究过程、持久化记忆、变更记录和目录治理。
- `claude-code-source-code/`
  想回到源码镜像核对证据；它是研究对象，不是蓝皮书正文。

## 最短进入

- 第一次进蓝皮书：`README -> bluebook/README -> bluebook/09 -> bluebook/03`
- 想按用户目标进入：`bluebook/userbook/README`
- 想跨目录反查：`bluebook/navigation/README`
- 想追研究材料与长期记忆：`docs/README`

## 目录分工

- `bluebook/`
  正式正文与专题结论。
- `bluebook/userbook/`
  面向使用者的系统说明书。
- `docs/`
  研究过程、证据归档、长期记忆与变更记录。
- `docs/userbook-memory/`
  userbook 作者侧记忆，不替代正式正文。
- 根目录辅助文档
  `Agents.md`、`cgit.md`、`cmainloop.md`、`crisk.md`、`cuserbook.md` 是协作或专题备忘，不替代主线入口。

## 写作纪律

- 根 README 只保留一级路由，不重复展开目录深链。
- 深层分流交给各目录 `README` 和 `bluebook/navigation/README.md`。
- `docs/` 记录过程与记忆，不回灌蓝皮书正文主语。
