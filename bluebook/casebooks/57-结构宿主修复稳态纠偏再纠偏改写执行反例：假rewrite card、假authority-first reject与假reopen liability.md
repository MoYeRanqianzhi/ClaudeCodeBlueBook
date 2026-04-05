# 结构宿主修复稳态纠偏再纠偏改写执行反例：假rewrite card、假authority-first reject与假reopen liability

这一章不再回答“结构宿主修复稳态纠偏再纠偏改写执行该怎样运行”，而是回答：

- 为什么团队明明已经写了 `rewrite card`、`authority-first reject order`、`single-source seam audit`、`anti-zombie evidence rebinding` 与 `reopen liability drill`，仍会重新退回假 `rewrite card`、假 `authority-first reject`、伪 `anti-zombie evidence` 与假 `reopen liability`。

它主要回答五个问题：

1. 为什么结构宿主修复稳态纠偏再纠偏改写执行最危险的失败方式不是“没有 rewrite card”，而是“rewrite card 存在，却仍围绕 pointer、telemetry 与 architecture prose 工作”。
2. 为什么假 `rewrite card` 最容易把 `authority_object_id`、`authoritative_path`、`single_source_ref` 与 `lineage_reproof_ref` 重新退回更整洁的架构说明。
3. 为什么假 `authority-first reject` 最容易把 authority、single-source、lineage 与 anti-zombie 证据重新退回 pointer 健康感、telemetry 转绿与结果导向。
4. 为什么假 `reopen liability` 最容易把 future reopen 的正式边界重新退回 reconnect 提示、旧入口与作者口述。
5. 怎样用苏格拉底式追问避免把这些反例读成“把结构 rewrite 再写严一点就好”。

## 0. 代表性源码锚点

- `claude-code-source-code/src/utils/QueryGuard.ts:1-121`
- `claude-code-source-code/src/utils/handlePromptSubmit.ts:430-517`
- `claude-code-source-code/src/utils/task/framework.ts:77-248`
- `claude-code-source-code/src/utils/sessionRestore.ts:435-490`
- `claude-code-source-code/src/utils/conversationRecovery.ts:533-570`
- `claude-code-source-code/src/services/api/sessionIngress.ts:57-170`
- `claude-code-source-code/src/bridge/bridgePointer.ts:22-184`
- `claude-code-source-code/src/cli/transports/WorkerStateUploader.ts:3-112`
- `claude-code-source-code/src/utils/sessionState.ts:1-149`
- `claude-code-source-code/src/state/onChangeAppState.ts:50-92`
- `claude-code-source-code/src/cli/structuredIO.ts:362-657`
- `claude-code-source-code/src/cli/print.ts:5048-5072`

这些锚点共同说明：

- 结构宿主修复稳态纠偏再纠偏改写执行真正最容易失真的地方，不在 `rewrite card` 有没有写出来，而在 authority、single-source writeback seam、lineage、anti-zombie evidence 与 reopen boundary 是否仍围绕同一个结构真相面消费 later 维护者的判断。

## 1. 第一性原理

结构宿主修复稳态纠偏再纠偏改写执行最危险的，不是：

- 没有 `rewrite card`
- 没有 `authority-first reject order`
- 没有 `reopen liability drill`

而是：

- 这些东西已经存在，却仍然围绕 pointer、telemetry 转绿、archive prose 与作者口述运作

一旦如此，团队就会重新回到：

1. 看 pointer 还在不在。
2. 看 reconnect 是不是成功了。
3. 看目录和文档是不是显得更整洁。
4. 看日志是不是很多。
5. 看作者是不是说没问题。

而不再围绕：

- 同一个 `authority_object_id + single_source_ref + lineage_reproof_ref + anti_zombie_evidence_ref + reopen_boundary`

## 2. 假rewrite card：rewrite by architecture prose

### 坏解法

- 宿主、CI、评审与交接系统虽然都拿到了 `rewrite_card_id` 与 `reject_verdict=steady_state_restituted`，但真正执行时只要架构说明更完整、目录更整洁、handoff 更好读，就默认 `authority_object_id`、`authoritative_path`、`single_source_ref` 与 `lineage_reproof_ref` 仍围绕同一个结构真相面成立。

### 为什么坏

- 结构 `rewrite card` 保护的不是“现在更像一份正式架构说明”，而是 same authority、same seam、same lineage 仍支撑 later 维护者的消费与反对能力。
- 一旦 rewrite card 退回 architecture prose，团队就会重新容忍：
  - `authority_object_id` 只是说明中的名词
  - `single_source_ref` 只是目录意图
  - `lineage_reproof_ref` 只是恢复故事
  - `reject_verdict` 先于对象复核生效
- 这会让更像样的架构文案直接取代结构真相面。

### Claude Code 式正解

- `reject verdict` 应先绑定同一个 `authority_object_id + authoritative_path + single_source_ref + lineage_reproof_ref`，再宣布 `steady_state_restituted`。

### 改写路径

1. 把目录整洁度与架构 prose 降为次级信号。
2. 把 `authority_object_id + authoritative_path + single_source_ref + lineage_reproof_ref` 提升为前提。
3. 任何先看解释、后看结构对象的 rewrite execution 都判为 drift。

## 3. 假authority-first reject：reject by pointer and telemetry before truth

### 坏解法

- 团队虽然承认 rewrite 要按 `authority surface restitution -> single-source writeback seam -> lineage reproof -> anti-zombie evidence restitution -> reopen liability rebinding` 的固定顺序执行，但真正值班时只要 pointer 还在、telemetry 还绿、archive note 更完整、最终结果没坏，就提前落下 `steady_state_restituted`，不再按 `authority-first reject order` 检查 `writer_chokepoint`、`writeback_primary_path`、`append_chain_ref`、`generation_regression_detected` 与 `anti_zombie_evidence_ref`。

### 为什么坏

- `authority-first reject order` 保护的是“谁先说真话”，不是“最后结果看起来还行”。
- `QueryGuard` 只能封住本地 async gap，不能替代 authority、seam 与 lineage 的正式复证；把本地串行错当结构真相，本质上仍是结果导向。
- 一旦 reject 顺序退回 pointer 与 telemetry 优先，团队就会最先误以为：
  - “入口还活着就说明 authority 还在”
  - “结果没坏就说明 single-source 没问题”
  - “telemetry 转绿就说明 anti-zombie 已经复证”
- 这会把源码先进性从 authority surface、dependency seam 与 anti-zombie 证据退回目录美学与结果崇拜。

### Claude Code 式正解

- `reject verdict order` 必须先证明 authority、seam、lineage 与 anti-zombie 证据仍围绕同一个结构真相面，再决定 `steady_state_restituted`、`hard_reject`、`reentry_required` 或 `reopen_required`。

### 改写路径

1. 把 pointer、telemetry 与 archive prose 降为观察信号。
2. 把 `authority_object_id + writer_chokepoint + writeback_primary_path + append_chain_ref + lineage_reproof_ref + anti_zombie_evidence_ref` 提升为正式对象。
3. 任何“入口还在、结果没坏就算 rewrite 完成”的结构 rewrite execution 都判为 drift。

## 4. 假reopen liability：liability by reconnect hint

### 坏解法

- 团队虽然写了 `reopen liability rebinding` 与 `reopen liability drill`，但真正保留责任时只是在工单里写“以后有问题再 reconnect”“原入口还在”，却没有正式绑定 `reopen_boundary`、`reservation_owner`、`threshold_retained_until` 与 `return_writeback_path`。

### 为什么坏

- reopen liability 不是“以后再试一次”，而是“未来失稳时正式回到哪个 boundary 组合并由谁负责”。
- `fresh merge`、late-response ignore、worktree stale cleanup fail-closed 与 transport duplicate suppression 都只是抗损机制，不是 reopen boundary 本身；如果系统只能靠这些 suppressor 才显得稳定，就说明 liability 还没有对象化。
- 一旦责任保留退回 reconnect 提示，later 团队会同时失去：
  - 正式的 recovery boundary
  - 对 stale path 的清退保证
  - 对 writeback 漂移的隔离保证
- 这会把 reopen 退回 retry 循环。

### Claude Code 式正解

- reopen liability 应围绕 authority、writeback 与 boundary，而不是围绕 reconnect 与旧入口。

### 改写路径

1. 把 reconnect 提示降为动作说明，不再当 liability 对象。
2. 把 `reopen_boundary + reservation_owner + threshold_retained_until + return_writeback_path` 提升为正式对象。
3. 任何只让 later 团队“以后再试一次恢复”的结构 rewrite execution 都判为 drift。

## 5. 为什么这会让源码先进性退回目录美学

- Claude Code 的源码先进性从来不在“目录是不是更整洁”，而在 authority surface、single-source seam、fresh lineage、anti-zombie evidence 与 fail-closed reopen boundary 是否先于 later 维护者的心理感受生效。
- 假 `rewrite card` 会把结构对象退回 architecture prose。
- 假 `authority-first reject` 会把结构判断退回 pointer 与 telemetry。
- 假 `reopen liability` 会把未来责任退回 reconnect 提示。

一旦这三件事同时发生，源码先进性剩下的就不再是结构真相面，而只是：

1. 更整洁的目录叙事。
2. 更好看的健康信号。
3. 更依赖作者记忆的 later handoff。

## 6. 苏格拉底式追问

在你读完这些反例后，先问自己：

1. 我现在修回的是唯一 authority object，还是一张更正式的 rewrite 卡。
2. 我现在保住的是 `single-source + lineage + anti-zombie evidence`，还是更漂亮的目录与几次幸运 reconnect。
3. 我现在遵守的是 `authority-first reject order`，还是一种“结果还行就先过”的冲动。
4. 我现在保留的是 future reopen 的正式 liability，还是一句“以后再试一次”。
5. later 团队明天如果必须 reopen，依赖的是正式 boundary，还是作者口述与旧入口循环。

## 7. 一句话总结

真正危险的结构宿主修复稳态纠偏再纠偏改写执行失败，不是没跑 `rewrite card`，而是跑了 `rewrite card` 却仍在围绕假 `rewrite card`、假 `authority-first reject`、伪 `anti-zombie evidence` 与假 `reopen liability` 消费结构世界。
