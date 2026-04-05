# 结构宿主修复稳态纠偏再纠偏执行反例：假authority surface、假single-source与假reopen liability

这一章不再回答“结构宿主修复稳态纠偏再纠偏执行该怎样运行”，而是回答：

- 为什么团队明明已经写了 `recorrection card`、`authority-first reject order`、`single-source seam audit`、`anti-zombie evidence rebinding` 与 `reopen liability drill`，仍会重新退回假 `authority surface`、假 `single-source`、假 `lineage reproof`、假 `anti-zombie evidence` 与假 `reopen liability`。

它主要回答五个问题：

1. 为什么结构宿主修复稳态纠偏再纠偏执行最危险的失败方式不是“没有 recorrection card”，而是“recorrection card 存在，却仍围绕 pointer、telemetry 与 archive prose 工作”。
2. 为什么假 `authority surface` 最容易把结构主权重新退回 pointer 健康感与作者说明。
3. 为什么假 `single-source` 与假 `lineage reproof` 最容易把唯一真相入口与恢复顺序重新退回目录审美、幸运 reconnect 与结果导向。
4. 为什么假 `anti-zombie evidence` 最容易把正式复证重新退回 archive prose、日志截图与作者口述。
5. 为什么假 `reopen liability` 最容易把 future reopen 的正式边界重新退回 reconnect 提示与旧入口循环。

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

- 结构宿主修复稳态纠偏再纠偏执行真正最容易失真的地方，不在 `recorrection card` 有没有写出来，而在 `authority surface`、`single-source`、`resume lineage`、`writeback custody`、`anti-zombie evidence` 与 `reopen liability` 是否仍围绕同一个结构真相面运作。

## 1. 第一性原理

结构宿主修复稳态纠偏再纠偏执行最危险的，不是：

- 没有 `recorrection card`
- 没有 `single-source seam audit`
- 没有 `reopen liability drill`

而是：

- 这些东西已经存在，却仍然围绕 pointer、telemetry 转绿、archive prose 与作者口述运作

一旦如此，团队就会重新回到：

1. 看 pointer 还在不在
2. 看 reconnect 是不是成功了
3. 看目录和文件是否显得更整洁
4. 看日志是不是很多
5. 看作者是不是说没问题

而不再围绕：

- 同一个结构真相面

## 2. 假authority surface：authority by pointer

### 坏解法

- 宿主、CI 与评审只要看到 pointer 还在、telemetry 还绿、`reject_verdict=steady_state_restituted`，就默认 `authority surface restitution` 已成立，不再检查 `authority_object_id`、`authoritative_path`、`authority_state_surface` 与 `writer_chokepoint` 是否仍围绕同一个 authority object。

### 为什么坏

- authority 不是“入口还活着”，而是“同一个结构真相面已重新夺回主权”。
- 一旦 authority 退回 pointer 健康感，团队就会重新容忍：
  - authority drift 被入口存在感掩盖
  - `reject_verdict` 被健康感提前消费
  - later 团队继续依赖作者解释补齐边界
- 这会让“看起来已经恢复”的感觉直接取代结构真相面。

### Claude Code 式正解

- `reject verdict` 应先证明 authority object 仍唯一、仍被重新绑定，再宣布 `steady_state_restituted`。


## 3. 假single-source 与假lineage reproof：truth by directory aesthetics

### 坏解法

- 团队虽然写了 `single-source reseal` 与 `resume lineage reproof`，但真正执行时只要目录更整洁、依赖更集中、reconnect 成功、最终结果没坏，就默认唯一真相入口与恢复顺序已经被正式复证，不再检查 `single_source_refs`、`dependency_seam_status`、`resume_lineage_ref`、`return_lineage` 与 `generation_regression_detected` 是否仍被正式约束。

### 为什么坏

- single-source 保护的是“谁是唯一真相入口”，不是“目录看起来更像单点”。
- lineage reproof 保护的是“恢复顺序仍合法闭合”，不是“反正又连上了”。
- 一旦 single-source 与 lineage 退回目录审美和好运气，团队就会最先误以为：
  - “结构更整洁就说明 truth 已单点”
  - “能继续就说明 lineage 也没问题”
- 这会把结构先进性从单一真相制度退回目录美感与结果崇拜。

### Claude Code 式正解

- single-source 与 lineage 必须围绕引用边界、dependency seam 与恢复顺序对象，而不是围绕目录印象与 reconnect 结果。


## 4. 假anti-zombie evidence：reproof by archive prose

### 坏解法

- 团队虽然写了 `anti_zombie evidence restitution`，但真正归档时只要产出一份复盘文字、几条日志截图与 archive note，就默认 zombie 风险已被复证，不再交付 `anti_zombie_evidence_ref`、`stale_writer_evidence`、`orphan_session_resolved` 与 `archive_truth_ref`。

### 为什么坏

- anti-zombie 保护的是“过去不会再写回现在”，不是“我们已经写了复盘”。
- 一旦复证退回 prose，团队就会最先误以为：
  - “结论说清楚了，应该就恢复了”
  - “later 应该能理解”
- 这会把 anti-zombie 从证据对象退回一段更会解释的文本。

### Claude Code 式正解

- anti-zombie evidence restitution 与 archive truth 应首先是可审计证据，其次才是复盘说明。


## 5. 假reopen liability：liability by reconnect hint

### 坏解法

- 团队虽然写了 `reservation liability rebinding` 与 `reopen liability drill`，但真正保留责任时只是在工单里写“以后有问题再 reconnect”“原恢复入口还在”，却没有正式绑定 `reopen_reservation_boundary`、`reservation_owner`、`threshold_retained_until` 与 `return_writeback_path`。

### 为什么坏

- reopen liability 不是“以后再试一次”，而是“未来失稳时正式回到哪个 boundary 组合并由谁负责”。
- 一旦责任保留退回 reconnect 提示，later 团队会同时失去：
  - 正式的 recovery boundary
  - 对 stale path 的清退保证
  - 对 writeback 漂移的隔离保证
- 这会把 reopen 退回 retry 循环。

### Claude Code 式正解

- reopen liability 应围绕 authority、writeback 与 boundary，而不是围绕 reconnect 与旧入口。


## 6. 苏格拉底式追问

在你读完这些反例后，先问自己：

1. 我现在修回的是唯一 authority object，还是只把入口感重新包装了一遍。
2. 我现在保住的是 `single-source + lineage reproof`，还是更漂亮的目录与几次幸运 reconnect。
3. 我现在归还的是 anti-zombie 证据，还是一段更会解释的 archive prose。
4. 我现在保留的是 future reopen 的正式 liability，还是一句“以后再试一次”。
5. later 团队明天如果必须 reopen，依赖的是正式 boundary，还是作者口述与旧入口循环。

## 7. 一句话总结

真正危险的结构宿主修复稳态纠偏再纠偏执行失败，不是没跑 `recorrection card`，而是跑了 `recorrection card` 却仍在围绕假 `authority surface`、假 `single-source`、假 `lineage reproof`、假 `anti-zombie evidence` 与假 `reopen liability` 消费结构世界。
