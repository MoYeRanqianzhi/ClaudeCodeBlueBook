# 如何给公开镜像做源码质量证据分级：public artifact ceiling、contract、registry、current-truth claim state、consumer subset、hotspot kernel 与 mirror gap discipline

这一章回答五个问题：

1. 为什么研究 Claude Code 这类公开镜像时，第一步不该直接夸“源码质量很高”或抱怨“缺太多源码”。
2. 怎样把公开镜像里的证据压成稳定的证据阶梯，而不是把 README、schema、注册表、current-truth claim 的不同状态、消费者子集、热点文件和缺口脑补成同一层真相。
3. 为什么“大文件”必须区分为合法复杂度中心和散落式复杂性，而不是一律判坏。
4. 为什么源码质量必须同时审读 `dependency honesty` 与 `temporal honesty`。
5. 怎样把这套证据分级方法迁移到别的 agent runtime 研究和代码评审中。

## 0. 代表性源码锚点

- `claude-code-source-code/README.md:250-290`
- `claude-code-source-code/src/Task.ts:6-124`
- `claude-code-source-code/src/tasks.ts:1-39`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:57-240`
- `claude-code-source-code/src/bridge/bridgeMain.ts:2799-2810`
- `claude-code-source-code/src/query.ts:369-560`
- `claude-code-source-code/src/query/config.ts:1-43`
- `claude-code-source-code/src/query/deps.ts:1-37`
- `claude-code-source-code/src/utils/QueryGuard.ts:1-121`
- `claude-code-source-code/src/services/api/sessionIngress.ts:57-211`

这些锚点共同说明：

- 公开镜像研究里最危险的不是“证据不够”，而是把不同层级的证据混成一层，然后对源码质量下出过度结论。

如果只先记公开镜像的源码质量前门顺序，也只记这条：

- `public artifact ceiling -> contract -> registry -> current-truth claim state -> consumer subset -> hotspot kernel -> mirror gap discipline`

这条 ladder 不是证据分类游戏；本页只判断证据是否足以 promotion，还是必须 downgrade 成 candidate、subset 或 gap note。
在目录契约上，本页也是 `根入口 -> guides/102 -> owner page` 里的唯一 promotion gate：没有经过这一页的 claim-state / downgrade discipline，`architecture/`、`api/`、`philosophy/` 与其他 frontdoor 页里的 noun 都只配先按 claim-state 读，不能自动升级成 landed truth。

这里还应先多记一句：

- 文件路径保留旧词只是为了兼容检索；正文在这一级统一把 `current-truth surface` 读作 `current-truth claim state`，而不是对象层 surface verdict。
- 本页只定义 canonical ladder、降格规则与 `change-risk record` 模板；目录导航与对象展开即使被提及，也只算证据状态声明，不算新的 frontdoor。
- 本页也显式负责 handoff matrix：claim-state rung 一旦锁定，再决定问题该升级给 `architecture/README`、`api/README`、`philosophy/README` 还是 `navigation/README`；在本页锁定前，其他 owner README 都不该偷接。
- handoff 一旦完成，owner page 只配消费这里已经锁定的 rung result，不得重述 canonical ladder、不得补判 promotion、也不得把 provisional claim 偷运成 landed truth；谁重开这三件事，谁就在目录上越位成第二个 gate。
- 在这条线里，artifact completeness 只决定 promotion eligibility，不重写下游页面的稳定职责；页面标题与补写者都不额外增加签字权。
- 凡正文把对象写成 `consumer subset` 或 provisional current-truth claim，必须同时把 `downgrade stamp` 与 `unresolved-authority note` 一起落页；只写“这里要保守”而不写这条说明，默认按证据纪律未落地处理。
- 若对象层 authority 仍需细化，note 只说明“缺少 promotion 所需证明”，不附带任何路由义务。
- 若 object-level authority 还没锁定，就只配先写 provisional current-truth claim；`current-truth surface candidate` 只保留为兼容标签。
- 同理，公开 evidence 若声称存在 `next-refactor entry`，也必须同时说明它落在哪条签字权层级、能触发哪一条 `first local veto`、以及失败时先退回哪一层；做不到这三点，它就只配先写成 `seam candidate`。
- 目录契约也因此只剩一条单向路：`102` 锁定 `object-level claim`，`architecture/` 才能展开 writer / invariant；`102` 锁定 `host-facing truth claim-state / consumer subset`，`api/` 才能展开宿主承认边界；`102` 锁定 `why`，`philosophy/` 才能解释第一性原理；`navigation/` 只在 subject 与 rung 都已知后负责路由，不代替任何一层重新分级。

如果要把本页的 promotion verdict 再压成 later maintainer 可一眼复查的最小盒子，也只剩三种输出、四个硬条件：

| verdict | 最小硬条件 |
|---|---|
| `promotion-passed` | `signer + effect ceiling + local veto cue + first retreat layer` 四项都能点名 |
| `provisional claim` | 对象仍缺 promotion 所需证明，但缺口可被明确记成 `downgrade stamp + unresolved-authority note` |
| `gap / candidate note` | 连对象层 authority、签字权层级或第一条回退都还说不清，只配停在 ceiling / gap / candidate |

如果要把 owner page 的 handoff 继续压成统一可见的 `evidence stamp`，最小也只先写四格：

| stamp field | 允许值 |
|---|---|
| `evidence mode` | `mirror present` / `mirror absent` / `public-evidence only` |
| `rung` | `object-level claim` / `host-facing truth claim-state` / `consumer subset` / `why` / `gap` |
| `verdict` | `promotion-passed` / `provisional claim` / `gap note` |
| `retreat` | 当前最靠近的 `local veto cue / first retreat layer` |

owner page 不必把这四格都做成固定卡片样式，但若 later maintainer 需要翻两段 prose 才看出这四项，handoff 就仍然太依赖作者解释。

这条线最短的 reject trio 也只认：

1. `layout-first drift`
2. `recovery-sovereignty leak`
3. `surface-gap blur`

这里还应再多记一句：

- continuity 在公开镜像里不另立第四类证据层；它应被写进 provisional current-truth claim、`temporal honesty` 与 `mirror gap discipline` 的同一组降格规则。

## 1. 先说结论

### Step 0. 先过 `public artifact ceiling`

在公开镜像研究里，第一步不是直接进 canonical ladder 第一级，而是先承认：

- public artifact 只能签它真正公开签出的东西
- 看得见的 README、schema、registry、热点文件、投影视图与恢复资产，不自动拥有同一种签字权
- 凡公开 artifact 会改变运行时行为（装配、权限、上下文、目录工作面、代理或工具池），至少还要同时写清 `signer`、`effect ceiling` 与第一条 `local veto cue`；缺任一项时，它最多停在 `public artifact ceiling`，不配 promotion 成 current-truth claim。

这一步不过，后面各级判断都会被写浅，因为你会先把“可见”误当成“已被完整证明”。
更硬一点说，能把 `public artifact ceiling / downgrade / gap note / change-risk record` 固化成统一 speaking-rights protocol，本身就是公开可见的工程先进性，因为它降低的是过度主张、误改与制度失忆成本。
本页只判断 promotion / downgrade，并要求记录 `dependency honesty / temporal honesty` 风险；这些风险为什么构成源码质量判断，统一回 `87`。更稳一点说，`102` 负责回答“公开证据够不够把 claim-state 升级给 owner page”，owner page 再回答 why、object 或 host-facing consumption；本页本身不越位成对象页，也不把 owner noun 预先签成 landed truth。
从第一性原理再压一次，这种目录设计并不是为了“把文档写得更细”，而是为了退休重复分级：promotion 只做一次，owner page 只消费一次锁定结果，later maintainer 就不用在每个 frontdoor 里反复重判 admissibility、重判 authority、重判 downgrade。

更稳的公开镜像研究顺序，不是：

- 先冲进 `query.ts`、`main.tsx` 这类热点文件，再从实现猜全貌

而是：

1. `public artifact ceiling`
2. `contract`
3. `registry`
4. `current-truth claim state`
5. `consumer subset`
6. `hotspot kernel`
7. `mirror gap discipline`

所以当公开镜像里出现 `resume path / snapshot / pointer / archive / adapter replay` 这些 continuity 线索时，更稳的默认动作不是宣布“恢复机制很成熟”，而是先问：

1. 它们只是 `recovery asset` 证据，还是已经足够支持 provisional current-truth claim。
2. 它们有没有越位成已获 promotion 的 current-truth claim。
3. 它们是否反而暴露了 `stale writer / stale snapshot / stale capability` 这类 temporal honesty 缺口。

这七层必须严格分开。

因为只有这样，你才不会把：

- 类型声明里“可能存在”的能力
- 当前 build “真的注册”的能力
- 某个宿主“当前实现”的能力
- 某个热点文件“正在维护的不变量”
- 以及 README 已明说“不包含”的能力

误写成同一层真相。

## 1.1 术语对照

在公开镜像研究里，下面这些 visible entry names 最容易互相挤占，必须先拆开：

- `contract truth` 只保留为旧 alias，不再拥有单独层级。
1. `contract`
   - 系统正式承认哪些对象、状态和动作可以存在。
2. `registry`
   - 当前 build / 当前 runtime 真的注册了哪些对象。
3. `current-truth claim state`
   - 在本页只指“current-truth claim 已获 promotion”的证据状态；`current-truth surface` 在这里只是兼容标签，不在这里回答对象层谁在写现在。
4. `provisional claim`
   - 这不是独立 rung，而是上一级在证据尚未满足 promotion 条件时的降格状态；`current-truth surface candidate` 只保留为兼容标签。
5. `consumer subset`
   - 同一份权威真相对不同 host / adapter / projection 只暴露各自职责宽度。
6. `hotspot kernel`
   - 集中维护统一 invariant 的合法复杂度中心。
7. `mirror gap discipline`
   - 明写未知边界，拒绝把缺口脑补成已知真相。

更稳的顺序是：

- 能证明 current-truth claim 已获 promotion，就直接按 claim state 写
- 还不能证明时，就降格写 provisional claim
- 不要反过来把所有接近当前真相的线索都写成已经完成 promotion 的 claim

这一页后面的所有降格规则都建立在这三句上，而不是建立在“我很熟源码”这种阅读体感上。

## 1.2 Worked Example：不要一眼把 `permission_mode` 写成对象真相

如果 later maintainer 只想先看一个对象怎样沿 ladder 被审读，可以先拿 `permission_mode` 这种高流量 noun 做演示，但也必须严格按 rung 走，而不是看见 mode 条、审批弹窗或 userbook 说明就直接宣布“这里已经有 sole writer”。

| rung | 这一步只该问什么 | 对 `permission_mode` 更稳的写法 |
|---|---|---|
| `public artifact ceiling` | 公开工件到底只签出了什么 | 只能先说“公开材料显示存在 mode / approval surface”，不能先说谁在写现在 |
| `contract` | 系统正式承认哪些 mode / state 可以存在 | 可以写“schema / contract 承认 permission-related state” |
| `registry` | 当前 build / runtime 真的列出了哪些 mode 对象 | 可以写“当前 build 暴露了 mode-related registry / control surface” |
| `current-truth claim state` | 公开证据是否已经足够 promotion | 只有能点名 `signer + effect ceiling + local veto cue + first retreat layer` 时，才配升级；否则继续停在 `provisional claim` |
| `consumer subset` | 哪些 host / UI / status 只是在消费这份 truth | mode 条、面板、外部元数据往往更接近 subset / projection，而不是 sole writer |
| `hotspot kernel` | 哪个 chokepoint 在集中维护 invariant | 只有前面 rung 已锁定，才值得继续问 mode 相关的 single-writer seam 在哪 |
| `mirror gap discipline` | 还缺哪种证据不能脑补 | 若镜像缺席、writer seam 不明、或 host 只给 receipt-grade 投影，就继续保留 `unresolved-authority note` |

从第一性原理再压一次，这个 worked example 真正要示范的不是 `permission_mode` 本身，而是一个更硬的阅读纪律：越是高流量对象，越不能靠 UI 熟悉感和文案体感跳过 promotion gate。后续若换成 `worker_status`、tool pool、session head 或 operator artifact，也仍应用同一张表，而不是各自发明一套“我大概知道它在干什么”的例外法。

## 2. 第一级：先找 contract

先看：

- schema
- type union
- state interface
- single-source file

因为这里回答的是：

- 系统承认哪些对象、状态和控制动作

`Task.ts`、`controlSchemas.ts` 这类文件的重要性，不在“它们更抽象”，而在：

- 它们先把系统允许存在的世界写出来

如果你跳过这一步，后面看到任何热点实现都很容易误判为：

- 全局合同

而不是：

- 局部实现

## 3. 第二级：再找 registry

contract 只回答：

- 系统设计空间里可能有哪些对象

registry 才回答：

- 当前 build / 当前运行时到底注册了哪些对象

`tasks.ts`、feature gate、tool pool 装配、plugin / MCP 注册表都属于这一层。

如果不把它和 contract 分开，你最容易犯两类错误：

1. 把“类型里声明存在”误当成“当前肯定能用”。
2. 把“注册表里当前没开”误当成“架构上根本没有”。

所以第二步必须单独判断：

- declaration space
- current registry

不能让两者互相替代。

## 4. 第三级：判断 current-truth claim 还停在什么证据状态

contract 和 registry 都还不够。

真正会决定源码质量判断稳定性的，是：

- 当前这份 claim 有没有足够可见证据支持 promotion

这里的 `current-truth claim state` 不是在本页回答“谁在写现在”，而是在判断公开镜像里的可见证据是否已经足够支撑 promotion。若这些证据还没锁定，就不能宣布这层真相已经成立，在公开镜像里最多只能先把它记成 `provisional claim`，并同步附一条 unresolved-authority note；`current-truth surface / candidate` 只保留为兼容标签。

典型信号只在证明“这里可能支持 current-truth claim”，不在本页直接升级成对象层 verdict。

如果这一层没有先锁定，你就很容易从：

- 派生逻辑
- UI 投影
- 恢复路径
- adapter 局部缓存

去反推系统真相。

而 Claude Code 式的成熟度，正好体现在：

- 它会主动暴露更接近权威 claim 的可见证据

## 5. 第四级：把 consumer subset 从协议全集里剥出来

公开镜像最容易被误读的一层，是：

- protocol full set vs consumer subset

因为协议全集里声明存在的能力，不等于每个 adapter、每个 host、每个入口都真的实现了它。`worker_status / external_metadata`、resume path 与 search layer 也都在消费同一 runtime truth 的诚实子集。

`bridgeMain` 明写 linear subset，remote / headless / REPL 又各有不同支持面。

还要再加一条：

- host / domain boundary 变化后，旧授权与旧 capability 目录不配自动继承

所以第四步必须单独问：

1. 这是协议全集吗。
2. 这是当前 adapter 的子集吗。
3. 这是当前入口此刻真启用的能力吗。
4. 这份启用资格是不是仍绑定在同一个 host / config / credential truth 上。

如果这三问不分开，后面就会频繁出现两种误写：

1. 把“代码里有”误写成“产品承诺有”。
2. 把“某入口支持”误写成“所有入口都支持”。

## 6. 第五级：最后才判断 hotspot kernel

只有在前四层都锁定之后，热点文件才值得读。

这时真正该问的也不再是：

- 为什么它这么大

而是：

1. 它是不是合法复杂度中心。
2. 它在集中维护哪些 invariant。
3. 新能力是否沿着正式 contract 进入它。
4. 它周围有没有足够诚实的 seam 把 blast radius 围住。

`query.ts`、`main.tsx`、`attachments.ts` 这类文件不能机械判坏。

更稳的判断标准是：

- 如果复杂度集中维护统一不变量，它更像 `hotspot kernel`
- 如果复杂度四散漂移、真相和副作用边界都不清楚，它才更像结构退化

这就是为什么“大文件”必须分成：

- 合法复杂度中心
- 散落式复杂性

## 7. 第六级：mirror gap discipline

公开镜像研究永远不能省略最后一层：

- 明确 gap，克制脑补

你可以稳定判断：

1. 当前可见 contract 的成熟度
2. 当前 registry / provisional current-truth claim 的清晰度
3. 当前 hotspot kernel 的职责是否可辩护
4. 当前 seam、命名、注释、state machine 是否足够诚实

但你不能稳定判断：

1. 缺失模块里一定还藏着什么“更完整实现”
2. 测试体系一定如何组织
3. feature-gated 能力在内部是否都和公开树同构

公开镜像最该保留的 unknown，不是“内部也许还有更多实现”，而是 current-truth claim promotion 所需的 authority evidence、跨时回写约束与 eviction rule 是否可见；这些证据不可见时，只能写 unknown，不能从 replay asset、UI snapshot 或 adapter cache 反推 current-truth claim。

gap discipline 的价值不是“保守一点”，而是：

- 让研究结论继续可验证、可反驳、可迁移

## 8. 源码质量必须双审：dependency honesty 与 temporal honesty

很多源码评审只盯：

- dependency honesty

也就是：

- import 图是否诚实
- seam 是否清楚
- single-source 是否稳定

但 Claude Code 这类 agent runtime 还必须同时审：

- temporal honesty

也就是：

- stale snapshot 会不会重写 fresh state
- recovery asset 会不会篡位为 authority
- stale writeback path / stale writeback capability 是否仍可达
- 过去对象会不会重新写坏现在
- stale capability / stale credential 会不会继续把 ghost tools 或 ghost auth 留在当前世界里

如果只看第一条，你会高估静态分层漂亮度。
如果只看第二条，你会忽视长期演化的认知债。

真正稳的源码质量判断必须同时回答：

1. 依赖图有没有说真话。
2. 时间图有没有说真话。
3. host / domain / credential truth 有没有继续说真话。

## 9. 迁移到自己的 runtime 设计与研究里

如果你要把这套方法迁移到自己的 agent runtime，最稳的步骤是：

1. 先列 contract，不先列目录树。
2. 再列 registry，不先夸能力全集。
3. 再锁定 `current-truth claim state`，或至少落成 `provisional claim`，不从 UI 投影反推真相。
4. 再区分 `consumer subset`，不把协议全集和宿主子集混写。
5. 最后才审 hotspot kernel 是否是合法复杂度中心。
6. 每一步都保留 gap note，不让缺失部分被脑补补齐。

这套方法的目标不是：

- 更会赞美 Claude Code

而是：

- 形成一套可迁移的研究协议，去稳当地审任何公开镜像

## 10. 危险改动面附表模板

当你已经完成 `contract -> registry -> current-truth claim state -> consumer subset -> hotspot kernel` 分级后，下一步最值钱的不是继续夸“结构很稳”，而是把危险改动面压成一张可交接的 `change-risk` 附表。

`guides/` 在这里只负责这张附表的字段与 gap note 写法，不替其他目录代写具体危险面。
这张附表也不是变更批准协议，而是把 visible evidence、常见误读、第一条局部拒收线索、降格理由与 unresolved-authority 缺口写实；如果改动前还写不出这张表，current-truth 判断就应继续保持 provisional。
更硬一点说，能把 `public artifact ceiling / downgrade / gap note / change-risk` 一起写成 later maintainer 可继承的记录协议，本身就是公开可见的工程先进性：它先公开的是拒收与降格能力，而不是过满 promotion。

更稳的记录模板至少应包含下面几列：

| change-risk surface | protected invariant | minimum visible evidence | first local veto cue | first retreat layer | common misread | downgrade note | unresolved-authority note |
|---|---|---|---|---|---|
| `<surface>` | `<what it protects>` | `<authoritative proof>` | `<where later maintainer first says no>` | `<where the fallback lands first>` | `<usual wrong reading>` | `<why this stays provisional>` | `<what promotion still lacks>` |

若 `change-risk surface` 本身是公开 operator artifact，`minimum visible evidence` 至少还应写出 `signer` 与 `effect ceiling`。缺任一项时，默认降格回 `public artifact ceiling`，不得 promotion 成 current-truth claim 或稳定 capability claim。

更短地说，这页真正要先写实的是：

1. 这份 `change-risk` 附表该长什么样。
2. 哪些 gap 必须显式保留。
3. later maintainer 第一条局部 veto 应该落在哪。
4. 第一退回层先落哪。
5. 为什么当前判断仍要降格。
6. 哪些 authority 缺口必须继续显式保留。

对象层若还需要继续写 `writeback seam / first fallback / local veto cue`，统一留给 `architecture/README`；`102` 不代写对象摘要。
更明确地说，`102` 在目录里的 handoff matrix 只认下面四条：

1. rung 已锁定为 object-level claim
   - 再进 `architecture/README`
   - 进入后只展开对象、writeback seam、local veto 与 first retreat layer，不重开 ladder，也不重做 promotion
2. rung 已锁定为 host-facing truth claim-state / consumer subset
   - 再进 `api/README`
   - 进入后只展开宿主承认边界、consumer subset 与 promise boundary，不重开 rung 分类
3. rung 已锁定为 why question，而不是 admissibility / promotion question
   - 再进 `philosophy/README`
   - 进入后只证明 why，不补 gate，也不把 claim-state 偷签成 landed truth
4. 主语与 rung 都已锁定，只缺下一种 artifact、gap note 或最近的 fail-closed seam
   - 再进 `navigation/README`
   - 进入后只反查下一种 artifact / seam，不重做 first-hop 或 rung typing

若这四条里任何一条还答不上，就继续留在 `102`；这页先锁 rung，不让 owner noun 提前升级成 landed truth。更硬一点说，handoff 之后 owner page 只配消费这条已锁定的 rung，不得再重讲 canonical ladder、重开 promotion，或把 provisional claim 偷签成 landed object truth。

## 11. 苏格拉底式检查清单

在你准备写下“这个仓库源码质量很高”前，先问自己：

1. 我现在看到的是 contract、registry、provisional current-truth claim、consumer subset 还是 hotspot。
2. 我是否把“声明存在”“当前注册”“宿主实装”混成了一层。
3. 这个大文件是在维护统一 invariant，还是在四处补丁式接线。
4. 我是否同时审了 dependency honesty 与 temporal honesty。
5. 我写下的哪一句判断，是被可见证据支撑的；哪一句只是脑补。
6. 如果作者今天不解释，我的结论还能不能成立。

## 12. 一句话总结

公开镜像里的源码质量，不该靠目录树和大文件体感判断；更稳的顺序是 `contract -> registry -> current-truth claim state -> consumer subset -> hotspot kernel -> mirror gap discipline`，并且同时审 `dependency honesty` 与 `temporal honesty`。
