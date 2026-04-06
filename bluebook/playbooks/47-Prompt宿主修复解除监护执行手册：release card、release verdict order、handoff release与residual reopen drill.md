# Prompt宿主修复解除监护执行手册：Authority、Boundary、Transcript、Lineage、Continuation 与 residual reopen drill

这一章不再解释 Prompt 宿主修复解除监护协议该消费哪些字段，而是把 Claude Code 式 Prompt 出监压成一张可持续执行的 side-door playbook。

它主要回答五个问题：

1. 宿主、CI、评审与交接怎样共享同一条 Prompt release 判断链，而不是各自围绕 watch note、handoff 文案与“最近没出事”工作。
2. 应该按什么固定顺序执行 Prompt 解除监护，才能真正围绕同一个世界宣布 released、阻断 handoff 或保留 residual reopen。
3. 哪些 release reason 一旦出现就必须立即阻断 handoff、拒绝 release 并进入 residual reopen drill。
4. 哪些演练最能暴露 Prompt watch release 又重新退回静默放行、叙事放行与无责任 release。
5. 怎样用第一性原理与苏格拉底式追问避免把这层写成“更细的结束观察清单”。

## 0. 第一性原理

Prompt 宿主修复解除监护真正要执行的不是：

- watch window 里最近没有告警
- watch note 已经写完整了
- handoff 包似乎还能继续读

而是：

- Authority、Boundary、Transcript、Lineage 与 Continuation 仍在共同定义同一个世界，同时 residual reopen 的正式责任没有被删除

## 1. 固定 release 顺序

### 1.1 先验 `Authority`

先看当前准备解除监护的，到底是不是同一个 authority winner 与同一个 restored request object。

只要对象不清楚，就不能进入 release。

### 1.2 再验 `Boundary`

再看 `stable prefix`、`lawful forgetting` 与 `baseline drift ledger seal` 是否共同成立。

如果 drift 只是暂时沉默，不是正式 seal，就还不能 released。

### 1.3 再验 `Transcript`

再看当前解除监护所依赖的，究竟是不是同一个 `protocol transcript`。

只要 display transcript、watch note 与 handoff prose 还能夺权，release 就还没有成立。

### 1.4 再验 `Lineage`

再看 `truth lineage`、`compaction lineage` 与 `resume lineage` 是否仍共同见证 later 团队可接手的同一身份链。

### 1.5 再验 `Continuation`

再看：

1. `continuation_clearance` 是否仍成立。
2. `required_preconditions` 与 `rollback_boundary` 是否仍围绕同一 continuation object。
3. `residual_reopen_gate` 是否仍正式保留。

### 1.6 最后才给 `Explainability`

最后才看：

1. `release card`
2. `release verdict`
3. `release reason`
4. `watch note`
5. `handoff prose`

它们都只能作为 Explainability 末端投影发放，不能反向定义是否 released。

## 2. 直接阻断条件

出现下面情况时，应直接阻断当前 Prompt release：

1. `release_object_missing`
2. `authority_blur`
3. `boundary_unsealed`
4. `transcript_conflation`
5. `lineage_unproven`
6. `continuation_not_cleared`
7. `residual_gate_missing`
8. `reopen_required`

## 3. handoff release 与 residual reopen 顺序

看到阻断 reason 之后，更稳的处理顺序是：

1. 先冻结 handoff，不再让 later 消费当前 release 工件。
2. 先把当前 verdict 降级为 `monitor_extended` 或 `reopen_required`。
3. 先回到上一个仍可验证的 authority winner、boundary bundle 与 protocol transcript。
4. 先补新的 witness、lineage 与 clearance，再允许重新发放 handoff release warranty。
5. 如果根因落在 release 制度本身，就回跳 `../guides/69` 做制度纠偏。

## 4. 最小 residual reopen 演练集

每轮至少跑下面六个 Prompt 宿主解除监护执行演练：

1. `authority_reconsume`
2. `boundary_reseal_replay`
3. `transcript_reconsume`
4. `lineage_resume_recheck`
5. `continuation_clearance_replay`
6. `residual_reopen_gate_replay`

## 5. 苏格拉底式检查清单

在你准备宣布“Prompt 宿主修复已经 released”前，先问自己：

1. 我现在 release 的是对象，还是一段更顺滑的值班叙事。
2. `stability witness` 证明的是稳定，还是只是平静。
3. handoff release 释放的是 continuation object，还是一段摘要故事。
4. residual reopen gate 还在不在，如果不在，我是在 release，还是在删风险痕迹。
5. 如果把 release card、watch note 与 handoff prose 都藏起来，later 团队是否仍知道该如何继续判断。

## 6. 一句话总结

真正成熟的 Prompt 宿主修复解除监护执行，不是宣布“现在终于没事了”，而是持续证明同一个 `Authority -> Boundary -> Transcript -> Lineage -> Continuation` 已经足够稳到可以停止额外监护，同时 residual reopen 责任仍在。
