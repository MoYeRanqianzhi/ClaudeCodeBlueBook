# shutdown mailbox lifecycle family 拆分记忆

## 本轮继续深入的核心判断

80 页已经把 approval-adjacent mailbox family 拆清了：

- `permission_request`
- `sandbox_permission_request`
- `plan_approval_request`

下一步如果继续稳定扩展，就不该再横向补新的 approval 页面，而该单列：

- shutdown lifecycle family

否则读者会因为“也走 teammate mailbox”而再次把：

- termination

误并回：

- approval

## 为什么这轮必须把 shutdown 单独拆开

因为 shutdown family 的主语已经变了。

80 页问的是：

- 哪种 request 在请求 continuation / transition？

81 页问的是：

- 某个 teammate 要不要结束当前生命周期？

这两者虽然 transport 一样，但协议对象和 consumer 都变了。

## 本轮最关键的新判断

### 判断一：`shutdown_request` 是 lifecycle interrupt，不是 queue ask

teammate 侧不会把它重包进本地 approval queue，而是：

- 保留原始 JSON
- 交给 UI 渲染
- 交给模型决定 approve / reject

in-process runner 甚至会优先于普通 unread message 处理它。

### 判断二：`shutdown_approved` 的价值主要在 cleanup side effect

leader 侧收到 approved 后，不只是“看到一条消息”，而是会：

- kill pane（如果是 pane backend）
- 从 teamContext / team file 移除 teammate

headless `print.ts` 也镜像了这条 cleanup 逻辑。

### 判断三：`shutdown_rejected` 更像显式 lifecycle reply

它没有专门的 leader cleanup 分支，主要回到可见消息层，告诉 leader：

- 我拒绝退出
- 原因是什么
- 我继续工作

### 判断四：`terminate()` 与 `kill()` 必须继续分写

`terminate()` 走 mailbox `shutdown_request`

`kill()` 走强制 backend 终止

这是用户级最稳定、最不该混写的一组边界。

## 为什么这轮不把“message routing 总图”一起写掉

当然还可以继续补：

- unread 分类全图
- `markMessagesAsRead` 时机
- `regularMessages` pass-through
- `teammate_terminated`、idle notification 与 shutdown 过滤关系

但这轮真正最值钱的，不是更大的 routing 总图，而是先把：

- shutdown != approval

这条主轴钉死。

否则再往后写消息路由图，读者还是会在上层把 shutdown 误解成“另一种 ask-response”。

## 苏格拉底式自审

### 问：为什么不把 shutdown 并进 80，做成四族总表？

答：因为 80 页的核心问题是 approval-adjacent family。shutdown 的关键问题不是“怎么批准”，而是“何时终止、谁清理、何时强杀”。

### 问：为什么正文里可以写 UI 过滤 approved，而不是把它全沉到记忆？

答：因为这不是纯实现噪音。它直接帮助用户理解：approved 在产品里的主要价值是控制后果，而不是继续阅读对话。

### 问：为什么不把 `requestId`、schema 字段、helper 全写进正文？

答：因为这些更像 transport implementation。正文只需要抓稳用户能形成正确判断的层：

- family object
- consumer shape
- terminate vs kill
- visible vs effect

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/81-shutdown_request、shutdown_approved、shutdown_rejected、terminate 与 kill：为什么 swarms 的 shutdown mailbox 消息属于 lifecycle termination family.md`
- `bluebook/userbook/03-参考索引/02-能力边界/70-Shutdown mailbox lifecycle termination family 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/81-2026-04-06-shutdown mailbox lifecycle family 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小改动：

- 长文层只补 81
- 索引层只补 70
- 记忆层只补 81

不把 approval family、routing family、UI filtering family 混成同一次正文。

## 下一轮候选

1. 把 shutdown family 再往下压一层，单独写 teammate termination visible surface 与 hidden cleanup surface。
2. 单独拆 unread 分类、mark-read、pass-through 与 filtered message 的 message routing layer。
3. 把 `shutdown_*` 与 `teammate_terminated`、idle notification 的显示面差异做成对照页。
