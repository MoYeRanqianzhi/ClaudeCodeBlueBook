# 100-115 summary、wire、callback 与 UI 家族

这个目录不是新的编号总图，

而是给已经存在的：

- `100-104` summary contract / terminal tail / observer restore
- `105-110` wider-wire visibility / raw wire / callback narrowing / projection
- `111-115` builder transport / callback surface / streamlined / UI consumer

补一个可浏览的记忆入口。

这里保护的首先是：

- 阅读骨架稳定

不是：

- 目录里出现的 summary、wire、callback、adapter 或 helper 名都已经属于稳定公开能力

如果你已经分清自己在追：

- `task_summary / post_turn_summary` 的分家、terminal tail、observer restore 与 settlement gap
- raw wire、callback narrowing、pre-wire projection 与 suppress reason
- builder/control transport、streamlined dual-entry、adapter triad 与 UI consumer policy

但不想再从 `100-149` 家族或主 `README` 里逐条找文件，

这里应该先于平铺编号列表阅读。

如果你是从 `100-149` family hub 往下继续收窄，

默认也应在这里完成下一次分流：

- `100-104`
- `105-110`
- `111-115`

而不是再回上游 family hub 或主时间流重找更深入口。

## 第一性原理

这组记忆真正想回答的不是：

- “`100-115` 该按编号怎么顺着翻”

而是：

- 哪些记忆负责把 `100-104` 收成 summary contract split、terminal tail 与 observer-restore 侧枝
- 哪些记忆负责把 `105-110` 收成 wider-wire visibility 根分裂与交叉叶子
- 哪些记忆负责把 `111-115` 收成四层可见性表与两条 consumer 支线

所以这个目录的作用只是：

- 把现有结构页、scope guard 与 forward handoff 收成一个更窄的子家族入口

不是：

- 再制造一张新的 umbrella map

## 先读哪一簇

### 1. 我还在 summary / terminal tail / observer restore（`100-104`）

先读蓝皮书结构页：

- [../../../../bluebook/userbook/05-控制面深挖/208-task_summary、post_turn_summary、terminal tail、observer restore 与 suggestion settlement：为什么 100-104 不是并列细页，而是先从 summary 分家，再分叉到终态收口与恢复合同.md](../../../../bluebook/userbook/05-%E6%8E%A7%E5%88%B6%E9%9D%A2%E6%B7%B1%E6%8C%96/208-task_summary%E3%80%81post_turn_summary%E3%80%81terminal%20tail%E3%80%81observer%20restore%20%E4%B8%8E%20suggestion%20settlement%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%20100-104%20%E4%B8%8D%E6%98%AF%E5%B9%B6%E5%88%97%E7%BB%86%E9%A1%B5%EF%BC%8C%E8%80%8C%E6%98%AF%E5%85%88%E4%BB%8E%20summary%20%E5%88%86%E5%AE%B6%EF%BC%8C%E5%86%8D%E5%88%86%E5%8F%89%E5%88%B0%E7%BB%88%E6%80%81%E6%94%B6%E5%8F%A3%E4%B8%8E%E6%81%A2%E5%A4%8D%E5%90%88%E5%90%8C.md)

再看护栏记忆：

- [../372-2026-04-13-observer-restore scope clarification 拆分记忆.md](../372-2026-04-13-observer-restore%20scope%20clarification%20拆分记忆.md)

### 2. 我已经进入 wider-wire visibility（`105-110`）

先读蓝皮书结构页：

- [../../../../bluebook/userbook/05-控制面深挖/209-post_turn_summary、StdoutMessage、SDKMessage、stream-json raw wire 与 streamlined_*：为什么 105、106、108、109、110 不是并列尾页，而是从 wider-wire visibility 分叉出去的四种后继问题.md](../../../../bluebook/userbook/05-%E6%8E%A7%E5%88%B6%E9%9D%A2%E6%B7%B1%E6%8C%96/209-post_turn_summary%E3%80%81StdoutMessage%E3%80%81SDKMessage%E3%80%81stream-json%20raw%20wire%20%E4%B8%8E%20streamlined_%2A%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%20105%E3%80%81106%E3%80%81108%E3%80%81109%E3%80%81110%20%E4%B8%8D%E6%98%AF%E5%B9%B6%E5%88%97%E5%B0%BE%E9%A1%B5%EF%BC%8C%E8%80%8C%E6%98%AF%E4%BB%8E%20wider-wire%20visibility%20%E5%88%86%E5%8F%89%E5%87%BA%E5%8E%BB%E7%9A%84%E5%9B%9B%E7%A7%8D%E5%90%8E%E7%BB%A7%E9%97%AE%E9%A2%98.md)

再看护栏记忆：

- [../374-2026-04-13-wire-visibility branch-map scope clarification 拆分记忆.md](../374-2026-04-13-wire-visibility%20branch-map%20scope%20clarification%20拆分记忆.md)

### 3. 我已经进入 builder / callback / streamlined / UI（`111-115`）

先读蓝皮书结构页：

- [../../../../bluebook/userbook/05-控制面深挖/210-builder transport、callback surface、streamlined dual-entry 与 UI consumer policy：为什么 111、112、113、114、115 不是并列细页，而是先定四层可见性表，再分叉到 streamlined 与 adapter 两条后继线.md](../../../../bluebook/userbook/05-%E6%8E%A7%E5%88%B6%E9%9D%A2%E6%B7%B1%E6%8C%96/210-builder%20transport%E3%80%81callback%20surface%E3%80%81streamlined%20dual-entry%20%E4%B8%8E%20UI%20consumer%20policy%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%20111%E3%80%81112%E3%80%81113%E3%80%81114%E3%80%81115%20%E4%B8%8D%E6%98%AF%E5%B9%B6%E5%88%97%E7%BB%86%E9%A1%B5%EF%BC%8C%E8%80%8C%E6%98%AF%E5%85%88%E5%AE%9A%E5%9B%9B%E5%B1%82%E5%8F%AF%E8%A7%81%E6%80%A7%E8%A1%A8%EF%BC%8C%E5%86%8D%E5%88%86%E5%8F%89%E5%88%B0%20streamlined%20%E4%B8%8E%20adapter%20%E4%B8%A4%E6%9D%A1%E5%90%8E%E7%BB%A7%E7%BA%BF.md)

再看护栏记忆：

- [../375-2026-04-13-builder-callback-ui branch-map scope clarification 拆分记忆.md](../375-2026-04-13-builder-callback-ui%20branch-map%20scope%20clarification%20拆分记忆.md)

如果你已经确认自己不只是看 `208/209/210` 这组结构页，

而是要回到更上游的 family-level 分流，

回跳：

- [../100-149-非交互、recovery 与 remote surface 家族/README.md](../100-149-%E9%9D%9E%E4%BA%A4%E4%BA%92%E3%80%81recovery%20%E4%B8%8E%20remote%20surface%20%E5%AE%B6%E6%97%8F/README.md)

## 这层入口保护什么

- 保护的是 `100-115` 这簇记忆的子家族入口，不是新的编号总图。
- 保护的是 `208 -> 209 -> 210` 的接力关系。
- 不把 `100-104`、`105-110`、`111-115` 误写成三份互不相干的旧批次。
- 不让上游 `100-149` hub 或主时间流继续代替这里完成 `100-115` 这一层的下一次分流。
- 不在这一轮移动或重命名任何现有记忆文件。
