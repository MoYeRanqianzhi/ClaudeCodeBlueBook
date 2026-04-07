# 安全专题入口

`security/` 研究的不是“规则越多越安全”，而是动作、权威、上下文与时间四种扩张如何被同一条治理秩序收费，以及弱 signer 为什么永远不配越级冒充强 signer。
如果你还没先经过 `09 / 05 / 15 / 41` 这组高阶前门，不要急着把安全页读成另一套规则堆。
`security/` 内部也继续继承 `问题分型 -> 工作对象 -> 控制面 -> 入口`：先判这次在失真的到底是 signer、ledger 还是 cleanup 工作对象，再判它卡在治理收费链的哪一段，最后才决定读主 README、appendix、source-notes 还是具体编号正文。

如果只先记安全前门的一句话，也只记这句：

- 这不是第二套安全故事，而是同一条 `governance key -> externalized truth chain -> typed ask -> decision window -> continuation pricing -> durable-transient cleanup` 收费链在安全侧的结算面。

这里还应再多记一句：

- `continuity` 在安全目录里也不是第四类安全主题；它只是 `decision window -> continuation pricing -> durable-transient cleanup` 这段时间轴在安全侧的继续资格与清算资格。

## 先记四句

- 安全不是单点沙箱，也不是单点分类器，而是一套 signer、ledger 与 lifecycle control plane。
- `governance key -> externalized truth chain -> typed ask -> decision window -> continuation pricing -> durable-transient cleanup` 不是安全页和省 token 页的拼接，而是同一条治理收费链。
- 完成、终局、遗忘、清理与家族级 cleanup 都各有 signer；任何弱层都不配替强层宣布“已经没事了”。
- 宿主不该自己从事件流回放拼当前真相；更稳的做法是消费 runtime 已外化的 truth-surface / decision window / cleanup verdict。
- `/status / /doctor / /usage` 只配做 runtime projection；`Compact / Resume / Memory / Export` 只配做 continuation consumer；用户侧恢复另沿 `signer + evidence + reopen` 去回读。

如果把安全前门继续压成最短公式，也只剩三条：

1. `governance key -> externalized truth chain -> typed ask`
   - 谁配改边界、谁配宣布当前治理真相、哪些扩张必须先协商
2. `decision window -> continuation pricing`
   - 当前扩张还配不配继续，继续是否仍值得付费
3. `durable-transient cleanup`
   - 谁配宣布已经没事了，哪些 signer / ledger / cleanup 结果词只配当投影

如果继续把这条机制链再压成 later maintainer 与 user-facing 都能共用的三段顺序，也只该再补一句：

- 先判 `pricing-right / truth-surface`
- 再判 `typed ask / sandbox`
- 最后才判 `decision window / continuation pricing / durable-transient cleanup`

如果继续把 `security/` 的目录发言权也压成最短公式，也只该剩三句：

1. `signer / ledger / cleanup authority`
   - 谁配签字、谁只配记账、谁只配结算。
2. `governance mechanism speaking right`
   - 哪条 signer / verdict / liability 机制在安全侧被看清。
3. `no user-side settlement right`
   - 用户侧误伤、恢复与入口语义差不在这里第一次裁决。

如果一个安全判断还压不回这三条，它就还停在规则堆或工具堆层。
如果一个安全判断还答不上“它保护的到底是哪种工作对象、哪段收费链、哪个入口只是证据层 consumer”，就说明它还没压回第一性原理。

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

## 什么时候进来

- 当你已经知道统一定价治理成立，但还没回答 signer、ledger 与 cleanup 责任究竟落在哪些对象上。
- 当你需要判断哪种扩张该被 ask、哪种 truth 必须外化、哪种 cleanup 不配越级宣布终局。
- 当你需要把“安全”和“省 token”继续压成同一治理纪律，而不是并列专题。
- 当你需要把 user-facing 的 `/status / /doctor / /usage` 这些 runtime projection 与 `/compact / /resume` 这些 continuation consumer 退回它们各自只配消费的治理阶段。

## 如果你只先判断一件事

- 如果你只先判断“哪种 signer 有资格改边界”，从 `00-29` 进入。
  - 失败信号：还在把 classifier、mode、allow 规则或单点沙箱当成最终主权。
- 如果你只先判断“哪条真相链必须被宿主承认”，从 `30-138` 进入。
  - 失败信号：还在让宿主从事件流、usage 条或局部 status 自己回放拼治理真相。
- 如果你只先判断“cleanup 与 forgetting 为什么不能混成一个结果词”，从 `147-224` 进入。
  - 失败信号：还在把完成、终局、遗忘、清理写成一个“已经没事了”的总结果。

更稳的 first reject signal 还应先记三条：

1. `Context Usage`、mode 条和 token UI 开始冒充治理真相
2. cleanup 结果词开始越级替 signer 和 verdict 说话
3. `Later / Outside`、default continuation 或全量可见重新让免费扩张复活

## 按问题进入

- 想看来源主权、权限模式、能力边界与显式降级
  从 `00-29` 进入。
- 想看当前真相、账本、恢复闭环、状态编辑与 failure semantics
  从 `30-138` 进入。
- 想看 signer ladder 从 `receipt -> completion -> finality -> forgetting`
  从 `147-166` 进入。
- 想看 artifact-family cleanup ladder
  从 `167-196` 进入。
- 想看 stronger-request cleanup ladder
  从 `197-224` 进入。

## 什么时候去 appendix / source-notes / docs

- [appendix/README.md](appendix/README.md)
  想快速查矩阵、字段、词法、签字权与速查表。
- [source-notes/README.md](source-notes/README.md)
  想追单机制、单协议、单文件群的源码证据簇。
- [../../docs/development/security/README.md](../../docs/development/security/README.md)
  想看长期记忆与目录治理，而不是正文判断。

## 维护约定

- `security/README` 只保留前门判断、编号段职责与分流。
- `security/README` 只负责治理 signer / ledger / cleanup 前门，不和 `risk/` 抢用户侧结算面，也不和 `playbooks/` 抢执行链。
- `security/README` 有 signer/ledger 机制解释权，但没有用户侧恢复签发权，也没有现场执行 verdict 的代签权。
- 巨型目录库存、逐篇标题镜像和作者侧记忆不再回灌首页。
- 深层速查表统一回 `appendix/README.md`，源码剖面统一回 `source-notes/README.md`。
- 需要宿主接入、验收、修复与长期回归时，回 [../playbooks/README.md](../playbooks/README.md) 与 [../risk/README.md](../risk/README.md)，不要继续停在安全首页摘要。

## 相关目录

- [../architecture/README.md](../architecture/README.md)
  更关心安全机制如何接线、如何进入状态机与恢复链。
- [../risk/README.md](../risk/README.md)
  更关心能力撤回、资格限制、误伤与治理后果。
- [../casebooks/README.md](../casebooks/README.md)
  更关心失败样本、伪成功与恢复失真。
