# 按阶段反查表：从design到evolution定位制度断裂点

这一章把参考层继续压成阶段优先的诊断表。

它主要回答四个问题：

1. 一次制度失效究竟是在设计、组装、运行、恢复还是演化阶段被放进系统。
2. 怎样避免把 design debt 误判成 runtime 抖动。
3. 怎样从生命周期位置直接回到正文、手册与样本。
4. 怎样用苏格拉底式追问避免把阶段表写成时间线装饰。

## 0. 第一性原理

很多看似“运行时发生”的问题，其实在更早阶段就已经决定了命运。

所以阶段反查表的价值，不在于给问题加时间戳，而在于判断：

- 问题最早是在哪个阶段获得了合法进入系统的机会

阶段反查优先于模块反查，因为制度失效首先是在某个时间层开始说谎，而不是先在某个文件里报错。

## 1. 阶段优先表

| 阶段 | 典型失效 | 首查入口 | 再查入口 | 第一性原理解释 | 常见自欺式误读 |
| --- | --- | --- | --- | --- | --- |
| `design` | `section drift / order violation / build-surface pollution` | `../navigation/08 / ../guides/24-26` | `01-03 / ../philosophy/60-62` | design 阶段决定哪些对象被允许成为正式制度资产，后面很多故障只是把早期错误显影出来。 | “先上线再补治理，运行时再说。” |
| `assembly` | `path parity split / boundary compile error / transport leakage` | `01 / 03 / ../api/30` | `../architecture/39 / ../architecture/59 / ../philosophy/45` | assembly 决定同一制度对象是否沿着同一条合法路径进入 runtime。 | “这只是 glue code，不影响设计本质。” |
| `runtime` | `wrong allow / wrong deny / approval-race degradation / split truth` | `02 / ../playbooks/02 / ../architecture/23` | `../architecture/47 / ../philosophy/58 / ../philosophy/61` | runtime 是权威状态、检查顺序和决策代价真正碰撞的地方。 | “模型偶尔发挥失常，所以看起来不稳定。” |
| `recovery` | `lawful-forgetting failure / replay mismatch / stale state / recovery-asset corruption` | `01 / 03 / ../architecture/60` | `../playbooks/01 / ../playbooks/03 / ../philosophy/47` | 恢复的目标不是回放历史，而是重新站回当前合法真相。 | “只要能 resume，就算恢复成立。” |
| `evolution` | `shadow fossilization / registry obesity / zombification` | `03 / ../playbooks/03 / ../guides/26` | `../philosophy/53 / ../philosophy/62 / ../architecture/75` | 演化阶段暴露的是系统是否为未来修改、退出 compat 和反 zombie 留出了制度出口。 | “这只是技术债慢慢多了一点。” |

## 2. 使用协议

当你已经知道“问题大概诞生在什么时候”，但还不知道先查哪条文档链时：

1. 先用本页锁定生命周期位置。
2. 再回 `04` 给这次问题补阶段标签。
3. 再进入对应样本、手册与解释层。

## 3. 苏格拉底式追问

在你准备把问题一概归因给 runtime 前，先问自己：

1. 这个问题是在运行时被触发，还是在更早阶段就被允许进入系统。
2. 我是在找第一现场，还是在找最后爆炸的位置。
3. 如果把组装错误误判成运行时错误，会不会把真正该改的制度对象漏掉。
4. 阶段标签是否真的帮助团队缩短修复路径。
