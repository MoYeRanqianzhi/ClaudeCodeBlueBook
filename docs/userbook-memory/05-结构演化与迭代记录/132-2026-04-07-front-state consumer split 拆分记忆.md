# front-state consumer split 拆分记忆

## 本轮继续深入的核心判断

130 已经把 surface presence 拆出来了，

131 又把 remote session 内部的几张账拆出来了。

但如果继续往下不补这一页，读者还是会把：

- direct connect
- remote session
- bridge

重新压成一句：

- “三条链路都在消费同一套远端状态，只是 UI 厚度不同。”

这轮要补的更窄一句是：

- bridge 能形成 transcript/footer/dialog/store 对齐，而 direct connect、remote session 更多只是前台事件投影

## 为什么这轮必须单列

如果不单列，正文最容易在三种错误里摇摆：

- 把 transcript projection 写成 authoritative state consumer
- 把 remote session 的 partial shadow 写成完整前台状态体系
- 把 bridge v2 的能力偷换成 bridge 全时稳定合同

这三种都会把：

- authoritative state
- local shadow
- transcript projection
- multi-surface consumer alignment

重新压扁。

## 本轮最关键的新判断

### 判断一：正式运行态应先认 `SessionState + SessionExternalMetadata`

### 判断二：direct connect 主要是 transcript + permission queue，不是 dedicated front-state shadow

### 判断三：remote session 主要是 event projection + partial shadow，不是完整 front-state consumer

### 判断四：bridge 才最接近 transcript/footer/dialog/store 对齐

### 判断五：这条结论还必须带上 v1/v2 条件差异

## 苏格拉底式自审

### 问：为什么这页不能并回 28？

答：28 讲 workflow shape；132 讲 consumer topology。

### 问：为什么这页不能并回 130？

答：130 讲 presence；132 讲 authoritative runtime state 的消费断点。

### 问：为什么这页不能并回 131？

答：131 讲 remote session 内部四张账；132 讲三条链路跨路径的前台消费结构。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/132-worker_status、external_metadata、AppState shadow 与 SDK event projection：为什么 bridge 能形成 transcript-footer-dialog-store 对齐，而 direct connect、remote session 更多只是前台事件投影.md`
- `bluebook/userbook/03-参考索引/02-能力边界/121-worker_status、external_metadata、AppState shadow 与 SDK event projection 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/132-2026-04-07-front-state consumer split 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 长文层只补 132
- 索引层只补 121
- 记忆层只补 132

不扩目录，不回写旧页。

## 下一轮候选

1. 单独拆 `post_turn_summary`、`pending_action`、`task_summary` 在 schema/store 里存在，却为什么并不等于当前前台已经消费。
2. 单独拆 bridge v1 / v2 在 front-state consumer 上的能力分叉，为什么“bridge”不是一条完全统一的状态消费链。
3. 单独拆 direct connect 为什么更像 transcript+permission queue 驱动的交互壳，而不是 remote session / bridge 那种有显式远端状态面的模式。
