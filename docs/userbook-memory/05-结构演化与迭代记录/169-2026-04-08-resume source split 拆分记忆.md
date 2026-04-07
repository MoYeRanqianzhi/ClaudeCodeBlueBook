# resume source split 拆分记忆

## 本轮继续深入的核心判断

168 已经把 headless transport 家族内部的恢复厚度拆成：

- protocol runtime
- recovery ledger
- persistence backpressure

但正文还缺一个更靠用户工作流的主语：

- 看起来都叫 continue / resume，不等于它们从同一份 source 继续

本轮要补的更窄一句是：

- stable conversation resume、headless remote hydrate 与 bridge continuity 不是同一种接续来源

## 为什么这轮必须单列

如果不单列，正文最容易在三种偷换里回卷：

- 把 `/resume` 与 generic `--continue` 的 conversation source，和 `remote-control --continue` 的 bridge pointer source 并列成一个默认主线
- 把 `print --resume` 写成单一来源，而漏掉它其实是能消费不同 source 的 host
- 把 stable 路径和条件路径重新用“或”写成同一个 continue 工作流

这三种都会把：

- conversation history
- remote-hydrated transcript
- bridge pointer continuity

重新压扁。

## 本轮最关键的新判断

### 判断一：`/resume` 与 generic `--continue` 先站在 stable conversation history 上

### 判断二：`print --continue` 仍消费 stable conversation source

### 判断三：`print --resume` 不是单一 source，而是会在条件分支下消费 remote-hydrated transcript source

### 判断四：`remote-control --continue` 读取的是 bridge pointer across worktrees，不是普通 conversation history

### 判断五：stable-first 写法必须先写 `/resume` / generic `--continue`，再写 headless remote hydrate，最后写 bridge continuity

## 苏格拉底式自审

### 问：为什么这页不是 161 的附录？

答：因为 161 讲入口宿主；169 讲接续来源。

### 问：为什么这页不是 163 的附录？

答：因为 163 讲 `print --resume` 内部的 parse / hydrate / restore stage；169 讲它放在整个 continue 家族里时消费的 source 类型。

### 问：为什么一定要把 `remote-control --continue` 写进来？

答：因为相同名字最容易误导文档把 bridge pointer source 写成 generic continue 的别名。

### 问：为什么一定要用稳定/条件/内部顺序来写？

答：因为 userbook 的写作纪律本来就要求稳定默认路径先写，条件路径后写，否则普通用户会被灰度路径污染主线认知。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/169-resume、--continue、print --resume 与 remote-control --continue：为什么 stable conversation resume、headless remote hydrate 与 bridge continuity 不是同一种接续来源.md`
- `bluebook/userbook/03-参考索引/02-能力边界/158-resume、--continue、print --resume 与 remote-control --continue 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/169-2026-04-08-resume source split 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 长文层只补 169
- 索引层只补 158
- 记忆层只补 169

不回写 24、33、161、163、168。

## 下一轮候选

1. 继续拆 `print --continue`、`print --resume <session-id>`、`print --resume <url>`：为什么同属 headless resume，也不是同一种 source certainty。
2. 继续拆 `remote-control --continue` 与 `--session-id`：为什么 bridge pointer continuity 与 explicit original-session targeting 不是同一种接回方式。
