# 蓝皮书总索引

## 这套目录怎么读

先只记三句：世界如何进入模型，扩张如何被定价，当前如何不被过去写坏。第一次进入先读 [09-三张控制面总图：世界进入模型、扩张定价与防过去写坏现在](09-三张控制面总图：世界进入模型、扩张定价与防过去写坏现在.md)，再回 [03-设计哲学](03-设计哲学.md)；要跨目录反查时再去 [navigation/README.md](navigation/README.md)；方法附录、证据归档与目录治理记录去 [../docs/README.md](../docs/README.md)。

- `bluebook/README + 00-09` 负责规范主线与最短阅读路径
- 各子目录 `README` 负责专题入口、编号段职责与稳定跳转
- `userbook/` 负责面向使用者的系统说明书
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

- [userbook/README.md](userbook/README.md): Claude Code Userbook，按用户目标、入口与运行时边界组织
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

- 先建立主线宪法：读 [09-三张控制面总图：世界进入模型、扩张定价与防过去写坏现在](09-三张控制面总图：世界进入模型、扩张定价与防过去写坏现在.md)，再回到 [00-导读](00-导读.md)、[01-源码结构地图](01-源码结构地图.md)、[03-设计哲学](03-设计哲学.md)、[06-第一性原理与苏格拉底反思](06-第一性原理与苏格拉底反思.md)
- 如果想按线性主线顺序完整走一遍：依次读 [00-导读](00-导读.md)、[01-源码结构地图](01-源码结构地图.md)、[03-设计哲学](03-设计哲学.md)、[07-运行时契约、知识层与生态边界](07-运行时契约、知识层与生态边界.md)、[09-三张控制面总图：世界进入模型、扩张定价与防过去写坏现在](09-三张控制面总图：世界进入模型、扩张定价与防过去写坏现在.md)
- 如果只想先抓最高阶判断：先读 [09-三张控制面总图：世界进入模型、扩张定价与防过去写坏现在](09-三张控制面总图：世界进入模型、扩张定价与防过去写坏现在.md)、[03-设计哲学](03-设计哲学.md)、[06-第一性原理与苏格拉底反思](06-第一性原理与苏格拉底反思.md)，再回 [philosophy/README.md](philosophy/README.md)、[guides/README.md](guides/README.md)、[navigation/README.md](navigation/README.md)

按主题进入：

- 能力与公开度：先读 [04-公开能力与隐藏能力](04-公开能力与隐藏能力.md)、[05-功能全景与API支持](05-功能全景与API支持.md)、[08-能力全集、公开度与成熟度矩阵](08-能力全集、公开度与成熟度矩阵.md)
- 设计内涵：先读 [09-三张控制面总图：世界进入模型、扩张定价与防过去写坏现在](09-三张控制面总图：世界进入模型、扩张定价与防过去写坏现在.md)、[03-设计哲学](03-设计哲学.md)、[06-第一性原理与苏格拉底反思](06-第一性原理与苏格拉底反思.md)
- Prompt 设计哲学与验证：先回 `09` 建立主语，再分别从 [philosophy/README.md](philosophy/README.md)、[guides/README.md](guides/README.md) 与 [playbooks/README.md](playbooks/README.md) 进入；跨目录执行链统一回 [navigation/README.md](navigation/README.md)
- 方法与构建：先读 [02-使用指南](02-使用指南.md)，再去 [guides/README.md](guides/README.md)
- 安全、风控与恢复：先回 [09-三张控制面总图：世界进入模型、扩张定价与防过去写坏现在](09-三张控制面总图：世界进入模型、扩张定价与防过去写坏现在.md) 的第二张图，再去 [security/README.md](security/README.md)、[risk/README.md](risk/README.md) 与 [playbooks/README.md](playbooks/README.md)
- 需要值班、验收、修复与长期回归：先去 [playbooks/README.md](playbooks/README.md)，更深的跨目录执行链统一回 [navigation/README.md](navigation/README.md)

从设计内涵进入：

- 想直接抓三张控制面总图：依次读 [09-三张控制面总图：世界进入模型、扩张定价与防过去写坏现在](09-三张控制面总图：世界进入模型、扩张定价与防过去写坏现在.md)、[03-设计哲学](03-设计哲学.md)、[06-第一性原理与苏格拉底反思](06-第一性原理与苏格拉底反思.md)、[navigation/03-深度专题导航：Prompt、预算、对象、底盘与治理](navigation/03-深度专题导航：Prompt、预算、对象、底盘与治理.md)、[architecture/82-请求装配流水线：authority chain、section registry、protocol transcript、lawful forgetting与cache-safe forks](architecture/82-请求装配流水线：authority chain、section registry、protocol transcript、lawful forgetting与cache-safe forks.md)、[architecture/83-反扩张治理流水线：trusted inputs、distributed ask arbitration、deferred visibility与continuation pricing](architecture/83-反扩张治理流水线：trusted inputs、distributed ask arbitration、deferred visibility与continuation pricing.md)、[architecture/84-权威面与反僵尸图谱：single-writer surfaces、409 adoption、bridge pointer freshness与release shaping](architecture/84-权威面与反僵尸图谱：single-writer surfaces、409 adoption、bridge pointer freshness与release shaping.md)
- 想把三张控制面图落成 Builder 审读模板：先读 [navigation/15-苏格拉底审读导航：三张控制面图、验证模板与builder-facing问题清单](navigation/15-苏格拉底审读导航：三张控制面图、验证模板与builder-facing问题清单.md)，再去 [guides/99-如何用苏格拉底诘问法审读请求装配控制面：authority chain、protocol transcript与continuation object](guides/99-如何用苏格拉底诘问法审读请求装配控制面：authority chain、protocol transcript与continuation object.md)、[guides/100-如何用苏格拉底诘问法审读当前世界准入主权：trusted inputs、最小可见面与continuation pricing](guides/100-如何用苏格拉底诘问法审读当前世界准入主权：trusted inputs、最小可见面与continuation pricing.md)、[guides/101-如何用苏格拉底诘问法审读one writable present：single-writer、recovery asset与anti-zombie](guides/101-如何用苏格拉底诘问法审读one writable present：single-writer、recovery asset与anti-zombie.md)
- 想把三张控制面图落成长期验证手册：先读 [navigation/39-长期验证导航：三张控制面图怎样进入持续回归、演练与release gate](navigation/39-长期验证导航：三张控制面图怎样进入持续回归、演练与release gate.md)，再去 [playbooks/77-请求装配控制面验证手册：authority chain、protocol transcript、continuation object与cache-safe fork回归](playbooks/77-请求装配控制面验证手册：authority chain、protocol transcript、continuation object与cache-safe fork回归.md)、[playbooks/78-当前世界准入主权验证手册：trusted inputs、typed ask、最小可见面与continuation gate回归](playbooks/78-当前世界准入主权验证手册：trusted inputs、typed ask、最小可见面与continuation gate回归.md)、[playbooks/79-one writable present验证手册：single-writer authority、recovery asset与anti-zombie回归](playbooks/79-one writable present验证手册：single-writer authority、recovery asset与anti-zombie回归.md)
- 想看三张控制面图的长期验证为何会被伪验证偷走：先读 [navigation/40-长期验证失真导航：三张控制面图怎样被假验证、假恢复与假完成偷走](navigation/40-长期验证失真导航：三张控制面图怎样被假验证、假恢复与假完成偷走.md)，再去 [casebooks/73-请求装配控制面验证失真反例：假authority chain、假protocol transcript与假continuation object](casebooks/73-请求装配控制面验证失真反例：假authority chain、假protocol transcript与假continuation object.md)、[casebooks/74-当前世界准入主权验证失真反例：低信任扩权、假最小可见面与免费继续](casebooks/74-当前世界准入主权验证失真反例：低信任扩权、假最小可见面与免费继续.md)、[casebooks/75-one writable present验证失真反例：健康投影篡位、恢复资产越权与anti-zombie伪证](casebooks/75-one writable present验证失真反例：健康投影篡位、恢复资产越权与anti-zombie伪证.md)，最后回到 [playbooks/77-请求装配控制面验证手册：authority chain、protocol transcript、continuation object与cache-safe fork回归](playbooks/77-请求装配控制面验证手册：authority chain、protocol transcript、continuation object与cache-safe fork回归.md)、[playbooks/78-当前世界准入主权验证手册：trusted inputs、typed ask、最小可见面与continuation gate回归](playbooks/78-当前世界准入主权验证手册：trusted inputs、typed ask、最小可见面与continuation gate回归.md)、[playbooks/79-one writable present验证手册：single-writer authority、recovery asset与anti-zombie回归](playbooks/79-one writable present验证手册：single-writer authority、recovery asset与anti-zombie回归.md)

从方法与质量进入：

- 想从使用方法进入：先读 [02-使用指南](02-使用指南.md)，再去 [guides/README.md](guides/README.md) 与 [navigation/README.md](navigation/README.md)
- 想直接按用户目标进入：先读 [userbook/README.md](userbook/README.md)，再去 [userbook/00-阅读路径](userbook/00-阅读路径.md)
- 想在公开镜像条件下稳当地判断源码质量：依次读 [07-运行时契约、知识层与生态边界](07-运行时契约、知识层与生态边界.md)、[guides/19-如何在公开镜像条件下阅读大型Agent源码：入口、合同与边界优先](guides/19-如何在公开镜像条件下阅读大型Agent源码：入口、合同与边界优先.md)、[guides/20-如何在公开镜像条件下判断实现深度：代码热点、缺口与保守推断](guides/20-如何在公开镜像条件下判断实现深度：代码热点、缺口与保守推断.md)、[guides/102-如何给公开镜像做源码质量证据分级：contract、registry、authoritative surface、adapter subset与hotspot gap discipline](guides/102-如何给公开镜像做源码质量证据分级：contract、registry、authoritative surface、adapter subset与hotspot gap discipline.md)、[philosophy/76-真正成熟的源码地图，不是目录列得更细，而是更快暴露权威入口、消费者子集与危险改动面](philosophy/76-真正成熟的源码地图，不是目录列得更细，而是更快暴露权威入口、消费者子集与危险改动面.md)、[philosophy/86-真正先进的内核，不是更会分层，而是更会阻止过去写坏现在](philosophy/86-真正先进的内核，不是更会分层，而是更会阻止过去写坏现在.md)、[philosophy/87-真正成熟的源码质量判断，不是文件更小，而是复杂度中心合法、边界可证、下一次重构仍有路](philosophy/87-真正成熟的源码质量判断，不是文件更小，而是复杂度中心合法、边界可证、下一次重构仍有路.md)、[architecture/38-Contract优先、运行时底盘与公开镜像缺口](architecture/38-Contract优先、运行时底盘与公开镜像缺口.md)、[architecture/63-构建系统塑形源码秩序：入口影子、传输外壳、薄Registry与Zombification治理](architecture/63-构建系统塑形源码秩序：入口影子、传输外壳、薄Registry与Zombification治理.md)、[architecture/84-权威面与反僵尸图谱：single-writer surfaces、409 adoption、bridge pointer freshness与release shaping](architecture/84-权威面与反僵尸图谱：single-writer surfaces、409 adoption、bridge pointer freshness与release shaping.md)
- 想看源码质量 / 可演化结构：依次读 [03-设计哲学](03-设计哲学.md)、[06-第一性原理与苏格拉底反思](06-第一性原理与苏格拉底反思.md)、[philosophy/76-真正成熟的源码地图，不是目录列得更细，而是更快暴露权威入口、消费者子集与危险改动面](philosophy/76-真正成熟的源码地图，不是目录列得更细，而是更快暴露权威入口、消费者子集与危险改动面.md)、[philosophy/80-真正先进的源码，会先替未来维护者保留反对当前实现的能力](philosophy/80-真正先进的源码，会先替未来维护者保留反对当前实现的能力.md)、[philosophy/83-故障模型先于模块美学：Claude Code为什么先把“过去别写坏现在”写进结构](philosophy/83-故障模型先于模块美学：Claude Code为什么先把“过去别写坏现在”写进结构.md)、[philosophy/86-真正先进的内核，不是更会分层，而是更会阻止过去写坏现在](philosophy/86-真正先进的内核，不是更会分层，而是更会阻止过去写坏现在.md)、[philosophy/87-真正成熟的源码质量判断，不是文件更小，而是复杂度中心合法、边界可证、下一次重构仍有路](philosophy/87-真正成熟的源码质量判断，不是文件更小，而是复杂度中心合法、边界可证、下一次重构仍有路.md)、[architecture/84-权威面与反僵尸图谱：single-writer surfaces、409 adoption、bridge pointer freshness与release shaping](architecture/84-权威面与反僵尸图谱：single-writer surfaces、409 adoption、bridge pointer freshness与release shaping.md)
- 想看安全、风控与误伤恢复：依次读 [security/README.md](security/README.md)、[risk/README.md](risk/README.md)、[casebooks/README.md](casebooks/README.md)
- 想看失败样本、演练与 rollout：依次读 [casebooks/README.md](casebooks/README.md)、[playbooks/README.md](playbooks/README.md)、[navigation/README.md](navigation/README.md)

更细的跨目录、跨阶段、跨工件阅读链，统一回 [navigation/README.md](navigation/README.md)。

## 索引分层

- 总索引负责一级路由、目录职责和稳定阅读路径。
- 子目录 README 负责编号段说明、专题入口和跨目录跳转。
- `userbook/README.md` 负责面向使用者的稳定入口，不替代蓝皮书主线总索引。
- `navigation/README.md` 负责跨主题、跨阶段、跨工件的深层反查。
- [../docs/README.md](../docs/README.md) 只处理方法附录、证据归档与目录治理记录，不承载正文。
