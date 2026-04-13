# governance-readme recovery-routing handoff 拆分记忆

## 本轮继续深入的核心判断

在：

- `02-能力地图/README.md`

已经补出 `恢复与连续性的横坐标` 之后，

下一刀不该同时去碰：

- `01-运行时主链/README.md`
- `03-治理与边界/README.md`
- `05-体验与入口/README.md`

而应只选一个 child README 做最小 handoff。

并行只读分析的共同结论是：

- 这一轮最值钱的落点是 `03-治理与边界/README.md`

## 为什么这轮值得单独提交

### 判断一：当前最缺的不是“是否已经有治理定义”，而是“治理页会不会误接恢复对象问题”

总 README 现在已经能把问题拆成两类：

- 恢复对象本身
- 这次继续是否仍被允许

但落到：

- `03-治理与边界/README.md`

之后，

当前文本只说：

- `continuity` 不是第四条治理线
- 它是 `decision window -> continuation pricing -> cleanup-before-resume`

还没有把另一半显式钉死：

- 这里不回答恢复对象本身

所以这一刀最小有效修正，

就是给治理 landing 页补一句否定式 handoff。

### 判断二：这一刀比去改 runtime 或 experience README 更稳

并行只读分析给出了三个可改候选：

- runtime README
- governance README
- experience README

但当前收益排序是：

1. governance README
2. runtime README
3. experience README

原因是：

- experience README 已经把 `projection / readback / consumer` 说得很硬
- runtime README 已经有 `projection != signer` 和 `continuity contract`
- governance README 则还没把“不是恢复对象本身”写成一眼可见的拒收句

所以本轮只改治理页，边界最清楚。

## 这轮具体怎么拆

这轮只做一件事：

1. 在 `03-治理与边界/README.md`
   现有的：
   - `continuity` 不是第四条治理线
   - `decision window -> continuation pricing -> cleanup-before-resume`
   后面，
   再补一句：
   - 这里判的是 `continuation pricing / cleanup-before-resume`，不是恢复对象本身；恢复对象仍回上层“恢复与连续性的横坐标”

这样：

- 上游横向路由表不再悬空
- 治理页不会误接 `resume / compact / memory / task recovery` 的对象分类
- `continuity` 也不会重新长回平行目录

## 苏格拉底式自审

### 问：为什么不优先改 `01-运行时主链/README.md`？

答：因为 runtime README 目前已经有 `projection != signer` 与 `continuity contract` 的边界。它还可以继续补强，但没有治理页这条缺口更硬。

### 问：为什么不同时把 `05-体验与入口/README.md` 也补上？

答：因为体验页此前已经明确：

- 它只翻译 `host / session / projection / display`
- `/status / /doctor / /usage / /resume / /remote-control`
  先只算 `projection / readback / consumer`

现在再一起改，只会把“一刀一个 handoff”重新做成并行重复维护。

### 问：这句为什么必须是否定句？

答：因为当前问题不是治理定义不够，而是 landing 页没把“不属于这里的问题”一眼踢出去。否定句比补更多散文更有效。
