# session-viewer continuation vs formal-restore echo 拆分记忆

## 本轮继续深入的核心判断

在上一刀已经把：

- `01-主线使用/04-会话、恢复、压缩与记忆.md`

补成

- `viewer / preview / history` 只是消费恢复资产

之后，

这一轮不该继续改：

- `158-...为什么 /resume 的 preview transcript 不是正式 session restore.md`

也不该把：

- `/session`
- `/remote-control`
- bridge host

重新混回一页更大的总结，

而应只在：

- `02-能力地图/05-体验与入口/03-Session 与 Remote-control：多宿主生命周期.md`

补一句本地 proof-level echo。

## 为什么这轮值得单独提交

### 判断一：当前最小缺口不在“有没有 formal restore 的证明”，而在“/session 会不会被顺手误读成 restore”

现在这条链已经分成三层：

- `158`
  证明 `preview transcript != formal restore`
- `05-体验与入口/README.md`
  把 `viewer continuation / preview / history`
  定成 consumption
- `01-主线使用/04-会话、恢复、压缩与记忆.md`
  把消费面踢出 continuity 本体

但落到：

- `03-Session 与 Remote-control：多宿主生命周期.md`

时，

当前仍有一句：

- `/session` 面向远端 session 的接续与暴露

如果没有再多一声本地 echo，

读者仍容易把：

- “接续”

顺手听成：

- formal restore

所以这一刀真正补的是：

- `/session` 的接续只是一条 `remoteSessionUrl` 暴露面

不是 restore 本体。

### 判断二：这句必须用 `remoteSessionUrl` 来写，而不能直接搬 `ownership handoff` 术语

并行只读分析指出，

原始直觉文案里若直接写：

- `viewer/client 侧附着`
- `runtime ownership handoff`

会同时激活三套不同语义：

- `--remote` owner-client
- attached viewer / viewerOnly
- `/remote-control` / bridge host

所以当前最稳的写法，

不是把 `158` 的术语生搬硬套过来，

而是把对象收窄成：

- `--remote` 链上的 `remoteSessionUrl`

这样才不会把体验层 proof 句写成控制面恢复判词。

## 这轮具体怎么拆

这轮只做一件事：

1. 在 `03-Session 与 Remote-control：多宿主生命周期.md`
   的第一条链内部，
   也就是：
   - `5. /session 只是把这个远端 session 的 URL / QR 暴露出来`
   后面，
   再补一句：
   - `/session` 只负责暴露已存在的 `remoteSessionUrl`，供其他 viewer/client 继续接入同一条远端 session；把这条会话创建或恢复出来的是 `--remote` / teleport 这条链，它不是 `/resume` 式 formal restore

这样：

- `/session` 的 URL surface
  不再被误读成 restore 本体
- `/session` 与 `--remote`
  的暴露/创建关系也被写成同一条链内的局部事实
- 体验 proof 叶子页与上游 README / 下游控制面证明页之间的职责更清楚

## 苏格拉底式自审

### 问：为什么不直接去改 `158`，让它顺手提一句 `/session`？

答：因为 `158` 的主轴是本地 `/resume` 的 preview vs formal restore。把 `/session` 塞进去，会把 remote attach / URL surface 和 ownership handoff 混成同一条证明链。

### 问：为什么这句要放回第一条链内部，而不是继续留在 `/session` 与 `/remote-control` 对照段？

答：因为当前更缺的是 `/session` 对 `--remote` 的局部角色关系，而不是再把 `/session` 与 `/remote-control` 拉成更大的对照句。把它放回第一条链内部，更不容易串轴。

### 问：为什么不同时把 `02-执行与工具/02-任务对象、输出回流、通知与恢复.md` 也改掉？

答：因为那已经是下一条横轴：`task recovery != /resume 本体`。本轮继续只做体验层 proof 句，不能把消费面和后台对象恢复混成一刀。
