# headless transport recovery thickness split 拆分记忆

## 本轮继续深入的核心判断

167 已经把：

- `restoredWorkerState`
- metadata readback
- local consumption

拆开了。

但正文还缺一句更底层的宿主判断：

- 同属 headless protocol family，`StructuredIO` 与 `RemoteIO` 也不是同一种恢复厚度

本轮要补的更窄一句是：

- protocol runtime、recovery ledger 与 persistence backpressure 不该继续被写成同一种 transport thickness

## 为什么这轮必须单列

如果不单列，正文最容易在三种偷换里回卷：

- 把 `StructuredIO` 写成天然带着 resume / flush / pending 账本的 headless 宿主
- 把 internal events 写成另一种普通前台消息流
- 把 `flushInternalEvents()` 写成 finally 里的实现噪音，而不是 shutdown discipline

这三种都会把：

- protocol shell
- recovery ledger
- persistence backpressure

重新压扁。

## 本轮最关键的新判断

### 判断一：`StructuredIO` 默认只有 protocol runtime，没有恢复厚度

### 判断二：`RemoteIO` 在同一家族里通过 reader / writer / flush / pending override 加厚恢复账本

### 判断三：`sessionStorage` 的 internal-event reader / writer 明确服务 transcript 持久化与 resume，不是前台消息流

### 判断四：`hydrateFromCCRv2InternalEvents()` 的厚度覆盖 foreground 与 subagent transcript

### 判断五：`print.ts` 会在 shutdown/idle 边界显式承认这本恢复账的背压

## 苏格拉底式自审

### 问：为什么这页不是 20 的附录？

答：因为 20 讲 headless vs interactive 宿主切换；168 讲同属 headless family 时的 thin vs thick transport。

### 问：为什么这页不是 167 的附录？

答：因为 167 讲 metadata bag vs local sink；168 讲 protocol shell vs recovery ledger vs persistence backpressure。

### 问：为什么一定要把 `setInternalEventReader/Writer(...)` 拉出来？

答：因为只有把注册点写出来，才能说明当前讨论的不是普通 stream，而是恢复账本。

### 问：为什么一定要写 `internalEventsPending`？

答：因为这能把“这本账还没刷完”正式写成 runtime 关闭时要观察的对象，而不是隐藏实现细节。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/168-StructuredIO、RemoteIO、setInternalEventReader、setInternalEventWriter 与 flushInternalEvents：为什么 headless transport 的协议宿主不等于同一种恢复厚度.md`
- `bluebook/userbook/03-参考索引/02-能力边界/157-StructuredIO、RemoteIO、setInternalEventReader、setInternalEventWriter 与 flushInternalEvents 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/168-2026-04-08-headless transport recovery thickness split 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 长文层只补 168
- 索引层只补 157
- 记忆层只补 168

不回写 20、50、162、167。

## 下一轮候选

1. 继续拆 `/resume`、`--continue`、`print --resume` 与 `remote-control --continue`：为什么 stable conversation resume、headless remote hydrate 与 bridge continuity 不是同一种接续来源。
2. 继续拆 `writeEvent`、`writeInternalEvent`、`flush()` 与 `flushInternalEvents()`：为什么 client-visible stream 与 recovery-only ledger 不是同一种交付账本。
