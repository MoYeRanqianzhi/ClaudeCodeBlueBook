# attached viewer transcript ownership 拆分记忆

## 本轮继续深入的核心判断

第 28 页已经拆开：

- remote session client
- viewer
- bridge host

第 30 页已经拆开：

- `viewerOnly`
- ownership
- runtime surface

第 57 页已经拆开：

- `useRemoteSession`
- `useDirectConnect`
- `useSSHSession`

但还缺一层很容易继续混写的“attached viewer 的 transcript / loading / title ownership”：

- `hasInitialPrompt`
- `useAssistantHistory`
- `anchor_to_latest`
- `before_id`
- `updateSessionTitle(...)`

如果不单独补这一批，正文会继续犯六种错：

- 把 attached viewer 的 loading 写成它自己发起了首问
- 把 attached transcript 写成只来自 live stream
- 把初始补历史写成从会话起点 replay
- 把 older page cursor 写成普通滚动副作用
- 把 title display 写成 title ownership
- 把 history sentinel 写成 remote runtime signal

## 苏格拉底式自审

### 问：为什么这批不能塞回第 28 页？

答：第 28 页回答的是：

- remote session client
- viewer
- bridge host

而本轮问题已经换成：

- attached viewer 看到的 transcript / loading / title 主权到底分别来自哪里

也就是：

- transcript ownership for attached viewer

不是：

- remote workflow taxonomy

### 问：为什么这批不能塞回第 30 页？

答：第 30 页回答的是：

- `viewerOnly`
- ownership
- 运行态 surface

而本轮问题已经换成：

- history API、latest anchor、older cursor、title rewrite 条件

也就是：

- transcript and loading sources

不是：

- runtime ownership summary

### 问：为什么这批不能塞回第 57 页？

答：第 57 页回答的是：

- 三种 remote hook 的连接、重连、权限与退出合同

而本轮问题已经换成：

- `useRemoteSession` 内部 attached viewer 这条线，在 transcript / loading / title ownership 上怎样分叉

也就是：

- one hook’s attached-viewer semantics

不是：

- hook-to-hook contract comparison

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/58-viewerOnly、hasInitialPrompt、useAssistantHistory 与 updateSessionTitle：为什么 attached assistant REPL 的首问加载、历史翻页与会话标题不是同一种主权.md`
- `bluebook/userbook/03-参考索引/02-能力边界/47-Remote attached history、loading 与 title ownership 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/58-2026-04-06-attached viewer transcript ownership 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 正文落笔纪律

### 应写进正文的

- `hasInitialPrompt` 只描述 owner 创建线的初始工作态
- attached viewer 的 transcript 同时来自 live stream 与 history paging
- 初始页走 `anchor_to_latest`，older page 走 `before_id`
- title ownership 只在非 viewerOnly 且无初始 prompt 时发生
- history sentinel 不是 runtime signal

### 不应写进正文的

- `viewerOnly` 的整套 ownership 总论
- scroll-anchor 与 fill-budget 的细部实现
- KAIROS build gating 的全部背景

这些只保留为作者判断依据。

## 本轮特别保留到记忆的源码发现

### owner 首问与 attached loading 分层是本批第一根骨架

没有这根骨架，正文就会把：

- attached viewer 一进来 loading

误写成：

- 它自己发起并拥有了当前首问

### transcript 双来源是本批第二根骨架

没有这根骨架，正文就会把：

- live stream
- history API

重新压成同一种来源。

### title display / title ownership 分层是本批第三根骨架

没有这根骨架，正文就会把：

- 看见标题
- 生成并写回标题

写成一个动作。

## 后续继续深入时的检查问题

1. 我当前讲的是 attached transcript 来源，还是 `viewerOnly` 总论？
2. 我是不是又把 loading 写成首问 ownership？
3. 我是不是又把初始 latest page 写成从头 replay？
4. 我是不是又把 older cursor 写成普通滚动副作用？
5. 我是不是又把 title display 写成 title ownership？
6. 我是不是又把正文滑回 28/30/57 的旧边界？

只要这六问没先答清，下一页继续深入就会重新滑回：

- viewerOnly ownership 复述
- 或 hook 合同比较复述

而不是用户真正可用的 attached viewer transcript ownership 正文。
