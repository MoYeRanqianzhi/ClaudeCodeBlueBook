# bridge history projection split 拆分记忆

## 本轮继续深入的核心判断

181 已经拆开：

- session birth
- history hydrate

183 已经拆开：

- wire slot
- local seed
- real delivery ledger

但 bridge 初始历史仍缺一句更窄的判断：

- history replay 不等于 prompt replay

本轮要补的更窄一句是：

- `initialHistoryCap`、`isEligibleBridgeMessage(...)`、`toSDKMessages(...)` 与 `local_command` 应分别落在 capped eligible replay、remote consumer projection、UI replay budget 与 prompt-authority contrast 四层

## 为什么这轮必须单列

如果不单列，正文最容易在四种偷换里回卷：

- 把 bridge initial flush 写成模型历史重喂
- 把 `initialHistoryCap` 写成上下文裁剪
- 把 `isEligibleBridgeMessage(...)` 和 `toSDKMessages(...)` 写成同一层过滤
- 把 `local_command` 的 bridge 角色与 prompt 角色压成同一种可见性

这四种都会把：

- bridge replay
- remote consumer payload
- model prompt authority

重新压扁。

## 本轮最关键的新判断

### 判断一：`isEligibleBridgeMessage(...)` 是 bridgeable source-family gate，不是 prompt gate

### 判断二：`toSDKMessages(...)` 是 remote consumer projection，不是 source-family eligibility

### 判断三：`initialHistoryCap` 控的是 UI replay persistence budget，不是 model token budget

### 判断四：`local_command` 在 bridge replay 与 prompt assembly 中分属不同 pipeline

### 判断五：v1 / v2 共享 eligible-then-cap 形态，但 dedup 差异不该吞掉本页主语

## 苏格拉底式自审

### 问：为什么这页不是 181 的附录？

答：181 讲的是 create vs hydrate；186 讲的是 replay 对象本身不等于 prompt authority。一个问时序合同，一个问对象边界。

### 问：为什么一定要把 `utils/messages.ts` 拉进来？

答：因为如果没有 prompt assembly 的对照，就无法证明 “UI-only” 说的是 bridge replay pipeline，而不是 source message 全局永不进模型。

### 问：为什么不顺手把 dedup 也一起讲完？

答：因为那会把本页重新拖回 183 的 ledger 主语，读者就看不到真正新增的句子：bridge replay 的对象根本不是 prompt authority。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/186-initialHistoryCap、isEligibleBridgeMessage、toSDKMessages 与 local_command：为什么 bridge 的 eligible history replay 不是 model prompt authority.md`
- `bluebook/userbook/03-参考索引/02-能力边界/175-initialHistoryCap、isEligibleBridgeMessage、toSDKMessages 与 local_command 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/186-2026-04-08-bridge history projection split 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 长文层只补 186
- 索引层只补 175
- 记忆层只补 186

不回写 181、183、115。

## 下一轮候选

1. 若回到 model 线，可单列 `mainLoopModelOverride` 作为统一 writer register 的语义，但必须避免和 185 只差一句话。
2. 若继续 bridge 线，可单列 v1 / v2 在 `previouslyFlushedUUIDs` 上的差异，但必须避免把 183 重写一遍。
3. allowlist admission 与 source selection 的错位仍是可行候选，但更适合等 model 线重新出现空档时再写。
