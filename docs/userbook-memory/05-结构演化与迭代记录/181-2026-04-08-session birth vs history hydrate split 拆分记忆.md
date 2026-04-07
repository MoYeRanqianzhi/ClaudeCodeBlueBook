# session birth vs history hydrate split 拆分记忆

## 本轮继续深入的核心判断

180 已经把 teleport runtime 拆成：

- repo admission
- branch replay

但 bridge create / replay 链里还缺一句更窄的判断：

- session object 的出生，不等于已有对话历史的持久化

本轮要补的更窄一句是：

- `createBridgeSession.events`、`initialMessages`、`previouslyFlushedUUIDs` 与 `writeBatch(...)` 应分别落在 session birth 与 history hydrate 两层

## 为什么这轮必须单列

如果不单列，正文最容易在三种偷换里回卷：

- 把 `events` 这个 API 槽位写成当前 bridge 历史默认走的机制
- 把 empty initial session 写成“只是没带全历史的同一种 create-with-history”
- 把 `previouslyFlushedUUIDs` 误写成 create-time event ledger

这三种都会把：

- session birth
- history hydrate

重新压扁。

## 本轮最关键的新判断

### 判断一：`createBridgeSession(...)` 虽然暴露 `events`，但当前 bridge caller 实际传 `events: []`

### 判断二：`initReplBridge(...)` 已经拿到 `initialMessages`，却仍故意不把它们转成 create-time events

### 判断三：`replBridge.ts` 明确把 session creation events 判为不适合承担历史回放，因为 `STREAM_ONLY` 时序下 UI 会丢失它们

### 判断四：真正的历史回放发生在 ingress transport `writeBatch(...)` 的 post-connect flush

### 判断五：`previouslyFlushedUUIDs` 属于 hydrate dedup ledger，不属于 session birth ledger

## 苏格拉底式自审

### 问：为什么这页不是 54 的附录？

答：54 讲 transport continuity / flush state machine；181 讲 create-time events 为何不是 history hydrate 机制。两页都出现 initial flush，但主语不同。

### 问：为什么一定要把 37 / 39 拉进来做边界？

答：因为不把 initial empty session seed 与 title seed 的旧页边界写清，读者会把“预创建一个空会话”误读成“已经把历史一起播进去了”。

### 问：为什么一定要把 `previouslyFlushedUUIDs` 写进去？

答：因为没有 dedup ledger 这层，读者仍可能把 later flush 误看成建会话时的一次性附带动作，而不是独立的历史持久化阶段。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/181-createBridgeSession.events、initialMessages、previouslyFlushedUUIDs 与 writeBatch：为什么 session-create events 不是 remote-control 历史回放机制.md`
- `bluebook/userbook/03-参考索引/02-能力边界/170-createBridgeSession.events、initialMessages、previouslyFlushedUUIDs 与 writeBatch 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/181-2026-04-08-session birth vs history hydrate split 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 长文层只补 181
- 索引层只补 170
- 记忆层只补 181

不回写 37、39、54、180。

## 下一轮候选

1. 继续拆 `session_context.model` 与 live / durable model ledger：为什么 session-create model stamp 不是同一种 runtime model truth。
2. 若继续沿 bridge create / replay 链往下拆，可再写 `initialMessageUUIDs` 注释语义与真实 flush ledger 的错位，但必须比本轮更窄，避免回卷到 54。
3. `createBridgeSession.source` 与 `BridgePointer.source` 仍暂不再优先单列：高重叠回卷到 175 / 177。
