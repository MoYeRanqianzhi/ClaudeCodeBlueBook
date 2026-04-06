# 蓝皮书入口

## 稳定入口

先只记三句：世界如何进入模型，扩张如何被定价，当前如何不被过去写坏。第一次进入先读 [09-三张控制面总图：世界进入模型、扩张定价与防过去写坏现在](09-三张控制面总图：世界进入模型、扩张定价与防过去写坏现在.md)，再回 [03-设计哲学](03-设计哲学.md)；要跨目录反查时再去 [navigation/README.md](navigation/README.md)；方法附录、证据归档与目录治理记录去 [../docs/README.md](../docs/README.md)。

入口页只保留一级路由和稳定阅读路径；更深的跨目录编号链统一下沉到各子目录 README，尤其是 `navigation/README.md`。目录分层首先是阅读协议，不是源码质量评分；根目录更薄、入口更清楚，不等于运行时边界就已经更稳。

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

## 专题目录

- [navigation/README.md](navigation/README.md): 跨目录路由、问题反查与执行链导航
- [architecture/README.md](architecture/README.md): 运行时结构、状态机、请求装配、治理控制面与演化边界
- [api/README.md](api/README.md): 命令、工具、状态、宿主与扩展协议
- [guides/README.md](guides/README.md): 使用方法、模板、审读清单与构建手册
- [philosophy/README.md](philosophy/README.md): 第一性原理、治理观、控制面收束与源码先进性解释
- [casebooks/README.md](casebooks/README.md): 失败样本、反例与失真原型
- [playbooks/README.md](playbooks/README.md): 回归、演练、rollout 与运行手册
- [risk/README.md](risk/README.md): 风控、账号治理、恢复与中国用户入口问题
- [security/README.md](security/README.md): 安全控制面正文
- [security/appendix/README.md](security/appendix/README.md): 安全速查表与证据附录

## 推荐阅读

第一次进入：

- 先建立主线宪法：读 [09-三张控制面总图：世界进入模型、扩张定价与防过去写坏现在](09-三张控制面总图：世界进入模型、扩张定价与防过去写坏现在.md)，再回到 [00-导读](00-导读.md)、[01-源码结构地图](01-源码结构地图.md)、[03-设计哲学](03-设计哲学.md)、[06-第一性原理与苏格拉底反思](06-第一性原理与苏格拉底反思.md)
- 只想先抓最高阶判断：读 [09-三张控制面总图：世界进入模型、扩张定价与防过去写坏现在](09-三张控制面总图：世界进入模型、扩张定价与防过去写坏现在.md)、[03-设计哲学](03-设计哲学.md)、[06-第一性原理与苏格拉底反思](06-第一性原理与苏格拉底反思.md)，再回各专题 README

按主题进入：

- 能力与公开度：先读 [04-公开能力与隐藏能力](04-公开能力与隐藏能力.md)、[05-功能全景与API支持](05-功能全景与API支持.md)、[08-能力全集、公开度与成熟度矩阵](08-能力全集、公开度与成熟度矩阵.md)
- 设计内涵：先读 [09-三张控制面总图：世界进入模型、扩张定价与防过去写坏现在](09-三张控制面总图：世界进入模型、扩张定价与防过去写坏现在.md)、[03-设计哲学](03-设计哲学.md)、[06-第一性原理与苏格拉底反思](06-第一性原理与苏格拉底反思.md)
- Prompt 设计哲学与验证：先回 `09` 建立主语，再分别从 [philosophy/README.md](philosophy/README.md)、[guides/README.md](guides/README.md) 与 [playbooks/README.md](playbooks/README.md) 进入；跨目录执行链统一回 [navigation/README.md](navigation/README.md)
- 方法与构建：先读 [02-使用指南](02-使用指南.md)，再去 [guides/README.md](guides/README.md)
- 安全、风控与恢复：先回 [09-三张控制面总图：世界进入模型、扩张定价与防过去写坏现在](09-三张控制面总图：世界进入模型、扩张定价与防过去写坏现在.md) 的第二张图，再去 [security/README.md](security/README.md)、[risk/README.md](risk/README.md) 与 [playbooks/README.md](playbooks/README.md)
- 需要值班、验收、修复与长期回归：先去 [playbooks/README.md](playbooks/README.md)，更深的跨目录执行链统一回 [navigation/README.md](navigation/README.md)

更细的跨目录、跨阶段、跨工件阅读链，统一回 [navigation/README.md](navigation/README.md)。

## 入口分工

- 蓝皮书入口页负责一级路由、目录职责和稳定阅读路径。
- 子目录 README 负责编号段说明、专题入口和跨目录跳转。
- `navigation/README.md` 负责跨主题、跨阶段、跨工件的深层反查。
- [../docs/README.md](../docs/README.md) 只处理方法附录、证据归档与目录治理记录，不承载正文。
- 兼容别名页统一交给 [navigation/04-目录职责、规范入口与兼容别名页说明.md](navigation/04-目录职责、规范入口与兼容别名页说明.md)。
