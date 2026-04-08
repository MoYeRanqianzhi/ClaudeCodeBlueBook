# 安全专题索引

`security/` 当前有 328 篇正文，范围 `00-327`；`appendix/` 当前有 311 篇速查文档；`source-notes/` 当前有 178 篇源码剖面。

`security/` 研究的不是“规则越多越安全”，而是动作、权威、上下文与时间四种扩张如何被同一条治理秩序收费，以及弱 signer 为什么永远不配越级冒充强 signer。
更短地说：安全与省 token 在这里保护的是同一个 model-reachable world；前者阻止免费危险扩张，后者阻止免费昂贵扩张。
如果你还没先经过 `09 / 05 / 15 / 41` 这组高阶前门顺序，不要急着把安全页读成另一套规则堆。
`security/` 内部也继续继承 `问题分型 -> 工作对象 -> 控制面 -> 入口`：先判这次在失真的到底是 signer、ledger 还是 cleanup 工作对象，再判它卡在治理收费链的哪一段，最后才决定读机制前门、速查表、源码证据簇还是具体编号正文。

本目录研究 Claude Code 的分层安全控制面：来源主权、权限模式、外部能力收口、恢复语义、能力发布、状态编辑、签字权分层，以及从 `receipt -> completion -> finality -> forgetting -> liability release -> archive close -> audit close -> irreversible erasure -> retention -> honesty -> isolation -> constitution -> rationale -> metadata -> runtime-conformance -> anti-drift verification -> repair -> migration -> sunset -> tombstone ...` 一路推进到 stronger-request cleanup 家族的同构治理链。

如果只先记安全入口判定的一句话，也只记这句：

- 这不是第二套安全故事，而是同一条 `governance key -> externalized truth chain -> typed ask -> decision window -> continuation pricing -> durable-transient cleanup` 收费链在安全目录里的机制翻译。

如果你只缺治理收费链的一屏速记，而不是安全侧机制翻译，先回 [../10-治理收费链入口卡：四类被收费资源、reject trio 与弱读回面](../10-%E6%B2%BB%E7%90%86%E6%94%B6%E8%B4%B9%E9%93%BE%E5%85%A5%E5%8F%A3%E5%8D%A1%EF%BC%9A%E5%9B%9B%E7%B1%BB%E8%A2%AB%E6%94%B6%E8%B4%B9%E8%B5%84%E6%BA%90%E3%80%81reject%20trio%20%E4%B8%8E%E5%BC%B1%E8%AF%BB%E5%9B%9E%E9%9D%A2.md)；`security/` 只保留 signer / ledger / cleanup authority 的安全侧翻译。

这里还应再多记一句：

- `continuity` 在安全目录里也不是第四类安全主题；它只是 `decision window -> continuation pricing -> durable-transient cleanup` 这段时间轴在安全侧的继续资格与清算资格。

## 先记四句

- 安全不是单点沙箱，也不是单点分类器；它是同一条 `governance key -> externalized truth chain -> typed ask -> decision window -> continuation pricing -> durable-transient cleanup` 在 signer authority、truth-surface attestation、ask arbitration、continuation pricing 与 cleanup authority 上的安全侧翻译。
- `governance key -> externalized truth chain -> typed ask -> decision window -> continuation pricing -> durable-transient cleanup` 不是两条结果词前门的拼接，而是同一条治理收费链。
- 完成、终局、遗忘、清理与家族级 cleanup 都各有 signer；任何弱层都不配替强层宣布“已经没事了”。
- 宿主不该自己从事件流回放拼当前真相；更稳的做法是消费 runtime 已外化的 truth-surface / decision window / cleanup stage verdict。
- 任何 user-facing 状态与诊断入口，都只配读取已外化的 truth-surface、decision window 与 cleanup stage verdict，不配定义治理真相或继续资格。
- 压缩入口只配做 continuation consumer；导出与用户侧恢复读法统一回 `risk/`，不在这里冒充 signer 链。
- `/status / /doctor / /usage`、approval UI、summary 与 dashboard 都只配做 weak readback surface：它们只能触发怀疑、做二跳或读取已外化 verdict，不配越级充当 signer。
- `Compact / Resume / Memory` 只配做 continuation consumer，不是 weak readback surface；cleanup tail evidence 与用户侧恢复读法统一回 `risk/`。
- 弱读回面之所以必须弱，不是因为信息少，而是因为一旦被误读成 signer，observability 就会反向偷权，重新长出新的免费扩张通道。
- 弱读回面一旦代签，observability 就不再是 consumer，而会长成第二个 same-world compiler / host-truth source；这不是读回增厚，而是 current truth 分叉。
- 弱读回面不能代签的根因，也不是权限不够，而是它们不持有 `verdict seam`，也不承担 rollback / residual liability。
- `shared_consumer_surface` 只表示不同 reader 是否仍在只读消费同一个 verdict object，不表示谁拥有 current truth；projection 字段层继续回 `appendix/87`，reprojection 分层继续回 `appendix/159`。
- consumer surface 可以多 reader、多 dialect 并存；signer surface 不能。否则不同宿主投影会把同一 verdict 再撕成多个当前真相。
- 这里说的 `cleanup stage verdict` 只表示前门层可见的 cleanup 读回，不自动等于更深层的 unified runtime-conformance receipt 或 future-readable finality；若要判断那条更强 signer 链，继续回深页 signer 分层。

如果把安全前门继续压成最短公式，也只剩三条：

1. `governance key -> externalized truth chain -> typed ask`
   - 谁配改边界、谁配宣布当前治理真相、哪些扩张必须先协商
2. `decision window -> continuation pricing`
   - 当前扩张还配不配继续，继续是否仍值得付费
3. `durable-transient cleanup`
   - 哪些 transient authority 必须清退，哪些 durable asset 还能继续被承认

如果继续把这条机制链再压成跨宿主都能对照的三段顺序，也只该再补一句：

- 先判 `pricing-right / truth-surface`
- 再判 `typed ask / sandbox`
- 最后才判 `decision window / continuation pricing / durable-transient cleanup`

如果继续把 `security/` 的目录发言权也压成最短公式，也只该剩三句：

1. `signer / ledger / cleanup authority`
   - 谁配签字、谁只配记账、谁只配收口。
2. `governance mechanism speaking right`
   - 哪条 signer / verdict / liability 机制在安全侧被看清。
3. `no user-side mechanism override`
   - 用户侧误伤、恢复与入口语义差不在这里第一次定义机制主语。

如果一个安全判断还压不回这三条，它就还停在规则堆或工具堆层。
如果一个安全判断还答不上“它保护的到底是哪种工作对象、哪段收费链、哪个入口只是证据层 consumer”，就说明它还没压回第一性原理。

## 高阶前门

想先抓第一性原理，不要从安全目录库存开始：

- [../09-三张控制面总图：世界进入模型、扩张定价与防过去写坏现在.md](../09-%E4%B8%89%E5%BC%A0%E6%8E%A7%E5%88%B6%E9%9D%A2%E6%80%BB%E5%9B%BE%EF%BC%9A%E4%B8%96%E7%95%8C%E8%BF%9B%E5%85%A5%E6%A8%A1%E5%9E%8B%E3%80%81%E6%89%A9%E5%BC%A0%E5%AE%9A%E4%BB%B7%E4%B8%8E%E9%98%B2%E8%BF%87%E5%8E%BB%E5%86%99%E5%9D%8F%E7%8E%B0%E5%9C%A8.md)
  第二张图先回答“扩张如何被定价”。
- [治理收费链为什么不是两套优化](../philosophy/19-%E5%AE%89%E5%85%A8%E4%B8%8EToken%E7%BB%8F%E6%B5%8E%E4%B8%8D%E6%98%AF%E6%9D%83%E8%A1%A1%E8%80%8C%E6%98%AF%E5%90%8C%E4%B8%80%E4%BC%98%E5%8C%96.md)
  看为什么治理收费链在动作、上下文与时间三面是同一优化。
- [扩张定价为什么会投影成安全、成本与体验](../philosophy/22-%E5%AE%89%E5%85%A8%E3%80%81%E6%88%90%E6%9C%AC%E4%B8%8E%E4%BD%93%E9%AA%8C%E5%BF%85%E9%A1%BB%E5%85%B1%E7%94%A8%E9%A2%84%E7%AE%97%E5%99%A8.md)
  看为什么这些可见外观不是第三个独立目标，而只是这条治理收费链的投影。
- [为什么“统一预算器”还不够](../philosophy/61-%E7%9C%9F%E6%AD%A3%E6%88%90%E7%86%9F%E7%9A%84%E5%AE%89%E5%85%A8%E4%B8%8E%E7%9C%81Token%E7%B3%BB%E7%BB%9F%EF%BC%8C%E4%B8%8D%E6%98%AF%E7%BB%9F%E4%B8%80%E9%A2%84%E7%AE%97%E5%99%A8%EF%BC%8C%E8%80%8C%E6%98%AF%E6%B2%BB%E7%90%86%E9%A1%BA%E5%BA%8F%E3%80%81%E5%A4%B1%E8%B4%A5%E8%AF%AD%E4%B9%89%E4%B8%8E%E5%8F%AF%E6%92%A4%E9%94%80%E8%87%AA%E5%8A%A8%E5%8C%96.md)
  看为什么安全与省 token 共享的是同一条秩序，而不是同一个单点预算器。
- [architecture/83：反扩张治理流水线](../architecture/83-%E5%8F%8D%E6%89%A9%E5%BC%A0%E6%B2%BB%E7%90%86%E6%B5%81%E6%B0%B4%E7%BA%BF%EF%BC%9Atrusted%20inputs%E3%80%81distributed%20ask%20arbitration%E3%80%81deferred%20visibility%E4%B8%8Econtinuation%20pricing.md)
  看治理控制面如何把 `governance key`、`externalized truth chain`、`typed ask`、`decision window`、`continuation pricing` 与 `durable-vs-transient cleanup` 写成同一条流水线。
- 若已确认自己缺的是 signer / projection / cleanup 不对称，按 `43 -> 49 -> 127 -> 134 -> 157` 继续下潜，而不要把这些机制读成彼此独立的安全专题。

## 核心判断

- Claude Code 的安全性不是单点沙箱，也不是单点分类器，而是一套分层 signer、ledger 与 lifecycle control plane。
- 真正重要的不是把能力做得尽量小，而是让能力、声明、恢复权和清理权只能沿着正确边界流动。
- `147-312` 这一整段已经证明：弱层只能说明局部事实，强层才有权宣布更高阶治理结果；任何弱层都不能越级冒充强层。
- 宿主如果绕过 runtime 已外化的 authority / status / verdict，自行从事件流回放拼“当前真相”，就会把安全控制面重新降成脆弱的局部推断。

## 什么时候进来

- 当你已经知道统一定价治理成立，但还没回答 signer、ledger 与 cleanup 责任究竟落在哪些对象上。
- 当你需要判断哪种扩张该被 ask、哪种 truth 必须外化、哪种 cleanup 不配越级宣布终局。
- 当你需要把“安全”和“省 token”继续压成同一治理纪律，而不是并列专题。
- 当你需要把 user-facing 的 runtime readback consumer 与 continuation consumer 退回它们各自只配消费的治理阶段，而不是再让 projection 词或 consumer 词冒充治理主语。
- 当你需要判断哪个对象只是弱读回面、哪个对象仍保留 signer authority，以及 cleanup 之后谁还配留下 reopen liability。

## 如果你只先判断一件事

- 如果你只先判断“哪种 signer 有资格改边界”，从 `00-29` 进入。失败信号：还在把 classifier、mode、allow 规则或单点沙箱当成最终主权。
- 如果你只先判断“哪条真相链必须被宿主承认”，从 `30-138` 进入。失败信号：还在让宿主从事件流、usage 条或局部 status 自己回放拼治理真相。
- 如果你只先判断“cleanup 与 forgetting 为什么不能混成一个结果词”，从 `147-312` 进入。失败信号：还在把完成、终局、遗忘、清理写成一个“已经没事了”的总结果。

## 目录分层

- `00-17`：研究方法、总论、权限/沙箱、配置与受管环境、统一安全控制台导读。
- `18-29`：检测内核、控制台字段与卡片、宿主资格、对象协议与显式降级。
- `30-69`：真相源、账本、恢复闭环、清理纪律、词法、租约与 failure path。
- `70-99`：能力发布、状态编辑、恢复资格、默认路由与 reject semantics。
- `100-138`：完成权、字段生命周期、工程迁移、验证架构与制度化接口。
- `139-312`：cleanup 契约与 signer/governor ladder，含 stronger-request cleanup 的 runtime-conformance、anti-drift、repair、migration、sunset、tombstone、resurrection、re-entitlement、reconfiguration、reactivation、readiness、continuity、recovery、reintegration、reprojection、reassurance、use-time revalidation、step-up reauthorization、continuation、completion、finality、forgetting、liability-release、archive-close、audit-close、irreversible-erasure、retention-governance、retention-enforcement-honesty、cleanup-isolation、cleanup-constitution、cleanup-rationale、cleanup-metadata、cleanup-runtime-conformance、cleanup-anti-drift-verification、cleanup-repair、cleanup-migration、cleanup-sunset、cleanup-tombstone、cleanup-resurrection、cleanup-re-entitlement、cleanup-reconfiguration、cleanup-reactivation、cleanup-readiness、cleanup-continuity、cleanup-recovery、cleanup-reintegration、cleanup-reprojection、cleanup-reassurance、cleanup-use-time revalidation、cleanup-step-up reauthorization、cleanup-continuation、cleanup-completion、cleanup-finality、cleanup-forgetting、cleanup-liability-release、cleanup-archive-close、cleanup-audit-close、cleanup-irreversible-erasure、cleanup-retention-governance、cleanup-retention-enforcement-honesty、cleanup-cleanup-isolation、cleanup-cleanup-constitution、cleanup-cleanup-rationale、cleanup-cleanup-metadata、cleanup-cleanup-runtime-conformance、cleanup-cleanup-anti-drift-verification、cleanup-cleanup-repair、cleanup-cleanup-migration、cleanup-cleanup-sunset、cleanup-cleanup-tombstone、cleanup-cleanup-resurrection、cleanup-cleanup-re-entitlement、cleanup-cleanup-reconfiguration、cleanup-cleanup-reactivation、cleanup-cleanup-readiness、cleanup-cleanup-continuity、cleanup-cleanup-recovery、cleanup-cleanup-reintegration、cleanup-cleanup-reprojection、cleanup-cleanup-reassurance、cleanup-cleanup-use-time revalidation、cleanup-cleanup-step-up reauthorization、cleanup-cleanup-continuation、cleanup-cleanup-completion、cleanup-cleanup-finality、cleanup-cleanup-forgetting、cleanup-cleanup-liability-release、cleanup-cleanup-archive-close 等高阶治理分层。

更稳的 first reject signal 还应先记三条：

1. `Context Usage`、mode 条和 token UI 开始冒充治理真相
2. cleanup 结果词开始越级替 signer 和 verdict 说话
3. `Later / Outside`、default continuation 或全量可见重新让免费扩张复活

## 继续下潜时

- 只按对象 handoff 继续：来源主权、能力边界与显式降级看 `00-29`；当前真相、账本与 failure semantics 看 `30-138`；`receipt -> completion -> finality -> forgetting` 与 cleanup ladder 看 `147-224`。
- 只按证据层 handoff 回跳：字段矩阵与速查表回 [appendix/README.md](appendix/README.md)，源码证据簇回 [source-notes/README.md](source-notes/README.md)，长期记忆与目录治理回 [../../docs/development/security/README.md](../../docs/development/security/README.md)。
- 想看来源主权、权限模式、能力边界与显式降级：从 `00-29` 进入。
- 想看当前真相、账本、恢复闭环、状态编辑与 failure semantics：从 `30-138` 进入。
- 想看 signer ladder 从 `receipt -> completion -> finality -> forgetting`：从 `147-166` 进入。
- 想看 artifact-family cleanup ladder：从 `167-196` 进入。
- 想看 stronger-request cleanup ladder 与更高阶 continuation / completion / finality / forgetting / constitution governor：从 `197-312` 进入。

## 推荐入口

- [00-研究方法与可信边界](00-研究方法与可信边界.md)
- [01-安全总论：Claude Code 不是单点沙箱，而是分层安全控制面](01-%E5%AE%89%E5%85%A8%E6%80%BB%E8%AE%BA%EF%BC%9AClaude%20Code%20%E4%B8%8D%E6%98%AF%E5%8D%95%E7%82%B9%E6%B2%99%E7%AE%B1%EF%BC%8C%E8%80%8C%E6%98%AF%E5%88%86%E5%B1%82%E5%AE%89%E5%85%A8%E6%8E%A7%E5%88%B6%E9%9D%A2.md)
- [14-安全控制面总图：从 trust 到 entitlement 的全链结构图谱](14-%E5%AE%89%E5%85%A8%E6%8E%A7%E5%88%B6%E9%9D%A2%E6%80%BB%E5%9B%BE%EF%BC%9A%E4%BB%8E%20trust%20%E5%88%B0%20entitlement%20%E7%9A%84%E5%85%A8%E9%93%BE%E7%BB%93%E6%9E%84%E5%9B%BE%E8%B0%B1.md)
- [116-安全工程迁移路线图：为什么这份研究版源码若要走向可持续验证系统，必须先固化边界，再分阶段迁移而不能一次性重构](116-安全工程迁移路线图：为什么这份研究版源码若要走向可持续验证系统，必须先固化边界，再分阶段迁移而不能一次性重构.md)
- [147-安全回执签字权：为什么receipt只能由持有pending ledger、schema context与lifecycle closure的signer签发](147-%E5%AE%89%E5%85%A8%E5%9B%9E%E6%89%A7%E7%AD%BE%E5%AD%97%E6%9D%83%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88receipt%E5%8F%AA%E8%83%BD%E7%94%B1%E6%8C%81%E6%9C%89pending%20ledger%E3%80%81schema%20context%E4%B8%8Elifecycle%20closure%E7%9A%84signer%E7%AD%BE%E5%8F%91.md)
- [229-安全载体家族强请求清理迁移治理与强请求清理退役治理分层：为什么artifact-family cleanup stronger-request cleanup-migration-governor signer不能越级冒充artifact-family cleanup stronger-request cleanup-sunset-governor signer](229-安全载体家族强请求清理迁移治理与强请求清理退役治理分层.md)
- [230-安全载体家族强请求清理退役治理与强请求清理墓碑治理分层：为什么artifact-family cleanup stronger-request cleanup-sunset-governor signer不能越级冒充artifact-family cleanup stronger-request cleanup-tombstone-governor signer](230-安全载体家族强请求清理退役治理与强请求清理墓碑治理分层.md)
- [231-安全载体家族强请求清理墓碑治理与强请求清理复活治理分层：为什么artifact-family cleanup stronger-request cleanup-tombstone-governor signer不能越级冒充artifact-family cleanup stronger-request cleanup-resurrection-governor signer](231-安全载体家族强请求清理墓碑治理与强请求清理复活治理分层.md)
- [232-安全载体家族强请求清理复活治理与强请求清理再赋权治理分层：为什么artifact-family cleanup stronger-request cleanup-resurrection-governor signer不能越级冒充artifact-family cleanup stronger-request cleanup-re-entitlement-governor signer](232-安全载体家族强请求清理复活治理与强请求清理再赋权治理分层.md)
- [233-安全载体家族强请求清理再赋权治理与强请求清理重配置治理分层：为什么artifact-family cleanup stronger-request cleanup-re-entitlement-governor signer不能越级冒充artifact-family cleanup stronger-request cleanup-reconfiguration-governor signer](233-安全载体家族强请求清理再赋权治理与强请求清理重配置治理分层.md)
- [234-安全载体家族强请求清理重配置治理与强请求清理重新激活治理分层：为什么artifact-family cleanup stronger-request cleanup-reconfiguration-governor signer不能越级冒充artifact-family cleanup stronger-request cleanup-reactivation-governor signer](234-安全载体家族强请求清理重配置治理与强请求清理重新激活治理分层.md)
- [235-安全载体家族强请求清理重新激活治理与强请求清理就绪治理分层：为什么artifact-family cleanup stronger-request cleanup-reactivation-governor signer不能越级冒充artifact-family cleanup stronger-request cleanup-readiness-governor signer](235-安全载体家族强请求清理重新激活治理与强请求清理就绪治理分层.md)
- [236-安全载体家族强请求清理就绪治理与强请求清理连续性治理分层：为什么artifact-family cleanup stronger-request cleanup-readiness-governor signer不能越级冒充artifact-family cleanup stronger-request cleanup-continuity-governor signer](236-安全载体家族强请求清理就绪治理与强请求清理连续性治理分层.md)
- [237-安全载体家族强请求清理连续性治理与强请求清理恢复治理分层：为什么artifact-family cleanup stronger-request cleanup-continuity-governor signer不能越级冒充artifact-family cleanup stronger-request cleanup-recovery-governor signer](237-安全载体家族强请求清理连续性治理与强请求清理恢复治理分层.md)
- [238-安全载体家族强请求清理恢复治理与强请求清理重新并入治理分层：为什么artifact-family cleanup stronger-request cleanup-recovery-governor signer不能越级冒充artifact-family cleanup stronger-request cleanup-reintegration-governor signer](238-安全载体家族强请求清理恢复治理与强请求清理重新并入治理分层.md)
- [239-安全载体家族强请求清理重新并入治理与强请求清理重新投影治理分层：为什么artifact-family cleanup stronger-request cleanup-reintegration-governor signer不能越级冒充artifact-family cleanup stronger-request cleanup-reprojection-governor signer](239-安全载体家族强请求清理重新并入治理与强请求清理重新投影治理分层.md)
- [240-安全载体家族强请求清理重新投影治理与强请求清理重新担保治理分层：为什么artifact-family cleanup stronger-request cleanup-reprojection-governor signer不能越级冒充artifact-family cleanup stronger-request cleanup-reassurance-governor signer](240-安全载体家族强请求清理重新投影治理与强请求清理重新担保治理分层.md)
- [241-安全载体家族强请求清理重新担保治理与强请求清理用时重验证治理分层：为什么artifact-family cleanup stronger-request cleanup-reassurance-governor signer不能越级冒充artifact-family cleanup stronger-request cleanup-use-time-revalidation-governor signer](241-安全载体家族强请求清理重新担保治理与强请求清理用时重验证治理分层.md)
- [242-安全载体家族强请求清理用时重验证治理与强请求清理step-up重授权治理分层：为什么artifact-family cleanup stronger-request cleanup-use-time revalidation-governor signer不能越级冒充artifact-family cleanup stronger-request cleanup-step-up reauthorization-governor signer](242-安全载体家族强请求清理用时重验证治理与强请求清理step-up重授权治理分层.md)
- [243-安全载体家族强请求清理step-up重授权治理与强请求清理续打治理分层：为什么artifact-family cleanup stronger-request cleanup-step-up reauthorization-governor signer不能越级冒充artifact-family cleanup stronger-request continuation-governor signer](243-安全载体家族强请求清理step-up重授权治理与强请求清理续打治理分层.md)
- [244-安全载体家族强请求清理续打治理与强请求清理完成治理分层：为什么artifact-family cleanup stronger-request continuation-governor signer不能越级冒充artifact-family cleanup stronger-request completion-governor signer](244-安全载体家族强请求清理续打治理与强请求清理完成治理分层.md)
- [245-安全载体家族强请求清理完成治理与强请求清理终局治理分层：为什么artifact-family cleanup stronger-request completion-governor signer不能越级冒充artifact-family cleanup stronger-request finality-governor signer](245-安全载体家族强请求清理完成治理与强请求清理终局治理分层.md)
- [246-安全载体家族强请求清理终局治理与强请求清理遗忘治理分层：为什么artifact-family cleanup stronger-request finality-governor signer不能越级冒充artifact-family cleanup stronger-request forgetting-governor signer](246-安全载体家族强请求清理终局治理与强请求清理遗忘治理分层.md)
- [247-安全载体家族强请求清理遗忘治理与强请求清理免责释放治理分层：为什么artifact-family cleanup stronger-request forgetting-governor signer不能越级冒充artifact-family cleanup stronger-request liability-release-governor signer](247-安全载体家族强请求清理遗忘治理与强请求清理免责释放治理分层.md)
- [248-安全载体家族强请求清理免责释放治理与强请求清理归档关闭治理分层：为什么artifact-family cleanup stronger-request liability-release-governor signer不能越级冒充artifact-family cleanup stronger-request archive-close-governor signer](248-安全载体家族强请求清理免责释放治理与强请求清理归档关闭治理分层.md)
- [249-安全载体家族强请求清理归档关闭治理与强请求清理审计关闭治理分层：为什么artifact-family cleanup stronger-request archive-close-governor signer不能越级冒充artifact-family cleanup stronger-request audit-close-governor signer](249-安全载体家族强请求清理归档关闭治理与强请求清理审计关闭治理分层.md)
- [250-安全载体家族强请求清理审计关闭治理与强请求清理不可逆擦除治理分层：为什么artifact-family cleanup stronger-request audit-close-governor signer不能越级冒充artifact-family cleanup stronger-request irreversible-erasure-governor signer](250-安全载体家族强请求清理审计关闭治理与强请求清理不可逆擦除治理分层.md)
- [251-安全载体家族强请求清理不可逆擦除治理与强请求清理保留期治理分层：为什么artifact-family cleanup stronger-request irreversible-erasure-governor signer不能越级冒充artifact-family cleanup stronger-request retention-governor signer](251-安全载体家族强请求清理不可逆擦除治理与强请求清理保留期治理分层.md)
- [252-安全载体家族强请求清理保留期治理与强请求清理保留期执行诚实性治理分层：为什么artifact-family cleanup stronger-request retention-governor signer不能越级冒充artifact-family cleanup stronger-request retention-enforcement-honesty-governor signer](252-安全载体家族强请求清理保留期治理与强请求清理保留期执行诚实性治理分层.md)
- [253-安全载体家族强请求清理保留期执行诚实性治理与强请求清理隔离治理分层：为什么artifact-family cleanup stronger-request retention-enforcement-honesty-governor signer不能越级冒充artifact-family cleanup stronger-request cleanup-isolation-governor signer](253-安全载体家族强请求清理保留期执行诚实性治理与强请求清理隔离治理分层.md)
- [254-安全载体家族强请求清理隔离治理与强请求清理家族宪法治理分层：为什么artifact-family cleanup stronger-request cleanup-isolation-governor signer不能越级冒充artifact-family cleanup stronger-request cleanup-constitution-governor signer](254-安全载体家族强请求清理隔离治理与强请求清理家族宪法治理分层.md)
- [255-安全载体家族强请求清理家族宪法治理与强请求清理制度理由治理分层：为什么artifact-family cleanup stronger-request cleanup-constitution-governor signer不能越级冒充artifact-family cleanup stronger-request cleanup-rationale-governor signer](255-安全载体家族强请求清理家族宪法治理与强请求清理制度理由治理分层.md)
- [256-安全载体家族强请求清理制度理由治理与强请求清理制度元数据治理分层：为什么artifact-family cleanup stronger-request cleanup-rationale-governor signer不能越级冒充artifact-family cleanup stronger-request cleanup-metadata-governor signer](256-安全载体家族强请求清理制度理由治理与强请求清理制度元数据治理分层.md)
- [257-安全载体家族强请求清理制度元数据治理与强请求清理运行时符合性治理分层：为什么artifact-family cleanup stronger-request cleanup-metadata-governor signer不能越级冒充artifact-family cleanup stronger-request cleanup-runtime-conformance-governor signer](257-安全载体家族强请求清理制度元数据治理与强请求清理运行时符合性治理分层.md)
- [258-安全载体家族强请求清理运行时符合性治理与强请求清理反漂移验证治理分层：为什么artifact-family cleanup stronger-request cleanup-runtime-conformance-governor signer不能越级冒充artifact-family cleanup stronger-request cleanup-anti-drift-verifier signer](258-安全载体家族强请求清理运行时符合性治理与强请求清理反漂移验证治理分层.md)
- [259-安全载体家族强请求清理反漂移验证治理与强请求清理修复治理分层：为什么artifact-family cleanup stronger-request cleanup-anti-drift-verifier signer不能越级冒充artifact-family cleanup stronger-request cleanup-repair-governor signer](259-安全载体家族强请求清理反漂移验证治理与强请求清理修复治理分层.md)
- [260-安全载体家族强请求清理修复治理与强请求清理迁移治理分层：为什么artifact-family cleanup stronger-request cleanup-repair-governor signer不能越级冒充artifact-family cleanup stronger-request cleanup-migration-governor signer](260-安全载体家族强请求清理修复治理与强请求清理迁移治理分层.md)
- [261-安全载体家族强请求清理迁移治理与强请求清理退役治理分层：为什么artifact-family cleanup stronger-request cleanup-migration-governor signer不能越级冒充artifact-family cleanup stronger-request cleanup-sunset-governor signer](261-安全载体家族强请求清理迁移治理与强请求清理退役治理分层.md)
- [262-安全载体家族强请求清理退役治理与强请求清理墓碑治理分层：为什么artifact-family cleanup stronger-request cleanup-sunset-governor signer不能越级冒充artifact-family cleanup stronger-request cleanup-tombstone-governor signer](262-安全载体家族强请求清理退役治理与强请求清理墓碑治理分层.md)
- [263-安全载体家族强请求清理墓碑治理与强请求清理复活治理分层：为什么artifact-family cleanup stronger-request cleanup-tombstone-governor signer不能越级冒充artifact-family cleanup stronger-request cleanup-resurrection-governor signer](263-安全载体家族强请求清理墓碑治理与强请求清理复活治理分层.md)
- [264-安全载体家族强请求清理复活治理与强请求清理再赋权治理分层：为什么artifact-family cleanup stronger-request cleanup-resurrection-governor signer不能越级冒充artifact-family cleanup stronger-request cleanup-re-entitlement-governor signer](264-安全载体家族强请求清理复活治理与强请求清理再赋权治理分层.md)
- [265-安全载体家族强请求清理再赋权治理与强请求清理重配置治理分层：为什么artifact-family cleanup stronger-request cleanup-re-entitlement-governor signer不能越级冒充artifact-family cleanup stronger-request cleanup-reconfiguration-governor signer](265-安全载体家族强请求清理再赋权治理与强请求清理重配置治理分层.md)
- [266-安全载体家族强请求清理重配置治理与强请求清理重新激活治理分层：为什么artifact-family cleanup stronger-request cleanup-reconfiguration-governor signer不能越级冒充artifact-family cleanup stronger-request cleanup-reactivation-governor signer](266-安全载体家族强请求清理重配置治理与强请求清理重新激活治理分层.md)
- [267-安全载体家族强请求清理重新激活治理与强请求清理就绪治理分层：为什么artifact-family cleanup stronger-request cleanup-reactivation-governor signer不能越级冒充artifact-family cleanup stronger-request cleanup-readiness-governor signer](267-安全载体家族强请求清理重新激活治理与强请求清理就绪治理分层.md)
- [268-安全载体家族强请求清理就绪治理与强请求清理连续性治理分层：为什么artifact-family cleanup stronger-request cleanup-readiness-governor signer不能越级冒充artifact-family cleanup stronger-request cleanup-continuity-governor signer](268-安全载体家族强请求清理就绪治理与强请求清理连续性治理分层.md)
- [269-安全载体家族强请求清理连续性治理与强请求清理恢复治理分层：为什么artifact-family cleanup stronger-request cleanup-continuity-governor signer不能越级冒充artifact-family cleanup stronger-request cleanup-recovery-governor signer](269-安全载体家族强请求清理连续性治理与强请求清理恢复治理分层.md)
- [270-安全载体家族强请求清理恢复治理与强请求清理重新并入治理分层：为什么artifact-family cleanup stronger-request cleanup-recovery-governor signer不能越级冒充artifact-family cleanup stronger-request cleanup-reintegration-governor signer](270-安全载体家族强请求清理恢复治理与强请求清理重新并入治理分层.md)
- [271-安全载体家族强请求清理重新并入治理与强请求清理重新投影治理分层：为什么artifact-family cleanup stronger-request cleanup-reintegration-governor signer不能越级冒充artifact-family cleanup stronger-request cleanup-reprojection-governor signer](271-安全载体家族强请求清理重新并入治理与强请求清理重新投影治理分层.md)
- [272-安全载体家族强请求清理重新投影治理与强请求清理重新担保治理分层：为什么artifact-family cleanup stronger-request cleanup-reprojection-governor signer不能越级冒充artifact-family cleanup stronger-request cleanup-reassurance-governor signer](272-安全载体家族强请求清理重新投影治理与强请求清理重新担保治理分层.md)
- [273-安全载体家族强请求清理重新担保治理与强请求清理用时重验证治理分层：为什么artifact-family cleanup stronger-request cleanup-reassurance-governor signer不能越级冒充artifact-family cleanup stronger-request cleanup-use-time-revalidation-governor signer](273-安全载体家族强请求清理重新担保治理与强请求清理用时重验证治理分层.md)
- [274-安全载体家族强请求清理用时重验证治理与强请求清理step-up重授权治理分层：为什么artifact-family cleanup stronger-request cleanup-use-time revalidation-governor signer不能越级冒充artifact-family cleanup stronger-request cleanup-step-up reauthorization-governor signer](274-安全载体家族强请求清理用时重验证治理与强请求清理step-up重授权治理分层.md)
- [275-安全载体家族强请求清理step-up重授权治理与强请求清理续打治理分层：为什么artifact-family cleanup stronger-request cleanup-step-up reauthorization-governor signer不能越级冒充artifact-family cleanup stronger-request continuation-governor signer](275-安全载体家族强请求清理step-up重授权治理与强请求清理续打治理分层.md)
- [276-安全载体家族强请求清理续打治理与强请求清理完成治理分层：为什么artifact-family cleanup stronger-request continuation-governor signer不能越级冒充artifact-family cleanup stronger-request completion-governor signer](276-安全载体家族强请求清理续打治理与强请求清理完成治理分层.md)
- [277-安全载体家族强请求清理完成治理与强请求清理终局治理分层：为什么artifact-family cleanup stronger-request completion-governor signer不能越级冒充artifact-family cleanup stronger-request finality-governor signer](277-安全载体家族强请求清理完成治理与强请求清理终局治理分层.md)
- [278-安全载体家族强请求清理终局治理与强请求清理遗忘治理分层：为什么artifact-family cleanup stronger-request finality-governor signer不能越级冒充artifact-family cleanup stronger-request forgetting-governor signer](278-安全载体家族强请求清理终局治理与强请求清理遗忘治理分层.md)
- [279-安全载体家族强请求清理遗忘治理与强请求清理免责释放治理分层：为什么artifact-family cleanup stronger-request forgetting-governor signer不能越级冒充artifact-family cleanup stronger-request liability-release-governor signer](279-安全载体家族强请求清理遗忘治理与强请求清理免责释放治理分层.md)
- [280-安全载体家族强请求清理免责释放治理与强请求清理归档关闭治理分层：为什么artifact-family cleanup stronger-request liability-release-governor signer不能越级冒充artifact-family cleanup stronger-request archive-close-governor signer](280-安全载体家族强请求清理免责释放治理与强请求清理归档关闭治理分层.md)
- [281-安全载体家族强请求清理归档关闭治理与强请求清理审计关闭治理分层：为什么artifact-family cleanup stronger-request archive-close-governor signer不能越级冒充artifact-family cleanup stronger-request audit-close-governor signer](281-安全载体家族强请求清理归档关闭治理与强请求清理审计关闭治理分层.md)
- [282-安全载体家族强请求清理审计关闭治理与强请求清理不可逆擦除治理分层：为什么artifact-family cleanup stronger-request audit-close-governor signer不能越级冒充artifact-family cleanup stronger-request irreversible-erasure-governor signer](282-安全载体家族强请求清理审计关闭治理与强请求清理不可逆擦除治理分层.md)
- [283-安全载体家族强请求清理不可逆擦除治理与强请求清理保留期治理分层：为什么artifact-family cleanup stronger-request irreversible-erasure-governor signer不能越级冒充artifact-family cleanup stronger-request retention-governor signer](283-安全载体家族强请求清理不可逆擦除治理与强请求清理保留期治理分层.md)
- [284-安全载体家族强请求清理保留期治理与强请求清理保留期执行诚实性治理分层：为什么artifact-family cleanup stronger-request retention-governor signer不能越级冒充artifact-family cleanup stronger-request retention-enforcement-honesty-governor signer](284-安全载体家族强请求清理保留期治理与强请求清理保留期执行诚实性治理分层.md)
- [285-安全载体家族强请求清理保留期执行诚实性治理与强请求清理隔离治理分层：为什么artifact-family cleanup stronger-request retention-enforcement-honesty-governor signer不能越级冒充artifact-family cleanup stronger-request cleanup-isolation-governor signer](285-安全载体家族强请求清理保留期执行诚实性治理与强请求清理隔离治理分层.md)
- [286-安全载体家族强请求清理隔离治理与强请求清理家族宪法治理分层：为什么artifact-family cleanup stronger-request cleanup-isolation-governor signer不能越级冒充artifact-family cleanup stronger-request cleanup-constitution-governor signer](286-安全载体家族强请求清理隔离治理与强请求清理家族宪法治理分层.md)
- [287-安全载体家族强请求清理家族宪法治理与强请求清理制度理由治理分层：为什么artifact-family cleanup stronger-request cleanup-constitution-governor signer不能越级冒充artifact-family cleanup stronger-request cleanup-rationale-governor signer](287-安全载体家族强请求清理家族宪法治理与强请求清理制度理由治理分层.md)
- [288-安全载体家族强请求清理制度理由治理与强请求清理制度元数据治理分层：为什么artifact-family cleanup stronger-request cleanup-rationale-governor signer不能越级冒充artifact-family cleanup stronger-request cleanup-metadata-governor signer](288-安全载体家族强请求清理制度理由治理与强请求清理制度元数据治理分层.md)
- [289-安全载体家族强请求清理制度元数据治理与强请求清理运行时符合性治理分层：为什么artifact-family cleanup stronger-request cleanup-metadata-governor signer不能越级冒充artifact-family cleanup stronger-request cleanup-runtime-conformance-governor signer](289-安全载体家族强请求清理制度元数据治理与强请求清理运行时符合性治理分层.md)
- [290-安全载体家族强请求清理运行时符合性治理与强请求清理反漂移验证治理分层：为什么artifact-family cleanup stronger-request cleanup-runtime-conformance-governor signer不能越级冒充artifact-family cleanup stronger-request cleanup-anti-drift-verifier signer](290-安全载体家族强请求清理运行时符合性治理与强请求清理反漂移验证治理分层.md)
- [291-安全载体家族强请求清理反漂移验证治理与强请求清理修复治理分层：为什么artifact-family cleanup stronger-request cleanup-anti-drift-verifier signer不能越级冒充artifact-family cleanup stronger-request cleanup-repair-governor signer](291-安全载体家族强请求清理反漂移验证治理与强请求清理修复治理分层.md)
- [292-安全载体家族强请求清理修复治理与强请求清理迁移治理分层：为什么artifact-family cleanup stronger-request cleanup-repair-governor signer不能越级冒充artifact-family cleanup stronger-request cleanup-migration-governor signer](292-安全载体家族强请求清理修复治理与强请求清理迁移治理分层.md)
- [293-安全载体家族强请求清理迁移治理与强请求清理退役治理分层：为什么artifact-family cleanup stronger-request cleanup-migration-governor signer不能越级冒充artifact-family cleanup stronger-request cleanup-sunset-governor signer](293-安全载体家族强请求清理迁移治理与强请求清理退役治理分层.md)
- [294-安全载体家族强请求清理退役治理与强请求清理墓碑治理分层：为什么artifact-family cleanup stronger-request cleanup-sunset-governor signer不能越级冒充artifact-family cleanup stronger-request cleanup-tombstone-governor signer](294-安全载体家族强请求清理退役治理与强请求清理墓碑治理分层.md)
- [295-安全载体家族强请求清理墓碑治理与强请求清理复活治理分层：为什么artifact-family cleanup stronger-request cleanup-tombstone-governor signer不能越级冒充artifact-family cleanup stronger-request cleanup-resurrection-governor signer](295-安全载体家族强请求清理墓碑治理与强请求清理复活治理分层.md)
- [296-安全载体家族强请求清理复活治理与强请求清理再赋权治理分层：为什么artifact-family cleanup stronger-request cleanup-resurrection-governor signer不能越级冒充artifact-family cleanup stronger-request cleanup-re-entitlement-governor signer](296-安全载体家族强请求清理复活治理与强请求清理再赋权治理分层.md)
- [297-安全载体家族强请求清理再赋权治理与强请求清理重配置治理分层：为什么artifact-family cleanup stronger-request cleanup-re-entitlement-governor signer不能越级冒充artifact-family cleanup stronger-request cleanup-reconfiguration-governor signer](297-安全载体家族强请求清理再赋权治理与强请求清理重配置治理分层.md)
- [298-安全载体家族强请求清理重配置治理与强请求清理重新激活治理分层：为什么artifact-family cleanup stronger-request cleanup-reconfiguration-governor signer不能越级冒充artifact-family cleanup stronger-request cleanup-reactivation-governor signer](298-安全载体家族强请求清理重配置治理与强请求清理重新激活治理分层.md)
- [299-安全载体家族强请求清理重新激活治理与强请求清理就绪治理分层：为什么artifact-family cleanup stronger-request cleanup-reactivation-governor signer不能越级冒充artifact-family cleanup stronger-request cleanup-readiness-governor signer](299-安全载体家族强请求清理重新激活治理与强请求清理就绪治理分层.md)
- [300-安全载体家族强请求清理就绪治理与强请求清理连续性治理分层：为什么artifact-family cleanup stronger-request cleanup-readiness-governor signer不能越级冒充artifact-family cleanup stronger-request cleanup-continuity-governor signer](300-安全载体家族强请求清理就绪治理与强请求清理连续性治理分层.md)
- [301-安全载体家族强请求清理连续性治理与强请求清理恢复治理分层：为什么artifact-family cleanup stronger-request cleanup-continuity-governor signer不能越级冒充artifact-family cleanup stronger-request cleanup-recovery-governor signer](301-安全载体家族强请求清理连续性治理与强请求清理恢复治理分层.md)
- [302-安全载体家族强请求清理恢复治理与强请求清理重新并入治理分层：为什么artifact-family cleanup stronger-request cleanup-recovery-governor signer不能越级冒充artifact-family cleanup stronger-request cleanup-reintegration-governor signer](302-安全载体家族强请求清理恢复治理与强请求清理重新并入治理分层.md)
- [303-安全载体家族强请求清理重新并入治理与强请求清理重新投影治理分层：为什么artifact-family cleanup stronger-request cleanup-reintegration-governor signer不能越级冒充artifact-family cleanup stronger-request cleanup-reprojection-governor signer](303-安全载体家族强请求清理重新并入治理与强请求清理重新投影治理分层.md)
- [304-安全载体家族强请求清理重新投影治理与强请求清理重新担保治理分层：为什么artifact-family cleanup stronger-request cleanup-reprojection-governor signer不能越级冒充artifact-family cleanup stronger-request cleanup-reassurance-governor signer](304-安全载体家族强请求清理重新投影治理与强请求清理重新担保治理分层.md)
- [305-安全载体家族强请求清理重新担保治理与强请求清理用时重验证治理分层：为什么artifact-family cleanup stronger-request cleanup-reassurance-governor signer不能越级冒充artifact-family cleanup stronger-request cleanup-use-time-revalidation-governor signer](305-安全载体家族强请求清理重新担保治理与强请求清理用时重验证治理分层.md)
- [306-安全载体家族强请求清理用时重验证治理与强请求清理step-up重授权治理分层：为什么artifact-family cleanup stronger-request cleanup-use-time revalidation-governor signer不能越级冒充artifact-family cleanup stronger-request cleanup-step-up reauthorization-governor signer](306-安全载体家族强请求清理用时重验证治理与强请求清理step-up重授权治理分层.md)
- [307-安全载体家族强请求清理step-up重授权治理与强请求清理续打治理分层：为什么artifact-family cleanup stronger-request cleanup-step-up reauthorization-governor signer不能越级冒充artifact-family cleanup stronger-request continuation-governor signer](307-安全载体家族强请求清理step-up重授权治理与强请求清理续打治理分层.md)
- [308-安全载体家族强请求清理续打治理与强请求清理完成治理分层：为什么artifact-family cleanup stronger-request continuation-governor signer不能越级冒充artifact-family cleanup stronger-request completion-governor signer](308-安全载体家族强请求清理续打治理与强请求清理完成治理分层.md)
- [309-安全载体家族强请求清理完成治理与强请求清理终局治理分层：为什么artifact-family cleanup stronger-request completion-governor signer不能越级冒充artifact-family cleanup stronger-request finality-governor signer](309-安全载体家族强请求清理完成治理与强请求清理终局治理分层.md)
- [310-安全载体家族强请求清理终局治理与强请求清理遗忘治理分层：为什么artifact-family cleanup stronger-request finality-governor signer不能越级冒充artifact-family cleanup stronger-request forgetting-governor signer](310-安全载体家族强请求清理终局治理与强请求清理遗忘治理分层.md)
- [311-安全载体家族强请求清理遗忘治理与强请求清理免责释放治理分层：为什么artifact-family cleanup stronger-request forgetting-governor signer不能越级冒充artifact-family cleanup stronger-request liability-release-governor signer](311-安全载体家族强请求清理遗忘治理与强请求清理免责释放治理分层.md)
- [312-安全载体家族强请求清理免责释放治理与强请求清理归档关闭治理分层：为什么artifact-family cleanup stronger-request liability-release-governor signer不能越级冒充artifact-family cleanup stronger-request archive-close-governor signer](312-安全载体家族强请求清理免责释放治理与强请求清理归档关闭治理分层.md)
- [313-安全载体家族强请求清理归档关闭治理与强请求清理审计关闭治理分层：为什么artifact-family cleanup stronger-request archive-close-governor signer不能越级冒充artifact-family cleanup stronger-request audit-close-governor signer](313-安全载体家族强请求清理归档关闭治理与强请求清理审计关闭治理分层.md)
- [314-安全载体家族强请求清理审计关闭治理与强请求清理不可逆擦除治理分层：为什么artifact-family cleanup stronger-request audit-close-governor signer不能越级冒充artifact-family cleanup stronger-request irreversible-erasure-governor signer](314-安全载体家族强请求清理审计关闭治理与强请求清理不可逆擦除治理分层.md)
- [315-安全载体家族强请求清理不可逆擦除治理与强请求清理保留期治理分层：为什么artifact-family cleanup stronger-request irreversible-erasure-governor signer不能越级冒充artifact-family cleanup stronger-request retention-governor signer](315-安全载体家族强请求清理不可逆擦除治理与强请求清理保留期治理分层.md)
- [316-安全载体家族强请求清理保留期治理与强请求清理保留期执行诚实性治理分层：为什么artifact-family cleanup stronger-request retention-governor signer不能越级冒充artifact-family cleanup stronger-request retention-enforcement-honesty-governor signer](316-安全载体家族强请求清理保留期治理与强请求清理保留期执行诚实性治理分层.md)
- [317-安全载体家族强请求清理保留期执行诚实性治理与强请求清理隔离治理分层：为什么artifact-family cleanup stronger-request retention-enforcement-honesty-governor signer不能越级冒充artifact-family cleanup stronger-request cleanup-isolation-governor signer](317-安全载体家族强请求清理保留期执行诚实性治理与强请求清理隔离治理分层.md)
- [318-安全载体家族强请求清理隔离治理与强请求清理家族宪法治理分层：为什么artifact-family cleanup stronger-request cleanup-isolation-governor signer不能越级冒充artifact-family cleanup stronger-request cleanup-constitution-governor signer](318-安全载体家族强请求清理隔离治理与强请求清理家族宪法治理分层.md)
- [319-安全载体家族强请求清理家族宪法治理与强请求清理制度理由治理分层：为什么artifact-family cleanup stronger-request cleanup-constitution-governor signer不能越级冒充artifact-family cleanup stronger-request cleanup-rationale-governor signer](319-安全载体家族强请求清理家族宪法治理与强请求清理制度理由治理分层.md)
- [320-安全载体家族强请求清理制度理由治理与强请求清理制度元数据治理分层：为什么artifact-family cleanup stronger-request cleanup-rationale-governor signer不能越级冒充artifact-family cleanup stronger-request cleanup-metadata-governor signer](320-安全载体家族强请求清理制度理由治理与强请求清理制度元数据治理分层.md)
- [321-安全载体家族强请求清理制度元数据治理与强请求清理运行时符合性治理分层：为什么artifact-family cleanup stronger-request cleanup-metadata-governor signer不能越级冒充artifact-family cleanup stronger-request cleanup-runtime-conformance-governor signer](321-安全载体家族强请求清理制度元数据治理与强请求清理运行时符合性治理分层.md)
- [322-安全载体家族强请求清理运行时符合性治理与强请求清理反漂移验证治理分层：为什么artifact-family cleanup stronger-request cleanup-runtime-conformance-governor signer不能越级冒充artifact-family cleanup stronger-request cleanup-anti-drift-verifier signer](322-安全载体家族强请求清理运行时符合性治理与强请求清理反漂移验证治理分层.md)
- [323-安全载体家族强请求清理反漂移验证治理与强请求清理修复治理分层：为什么artifact-family cleanup stronger-request cleanup-anti-drift-verifier signer不能越级冒充artifact-family cleanup stronger-request cleanup-repair-governor signer](323-安全载体家族强请求清理反漂移验证治理与强请求清理修复治理分层.md)
- [324-安全载体家族强请求清理修复治理与强请求清理迁移治理分层：为什么artifact-family cleanup stronger-request cleanup-repair-governor signer不能越级冒充artifact-family cleanup stronger-request cleanup-migration-governor signer](324-安全载体家族强请求清理修复治理与强请求清理迁移治理分层.md)
- [325-安全载体家族强请求清理迁移治理与强请求清理退役治理分层：为什么artifact-family cleanup stronger-request cleanup-migration-governor signer不能越级冒充artifact-family cleanup stronger-request cleanup-sunset-governor signer](325-安全载体家族强请求清理迁移治理与强请求清理退役治理分层.md)
- [326-安全载体家族强请求清理退役治理与强请求清理墓碑治理分层：为什么artifact-family cleanup stronger-request cleanup-sunset-governor signer不能越级冒充artifact-family cleanup stronger-request cleanup-tombstone-governor signer](326-安全载体家族强请求清理退役治理与强请求清理墓碑治理分层.md)
- [327-安全载体家族强请求清理墓碑治理与强请求清理复活治理分层：为什么artifact-family cleanup stronger-request cleanup-tombstone-governor signer不能越级冒充artifact-family cleanup stronger-request cleanup-resurrection-governor signer](327-安全载体家族强请求清理墓碑治理与强请求清理复活治理分层.md)

## 阅读顺序

- 想理解安全控制面如何组织：先读 `00-29`。
- 想定位“当前真相从哪里来、为什么恢复不等于完成”：先读 `30-69`。
- 想看能力发布、状态编辑与恢复资格：先读 `70-99`。
- 想看验证、迁移与工程化落地：先读 `100-138`。
- 想直看治理链主干：先读 `147-327 -> appendix/131-311 -> source-notes/01-178`。
- 想快速查字段、词法、路由、签字权和速查表：直接去 [appendix/README.md](appendix/README.md)。
- 想追具体源码证据簇：直接去 [source-notes/README.md](source-notes/README.md)。

## 什么时候去 appendix / source-notes / docs

- [appendix/README.md](appendix/README.md)
  想快速查矩阵、字段、词法、签字权与速查表。
- [source-notes/README.md](source-notes/README.md)
  想追单机制、单协议、单文件群的源码证据簇。
- [../../docs/development/security/README.md](../../docs/development/security/README.md)
  想看长期记忆与目录治理，而不是正文判断。

## 维护约定

- `security/README` 只保留前门判断、编号段职责、代表性入口与分流，不再镜像全部正文标题。
- `security/README` 只负责治理 signer / ledger / cleanup 入口摘要与机制解释权，不和 `risk/` 抢用户侧恢复与入口差异前门，也不和 `playbooks/` 抢执行链或现场 verdict 代签权。
- 巨型目录库存、逐篇标题镜像和作者侧记忆不再回灌首页。
- 深层速查和证据字典统一维护在 [appendix/README.md](appendix/README.md)。
- 单机制、单协议、单文件群的源码剖面统一维护在 [source-notes/README.md](source-notes/README.md)。
- 章节推进记忆、未来候选和目录编排提示统一写入 [../../docs/development/security/README.md](../../docs/development/security/README.md)，不再回写到正文尾段。
- 需要失败样本、恢复演练、宿主接入、验收、修复与长期回归时，分别回到 [../casebooks/README.md](../casebooks/README.md)、[../playbooks/README.md](../playbooks/README.md) 与 [../risk/README.md](../risk/README.md)，不要继续停在安全首页摘要。

## 相关目录

- [../architecture/README.md](../architecture/README.md)
  更关心安全机制如何接线、如何进入状态机与恢复链。
- [../risk/README.md](../risk/README.md)
  更关心能力撤回、资格限制、误伤与治理后果。
- [../philosophy/README.md](../philosophy/README.md)
  更关心第一性原理和抽象判断。
- [../casebooks/README.md](../casebooks/README.md)
  更关心失败样本、伪成功与恢复失真。
