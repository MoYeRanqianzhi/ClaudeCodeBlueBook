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

## 按角色阅读

### 1. 想先建立整体判断

- 先读 `00 -> 01 -> 03 -> 06 -> 07`
- 目标：先看清 Claude Code 的设计单位是 runtime plane，而不是功能清单

### 2. 想高效使用 Claude Code

- 先读 [02-使用指南](02-%E4%BD%BF%E7%94%A8%E6%8C%87%E5%8D%97.md)
- 再读 [guides/01-使用指南](guides/01-%E4%BD%BF%E7%94%A8%E6%8C%87%E5%8D%97.md)
- 多 Agent 与 prompt 编排继续读 [guides/02-多Agent编排与Prompt模板](guides/02-%E5%A4%9AAgent%E7%BC%96%E6%8E%92%E4%B8%8EPrompt%E6%A8%A1%E6%9D%BF.md)
- 知识层与 `CLAUDE.md` 实践继续读 [guides/03-CLAUDE.md、记忆层与上下文注入实践](guides/03-CLAUDE.md%E3%80%81%E8%AE%B0%E5%BF%86%E5%B1%82%E4%B8%8E%E4%B8%8A%E4%B8%8B%E6%96%87%E6%B3%A8%E5%85%A5%E5%AE%9E%E8%B7%B5.md)

### 3. 想接入宿主、SDK 或控制协议

- 先读 [05-功能全景与 API 支持](05-%E5%8A%9F%E8%83%BD%E5%85%A8%E6%99%AF%E4%B8%8EAPI%E6%94%AF%E6%8C%81.md)
- 再读 [api/README](api/README.md)
- 最后顺着 `13 -> 14 -> 15 -> 16 -> 17 -> 20` 读宿主闭环

### 4. 想研究 prompt、知识、记忆与上下文经济

- 先读 `06 -> 07`
- 再读 `api/18 -> api/21 -> architecture/18 -> architecture/28 -> architecture/29`
- 哲学收束看 `philosophy/14 -> philosophy/18 -> philosophy/19`

### 5. 想研究安全、风控与治理

- 产品内安全先读 `architecture/05 -> architecture/11 -> architecture/19`
- 哲学收束看 `philosophy/03 -> philosophy/19`
- 平台风控与账号治理读 [risk/README](risk/README.md)

### 6. 想研究源码结构与工程先进性

- 先读 `01 -> 03 -> 05`
- 再读 `architecture/20 -> architecture/21 -> architecture/22 -> architecture/24 -> architecture/25`
- 哲学收束看 `philosophy/15 -> philosophy/16 -> philosophy/17`

## 按第一性原理阅读

- 观察：`05` -> `api/08` -> `architecture/12`
- 决策：`03` -> `architecture/02` -> `architecture/22`
- 行动：`architecture/05` -> `architecture/11` -> `architecture/19`
- 记忆：`architecture/09` -> `api/09` -> `architecture/29`
- 协作：`architecture/10` -> `architecture/30` -> `guides/02`
- 宿主：`api/13` -> `architecture/13` -> `philosophy/09`
- 恢复：`architecture/06` -> `architecture/16` -> `architecture/25`
- 治理：`04` -> `philosophy/20` -> `risk/README`

## 按问题阅读

### 为什么 prompt 看起来有魔力

- `06 -> 07 -> api/18 -> architecture/18 -> architecture/28 -> philosophy/14 -> philosophy/18`

### 为什么它不像普通 IDE 插件

- `03 -> 05 -> architecture/13 -> architecture/14 -> philosophy/09 -> philosophy/16`

### 为什么多 Agent 没有写成“多开几个线程”

- `06 -> architecture/10 -> architecture/30 -> guides/02 -> philosophy/07`

### 为什么安全和 token 经济要一起看

- `03 -> architecture/19 -> architecture/21 -> philosophy/03 -> philosophy/19`

### 为什么宿主接入不能只看 `query(prompt)`

- `05 -> api/02 -> api/13 -> api/15 -> api/16 -> api/20`

### 为什么有代码不等于有公共承诺

- `04 -> architecture/27 -> philosophy/05 -> philosophy/20`

## 专题入口

- [架构专题](architecture/README.md)
- [API 手册](api/README.md)
- [哲学专题](philosophy/README.md)
- [使用专题](guides/README.md)
- [风险与治理专题](risk/README.md)
- [开发与持久化记忆](../docs/README.md)
