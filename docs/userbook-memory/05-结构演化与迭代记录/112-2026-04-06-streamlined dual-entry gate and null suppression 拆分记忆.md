# streamlined dual-entry gate and null suppression 拆分记忆

## 本轮继续深入的核心判断

109 已经说明：

- streamlined path 发生在 write 之前

但如果只停在那个层面，读者仍然会保留一个更细的误解：

- 只要进入 streamlined path，assistant、result 与其余 family 只是同一种“消息简化”的不同外观

这轮要补的更窄一句是：

- `shouldIncludeInStreamlined(...)` 是纳入 gate
- `assistant` 是 rewrite-or-null
- `result` 是 passthrough
- 其他 family 多数是 suppression

这四者不是同一种动作。

## 为什么这轮必须单列

如果不单列，正文最容易在两种错误里摇摆：

- 把 gate 写成 transform contract
- 把 passthrough 与 suppression 一起写成“没做转换”

这两种都会把：

- inclusion
- replacement
- preservation
- suppression

四种动作重新压平。

## 本轮最关键的新判断

### 判断一：same inclusion 不等于 same transformation

这是这页最需要钉死的根句。

### 判断二：`result` 的保留原样，是为了继续写出，不是“没资格被处理”

所以它和 `null` suppression 不能混写。

### 判断三：`assistant` 分支自己也不是单一简化，而是 replacement/null 的分流

所以 even within assistant，动作也已经不是一类。

## 苏格拉底式自审

### 问：为什么这页不能并回 109？

答：因为 109 讲时序；112 讲这个时序内部到底有几种不同动作。

### 问：为什么这页不能并回 111？

答：因为 111 讲跨层表栈；112 讲 transformer 内部的动作分层。

### 问：为什么要反复强调 gate 与 action 的差别？

答：因为没有这层，读者会把“进入路径”直接写成“同一种简化语义”。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/112-shouldIncludeInStreamlined、assistant-result 双入口、streamlined_* 与 null：为什么 streamlined path 的纳入 gate、替换入口与抑制返回不是同一种消息简化.md`
- `bluebook/userbook/03-参考索引/02-能力边界/101-streamlined dual-entry gate、passthrough 与 null suppression 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/112-2026-04-06-streamlined dual-entry gate and null suppression 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 长文层只补 112
- 索引层只补 101
- 记忆层只补 112

不需要新增目录，只更新导航即可。

## 下一轮候选

1. 单独拆 `result` 在 streamlined path 里 passthrough、在 `lastMessage` 里保终态主位，为什么不是同一种“保留原样”。
2. 单独拆 `convertSDKMessage(...)` 的 `message` / `stream_event` / `ignored` 三分法为什么不是 callback surface 的镜像映射。
3. 单独拆 `convertToolResults`、`convertUserTextMessages` 与 success result ignored 为什么不是同一种 UI consumer policy。
