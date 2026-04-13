# 105-110 wider wire、callback narrowing 与 projection 家族

这个目录不是新的编号总图，

而是给已经存在的：

- `105` wider-wire visibility 根分裂
- `106` raw wire contract
- `108` callback consumer-path narrowing
- `109` pre-wire projection
- `110` suppress-reason split 交叉叶子

补一个可浏览的记忆入口。

这里保护的首先是：

- 阅读骨架稳定

不是：

- 目录里出现的 wire、callback、projection、skip list 或 helper 名都已经属于稳定公开能力

如果你已经分清自己在追：

- `post_turn_summary` 为什么 not core SDK-visible，却不等于完全不可见
- `stream-json --verbose` 为什么代表 raw wire contract
- direct connect callback 为什么比 parse gate 更窄
- `streamlined_*` 与 `post_turn_summary` 为什么虽然同在 skip list，却不是同一种 suppress reason

但不想再从 `100-115` 子家族或主 `README` 里逐条找文件，

这里应该先于平铺编号列表阅读。

如果你是从 `100-115` hub 往下继续收窄，

默认也应在这里完成下一次分流：

- `105`
- `106`
- `108/109`
- `110`

而不是再回上游 hub 重找更深入口。

## 第一性原理

这组记忆真正想回答的不是：

- “`105-110` 该按编号怎么顺着翻”

而是：

- 哪些记忆负责把 `105` 立成 wider-wire visibility 的根页
- 哪些记忆负责把 `106`、`108`、`109` 分成 raw wire、callback narrowing 与 projection 三条后继线
- 哪些记忆负责把 `110` 固定成“same skip list != same suppress reason”的交叉叶子

所以这个目录的作用只是：

- 把现有结构页、scope guard 与 forward handoff 收成一个更窄的子家族入口

不是：

- 再制造一张新的 umbrella map

## 先读哪一簇

### 1. 我还在 wider-wire visibility 根分裂（`105`）

先读蓝皮书结构页：

- [../../../../bluebook/userbook/05-控制面深挖/209-post_turn_summary、StdoutMessage、SDKMessage、stream-json raw wire 与 streamlined_*：为什么 105、106、108、109、110 不是并列尾页，而是从 wider-wire visibility 分叉出去的四种后继问题.md](../../../../bluebook/userbook/05-%E6%8E%A7%E5%88%B6%E9%9D%A2%E6%B7%B1%E6%8C%96/209-post_turn_summary%E3%80%81StdoutMessage%E3%80%81SDKMessage%E3%80%81stream-json%20raw%20wire%20%E4%B8%8E%20streamlined_%2A%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%20105%E3%80%81106%E3%80%81108%E3%80%81109%E3%80%81110%20%E4%B8%8D%E6%98%AF%E5%B9%B6%E5%88%97%E5%B0%BE%E9%A1%B5%EF%BC%8C%E8%80%8C%E6%98%AF%E4%BB%8E%20wider-wire%20visibility%20%E5%88%86%E5%8F%89%E5%87%BA%E5%8E%BB%E7%9A%84%E5%9B%9B%E7%A7%8D%E5%90%8E%E7%BB%A7%E9%97%AE%E9%A2%98.md)

再看关键记忆：

- [../105-2026-04-06-post_turn_summary wider wire visibility 拆分记忆.md](../105-2026-04-06-post_turn_summary%20wider%20wire%20visibility%20拆分记忆.md)
- [../374-2026-04-13-wire-visibility branch-map scope clarification 拆分记忆.md](../374-2026-04-13-wire-visibility%20branch-map%20scope%20clarification%20拆分记忆.md)

### 2. 我已经进入 raw wire / callback narrowing / projection（`106 / 108 / 109`）

先读蓝皮书结构页：

- [../../../../bluebook/userbook/05-控制面深挖/209-post_turn_summary、StdoutMessage、SDKMessage、stream-json raw wire 与 streamlined_*：为什么 105、106、108、109、110 不是并列尾页，而是从 wider-wire visibility 分叉出去的四种后继问题.md](../../../../bluebook/userbook/05-%E6%8E%A7%E5%88%B6%E9%9D%A2%E6%B7%B1%E6%8C%96/209-post_turn_summary%E3%80%81StdoutMessage%E3%80%81SDKMessage%E3%80%81stream-json%20raw%20wire%20%E4%B8%8E%20streamlined_%2A%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%20105%E3%80%81106%E3%80%81108%E3%80%81109%E3%80%81110%20%E4%B8%8D%E6%98%AF%E5%B9%B6%E5%88%97%E5%B0%BE%E9%A1%B5%EF%BC%8C%E8%80%8C%E6%98%AF%E4%BB%8E%20wider-wire%20visibility%20%E5%88%86%E5%8F%89%E5%87%BA%E5%8E%BB%E7%9A%84%E5%9B%9B%E7%A7%8D%E5%90%8E%E7%BB%A7%E9%97%AE%E9%A2%98.md)

再看关键记忆：

- [../106-2026-04-06-stream-json verbose raw wire 拆分记忆.md](../106-2026-04-06-stream-json%20verbose%20raw%20wire%20拆分记忆.md)
- [../108-2026-04-06-direct connect post_turn_summary callback consumer-path narrowing 拆分记忆.md](../108-2026-04-06-direct%20connect%20post_turn_summary%20callback%20consumer-path%20narrowing%20拆分记忆.md)
- [../109-2026-04-06-streamlined pre-wire rewrite ordering 拆分记忆.md](../109-2026-04-06-streamlined%20pre-wire%20rewrite%20ordering%20拆分记忆.md)

### 3. 我已经进入 suppress-reason split（`110`）

先读蓝皮书结构页：

- [../../../../bluebook/userbook/05-控制面深挖/209-post_turn_summary、StdoutMessage、SDKMessage、stream-json raw wire 与 streamlined_*：为什么 105、106、108、109、110 不是并列尾页，而是从 wider-wire visibility 分叉出去的四种后继问题.md](../../../../bluebook/userbook/05-%E6%8E%A7%E5%88%B6%E9%9D%A2%E6%B7%B1%E6%8C%96/209-post_turn_summary%E3%80%81StdoutMessage%E3%80%81SDKMessage%E3%80%81stream-json%20raw%20wire%20%E4%B8%8E%20streamlined_%2A%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%20105%E3%80%81106%E3%80%81108%E3%80%81109%E3%80%81110%20%E4%B8%8D%E6%98%AF%E5%B9%B6%E5%88%97%E5%B0%BE%E9%A1%B5%EF%BC%8C%E8%80%8C%E6%98%AF%E4%BB%8E%20wider-wire%20visibility%20%E5%88%86%E5%8F%89%E5%87%BA%E5%8E%BB%E7%9A%84%E5%9B%9B%E7%A7%8D%E5%90%8E%E7%BB%A7%E9%97%AE%E9%A2%98.md)

再看关键记忆：

- [../110-2026-04-06-direct connect suppress-reason split for streamlined and post_turn_summary 拆分记忆.md](../110-2026-04-06-direct%20connect%20suppress-reason%20split%20for%20streamlined%20and%20post_turn_summary%20拆分记忆.md)

如果你已经确认自己不只是看这一支，

而是要回到 `100-115` 的更上层分流，

回跳：

- [../100-115-summary、wire、callback 与 UI 家族/README.md](../100-115-summary、wire、callback%20与%20UI%20家族/README.md)

## 这层入口保护什么

- 保护的是 `105-110` 这簇记忆的子家族入口，不是新的编号总图。
- 保护的是 `105 -> 106/108/109 -> 110` 的分叉关系。
- 不把 wider-wire 根分裂、raw wire / callback narrowing / projection 与 suppress-reason split 误写成同一种消息过滤问题。
- 不让上游 `100-115` hub 继续代替这里完成 wider-wire 这一层的下一次分流。
- 不在这一轮移动或重命名任何现有记忆文件。
