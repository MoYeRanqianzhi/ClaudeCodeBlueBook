# 蓝皮书总索引

## 这套目录怎么读

这套文档分成三层：

- `bluebook/README + 00-09` 负责规范主线与最短阅读路径
- 各子目录 `README` 负责专题入口、编号段职责与稳定跳转
- `docs/` 与 `bluebook/` 并列协同，负责开发记忆、研究过程与清理批次，不承载正文

总索引只保留一级路由和稳定阅读路径；更深的跨目录编号链统一下沉到各子目录 README，尤其是 `navigation/README.md`。如果问题已经变成“上一轮推进到哪、下一批准备清什么、哪些内容被迁出正文”，就不要继续留在 `bluebook/`，直接去 `docs/README.md`。

还要多记一句：

- 目录分层首先是阅读协议，不是源码质量评分；根目录更薄、索引更清楚，不等于运行时边界就已经更稳
- 安全与省 token 也必须共读，因为它们共享同一张“扩张如何被定价”的治理控制面；想继续深读，不要在根层展开长链，先回 `09` 与 `philosophy/85`

## 主线章节

1. [00-导读](00-导读.md)
2. [01-源码结构地图](01-源码结构地图.md)
3. [02-使用指南](02-使用指南.md)
4. [03-设计哲学](03-设计哲学.md)
5. [04-公开能力与隐藏能力](04-公开能力与隐藏能力.md)
6. [05-功能全景与API支持](05-功能全景与API支持.md)
7. [06-第一性原理与苏格拉底反思](06-第一性原理与苏格拉底反思.md)
8. [07-运行时契约、知识层与生态边界](07-运行时契约、知识层与生态边界.md)
9. [08-能力全集、公开度与成熟度矩阵](08-能力全集、公开度与成熟度矩阵.md)
10. [09-三张控制面总图：世界进入模型、扩张定价与防过去写坏现在](09-三张控制面总图：世界进入模型、扩张定价与防过去写坏现在.md)

- 兼容别名页：`00-总览.md`、`00-蓝皮书总览.md`、`01-源码总地图.md`

## 专题目录

- [navigation/README.md](navigation/README.md): 104 篇，阅读地图、问题反查与机制回灌
- [architecture/README.md](architecture/README.md): 84 篇，运行时结构、状态机、请求装配、治理控制面与演化边界
- [api/README.md](api/README.md): 95 篇，命令、工具、状态、宿主与扩展协议
- [guides/README.md](guides/README.md): 102 篇，使用方法、模板、审读清单与构建手册
- [philosophy/README.md](philosophy/README.md): 87 篇，第一性原理、治理观、控制面收束与源码先进性解释
- [casebooks/README.md](casebooks/README.md): 75 篇，失败样本、反例与失真原型
- [playbooks/README.md](playbooks/README.md): 79 篇，回归、演练、rollout 与运行手册
- [risk/README.md](risk/README.md): 65 篇，风控、账号治理、恢复与中国用户入口问题
- [security/README.md](security/README.md): 139 篇正文，安全控制面、恢复语义与工程化验证
- [security/appendix/README.md](security/appendix/README.md): 122 篇速查表，安全证据、词法、路由与验证附录

## 推荐阅读

第一次进入：

- 建立整体判断：先读 [09-三张控制面总图：世界进入模型、扩张定价与防过去写坏现在](09-三张控制面总图：世界进入模型、扩张定价与防过去写坏现在.md)，再回到 [00-导读](00-导读.md)、[01-源码结构地图](01-源码结构地图.md)、[03-设计哲学](03-设计哲学.md)、[06-第一性原理与苏格拉底反思](06-第一性原理与苏格拉底反思.md)
- 如果只想先抓最高阶判断：依次读 [09-三张控制面总图：世界进入模型、扩张定价与防过去写坏现在](09-三张控制面总图：世界进入模型、扩张定价与防过去写坏现在.md)、[03-设计哲学](03-设计哲学.md)、[06-第一性原理与苏格拉底反思](06-第一性原理与苏格拉底反思.md)、[philosophy/84-真正有魔力的Prompt，会先规定世界如何合法进入模型](philosophy/84-真正有魔力的Prompt，会先规定世界如何合法进入模型.md)、[philosophy/85-真正成熟的治理，不是更会拦截，而是更会为扩张定价](philosophy/85-真正成熟的治理，不是更会拦截，而是更会为扩张定价.md)、[philosophy/86-真正先进的内核，不是更会分层，而是更会阻止过去写坏现在](philosophy/86-真正先进的内核，不是更会分层，而是更会阻止过去写坏现在.md)、[philosophy/87-真正成熟的源码质量判断，不是文件更小，而是复杂度中心合法、边界可证、下一次重构仍有路](philosophy/87-真正成熟的源码质量判断，不是文件更小，而是复杂度中心合法、边界可证、下一次重构仍有路.md)

从能力与公开度进入：

- 看 Claude Code 到底支持什么、承诺到哪：依次读 [04-公开能力与隐藏能力](04-公开能力与隐藏能力.md)、[05-功能全景与API支持](05-功能全景与API支持.md)、[08-能力全集、公开度与成熟度矩阵](08-能力全集、公开度与成熟度矩阵.md)、[navigation/02-能力、API与治理检索图](navigation/02-能力、API与治理检索图.md)、[api/README.md](api/README.md)
- 看宿主接入与协议边界：先读 [05-功能全景与API支持](05-功能全景与API支持.md)，再去 [api/README.md](api/README.md) 与 [architecture/README.md](architecture/README.md)

从设计内涵进入：

- 想直接抓三张控制面总图：先读 [09-三张控制面总图：世界进入模型、扩张定价与防过去写坏现在](09-三张控制面总图：世界进入模型、扩张定价与防过去写坏现在.md)、[03-设计哲学](03-设计哲学.md)、[06-第一性原理与苏格拉底反思](06-第一性原理与苏格拉底反思.md)，再去 [navigation/README.md](navigation/README.md) 选择深线路由
- 想把三张控制面图落成 Builder 审读模板、长期验证手册或长期验证失真反例：统一先去 [navigation/README.md](navigation/README.md)

从方法与质量进入：

- 想从使用方法进入：先读 [02-使用指南](02-使用指南.md)，再去 [guides/README.md](guides/README.md) 与 [navigation/README.md](navigation/README.md)
- 想在公开镜像条件下稳当地判断源码质量：先读 [07-运行时契约、知识层与生态边界](07-运行时契约、知识层与生态边界.md)，再去 [guides/README.md](guides/README.md)、[philosophy/README.md](philosophy/README.md) 与 [navigation/README.md](navigation/README.md)
- 想看源码质量 / 可演化结构：先读 [03-设计哲学](03-设计哲学.md)、[06-第一性原理与苏格拉底反思](06-第一性原理与苏格拉底反思.md)，再去 [philosophy/README.md](philosophy/README.md) 与 [navigation/README.md](navigation/README.md)
- 想看安全、风控与误伤恢复：先回 [09-三张控制面总图：世界进入模型、扩张定价与防过去写坏现在](09-三张控制面总图：世界进入模型、扩张定价与防过去写坏现在.md) 的第二张图，再去 [philosophy/85-真正成熟的治理，不是更会拦截，而是更会为扩张定价](philosophy/85-真正成熟的治理，不是更会拦截，而是更会为扩张定价.md)、[security/README.md](security/README.md)、[risk/README.md](risk/README.md)、[casebooks/README.md](casebooks/README.md)
- 想看失败样本、演练与 rollout：依次读 [casebooks/README.md](casebooks/README.md)、[playbooks/README.md](playbooks/README.md)、[navigation/README.md](navigation/README.md)

## 索引分层

- 总索引负责一级路由、目录职责和稳定阅读路径。
- 子目录 README 负责编号段说明、专题入口和跨目录跳转。
- `navigation/README.md` 负责跨主题、跨阶段、跨工件的深层反查。
- [../docs/README.md](../docs/README.md) 只处理开发过程与长期记忆，不承载正文。
