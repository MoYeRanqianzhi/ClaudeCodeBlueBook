# remote session hook contract 拆分记忆

## 本轮继续深入的核心判断

第 21 页已经拆开：

- host
- viewer
- health check

第 28 页已经拆开：

- remote session client
- viewer
- bridge host

第 30 页已经拆开：

- `viewerOnly`
- ownership
- runtime surface

但还缺一层很容易继续混写的“三种远端会话 hook 同形接口、异形合同”：

- `useRemoteSession`
- `useDirectConnect`
- `useSSHSession`

如果不单独补这一批，正文会继续犯六种错：

- 把同一个 REPL 接口写成同一种会话合同
- 把 session ownership 写成 server socket
- 把 WebSocket 直连写成 SSH child process
- 把三条线的 reconnect / exit 语义写成一种“远端断线”
- 把 `viewerOnly` / `hasInitialPrompt` 的 ownership 差异漏掉
- 把 remoteSession 的完整权限合同与 directConnect/ssh 的窄路径写平

## 苏格拉底式自审

### 问：为什么这批不能塞回第 28 页？

答：第 28 页回答的是：

- remote session client
- viewer
- bridge host

而本轮问题已经换成：

- REPL 内部三个远端 hook 为什么同形不同约

也就是：

- runtime hook contract

不是：

- remote workflow taxonomy

### 问：为什么这批不能塞回第 30 页？

答：第 30 页回答的是：

- `viewerOnly`
- ownership
- 运行态告警面

而本轮问题已经换成：

- `useRemoteSession` 与 `useDirectConnect` / `useSSHSession` 的 transport、reconnect、exit 合同差异

也就是：

- remote hook lifecycle contract

不是：

- runtime surface ownership

### 问：为什么这批不能写成“远端入口大全”？

答：因为真正值得写进正文的不是：

- 所有 CLI 入口
- 所有 manager 类型
- 所有 config 字段

而是：

- 共享 REPL shape
- ownership line
- direct server socket line
- SSH child-process line
- reconnect / exit contract

如果写成入口大全，正文会再次滑回目录学。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/57-useRemoteSession、useDirectConnect 与 useSSHSession：为什么看起来都是远端 REPL，但连接、重连、权限与退出不是同一种会话合同.md`
- `bluebook/userbook/03-参考索引/02-能力边界/46-Remote useRemoteSession、useDirectConnect 与 useSSHSession 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/57-2026-04-06-remote session hook contract 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 正文落笔纪律

### 应写进正文的

- 三条线共享 REPL 四元接口，但生命周期不同
- `useRemoteSession` 是 session ownership 合同
- `useDirectConnect` 是 direct server socket 合同
- `useSSHSession` 是 SSH child-process 合同
- reconnect / exit / permission / title ownership 的实际差异

### 不应写进正文的

- 所有 CLI 入口帮助文本
- manager 内部实现细节
- auth proxy 的全部创建细节

这些只保留为作者判断依据。

## 本轮特别保留到记忆的源码发现

### “同形接口，不同合同”是本批第一根骨架

没有这根骨架，正文就会把：

- `isRemoteMode / sendMessage / cancelRequest / disconnect`

写成：

- 同一种 remote mode

### reconnect / exit 差异是本批第二根骨架

没有这根骨架，正文就会把：

- timeout reconnect
- fail-fast disconnect
- SSH stderr shutdown

写成同一种“断了以后怎么办”。

### ownership 差异是本批第三根骨架

没有这根骨架，正文就会把：

- `viewerOnly`
- `hasInitialPrompt`
- title rewrite
- interrupt authority

重新写平。

## 后续继续深入时的检查问题

1. 我当前讲的是高层入口，还是 REPL 内部 hook contract？
2. 我是不是又把 session ownership 写成 direct socket？
3. 我是不是又把 direct connect 与 SSH 写成同一种 transport？
4. 我是不是又把 reconnect / exit 写成一种统一后果？
5. 我是不是又把 ownership 差异漏掉了？
6. 我是不是又把正文滑回入口/manager 目录学？

只要这六问没先答清，下一页继续深入就会重新滑回：

- 入口分类复述
- 或实现对象目录学

而不是用户真正可用的 remote session hook contract 正文。
