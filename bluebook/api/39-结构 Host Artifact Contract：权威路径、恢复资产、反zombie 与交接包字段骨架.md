# 结构 Host Artifact Contract：权威路径、恢复资产、反zombie 与交接包字段骨架

这一章回答五个问题：

1. 结构线的宿主卡、CI 附件、评审卡与交接包，到底应该共享哪些正式字段。
2. 哪些字段是 shared contract，哪些只是 role-specific projection，哪些仍应停留在 internal hint。
3. 为什么结构工件必须继续围绕 authoritative path、recovery asset ledger、anti-zombie evidence、retained assets 与 rollback object，而不是围绕结构图、恢复成功率与作者说明。
4. 哪些字段最适合写成 hard contract，缺失时必须直接判定工件不合法。
5. 宿主开发者与平台设计者该按什么顺序接入这套结构 artifact contract。

## 0. 关键源码锚点

- `claude-code-source-code/scripts/prepare-src.mjs:3-64`
- `claude-code-source-code/scripts/stub-modules.mjs:2-42`
- `claude-code-source-code/src/bridge/replBridgeTransport.ts:13-116`
- `claude-code-source-code/src/bridge/bridgePointer.ts:22-167`
- `claude-code-source-code/src/services/api/sessionIngress.ts:60-120`
- `claude-code-source-code/src/utils/cleanupRegistry.ts:1-21`
- `claude-code-source-code/src/utils/QueryGuard.ts:69-106`
- `claude-code-source-code/src/utils/task/framework.ts:160-248`

## 1. 先说结论

结构线真正成熟的 artifact contract，不是四类角色各自维护结构图、恢复日志和交接说明，而是四类工件共享同一份 Structure object contract：

1. 宿主卡回答“当前结构对象、当前权威路径与当前回退对象是什么”。
2. CI 附件回答“恢复资产、反 zombie 证据与 retained assets 是否仍成立”。
3. 评审卡回答“这次结构演化是否仍围绕同一 authoritative path”。
4. handoff package 回答“后来者是否不问作者也能继续恢复、回退与交接判断”。

四类工件的差异只应该体现在展开深度，而不应该体现在：

- 结构真相来源

## 2. Structure Artifact Contract 的三层字段

### 2.1 Shared Contract

这些字段必须被四类工件共享：

1. `artifact_line_id`
2. `structure_object_type`
3. `structure_object_id`
4. `authoritative_path`
5. `current_read_path`
6. `current_write_path`
7. `projection_set`
8. `recovery_asset_ledger`
9. `anti_zombie_evidence`
10. `retained_assets`
11. `danger_paths`
12. `rollback_object`
13. `dropped_stale_writers`

### 2.2 Role-Specific Projection

这些字段只在特定工件里展开：

1. 宿主卡：
   - `current_recovery_state`
   - `next_action`
2. CI 附件：
   - `recovery_result`
   - `hard_fail_result`
   - `stale_writer_watchpoints`
3. 评审卡：
   - `authority_judgement`
   - `projection_judgement`
   - `rollback_judgement`
4. Handoff package：
   - `handoff_steps`
   - `background_refs`
   - `re_entry_conditions`

### 2.3 Internal Hint

这些信息可以引用，但不应直接升格成稳定公共字段：

1. 临时桥接内部指针细项
2. 局部调试日志
3. 非公共的中间 merge 痕迹
4. 临时实验用的内部路径标志

## 3. Shared Header

更稳的结构 artifact header 可以固定为：

```text
artifact_header:
- artifact_line_id
- structure_object_type
- structure_object_id
- authoritative_path
- current_read_path
- current_write_path
- projection_set
- recovery_asset_ledger
- anti_zombie_evidence
- retained_assets
- danger_paths
- rollback_object
- dropped_stale_writers
```

它的作用不是：

- 取代结构图和恢复日志

而是：

- 让四类工件都从同一结构对象起手

## 4. 四类工件的最小 contract

### 4.1 宿主卡

最少字段：

1. `structure_object_id`
2. `authoritative_path`
3. `current_recovery_state`
4. `rollback_object`
5. `danger_paths`

禁止退化为：

- 只有目录图
- 只有文件 diff

### 4.2 CI 附件

最少字段：

1. `recovery_asset_ledger`
2. `anti_zombie_evidence`
3. `retained_assets`
4. `dropped_stale_writers`
5. `hard_fail_result`

禁止退化为：

- 只有恢复成功率
- 只有 gate 存在性判断

### 4.3 评审卡

最少字段：

1. `authoritative_path`
2. `current_read_path`
3. `current_write_path`
4. `projection_set`
5. `rollback_object`
6. `review_judgement`

禁止退化为：

- 先看结构图，再看对象路径

### 4.4 Handoff Package

最少字段：

1. `structure_object_id`
2. `retained_assets`
3. `danger_paths`
4. `rollback_object`
5. `dropped_stale_writers`

禁止退化为：

- 只有作者讲解
- 只有危险路径口头说明

## 5. 为什么这些工件必须继续围绕 authoritative path

因为结构真正要回答的不是：

- 看起来是不是更整洁

而是：

- 当前哪条路径才是唯一权威路径

如果工件围绕的不是 authoritative path：

1. 宿主卡会重新退回结构图。
2. CI 附件会重新退回结果面。
3. 评审卡会重新退回目录审美。
4. handoff package 会重新退回作者权威。

## 6. 为什么 recovery asset ledger、anti-zombie evidence 与 retained assets 也必须进入 contract

因为源码先进性不只来自：

- 当前看起来能跑

还来自：

1. 你知道恢复靠哪些资产成立。
2. 你知道哪些 stale writer 已经被清退。
3. 你知道哪些资产必须保留，哪些路径最危险。

如果这三类字段没有写进 contract：

1. 恢复就会退回幸运结果。
2. anti-zombie 就会退回象征性规则。
3. 交接就会退回作者记忆。

## 7. Hard Contract 字段

最应写成 hard contract 的字段：

1. `structure_object_type`
2. `structure_object_id`
3. `authoritative_path`
4. `current_read_path`
5. `current_write_path`
6. `recovery_asset_ledger`
7. `anti_zombie_evidence`
8. `retained_assets`
9. `rollback_object`
10. `danger_paths`

这些字段缺任何一项，都不应再被视为：

- 合法 Structure artifact

## 8. 最小接法

如果你要最小化接入结构 artifact contract，建议按下面顺序做：

1. 先把 shared header 固定下来。
2. 再让宿主卡、CI 附件、评审卡与 handoff package 都继承这一 header。
3. 再按角色增加 projection 字段。
4. 最后再把 internal hints 变成 evidence refs，而不是公共 schema。

## 9. 一句话总结

结构 Host Artifact Contract 真正统一的，不是四类工件的展示形式，而是它们依赖的同一条权威路径、同一组恢复资产与同一个回退对象。
