# 安全专题索引

`security/` 当前有 174 篇正文，范围 `00-173`；`appendix/` 当前有 157 篇速查文档；`source-notes/` 当前有 24 篇源码剖面。本目录研究 Claude Code 的分层安全控制面：来源主权、权限模式、外部能力收口、恢复语义、能力发布、状态编辑、签字权分层，以及终局、遗忘、免责释放、归档关闭、审计关闭、不可逆销毁、保留期治理、执行诚实性、清理隔离、载体家族宪法边界、制度理由边界、制度元数据边界、运行时符合性边界、反漂移验证边界、修复治理边界、迁移治理边界、退役治理边界、墓碑治理边界、复活治理边界、再赋权治理边界、重配置治理边界、重新激活治理边界、就绪治理边界、连续性治理边界与恢复治理边界的工程化验证。

## 核心判断

- Claude Code 的安全性不是单点沙箱，也不是单点分类器，而是一套分层 signer、ledger 与 lifecycle control plane。
- 真正重要的不是把能力尽量做小，而是让能力、声明、恢复权和清理权只能沿着正确边界流动。
- `147-173` 这一段 signer/governor/honesty/constitution/rationale/metadata/conformance/verifier/repair/migration/sunset/tombstone/resurrection/re-entitlement/reconfiguration/reactivation/readiness/continuity/recovery ladder 已经说明：`receipt -> completion -> finality -> forgetting -> liability release -> archive close -> audit close -> irreversible erasure -> retention governance -> retention enforcement honesty -> cleanup isolation -> artifact-family cleanup constitution -> artifact-family cleanup rationale -> artifact-family cleanup metadata -> artifact-family cleanup runtime-conformance -> artifact-family cleanup anti-drift verification -> artifact-family cleanup repair-governance -> artifact-family cleanup migration-governance -> artifact-family cleanup sunset-governance -> artifact-family cleanup tombstone-governance -> artifact-family cleanup resurrection-governance -> artifact-family cleanup re-entitlement-governance -> artifact-family cleanup reconfiguration-governance -> artifact-family cleanup reactivation-governance -> artifact-family cleanup readiness-governance -> artifact-family cleanup continuity-governance -> artifact-family cleanup recovery-governance` 是逐层增强的安全声明、治理主权、执行诚实性、非干扰边界、家族级宪法主权、制度理由主权、制度元数据主权、运行时符合性主权、反漂移验证主权、修复治理主权、迁移治理主权、退役治理主权、墓碑治理主权、复活治理主权、再赋权治理主权、重配置治理主权、重新激活治理主权、就绪治理主权、连续性治理主权与恢复治理主权，任何弱层都不能越级冒充强层。

## 目录分层

- `00-17`: 研究方法、总论、权限/沙箱、配置与受管环境、统一安全控制台导读。
- `18-29`: 检测内核、控制台字段与卡片、宿主资格、对象协议与显式降级。
- `30-69`: 真相源、账本、恢复闭环、清理纪律、词法、租约与 failure path。
- `70-99`: 能力发布、状态编辑、恢复资格、默认路由与 reject semantics。
- `100-138`: 完成权、字段生命周期、工程迁移、验证架构与制度化接口。
- `139-173`: cleanup 契约、兼容迁移、版本偏斜、handoff、receipt/completion/finality/forgetting/liability-release/archive-close/audit-close/irreversible-erasure/retention-governance/retention-enforcement-honesty/cleanup-isolation/artifact-family-cleanup-constitution/artifact-family-cleanup-rationale/artifact-family-cleanup-metadata/artifact-family-cleanup-runtime-conformance/artifact-family-cleanup-anti-drift-verification/artifact-family-cleanup-repair-governance/artifact-family-cleanup-migration-governance/artifact-family-cleanup-sunset-governance/artifact-family-cleanup-tombstone-governance/artifact-family-cleanup-resurrection-governance/artifact-family-cleanup-re-entitlement-governance/artifact-family-cleanup-reconfiguration-governance/artifact-family-cleanup-reactivation-governance/artifact-family-cleanup-readiness-governance/artifact-family-cleanup-continuity-governance/artifact-family-cleanup-recovery-governance 分层。

## 推荐入口

- [00-研究方法与可信边界](00-研究方法与可信边界.md)
- [01-安全总论：Claude Code 不是单点沙箱，而是分层安全控制面](01-安全总论：Claude%20Code%20不是单点沙箱，而是分层安全控制面.md)
- [14-安全控制面总图：从 trust 到 entitlement 的全链结构图谱](14-安全控制面总图：从%20trust%20到%20entitlement%20的全链结构图谱.md)
- [18-安全检测技术内核：从危险模式识别到来源主权收口](18-安全检测技术内核：从危险模式识别到来源主权收口.md)
- [54-安全恢复验证闭环：为什么用户执行修复命令不等于状态已恢复，必须由对应回读与signer关环](54-安全恢复验证闭环：为什么用户执行修复命令不等于状态已恢复，必须由对应回读与signer关环.md)
- [70-安全多重窄门：为什么Claude Code不是先给全量能力再补权限，而是逐层借出能力](70-安全多重窄门：为什么Claude%20Code不是先给全量能力再补权限，而是逐层借出能力.md)
- [116-安全工程迁移路线图：为什么这份研究版源码若要走向可持续验证系统，必须先固化边界，再分阶段迁移而不能一次性重构](116-安全工程迁移路线图：为什么这份研究版源码若要走向可持续验证系统，必须先固化边界，再分阶段迁移而不能一次性重构.md)
- [147-安全回执签字权：为什么receipt只能由持有pending ledger、schema context与lifecycle closure的signer签发](147-安全回执签字权：为什么receipt只能由持有pending%20ledger、schema%20context与lifecycle%20closure的signer签发.md)
- [148-安全回执与完成分层：为什么receipt signer不能越级冒充completion signer](148-安全回执与完成分层：为什么receipt%20signer不能越级冒充completion%20signer.md)
- [149-安全完成与终局分层：为什么completion signer不能越级冒充finality signer](149-安全完成与终局分层：为什么completion%20signer不能越级冒充finality%20signer.md)
- [150-安全终局与遗忘分层：为什么finality signer不能越级冒充forgetting signer](150-安全终局与遗忘分层：为什么finality%20signer不能越级冒充forgetting%20signer.md)
- [151-安全遗忘与免责释放分层：为什么forgetting signer不能越级冒充liability-release signer](151-安全遗忘与免责释放分层：为什么forgetting%20signer不能越级冒充liability-release%20signer.md)
- [152-安全免责释放与归档关闭分层：为什么liability-release signer不能越级冒充archive-close signer](152-安全免责释放与归档关闭分层：为什么liability-release%20signer不能越级冒充archive-close%20signer.md)
- [153-安全归档关闭与审计关闭分层：为什么archive-close signer不能越级冒充audit-close signer](153-安全归档关闭与审计关闭分层：为什么archive-close%20signer不能越级冒充audit-close%20signer.md)
- [154-安全审计关闭与不可逆销毁分层：为什么audit-close signer不能越级冒充irreversible-erasure signer](154-安全审计关闭与不可逆销毁分层：为什么audit-close%20signer不能越级冒充irreversible-erasure%20signer.md)
- [155-安全不可逆销毁与保留期主权分层：为什么irreversible-erasure signer不能越级冒充retention-governor signer](155-安全不可逆销毁与保留期主权分层：为什么irreversible-erasure%20signer不能越级冒充retention-governor%20signer.md)
- [156-安全保留期治理与执行诚实性分层：为什么retention-governor signer不能越级冒充retention-enforcement-honesty signer](156-安全保留期治理与执行诚实性分层：为什么retention-governor%20signer不能越级冒充retention-enforcement-honesty%20signer.md)
- [157-安全执行诚实性与清理隔离分层：为什么retention-enforcement-honesty signer不能越级冒充cleanup-isolation signer](157-安全执行诚实性与清理隔离分层：为什么retention-enforcement-honesty%20signer不能越级冒充cleanup-isolation%20signer.md)
- [158-安全清理隔离与载体家族宪法分层：为什么cleanup-isolation signer不能越级冒充artifact-family cleanup constitution signer](158-安全清理隔离与载体家族宪法分层：为什么cleanup-isolation%20signer不能越级冒充artifact-family%20cleanup%20constitution%20signer.md)
- [159-安全载体家族宪法与制度理由分层：为什么artifact-family cleanup constitution signer不能越级冒充artifact-family cleanup rationale signer](159-安全载体家族宪法与制度理由分层：为什么artifact-family%20cleanup%20constitution%20signer不能越级冒充artifact-family%20cleanup%20rationale%20signer.md)
- [160-安全载体家族制度理由与元数据分层：为什么artifact-family cleanup rationale signer不能越级冒充artifact-family cleanup metadata signer](160-安全载体家族制度理由与元数据分层：为什么artifact-family%20cleanup%20rationale%20signer不能越级冒充artifact-family%20cleanup%20metadata%20signer.md)
- [161-安全载体家族元数据与运行时符合性分层：为什么artifact-family cleanup metadata signer不能越级冒充artifact-family cleanup runtime-conformance signer](161-安全载体家族元数据与运行时符合性分层：为什么artifact-family%20cleanup%20metadata%20signer不能越级冒充artifact-family%20cleanup%20runtime-conformance%20signer.md)
- [162-安全载体家族运行时符合性与反漂移验证分层：为什么artifact-family cleanup runtime-conformance signer不能越级冒充artifact-family cleanup anti-drift verifier signer](162-安全载体家族运行时符合性与反漂移验证分层：为什么artifact-family%20cleanup%20runtime-conformance%20signer不能越级冒充artifact-family%20cleanup%20anti-drift%20verifier%20signer.md)
- [163-安全载体家族反漂移验证与修复治理分层：为什么artifact-family cleanup anti-drift verifier signer不能越级冒充artifact-family cleanup repair-governor signer](163-安全载体家族反漂移验证与修复治理分层：为什么artifact-family%20cleanup%20anti-drift%20verifier%20signer不能越级冒充artifact-family%20cleanup%20repair-governor%20signer.md)
- [164-安全载体家族修复治理与迁移治理分层：为什么artifact-family cleanup repair-governor signer不能越级冒充artifact-family cleanup migration-governor signer](164-安全载体家族修复治理与迁移治理分层：为什么artifact-family%20cleanup%20repair-governor%20signer不能越级冒充artifact-family%20cleanup%20migration-governor%20signer.md)
- [165-安全载体家族迁移治理与退役治理分层：为什么artifact-family cleanup migration-governor signer不能越级冒充artifact-family cleanup sunset-governor signer](165-安全载体家族迁移治理与退役治理分层：为什么artifact-family%20cleanup%20migration-governor%20signer不能越级冒充artifact-family%20cleanup%20sunset-governor%20signer.md)
- [166-安全载体家族退役治理与墓碑治理分层：为什么artifact-family cleanup sunset-governor signer不能越级冒充artifact-family cleanup tombstone-governor signer](166-安全载体家族退役治理与墓碑治理分层：为什么artifact-family%20cleanup%20sunset-governor%20signer不能越级冒充artifact-family%20cleanup%20tombstone-governor%20signer.md)
- [167-安全载体家族墓碑治理与复活治理分层：为什么artifact-family cleanup tombstone-governor signer不能越级冒充artifact-family cleanup resurrection-governor signer](167-安全载体家族墓碑治理与复活治理分层：为什么artifact-family%20cleanup%20tombstone-governor%20signer不能越级冒充artifact-family%20cleanup%20resurrection-governor%20signer.md)
- [168-安全载体家族复活治理与再赋权治理分层：为什么artifact-family cleanup resurrection-governor signer不能越级冒充artifact-family cleanup re-entitlement-governor signer](168-安全载体家族复活治理与再赋权治理分层：为什么artifact-family%20cleanup%20resurrection-governor%20signer不能越级冒充artifact-family%20cleanup%20re-entitlement-governor%20signer.md)
- [169-安全载体家族再赋权治理与重配置治理分层：为什么artifact-family cleanup re-entitlement-governor signer不能越级冒充artifact-family cleanup reconfiguration-governor signer](169-安全载体家族再赋权治理与重配置治理分层：为什么artifact-family%20cleanup%20re-entitlement-governor%20signer不能越级冒充artifact-family%20cleanup%20reconfiguration-governor%20signer.md)
- [170-安全载体家族重配置治理与重新激活治理分层：为什么artifact-family cleanup reconfiguration-governor signer不能越级冒充artifact-family cleanup reactivation-governor signer](170-安全载体家族重配置治理与重新激活治理分层：为什么artifact-family%20cleanup%20reconfiguration-governor%20signer不能越级冒充artifact-family%20cleanup%20reactivation-governor%20signer.md)
- [171-安全载体家族重新激活治理与就绪治理分层：为什么artifact-family cleanup reactivation-governor signer不能越级冒充artifact-family cleanup readiness-governor signer](171-安全载体家族重新激活治理与就绪治理分层：为什么artifact-family%20cleanup%20reactivation-governor%20signer不能越级冒充artifact-family%20cleanup%20readiness-governor%20signer.md)
- [172-安全载体家族就绪治理与连续性治理分层：为什么artifact-family cleanup readiness-governor signer不能越级冒充artifact-family cleanup continuity-governor signer](172-安全载体家族就绪治理与连续性治理分层：为什么artifact-family%20cleanup%20readiness-governor%20signer不能越级冒充artifact-family%20cleanup%20continuity-governor%20signer.md)
- [173-安全载体家族连续性治理与恢复治理分层：为什么artifact-family cleanup continuity-governor signer不能越级冒充artifact-family cleanup recovery-governor signer](173-安全载体家族连续性治理与恢复治理分层：为什么artifact-family%20cleanup%20continuity-governor%20signer不能越级冒充artifact-family%20cleanup%20recovery-governor%20signer.md)
- [安全专题附录索引](appendix/README.md)
- [安全源码剖面索引](source-notes/README.md)

## 什么时候先读正文，什么时候先读附录/源码剖面

- 想理解安全控制面如何组织：先读 `00-29`
- 想定位“当前真相从哪里来、为什么恢复不等于完成”：先读 `30-69`
- 想看能力发布、状态编辑与恢复资格：先读 `70-99`
- 想看验证、迁移与工程化落地：先读 `100-138`
- 想直看 signer ladder、终局边界、遗忘边界、免责释放边界、归档关闭边界、审计关闭边界、不可逆销毁边界、保留期治理边界、执行诚实性边界、清理隔离边界、载体家族宪法边界、制度理由边界、制度元数据边界、运行时符合性边界、反漂移验证边界、修复治理边界、迁移治理边界、退役治理边界、墓碑治理边界、复活治理边界、再赋权治理边界、重配置治理边界、重新激活治理边界、就绪治理边界、连续性治理边界与恢复治理边界：先读 `147 -> 148 -> 149 -> 150 -> 151 -> 152 -> 153 -> 154 -> 155 -> 156 -> 157 -> 158 -> 159 -> 160 -> 161 -> 162 -> 163 -> 164 -> 165 -> 166 -> 167 -> 168 -> 169 -> 170 -> 171 -> 172 -> 173 -> appendix/131-157 -> source-notes/01-24`
- 想快速查字段、词法、路由、签字权和速查表：直接去 [appendix/README.md](appendix/README.md)
- 想追具体源码证据簇：直接去 [source-notes/README.md](source-notes/README.md)

## 维护约定

- README 只保留编号段和代表性入口，不再镜像全部 174 篇标题。
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
