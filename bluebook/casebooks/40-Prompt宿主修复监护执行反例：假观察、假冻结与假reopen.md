# Prompt宿主修复监护执行反例：假观察、假冻结与假reopen

这一章不再回答“Prompt 宿主修复监护执行该怎样运行”，而是回答：

- 为什么团队明明已经写了 watch card、drift verdict order、handoff freeze 与 reopen drill，仍会重新退回假观察、假冻结与假 reopen。

它主要回答五个问题：

1. 为什么 Prompt 宿主修复监护执行最危险的失败方式不是“没有 watch card”，而是“watch card 存在，却仍围绕叙事与提醒工作”。
2. 为什么假观察最容易把 `compiled request truth` 重新退回 closeout note、summary 解释与 UI transcript。
3. 为什么假冻结最容易把 continuation object 重新退回 handoff 提示与 later 自觉。
4. 为什么假 reopen 最容易把对象级重开重新退回按钮状态、旧消息与临场判断。
5. 怎样用苏格拉底式追问避免把这些反例读成“把 watch card 再填细一点就好”。

## 0. 代表性源码锚点

- `claude-code-source-code/src/constants/systemPromptSections.ts:20-65`
- `claude-code-source-code/src/constants/prompts.ts:105-115`
- `claude-code-source-code/src/constants/prompts.ts:343-347`
- `claude-code-source-code/src/utils/api.ts:136-405`
- `claude-code-source-code/src/services/api/claude.ts:1374-1485`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:494-698`
- `claude-code-source-code/src/utils/messages.ts:1989-2148`
- `claude-code-source-code/src/utils/messages.ts:5133-5458`
- `claude-code-source-code/src/services/compact/prompt.ts:293-337`
- `claude-code-source-code/src/services/compact/compact.ts:330-711`
- `claude-code-source-code/src/services/compact/postCompactCleanup.ts:31-66`
- `claude-code-source-code/src/query/stopHooks.ts:257-331`
- `claude-code-source-code/src/query.ts:1258-1518`

这些锚点共同说明：

- Prompt 宿主修复监护执行真正最容易失真的地方，不在 watch verdict 有没有写出来，而在观察、冻结与 reopen 是否仍围绕同一个 `compiled request truth`、`protocol transcript`、lawful forgetting boundary 与 continuation object 运作。

## 1. 第一性原理

Prompt 宿主修复监护执行最危险的，不是：

- 没有 watch card
- 没有 handoff freeze
- 没有 reopen drill

而是：

- 这些东西已经存在，却仍然围绕 closeout note、handoff 提示与“先观察一下”运作

一旦如此，团队就会重新回到：

1. 看值班备注是不是写全了
2. 看 summary 是不是还说得通
3. 看 later 团队是不是被提醒过了
4. 看按钮是不是还能点

而不再围绕：

- 同一个 `compiled request truth`

## 2. 假观察：monitor_only 退回 closeout 叙事

### 坏解法

- 宿主、CI、评审与交接系统虽然都拿到了 `monitor_only`，但没有继续核对 `watch_window_id`、`restored_request_object_id` 与 `compiled_request_hash` 是否仍指向同一个 request object family。

### 为什么坏

- `monitor_only` 不是一句态度，而是对同一个 request object 的正式观察窗口。
- 一旦 `monitor_only` 被 closeout 文案与 narrative override 替代，就会重新容忍：
  - watch window 只是备注
  - request object 只是标题
  - compiled request hash 只是抄录值
- 这会让“正在观察”的监护感直接取代 Prompt 的正式真相面。

### Claude Code 式正解

- watch verdict 应先绑定同一个 request object，再宣布 stable under watch。

### 改写路径

1. 把值班备注降为注释。
2. 把 `watch_window_id + restored_request_object_id + compiled_request_hash` 提升为监护前提。
3. 任何先看 note、后看对象的 Prompt watch 都判为 drift。

## 3. drift ledger 故事化：baseline drift 退回解释文本

### 坏解法

- 团队虽然承认 watch 要验证 `baseline_drift_ledger`，但真正执行时只要看到 closeout note、复盘总结与 handoff 文本自洽，就默认 baseline 仍然稳定。

### 为什么坏

- drift ledger 记录的是 protocol truth 与 lawful forgetting 的对象漂移，不是解释文本是否完整。
- 一旦 drift ledger 退回故事，团队就会最先误以为：
  - “原因说清了，应该就稳定了”
  - “summary 还读得懂，later 应该能接”
- 这会让 Prompt 监护从对象级记账退回一份更会解释的文本。

### Claude Code 式正解

- watch 应持续围绕 protocol witness 与 lawful forgetting witness 记账，而不是让观察说明替代它。

### 改写路径

1. 把观察说明降为评审材料。
2. 把 `protocol_truth_witness + lawful_forgetting_witness + baseline_reset_witness + drift_events` 提升为正式对象。
3. 任何“解释成立即视为 baseline 稳定”的 Prompt watch 都判为 drift。

## 4. 假冻结：handoff freeze 退回提醒 later 小心

### 坏解法

- 团队虽然写了 `handoff_freeze`，但真正冻结时只是在 handoff 包里加一段“先小心一点”的提示，later 仍可直接消费 summary、next step 与 continuation object。

### 为什么坏

- freeze 的本质是阻断错误 continuation，不是补一条更谨慎的交接提示。
- 一旦 freeze 退回提醒，Prompt 监护执行就会重新退回：
  - continuation without boundary
  - handoff without object gate
  - narrative override without freeze
- 这会让冻结成为“态度表达”，而不是对象阻断。

### Claude Code 式正解

- handoff freeze 应阻断 continuation object 的消费资格，而不是只提醒 later 团队小心。

### 改写路径

1. 把风险提示降为 handoff 注释。
2. 把 `handoff_watch_status + continuation_object_attested + consumer_readiness_handoff` 提升为冻结硬条件。
3. 任何只写提示、不阻断对象消费的 Prompt watch 都判为 drift。

## 5. 假重开：reopen gate 退回按钮状态与旧消息

### 坏解法

- 团队虽然写了 `reopen_gate`，但真正重开时仍只看“按钮可点”“现在没报错”“最后一条消息像是还能接”，不再回到同一个 request object boundary。

### 为什么坏

- reopen gate 不是礼貌性 retry，而是围绕 `rollback_boundary + re_entry_warranty + required_preconditions` 的正式重开。
- 一旦 reopen 退回按钮状态，团队会同时做坏：
  - 把 request object 降为 UI 入口
  - 把 handoff freeze 降为无效提醒
  - 把 later 接手降为从旧 summary 接故事
- 这正是 Prompt 监护重新制造假连续性的地方。

### Claude Code 式正解

- reopen 应围绕对象边界、precondition 与 continuation object，而不是围绕“现在没被阻止”。

### 改写路径

1. 禁止按钮可点充当 reopen 资格。
2. 把 `reopen_trigger + rollback_boundary + re_entry_warranty + pending_action_ref` 提升为正式对象。
3. 任何默认从旧消息与旧 summary 重开的 Prompt watch 都判为 drift。

## 6. watch 过期装饰化：deadline 变成日历提醒

### 坏解法

- 团队只要在值班系统里挂一个提醒，就默认 `watch_deadline` 已存在；即使 deadline 已过，也不升级 verdict，不冻结 handoff，不进入 reopen 判定。

### 为什么坏

- watch deadline 是判定时态，不是提醒文案；过期之后必须改变语义。
- 一旦 deadline 退回提醒，团队就会重新容忍：
  - 过期 watch 继续冒充稳定
  - 过期 gate 继续允许 continuation
  - 过期 handoff 继续被 later 团队消费
- 这会把监护从正式时态退回任务提醒。

### Claude Code 式正解

- watch deadline 应是 verdict 升级器，而不是日历装饰。

### 改写路径

1. 把日历提醒降为辅助信号。
2. 把 `watch_deadline + watch_verdict + reopen_gate` 提升为正式时态对象。
3. 任何过期后仍只提醒不升级的 Prompt watch 都判为 drift。

## 7. 苏格拉底式追问

在你读完这些反例后，先问自己：

1. 我现在监护的是 request object，还是 closeout note。
2. 我现在保护的是 drift ledger，还是一套更会解释的观察文本。
3. 我现在冻结的是 continuation object，还是只是 later 的心理预期。
4. 我现在重开的是同一真相，还是默认继续。
5. 我现在保护的是 watch 时态，还是日历提醒。

## 8. 一句话总结

真正危险的 Prompt 宿主修复监护执行失败，不是没写 watch card，而是写了 watch card 却仍在围绕假观察、假冻结与假 reopen 消费 Prompt 世界。
