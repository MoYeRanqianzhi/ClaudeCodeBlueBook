# 按资产反查表：section、stable-bytes、shadow-stub与recovery-asset定位

这一章把参考层继续压成资产优先的诊断表。

它主要回答四个问题：

1. 为什么很多“实现细节问题”其实是在伤害正式制度资产。
2. 怎样从受损资产直接回到相关正文、手册与底盘章节。
3. 为什么按资产查往往比按文件名查更稳定。
4. 怎样用苏格拉底式追问避免把资产表写成抽象名词堆。

## 0. 第一性原理

真正需要长期守住的，不是：

- 某个当前文件长什么样

而是：

- 哪些制度资产在长期演化里必须保持可治理、可恢复、可审计

所以资产反查表的作用，是把读者从“哪个文件坏了”重新拉回：

- 哪个正式资产受伤了

## 1. 资产优先表

| 资产 | 失效表现 | 首查入口 | 再查入口 | 为什么它是资产 | 最易混淆边界 |
| --- | --- | --- | --- | --- | --- |
| `section` | token 占比漂移、角色约束失衡、cache break 解释失真 | `01 / ../guides/24 / ../architecture/73` | `../philosophy/33 / ../philosophy/60` | section 自带命名、缓存、主权与修宪语义，是可复用、可审计的 prompt 治理单元。 | 容易和 `boundary` 混淆；section 是制度内容单元，boundary 是这些单元的合法切线。 |
| `boundary` | dynamic/static 放错侧、compact 后补边失败、protocol truth 编译失真 | `01 / ../guides/24 / ../architecture/53` | `../architecture/54 / ../philosophy/41 / ../philosophy/57` | boundary 决定哪些内容可以一起缓存、一起遗忘、一起重放，是运行时合法性的正式边界。 | 容易和 `stable bytes` 混淆；boundary 讲切线，stable bytes 讲切线两侧必须稳定的字节身份。 |
| `stable bytes` | cache hit 下降、approval / replay 证据难以复用、drift 难解释 | `02 / ../guides/25 / ../architecture/74` | `../guides/28 / ../philosophy/39 / ../philosophy/61` | 能被缓存、复用、比较和解释的不是“意思差不多”，而是可稳定重放的字节资产本身。 | 容易和 `section` 混淆；section 是治理对象，stable bytes 是它序列化后可共享的身份。 |
| `shadow-stub` | external build 被拖脏、portable 入口失守、compat 壳层长期不退 | `03 / ../guides/26 / ../architecture/75` | `../guides/29 / ../philosophy/53 / ../philosophy/62` | shadow/stub 保护的是发布面、导入安全和可移植构建，是结构秩序的一部分。 | 容易和 `transport shell` 混淆；shadow-stub 管入口与发布面，transport shell 管载体与协议隔离。 |
| `transport shell` | local/remote、v1/v2、structured/bridge 差异渗进业务层 | `03 / ../api/13 / ../architecture/59` | `../architecture/75 / ../philosophy/46 / ../philosophy/62` | transport shell 承载的是“载体变化但语义不变”的隔离能力，不是普通适配器外壳。 | 容易和 `boundary` 混淆；boundary 管输入切线，transport shell 管不同 carrier 下的语义连续性。 |
| `recovery asset` | resume 找不到现场、pointer 丢失、replacement replay 失灵 | `03 / ../api/20 / ../architecture/60` | `../playbooks/03 / ../philosophy/47` | pointer、snapshot、replacement log 等对象让系统在进程死亡后仍能找回同一当前真相。 | 容易和 `object state` 混淆；recovery asset 是跨进程保存的恢复句柄，object state 是此刻活着的权威当前态。 |
| `object state` | UI、host、query loop 读到不同当前态，出现 stale 或 zombie | `02 / 03 / ../api/17` | `../architecture/47 / ../philosophy/13 / ../philosophy/34` | object state 是审批、渲染、恢复与观测共同依赖的权威当前事实。 | 容易和 `recovery asset` 混淆；object state 负责“现在是什么”，recovery asset 负责“崩了以后怎样找回现在”。 |

## 2. 使用协议

当你已经知道“伤到的是哪类制度资产”，但还不知道该查哪篇正文时：

1. 先用本页锁定资产。
2. 再回 `04` 给这次问题补资产标签。
3. 最后按首查入口和再查入口分流到样本、手册与底盘章节。

## 3. 苏格拉底式追问

在你准备继续按文件名搜索前，先问自己：

1. 我现在看到的是某个文件的局部问题，还是某类正式资产的制度受损。
2. 这次问题真正破坏的是 section、boundary、stable bytes，还是恢复与状态资产。
3. 我是在缩短未来团队的检索路径，还是又写了一份只有自己记得住的资产清单。
4. 如果把这类资产写错，未来复盘会不会再次把根因贴回表层实现细节。
