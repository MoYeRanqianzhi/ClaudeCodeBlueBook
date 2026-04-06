# 如何给公开镜像做源码质量证据分级：contract、registry、authoritative surface、adapter subset与hotspot gap discipline

这一章回答五个问题：

1. 为什么研究 Claude Code 这类公开镜像时，第一步不该直接夸“源码质量很高”或抱怨“缺太多源码”。
2. 怎样把公开镜像里的证据压成稳定的六级阶梯，而不是把 README、schema、注册表、热点文件和缺口脑补成同一层真相。
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

## 1. 先说结论

更稳的公开镜像研究顺序，不是：

- 先冲进 `query.ts`、`main.tsx` 这类热点文件，再从实现猜全貌

而是：

1. `contract truth`
2. `registry truth`
3. `authoritative surface truth`
4. `adapter subset truth`
5. `hotspot kernel truth`
6. `mirror gap discipline`

这六层必须严格分开。

因为只有这样，你才不会把：

- 类型声明里“可能存在”的能力
- 当前 build “真的注册”的能力
- 某个宿主“当前实现”的能力
- 某个热点文件“正在维护的不变量”
- 以及 README 已明说“不包含”的能力

误写成同一层真相。

## 2. 第一级：先找 contract truth

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

## 3. 第二级：再找 registry truth

contract truth 只回答：

- 系统设计空间里可能有哪些对象

registry truth 才回答：

- 当前 build / 当前运行时到底注册了哪些对象

`tasks.ts`、feature gate、tool pool 装配、plugin / MCP 注册表都属于这一层。

如果不把它和 contract truth 分开，你最容易犯两类错误：

1. 把“类型里声明存在”误当成“当前肯定能用”。
2. 把“注册表里当前没开”误当成“架构上根本没有”。

所以第二步必须单独判断：

- declaration space
- current registry

不能让两者互相替代。

## 4. 第三级：锁定 authoritative surface

contract 和 registry 都还不够。

真正会决定源码质量判断稳定性的，是：

- 当前谁有权宣布真相

这就是 `authoritative surface`。

典型信号包括：

- `single source of truth`
- `authoritative`
- `single choke point`
- state machine / lifecycle guard

如果这一层没有先锁定，你就很容易从：

- 派生逻辑
- UI 投影
- 恢复路径
- adapter 局部缓存

去反推系统真相。

而 Claude Code 式的成熟度，正好体现在：

- 它会主动把权威入口暴露出来

## 5. 第四级：把 adapter subset 从协议全集里剥出来

公开镜像最容易被误读的一层，是：

- protocol full set vs adapter subset

因为协议全集里声明存在的能力，不等于每个 adapter、每个 host、每个入口都真的实现了它。

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
2. 当前 registry / authoritative surface 的清晰度
3. 当前 hotspot kernel 的职责是否可辩护
4. 当前 seam、命名、注释、state machine 是否足够诚实

但你不能稳定判断：

1. 缺失模块里一定还藏着什么“更完整实现”
2. 测试体系一定如何组织
3. feature-gated 能力在内部是否都和公开树同构

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
- stale writer 是否仍可达
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
3. 再锁定 authoritative surface，不从 UI 投影反推真相。
4. 再区分 adapter subset，不把协议全集和宿主子集混写。
5. 最后才审 hotspot kernel 是否是合法复杂度中心。
6. 每一步都保留 gap note，不让缺失部分被脑补补齐。

这套方法的目标不是：

- 更会赞美 Claude Code

而是：

- 形成一套可迁移的研究协议，去稳当地审任何公开镜像

## 10. 危险改动面 Atlas

当你已经完成 `contract -> registry -> authoritative surface -> adapter subset -> hotspot kernel` 分级后，下一步最值钱的不是继续夸“结构很稳”，而是把危险改动面点名出来。

更稳的 atlas 至少应包含下面几类面：

| 危险改动面 | 为什么危险 | 最小可见证据 | 最常见误判 |
|---|---|---|---|
| `QueryGuard / query lifecycle` | stale finally 最容易在这里重新获得清理权 | generation / forceEnd / running-dispatching boundary | 把它当普通并发细节 |
| `messages normalization / tool pairing` | display truth、protocol truth 与 continuation truth 最容易在这里分裂 | normalize / pair / boundary-after-compact | 把它当格式整理 |
| `session ingress / append chain` | 旧 head 假设最容易在这里重写当前真相 | `Last-Uuid` / `409 adopt` / retry ordering | 把它当远端同步噪声 |
| `bridge pointer / resume path` | recovery asset 最容易在这里篡位 present state | pointer TTL / freshest worktree / generation gate | 把它当体验性断点续连 |
| `host-facing state writeback` | event stream 最容易在这里冒充 current truth | single choke point / metadata clear / worker status upload | 把它当 UI 同步层 |
| `fresh-read file write path` | stale snapshot 最容易在这里重写 fresh filesystem state | read-before-write / staleness check / timestamp refresh | 把它当普通文件写入 |

这张 atlas 的作用不是再给目录贴标签，而是强迫 later maintainer 先回答：

1. 这里在保护哪一条不变量。
2. 这里最常复活的是哪类旧对象。
3. 改这里时至少要回放哪一种 drift。
4. 这里失败后，系统会重新退回哪一种第二真相。

## 11. 苏格拉底式检查清单

在你准备写下“这个仓库源码质量很高”前，先问自己：

1. 我现在看到的是 contract、registry、authoritative surface、adapter subset 还是 hotspot。
2. 我是否把“声明存在”“当前注册”“宿主实装”混成了一层。
3. 这个大文件是在维护统一 invariant，还是在四处补丁式接线。
4. 我是否同时审了 dependency honesty 与 temporal honesty。
5. 我写下的哪一句判断，是被可见证据支撑的；哪一句只是脑补。
6. 如果作者今天不解释，我的结论还能不能成立。

## 12. 一句话总结

公开镜像里的源码质量，不该靠目录树和大文件体感判断；更稳的顺序是 `contract -> registry -> authoritative surface -> adapter subset -> hotspot kernel -> mirror gap discipline`，并且同时审 `dependency honesty` 与 `temporal honesty`。
