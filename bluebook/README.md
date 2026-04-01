# 蓝皮书索引

## 目标

这套文档不复述表层功能，而是回答四个问题：

1. Claude Code 的源码结构到底是怎么组织的。
2. 用户与开发者应该如何高效使用它。
3. 它为什么在工程场景里表现强。
4. 哪些能力是公开可用的，哪些只是 feature gate 或内部能力。

## 阅读顺序

1. [00-导读](00-%E5%AF%BC%E8%AF%BB.md)
2. [01-源码结构地图](01-%E6%BA%90%E7%A0%81%E7%BB%93%E6%9E%84%E5%9C%B0%E5%9B%BE.md)
3. [02-使用指南](02-%E4%BD%BF%E7%94%A8%E6%8C%87%E5%8D%97.md)
4. [03-设计哲学](03-%E8%AE%BE%E8%AE%A1%E5%93%B2%E5%AD%A6.md)
5. [04-公开能力与隐藏能力](04-%E5%85%AC%E5%BC%80%E8%83%BD%E5%8A%9B%E4%B8%8E%E9%9A%90%E8%97%8F%E8%83%BD%E5%8A%9B.md)
6. [05-功能全景与 API 支持](05-%E5%8A%9F%E8%83%BD%E5%85%A8%E6%99%AF%E4%B8%8EAPI%E6%94%AF%E6%8C%81.md)
7. [06-第一性原理与苏格拉底反思](06-%E7%AC%AC%E4%B8%80%E6%80%A7%E5%8E%9F%E7%90%86%E4%B8%8E%E8%8B%8F%E6%A0%BC%E6%8B%89%E5%BA%95%E5%8F%8D%E6%80%9D.md)

## 按目标阅读

- 想先建立整体判断：顺读 `bluebook/` 主线。
- 想查具体机制：看 `architecture/`。
- 想查接口、字段和协议：看 `api/`。
- 想理解设计内涵与演化方法：看 `philosophy/`。
- 想核对证据、日志与边界：看 `../docs/development/`。

## 按分析面阅读

- 控制面：命令、权限、REPL、remote/bridge。
- 执行面：tools、subagent、MCP、tool orchestration。
- 状态面：transcript、memory、session、rewind、compact/recovery。
- 演化面：feature gate、runtime gate、compat shim、默认值与 rollout。

## 按第一性原理阅读

- 观察：`05-功能全景与API支持.md`、`api/08-工具协议与ToolUseContext.md`
- 决策：`architecture/02-Agent循环与工具系统.md`、`architecture/08-compact算法与上下文管理细拆.md`
- 行动：`architecture/05-权限系统与安全状态机.md`、`api/01-命令与功能矩阵.md`
- 记忆：`architecture/09-会话存储记忆与回溯状态面.md`、`api/09-会话与状态API手册.md`
- 协作：`architecture/10-AgentTool与隔离编排.md`、`philosophy/07-隔离优先于并发.md`
- 恢复：`architecture/06-上下文压缩与恢复链.md`、`philosophy/06-状态优先于对话.md`

## 正式主线与兼容入口

- 正式主线以 `bluebook/00-导读.md` 到 `bluebook/06-第一性原理与苏格拉底反思.md` 为准。
- 历史兼容入口如 `00-蓝皮书总览.md`、`01-源码总地图.md` 仍保留在 `bluebook/` 根目录，主要用于兼容旧链接与旧阅读习惯。
- 后续持续扩写的正文也优先落在 `bluebook/`。

## 当前结论的可信边界

- 可靠: 目录结构、启动路径、工具与权限模型、技能与 MCP 装配方式、远程与多 Agent 主流程。
- 半可靠: 某些通过 `feature()` 或 GrowthBook 控制的能力，只能确认“代码有入口”或“公开包引用了接口”，不能等同于“外部用户必可用”。
- 不应过度断言: npm 发布包里被编译时裁剪掉的内部模块行为细节。

## 维护约定

- 新发现先写入 [development/research-log.md](../docs/development/research-log.md)。
- 形成稳定结论后，再升级到 `bluebook/` 正式章节。
- 发现源码版本变化时，先更新导读中的版本范围，再逐章校验。

## 目录结构

- `bluebook/`: 正式主线章节
- `architecture/`: 机制、状态机与算法深挖
- `api/`: 接口、字段与可用性索引
- `guides/`: 用法与工作流
- `philosophy/`: 哲学、产品演化与第一性原理解读
- `../docs/`: 持久化记忆、研究过程、日志与迭代准则

## 专题索引

- [架构专题](architecture/README.md)
- [API 专题](api/README.md)
- [使用专题](guides/README.md)
- [哲学专题](philosophy/README.md)

本轮新增的深挖入口：

- [compact 算法与上下文管理细拆](architecture/08-compact%E7%AE%97%E6%B3%95%E4%B8%8E%E4%B8%8A%E4%B8%8B%E6%96%87%E7%AE%A1%E7%90%86%E7%BB%86%E6%8B%86.md)
- [会话存储、记忆与回溯状态面](architecture/09-%E4%BC%9A%E8%AF%9D%E5%AD%98%E5%82%A8%E8%AE%B0%E5%BF%86%E4%B8%8E%E5%9B%9E%E6%BA%AF%E7%8A%B6%E6%80%81%E9%9D%A2.md)
- [AgentTool 与隔离编排](architecture/10-AgentTool%E4%B8%8E%E9%9A%94%E7%A6%BB%E7%BC%96%E6%8E%92.md)
- [命令字段与可用性索引](api/07-%E5%91%BD%E4%BB%A4%E5%AD%97%E6%AE%B5%E4%B8%8E%E5%8F%AF%E7%94%A8%E6%80%A7%E7%B4%A2%E5%BC%95.md)
- [工具协议与 ToolUseContext](api/08-%E5%B7%A5%E5%85%B7%E5%8D%8F%E8%AE%AE%E4%B8%8EToolUseContext.md)
- [会话与状态 API 手册](api/09-%E4%BC%9A%E8%AF%9D%E4%B8%8E%E7%8A%B6%E6%80%81API%E6%89%8B%E5%86%8C.md)
- [构建期开关、运行期开关与兼容层](philosophy/05-%E6%9E%84%E5%BB%BA%E6%9C%9F%E5%BC%80%E5%85%B3%E3%80%81%E8%BF%90%E8%A1%8C%E6%9C%9F%E5%BC%80%E5%85%B3%E4%B8%8E%E5%85%BC%E5%AE%B9%E5%B1%82.md)
- [状态优先于对话](philosophy/06-%E7%8A%B6%E6%80%81%E4%BC%98%E5%85%88%E4%BA%8E%E5%AF%B9%E8%AF%9D.md)
- [隔离优先于并发](philosophy/07-%E9%9A%94%E7%A6%BB%E4%BC%98%E5%85%88%E4%BA%8E%E5%B9%B6%E5%8F%91.md)
