# blocked-state ceiling contract hardening 拆分记忆

## 本轮继续深入的核心判断

在当前 worktree 已经把：

- `191-206` 家族入口
- `197` ingress 阅读链
- `203` permission tail 分叉图
- `206` blocked-state publish ceiling

这些局部结构页都补齐之后，

这一支眼下更值钱的下一刀，

不是继续新建 hub，

而是回到：

- `206-...bridge blocked-state publish 只签裸 blocked bit.md`

把它对：

- `ask transport`
- `blocked projection`
- `worker metadata`
- `bridge publish ceiling`

之间的合同边界再压硬一层。

## 为什么这轮值得单独提交

### 判断一：`206` 现在缺的不是分层框架，而是 “coarse blocked bit 不是偶然漏传” 的证明厚度

`206`

原本已经能说清：

- `can_use_tool` 不是 blocked session 本身
- `requires_action_details` / `pending_action` 是双轨投影
- bridge 只发 `reportState('requires_action')`

但如果只停在这里，

读者还是很容易把 bridge 的上限写成：

- “其实就差把 details 和 pending_action 一起补出去”

这轮补的关键，

就是把问题再压成三个更底层的合同追问：

1. 它有没有 details-carrying state publish 签名？
2. 它有没有并列的 pending-object mirror？
3. 它有没有 foreground restore 必须接回完整 blocked context 的承诺？

这样才能把：

- 当前只看见 coarse blocked bit

写成：

- contract ceiling 本来就只签 coarse blocked bit

而不是：

- 一个暂时少传字段的实现现象

### 判断二：`191-206` 当前已经是 family hub 足够、正文厚度优先的范围

这一簇现在已经同时有：

- 家族入口 README
- `197`
- `203`
- `206`

继续加新 hub，

只会重复导航，

不会增加正文的稳定/条件/灰度边界。

所以这轮结构优化的动作，

不是再补入口，

而是继续减少正文里的“像是漏传”式误读。

### 判断三：这轮也在把旧页继续拉回当前成熟口径

`206`

之前用的是：

- `稳定 / 条件 / 灰度保护`

这轮把它同步回最近已经稳定下来的：

- `稳定层、条件层与灰度层`

并补上：

- 结论应停在这里
- 苏格拉底式自检

本质上是在继续收紧这条线的落笔纪律。

## 这轮具体怎么拆

这轮只做三件事：

1. 修改 `206-...blocked bit.md`
   - 给 bridge publish ceiling 补一层 `signature / mirror / restore promise` 三问
2. 统一 `206` 尾部口径
   - 改成 `稳定层、条件层与灰度层`
   - 并补上安全收束句与苏格拉底式自检
3. 新增这条 `411` 记忆并更新 `memory/05 README`

## 苏格拉底式自审

### 问：为什么这轮不是去做新的 `191-206` hub？

答：因为这簇现在更缺的是合同厚度，不是 findability。读者已经能稳定走到 `206`，缺的是怎样不把 coarse blocked bit 写成 accidental missing details。

### 问：为什么这轮不直接跳去 `206` 之后的新专题页？

答：因为当前更稀缺的是把 `206` 自己压硬。若本页仍停在“少了 details”的现象层，再往外扩专题只会把误读继续带出去。

### 问：为什么这也算结构优化？

答：因为结构优化不只等于新增 README。当前统一旧页尾部口径、减少正文术语漂移，本身就在保护目录系统的稳定分工。
