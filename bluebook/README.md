# 蓝皮书索引

`bluebook/` 当前由 9 条主线章节、3 个兼容别名页和 9 个专题目录组成。

这个 README 只保留稳定入口，不再复制各子目录的超长手工索引；专题细分结构以各自目录 README 为准。

## 主线入口

1. [00-导读](<00-导读.md>)
2. [01-源码结构地图](<01-源码结构地图.md>)
3. [02-使用指南](<02-使用指南.md>)
4. [03-设计哲学](<03-设计哲学.md>)
5. [04-公开能力与隐藏能力](<04-公开能力与隐藏能力.md>)
6. [05-功能全景与API支持](<05-功能全景与API支持.md>)
7. [06-第一性原理与苏格拉底反思](<06-第一性原理与苏格拉底反思.md>)
8. [07-运行时契约、知识层与生态边界](<07-运行时契约、知识层与生态边界.md>)
9. [08-能力全集、公开度与成熟度矩阵](<08-能力全集、公开度与成熟度矩阵.md>)

兼容别名页仍保留，但不再承担主入口职责：

- [00-总览](<00-总览.md>)
- [00-蓝皮书总览](<00-蓝皮书总览.md>)
- [01-源码总地图](<01-源码总地图.md>)

## 专题目录

- [api/README.md](<api/README.md>): 92 篇协议、字段、宿主消费与接入边界文档。适合查命令、工具、Control、SDK、Remote、插件和 Host Artifact。
- [architecture/README.md](<architecture/README.md>): 81 篇运行时结构文档。适合查启动链、agent loop、状态机、恢复链、Prompt 装配和内核边界。
- [guides/README.md](<guides/README.md>): 95 篇实践文档。适合查使用方法、Builder 手册、宿主接入、迁移与修复模板。
- [navigation/README.md](<navigation/README.md>): 99 篇导航文档。适合做阅读地图、专题检索和跨目录跳转。
- [philosophy/README.md](<philosophy/README.md>): 83 篇第一性原理与设计哲学文档。
- [playbooks/README.md](<playbooks/README.md>): 73 篇回归、演练、运营与交付手册。
- [casebooks/README.md](<casebooks/README.md>): 66 篇失败样本、事故原型与结构反例。
- [risk/README.md](<risk/README.md>): 65 篇账号、地区、风控、误伤与治理专题。
- [security/README.md](<security/README.md>): 139 篇安全章节；配套速查附录见 [security/appendix/README.md](<security/appendix/README.md>)。

## 推荐阅读路径

- 想快速建立整体判断：`00 -> 01 -> 03 -> 07 -> 08`
- 想理解“它为什么更像 runtime 而不是聊天壳”：`00 -> 01 -> architecture/README -> philosophy/README`
- 想高效使用 Claude Code 或迁移其方法：`02 -> guides/README -> navigation/README`
- 想接入宿主、SDK 或控制协议：`05 -> api/README -> architecture/README`
- 想研究安全、账号与治理：`04 -> security/README -> risk/README`
- 想做长期运营、事故复盘与反例校准：`navigation/README -> playbooks/README -> casebooks/README`

## 维护约定

- `README.md` 与 `00-08` 是稳定主入口。
- 兼容别名页只为旧引用保留，不继续扩张。
- 各专题的编号段、细分主题和最新入口以对应目录 README 为准。
