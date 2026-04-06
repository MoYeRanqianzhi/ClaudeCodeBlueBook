# 控制面深挖

这一层专门处理“概览已经不够”的高价值控制面。

它和 `04-专题深潜` 的区别是：

- `04-专题深潜` 按真实工作目标组织。
- 这里按控制面组织，专门回答“为什么同一目标不能随便走相邻入口”。
- 这里不承担命令速查；速查页统一留在 `03-参考索引/`。

- [01-权限、计划模式与 Worktree：如何安全放大行动范围.md](./01-%E6%9D%83%E9%99%90%E3%80%81%E8%AE%A1%E5%88%92%E6%A8%A1%E5%BC%8F%E4%B8%8E%20Worktree%EF%BC%9A%E5%A6%82%E4%BD%95%E5%AE%89%E5%85%A8%E6%94%BE%E5%A4%A7%E8%A1%8C%E5%8A%A8%E8%8C%83%E5%9B%B4.md)
- [02-MCP、插件、技能与 Hooks：如何选择正确扩展层.md](./02-MCP%E3%80%81%E6%8F%92%E4%BB%B6%E3%80%81%E6%8A%80%E8%83%BD%E4%B8%8E%20Hooks%EF%BC%9A%E5%A6%82%E4%BD%95%E9%80%89%E6%8B%A9%E6%AD%A3%E7%A1%AE%E6%89%A9%E5%B1%95%E5%B1%82.md)
- [03-Compact、Resume、Memory：长任务连续性手册.md](./03-Compact%E3%80%81Resume%E3%80%81Memory%EF%BC%9A%E9%95%BF%E4%BB%BB%E5%8A%A1%E8%BF%9E%E7%BB%AD%E6%80%A7%E6%89%8B%E5%86%8C.md)
- [04-Agent、Task、Team、Cron：并行执行而不失控.md](./04-Agent%E3%80%81Task%E3%80%81Team%E3%80%81Cron%EF%BC%9A%E5%B9%B6%E8%A1%8C%E6%89%A7%E8%A1%8C%E8%80%8C%E4%B8%8D%E5%A4%B1%E6%8E%A7.md)
- [05-命令、提示词、技能、工具：入口选择决策树.md](./05-%E5%91%BD%E4%BB%A4%E3%80%81%E6%8F%90%E7%A4%BA%E8%AF%8D%E3%80%81%E6%8A%80%E8%83%BD%E3%80%81%E5%B7%A5%E5%85%B7%EF%BC%9A%E5%85%A5%E5%8F%A3%E9%80%89%E6%8B%A9%E5%86%B3%E7%AD%96%E6%A0%91.md)
- [06-Status、Doctor、Usage：运行时自检、额度与诊断.md](./06-Status%E3%80%81Doctor%E3%80%81Usage%EF%BC%9A%E8%BF%90%E8%A1%8C%E6%97%B6%E8%87%AA%E6%A3%80%E3%80%81%E9%A2%9D%E5%BA%A6%E4%B8%8E%E8%AF%8A%E6%96%AD.md)
- [07-Add-dir：工作面扩张、权限上下文与 Sandbox 刷新.md](./07-Add-dir%EF%BC%9A%E5%B7%A5%E4%BD%9C%E9%9D%A2%E6%89%A9%E5%BC%A0%E3%80%81%E6%9D%83%E9%99%90%E4%B8%8A%E4%B8%8B%E6%96%87%E4%B8%8E%20Sandbox%20%E5%88%B7%E6%96%B0.md)
- [08-Rename、Export：会话对象化与对外交付.md](./08-Rename%E3%80%81Export%EF%BC%9A%E4%BC%9A%E8%AF%9D%E5%AF%B9%E8%B1%A1%E5%8C%96%E4%B8%8E%E5%AF%B9%E5%A4%96%E4%BA%A4%E4%BB%98.md)
- [09-Release-notes、Feedback：版本证据与产品反馈回路.md](./09-Release-notes%E3%80%81Feedback%EF%BC%9A%E7%89%88%E6%9C%AC%E8%AF%81%E6%8D%AE%E4%B8%8E%E4%BA%A7%E5%93%81%E5%8F%8D%E9%A6%88%E5%9B%9E%E8%B7%AF.md)
- [10-设置面板、诊断屏与运营命令：会内控制面的三层分工.md](./10-%E8%AE%BE%E7%BD%AE%E9%9D%A2%E6%9D%BF%E3%80%81%E8%AF%8A%E6%96%AD%E5%B1%8F%E4%B8%8E%E8%BF%90%E8%90%A5%E5%91%BD%E4%BB%A4%EF%BC%9A%E4%BC%9A%E5%86%85%E6%8E%A7%E5%88%B6%E9%9D%A2%E7%9A%84%E4%B8%89%E5%B1%82%E5%88%86%E5%B7%A5.md)
- [11-命令对象、执行语义与可见性：为什么 slash command 不是同一种按钮.md](./11-%E5%91%BD%E4%BB%A4%E5%AF%B9%E8%B1%A1%E3%80%81%E6%89%A7%E8%A1%8C%E8%AF%AD%E4%B9%89%E4%B8%8E%E5%8F%AF%E8%A7%81%E6%80%A7%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%20slash%20command%20%E4%B8%8D%E6%98%AF%E5%90%8C%E4%B8%80%E7%A7%8D%E6%8C%89%E9%92%AE.md)
- [12-技能来源、暴露面与触发：为什么 skills 菜单不是能力全集.md](./12-%E6%8A%80%E8%83%BD%E6%9D%A5%E6%BA%90%E3%80%81%E6%9A%B4%E9%9C%B2%E9%9D%A2%E4%B8%8E%E8%A7%A6%E5%8F%91%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%20skills%20%E8%8F%9C%E5%8D%95%E4%B8%8D%E6%98%AF%E8%83%BD%E5%8A%9B%E5%85%A8%E9%9B%86.md)
- [13-system-init、技能提醒与 SkillTool：Claude 如何看见可用能力.md](./13-system-init%E3%80%81%E6%8A%80%E8%83%BD%E6%8F%90%E9%86%92%E4%B8%8E%20SkillTool%EF%BC%9AClaude%20%E5%A6%82%E4%BD%95%E7%9C%8B%E8%A7%81%E5%8F%AF%E7%94%A8%E8%83%BD%E5%8A%9B.md)
- [14-来源信任、Trust Dialog 与 Plugin-only Policy：扩展面为何分级信任.md](./14-%E6%9D%A5%E6%BA%90%E4%BF%A1%E4%BB%BB%E3%80%81Trust%20Dialog%20%E4%B8%8E%20Plugin-only%20Policy%EF%BC%9A%E6%89%A9%E5%B1%95%E9%9D%A2%E4%B8%BA%E4%BD%95%E5%88%86%E7%BA%A7%E4%BF%A1%E4%BB%BB.md)

这一层适合在你已经知道“我想做什么”之后，进一步判断“为什么系统推荐这条路径，而不是相邻那条路径”。
