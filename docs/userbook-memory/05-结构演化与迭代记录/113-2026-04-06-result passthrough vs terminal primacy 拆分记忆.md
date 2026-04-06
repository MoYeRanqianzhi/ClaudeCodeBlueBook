# result passthrough vs terminal primacy 拆分记忆

## 本轮继续深入的核心判断

112 已经把 streamlined path 内部的动作拆成：

- gate
- rewrite
- passthrough
- suppression

但如果只停在那里，读者仍然会保留一个更细的误解：

- `result` 之所以在 transformer 里原样保留，本质上就是因为它在最终收尾里也必须当主位

这轮要补的更窄一句是：

- transformer 里的 `result` passthrough 保的是 payload
- `lastMessage` / `gracefulShutdownSync` 保的是 terminal primacy

这不是同一种“保留原样”。

## 为什么这轮必须单列

如果不单列，正文最容易在两种错误里摇摆：

- 把 payload preservation 写成 semantic primacy
- 把 terminal primacy 写成 transformer 里的实现细节

这两种都会把：

- payload
- cursor
- final output
- shutdown exit

四层对象重新压平。

## 本轮最关键的新判断

### 判断一：same keep-unchanged wording 不等于 same semantic job

这是这页最需要钉死的根句。

### 判断二：`structured_output` / `permission_denials` 是 transformer 侧的保留理由

不是 terminal final contract 的保留理由。

### 判断三：退出码和最终输出围绕的是 terminal result cursor，而不是某次 transformer 的返回值

所以 passthrough 不能替代 primacy。

## 苏格拉底式自审

### 问：为什么这页不能并回 101？

答：因为 101 讲 result 为何保持终态主位；113 讲 streamlined transformer 里的 passthrough 为什么不是同一种主位保留。

### 问：为什么这页不能并回 112？

答：因为 112 讲 action taxonomy；113 讲 passthrough 这一格内部为什么还要再拆 payload 与 terminal semantics。

### 问：为什么要反复强调 payload 与 cursor？

答：因为没有这层，读者会把“没被改写”直接等同于“最后当然还是它说了算”。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/113-result、structured_output、permission_denials、lastMessage 与 gracefulShutdownSync：为什么 streamlined path 的 passthrough 不是 terminal semantic 主位保留.md`
- `bluebook/userbook/03-参考索引/02-能力边界/102-result payload passthrough vs terminal primacy 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/113-2026-04-06-result passthrough vs terminal primacy 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 长文层只补 113
- 索引层只补 102
- 记忆层只补 113

不需要新增目录，只更新导航即可。

## 下一轮候选

1. 单独拆 `convertSDKMessage(...)` 的 `message` / `stream_event` / `ignored` 三分法为什么不是 callback surface 的镜像映射。
2. 单独拆 `convertToolResults`、`convertUserTextMessages` 与 success result ignored 为什么不是同一种 UI consumer policy。
3. 单独拆 success `result` ignored、error `result` visible 与 `setIsLoading(false)` 为什么不是同一种 direct-connect completion signal。
