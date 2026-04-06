# headless remote-control startup verdict 拆分记忆

## 本轮继续深入的核心判断

第 20 页已经拆开：

- headless / print 的宿主合同
- StructuredIO / RemoteIO
- 首问就绪链

第 23 页已经拆开：

- workspace trust
- bridge eligibility
- trusted-device

第 35 页已经拆开：

- trust / login / restart / fallback / retry 这些用户修复建议

第 37 页已经拆开：

- worktree / same-dir / single-session 这些 spawn topology

但还缺一层非常容易继续混写的 worker-startup verdict：

- interactive host 直接退出
- headless worker 的 permanent error
- headless worker 的 transient retry
- session pre-create 的 non-fatal continue
- saved worktree pref 的 warning + fallback

如果不单独补这一批，正文会继续犯六种错：

- 把 trust 缺失与 token 缺失写成同一种启动失败
- 把 HTTP-only base URL 与 registration failure 写成同一种失败
- 把 saved worktree pref fallback 与 explicit worktree hard fail 写成同一种错误
- 把 interactive `process.exit(1)` 与 headless `permanent/transient` verdict 写成同一种处理
- 把 session pre-create 的 non-fatal continue 写成 headless startup 整体失败
- 把 page 35 的用户修复建议写成 worker retryability
- 把注释里的 park / backoff 契约写成已展开的 supervisor 实现

## 苏格拉底式自审

### 问：为什么这批不能塞回第 20 页？

答：第 20 页解决的是：

- headless 宿主与 REPL 的 I/O 合同
- StructuredIO / RemoteIO
- 首问前等什么、不等什么

而本轮问题已经换成：

- worker 在启动前置条件上如何分 permanent / transient
- interactive host 与 headless worker 为什么不是同一种失败合同

也就是：

- startup verdict semantics

不是：

- host I/O contract

### 问：为什么这批不能塞回第 23 页？

答：第 23 页解决的是：

- trust、eligibility、trusted-device 不是同一把钥匙

而本轮要继续下钻的是：

- trust 缺失在 worker 语义里为什么是 permanent
- token 缺失为什么反而是 transient
- HTTP / worktree substrate 为什么也是 permanent

也就是：

- retryability verdict by broken plane

不是单纯：

- capability gates taxonomy

### 问：为什么这批不能塞回第 35 页？

答：第 35 页解决的是：

- 用户现在该跑 `claude`
- 还是 `/login`
- 还是 restart remote-control
- 还是接受 fallback / retry

而本轮关心的是：

- worker 要不要交给 supervisor 继续 backoff
- 哪些失败本来就不该继续拉起

也就是：

- host-side retry policy

不是：

- user-facing repair advice

### 问：为什么这批不能写成“headless 开桥错误大全”？

答：因为真正值得写进正文的不是：

- 全部 console 文案
- 所有 bootstrap 细节
- 所有 exit code 常量

而是：

- broken plane
- host contract
- retryability verdict
- warning/fallback 与 hard fail / permanent / transient 的区别

如果写成错误大全，正文会再次被实现噪音污染。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/48-Workspace not trusted、login token、HTTP base URL、worktree availability 与 registration failure：为什么 headless remote-control 的 permanent error 与 transient retry 不是同一种开桥失败.md`
- `bluebook/userbook/03-参考索引/02-能力边界/37-Remote Control headless startup permanent error 与 transient retry 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/48-2026-04-06-headless remote-control startup verdict 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 正文落笔纪律

### 应写进正文的

- interactive host 与 headless worker 的失败合同不同
- trust / HTTP / worktree substrate 在 worker 语义里是 permanent
- token 缺失与 registration failure 在 worker 语义里是 transient
- session pre-create 失败只是 non-fatal continue
- saved worktree pref fallback 不是 explicit worktree hard fail
- park / backoff 只按注释推断，不假装看到 supervisor 实现

### 不应写进正文的

- 所有 bootstrap 初始化细节
- 所有 exit code 常量猜测
- trusted-device 的旁支
- 全部 interactive 文案总表
- 与 page 35 重复的修复建议展开

这些只保留为作者判断依据。

## 本轮特别保留到记忆的源码发现

### `BridgeHeadlessPermanentError` 这一批值得保留，但不能抬成正文主角

正文真正该写的是：

- permanent vs transient 的用户可理解判定

而不是：

- 类型名本身

### `saved worktree pref` 的 warning + fallback 是本批第二根骨架

若不保留，正文很容易把：

- 偏好回退
- 显式 worktree hard fail
- worker permanent error

重新写平。

### `session pre-creation failed (non-fatal)` 是第三桶，不能漏掉

若不保留，正文很容易把：

- registration failed
- session pre-create failed

重新写成同一种 startup failure。

### supervisor 行为必须明确标成“基于注释的推断”

这是本批第四根骨架。

当前源码能直接看到的是：

- worker 注释
- worker 抛错契约

而不是：

- supervisor 的完整实现

## 并行 agent 处理策略

本轮继续按多 agent 旁路勘探执行：

- 一路评估这批是否与 20 / 23 / 35 / 37 重复
- 一路收敛 stable / conditional / internal 边界
- 一路给标题、索引与阅读路径命名

主线程仍不等待旁证返回才落笔，因为源码主锚点已足够收敛本批边界。

## 后续继续深入时的检查问题

1. 我当前讲的是 user repair advice，还是 worker retryability？
2. 我当前讲的是 trust/auth/policy taxonomy，还是 startup verdict？
3. 我是不是又把 `process.exit(1)` 与 permanent worker failure 写成同一种处理？
4. 我是不是又把 saved worktree fallback 写成了 hard fail？
5. 我是不是又把 `session pre-creation failed (non-fatal)` 写成了整体启动失败？
6. 我是不是又把 supervisor 行为写成了已见源码实现？
7. 我是不是又把正文滑回“错误文案大全”？

只要这六问没先答清，下一页继续深入就会重新滑回：

- verdict 语义混写
- 或错误目录学污染正文

而不是用户真正可用的 headless remote-control startup 正文。
