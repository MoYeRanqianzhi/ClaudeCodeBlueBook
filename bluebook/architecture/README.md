# 架构专题

`architecture/` 只负责对象层：谁在写现在，哪些 truth plane 在说话，writeback seam 在哪，第一退回层落哪。

> Evidence mode
> - 公开镜像的证据上限、canonical ladder 与降格规则统一回 [../guides/102](../guides/102-%E5%A6%82%E4%BD%95%E7%BB%99%E5%85%AC%E5%BC%80%E9%95%9C%E5%83%8F%E5%81%9A%E6%BA%90%E7%A0%81%E8%B4%A8%E9%87%8F%E8%AF%81%E6%8D%AE%E5%88%86%E7%BA%A7%EF%BC%9Acontract%E3%80%81registry%E3%80%81authoritative%20surface%E3%80%81adapter%20subset%E4%B8%8Ehotspot%20gap%20discipline.md)；本 README 只承接对象、状态机、writeback seam 与 choke point。

如果只先记架构对象层的一句话，也只记这句：

- 架构层不负责再判梯子，而负责把“四个对象问题”继续展开成正式对象、状态机与 choke point，并用它们保护 `one writable present`。
- 这里首先在分配 present 的写权与回写责任，而不是描述结构形状。

这里还要再多记一句：

- `architecture/` 真正值钱的，不只是把对象链列出来，而是把 later maintainer 的局部可反对性落成可见对象与 seam。
- 这里说的 `局部可反对性` 不是“最后还能看懂”，而是拿不到作者时，later maintainer 仍能只凭局部对象与 seam 指出哪条 `event / snapshot / pointer / recovery asset` 在越权。
- 因而 `event truth / current truth / display truth` 的对象化分工，以及 `writeEvent / reportState / reportMetadata` 这类通道怎样落到 writeback seam，也统一由本目录与 `60 / 84` 负责，不在 `87` 这类 why 页重发对象矩阵。
- 这里的前置输入只有两件：`102` 已产出的 `change-risk record`，以及 `87` 已补完的 why-proof。
- 本页输出也只有两件：landing card，以及只在本页执行的 `landing-card local gate`。

## 四个对象问题

- 谁在写现在。
- 现在是哪条 truth plane 在发言。
- writeback seam 在哪。
- 第一退回层先落哪。

如果这四问还答不上，说明你缺的还是对象层，而不是新的目录路线。

对象层不再单独发第二条 handoff；这里不重发全局顺序，只负责把前置输入落成对象、状态机与 seam。

## landing card

当 `102` 已经产出 `change-risk record`，对象层至少还要把它继续落成下面六栏：

| surface | protected invariant | writer truth plane | writeback seam | first fallback | unresolved authority |
|---|---|---|---|---|---|
| `<surface>` | `<what it protects>` | `<who may write now>` | `<where current truth is committed>` | `<first retreat layer>` | `<what still lacks promotion proof>` |

字段映射也应固定成机械关系，而不是解释关系：

- `change-risk surface` -> `surface`
- `protected invariant` -> `protected invariant`
- `minimum visible evidence` -> `writer truth plane / unresolved authority`
- `replay obligation` -> `writeback seam / first fallback`
- `second-truth risk` -> `first fallback / unresolved authority`

`landing card` 写完后，默认下一步不是立刻展开更多对象专题，而是先在当前链内过一遍 `landing-card local gate`；`87` 只提供 why-proof 命题，本页只负责执行这道本地 gate：

1. 这里是否仍是 `合法复杂度中心`
2. 这里是否仍只承认 `one writable present`
3. later maintainer 是否已能据此执行第一条 veto

三问有一问答不上，就说明 landing card 还只是对象草图，不是可升级的 change control。

## 什么时候进来

- 当你已经知道某条高阶判断成立，但还没回答“它到底落成了哪些正式对象、状态机与 choke point”。
- 当你需要把 Prompt、治理或当前真相保护继续压到运行时结构，而不是停在哲学判断、模板或排错层。
- 当你准备判断 later maintainer 拿什么局部反对当前实现，而不想把问题退回目录观感或作者说明。

## quality gate 通过后的对象展开

- [82-请求装配流水线：world entry / request assembly / six-stage assembly chain](82-请求装配流水线：authority chain、section registry、protocol transcript、lawful forgetting与cache-safe forks.md)
  - 看 same-world compiler 怎样落成 request assembly 对象。
- [83-反扩张治理流水线：governance key -> externalized truth chain -> typed ask -> decision window -> continuation pricing -> durable-transient cleanup](83-反扩张治理流水线：trusted inputs、distributed ask arbitration、deferred visibility与continuation pricing.md)
  - 看治理秩序怎样落成定价对象与 choke point。
- [60-恢复优先的双通道状态面：writeback、resume与reconnect一体化](60-恢复优先的双通道状态面：writeback、resume与reconnect一体化.md)
  - 看 event truth、current truth 与 display truth 怎样在 writeback seam 分开。
- [63-可演化内核：Claude Code如何在持续增长中维持不变量](63-可演化内核：Claude Code如何在持续增长中维持不变量.md)
  - 看 later maintainer 的局部可反对性怎样落成结构约束。
- [84-权威面与反僵尸图谱：single-writer surfaces、409 adoption、bridge pointer freshness与release shaping](84-权威面与反僵尸图谱：single-writer surfaces、409 adoption、bridge pointer freshness与release shaping.md)
  - 看 anti-stale 如何落到 freshness gate、validator、per-host 与 capability surface。

## 这里不回答什么

- 本目录不负责直接给出 host-facing contract、字段 schema 与 consumer subset 判决。
- 本目录也不负责替缺席镜像补 certainty；如果你需要把源码质量压成公开镜像证据梯度，去 `../guides/102`。
- 本目录也不负责值班、验收、回退与长期 reopen 执行链。
- 若缺 why-proof，统一回 `../philosophy/87`；`../navigation/README` 只做跨专题反查。

更准确地说，`architecture/` 负责把对象链、chokepoint 与 current-truth writeback 说清，但不负责替 `playbooks/` 直接发 verdict，也不替 `philosophy/` 重判为什么必须如此。

## 维护约定

- README 只负责运行时对象、结构边界与推荐起点，不重复 `05 / 15 / 41` 的高阶判据，也不替 `api/` 宣布 contract truth。
- README 应优先暴露 later maintainer 能直接据此提出反对的对象与 seams，而不是先暴露目录体感或功能库存。
- 如果一段 README 开始代发 evidence ladder、五段公式链、change-risk protocol 或目录法，它就已经离开对象层。
- 需要字段、接口与宿主契约时，回到 [../api/README.md](../api/README.md)。
- 需要跨专题反查时，回到 [../navigation/README.md](../navigation/README.md)。
