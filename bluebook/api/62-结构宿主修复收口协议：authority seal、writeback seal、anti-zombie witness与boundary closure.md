# 结构宿主修复收口协议：authority seal、writeback seal、anti-zombie witness与boundary closure

这一章回答五个问题：

1. Claude Code 当前到底通过哪些正式对象让宿主、SDK、CI、评审与交接系统消费结构修复纠偏的收口结果。
2. 哪些字段属于必须消费的结构 closeout object，哪些属于 closeout verdict 语义，哪些仍然不应被绑定成公共 ABI。
3. 为什么结构收口协议不应退回 pointer、重连通过感、日志繁荣与恢复成功率。
4. 宿主开发者该按什么顺序消费这套结构收口规则面。
5. 哪些现象一旦出现应被直接升级为 reopen required 或 handoff blocked，而不是宣布修复完成。

## 0. 关键源码锚点

- `claude-code-source-code/src/utils/QueryGuard.ts:1-121`
- `claude-code-source-code/src/utils/handlePromptSubmit.ts:430-517`
- `claude-code-source-code/src/utils/task/framework.ts:77-248`
- `claude-code-source-code/src/utils/sessionRestore.ts:435-490`
- `claude-code-source-code/src/utils/conversationRecovery.ts:533-570`
- `claude-code-source-code/src/state/onChangeAppState.ts:50-92`
- `claude-code-source-code/src/utils/sessionState.ts:92-149`
- `claude-code-source-code/src/services/api/sessionIngress.ts:57-170`
- `claude-code-source-code/src/bridge/bridgePointer.ts:22-184`
- `claude-code-source-code/src/cli/transports/WorkerStateUploader.ts:3-112`
- `claude-code-source-code/src/cli/print.ts:5048-5067`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:578-619`

## 1. 先说结论

Claude Code 当前并没有公开一份名为：

- `StructureRepairCloseoutContract`

的单独公共对象。

但结构宿主修复收口实际上已经能围绕五类正式对象稳定成立：

1. `authority_seal`
2. `resume_closure_order`
3. `writeback_seal`
4. `anti_zombie_witness`
5. `boundary_closure`

更成熟的修复收口方式不是：

- 只看 pointer 还在
- 只看 reconnect 又成功了
- 只看日志变多了

而是：

- 围绕这五类对象消费结构真相面怎样正式回到同一个 authority object

## 2. authority seal：最小收口对象

宿主应至少围绕下面对象消费结构收口真相：

1. `authority_object_before`
2. `authority_object_after`
3. `authority_state_surface`
4. `generation`
5. `writer_chokepoint`
6. `seal_generation`

这些字段回答的不是：

- 现在恢复入口还在不在

而是：

- 当前到底把哪个 authority 漂移收口成了哪个正式结构边界

## 3. resume closure order 与 writeback seal

结构宿主还必须显式消费：

### 3.1 resume closure order

1. `switch_reset_done`
2. `restore_metadata_done`
3. `restore_worktree_done`
4. `adopt_resumed_session_done`
5. `clear_stale_done`

### 3.2 writeback seal

1. `writeback_path`
2. `worker_status`
3. `external_metadata`
4. `merge_semantics`
5. `writeback_sealed`

这说明宿主当前消费的不是：

- 一次重连动作
- 一串日志记录

而是：

- `resume closure order + writeback seal` 共同组成的结构收口对象

## 4. anti-zombie witness 与 boundary closure

结构收口还必须消费：

### 4.1 anti-zombie witness

1. `anti_zombie_projection`
2. `stale_writer_evidence`
3. `duplicate_or_orphan_control_state_resolved`
4. `transition_legality_snapshot`
5. `witness_attested`

### 4.2 boundary closure

1. `rollback_object`
2. `recovery_boundary`
3. `breadcrumb_demoted`
4. `re_entry_condition`
5. `boundary_closed`

这两组对象回答的不是：

- 现在是不是又能连上了
- 监控是不是恢复正常了

而是：

- stale path 是否已被正式清退并留下可审计证据
- 当前回退边界是否已经正式收口并允许 later 安全接手

## 5. closeout verdict：必须共享的完成语义

更成熟的结构宿主收口 verdict 至少应共享下面枚举：

1. `authority_not_sealed`
2. `resume_order_not_closed`
3. `writeback_not_sealed`
4. `anti_zombie_not_witnessed`
5. `boundary_not_closed`
6. `reconnect_only_closeout`
7. `handoff_not_ready`
8. `reopen_required`

这些 verdict reason 的价值在于：

- 把“看起来已经修好了”的结构幻觉压成宿主、CI、评审与交接都能共享的收口语义

## 6. 不应直接绑定为公共 ABI 的对象

宿主不应直接把下面内容绑成长期契约：

1. pointer mtime
2. sidecar 文件存在性
3. 恢复成功率
4. spinner / loading UI
5. PUT 次数
6. 重连按钮状态
7. 目录美学描述
8. 作者口头说明

它们可以是收口线索，但不能是收口对象。

## 7. 收口顺序建议

更稳的顺序是：

1. 先验 `authority_seal`
2. 再验 `resume_closure_order`
3. 再验 `writeback_seal`
4. 再验 `anti_zombie_witness`
5. 最后验 `boundary_closure`

不要反过来做：

1. 不要先看 pointer。
2. 不要先看日志繁荣。
3. 不要先看 reconnect 是否暂时可用。

## 8. 一句话总结

Claude Code 的结构宿主修复收口协议，不是 pointer / reconnect 修补完成 API，而是 `authority seal + resume closure order + writeback seal + anti-zombie witness + boundary closure` 共同组成的规则面。
