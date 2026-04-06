# 架构专题

`architecture/` 当前有 84 篇编号文档，范围 `01-84`。本目录负责把 Claude Code 拆成可验证的运行时对象、状态机、控制面和演化边界。

## 八个平面

- `01-09`: 启动链路、Agent 循环、REPL、权限、compact、会话与记忆。
- `10-17`: AgentTool、权限决策、流式工具执行、Bridge、Remote/StructuredIO 与双通道状态同步。
- `18-27`: 提示词装配、服务层全景、Sticky Prompt、产品边界与对象升级。
- `28-38`: 提示词契约、知识层栈、多 Agent 语法、统一预算器、workflow engine 与 Contract-First 阅读法。
- `39-52`: 缓存稳定性、失败语义、依赖图诚实性、观察性、插件双真相、PolicySettings 与安全边界编译。
- `53-63`: Cache-aware Prompt Assembly、Protocol Transcript、能力可见性、可解释运行时、恢复优先状态面与可演化内核。
- `64-72`: 语义压缩、资源宪法、协调成本、有效自由、源码即治理界面与未来维护者消费者。
- `73-84`: Prompt Constitution、治理顺序、构建系统、升级证据、持续验证、message lineage 请求装配、source-lattice 反扩张治理与 anti-stale 内核对象边界。

## 推荐入口

- [01-启动链路与CLI](01-启动链路与CLI.md)
- [10-AgentTool与隔离编排](10-AgentTool与隔离编排.md)
- [18-提示词装配链与上下文成形](18-提示词装配链与上下文成形.md)
- [30-多Agent任务对象、Mailbox与后台协作运行时](30-多Agent任务对象、Mailbox与后台协作运行时.md)
- [38-Contract优先、运行时底盘与公开镜像缺口](38-Contract优先、运行时底盘与公开镜像缺口.md)
- [60-恢复优先的双通道状态面：writeback、resume与reconnect一体化](60-恢复优先的双通道状态面：writeback、resume与reconnect一体化.md)
- [63-可演化内核：Claude Code如何在持续增长中维持不变量](63-可演化内核：Claude Code如何在持续增长中维持不变量.md)
- [82-请求装配流水线：authority chain、section registry、protocol transcript、lawful forgetting与cache-safe forks](82-请求装配流水线：authority chain、section registry、protocol transcript、lawful forgetting与cache-safe forks.md): 看 `message lineage` 如何被投影成 display / protocol / handoff truth
- [83-反扩张治理流水线：trusted inputs、distributed ask arbitration、deferred visibility与continuation pricing](83-反扩张治理流水线：trusted inputs、distributed ask arbitration、deferred visibility与continuation pricing.md): 看 `source lattice` 如何派生动作、可见性与 continuation 定价
- [84-权威面与反僵尸图谱：single-writer surfaces、409 adoption、bridge pointer freshness与release shaping](84-权威面与反僵尸图谱：single-writer surfaces、409 adoption、bridge pointer freshness与release shaping.md): 看 anti-stale 如何落到 freshness gate、validator、per-host 与 capability surface

## 阅读路径

- 想先看启动和主循环：`01 -> 02 -> 12`
- 想先看 Prompt / 上下文 / 缓存：`18 -> 28 -> 31 -> 39`
- 想先看多 Agent 与对象升级：`30 -> 45`
- 想先看安全、权限与治理：`19 -> 23 -> 32 -> 50-52`
- 想先看长期演化与验证：`63 -> 73-84`
- 想先抓最新三张深控制面：`82 -> 83 -> 84`

## 维护约定

- README 只描述运行时平面和推荐起点，未单列文档仍属于对应平面的延伸。
- 需要字段、接口与宿主契约时，回到 [../api/README.md](../api/README.md)。
- 需要跨专题反查时，回到 [../navigation/README.md](../navigation/README.md)。
