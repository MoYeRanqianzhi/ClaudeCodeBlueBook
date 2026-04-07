# post-turn-summary visibility ladder 拆分记忆

## 本轮继续深入的核心判断

139 已经把 mirror 的 startup intent / routing / runtime topology 分开。

接下来如果不再把 `post_turn_summary` 继续压细，正文又会滑成：

- “它要么可见，要么不可见。”

这轮要补的更窄一句是：

- `post_turn_summary` 的 wide-wire、`@internal` 与 foreground narrowing 不是同一种可见性

## 为什么这轮必须单列

如果不单列，正文最容易在三种误写里摇摆：

- 把 `@internal` 写成完全不可见
- 把 stdout wire 接纳写成 core SDK / foreground 已接纳
- 把 callback / terminal narrowing 写成 raw wire 根本不存在

这三种都会把：

- schema existence
- stdout wire admissibility
- core SDK contract
- callback / terminal semantics

重新压扁。

## 本轮最关键的新判断

### 判断一：`SDKPostTurnSummaryMessageSchema` 先证明它是正式建模的 family

### 判断二：schema 描述里的 `@internal` 说明它属于更灰的内部可见层，不等于完全不可见

### 判断三：`StdoutMessageSchema` 接纳它，说明它具备 wide-wire visibility

### 判断四：`SDKMessageSchema` 不接纳它，说明它不属于 core SDK-visible 主合同

### 判断五：`print.ts` / `directConnectManager.ts` 的主动 narrowing 说明 foreground consumer 还在继续收窄它

## 苏格拉底式自审

### 问：为什么不能只说“它不是 core SDK-visible”？

答：因为这句话仍然没说清它还能在哪一层被看见，仍然容易被误读成“完全不可见”。

### 问：为什么一定要把 `print.ts` 和 `directConnectManager.ts` 一起拉进来？

答：因为一个说明 terminal semantic narrowing，一个说明 callback narrowing，二者共同构成 visibility ladder 的下半段。

### 问：为什么一定要把 `@internal` 单独写出来？

答：因为它正好卡在“schema 已存在”和“foreground 还没接纳”之间，是最容易被压扁的一层灰度语义。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/140-SDKPostTurnSummaryMessageSchema、StdoutMessageSchema、SDKMessageSchema、print.ts 与 directConnectManager：为什么 post_turn_summary 的 wide-wire、@internal 与 foreground narrowing 不是同一种可见性.md`
- `bluebook/userbook/03-参考索引/02-能力边界/129-SDKPostTurnSummaryMessageSchema、StdoutMessageSchema、SDKMessageSchema、print.ts 与 directConnectManager 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/140-2026-04-07-post-turn-summary visibility ladder 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 长文层只补 140
- 索引层只补 129
- 记忆层只补 140

不扩目录，不回写旧页。

## 下一轮候选

1. 单独拆 remote-session presence ledger 为什么不会自动被 direct connect / ssh remote 复用。
2. 单独拆 hook 侧 outboundOnly 本地语义与 env-based core 双向 wiring 为什么会形成 gray runtime。
3. 单独拆 `post_turn_summary` 在 raw stream、callback surface 与 terminal semantics 三层为什么不是同一种 “可见”。
