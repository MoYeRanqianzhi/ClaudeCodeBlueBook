# 执行与工具

这一层不回答“Claude Code 有哪些功能”，而是回答：

1. 模型到底能调用哪些执行面。
2. 哪些调用只是工具动作，哪些已经升级成任务对象。
3. 输出怎样回流、通知、恢复，而不是只停在一次 shell/tool 调用。

更短的前门公式只有两条：

1. `tool surface -> runtime gate -> execution`
2. `task object -> output return -> notification -> recovery`

这里也要先压住一个常见误读：`continuity` 不是第三条执行主线；`/compact / /resume / /memory` 只是在执行结果已经对象化之后，沿同一工作对象继续消费 `notification / output / recovery` 的时间轴动作。

这里也要主动拒收一种常见误读：

- 别把“工具多”当成执行先进性。
- 真正值钱的是 action surface 怎样被 gate、怎样回流成 task/output/notification contract。

更稳一点说，这一层也必须继承 `问题分型 -> 工作对象 -> 控制面 -> 入口` 的 first-answer order；如果用户还没先判这是工具调用还是任务对象，就不该先按工具名或入口名碰运气。

- [01-工具系统：文件、Shell、Web、Notebook、LSP 与结构化输出.md](./01-%E5%B7%A5%E5%85%B7%E7%B3%BB%E7%BB%9F%EF%BC%9A%E6%96%87%E4%BB%B6%E3%80%81Shell%E3%80%81Web%E3%80%81Notebook%E3%80%81LSP%20%E4%B8%8E%E7%BB%93%E6%9E%84%E5%8C%96%E8%BE%93%E5%87%BA.md)
- [02-任务对象、输出回流、通知与恢复.md](./02-%E4%BB%BB%E5%8A%A1%E5%AF%B9%E8%B1%A1%E3%80%81%E8%BE%93%E5%87%BA%E5%9B%9E%E6%B5%81%E3%80%81%E9%80%9A%E7%9F%A5%E4%B8%8E%E6%81%A2%E5%A4%8D.md)

如果你只看一页，先看 `01`；如果你现在争议的是“为什么这已经不是普通工具调用，而是任务对象”，先看 `02`。
