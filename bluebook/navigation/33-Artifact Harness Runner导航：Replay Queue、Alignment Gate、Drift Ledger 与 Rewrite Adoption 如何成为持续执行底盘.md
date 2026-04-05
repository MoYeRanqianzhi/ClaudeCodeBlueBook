# Artifact Harness Runner导航：Replay Queue、Alignment Gate、Drift Ledger 与 Rewrite Adoption 如何成为持续执行底盘

这一篇不再回答“回放实验室怎样设计”，而是回答一个更靠近持续执行底盘的问题：

- 当团队已经有 `replay case`、`alignment assertion`、`drift regression` 与 `rewrite replay` 之后，下一步就不该继续停在“实验室能否证明同一 reject semantics”，而要把这些实验室接成可排队执行、可持续留痕、可采纳改写、可跨消费者复查的正式 runner。

它主要回答五个问题：

1. 为什么 Artifact Evaluator Harness / Replay Lab 层之后仍需要单独讨论 harness runner / drift ledger 层。
2. 为什么真正成熟的持续验证，不是 replay case 更多，而是 replay queue、alignment gate、drift ledger 与 rewrite adoption 共用同一 shared object。
3. 怎样把 Prompt、安全/省 token 与结构演化三条线分别压成可持续执行协议，而不是继续停在 playbook。
4. 为什么这一层应该同时落在 `api/` 与 `architecture/`，而不是重新放回 `playbooks/`。
5. 怎样用苏格拉底式追问避免把这层写成“又一套验证管线术语”。

## 1. Prompt Artifact Harness Runner

适合在这些问题下阅读：

- 为什么 Prompt 线不能停在 continuation replay 实验室，而必须继续证明 `compiled request continuity` 怎样被持续排队执行、持续记录 drift、持续采纳 rewrite。
- 为什么 Claude Code 的 Prompt 魔力进入运行层之后，必须靠 runner / ledger 才能证明共享的不是一次 replay，而是可持续复用的 continuation 真相。

稳定阅读顺序：

1. `32`
2. `../api/43`
3. `../architecture/78`
4. `../philosophy/74`

这条线的核心不是：

- 再补几条 replay case

而是：

- 让 `prompt_object_id`、`compiled_request_diff_ref`、`stable_bytes_ledger_ref` 与 `lawful_forgetting_abi_ref` 在每次执行后都进入同一 drift ledger

## 2. 治理 Artifact Harness Runner

适合在这些问题下阅读：

- 为什么治理线不能停在 decision gain replay 实验室，而必须继续证明 `decision_window`、`control_arbitration_truth`、`rollback_object` 与 `next_action` 怎样被持续执行和持续追责。
- 为什么安全与省 token 设计进入运行层之后，必须靠 runner / ledger 才能证明共享的不是一次 upgrade verdict，而是持续执行的“没有决策增益就不继续”。

稳定阅读顺序：

1. `32`
2. `../api/44`
3. `../architecture/78`
4. `../philosophy/74`

这条线的核心不是：

- 让门禁重复返回 `upgrade_required`

而是：

- 让 `decision_window`、`arbitration_source` 与 `rollback_object` 在每次继续 / 停止 / 回退之后都进入同一 governance ledger

## 3. 结构 Artifact Harness Runner

适合在这些问题下阅读：

- 为什么结构线不能停在 split-brain / anti-zombie replay 实验室，而必须继续证明 `authoritative_path`、`recovery_asset_ledger`、`dropped_stale_writers` 与 `rollback_object` 怎样被持续执行和持续交接。
- 为什么源码先进性进入运行层之后，必须靠 runner / ledger 才能证明共享的不是一次结构拒收，而是持续防止 split-brain 与 stale writer 的执行秩序。

稳定阅读顺序：

1. `32`
2. `../api/45`
3. `../architecture/78`
4. `../philosophy/74`

这条线的核心不是：

- 再证明一次 anti-zombie replay

而是：

- 让 `structure_object_id`、`authoritative_path`、`recovery_asset_ledger` 与 `dropped_stale_writers` 在每次执行后都进入同一 structure ledger

## 4. 为什么这一层不再放回 playbooks

因为 `playbooks/23-25` 已经回答了：

- 实验室怎样重放
- case 怎样设计
- replay 输出长什么样

但 runner / ledger 层要继续回答的是：

1. 哪些 replay case 进入队列。
2. 哪些 alignment assertion 先于 rewrite adoption。
3. drift ledger 怎样成为下次继续执行的输入。
4. 哪些字段应该机器可读，哪些判断必须进入 runtime chokepoint。

所以这层更稳的落点是：

- `api/43-45` 负责定义持续执行协议
- `architecture/78` 负责定义持续执行底盘

## 5. 一句话用法

如果：

- `32` 回答“这些规则怎样被组织成可重放验证与跨消费者对齐实验室”

那么：

- `33` 回答“这些实验室怎样继续进入 replay queue、alignment gate、drift ledger 与 rewrite adoption 的持续执行底盘”

## 6. 苏格拉底式自检

在你准备宣布“团队已经有持续验证 runner 了”前，先问自己：

1. 我只是把实验室定时跑起来，还是已经让 replay verdict、rewrite adoption 与 drift ledger 进入同一对象链。
2. 同一 shared object 断裂时，runner 记录的是对象 drift，还是只记录脚本通过率。
3. rewrite adoption 是在恢复 shared object，还是在补几段更好看的说明。
4. drift ledger 是否真的会反过来约束下一次继续执行，还是仍然只是事后复盘附件。
