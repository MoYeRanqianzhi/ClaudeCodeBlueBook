# standalone remote-control 传输凭证与纪元拆分记忆

## 本轮继续深入的核心判断

第 26 页已经拆开：

- connect URL
- session URL
- environment ID
- session ID
- `remoteSessionUrl`

第 39 页已经拆开：

- host flags
- session default policy
- child runtime constraint
- title fallback

第 40 页已经拆开：

- tool approval
- sandbox network ask
- approval race
- prompt teardown

但 standalone remote-control 仍缺一层非常容易继续混写的 transport credential 语义：

- `sessionIngressUrl`
- `sdkUrl`
- `environmentSecret`
- session access token
- `workerEpoch`

如果不单独补这一批，正文会继续犯七种错：

- 把 `sdkUrl` 写成用户会打开的链接
- 把 `sessionIngressUrl` 和 `apiBaseUrl` 写成同一个 base
- 把 `environmentSecret` 写成 session token
- 把 `workerEpoch` 写成另一个 session ID
- 把 environment 级认证和 session 级认证压成同一种密钥
- 把 v2 专属纪元写成所有 remote-control 都有的稳定字段
- 把用户可见定位符重新混回内部 transport 凭证

## 苏格拉底式自审

### 问：为什么这批不能塞回第 26 页？

答：第 26 页解决的是：

- 给用户看的链接和 ID

也就是：

- 哪些是 environment / session 的定位符

而本轮问题已经换成：

- host 和 child 真正靠什么 URL、secret、token、epoch 连起来

也就是从：

- user-facing locators

继续下钻到：

- transport credentials and generation markers

所以需要新起一页。

### 问：为什么这批也不能塞回第 39 页？

答：第 39 页解决的是：

- host flags 如何继承到 session object / child runtime

而本轮更偏：

- 这些 child 到底拿什么 endpoint 和 credential 进入 transport

也就是：

- configuration inheritance

之后的：

- runtime transport materialization

所以不能再混回 39。

### 问：为什么不能把它写成“v2 补充说明”？

答：因为真正需要拆开的不是：

- v2 额外多了什么字段

而是：

- URL、secret、token、epoch 这四种对象根本不是一类
- 即使在 v1，也已经存在 `sdkUrl`、`sessionIngressUrl` 与 session token 的分层
- v2 只是把 `workerEpoch` 这条轴再显化出来

如果只写 v2 补充，v1 / v2 共享的 transport credential 骨架会继续缺失。

### 问：这批最该防的偷换是什么？

答：

- 用户入口链接 = child transport target
- environment credential = session credential
- epoch = identity
- API base = ingress base
- 可显示 ID = 可暴露 secret

只要这五组没拆开，standalone remote-control 的 transport 正文就还会继续糊。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/41-sdk-url、sessionIngressUrl、environmentSecret、session access token 与 workerEpoch：为什么 standalone remote-control 的 URL、密钥、令牌与传输纪元不是同一种连接凭证.md`
- `bluebook/userbook/03-参考索引/02-能力边界/30-Remote Control sdk-url、session ingress、environment secret、access token 与 worker epoch 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/41-2026-04-06-standalone remote-control 传输凭证与纪元拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 正文落笔纪律

### 应写进正文的

- `sessionIngressUrl` 是 ingress base，`sdkUrl` 是 child transport target
- `environmentSecret` 是 environment poll credential
- session access token 是 session ingress / heartbeat credential
- `workerEpoch` 是 v2 generation marker，不是 ID
- `apiBaseUrl` 与 `sessionIngressUrl` 在某些本地场景下明确分层

### 不应写进正文的

- token refresh scheduler 何时覆盖哪个字段的全部时序
- epoch mismatch 的所有恢复枝节
- Envoy 重写与 localhost 版本号切换的全部历史兼容背景
- debug 日志里 access token present / missing 的实现噪音
- 各 transport uploader 的批量细节

这些只保留为作者判断依据。

## 本轮特别保留到记忆的源码发现

### `sdkUrl` 和 `sessionIngressUrl` 的关系最容易被写坏

它们不是：

- base URL 与展示 URL 的简单关系

而是：

- host 保存的 ingress base
- child 最终使用的 per-session transport target

如果记忆里不持续提醒，正文非常容易把它重写成“另一个 session URL”。

### `environmentSecret` 与 session token 正好形成第一性原理对照

源码非常清楚地分成：

- pollForWork 用 `environmentSecret`
- heartbeat / child session 用 session token

这组对照是正文最值得保留的骨架之一。

### `workerEpoch` 必须被写成 generation，不是 identity

只要把它写成：

- 另一个 session ID
- 或另一种 token

整条 v2 transport 叙事就会错位。

### 第 26 页只够解释“看到什么”，不够解释“内部靠什么连”

第 26 页的边界已经足够稳。

本轮不该回去改写那一页，而应继续在新页里解释：

- host / child / v2 worker 各自靠什么对象连起来

## 并行 agent 结果

本轮并行 agent 返回依旧不稳定，因此本轮正文判断仍以主线本地源码复核为准。

agent 结果只保留为：

- 后续继续扩展 transport 专题时的旁证来源

而不直接回灌正文。

## 后续继续深入时的检查问题

1. 我当前讲的是用户定位符，还是内部 transport 凭证？
2. 我当前讲的是 environment 级对象，还是 session 级对象？
3. 我是不是又把 `sdkUrl` 写成了用户入口链接？
4. 我是不是又把 secret、token、epoch 写成同一种凭证？
5. 我是不是又把 v2 专属对象误写成所有 remote-control 的稳定表面？

只要这五问没先答清，下一页继续深入就会重新滑回：

- URL / 凭证混写
- 或 transport 内部细节污染正文

而不是用户真正可用的 standalone remote-control transport 正文。
