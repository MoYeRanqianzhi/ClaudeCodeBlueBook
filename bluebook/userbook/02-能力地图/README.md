# 能力地图

这一部分只承接 [../README.md](../README.md) 已判清的用户问题分型，按运行时主链拆成五个子层，帮助你理解“能力在哪一层暴露、边界在哪一层收紧”。
它只做 capability map 与退层提示，不重签 host-facing truth，也不重判 why。

如果只先记住读图前三句，也只先记这三句：

1. Prompt
   - 能力出现不等于 later consumer 可以在 `tool choice / resume / handoff / compaction` 后继续消费同一件事；若它还会逼你重答世界主语、重判继续资格或把已排除路径拉回候选集，这层就不是 Prompt 正常桥接。
2. 治理
   - 能力可见不等于扩张已被允许；继续前若还答不出 `repricing proof / lease checkpoint / cleanup`，就不要把当前层的按钮、面板或设置项误读成治理 verdict。
3. 当前真相
   - 能力挂在哪层，不等于它能宣布现在；若解释答不出它靠的是 `contract / registry / current-truth claim state`，以及如何不破坏 `one writable present`，这层就还只是地图，不是当前真相。

如果你还没分清自己现在更需要工作主题前门、任务入口速查，还是控制面分诊，先回 [../README.md](../README.md) 的“按目标进入”；需要速查入口时再看 [../03-参考索引/README.md](../03-%E5%8F%82%E8%80%83%E7%B4%A2%E5%BC%95/README.md)，需要控制面主权时再看 [../05-控制面深挖/README.md](../05-%E6%8E%A7%E5%88%B6%E9%9D%A2%E6%B7%B1%E6%8C%96/README.md)。

## 五个子层分别回答什么

- [01-运行时主链/README.md](./01-%E8%BF%90%E8%A1%8C%E6%97%B6%E4%B8%BB%E9%93%BE/README.md)
  回答 Claude Code 从启动、会话装配到主循环是怎样串起来的。
- [02-执行与工具/README.md](./02-%E6%89%A7%E8%A1%8C%E4%B8%8E%E5%B7%A5%E5%85%B7/README.md)
  回答模型怎样驱动文件、Shell、Web、Notebook、LSP 等执行面。
- [03-治理与边界/README.md](./03-%E6%B2%BB%E7%90%86%E4%B8%8E%E8%BE%B9%E7%95%8C/README.md)
  回答权限、连续性、约束和边界是怎样把运行时收住的。
- [04-扩展与生态/README.md](./04-%E6%89%A9%E5%B1%95%E4%B8%8E%E7%94%9F%E6%80%81/README.md)
  回答 skills、plugins、MCP、hooks、agents 怎样接进系统。
- [05-体验与入口/README.md](./05-%E4%BD%93%E9%AA%8C%E4%B8%8E%E5%85%A5%E5%8F%A3/README.md)
  回答终端、IDE、多前端和入口层是怎样把运行时投影给用户的。

## 使用边界

- 想判“为什么必须如此设计”，退回 `../../philosophy/README.md`
- 想判“现在什么被正式承认”，退回 `../../api/README.md`
- 想判“现场该走哪个 verdict”，退回 `../../playbooks/README.md`
