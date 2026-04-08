# 命令工具

这一层不是命令表，而是“命令怎样进入世界、怎样执行、怎样被过滤”的索引层。

如果把这一层压成最短前门，只剩两条：

1. 先认 `command object -> execution semantics -> visibility/caller gate -> host mode`
2. 先认 `task object -> capability projection -> runtime gate -> execution surface`

所以这里不是按钮目录，而是命令对象、执行语义与入口选择的速查层。

如果把整组再压成一条总公式，就是：

- `plane -> object -> semantics -> gate`

这里也要先压住一个常见误读：`/compact / /resume / /memory` 在命令索引层不是第四类命令家族；它们只是同一工作对象在时间轴上的 continuation actions。

如果你现在不是来查单个命令，而是想先分清：

- 启动时决定什么，进会话后决定什么。
- root flags、root commands、slash commands 为什么不是一层。

先看 [../00-阅读路径.md](../00-%E9%98%85%E8%AF%BB%E8%B7%AF%E5%BE%84.md) 里的“路径 14：我想分清 root flags、root commands 和 slash commands”，再读 [../../04-专题深潜/18-CLI 根入口、旗标与启动模式专题.md](../../04-%E4%B8%93%E9%A2%98%E6%B7%B1%E6%BD%9C/18-CLI%20%E6%A0%B9%E5%85%A5%E5%8F%A3%E3%80%81%E6%97%97%E6%A0%87%E4%B8%8E%E5%90%AF%E5%8A%A8%E6%A8%A1%E5%BC%8F%E4%B8%93%E9%A2%98.md)。

如果你真正卡住的是同名入口为什么不在一层，继续看 [../00-阅读路径.md](../00-%E9%98%85%E8%AF%BB%E8%B7%AF%E5%BE%84.md) 里的“路径 15：我想分清会外 root commands 和会内面板”，再读 [../../04-专题深潜/19-会外控制台与会内面板专题.md](../../04-%E4%B8%93%E9%A2%98%E6%B7%B1%E6%BD%9C/19-%E4%BC%9A%E5%A4%96%E6%8E%A7%E5%88%B6%E5%8F%B0%E4%B8%8E%E4%BC%9A%E5%86%85%E9%9D%A2%E6%9D%BF%E4%B8%93%E9%A2%98.md)。

- [01-命令索引.md](./01-%E5%91%BD%E4%BB%A4%E7%B4%A2%E5%BC%95.md)
- [02-工具索引.md](./02-%E5%B7%A5%E5%85%B7%E7%B4%A2%E5%BC%95.md)
- [03-CLI 旗标与根命令索引.md](./03-CLI%20%E6%97%97%E6%A0%87%E4%B8%8E%E6%A0%B9%E5%91%BD%E4%BB%A4%E7%B4%A2%E5%BC%95.md)
  这页是 root plane 投影页，先分 `flag / root command / fast-path`。
- [04-根命令与斜杠命令对照索引.md](./04-%E6%A0%B9%E5%91%BD%E4%BB%A4%E4%B8%8E%E6%96%9C%E6%9D%A0%E5%91%BD%E4%BB%A4%E5%AF%B9%E7%85%A7%E7%B4%A2%E5%BC%95.md)
  这页是同名异层 reject 页，先分 root plane 与 session plane。
- [05-设置、状态、预算与调参入口索引.md](./05-%E8%AE%BE%E7%BD%AE%E3%80%81%E7%8A%B6%E6%80%81%E3%80%81%E9%A2%84%E7%AE%97%E4%B8%8E%E8%B0%83%E5%8F%82%E5%85%A5%E5%8F%A3%E7%B4%A2%E5%BC%95.md)
  这页是运行时对象页，先分宿主状态投影、信任、预算窗口与调参/显示层。
- [06-命令类型、执行语义与可见性索引.md](./06-%E5%91%BD%E4%BB%A4%E7%B1%BB%E5%9E%8B%E3%80%81%E6%89%A7%E8%A1%8C%E8%AF%AD%E4%B9%89%E4%B8%8E%E5%8F%AF%E8%A7%81%E6%80%A7%E7%B4%A2%E5%BC%95.md)
  这页是主判断页，先分对象、语义与 gate。

如果你只看一页，先看 `06`；如果你想先按任务挑入口，再回到 `05-控制面深挖/05`。

更稳一点说，这一层也必须继承 `问题分型 -> 工作对象 -> 控制面 -> 入口` 的 first-answer order；如果先看命令名、后判工作对象，命令索引就会重新长成 pseudo-route map。

还要再补一句索引边界：

- 这一组页只负责把命令对象、执行语义与 gate 拆开，不负责把 projection 写回 signer。
