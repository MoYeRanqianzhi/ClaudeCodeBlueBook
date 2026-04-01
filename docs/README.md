# 蓝皮书索引

## 目标

这套文档不复述表层功能，而是回答四个问题：

1. Claude Code 的源码结构到底是怎么组织的。
2. 用户与开发者应该如何高效使用它。
3. 它为什么在工程场景里表现强。
4. 哪些能力是公开可用的，哪些只是 feature gate 或内部能力。

## 阅读顺序

1. [00-导读](bluebook/00-%E5%AF%BC%E8%AF%BB.md)
2. [01-源码结构地图](bluebook/01-%E6%BA%90%E7%A0%81%E7%BB%93%E6%9E%84%E5%9C%B0%E5%9B%BE.md)
3. [02-使用指南](bluebook/02-%E4%BD%BF%E7%94%A8%E6%8C%87%E5%8D%97.md)
4. [03-设计哲学](bluebook/03-%E8%AE%BE%E8%AE%A1%E5%93%B2%E5%AD%A6.md)
5. [04-公开能力与隐藏能力](bluebook/04-%E5%85%AC%E5%BC%80%E8%83%BD%E5%8A%9B%E4%B8%8E%E9%9A%90%E8%97%8F%E8%83%BD%E5%8A%9B.md)
6. [05-功能全景与 API 支持](bluebook/05-%E5%8A%9F%E8%83%BD%E5%85%A8%E6%99%AF%E4%B8%8EAPI%E6%94%AF%E6%8C%81.md)
7. [06-第一性原理与苏格拉底反思](bluebook/06-%E7%AC%AC%E4%B8%80%E6%80%A7%E5%8E%9F%E7%90%86%E4%B8%8E%E8%8B%8F%E6%A0%BC%E6%8B%89%E5%BA%95%E5%8F%8D%E6%80%9D.md)

## 当前结论的可信边界

- 可靠: 目录结构、启动路径、工具与权限模型、技能与 MCP 装配方式、远程与多 Agent 主流程。
- 半可靠: 某些通过 `feature()` 或 GrowthBook 控制的能力，只能确认“代码有入口”或“公开包引用了接口”，不能等同于“外部用户必可用”。
- 不应过度断言: npm 发布包里被编译时裁剪掉的内部模块行为细节。

## 维护约定

- 新发现先写入 [development/research-log.md](development/research-log.md)。
- 形成稳定结论后，再升级到 `bluebook/` 正式章节。
- 发现源码版本变化时，先更新导读中的版本范围，再逐章校验。

## 目录结构

- `bluebook/`: 正式主线章节
- `architecture/`: 结构深挖
- `api/`: 接口与能力支持
- `guides/`: 用法与工作流
- `philosophy/`: 哲学与方法论
- `development/`: 研究过程、日志、记忆与迭代准则
