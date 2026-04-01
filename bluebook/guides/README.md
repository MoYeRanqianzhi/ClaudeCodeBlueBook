# 使用专题

本目录收纳从源码反推的实战方法，不重复产品文案。

## 当前入口

1. [01-使用指南](01-%E4%BD%BF%E7%94%A8%E6%8C%87%E5%8D%97.md)
2. [02-多Agent编排与Prompt模板](02-%E5%A4%9AAgent%E7%BC%96%E6%8E%92%E4%B8%8EPrompt%E6%A8%A1%E6%9D%BF.md)
3. [03-CLAUDE.md、记忆层与上下文注入实践](03-CLAUDE.md%E3%80%81%E8%AE%B0%E5%BF%86%E5%B1%82%E4%B8%8E%E4%B8%8A%E4%B8%8B%E6%96%87%E6%B3%A8%E5%85%A5%E5%AE%9E%E8%B7%B5.md)
4. [04-Channels、托管策略与组织级治理实践](04-Channels%E3%80%81%E6%89%98%E7%AE%A1%E7%AD%96%E7%95%A5%E4%B8%8E%E7%BB%84%E7%BB%87%E7%BA%A7%E6%B2%BB%E7%90%86%E5%AE%9E%E8%B7%B5.md)
5. [05-企业托管设置实战：channelsEnabled、allowedChannelPlugins与危险配置审批](05-%E4%BC%81%E4%B8%9A%E6%89%98%E7%AE%A1%E8%AE%BE%E7%BD%AE%E5%AE%9E%E6%88%98%EF%BC%9AchannelsEnabled%E3%80%81allowedChannelPlugins%E4%B8%8E%E5%8D%B1%E9%99%A9%E9%85%8D%E7%BD%AE%E5%AE%A1%E6%89%B9.md)
6. [06-第一性原理实践：目标、预算、对象、边界与回写](06-%E7%AC%AC%E4%B8%80%E6%80%A7%E5%8E%9F%E7%90%86%E5%AE%9E%E8%B7%B5%EF%BC%9A%E7%9B%AE%E6%A0%87%E3%80%81%E9%A2%84%E7%AE%97%E3%80%81%E5%AF%B9%E8%B1%A1%E3%80%81%E8%BE%B9%E7%95%8C%E4%B8%8E%E5%9B%9E%E5%86%99.md)
7. [07-用Context Usage与状态回写调优Prompt和预算](07-%E7%94%A8Context%20Usage%E4%B8%8E%E7%8A%B6%E6%80%81%E5%9B%9E%E5%86%99%E8%B0%83%E4%BC%98Prompt%E5%92%8C%E9%A2%84%E7%AE%97.md)
8. [08-如何根据预算、阻塞与风险选择session、task、worktree与compact](08-%E5%A6%82%E4%BD%95%E6%A0%B9%E6%8D%AE%E9%A2%84%E7%AE%97%E3%80%81%E9%98%BB%E5%A1%9E%E4%B8%8E%E9%A3%8E%E9%99%A9%E9%80%89%E6%8B%A9session%E3%80%81task%E3%80%81worktree%E4%B8%8Ecompact.md)

## 按使用目标阅读

- 想先把 Claude Code 用顺手：`01`
- 想把多 Agent 用对，而不是只会并行：`01 -> 02`
- 想把规则层、长期记忆、会话连续性分层设计清楚：`01 -> 03`
- 想把 Prompt 写成可运行的 contract，而不是一次性文案：`01 -> 02 -> 03 -> ../philosophy/18 -> ../architecture/36`
- 想把 channels 用在团队里而不是把风险直接带进会话：`01 -> 04 -> 05 -> ../api/28 -> ../architecture/37 -> ../risk/05`
- 想理解 Claude Code 为什么能同时兼顾安全、成本与体验：`01 -> ../architecture/32 -> ../architecture/37 -> ../philosophy/22`
- 想从源码反推更一般的 Agent runtime 设计法：`01 -> ../architecture/33 -> ../architecture/38 -> ../philosophy/23`
- 想把复杂任务压缩成一套可执行方法：`01 -> 06 -> ../architecture/36 -> ../architecture/37`
- 想真正调优 prompt 和预算，而不是凭感觉乱改：`06 -> 07 -> ../api/32 -> ../architecture/37`
- 想知道什么时候该 compact、什么时候该升级成 task / session / worktree：`06 -> 07 -> 08 -> ../architecture/45`

## 与其他目录的边界

- 需要字段、schema、控制协议时回到 [../api/README.md](../api/README.md)
- 需要运行时机制时回到 [../architecture/README.md](../architecture/README.md)
- 需要第一性原理解释时回到 [../philosophy/README.md](../philosophy/README.md)

后续继续补：

- 项目级 skills 工程化设计
- 宿主接入与远程协作实践
