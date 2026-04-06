# visibility tables from builder transport to UI consumer 拆分记忆

## 本轮继续深入的核心判断

108、110 已经把 direct connect 里的两个关键 family 压开了。

但如果只停在那两页，读者仍然会保留一个更高层的误解：

- 反正最后都在讲“消息能不能被看到”，那 `controlSchemas`、`agentSdkTypes`、`directConnectManager`、`useDirectConnect` 应该只是同一张可见性表的不同实现位置

这轮要补的更窄一句是：

- 从 builder/control transport 到 UI consumer 至少有四张逐级收窄的表
- 不是一张 universal visibility table

## 为什么这轮必须单列

如果不单列，正文最容易在两种错误里摇摆：

- 把 `controlSchemas` 写成 public SDK 定义
- 把 callback 结果直接写成 UI transcript 结果

这两种都会把：

- wider transport
- public/core SDK
- callback surface
- UI consumer

四层对象重新压平。

## 本轮最关键的新判断

### 判断一：`controlSchemas.ts` 和 `agentSdkTypes.ts` 从文件头就已经在回答不同问题

这句是本轮最需要钉死的根句。

### 判断二：`directConnectManager` 站在 transport 与 callback 之间，不是终态可见性终点

所以不能拿 manager 的结果去替代整条链。

### 判断三：`useDirectConnect` + `sdkMessageAdapter` 是另一层 consumer 收窄

所以“进入 `onMessage`”依然不等于“进入 UI transcript”。

## 苏格拉底式自审

### 问：为什么这页不能并回 108？

答：因为 108 讲 `post_turn_summary` 在 direct connect 里的单点 narrowing；111 讲从 transport 到 UI 的整张表栈。

### 问：为什么这页不能并回 110？

答：因为 110 讲同一 skip list 内两个 family 的 provenance split；111 讲不同文件/不同 consumer 回答的是不同 visibility question。

### 问：为什么要反复强调“表”而不是“消息”？

答：因为这轮真正要纠偏的是读者对层级的误判，不是再增加一个 family 个案。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/111-controlSchemas、agentSdkTypes、directConnectManager、useDirectConnect 与 sdkMessageAdapter：为什么 builder transport、callback surface 与 UI consumer 不是同一张可见性表.md`
- `bluebook/userbook/03-参考索引/02-能力边界/100-builder transport、public SDK、direct-connect callback 与 UI consumer 可见性分层 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/111-2026-04-06-visibility tables from builder transport to UI consumer 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 长文层只补 111
- 索引层只补 100
- 记忆层只补 111

不需要新增目录，只更新导航即可。

## 下一轮候选

1. 单独拆 `shouldIncludeInStreamlined(...)`、assistant/result 双入口与 null suppression 为什么不是同一种“消息简化”。
2. 单独拆 `result` 在 streamlined path 里 passthrough、在 `lastMessage` 里保终态主位，为什么不是同一种“保留原样”。
3. 单独拆 `convertSDKMessage(...)` 的 `message` / `stream_event` / `ignored` 三分法为什么不是 callback surface 的镜像映射。
