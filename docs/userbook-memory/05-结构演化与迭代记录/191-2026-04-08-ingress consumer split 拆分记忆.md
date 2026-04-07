# ingress consumer split 拆分记忆

## 本轮继续深入的核心判断

55 已经拆开：

- dedup family taxonomy

190 已经拆开：

- REPL write contract vs daemon write contract

但 bridge 读入侧还缺一句更窄的判断：

- 同一个 ingress reader 自己就不是同一种 consumer contract

本轮要补的更窄一句是：

- `handleIngressMessage(...)`、`recentPostedUUIDs`、`recentInboundUUIDs` 与 `onInboundMessage` 应分别落在 control side-channel bypass、outbound echo drop、inbound replay guard 与 user-only consumer domain 四层

## 为什么这轮必须单列

如果不单列，正文最容易在四种偷换里回卷：

- 把 ingress reader 写成单一 dedup gate
- 把 `recentPostedUUIDs` / `recentInboundUUIDs` 写成同一种 UUID 去重
- 把 non-user ignore 写成 dedup 特例
- 把 55 的 family taxonomy 或 142 的 wiring 主题重新拼回来

这四种都会把：

- control routing
- dedup
- consumer domain

重新压扁。

## 本轮最关键的新判断

### 判断一：control payload 先走 side-channel bypass，不进入 SDK message consumer

### 判断二：`recentPostedUUIDs` 负责 outbound echo drop

### 判断三：`recentInboundUUIDs` 负责 inbound replay guard

### 判断四：`onInboundMessage` 只消费 user message，non-user ignore 是 domain narrowing

## 苏格拉底式自审

### 问：为什么这页不是 55 的附录？

答：55 讲的是不同 dedup family 彼此不是同一种；191 讲的是在一个 shared reader 里，这些 family 与 type-routing 如何再分合同。一个问 taxonomy，一个问 consumer split。

### 问：为什么这页不是 142 的附录？

答：142 讲的是这条 reader 有没有被 wiring 进 gray runtime；191 讲的是一旦进入执行态，这条 reader 自己怎样分成不同 consumer contract。

### 问：为什么 non-user ignore 不能当作 dedup 结果？

答：因为它不是“已处理过所以丢掉”，而是从一开始就不属于 `onInboundMessage` 这条 consumer 域。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/191-handleIngressMessage、recentPostedUUIDs、recentInboundUUIDs 与 onInboundMessage：为什么 outbound echo drop、inbound replay guard 与 non-user ignore 不是同一种 ingress consumer contract.md`
- `bluebook/userbook/03-参考索引/02-能力边界/180-handleIngressMessage、recentPostedUUIDs、recentInboundUUIDs 与 onInboundMessage 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/191-2026-04-08-ingress consumer split 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 长文层只补 191
- 索引层只补 180
- 记忆层只补 191

不回写 55、142、190。

## 下一轮候选

1. 若继续 bridge 线，可看 control_request / control_response 的 side-channel contract 是否还能更窄拆一层，但必须避免把 191 再切碎成重复页。
2. 若切回 model 线，可整理 184-188 的阅读簇提示，但不应把正文膨胀成综述。
3. 若转去 reader surface，可看 non-user ingress 与 viewer-side consumer 是否需要一条跨前端 consumer 厚度页，但必须避免重写 114-116。
