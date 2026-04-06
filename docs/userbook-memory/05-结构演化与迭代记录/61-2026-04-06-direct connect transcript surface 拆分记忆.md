# direct connect transcript surface 拆分记忆

## 本轮继续深入的核心判断

第 59 页已经拆开：

- session factory
- `ws_url`
- `work_dir`
- fail-fast disconnect

第 60 页已经拆开：

- control subset
- permission projection
- `interrupt`
- `result`
- stderr shutdown

但还缺一层很容易继续混写的对象：

- manager 先过滤哪些 message family
- adapter 再把哪些 family 投影成 transcript
- 为什么 `tool_result` 会被特判保留
- 为什么 success `result`、`auth_status`、`rate_limit_event` 被忽略
- 为什么 `stream_event` 虽能转换，但 direct connect 当前 hook 不消费
- 为什么连接成功提示与远端 `init` 不是同一来源

如果不单独补这一批，正文会继续犯六种错：

- 把 wire family 写成 transcript surface
- 把所有 `user` family 写成普通 prompt echo
- 把 success `result` 写成可见完成消息
- 把 `stream_event` 能转换写成 direct connect 会流式展示
- 把每轮 `init` 写成都会刷新一次
- 把 main 注入的连接提示写成远端原样回显

## 苏格拉底式自审

### 问：为什么这批不能塞回第 60 页？

答：第 60 页回答的是：

- 控制子集
- 权限投影
- 关闭与收口语义

而本轮问题已经换成：

- transcript surface 是怎样由 wire family 一层层筛出来的

也就是：

- message projection semantics

不是：

- control/shutdown semantics

### 问：为什么这批不能继续塞回第 59 页？

答：第 59 页回答的是：

- 入口改写
- 建会话
- transport locator
- workspace writeback

而本轮问题已经换成：

- 会话建立之后，哪类远端消息最终进正文

也就是：

- runtime message surface

不是：

- session factory

### 问：为什么这批不应写成 generic “状态面”页面？

答：因为这里真正的关键不是：

- 当前 server 有哪些状态词

而是：

- 哪些远端事件被故意离散投影成 transcript
- 哪些只改 loading/waiting
- 哪些完全不显示

如果写成 generic 状态页，就会把：

- transcript event
- overlay
- loading flag
- stderr disconnect

重新压成一张面。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/61-init、status、tool_result、tool_progress 与 ignored families：为什么 direct connect 的远端消息流不是原样落进 REPL transcript.md`
- `bluebook/userbook/03-参考索引/02-能力边界/50-Direct connect message filtering、init dedupe 与 transcript surface 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/61-2026-04-06-direct connect transcript surface 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 正文落笔纪律

### 应写进正文的

- transport filter 与 adapter projection 是两层不同筛选
- `tool_result` 是远端 `user` family 的特判保留对象
- 普通 user echo 默认不进正文
- success `result` 默认只收 loading
- `stream_event` 在 adapter 存在，但当前 hook 不消费
- 首条 `init` 会显示，后续同类会 suppress
- main 注入的连接提示与远端 `init` 是两种不同来源

### 不应写进正文的

- 59 页的 `cc://` / `ws_url` / `work_dir`
- 60 页的 control subset / interrupt / shutdown 总论
- bridge / remote session 的整套状态词
- adapter 每个类型的实现细枝末节

这些只保留为作者判断依据。

## 本轮特别保留到记忆的源码发现

### `tool_result` special-case 是本批第一根骨架

如果漏掉它，正文会把：

- direct connect 为什么能显示远端工具结果

写得不成体系。

### `stream_event` 能转但当前 hook 不消费，是本批第二根骨架

如果漏掉它，正文就会错误暗示：

- adapter 支持流式 = direct connect 有流式 transcript surface

### “本地连接提示”和“远端 init”分源是本批第三根骨架

如果漏掉它，正文就会把所有开场提示都写成：

- 远端原样初始化消息

## 后续继续深入时的检查问题

1. 我当前讲的是 message surface，还是又滑回 control/shutdown？
2. 我是不是又把 wire family 写成 transcript surface？
3. 我是不是又把普通 user echo 与 `tool_result` 混成一类？
4. 我是不是又把 success `result` 写成可见完成消息？
5. 我是不是又把 `stream_event` 能转写成“当前就会显示”？
6. 我是不是又把 main 注入提示和远端 `init` 写成同一来源？

只要这六问没先答清，下一页继续深入就会重新滑回：

- 59/60 复述
- 或 generic 状态面复述

而不是用户真正可用的 direct connect transcript surface 正文。
