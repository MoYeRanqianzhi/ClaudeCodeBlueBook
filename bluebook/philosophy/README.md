# 哲学专题

`philosophy/` 解释 Claude Code 为什么要这样设计，而不是仅仅罗列功能：为什么 `world entry / request assembly / six-stage assembly chain` 必须先成立，为什么治理要被写成统一定价，为什么源码质量首先服务当前真相保护。
如果你还没先经过 `09 / 05 / 15 / 41` 这组高阶前门，不要急着在这里直接下哲学判断。

如果把 `philosophy/` 前门再压成最短公式，只剩三条：

1. Prompt 线
   - `same-world compiler = Authority -> Boundary -> Transcript -> Lineage -> Continuation -> Explainability`
2. 治理线
   - `governance key -> externalized truth chain -> typed ask -> decision window -> continuation pricing -> durable-transient cleanup`
   - `Narrow / Later / Outside` 只是用户侧助记，不是第二套治理故事
3. 源码质量线
   - `contract -> registry -> current-truth surface -> consumer subset -> hotspot kernel -> mirror gap discipline`
   - `future maintainer = formal consumer`

这里还应再多记一句：

- `continuity` 不是第四条独立哲学母线；它是 Prompt `Continuation`、治理 `continuation pricing` 与源码质量 `recovery non-sovereignty / anti-zombie` 的共同时间轴。

这里还要再补一条纪律：

- `evidence gradient -> authority surface -> temporal honesty -> future maintainer rejectability` 这组句子只保留为解释层压缩句，不再和源码质量线 canonical ladder 并列抢 frontdoor 首答权。
- 真正进入 later maintainer 排查前，还应先过 `public artifact ceiling`，再回 `contract -> registry -> current-truth surface -> consumer subset -> hotspot kernel -> mirror gap discipline`。

如果继续把 `refactor capital` 压成更短的资本表，也只该剩：

- 单一 authority 未裂开
- 时间边界仍可说明
- seam 仍可继续抽离
- retreat layer 仍可点名

如果一页解释还没压到这三条，它就还停在对象层总结，不算最硬的第一性原理前门。

如果只先记 Prompt 前门的一句话，也只记这句：

- Prompt 的效力不在措辞，而在它先用 Authority 定义世界、用 Boundary 固定合法字节、用 Transcript 规定模型实际消费、用 Lineage 保住同一身份、用 Continuation 裁定还能否继续，并用 Explainability 把失稳点提前点名。
- 前五项才是 `world-entry / continue verdict` 的 witness set；`Explainability` 只拥有失稳命名权，没有改判权。
- 前门 shorthand 一旦落到排查，只认 `message_lineage_ref -> section_registry_ref -> stable_prefix_ref -> protocol_transcript_ref -> continuation_object_ref -> continue_qualification_verdict`；`CLAUDE.md / auto memory` 在官方文档里属于 advisory context，不是 enforced configuration，不能直接越位成 Authority witness。

如果只先记治理前门的一句话，也只记这句：

- 治理不是更会拦截，而是先由 governance key 外化当前真相，再给动作、可见性、上下文与 continuation 的一切扩张定价；安全、省 Token 与恢复都只是这条收费链的外观。

这里还要再多记一句：

- `governance key` 不只是第一环，而是后续收费权的主权对象；若这层退回 settings merge 或 mode 切换，后面的 `typed ask / decision window / continuation pricing / cleanup` 就只剩事后补救。

想继续沿 Prompt 母线下钻时，哲学层只认分工清楚的四条 route：

- `frontdoor appeal chain = 84 -> 63 -> 33`
- `mechanism deep dive = 84 -> 81`
- `collaboration interface = 57`
- `compat jump / one-screen mnemonic = 78`

也就是说：

- `84` 先回答世界如何合法进入模型
- `63` 只回答继续资格与时间轴
- `33` 只回答 Explainability 如何命名失稳
- `81` 只展开机制链
- `57` 只解释 `Transcript -> Lineage -> Continuation` 的协作接口
- `78` 只保留 Prompt 前门速记，不再和 `84` 并列争首答

想继续沿治理母线下钻时，哲学层最短跳转只认：

- `85 -> 64 / 82 -> 83 -> 100`

Prompt 线最短的 reject trio 也只认：

- `authority_blur`
- `transcript_conflation`
- `continuation_story_only`

治理线最短的 reject trio 也只认：

- `decision-window collapse`
- `projection usurpation`
- `free-expansion relapse`

## 什么时候进来

- 当你已经知道功能和机制存在，但还没回答“为什么必须这样设计”。
- 当你想把 `world entry / request assembly / six-stage assembly chain`、统一定价治理、当前真相保护，从做法解释压回不可约判断。
- 当你需要区分什么是实现、什么是约束、什么是迁移到别的 runtime 后仍成立的原则。
- 当你已经完成“模仿对象校正”和“失稳前追问”，准备把它们继续压成第一性原理。

## 如果你只先判断一件事

- 如果你只先判断“为什么 `world entry / request assembly / six-stage assembly chain` 不是文案技巧”，从 [84-世界如何合法进入模型：request assembly 与 six-stage assembly chain](<84-世界如何合法进入模型：request assembly 与 six-stage assembly chain.md>) 进入；缺机制展开再下潜到 [81-请求编译链：可缓存、可转写、可继续](<81-请求编译链：可缓存、可转写、可继续.md>)，缺时间轴再走 [63-Prompt 时间轴：先规定继续资格，再谈摘要连续性](<63-Prompt 时间轴：先规定继续资格，再谈摘要连续性.md>)，缺诊断命名再走 [33-Explainability只是Prompt的诊断命名层](<33-Explainability只是Prompt的诊断命名层.md>)。
  - 失败信号：还在把 Prompt 效力解释成更长 instruction 或更强措辞，或者前门还没有回到 `Authority / Boundary / Transcript / Lineage / Continuation / Explainability`。
- 如果你只先判断“为什么安全与省 token 是同一条治理定价链”，从 [85-真正成熟的治理，不是更会拦截，而是更会为扩张定价.md](85-%E7%9C%9F%E6%AD%A3%E6%88%90%E7%86%9F%E7%9A%84%E6%B2%BB%E7%90%86%EF%BC%8C%E4%B8%8D%E6%98%AF%E6%9B%B4%E4%BC%9A%E6%8B%A6%E6%88%AA%EF%BC%8C%E8%80%8C%E6%98%AF%E6%9B%B4%E4%BC%9A%E4%B8%BA%E6%89%A9%E5%BC%A0%E5%AE%9A%E4%BB%B7.md) 进入。
  - 失败信号：还在把治理理解成权限门数、模式面板、token 百分比，或把 `Context Usage` 继续读成成本面板；还没把 `governance key -> externalized truth chain -> typed ask -> decision window -> continuation pricing -> durable-transient cleanup` 写成正式判断。
- 如果你只先判断“为什么源码质量首先服务当前真相保护”，从 [86-真正先进的内核，不是更会分层，而是更会阻止过去写坏现在.md](86-%E7%9C%9F%E6%AD%A3%E5%85%88%E8%BF%9B%E7%9A%84%E5%86%85%E6%A0%B8%EF%BC%8C%E4%B8%8D%E6%98%AF%E6%9B%B4%E4%BC%9A%E5%88%86%E5%B1%82%EF%BC%8C%E8%80%8C%E6%98%AF%E6%9B%B4%E4%BC%9A%E9%98%BB%E6%AD%A2%E8%BF%87%E5%8E%BB%E5%86%99%E5%9D%8F%E7%8E%B0%E5%9C%A8.md) 与 [87-真正成熟的源码质量判断，不是文件更小，而是复杂度中心合法、边界可证、下一次重构仍有路.md](87-%E7%9C%9F%E6%AD%A3%E6%88%90%E7%86%9F%E7%9A%84%E6%BA%90%E7%A0%81%E8%B4%A8%E9%87%8F%E5%88%A4%E6%96%AD%EF%BC%8C%E4%B8%8D%E6%98%AF%E6%96%87%E4%BB%B6%E6%9B%B4%E5%B0%8F%EF%BC%8C%E8%80%8C%E6%98%AF%E5%A4%8D%E6%9D%82%E5%BA%A6%E4%B8%AD%E5%BF%83%E5%90%88%E6%B3%95%E3%80%81%E8%BE%B9%E7%95%8C%E5%8F%AF%E8%AF%81%E3%80%81%E4%B8%8B%E4%B8%80%E6%AC%A1%E9%87%8D%E6%9E%84%E4%BB%8D%E6%9C%89%E8%B7%AF.md) 进入。
  - 失败信号：还在用目录观感、文件大小和热点体感代替 `evidence gradient / authority surface / temporal honesty / future maintainer rejectability`，或者还没分清这些判据属于 architecture doctrine。
- 如果你只先判断“为什么 future maintainer 不只是读者，而是正式消费者”，从 [80-真正先进的源码，会先替未来维护者保留反对当前实现的能力.md](80-%E7%9C%9F%E6%AD%A3%E5%85%88%E8%BF%9B%E7%9A%84%E6%BA%90%E7%A0%81%EF%BC%8C%E4%BC%9A%E5%85%88%E6%9B%BF%E6%9C%AA%E6%9D%A5%E7%BB%B4%E6%8A%A4%E8%80%85%E4%BF%9D%E7%95%99%E5%8F%8D%E5%AF%B9%E5%BD%93%E5%89%8D%E5%AE%9E%E7%8E%B0%E7%9A%84%E8%83%BD%E5%8A%9B.md)、[59-源码先进性不在静态分层，而在未来维护者也是正式消费者.md](59-%E6%BA%90%E7%A0%81%E5%85%88%E8%BF%9B%E6%80%A7%E4%B8%8D%E5%9C%A8%E9%9D%99%E6%80%81%E5%88%86%E5%B1%82%EF%BC%8C%E8%80%8C%E5%9C%A8%E6%9C%AA%E6%9D%A5%E7%BB%B4%E6%8A%A4%E8%80%85%E4%B9%9F%E6%98%AF%E6%AD%A3%E5%BC%8F%E6%B6%88%E8%B4%B9%E8%80%85.md) 与 [53-好架构不是更会重构，而是始终保留重构可能性.md](53-%E5%A5%BD%E6%9E%B6%E6%9E%84%E4%B8%8D%E6%98%AF%E6%9B%B4%E4%BC%9A%E9%87%8D%E6%9E%84%EF%BC%8C%E8%80%8C%E6%98%AF%E5%A7%8B%E7%BB%88%E4%BF%9D%E7%95%99%E9%87%8D%E6%9E%84%E5%8F%AF%E8%83%BD%E6%80%A7.md) 进入，再回 [87-真正成熟的源码质量判断，不是文件更小，而是复杂度中心合法、边界可证、下一次重构仍有路.md](87-%E7%9C%9F%E6%AD%A3%E6%88%90%E7%86%9F%E7%9A%84%E6%BA%90%E7%A0%81%E8%B4%A8%E9%87%8F%E5%88%A4%E6%96%AD%EF%BC%8C%E4%B8%8D%E6%98%AF%E6%96%87%E4%BB%B6%E6%9B%B4%E5%B0%8F%EF%BC%8C%E8%80%8C%E6%98%AF%E5%A4%8D%E6%9D%82%E5%BA%A6%E4%B8%AD%E5%BF%83%E5%90%88%E6%B3%95%E3%80%81%E8%BE%B9%E7%95%8C%E5%8F%AF%E8%AF%81%E3%80%81%E4%B8%8B%E4%B8%80%E6%AC%A1%E9%87%8D%E6%9E%84%E4%BB%8D%E6%9C%89%E8%B7%AF.md) 收束到质量门槛。
  - 失败信号：还在把 later maintainer 写成“最后能看懂的人”，而不是拥有局部可反对性、第一退回层与重构资本的人。
- 如果你只先判断“为什么 continuity system 不是命令集合，而是三条母线在时间维度的交汇”，先走 [81-请求编译链：可缓存、可转写、可继续](<81-请求编译链：可缓存、可转写、可继续.md>) -> [85-真正成熟的治理，不是更会拦截，而是更会为扩张定价.md](<85-真正成熟的治理，不是更会拦截，而是更会为扩张定价.md>) -> [80-真正先进的源码，会先替未来维护者保留反对当前实现的能力.md](<80-真正先进的源码，会先替未来维护者保留反对当前实现的能力.md>)。
  - 失败信号：还在把 continuity 理解成 `/compact / /resume / /memory` 的按钮并排，而不是 `Continuation / continuation pricing / anti-zombie` 的共同制度面。
- 如果你只先判断“三条母线的哲学收束是不是已经成立”，以 [../09-三张控制面总图：世界进入模型、扩张定价与防过去写坏现在.md](../09-%E4%B8%89%E5%BC%A0%E6%8E%A7%E5%88%B6%E9%9D%A2%E6%80%BB%E5%9B%BE%EF%BC%9A%E4%B8%96%E7%95%8C%E8%BF%9B%E5%85%A5%E6%A8%A1%E5%9E%8B%E3%80%81%E6%89%A9%E5%BC%A0%E5%AE%9A%E4%BB%B7%E4%B8%8E%E9%98%B2%E8%BF%87%E5%8E%BB%E5%86%99%E5%9D%8F%E7%8E%B0%E5%9C%A8.md) 为宪法页，再用 `84-87` 校正三条母线。

## 这里不回答什么

- 本目录不负责展开完整跨目录执行链。
- 本目录不负责提供宿主接入、修复、值班与长期验证手册。
- 本目录也不负责失败样本与反例库；这些统一回 `navigation/README.md` 分流。
- 如果你还在问“现在到底该模仿什么”或“第一条反证信号是什么”，先回 `../navigation/05` 与 `../navigation/15`。

## 维护约定

- `philosophy/` 负责解释“为什么”，不替代 `architecture/` 的机制拆解和 `api/` 的协议定义。
- README 只保留判断式入口，不再展开长链路由。
- README 应优先暴露三条 frontdoor formula、最短 first reject signal 与 later maintainer 可直接复用的判断主语，不重新退回对象库存页。
- README 只负责第一性原理前门，不和 `05 / 15 / 41` 抢高阶 judgment map 的职责。
- 需要跨目录执行链时，回到 [../navigation/README.md](../navigation/README.md)。
