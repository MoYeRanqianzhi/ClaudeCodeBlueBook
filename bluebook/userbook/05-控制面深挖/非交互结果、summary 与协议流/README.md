# 非交互结果、summary 与协议流

这个目录不是新的编号总图，

而是给已经存在的 headless / 非交互深线补一个可浏览的物理入口。

如果你已经分清：

- `-p/--print` 是一次性非交互输出
- `--bg` 是后台继续跑
- `--sdk-url` / `stream-json` 是宿主协议流

但还没分清：

- 结果为什么不会落在同一本账
- summary / terminal tail / observer restore 为什么不是一层
- raw wire、callback 与 streamlined projection 为什么不是同一种“消息可见性”

这里应该先于平铺叶子页阅读。

## 第一性原理

这组页真正想回答的不是：

- “92-110 里我该按兴趣挑哪几篇读”

而是：

- 非交互入口已经成立后，结果怎样收束
- summary 与尾部恢复怎样继续分叉
- 协议流、callback 与 projection 又怎样形成另一条可见性分叉

所以更稳的读法不是：

- 从 `92/100/105` 随便挑一页开始

而是先固定三层不同问题：

1. 结果收束层：后台任务结果怎样从多账本前提收束到真实交付。
2. tail / restore 层：summary、terminal tail、observer restore 与 suggestion settlement 怎样分家。
3. wire / projection 层：wide wire、raw wire、callback surface 与 streamlined projection 怎样继续分叉。

## 先读哪一页

### 1. 我还在确认非交互入口本身

先读：

1. [../../04-专题深潜/13-非交互、后台会话与自动化专题.md](../../04-%E4%B8%93%E9%A2%98%E6%B7%B1%E6%BD%9C/13-%E9%9D%9E%E4%BA%A4%E4%BA%92%E3%80%81%E5%90%8E%E5%8F%B0%E4%BC%9A%E8%AF%9D%E4%B8%8E%E8%87%AA%E5%8A%A8%E5%8C%96%E4%B8%93%E9%A2%98.md)
2. [../20-Headless 启动链、首问就绪与 StructuredIO：为什么 print 不是没有 UI 的 REPL.md](../20-Headless%20%E5%90%AF%E5%8A%A8%E9%93%BE%E3%80%81%E9%A6%96%E9%97%AE%E5%B0%B1%E7%BB%AA%E4%B8%8E%20StructuredIO%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%20print%20%E4%B8%8D%E6%98%AF%E6%B2%A1%E6%9C%89%20UI%20%E7%9A%84%20REPL.md)

这两页负责固定：

- 入口类型
- 启动宿主
- `StructuredIO` / `RemoteIO` 的基础对象

### 2. 我已经进入 headless print 的结果收束链

先读：

1. [../207-task triad、result return-path、flush ordering、authoritative idle、semantic last result 与 suggestion delivery：为什么 headless print 的 92-99 不是并列细页，而是一条从多账本前提走到延迟交付的收束链.md](../207-task%20triad%E3%80%81result%20return-path%E3%80%81flush%20ordering%E3%80%81authoritative%20idle%E3%80%81semantic%20last%20result%20%E4%B8%8E%20suggestion%20delivery%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%20headless%20print%20%E7%9A%84%2092-99%20%E4%B8%8D%E6%98%AF%E5%B9%B6%E5%88%97%E7%BB%86%E9%A1%B5%EF%BC%8C%E8%80%8C%E6%98%AF%E4%B8%80%E6%9D%A1%E4%BB%8E%E5%A4%9A%E8%B4%A6%E6%9C%AC%E5%89%8D%E6%8F%90%E8%B5%B0%E5%88%B0%E5%BB%B6%E8%BF%9F%E4%BA%A4%E4%BB%98%E7%9A%84%E6%94%B6%E6%9D%9F%E9%93%BE.md)

它负责固定：

- 92-99 不是并列 FAQ
- 93/95/96/97/98 是主干
- 94/99 是挂枝

### 3. 我已经进入 summary / tail / restore 的后继线

再读：

1. [../208-task_summary、post_turn_summary、terminal tail、observer restore 与 suggestion settlement：为什么 100-104 不是并列细页，而是先从 summary 分家，再分叉到终态收口与恢复合同.md](../208-task_summary%E3%80%81post_turn_summary%E3%80%81terminal%20tail%E3%80%81observer%20restore%20%E4%B8%8E%20suggestion%20settlement%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%20100-104%20%E4%B8%8D%E6%98%AF%E5%B9%B6%E5%88%97%E7%BB%86%E9%A1%B5%EF%BC%8C%E8%80%8C%E6%98%AF%E5%85%88%E4%BB%8E%20summary%20%E5%88%86%E5%AE%B6%EF%BC%8C%E5%86%8D%E5%88%86%E5%8F%89%E5%88%B0%E7%BB%88%E6%80%81%E6%94%B6%E5%8F%A3%E4%B8%8E%E6%81%A2%E5%A4%8D%E5%90%88%E5%90%8C.md)

它负责固定：

- 100 是根页
- `101 -> 102 -> 104` 是主干
- 103 是 observer-restore 侧枝

### 4. 我已经进入 wire / callback / streamlined 的可见性分叉

再读：

1. [../209-post_turn_summary、StdoutMessage、SDKMessage、stream-json raw wire 与 streamlined_*：为什么 105、106、108、109、110 不是并列尾页，而是从 wider-wire visibility 分叉出去的四种后继问题.md](../209-post_turn_summary%E3%80%81StdoutMessage%E3%80%81SDKMessage%E3%80%81stream-json%20raw%20wire%20%E4%B8%8E%20streamlined_%2A%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%20105%E3%80%81106%E3%80%81108%E3%80%81109%E3%80%81110%20%E4%B8%8D%E6%98%AF%E5%B9%B6%E5%88%97%E5%B0%BE%E9%A1%B5%EF%BC%8C%E8%80%8C%E6%98%AF%E4%BB%8E%20wider-wire%20visibility%20%E5%88%86%E5%8F%89%E5%87%BA%E5%8E%BB%E7%9A%84%E5%9B%9B%E7%A7%8D%E5%90%8E%E7%BB%A7%E9%97%AE%E9%A2%98.md)

它负责固定：

- 105 是根页
- 106 / 108 / 109 是三条不同分叉
- 110 是 skip-list 相交后长出的交叉叶子

## 这层入口保护什么

- 保护的是非交互深线的阅读闭环，不是新的编号总图。
- 保护的是 `13 -> 20 -> 207 -> 208 -> 209` 这条高频深入路径。
- 不把 `print`、`--bg`、`--sdk-url` 混写成同一种自动化模式。
- 不把 `207/208/209` 误写成产品稳定能力目录；这里稳定的是阅读骨架，不是中间节点名。

## 苏格拉底式自审

### 问：我现在是在分清入口，还是已经进入结果收束 / summary / wire 的后继问题？

答：如果还没分清入口，就先回 `13` 和 `20`，不要直接跳叶子页。

### 问：我现在是在问后台任务如何结束，还是在问 summary / observer restore？

答：这两者不是同一个“tail”。

### 问：我是不是因为都看见了 `stream-json` / `SDKMessage` / `post_turn_summary`，就把协议流可见性写成同一种过滤？

答：先分 wider wire、callback narrowing、pre-wire projection，再谈 suppress reason。
