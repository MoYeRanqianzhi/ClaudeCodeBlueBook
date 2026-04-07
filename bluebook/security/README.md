# 安全专题索引

`security/` 当前有 304 篇正文，范围 `00-303`；`appendix/` 当前有 287 篇速查文档；`source-notes/` 当前有 154 篇源码剖面。

本目录研究 Claude Code 的分层安全控制面：来源主权、权限模式、外部能力收口、恢复语义、能力发布、状态编辑、签字权分层，以及从 `receipt -> completion -> finality -> forgetting -> liability release -> archive close -> audit close -> irreversible erasure -> retention -> honesty -> isolation -> constitution -> rationale -> metadata -> runtime-conformance -> anti-drift verification -> repair -> migration -> sunset -> tombstone ...` 一路推进到 stronger-request cleanup 家族的同构治理链。

## 核心判断

- Claude Code 的安全性不是单点沙箱，也不是单点分类器，而是一套分层 signer、ledger 与 lifecycle control plane。
- 真正重要的不是把能力做得尽量小，而是让能力、声明、恢复权和清理权只能沿着正确边界流动。
- `147-303` 这一整段已经证明：弱层只能说明局部事实，强层才有权宣布更高阶治理结果；任何弱层都不能越级冒充强层。

## 目录分层

- `00-17`：研究方法、总论、权限/沙箱、配置与受管环境、统一安全控制台导读。
- `18-29`：检测内核、控制台字段与卡片、宿主资格、对象协议与显式降级。
- `30-69`：真相源、账本、恢复闭环、清理纪律、词法、租约与 failure path。
- `70-99`：能力发布、状态编辑、恢复资格、默认路由与 reject semantics。
- `100-138`：完成权、字段生命周期、工程迁移、验证架构与制度化接口。
- `139-294`：cleanup 契约与 signer/governor ladder，含 stronger-request cleanup 的 runtime-conformance、anti-drift、repair、migration、sunset、tombstone、resurrection、re-entitlement、reconfiguration、reactivation、readiness、continuity、recovery、reintegration、reprojection、reassurance、use-time revalidation、step-up reauthorization、continuation、completion、finality、forgetting、liability-release、archive-close、audit-close、irreversible-erasure、retention-governance、retention-enforcement-honesty、cleanup-isolation、cleanup-constitution、cleanup-rationale、cleanup-metadata、cleanup-runtime-conformance、cleanup-anti-drift-verification、cleanup-repair、cleanup-migration、cleanup-sunset、cleanup-tombstone、cleanup-resurrection、cleanup-re-entitlement、cleanup-reconfiguration、cleanup-reactivation、cleanup-readiness、cleanup-continuity、cleanup-recovery、cleanup-reintegration、cleanup-reprojection、cleanup-reassurance、cleanup-use-time revalidation、cleanup-step-up reauthorization、cleanup-continuation、cleanup-completion、cleanup-finality、cleanup-forgetting、cleanup-liability-release、cleanup-archive-close、cleanup-audit-close、cleanup-irreversible-erasure、cleanup-retention-governance、cleanup-retention-enforcement-honesty、cleanup-cleanup-isolation、cleanup-cleanup-constitution、cleanup-cleanup-rationale、cleanup-cleanup-metadata、cleanup-cleanup-runtime-conformance、cleanup-cleanup-anti-drift-verification、cleanup-cleanup-repair、cleanup-cleanup-migration、cleanup-cleanup-sunset、cleanup-cleanup-tombstone 等高阶治理分层。

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

## 阅读顺序

- 想理解安全控制面如何组织：先读 `00-29`。
- 想定位“当前真相从哪里来、为什么恢复不等于完成”：先读 `30-69`。
- 想看能力发布、状态编辑与恢复资格：先读 `70-99`。
- 想看验证、迁移与工程化落地：先读 `100-138`。
- 想直看治理链主干：先读 `147-303 -> appendix/131-287 -> source-notes/01-154`。
- 想快速查字段、词法、路由、签字权和速查表：直接去 [appendix/README.md](appendix/README.md)。
- 想追具体源码证据簇：直接去 [source-notes/README.md](source-notes/README.md)。

## 维护约定

- README 只保留编号段、核心判断和代表性入口，不再镜像全部正文标题。
- 深层速查和证据字典统一维护在 [appendix/README.md](appendix/README.md)。
- 单机制、单协议、单文件群的源码剖面统一维护在 [source-notes/README.md](source-notes/README.md)。
- 章节推进记忆、未来候选和目录编排提示统一写入 [../../docs/development/security/README.md](../../docs/development/security/README.md)，不再回写到正文尾段。
- 需要失败样本和恢复演练时，分别回到 [../casebooks/README.md](../casebooks/README.md) 与 [../playbooks/README.md](../playbooks/README.md)。

## 相关目录

- [../architecture/README.md](../architecture/README.md)
  更关心安全机制如何接线、如何进入状态机与恢复链。
- [../risk/README.md](../risk/README.md)
  更关心能力撤回、资格限制、误伤与治理后果。
- [../philosophy/README.md](../philosophy/README.md)
  更关心第一性原理和抽象判断。
