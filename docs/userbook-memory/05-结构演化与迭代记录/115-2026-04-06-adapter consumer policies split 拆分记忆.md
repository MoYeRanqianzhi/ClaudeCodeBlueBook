# adapter consumer policies split 拆分记忆

## 本轮继续深入的核心判断

114 已经把：

- callback-visible
- adapter triad
- hook sink

拆成三层。

但如果不继续往 adapter 内压，读者仍会保留另一个误解：

- `convertToolResults`
- `convertUserTextMessages`
- success `result -> ignored`

都只是同一种“显示/不显示”过滤。

这轮要补的更窄一句是：

- 有的 policy 在补 render parity
- 有的 policy 在补 replay completeness
- 有的 policy 在压 success noise

它们同层，不同题。

## 为什么这轮必须单列

如果不单列，正文最容易在三种错误里摇摆：

- 把 `convertToolResults` 写成 generic user replay
- 把 `convertUserTextMessages` 写成 live transcript 开关
- 把 success `result -> ignored` 写成“该对象没有消费价值”

这三种都会把：

- backfill
- replay
- suppression

重新压平。

## 本轮最关键的新判断

### 判断一：同在 adapter，不等于同一种 consumer rationale

这是这页最需要钉死的根句。

### 判断二：`convertToolResults` 补的是 remote tool result 的本地补画

不是 generic user message replay。

### 判断三：`convertUserTextMessages` 补的是 history/viewer user text 回放

而且天然伴随 echo dedup 风险。

### 判断四：success `result -> ignored` 压的是 multi-turn success noise

它不是 replay/backfill 的第三种写法。

## 苏格拉底式自审

### 问：为什么这页不能并回 114？

答：114 讲 triad 不是 callback mirror；115 讲 triad 内部几种 policy 也不是同一种 consumer problem。

### 问：为什么这页不能直接并成“completion signal”那一页？

答：因为这页只需要证明 success `result` 的 transcript 静默不等于 replay/backfill；还没必要把 error visible、loading end 和 session end 全写进来。

### 问：为什么必须把 `useAssistantHistory` 和 `useRemoteSession` 一起拉进来？

答：因为没有宿主证据，`convertUserTextMessages` 就容易停留在注释层，写不实。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/115-convertToolResults、convertUserTextMessages、useAssistantHistory、viewerOnly 与 success result ignored：为什么 tool_result 本地补画、user text 历史回放与成功结果静默不是同一种 UI consumer policy.md`
- `bluebook/userbook/03-参考索引/02-能力边界/104-tool_result 本地补画、history user replay 与 success result 静默索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/115-2026-04-06-adapter consumer policies split 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 长文层只补 115
- 索引层只补 104
- 记忆层只补 115

不新增目录，只更新导航。

## 下一轮候选

1. 单独拆 success `result` ignored、error `result` visible 与 `setIsLoading(false)` 为什么不是同一种 direct-connect completion signal。
2. 单独拆 `system.init` callback-visible、`useDirectConnect` 去重与 `convertInitMessage(...)` 为什么不是同一种初始化可见性。
3. 单独拆 viewerOnly 的 `convertUserTextMessages`、`sentUUIDsRef` echo dedup 与 history attach overlap 为什么不是同一种 replay 去重。
