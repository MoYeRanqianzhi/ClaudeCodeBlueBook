# bridge session tag 与 compat shim 拆分记忆

## 本轮继续深入的核心判断

第 41 页已经拆开：

- transport URL
- secret
- token
- epoch

第 42 页已经拆开：

- environment
- work
- session lifecycle verbs

但 bridge 仍缺一层非常容易继续混写的 session tag 兼容语义：

- `session_*`
- `cse_*`
- `toCompatSessionId`
- `toInfraSessionId`
- `sameSessionId`
- `sessionCompatIds`

如果不单独补这一批，正文会继续犯六种错：

- 把 `session_*` 与 `cse_*` 写成两条不同 session
- 把 retag helper 与 compare helper 写成同一种函数
- 把 pointer 里的 `session_*` 写成 reconnect 唯一合法 tag
- 把 `sessionCompatIds` 写成新的权威 session 表
- 把 compat shim 写成永久稳定产品层
- 把 archive/title/logger/reconnect 里不同 tag 需求压成同一种 session ID

## 苏格拉底式自审

### 问：为什么这批不能塞回第 41 页？

答：第 41 页解决的是：

- URL、secret、token、epoch 这些 transport credential

而本轮问题已经换成：

- 同一条 session 在不同 surface 穿什么 tag costume

也就是：

- transport material

之后的：

- session identity costume

所以不能再混回 41。

### 问：为什么这批也不能塞回第 42 页？

答：第 42 页解决的是：

- environment / work / session 的生命周期动词

而本轮更偏：

- 这些动词在不同 surface 上该用哪种 tag

也就是：

- lifecycle verbs

之后的：

- cross-surface session identity

所以不能再混回 42。

### 问：为什么不能把它写成“resume 补充说明”？

答：因为真正需要拆开的不是：

- resume 时为什么试两个 candidate

而是：

- 整个 bridge 运行期里 compat-facing 与 infra-facing tag 本来就分层
- resume 只是把这层错位暴露得最明显

如果只写 resume 补充，title / archive / logger 这组 compat-facing 证据会继续丢失。

### 问：这批最该防的偷换是什么？

答：

- compat tag = infra tag
- retag = compare
- pointer tag = reconnect lookup tag
- compat shim = 稳定主线对象

只要这四组没拆开，bridge 的 session 标识正文就还会继续糊。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/43-session tag、compat shim 与 reconnect tag：为什么 bridge 的 compat session ID、infra session ID 与 sameSessionId 不是同一种标识.md`
- `bluebook/userbook/03-参考索引/02-能力边界/32-Remote Control session tag、compat shim 与 reconnect tag 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/43-2026-04-06-bridge session tag 与 compat shim 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 正文落笔纪律

### 应写进正文的

- `session_*` 与 `cse_*` 是同一 UUID 的不同 costume
- `toCompatSessionId` / `toInfraSessionId` 与 `sameSessionId` 的问题域不同
- compat-facing 与 infra-facing 操作对 tag 的要求不同
- compat shim 是条件兼容层，不是永久稳定主线

### 不应写进正文的

- sdk.mjs bundle 依赖限制细节
- GrowthBook 注入路径的全部背景
- every cse shim future-removal note
- all currentSessionId / workSessionId race comments

这些只保留为作者判断依据。

## 本轮特别保留到记忆的源码发现

### `sameSessionId(...)` 最容易被写坏

它不是：

- 把 tag 转成另一种 tag

而是：

- 跨 costume 比较底层 UUID 是否同一条

这条必须持续提醒，否则正文会很容易把 compare helper 写成 retag helper。

### resume 之所以重要，是因为它把三层 tag 错位暴露得最完整

- pointer 存 `session_*`
- reconnect 可能需要 `cse_*`
- current worker / poll 里又可能已经是 `cse_*`

这组对照非常值得保留。

### `sessionCompatIds` 只是 costume cache，不是新主键

这一点如果记忆里不持续提醒，正文会很容易把它抬成另一张 session registry。

### compat shim 必须归到“条件公开”

否则 userbook 会把过渡层写成稳定表面，破坏稳定功能与灰度功能的保护原则。

## 并行 agent 结果

本轮并行 agent 仍在后台侦察；若有稳定回传，只作为后续继续扩展 session identity 线的旁证，不直接回灌本轮正文。

## 后续继续深入时的检查问题

1. 我当前讲的是 compat tag、infra tag，还是底层 UUID 比较？
2. 我当前讲的是 retag helper，还是 compare helper？
3. 我是不是又把 `session_*` 与 `cse_*` 写成了两条 session？
4. 我是不是又把 pointer tag 写成 reconnect 唯一合法 tag？
5. 我是不是把 compat shim 写成了永久稳定主线？

只要这五问没先答清，下一页继续深入就会重新滑回：

- session tag 混写
- 或兼容层细节污染正文

而不是用户真正可用的 bridge session identity 正文。
