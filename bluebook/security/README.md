# 安全专题入口

`security/` 研究的不是“规则越多越安全”，也不是与省 token 并列的第二条优化线，而是 signer、ledger 与 cleanup authority 这三种不对称如何阻止最早 `unpaid expansion` 免费续租。
更短地说：安全入口第一问不是“哪条规则更严”，而是“最早 `unpaid expansion` 是什么，以及 signer / verdict ledger / cleanup authority 怎样让这次扩张不能免费继续”。
若你还没先在 `10` 定位最早 `unpaid expansion`，本页不开始；那时你缺的还是治理前门，不是安全机制翻译。
`security/` 内部也不再自建 syllabus，只保留三件事：谁在签字、谁在记 `verdict ledger`、谁在 `cleanup` 时撤租旧 authority。若这三件事还答不上，再复用 `10` 的 `same scene? still priced? who settles?` 去看 lease 到底卡在哪，但不在首页编排“先读哪类材料”。

## 入场条件

- 已定位最早 `unpaid expansion`。
- 问题明确落在 signer / `verdict ledger` / `cleanup authority` 其中一类 ambiguity。
- 若还在问 why、尾部读回或执行动作，统一离场到 `../10`、`../risk/README.md`、`../playbooks/README.md`。

如果把安全首页继续压成最短公式，也只剩三类 ambiguity：

1. `signer ambiguity`
   - 谁配签字
2. `ledger / verdict ambiguity`
   - 谁在记账（`verdict ledger`），谁在宣布治理事实
3. `cleanup authority ambiguity`
   - 谁能收口

如果一条安全判断还压不回这三类 ambiguity，它就还停在规则堆或工具堆层；如果已经开始重发 canonical chain 的 stage names，这页就又在代签 `10`。

## 什么时候进来

- 当你已经定位到最早 `unpaid expansion`，但还没回答 signer、ledger 与 cleanup 责任究竟落在哪些对象上。
- 当 signer 到底是谁仍然模糊，弱层开始越级替强层说话。
- 当 ledger 与 verdict 的边界模糊，结果词开始冒充治理事实。
- 当 cleanup authority 到底落在哪仍不清楚，收口后谁还配负责也开始失真。

更稳的读法是：若 projection、状态词或收口结果开始替 signer / verdict 说话，把它们先当安全症状，而不是治理事实；缺字段矩阵与源码证据簇时再去 appendix 或 source-notes，不在首页列材料菜单。

## 维护约定

- `security/README` 只保留入口判断、编号段职责与分流。
- `security/README` 只负责治理 signer / ledger / cleanup 入口摘要，不和 `risk/` 抢用户侧恢复与入口差异摘要，也不和 `playbooks/` 抢执行链。
- `security/README` 有 signer/ledger 机制解释权，但没有用户侧恢复签发权，也没有现场执行 verdict 的代签权。
- 巨型目录库存、逐篇标题镜像和作者侧记忆不再回灌首页。
- 深层速查表统一回 `appendix/README.md`，源码剖面统一回 `source-notes/README.md`。
- 需要宿主接入、验收、修复与长期回归时，回 [../playbooks/README.md](../playbooks/README.md) 与 [../risk/README.md](../risk/README.md)，不要继续停在安全首页摘要。

相关对象页与证据页统一留给对应目录；安全首页不再补充目录菜单。
