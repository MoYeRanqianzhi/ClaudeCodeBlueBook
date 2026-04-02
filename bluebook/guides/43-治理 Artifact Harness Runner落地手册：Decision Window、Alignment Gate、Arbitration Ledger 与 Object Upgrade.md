# 治理 Artifact Harness Runner落地手册：Decision Window、Alignment Gate、Arbitration Ledger 与 Object Upgrade

这一章不再解释治理 harness runner 为什么重要，而是把它压成团队可复用的落地手册。

它主要回答五个问题：

1. 怎样让治理 runner 真正围绕同一 `decision window` 连续运行，而不是围绕状态色、计数与 verdict 连续运行。
2. 怎样把 `decision queue`、`alignment gate`、`arbitration ledger` 与 `object upgrade` 放进同一张操作卡。
3. 怎样让宿主、CI、评审与交接沿同一治理顺序消费 runner，而不是各自解释为什么这次还能继续。
4. 怎样识别“自动化已经完成、面板也转绿了、审批也结束了”这类看似成熟、实则没有治理对象的假落地。
5. 怎样用苏格拉底式追问避免把治理 runner 退回更复杂的审批流程图。

## 0. 代表性源码锚点

- `claude-code-source-code/src/utils/QueryGuard.ts:29-93`
- `claude-code-source-code/src/query/tokenBudget.ts:1-92`
- `claude-code-source-code/src/utils/permissions/permissions.ts:593-760`
- `claude-code-source-code/src/utils/permissions/permissions.ts:1169-1280`
- `claude-code-source-code/src/hooks/toolPermission/handlers/interactiveHandler.ts:138-330`
- `claude-code-source-code/src/cli/structuredIO.ts:149-657`
- `claude-code-source-code/src/services/mcp/channelPermissions.ts:1-240`
- `claude-code-source-code/src/utils/sessionState.ts:92-133`
- `claude-code-source-code/src/state/onChangeAppState.ts:43-92`

这些锚点共同说明：

- 安全设计与省 token 设计真正共享的不是一堆规则，而是“当前这轮是否仍有决策增益、谁赢得仲裁、失败时回退哪个对象”。

## 1. 第一性原理

更成熟的治理 runner 不是：

- 让更多 gate 排队运行

而是：

- 每次继续前，都重新确认这次继续是否仍然围绕同一个 `decision_window`

所以团队最该先问的不是：

- 当前是不是已经转绿

而是：

- 当前这轮继续到底还能改变什么判断

## 2. Governance Runner Header

任何治理 runner 操作卡都先锁这一组 shared header：

```text
queue_item_id:
governance_object_id:
decision_window:
continuation_count:
winner_source:
control_arbitration_truth:
permission_mode:
pending_action:
rollback_object:
object_upgrade_rule:
next_action:
transition_reason:
generation:
```

团队规则：

1. 没有 `decision_window` 的 queue item，不得入主路径。
2. 没有 `winner_source` 与 `control_arbitration_truth` 的批准结果，不得当作正式治理决定。
3. 没有 `rollback_object` 与 `next_action` 的 handoff，不得当作继续输入。
4. `permission_mode` 如果已经写回外部元数据，却没有对应 `governance_object_id`，直接判 drift。
5. `dispatching` 也算窗口已占用；如果只有 `running` 才算忙态，这条 queue policy 直接不合格。

## 3. Decision Queue Policy

先审 queue 是不是在保护治理对象，而不是在保护“当前大家还没明确反对”：

```text
[ ] QueryGuard generation 是否存在
[ ] dispatching 是否被视为 active window
[ ] 当前 queue item 是否点名 decision_window
[ ] 当前继续是否带着 continuation_count / pct / delta
[ ] 当前 pending_action 是否已写回
[ ] rollback_object 是否已先于继续被点名
```

直接判 drift 的情形：

1. queue 只保存 pass / fail，没有 `decision_window`。
2. queue 只保存 token 图，没有 continuation_count / delta。
3. 当前是 requires_action，但没有 pending_action 与 rollback_object。
4. cancel 只是把状态设回 idle，却没有 bump generation。

## 4. Alignment Gate

治理 runner 的 alignment gate 必须先审谁赢了这次仲裁，而不是先审结果好不好看：

```text
[ ] 本地 UI / bridge / hook / channel / classifier 是否有唯一 winner
[ ] late response / duplicate response 是否被显式取消
[ ] control_cancel_request 是否随胜者产生
[ ] 结果是否回链到同一 governance_object_id
[ ] Context Usage 是否能解释为何继续或停止
```

团队规则：

1. ask 次数不能替代 `winner_source`。
2. verdict 不能替代 `control_arbitration_truth`。
3. “这次没有报错”不能替代 `decision_window` 仍然有效。
4. host ABI 只能消费 external mode，不能直接消费 internal `auto / bubble` 名字。

## 5. Arbitration Ledger Review

任何治理 runner 都要单独审 arbitration ledger，而不是只审谁最后按下了允许：

```text
[ ] permission_mode 写回是否通过单一 choke point
[ ] pending_action 是否被外化
[ ] resolvedToolUseIds / cancel path 是否存在
[ ] internal mode 与 external mode 是否分层
[ ] managed-only 打开时非 policy source 是否被清空
[ ] classifier / hook / bridge / channel 的胜负是否可复盘
[ ] 失败时的 transition_reason 是否存在
```

更稳的 ledger 不记录：

- “最后通过了”

而记录：

1. 谁先赢。
2. 谁被取消。
3. 为什么继续。
4. 为什么停止。
5. 当前 metadata 对外暴露的是哪个 external mode。

## 6. Object Upgrade Runbook

更稳的治理升级顺序应固定为：

1. 先确认这次 drift 是 `decision_window` 消失，还是 `arbitration_truth` 消失。
2. 再确认当前 `rollback_object` 是否足够窄。
3. 再确认 mode 切换是不是对象升级，而不是 UI toggle；必要时先 stash / strip dangerous allow rules。
4. 再判断是否需要从 session 升级成 task / compact / worktree。
5. 最后把 `object_upgrade_rule`、`next_action` 与 `transition_reason` 一起写回。

团队记录卡：

```text
当前 decision_window:
当前 generation:
当前 winner_source:
当前 rollback_object:
为什么不该继续:
应升级成什么对象:
upgrade 后如何重新进入主路径:
```

## 7. 常见自欺

看到下面信号时，应提高警惕：

1. 用状态色替代 decision window。
2. 用审批结束替代 arbitration truth。
3. 用 token 更省替代治理更成熟。
4. 用 bypass / auto 放行替代 rollback object 已明确。
5. 用 internal mode 名字直接对外暴露，假装 host 看懂了真实治理状态。
6. 用 object upgrade 已写在文档里替代它已重新通过 gate。

## 8. 苏格拉底式检查清单

在你准备宣布“治理 runner 已经落地”前，先问自己：

1. 我现在消费的是同一 decision window，还是只是在消费一组面板结果。
2. 这次继续还有决策增益，还是只是没有人先按停止。
3. arbitration ledger 记录的是正式胜负，还是只记录了最终表态。
4. object upgrade 恢复的是治理对象，还是只恢复了流程表面。
5. 如果删掉状态色、计数和 verdict，这套治理顺序是否仍然成立。
