# approval shell atlas 拆分记忆

## 本轮继续深入的核心判断

74-78 已经把 approval shell 拆成了五个局部：

- remote session remote ask
- remote/direct/ssh/bridge topology
- local modal family
- worker mailbox tool ask
- worker sandbox host ask

但如果不再往上压一层，读者仍会在脑中把它们重新混回：

- “反正都是 REPL 里的审批框”

所以这轮的任务不是再增加第六个局部，而是：

- 建一张总图

## 为什么这轮不再写新的实现切面

继续单点深挖当然还能写很多：

- teammate mailbox 消息族
- worker sandbox side effect
- bridge / worker / remote 的更多局部对照

但现在更缺的不是局部，而是：

- 统一命名坐标系

如果这一步不补，前五页会越来越厚，但心智模型仍是散的。

## 本轮最关键的新判断

### 判断一：真正稳定的总坐标不是组件名，而是四条轴

最稳的四轴是：

- `ask origin`
- `queue owner`
- `return path`
- `recheck meaning`

之后无论遇到新的 approval shell，先把它放进这四轴里，几乎都不会再误判。

### 判断二：74-78 至少对应五张不同的 authority map

这一步必须写出来，否则读者会继续以为：

- 74-78 只是一个主题的不同例子

更准确的是：

- 它们是五张不同的主权图

### 判断三：同款 UI / 同款组件 / 同款壳都不该当成最高层命名

这轮总图的价值正在于把：

- `PermissionRequest`
- `SandboxPermissionRequest`
- `ToolUseConfirm`
- `WorkerPendingPermission`

降回证据层，而不让它们继续霸占总纲命名。

## 苏格拉底式自审

### 问：为什么这轮应该写总览长文，而不是只加一张索引？

答：因为这里不只是对象表，还要回答：

- 为什么这些对象明明长得像同一类审批框，却落在五张主权图里

这个“为什么”需要因果链，不只是速查表。

### 问：为什么总图还要再补一张索引？

答：因为总图长文回答“为什么”，索引回答“我现在该去哪一页”。两者不是替代关系。

### 问：为什么总图不应该继续塞更多实现细节？

答：因为这页的任务是：

- 收束

不是：

- 再次扩散

所以只保留最稳的比较轴，把细节继续留在 74-78。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/79-approval shell atlas、ask origin、queue owner、return path 与 recheck meaning：为什么同一 REPL 审批外观背后其实是五张不同的主权图.md`
- `bluebook/userbook/03-参考索引/02-能力边界/68-Approval shell atlas、ask origin、queue owner、return path 与 recheck meaning 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/79-2026-04-06-approval shell atlas 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小改动：

- 不改旧索引结构
- 只在 68-79 连续链末端补一个 atlas 总览
- 索引层补一个 68 作为总入口

## 下一轮候选

1. 单独整理 teammate mailbox 在 permission / sandbox / plan approval 三条消息族上的协议谱系。
2. 把 68-79 再上收成一张“命令面 / tool plane / approval shell”三大簇索引。
3. 回到 76-78，继续拆 leader 本地 side effect 与 worker continuation 的状态分裂。
