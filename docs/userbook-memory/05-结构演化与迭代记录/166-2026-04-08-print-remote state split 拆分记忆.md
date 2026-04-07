# print-remote state split 拆分记忆

## 本轮继续深入的核心判断

165 已经把 `print` remote 路径拆成 transcript hydrate、metadata refill、startup fallback 三张账。

但正文还缺一个更细的状态结论：

- transcript、metadata 与 emptiness 这三层彼此之间也不是同一种 state dimension

本轮要补的更窄一句是：

- `print` remote recovery 不能再被写成单一“远端恢复成功/失败”，而要拆成文件层、状态层、解释层三张账

## 为什么这轮必须单列

如果不单列，正文最容易在三种偷换里回卷：

- 把 metadata refill 写成 hydrate 的附带动作
- 把 emptiness fallback 写成 hydrate 失败
- 把 v2 internal events 和 observer metadata refill 再次混成一条链

这三种都会把：

- transcript
- metadata
- emptiness interpretation

重新压扁。

## 本轮最关键的新判断

### 判断一：transcript hydrate 只保证本地文件可读

### 判断二：metadata refill 只保证 headless runtime shadow 被补齐

### 判断三：emptiness fallback 只负责解释空结果最后该去 startup 还是失败

### 判断四：CCR v2 比 ingress 多出独立的 metadata lane

### 判断五：startup fallback 的输出是新 hook payload，不是旧恢复结果残片

## 苏格拉底式自审

### 问：为什么这页不是 165 的附录？

答：因为 165 还是“更宽的 remote recovery 初拆”；166 继续把 transcript / metadata / emptiness 三层写成不同 state dimension。

### 问：为什么一定要把 emptiness 单列？

答：因为这是最容易被误写成“hydrate 失败”的层，但它本质上是解释学，不是 IO 成败。

### 问：为什么一定要写 CCR v2 vs ingress 的差异？

答：因为只有这样才能说明 metadata refill 不是所有 remote hydrate 路径都天然拥有的附带效果。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/166-print.ts、externalMetadataToAppState、setMainLoopModelOverride 与 startup fallback：为什么 print remote recovery 的 transcript、metadata 与 emptiness 不是同一种 stage.md`
- `bluebook/userbook/03-参考索引/02-能力边界/155-print.ts、externalMetadataToAppState、setMainLoopModelOverride 与 startup fallback 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/166-2026-04-08-print-remote state split 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 长文层只补 166
- 索引层只补 155
- 记忆层只补 166

不回写 163、165。

## 下一轮候选

1. 继续拆 interactive live `/resume` 与 startup direct resume 为什么共享 restore contract，却不是同一种 session-unwind stage。
2. 继续拆 CCR v2 remote metadata refill 与更宽的 observer metadata 消费为什么不是同一种状态回填面。
