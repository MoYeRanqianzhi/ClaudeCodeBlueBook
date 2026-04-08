# 安全专题入口

`security/` 研究的不是“规则越多越安全”，也不是与省 token 并列的第二条优化线，而是 signer、ledger 与 cleanup authority 这三种不对称如何阻止最早 `unpaid expansion` 免费续租。
更短地说：安全入口第一问不是“哪条规则更严”，而是“最早 `unpaid expansion` 是什么，以及 signer / verdict ledger / cleanup authority 怎样让这次扩张不能免费继续”。
若你还没先在 `10` 定位最早 `unpaid expansion`，本页不开始；那时你缺的还是治理前门，不是安全机制翻译。
`security/` 内部也不再自建 syllabus，只保留三件事：谁在签字、谁在记 `verdict ledger`、谁在 `cleanup` 时撤租旧 authority。若这三件事还答不上，再复用 `10` 的 `same scene? still priced? who settles?` 去看 lease 到底卡在哪，再决定读机制入口摘要、速查表、源码证据簇还是具体编号正文。

如果只先记安全入口判定的一句话，也只记这句：

- 这不是第二套安全故事，而是同一治理收费链在 signer / ledger / cleanup authority 上的机制翻译。
- 换句话说，安全页不先决定“更严”，而先决定哪次扩张没有被合法 repricing、哪份 lease 还没被结算。

如果你只缺治理收费链的一屏速记，而不是安全侧机制翻译，先回 [../10-治理收费链入口卡：最早 unpaid expansion、reject trio 与弱读回面](../10-%E6%B2%BB%E7%90%86%E6%94%B6%E8%B4%B9%E9%93%BE%E5%85%A5%E5%8F%A3%E5%8D%A1%EF%BC%9A%E6%9C%80%E6%97%A9%20unpaid%20expansion%E3%80%81reject%20trio%20%E4%B8%8E%E5%BC%B1%E8%AF%BB%E5%9B%9E%E9%9D%A2.md)；`security/` 只保留 signer / ledger / cleanup authority 的安全侧翻译。

这里还应再多记一句：

- `continuity` 在安全目录里也不是第四类安全主题；它继续只复用 `10` 的 lease checkpoint：`same scene? still priced? who settles?`

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

若要把一条安全说法当成强结论，至少先能点名四个 intake object：

- `signer_ref`
- `verdict_ledger_ref`
- `cleanup_ref`
- `lease_revocation_condition`

一个都点不出来时，先按弱投影或读回面处理，不按安全真相处理。

如果你已经开始重发 canonical chain 的 stage names，说明这页又在代签 `10`。

如果一个安全判断还压不回 `signer ambiguity / ledger-verdict ambiguity / cleanup authority ambiguity` 这三类入口，它就还停在规则堆或工具堆层。
如果一个安全判断还答不上“它保护的到底是哪种工作对象、哪段收费链、哪个入口只是证据层 consumer”，就说明它还没压回第一性原理。

## 高阶入口顺序

想先抓第一性原理，统一回 `../10`；安全首页只保留 `signer / ledger / cleanup authority` 的机制分诊与 handoff，不再重建多跳 syllabus。

## 什么时候进来

- 当你已经定位到最早 `unpaid expansion`，但还没回答 signer、ledger 与 cleanup 责任究竟落在哪些对象上。
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
