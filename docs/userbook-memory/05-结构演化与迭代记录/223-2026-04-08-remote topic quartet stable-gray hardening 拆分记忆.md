# remote topic quartet stable-gray hardening 拆分记忆

## 本轮继续深入的核心判断

`20/21/22/23` 这组用户专题已经不缺：

- 新的范围图
- 新的 topic page

真正还欠的是两件事：

1. topic layer 自己也要明确 stable / conditional / internal 的边界
2. 根 README 必须把这组 quartet 的 discoverability 补齐

所以这轮更稳的做法不是：

- 再画一张 remote / approval / blocked / presence 总图

而是：

- 在现有四页内部补 stable-gray hardening
- 在根 README 把 `22/23` 也补成 top-level 入口

## 为什么这轮不该再开新图

### 判断一：quartet 的切页已经成立，缺的是边界厚度

当前 topic quartet 已经形成：

- `20` = 远端接续 / host control / ingress input / verdict 的前置分诊
- `21` = verdict 返回之后的 tail 分诊
- `22` = ask 还没判完时的 blocked-state 厚薄分诊
- `23` = foreground runtime / presence ledger / bridge overlay / coarse remote bit 的 remote surface 分诊

这说明：

- 题目切法已经够用

真正还容易滑坡的是：

- 把 `SDKMessage`
- `pending_action`
- `activeRemote`
- `remoteSessionUrl`
- `persistToSettings`

这些条件化或实现层对象，

重新误写成普通用户可稳定依赖的主语。

所以这轮的重点必须落在：

- stable / conditional / internal 的硬分层

而不是：

- 新开页

## 为什么根 README 必须把 22 / 23 补出来

### 判断二：如果根入口只露出 20 / 21，读者会把 blocked-state 与 remote-surface 误判重新挤回宽口径专题

`04-专题深潜/README.md` 已经完整列出：

- `20`
- `21`
- `22`
- `23`

但根 README 如果只露出：

- `20`
- `21`

读者就会更容易把：

- “为什么只有 waiting bit”
- “我现在面对的是前台 runtime 还是 session URL / bridge overlay”

重新挤回：

- `20` 的远端总入口
- `21` 的审批后处理入口

于是又把：

- blocked-state thickness
- remote surface partition

压回笼统的“远端体验”。

所以这轮的 discoverability 优化必须把：

- `22`
- `23`

也补到根入口。

## 本轮最关键的新判断

### 判断三：topic layer 也必须承担“保护稳定功能与灰度功能”的责任

之前的 `197/203/206/219` 等结构页已经证明：

- 结构图解决的是“怎么读”

但用户专题如果不再补一层 stable-gray hardening，

读者仍然会把实现证据误当成可稳定依赖的对象。

因此这轮继续深入的正确方向是：

- 在 topic quartet 内部加厚边界

而不是：

- 再造一张 topic 总图

## 主树状态记录

本轮开始前已再次核对：

- `git fetch origin`
- `git pull --ff-only`
- `git rev-list --left-right --count HEAD...origin/main` = `0 0`

并确认主树与 `origin/main` 一致。

## 苏格拉底式自审

### 问：我现在补的是 topic layer 的树形，还是 topic layer 的边界厚度？

答：如果 20/21/22/23 的切页本身没被推翻，就不要再靠新页解决稳定 / 条件 / 灰度问题。

### 问：我是不是因为某个 helper 很常见，就把它升级成了用户专题的主语？

答：先问用户能否稳定观察并依赖它；若不能，它就只该留在证据层。

### 问：我是不是把 blocked-state、approval tail、remote presence 又写回了同一种“远端体验”？

答：如果一句话同时想解释 waiting bit、prompt closeout、session URL 和 bridge overlay，它大概率已经跨了不止一层。
