# 100-149 非交互、recovery 与 remote surface 家族

这个目录不是新的编号总图，

而是给已经存在的：

- `100-115` summary / wire / callback / UI 可见性链
- `116-127` completion / attach / recovery 双主干
- `128-149` remote surface / truth / shell pair

补一个可浏览的记忆入口。

这里保护的首先是：

- 阅读骨架稳定

不是：

- 目录里出现的中间节点名都已经属于稳定公开能力

如果你已经分清自己在追：

- `task_summary / post_turn_summary / terminal tail / observer restore`
- raw wire / callback / streamlined / UI consumer
- completion signal / init / attach restore / recovery contract
- surface presence / interaction shell / remote truth / command shell / env-driven memory

但不想再从主 `README` 的全量时间流里逐条找文件，

这里应该先于平铺编号列表阅读。

## 第一性原理

这组记忆真正想回答的不是：

- “`100-149` 该按编号怎么顺着翻”

而是：

- 哪些记忆负责把 `100-115` 收成 summary / wire / callback / UI 三层可见性骨架
- 哪些记忆负责把 `116-127` 收成 completion / attach / recovery 的双主干
- 哪些记忆负责把 `128-149` 收成 remote surface、remote truth 与 shell pair 的后继结构

所以这个目录的作用只是：

- 把现有结构页、scope guard 与二层导航收成一个家族入口

不是：

- 再制造一张新的 umbrella map

## 先读哪一簇

### 1. 我还在 summary / wire / callback / UI（`100-115`）

先读蓝皮书结构页：

- [../../../../bluebook/userbook/05-控制面深挖/208-task_summary、post_turn_summary、terminal tail、observer restore 与 suggestion settlement：为什么 100-104 不是并列细页，而是先从 summary 分家，再分叉到终态收口与恢复合同.md](../../../../bluebook/userbook/05-%E6%8E%A7%E5%88%B6%E9%9D%A2%E6%B7%B1%E6%8C%96/208-task_summary%E3%80%81post_turn_summary%E3%80%81terminal%20tail%E3%80%81observer%20restore%20%E4%B8%8E%20suggestion%20settlement%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%20100-104%20%E4%B8%8D%E6%98%AF%E5%B9%B6%E5%88%97%E7%BB%86%E9%A1%B5%EF%BC%8C%E8%80%8C%E6%98%AF%E5%85%88%E4%BB%8E%20summary%20%E5%88%86%E5%AE%B6%EF%BC%8C%E5%86%8D%E5%88%86%E5%8F%89%E5%88%B0%E7%BB%88%E6%80%81%E6%94%B6%E5%8F%A3%E4%B8%8E%E6%81%A2%E5%A4%8D%E5%90%88%E5%90%8C.md)
- [../../../../bluebook/userbook/05-控制面深挖/209-post_turn_summary、StdoutMessage、SDKMessage、stream-json raw wire 与 streamlined_*：为什么 105、106、108、109、110 不是并列尾页，而是从 wider-wire visibility 分叉出去的四种后继问题.md](../../../../bluebook/userbook/05-%E6%8E%A7%E5%88%B6%E9%9D%A2%E6%B7%B1%E6%8C%96/209-post_turn_summary%E3%80%81StdoutMessage%E3%80%81SDKMessage%E3%80%81stream-json%20raw%20wire%20%E4%B8%8E%20streamlined_%2A%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%20105%E3%80%81106%E3%80%81108%E3%80%81109%E3%80%81110%20%E4%B8%8D%E6%98%AF%E5%B9%B6%E5%88%97%E5%B0%BE%E9%A1%B5%EF%BC%8C%E8%80%8C%E6%98%AF%E4%BB%8E%20wider-wire%20visibility%20%E5%88%86%E5%8F%89%E5%87%BA%E5%8E%BB%E7%9A%84%E5%9B%9B%E7%A7%8D%E5%90%8E%E7%BB%A7%E9%97%AE%E9%A2%98.md)
- [../../../../bluebook/userbook/05-控制面深挖/210-builder transport、callback surface、streamlined dual-entry 与 UI consumer policy：为什么 111、112、113、114、115 不是并列细页，而是先定四层可见性表，再分叉到 streamlined 与 adapter 两条后继线.md](../../../../bluebook/userbook/05-%E6%8E%A7%E5%88%B6%E9%9D%A2%E6%B7%B1%E6%8C%96/210-builder%20transport%E3%80%81callback%20surface%E3%80%81streamlined%20dual-entry%20%E4%B8%8E%20UI%20consumer%20policy%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%20111%E3%80%81112%E3%80%81113%E3%80%81114%E3%80%81115%20%E4%B8%8D%E6%98%AF%E5%B9%B6%E5%88%97%E7%BB%86%E9%A1%B5%EF%BC%8C%E8%80%8C%E6%98%AF%E5%85%88%E5%AE%9A%E5%9B%9B%E5%B1%82%E5%8F%AF%E8%A7%81%E6%80%A7%E8%A1%A8%EF%BC%8C%E5%86%8D%E5%88%86%E5%8F%89%E5%88%B0%20streamlined%20%E4%B8%8E%20adapter%20%E4%B8%A4%E6%9D%A1%E5%90%8E%E7%BB%A7%E7%BA%BF.md)

再看后续护栏记忆：

- [../373-2026-04-13-branch-map scope clarification 拆分记忆.md](../373-2026-04-13-branch-map%20scope%20clarification%20拆分记忆.md)
- [../374-2026-04-13-wire-visibility branch-map scope clarification 拆分记忆.md](../374-2026-04-13-wire-visibility%20branch-map%20scope%20clarification%20拆分记忆.md)
- [../375-2026-04-13-builder-callback-ui branch-map scope clarification 拆分记忆.md](../375-2026-04-13-builder-callback-ui%20branch-map%20scope%20clarification%20拆分记忆.md)

### 2. 我已经进入 completion / attach / recovery（`116-127`）

先读蓝皮书结构页：

- [../../../../bluebook/userbook/05-控制面深挖/211-completion signal、system.init dual-axis、history attach restore 与 loading edge：为什么 116、117、118、119、120、121 不是线性后续页，而是三组相邻配对分叉.md](../../../../bluebook/userbook/05-%E6%8E%A7%E5%88%B6%E9%9D%A2%E6%B7%B1%E6%8C%96/211-completion%20signal%E3%80%81system.init%20dual-axis%E3%80%81history%20attach%20restore%20%E4%B8%8E%20loading%20edge%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%20116%E3%80%81117%E3%80%81118%E3%80%81119%E3%80%81120%E3%80%81121%20%E4%B8%8D%E6%98%AF%E7%BA%BF%E6%80%A7%E5%90%8E%E7%BB%AD%E9%A1%B5%EF%BC%8C%E8%80%8C%E6%98%AF%E4%B8%89%E7%BB%84%E7%9B%B8%E9%82%BB%E9%85%8D%E5%AF%B9%E5%88%86%E5%8F%89.md)
- [../../../../bluebook/userbook/05-控制面深挖/212-remote recovery、viewer ownership、transport terminality 与 compaction contract：为什么 122、123、124、125、126、127 不是一条 recovery 后续链.md](../../../../bluebook/userbook/05-%E6%8E%A7%E5%88%B6%E9%9D%A2%E6%B7%B1%E6%8C%96/212-remote%20recovery%E3%80%81viewer%20ownership%E3%80%81transport%20terminality%20%E4%B8%8E%20compaction%20contract%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%20122%E3%80%81123%E3%80%81124%E3%80%81125%E3%80%81126%E3%80%81127%20%E4%B8%8D%E6%98%AF%E4%B8%80%E6%9D%A1%20recovery%20%E5%90%8E%E7%BB%AD%E9%93%BE.md)
- [../../../../bluebook/userbook/05-控制面深挖/213-owner-side recovery、transport stop rule 与 compaction boundary：为什么 122、123、124、125、126、127 不是线性六连，而是双主干加两个 zoom.md](../../../../bluebook/userbook/05-%E6%8E%A7%E5%88%B6%E9%9D%A2%E6%B7%B1%E6%8C%96/213-owner-side%20recovery%E3%80%81transport%20stop%20rule%20%E4%B8%8E%20compaction%20boundary%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%20122%E3%80%81123%E3%80%81124%E3%80%81125%E3%80%81126%E3%80%81127%20%E4%B8%8D%E6%98%AF%E7%BA%BF%E6%80%A7%E5%85%AD%E8%BF%9E%EF%BC%8C%E8%80%8C%E6%98%AF%E5%8F%8C%E4%B8%BB%E5%B9%B2%E5%8A%A0%E4%B8%A4%E4%B8%AA%20zoom.md)

再看后续护栏记忆：

- [../376-2026-04-13-completion-init-attach branch-map scope clarification 拆分记忆.md](../376-2026-04-13-completion-init-attach%20branch-map%20scope%20clarification%20拆分记忆.md)
- [../377-2026-04-13-remote-recovery branch-map scope clarification 拆分记忆.md](../377-2026-04-13-remote-recovery%20branch-map%20scope%20clarification%20拆分记忆.md)
- [../378-2026-04-13-dual-trunk zoom-map scope clarification 拆分记忆.md](../378-2026-04-13-dual-trunk%20zoom-map%20scope%20clarification%20拆分记忆.md)

### 3. 我已经进入 remote surface / truth / shell（`128-149`）

先读蓝皮书结构页：

- [../../../../bluebook/userbook/05-控制面深挖/214-4001 contract、surface presence、status ledger 与 front-state consumer topology：为什么 128、129、130、131、132 不是线性五连，而是两段延伸加一个后继根页.md](../../../../bluebook/userbook/05-%E6%8E%A7%E5%88%B6%E9%9D%A2%E6%B7%B1%E6%8C%96/214-4001%20contract%E3%80%81surface%20presence%E3%80%81status%20ledger%20%E4%B8%8E%20front-state%20consumer%20topology%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%20128%E3%80%81129%E3%80%81130%E3%80%81131%E3%80%81132%20%E4%B8%8D%E6%98%AF%E7%BA%BF%E6%80%A7%E4%BA%94%E8%BF%9E%EF%BC%8C%E8%80%8C%E6%98%AF%E4%B8%A4%E6%AE%B5%E5%BB%B6%E4%BC%B8%E5%8A%A0%E4%B8%80%E4%B8%AA%E5%90%8E%E7%BB%A7%E6%A0%B9%E9%A1%B5.md)
- [../../../../bluebook/userbook/05-控制面深挖/215-schema-store consumer path、bridge chain split 与 remote interaction shell：为什么 133、134、135、136、137、138 不是线性六连，而是从 132 分出去的三条两步后继线.md](../../../../bluebook/userbook/05-%E6%8E%A7%E5%88%B6%E9%9D%A2%E6%B7%B1%E6%8C%96/215-schema-store%20consumer%20path%E3%80%81bridge%20chain%20split%20%E4%B8%8E%20remote%20interaction%20shell%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%20133%E3%80%81134%E3%80%81135%E3%80%81136%E3%80%81137%E3%80%81138%20%E4%B8%8D%E6%98%AF%E7%BA%BF%E6%80%A7%E5%85%AD%E8%BF%9E%EF%BC%8C%E8%80%8C%E6%98%AF%E4%BB%8E%20132%20%E5%88%86%E5%87%BA%E5%8E%BB%E7%9A%84%E4%B8%89%E6%9D%A1%E4%B8%A4%E6%AD%A5%E5%90%8E%E7%BB%A7%E7%BA%BF.md)
- [../../../../bluebook/userbook/05-控制面深挖/216-post_turn_summary visibility、mirror gray runtime、remote-session ledger 与 global remote bit：为什么 139、140、141、142、143 不是线性五连，而是接在三条后继线上的三组问题.md](../../../../bluebook/userbook/05-%E6%8E%A7%E5%88%B6%E9%9D%A2%E6%B7%B1%E6%8C%96/216-post_turn_summary%20visibility%E3%80%81mirror%20gray%20runtime%E3%80%81remote-session%20ledger%20%E4%B8%8E%20global%20remote%20bit%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%20139%E3%80%81140%E3%80%81141%E3%80%81142%E3%80%81143%20%E4%B8%8D%E6%98%AF%E7%BA%BF%E6%80%A7%E4%BA%94%E8%BF%9E%EF%BC%8C%E8%80%8C%E6%98%AF%E6%8E%A5%E5%9C%A8%E4%B8%89%E6%9D%A1%E5%90%8E%E7%BB%A7%E7%BA%BF%E4%B8%8A%E7%9A%84%E4%B8%89%E7%BB%84%E9%97%AE%E9%A2%98.md)
- [../../../../bluebook/userbook/05-控制面深挖/217-session pane、command shell 与 headless remote memory：为什么 144、145、146、147、148、149 不是线性六连，而是从 143 分出去的三组相邻配对.md](../../../../bluebook/userbook/05-%E6%8E%A7%E5%88%B6%E9%9D%A2%E6%B7%B1%E6%8C%96/217-session%20pane%E3%80%81command%20shell%20%E4%B8%8E%20headless%20remote%20memory%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%20144%E3%80%81145%E3%80%81146%E3%80%81147%E3%80%81148%E3%80%81149%20%E4%B8%8D%E6%98%AF%E7%BA%BF%E6%80%A7%E5%85%AD%E8%BF%9E%EF%BC%8C%E8%80%8C%E6%98%AF%E4%BB%8E%20143%20%E5%88%86%E5%87%BA%E5%8E%BB%E7%9A%84%E4%B8%89%E7%BB%84%E7%9B%B8%E9%82%BB%E9%85%8D%E5%AF%B9.md)

再看后续护栏记忆：

- [../379-2026-04-13-remote-surface branch-map scope clarification 拆分记忆.md](../379-2026-04-13-remote-surface%20branch-map%20scope%20clarification%20拆分记忆.md)
- [../380-2026-04-13-schema-store bridge-shell branch-map scope clarification 拆分记忆.md](../380-2026-04-13-schema-store%20bridge-shell%20branch-map%20scope%20clarification%20拆分记忆.md)
- [../381-2026-04-13-remote-truth branch-map scope clarification 拆分记忆.md](../381-2026-04-13-remote-truth%20branch-map%20scope%20clarification%20拆分记忆.md)
- [../382-2026-04-13-shell-pair branch-map scope clarification 拆分记忆.md](../382-2026-04-13-shell-pair%20branch-map%20scope%20clarification%20拆分记忆.md)

## 这层入口保护什么

- 保护的是 `100-149` 这簇记忆的家族入口，不是新的编号总图。
- 保护的是 `208 -> 209 -> 210`、`211 -> 212 -> 213`、`214 -> 215 -> 216 -> 217` 三段接力关系。
- 不把 `100-115`、`116-127`、`128-149` 误写成三份互不相干的旧批次。
- 不在这一轮移动或重命名任何现有记忆文件。
