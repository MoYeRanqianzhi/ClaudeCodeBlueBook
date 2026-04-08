# API 文档

`api/` 不先回答“接口有多少”，而先回答：Claude Code 哪些 truth 会被正式暴露给宿主，哪些 consumer 只配消费哪一层 truth，哪些危险面必须被显式承认。
如果你还没先定清主语或 first-hop，不要急着把这里读成接口库存；那时你缺的还是根入口，不是 API owner page。

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
- 如果你只先判断“结构工件、规则包与目录地图怎样回到 `contract -> registry -> current-truth surface -> consumer subset -> hotspot kernel -> mirror gap discipline` 这条 canonical ladder”，从 `30 -> 39 -> 42 -> 46-50` 进入。
  - 失败信号：还在把目录图、恢复成功率、bridge 指针或作者说明当成 `current-truth surface`。

## 离场条件

- 如果你还在问 why 或第一条反证，回 `../philosophy/README.md` 与 `../README.md`。
- 如果你需要对象、state machine、truth plane 与 `writeback seam`，回 [../architecture/README.md](../architecture/README.md)。
- 如果你缺的是跨目录 artifact gap，而不是 host-facing truth，回 [../navigation/README.md](../navigation/README.md)。
- 如果你已经在下 execution verdict、rollback 或 reopen 顺序，回 `../playbooks/README.md`。

## 这里不回答什么

- 本目录不负责解释第一性原理，也不负责展开运行手册、拒收顺序与案例反例。
- 本目录只回答“哪些真相被正式暴露、哪些 consumer 应怎样消费、哪里最危险”。
- 如果你还在问“为什么必须如此设计”或“第一条反证信号是什么”，先回 `../navigation/15` 与 `../navigation/41`。

更准确地说，`api/` 有正式承认权与消费边界说明权，但没有第一性原理改判权，也没有现场 verdict 签发权。

## 维护约定

- README 只保留 owner scope、入场条件、最小对象与离场条件，不再在首页展开平面书架、推荐入口或长链 syllabus。
- `api/` 的前门判断优先级，应始终是“谁在说真话、谁有子集、哪里最危险”，而不是“目录怎么分得更细”。
- README 只负责 contract truth / host-facing truth 前门，不和 `architecture/` 抢对象前门，不和 `playbooks/` 抢执行 verdict。
- 需要跨目录理解运行时机制时，回到 [../architecture/README.md](../architecture/README.md)。
- 需要跨主题反查时，回到 [../navigation/README.md](../navigation/README.md)。
