# remote metadata restore and writeback 拆分记忆

## 本轮继续深入的核心判断

第 25 页已经拆开：

- 设置面
- 控制面
- 状态面

第 29 页已经拆开：

- `set_permission_mode`
- `set_model`
- session control request

第 51 页已经拆开：

- `worker_status`
- `pending_action`
- `task_summary`
- `session_state_changed`

但还缺一层非常容易继续混写的“远端 metadata 写回与恢复回填”：

- `permission_mode`
- `is_ultraplan_mode`
- `model`

如果不单独补这一批，正文会继续犯六种错：

- 把本地 `toolPermissionContext.mode` 与远端 `permission_mode` 写成同一个值
- 把 `permission_mode` 与 `is_ultraplan_mode` 写成同一种模式
- 把 `model` 与 `permission_mode` 写成同一路自动写回
- 把 `model` 的恢复回填写成统一 mapper 结果
- 把 control request 权限和 restore path 写成同一层
- 把 mode、stage flag 与 model override 写成一张远端设置表

## 苏格拉底式自审

### 问：为什么这批不能塞回第 29 页？

答：第 29 页解决的是：

- 谁能改 session parameter
- `set_permission_mode` / `set_model` 属于哪类 control request

而本轮问题已经换成：

- 改完之后，哪些会写回 metadata
- 下次恢复时怎样回填
- 哪些参数生命周期不同

也就是：

- writeback and restore contract

不是：

- control authority

### 问：为什么这批不能塞回第 25 页？

答：第 25 页解决的是：

- 设置默认
- 当前控制动作
- 状态展示

而本轮问题已经换成：

- 远端 metadata 怎样保存与恢复 session parameter

也就是：

- remote persistence / restore surface

不是：

- settings / control / status surface split

### 问：为什么这批不能塞回第 51 页？

答：第 51 页解决的是：

- phase
- block context
- progress
- SDK broadcast

而本轮问题已经换成：

- 哪些长期 parameter 与阶段标记被写回并恢复

也就是：

- parameter metadata restore

不是：

- runtime state projection

### 问：为什么不能写成“external_metadata 字段大全”？

答：因为真正值得写进正文的不是：

- 所有 metadata key
- 所有 notify / listener 函数名
- 所有 SDK status stream 旁支

而是：

- 哪些参数是长期 parameter
- 哪些只是阶段标记
- 哪些写回路径不同
- 哪些恢复路径不同

如果写成字段大全，正文会再次掉回目录学。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/52-permission_mode、is_ultraplan_mode 与 model：为什么远端恢复回填、当前本地状态与 session control request 不是同一种会话参数.md`
- `bluebook/userbook/03-参考索引/02-能力边界/41-Remote Control permission_mode、is_ultraplan_mode 与 model restore 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/52-2026-04-06-remote metadata restore and writeback 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 正文落笔纪律

### 应写进正文的

- `permission_mode` 是外化去噪后的镜像，不是本地 mode 原样
- `is_ultraplan_mode` 是一次性阶段标记
- `model` 的写回链与恢复链都和 mode 不同
- control authority 与 restore path 是不同层

### 不应写进正文的

- 全部 function 名与 listener 细节
- SDK status stream 的旁支
- 其他 metadata 键大全
- 与 29 页重复的 control request 长篇

这些只保留为作者判断依据。

## 本轮特别保留到记忆的源码发现

### `model` 不走 mode 那条中心 diff 写回

这是本批第一根骨架。

### `is_ultraplan_mode` 只能写成阶段标记

这是本批第二根骨架。

### 恢复时 mode / ultraplan 与 model 也不是同一路回填

这是本批第三根骨架。

如果不持续提醒，正文很容易把三者重新压成同一种 metadata。

## 并行 agent 处理策略

本轮继续按多 agent 旁路勘探执行：

- 一路判断这批是否与 25 / 29 / 51 重复
- 一路收敛 stable / conditional / internal 边界
- 一路给路径与标题命名

主线程在本轮不等待 agent 结论先落笔，因为本地写回链和恢复链已经足够收敛本批边界。

## 后续继续深入时的检查问题

1. 我当前讲的是 control authority，还是 restore path？
2. 我是不是又把本地 mode 和远端 `permission_mode` 写成了同一个值？
3. 我是不是又把 `is_ultraplan_mode` 写成了长期 mode？
4. 我是不是又把 `model` 写成了和 mode 同一路自动写回？
5. 我是不是又把三者写成了一张远端设置表？
6. 我是不是又把正文滑回 external_metadata 字段大全？

只要这六问没先答清，下一页继续深入就会重新滑回：

- 参数生命周期混写
- 或字段目录学污染正文

而不是用户真正可用的远端 metadata 恢复回填正文。
