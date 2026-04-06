# remote slash discoverability vs executability 拆分记忆

## 本轮继续深入的核心判断

第 68 页已经拆开：

- 启动期保守命令表
- 提示层命令表
- 提交期执行路由表

但还差一层更贴近用户输入瞬间的误判：

- 同一个 `/name` 在 remote mode 下会依次经过
  - 名字识别
  - 候选可见性
  - hidden 例外
  - enabled gate
  - local / remote 执行路由

如果不单独补这一批，正文还会继续犯六种错：

- 把高亮当成启用证明
- 把候选缺失当成远端不认
- 把 hidden 当成完全不可见
- 把 `commands` 里的对象存在性当成当前启用态
- 把 slash 命令统一写成本地先解释
- 把 discoverability / executability 重新混成一层

## 本轮最关键的源码纠偏

### 纠偏一：高亮层比候选层更“宽”

`PromptInput` 的高亮只经过：

- `hasCommand(...)`

它不看：

- `isHidden`
- `isCommandEnabled(...)`

而 `generateCommandSuggestions(...)` 明确对候选主列表过滤：

- `!cmd.isHidden`

因此：

- 能高亮

不等于：

- 会出现在常规候选里

### 纠偏二：候选层和启用层不是同一层

这次比上一批更重要的新发现是：

- 提示链里没有重新统一过 `isCommandEnabled(...)`

而提交链明确会再次检查：

- `isCommandEnabled(cmd)`

所以更准确的句子不是：

- “候选里能看到，就还是启用命令”

而是：

- “候选 UI 和执行路由对 enablement 的信任边界不一样”

### 纠偏三：`hidden` 不是二元消失，而是带 exact-match 例外

`commandSuggestions.ts` 给 hidden command 保留了一个精确命中回补路径。这个发现很关键，因为如果忽略它，正文会把：

- hidden

误写成：

- 完全不可见、完全不可命中

这会直接误导高级用户对 slash discoverability 的判断。

## 苏格拉底式自审

### 问：为什么这批不能塞回第 68 页？

答：第 68 页回答的是：

- 有三张不同意义上的命令表

本轮问题已经换成：

- 同一个 slash token 穿过哪些判定器后，才得到最终执行去向

也就是：

- one token, multiple predicates

不是：

- multiple command surfaces

### 问：为什么这批必须单写，而不是在第 68 页补一节？

答：因为这次真正补上的不是一个附属例子，而是一个新的分析维度：

- 判定器链

上一批讨论的是“表”；这一批讨论的是“判定器”。对象已经变了。

### 问：为什么这批必须强调 `isHidden` 与 `isCommandEnabled(...)` 分离？

答：因为这正是 UI 误判的根。只要把两者压成一层，读者就会继续把：

- 看得见 / 看不见

和：

- 此刻能不能算启用命令

混写成一锅。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/69-hasCommand、isHidden、isCommandEnabled、local-jsx 与 remote send：为什么 remote mode 里的 slash 高亮、候选补全、启用态与实际执行去向不是同一个判定器.md`
- `bluebook/userbook/03-参考索引/02-能力边界/58-Remote slash discoverability、hidden exact、enabled gate 与 raw-send routing 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/69-2026-04-06-remote slash discoverability vs executability 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 正文落笔纪律

### 应写进正文的

- 高亮为什么只证明名字匹配
- 候选为什么主要受 `isHidden` 支配
- hidden exact match 为什么值得单独写
- `isCommandEnabled(...)` 为什么是更靠近执行的 gate
- remote mode 为什么只本地截启用中的 `local-jsx`

### 不应写进正文的

- 第 68 页“三张命令表”整段复述
- 各个命令对象具体 `isEnabled()` 实现
- Fuse 排序与 suggestion item 去重细节
- 作者对“为什么产品故意这么设计”的猜测性动机

这些继续留在记忆层。

## 下一轮继续深入的候选问题

1. remote mode 下 plugin / MCP prompt commands 的 discoverability 为什么仍比本地 REPL 更薄？
2. `disableSlashCommands` 把 `commands` 清空后，remote send 路由还剩下什么语义？
3. direct connect / bridge inbound / remote session submit 三种 slash 输入路径，对 `local` / `prompt` / `local-jsx` 的解释权是否还能继续交叉拆分？

只要这三问没答清，后续继续深入时仍容易把：

- UI 认得什么
- 系统愿意建议什么
- 当前算不算启用
- 最终去哪执行

重新压回一句模糊的“命令可见性”。
