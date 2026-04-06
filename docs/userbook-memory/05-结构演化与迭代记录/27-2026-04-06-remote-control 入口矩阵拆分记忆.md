# remote-control 入口矩阵拆分记忆

## 本轮继续深入的核心判断

第 24 到 26 页已经拆开了：

- 生命周期模式
- 设置面 / 控制面 / 状态面
- 链接 / 二维码 / 定位符

但 still missing 的，是进入 remote-control 本身的入口矩阵：

- `/remote-control`
- `--remote-control` / `--rc`
- `claude remote-control`
- Remote Callout
- standalone host 的 spawn mode choice

如果不补这一批，正文会继续犯六种错：

- 把 `/remote-control` 写成 `claude remote-control` 的另一种语法
- 把 `--rc` 写成 REPL 内命令别名
- 把 Remote Callout 写成所有 remote-control 入口的总闸门
- 把 standalone host 的 spawn mode 写成会内开桥共有设置
- 把 hidden flags / aliases 与稳定主线入口写成同一层
- 把“会内开桥”“启动带桥”“standalone host”重新压成一种 remote-control 动作

## 苏格拉底式自审

### 问：为什么这批不能塞回第 25 页？

答：第 25 页回答的是：

- 各个 surface 在改什么对象

而本轮问题变成：

- 用户到底从哪一类入口进入 remote-control

这已经从：

- control surface boundary

切到：

- entrypoint boundary

所以应该单独起一页。

### 问：为什么这批值得进入正文，而不是只留在记忆？

答：因为这直接影响用户怎么用：

- 我该在 REPL 里打 `/remote-control`，还是一开始就带 `--rc`？
- `claude remote-control` 为什么不是“会外版 /remote-control”那么简单？
- 为什么第一次从 REPL 里开桥会弹一个 callout，但其他入口不一定有？
- 为什么 standalone host 会谈 spawn mode，而 REPL `/remote-control` 不谈？

这些都属于用户可感知的使用误判。

### 问：这批最该防的假并列是什么？

答：

- `/remote-control` = `claude remote-control`
- `--rc` = `/remote-control`
- callout = 总闸门
- spawn mode = 共有设置

只要这四组没拆开，正文就会再次把不同入口压扁。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/27-remote-control 命令、--remote-control、claude remote-control 与 Remote Callout：为什么 remote-control 的会内开桥、启动带桥与 standalone host 不是同一种入口.md`
- `bluebook/userbook/03-参考索引/02-能力边界/16-Remote Control 入口矩阵索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/27-2026-04-06-remote-control 入口矩阵拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 正文落笔纪律

### 应写进正文的

- `/remote-control` 是当前 REPL 的 session-first 开桥入口
- `--remote-control` / `--rc` 是 startup flag，不是 REPL 命令
- `claude remote-control` 是 standalone host 路径
- Remote Callout 只属于 `/remote-control` 的 first-run consent
- spawn mode 只属于 standalone host 的 multi-session 路径
- hidden flags / aliases / legacy names 应降权写入边界说明

### 不应写进正文的

- fast-path 加载顺序的全部底层细节
- build-time dead-code elimination 细枝末节
- 全量 analytics 事件名
- spawn runner 的底层实现

这些内容只作作者判据，不回流正文。

## 本轮特殊注意

### “命令名字像”不等于“对象相同”

本轮最容易犯的偷换是：

- 用户都看到 `remote-control`

于是误写成：

- `/remote-control` 和 `claude remote-control` 本质一样

但源码明确显示：

- 一个在当前 REPL 内改桥状态
- 一个在 CLI fast-path 上直接起 standalone host

正文必须保留这个 host-shape 差异。

### “都能连上 web”也不等于“入口同类”

同样容易滑坡的点是：

- 反正最后都能去 claude.ai/code

于是误写成：

- 所有 remote-control 入口只是写法不同

这会直接抹掉 activation time、host shape 与 consent surface 的差异。

## 后续继续深入时的检查问题

1. 我现在拆的是入口矩阵，还是控制/状态/定位符边界？
2. 这个入口作用于当前 REPL，还是 standalone host？
3. 这个提示页是这个入口独有的，还是多入口共用的？
4. 我是不是又把会内开桥、启动带桥与 standalone host 压回一个 remote-control 动作？

只要这四问没先答清，下一页继续深入就会重新滑回：

- 命令名罗列
- 或实现层流水账

而不是用户真正可用的入口正文。
