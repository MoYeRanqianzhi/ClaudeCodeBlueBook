# 治理与边界

这里先只记三句：

1. 核心不是弹窗多少，而是这次扩张有没有先拿到 `pricing-right`。
2. sandbox、approval、settings、hooks 与 worktree 是不同控制面，不是一把总开关。
3. 如果你还分不清现在看到的是治理本体还是 UI 投影，先回 [01-权限、沙箱、审批与安全边界.md](./01-%E6%9D%83%E9%99%90%E3%80%81%E6%B2%99%E7%AE%B1%E3%80%81%E5%AE%A1%E6%89%B9%E4%B8%8E%E5%AE%89%E5%85%A8%E8%BE%B9%E7%95%8C.md) 与 [../../README.md](../../README.md)。

这里也要先压住一个常见误读：`continuity` 不是第四条治理线；它只是 `decision window -> continuation pricing -> cleanup-before-resume` 这段时间轴在用户侧的继续条件。

更稳一点说，这一层也必须继承 `问题分型 -> 工作对象 -> 控制面 -> 入口` 的 first-answer order；治理页若不能先把用户送回 `pricing-right / decision window / cleanup` 这组顺序，就会重新退回“看弹窗和 mode 猜结论”。

- [01-权限、沙箱、审批与安全边界.md](./01-%E6%9D%83%E9%99%90%E3%80%81%E6%B2%99%E7%AE%B1%E3%80%81%E5%AE%A1%E6%89%B9%E4%B8%8E%E5%AE%89%E5%85%A8%E8%BE%B9%E7%95%8C.md)
- [02-多 Agent、任务、团队、计划模式与 Worktree.md](./02-%E5%A4%9A%20Agent%E3%80%81%E4%BB%BB%E5%8A%A1%E3%80%81%E5%9B%A2%E9%98%9F%E3%80%81%E8%AE%A1%E5%88%92%E6%A8%A1%E5%BC%8F%E4%B8%8E%20Worktree.md)
