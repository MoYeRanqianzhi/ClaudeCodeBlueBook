# 蓝皮书总索引

## 这套目录怎么读

`bluebook/` 分成三层：

- `README + 00-08` 负责规范主线与最短阅读路径
- 各子目录 `README` 负责专题入口、编号段职责与稳定跳转
- `docs/` 负责开发记忆、研究过程与清理批次，不承载正文

总索引只保留一级路由和稳定阅读路径；深层反查与交叉跳转统一下沉到各子目录 README，尤其是 `navigation/README.md`。如果问题已经变成“上一轮推进到哪、下一批准备清什么、哪些内容被迁出正文”，就不要继续留在 `bluebook/`，直接去 `docs/README.md`。

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

- 兼容别名页：`00-总览.md`、`00-蓝皮书总览.md`、`01-源码总地图.md`

## 专题目录

- [navigation/README.md](navigation/README.md): 104 篇，阅读地图、问题反查与机制回灌
- [architecture/README.md](architecture/README.md): 84 篇，运行时结构、状态机、请求装配、治理控制面与演化边界
- [api/README.md](api/README.md): 95 篇，命令、工具、状态、宿主与扩展协议
- [guides/README.md](guides/README.md): 98 篇，使用方法、模板、审读清单与构建手册
- [philosophy/README.md](philosophy/README.md): 83 篇，第一性原理、治理观和源码先进性解释
- [casebooks/README.md](casebooks/README.md): 72 篇，失败样本、反例与失真原型
- [playbooks/README.md](playbooks/README.md): 76 篇，回归、演练、rollout 与运行手册
- [risk/README.md](risk/README.md): 65 篇，风控、账号治理、恢复与中国用户入口问题
- [security/README.md](security/README.md): 139 篇正文，安全控制面、恢复语义与工程化验证
- [security/appendix/README.md](security/appendix/README.md): 122 篇速查表，安全证据、词法、路由与验证附录

## 推荐阅读

- 建立整体判断：`00 -> 01 -> 03 -> 07 -> 08`
- 想从使用方法进入：`02 -> guides/README -> navigation/README`
- 想看宿主接入与协议边界：`05 -> api/README -> architecture/README`
- 想看安全、风控与误伤恢复：`security/README -> risk/README -> casebooks/README`
- 想看失败样本、演练与 rollout：`casebooks/README -> playbooks/README -> navigation/README`

## 索引分层

- 总索引负责一级路由、目录职责和稳定阅读路径。
- 子目录 README 负责编号段说明、专题入口和跨目录跳转。
- `navigation/README.md` 负责跨主题、跨阶段、跨工件的深层反查。
- [../docs/README.md](../docs/README.md) 只处理开发过程与长期记忆，不承载正文。
