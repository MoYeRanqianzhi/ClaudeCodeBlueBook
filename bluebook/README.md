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

### 3. 想接入宿主、SDK 或控制协议

- 先读 [05-功能全景与 API 支持](05-%E5%8A%9F%E8%83%BD%E5%85%A8%E6%99%AF%E4%B8%8EAPI%E6%94%AF%E6%8C%81.md)
- 再读 [08-能力全集、公开度与成熟度矩阵](08-%E8%83%BD%E5%8A%9B%E5%85%A8%E9%9B%86%E3%80%81%E5%85%AC%E5%BC%80%E5%BA%A6%E4%B8%8E%E6%88%90%E7%86%9F%E5%BA%A6%E7%9F%A9%E9%98%B5.md)
- 再读 [api/README](api/README.md)
- 先用 [api/30-源码目录级能力地图：commands、tools、services、状态与宿主平面](api/30-%E6%BA%90%E7%A0%81%E7%9B%AE%E5%BD%95%E7%BA%A7%E8%83%BD%E5%8A%9B%E5%9C%B0%E5%9B%BE%EF%BC%9Acommands%E3%80%81tools%E3%80%81services%E3%80%81%E7%8A%B6%E6%80%81%E4%B8%8E%E5%AE%BF%E4%B8%BB%E5%B9%B3%E9%9D%A2.md) 校准能力地形
- 最后顺着 `13 -> 14 -> 15 -> 16 -> 17 -> 20 -> 26` 读宿主闭环

### 4. 想研究 prompt、知识、记忆与上下文经济

- 先读 `06 -> 07`
- 再读 `api/18 -> api/21 -> architecture/18 -> architecture/28 -> architecture/29 -> architecture/31 -> architecture/36`
- 哲学收束看 `philosophy/14 -> philosophy/18 -> philosophy/21`

### 5. 想研究安全、风控与治理

- 产品内安全先读 `architecture/05 -> architecture/11 -> architecture/19 -> architecture/32 -> architecture/37`
- 哲学收束看 `philosophy/03 -> philosophy/19 -> philosophy/22 -> philosophy/27 -> philosophy/31`
- 平台风控与账号治理读 [risk/README](risk/README.md)

### 6. 想研究源码结构与工程先进性

- 先读 `01 -> 03 -> 05`
- 再读 `api/30 -> api/34 -> architecture/20 -> architecture/21 -> architecture/22 -> architecture/24 -> architecture/25 -> architecture/33 -> architecture/38 -> architecture/40 -> architecture/41 -> architecture/44 -> architecture/47`
- 哲学收束看 `philosophy/15 -> philosophy/16 -> philosophy/23 -> philosophy/24 -> philosophy/28 -> philosophy/29 -> philosophy/32 -> philosophy/34`

## 按第一性原理阅读

- 观察：`05` -> `api/08` -> `architecture/12`
- 决策：`03` -> `architecture/02` -> `architecture/22`
- 行动：`architecture/05` -> `architecture/11` -> `architecture/19`
- 记忆：`architecture/09` -> `api/09` -> `architecture/29`
- 协作：`architecture/10` -> `architecture/30` -> `architecture/34` -> `guides/02`
- 宿主：`api/13` -> `architecture/13` -> `philosophy/09`
- 恢复：`architecture/06` -> `architecture/16` -> `architecture/25`
- 预算：`architecture/21` -> `architecture/32` -> `architecture/37` -> `philosophy/22`
- 治理：`04` -> `api/28` -> `guides/04` -> `guides/05` -> `philosophy/27` -> `risk/README`
- 目录拓扑：`05` -> `api/23` -> `api/29` -> `api/30`

## 按问题阅读

### 为什么 prompt 看起来有魔力

- `06 -> 07 -> api/18 -> architecture/18 -> architecture/28 -> architecture/31 -> architecture/36 -> architecture/39 -> architecture/42 -> architecture/46 -> philosophy/14 -> philosophy/18 -> philosophy/21 -> philosophy/30 -> philosophy/33`

### 为什么它不像普通 IDE 插件

- `03 -> 05 -> architecture/13 -> architecture/14 -> philosophy/09 -> philosophy/16`

### 为什么多 Agent 没有写成“多开几个线程”

- `06 -> architecture/10 -> architecture/30 -> guides/02 -> philosophy/07`

### 为什么复杂任务不该继续写成多轮聊天

- `06 -> architecture/30 -> architecture/34 -> architecture/45 -> guides/06 -> guides/08 -> philosophy/25`

### 为什么安全和 token 经济要一起看

- `03 -> architecture/19 -> architecture/21 -> architecture/32 -> architecture/37 -> philosophy/03 -> philosophy/19 -> philosophy/22`

### 为什么宿主接入不能只看 `query(prompt)`

- `05 -> api/30 -> api/02 -> api/13 -> api/15 -> api/16 -> api/20 -> api/31`

### 为什么有代码不等于有公共承诺

- `04 -> 08 -> architecture/27 -> philosophy/05 -> philosophy/20`

### 为什么目录结构本身也在暴露能力拓扑

- `05 -> api/24 -> api/29 -> api/30 -> architecture/24 -> architecture/38`

### 想按深度专题而不是按目录来读

- 先读 [navigation/03-深度专题导航：Prompt、预算、对象、底盘与治理](navigation/03-%E6%B7%B1%E5%BA%A6%E4%B8%93%E9%A2%98%E5%AF%BC%E8%88%AA%EF%BC%9APrompt%E3%80%81%E9%A2%84%E7%AE%97%E3%80%81%E5%AF%B9%E8%B1%A1%E3%80%81%E5%BA%95%E7%9B%98%E4%B8%8E%E6%B2%BB%E7%90%86.md)

### 为什么宿主不该猜，而系统必须显式失败与显式回写

- `architecture/13 -> architecture/17 -> architecture/40 -> philosophy/11 -> philosophy/29`

### 为什么调优上下文前必须先看预算结构

- `guides/07 -> api/32 -> architecture/43 -> philosophy/22 -> philosophy/31`

### 为什么单一真相入口比多处半真相实现更可靠

- `api/34 -> architecture/41 -> architecture/44 -> philosophy/28 -> philosophy/32`

## 专题入口

- [导航专题](navigation/README.md)
- [架构专题](architecture/README.md)
- [API 手册](api/README.md)
- [哲学专题](philosophy/README.md)
- [使用专题](guides/README.md)
- [风险与治理专题](risk/README.md)
- [开发与持久化记忆](../docs/README.md)
