# direct connect session contract 拆分记忆

## 本轮继续深入的核心判断

第 57 页已经拆开：

- `useRemoteSession`
- `useDirectConnect`
- `useSSHSession`

但第 57 页回答的是：

- 三种远端 hook 的比较

不是：

- direct connect 自己内部的建会话、transport locator、workspace writeback 与 fail-fast contract

而源码里这条线仍然有一组很容易继续混写的对象：

- `cc://`
- `open <cc-url>`
- `createDirectConnectSession(...)`
- `session_id`
- `ws_url`
- `work_dir`
- `can_use_tool`
- `interrupt`
- `gracefulShutdown(1)`

如果不单独补这一批，正文会继续犯六种错：

- 把 connect URL 的 argv 改写写成 session 已经建立
- 把建 session 写成 transport 已经连通
- 把 `session_id` 写成真正的 transport locator
- 把 `work_dir` 写成无关紧要的显示信息
- 把 direct connect 的控制面写成 generic remote controller
- 把断线退出写成 remote reconnect 的弱化版

## 苏格拉底式自审

### 问：为什么这批不能塞回第 57 页？

答：第 57 页回答的是：

- 三种 hook 的接口同形与合同异形

而本轮问题已经换成：

- `useDirectConnect` 这一条线内部，session factory、transport、workspace 与 failure policy 如何分叉

也就是：

- one hook’s own contract

不是：

- hook-to-hook comparison

### 问：为什么这批不能塞回第 21 或第 28 页？

答：第 21 / 28 页回答的是：

- host / viewer / remote workflow taxonomy

而本轮问题已经换成：

- `cc://` 重写、`open` headless 壳、`POST /sessions`、`ws_url` 与 fail-fast disconnect

也就是：

- direct connect session factory semantics

不是：

- entrance taxonomy

### 问：为什么这批不能塞进“非交互/自动化专题”而不单开控制面页？

答：专题页按用户目标组织，适合讲：

- 脚本
- 后台任务
- print mode

但本轮核心价值是：

- 让读者别把 connect URL、session creation、transport 与 disconnect policy 写成同一层

这更像：

- 控制面合同

而不是：

- 用户目标串讲

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/59-cc__、open、createDirectConnectSession、ws_url 与 fail-fast disconnect：为什么 direct connect 的建会话、直连 socket 与断线退出不是同一种远端附着.md`
- `bluebook/userbook/03-参考索引/02-能力边界/48-Direct connect create session、ws_url 与 fail-fast disconnect 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/59-2026-04-06-direct connect session contract 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 正文落笔纪律

### 应写进正文的

- `cc://` 到交互态 / `open` 的入口分流
- `createDirectConnectSession(...)` 是 session factory，不是 transport 本身
- `session_id`、`ws_url`、`work_dir` 各自回答不同问题
- server 可通过 `work_dir` 改写本地工作目录状态
- direct connect 的控制面只窄支持 `can_use_tool` 与 `interrupt`
- disconnect 后直接 `gracefulShutdown(1)`

### 不应写进正文的

- 57 页三种 hook 的整套比较回顾
- 21 / 28 页的 host / viewer / bridge taxonomy
- 58 页 attached viewer 的 history / title ownership 语义
- 缺失源码文件的实现猜测

这些只保留为作者判断依据。

## 本轮特别保留到记忆的源码发现

### `work_dir` 是本批最容易漏写的一根骨架

如果漏掉它，正文会把：

- connect 时提交的本地 `cwd`

与：

- session 最终实际采用的工作目录

重新压成同一种 workspace。

### direct connect 的控制面比想象中更窄

如果漏掉它，正文会把：

- `can_use_tool`
- unsupported control subtype 回错
- `interrupt`

写成 generic remote control plane。

### fail-fast disconnect 是本批最关键的运行时分水岭

如果漏掉它，正文就会重新滑回：

- remote reconnect 心智

而不是：

- socket dies => local session exits

## 本轮额外的源码约束

当前源码快照里可以稳定看到：

- `main.tsx` 的 `cc://` 改写 callsite
- `createDirectConnectSession.ts`
- `directConnectManager.ts`
- `useDirectConnect.ts`

但 `main.tsx` 动态 import 的：

- `./server/parseConnectUrl.js`
- `./server/connectHeadless.js`

在当前快照中看不到源码文件。

因此正文只写：

- 已可见的调用边界与合同

不写：

- URL grammar 细节
- headless connect 内部流式实现猜测

## 后续继续深入时的检查问题

1. 我当前讲的是 direct connect 自己的合同，还是又回到了三 hook 总比较？
2. 我是不是又把 connect URL 写成 transport 本身？
3. 我是不是又把 `session_id` 写成 `ws_url`？
4. 我是不是又漏掉了 `work_dir` 的 workspace 回填语义？
5. 我是不是又把 `can_use_tool` 窄支持写成完整控制面？
6. 我是不是又把 direct connect 的断线退出写成 reconnect？

只要这六问没先答清，下一页继续深入就会重新滑回：

- hook 比较复述
- 或 remote session 心智复述

而不是用户真正可用的 direct connect session contract 正文。
