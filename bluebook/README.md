# 蓝皮书索引

## 目标

这套蓝皮书不重复产品介绍，而是回答六个问题：

1. Claude Code 的源码究竟由哪些运行时平面组成。
2. 功能、工具、命令、SDK、宿主协议分别暴露在哪一层。
3. 为什么它的 prompt、权限、安全、token 经济必须一起理解。
4. 为什么它更像 agent runtime，而不是聊天壳或 IDE 插件。
5. 哪些能力属于公共主路径，哪些只是 gate、子集或内部痕迹。
6. 用户、宿主开发者、Agent 平台设计者各该如何读这套源码。

## 目录职责

- `bluebook/` 根目录：主线结论，强调一跳能懂。
- `bluebook/architecture/`：运行时结构拆解，强调链路、状态机、时序和分层。
- `bluebook/api/`：接口、字段、协议和能力支持面，强调宿主可接入性。
- `bluebook/navigation/`：阅读地图与检索入口，不承载新的正文平面。
- `bluebook/philosophy/`：设计内涵、第一性原理与演化方法。
- `bluebook/guides/`：从源码反推的实战使用方法。
- `bluebook/risk/`：账号治理、风控、远程控制与误伤处置。
- `docs/`：持久化记忆与开发文档，不承载蓝皮书正文。

## 规范入口

- 规范主线入口是 `README.md + 00-08`
- `00-总览.md`、`00-蓝皮书总览.md`、`01-源码总地图.md` 作为兼容别名页保留，不再承担规范主线职责
- 目录治理说明见 [navigation/04-目录职责、规范入口与兼容别名页说明](navigation/04-%E7%9B%AE%E5%BD%95%E8%81%8C%E8%B4%A3%E3%80%81%E8%A7%84%E8%8C%83%E5%85%A5%E5%8F%A3%E4%B8%8E%E5%85%BC%E5%AE%B9%E5%88%AB%E5%90%8D%E9%A1%B5%E8%AF%B4%E6%98%8E.md)

## 主线阅读

1. [00-导读](00-%E5%AF%BC%E8%AF%BB.md)
2. [01-源码结构地图](01-%E6%BA%90%E7%A0%81%E7%BB%93%E6%9E%84%E5%9C%B0%E5%9B%BE.md)
3. [02-使用指南](02-%E4%BD%BF%E7%94%A8%E6%8C%87%E5%8D%97.md)
4. [03-设计哲学](03-%E8%AE%BE%E8%AE%A1%E5%93%B2%E5%AD%A6.md)
5. [04-公开能力与隐藏能力](04-%E5%85%AC%E5%BC%80%E8%83%BD%E5%8A%9B%E4%B8%8E%E9%9A%90%E8%97%8F%E8%83%BD%E5%8A%9B.md)
6. [05-功能全景与 API 支持](05-%E5%8A%9F%E8%83%BD%E5%85%A8%E6%99%AF%E4%B8%8EAPI%E6%94%AF%E6%8C%81.md)
7. [06-第一性原理与苏格拉底反思](06-%E7%AC%AC%E4%B8%80%E6%80%A7%E5%8E%9F%E7%90%86%E4%B8%8E%E8%8B%8F%E6%A0%BC%E6%8B%89%E5%BA%95%E5%8F%8D%E6%80%9D.md)
8. [07-运行时契约、知识层与生态边界](07-%E8%BF%90%E8%A1%8C%E6%97%B6%E5%A5%91%E7%BA%A6%E3%80%81%E7%9F%A5%E8%AF%86%E5%B1%82%E4%B8%8E%E7%94%9F%E6%80%81%E8%BE%B9%E7%95%8C.md)
9. [08-能力全集、公开度与成熟度矩阵](08-%E8%83%BD%E5%8A%9B%E5%85%A8%E9%9B%86%E3%80%81%E5%85%AC%E5%BC%80%E5%BA%A6%E4%B8%8E%E6%88%90%E7%86%9F%E5%BA%A6%E7%9F%A9%E9%98%B5.md)

## 按角色阅读

### 1. 想先建立整体判断

- 先读 `00 -> 01 -> 03 -> 06 -> 07 -> 08`
- 目标：先看清 Claude Code 的设计单位是 runtime plane，而不是功能清单

### 2. 想高效使用 Claude Code

- 先读 [02-使用指南](02-%E4%BD%BF%E7%94%A8%E6%8C%87%E5%8D%97.md)
- 再读 [guides/01-使用指南](guides/01-%E4%BD%BF%E7%94%A8%E6%8C%87%E5%8D%97.md)
- 多 Agent 与 prompt 编排继续读 [guides/02-多Agent编排与Prompt模板](guides/02-%E5%A4%9AAgent%E7%BC%96%E6%8E%92%E4%B8%8EPrompt%E6%A8%A1%E6%9D%BF.md)
- 知识层与 `CLAUDE.md` 实践继续读 [guides/03-CLAUDE.md、记忆层与上下文注入实践](guides/03-CLAUDE.md%E3%80%81%E8%AE%B0%E5%BF%86%E5%B1%82%E4%B8%8E%E4%B8%8A%E4%B8%8B%E6%96%87%E6%B3%A8%E5%85%A5%E5%AE%9E%E8%B7%B5.md)
- 想把复杂任务压缩成稳定方法，再读 [guides/06-第一性原理实践：目标、预算、对象、边界与回写](guides/06-%E7%AC%AC%E4%B8%80%E6%80%A7%E5%8E%9F%E7%90%86%E5%AE%9E%E8%B7%B5%EF%BC%9A%E7%9B%AE%E6%A0%87%E3%80%81%E9%A2%84%E7%AE%97%E3%80%81%E5%AF%B9%E8%B1%A1%E3%80%81%E8%BE%B9%E7%95%8C%E4%B8%8E%E5%9B%9E%E5%86%99.md)
- 想先观测预算再调 prompt / tools / memory，再读 [guides/07-用Context Usage与状态回写调优Prompt和预算](guides/07-%E7%94%A8Context%20Usage%E4%B8%8E%E7%8A%B6%E6%80%81%E5%9B%9E%E5%86%99%E8%B0%83%E4%BC%98Prompt%E5%92%8C%E9%A2%84%E7%AE%97.md)
- 想知道什么时候该继续当前 session、什么时候该升级成 task / worktree / compact，再读 [guides/08-如何根据预算、阻塞与风险选择session、task、worktree与compact](guides/08-%E5%A6%82%E4%BD%95%E6%A0%B9%E6%8D%AE%E9%A2%84%E7%AE%97%E3%80%81%E9%98%BB%E5%A1%9E%E4%B8%8E%E9%A3%8E%E9%99%A9%E9%80%89%E6%8B%A9session%E3%80%81task%E3%80%81worktree%E4%B8%8Ecompact.md)
- 想降低长任务里的人类-模型协调成本，再读 [guides/09-如何降低人类-模型协调成本：Sticky Prompt、Suggestion、Session Memory与接手连续性](guides/09-%E5%A6%82%E4%BD%95%E9%99%8D%E4%BD%8E%E4%BA%BA%E7%B1%BB-%E6%A8%A1%E5%9E%8B%E5%8D%8F%E8%B0%83%E6%88%90%E6%9C%AC%EF%BC%9ASticky%20Prompt%E3%80%81Suggestion%E3%80%81Session%20Memory%E4%B8%8E%E6%8E%A5%E6%89%8B%E8%BF%9E%E7%BB%AD%E6%80%A7.md)
- 想在约束里保持高行动力，而不是靠放大权限硬冲，再读 [guides/10-如何在约束中保持高行动力：permission mode、反馈式审批与渐进能力暴露](guides/10-%E5%A6%82%E4%BD%95%E5%9C%A8%E7%BA%A6%E6%9D%9F%E4%B8%AD%E4%BF%9D%E6%8C%81%E9%AB%98%E8%A1%8C%E5%8A%A8%E5%8A%9B%EF%BC%9Apermission%20mode%E3%80%81%E5%8F%8D%E9%A6%88%E5%BC%8F%E5%AE%A1%E6%89%B9%E4%B8%8E%E6%B8%90%E8%BF%9B%E8%83%BD%E5%8A%9B%E6%9A%B4%E9%9C%B2.md)
- 想把 Claude Code 的源码方法迁移到自己的 Agent 平台，再读 [guides/11-给Agent平台构建者：如何把源码写成治理界面并保留重构余量](guides/11-%E7%BB%99Agent%E5%B9%B3%E5%8F%B0%E6%9E%84%E5%BB%BA%E8%80%85%EF%BC%9A%E5%A6%82%E4%BD%95%E6%8A%8A%E6%BA%90%E7%A0%81%E5%86%99%E6%88%90%E6%B2%BB%E7%90%86%E7%95%8C%E9%9D%A2%E5%B9%B6%E4%BF%9D%E7%95%99%E9%87%8D%E6%9E%84%E4%BD%99%E9%87%8F.md)
- 想把 prompt 当成人机协作接口，而不是继续堆长文案，再读 [guides/12-如何把Prompt当成人机协作接口：固定主语、反馈纠偏与低成本接手](guides/12-%E5%A6%82%E4%BD%95%E6%8A%8APrompt%E5%BD%93%E6%88%90%E4%BA%BA%E6%9C%BA%E5%8D%8F%E4%BD%9C%E6%8E%A5%E5%8F%A3%EF%BC%9A%E5%9B%BA%E5%AE%9A%E4%B8%BB%E8%AF%AD%E3%80%81%E5%8F%8D%E9%A6%88%E7%BA%A0%E5%81%8F%E4%B8%8E%E4%BD%8E%E6%88%90%E6%9C%AC%E6%8E%A5%E6%89%8B.md)
- 想在秩序里释放有效自由，而不是把提权当成唯一解，再读 [guides/13-如何在秩序中释放有效自由：mode选择、审批协商与能力按需出现](guides/13-%E5%A6%82%E4%BD%95%E5%9C%A8%E7%A7%A9%E5%BA%8F%E4%B8%AD%E9%87%8A%E6%94%BE%E6%9C%89%E6%95%88%E8%87%AA%E7%94%B1%EF%BC%9Amode%E9%80%89%E6%8B%A9%E3%80%81%E5%AE%A1%E6%89%B9%E5%8D%8F%E5%95%86%E4%B8%8E%E8%83%BD%E5%8A%9B%E6%8C%89%E9%9C%80%E5%87%BA%E7%8E%B0.md)
- 想给未来维护者设计可治理的 runtime，而不是只把功能堆出来，再读 [guides/14-如何为未来维护者设计Agent Runtime：注释、命名、leaf module与重构余量](guides/14-%E5%A6%82%E4%BD%95%E4%B8%BA%E6%9C%AA%E6%9D%A5%E7%BB%B4%E6%8A%A4%E8%80%85%E8%AE%BE%E8%AE%A1Agent%20Runtime%EF%BC%9A%E6%B3%A8%E9%87%8A%E3%80%81%E5%91%BD%E5%90%8D%E3%80%81leaf%20module%E4%B8%8E%E9%87%8D%E6%9E%84%E4%BD%99%E9%87%8F.md)
- 想把 UI 真相翻译成 protocol 真相，而不是继续把显示层误当执行层，再读 [guides/15-如何把UI真相翻译成Protocol真相：transcript重写、边界补写与恢复不变量](guides/15-%E5%A6%82%E4%BD%95%E6%8A%8AUI%E7%9C%9F%E7%9B%B8%E7%BF%BB%E8%AF%91%E6%88%90Protocol%E7%9C%9F%E7%9B%B8%EF%BC%9Atranscript%E9%87%8D%E5%86%99%E3%80%81%E8%BE%B9%E7%95%8C%E8%A1%A5%E5%86%99%E4%B8%8E%E6%81%A2%E5%A4%8D%E4%B8%8D%E5%8F%98%E9%87%8F.md)
- 想把安全、可见性和 continuation 写成统一资源定价秩序，再读 [guides/16-如何用资源定价设计Agent Runtime：mode、visibility、externalization与continuation](guides/16-%E5%A6%82%E4%BD%95%E7%94%A8%E8%B5%84%E6%BA%90%E5%AE%9A%E4%BB%B7%E8%AE%BE%E8%AE%A1Agent%20Runtime%EF%BC%9Amode%E3%80%81visibility%E3%80%81externalization%E4%B8%8Econtinuation.md)
- 想把未来维护者当成正式消费者，而不是把工程制度留在口头传承里，再读 [guides/17-如何把未来维护者当正式消费者：风险命名、制度注释、seam与状态机](guides/17-%E5%A6%82%E4%BD%95%E6%8A%8A%E6%9C%AA%E6%9D%A5%E7%BB%B4%E6%8A%A4%E8%80%85%E5%BD%93%E6%AD%A3%E5%BC%8F%E6%B6%88%E8%B4%B9%E8%80%85%EF%BC%9A%E9%A3%8E%E9%99%A9%E5%91%BD%E5%90%8D%E3%80%81%E5%88%B6%E5%BA%A6%E6%B3%A8%E9%87%8A%E3%80%81seam%E4%B8%8E%E7%8A%B6%E6%80%81%E6%9C%BA.md)
- 想把 prompt 理解成主线程生产、旁路循环复用的共享前缀网络，再读 [guides/18-如何把Prompt当成共享前缀资产网络：侧问题、suggestion、memory与summary共用主线程前缀](guides/18-%E5%A6%82%E4%BD%95%E6%8A%8APrompt%E5%BD%93%E6%88%90%E5%85%B1%E4%BA%AB%E5%89%8D%E7%BC%80%E8%B5%84%E4%BA%A7%E7%BD%91%E7%BB%9C%EF%BC%9A%E4%BE%A7%E9%97%AE%E9%A2%98%E3%80%81suggestion%E3%80%81memory%E4%B8%8Esummary%E5%85%B1%E7%94%A8%E4%B8%BB%E7%BA%BF%E7%A8%8B%E5%89%8D%E7%BC%80.md)
- 想研究 Claude Code 源码时先锁定合同真相，再回到热点实现，再读 [guides/19-如何用Contract-First方法阅读和设计Agent Runtime：先找合同，再看热点文件](guides/19-%E5%A6%82%E4%BD%95%E7%94%A8Contract-First%E6%96%B9%E6%B3%95%E9%98%85%E8%AF%BB%E5%92%8C%E8%AE%BE%E8%AE%A1Agent%20Runtime%EF%BC%9A%E5%85%88%E6%89%BE%E5%90%88%E5%90%8C%EF%BC%8C%E5%86%8D%E7%9C%8B%E7%83%AD%E7%82%B9%E6%96%87%E4%BB%B6.md)
- 想把依赖图诚实性写成长期维护制度，而不是抽象洁癖，再读 [guides/20-如何工程化地维持依赖图诚实性：leaf module、anti-cycle seam与single-source file](guides/20-%E5%A6%82%E4%BD%95%E5%B7%A5%E7%A8%8B%E5%8C%96%E5%9C%B0%E7%BB%B4%E6%8C%81%E4%BE%9D%E8%B5%96%E5%9B%BE%E8%AF%9A%E5%AE%9E%E6%80%A7%EF%BC%9Aleaf%20module%E3%80%81anti-cycle%20seam%E4%B8%8Esingle-source%20file.md)
- 想把这三条深方法进一步落成团队模板和 review checklist，再读 [navigation/07-深方法导航：共享前缀、合同优先与依赖图诚实性](navigation/07-%E6%B7%B1%E6%96%B9%E6%B3%95%E5%AF%BC%E8%88%AA%EF%BC%9A%E5%85%B1%E4%BA%AB%E5%89%8D%E7%BC%80%E3%80%81%E5%90%88%E5%90%8C%E4%BC%98%E5%85%88%E4%B8%8E%E4%BE%9D%E8%B5%96%E5%9B%BE%E8%AF%9A%E5%AE%9E%E6%80%A7.md)
- 想继续看 prompt、安全、源码先进性的第二序制度层，再读 [navigation/08-高阶制度导航：Prompt Constitution、治理顺序与构建系统](navigation/08-%E9%AB%98%E9%98%B6%E5%88%B6%E5%BA%A6%E5%AF%BC%E8%88%AA%EF%BC%9APrompt%20Constitution%E3%80%81%E6%B2%BB%E7%90%86%E9%A1%BA%E5%BA%8F%E4%B8%8E%E6%9E%84%E5%BB%BA%E7%B3%BB%E7%BB%9F.md)

### 3. 想接入宿主、SDK 或控制协议

- 先读 [05-功能全景与 API 支持](05-%E5%8A%9F%E8%83%BD%E5%85%A8%E6%99%AF%E4%B8%8EAPI%E6%94%AF%E6%8C%81.md)
- 再读 [08-能力全集、公开度与成熟度矩阵](08-%E8%83%BD%E5%8A%9B%E5%85%A8%E9%9B%86%E3%80%81%E5%85%AC%E5%BC%80%E5%BA%A6%E4%B8%8E%E6%88%90%E7%86%9F%E5%BA%A6%E7%9F%A9%E9%98%B5.md)
- 再读 [api/README](api/README.md)
- 先用 [api/30-源码目录级能力地图：commands、tools、services、状态与宿主平面](api/30-%E6%BA%90%E7%A0%81%E7%9B%AE%E5%BD%95%E7%BA%A7%E8%83%BD%E5%8A%9B%E5%9C%B0%E5%9B%BE%EF%BC%9Acommands%E3%80%81tools%E3%80%81services%E3%80%81%E7%8A%B6%E6%80%81%E4%B8%8E%E5%AE%BF%E4%B8%BB%E5%B9%B3%E9%9D%A2.md) 校准能力地形
- 最后顺着 `13 -> 14 -> 15 -> 17 -> 59 -> 16 -> 60 -> 20 -> 26` 读宿主闭环

### 4. 想研究 prompt、知识、记忆与上下文经济

- 先读 `06 -> 07`
- 先用 [guides/18-如何把Prompt当成共享前缀资产网络：侧问题、suggestion、memory与summary共用主线程前缀](guides/18-%E5%A6%82%E4%BD%95%E6%8A%8APrompt%E5%BD%93%E6%88%90%E5%85%B1%E4%BA%AB%E5%89%8D%E7%BC%80%E8%B5%84%E4%BA%A7%E7%BD%91%E7%BB%9C%EF%BC%9A%E4%BE%A7%E9%97%AE%E9%A2%98%E3%80%81suggestion%E3%80%81memory%E4%B8%8Esummary%E5%85%B1%E7%94%A8%E4%B8%BB%E7%BA%BF%E7%A8%8B%E5%89%8D%E7%BC%80.md) 把共享前缀网络先实践化
- 再读 `api/18 -> api/21 -> architecture/18 -> architecture/28 -> architecture/29 -> architecture/31 -> architecture/36`
- 哲学收束看 `philosophy/14 -> philosophy/18 -> philosophy/21 -> philosophy/54 -> philosophy/57`

### 5. 想研究安全、风控与治理

- 产品内安全先读 `architecture/05 -> architecture/11 -> architecture/19 -> architecture/32 -> architecture/37 -> architecture/50 -> architecture/51`
- 哲学收束看 `philosophy/03 -> philosophy/19 -> philosophy/22 -> philosophy/27 -> philosophy/31 -> philosophy/37 -> philosophy/38 -> philosophy/55 -> philosophy/58`
- 平台风控与账号治理读 [risk/README](risk/README.md)

### 6. 想研究源码结构与工程先进性

- 先读 `01 -> 03 -> 05`
- 先用 [guides/19-如何用Contract-First方法阅读和设计Agent Runtime：先找合同，再看热点文件](guides/19-%E5%A6%82%E4%BD%95%E7%94%A8Contract-First%E6%96%B9%E6%B3%95%E9%98%85%E8%AF%BB%E5%92%8C%E8%AE%BE%E8%AE%A1Agent%20Runtime%EF%BC%9A%E5%85%88%E6%89%BE%E5%90%88%E5%90%8C%EF%BC%8C%E5%86%8D%E7%9C%8B%E7%83%AD%E7%82%B9%E6%96%87%E4%BB%B6.md) 校准阅读顺序
- 再用 [guides/20-如何工程化地维持依赖图诚实性：leaf module、anti-cycle seam与single-source file](guides/20-%E5%A6%82%E4%BD%95%E5%B7%A5%E7%A8%8B%E5%8C%96%E5%9C%B0%E7%BB%B4%E6%8C%81%E4%BE%9D%E8%B5%96%E5%9B%BE%E8%AF%9A%E5%AE%9E%E6%80%A7%EF%BC%9Aleaf%20module%E3%80%81anti-cycle%20seam%E4%B8%8Esingle-source%20file.md) 理解维护制度
- 再读 `api/30 -> api/34 -> architecture/20 -> architecture/21 -> architecture/22 -> architecture/24 -> architecture/25 -> architecture/33 -> architecture/38 -> architecture/40 -> architecture/41 -> architecture/44 -> architecture/47 -> architecture/52`
- 哲学收束看 `philosophy/15 -> philosophy/16 -> philosophy/23 -> philosophy/24 -> philosophy/28 -> philosophy/29 -> philosophy/32 -> philosophy/34 -> philosophy/39 -> philosophy/56 -> philosophy/59`

## 按第一性原理阅读

- 观察：`05` -> `api/08` -> `architecture/12`
- 决策：`03` -> `architecture/02` -> `architecture/22`
- 行动：`architecture/05` -> `architecture/11` -> `architecture/19`
- 记忆：`architecture/09` -> `api/09` -> `architecture/29`
- 协作：`architecture/10` -> `architecture/30` -> `architecture/34` -> `guides/02`
- 宿主：`api/13` -> `architecture/13` -> `architecture/59` -> `philosophy/46`
- 恢复：`architecture/06` -> `architecture/16` -> `architecture/25` -> `architecture/60` -> `philosophy/47`
- 预算：`architecture/21` -> `architecture/32` -> `architecture/37` -> `architecture/50` -> `philosophy/22` -> `philosophy/37` -> `philosophy/38`
- 治理：`04` -> `api/28` -> `guides/04` -> `guides/05` -> `architecture/50` -> `architecture/51` -> `philosophy/27` -> `philosophy/38` -> `risk/README`
- 目录拓扑：`05` -> `api/23` -> `api/29` -> `api/30`

## 按问题阅读

### 为什么 prompt 看起来有魔力

- `06 -> 07 -> guides/18 -> api/18 -> architecture/18 -> architecture/28 -> architecture/31 -> architecture/36 -> architecture/39 -> architecture/42 -> architecture/46 -> architecture/53 -> philosophy/14 -> philosophy/18 -> philosophy/21 -> philosophy/30 -> philosophy/33 -> philosophy/38 -> philosophy/39 -> philosophy/40 -> philosophy/57`

### 为什么 prompt 的魔力能在侧问题、suggestion、memory、summary、dream 之间继承

- `guides/18 -> architecture/42 -> architecture/53 -> philosophy/30 -> philosophy/39 -> philosophy/57`

### 为什么它不像普通 IDE 插件

- `03 -> 05 -> architecture/13 -> architecture/14 -> philosophy/09 -> philosophy/16`

### 为什么多 Agent 没有写成“多开几个线程”

- `06 -> architecture/10 -> architecture/30 -> guides/02 -> philosophy/07`

### 为什么复杂任务不该继续写成多轮聊天

- `06 -> architecture/30 -> architecture/34 -> architecture/45 -> guides/06 -> guides/08 -> philosophy/25`

### 为什么安全和 token 经济要一起看

- `03 -> architecture/19 -> architecture/21 -> architecture/32 -> architecture/37 -> architecture/50 -> architecture/51 -> philosophy/03 -> philosophy/19 -> philosophy/22 -> philosophy/37 -> philosophy/38 -> philosophy/58`

### 为什么安全不是事后检查而是输入边界控制平面

- `03 -> architecture/19 -> architecture/23 -> architecture/50 -> architecture/51 -> philosophy/27 -> philosophy/38`

### 为什么 prompt 稳定性不是性能技巧而是运行时治理

- `06 -> architecture/31 -> architecture/39 -> architecture/46 -> architecture/50 -> philosophy/30 -> philosophy/33 -> philosophy/38 -> philosophy/39`

### 为什么 Claude Code 的 prompt 更像上下文准入编译器

- `07 -> architecture/28 -> architecture/39 -> architecture/46 -> architecture/53 -> philosophy/18 -> philosophy/30 -> philosophy/39 -> philosophy/40`

### 为什么 Claude Code 宁可接受轻微陈旧，也要换取系统级确定性

- `architecture/39 -> architecture/53 -> philosophy/33 -> philosophy/39 -> philosophy/40`

### 为什么模型看到的 transcript 不等于界面上看到的 transcript

- `architecture/53 -> architecture/54 -> philosophy/26 -> philosophy/30 -> philosophy/41`

### 为什么 UI 历史必须在 API 边界前被重新编译

- `architecture/54 -> architecture/70 -> philosophy/57`

### 为什么 Claude Code 偏爱渐进暴露，而不是全量声明

- `architecture/51 -> architecture/53 -> philosophy/38 -> philosophy/41`

### 为什么最小可见面比全量能力表更强

- `architecture/56 -> philosophy/41 -> philosophy/43`

### 为什么宿主接入不能只看 `query(prompt)`

- `05 -> api/30 -> api/02 -> api/13 -> api/15 -> api/16 -> api/20 -> api/31`

### 为什么有代码不等于有公共承诺

- `04 -> 08 -> architecture/27 -> philosophy/05 -> philosophy/20`

### 为什么目录结构本身也在暴露能力拓扑

- `05 -> api/24 -> api/29 -> api/30 -> architecture/24 -> architecture/38`

### 为什么高级工程不在功能数量，而在不变量治理

- `01 -> api/30 -> architecture/20 -> architecture/40 -> architecture/41 -> architecture/47 -> architecture/52 -> philosophy/23 -> philosophy/29 -> philosophy/39 -> philosophy/59`

### 为什么 `query.ts`、`REPL.tsx` 很大，却不等于架构失控

- `architecture/52 -> architecture/55 -> philosophy/42`

### 为什么 observability 不是调试附属层，而是正式运行时合同

- `architecture/17 -> architecture/43 -> architecture/57 -> philosophy/31 -> philosophy/33 -> philosophy/44`

### 为什么依赖图诚实性比抽象洁癖更重要

- `guides/20 -> architecture/41 -> architecture/58 -> philosophy/28 -> philosophy/45`

### 为什么研究 Claude Code 源码时必须先找合同，再看热点文件

- `guides/19 -> api/34 -> architecture/38 -> philosophy/24 -> philosophy/59`

### 为什么依赖图诚实性是一种工程正确性，而不是代码洁癖

- `guides/20 -> architecture/58 -> philosophy/45 -> philosophy/56 -> philosophy/59`

### 想按深度专题而不是按目录来读

- 先读 [navigation/03-深度专题导航：Prompt、预算、对象、底盘与治理](navigation/03-%E6%B7%B1%E5%BA%A6%E4%B8%93%E9%A2%98%E5%AF%BC%E8%88%AA%EF%BC%9APrompt%E3%80%81%E9%A2%84%E7%AE%97%E3%80%81%E5%AF%B9%E8%B1%A1%E3%80%81%E5%BA%95%E7%9B%98%E4%B8%8E%E6%B2%BB%E7%90%86.md)
- 想直接看高阶设计母线，再读 [navigation/05-设计母线导航：工作语法、反扩张与可演化内核](navigation/05-%E8%AE%BE%E8%AE%A1%E6%AF%8D%E7%BA%BF%E5%AF%BC%E8%88%AA%EF%BC%9A%E5%B7%A5%E4%BD%9C%E8%AF%AD%E6%B3%95%E3%80%81%E5%8F%8D%E6%89%A9%E5%BC%A0%E4%B8%8E%E5%8F%AF%E6%BC%94%E5%8C%96%E5%86%85%E6%A0%B8.md)
- 想直接看最新终局判断，再读 [navigation/06-终局判断导航：协作语法、资源定价与未来维护者消费者](navigation/06-%E7%BB%88%E5%B1%80%E5%88%A4%E6%96%AD%E5%AF%BC%E8%88%AA%EF%BC%9A%E5%8D%8F%E4%BD%9C%E8%AF%AD%E6%B3%95%E3%80%81%E8%B5%84%E6%BA%90%E5%AE%9A%E4%BB%B7%E4%B8%8E%E6%9C%AA%E6%9D%A5%E7%BB%B4%E6%8A%A4%E8%80%85%E6%B6%88%E8%B4%B9%E8%80%85.md)
- 想直接看“共享前缀 / 合同优先 / 依赖图诚实性”怎样变成模板层，再读 [navigation/07-深方法导航：共享前缀、合同优先与依赖图诚实性](navigation/07-%E6%B7%B1%E6%96%B9%E6%B3%95%E5%AF%BC%E8%88%AA%EF%BC%9A%E5%85%B1%E4%BA%AB%E5%89%8D%E7%BC%80%E3%80%81%E5%90%88%E5%90%8C%E4%BC%98%E5%85%88%E4%B8%8E%E4%BE%9D%E8%B5%96%E5%9B%BE%E8%AF%9A%E5%AE%9E%E6%80%A7.md)
- 想继续看 prompt、安全、源码先进性的第二序制度层，再读 [navigation/08-高阶制度导航：Prompt Constitution、治理顺序与构建系统](navigation/08-%E9%AB%98%E9%98%B6%E5%88%B6%E5%BA%A6%E5%AF%BC%E8%88%AA%EF%BC%9APrompt%20Constitution%E3%80%81%E6%B2%BB%E7%90%86%E9%A1%BA%E5%BA%8F%E4%B8%8E%E6%9E%84%E5%BB%BA%E7%B3%BB%E7%BB%9F.md)
- 需要先判断规范入口和兼容别名页时，读 [navigation/04-目录职责、规范入口与兼容别名页说明](navigation/04-%E7%9B%AE%E5%BD%95%E8%81%8C%E8%B4%A3%E3%80%81%E8%A7%84%E8%8C%83%E5%85%A5%E5%8F%A3%E4%B8%8E%E5%85%BC%E5%AE%B9%E5%88%AB%E5%90%8D%E9%A1%B5%E8%AF%B4%E6%98%8E.md)

### 为什么宿主不该猜，而系统必须显式失败与显式回写

- `architecture/13 -> architecture/17 -> architecture/40 -> architecture/59 -> architecture/60 -> philosophy/11 -> philosophy/29 -> philosophy/47`

### 为什么单一权威不等于单一全景

- `philosophy/10 -> architecture/14 -> architecture/59 -> philosophy/32 -> philosophy/46`

### 为什么状态回写不是遥测附属层

- `architecture/17 -> architecture/25 -> architecture/57 -> architecture/60 -> philosophy/44 -> philosophy/47`

### 为什么 Claude Code 的 prompt 魔力更像工作语法机

- `architecture/39 -> architecture/53 -> architecture/54 -> architecture/61 -> philosophy/39 -> philosophy/48`

### 为什么 prompt 的魔力不在措辞，而在协作语法

- `navigation/06 -> architecture/54 -> architecture/61 -> architecture/67 -> philosophy/54 -> philosophy/57`

### 为什么真正强的Prompt不是信息更多，而是行动语义更密

- `architecture/61 -> architecture/64 -> philosophy/48 -> philosophy/51`

### 为什么安全设计和省Token设计其实是同一个系统

- `architecture/37 -> architecture/51 -> architecture/56 -> architecture/62 -> philosophy/38 -> philosophy/49`

### 为什么模型不是资源的主人，Runtime才是

- `architecture/62 -> architecture/65 -> philosophy/49 -> philosophy/52`

### 为什么真正的安全不是拦截动作，而是资源定价

- `navigation/06 -> architecture/50 -> architecture/56 -> architecture/65 -> philosophy/55 -> philosophy/58`

### 为什么 prompt 的更深魔力不在文案，而在一部可治理的 Prompt Constitution

- `navigation/08 -> architecture/36 -> architecture/39 -> architecture/46 -> philosophy/33 -> philosophy/60`

### 为什么安全和省Token更深层上是治理顺序、失败语义与可撤销自动化

- `navigation/08 -> architecture/23 -> architecture/40 -> architecture/50 -> architecture/62 -> philosophy/47 -> philosophy/61`

### 为什么构建系统本身也是 Claude Code 源码先进性的一部分

- `navigation/08 -> architecture/33 -> architecture/63 -> architecture/66 -> philosophy/50 -> philosophy/62`

### 为什么高行动力来自统一定价而不是统一放权

- `architecture/50 -> architecture/56 -> architecture/68 -> architecture/71 -> philosophy/58`

### 为什么 Claude Code 值得学的是“可演化内核”

- `architecture/41 -> architecture/52 -> architecture/58 -> architecture/63 -> philosophy/45 -> philosophy/50`

### 为什么好架构不是更会重构，而是始终保留重构可能性

- `architecture/63 -> architecture/66 -> philosophy/50 -> philosophy/53`

### 为什么好的Prompt同时组织模型与人类接手路径

- `guides/09 -> guides/12 -> architecture/64 -> architecture/67 -> philosophy/51 -> philosophy/54 -> philosophy/57`

### 为什么真正的自由不是少约束，而是约束不再破坏行动

- `guides/10 -> guides/13 -> architecture/62 -> architecture/68 -> philosophy/52 -> philosophy/55 -> philosophy/58`

### 为什么可读性不是修辞，而是系统治理能力

- `guides/11 -> guides/14 -> architecture/66 -> architecture/69 -> philosophy/53 -> philosophy/56 -> philosophy/59`

### 为什么未来维护者也是正式消费者

- `navigation/06 -> architecture/41 -> architecture/66 -> architecture/69 -> philosophy/56 -> philosophy/59`

### 为什么调优上下文前必须先看预算结构

- `guides/07 -> api/32 -> architecture/43 -> philosophy/22 -> philosophy/31`

### 为什么远程失败不该写成“断线重连”

- `api/33 -> architecture/16 -> architecture/48 -> philosophy/11 -> philosophy/35`

### 为什么单一真相入口比多处半真相实现更可靠

- `api/34 -> architecture/41 -> architecture/44 -> philosophy/28 -> philosophy/32`

### 为什么插件系统不能只看一个 enabled 开关

- `api/27 -> api/34 -> architecture/49 -> philosophy/20 -> philosophy/36`

## 专题入口

- [导航专题](navigation/README.md)
- [架构专题](architecture/README.md)
- [API 手册](api/README.md)
- [哲学专题](philosophy/README.md)
- [使用专题](guides/README.md)
- [风险与治理专题](risk/README.md)
- [开发与持久化记忆](../docs/README.md)
