# remote command surface is not one table 拆分记忆

## 本轮继续深入的核心判断

第 67 页已经拆开：

- `slash_commands`、`stream_event`、`task_*`、`compacting` 分属不同消费者

但还缺一层更贴近“用户如何实际使用”的说明：

- remote session 里的命令系统不是一张表
- 至少分成启动期保守表、提示层保留表、提交期执行路由表

如果不单独补这一批，正文会继续犯五种错：

- 把 `slash_commands` 写成 remote mode 的唯一命令真相
- 把 `REMOTE_SAFE_COMMANDS` 只写成实现细节
- 把 slash 高亮 / typeahead 误写成远端执行面
- 把 `local-jsx` 的本地旁路漏掉
- 把 “补全里没有” 误写成 “远端一定不能执行”

## 本轮最关键的源码纠偏

### 纠偏一：`handleRemoteInit(...)` 是过滤器，不是注入器

这次最大的认知修正不是：

- “远端会发布 `slash_commands`”

而是：

- `REPL.tsx` 用的是 `prev.filter(...)`

所以这步更接近：

- 对当前本地已知命令对象做保留过滤

不是：

- 依据远端名字重建一张新的完整命令表

### 纠偏二：remote mode 真正决定执行去向的是 `onSubmit(...)`

高亮与 typeahead 虽然都看 `commands`，但真正分流发生在：

- `REPL.tsx` 的 remote submit path

核心判定是：

- 当前输入若被本地识别为 `local-jsx`，则留本地执行
- 否则原样送 remote

这说明：

- discoverability
- executability

不是同一个平面。

### 纠偏三：`filterCommandsForRemoteMode(...)` 让启动期先天保守

`main.tsx` 在进入 remote session 前就预过滤命令，目的不是表达远端能力总表，而是：

- 防止 `init` 前 race 暴露整套本地 slash commands

因此启动时看到的第一张命令面，本质是：

- 本地安全控制面

不是：

- 远端发布能力面

## 苏格拉底式自审

### 问：为什么这批不能塞回第 67 页？

答：第 67 页回答的是：

- 哪类 remote 事件喂给哪种本地消费者

本轮问题已经换成：

- 命令提示面与执行路由面为什么不是一层

也就是：

- command-surface decomposition

不是：

- remote event-family to consumer mapping

### 问：为什么不能简单写成“远端发布命令 + 本地保留命令”？

答：因为还缺第三层：

- submit routing

如果不把执行路由单独拆开，正文仍然会暗示：

- 能看到什么 = 会怎么执行

而源码恰恰证明两者不是同一条判定链。

### 问：为什么这批必须从第一性原理重写，而不是补几句实现说明？

答：因为读者真正会问的是：

- “我为什么在补全里看不到它，却仍可能让远端执行？”

这是使用层问题，不是实现层问题。只有把“启动可见性 / 提示可见性 / 提交路由”作为三个不同对象，正文才不会再次滑向源码备忘录口吻。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/68-slash_commands、REMOTE_SAFE_COMMANDS、local-jsx fallthrough 与 remote send：为什么 remote session 的远端发布命令面、本地保留命令面与实际执行路由不是同一张命令表.md`
- `bluebook/userbook/03-参考索引/02-能力边界/57-Remote slash_commands、REMOTE_SAFE_COMMANDS 与 local-jsx remote routing 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/68-2026-04-06-remote command surface is not one table 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 正文落笔纪律

### 应写进正文的

- 启动期为什么先看见 `REMOTE_SAFE_COMMANDS`
- `slash_commands` 为什么更像保留过滤器
- prompt input 的高亮 / typeahead 为什么只代表提示层
- `local-jsx` 为什么在 remote mode 下仍留本地
- “本地提示面”和“实际执行路由面”为什么不是一张表

### 不应写进正文的

- 第 67 页的 event-family 复述
- 第 58 页的 viewer ownership 复述
- 过细的命令对象构造、别名解析与实现常量
- 作者对“为什么用 `prev.filter(...)`”的猜测性动机

这些只保留为作者判断依据。

## 下一轮继续深入的候选问题

1. remote mode 下“未知 slash command 仍可 raw send”的边界，是否要单独拆出 discoverability vs executability 专题？
2. plugin / MCP command 在 remote session 中的可见性为什么比本地 REPL 更薄？
3. `local-jsx` 之外的 `local` 命令与 `prompt` 命令，在 remote / bridge / direct-connect 三种远端模式中的可执行性是否还能继续交叉对照？

只要这三问没答清，后续继续深入时仍容易把：

- 可见性
- 所有权
- 执行位置

重新压回同一张“命令表”。
