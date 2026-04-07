# API 文档

`api/` 当前有 95 篇编号文档，范围 `01-95`。本目录回答 Claude Code 的能力通过哪些命令、工具、状态消息、宿主协议和扩展接口暴露，以及这些暴露面在宿主侧应如何消费。
如果你还没先经过 `09 / 05 / 15 / 41` 这组高阶前门，不要急着把这里读成接口库存。

还要先记一句：

- `api/` 不是接口清单层，而是真相暴露层；更稳的读法不是先按编号扫平面，而是先问哪些 contract 被外化、哪些 registry 在列出对象、哪个 `current-truth surface` 在宣布现在、宿主自己只是哪个 `consumer subset`，以及哪些热点只能在 `hotspot kernel / mirror gap discipline` 的约束下被消费。

如果把 API 前门继续压成最短公式，也只剩三条：

1. `Authority -> Boundary -> Transcript -> Lineage -> Continuation -> Explainability`
   - 宿主到底承认了哪一段请求编译链
2. `governance key -> externalized truth chain -> typed ask -> decision window -> continuation pricing -> durable-transient cleanup`
   - 宿主到底承认了哪一条治理外化真相
3. `contract -> registry -> current-truth surface -> consumer subset -> hotspot kernel -> mirror gap discipline`
   - 宿主到底在消费哪一层 truth、哪一层热点、哪一层镜像缺口

这里也要先压住一个常见误读：`continuity` 不是第四类 API 平面；它只是 Prompt `Continuation`、治理 `continuation pricing` 与源码质量 `recovery non-sovereignty / anti-zombie` 在 host-facing truth 上的共同时间轴。

更硬一点说，`api/` 在目录里的发言权也只该剩三条：

1. `承认权`
   - 哪些 contract / schema / host-facing truth 被正式承认。
2. `消费边界`
   - 哪些 host / adapter / consumer 只配消费哪一层 truth。
3. `危险面暴露`
   - 哪些 seam、rollback object、reopen boundary 与 hotspot 必须被显式对外。

如果继续把 `consumer subset` 再压成 later maintainer 可直接复查的一张最小矩阵，也只先问五格：

1. `code present`
2. `registry listed`
3. `host-facing truth signed`
4. `consumer subset admitted`
5. `promise boundary declared`

代码里有，不等于 registry 承认；registry 承认，不等于 host-facing truth 已签发；truth 已签发，也不等于所有 consumer 都能合法消费。

如果一页开始替 `philosophy/` 重判必要性，替 `architecture/` 重新发明对象链，或替 `playbooks/` 直接下 verdict，它就已经越权。

更稳一点说，`api/` 也必须继承 shared first-answer order：先判是 Prompt witness、治理外化，还是 current-truth exposure，再决定去看 contract、registry、host-facing truth 还是 consumer subset；顺序没先站住时，API README 也会退回接口库存。

如果一个 API 判断还压不回这三条，它就还停在接口库存层。

## 什么时候进来

- 当你已经知道某条对象链成立，准备判断宿主究竟承认了哪些 truth、哪些只配做 consumer subset。
- 当你需要把运行时对象压成 command、tool、state message、artifact contract 或 host-facing truth。
- 当你需要判断“谁在宣布真相、谁只是在消费真相”，而不是继续看源码结构或哲学解释。

## 如果你只先判断一件事

- 如果你只先判断“谁在宣布当前真相、谁只是在消费它”，从 `23 -> 30 -> 31 -> 46-50 -> 52-56` 进入。
  - 失败信号：还在让宿主从事件流、面板状态或作者说明自己回放拼真相。
- 如果你只先判断“Prompt contract 究竟怎样暴露给宿主”，从 `18 -> 21 -> 49 -> 54` 进入。
  - 失败信号：还在把 `systemPrompt`、UI transcript、最后一条消息或 display summary 当成宿主应消费的主语。
- 如果你只先判断“治理真相怎样外化给宿主”，从 `28 -> 32 -> 52 -> 55` 进入。
  - 失败信号：还在把 `Context Usage` 当成本面板，把 mode 条、弹窗和 token 条当治理真相。
- 如果你只先判断“结构工件、规则包与目录地图怎样回到源码真相梯度”，从 `30 -> 39 -> 42 -> 46-50` 进入。
  - 失败信号：还在把目录图、恢复成功率、bridge 指针或作者说明当成 `current-truth surface`。

## 七个平面

- `01-07`: 命令与控制面，回答功能入口、命令字段和响应矩阵。
- `08-20`: 工具、事件、状态与恢复面，回答 ToolUseContext、SDK 消息、外部元数据和最小闭环。
- `21-30`: 提示词、记忆、能力地图与公开度，回答知识注入、上下文控制，以及目录级能力怎样回到 `contract -> registry -> current-truth surface -> consumer subset`。
- `31-45`: 失败语义、Evidence Envelope、Artifact Contract 与 Harness Runner，回答共享工件怎样挂回治理链与源码真相梯度，而不是长出第二套壳层主语。
- `46-50`: `services/`、`tools/`、`commands/` 二级目录地图与支持面，回答 repo-specific 的 `current-truth surface / consumer subset / hotspot kernel / mirror gap discipline` 如何落到二级目录阅读动作。
- `51-71`: 宿主消费、验收、修复、监护与稳态协议，回答接入后怎样持续消费编译请求、治理控制面和故障模型。
- `72-95`: 稳态纠偏、改写纠偏与长期 reopen 责任，回答深层修正对象如何继续协议化。

## 推荐入口

- [01-命令与功能矩阵](01-命令与功能矩阵.md)
- [09-会话与状态API手册](09-会话与状态API手册.md)
- [21-提示词控制、知识注入与记忆API手册](21-提示词控制、知识注入与记忆API手册.md)
- [23-能力平面、公开度与宿主支持矩阵](23-能力平面、公开度与宿主支持矩阵.md)
- [30-源码目录级能力地图：commands、tools、services、状态与宿主平面](30-源码目录级能力地图：commands、tools、services、状态与宿主平面.md)
- [31-失败语义、取消请求与孤儿修复API手册](31-失败语义、取消请求与孤儿修复API手册.md)
- [39-结构 Host Artifact Contract：权威路径、恢复资产、反zombie 与交接包字段骨架](39-结构 Host Artifact Contract：权威路径、恢复资产、反zombie 与交接包字段骨架.md)
- [42-结构 Artifact Rule ABI：Authoritative Path、Recovery Asset、Anti-Zombie 与 Reject 语义的机器可读结构](42-结构 Artifact Rule ABI：Authoritative Path、Recovery Asset、Anti-Zombie 与 Reject 语义的机器可读结构.md)
- [46-services 二级目录地图：API、Compact、Memory、MCP、LSP 与 Observability 子系统的权威入口](<46-services 二级目录地图：API、Compact、Memory、MCP、LSP 与 Observability 子系统的权威入口.md>)
- [47-tools 二级目录地图：执行原语、交互控制、任务编排、扩展桥接与延迟暴露边界](<47-tools 二级目录地图：执行原语、交互控制、任务编排、扩展桥接与延迟暴露边界.md>)
- [48-commands 二级目录地图：会话控制、模式治理、扩展装配、交付诊断与内部命令边界](<48-commands 二级目录地图：会话控制、模式治理、扩展装配、交付诊断与内部命令边界.md>)
- [49-Prompt编译与稳定性支持面手册：注入入口、协议转译、缓存断点与合法遗忘边界](49-Prompt编译与稳定性支持面手册：注入入口、协议转译、缓存断点与合法遗忘边界.md)
- [50-治理控制面支持面手册：Settings、Permission、MCP、Context Usage、状态写回与继续门控](50-治理控制面支持面手册：Settings、Permission、MCP、Context Usage、状态写回与继续门控.md)

## 适合谁先读

- 想先抓“谁在宣布真相、谁只是在消费真相”：从 `23 -> 30 -> 31 -> 46-50`
- 想看目录级地图、结构工件与规则包怎样回到源码真相梯度：从 `30 -> 39 -> 42 -> 46-50`
- 想看命令和控制协议：从 `01 -> 05 -> 15`
- 想看状态消息与宿主消费：从 `09 -> 17 -> 19 -> 31`
- 想看 Prompt 编译与宿主消费：从 `18 -> 21 -> 49 -> 54`
- 想看 Prompt 在出监与稳态后怎样继续把 reopen 条件协议化：先按 `66 -> 69 -> 72 -> 78` 锁定 host-facing truth，再到 `../playbooks/47 -> ../playbooks/50` 看执行 verdict；这条线只回答 residual gate / threshold / liability，不重新定义 Prompt contract
- 这条 Prompt 尾段线不要再借治理 `67` 的 liability 词或结构 `71` 的 reservation 词做主语；它们最多只配当 sibling 旁证。
- 若问题已滑到 pricing release 或 writeback steady-state，就该离开 Prompt 线，分别回治理 `67` 或结构 `71`。
- 想看治理外化真相链与宿主消费：从 `28 -> 32 -> 52`
- 想看结构深层纠偏对象怎样继续被宿主消费：先过 `30 -> 39 -> 42`，再按 `83 -> 92` 下钻；不要从模板页第一次理解源码先进性
- 想看扩展、MCP 和远程：从 `03 -> 12 -> 22`
- 想看长期宿主协议化：从 `35 -> 51-71 -> 72-95`
- 想看最新共同 `reject` 与长期 `reopen` 协议化：从 `../navigation/98 -> ../navigation/102 -> 93-95`

## 这里不回答什么

- 本目录不负责解释第一性原理，也不负责展开运行手册、拒收顺序与案例反例。
- 本目录只回答“哪些真相被正式暴露、哪些 consumer 应怎样消费、哪里最危险”。
- 如果你还在问“为什么必须如此设计”或“第一条反证信号是什么”，先回 `../navigation/15` 与 `../navigation/41`。

更准确地说，`api/` 有正式承认权与消费边界说明权，但没有第一性原理改判权，也没有现场 verdict 签发权。

## 维护约定

- README 只保留平面级入口与起点文档，不追求覆盖全部 95 篇。
- `api/` 的前门判断优先级，应始终是“谁在说真话、谁有子集、哪里最危险”，而不是“目录怎么分得更细”。
- README 只负责 contract truth / host-facing truth 前门，不和 `architecture/` 抢对象前门，不和 `playbooks/` 抢执行 verdict。
- 需要跨目录理解运行时机制时，回到 [../architecture/README.md](../architecture/README.md)。
- 需要跨主题反查时，回到 [../navigation/README.md](../navigation/README.md)。
