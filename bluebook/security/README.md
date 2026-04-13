# 安全专题入口

`security/` 只处理三类机制 ambiguity：`signer / verdict ledger / cleanup authority`。安全在这里不是第二条优化线，而是回答最早 `unpaid expansion` 怎样被 signer、记账与 cleanup authority 阻止免费续租。
若你还没先在 `10` 定位最早 `unpaid expansion`，本页不开始；那时你缺的还是治理前门，不是安全机制翻译。

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

这里还应先压住一条分流纪律：`sandboxing` 不构成第四类 ambiguity，它只是 signer 已起租后的 boundary custody；而 `async hook / weak readback / host replay` 若开始改写 allow、continue 或 cleanup 结论，应先分别退回 `ledger / cleanup authority ambiguity`，而不是另发一条安全主线。更硬一点说，`approval receipt / status / host replay` 若没有新增 `decision delta`，就只是在重复同一条 boundary decision 或同一段 lease checkpoint，因此一律按 `zero-delta ask / weak readback` 处理。
还要再分清一层：`approval receipt / status green / modal closeout` 这类 readback surface 即使带着“已允许”措辞，也最多证明 ledger 上记过一次 verdict，不证明 signer ceiling 合法；若团队开始拿 receipt 反推“谁配批准”，应先按 `signer ambiguity` 处理。
更硬一点说，任何 surface 只有在新增 signer 证据、boundary delta 或 cleanup delta 时，才配从安全 readback 升级成治理事实；否则就只配留在 receipt-grade。
同理，安全效率也不是 approval 更快，而是 delta-free approvals 更少；若批准更快却没有减少零增量 ask，治理仍在为同一条 boundary decision 重复付费。

如果一条安全判断还压不回这三类 ambiguity，它就还停在规则堆或工具堆层；如果已经开始重发治理 stage names，这页就又在代签 `10`。

## 什么时候进来

- 当你已经定位到最早 `unpaid expansion`，但 signer、ledger 与 cleanup 责任还没落到具体对象上。
- 当弱层开始替 signer 说话、结果词开始冒充治理事实，或 cleanup 之后谁还配负责开始失真。

## 维护约定

- `security/README` 只保留入口判断、编号段职责与分流。
- `security/README` 只负责治理 signer / ledger / cleanup 入口摘要，不和 `risk/` 抢用户侧恢复与入口差异摘要，也不和 `playbooks/` 抢执行链。
- `security/README` 有 signer/ledger 机制解释权，但没有用户侧恢复签发权，也没有现场执行 verdict 的代签权。
- 需要宿主接入、验收、修复与长期回归时，回 [../playbooks/README.md](../playbooks/README.md) 与 [../risk/README.md](../risk/README.md)，不要继续停在安全首页摘要。

相关对象页与证据页统一留给对应目录；安全首页不再补充目录菜单。
