# worker sandbox mailbox queue 拆分记忆

## 本轮继续深入的核心判断

77 页已经拆开：

- worker-originated tool ask
- leader-visible `ToolUseConfirm` shell
- worker-owned continuation

但这条心智模型还缺另一条并列分支：

- worker-originated sandbox ask
- leader-visible host approval queue
- worker-owned sandbox callback

如果不单独补这一批，正文会继续把：

- `workerSandboxPermissions.queue`

误写成：

- leader 本地 `sandboxPermissionRequestQueue`

## 为什么这轮必须单写，而不是只在 77 页加一段

两页虽对称，但并不重复：

- 77 页的壳是 `ToolUseConfirm`
- 78 页的壳是 `workerSandboxPermissions.queue` + `SandboxPermissionRequest`

更重要的是，78 页多了一条 77 没有的副作用：

- leader 允许并持久化时，会更新自己本地的 `domain:` 规则并刷新 sandbox config

这意味着它不是简单的“host 版 77”，而是：

- mailbox host queue + optional local config side-effect

## 本轮最关键的新判断

### 判断一：worker 上报成功后，自己只保留 `pendingSandboxRequest` 和 callback

worker 侧不再弹本地 `sandboxPermissionRequestQueue`，而是：

- `registerSandboxPermissionCallback(...)`
- `setAppState(...pendingSandboxRequest...)`

这说明 worker 本地的角色只有：

- waiting state
- callback holder

### 判断二：leader 看到的不是本地 sandbox queue，而是 worker sandbox queue

leader 侧 mailbox request 会进入：

- `workerSandboxPermissions.queue`

而不是：

- `sandboxPermissionRequestQueue`

这层必须明确，否则“同款 `SandboxPermissionRequest` 组件”会重新造成 ownership 误判。

### 判断三：真正 resolve 原 promise 的仍然是 worker callback

`processSandboxPermissionResponse(...)` 只是调用 worker 注册的：

- `resolve(allow)`

所以 continuation 仍然不在 leader。

### 判断四：leader 的 allow 可能顺手改变自己的本地 host 规则

这一点是本轮必须单独记住的新增：

- `persistToSettings && allow`

时 leader 会：

- `applyPermissionUpdate(...)`
- `persistPermissionUpdate(...)`
- `SandboxManager.refreshConfig()`

这说明 leader 既是 approval host，又可能顺手修改自己的本地配置。

## 苏格拉底式自审

### 问：为什么这批不该并入 76 的容器家族总论？

答：76 讲的是单个 REPL 宿主里的本地阻塞容器族。

本轮问题已经换成：

- worker ask 如何跨进程进入 leader host queue

也就是：

- cross-process host approval queue

不是：

- same-host modal taxonomy

### 问：为什么不能只写成“worker sandbox 是 77 的平行例子”？

答：因为 78 有自己的非对称增量：

- 不是 `ToolUseConfirm`
- 有本地 host rule side-effect
- queue 类型和 continuation 类型都不同

### 问：为什么这一页仍值得单独长文？

答：因为 UI 上它看起来最容易和 leader 自己的 network prompt 混淆，而源码上它又确实不是那回事。这个错位足够高频，值得单独拆。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/78-sendSandboxPermissionRequestViaMailbox、workerSandboxPermissions、pendingSandboxRequest 与 sandbox callback：为什么 worker sandbox ask 不等于 leader 本地 network prompt.md`
- `bluebook/userbook/03-参考索引/02-能力边界/67-Worker sandbox mailbox ask、workerSandboxPermissions.queue 与 pendingSandboxRequest 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/78-2026-04-06-worker sandbox mailbox queue 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小改动：

- 只把 78 接到 68-78 连续阅读链尾部
- 索引层只补一张 67

不额外大改其它总索引。

## 下一轮候选

1. 压一张 74-78 的 approval shell / worker mailbox / host queue 总索引。
2. 继续拆 teammate mailbox 在 permission / sandbox / plan approval 三条线上的消息族差异。
3. 继续拆 leader 本地持久化规则与 worker continuation 之间的状态分裂。
