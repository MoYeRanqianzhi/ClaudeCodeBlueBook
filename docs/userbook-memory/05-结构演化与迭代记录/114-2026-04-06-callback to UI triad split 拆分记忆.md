# callback to UI triad split 拆分记忆

## 本轮继续深入的核心判断

111 已经把 callback surface 与 UI consumer 拆成了不同层。

但如果只停在那里，读者仍然会保留一个更细的误解：

- `convertSDKMessage(...)` 的 `message / stream_event / ignored` 三分法只是 callback surface 的镜像重命名

这轮要补的更窄一句是：

- callback-visible 是一层
- adapter triad 是一层
- 当前 hook sink 只消费其中一部分，又是下一层

这三者不是同一件事。

## 为什么这轮必须单列

如果不单列，正文最容易在两种错误里摇摆：

- 把 adapter triad 写成 callback membership mirror
- 把 hook sink 写成 triad 的自动全消费

这两种都会把：

- callback object
- consumer classification
- actual sink

三层对象重新压平。

## 本轮最关键的新判断

### 判断一：same callback-visible 不等于 same UI classification

这是这页最需要钉死的根句。

### 判断二：same adapter triad 结果 也不等于 same hook sink

因为当前 hook 只消费 `message`。

### 判断三：success `result` 是最值钱的反例

它 callback-visible，却会在 triad 里变成 `ignored`。

## 苏格拉底式自审

### 问：为什么这页不能并回 111？

答：因为 111 讲整张表栈；114 讲 callback -> adapter -> hook sink 这一个局部 narrowing step。

### 问：为什么这页不能并回 113？

答：因为 113 讲 result 的 payload/terminal 语义差异；114 讲 callback-visible 对象进 UI 时的 triad 分类差异。

### 问：为什么要反复强调 triad 后还有 hook sink？

答：因为没有这层，读者会把 `stream_event` triad 结果直接当成当前 hook 一定消费的对象。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/114-convertSDKMessage、useDirectConnect、stream_event 与 ignored：为什么 UI consumer 的三分法不是 callback surface 的镜像映射.md`
- `bluebook/userbook/03-参考索引/02-能力边界/103-callback visible vs adapter triad vs hook sink 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/114-2026-04-06-callback to UI triad split 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 长文层只补 114
- 索引层只补 103
- 记忆层只补 114

不需要新增目录，只更新导航即可。

## 下一轮候选

1. 单独拆 `convertToolResults`、`convertUserTextMessages` 与 success result ignored 为什么不是同一种 UI consumer policy。
2. 单独拆 success `result` ignored、error `result` visible 与 `setIsLoading(false)` 为什么不是同一种 direct-connect completion signal。
3. 单独拆 `system.init` 去重、`convertInitMessage(...)` 与 callback-visible init 为什么不是同一种“初始化可见性”。
