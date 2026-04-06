# 参考索引

这一部分不讲长篇原理，直接回答四个问题：

1. 到底有哪些命令。
2. 到底有哪些工具。
3. 哪些能力是稳定的，哪些是灰度的，哪些是内部的。
4. 当前版本自带哪些 bundled skills。
5. 从用户视角看，全部功能面应怎样分层。
6. 面对真实任务时，应该先走哪个入口。
7. 高价值入口背后到底有哪些运行时合同。
8. 名字相近的 root command 和 slash command 到底是不是一回事。
9. Settings tab、独立 screen、调参命令和预算分流到底分别属于什么对象。
10. 同样都是 slash command，为什么它们在对象类型、执行语义和可见性边界上并不是同一类按钮。
11. 技能为什么不是一张表，为什么 `/skills`、SkillTool、dynamic skills 看到的是不同投影。
12. Claude 与 remote client 到底通过哪些链看到可用能力，为什么 UI 菜单、system/init、skill 提醒不是同一张表。
13. 为什么同样是扩展来源，workspace trust、plugin-only policy、hooks 总闸和 admin-trusted source 不是同一层限制。
14. 为什么 `relevant skills`、static listing、remote skills 与 `shortId` 反馈回路不是同一条公开主线。
15. 为什么 `/hooks` 菜单、已配置 hooks、已注册 hooks 和实际会执行的 hooks 不是同一对象。
16. 为什么 `/mcp` 菜单、全局配置总览、按名解析与 Agent `mcpServers` 不是同一类 server。
17. 为什么插件“装好了、改好了、提示待刷新了、当前会话已吃到”不是同一状态。
18. 为什么插件有时会自己出现、有时只提示 `/reload-plugins`，而 startup trust、background install、headless refresh 又不是同一条自动链。
19. 为什么 `print` 不是没有 UI 的 REPL，为什么 headless 的首问就绪、StructuredIO 与 `--sdk-url` 又不是同一层对象。
20. 为什么 `server`、`remote-control`、`assistant`、`doctor` 与 `mcp list|get` 虽然都在会外层，却不是同一类 host、viewer 或 health-check 对象。
21. 为什么 `skip trust dialog`、项目级 `.mcp.json` 批准、`doctor` 与 `mcp list|get` 不属于同一层安全或运行时状态。
22. 为什么 remote-control 的 workspace trust、bridge eligibility、trusted-device、policy 与 OAuth 前提不是同一把钥匙。
23. 为什么 remote-control 的 auto-connect、mirror、perpetual continuity 与 `--continue` 不是同一种 bridge 重连。
24. 为什么 remote-control 的设置默认、显式开关、状态展示与当前断开语义不是同一个按钮。
25. 为什么 remote-control 的链接、二维码与 ID 不是同一种定位符。
26. 为什么 remote-control 的会内开桥、启动带桥与 standalone host 不是同一种入口。
27. 为什么 remote session client、viewer 与 bridge host 不是同一种远程工作流。
28. 为什么远端的权限提示、会话控制与命令白名单不是同一种控制合同。
29. 为什么远端会话的连接告警、后台任务、viewer ownership 与 bridge reconnect 不是同一张运行态面。
30. 为什么 bridge 的状态词、恢复厚度与动作上限不是同一个“已恢复”。
31. 为什么 bridge 的故障提示、当前会话停机与默认回退不是同一种关闭。

- [01-命令工具/README.md](./01-%E5%91%BD%E4%BB%A4%E5%B7%A5%E5%85%B7/README.md)
- [02-能力边界/README.md](./02-%E8%83%BD%E5%8A%9B%E8%BE%B9%E7%95%8C/README.md)
- [03-技能与扩展/README.md](./03-%E6%8A%80%E8%83%BD%E4%B8%8E%E6%89%A9%E5%B1%95/README.md)
- [04-功能面七分法.md](./04-%E5%8A%9F%E8%83%BD%E9%9D%A2%E4%B8%83%E5%88%86%E6%B3%95.md)
- [05-任务到入口速查矩阵.md](./05-%E4%BB%BB%E5%8A%A1%E5%88%B0%E5%85%A5%E5%8F%A3%E9%80%9F%E6%9F%A5%E7%9F%A9%E9%98%B5.md)
- [06-高价值入口运行时合同速查.md](./06-%E9%AB%98%E4%BB%B7%E5%80%BC%E5%85%A5%E5%8F%A3%E8%BF%90%E8%A1%8C%E6%97%B6%E5%90%88%E5%90%8C%E9%80%9F%E6%9F%A5.md)
