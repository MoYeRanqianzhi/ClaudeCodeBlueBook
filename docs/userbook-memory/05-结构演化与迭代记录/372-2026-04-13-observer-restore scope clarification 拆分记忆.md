# observer-restore scope clarification 拆分记忆

## 本轮继续深入的核心判断

在上一刀已经把：

- `104-headless print 的 deferred suggestion staging 会留下 inert stale slot.md`

补成：

- `104` 只抓 cleanup asymmetry 与 staging inertness

之后，

当前更值钱的继续深入，

不是立刻回去补：

- `208`

做整组后设收束，

而是先让：

- `103-CCR 的 observer metadata 不是同一种恢复面.md`

自己在开头把页内主语收紧成一句。

## 为什么这轮值得单独提交

### 判断一：当前缺口不在“103 有没有讲 stale scrub vs restore”，而在“103 会不会被读成 metadata 总论，或 208 的恢复附录”

`103` 正文已经把这些层拆得很细：

- `SessionExternalMetadata` 是 bag，不是对称恢复契约
- `pending_action` / `task_summary` 是 transient observer metadata
- CCR startup 会先 scrub stale 值
- `GET /worker` readback 不等于 local restore adoption
- transcript/internal-event resume 与 metadata restore 是两条通道
- `permission_mode` / `is_ultraplan_mode` / `model` 与 observer metadata 的恢复合同并不相同

但如果读者在进入第一性原理前，

还没先被明确提醒：

- 这里不再重讲 52 页的 durable parameter restore 差异
- 这里也不在重讲 transcript/internal-event 的内容恢复真相

就仍然很容易把：

- metadata bag
- local restore path
- worker startup scrub
- `GET /worker` readback
- transcript resume

重新压回一句：

- “既然都在 external metadata 里，恢复时应该一起回来，只是实现上分散在不同函数里”

所以这一刀真正补的，

不是更多事实，

而是范围声明。

### 判断二：这句必须把 stable、conditional 与相邻通道一起点出来

并行只读分析和本地复核指向同一个风险：

- `103` 最容易把 bag 宽度、readback、scrub、restore adoption 压成一条“恢复通道”

如果只写：

- “这里只讲 observer metadata restore”

还不够稳，

因为读者仍可能把几层对象写平：

- stable contract：
  - `pending_action` / `task_summary` 不进入本地 restore path
  - startup scrub 是合同的一部分
- conditional / path-level evidence：
  - `GET /worker` 会读回 prior metadata
  - `externalMetadataToAppState(...)` 只恢复部分 durable config
  - `model` 另走单独 path
- adjacent but different channel：
  - transcript/internal-event resume
  - worker metadata recovery

所以当前最稳的说法必须同时说明：

- 本页主语是 observer metadata 是否构成可信 restore input
- bag / readback / scrub / local adoption 不是同一层
- transcript/internal-event resume 留在并行恢复通道，不并进同一条 metadata 恢复线

## 这轮具体怎么拆

这轮只做一件事：

1. 在 `103-CCR 的 observer metadata 不是同一种恢复面.md`
   的导语和第一性原理之间，
   增加一句范围声明：
   - 本页不重讲 `52` 的 durable parameter restore 差异
   - 也不重讲 transcript/internal-event resume 的内容恢复真相
   - 这里只拆 `pending_action` / `task_summary` 虽然也属于 `SessionExternalMetadata` bag，却为什么只享有 stale scrub first 的观察面合同，而不进入 `externalMetadataToAppState(...)` 或 `model` 那种本地 restore path
   - `GET /worker` readback、worker startup scrub、local restore adoption 分属不同恢复层

这样：

- `100 -> 103`
  这条侧枝终于在页首把主语说死
- `103`
  不再像一页 “external metadata 总论” 或 `208` 的恢复附录
- `208`
  之后再回头做整组收束时，
  `103` 的 observer-restore 主语会更稳

## 苏格拉底式自审

### 问：为什么不直接去补 `208`？

答：因为 `208` 讲的是 `100-104` 的跨页拓扑，而当前更前提的问题是 `103` 自己还没在页首把“我只抓 observer metadata stale scrub vs local restore”写成一句。先做后设总图，会让局部页主语继续发空。

### 问：为什么这句还要显式说“不重讲 52”？

答：因为 `103` 最容易被听成 52 页 durable parameter restore 的延长注脚。先把 durable config 与 observer metadata 的恢复待遇拆开，才能让 `103` 的侧枝主语真正成立。

### 问：为什么这句还要显式说“不重讲 transcript/internal-event resume”？

答：因为很多误写都来自把“恢复内容历史”与“恢复 metadata key”当成同一个动作。先把这条并行恢复通道从页首剥开，正文里的 bag/readback/scrub/adoption 分层才不会再塌。

### 问：为什么要把 `GET /worker` readback、startup scrub、local restore adoption 同时点出来？

答：因为 `103` 的难点不在某一个 API 名，而在这些动作看起来都叫“恢复”，但其实属于不同层的恢复合同。范围声明必须先把这三者拆开，后文的对象层级才稳。
