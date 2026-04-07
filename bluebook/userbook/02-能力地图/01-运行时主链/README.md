# 运行时主链

这一层关注 Claude Code 怎样把用户输入编译成行动。

更稳的前门不是直接扫文件名，而是先记这三句：

1. `world entry -> command bus -> query loop -> session truth -> continuation`
   - 先看同一个工作对象怎样被编译、分发、执行、记账和继续。
2. `compile first, truth later`
   - 输入怎样进入模型，与当前真相怎样被维持，不是同一层。
3. `projection != signer`
   - transcript、summary、状态词和恢复资产都可能只是投影，不自动拥有签字权。

这里也要先压住一个常见误读：`/compact`、`/resume`、`/memory` 不是另一条运行时主线；它们只是同一工作对象在 `session truth -> continuation` 这段时间轴上的动作与合同。

如果你在这一层还分不清“哪一环在编译世界、哪一环只是在展示世界”，就不要继续靠目录名碰运气。

这组页真正回答的是：

1. 输入怎样进入系统。
2. 命令与查询循环怎样把输入变成行动。
3. 会话真相怎样被记账而不是只被展示。
4. 压缩、恢复与记忆怎样维持继续资格。

进入这一层前的 first reject signal 也只该剩三句：

1. 你把长摘要、最后一条消息或 transcript 当成 signer。
2. 你把 `/compact`、`/resume`、`/memory` 当成技巧，而不是 continuity contract。
3. 你还没先判 `compile / verify / continue` 的哪一环失真，就已经开始点深页标题。

更稳一点说，这一层也必须继承 `问题分型 -> 工作对象 -> 控制面 -> 入口` 的 first-answer order；若工作对象和控制面还没先站住，运行时主链 README 也只会被读成另一张机制目录。

- [01-输入分流、命令分发与入口编译.md](./01-%E8%BE%93%E5%85%A5%E5%88%86%E6%B5%81%E3%80%81%E5%91%BD%E4%BB%A4%E5%88%86%E5%8F%91%E4%B8%8E%E5%85%A5%E5%8F%A3%E7%BC%96%E8%AF%91.md)
- [02-命令总线、注入链与命令空间合同.md](./02-%E5%91%BD%E4%BB%A4%E6%80%BB%E7%BA%BF%E3%80%81%E6%B3%A8%E5%85%A5%E9%93%BE%E4%B8%8E%E5%91%BD%E4%BB%A4%E7%A9%BA%E9%97%B4%E5%90%88%E5%90%8C.md)
- [03-查询循环、工具池与行动编排.md](./03-%E6%9F%A5%E8%AF%A2%E5%BE%AA%E7%8E%AF%E3%80%81%E5%B7%A5%E5%85%B7%E6%B1%A0%E4%B8%8E%E8%A1%8C%E5%8A%A8%E7%BC%96%E6%8E%92.md)
- [04-会话真相层：实时状态、Transcript 与恢复账本.md](./04-%E4%BC%9A%E8%AF%9D%E7%9C%9F%E7%9B%B8%E5%B1%82%EF%BC%9A%E5%AE%9E%E6%97%B6%E7%8A%B6%E6%80%81%E3%80%81Transcript%20%E4%B8%8E%E6%81%A2%E5%A4%8D%E8%B4%A6%E6%9C%AC.md)
- [05-压缩、恢复与记忆：如何维持可继续工作的现场.md](./05-%E5%8E%8B%E7%BC%A9%E3%80%81%E6%81%A2%E5%A4%8D%E4%B8%8E%E8%AE%B0%E5%BF%86%EF%BC%9A%E5%A6%82%E4%BD%95%E7%BB%B4%E6%8C%81%E5%8F%AF%E7%BB%A7%E7%BB%AD%E5%B7%A5%E4%BD%9C%E7%9A%84%E7%8E%B0%E5%9C%BA.md)
- [06-功能设计关键事实清单.md](./06-%E5%8A%9F%E8%83%BD%E8%AE%BE%E8%AE%A1%E5%85%B3%E9%94%AE%E4%BA%8B%E5%AE%9E%E6%B8%85%E5%8D%95.md)

如果你只看一页，先看 `01` 和 `03`；如果你现在争议的是“谁在签当前会话真相”，先看 `04`；如果你现在争议的是“怎么继续而不是怎么展示”，先看 `05`。
