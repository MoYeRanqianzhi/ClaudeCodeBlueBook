# 安全专题索引

`security/` 当前有 155 篇正文，范围 `00-154`；`appendix/` 当前有 138 篇速查文档；`source-notes/` 当前有 5 篇源码剖面。本目录研究 Claude Code 的分层安全控制面：来源主权、权限模式、外部能力收口、恢复语义、能力发布、状态编辑、签字权分层，以及终局、遗忘、免责释放、归档关闭、审计关闭与不可逆销毁边界的工程化验证。

## 核心判断

- Claude Code 的安全性不是单点沙箱，也不是单点分类器，而是一套分层 signer、ledger 与 lifecycle control plane。
- 真正重要的不是把能力尽量做小，而是让能力、声明、恢复权和清理权只能沿着正确边界流动。
- `147-154` 这一段 signer ladder 已经说明：`receipt -> completion -> finality -> forgetting -> liability release -> archive close -> audit close -> irreversible erasure` 是逐层增强的安全声明，任何弱层都不能越级冒充强层。

## 目录分层

- `00-17`: 研究方法、总论、权限/沙箱、配置与受管环境、统一安全控制台导读。
- `18-29`: 检测内核、控制台字段与卡片、宿主资格、对象协议与显式降级。
- `30-69`: 真相源、账本、恢复闭环、清理纪律、词法、租约与 failure path。
- `70-99`: 能力发布、状态编辑、恢复资格、默认路由与 reject semantics。
- `100-138`: 完成权、字段生命周期、工程迁移、验证架构与制度化接口。
- `139-154`: cleanup 契约、兼容迁移、版本偏斜、handoff、receipt/completion/finality/forgetting/liability-release/archive-close/audit-close/irreversible-erasure 分层。

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
- [安全专题附录索引](appendix/README.md)
- [安全源码剖面索引](source-notes/README.md)

## 什么时候先读正文，什么时候先读附录/源码剖面

- 想理解安全控制面如何组织：先读 `00-29`
- 想定位“当前真相从哪里来、为什么恢复不等于完成”：先读 `30-69`
- 想看能力发布、状态编辑与恢复资格：先读 `70-99`
- 想看验证、迁移与工程化落地：先读 `100-138`
- 想直看 signer ladder、终局边界、遗忘边界、免责释放边界、归档关闭边界、审计关闭边界与不可逆销毁边界：先读 `147 -> 148 -> 149 -> 150 -> 151 -> 152 -> 153 -> 154 -> appendix/131-138 -> source-notes/01-05`
- 想快速查字段、词法、路由、签字权和速查表：直接去 [appendix/README.md](appendix/README.md)
- 想追具体源码证据簇：直接去 [source-notes/README.md](source-notes/README.md)

## 维护约定

- README 只保留编号段和代表性入口，不再镜像全部 155 篇标题。
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
