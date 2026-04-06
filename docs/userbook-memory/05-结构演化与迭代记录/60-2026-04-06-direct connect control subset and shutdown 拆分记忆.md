# direct connect control subset and shutdown 拆分记忆

## 本轮继续深入的核心判断

第 59 页已经拆开：

- `cc://`
- `createDirectConnectSession(...)`
- `ws_url`
- `work_dir`
- fail-fast disconnect

但第 59 页回答的是：

- direct connect 的建会话与 transport contract

不是：

- direct connect 跑起来之后，哪些控制消息会被承接、哪些只被过滤、哪些会变成权限投影、哪些才会触发真正的退出

而源码里这条线仍然有一组很容易继续混写的对象：

- `can_use_tool`
- unsupported `control_request`
- synthetic assistant message
- tool stub
- `interrupt`
- `result`
- `Server disconnected.`
- `Failed to connect to server at ...`
- `control_response`
- `keep_alive`

如果不单独补这一批，正文会继续犯六种错：

- 把 SDK 协议全集写成 direct connect 的实际支持面
- 把权限弹层写成远端 transcript 正文
- 把 `interrupt` 写成 disconnect
- 把 `result` 写成 transport end
- 把固定 stderr 文案写成远端 stderr 原文
- 把“没显示”写成“协议上没发生”

## 苏格拉底式自审

### 问：为什么这批不能塞回第 59 页？

答：第 59 页回答的是：

- 建会话
- 拿 `ws_url`
- workspace writeback
- fail-fast transport contract

而本轮问题已经换成：

- 运行中的 direct connect 究竟怎样处理 control request、turn end、transport death 与用户可见投影

也就是：

- runtime control subset and shutdown semantics

不是：

- session factory semantics

### 问：为什么这批不能塞回第 57 页？

答：第 57 页回答的是：

- 三种远端 hook 的对比

而本轮问题已经换成：

- `useDirectConnect` 这一条线内部，协议全集与实际支持面怎么错位

也就是：

- one hook’s internal control surface

不是：

- hook-to-hook comparison

### 问：为什么这批不应写成 generic remote control page？

答：因为这里讨论的不是：

- bridge / remote session 的完整控制面

而是：

- direct connect 明确只保留了一个窄子集

如果写成 generic remote control page，就会重新把：

- bridge control
- remote session control
- direct connect narrow control

压回一页。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/60-can_use_tool、interrupt、result、disconnect 与 stderr shutdown：为什么 direct connect 的控制子集、回合结束与连接失败不是同一种收口.md`
- `bluebook/userbook/03-参考索引/02-能力边界/49-Direct connect control subset、interrupt、result 与 stderr shutdown 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/60-2026-04-06-direct connect control subset and shutdown 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 正文落笔纪律

### 应写进正文的

- SDK control family 比 direct connect 实际支持面更宽
- unsupported subtype 会显式回 error，而不是静默丢弃
- 权限弹层是本地合成投影
- `interrupt` 只取消当前回合
- `result` 只结束当前回合，不等于 transport close
- stderr 断线文案是 hook 本地投影
- 许多协议消息会被故意过滤，不进入用户面

### 不应写进正文的

- 59 页已写过的 `cc://` / `ws_url` / `work_dir`
- 57 页三 hook 总比较
- bridge 控制面的整套术语
- 过细的 overlay 组件布局实现

这些只保留为作者判断依据。

## 本轮特别保留到记忆的源码发现

### synthetic permission projection 是本批第一根骨架

如果漏掉它，正文会把：

- 远端 `can_use_tool`

与：

- 本地 `PermissionRequest`

写成同一种消息来源。

### `result` 与 transport death 的切口必须单独保护

如果漏掉它，正文会重新把：

- 回合完成
- 会话断线

压成同一个“结束”。

### “可见状态面很窄”是本批第三根骨架

如果漏掉它，正文就会脑补：

- direct connect 有一张持续更新的远端状态板

而源码真正暴露的是：

- system message
- transcript 正文
- permission overlay
- stderr 断线文案

## 后续继续深入时的检查问题

1. 我当前讲的是 direct connect 的控制子集，还是又滑回 session factory？
2. 我是不是又把协议全集写成实现支持面？
3. 我是不是又把 permission overlay 写成 transcript 正文？
4. 我是不是又把 `interrupt`、`result` 与 disconnect 压成同一种结束？
5. 我是不是又把 stderr 文案写成远端 stderr 原文？
6. 我是不是又把“未显示”写成“未发生”？

只要这六问没先答清，下一页继续深入就会重新滑回：

- 建会话合同复述
- 或 generic remote control 复述

而不是用户真正可用的 direct connect runtime control 正文。
