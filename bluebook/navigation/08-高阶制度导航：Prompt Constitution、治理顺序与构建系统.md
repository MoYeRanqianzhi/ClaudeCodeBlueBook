# 高阶制度导航：Prompt Constitution、治理顺序与构建系统

这一篇不新增新的正文判断，而是把 Claude Code 最近已经稳定下来的三条第二序制度母线压成一个直接入口。

它主要回答四个问题：

1. 如果已经接受 57-59 的终局判断，接下来应转入哪组更深的制度章节。
2. 如果想把 prompt、安全、源码先进性再讲深一层，最稳的阅读入口是什么。
3. 如果想做苏格拉底式自检，怎样避免把这些高阶制度又重新写浅。
4. 如果想迁移到自己的 runtime，哪些制度比目录模仿更值得先抄。

## 1. Prompt Constitution 母线

适合在这些问题下阅读：

- 为什么 prompt 不该再被写成一段文案。
- 为什么 section 宪法、角色优先级链、合法遗忘和 transport 不变语义必须一起看。
- 为什么 prompt 本身应被 diff、被解释、被观测。

稳定阅读顺序：

1. `architecture/36-五层合同、缓存断点与Prompt装配时序.md`
2. `architecture/39-Prompt可重放前缀、可观测预算与Section编译器.md`
3. `architecture/46-Prompt稳定性解释层：cache-break detection的两阶段诊断器.md`
4. `architecture/54-从UI Transcript到Protocol Transcript：Prompt不是聊天记录的直接重放.md`
5. `architecture/73-Prompt Constitution控制面：section宪法、角色主权链、合法遗忘与可观测diff.md`
6. `philosophy/33-可解释稳定性比神秘措辞更接近Prompt魔力.md`
7. `philosophy/39-治理必须落到字节级确定性：上下文准入优于功能堆叠.md`
8. `philosophy/60-Prompt不是文案，而是受治理的Prompt Constitution.md`

这条线的核心结论是：

- Claude Code 的 prompt 不是一次性文本，而是一份受 section、角色、删除策略、恢复策略和 diff 机制共同治理的制度体

苏格拉底式自检：

1. 我描述的是 prompt 写得更强，还是 prompt 由什么构成、谁有权改它。
2. 我描述的是注入更多信息，还是删掉什么后系统仍然合法。
3. 我描述的是神秘效果，还是可 diff、可解释、可诊断的基础设施。

## 2. 治理顺序与失败语义母线

适合在这些问题下阅读：

- 为什么仅仅说“统一预算器”还不够。
- 为什么成熟安全系统要强调检查顺序、失败语义分型和自动化撤销。
- 为什么系统只该在仍有决策增益的地方继续花 token。

稳定阅读顺序：

1. `architecture/23-统一权限决策流水线与多路仲裁.md`
2. `architecture/40-显式失败语义、重复响应与反竞争条件设计.md`
3. `architecture/50-PolicySettings控制平面、Sandbox契约与三套预算器.md`
4. `architecture/51-安全即输入边界控制平面：Managed Authority、Trusted Sources与Runtime Boundary Compilation.md`
5. `architecture/62-Narrow、Later、Outside：安全设计与省Token设计的统一反扩张运行时.md`
6. `architecture/74-治理顺序控制面：失败语义分型、可撤销自动化与稳定字节资产.md`
7. `philosophy/37-统一第一性原理不等于单一预算实现.md`
8. `philosophy/47-当前真相必须可恢复，而不是事后可观测.md`
9. `philosophy/61-真正成熟的安全与省Token系统，不是统一预算器，而是治理顺序、失败语义与可撤销自动化.md`

这条线的核心结论是：

- Claude Code 真正成熟的不是“限制更多”，而是把判断放在正确顺序、让失败按资产分型、并在自动化失去增益时及时退回人工或停机

苏格拉底式自检：

1. 我描述的是检查更多，还是顺序更对。
2. 我描述的是 fail-open/fail-closed 立场，还是不同资产的失败语义分型。
3. 我描述的是省 token 技巧，还是何时继续判断、何时停止判断。

## 3. 构建系统与源码秩序母线

适合在这些问题下阅读：

- 为什么构建系统也该被视为架构工具。
- 为什么入口影子、transport shell、薄 registry 与恢复路径设计要放在一起看。
- 为什么源码先进性还体现在发布面塑形和对象命运治理上。

稳定阅读顺序：

1. `architecture/33-公开源码镜像的先进性、热点与技术债.md`
2. `architecture/55-热点文件不是坏味道：Kernel、Shell与Chokepoint的分工.md`
3. `architecture/63-可演化内核：Claude Code如何在持续增长中维持不变量.md`
4. `architecture/66-演化制度设计：Claude Code如何在增长中保留重构可能性.md`
5. `architecture/69-源码即治理界面：注释、命名与显式边界如何降低误改成本.md`
6. `architecture/75-构建系统塑形源码秩序：入口影子、传输外壳、薄Registry与Zombification治理.md`
7. `philosophy/50-先进源码不是一开始就完美分层，而是增长时仍能守住不变量.md`
8. `philosophy/53-好架构不是更会重构，而是始终保留重构可能性.md`
9. `philosophy/62-构建系统也是架构工具：发布面、入口影子与传输外壳共同塑造源码秩序.md`

这条线的核心结论是：

- Claude Code 的源码秩序不只由运行时机制决定，也由构建、入口、传输与恢复制度共同塑形

苏格拉底式自检：

1. 我描述的是目录更漂亮，还是发布面和模块图被主动塑形。
2. 我描述的是更多复用，还是入口安全可导入的 implementation shadow。
3. 我描述的是某次重构漂亮，还是恢复路径和状态写法已经互相约束。

## 4. 一句话总纲

如果把这一层高阶制度压成一句话，它更像：

- 先把 prompt 写成一部可治理的宪法，再把安全与成本写成有顺序和失败语义的制度，最后让构建、入口与恢复一起塑造源码秩序
