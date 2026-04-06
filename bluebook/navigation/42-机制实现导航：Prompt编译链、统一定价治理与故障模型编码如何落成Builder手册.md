# 机制实现导航：message lineage、governance key 与 authority object 如何落成 Builder 手册

实现层真正要固定的，不是三组旧名词，而是三条 builder-facing 对象链：

- Prompt: `message lineage -> projection consumer -> protocol transcript -> continuation object -> continuation qualification`
- Governance: `governance key -> externalized truth chain -> typed ask -> decision window -> continuation pricing -> rollback / durable-transient cleanup`
- Structure: `authority object -> authoritative path -> per-host authority width -> event-stream-vs-state-writeback -> freshness gate -> stale worldview / ghost capability`

## 1. Prompt 编译链实现线

实现顺序优先固定这些对象：

1. `message lineage` 的三键内核与 section registry / stable prefix boundary 的准入律。
2. display、model API、SDK/control、handoff/resume 四类 `projection consumer`。
3. model-facing 的 `protocol transcript` 重写与合法化。
4. compact、resume、handoff 共用的 `continuation object`。
5. 当前是否仍配继续的 `continuation qualification`。

阅读顺序：

1. `../philosophy/84`
2. `../architecture/82`
3. `../guides/99`
4. `../guides/51`

这条线的核心不是再夸一次 Prompt 魔力，而是把世界怎样进入模型、怎样合法遗忘、怎样继续交接，压成实现者真的可以照着搭的对象顺序。

## 2. 统一定价治理实现线

实现顺序优先固定这些对象：

1. `governance key`
2. `externalized truth chain`
3. `typed ask`
4. `decision window`
5. `continuation pricing`
6. `rollback / durable-transient cleanup`

其中：

- `authority source` 只是 `governance key` 的 source slot。
- `Context Usage` 与 `pending_action` 只是 `decision window` 的证据面。
- `continuation gate` 只是 `continuation pricing` 的一个 verdict 字段。
- `rollback object` 只是 cleanup / handoff 的一个 carrier。

阅读顺序：

1. `../philosophy/85`
2. `../architecture/83`
3. `../guides/100`
4. `../guides/49`
5. `../guides/52`

这条线的核心不是把 mode、弹窗、token 条和 rewind 动作排成表，而是把动作、能力、上下文、时间与 cleanup 写成一条单一控制面。

## 3. 故障模型编码实现线

实现顺序优先固定这些对象：

1. `authority object`
2. `authoritative path`
3. `per-host authority width`
4. `event-stream-vs-state-writeback`
5. `freshness gate`
6. `stale worldview / ghost capability`

阅读顺序：

1. `../philosophy/86`
2. `../architecture/84`
3. `../guides/101`
4. `../guides/53`

这条线的核心不是做结构美学陈述，而是把谁能写当前真相、谁只能读局部宽度、哪些旧 writer 必须先被 freshness gate 撤权，压成可执行工程动作。

## 4. 为什么实现层更适合落在 guides

因为这里真正要固定的是：

1. 对象实现顺序不能怎样调换。
2. 哪些字段属于 root object，哪些只是下游证据或投影。
3. 哪些错误边界必须硬拒收。
4. 宿主、SDK、控制面与交接链分别该消费哪些正式对象。

这些问题都更接近 builder 手册，而不是机制哲学。

## 5. 苏格拉底式自检

在你准备宣布“我们已经学会这套机制”前，先问自己：

1. 我现在实现的是 root chain，还是一组熟悉的旧字段。
2. 哪个 consumer 该吃哪个 projection，我是否已经明确分层。
3. 发生 drift 时，我是否知道要先回哪个对象、哪个边界、哪个 verdict。
4. 我写出来的是一条可迁移的实现顺序，还是一组只能靠作者解释的术语。
