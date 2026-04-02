# 结构 Artifact Harness Runner落地手册：Authoritative Queue、Recovery Ledger、Anti-Zombie 审读与 Recovery Adoption

这一章不再解释结构 harness runner 为什么重要，而是把它压成团队可复用的落地手册。

它主要回答五个问题：

1. 怎样让结构 runner 真正围绕同一 `authoritative object` 连续运行，而不是围绕目录图、成功率与作者说明连续运行。
2. 怎样把 `authoritative queue`、`recovery ledger`、`anti-zombie review` 与 `recovery adoption` 放进同一张操作卡。
3. 怎样让宿主、CI、评审与交接沿同一结构顺序消费 runner，而不是各自保存一份局部真相。
4. 怎样识别“恢复已经成功、bridge 也连上了、作者也解释了”这类看似成熟、实则仍会 split-brain 的假落地。
5. 怎样用苏格拉底式追问避免把结构 runner 退回目录审美和口头经验。

## 0. 代表性源码锚点

- `claude-code-source-code/src/services/api/sessionIngress.ts:57-186`
- `claude-code-source-code/src/utils/sessionStorage.ts:1085-1215`
- `claude-code-source-code/src/utils/sessionStorage.ts:3469-3705`
- `claude-code-source-code/src/utils/task/framework.ts:160-269`
- `claude-code-source-code/src/tasks/RemoteAgentTask/RemoteAgentTask.tsx:386-845`
- `claude-code-source-code/src/bridge/bridgePointer.ts:22-184`
- `claude-code-source-code/src/bridge/remoteBridgeCore.ts:824-880`
- `claude-code-source-code/src/cli/remoteIO.ts:54-199`

这些锚点共同说明：

- 源码先进性真正共享的不是目录更整洁，而是“恢复对象边界明确、stale writer 被清退、live truth 在恢复时重建”。

## 1. 第一性原理

更成熟的结构 runner 不是：

- 有更多恢复脚本

而是：

- 每次继续前，都重新确认当前进入主路径的仍然是同一个 `authoritative object`

所以团队最该先问的不是：

- 现在看起来能不能恢复

而是：

- 当前恢复的是哪个对象、谁还在写它、谁已经被正式清退

## 2. Structure Runner Header

任何结构 runner 操作卡都先锁这一组 shared header：

```text
queue_item_id:
structure_object_id:
authoritative_path:
current_read_path:
current_write_path:
recovery_asset_ledger:
retained_assets:
dropped_stale_writers:
rollback_object:
bridge_pointer_ref:
sequence_cursor:
generation:
adoption_target:
identity_sidecar_ref:
```

团队规则：

1. 没有 `authoritative_path` 的 queue item，不得入主路径。
2. 没有 `recovery_asset_ledger` 的恢复结果，不得宣称恢复成功。
3. 没有 `dropped_stale_writers` 的 anti-zombie 结论，不得宣称 split-brain 已解决。
4. 没有 `rollback_object` 的 handoff，不得要求后来者继续。
5. `identity ledger` 与 `live status truth` 必须分开；sidecar 里记录身份，不记录最终真相。

## 3. Authoritative Queue Policy

先审 queue 是不是在保护真实对象，而不是保护“当前还能跑”：

```text
[ ] authoritative_path 是否点名
[ ] 当前 read / write path 是否点名
[ ] session / subagent / remote-agent 路径是否都走 helper
[ ] 当前 queue item 是否只持久化 identity，而不是 stale runtime status
[ ] sidecar / pointer / transcript 之间的恢复边界是否点名
[ ] rollback_object 是否已先于继续被点名
```

直接判 drift 的情形：

1. queue 只保存“上次状态是 running”，没有 object identity。
2. queue 没有 `authoritative_path`，只给目录图。
3. 恢复时继续沿用 stale task / stale bridge status，而不是拉 live truth。
4. 代码自己拼 `sessionId + subagents|remote-agents|jsonl` 路径，而不是走 sessionStorage helper。

## 4. Recovery Ledger Review

任何结构 runner 都要单独审 recovery ledger，而不是只看恢复成功率：

```text
[ ] session ingress 是否围绕 append chain 对象
[ ] queue-operation 是否被当作 ledger 而不是 authoritative queue
[ ] typed object set 是否存在
[ ] retained_assets 是否存在
[ ] bridge pointer / TTL / worktree fanout 是否存在
[ ] 恢复时的 live status rehydrate 是否存在
```

团队规则：

1. “已经恢复”不能替代 `recovery_asset_ledger`。
2. “桥已连上”不能替代 `bridge_pointer + generation + sequence cursor`。
3. “任务回来了”不能替代重新拉 live truth。
4. “有 queue-operation 日志”不能替代用户消息已被 transcript 接受。

## 5. Anti-Zombie Review

任何结构 runner 都必须单独审 stale writer 是否真的死掉：

```text
[ ] stale writer 是否已被 dropped
[ ] task offset patch 是否只打在 fresh state
[ ] 新 task 类型是否进入中央 registry
[ ] 401 recovery 期间 stale control / stale result 是否被丢弃
[ ] duplicate / stale pointer 是否会被清理
[ ] session write chain 是否仍围绕同一 last uuid
```

核心原则不是：

- 写了 anti-zombie 规则

而是：

- 旧 writer 必须被正式证明无法继续夺权

因此任何下列实现都应直接标红：

1. async 之后把旧 task 整体 spread 回 `AppState`
2. 绕过 `registerTask/updateTaskState/applyTaskOffsetsAndEvictions` 直接写 `tasks[id]`
3. 新 task 类型没有同时补 registry、restore、kill 与 notification 语义

## 6. Recovery Adoption Runbook

更稳的结构 adoption 顺序应固定为：

1. 先确认当前 drift 是 authority drift、recovery drift 还是 stale-writer drift。
2. 再确认恢复资产是 typed object set，而不是 transcript 一坨字节。
3. 再按 `clear session metadata -> restore metadata -> restore worktree -> adopt resumed session file -> restore remote tasks` 的顺序执行恢复采纳。
4. 再确认哪些 `retained_assets` 还可信，以及 `rollback_object` 是否过宽或过窄。
5. 最后把 `dropped_stale_writers`、`authoritative_path` 与 `recovery adoption` 一起写回，并重新进入 queue。

团队记录卡：

```text
当前结构对象:
当前 authoritative_path:
本次 recovery ledger:
已清退的 stale writers:
本次 adoption target:
adoption 后如何重新进入主路径:
```

## 7. 常见自欺

看到下面信号时，应提高警惕：

1. 用目录图替代 authoritative queue。
2. 用成功率替代 recovery ledger。
3. 用作者说明替代 dropped_stale_writers。
4. 用 pointer 还在替代 generation 仍然有效。
5. 用 sidecar 里的旧状态替代 live truth。
6. 用 recovery adoption 已写进文档替代它已重新通过 anti-zombie review。

## 8. 苏格拉底式检查清单

在你准备宣布“结构 runner 已经落地”前，先问自己：

1. 我现在消费的是同一 authoritative object，还是一组相关但分裂的结构材料。
2. recovery ledger 记录的是恢复边界，还是只记录了恢复结果。
3. anti-zombie review 证明的是旧 writer 已死，还是只证明团队相信它已死。
4. recovery adoption 恢复的是主路径，还是只恢复了口头共识。
5. 如果删掉作者解释和目录图，后来者是否仍能沿同一对象继续恢复。
