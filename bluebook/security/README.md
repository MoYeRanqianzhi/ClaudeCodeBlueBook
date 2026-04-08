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
