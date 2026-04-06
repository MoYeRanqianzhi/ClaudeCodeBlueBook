# direct connect transcript mode vs raw stream 拆分记忆

## 本轮继续深入的核心判断

第 61 页已经拆开：

- 哪些消息会不会进 transcript

第 62 页已经拆开：

- 用户现在能看到哪几张状态面

但还缺一层很容易继续混写的对象：

- prompt 面
- `Ctrl+O` transcript
- `showAllInTranscript`
- `verbose=true`
- transcript-only 消息
- raw SDK stream

如果不单独补这一批，正文会继续犯六种错：

- 把 transcript 写成 raw SDK stream
- 把 prompt 面看不到写成远端没发
- 把 `showAllInTranscript` 写成显示所有远端事件
- 把普通 user echo 写成远端回显主来源
- 把 `tool_result` 与普通 user echo 写成一类
- 把 transcript 写成 prompt 面的简单展开

## 苏格拉底式自审

### 问：为什么这批不能塞回第 61 页？

答：第 61 页回答的是：

- 哪些家族会不会进 transcript

而本轮问题已经换成：

- 同一批 UI 消息在 prompt 面与 transcript 屏为什么可见性还不同

也就是：

- view-level visibility semantics

不是：

- message family filtering

### 问：为什么这批不能塞回第 62 页？

答：第 62 页回答的是：

- 各种“像状态”的对象来自哪张面

而本轮问题已经换成：

- 同一消息在 prompt / transcript / raw wire 三层之间怎么错位

也就是：

- transcript mode visibility

不是：

- status surfaces

### 问：为什么这批不应继续写成 generic transcript 总论？

答：因为当前真正的新增量只在 direct connect：

- 普通 `user` echo 与 `tool_result`
- `verbose` 对 info system visibility 的影响
- transcript 比 prompt 更宽，但比 raw wire 更窄

如果写成 generic transcript 总论，就会把全局 transcript 机制与当前 direct-connect 特判重新混平。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/63-Ctrl+O transcript、verbose、showAllInTranscript 与 tool_result：为什么 direct connect 的 transcript 不是 prompt 面展开版，也不是 raw SDK stream.md`
- `bluebook/userbook/03-参考索引/02-能力边界/52-Direct connect transcript mode、verbose 与 raw SDK stream 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/63-2026-04-06-direct connect transcript mode vs raw stream 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 正文落笔纪律

### 应写进正文的

- transcript 模式强制 `verbose=true`
- `showAllInTranscript` 只放开截断
- prompt 面会继续隐藏一批 info system message
- 普通 user message 是本地先写，`tool_result` 是远端特判回写
- transcript 仍看不到上游已被过滤掉的事件
- transcript-only 消息不等于 raw wire

### 不应写进正文的

- 61 页已写过的 family 过滤全表
- 62 页的状态面分层
- 全局 transcript 模式的泛化总论
- 过细的 virtual scroll / render cap 实现枝节

这些只保留为作者判断依据。

## 本轮特别保留到记忆的源码发现

### “比 prompt 更宽、比 wire 更窄”是本批第一根骨架

如果漏掉它，正文会继续在两个极端之间摇摆：

- transcript = raw wire
- 或 transcript = prompt 纯展开

### `tool_result` special-case 是本批第二根骨架

如果漏掉它，正文就无法解释：

- 为什么普通 user echo 不显示
- 但工具结果却能再次进入 transcript

### `verbose` 与 transcript-only 是本批第三根骨架

如果漏掉它，正文会继续把：

- prompt 不显示
- transcript 显示

写成上游消息流不同，而不是下游可见性闸门不同。

## 后续继续深入时的检查问题

1. 我当前讲的是 prompt/transcript/raw wire 的差异，还是又滑回 message filtering？
2. 我是不是又把 prompt 面看不到写成远端没发？
3. 我是不是又把 `showAllInTranscript` 写成显示所有远端事件？
4. 我是不是又把普通 user echo 和 `tool_result` 混成一类？
5. 我是不是又把 transcript 写成 prompt 面简单展开？
6. 我是不是又把 transcript 写成 raw SDK stream？

只要这六问没先答清，下一页继续深入就会重新滑回：

- 61/62 复述

而不是用户真正可用的 transcript mode 正文。
