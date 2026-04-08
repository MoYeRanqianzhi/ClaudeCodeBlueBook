# headless print wire-visibility and projection branch map split 拆分记忆

## 本轮继续深入的核心判断

`105/106/108/109/110` 这一组页不能继续被读成并列“可见性页”。

更准确的结构是：

- 105 先定 `post_turn_summary` 的 wider-wire visibility 根分裂
- 106 分出 headless raw wire contract
- 108 分出 direct-connect callback narrowing
- 109 分出 streamlined pre-wire projection
- 110 再解释 108 与 109 在 skip list 处相交后，为什么 same skip list 不等于 same suppress reason

所以这轮最该补的是：

- 一张只覆盖 `105/106/108/109/110` 的 `05` 分叉结构页
- 一张对应 `94/95/97/98/99` 的 `03` 速查索引

## 为什么这轮必须单列

如果不补这一层，

正文最容易在五种偷换里回卷：

- 把 106 写成 105 的 `stream-json` 附录
- 把 108 写成 105 的 direct-connect 重述
- 把 109 写成 terminal display optimization
- 把 110 写成 108/109 的重复证明
- 把 `post_turn_summary` 与 `streamlined_*` 写成同一种 suppressed family

## 本轮最关键的新判断

### 判断一：105 是根页，不是尾页之一

它先回答：

- `post_turn_summary`

为什么不属于 core SDK-visible，

却仍属于更宽的 wire-admissible set。

### 判断二：106 / 108 / 109 是三条真正的后继分叉

它们分别在回答：

- raw wire contract
- callback consumer-path narrowing
- pre-wire projection path

### 判断三：110 是交叉叶子，不是任一分叉的附录

它不是继续讲 parse gate，

也不是继续讲 transformer，

而是在 direct-connect skip list 的交叉位置解释：

- same skip list
- different suppress reason

### 判断四：这一组页更适合保护“对象层级分裂”，不是继续追 helper 名

稳定层应写：

- `post_turn_summary` 不属于 core SDK-visible，却属于更宽 wire-admissible
- `stream-json --verbose` 是 raw wire contract
- direct connect callback 比 parse gate 更窄
- streamlined 是 pre-wire projection
- same skip list 不等于 same suppress reason

灰度层才写：

- `@internal`
- skip list 明细
- feature/env gate
- emitter 频率

## 苏格拉底式自审

### 问：为什么这轮不把 107 一起收进去？

答：107 属于 `103/167` 那条恢复线，不属于这组 wire/callback/projection 分叉。

### 问：为什么这轮不直接跳到 111-115？

答：因为当前缺口不在更多 leaf-level 证明，而在 105-110 缺一张更窄的对象层级分叉图。

### 问：为什么这轮值得补 `03` 索引？

答：因为这里新增的是一个新的能力边界对象：

- wire-visibility and projection branch map

它不是任意一篇单页正文的附属摘要。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/209-post_turn_summary、StdoutMessage、SDKMessage、stream-json raw wire 与 streamlined_*：为什么 105、106、108、109、110 不是并列尾页，而是从 wider-wire visibility 分叉出去的四种后继问题.md`
- `bluebook/userbook/03-参考索引/02-能力边界/196-Headless print wire-visibility and projection branch map 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/211-2026-04-08-headless print wire-visibility and projection branch map split 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 补 `05` 分叉结构页
- 补 `03` 速查索引
- 不新增 `04` 专题投影
- 不回写 105-110 旧正文

## 下一轮候选

1. 若继续这一簇，可把 111/112/113/114/115 再收成一张 `builder transport / callback surface / UI consumer` 的后继结构页。
2. 若继续恢复线，可回到 107/167 把 metadata readback / model override / local sink 收成另一条恢复结构图。
3. 若继续用户症状入口，再决定是否要把这一组 wire / callback / projection 分叉投到 `04` 的自动化专题里。
