# headless print builder-callback-ui branch map split 拆分记忆

## 本轮继续深入的核心判断

`111-115` 这一组页不能继续被读成并列“callback / adapter / streamlined”细页。

更准确的结构是：

- 111 先定四层可见性表
- `112→113` 收成 streamlined 支线
- `114→115` 收成 adapter / UI consumer 支线

所以这轮最该补的是：

- 一张只覆盖 `111-115` 的 `05` 分叉结构页
- 一张对应 `100-104` 索引的 `03` 速查入口

## 为什么这轮必须单列

如果不补这一层，

正文最容易在五种偷换里回卷：

- 把 112 写成 111 的 streamlined 附录
- 把 113 写成 101 的 result 重述
- 把 114 写成 111 的 UI 版翻译
- 把 115 写成 114 的细节补丁
- 把 callback-visible、adapter triad、hook sink 与 UI policy 混成同一种“显示不显示”

## 本轮最关键的新判断

### 判断一：111 是根页，不是细页之一

它先回答：

- builder transport
- public SDK
- callback surface
- UI consumer

为什么不是同一张可见性表。

### 判断二：`112→113` 是 streamlined 支线

它们分别在回答：

- gate / replacement / suppression
- `result` passthrough vs terminal primacy

### 判断三：`114→115` 是 adapter / UI consumer 支线

它们分别在回答：

- callback-visible vs adapter triad vs hook sink
- tool_result parity / history replay / success-noise suppression

### 判断四：这一组页更适合保护“层级 + policy 分裂”，不是继续追 helper 名

稳定层应写：

- 四层可见性表不是同一张表
- 同为 streamlined 纳入对象也不等于同一种动作
- callback-visible 不等于 UI-visible
- adapter 内三种 policy 方向不同

灰度层才写：

- option 名
- helper 顺序
- `sentUUIDsRef`
- `setIsLoading(false)`
- host-specific wiring

### 判断五：要把“当前四层表读法”与“长期稳定主干”分开

这轮继续保留“111 先定四层可见性表”的结构页写法，

但更稳的保护对象不是：

- 永远恰好四层
- `DirectConnectSessionManager -> useDirectConnect -> sdkMessageAdapter` 这条 exact 链

而是：

- 更宽层可承载，不等于更窄层必消费
- 进入更窄层后，也不等于会落成同一种 streamlined action 或 UI consumer policy

所以 112-115 更适合被写成：

- 当前宿主怎样把更宽层对象继续压成 action / policy 分裂的实现证据

而不是：

- 五条并列稳定用户合同

## 苏格拉底式自审

### 问：为什么这轮不把 116-121 一起收掉？

答：因为 116 以后已经进入 completion/init/replay 另一组后继叶子；这轮先把 111-115 的支线主语收稳更重要。

### 问：为什么这轮不新开 `04` 专题页？

答：这轮主要在修正 `05/03` 层的结构主语，不值得单独新开 `04`；但可以把“callback-visible 不等于 UI/transcript-visible”的入口回挂到既有专题页。

### 问：为什么这轮值得补 `03` 索引？

答：因为这里新增的是一个新的能力边界对象：

- builder-callback-UI branch map

它不是任意一篇单页正文的附属摘要。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/210-builder transport、callback surface、streamlined dual-entry 与 UI consumer policy：为什么 111、112、113、114、115 不是并列细页，而是先定四层可见性表，再分叉到 streamlined 与 adapter 两条后继线.md`
- `bluebook/userbook/03-参考索引/02-能力边界/197-Headless print builder-callback-UI branch map 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/212-2026-04-08-headless print builder-callback-ui branch map split 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/04-专题深潜/23-远端前台运行、会话存在面与桥接后台分诊专题.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 补 `05` 分叉结构页
- 补 `03` 速查索引
- 不新增 `04` 专题页，只在既有专题页补投影入口
- 不回写 111-115 旧正文

## 下一轮候选

1. 若继续这一簇，可把 116-121 再收成一张 `completion / init / replay` 的后继结构页。
2. 若继续恢复线，可回到 107/167 补 metadata readback / model override / local sink 的恢复结构图。
3. 若继续用户症状入口，再决定是否把这一组 callback / adapter / streamlined 分叉投到 `04-13` 的自动化专题里。
