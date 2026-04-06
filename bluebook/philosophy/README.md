# 哲学专题

`philosophy/` 解释 Claude Code 为什么要这样设计，而不是仅仅罗列功能：为什么 `world entry / request assembly / six-stage assembly chain` 必须先成立，为什么治理要被写成统一定价，为什么源码质量首先服务当前真相保护。
如果你还没先经过 `09 / 05 / 15 / 41` 这组高阶前门，不要急着在这里直接下哲学判断。

如果把 `philosophy/` 前门再压成最短公式，只剩三条：

1. Prompt 线
   - `same-world test = world-defining winner -> message lineage -> protocol transcript -> stable bytes -> continuation qualification`
2. 治理线
   - `治理先外化当前真相，再批准当前扩张`
   - `Narrow / Later / Outside + stable bytes + working set`
3. 源码质量线
   - `contract truth -> registry truth -> orchestration shell -> current-truth surface -> consumer subset -> danger surface`

如果一页解释还没压到这三条，它就还停在对象层总结，不算最硬的第一性原理前门。

## 什么时候进来

- 当你已经知道功能和机制存在，但还没回答“为什么必须这样设计”。
- 当你想把 `world entry / request assembly / six-stage assembly chain`、安全/省 token、源码先进性，从做法解释压回不可约判断。
- 当你需要区分什么是实现、什么是约束、什么是迁移到别的 runtime 后仍成立的原则。
- 当你已经完成“模仿对象校正”和“失稳前追问”，准备把它们继续压成第一性原理。

## 如果你只先判断一件事

- 如果你只先判断“为什么 `world entry / request assembly / six-stage assembly chain` 不是文案技巧”，从 [84-世界如何合法进入模型：request assembly 与 six-stage assembly chain](84-%E7%9C%9F%E6%AD%A3%E6%9C%89%E9%AD%94%E5%8A%9B%E7%9A%84Prompt%EF%BC%8C%E4%BC%9A%E5%85%88%E8%A7%84%E5%AE%9A%E4%B8%96%E7%95%8C%E5%A6%82%E4%BD%95%E5%90%88%E6%B3%95%E8%BF%9B%E5%85%A5%E6%A8%A1%E5%9E%8B.md) 进入，再用 [81-Prompt的魔力来自把提示词写成可缓存、可转写、可继续的编译链.md](81-Prompt%E7%9A%84%E9%AD%94%E5%8A%9B%E6%9D%A5%E8%87%AA%E6%8A%8A%E6%8F%90%E7%A4%BA%E8%AF%8D%E5%86%99%E6%88%90%E5%8F%AF%E7%BC%93%E5%AD%98%E3%80%81%E5%8F%AF%E8%BD%AC%E5%86%99%E3%80%81%E5%8F%AF%E7%BB%A7%E7%BB%AD%E7%9A%84%E7%BC%96%E8%AF%91%E9%93%BE.md) 深挖。
  - 失败信号：还在把 Prompt 强度解释成更长 instruction 或更强措辞，或者还没写出 `same-world test`。
- 如果你只先判断“为什么安全与省 token 是同一条治理定价链”，从 [85-真正成熟的治理，不是更会拦截，而是更会为扩张定价.md](85-%E7%9C%9F%E6%AD%A3%E6%88%90%E7%86%9F%E7%9A%84%E6%B2%BB%E7%90%86%EF%BC%8C%E4%B8%8D%E6%98%AF%E6%9B%B4%E4%BC%9A%E6%8B%A6%E6%88%AA%EF%BC%8C%E8%80%8C%E6%98%AF%E6%9B%B4%E4%BC%9A%E4%B8%BA%E6%89%A9%E5%BC%A0%E5%AE%9A%E4%BB%B7.md) 进入。
  - 失败信号：还在把治理理解成权限门数、模式面板、token 百分比，或把 `Context Usage` 继续读成成本面板；还没把 `没有决策增益的检查也是免费扩张` 写成正式判断。
- 如果你只先判断“为什么源码质量首先服务当前真相保护”，从 [86-真正先进的内核，不是更会分层，而是更会阻止过去写坏现在.md](86-%E7%9C%9F%E6%AD%A3%E5%85%88%E8%BF%9B%E7%9A%84%E5%86%85%E6%A0%B8%EF%BC%8C%E4%B8%8D%E6%98%AF%E6%9B%B4%E4%BC%9A%E5%88%86%E5%B1%82%EF%BC%8C%E8%80%8C%E6%98%AF%E6%9B%B4%E4%BC%9A%E9%98%BB%E6%AD%A2%E8%BF%87%E5%8E%BB%E5%86%99%E5%9D%8F%E7%8E%B0%E5%9C%A8.md) 与 [87-真正成熟的源码质量判断，不是文件更小，而是复杂度中心合法、边界可证、下一次重构仍有路.md](87-%E7%9C%9F%E6%AD%A3%E6%88%90%E7%86%9F%E7%9A%84%E6%BA%90%E7%A0%81%E8%B4%A8%E9%87%8F%E5%88%A4%E6%96%AD%EF%BC%8C%E4%B8%8D%E6%98%AF%E6%96%87%E4%BB%B6%E6%9B%B4%E5%B0%8F%EF%BC%8C%E8%80%8C%E6%98%AF%E5%A4%8D%E6%9D%82%E5%BA%A6%E4%B8%AD%E5%BF%83%E5%90%88%E6%B3%95%E3%80%81%E8%BE%B9%E7%95%8C%E5%8F%AF%E8%AF%81%E3%80%81%E4%B8%8B%E4%B8%80%E6%AC%A1%E9%87%8D%E6%9E%84%E4%BB%8D%E6%9C%89%E8%B7%AF.md) 进入。
  - 失败信号：还在用目录观感、文件大小和热点体感代替时间保护与重构边界判断，或者还没分清 `truth ladder` 与 `failure semantics` 属于 architecture doctrine。
- 如果你只先判断“三条母线的哲学收束是不是已经成立”，以 [../09-三张控制面总图：世界进入模型、扩张定价与防过去写坏现在.md](../09-%E4%B8%89%E5%BC%A0%E6%8E%A7%E5%88%B6%E9%9D%A2%E6%80%BB%E5%9B%BE%EF%BC%9A%E4%B8%96%E7%95%8C%E8%BF%9B%E5%85%A5%E6%A8%A1%E5%9E%8B%E3%80%81%E6%89%A9%E5%BC%A0%E5%AE%9A%E4%BB%B7%E4%B8%8E%E9%98%B2%E8%BF%87%E5%8E%BB%E5%86%99%E5%9D%8F%E7%8E%B0%E5%9C%A8.md) 为宪法页，再用 `84-87` 校正三条母线。

## 这里不回答什么

- 本目录不负责展开完整跨目录执行链。
- 本目录不负责提供宿主接入、修复、值班与长期验证手册。
- 本目录也不负责失败样本与反例库；这些统一回 `navigation/README.md` 分流。
- 如果你还在问“现在到底该模仿什么”或“第一条反证信号是什么”，先回 `../navigation/05` 与 `../navigation/15`。

## 维护约定

- `philosophy/` 负责解释“为什么”，不替代 `architecture/` 的机制拆解和 `api/` 的协议定义。
- README 只保留判断式入口，不再展开长链路由。
- README 应优先暴露三条 frontdoor formula、`same-world test`、`truth ladder` 与 first reject signal，不重新退回对象库存页。
- README 只负责第一性原理前门，不和 `05 / 15 / 41` 抢高阶 judgment map 的职责。
- 需要跨目录执行链时，回到 [../navigation/README.md](../navigation/README.md)。
