# 安全专题入口

`security/` 研究的不是“规则越多越安全”，而是 signer、ledger 与 cleanup authority 这三种不对称如何阻止免费危险扩张与免费昂贵扩张。
更短地说：安全与省 token 在这里保护的是同一个 model-reachable world；前者拒绝未授权危险扩张，后者拒绝未定价昂贵扩张。
如果你还没先经过 `09 / 05 / 15 / 41` 这组高阶入口顺序，不要急着把安全页读成另一套规则堆。
`security/` 内部也继续继承 `问题分型 -> 工作对象 -> 控制面 -> 入口`：先判这次在失真的到底是 signer、ledger 还是 cleanup 工作对象，再判它卡在治理收费链的哪一段，最后才决定读机制入口摘要、速查表、源码证据簇还是具体编号正文。

如果只先记安全入口判定的一句话，也只记这句：

- 这不是第二套安全故事，而是同一治理收费链在 signer / ledger / cleanup authority 上的机制翻译。

如果你只缺治理收费链的一屏速记，而不是安全侧机制翻译，先回 [../10-治理收费链入口卡：四类被收费资源、reject trio 与弱读回面](../10-%E6%B2%BB%E7%90%86%E6%94%B6%E8%B4%B9%E9%93%BE%E5%85%A5%E5%8F%A3%E5%8D%A1%EF%BC%9A%E5%9B%9B%E7%B1%BB%E8%A2%AB%E6%94%B6%E8%B4%B9%E8%B5%84%E6%BA%90%E3%80%81reject%20trio%20%E4%B8%8E%E5%BC%B1%E8%AF%BB%E5%9B%9E%E9%9D%A2.md)；`security/` 只保留 signer / ledger / cleanup authority 的安全侧翻译。

这里还应再多记一句：

- `continuity` 在安全目录里也不是第四类安全主题；它只是安全侧的继续资格与清算资格。

## 先记四句

- 安全页只翻译 signer / ledger / cleanup authority 的不对称；canonical chain 与 readback vocabulary 一律回 `../10` 与 `risk/`。
- 完成、终局、遗忘与清理都各有 signer；弱层最多触发怀疑或消费已外化 verdict，不能替强层宣布“已经没事了”。
- 宿主与 user-facing 入口只配消费 runtime 已外化的治理结果，不配自己从投影回放拼当前真相。
- 如果你已经开始列 stage names、consumer classes 或恢复术语，说明这页又在越位代签；更细顺序、尾部读回与执行尾链统一回 `../10`、`risk/` 与 `playbooks/`。

如果把安全入口判定继续压成最短公式，也只剩三种不对称：

1. `signer ambiguity`
   - 谁配签字
2. `ledger / verdict ambiguity`
   - 谁在记账（`verdict ledger`），谁在宣布治理事实
3. `cleanup authority ambiguity`
   - 谁能收口

如果你已经开始重发 canonical chain 的 stage names，说明这页又在代签 `10`。

如果一个安全判断还压不回 `signer ambiguity / ledger-verdict ambiguity / cleanup authority ambiguity` 这三类入口，它就还停在规则堆或工具堆层。
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
  看治理控制面如何把定价对象与 choke point 写成同一条流水线。
- 若已确认自己缺的是 signer / projection / cleanup 不对称，继续下潜到对应编号页，而不要把这些机制读成彼此独立的安全专题。

## 什么时候进来

- 当你已经知道统一定价治理成立，但还没回答 signer、ledger 与 cleanup 责任究竟落在哪些对象上。
- 当 signer 到底是谁仍然模糊，弱层开始越级替强层说话。
- 当 ledger 与 verdict 的边界模糊，结果词开始冒充治理事实。
- 当 cleanup authority 到底落在哪仍不清楚，收口后谁还配负责也开始失真。

更稳的读法是：若 projection、状态词或收口结果开始替 signer / verdict 说话，把它们先当安全症状，而不是治理事实；更细弱读回与拒收语义统一回 `../10` 与 `risk/`。

## 继续下潜时

- 只按对象 handoff 继续：来源主权、能力边界与显式降级看 `00-29`；当前真相、账本与 failure semantics 看 `30-138`；cleanup 收口对象继续看 `147-224`。
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
