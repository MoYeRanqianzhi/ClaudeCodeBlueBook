# remote session client 与 viewer 边界拆分记忆

## 本轮继续深入的核心判断

第 27 页已经拆开了 remote-control 的入口矩阵：

- 会内开桥
- 启动带桥
- standalone host
- first-run callout

但仍然有一块高频误判没有被正文单独稳定拆出：

- `claude --remote`
- `/session`
- footer remote pill
- `claude assistant [sessionId]`
- `REMOTE_SAFE_COMMANDS`
- `remoteConnectionStatus` / `remoteBackgroundTaskCount`

如果不补这一批，正文会继续犯六种错：

- 把 `--remote` 写成 viewer attach
- 把 `assistant [sessionId]` 写成“另一种创建远端 session”
- 把 `/session` 写成 generic remote-mode 命令
- 把 `remoteSessionUrl` 写成所有 remote mode 共有字段
- 把 remote-safe 与 bridge-safe 命令合同混成一张表
- 把 remote session client / viewer 与 bridge host 重新压成一种“远程模式”

## 苏格拉底式自审

### 问：为什么这批不能塞回第 21 页？

答：第 21 页回答的是：

- host / viewer / health-check 这三类大对象

而本轮问题变成：

- 当对象已经收窄到 remote session 这一支时，client、viewer、URL surface、命令合同又如何继续分层

这已经从高层对象分类，进入：

- remote session branch 的内部边界

所以值得另起一页。

### 问：为什么这批不能塞回第 26 或 27 页？

答：因为：

- 第 26 页讲的是 locator boundary
- 第 27 页讲的是 remote-control entrypoint boundary

本轮要讲的是：

- remote session client / viewer boundary

如果硬塞回去，会把不同层面重新混回一页。

### 问：为什么这批值得进入正文，而不是只留在记忆？

答：因为这些都是用户能直接碰到的误判：

- 为什么 `--remote` 有时直接打印 URL 退出，有时进入 TUI？
- 为什么 `/session` 不是任意 remote mode 都能用？
- 为什么 assistant viewer 和 `--remote` 都像“远端 REPL”，但行为不一样？
- 为什么 remote-safe commands 和 remote-control bridge safe commands 不是一张表？

这些都属于使用层主线。

### 问：这批最该防的假并列是什么？

答：

- `--remote` = `assistant`
- `remoteSessionUrl` = remote mode
- remote-safe = bridge-safe

只要这三组没拆开，远端工作流正文就还会继续糊。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/28-remote 会话、session 命令、assistant viewer 与 remote-safe commands：为什么远端会话 client、viewer 与 bridge host 不是同一种远程工作流.md`
- `bluebook/userbook/03-参考索引/02-能力边界/17-Remote Session Client、Viewer 与 Bridge Host 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/28-2026-04-06-remote session client 与 viewer 边界拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 正文落笔纪律

### 应写进正文的

- `--remote` 是创建新远端 session 再接入
- `/session` 和 remote pill 只属于 `remoteSessionUrl` 链
- assistant 是 viewer client，不是新建远端 session
- `viewerOnly` 的用户可见后果值得写进正文
- `REMOTE_SAFE_COMMANDS` 与 `BRIDGE_SAFE_COMMANDS` 不是同一种命令合同
- `remoteConnectionStatus` / `remoteBackgroundTaskCount` 属于 remote session 运行面，不属于 bridge host 状态

### 不应写进正文的

- 完整 WebSocket / ingress 实现
- 所有消息转换分支
- 所有 reconnect / timeout 细节
- 底层 protocol 和 API 细枝末节

这些内容只保留在作者判断层，不回流正文。

## 本轮特殊注意

### “都连到远端”不等于“同一条工作流”

本轮最容易犯的偷换是：

- 反正最后都是远端跑

于是误写成：

- `--remote`、assistant viewer、remote-control host 本质一样

但源码清楚区分了：

- 谁创建 session
- 谁只做 viewer
- 谁是 host

正文必须保留这个 ownership boundary。

### “remote mode”本身也是分层概念

另一个容易滑坡的点是：

- 既然都 `setIsRemoteMode(true)`

于是误写成：

- 所有 remote mode surface 都一致

但源码显示：

- `remoteSessionUrl` 只是其中一条更窄的 URL surface
- `/session` 只认这条 URL

所以正文必须写清：

- remote mode 比 `remoteSessionUrl` 更宽

## 后续继续深入时的检查问题

1. 我现在拆的是 remote session client / viewer boundary，还是又回到了 bridge host boundary？
2. 这个 surface 依赖的是 remote-mode 状态，还是 `remoteSessionUrl` 这条窄链？
3. 这个命令合同是 remote-safe，还是 bridge-safe？
4. 我是不是又把 client、viewer、host 压回一种远程工作流？

只要这四问没先答清，下一页继续深入就会重新滑回：

- 远程入口名词堆砌
- 或实现细节笔记

而不是读者真正可用的远端会话正文。
