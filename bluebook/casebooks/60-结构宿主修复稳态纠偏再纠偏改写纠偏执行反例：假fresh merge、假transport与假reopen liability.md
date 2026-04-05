# 结构宿主修复稳态纠偏再纠偏改写纠偏执行反例：假fresh merge、假transport与假reopen liability

这一章不再回答“结构宿主修复稳态纠偏再纠偏改写纠偏执行该怎样运行”，而是回答：

- 为什么团队明明已经写了 `rewrite correction card`、fresh merge contract、transport boundary 与 `reopen liability drill`，仍会重新退回假 authority surface、假 fresh merge、假 transport boundary、假 fail-closed worktree 与假 `reopen liability`。

它主要回答五个问题：

1. 为什么结构宿主修复稳态纠偏再纠偏改写纠偏执行最危险的失败方式不是“没有 rewrite correction card”，而是“rewrite correction card 存在，却仍围绕 pointer、telemetry 与 architecture prose 工作”。
2. 为什么假 authority surface 最容易把 `authority_object_id`、`authoritative_path`、`externally_verifiable_head` 与 `single_source_ref` 重新退回更整洁的架构说明。
3. 为什么假 fresh merge 与假 transport boundary 最容易把 `lineage reproof`、`append_chain_ref`、`stale_finally_suppressed`、`transport_boundary_attested` 与 `dirty_git_fail_closed_attested` 重新退回结果导向与恢复成功率。
4. 为什么假 `reopen liability` 最容易把 future reopen 的正式边界重新退回 reconnect 提示、旧入口与作者口述。
5. 怎样用苏格拉底式追问避免把这些反例读成“把结构 rewrite correction 再写严一点就好”。

## 0. 代表性源码锚点

- `claude-code-source-code/src/utils/QueryGuard.ts:1-121`
- `claude-code-source-code/src/utils/handlePromptSubmit.ts:430-517`
- `claude-code-source-code/src/utils/task/framework.ts:77-248`
- `claude-code-source-code/src/utils/sessionRestore.ts:435-490`
- `claude-code-source-code/src/utils/conversationRecovery.ts:186-230`
- `claude-code-source-code/src/utils/conversationRecovery.ts:375-400`
- `claude-code-source-code/src/services/api/sessionIngress.ts:57-211`
- `claude-code-source-code/src/bridge/bridgePointer.ts:22-184`
- `claude-code-source-code/src/cli/transports/WorkerStateUploader.ts:3-112`
- `claude-code-source-code/src/utils/toolResultStorage.ts:749-838`
- `claude-code-source-code/src/utils/worktree.ts:1046-1172`
- `claude-code-source-code/src/cli/transports/SSETransport.ts:156-160`
- `claude-code-source-code/src/cli/transports/SSETransport.ts:448-457`
- `claude-code-source-code/src/cli/ndjsonSafeStringify.ts:24-31`

这些锚点共同说明：

- 结构宿主修复稳态纠偏再纠偏改写纠偏执行真正最容易失真的地方，不在 `rewrite correction card` 有没有写出来，而在 authority、single-source writeback seam、lineage、fresh merge、anti-zombie evidence、transport boundary、fail-closed worktree 与 reopen boundary 是否仍围绕同一个结构真相面消费 later 维护者的判断。

## 1. 第一性原理

结构宿主修复稳态纠偏再纠偏改写纠偏执行最危险的，不是：

- 没有 `rewrite correction card`
- 没有 fresh merge contract
- 没有 transport boundary
- 没有 `reopen liability drill`

而是：

- 这些东西已经存在，却仍然围绕 pointer、telemetry 转绿、archive prose 与作者口述运作

一旦如此，团队就会重新回到：

1. 看 pointer 还在不在。
2. 看 reconnect 是不是成功了。
3. 看结果没坏就默认 merge 没问题。
4. 看 transport 没报错就默认边界还在。
5. 看作者是不是说没问题。

而不再围绕：

- 同一个 `authority_object_id + authoritative_path + single_source_ref + lineage_reproof_ref + fresh_merge_contract + anti_zombie_evidence_ref + transport_boundary_attested + dirty_git_fail_closed_attested + reopen_boundary`

## 2. 假authority surface：authority by pointer and prose

### 坏解法

- 宿主、CI、评审与交接系统虽然都拿到了 `rewrite_correction_card_id` 与 `reject_verdict=steady_state_restituted`，但真正执行时只要架构说明更完整、目录更整洁、pointer 还活着，就默认 `authority_object_id`、`authoritative_path`、`externally_verifiable_head` 与 `single_source_ref` 仍围绕同一个结构真相面成立。

### 为什么坏

- 结构 `rewrite correction card` 保护的不是“现在更像一份正式架构说明”，而是 same authority、same seam、same head 仍支撑 later 维护者的消费与反对能力。
- 一旦 authority surface 退回 architecture prose 与 pointer 健康感，团队就会重新容忍：
  - `authority_object_id` 只是说明中的名词
  - `externally_verifiable_head` 被对象自述替代
  - `single_source_ref` 只是目录意图
  - `reject_verdict` 先于对象复核生效
- 这会让更像样的架构文案与 pointer 入口直接取代结构真相面。

### Claude Code 式正解

- `reject verdict` 应先绑定同一个 `authority_object_id + authoritative_path + externally_verifiable_head + single_source_ref`，再宣布 `steady_state_restituted`。


## 3. 假fresh merge 与假transport boundary：merge by result, transport by silence

### 坏解法

- 团队虽然承认 rewrite correction 要按 `authority surface -> single-source writeback seam -> lineage reproof -> fresh merge contract -> anti-zombie evidence -> transport boundary -> dirty-git fail-closed -> reopen liability` 的固定顺序执行，但真正值班时只要结果没坏、telemetry 还绿、transport 没报错、工作树看起来还能用，就提前落下 `steady_state_restituted`，不再按顺序检查 `append_chain_ref`、`stale_finally_suppressed`、`deletion_semantics_attested`、`transport_boundary_attested` 与 `dirty_git_fail_closed_attested`。

### 为什么坏

- `fresh merge` 保护的不是“最终结果看起来还行”，而是旧 finally、旧 append、旧 snapshot 即使迟到也不能继续篡位。
- `transport boundary` 保护的不是“网络当前没报错”，而是远端与本地不会重新长出第二语义。
- `dirty_git_fail_closed` 保护的不是“当前大概没事”，而是脏状态时系统必须拒绝继续写。
- 一旦 merge 与 transport 退回结果导向，团队就会最先误以为：
  - “结果没坏就说明 merge 还健康”
  - “transport 静默就说明边界还在”
  - “工作树还能用就说明 fail-closed 还成立”
- 这会把源码先进性从 authority surface、fresh merge、transport boundary 与 fail-closed worktree 退回目录美学与恢复成功率崇拜。

### Claude Code 式正解

- `reject verdict order` 必须先证明 `lineage_reproof_ref + fresh_merge_contract + append_chain_ref + stale_finally_suppressed + transport_boundary_attested + dirty_git_fail_closed_attested` 仍围绕同一个结构真相面，再决定 `steady_state_restituted`、`merge_reproof_required`、`transport_reseal_required`、`reentry_required` 或 `reopen_required`。


## 4. 假reopen liability：liability by reconnect hint and author memory

### 坏解法

- 团队虽然写了 `reopen liability rebinding` 与 `reopen liability drill`，但真正保留责任时只是在工单里写“以后有问题再 reconnect”“原入口还在”“工作树应该没问题”，却没有正式绑定 `reopen_boundary`、`return_authority_object`、`threshold_retained_until` 与 `dirty_git_fail_closed_attested`。

### 为什么坏

- reopen liability 不是“以后再试一次”，而是“未来失稳时正式回到哪个 boundary 组合并由谁负责”。
- `fresh merge`、transport suppression 与 fail-closed worktree 都只是抗损机制，不是 reopen boundary 本身；如果系统只能靠这些 suppressor 才显得稳定，就说明 liability 还没有对象化。
- 一旦责任保留退回 reconnect 提示与作者记忆，later 团队会同时失去：
  - 正式的 recovery boundary
  - 对 stale path 的清退保证
  - 对 transport 漂移的隔离保证
  - 对 dirty git 状态的拒绝继续写保证
- 这会把 reopen 退回 retry 循环。

### Claude Code 式正解

- reopen liability 应围绕 authority、writeback、transport 与 fail-closed boundary，而不是围绕 reconnect 提示与旧入口。


## 5. 为什么这会让源码先进性退回目录美学

- Claude Code 的源码先进性从来不在“目录是不是更整洁”，而在 authority surface、single-source seam、fresh merge、anti-zombie evidence、transport boundary 与 fail-closed reopen boundary 是否先于 later 维护者的心理感受生效。
- 假 authority surface 会把结构对象退回 architecture prose。
- 假 fresh merge 会把结构判断退回结果没坏。
- 假 transport boundary 与假 fail-closed worktree 会把结构边界退回“当前没报错”。
- 假 `reopen liability` 会把未来责任退回 reconnect 提示与作者记忆。

一旦这几件事同时发生，源码先进性剩下的就不再是结构真相面，而只是：

1. 更整洁的目录叙事。
2. 更好看的健康信号。
3. 更依赖作者记忆的 later handoff。

## 6. 苏格拉底式追问

在你读完这些反例后，先问自己：

1. 我现在修回的是唯一 authority object，还是一张更正式的 rewrite correction 卡。
2. 我现在保住的是 `single-source + lineage + fresh merge`，还是更漂亮的目录与几次幸运 reconnect。
3. 我现在保住的是 `transport boundary + fail-closed worktree`，还是一种“当前没报错就先过”的冲动。
4. 我现在保留的是 future reopen 的正式 liability，还是一句“以后再试一次”。
5. later 团队明天如果必须 reopen，依赖的是正式 boundary，还是作者口述、旧入口与 retry 循环。

## 7. 一句话总结

真正危险的结构宿主修复稳态纠偏再纠偏改写纠偏执行失败，不是没跑 `rewrite correction card`，而是跑了 `rewrite correction card` 却仍在围绕假 authority surface、假 fresh merge、假 transport boundary、假 fail-closed worktree 与假 `reopen liability` 消费结构世界。
