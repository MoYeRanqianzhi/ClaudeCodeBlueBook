# 治理 Evidence Envelope落地手册：决策窗口、仲裁证据、对象升级与回退门禁

这一章不再把 `Evidence Envelope` 当成治理主语，而是把它压回一层承载壳：

- envelope 只是把治理判断链装订给宿主、CI、评审与交接系统的记录外壳
- 真正应被共同消费的，始终是同一条 canonical governance chain

1. `governance key`
2. `externalized truth chain`
3. `typed ask`
4. `decision window`
5. `continuation pricing`
6. `durable-transient cleanup`

它主要回答五个问题：

1. 为什么治理 evidence envelope 不能再从 envelope 本身起笔。
2. 宿主、CI、评审与交接到底该共享哪些治理字段。
3. 哪些字段属于 hard gate，哪些只属于角色投影。
4. 怎样避免 envelope 重新退回 token、审批与结果摘要。
5. 怎样用苏格拉底式追问避免把这章写成“治理记录模板大全”。

## 0. 第一性原理

没有治理 envelope 的团队，最常见失败不是：

- 少一张表
- 少几个字段

而是：

- 宿主、CI、评审与交接各自看各自的 mode、token、审批与回退印象

所以 `Evidence Envelope` 真正要解决的，不是“记录更全”，而是：

- 让四类角色围绕同一治理判断链做决定

只要 envelope 抢走了主语，团队就会重新围绕：

1. mode 名字
2. token 条颜色
3. 弹窗是否出现
4. 文件回退是否执行

来理解治理，而不再围绕边界、事务、窗口、继续定价与 cleanup 边界来理解治理。

## 1. Envelope 只是一层承载壳

更稳的写法不是：

- “治理 envelope 应该长什么样”

而是：

- “同一条治理链怎样被稳定装订为一份跨角色记录”

因此旧桥接词必须固定降级：

1. `authority source`
   - 只是 `governance key` 的 source slot。
2. `control arbitration truth`
   - 只是 `typed ask` 的 witness。
3. `Context Usage`
   - 只是 `decision window` 的诚实投影。
4. `continuation gate`
   - 只是 `continuation pricing` 的 verdict。
5. `rollback object`
   - 只是 `durable-transient cleanup` 的 carrier。

## 2. 最小 shared envelope header

更稳的 envelope header 至少应共享：

```text
envelope_header:
- governance_object_id
- governance_key_ref
- truth_chain_ref
- typed_ask_ref
- permission_ledger_ref
- decision_window_ref
- continuation_pricing_ref
- cleanup_carrier_ref
- durable_assets_after
- transient_authority_cleared
- reject_verdict
- verdict_reason
- next_action
- re_entry_condition
```

这份 header 的作用不是：

- 取代治理对象本身

而是：

- 让所有角色都先从同一治理链起手

## 3. 四类角色如何消费同一条链

### 3.1 宿主

宿主最少应消费：

1. `worker_status`
2. `session_state_changed`
3. `pending_action`
4. `decision_window_ref`
5. `continuation_pricing_ref`
6. `cleanup_carrier_ref`

宿主最容易犯的错，不是少显示一个字段，而是把这些字段重新压成 allow / deny / requires_action。

### 3.2 CI

CI 最少应校验：

1. `governance_key_ref`
2. `truth_chain_ref`
3. `typed_ask_ref`
4. `decision_window_ref`
5. `continuation_pricing_ref`
6. `cleanup_carrier_ref`
7. `reject_verdict`

CI 最容易犯的错，是重新退回 token / latency 阈值和“这轮过没过”。

### 3.3 评审

评审最少应先看：

1. `governance_key_ref`
2. `truth_chain_ref`
3. `typed_ask_ref`
4. `winner_source`
5. `reject_verdict`
6. `cleanup_carrier_ref`

禁止事项：

- 只凭 ask 次数、最终 allow / deny 或一句“看起来风险不大”做治理判断

### 3.4 交接

交接最少应交付：

1. `governance_object_id`
2. `decision_window_ref`
3. `continuation_pricing_ref`
4. `cleanup_carrier_ref`
5. `durable_assets_after`
6. `transient_authority_cleared`
7. `re_entry_condition`

交接最容易犯的错，是只说“现在比较贵/比较严/正在等审批”，却不说明当前对象、当前窗口和下一步如何重入。

## 4. 最小落地 diff

### 改写前

```text
宿主:
- 显示 allow / deny / requires_action

CI:
- 看 token / latency 阈值

评审:
- 看 ask 次数 / 最终结果

交接:
- 只知道当前卡住了
```

### 改写后

```text
宿主:
- 先看 worker_status / session_state_changed / pending_action

CI:
- 先看 governance_key_ref / typed_ask_ref / decision_window_ref

评审:
- 先看 truth_chain_ref / winner_source / reject_verdict

交接:
- 先看 cleanup_carrier_ref / durable_assets_after / re_entry_condition
```

### 这段 diff 的意义

真正的变化不是：

- 增加几项记录字段

而是：

- 把治理从“结果摘要”收回到“统一定价判断链”

## 5. Hard Gate 与 Reject Trio

治理 envelope 里最适合写成 hard gate 的字段：

1. `governance_key_ref`
2. `truth_chain_ref`
3. `typed_ask_ref`
4. `decision_window_ref`
5. `continuation_pricing_ref`
6. `cleanup_carrier_ref`
7. `reject_verdict`

更稳的 reject trio 是：

1. `projection_usurpation`
2. `decision_window_collapse`
3. `free_expansion_relapse`

如果 envelope 不能直接指出这三类 drift 的哪一类在发生，它就仍然只是表单壳，不是治理记录壳。

## 6. 对象升级与 cleanup 顺序

治理线真正稳的顺序是：

1. 先判断当前对象是否还值得继续。
2. 不值得时先 `upgrade object`，而不是继续烧 token。
3. 需要停止时先关掉当前 `decision window`。
4. 再进入 `durable-transient cleanup`，清掉不该继续继承的 authority。
5. 最后才给 later maintainer 一个可重入的 `re_entry_condition`。

这正是 envelope 需要装订的关键顺序，而不是“记录下发生过什么”。

## 7. 苏格拉底式追问

在你准备宣布治理 envelope 已经落地前，先问自己：

1. 我共享的是同一条治理判断链，还是四份角色各自的摘要。
2. `Context Usage` 在这里是 `decision window` 的诚实投影，还是账单页。
3. `permission ledger` 在这里是 ask 事务证据，还是审批完成感。
4. cleanup 恢复的是对象边界，还是文件动作。
5. 如果把 modal、仪表盘和回退按钮都藏起来，四类角色是否仍知道该如何继续判断。

## 8. 一句话总结

`Evidence Envelope` 真正该承载的，不是更多治理字段，而是同一条 `governance key -> externalized truth chain -> typed ask -> decision window -> continuation pricing -> durable-transient cleanup` 在四类角色之间的稳定复述。
