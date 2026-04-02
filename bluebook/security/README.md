# 安全专题索引

## 这一专题研究什么

这一专题研究的不是泛泛的“Claude Code 很安全”，  
而是更具体的六个问题：

1. 它的安全边界从哪一层开始建立
2. 它如何把权限、沙箱、分类器、受管环境和远程能力串成一张控制面
3. 它如何保护密钥、配置和宿主运行时不被项目内容反向污染
4. 它如何收口外部能力，例如 MCP、WebFetch、hooks 与 gateway
5. 这套设计在工程上先进在哪里，又有哪些公开构建边界
6. 如果从第一性原理重写这套系统，还能做得更好吗

## 当前核心判断

- Claude Code 的安全性不是单点沙箱，也不是单点分类器。
- 它更像一套分层安全控制面：启动信任、权限模式、规则系统、分类器仲裁、受管环境过滤、外部能力收口、远程资格与宿主边界。
- 真正的设计重点不是“尽量禁用能力”，而是“能力必须经过正确边界流动”。

## 建议阅读顺序

1. [00-研究方法与可信边界](00-%E7%A0%94%E7%A9%B6%E6%96%B9%E6%B3%95%E4%B8%8E%E5%8F%AF%E4%BF%A1%E8%BE%B9%E7%95%8C.md)
2. [01-安全总论：Claude Code 不是单点沙箱，而是分层安全控制面](01-%E5%AE%89%E5%85%A8%E6%80%BB%E8%AE%BA%EF%BC%9AClaude%20Code%20%E4%B8%8D%E6%98%AF%E5%8D%95%E7%82%B9%E6%B2%99%E7%AE%B1%EF%BC%8C%E8%80%8C%E6%98%AF%E5%88%86%E5%B1%82%E5%AE%89%E5%85%A8%E6%8E%A7%E5%88%B6%E9%9D%A2.md)
3. [02-权限、沙箱与最小授权：真正危险的不是工具强，而是工具绕过仲裁](02-%E6%9D%83%E9%99%90%E3%80%81%E6%B2%99%E7%AE%B1%E4%B8%8E%E6%9C%80%E5%B0%8F%E6%8E%88%E6%9D%83%EF%BC%9A%E7%9C%9F%E6%AD%A3%E5%8D%B1%E9%99%A9%E7%9A%84%E4%B8%8D%E6%98%AF%E5%B7%A5%E5%85%B7%E5%BC%BA%EF%BC%8C%E8%80%8C%E6%98%AF%E5%B7%A5%E5%85%B7%E7%BB%95%E8%BF%87%E4%BB%B2%E8%A3%81.md)
4. [03-认证、密钥与受管环境：安全边界首先要防的是运行时被配置污染](03-%E8%AE%A4%E8%AF%81%E3%80%81%E5%AF%86%E9%92%A5%E4%B8%8E%E5%8F%97%E7%AE%A1%E7%8E%AF%E5%A2%83%EF%BC%9A%E5%AE%89%E5%85%A8%E8%BE%B9%E7%95%8C%E9%A6%96%E5%85%88%E8%A6%81%E9%98%B2%E7%9A%84%E6%98%AF%E8%BF%90%E8%A1%8C%E6%97%B6%E8%A2%AB%E9%85%8D%E7%BD%AE%E6%B1%A1%E6%9F%93.md)
5. [04-MCP、WebFetch、hooks 与外部能力收口：外部世界不是默认可信上下文](04-MCP%E3%80%81WebFetch%E3%80%81hooks%20%E4%B8%8E%E5%A4%96%E9%83%A8%E8%83%BD%E5%8A%9B%E6%94%B6%E5%8F%A3%EF%BC%9A%E5%A4%96%E9%83%A8%E4%B8%96%E7%95%8C%E4%B8%8D%E6%98%AF%E9%BB%98%E8%AE%A4%E5%8F%AF%E4%BF%A1%E4%B8%8A%E4%B8%8B%E6%96%87.md)
6. [05-安全设计哲学与技术先进性：它不是把能力做小，而是把边界做实](05-%E5%AE%89%E5%85%A8%E8%AE%BE%E8%AE%A1%E5%93%B2%E5%AD%A6%E4%B8%8E%E6%8A%80%E6%9C%AF%E5%85%88%E8%BF%9B%E6%80%A7%EF%BC%9A%E5%AE%83%E4%B8%8D%E6%98%AF%E6%8A%8A%E8%83%BD%E5%8A%9B%E5%81%9A%E5%B0%8F%EF%BC%8C%E8%80%8C%E6%98%AF%E6%8A%8A%E8%BE%B9%E7%95%8C%E5%81%9A%E5%AE%9E.md)
7. [06-第一性原理与苏格拉底式反思：如果要把这套安全性再提高一倍，还缺什么](06-%E7%AC%AC%E4%B8%80%E6%80%A7%E5%8E%9F%E7%90%86%E4%B8%8E%E8%8B%8F%E6%A0%BC%E6%8B%89%E5%BA%95%E5%BC%8F%E5%8F%8D%E6%80%9D%EF%BC%9A%E5%A6%82%E6%9E%9C%E8%A6%81%E6%8A%8A%E8%BF%99%E5%A5%97%E5%AE%89%E5%85%A8%E6%80%A7%E5%86%8D%E6%8F%90%E9%AB%98%E4%B8%80%E5%80%8D%EF%BC%8C%E8%BF%98%E7%BC%BA%E4%BB%80%E4%B9%88.md)
8. [07-权限状态机与安全仲裁时序：从 mode 切换到 ask、allow、deny 的真实顺序](07-%E6%9D%83%E9%99%90%E7%8A%B6%E6%80%81%E6%9C%BA%E4%B8%8E%E5%AE%89%E5%85%A8%E4%BB%B2%E8%A3%81%E6%97%B6%E5%BA%8F%EF%BC%9A%E4%BB%8E%20mode%20%E5%88%87%E6%8D%A2%E5%88%B0%20ask%E3%80%81allow%E3%80%81deny%20%E7%9A%84%E7%9C%9F%E5%AE%9E%E9%A1%BA%E5%BA%8F.md)
9. [08-配置来源优先级矩阵与受管环境主权：谁有资格定义运行时](08-%E9%85%8D%E7%BD%AE%E6%9D%A5%E6%BA%90%E4%BC%98%E5%85%88%E7%BA%A7%E7%9F%A9%E9%98%B5%E4%B8%8E%E5%8F%97%E7%AE%A1%E7%8E%AF%E5%A2%83%E4%B8%BB%E6%9D%83%EF%BC%9A%E8%B0%81%E6%9C%89%E8%B5%84%E6%A0%BC%E5%AE%9A%E4%B9%89%E8%BF%90%E8%A1%8C%E6%97%B6.md)
10. [09-外部入口风险分级矩阵：MCP、WebFetch、hooks、gateway 分别在打开哪一种攻击面](09-%E5%A4%96%E9%83%A8%E5%85%A5%E5%8F%A3%E9%A3%8E%E9%99%A9%E5%88%86%E7%BA%A7%E7%9F%A9%E9%98%B5%EF%BC%9AMCP%E3%80%81WebFetch%E3%80%81hooks%E3%80%81gateway%20%E5%88%86%E5%88%AB%E5%9C%A8%E6%89%93%E5%BC%80%E5%93%AA%E4%B8%80%E7%A7%8D%E6%94%BB%E5%87%BB%E9%9D%A2.md)
11. [10-安全状态面与可解释性产品化：系统已经有零件，但还缺一张统一仪表盘](10-%E5%AE%89%E5%85%A8%E7%8A%B6%E6%80%81%E9%9D%A2%E4%B8%8E%E5%8F%AF%E8%A7%A3%E9%87%8A%E6%80%A7%E4%BA%A7%E5%93%81%E5%8C%96%EF%BC%9A%E7%B3%BB%E7%BB%9F%E5%B7%B2%E7%BB%8F%E6%9C%89%E9%9B%B6%E4%BB%B6%EF%BC%8C%E4%BD%86%E8%BF%98%E7%BC%BA%E4%B8%80%E5%BC%A0%E7%BB%9F%E4%B8%80%E4%BB%AA%E8%A1%A8%E7%9B%98.md)
12. [11-给 Agent 平台构建者的可迁移安全设计法则：把来源、仲裁、主权与解释做成同一套控制面](11-%E7%BB%99%20Agent%20%E5%B9%B3%E5%8F%B0%E6%9E%84%E5%BB%BA%E8%80%85%E7%9A%84%E5%8F%AF%E8%BF%81%E7%A7%BB%E5%AE%89%E5%85%A8%E8%AE%BE%E8%AE%A1%E6%B3%95%E5%88%99%EF%BC%9A%E6%8A%8A%E6%9D%A5%E6%BA%90%E3%80%81%E4%BB%B2%E8%A3%81%E3%80%81%E4%B8%BB%E6%9D%83%E4%B8%8E%E8%A7%A3%E9%87%8A%E5%81%9A%E6%88%90%E5%90%8C%E4%B8%80%E5%A5%97%E6%8E%A7%E5%88%B6%E9%9D%A2.md)
13. [12-如果要把 Claude Code 的安全产品化再推进一代：平台方最该做成产品的十二项改进](12-%E5%A6%82%E6%9E%9C%E8%A6%81%E6%8A%8A%20Claude%20Code%20%E7%9A%84%E5%AE%89%E5%85%A8%E4%BA%A7%E5%93%81%E5%8C%96%E5%86%8D%E6%8E%A8%E8%BF%9B%E4%B8%80%E4%BB%A3%EF%BC%9A%E5%B9%B3%E5%8F%B0%E6%96%B9%E6%9C%80%E8%AF%A5%E5%81%9A%E6%88%90%E4%BA%A7%E5%93%81%E7%9A%84%E5%8D%81%E4%BA%8C%E9%A1%B9%E6%94%B9%E8%BF%9B.md)
14. [13-安全专题二级索引：按问题、攻击面、主权冲突与产品改进快速阅读](13-%E5%AE%89%E5%85%A8%E4%B8%93%E9%A2%98%E4%BA%8C%E7%BA%A7%E7%B4%A2%E5%BC%95%EF%BC%9A%E6%8C%89%E9%97%AE%E9%A2%98%E3%80%81%E6%94%BB%E5%87%BB%E9%9D%A2%E3%80%81%E4%B8%BB%E6%9D%83%E5%86%B2%E7%AA%81%E4%B8%8E%E4%BA%A7%E5%93%81%E6%94%B9%E8%BF%9B%E5%BF%AB%E9%80%9F%E9%98%85%E8%AF%BB.md)
15. [14-安全控制面总图：从 trust 到 entitlement 的全链结构图谱](14-%E5%AE%89%E5%85%A8%E6%8E%A7%E5%88%B6%E9%9D%A2%E6%80%BB%E5%9B%BE%EF%BC%9A%E4%BB%8E%20trust%20%E5%88%B0%20entitlement%20%E7%9A%84%E5%85%A8%E9%93%BE%E7%BB%93%E6%9E%84%E5%9B%BE%E8%B0%B1.md)
16. [15-来源主权总表：settings、permissions、hooks、MCP、plugins、sandbox、gateway 到底谁能覆盖谁](15-%E6%9D%A5%E6%BA%90%E4%B8%BB%E6%9D%83%E6%80%BB%E8%A1%A8%EF%BC%9Asettings%E3%80%81permissions%E3%80%81hooks%E3%80%81MCP%E3%80%81plugins%E3%80%81sandbox%E3%80%81gateway%20%E5%88%B0%E5%BA%95%E8%B0%81%E8%83%BD%E8%A6%86%E7%9B%96%E8%B0%81.md)
17. [16-安全反模式与反公理：哪些看似方便的做法会掏空这套边界](16-%E5%AE%89%E5%85%A8%E5%8F%8D%E6%A8%A1%E5%BC%8F%E4%B8%8E%E5%8F%8D%E5%85%AC%E7%90%86%EF%BC%9A%E5%93%AA%E4%BA%9B%E7%9C%8B%E4%BC%BC%E6%96%B9%E4%BE%BF%E7%9A%84%E5%81%9A%E6%B3%95%E4%BC%9A%E6%8E%8F%E7%A9%BA%E8%BF%99%E5%A5%97%E8%BE%B9%E7%95%8C.md)
18. [17-终局总指南：Claude Code 安全研究的最佳最全版](17-%E7%BB%88%E5%B1%80%E6%80%BB%E6%8C%87%E5%8D%97%EF%BC%9AClaude%20Code%20%E5%AE%89%E5%85%A8%E7%A0%94%E7%A9%B6%E7%9A%84%E6%9C%80%E4%BD%B3%E6%9C%80%E5%85%A8%E7%89%88.md)
19. [18-安全检测技术内核：从危险模式识别到来源主权收口](18-%E5%AE%89%E5%85%A8%E6%A3%80%E6%B5%8B%E6%8A%80%E6%9C%AF%E5%86%85%E6%A0%B8%EF%BC%9A%E4%BB%8E%E5%8D%B1%E9%99%A9%E6%A8%A1%E5%BC%8F%E8%AF%86%E5%88%AB%E5%88%B0%E6%9D%A5%E6%BA%90%E4%B8%BB%E6%9D%83%E6%94%B6%E5%8F%A3.md)
20. [19-安全不变量：哪些约束绝不能被模式切换、快路径和来源合并打破](19-%E5%AE%89%E5%85%A8%E4%B8%8D%E5%8F%98%E9%87%8F%EF%BC%9A%E5%93%AA%E4%BA%9B%E7%BA%A6%E6%9D%9F%E7%BB%9D%E4%B8%8D%E8%83%BD%E8%A2%AB%E6%A8%A1%E5%BC%8F%E5%88%87%E6%8D%A2%E3%80%81%E5%BF%AB%E8%B7%AF%E5%BE%84%E5%92%8C%E6%9D%A5%E6%BA%90%E5%90%88%E5%B9%B6%E6%89%93%E7%A0%B4.md)
21. [20-边界失真理论：为什么 Claude Code 检测的不是坏动作而是结构失真](20-%E8%BE%B9%E7%95%8C%E5%A4%B1%E7%9C%9F%E7%90%86%E8%AE%BA%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%20Claude%20Code%20%E6%A3%80%E6%B5%8B%E7%9A%84%E4%B8%8D%E6%98%AF%E5%9D%8F%E5%8A%A8%E4%BD%9C%E8%80%8C%E6%98%AF%E7%BB%93%E6%9E%84%E5%A4%B1%E7%9C%9F.md)
22. [21-安全状态面源码解剖：为什么系统已有很多零件，却还没有一张统一安全控制台](21-%E5%AE%89%E5%85%A8%E7%8A%B6%E6%80%81%E9%9D%A2%E6%BA%90%E7%A0%81%E8%A7%A3%E5%89%96%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%E7%B3%BB%E7%BB%9F%E5%B7%B2%E6%9C%89%E5%BE%88%E5%A4%9A%E9%9B%B6%E4%BB%B6%EF%BC%8C%E5%8D%B4%E8%BF%98%E6%B2%A1%E6%9C%89%E4%B8%80%E5%BC%A0%E7%BB%9F%E4%B8%80%E5%AE%89%E5%85%A8%E6%8E%A7%E5%88%B6%E5%8F%B0.md)
23. [22-安全证明链：主体、主权、授权、包络、外部能力与增量审批为何必须同时成立](22-%E5%AE%89%E5%85%A8%E8%AF%81%E6%98%8E%E9%93%BE%EF%BC%9A%E4%B8%BB%E4%BD%93%E3%80%81%E4%B8%BB%E6%9D%83%E3%80%81%E6%8E%88%E6%9D%83%E3%80%81%E5%8C%85%E7%BB%9C%E3%80%81%E5%A4%96%E9%83%A8%E8%83%BD%E5%8A%9B%E4%B8%8E%E5%A2%9E%E9%87%8F%E5%AE%A1%E6%89%B9%E4%B8%BA%E4%BD%95%E5%BF%85%E9%A1%BB%E5%90%8C%E6%97%B6%E6%88%90%E7%AB%8B.md)
24. [23-统一安全控制台字段设计：源码里已经有哪些状态字段，还缺哪些跨面字段](23-%E7%BB%9F%E4%B8%80%E5%AE%89%E5%85%A8%E6%8E%A7%E5%88%B6%E5%8F%B0%E5%AD%97%E6%AE%B5%E8%AE%BE%E8%AE%A1%EF%BC%9A%E6%BA%90%E7%A0%81%E9%87%8C%E5%B7%B2%E7%BB%8F%E6%9C%89%E5%93%AA%E4%BA%9B%E7%8A%B6%E6%80%81%E5%AD%97%E6%AE%B5%EF%BC%8C%E8%BF%98%E7%BC%BA%E5%93%AA%E4%BA%9B%E8%B7%A8%E9%9D%A2%E5%AD%97%E6%AE%B5.md)
25. [24-统一安全控制台卡片设计：如何把字段、证明链与最短动作做成真正可用的界面](24-%E7%BB%9F%E4%B8%80%E5%AE%89%E5%85%A8%E6%8E%A7%E5%88%B6%E5%8F%B0%E5%8D%A1%E7%89%87%E8%AE%BE%E8%AE%A1%EF%BC%9A%E5%A6%82%E4%BD%95%E6%8A%8A%E5%AD%97%E6%AE%B5%E3%80%81%E8%AF%81%E6%98%8E%E9%93%BE%E4%B8%8E%E6%9C%80%E7%9F%AD%E5%8A%A8%E4%BD%9C%E5%81%9A%E6%88%90%E7%9C%9F%E6%AD%A3%E5%8F%AF%E7%94%A8%E7%9A%84%E7%95%8C%E9%9D%A2.md)
26. [25-统一安全控制台最短诊断路径：如何把状态、证明断点、控制动作与回读验证闭成一条链](25-%E7%BB%9F%E4%B8%80%E5%AE%89%E5%85%A8%E6%8E%A7%E5%88%B6%E5%8F%B0%E6%9C%80%E7%9F%AD%E8%AF%8A%E6%96%AD%E8%B7%AF%E5%BE%84%EF%BC%9A%E5%A6%82%E4%BD%95%E6%8A%8A%E7%8A%B6%E6%80%81%E3%80%81%E8%AF%81%E6%98%8E%E6%96%AD%E7%82%B9%E3%80%81%E6%8E%A7%E5%88%B6%E5%8A%A8%E4%BD%9C%E4%B8%8E%E5%9B%9E%E8%AF%BB%E9%AA%8C%E8%AF%81%E9%97%AD%E6%88%90%E4%B8%80%E6%9D%A1%E9%93%BE.md)
27. [26-统一安全控制台交互状态机：页面切换、动作触发、回读刷新与宿主适配为什么必须统一设计](26-统一安全控制台交互状态机：页面切换、动作触发、回读刷新与宿主适配为什么必须统一设计.md)
28. [27-安全对象协议：为什么统一安全控制台必须先有宿主保真契约，再谈页面设计](27-安全对象协议：为什么统一安全控制台必须先有宿主保真契约，再谈页面设计.md)
29. [28-显式降级理论：为什么窄宿主不是问题，隐性子集才是安全问题](28-显式降级理论：为什么窄宿主不是问题，隐性子集才是安全问题.md)
30. [29-宿主资格等级：观察宿主、控制宿主、证明宿主为何必须分层定义](29-宿主资格等级：观察宿主、控制宿主、证明宿主为何必须分层定义.md)
31. [30-安全真相源层级：为什么 `worker_status`、`external_metadata`、`AppState` 与界面文案不能互相替代](30-%E5%AE%89%E5%85%A8%E7%9C%9F%E7%9B%B8%E6%BA%90%E5%B1%82%E7%BA%A7%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%20%60worker_status%60%E3%80%81%60external_metadata%60%E3%80%81%60AppState%60%20%E4%B8%8E%E7%95%8C%E9%9D%A2%E6%96%87%E6%A1%88%E4%B8%8D%E8%83%BD%E4%BA%92%E7%9B%B8%E6%9B%BF%E4%BB%A3.md)
32. [31-安全真相仲裁：当实时事件、复制状态、本地状态与界面摘要冲突时谁说了算](31-%E5%AE%89%E5%85%A8%E7%9C%9F%E7%9B%B8%E4%BB%B2%E8%A3%81%EF%BC%9A%E5%BD%93%E5%AE%9E%E6%97%B6%E4%BA%8B%E4%BB%B6%E3%80%81%E5%A4%8D%E5%88%B6%E7%8A%B6%E6%80%81%E3%80%81%E6%9C%AC%E5%9C%B0%E7%8A%B6%E6%80%81%E4%B8%8E%E7%95%8C%E9%9D%A2%E6%91%98%E8%A6%81%E5%86%B2%E7%AA%81%E6%97%B6%E8%B0%81%E8%AF%B4%E4%BA%86%E7%AE%97.md)
33. [32-安全裂脑防御：为什么单一更新闸门、镜像纪律、去重与清理优于事后解释](32-%E5%AE%89%E5%85%A8%E8%A3%82%E8%84%91%E9%98%B2%E5%BE%A1%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%E5%8D%95%E4%B8%80%E6%9B%B4%E6%96%B0%E9%97%B8%E9%97%A8%E3%80%81%E9%95%9C%E5%83%8F%E7%BA%AA%E5%BE%8B%E3%80%81%E5%8E%BB%E9%87%8D%E4%B8%8E%E6%B8%85%E7%90%86%E4%BC%98%E4%BA%8E%E4%BA%8B%E5%90%8E%E8%A7%A3%E9%87%8A.md)
34. [33-安全单写者原则：为什么关键安全事实必须有唯一作者，其他层只能镜像](33-%E5%AE%89%E5%85%A8%E5%8D%95%E5%86%99%E8%80%85%E5%8E%9F%E5%88%99%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%E5%85%B3%E9%94%AE%E5%AE%89%E5%85%A8%E4%BA%8B%E5%AE%9E%E5%BF%85%E9%A1%BB%E6%9C%89%E5%94%AF%E4%B8%80%E4%BD%9C%E8%80%85%EF%BC%8C%E5%85%B6%E4%BB%96%E5%B1%82%E5%8F%AA%E8%83%BD%E9%95%9C%E5%83%8F.md)
35. [34-安全提交语义：关键安全事实何时算已提交，何时只是排队、可见或可恢复](34-%E5%AE%89%E5%85%A8%E6%8F%90%E4%BA%A4%E8%AF%AD%E4%B9%89%EF%BC%9A%E5%85%B3%E9%94%AE%E5%AE%89%E5%85%A8%E4%BA%8B%E5%AE%9E%E4%BD%95%E6%97%B6%E7%AE%97%E5%B7%B2%E6%8F%90%E4%BA%A4%EF%BC%8C%E4%BD%95%E6%97%B6%E5%8F%AA%E6%98%AF%E6%8E%92%E9%98%9F%E3%80%81%E5%8F%AF%E8%A7%81%E6%88%96%E5%8F%AF%E6%81%A2%E5%A4%8D.md)
36. [35-安全多账本原则：为什么语义、复制、可见与恢复不能共用同一本账](35-%E5%AE%89%E5%85%A8%E5%A4%9A%E8%B4%A6%E6%9C%AC%E5%8E%9F%E5%88%99%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%E8%AF%AD%E4%B9%89%E3%80%81%E5%A4%8D%E5%88%B6%E3%80%81%E5%8F%AF%E8%A7%81%E4%B8%8E%E6%81%A2%E5%A4%8D%E4%B8%8D%E8%83%BD%E5%85%B1%E7%94%A8%E5%90%8C%E4%B8%80%E6%9C%AC%E8%B4%A6.md)
37. [36-安全账本投影原则：为什么不同宿主只能看到账本子集，而不能冒充完整安全控制台](36-%E5%AE%89%E5%85%A8%E8%B4%A6%E6%9C%AC%E6%8A%95%E5%BD%B1%E5%8E%9F%E5%88%99%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%E4%B8%8D%E5%90%8C%E5%AE%BF%E4%B8%BB%E5%8F%AA%E8%83%BD%E7%9C%8B%E5%88%B0%E8%B4%A6%E6%9C%AC%E5%AD%90%E9%9B%86%EF%BC%8C%E8%80%8C%E4%B8%8D%E8%83%BD%E5%86%92%E5%85%85%E5%AE%8C%E6%95%B4%E5%AE%89%E5%85%A8%E6%8E%A7%E5%88%B6%E5%8F%B0.md)
38. [37-安全解释权限：为什么看到账本子集的宿主不应替完整控制面下结论](37-%E5%AE%89%E5%85%A8%E8%A7%A3%E9%87%8A%E6%9D%83%E9%99%90%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%E7%9C%8B%E5%88%B0%E8%B4%A6%E6%9C%AC%E5%AD%90%E9%9B%86%E7%9A%84%E5%AE%BF%E4%B8%BB%E4%B8%8D%E5%BA%94%E6%9B%BF%E5%AE%8C%E6%95%B4%E6%8E%A7%E5%88%B6%E9%9D%A2%E4%B8%8B%E7%BB%93%E8%AE%BA.md)
39. [38-安全未知语义：为什么系统必须显式说不知道，而不是让宿主替缺失账本硬猜](38-%E5%AE%89%E5%85%A8%E6%9C%AA%E7%9F%A5%E8%AF%AD%E4%B9%89%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%E7%B3%BB%E7%BB%9F%E5%BF%85%E9%A1%BB%E6%98%BE%E5%BC%8F%E8%AF%B4%E4%B8%8D%E7%9F%A5%E9%81%93%EF%BC%8C%E8%80%8C%E4%B8%8D%E6%98%AF%E8%AE%A9%E5%AE%BF%E4%B8%BB%E6%9B%BF%E7%BC%BA%E5%A4%B1%E8%B4%A6%E6%9C%AC%E7%A1%AC%E7%8C%9C.md)
40. [39-安全声明等级：为什么控制面不该只输出 yes/no，而要把状态、理由与证据强度分层编码](39-%E5%AE%89%E5%85%A8%E5%A3%B0%E6%98%8E%E7%AD%89%E7%BA%A7%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%E6%8E%A7%E5%88%B6%E9%9D%A2%E4%B8%8D%E8%AF%A5%E5%8F%AA%E8%BE%93%E5%87%BA%20yes-no%EF%BC%8C%E8%80%8C%E8%A6%81%E6%8A%8A%E7%8A%B6%E6%80%81%E3%80%81%E7%90%86%E7%94%B1%E4%B8%8E%E8%AF%81%E6%8D%AE%E5%BC%BA%E5%BA%A6%E5%88%86%E5%B1%82%E7%BC%96%E7%A0%81.md)
41. [40-安全动作语法：为什么状态、理由与等级之后，还必须绑定正确的下一步动作](40-%E5%AE%89%E5%85%A8%E5%8A%A8%E4%BD%9C%E8%AF%AD%E6%B3%95%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%E7%8A%B6%E6%80%81%E3%80%81%E7%90%86%E7%94%B1%E4%B8%8E%E7%AD%89%E7%BA%A7%E4%B9%8B%E5%90%8E%EF%BC%8C%E8%BF%98%E5%BF%85%E9%A1%BB%E7%BB%91%E5%AE%9A%E6%AD%A3%E7%A1%AE%E7%9A%84%E4%B8%8B%E4%B8%80%E6%AD%A5%E5%8A%A8%E4%BD%9C.md)
42. [41-安全动作归属：为什么正确下一步还必须绑定正确主体、作用域与持久层](41-%E5%AE%89%E5%85%A8%E5%8A%A8%E4%BD%9C%E5%BD%92%E5%B1%9E%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%E6%AD%A3%E7%A1%AE%E4%B8%8B%E4%B8%80%E6%AD%A5%E8%BF%98%E5%BF%85%E9%A1%BB%E7%BB%91%E5%AE%9A%E6%AD%A3%E7%A1%AE%E4%B8%BB%E4%BD%93%E3%80%81%E4%BD%9C%E7%94%A8%E5%9F%9F%E4%B8%8E%E6%8C%81%E4%B9%85%E5%B1%82.md)
43. [42-安全动作完成权：为什么动作执行不等于动作完成，必须由authoritative回读签字](42-%E5%AE%89%E5%85%A8%E5%8A%A8%E4%BD%9C%E5%AE%8C%E6%88%90%E6%9D%83%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%E5%8A%A8%E4%BD%9C%E6%89%A7%E8%A1%8C%E4%B8%8D%E7%AD%89%E4%BA%8E%E5%8A%A8%E4%BD%9C%E5%AE%8C%E6%88%90%EF%BC%8C%E5%BF%85%E9%A1%BB%E7%94%B1authoritative%E5%9B%9E%E8%AF%BB%E7%AD%BE%E5%AD%97.md)
44. [43-安全完成投影：为什么不同宿主只能看到完成签字链的子集，不能把局部完成冒充全链完成](43-%E5%AE%89%E5%85%A8%E5%AE%8C%E6%88%90%E6%8A%95%E5%BD%B1%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%E4%B8%8D%E5%90%8C%E5%AE%BF%E4%B8%BB%E5%8F%AA%E8%83%BD%E7%9C%8B%E5%88%B0%E5%AE%8C%E6%88%90%E7%AD%BE%E5%AD%97%E9%93%BE%E7%9A%84%E5%AD%90%E9%9B%86%EF%BC%8C%E4%B8%8D%E8%83%BD%E6%8A%8A%E5%B1%80%E9%83%A8%E5%AE%8C%E6%88%90%E5%86%92%E5%85%85%E5%85%A8%E9%93%BE%E5%AE%8C%E6%88%90.md)
45. [44-安全完成差异显化：为什么统一安全控制台必须把宿主缺失的完成链显式告诉用户，而不是复用同一状态文案](44-%E5%AE%89%E5%85%A8%E5%AE%8C%E6%88%90%E5%B7%AE%E5%BC%82%E6%98%BE%E5%8C%96%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%E7%BB%9F%E4%B8%80%E5%AE%89%E5%85%A8%E6%8E%A7%E5%88%B6%E5%8F%B0%E5%BF%85%E9%A1%BB%E6%8A%8A%E5%AE%BF%E4%B8%BB%E7%BC%BA%E5%A4%B1%E7%9A%84%E5%AE%8C%E6%88%90%E9%93%BE%E6%98%BE%E5%BC%8F%E5%91%8A%E8%AF%89%E7%94%A8%E6%88%B7%EF%BC%8C%E8%80%8C%E4%B8%8D%E6%98%AF%E5%A4%8D%E7%94%A8%E5%90%8C%E4%B8%80%E7%8A%B6%E6%80%81%E6%96%87%E6%A1%88.md)
46. [45-安全完成差异字段：统一安全控制台最少该用哪些字段显式展示宿主盲区](45-%E5%AE%89%E5%85%A8%E5%AE%8C%E6%88%90%E5%B7%AE%E5%BC%82%E5%AD%97%E6%AE%B5%EF%BC%9A%E7%BB%9F%E4%B8%80%E5%AE%89%E5%85%A8%E6%8E%A7%E5%88%B6%E5%8F%B0%E6%9C%80%E5%B0%91%E8%AF%A5%E7%94%A8%E5%93%AA%E4%BA%9B%E5%AD%97%E6%AE%B5%E6%98%BE%E5%BC%8F%E5%B1%95%E7%A4%BA%E5%AE%BF%E4%B8%BB%E7%9B%B2%E5%8C%BA.md)
47. [46-安全完成差异卡片：统一安全控制台应把宿主盲区字段挂到哪张卡、按什么优先级显示](46-%E5%AE%89%E5%85%A8%E5%AE%8C%E6%88%90%E5%B7%AE%E5%BC%82%E5%8D%A1%E7%89%87%EF%BC%9A%E7%BB%9F%E4%B8%80%E5%AE%89%E5%85%A8%E6%8E%A7%E5%88%B6%E5%8F%B0%E5%BA%94%E6%8A%8A%E5%AE%BF%E4%B8%BB%E7%9B%B2%E5%8C%BA%E5%AD%97%E6%AE%B5%E6%8C%82%E5%88%B0%E5%93%AA%E5%BC%A0%E5%8D%A1%E3%80%81%E6%8C%89%E4%BB%80%E4%B9%88%E4%BC%98%E5%85%88%E7%BA%A7%E6%98%BE%E7%A4%BA.md)
48. [47-安全完成差异升级规则：哪些宿主盲区必须抢占界面，哪些只能下钻显示](47-%E5%AE%89%E5%85%A8%E5%AE%8C%E6%88%90%E5%B7%AE%E5%BC%82%E5%8D%87%E7%BA%A7%E8%A7%84%E5%88%99%EF%BC%9A%E5%93%AA%E4%BA%9B%E5%AE%BF%E4%B8%BB%E7%9B%B2%E5%8C%BA%E5%BF%85%E9%A1%BB%E6%8A%A2%E5%8D%A0%E7%95%8C%E9%9D%A2%EF%BC%8C%E5%93%AA%E4%BA%9B%E5%8F%AA%E8%83%BD%E4%B8%8B%E9%92%BB%E6%98%BE%E7%A4%BA.md)
49. [48-安全完成差异交互路由：为什么卡片、通知、动作可用性与清除条件必须同时联动](48-%E5%AE%89%E5%85%A8%E5%AE%8C%E6%88%90%E5%B7%AE%E5%BC%82%E4%BA%A4%E4%BA%92%E8%B7%AF%E7%94%B1%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%E5%8D%A1%E7%89%87%E3%80%81%E9%80%9A%E7%9F%A5%E3%80%81%E5%8A%A8%E4%BD%9C%E5%8F%AF%E7%94%A8%E6%80%A7%E4%B8%8E%E6%B8%85%E9%99%A4%E6%9D%A1%E4%BB%B6%E5%BF%85%E9%A1%BB%E5%90%8C%E6%97%B6%E8%81%94%E5%8A%A8.md)
50. [49-安全完成差异清除纪律：为什么宿主盲区恢复时不能先删告警，必须等fresh回读撤销旧结论](49-%E5%AE%89%E5%85%A8%E5%AE%8C%E6%88%90%E5%B7%AE%E5%BC%82%E6%B8%85%E9%99%A4%E7%BA%AA%E5%BE%8B%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%E5%AE%BF%E4%B8%BB%E7%9B%B2%E5%8C%BA%E6%81%A2%E5%A4%8D%E6%97%B6%E4%B8%8D%E8%83%BD%E5%85%88%E5%88%A0%E5%91%8A%E8%AD%A6%EF%BC%8C%E5%BF%85%E9%A1%BB%E7%AD%89fresh%E5%9B%9E%E8%AF%BB%E6%92%A4%E9%94%80%E6%97%A7%E7%BB%93%E8%AE%BA.md)
51. [50-安全恢复签字层级：哪些证据只够清通知，哪些才够恢复动作、卡片与主结论](50-%E5%AE%89%E5%85%A8%E6%81%A2%E5%A4%8D%E7%AD%BE%E5%AD%97%E5%B1%82%E7%BA%A7%EF%BC%9A%E5%93%AA%E4%BA%9B%E8%AF%81%E6%8D%AE%E5%8F%AA%E5%A4%9F%E6%B8%85%E9%80%9A%E7%9F%A5%EF%BC%8C%E5%93%AA%E4%BA%9B%E6%89%8D%E5%A4%9F%E6%81%A2%E5%A4%8D%E5%8A%A8%E4%BD%9C%E3%80%81%E5%8D%A1%E7%89%87%E4%B8%8E%E4%B8%BB%E7%BB%93%E8%AE%BA.md)
52. [51-安全恢复中间态：为什么系统必须显式区分write-only、mirror-only、restored-but-not-fresh，而不是统一说已恢复](51-%E5%AE%89%E5%85%A8%E6%81%A2%E5%A4%8D%E4%B8%AD%E9%97%B4%E6%80%81%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%E7%B3%BB%E7%BB%9F%E5%BF%85%E9%A1%BB%E6%98%BE%E5%BC%8F%E5%8C%BA%E5%88%86write-only%E3%80%81mirror-only%E3%80%81restored-but-not-fresh%EF%BC%8C%E8%80%8C%E4%B8%8D%E6%98%AF%E7%BB%9F%E4%B8%80%E8%AF%B4%E5%B7%B2%E6%81%A2%E5%A4%8D.md)
53. [52-安全恢复文案禁令：为什么系统必须禁止过满绿色词，并为半恢复状态提供受约束语言](52-%E5%AE%89%E5%85%A8%E6%81%A2%E5%A4%8D%E6%96%87%E6%A1%88%E7%A6%81%E4%BB%A4%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%E7%B3%BB%E7%BB%9F%E5%BF%85%E9%A1%BB%E7%A6%81%E6%AD%A2%E8%BF%87%E6%BB%A1%E7%BB%BF%E8%89%B2%E8%AF%8D%EF%BC%8C%E5%B9%B6%E4%B8%BA%E5%8D%8A%E6%81%A2%E5%A4%8D%E7%8A%B6%E6%80%81%E6%8F%90%E4%BE%9B%E5%8F%97%E7%BA%A6%E6%9D%9F%E8%AF%AD%E8%A8%80.md)
54. [53-安全恢复跳转纪律：为什么半恢复状态必须绑定唯一默认修复路径，而不能让用户在多个命令之间盲选](53-%E5%AE%89%E5%85%A8%E6%81%A2%E5%A4%8D%E8%B7%B3%E8%BD%AC%E7%BA%AA%E5%BE%8B%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%E5%8D%8A%E6%81%A2%E5%A4%8D%E7%8A%B6%E6%80%81%E5%BF%85%E9%A1%BB%E7%BB%91%E5%AE%9A%E5%94%AF%E4%B8%80%E9%BB%98%E8%AE%A4%E4%BF%AE%E5%A4%8D%E8%B7%AF%E5%BE%84%EF%BC%8C%E8%80%8C%E4%B8%8D%E8%83%BD%E8%AE%A9%E7%94%A8%E6%88%B7%E5%9C%A8%E5%A4%9A%E4%B8%AA%E5%91%BD%E4%BB%A4%E4%B9%8B%E9%97%B4%E7%9B%B2%E9%80%89.md)
55. [54-安全恢复验证闭环：为什么用户执行修复命令不等于状态已恢复，必须由对应回读与signer关环](54-%E5%AE%89%E5%85%A8%E6%81%A2%E5%A4%8D%E9%AA%8C%E8%AF%81%E9%97%AD%E7%8E%AF%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%E7%94%A8%E6%88%B7%E6%89%A7%E8%A1%8C%E4%BF%AE%E5%A4%8D%E5%91%BD%E4%BB%A4%E4%B8%8D%E7%AD%89%E4%BA%8E%E7%8A%B6%E6%80%81%E5%B7%B2%E6%81%A2%E5%A4%8D%EF%BC%8C%E5%BF%85%E9%A1%BB%E7%94%B1%E5%AF%B9%E5%BA%94%E5%9B%9E%E8%AF%BB%E4%B8%8Esigner%E5%85%B3%E7%8E%AF.md)
56. [55-安全恢复自动验证门槛：哪些闭环可以自动撤警，哪些必须停留人工确认](55-%E5%AE%89%E5%85%A8%E6%81%A2%E5%A4%8D%E8%87%AA%E5%8A%A8%E9%AA%8C%E8%AF%81%E9%97%A8%E6%A7%9B%EF%BC%9A%E5%93%AA%E4%BA%9B%E9%97%AD%E7%8E%AF%E5%8F%AF%E4%BB%A5%E8%87%AA%E5%8A%A8%E6%92%A4%E8%AD%A6%EF%BC%8C%E5%93%AA%E4%BA%9B%E5%BF%85%E9%A1%BB%E5%81%9C%E7%95%99%E4%BA%BA%E5%B7%A5%E7%A1%AE%E8%AE%A4.md)
57. [56-安全恢复留痕纪律：为什么auto-close失败、transient failure与人工确认挂起都必须保留可重试痕迹](56-%E5%AE%89%E5%85%A8%E6%81%A2%E5%A4%8D%E7%95%99%E7%97%95%E7%BA%AA%E5%BE%8B%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88auto-close%E5%A4%B1%E8%B4%A5%E3%80%81transient%20failure%E4%B8%8E%E4%BA%BA%E5%B7%A5%E7%A1%AE%E8%AE%A4%E6%8C%82%E8%B5%B7%E9%83%BD%E5%BF%85%E9%A1%BB%E4%BF%9D%E7%95%99%E5%8F%AF%E9%87%8D%E8%AF%95%E7%97%95%E8%BF%B9.md)
58. [57-安全恢复清理权限边界：为什么不是任何层都能删除恢复痕迹，必须由对应闭环所有者清理](57-%E5%AE%89%E5%85%A8%E6%81%A2%E5%A4%8D%E6%B8%85%E7%90%86%E6%9D%83%E9%99%90%E8%BE%B9%E7%95%8C%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%E4%B8%8D%E6%98%AF%E4%BB%BB%E4%BD%95%E5%B1%82%E9%83%BD%E8%83%BD%E5%88%A0%E9%99%A4%E6%81%A2%E5%A4%8D%E7%97%95%E8%BF%B9%EF%BC%8C%E5%BF%85%E9%A1%BB%E7%94%B1%E5%AF%B9%E5%BA%94%E9%97%AD%E7%8E%AF%E6%89%80%E6%9C%89%E8%80%85%E6%B8%85%E7%90%86.md)
59. [58-安全恢复清理门槛：为什么即便清理者正确，也必须等到对应闭环证据足够强才允许删除痕迹](58-%E5%AE%89%E5%85%A8%E6%81%A2%E5%A4%8D%E6%B8%85%E7%90%86%E9%97%A8%E6%A7%9B%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%E5%8D%B3%E4%BE%BF%E6%B8%85%E7%90%86%E8%80%85%E6%AD%A3%E7%A1%AE%EF%BC%8C%E4%B9%9F%E5%BF%85%E9%A1%BB%E7%AD%89%E5%88%B0%E5%AF%B9%E5%BA%94%E9%97%AD%E7%8E%AF%E8%AF%81%E6%8D%AE%E8%B6%B3%E5%A4%9F%E5%BC%BA%E6%89%8D%E5%85%81%E8%AE%B8%E5%88%A0%E9%99%A4%E7%97%95%E8%BF%B9.md)
60. [59-安全恢复隐藏权与删除权：为什么提示消失、卡片转绿与摘要收缩都不等于正式trace已被安全清除](59-%E5%AE%89%E5%85%A8%E6%81%A2%E5%A4%8D%E9%9A%90%E8%97%8F%E6%9D%83%E4%B8%8E%E5%88%A0%E9%99%A4%E6%9D%83%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%E6%8F%90%E7%A4%BA%E6%B6%88%E5%A4%B1%E3%80%81%E5%8D%A1%E7%89%87%E8%BD%AC%E7%BB%BF%E4%B8%8E%E6%91%98%E8%A6%81%E6%94%B6%E7%BC%A9%E9%83%BD%E4%B8%8D%E7%AD%89%E4%BA%8E%E6%AD%A3%E5%BC%8Ftrace%E5%B7%B2%E8%A2%AB%E5%AE%89%E5%85%A8%E6%B8%85%E9%99%A4.md)
61. [60-安全恢复显式语义：为什么hidden、suppressed、cleared与resolved必须严格区分，不能被同一句“没事了”压平](60-%E5%AE%89%E5%85%A8%E6%81%A2%E5%A4%8D%E6%98%BE%E5%BC%8F%E8%AF%AD%E4%B9%89%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88hidden%E3%80%81suppressed%E3%80%81cleared%E4%B8%8Eresolved%E5%BF%85%E9%A1%BB%E4%B8%A5%E6%A0%BC%E5%8C%BA%E5%88%86%EF%BC%8C%E4%B8%8D%E8%83%BD%E8%A2%AB%E5%90%8C%E4%B8%80%E5%8F%A5%E2%80%9C%E6%B2%A1%E4%BA%8B%E4%BA%86%E2%80%9D%E5%8E%8B%E5%B9%B3.md)
62. [61-安全恢复词法主权：为什么通知、摘要、footer与账本不能各自发明恢复语言，必须服从同一套命名仲裁](61-%E5%AE%89%E5%85%A8%E6%81%A2%E5%A4%8D%E8%AF%8D%E6%B3%95%E4%B8%BB%E6%9D%83%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%E9%80%9A%E7%9F%A5%E3%80%81%E6%91%98%E8%A6%81%E3%80%81footer%E4%B8%8E%E8%B4%A6%E6%9C%AC%E4%B8%8D%E8%83%BD%E5%90%84%E8%87%AA%E5%8F%91%E6%98%8E%E6%81%A2%E5%A4%8D%E8%AF%AD%E8%A8%80%EF%BC%8C%E5%BF%85%E9%A1%BB%E6%9C%8D%E4%BB%8E%E5%90%8C%E4%B8%80%E5%A5%97%E5%91%BD%E5%90%8D%E4%BB%B2%E8%A3%81.md)
63. [62-安全恢复词法仲裁：当通知、卡片、摘要与footer同时说话时，谁有资格代表当前真相](62-%E5%AE%89%E5%85%A8%E6%81%A2%E5%A4%8D%E8%AF%8D%E6%B3%95%E4%BB%B2%E8%A3%81%EF%BC%9A%E5%BD%93%E9%80%9A%E7%9F%A5%E3%80%81%E5%8D%A1%E7%89%87%E3%80%81%E6%91%98%E8%A6%81%E4%B8%8Efooter%E5%90%8C%E6%97%B6%E8%AF%B4%E8%AF%9D%E6%97%B6%EF%BC%8C%E8%B0%81%E6%9C%89%E8%B5%84%E6%A0%BC%E4%BB%A3%E8%A1%A8%E5%BD%93%E5%89%8D%E7%9C%9F%E7%9B%B8.md)
64. [63-安全恢复词法失效：为什么高风险新证据出现时，旧绿色词必须被显式invalidated，不能允许多面并存](63-%E5%AE%89%E5%85%A8%E6%81%A2%E5%A4%8D%E8%AF%8D%E6%B3%95%E5%A4%B1%E6%95%88%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%E9%AB%98%E9%A3%8E%E9%99%A9%E6%96%B0%E8%AF%81%E6%8D%AE%E5%87%BA%E7%8E%B0%E6%97%B6%EF%BC%8C%E6%97%A7%E7%BB%BF%E8%89%B2%E8%AF%8D%E5%BF%85%E9%A1%BB%E8%A2%AB%E6%98%BE%E5%BC%8Finvalidated%EF%BC%8C%E4%B8%8D%E8%83%BD%E5%85%81%E8%AE%B8%E5%A4%9A%E9%9D%A2%E5%B9%B6%E5%AD%98.md)
65. [64-安全恢复绿色词租约：为什么active、connected、ready都只能被视作可撤销租约，而不是稳定承诺](64-%E5%AE%89%E5%85%A8%E6%81%A2%E5%A4%8D%E7%BB%BF%E8%89%B2%E8%AF%8D%E7%A7%9F%E7%BA%A6%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88active%E3%80%81connected%E3%80%81ready%E9%83%BD%E5%8F%AA%E8%83%BD%E8%A2%AB%E8%A7%86%E4%BD%9C%E5%8F%AF%E6%92%A4%E9%94%80%E7%A7%9F%E7%BA%A6%EF%BC%8C%E8%80%8C%E4%B8%8D%E6%98%AF%E7%A8%B3%E5%AE%9A%E6%89%BF%E8%AF%BA.md)
66. [65-安全恢复续租信号：为什么绿色词必须靠heartbeat、poll、refresh与recheck持续续租，而不是一次观察永久有效](65-%E5%AE%89%E5%85%A8%E6%81%A2%E5%A4%8D%E7%BB%AD%E7%A7%9F%E4%BF%A1%E5%8F%B7%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%E7%BB%BF%E8%89%B2%E8%AF%8D%E5%BF%85%E9%A1%BB%E9%9D%A0heartbeat%E3%80%81poll%E3%80%81refresh%E4%B8%8Erecheck%E6%8C%81%E7%BB%AD%E7%A7%AD%E7%A7%9F%EF%BC%8C%E8%80%8C%E4%B8%8D%E6%98%AF%E4%B8%80%E6%AC%A1%E8%A7%82%E5%AF%9F%E6%B0%B8%E4%B9%85%E6%9C%89%E6%95%88.md)
67. [66-安全恢复续租失败分级：为什么不同lease failure必须分别降到hidden、pending、reconnecting、failed与stale，而不能一律算挂了](66-%E5%AE%89%E5%85%A8%E6%81%A2%E5%A4%8D%E7%BB%AD%E7%A7%9F%E5%A4%B1%E8%B4%A5%E5%88%86%E7%BA%A7%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%E4%B8%8D%E5%90%8Clease%20failure%E5%BF%85%E9%A1%BB%E5%88%86%E5%88%AB%E9%99%8D%E5%88%B0hidden%E3%80%81pending%E3%80%81reconnecting%E3%80%81failed%E4%B8%8Estale%EF%BC%8C%E8%80%8C%E4%B8%8D%E8%83%BD%E4%B8%80%E5%BE%8B%E7%AE%97%E6%8C%82%E4%BA%86.md)
68. [67-安全恢复失败路径选择器：为什么failure ladder必须直接决定下一步repair path，而不是让用户自己猜](67-%E5%AE%89%E5%85%A8%E6%81%A2%E5%A4%8D%E5%A4%B1%E8%B4%A5%E8%B7%AF%E5%BE%84%E9%80%89%E6%8B%A9%E5%99%A8%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88failure%20ladder%E5%BF%85%E9%A1%BB%E7%9B%B4%E6%8E%A5%E5%86%B3%E5%AE%9A%E4%B8%8B%E4%B8%80%E6%AD%A5repair%20path%EF%BC%8C%E8%80%8C%E4%B8%8D%E6%98%AF%E8%AE%A9%E7%94%A8%E6%88%B7%E8%87%AA%E5%B7%B1%E7%8C%9C.md)
69. [68-安全恢复错误路径禁令：为什么控制面必须主动禁止邻近wrong path，而不只是提示dominant repair path](68-%E5%AE%89%E5%85%A8%E6%81%A2%E5%A4%8D%E9%94%99%E8%AF%AF%E8%B7%AF%E5%BE%84%E7%A6%81%E4%BB%A4%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%E6%8E%A7%E5%88%B6%E9%9D%A2%E5%BF%85%E9%A1%BB%E4%B8%BB%E5%8A%A8%E7%A6%81%E6%AD%A2%E9%82%BB%E8%BF%91wrong%20path%EF%BC%8C%E8%80%8C%E4%B8%8D%E5%8F%AA%E6%98%AF%E6%8F%90%E7%A4%BAdominant%20repair%20path.md)
70. [69-安全恢复合法性：为什么只要剩余可恢复性仍在，系统就必须禁止destructive cleanup](69-%E5%AE%89%E5%85%A8%E6%81%A2%E5%A4%8D%E5%90%88%E6%B3%95%E6%80%A7%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%E5%8F%AA%E8%A6%81%E5%89%A9%E4%BD%99%E5%8F%AF%E6%81%A2%E5%A4%8D%E6%80%A7%E4%BB%8D%E5%9C%A8%EF%BC%8C%E7%B3%BB%E7%BB%9F%E5%B0%B1%E5%BF%85%E9%A1%BB%E7%A6%81%E6%AD%A2destructive%20cleanup.md)
71. [70-安全多重窄门：为什么Claude Code不是先给全量能力再补权限，而是逐层借出能力](70-%E5%AE%89%E5%85%A8%E5%A4%9A%E9%87%8D%E7%AA%84%E9%97%A8%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88Claude%20Code%E4%B8%8D%E6%98%AF%E5%85%88%E7%BB%99%E5%85%A8%E9%87%8F%E8%83%BD%E5%8A%9B%E5%86%8D%E8%A1%A5%E6%9D%83%E9%99%90%EF%BC%8C%E8%80%8C%E6%98%AF%E9%80%90%E5%B1%82%E5%80%9F%E5%87%BA%E8%83%BD%E5%8A%9B.md)
72. [71-安全能力发布主权：为什么不是任何接入层都能把能力显示成可用入口](71-%E5%AE%89%E5%85%A8%E8%83%BD%E5%8A%9B%E5%8F%91%E5%B8%83%E4%B8%BB%E6%9D%83%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%E4%B8%8D%E6%98%AF%E4%BB%BB%E4%BD%95%E6%8E%A5%E5%85%A5%E5%B1%82%E9%83%BD%E8%83%BD%E6%8A%8A%E8%83%BD%E5%8A%9B%E6%98%BE%E7%A4%BA%E6%88%90%E5%8F%AF%E7%94%A8%E5%85%A5%E5%8F%A3.md)
73. [72-安全能力撤回主权：为什么不是任何层都能撤回已发布入口，必须由authoritative publisher改口](72-%E5%AE%89%E5%85%A8%E8%83%BD%E5%8A%9B%E6%92%A4%E5%9B%9E%E4%B8%BB%E6%9D%83%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%E4%B8%8D%E6%98%AF%E4%BB%BB%E4%BD%95%E5%B1%82%E9%83%BD%E8%83%BD%E6%92%A4%E5%9B%9E%E5%B7%B2%E5%8F%91%E5%B8%83%E5%85%A5%E5%8F%A3%EF%BC%8C%E5%BF%85%E9%A1%BB%E7%94%B1authoritative%20publisher%E6%94%B9%E5%8F%A3.md)
74. [73-安全能力恢复主权：为什么不是任何层都能把已撤回入口重新恢复为可见可用](73-%E5%AE%89%E5%85%A8%E8%83%BD%E5%8A%9B%E6%81%A2%E5%A4%8D%E4%B8%BB%E6%9D%83%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%E4%B8%8D%E6%98%AF%E4%BB%BB%E4%BD%95%E5%B1%82%E9%83%BD%E8%83%BD%E6%8A%8A%E5%B7%B2%E6%92%A4%E5%9B%9E%E5%85%A5%E5%8F%A3%E9%87%8D%E6%96%B0%E6%81%A2%E5%A4%8D%E4%B8%BA%E5%8F%AF%E8%A7%81%E5%8F%AF%E7%94%A8.md)
75. [74-安全能力声明主权：为什么不是任何层都配把能力状态说成enabled、pending、connected、active](74-%E5%AE%89%E5%85%A8%E8%83%BD%E5%8A%9B%E5%A3%B0%E6%98%8E%E4%B8%BB%E6%9D%83%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%E4%B8%8D%E6%98%AF%E4%BB%BB%E4%BD%95%E5%B1%82%E9%83%BD%E9%85%8D%E6%8A%8A%E8%83%BD%E5%8A%9B%E7%8A%B6%E6%80%81%E8%AF%B4%E6%88%90enabled%E3%80%81pending%E3%80%81connected%E3%80%81active.md)
76. [75-安全能力声明仲裁：当status、notification、footer与hook同时说话时，谁有资格代表当前能力真相](75-%E5%AE%89%E5%85%A8%E8%83%BD%E5%8A%9B%E5%A3%B0%E6%98%8E%E4%BB%B2%E8%A3%81%EF%BC%9A%E5%BD%93status%E3%80%81notification%E3%80%81footer%E4%B8%8Ehook%E5%90%8C%E6%97%B6%E8%AF%B4%E8%AF%9D%E6%97%B6%EF%BC%8C%E8%B0%81%E6%9C%89%E8%B5%84%E6%A0%BC%E4%BB%A3%E8%A1%A8%E5%BD%93%E5%89%8D%E8%83%BD%E5%8A%9B%E7%9C%9F%E7%9B%B8.md)
77. [76-安全能力显式让位：为什么更高风险、更具体的新状态必须主动驱逐旧的弱状态，而不能等它自然过期](76-%E5%AE%89%E5%85%A8%E8%83%BD%E5%8A%9B%E6%98%BE%E5%BC%8F%E8%AE%A9%E4%BD%8D%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%E6%9B%B4%E9%AB%98%E9%A3%8E%E9%99%A9%E3%80%81%E6%9B%B4%E5%85%B7%E4%BD%93%E7%9A%84%E6%96%B0%E7%8A%B6%E6%80%81%E5%BF%85%E9%A1%BB%E4%B8%BB%E5%8A%A8%E9%A9%B1%E9%80%90%E6%97%A7%E7%9A%84%E5%BC%B1%E7%8A%B6%E6%80%81%EF%BC%8C%E8%80%8C%E4%B8%8D%E8%83%BD%E7%AD%89%E5%AE%83%E8%87%AA%E7%84%B6%E8%BF%87%E6%9C%9F.md)
78. [77-安全状态替换语法：为什么新增、折叠、失效、移除与共存必须是不同的状态动作，而不能统一成再发一条通知](77-%E5%AE%89%E5%85%A8%E7%8A%B6%E6%80%81%E6%9B%BF%E6%8D%A2%E8%AF%AD%E6%B3%95%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%E6%96%B0%E5%A2%9E%E3%80%81%E6%8A%98%E5%8F%A0%E3%80%81%E5%A4%B1%E6%95%88%E3%80%81%E7%A7%BB%E9%99%A4%E4%B8%8E%E5%85%B1%E5%AD%98%E5%BF%85%E9%A1%BB%E6%98%AF%E4%B8%8D%E5%90%8C%E7%9A%84%E7%8A%B6%E6%80%81%E5%8A%A8%E4%BD%9C%EF%BC%8C%E8%80%8C%E4%B8%8D%E8%83%BD%E7%BB%9F%E4%B8%80%E6%88%90%E5%86%8D%E5%8F%91%E4%B8%80%E6%9D%A1%E9%80%9A%E7%9F%A5.md)
79. [78-安全状态编辑主权：为什么状态替换语法之后，还必须继续回答谁有资格编辑谁的状态](78-%E5%AE%89%E5%85%A8%E7%8A%B6%E6%80%81%E7%BC%96%E8%BE%91%E4%B8%BB%E6%9D%83%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%E7%8A%B6%E6%80%81%E6%9B%BF%E6%8D%A2%E8%AF%AD%E6%B3%95%E4%B9%8B%E5%90%8E%EF%BC%8C%E8%BF%98%E5%BF%85%E9%A1%BB%E7%BB%A7%E7%BB%AD%E5%9B%9E%E7%AD%94%E8%B0%81%E6%9C%89%E8%B5%84%E6%A0%BC%E7%BC%96%E8%BE%91%E8%B0%81%E7%9A%84%E7%8A%B6%E6%80%81.md)
80. [79-安全状态家族作用域：为什么全局key字符串不是长期安全边界，family scope才是状态编辑主权的真正载体](79-%E5%AE%89%E5%85%A8%E7%8A%B6%E6%80%81%E5%AE%B6%E6%97%8F%E4%BD%9C%E7%94%A8%E5%9F%9F%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%E5%85%A8%E5%B1%80key%E5%AD%97%E7%AC%A6%E4%B8%B2%E4%B8%8D%E6%98%AF%E9%95%BF%E6%9C%9F%E5%AE%89%E5%85%A8%E8%BE%B9%E7%95%8C%EF%BC%8Cfamily%20scope%E6%89%8D%E6%98%AF%E7%8A%B6%E6%80%81%E7%BC%96%E8%BE%91%E4%B8%BB%E6%9D%83%E7%9A%84%E7%9C%9F%E6%AD%A3%E8%BD%BD%E4%BD%93.md)
81. [80-安全状态句柄化：为什么下一代控制面不该继续用裸key编辑状态，而应把family scope升级为opaque handle](80-%E5%AE%89%E5%85%A8%E7%8A%B6%E6%80%81%E5%8F%A5%E6%9F%84%E5%8C%96%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%E4%B8%8B%E4%B8%80%E4%BB%A3%E6%8E%A7%E5%88%B6%E9%9D%A2%E4%B8%8D%E8%AF%A5%E7%BB%A7%E7%BB%AD%E7%94%A8%E8%A3%B8key%E7%BC%96%E8%BE%91%E7%8A%B6%E6%80%81%EF%BC%8C%E8%80%8C%E5%BA%94%E6%8A%8Afamily%20scope%E5%8D%87%E7%BA%A7%E4%B8%BAopaque%20handle.md)
82. [81-安全能力闭包绑定：为什么句柄真正承载的不是方法集合，而是创建时上下文](81-%E5%AE%89%E5%85%A8%E8%83%BD%E5%8A%9B%E9%97%AD%E5%8C%85%E7%BB%91%E5%AE%9A%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%E5%8F%A5%E6%9F%84%E7%9C%9F%E6%AD%A3%E6%89%BF%E8%BD%BD%E7%9A%84%E4%B8%8D%E6%98%AF%E6%96%B9%E6%B3%95%E9%9B%86%E5%90%88%EF%BC%8C%E8%80%8C%E6%98%AF%E5%88%9B%E5%BB%BA%E6%97%B6%E4%B8%8A%E4%B8%8B%E6%96%87.md)
83. [82-安全上下文重推导禁令：为什么session、token、transport与scope不能像标题那样交给调用方二次重算](82-%E5%AE%89%E5%85%A8%E4%B8%8A%E4%B8%8B%E6%96%87%E9%87%8D%E6%8E%A8%E5%AF%BC%E7%A6%81%E4%BB%A4%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88session%E3%80%81token%E3%80%81transport%E4%B8%8Escope%E4%B8%8D%E8%83%BD%E5%83%8F%E6%A0%87%E9%A2%98%E9%82%A3%E6%A0%B7%E4%BA%A4%E7%BB%99%E8%B0%83%E7%94%A8%E6%96%B9%E4%BA%8C%E6%AC%A1%E9%87%8D%E7%AE%97.md)
84. [83-安全授权连续性：为什么session、token、transport与scope真正需要被保护的不是值，而是其背后的授权连续性](83-%E5%AE%89%E5%85%A8%E6%8E%88%E6%9D%83%E8%BF%9E%E7%BB%AD%E6%80%A7%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88session%E3%80%81token%E3%80%81transport%E4%B8%8Escope%E7%9C%9F%E6%AD%A3%E9%9C%80%E8%A6%81%E8%A2%AB%E4%BF%9D%E6%8A%A4%E7%9A%84%E4%B8%8D%E6%98%AF%E5%80%BC%EF%BC%8C%E8%80%8C%E6%98%AF%E5%85%B6%E8%83%8C%E5%90%8E%E7%9A%84%E6%8E%88%E6%9D%83%E8%BF%9E%E7%BB%AD%E6%80%A7.md)
85. [84-安全失效边界复活禁令：为什么最危险的不是脏状态，而是已归档旧session被重新认证为当前边界](84-%E5%AE%89%E5%85%A8%E5%A4%B1%E6%95%88%E8%BE%B9%E7%95%8C%E5%A4%8D%E6%B4%BB%E7%A6%81%E4%BB%A4%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%E6%9C%80%E5%8D%B1%E9%99%A9%E7%9A%84%E4%B8%8D%E6%98%AF%E8%84%8F%E7%8A%B6%E6%80%81%EF%BC%8C%E8%80%8C%E6%98%AF%E5%B7%B2%E5%BD%92%E6%A1%A3%E6%97%A7session%E8%A2%AB%E9%87%8D%E6%96%B0%E8%AE%A4%E8%AF%81%E4%B8%BA%E5%BD%93%E5%89%8D%E8%BE%B9%E7%95%8C.md)
86. [85-安全边界换届协议：为什么连续性一旦断裂，系统必须显式archive旧边界、重绑新边界并重置所有会话级账本](85-%E5%AE%89%E5%85%A8%E8%BE%B9%E7%95%8C%E6%8D%A2%E5%B1%8A%E5%8D%8F%E8%AE%AE%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%E8%BF%9E%E7%BB%AD%E6%80%A7%E4%B8%80%E6%97%A6%E6%96%AD%E8%A3%82%EF%BC%8C%E7%B3%BB%E7%BB%9F%E5%BF%85%E9%A1%BB%E6%98%BE%E5%BC%8Farchive%E6%97%A7%E8%BE%B9%E7%95%8C%E3%80%81%E9%87%8D%E7%BB%91%E6%96%B0%E8%BE%B9%E7%95%8C%E5%B9%B6%E9%87%8D%E7%BD%AE%E6%89%80%E6%9C%89%E4%BC%9A%E8%AF%9D%E7%BA%A7%E8%B4%A6%E6%9C%AC.md)
87. [86-安全恢复承诺诚实性：为什么--continue、pointer与resume提示不是帮助文案，而是对边界可恢复性的安全承诺](86-%E5%AE%89%E5%85%A8%E6%81%A2%E5%A4%8D%E6%89%BF%E8%AF%BA%E8%AF%9A%E5%AE%9E%E6%80%A7%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88--continue%E3%80%81pointer%E4%B8%8Eresume%E6%8F%90%E7%A4%BA%E4%B8%8D%E6%98%AF%E5%B8%AE%E5%8A%A9%E6%96%87%E6%A1%88%EF%BC%8C%E8%80%8C%E6%98%AF%E5%AF%B9%E8%BE%B9%E7%95%8C%E5%8F%AF%E6%81%A2%E5%A4%8D%E6%80%A7%E7%9A%84%E5%AE%89%E5%85%A8%E6%89%BF%E8%AF%BA.md)
88. [87-安全恢复资格签发权：为什么不是任何局部signal都配说仍可恢复，而必须由掌握边界真相的控制层签字](87-%E5%AE%89%E5%85%A8%E6%81%A2%E5%A4%8D%E8%B5%84%E6%A0%BC%E7%AD%BE%E5%8F%91%E6%9D%83%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%E4%B8%8D%E6%98%AF%E4%BB%BB%E4%BD%95%E5%B1%80%E9%83%A8signal%E9%83%BD%E9%85%8D%E8%AF%B4%E4%BB%8D%E5%8F%AF%E6%81%A2%E5%A4%8D%EF%BC%8C%E8%80%8C%E5%BF%85%E9%A1%BB%E7%94%B1%E6%8E%8C%E6%8F%A1%E8%BE%B9%E7%95%8C%E7%9C%9F%E7%9B%B8%E7%9A%84%E6%8E%A7%E5%88%B6%E5%B1%82%E7%AD%BE%E5%AD%97.md)
89. [88-安全恢复资格证据门槛：为什么即使signer正确，仍可恢复也必须建立在最小truth-bundle之上](88-%E5%AE%89%E5%85%A8%E6%81%A2%E5%A4%8D%E8%B5%84%E6%A0%BC%E8%AF%81%E6%8D%AE%E9%97%A8%E6%A7%9B%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%E5%8D%B3%E4%BD%BFsigner%E6%AD%A3%E7%A1%AE%EF%BC%8C%E4%BB%8D%E5%8F%AF%E6%81%A2%E5%A4%8D%E4%B9%9F%E5%BF%85%E9%A1%BB%E5%BB%BA%E7%AB%8B%E5%9C%A8%E6%9C%80%E5%B0%8Ftruth-bundle%E4%B9%8B%E4%B8%8A.md)
90. [89-安全恢复资格降级语法：为什么no-candidate、invalid-id、dead-session、fresh-session-fallback与retryable不能压成同一句无法恢复](89-%E5%AE%89%E5%85%A8%E6%81%A2%E5%A4%8D%E8%B5%84%E6%A0%BC%E9%99%8D%E7%BA%A7%E8%AF%AD%E6%B3%95%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88no-candidate%E3%80%81invalid-id%E3%80%81dead-session%E3%80%81fresh-session-fallback%E4%B8%8Eretryable%E4%B8%8D%E8%83%BD%E5%8E%8B%E6%88%90%E5%90%8C%E4%B8%80%E5%8F%A5%E6%97%A0%E6%B3%95%E6%81%A2%E5%A4%8D.md)
91. [90-安全恢复资格清理权限：为什么pointer清理权不是普通清扫动作，而是恢复资格的撤回权](90-%E5%AE%89%E5%85%A8%E6%81%A2%E5%A4%8D%E8%B5%84%E6%A0%BC%E6%B8%85%E7%90%86%E6%9D%83%E9%99%90%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88pointer%E6%B8%85%E7%90%86%E6%9D%83%E4%B8%8D%E6%98%AF%E6%99%AE%E9%80%9A%E6%B8%85%E6%89%AB%E5%8A%A8%E4%BD%9C%EF%BC%8C%E8%80%8C%E6%98%AF%E6%81%A2%E5%A4%8D%E8%B5%84%E6%A0%BC%E7%9A%84%E6%92%A4%E5%9B%9E%E6%9D%83.md)
92. [91-安全恢复资产保全义务：为什么pointer、retry-path与resumable-shutdown在资格未撤回前必须被制度性保留](91-%E5%AE%89%E5%85%A8%E6%81%A2%E5%A4%8D%E8%B5%84%E4%BA%A7%E4%BF%9D%E5%85%A8%E4%B9%89%E5%8A%A1%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88pointer%E3%80%81retry-path%E4%B8%8Eresumable-shutdown%E5%9C%A8%E8%B5%84%E6%A0%BC%E6%9C%AA%E6%92%A4%E5%9B%9E%E5%89%8D%E5%BF%85%E9%A1%BB%E8%A2%AB%E5%88%B6%E5%BA%A6%E6%80%A7%E4%BF%9D%E7%95%99.md)
85. [84-安全失效边界复活禁令：为什么最危险的不是脏状态，而是已归档旧session被重新认证为当前边界](84-%E5%AE%89%E5%85%A8%E5%A4%B1%E6%95%88%E8%BE%B9%E7%95%8C%E5%A4%8D%E6%B4%BB%E7%A6%81%E4%BB%A4%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%E6%9C%80%E5%8D%B1%E9%99%A9%E7%9A%84%E4%B8%8D%E6%98%AF%E8%84%8F%E7%8A%B6%E6%80%81%EF%BC%8C%E8%80%8C%E6%98%AF%E5%B7%B2%E5%BD%92%E6%A1%A3%E6%97%A7session%E8%A2%AB%E9%87%8D%E6%96%B0%E8%AE%A4%E8%AF%81%E4%B8%BA%E5%BD%93%E5%89%8D%E8%BE%B9%E7%95%8C.md)

## 附录目录

- [安全专题附录索引](appendix/README.md)
- `appendix/` 只放证据索引、图表、术语表和速查卡，避免主线章节继续线性膨胀。
- 想快速查“某类风险由谁检测、第一硬拦截层在哪、classifier 能不能替代”：看 `appendix/02`
- 想把“检测链”“不变量”“边界失真”三层压回同一张速查表：看 `appendix/03`
- 想从“当前界面看到什么”反推“系统实际暴露了哪类安全事实、又还缺哪条因果”：看 `appendix/04`
- 想从“哪条证明链断了”直接回到源码入口、失效后果和用户症状：看 `appendix/05`
- 想直接看“统一安全控制台”最小应有哪些面，以及这些面当前散落在哪些源码里：看 `appendix/06`
- 想直接看统一安全控制台的字段组、字段来源、缺失派生字段和最佳展示层级：看 `appendix/07`
- 想直接看统一安全控制台应该拆成哪些卡片，以及每张卡默认回答什么问题、给什么动作：看 `appendix/08`
- 想直接看统一安全控制台应如何把“状态 -> 断链 -> 动作 -> 回读”压成最短诊断闭环：看 `appendix/09`
- 想直接看统一安全控制台应如何把页面切换、动作触发、刷新回读、验证与宿主保真压成一张交互矩阵：看 `appendix/10`
- 想直接看统一安全控制台最少必须保真哪些安全对象、这些对象从哪里来、又最容易在哪被压扁：看 `appendix/11`
- 想直接看 bridge、direct connect、remote session manager 和适配层这几类宿主分别属于什么子集、哪些地方最危险：看 `appendix/12`
- 想直接看不同宿主到底属于观察、控制还是证明层，以及每一层最少承担什么责任：看 `appendix/13`
- 想直接看 `worker_status`、`external_metadata`、本地状态和 UI 文案分别属于哪一层真相，以及最常见的误读是什么：看 `appendix/14`
- 想直接看多层真相冲突时谁优先、谁不能赢，以及最危险的误读是什么：看 `appendix/15`
- 想直接看最典型的裂脑场景由谁收口、靠什么守卫，以及哪里最容易被错误改动破坏：看 `appendix/16`
- 想直接看关键安全事实到底由谁正式写、哪些层只能镜像，以及一旦越权会坏什么：看 `appendix/17`
- 想直接看“已提交”到底分成哪五层，以及每一层最容易被误读成什么：看 `appendix/18`
- 想直接看语义账、复制账、可见账和恢复账分别服务谁、何时成立、最怕被误读成什么：看 `appendix/19`
- 想直接看不同宿主分别拿到了哪些账本子集、缺哪些账，以及最容易在哪一类解释上越界：看 `appendix/20`
- 想直接看不同宿主到底能解释什么、不能解释什么，以及最典型的越权解释长什么样：看 `appendix/21`
- 想直接看哪些场景必须明确说“不知道 / 不支持 / 当前不可判定”，以及哪些伪解释最危险：看 `appendix/22`
- 想直接看不同声明族到底有哪些等级、典型字段和最危险的压扁误读：看 `appendix/23`
- 想直接看不同声明族到底各自绑定哪种正确下一步动作，以及最危险的错误动作压缩是什么：看 `appendix/24`
- 想直接看不同动作到底该由系统、宿主、用户还是管理员来执行，以及该写到哪一层、持续多久：看 `appendix/25`
- 想直接看一条动作到底何时才算真正完成、哪个信号才配签字，以及最危险的提前完成误读是什么：看 `appendix/26`
- 想直接看不同宿主到底分别看到了哪种完成信号、缺哪本账、最多能对“已完成”说到哪一步：看 `appendix/27`
- 想直接看为什么这些宿主差异必须被界面显式展示，而不是继续藏在实现里：看 `appendix/28`
- 想直接看统一安全控制台最少该用哪些字段把这些宿主盲区做成正式对象，而不是继续靠提示词补丁：看 `appendix/29`
- 想直接看这些字段到底该挂到哪张卡、按什么优先级显示，才不会又被埋进详情区：看 `appendix/30`
- 想直接看哪些宿主盲区必须抢占界面、哪些只需中层提示、哪些可以留在下钻层：看 `appendix/31`
- 想直接看宿主盲区一旦变化时，卡片、通知、动作和清除条件应按什么顺序一起改口：看 `48`
- 想直接看这些联动规则的最短矩阵，快速核对“谁触发、哪张卡改口、通知几级、动作怎么收、何时才能清除”：看 `appendix/32`
- 想直接看为什么“恢复”比“告警”更需要纪律，以及哪些旧结论绝不能因为表面恢复就被先删掉：看 `49`
- 想直接看哪些旧结论能删、凭什么删、删之前哪些动作绝不能先恢复：看 `appendix/33`
- 想直接看不同恢复证据的强弱层级，区分哪些 signal 只配清通知、哪些才配恢复动作和主结论：看 `50`
- 想直接看 signer hierarchy 的压缩矩阵，快速判断某个恢复信号有没有越级替高层对象签字：看 `appendix/34`
- 想直接看系统恢复到一半时该如何命名，避免把 write-only、mirror-only 或 restored-but-not-fresh 压成同一句“已恢复”：看 `51`
- 想直接看这些中间态各自缺哪条链、还能做什么、不能说什么、该把用户带去哪里：看 `appendix/35`
- 想直接看为什么某些绿色词在半恢复状态下必须被禁止，以及系统应该改说什么：看 `52`
- 想直接看一张可执行的文案规则表，快速判断某个状态当前禁说什么、允许说什么、默认句式应该是什么：看 `appendix/36`
- 想直接看为什么半恢复状态还必须绑定唯一默认修复路径，避免用户在多个命令之间盲选：看 `53`
- 想直接看每种半恢复状态默认该跳去哪、哪些入口只能作为次级路径、哪些并列会制造歧义：看 `appendix/37`
- 想直接看为什么用户执行了修复命令仍不等于系统已经恢复，以及控制面该等哪类回读和 signer 来真正关环：看 `54`
- 想直接看每条修复路径对应的 verifier、最终 signer 和可清除对象，快速判断有没有“假闭环”：看 `appendix/38`
- 想直接看为什么有些闭环可以自动撤警而另一些必须停在人类确认态，以及这条门槛到底由什么决定：看 `55`
- 想直接看不同 repair path 的 ownership 完整度，以及哪些路径允许 auto-close、哪些必须转人工确认：看 `appendix/39`
- 想直接看为什么恢复没闭环时系统还必须留下可重试、可回访、可解释的痕迹，而不是把失败静默抹掉：看 `56`
- 想直接看不同失败场景分别该保留什么痕迹、再从哪里重新进入，以及什么条件下才允许清除这些痕迹：看 `appendix/40`
- 想直接看为什么这些痕迹不是谁都能删，以及哪些痕迹只能由对应闭环所有者或更高层 signer 清理：看 `57`
- 想直接看不同 trace 对象到底由谁拥有、谁能清、谁绝不能清：看 `appendix/41`
- 想直接看为什么即便清理者正确也不能立刻删痕迹，以及控制面该等哪些 full rebuild、terminal 或 manual-confirmed 证据：看 `58`
- 想直接看不同 trace 到底需要什么 minimum clearer、哪类证据才过门槛、何时允许 auto-clear：看 `appendix/42`
- 想直接看为什么提示消失、卡片转绿与摘要收缩都不等于正式 trace 已被清除：看 `59`
- 想直接看 surface hider、projection owner、trace writer 与 explanation closer 四层到底分别能做什么、不能做什么：看 `appendix/43`
- 想直接看为什么 hidden、suppressed、cleared 与 resolved 必须严格区分，不能继续共用一句“没事了”：看 `60`
- 想直接看 hidden、suppressed、cleared、resolved 四个词到底各自代表什么、允许说什么、禁止说什么：看 `appendix/44`
- 想直接看为什么通知、摘要、footer 与账本不能各自发明恢复语言，以及谁才有资格给恢复状态命名：看 `61`
- 想直接看不同 surface 最多能说到哪一步、哪些更强词绝对不能说：看 `appendix/45`
- 想直接看当通知、卡片、摘要和 footer 同时说话时，谁有资格代表当前真相：看 `62`
- 想直接看不同 surface 在词法冲突里谁该赢、谁必须让位：看 `appendix/46`
- 想直接看为什么高风险新证据出现时，旧的弱绿色词必须被显式 invalidated 而不是继续并存：看 `63`
- 想直接看哪类更强新证据会使哪些旧词失效，以及这些失效会影响哪些 surface：看 `appendix/47`
- 想直接看为什么 `active`、`connected`、`ready` 这类绿色词都只能被视作可撤销租约，而不是稳定承诺：看 `64`
- 想直接看每类绿色词的续租条件、撤租触发器和租期长短：看 `appendix/48`
- 想直接看为什么这些绿色词还必须靠 heartbeat、poll、refresh 与 recheck 持续续租，而不是一次观察永久有效：看 `65`
- 想直接看不同 lease failure 到底还剩下多少恢复能力、下一步该走哪条修复路径：看 `appendix/50`
- 想直接看为什么 lease failure 不能一律压成“挂了”，而必须分别降到 hidden、pending、reconnecting、failed、stale 与 auth_failed：看 `66`
- 想直接看不同绿色词分别靠什么续租、多久续租一次、续租失败后会掉到哪条分支：看 `appendix/49`
- 想直接看为什么这些 failure 层级还必须直接决定下一步 repair path，而不是让用户自己猜：看 `67`
- 想直接看不同 failure tier 的 dominant repair path 是什么，以及哪些 wrong path 绝对不能走：看 `appendix/51`
- 想直接看为什么只给 dominant repair path 仍然不够，以及系统为什么还必须主动禁止邻近 wrong path：看 `68`
- 想直接看不同 failure tier 当前绝不能走哪条邻近 wrong path、为什么被禁、什么时候才会解除禁令：看 `appendix/52`
- 想直接看为什么 cleanup 不是默认合法动作，以及系统何时必须保留 pointer、retry 与 needsRefresh 这类恢复资产：看 `69`
- 想直接看不同 recoverability asset 当前禁止什么 cleanup、为什么还受保护、以及何时才会重新放行：看 `appendix/53`
- 想直接看为什么这套系统不是靠最后一个 permission dialog 才安全，而是靠环境门、信任门、内容门、决议门与发布门逐层缩减能力面：看 `70`
- 想直接看不同 gate 各自保护哪段能力、放行条件是什么、最危险的 shortcut 是什么：看 `appendix/54`
- 想直接看为什么“入口可见”本身也是一种安全承诺，以及为什么不是任何 adapter / 宿主都能把能力发布成前台入口：看 `71`
- 想直接看不同 surface 到底由谁发布能力入口、最危险的 overclaim 是什么，以及哪些层只能转述不能自报：看 `appendix/55`
- 想直接看为什么不是任何镜像层都能把入口撤回，以及为什么撤回一项能力同样是一种主权改口：看 `72`
- 想直接看不同 surface 到底由谁撤回入口、触发条件是什么，以及继续保留旧入口会形成哪种 stale promise：看 `appendix/56`
- 想直接看为什么不是任何局部回暖信号都能把入口恢复回来，以及为什么能力恢复本质上是重新授权：看 `73`
- 想直接看不同 surface 到底由谁重新授予入口、正式恢复链是什么，以及哪些“恢复”其实只是提前改口：看 `appendix/57`
- 想直接看为什么不是任何表面都配把能力状态说成 `connected`、`active`、`installed` 或 `failed`，以及谁只能提醒、谁才配完整命名：看 `74`
- 想直接看不同 surface 当前最多配说到哪一个能力词、哪些更满词绝对不能说，以及用户下一步该去哪确认：看 `appendix/58`
- 想直接看为什么多个 surface 同时发声时，不能把“谁更显眼”误当成“谁更权威”，以及 notification、`/status`、footer 与 hook 到底谁该赢什么：看 `75`
- 想直接看不同 surface 到底拥有什么仲裁权、冲突时谁必须让位、以及哪条 handoff 是硬规则：看 `appendix/59`
- 想直接看为什么“仲裁已决定谁该赢”仍然不够，以及为什么系统还必须主动撤掉旧的弱状态，避免旧真相赖在屏幕上：看 `76`
- 想直接看不同 incoming state 到底应该驱逐哪条旧状态、驱逐靠什么机制、以及不驱逐会形成哪种 stale risk：看 `appendix/60`
- 想直接看为什么“驱逐旧状态”仍然不够，以及为什么 Claude Code 还必须区分折叠、失效、移除与共存，而不是把所有变化都压成再发一条提示：看 `77`
- 想直接看不同 change pattern 到底该用哪一种 operator、每种 operator 的安全效果是什么、以及最危险的 shortcut 是什么：看 `appendix/61`
- 想直接看为什么 replacement grammar 仍然不够，以及为什么 fold、invalidate、remove 这些动词之后还必须继续追问“谁配说这句改口”：看 `78`
- 想直接看不同 status family 到底允许谁编辑、允许用什么 operator、以及最危险的 outsider 是谁：看 `appendix/62`
- 想直接看为什么回答了“谁有资格编辑”仍然不够，以及为什么真正的长期边界不该只是全局 key 名，而应是被正式承认的 family scope：看 `79`
- 想直接看不同 key pattern 当前隐含着什么 family、它现在靠什么维持作用域，以及最大的 scope risk 在哪：看 `appendix/63`
- 想直接看为什么即使 family scope 已经被看见，也仍然不该继续停留在命名约定，而应升级成真正的句柄能力对象：看 `80`
- 想直接看 notifications 当前 carrier 缺了哪些 scope、推荐的 handle 字段是什么，以及迁移后先解决哪类风险：看 `appendix/64`
- 想直接看为什么即使已经做成 handle，也仍然不能把它理解成“有方法的对象”，而必须继续追问它绑定了哪些创建时上下文：看 `81`
- 想直接看不同 handle 到底捕获了什么上下文、禁止调用方重建什么对象，以及闭包绑定带来的直接安全收益：看 `appendix/65`
- 想直接看为什么“句柄里有上下文”仍然不够，以及为什么系统必须继续明确禁止对 authority-bearing context 二次重算，而不是把它们当普通派生值：看 `82`
- 想直接看不同 surface 上哪些上下文可重推导、哪些绝不能重推导，以及误重算后的 failure mode 是什么：看 `appendix/66`
- 想直接看为什么这些 authority-bearing context 真正需要被保护的不是值本身，而是它们共同维持的 authorization continuity：看 `83`
- 想直接看不同 context 的 continuity owner、allowed substitution、explicit break signal 与 boundary failure：看 `appendix/67`
- 想直接看为什么比 stale state 更危险的是已失效旧边界被重新认证为 current，以及 bridge 里哪些 race、pointer 与 resume path 正在专门防这种复活：看 `84`
- 想直接看不同 stale object 到底会沿哪条 revival path 复活、当前 guard 是什么、漏掉后会造成哪种边界后果：看 `appendix/68`
- 想直接看为什么即使禁止了旧边界复活仍然不够，以及 continuity 正式结束后系统必须如何完成合法换届：看 `85`
- 想直接看不同 break trigger 到底如何处置旧边界、要重置哪些 session-scoped ledger，以及哪些 continuity 说法绝不能继续保留：看 `appendix/69`
- 想直接看为什么即使换届制度已经明确仍然不够，以及系统何时才有资格向用户承诺“仍可恢复”：看 `86`
- 想直接看不同恢复表面到底基于什么 promise basis 发声、何时必须撤回承诺，以及哪些 resume 话术绝不能说：看 `appendix/70`
- 想直接看为什么即使 promise honesty 已经建立仍然不够，以及“仍可恢复”这句话到底由谁签发、谁撤回、谁只能转述：看 `87`
- 想直接看不同恢复表面到底由谁签字、依赖哪些 truth inputs、最多配说到哪一步，以及哪些 overclaim 绝不能说：看 `appendix/71`
- 想直接看为什么即使 signer 已经正确仍然不够，以及“仍可恢复”还必须满足哪些最小证据门槛：看 `88`
- 想直接看不同 evidence piece 到底由谁提供、最低 threshold 是什么、缺失后该降级成什么：看 `appendix/72`
- 想直接看为什么即使证据门槛已经建立仍然不够，以及不同恢复失败为什么还必须继续分层改口，而不能压成同一句“无法恢复”：看 `89`
- 想直接看不同 resume result 到底代表什么、下一步该做什么、何时该清理什么，以及哪些压平说法绝不能再说：看 `appendix/73`
- 想直接看为什么即使降级语法已经建立仍然不够，以及恢复 carrier 到底由谁清、何时禁止清、何时必须清：看 `90`
- 想直接看不同恢复 carrier 到底由谁清理、clear trigger 是什么，以及哪些提前清理绝不能发生：看 `appendix/74`
- 想直接看为什么即使清理权限已经分清仍然不够，以及在撤回条件未成立前哪些恢复资产反而必须被制度性保留：看 `91`
- 想直接看不同恢复资产到底由谁保全、何时过期、哪些过早丢失绝不能发生：看 `appendix/75`

## 和其他目录的关系

- 与 `architecture/` 的关系：`security/` 更关心为什么要这样收口，`architecture/` 更关心它是如何接线。
- 与 `risk/` 的关系：`risk/` 更关心能力撤回、资格限制和误伤；`security/` 更关心能力在什么边界里被允许、仲裁和隔离。
- 与 `philosophy/` 的关系：`philosophy/` 是抽象原则，`security/` 是把这些原则重新压成一套安全专题。

## 按主题阅读

- 想先看安全控制面的总框架：`00` -> `01`
- 想看权限和沙箱：`01` -> `02`
- 想看认证、密钥和受管环境：`01` -> `03`
- 想看 MCP、WebFetch、hooks 这些外部入口如何被收口：`01` -> `04`
- 想看技术先进性与设计启示：`01` -> `05`
- 想看第一性原理和苏格拉底收束：`01` -> `06`
- 想看权限系统到底按什么真实时序做仲裁：`02` -> `07`
- 想看配置来源、host 主权和 managed-only 策略到底怎样重新定义运行时：`03` -> `08`
- 想按攻击面而不是按功能标签理解 MCP、WebFetch、hooks、gateway：`04` -> `09`
- 想理解为什么这套安全机制仍然会被用户感知成黑箱，以及下一步该如何产品化：`05` -> `06` -> `10`
- 想把 Claude Code 的安全设计提炼成别的 Agent 平台也能复用的设计法则：`05` -> `06` -> `11`
- 想直接看平台方下一步最该把哪些安全零件做成产品：`10` -> `11` -> `12`
- 想直接读压缩后的终局版本：`17`
- 想看安全检测链是如何从源码级一路收口到主权判断：`18` -> `appendix/01`
- 想看这套安全系统背后哪些约束绝不能被局部优化打破：`18` -> `19`
- 想看更抽象但更统一的第一性原理框架，理解为什么这些检测最终都在修复“边界失真”：`19` -> `20`
- 想看现有源码里安全状态面碎片是怎样形成的，以及为什么下一步必须做统一安全控制台：`10` -> `21`
- 想看系统凭什么认为“当前可安全执行”，以及哪些证明必须同时成立：`18` -> `21` -> `22`
- 想看统一安全控制台如果真的做成产品，最少应该有哪些字段、哪些字段已经在源码里存在：`21` -> `22` -> `23`
- 想看统一安全控制台如果真的做成界面，最少应该有哪些卡片，以及每张卡应当绑定哪条证明链和最短动作：`22` -> `23` -> `24`
- 想看统一安全控制台如何真正带用户完成“识别 -> 断链 -> 动作 -> 回读验证”的最短闭环：`23` -> `24` -> `25`
- 想看统一安全控制台如何进一步从动作闭环升级成跨页面、跨宿主保真的交互状态机：`24` -> `25` -> `26`
- 想看统一安全控制台如果要跨宿主真正成立，最少必须保真哪些安全对象，以及为什么这首先是协议问题：`25` -> `26` -> `27`
- 想看为什么多宿主、多子集本身并不可怕，真正可怕的是宿主把自己的降级身份藏起来：`26` -> `27` -> `28`
- 想看不同宿主到底分别有资格承担观察、控制还是证明责任，以及为什么这不是功能多少而是责任分层：`27` -> `28` -> `29`
- 想看 `worker_status`、`external_metadata`、本地 `AppState` 和 UI 文案之间到底是什么关系，以及为什么它们都不能冒充全部真相：`28` -> `29` -> `30`
- 想看多层真相一旦冲突时，恢复顺序、语义事件、复制层、本地状态和 UI 摘要之间到底谁优先：`29` -> `30` -> `31`
- 想看为什么源码里反复出现单一闸门、镜像、去重、清理和串行化，以及它们到底在防什么：`30` -> `31` -> `32`
- 想看反裂脑工程再往下一层到底依赖什么底层公理，以及为什么“谁有资格写”比“怎么解释”更重要：`31` -> `32` -> `33`
- 想把 `33` 的长文压回一张适合设计评审和代码审计的矩阵，直接检查哪些事实必须单写、哪些层只能镜像：`33` -> `appendix/17`
- 想看单写者再往下一层还缺什么，以及为什么“谁能写”之后还必须继续追问“何时算写成”：`32` -> `33` -> `34`
- 想把 `34` 的长文压成一张可直接用于提交边界评审的矩阵，快速区分语义、复制、可见、持久和恢复五层：`34` -> `appendix/18`
- 想看为什么提交层一旦分开，系统最后就不得不维护多本职责不同的账，而不是强行统一成一个“总状态流”：`34` -> `35`
- 想把 `35` 的长文压成一张可直接用于设计评审的账本矩阵，快速分清不同读者该信哪一本账：`35` -> `appendix/19`
- 想看为什么宿主一旦接入协议，也依然可能只看到账本子集，以及为什么“接入了”不等于“看全了”：`35` -> `36`
- 想把 `36` 的长文压成一张宿主矩阵，快速看出每类宿主拿到了哪些账、缺哪些账、最怕误读什么：`36` -> `appendix/20`
- 想看为什么宿主即使接入了账本子集，也未必有资格替整套控制面下结论，以及解释权限该如何收口：`36` -> `37`
- 想把 `37` 的长文压成一张解释权限矩阵，快速判断每类宿主“能说到哪、必须停在哪”：`37` -> `appendix/21`
- 想看为什么解释权限继续往下还会收敛成“未知必须显式化”，以及为什么成熟系统宁可说不知道也不该硬猜：`37` -> `38`
- 想把 `38` 的长文压成一张未知语义矩阵，快速区分 unsupported、no ledger、precondition fail 与 timing unknown：`38` -> `appendix/22`
- 想看为什么系统即使知道，也不该只给粗糙的 yes/no，而应把结论按强度、理由和条件分级表达：`38` -> `39`
- 想把 `39` 的长文压成一张声明矩阵，快速看出 allowed-warning、needs-auth、review_ready、typed reason 各自属于什么等级：`39` -> `appendix/23`
- 想看为什么声明即使已经分级，也仍然必须继续绑定正确下一步动作，以及 why `needs-auth`、`pending`、`review_ready`、`canRewind = false` 绝不能共用同一种恢复路径：`39` -> `40`
- 想把 `40` 的长文压成一张动作矩阵，快速看出不同状态到底该走哪条动作、最怕被压成哪条错动作：`40` -> `appendix/24`
- 想看为什么动作即使已经正确，也仍然必须继续绑定正确主体、写入层和持续时间，以及 why 宿主、用户、管理员和系统不能互相代做：`40` -> `41`
- 想把 `41` 的长文压成一张归属矩阵，快速看出不同信号到底该由谁执行、写到哪层、以及最危险的越权者是谁：`41` -> `appendix/25`
- 想看为什么动作即使已经由正确主体执行，也仍然不能立刻宣布完成，以及 why queue drain、局部副作用、临时 idle 都不能直接代替 authoritative completion：`41` -> `42`
- 想把 `42` 的长文压成一张完成权矩阵，快速看出哪些只是执行信号、哪些才是 completion signer、以及最危险的提前宣布是什么：`42` -> `appendix/26`
- 想看为什么同一条完成签字链到了不同宿主手里还会继续收缩，以及 why StructuredIO、RemoteIO、bridge、direct connect、remote session manager 不该说同样满的完成话：`42` -> `43`
- 想把 `43` 的长文压成一张宿主矩阵，快速看出不同宿主看到了哪些完成信号、缺哪本账、最危险会误说成什么：`43` -> `appendix/27`
- 想看为什么宿主差异即使在底层已经存在，也仍然必须继续被界面显式揭示，以及 why `/status`、bridge label 和 adapter 文案不能继续把它们压平成同一句话：`43` -> `44`
- 想把 `44` 的长文压成一张界面矩阵，快速看出哪些表面正在压缩宿主差异、最少该补哪些显化字段、最不该继续复用哪句文案：`44` -> `appendix/28`
- 想看要把这些差异真正产品化，统一安全控制台最少该补哪些字段，以及哪些字段来自源码、哪些只需轻度派生：`44` -> `45`
- 想把 `45` 的长文压成一张字段矩阵，快速看出字段来源、展示层级和缺失后最会误导什么：`45` -> `appendix/29`
- 想看这些字段不只“存在”还要“挂得对”，以及 why completion ceiling、missing_ledgers、write/read readiness 和 subtype 宽度必须占据不同的卡片层级：`45` -> `46`
- 想把 `46` 的长文压成一张卡片矩阵，快速看出每个字段组该挂到哪、优先级多高、最怕被埋成什么样：`46` -> `appendix/30`
- 想看这些字段不仅要挂得对，还必须在恰当时机赢得用户注意力，以及 why immediate/high/medium/low 应映射到不同宿主盲区风险：`46` -> `47`
- 想把 `47` 的长文压成一张升级矩阵，快速看出默认优先级、升级条件和绝不能降到哪一级：`47` -> `appendix/31`
- 想看为什么字段、卡片和升级规则仍然不够，以及 why 宿主盲区必须进一步被路由成“卡片改口、通知抢位、动作收口、清除守纪”的同一时刻联动：`47` -> `48`
- 想把 `48` 的长文压成一张联动路由矩阵，快速看出触发器、卡片更新、通知级别、动作收口和清除条件之间如何成套移动：`48` -> `appendix/32`
- 想看为什么有了联动还不够，以及 why 旧结论撤销必须继续服从 stale cleanup、restore/hydrate 排序和 authoritative signer，而不能先删告警再等状态回来：`48` -> `49`
- 想把 `49` 的长文压成一张清除纪律矩阵，快速看出不同旧结论分别允许被什么 fresh 证据清除、又禁止先恢复什么动作：`49` -> `appendix/33`
- 想看为什么 fresh 证据本身也必须继续分层，以及 why connected、state_restored、session_state_changed(idle)、files_persisted 与账本补齐分别只配恢复不同层级对象：`49` -> `50`
- 想把 `50` 的长文压成一张 signer 矩阵，快速看出不同 signer 分别能恢复什么、不能恢复什么、最危险的越级误读是什么：`50` -> `appendix/34`
- 想看为什么 signer hierarchy 仍然不够，以及 why 系统还必须给“半恢复”状态正式命名，否则用户仍会把它们读成 fully recovered：`50` -> `51`
- 想把 `51` 的长文压成一张中间态矩阵，快速看出每种半恢复状态缺哪条链、允许哪些动作、禁止哪种文案：`51` -> `appendix/35`
- 想看为什么中间态即使已经被命名，也仍可能在最后一步被绿色文案重新说满，以及 why 控制面必须给词汇本身建立禁令：`51` -> `52`
- 想把 `52` 的长文压成一张文案规则矩阵，快速看出某层 signer 或某种中间态当前禁止说什么、允许说什么、默认句式该怎么写：`52` -> `appendix/36`
- 想看为什么文案即使已经受约束，也仍然不够，以及 why 每种半恢复状态必须继续绑定唯一 dominant repair path，不能让用户在 `/status`、`/mcp`、`/plugins`、`/login`、`/remote-control` 之间自己猜：`52` -> `53`
- 想把 `53` 的长文压成一张跳转路由矩阵，快速看出每种半恢复状态的 dominant repair path、次级路径和禁止歧义：`53` -> `appendix/37`
- 想看为什么 dominant repair path 仍然不够，以及 why repair action 只能产生修复意图，真正恢复还必须继续经过 verifier readback、state signer、effect signer 关环：`53` -> `54`
- 想把 `54` 的长文压成一张恢复闭环矩阵，快速看出不同 repair path 对应的 verifier、最终 signer 和可清除对象：`54` -> `appendix/38`
- 想看为什么 verifier 和 signer 即使已经存在，也不代表系统就该自动撤警，以及 why 只有在 action/verifier/signer 三权都在系统手里时才配 auto-close：`54` -> `55`
- 想把 `55` 的长文压成一张自动验证门槛矩阵，快速看出各类 repair path 的 ownership 完整度、是否允许 auto-close、何时必须转人工确认：`55` -> `appendix/39`
- 想看为什么即使已经停在人工确认态或自动闭环失败，系统仍不能把问题静默忘掉，以及 why `needsRefresh`、`pending`、`failed`、pointer、retry count 这些对象必须继续保留：`55` -> `56`
- 想把 `56` 的长文压成一张留痕矩阵，快速看出不同失败场景对应的留痕对象、再进入入口和清除条件：`56` -> `appendix/40`
- 想看为什么留痕即使已经存在，也仍可能被错误层级越权清掉，以及 why `notification key`、`needsRefresh`、reconnect trace、pointer、高层解释痕迹必须分别由不同所有者清理：`56` -> `57`
- 想把 `57` 的长文压成一张清理权限矩阵，快速看出不同 trace 的 owner、allowed clearer 和 forbidden clearer：`57` -> `appendix/41`
- 想看为什么 owner 已经正确仍然不等于现在就能清，以及 why timeout/invalidates、full rebuild、retry budget、archive+deregister、fatal/stale 都是清理门槛的一部分：`57` -> `58`
- 想把 `58` 的长文压成一张清理门槛矩阵，快速看出不同 trace 的 minimum clearer、threshold evidence 与 auto-clear 许可：`58` -> `appendix/42`
- 想看为什么痕迹在界面上消失并不等于它已被正式删除，以及 why notification layer、BridgeDialog、`/status` 与 authoritative trace writer 是四个不同层次：`58` -> `59`
- 想把 `59` 的长文压成一张分层矩阵，快速看出 surface hider、projection owner、trace writer 与 explanation closer 各自的权限边界：`59` -> `appendix/43`
- 想看为什么恢复控制面还必须继续把 hidden、suppressed、cleared、resolved 做成不同词法，而不能把不同责任层状态压成同一句“已恢复”：`59` -> `60`
- 想把 `60` 的长文压成一张词法矩阵，快速看出 hidden、suppressed、cleared、resolved 的定义、禁止误说与责任层：`60` -> `appendix/44`
- 想看为什么有了词法还不够，以及 why 不同界面、通知、footer 和摘要仍必须服从同一套命名主权与表达 ceiling：`60` -> `61`
- 想把 `61` 的长文压成一张命名仲裁矩阵，快速看出不同 surface 的 visible inputs、max allowed lexicon 与 forbidden stronger terms：`61` -> `appendix/45`
- 想看为什么有了命名主权仍然不够，以及 why 多个 surface 同时存在时还必须继续仲裁谁能代表当前真相：`61` -> `62`
- 想把 `62` 的长文压成一张跨面仲裁矩阵，快速看出不同 surface 的 lexical authority level 以及冲突时谁赢谁输：`62` -> `appendix/46`
- 想看为什么词法冲突被仲裁后仍然不够，以及 why 更强新证据出现时旧词必须继续被显式 invalidated、remove 或降级：`62` -> `63`
- 想把 `63` 的长文压成一张失效矩阵，快速看出 new stronger evidence 会使哪些 old lexicon 退场、影响哪些 surfaces：`63` -> `appendix/47`
- 想看为什么这些绿色词从一开始就不应被理解成永久承诺，以及 why 它们更像带续租条件和撤租触发器的短租约：`63` -> `64`
- 想把 `64` 的长文压成一张租约矩阵，快速看出不同绿色词的 renewal condition、revocation trigger 与 lease length：`64` -> `appendix/48`
- 想看为什么租约本身还不够，以及 why 绿色词必须继续靠 heartbeat、poll、refresh 与 recheck 续租、续租失败就要降级：`64` -> `65`
- 想把 `65` 的长文压成一张续租矩阵，快速看出不同 lexicon 的 renewal signal、cadence 与 failure branch：`65` -> `appendix/49`
- 想把 `66` 的长文压成一张失败梯子矩阵，快速看出不同 lease failure type 的 recovery capacity 与 next repair path：`66` -> `appendix/50`
- 想看为什么续租失败后还不能只剩一个 failed，以及 why 不同 failure 必须继续分层表达剩余恢复能力：`65` -> `66`
- 想看为什么有了 failure ladder 还不够，以及 why 不同 failure tier 还必须直接绑定不同的 next repair path：`66` -> `67`
- 想把 `67` 的长文压成一张路径选择器矩阵，快速看出不同 failure tier 的 dominant repair path 与 forbidden wrong path：`67` -> `appendix/51`
- 想看为什么 dominant repair path 即使已经存在也仍然不够，以及 why 控制面还必须显式禁止邻近错误路径、收缩动作空间：`67` -> `68`
- 想把 `68` 的长文压成一张禁令矩阵，快速看出不同 failure tier 的 forbidden adjacent path、block reason 与 release condition：`68` -> `appendix/52`
- 想看为什么 wrong path 里最危险的是 destructive cleanup，以及 why pointer、retry、needsRefresh 这些对象在可恢复性耗尽前都不该被删：`68` -> `69`
- 想把 `69` 的长文压成一张合法性矩阵，快速看出不同 recoverability asset 的 forbidden cleanup 与 release condition：`69` -> `appendix/53`
- 想看为什么 bypass、workspace trust、bridge-safe commands、MCP 审批与 channel relay 不是互相替代，而是同一条能力发布链上的多重窄门：`02` -> `03` -> `04` -> `07` -> `70`
- 想把 `70` 的长文压成一张能力借出矩阵，快速看出不同 gate 的 admission condition、protected capability 与 forbidden shortcut：`70` -> `appendix/54`
- 想看为什么能力一旦被显示成入口，就已经构成安全承诺，以及 why 只有 authoritative publish set 才有资格决定“现在可见”：`70` -> `71`
- 想把 `71` 的长文压成一张发布主权矩阵，快速看出不同 surface 的 authoritative publisher、visible capability 与 forbidden overclaim：`71` -> `appendix/55`
- 想看为什么能力撤回和能力发布一样都必须服从同一主权层，以及 why stale client、dead button 与局部隐藏都不足以代表正式撤回：`71` -> `72`
- 想把 `72` 的长文压成一张撤回矩阵，快速看出不同 surface 的 revocation authority、retraction trigger 与 forbidden stale promise：`72` -> `appendix/56`
- 想看为什么能力恢复不是简单回暖，而必须重新经过同一条主权链签字，以及 why `pending` 往往比“已可用”更诚实：`72` -> `73`
- 想把 `73` 的长文压成一张恢复矩阵，快速看出不同 surface 的 restoration authority、regrant path 与 forbidden premature return：`73` -> `appendix/57`
- 想看为什么状态枚举和前台词法必须继续分层，以及 why `/status`、notification、footer 与 hook 不该说同样满的能力词：`71` -> `72` -> `73` -> `74`
- 想把 `74` 的长文压成一张声明矩阵，快速看出不同 surface 的 visible inputs、max allowed lexicon 与 forbidden stronger claim：`74` -> `appendix/58`
- 想看为什么有了词法 ceiling 仍然不够，以及 why notification priority、`/status` handoff 与 footer 让位还必须继续组成同一套仲裁规则：`74` -> `75`
- 想把 `75` 的长文压成一张仲裁矩阵，快速看出不同 surface 的 authority kind、conflict winner-loser 与 forced handoff：`75` -> `appendix/59`
- 想看为什么知道“谁更权威”仍然不够，以及 why 更高风险、更具体的新状态还必须显式驱逐旧的弱状态，而不能只靠 timeout：`75` -> `76`
- 想把 `76` 的长文压成一张驱逐矩阵，快速看出不同 incoming state、evicted state、eviction mechanism 与 stale risk：`76` -> `appendix/60`
- 想看为什么即使已经知道该不该驱逐，也仍然不能把所有状态变化统一成一种更新方式，以及 why `fold`、`invalidate`、`remove` 与 `coexist` 必须分开：`76` -> `77`
- 想把 `77` 的长文压成一张编辑矩阵，快速看出不同 change pattern、operator、safe effect 与 forbidden shortcut：`77` -> `appendix/61`
- 想看为什么即使编辑动词已经分清，系统仍然可能因为“谁都能删谁”而失控，以及 why 下一代控制台必须把编辑主权也编码进接口：`77` -> `78`
- 想把 `78` 的长文压成一张主权矩阵，快速看出不同 status family、allowed editor、allowed operator 与 forbidden outsider：`78` -> `appendix/62`
- 想看为什么即使主语已经分清，系统仍可能因为 family scope 只存在于命名习惯里而不够稳，以及 why 全局 key 不是长期安全边界：`78` -> `79`
- 想把 `79` 的长文压成一张作用域矩阵，快速看出不同 key pattern、implicit family、current guarantee 与 scope risk：`79` -> `appendix/63`
- 想看为什么即使作用域已经看清，系统仍应继续从裸 key 迁移到句柄，以及 why bridge handle 提供了现成范式：`79` -> `80`
- 想把 `80` 的长文压成一张句柄化矩阵，快速看出不同 subsystem 的 current carrier、missing scope、recommended handle fields 与 migration gain：`80` -> `appendix/64`
- 想看为什么句柄真正值钱的不是“对象化”，而是 creator-bound closure，以及 why bridge 子系统已经给出上下文绑定范式：`80` -> `81`
- 想把 `81` 的长文压成一张闭包矩阵，快速看出不同 handle、captured context、forbidden re-derivation 与 security gain：`81` -> `appendix/65`
- 想看为什么闭包绑定之后还必须继续提出“禁止重推导”的硬禁令，以及 why title 这种 cosmetic context 与 session/token 这种 authority context 必须分治：`81` -> `82`
- 想把 `82` 的长文压成一张禁令矩阵，快速看出不同 surface、re-derivable context、forbidden authority context 与 failure mode：`82` -> `appendix/66`
- 想看为什么“禁止重推导”继续往下压后，真正被保护的对象其实是 authorization continuity 本身，而不是单个字段值：`82` -> `83`
- 想把 `83` 的长文压成一张连续性矩阵，快速看出不同 context 的 continuity owner、allowed substitution 与 boundary failure：`83` -> `appendix/67`
- 想看为什么 continuity failure 里最危险的一种不是普通断裂，而是已失效边界被旧 timer、旧 transport、旧 pointer 或假 resume 重新写成 current：`83` -> `84`
- 想把 `84` 的长文压成一张复活禁令矩阵，快速看出不同 stale object 的 revival path、current guard 与 boundary consequence：`84` -> `appendix/68`
- 想看为什么即使已经防住复活，系统仍必须继续明确“续接、换届、挂起、退役”四种制度动作，而不是统一压成重新连一下：`84` -> `85`
- 想把 `85` 的长文压成一张换届矩阵，快速看出不同 break trigger、old boundary disposition、required reset 与 forbidden fake continuity：`85` -> `appendix/69`
- 想看为什么即使边界生命周期已经分清，resume command、pointer 与 try-again 提示仍必须继续遵守 promise honesty，而不能把“看起来还能恢复”说成“真的还能恢复”：`85` -> `86`
- 想把 `86` 的长文压成一张恢复承诺矩阵，快速看出不同 surface 的 promise basis、allowed promise 与 forbidden lie：`86` -> `appendix/70`
- 想看为什么即使恢复承诺已经要求诚实，局部 signal 仍然不能越权签发这种承诺，以及 why signer authority 也必须被治理：`86` -> `87`
- 想把 `87` 的长文压成一张签发矩阵，快速看出不同 surface 的 signer、truth inputs 与 forbidden overclaim：`87` -> `appendix/71`
- 想看为什么即使 signer 已经找对，单个 signal 仍然不够，以及 why resumability 必须建立在最小 truth bundle 上：`87` -> `88`
- 想把 `88` 的长文压成一张证据矩阵，快速看出不同 evidence piece、owner、threshold 与 failure downgrade：`88` -> `appendix/72`
- 想看为什么即使 truth bundle 已经齐全，系统仍不能把所有失败统一压成 generic failed，而必须继续区分 no-candidate、dead-session、fresh fallback 与 retryable：`88` -> `89`
- 想把 `89` 的长文压成一张降级矩阵，快速看出不同 resume result、meaning、next action 与 forbidden flattening：`89` -> `appendix/73`
- 想看为什么即使恢复结果已经分层，系统仍不能让任何局部层随手清掉 pointer，而必须继续治理 revocation cleanup authority：`89` -> `90`
- 想把 `90` 的长文压成一张清理权限矩阵，快速看出不同 carrier、clearer、clear trigger 与 forbidden premature clear：`90` -> `appendix/74`
- 想看为什么即使撤回权已经管住了，系统仍必须继续回答哪些恢复资产在资格未撤回前必须被主动保全：`90` -> `91`
- 想把 `91` 的长文压成一张保全矩阵，快速看出不同 asset、preservation owner、expiry basis 与 forbidden early loss：`91` -> `appendix/75`
- 想看为什么即使恢复资产已经被保住，系统仍必须继续为这些资产持续续保 freshness proof，而不是等它们静静变 stale：`91` -> `92`
- 想把 `92` 的长文压成一张续保矩阵，快速看出不同 asset、freshness signal、refresh cadence 与 stale consequence：`92` -> `appendix/76`
- 想看为什么即使恢复资产已经持续续保，系统仍不能让“当前目录里的那个 pointer”天然胜出，以及 why 多 worktree 并存时必须由最新活性证明而不是路径亲缘决定当前真相：`92` -> `93`
- 想把 `93` 的长文压成一张仲裁矩阵，快速看出不同 candidate 的 admission gate、winner rule 与 loser handling：`93` -> `appendix/77`
- 想看为什么即使仲裁规则已经正确，系统真正保护的仍不是 pointer、plugin 文件或 MCP client 这些工件，而是同一边界下的继续行动权：`93` -> `94`
- 想把 `94` 的长文压成一张资格对象矩阵，快速看出不同 artifact 的 boundary binding、freshness proof、revocation gate 与 regrant path：`94` -> `appendix/78`
- 想看为什么即使资格对象已经定义清楚，失效对象也不能靠残留工件直接回到 `current`，而必须先走 `pending`、`reload` 或 `fresh-session` 这类重签发路径：`94` -> `95`
- 想把 `95` 的长文压成一张重签发矩阵，快速看出不同 artifact 的 revocation trigger、regrant path 与 forbidden shortcut：`95` -> `appendix/79`
- 想看为什么即使重签发协议已经成立，`needsRefresh`、`pending`、retryable 与 `fresh-session-fallback` 这些中间态仍不能压成同一句“正在恢复”：`95` -> `96`
- 想把 `96` 的长文压成一张中间态矩阵，快速看出不同 state 的 meaning、allowed promise 与 next action：`96` -> `appendix/80`
- 想看为什么即使中间态语法已经分清，每一种状态仍只能说到自己的承诺上限，不能把 `pending`、`reconnecting` 或 `needsRefresh` 说成 `active`：`96` -> `97`
- 想把 `97` 的长文压成一张承诺矩阵，快速看出不同 state 的 lexical ceiling、forbidden stronger claim 与 default route：`97` -> `appendix/81`
- 想看为什么即使语言上限已经守住，每一种资格状态仍必须继续绑定唯一 dominant route，而不能把修复选择权外包给用户自己猜：`97` -> `98`
- 想把 `98` 的长文压成一张动作路由矩阵，快速看出不同 state 的 dominant route、route owner 与 forbidden adjacent path：`98` -> `appendix/82`
- 想看为什么即使正确默认动作已经存在，系统仍必须显式禁止那些看起来合理、却会破坏资格真相的近邻错路：`98` -> `99`
- 想把 `99` 的长文压成一张禁令矩阵，快速看出不同 state 的 dominant route、forbidden adjacent path 与 block reason：`99` -> `appendix/83`
- 想看为什么即使用户已经走上正确修复路径，系统仍不能立刻宣布资格已恢复，而必须等待对应 completion-signer 签字：`99` -> `100`
- 想把 `100` 的长文压成一张完成矩阵，快速看出不同 action 的 completion-signer、completion signal 与 forbidden premature success：`100` -> `appendix/84`
- 想看为什么即使 completion-signer 已经签字，不同 surface 仍只能看到完成真相的子集，而不应互相冒充完整控制台：`100` -> `101`
- 想把 `101` 的长文压成一张完成投影矩阵，快速看出不同 surface 的 visible completion subset、hidden truth 与 overclaim risk：`101` -> `appendix/85`
- 想看为什么即使完成投影已经分层，系统仍不应让用户自己猜某个 surface 漏看了什么，而应显式说明自己的投影盲区：`101` -> `102`
- 想把 `102` 的长文压成一张差异显化矩阵，快速看出不同 surface 的 projection scope、missing truth 与 recommended disclosure：`102` -> `appendix/86`
- 想看为什么即使差异显化理念已经成立，下一代控制台仍必须把 projection-scope、hidden-truth、handoff-route 做成结构化字段，而不是继续散落在注释里：`102` -> `103`
- 想把 `103` 的长文压成一张字段矩阵，快速看出不同 projection protocol field 的 meaning、example source 与 UI gain：`103` -> `appendix/87`
- 想看为什么即使 projection protocol fields 已经定义出来，这些字段仍不应平均撒到所有 surface，而应随控制面强弱、带宽与责任分层落位：`103` -> `104`
- 想把 `104` 的长文压成一张落位矩阵，快速看出不同 surface 的 must-show fields、optional fields 与 forbidden clutter：`104` -> `appendix/88`
- 想看为什么即使字段已经落在正确 surface，上面出现的多个 signal 仍不能平权竞争，而应让强断点抢占弱信号：`104` -> `105`
- 想把 `105` 的长文压成一张优先级矩阵，快速看出不同 signal 的 priority、preemption target 与 display policy：`105` -> `appendix/89`
- 想看为什么即使优先级已经分出来，系统仍不能只靠“谁更强”治理字段，而必须继续回答它何时配升级、何时该留场、何时必须退场：`105` -> `106`
- 想把 `106` 的长文压成一张生命周期矩阵，快速看出不同 signal 的 upgrade threshold、stay condition、retire trigger 与 premature exit risk：`106` -> `appendix/90`
- 想看为什么即使生命周期规则已经被找出来，它们仍不该继续散落在局部 hook、controller 与 comment 里，而应升级成统一 field-lifecycle protocol：`106` -> `107`
- 想把 `107` 的长文压成一张协议化矩阵，快速看出不同 subsystem 的 current carrier、hidden lifecycle rule 与 recommended protocol fields：`107` -> `appendix/91`
- 想看为什么即使协议已经定义出来，统一控制台仍不能只保存当前快照，而必须保存字段为何升级、为何留场、为何退场的时间性依据：`107` -> `108`
- 想把 `108` 的长文压成一张账本矩阵，快速看出不同 subsystem 的 current snapshot、missing temporal basis 与 recommended ledger record：`108` -> `appendix/92`
- 想看为什么即使 lifecycle ledger 已经成立，系统仍不能继续让高风险字段通过裸 `setState` 变化，而必须补统一 transition dispatch / state machine：`108` -> `109`
- 想把 `109` 的长文压成一张调度矩阵，快速看出不同 subsystem 的 current writer、implicit transition 与 recommended dispatch event：`109` -> `appendix/93`
- 想看为什么即使 dispatch 已经存在，状态机仍不能只会“调度”，而必须继续回答哪些 from_state -> to_state 根本不被允许：`109` -> `110`
- 想把 `110` 的长文压成一张宪法矩阵，快速看出不同 subsystem 的 forbidden jump、allowed gate 与 reason：`110` -> `appendix/94`
- 想看为什么即使 transition constitution 已经成立，如果这些禁令不能被机器持续验证，就仍然太依赖维护者记忆：`110` -> `111`
- 想把 `111` 的长文压成一张机检矩阵，快速看出不同 subsystem 的 candidate invariant、current guard 与 recommended automated check：`111` -> `appendix/95`
- 想看为什么即使 candidate invariants 已经被找出来，安全验证仍不能停留在单点机检，而必须把 schema、guard、transition、ledger 与 tests 组织成验证金字塔：`111` -> `112`
- 想把 `112` 的长文压成一张分层矩阵，快速看出不同 layer 的 responsibility、best-fit rules 与 current evidence：`112` -> `appendix/96`
- 想看为什么即使验证金字塔已经成形，测试补强仍不能平均推进，而必须优先覆盖最贵的失真与最脆的时序：`112` -> `113`
- 想把 `113` 的长文压成一张优先级矩阵，快速看出不同 area 的 historical signal、recommended test type 与 priority：`113` -> `appendix/97`
- 想看为什么即使优先级已经排清，下一步仍不能停留在路线图，而必须直接收口成首批可执行测试套件与 rollout order：`113` -> `114`
- 想把 `114` 的长文压成一张执行矩阵，快速看出不同 suite 的 first test、minimal assertion 与 rollout order：`114` -> `appendix/98`
- 想看为什么即使最小验证蓝图已经存在，只要它还没进入 script、目录、tsconfig 与 CI 挂载点，就仍然不是工程制度：`114` -> `115`
- 想把 `115` 的长文压成一张接口矩阵，快速看出不同 interface 的 current state、missing hook 与 recommended contract：`115` -> `appendix/99`
- 想看为什么即使验证制度化接口已经明确，这份研究版源码若要真正走向可持续安全工程，仍必须先固化边界并按阶段迁移，而不能假装可以一步到位重构：`115` -> `116`
- 想把 `116` 的长文压成一张迁移矩阵，快速看出不同 phase 的 goal、repo touchpoint 与 exit criteria：`116` -> `appendix/100`
- 想看为什么即使迁移路线图已经明确，仍不能把 phase 只写成顺序列表，而必须让每个阶段都拥有明确的 entry gate、exit criteria 与 forbidden shortcut：`116` -> `117`
- 想把 `117` 的长文压成一张阶段门矩阵，快速看出不同 phase 的 entry gate、exit criteria 与 forbidden shortcut：`117` -> `appendix/101`
- 想看为什么即使阶段门已经成立，仍必须继续区分不同 gate 的签字权限，避免低级 gate 越权冒充高级结论：`117` -> `118`
- 想把 `118` 的长文压成一张门类型矩阵，快速看出不同 gate 的 question、repo touchpoint、pass signal 与 forbidden overclaim：`118` -> `appendix/102`
- 想看更技术化的检测链拆解，以及规则、路径、外部入口和来源主权如何串成一套内核：`07` -> `08` -> `09` -> `18`
