# initial message ledger split 拆分记忆

## 本轮继续深入的核心判断

182 已经把 model 这条线拆成：

- create-time stamp
- live shadow
- durable usage
- resumed fallback

但 bridge 初始历史这条线里还缺一句更窄的判断：

- 带着 initial message UUID 的集合，也不等于共享同一种历史账

本轮要补的更窄一句是：

- `initialMessageUUIDs`、`previouslyFlushedUUIDs`、`createBridgeSession.events` 与 `writeBatch(...)` 应分别落在 local dedup seed、real delivery ledger、wire slot 与 success write 四层

## 为什么这轮必须单列

如果不单列，正文最容易在三种偷换里回卷：

- 把 `initialMessageUUIDs` 写成建会话时已送达的历史集合
- 把旧注释里的 session creation events 当成当前实现证据
- 把 `previouslyFlushedUUIDs` 写成 `initialMessageUUIDs` 的一个缓存副本

这三种都会把：

- wire slot
- local seed
- success ledger

重新压扁。

## 本轮最关键的新判断

### 判断一：`createBridgeSession.events` 在当前 bridge 实现里不是初始历史送达路径

### 判断二：`initialMessageUUIDs` 先是由 `initialMessages` 派生出来的 local dedup seed

### 判断三：`writeMessages()` 注释里的 “messages sent as session creation events” 叙述已经落后于当前实现

### 判断四：`previouslyFlushedUUIDs` 只有在 `writeBatch(...)` 成功后才构成真实 delivery ledger

### 判断五：`writeMessages()` 同时检查 `initialMessageUUIDs` 与 `recentPostedUUIDs`，恰好说明本地防重不等于 remote delivery truth

## 苏格拉底式自审

### 问：为什么这页不是 181 的附录？

答：181 讲 birth vs hydrate；183 讲在这条结论已经成立之后，哪个 UUID 集合才配叫“真实历史账”。

### 问：为什么一定要把旧注释单独拉出来？

答：因为不把这句旧注释钉死，读者会继续把 `initialMessageUUIDs` 误当成 create-time delivery proof，而不是 local dedup seed。

### 问：为什么一定要把 `previouslyFlushedUUIDs` 写成 success ledger？

答：因为只有把写回时机压到 `writeBatch(...)` 成功之后，才能直接说明“server 已持久化”与“本地先播种 dedup”不是同一时刻。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/183-initialMessageUUIDs、previouslyFlushedUUIDs、createBridgeSession.events 与 writeBatch：为什么注释里的 session creation events 不等于 bridge 的真实历史账.md`
- `bluebook/userbook/03-参考索引/02-能力边界/172-initialMessageUUIDs、previouslyFlushedUUIDs、createBridgeSession.events 与 writeBatch 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/183-2026-04-08-initial message ledger split 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 长文层只补 183
- 索引层只补 172
- 记忆层只补 183

不回写 54、55、181、182。

## 下一轮候选

1. 若继续沿 model 线往下拆，可再写 `settings.model`、override cascade 与 resumed agent model precedence，但必须避免回卷到 52 / 107 / 182。
2. 若继续沿 bridge 线往下拆，可再写 `initialHistoryCap` 与 “UI-only history” 的对象边界，但必须避免回卷到 54 / 181。
3. `createBridgeSession.source` 与 `BridgePointer.source` 仍暂不再优先单列：高重叠回卷到 175 / 177。
