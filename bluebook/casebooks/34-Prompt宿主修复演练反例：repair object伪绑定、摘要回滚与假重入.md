# Prompt宿主修复演练反例：repair object伪绑定、摘要回滚与假重入

这一章不再回答“Prompt 宿主修复演练该怎样运行”，而是回答：

- 为什么团队明明已经写了 repair object 共享升级卡、rollback drill 与 re-entry drill，仍会重新退回修复说明、摘要回退与“似乎还能继续”。

它主要回答五个问题：

1. 为什么 Prompt 宿主修复演练最危险的失败方式不是“没有升级卡”，而是“升级卡存在，却仍围绕解释文本工作”。
2. 为什么 repair object 伪绑定最容易把 `compiled request truth` 重新退回字符串、截图与事故摘要。
3. 为什么摘要回滚最容易把对象级 rollback 重新退回旧 summary、旧消息与 cache 通过感。
4. 为什么假重入最容易把 continue gate 重新退回按钮状态、默认继续与 last-message heuristic。
5. 怎样用苏格拉底式追问避免把这些反例读成“把修复卡再填细一点就好”。

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
- `claude-code-source-code/src/utils/sessionState.ts:92-146`

这些锚点共同说明：

- Prompt 宿主修复演练真正最容易失真的地方，不在 repair card 有没有写出来，而在 repair、rollback 与 re-entry 是否仍围绕同一个 `compiled request truth`、`protocol transcript`、lawful forgetting object 与 `continue qualification` 运作。

## 1. 第一性原理

Prompt 宿主修复演练最危险的，不是：

- 没有 repair card
- 没有 rollback drill
- 没有 re-entry ticket

而是：

- 这些东西已经存在，却仍然围绕修复说明、摘要解释与“先继续看看”运作

一旦如此，团队就会重新回到：

1. 看修复字段是不是都填了
2. 看事故摘要是不是说得通
3. 看 rollback 像不像回到了上一版
4. 看最后一条消息像不像还能继续

而不再围绕：

- 同一个 `compiled request truth`

## 2. repair object 伪绑定：升级卡存在，却没有绑定同一个请求对象

### 坏解法

- 宿主、CI、评审与交接系统虽然都拿到了一张 repair card，但 card 上的 `repair_object_id` 实际只是在引用一次事故说明、一次 patch 讨论或一份交接摘要，而不是同一个 request object family。

### 为什么坏

- Claude Code 的 Prompt 魔力不在“修复解释写得更完整”，而在 repair 仍服务于同一个已编译请求对象。
- 一旦 `repair_object_id` 退回说明对象，就会重新容忍：
  - `source_request_object_id` 与 `target_request_object_id` 只剩票据关系
  - `compiled_request_hash` 只是抄录而不是 live truth
  - `section registry` 与 `stable prefix boundary` 退回作者脑内边界
- 这样看起来更制度化，实际却把 Prompt 的编译链重新蒸发成事故叙事。

### Claude Code 式正解

- repair card 应首先证明它绑定的是同一个 request object，而不是一份更像正式文件的事故说明。


## 3. protocol truth 被修复说明掩盖

### 坏解法

- 团队虽然承认发生了 protocol truth 问题，但在 repair drill 里只验证解释链自洽，不再验证 `protocol transcript` 是否仍是模型真正消费的权威历史。

### 为什么坏

- Claude Code 真正面对模型的是 rewrite 之后的 protocol 世界，而不是 UI 历史或事故复盘文字。
- 一旦修复说明掩盖了 protocol truth，团队会最先误以为：
  - “原因说清了，应该就修好了”
  - “日志都在，应该还能继续”
- 这会让 Prompt 魔力从“可转写、可继续的协议对象”退回“更会解释的事故文本”。

### Claude Code 式正解

- repair drill 应持续验证 protocol truth，而不是让解释文本替代它。


## 4. 摘要回滚：rollback drill 回到旧 summary 与最后一条消息

### 坏解法

- rollback 看起来存在，实际只是回到上一份 summary、上一轮最后一条消息、某个 cache 仍命中的状态，或者“重新 compact 一次看看”。

### 为什么坏

- Prompt rollback 真正该回的不是叙事材料，而是上一个仍可验证的 `compiled request truth`、`protocol transcript boundary` 或 lawful forgetting boundary。
- 一旦回滚只剩 summary 与消息，团队就无法分清：
  - 是 section law 漂了
  - 是 rewrite 边界坏了
  - 是 lawful forgetting object 失真了
  - 还是 baseline reset 没执行
- 这会把 rollback 从对象级恢复重新退回可读性安慰。

### Claude Code 式正解

- rollback 应先回对象边界，再回辅助叙事。


## 5. 假重入：re-entry 被按钮状态与默认继续篡位

### 坏解法

- 团队虽然写了 `re_entry_qualification`，但真正允许继续时仍只看“现在没有硬错误”“按钮可点”“最后一条消息像是还能接”。

### 为什么坏

- Claude Code 的 continue 不是礼貌行为，而是由预算、hook、状态与 pending action 共治的正式 gate。
- 一旦重入退回默认继续，团队会同时做坏：
  - 把 continue gate 降为 UI 行为
  - 把 re-entry ticket 降为“重试一下”
  - 把 later 接手降为摘要接故事
- 这正是 Prompt 修复演练重新制造假连续性的地方。

### Claude Code 式正解

- re-entry 应围绕 `continue qualification`、`session_state_changed`、`pending_action_ref` 与 `required_preconditions`，而不是围绕“目前没被阻止”。


## 6. lawful forgetting 被事故故事取代

### 坏解法

- compact 之后，交接系统只要看到一段说得通的事故故事与 next step，就默认 later 团队已经可以继续，不再检查 lawful forgetting object 是否仍然保留行动边界。

### 为什么坏

- Claude Code 的 lawful forgetting 保护的是“later 还能继续行动的对象”，不是“later 还能看懂发生过什么”。
- 一旦交接只剩故事，Prompt 修复演练就会最先退回：
  - summary shadow
  - handoff through narrative
  - continuation without boundary

### Claude Code 式正解

- 交接通过应围绕 continuation object，而不是围绕事故叙事的可读性。


## 7. 苏格拉底式追问

在你读完这些反例后，先问自己：

1. 我现在修复的是 request object，还是事故说明。
2. 我现在保护的是 protocol truth，还是一套更会解释的文本。
3. 我现在回滚的是 boundary，还是 summary 与最后一条消息。
4. 我现在重入的是同一真相，还是默认继续。
5. 我现在交接的是 continuation object，还是一段更精致的故事。

## 8. 一句话总结

真正危险的 Prompt 宿主修复演练失败，不是没写升级卡，而是写了升级卡却仍在围绕 repair object 伪绑定、摘要回滚与假重入消费 Prompt 世界。
