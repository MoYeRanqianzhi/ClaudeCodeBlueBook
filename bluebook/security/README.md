# 安全专题索引

`security/` 当前有 245 篇正文，范围 `00-244`；`appendix/` 当前有 228 篇速查文档；`source-notes/` 当前有 95 篇源码剖面。

`security/` 研究的不是“规则越多越安全”，而是动作、权威、上下文与时间四种扩张如何被同一条治理秩序收费，以及弱 signer 为什么永远不配越级冒充强 signer。
如果你还没先经过 `09 / 05 / 15 / 41` 这组高阶前门，不要急着把安全页读成另一套规则堆。

本目录研究 Claude Code 的分层安全控制面：来源主权、权限模式、外部能力收口、恢复语义、能力发布、状态编辑、签字权分层，以及从 `receipt -> completion -> finality -> forgetting -> liability release -> archive close -> audit close -> irreversible erasure -> retention -> honesty -> isolation -> constitution -> rationale -> metadata -> runtime-conformance -> anti-drift verification -> repair -> migration -> sunset -> tombstone ...` 一路推进到 stronger-request cleanup 家族的同构治理链。

## 先记四句

- 安全不是单点沙箱，也不是单点分类器，而是一套 signer、ledger 与 lifecycle control plane。
- `governance key -> externalized truth chain -> typed ask -> decision window -> continuation pricing -> durable-transient cleanup` 不是安全页和省 token 页的拼接，而是同一条治理收费链。
- 完成、终局、遗忘、清理与家族级 cleanup 都各有 signer；任何弱层都不配替强层宣布“已经没事了”。
- 宿主不该自己从事件流回放拼当前真相；更稳的做法是消费 runtime 已外化的 authority / status / verdict。

## 高阶前门

想先抓第一性原理，不要从安全目录库存开始：

- [../09-三张控制面总图：世界进入模型、扩张定价与防过去写坏现在.md](../09-%E4%B8%89%E5%BC%A0%E6%8E%A7%E5%88%B6%E9%9D%A2%E6%80%BB%E5%9B%BE%EF%BC%9A%E4%B8%96%E7%95%8C%E8%BF%9B%E5%85%A5%E6%A8%A1%E5%9E%8B%E3%80%81%E6%89%A9%E5%BC%A0%E5%AE%9A%E4%BB%B7%E4%B8%8E%E9%98%B2%E8%BF%87%E5%8E%BB%E5%86%99%E5%9D%8F%E7%8E%B0%E5%9C%A8.md)
  第二张图先回答“扩张如何被定价”。
- [治理收费链为什么不是两套优化](../philosophy/19-%E5%AE%89%E5%85%A8%E4%B8%8EToken%E7%BB%8F%E6%B5%8E%E4%B8%8D%E6%98%AF%E6%9D%83%E8%A1%A1%E8%80%8C%E6%98%AF%E5%90%8C%E4%B8%80%E4%BC%98%E5%8C%96.md)
  看为什么治理收费链在动作、上下文与时间三面是同一优化。
- [宿主体验为什么只是治理收费链的外显](../philosophy/22-%E5%AE%89%E5%85%A8%E3%80%81%E6%88%90%E6%9C%AC%E4%B8%8E%E4%BD%93%E9%AA%8C%E5%BF%85%E9%A1%BB%E5%85%B1%E7%94%A8%E9%A2%84%E7%AE%97%E5%99%A8.md)
  看为什么体验只是这条治理收费链对外的结果。
- [architecture/83：反扩张治理流水线](../architecture/83-%E5%8F%8D%E6%89%A9%E5%BC%A0%E6%B2%BB%E7%90%86%E6%B5%81%E6%B0%B4%E7%BA%BF%EF%BC%9Atrusted%20inputs%E3%80%81distributed%20ask%20arbitration%E3%80%81deferred%20visibility%E4%B8%8Econtinuation%20pricing.md)
  看治理控制面如何把 `governance key`、`externalized truth chain`、`typed ask`、`decision window`、`continuation pricing` 与 `durable-vs-transient cleanup` 写成同一条流水线。

## 核心判断

- Claude Code 的安全性不是单点沙箱，也不是单点分类器，而是一套分层 signer、ledger 与 lifecycle control plane。
- 真正重要的不是把能力做得尽量小，而是让能力、声明、恢复权和清理权只能沿着正确边界流动。
- `147-244` 这一整段已经证明：弱层只能说明局部事实，强层才有权宣布更高阶治理结果；任何弱层都不能越级冒充强层。
- 宿主如果绕过 runtime 已外化的 authority / status / verdict，自行从事件流回放拼“当前真相”，就会把安全控制面重新降成脆弱的局部推断。

## 什么时候进来

- 当你已经知道统一定价治理成立，但还没回答 signer、ledger 与 cleanup 责任究竟落在哪些对象上。
- 当你需要判断哪种扩张该被 ask、哪种 truth 必须外化、哪种 cleanup 不配越级宣布终局。
- 当你需要把“安全”和“省 token”继续压成同一治理纪律，而不是并列专题。

## 如果你只先判断一件事

- 如果你只先判断“哪种 signer 有资格改边界”，从 `00-29` 进入。失败信号：还在把 classifier、mode、allow 规则或单点沙箱当成最终主权。
- 如果你只先判断“哪条真相链必须被宿主承认”，从 `30-138` 进入。失败信号：还在让宿主从事件流、usage 条或局部 status 自己回放拼治理真相。
- 如果你只先判断“cleanup 与 forgetting 为什么不能混成一个结果词”，从 `147-244` 进入。失败信号：还在把完成、终局、遗忘、清理写成一个“已经没事了”的总结果。

## 目录分层

- `00-17`：研究方法、总论、权限/沙箱、配置与受管环境、统一安全控制台导读。
- `18-29`：检测内核、控制台字段与卡片、宿主资格、对象协议与显式降级。
- `30-69`：真相源、账本、恢复闭环、清理纪律、词法、租约与 failure path。
- `70-99`：能力发布、状态编辑、恢复资格、默认路由与 reject semantics。
- `100-138`：完成权、字段生命周期、工程迁移、验证架构与制度化接口。
- `139-244`：cleanup 契约与 signer/governor ladder，含 stronger-request cleanup 的 runtime-conformance、anti-drift、repair、migration、sunset、tombstone、resurrection、re-entitlement、reconfiguration、reactivation、readiness、continuity、recovery、reintegration、reprojection、reassurance、use-time revalidation、step-up reauthorization、continuation、completion 等高阶治理分层。

## 按问题进入

- 想看来源主权、权限模式、能力边界与显式降级：从 `00-29` 进入。
- 想看当前真相、账本、恢复闭环、状态编辑与 failure semantics：从 `30-138` 进入。
- 想看 signer ladder 从 `receipt -> completion -> finality -> forgetting`：从 `147-166` 进入。
- 想看 artifact-family cleanup ladder：从 `167-196` 进入。
- 想看 stronger-request cleanup ladder 与更高阶 continuation / completion governor：从 `197-244` 进入。

## 推荐入口

- [00-研究方法与可信边界](00-研究方法与可信边界.md)
- [01-安全总论：Claude Code 不是单点沙箱，而是分层安全控制面](01-安全总论：Claude%20Code%20不是单点沙箱，而是分层安全控制面.md)
- [14-安全控制面总图：从 trust 到 entitlement 的全链结构图谱](14-安全控制面总图：从%20trust%20到%20entitlement%20的全链结构图谱.md)
- [116-安全工程迁移路线图：为什么这份研究版源码若要走向可持续验证系统，必须先固化边界，再分阶段迁移而不能一次性重构](116-安全工程迁移路线图：为什么这份研究版源码若要走向可持续验证系统，必须先固化边界，再分阶段迁移而不能一次性重构.md)
- [147-安全回执签字权：为什么receipt只能由持有pending ledger、schema context与lifecycle closure的signer签发](147-安全回执签字权：为什么receipt只能由持有pending%20ledger、schema%20context与lifecycle%20closure的signer签发.md)
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

## 阅读顺序

- 想理解安全控制面如何组织：先读 `00-29`。
- 想定位“当前真相从哪里来、为什么恢复不等于完成”：先读 `30-69`。
- 想看能力发布、状态编辑与恢复资格：先读 `70-99`。
- 想看验证、迁移与工程化落地：先读 `100-138`。
- 想直看治理链主干：先读 `147-244 -> appendix/131-228 -> source-notes/01-95`。
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

- `security/README` 只保留前门判断、编号段职责、核心判断和代表性入口，不再镜像全部 245 篇标题。
- `security/README` 只负责治理 signer / ledger / cleanup 前门，不和 `risk/` 抢用户侧结算面，也不和 `playbooks/` 抢执行链。
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
