# sandbox persist write surfaces split 拆分记忆

## 本轮继续深入的核心判断

201 已经拆开：

- same-host sibling sweep

但 sandbox permission 里“允许并持久化”这句话还没有被拆开：

- 用户动作看起来像一次 persist
- 实际落点却至少跨了本地 context、durable settings 与 live sandbox runtime 三层

本轮要补的更窄一句是：

- `applyPermissionUpdate(...)`、`persistPermissionUpdate(...)` 与 `SandboxManager.refreshConfig()` 不是同一种 side effect，而是 sandbox persist 手势的三层写面

## 为什么这轮必须单列

如果不单列，正文最容易在四种偷换里回卷：

- 把 `applyPermissionUpdate(...)` 写成磁盘持久化
- 把 `persistPermissionUpdate(...)` 写成 live sandbox 已即时更新
- 把 `refreshConfig()` 写成冗余重复调用
- 把 worker persist 分支和本地 persist 分支写成同一条 allow / deny 合同

这四种都会把：

- context mutation
- settings persistence
- runtime refresh

重新压扁。

## 本轮最关键的新判断

### 判断一：`applyPermissionUpdate(...)` 只改 leader 本地 permission context

### 判断二：`persistPermissionUpdate(...)` 只负责 durable settings write

### 判断三：`SandboxManager.refreshConfig()` 用来补上当前 runtime 的同步追平，避免 stale window

### 判断四：worker sandbox 的 persist 分支只在 allow 时落盘，本地 sandbox 分支则允许 allow / deny 两种持久化

## 苏格拉底式自审

### 问：为什么这页不是 201 的附录？

答：201 讲 host-level sibling sweep；202 讲 persist 手势的多层写面传播。

### 问：为什么这页不是 73 的附录？

答：73 讲本地 tool plane 主权；202 讲一次具体 sandbox persist 动作如何跨这张主权图写入多层状态。

### 问：为什么这页不是 78 的附录？

答：78 讲 worker sandbox ask 与 leader 本地 prompt 不是同一壳；202 只抓它们在 persist 分支上的共享模型与差异边界。

### 问：为什么不能直接说“写 settings 后 sandbox 自然会更新”？

答：因为 `sandbox-adapter.ts` 明写了 `refreshConfig()` 是为避免 settings change 尚未被探测时的竞态窗口。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/202-applyPermissionUpdate、persistPermissionUpdate、SandboxManager.refreshConfig 与 localSettings：为什么 sandbox permission 的 persist-to-settings 不是一次单层 permission 写入.md`
- `bluebook/userbook/03-参考索引/02-能力边界/190-applyPermissionUpdate、persistPermissionUpdate、SandboxManager.refreshConfig 与 localSettings 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/202-2026-04-08-sandbox persist write surfaces split 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 长文层只补 202
- 索引层只补 190
- 记忆层只补 202

不回写 201。

## 下一轮候选

1. 若继续功能设计线，可把 sandbox permission 的 “选择持久化” 与 `setToolPermissionContext` 触发的 queue recheck 再拆成更细的治理边界。
2. 若继续专题投影层，可把 sandbox network / permission / persist 三页投影成一个更偏用户目标的专题页，但不能复制 20 的 ingress / continuation 职责。
3. 若后续子代理确认更强候选，可继续往 stable / conditional / gray 的跨页导航层推进。
