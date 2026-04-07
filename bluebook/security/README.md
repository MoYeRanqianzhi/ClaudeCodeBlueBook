# 安全专题入口

`security/` 研究的不是“规则越多越安全”，而是动作、权威、上下文与时间四种扩张如何被同一条治理秩序收费，以及弱 signer 为什么永远不配越级冒充强 signer。
更短地说：安全与省 token 在这里保护的是同一个 model-reachable world；前者阻止免费危险扩张，后者阻止免费昂贵扩张。
如果你还没先经过 `09 / 05 / 15 / 41` 这组高阶入口顺序，不要急着把安全页读成另一套规则堆。
`security/` 内部也继续继承 `问题分型 -> 工作对象 -> 控制面 -> 入口`：先判这次在失真的到底是 signer、ledger 还是 cleanup 工作对象，再判它卡在治理收费链的哪一段，最后才决定读机制入口摘要、速查表、源码证据簇还是具体编号正文。

如果只先记安全入口判定的一句话，也只记这句：

- 这不是第二套安全故事，而是同一条 `governance key -> externalized truth chain -> typed ask -> decision window -> continuation pricing -> durable-transient cleanup` 收费链在安全目录里的机制翻译。

如果你只缺治理收费链的一屏速记，而不是安全侧机制翻译，先回 [../10-治理收费链入口卡：四类被收费资源、reject trio 与弱读回面](../10-%E6%B2%BB%E7%90%86%E6%94%B6%E8%B4%B9%E9%93%BE%E5%85%A5%E5%8F%A3%E5%8D%A1%EF%BC%9A%E5%9B%9B%E7%B1%BB%E8%A2%AB%E6%94%B6%E8%B4%B9%E8%B5%84%E6%BA%90%E3%80%81reject%20trio%20%E4%B8%8E%E5%BC%B1%E8%AF%BB%E5%9B%9E%E9%9D%A2.md)；`security/` 只保留 signer / ledger / cleanup authority 的安全侧翻译。

这里还应再多记一句：

- `continuity` 在安全目录里也不是第四类安全主题；它只是 `decision window -> continuation pricing -> durable-transient cleanup` 这段时间轴在安全侧的继续资格与清算资格。

## 先记四句

- 安全不是单点沙箱，也不是单点分类器；它是同一条 `governance key -> externalized truth chain -> typed ask -> decision window -> continuation pricing -> durable-transient cleanup` 在 signer authority、truth-surface attestation、ask arbitration、continuation pricing 与 cleanup authority 上的安全侧翻译。
- `governance key -> externalized truth chain -> typed ask -> decision window -> continuation pricing -> durable-transient cleanup` 不是两条结果词入口的拼接，而是同一条治理收费链。
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

如果把安全入口判定继续压成最短公式，也只剩三条：

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

## 高阶入口顺序

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

## 什么时候进来

- 当你已经知道统一定价治理成立，但还没回答 signer、ledger 与 cleanup 责任究竟落在哪些对象上。
- 当你需要判断哪种扩张该被 ask、哪种 truth 必须外化、哪种 cleanup 不配越级宣布终局。
- 当你需要把“安全”和“省 token”继续压成同一治理纪律，而不是并列专题。
- 当你需要把 user-facing 的 runtime readback consumer 与 continuation consumer 退回它们各自只配消费的治理阶段，而不是再让 projection 词或 consumer 词冒充治理主语。
- 当你需要判断哪个对象只是弱读回面、哪个对象仍保留 signer authority，以及 cleanup 之后谁还配留下 reopen liability。

更稳的 first reject signal 还应先记三条：

1. usage 读数、permission 投影和 token 条开始冒充治理真相
2. cleanup 结果词开始越级替 signer 和 verdict 说话
3. `Later / Outside`、default continuation 或全量可见重新让免费扩张复活

## 继续下潜时

- 只按对象 handoff 继续：来源主权、能力边界与显式降级看 `00-29`；当前真相、账本与 failure semantics 看 `30-138`；`receipt -> completion -> finality -> forgetting` 与 cleanup ladder 看 `147-224`。
- 只按证据层 handoff 回跳：字段矩阵与速查表回 [appendix/README.md](appendix/README.md)，源码证据簇回 [source-notes/README.md](source-notes/README.md)，长期记忆与目录治理回 [../../docs/development/security/README.md](../../docs/development/security/README.md)。

## 维护约定

- `security/README` 只保留入口判断、编号段职责与分流。
- `security/README` 只负责治理 signer / ledger / cleanup 入口摘要，不和 `risk/` 抢用户侧恢复与入口差异摘要，也不和 `playbooks/` 抢执行链。
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
