# disableSlashCommands does not kill remote slash ingress 拆分记忆

## 本轮继续深入的核心判断

第 69 页已经拆开：

- 高亮
- 候选
- enabled gate
- 本地旁路
- remote send

但还缺一个更容易让用户误判的总开关：

- `disableSlashCommands`

如果不单独补这一批，正文还会继续犯五种错：

- 把 `commands=[]` 写成 slash 文本被禁
- 把本地 slash UI 消失写成远端 slash 语义消失
- 把 `disableSlashCommands` 只写成显示层开关
- 漏掉 `local-jsx` 旁路也会一起失效
- 漏掉 remote mode 仍可能 raw send `/xxx`

## 本轮最关键的源码纠偏

### 纠偏一：这个开关真正切的是“本地命令层”

关键代码不是某个 UI 组件，而是：

- `const commands = useMemo(() => disableSlashCommands ? [] : mergedCommands, ...)`

这说明开关并不是：

- 单独禁掉高亮
- 单独禁掉候选

而是直接把支持这些能力的命令对象集合整体清空。

### 纠偏二：slash 语法层仍然活着

`REPL.tsx` 仍然用：

- `input.trim().startsWith('/')`

来判断 `isSlashCommand`

这说明：

- `/foo`

在字面形态上仍然是 slash 输入。

### 纠偏三：remote send 仍然可以吃这段文本

这一批最关键的边界不是“slash UI 没了”，而是：

- 在 remote mode 下，只要本地没有命中启用中的 `local-jsx`
- REPL 就会把 `input.trim()` 作为 `remoteContent` 发给远端

因此：

- `disableSlashCommands`

并不自动等于：

- `disable remote slash text ingress`

## 苏格拉底式自审

### 问：为什么这批不能塞回第 69 页？

答：第 69 页回答的是：

- 同一个 slash token 穿过哪些判定器

本轮问题已经换成：

- 一个上游总开关如何同时拿掉本地判定器链，却不自动拿掉远端文本入口

也就是：

- global suppression vs residual remote ingress

不是：

- token predicate chain

### 问：为什么这批必须单独写？

答：因为用户在真实使用里最容易问的不是：

- “哪个判定器先跑？”

而是：

- “我都把 slash commands 关了，为什么 `/foo` 还像是能发出去？”

这是一个更直接的使用层问题，值得单独成页。

### 问：为什么这批必须强调 remote mode？

答：因为“本地 slash 层消失但远端文本入口仍在”这一现象，只有 remote mode 下才最清晰。放回纯本地 REPL 里，这个差异就不成立。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/70-disableSlashCommands、commands=[]、hasCommand 与 remote send：为什么关掉本地 slash 命令层，不等于 remote mode 失去 slash 文本入口.md`
- `bluebook/userbook/03-参考索引/02-能力边界/59-Remote disableSlashCommands、commands=[] 与 slash raw-send 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/70-2026-04-06-disableSlashCommands does not kill remote slash ingress 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 正文落笔纪律

### 应写进正文的

- 入口旗标如何透传到 REPL
- `commands=[]` 为什么是这批的中心事实
- slash 高亮 / 候选 / `local-jsx` 旁路为何一起消失
- remote mode 下 `/xxx` 为什么仍可能 raw send
- “关掉本地 slash 命令层”与“失去 slash 文本入口”为什么不是一回事

### 不应写进正文的

- 第 69 页判定器链整段复述
- headless `commandsHeadless` 的完整专题
- 远端收到 `/xxx` 后如何解释的猜测性叙述
- 对产品意图的心理分析

这些继续留在记忆层。

## 下一轮继续深入的候选问题

1. remote mode 下 plugin / MCP / prompt command 为什么更容易在本地命令面中变薄？
2. headless `disableSlashCommands` 与 interactive remote `disableSlashCommands` 的合同是否值得单独对照？
3. `disableSlashCommands` 与 `viewerOnly`、remote-safe commands、local-jsx bypass 三者之间是否还能进一步拆出“本地解释权最小化”专题？

只要这三问没答清，后续继续深入时仍容易把：

- 入口开关
- 本地命令层
- 远端文本入口

重新写成一句不准确的“slash 被禁用了”。
