# Artifact Runner落地导航：Queue Policy、Alignment Gate、Drift Review 与 Adoption Runbook 如何进入团队手册

这一篇不再回答“持续验证底盘为什么成立”，而是回答一个更靠近团队执行的问题：

- 当团队已经知道 replay queue、alignment gate、drift ledger 与 rewrite adoption 为什么重要之后，下一步就不该继续停在架构与 API 层，而要把它们压成 builder-facing 的日常手册。

它主要回答五个问题：

1. 为什么 Artifact Harness Runner / Drift Ledger 层之后仍需要单独讨论操作手册层。
2. 为什么真正成熟的 runner 落地，不是把实验室定时跑起来，而是把 queue policy、alignment gate、drift review 与 adoption runbook 写成团队顺序。
3. 怎样把 Prompt、安全/省 token 与结构演化三条线分别压成可执行手册。
4. 为什么这层更适合落在 `guides/`，而不是继续写进 `api/` 或 `architecture/`。
5. 怎样用苏格拉底式追问避免把这层写成“又一组模板文件”。

## 1. Prompt Artifact Runner落地手册

适合在这些问题下阅读：

- 为什么 Prompt 线不能停在 `compiled request continuity` 的 runner 协议，而必须继续回答“团队每天该怎么排 replay queue、审 stable bytes ledger、决定 rewrite adoption”。
- 为什么 Claude Code 的 Prompt 魔力要继续从对象链下沉成操作顺序，才能真正防止原文崇拜、绿灯崇拜与摘要崇拜回潮。

稳定阅读顺序：

1. `33`
2. `../guides/42`
3. `../philosophy/75`

这条线的核心不是：

- 再多看几张 prompt 卡

而是：

- 让 `prompt_object_id`、`cache-safe prefix`、`stable bytes ledger` 与 `rewrite adoption` 进入同一套日常操作顺序

## 2. 治理 Artifact Runner落地手册

适合在这些问题下阅读：

- 为什么治理线不能停在 `decision_window` 与 `rollback_object` 的 runner 协议，而必须继续回答“什么时候继续、什么时候升级对象、什么时候把仲裁冲突记进 ledger”。
- 为什么安全与省 token 设计要继续从统一语义下沉成团队动作，才能真正防止状态色、计数与 verdict 重新夺权。

稳定阅读顺序：

1. `33`
2. `../guides/43`
3. `../philosophy/75`

这条线的核心不是：

- 更频繁地看仪表盘

而是：

- 让 `decision_window`、`winner_source`、`rollback_object` 与 `object upgrade` 进入同一套治理操作顺序

## 3. 结构 Artifact Runner落地手册

适合在这些问题下阅读：

- 为什么结构线不能停在 `authoritative_path` 与 `recovery_asset_ledger` 的 runner 协议，而必须继续回答“谁进入当前 queue、谁已被 stale writer 清退、恢复后怎样重新接回主路径”。
- 为什么源码先进性要继续从 authority / anti-zombie 语义下沉成团队手册，才能真正防止目录图、成功率与作者说明重新夺权。

稳定阅读顺序：

1. `33`
2. `../guides/44`
3. `../philosophy/75`

这条线的核心不是：

- 再多补几条 anti-zombie case

而是：

- 让 `structure_object_id`、`authoritative_path`、`recovery_asset_ledger` 与 `recovery adoption` 进入同一套结构操作顺序

## 4. 为什么这层落在 guides

因为：

- `api/43-45` 已经回答“持续执行协议怎么定义”
- `architecture/78` 已经回答“持续执行底盘怎么理解”

但 builder 真正还需要回答的是：

1. 今天先审哪个队列。
2. 哪个 gate 比另一个 gate 更早发生。
3. drift ledger 应该怎样开、怎样关、怎样复盘。
4. rewrite / upgrade / recovery adoption 什么时候算真正接回主路径。

这些都属于：

- 团队如何使用源码方法

所以这层更稳的落点是：

- `guides/42-44`

## 5. 一句话用法

如果：

- `33` 回答“runner / ledger 底盘为什么成立”

那么：

- `34` 回答“团队怎样把这个底盘写成每天真的会执行的操作手册”

## 6. 苏格拉底式自检

在你准备宣布“团队已经把 runner 层落地了”前，先问自己：

1. 我是把 API 名词翻译成了文件名，还是把判断顺序翻译成了团队动作。
2. queue policy 保护的是 shared object，还是保护了某个习惯流程。
3. drift review 审的是对象漂移，还是只审通过率波动。
4. adoption runbook 恢复的是主路径，还是只恢复了文档表面。
