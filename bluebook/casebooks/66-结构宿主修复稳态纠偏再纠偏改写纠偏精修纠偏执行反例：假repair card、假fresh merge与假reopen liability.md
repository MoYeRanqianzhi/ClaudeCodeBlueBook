# 结构宿主修复稳态纠偏再纠偏改写纠偏精修纠偏执行反例：假repair card、假fresh merge与假reopen liability

这一章不再回答“结构 refinement correction execution 该怎样运行”，而是回答：

- 为什么团队明明已经写了 `repair card`、固定 `reject order` 与 `reopen drill`，仍会重新退回假 `repair card`、假 `fresh merge` 与假 `reopen liability`。

它主要回答五个问题：

1. 为什么结构 refinement correction execution 最危险的失败方式不是“没有 repair card”，而是“card 存在，却仍围绕 pointer、telemetry、archive prose、脏 worktree 侥幸与 reconnect 提示工作”。
2. 为什么假 `repair card` 最容易把 `authority_object_id`、`authoritative_path`、`externally_verifiable_head` 与 `single_source_ref` 重新退回更整洁的架构说明。
3. 为什么假 `fresh merge` 最容易把 `lineage reproof`、`append_chain_ref`、`stale_finally_suppressed`、`anti_zombie_evidence_ref` 与 `dirty_git_fail_closed_attested` 重新退回结果导向与恢复成功率。
4. 为什么假 `reopen liability` 最容易把 future reopen 的正式边界重新退回 reconnect 提示、旧入口与作者口述。
5. 怎样用苏格拉底式追问避免把这些反例读成“把结构 repair card 再写严一点就好”。

## 0. 代表性源码锚点

- `claude-code-source-code/src/utils/QueryGuard.ts:1-121`
- `claude-code-source-code/src/utils/sessionRestore.ts:435-490`
- `claude-code-source-code/src/utils/conversationRecovery.ts:186-230`
- `claude-code-source-code/src/bridge/bridgePointer.ts:22-184`
- `claude-code-source-code/src/cli/transports/WorkerStateUploader.ts:3-112`
- `claude-code-source-code/src/utils/worktree.ts:1046-1172`
- `claude-code-source-code/src/services/api/sessionIngress.ts:57-211`

这些锚点共同说明：

- 结构 refinement correction execution 真正最容易失真的地方，不在 `repair card` 有没有写出来，而在 authority、single-source writeback、lineage、fresh merge、anti-zombie、transport boundary、dirty git fail-closed 与 reopen boundary 是否仍围绕同一个结构真相面消费 later 维护者的判断。

## 1. 第一性原理

结构 refinement correction execution 最危险的，不是：

- 没有 `repair card`
- 没有 `reject order`
- 没有 `reopen drill`

而是：

- 这些东西已经存在，却仍然围绕 pointer、telemetry 转绿、archive prose、脏工作树侥幸与 reconnect 提示运作

一旦如此，团队就会重新回到：

1. 看 pointer 还在不在。
2. 看 reconnect 是不是成功了。
3. 看结果没坏就默认 merge 没问题。
4. 看工作树当前还能用就默认 fail-closed 还在。
5. 看作者是不是说没问题。

而不再围绕：

- 同一个 `authority_object_id + authoritative_path + externally_verifiable_head + single_source_ref + resume_lineage_ref + fresh_merge_contract_attested + anti_zombie_evidence_ref + transport_boundary_attested + dirty_git_fail_closed_attested + reopen_boundary`

## 2. 假repair card：card by pointer and prose

### 坏解法

- 宿主、CI、评审与交接系统虽然都拿到了 `repair_card_id` 与 `reject_verdict=steady_state_chain_resealed`，但真正执行时只要架构说明更完整、目录更整洁、pointer 还活着，就默认 `authority_object_id`、`authoritative_path`、`externally_verifiable_head` 与 `single_source_ref` 仍围绕同一个结构真相面成立。

### 为什么坏

- 结构 `repair card` 保护的不是“现在更像一份正式运行卡”，而是 same authority、same seam、same head 仍支撑 later 维护者的消费与反对能力。
- 一旦修正卡退回 architecture prose 与 pointer 健康感，团队就会重新容忍：
  - `authority_object_id` 只是说明中的名词
  - `externally_verifiable_head` 被对象自述替代
  - `single_source_ref` 只是目录意图
  - `reject_verdict` 先于对象复核生效
- 这会让更像样的架构文案与 pointer 入口直接取代结构真相面。

### Claude Code 式正解

- `reject verdict` 应先绑定同一个 `authority_object_id + authoritative_path + externally_verifiable_head + single_source_ref`，再宣布 `steady_state_chain_resealed`。

### 改写路径

1. 把目录整洁度、架构 prose 与 pointer 健康感降为次级信号。
2. 把 `authority_object_id + authoritative_path + externally_verifiable_head + single_source_ref` 提升为前提。
3. 任何先看解释、后看结构对象的 refinement correction execution 都判为 drift。

## 3. 假fresh merge：merge by result and luck

### 坏解法

- 团队虽然承认 refinement correction execution 要按 `authority surface -> single-source writeback -> lineage resume -> fresh merge -> anti-zombie -> transport boundary -> fail-closed worktree -> reopen liability` 的固定顺序执行，但真正值班时只要结果没坏、telemetry 还绿、工作树当前还能用、没有立刻炸出 git 错误，就提前落下 `steady_state_chain_resealed`，不再按顺序检查 `append_chain_ref`、`stale_finally_suppressed`、`anti_zombie_evidence_ref`、`worktree_change_guard` 与 `dirty_git_fail_closed_attested`。

### 为什么坏

- `fresh merge` 保护的不是“最终结果看起来还行”，而是旧 finally、旧 append、旧 snapshot 即使迟到也不能继续篡位。
- `anti-zombie` 保护的不是“当前很安静”，而是旧 generation、旧 writer 与 orphan state 已经真的失去回写资格。
- `dirty git fail-closed` 保护的不是“当前大概没事”，而是脏状态时系统必须拒绝继续写。
- 一旦 merge 退回结果导向，团队就会最先误以为：
  - “结果没坏就说明 merge 还健康”
  - “当前还能写就说明 fail-closed 还成立”
  - “git 没立刻报错就说明 worktree 还安全”
- 这会把源码先进性从 authority、merge 与 fail-closed object 退回恢复成功率崇拜。

### Claude Code 式正解

- `reject order` 必须先证明 `resume_lineage_ref + append_chain_ref + stale_finally_suppressed + anti_zombie_evidence_ref + worktree_change_guard + unpushed_commit_guard + dirty_git_fail_closed_attested` 仍围绕同一个结构真相面，再决定 `steady_state_chain_resealed`、`merge_reproof_required`、`fail_closed_reseal_required` 或 `reopen_required`。

### 改写路径

1. 把结果没坏、telemetry 转绿与“git 当前没炸”降为观察信号。
2. 把 `fresh_merge + anti_zombie + fail-closed` 提升为正式对象。
3. 任何“结果还行就算 refinement 完成”的结构 execution 都判为 drift。

## 4. 假reopen liability：liability by reconnect hint and author memory

### 坏解法

- 团队虽然写了 `reopen liability ledger` 与 `reopen drill`，但真正保留责任时只是在工单里写“以后有问题再 reconnect”“原入口还在”“工作树应该没问题”，却没有正式绑定 `reopen_boundary`、`return_authority_object`、`return_writeback_path` 与 `threshold_retained_until`。

### 为什么坏

- reopen liability 不是“以后再试一次”，而是“未来失稳时正式回到哪个 boundary 组合并由谁负责”。
- `fresh merge` 与 `dirty git fail-closed` 都只是抗损机制，不是 reopen boundary 本身；如果系统只能靠这些 suppressor 才显得稳定，就说明 liability 还没有对象化。
- 一旦责任保留退回 reconnect 提示与作者记忆，later 团队会同时失去：
  - 正式的 recovery boundary
  - 对 stale path 的清退保证
  - 对 dirty git 状态的拒绝继续写保证
  - 对 transport 漂移的隔离保证
- 这会把 reopen 退回 retry 循环。

### Claude Code 式正解

- reopen liability 应围绕 authority、writeback、fail-closed 与 return boundary，而不是围绕 reconnect 提示与旧入口。

### 改写路径

1. 把 reconnect 提示与作者口述降为动作说明，不再当 liability 对象。
2. 把 `reopen_boundary + return_authority_object + return_writeback_path + threshold_retained_until + dirty_git_fail_closed_attested` 提升为正式对象。
3. 任何只让 later 团队“以后再试一次恢复”的结构 refinement correction execution 都判为 drift。

## 5. 为什么这会让源码先进性退回目录美学

- Claude Code 的源码先进性从来不在“目录是不是更整洁”，而在 authority、single-source seam、fresh merge、anti-zombie、transport boundary、fail-closed 与 reopen boundary 是否先于 later 维护者的心理感受生效。
- 假 `repair card` 会把结构对象退回 architecture prose。
- 假 `fresh merge` 会把结构判断退回结果没坏。
- 假 `reopen liability` 会把未来责任退回 reconnect 提示与作者记忆。

一旦这几件事同时发生，源码先进性剩下的就不再是结构真相面，而只是：

1. 更整洁的目录叙事。
2. 更好看的健康信号。
3. 更依赖作者记忆的 later handoff。

## 6. 苏格拉底式追问

在你读完这些反例后，先问自己：

1. 我现在修回的是唯一 authority object，还是一张更正式的修正卡。
2. 我现在保住的是 `single-source + fresh merge`，还是更漂亮的目录与几次幸运 reconnect。
3. 我现在保住的是 `anti-zombie + dirty git fail-closed`，还是一种“当前没报错就先过”的冲动。
4. 我现在保留的是 future reopen 的正式 liability，还是一句“以后再试一次”。
5. later 团队明天如果必须 reopen，依赖的是正式 boundary，还是作者口述、旧入口与 retry 循环。

## 7. 一句话总结

真正危险的结构宿主修复稳态纠偏再纠偏改写纠偏精修纠偏执行失败，不是没跑 `repair card`，而是跑了 `repair card` 却仍在围绕假 `repair card`、假 `fresh merge` 与假 `reopen liability` 消费结构世界。
