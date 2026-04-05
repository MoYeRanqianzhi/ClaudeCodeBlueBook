# 安全不可逆销毁与保留期主权分层速查表：layer、current authority、execution gate、forbidden overclaim与design implication

## 1. 这一页服务于什么

这一页服务于 [155-安全不可逆销毁与保留期主权分层：为什么irreversible-erasure signer不能越级冒充retention-governor signer](../155-安全不可逆销毁与保留期主权分层：为什么irreversible-erasure%20signer不能越级冒充retention-governor%20signer.md)。

如果 `155` 的长文解释的是：

`为什么 destructive executor 仍不等于 retention governor，`

那么这一页只做一件事：

`把 retention governance 的不同 layer 到底谁在说话、谁在触发执行、谁不能越级说什么，压成一张矩阵。`

## 2. 不可逆销毁与保留期主权分层矩阵

| layer | current authority | execution gate | forbidden overclaim | design implication | 关键证据 |
| --- | --- | --- | --- | --- | --- |
| retention declaration | settings schema / docs text | config accepted into effective settings | “文案写了就等于已执行” | 需要 declaration vs enforcement honesty | `settings/types.ts:325-332`; `validationTips.ts:48-54` |
| retention precedence | merged settings sources | `user -> project -> local -> policy` effective merge | “执行器天然知道谁最该决定 retention” | 需要 destructive-policy trust class | `settings/settings.ts:798-820` |
| user-intent honesty guard | `rawSettingsContainsKey()` + validation error check | explicit user key + validation failure => skip cleanup | “默认 30 天可安全代替用户失败配置” | 需要 intent-preservation ledger | `settings/settings.ts:871-875,984-1015`; `cleanup.ts:575-584` |
| housekeeping scheduler | `main.tsx` / `REPL.tsx` / `backgroundHousekeeping.ts` | non-bare, first submit, delay, recent-activity checks | “policy 存在就等于现在立刻删” | 需要 schedule-state visibility | `main.tsx:2811-2818`; `REPL.tsx:3903-3906`; `backgroundHousekeeping.ts:25-29,43-60` |
| destroy executor | `cleanup.ts` unlink/rm paths | cutoff reached and cleanup path invoked | “会 rm 的函数就拥有 retention law” | 需要 executor scoped as bailiff not governor | `cleanup.ts:155-257,305-347,575-595` |
| sensitive-setting hardening comparison | dangerous-permission / auto-mode config excludes project settings | trusted-source-only reads | “retention governance 已与 permission governance 同级加固” | 当前 retention governance 仍较通用 | `settings/settings.ts:877-904,916-921` |

## 3. 最短判断公式

判断某句“系统现在有权删除这些材料”的说法有没有越级，先问五句：

1. 当前说的是 declaration、precedence、scheduler 还是 executor
2. retention 值从哪个 source merge 出来
3. validation error 时系统有没有因为用户显式意图而暂停 cleanup
4. 当前 entrypoint / mode / lifecycle 是否真的已经启动 housekeeping
5. 执行 unlink/rm 的代码是否正在冒充 policy governor

## 4. 最常见的五类误读

| 误读 | 实际问题 |
| --- | --- |
| “schema 写 startup delete，所以 runtime 已经 startup delete” | declaration 不等于 enforcement |
| “cleanup.ts 会删，所以它就是 retention authority” | executor 不等于 governor |
| “默认 30 天在任何异常下都能接管” | 显式用户意图 + validation failure 会直接跳过 cleanup |
| “只要进程启动了，cleanup 就已经开始跑” | REPL 路径要 first submit，且 housekeeping 还受 delay/activity gating 影响 |
| “retention governance 已像危险权限一样单独加固” | 当前可见实现仍走通用 settings merge 逻辑 |

## 5. 一条硬结论

真正成熟的 retention grammar 不是：

`destroy_executed -> policy_legitimate`

而是：

`retention_declared、retention_merged、intent_preserved、cleanup_scheduled、destruction_executed`

分别由不同 layer、不同 authority 与不同 honesty gate 署名。
