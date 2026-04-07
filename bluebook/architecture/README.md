# 架构专题

`architecture/` 当前有 84 篇编号文档，范围 `01-84`。本目录负责把 Claude Code 拆成可验证的运行时对象、状态机、控制面、writeback seam 和演化边界。
如果你还没先建立 `09 / 05 / 15 / 41` 这组高阶判据，不要把这里读成目录库存；这里回答的是这些判据在运行时对象、状态机与 choke point 上怎样落地。

如果只先记源码质量判断在架构层的一句话，也只记这句：

- 源码质量判断不是文件更小，而是把复杂度收进合法复杂度中心，把 `contract -> registry -> current-truth surface -> consumer subset -> hotspot kernel -> mirror gap discipline` 落成正式对象、状态机与 choke point，并用它们保护 `one writable present`。

这里还要再多记一句：

- `architecture/` 真正值钱的，不只是把对象链列出来，而是把 later maintainer 的局部可反对性落成可见的 `authority surface / truth planes / current-truth writeback / retreat layer`。
- 这里说的 `局部可反对性` 不是“最后还能看懂”，而是拿不到作者时，later maintainer 仍能只凭局部对象与 seam 指出哪条 `event / snapshot / pointer / recovery asset` 在越权。

## 什么时候进来

- 当你已经知道某条高阶判断成立，但还没回答“它到底落成了哪些正式对象、状态机与 choke point”。
- 当你需要把 Prompt、治理或当前真相保护继续压到运行时结构，而不是停在哲学判断或模板层。
- 当你准备审读源码质量判断，却不想把它误读成目录观感。
- 当你需要知道“谁在声明现在、谁只在讲时间线、第一退回层先落哪”，而不想把这些问题混成 UI 体感或作者说明。

## 如果你只先判断一件事

- 如果你只先判断“世界怎样先被编进模型”，从 `18 -> 28 -> 39 -> 53 -> 54 -> 82` 进入。
  - 失败信号：还在把 Prompt 魔力理解成更长 instruction、UI transcript 或继续聊天体感。
- 如果你只先判断“扩张怎样先被定价”，从 `23 -> 32 -> 50-52 -> 56 -> 62 -> 65 -> 68 -> 83` 进入。
  - 失败信号：还在把治理理解成 mode 面板、权限门数、token 百分比，或把 `Context Usage` 继续读成成本面板。
- 如果你只先判断“过去怎样不得写坏现在”，从 `41 -> 58 -> 60 -> 63 -> 66 -> 69 -> 84` 进入。
  - 失败信号：还在用 replay、pointer、恢复资产或目录体感代替 `current-truth surface / current-truth writeback / freshness gate`。
- 如果你只先判断“源码质量到底该怎样判”，从 `44 -> 55 -> 63 -> 84` 进入。
  - 最短顺序：`contract -> registry -> current-truth surface -> consumer subset -> hotspot kernel -> mirror gap discipline`
  - 失败信号：还在先谈“目录更整齐 / 文件更小 / 热点文件更大或更小”，而没先点名合法复杂度中心、`one writable present` 与第一条 reject path。
- 如果你只先判断“future maintainer 在结构层到底拿什么正式反对当前实现”，从 `60 -> 63 -> 69 -> 72 -> 84` 进入。
  - 最短顺序：`authority surface -> truth planes -> writeback seam -> danger surface -> retreat layer`
  - 失败信号：later maintainer 还必须追全仓、追作者或靠日志回放猜 authority。
  - counterfeit test：如果“目录更整齐 / 文件更小 / 注释更完整”已经足以被写成先进性结论，而还没点名 `writeback seam / first retreat layer`，那就仍停在目录观感层。

## 八个平面

- `01-09`: 启动链路、Agent 循环、REPL、权限、compact、会话与记忆。
- `10-17`: AgentTool、权限决策、流式工具执行、Bridge、Remote/StructuredIO 与双通道状态同步。
- `18-27`: request assembly、服务层全景、Sticky Prompt、产品边界与对象升级。
- `28-38`: 提示词契约、知识层栈、多 Agent 语法、治理收费链、workflow engine 与 Contract-First 阅读法。
- `39-52`: 缓存稳定性、失败语义、依赖图诚实性、观察性、插件双真相、PolicySettings 与安全边界编译。
- `53-63`: Cache-aware Prompt Assembly、Protocol Transcript、能力可见性、可解释运行时、恢复优先状态面与可演化内核。
- `64-72`: 语义压缩、资源宪法、协调成本、有效自由、源码即治理界面与未来维护者消费者。
- `73-84`: `world entry / request assembly / six-stage assembly chain`、治理顺序、构建系统、升级证据、持续验证、source-lattice 反扩张治理与 anti-stale 内核对象边界。

## 最短证据入口

先按运行时对象与 first reject signal 选入口，不按目录名碰运气。

- [01-启动链路与CLI](01-启动链路与CLI.md)
- [10-AgentTool与隔离编排](10-AgentTool与隔离编排.md)
- [18-提示词装配链与上下文成形](18-提示词装配链与上下文成形.md)
- [30-多Agent任务对象、Mailbox与后台协作运行时](30-多Agent任务对象、Mailbox与后台协作运行时.md)
- [38-Contract优先、运行时底盘与公开镜像缺口](38-Contract优先、运行时底盘与公开镜像缺口.md)
- [60-恢复优先的双通道状态面：writeback、resume与reconnect一体化](60-恢复优先的双通道状态面：writeback、resume与reconnect一体化.md)
- [63-可演化内核：Claude Code如何在持续增长中维持不变量](63-可演化内核：Claude Code如何在持续增长中维持不变量.md)
- [82-请求装配流水线：world entry / request assembly / six-stage assembly chain](82-请求装配流水线：authority chain、section registry、protocol transcript、lawful forgetting与cache-safe forks.md): 看六阶段装配链如何让当前、下一步与 handoff 继续共享同一世界
- [83-反扩张治理流水线：governance key -> externalized truth chain -> typed ask -> decision window -> continuation pricing -> durable-transient cleanup](83-反扩张治理流水线：trusted inputs、distributed ask arbitration、deferred visibility与continuation pricing.md): 看治理控制面如何把这六段链条压成同一条反扩张治理收费链
- [84-权威面与反僵尸图谱：single-writer surfaces、409 adoption、bridge pointer freshness与release shaping](84-权威面与反僵尸图谱：single-writer surfaces、409 adoption、bridge pointer freshness与release shaping.md): 看 anti-stale 如何落到 freshness gate、validator、per-host 与 capability surface

## 缺对象时再跳转

- 缺启动与主循环对象：`01 -> 02 -> 12`
- 缺 `world entry / request assembly / six-stage assembly chain` 对象：`18 -> 28 -> 31 -> 39 -> 82`
- 缺多 Agent / 任务对象：`30 -> 45`
- 缺治理对象与 choke point：`19 -> 23 -> 32 -> 50-52 -> 83`
- 缺 current-truth writeback / anti-stale 对象：`60 -> 63 -> 84`
- 缺长期演化 / 验证对象：`63 -> 73-84`

## 这里不回答什么

- 本目录不负责直接给出 host-facing contract、字段 schema 与 consumer subset 判决。
- 本目录也不负责公开镜像证据分级；如果你需要把源码质量压成证据梯度，去 `../guides/102`。
- 本目录也不负责值班、验收、回退与长期 reopen 执行链。
- 如果你还在问“为什么必须这样设计”或“第一条反证信号是什么”，先回 `../navigation/15` 与 `../navigation/41`。

更准确地说，`architecture/` 负责把对象链、chokepoint 与 current-truth writeback 说清，但不负责替 `playbooks/` 直接发 verdict，也不替 `philosophy/` 重判为什么必须如此。

## 维护约定

- README 只描述运行时平面、最短证据入口与对象分流，未单列文档仍属于对应平面的延伸。
- README 只负责运行时对象、结构边界与推荐起点，不重复 `05 / 15 / 41` 的高阶判据，也不替 `api/` 宣布 contract truth。
- README 应优先暴露 later maintainer 能直接据此提出反对的对象与 seams，而不是先暴露目录体感或功能库存。
- 需要字段、接口与宿主契约时，回到 [../api/README.md](../api/README.md)。
- 需要跨专题反查时，回到 [../navigation/README.md](../navigation/README.md)。
