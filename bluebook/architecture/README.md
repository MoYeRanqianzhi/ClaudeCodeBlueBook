# 架构专题

`architecture/` 只负责对象层：哪个对象面在写现在，哪些 truth plane 在发言，writeback seam 在哪，局部 veto 该落在哪，第一退回层先落哪。

> Evidence mode
> - 公开镜像的证据上限、canonical ladder 与降格规则统一回 [../guides/102](../guides/102-%E5%A6%82%E4%BD%95%E7%BB%99%E5%85%AC%E5%BC%80%E9%95%9C%E5%83%8F%E5%81%9A%E6%BA%90%E7%A0%81%E8%B4%A8%E9%87%8F%E8%AF%81%E6%8D%AE%E5%88%86%E7%BA%A7%EF%BC%9Acontract%E3%80%81registry%E3%80%81authoritative%20surface%E3%80%81adapter%20subset%E4%B8%8Ehotspot%20gap%20discipline.md)；本 README 只承接对象、状态机、writeback seam 与 choke point。

如果只先记架构对象层的一句话，也只记这句：

- 架构层不负责再判梯子，而负责把“四个对象问题”继续展开成正式对象、状态机与 choke point，并用它们保护 `one writable present`。

这里也只再多记一句：`architecture/` 真正值钱的，不只是把对象链列出来，而是把 later maintainer 的局部可反对性落成可见对象与 seam。这里说的局部可反对性，不是“最后还能看懂”，而是拿不到作者时仍能只凭局部对象与 seam 指出哪一处对象边界在越权。

## 四个对象问题

- 哪个对象面在写现在。
- 现在是哪条 truth plane 在发言。
- writeback seam 在哪。
- 局部 veto 该先落在哪。
- 第一退回层先落哪。

如果这四问还答不上，说明你缺的还是对象层，而不是新的目录路线。
若你已经知道自己在找 `first no / first retreat layer`，却还说不清它落在哪类 seam，上游先回 `../01-源码结构地图.md` 定位 `generation guard / server-head adoption / host truth externalization / release-surface split` 这类 repo-specific locator；对象层不代做 repo grep。

这里的 `surface` 也不只指 runtime state surface；凡是会改变运行时行为、权限裁决、上下文注入或代理装配的 `operator artifacts`，例如 `CLAUDE.md`、hooks、skills、agent defs 与 permission schemas，也都属于对象层要点名的 `surface`。它们之所以算对象层，不是因为它们更像文档，而是因为 later maintainer 也必须能在这些工件上定位第一条局部 veto。

## landing card（对象摘要）

当对象层判断需要落成统一摘要时，至少写成下面七栏：

| surface | protected invariant | writer truth plane | writeback seam | stale-writer risk | local veto cue | first retreat layer |
|---|---|---|---|---|---|
| `<surface>` | `<what it protects>` | `<who may write now>` | `<where current truth is committed>` | `<which stale write most threatens this surface>` | `<what should trigger a local veto>` | `<where the fallback lands first>` |

这七栏只做对象摘要，不复写 `ceiling / downgrade / unresolved-authority` 之类证据字段；那些 promotion 纪律统一留在 `102`，`landing card` 也不承担验收卡或准入判断。若 `surface` 本身是 operator artifact，也同样必须写清 `writer truth plane`、`local veto cue` 与 `first retreat layer`，否则 later maintainer 拿到的仍只是阅读体感，而不是正式反对路径；答不出退回层的 seam 也还不配被叫作可继承的 `next-refactor entry`。更硬一点说，`first retreat layer` 默认应指向最近的 `fail-closed seam`，也就是 first no 之后先把错误 writer 降回 `no-authority / no-write` 的那一层，而不是下一步修复计划。

## 对象专题索引

如果要继续展开某一个对象面，可按主题进入下面页面；这些链接只是对象摘要页的专题索引，不构成固定顺序：

- [82-请求装配流水线：world entry / request assembly / six-stage assembly chain](82-请求装配流水线：authority chain、section registry、protocol transcript、lawful forgetting与cache-safe forks.md)
- [83-反扩张治理流水线：governance key -> externalized truth chain -> typed ask -> decision window -> continuation pricing -> durable-transient cleanup](83-反扩张治理流水线：trusted inputs、distributed ask arbitration、deferred visibility与continuation pricing.md)
- [60-恢复优先的双通道状态面：writeback、resume与reconnect一体化](60-恢复优先的双通道状态面：writeback、resume与reconnect一体化.md)
- [63-可演化内核：Claude Code如何在持续增长中维持不变量](63-可演化内核：Claude Code如何在持续增长中维持不变量.md)
- [84-权威面与反僵尸图谱：single-writer surfaces、409 adoption、bridge pointer freshness与release shaping](84-权威面与反僵尸图谱：single-writer surfaces、409 adoption、bridge pointer freshness与release shaping.md)

## 这里不回答什么

- 本目录不负责直接给出 host-facing contract、字段 schema 与 consumer subset 判决。
- 本目录也不负责替缺席镜像补 certainty；如果你需要把源码质量压成公开镜像证据梯度，去 `../guides/102`。
- 本目录也不负责值班、验收、回退与长期 reopen 执行链。
- 当前真相 why-proof 由 `../philosophy/86` 负责，源码质量 why-proof 由 `../philosophy/87` 负责；跨专题反查由 `../navigation/README` 负责。
- 本目录也不负责把 seam type 先翻成 repo path locator；如果你还分不清该先找 `QueryGuard`、`sessionIngress`、`onChangeAppState` 还是 `build.mjs`，先回 `../01-源码结构地图.md`。

更准确地说，`architecture/` 负责把对象链、chokepoint 与 current-truth writeback 说清，但不负责替 `playbooks/` 直接发 verdict，也不替 `philosophy/` 重判为什么必须如此。

## 维护约定

- README 只负责运行时对象、结构边界与推荐起点，不重复 `05 / 15 / 41` 的高阶判据，也不替 `api/` 宣布 contract truth。
- README 应优先暴露 later maintainer 能直接据此提出反对的对象与 seams，而不是先暴露目录体感或功能库存。
- 如果一段 README 开始代发 evidence ladder、五段公式链、change-risk protocol 或目录法，它就已经离开对象层。
- 需要字段、接口与宿主契约时，回到 [../api/README.md](../api/README.md)。
- 需要跨专题反查时，回到 [../navigation/README.md](../navigation/README.md)。
