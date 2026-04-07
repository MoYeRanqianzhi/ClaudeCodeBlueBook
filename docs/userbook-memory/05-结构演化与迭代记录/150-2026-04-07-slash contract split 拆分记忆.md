# slash contract split 拆分记忆

## 本轮继续深入的核心判断

68、69、147 已经把 slash 的表层结构拆得比较细了。

但正文还缺一个更靠近输入/运输/runtime 的结论：

- slash 不是静态命令表问题，而是跨宿主的合同换形问题

本轮要补的更窄一句是：

- 同一个 `/foo` 会在不同宿主里经历声明面、文本载荷与 runtime 再解释三次换形

## 为什么这轮必须单列

如果不单列，正文最容易在三种偷换里回卷：

- 把 `system/init.slash_commands` 写成可执行命令表
- 把输入框高亮写成当前宿主的执行主权
- 把 wire 上传输的 slash 文本继续写成“本地已解析命令”

这三种都会把：

- 命令声明
- 文本运输
- runtime 解释

重新压扁。

## 本轮最关键的新判断

### 判断一：`system/init.slash_commands` 是名字声明面，不是执行证明

### 判断二：`REMOTE_SAFE_COMMANDS` / `filterCommandsForRemoteMode(...)` 只是在裁本地 remote 壳

### 判断三：`PromptInput` 只消费本地命令对象集，因此它的高亮不是执行主权

### 判断四：remote `REPL` 会把大量 slash 当文本送远端，只把 `local-jsx` 留本地

### 判断五：bridge / `print` 某些路径会显式 `skipSlashCommands: true`，直接把 slash 纯文本化

### 判断六：因此 slash 的真实问题不是哪张表更真，而是哪一端在什么时候重新解释文本

## 苏格拉底式自审

### 问：为什么这页不是 68 的续写？

答：因为 68 还停在“几张命令表”的层面，这页已经进入 slash 文本跨宿主运输与再解释的层面。

### 问：为什么一定要把 `print` 写进来？

答：因为只有 `skipSlashCommands: true` 这种硬信号，才能说明 slash 在某些宿主根本不会进入命令解释链。

### 问：为什么一定要把发送层写出来？

答：因为不把 `sendMessage(content)` 写出来，就看不见 slash 从命令对象退化成原始文本 payload 的过程。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/150-system-init.slash_commands、REMOTE_SAFE_COMMANDS、PromptInput、REPL、processUserInput 与 print：为什么 slash 不是一张命令表，而是声明面、文本载荷与 runtime 再解释的三段合同.md`
- `bluebook/userbook/03-参考索引/02-能力边界/139-system-init.slash_commands、REMOTE_SAFE_COMMANDS、PromptInput、REPL、processUserInput 与 print 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/150-2026-04-07-slash contract split 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 长文层只补 150
- 索引层只补 139
- 记忆层只补 150

不回写 68、69、147。

## 下一轮候选

1. 单独拆 `remote.session_id`、`StatusLine`、attached viewer 与 remote TUI 为什么不共享同一种 session presence。
2. 单独拆 `system/init` 里更厚的状态字段与前台消费链为什么不会一起变成执行证明。
