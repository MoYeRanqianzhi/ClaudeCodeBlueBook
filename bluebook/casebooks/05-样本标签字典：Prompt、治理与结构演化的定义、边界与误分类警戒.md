# 样本标签字典：Prompt、治理与结构演化的定义、边界与误分类警戒

这一章不再新增新案例，而是给现有标签一个稳定字典。

它主要回答五个问题：

1. 每个标签到底是什么意思。
2. 相邻标签之间的边界在哪里。
3. 哪些误分类最常见。
4. 为什么标签字典本身就是制度资产。
5. 怎样用苏格拉底式追问避免把标签当成修辞词。

## 0. 第一性原理

一个标签如果：

- 没有定义
- 没有边界
- 没有误分类警戒

那它就不是制度标签，只是一个听起来专业的词。

## 1. Prompt 标签字典

### `section drift`

- 定义：条款内容、标题或所在 section 发生变化，导致宪法槽位失真。
- 不等于：纯运行时 cache miss。
- 常见误判：把 header wording 变化误认为文案微调。

### `boundary drift`

- 定义：本应位于 dynamic boundary 后或 delta 中的信息，误入稳定前缀。
- 不等于：任何 token 增长。
- 常见误判：把所有 prompt 变贵都叫 boundary drift。

### `path parity split`

- 定义：同一现场在不同 assembly path 下编译成不同 prompt truth。
- 不等于：单一路径内的 section 变化。
- 常见误判：把入口差异误判成模型偶发失常。

### `lawful-forgetting failure`

- 定义：compact / recovery 后摘要仍在，但继续工作所需 ABI 已断。
- 不等于：summary 写得不够好。
- 常见误判：把任何 compact 后异常都归因为总结质量。

### `invalidation drift`

- 定义：应失效的缓存、section 或 triage 状态未按制度事件刷新。
- 不等于：正常 TTL 过期。
- 常见误判：把预期 invalidation 当成系统失稳。

## 2. 治理标签字典

### `order violation`

- 定义：规则被放错顺序，导致错误 allow / deny / ask。
- 不等于：单条规则本身太宽或太窄。

### `hard-guard bypass`

- 定义：本不应被 mode 覆盖的保护被绕开。
- 不等于：合理的窄例外。

### `approval-race degradation`

- 定义：本应并发竞速的治理协议退化成串行等待或 split-brain。
- 不等于：任何审批等待时间增长。

### `stable-bytes drift`

- 定义：影响安全、成本或 replay 的关键字节发生未受控漂移。
- 不等于：普通输出波动。

### `stop-logic failure`

- 定义：自动链路继续花费预算，但结论已不可能改变。
- 不等于：一次正常重试。

## 3. 结构标签字典

### `shadow fossilization`

- 定义：影子实现从过渡层演化成永久第二真相。
- 不等于：合理长期存在的 lightweight entry。

### `transport leakage`

- 定义：本应被关在 shell 的协议分叉扩散到业务层。
- 不等于：shell 内部的正常适配代码。

### `recovery-asset corruption`

- 定义：pointer、cursor、uuid、merge rule 等恢复资产失真。
- 不等于：一次普通 reconnect。

### `registry obesity`

- 定义：高扇入 registry 从注册壳长成第二业务中心。
- 不等于：正常的最小构造逻辑。

### `zombification`

- 定义：旧快照、stale finally、stale append 等复活旧对象或污染当前真相。
- 不等于：一般 race condition 的局部表现。

## 4. 跨线元字段字典

### `authority source`

- 定义：当前由谁给出最终权威判断。

### `assembly path`

- 定义：对象经哪条组装、适配或入口路径进入运行时。

### `decision-gain judgement`

- 定义：这次额外成本是否改变最终治理结论。

### `evidence schema`

- 定义：一次记录至少应保留哪些最小证据字段。

## 5. 苏格拉底式追问

在你准备给一个事故贴标签前，先问自己：

1. 我给的是制度标签，还是现象形容词。
2. 这个标签的边界我真的说得清吗。
3. 我是不是在拿一个更响亮的词替代真正判断。
4. 这次误判是不是因为我没区分相邻标签。
5. 这个标签未来别人能稳定复用吗。
