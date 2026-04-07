# control side-channel split 拆分记忆

## 本轮继续深入的核心判断

191 已经拆开：

- `control bypass`

但 bridge 读侧还缺一条更细的句子：

- bypass 之后并没有落成统一 control 总线，而是立刻分成 permission verdict 返回腿与 session-control 请求腿

本轮要补的更窄一句是：

- `control_response -> onPermissionResponse` 与 `control_request -> onControlRequest -> handleServerControlRequest(...)` 不是同一种 callback contract

## 为什么这轮必须单列

如果不单列，正文最容易在四种偷换里回卷：

- 把 `control_response` 和 `control_request` 写成对称总线
- 把 `onPermissionResponse` 写成通用 control callback
- 把 env-less 的 `reportState('running')` 包装忽略掉
- 把 29 的 object taxonomy、142 的 wiring、191 的 bypass 重新拼回来

这四种都会把：

- control object
- control callback
- control runtime patch

重新压扁。

## 本轮最关键的新判断

### 判断一：`control_response` 在 ingress 上首先是 permission verdict 返回腿

### 判断二：`onPermissionResponse` 只消费 `pendingPermissionHandlers` 上挂起的 verdict

### 判断三：真正通用的 session-control bus 只存在于 request 腿

### 判断四：env-less 不是把两腿重新对称化，而是给 permission leg 套了一层 `running` 状态修复壳

## 苏格拉底式自审

### 问：为什么这页不是 29 的附录？

答：29 讲控制对象的种类；193 讲 ingress demux 之后控制帧落到哪条 callback 腿上。

### 问：为什么这页不是 142 的附录？

答：142 讲 gray wiring；193 讲 wiring 成立以后 control side-channel 自己为什么已不对称。

### 问：为什么这页不是 191 的附录？

答：191 只说 control payload 不进入 message consumer；193 继续追问 bypass 之后为什么不是统一 control bus。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/193-handleIngressMessage、isSDKControlResponse、isSDKControlRequest、onPermissionResponse 与 onControlRequest：为什么 bridge ingress 的 control side-channel 不是对称的通用 control 总线.md`
- `bluebook/userbook/03-参考索引/02-能力边界/182-handleIngressMessage、isSDKControlResponse、isSDKControlRequest、onPermissionResponse 与 onControlRequest 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/193-2026-04-08-control side-channel split 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 长文层只补 193
- 索引层只补 182
- 记忆层只补 193

不回写 29、142、191。

## 下一轮候选

1. 若继续 ingress 面，可看 user-only transcript adapter 与 non-user `SDKMessage` 没有第二消费面的边界，但必须避免重写 191。
2. 若继续 control 面，可看 permission verdict leg 与 `pendingPermissionHandlers` 的竞态所有权是否值得再拆，但必须避免回卷通用 control bus。
3. 若切回 wider surface，可把 191-193 组织成一组 ingress 阅读簇导航，而不是继续扩正文。
