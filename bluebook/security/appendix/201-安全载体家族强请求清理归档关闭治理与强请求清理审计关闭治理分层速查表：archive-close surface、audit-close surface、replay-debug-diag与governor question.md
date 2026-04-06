# 安全载体家族强请求清理归档关闭治理与强请求清理审计关闭治理分层速查表：archive-close surface、audit-close surface、replay-debug-diag与governor question

## 1. 这一页服务于什么

这一页服务于 [217-安全载体家族强请求清理归档关闭治理与强请求清理审计关闭治理分层：为什么artifact-family cleanup stronger-request archive-close-governor signer不能越级冒充artifact-family cleanup stronger-request audit-close-governor signer](../217-安全载体家族强请求清理归档关闭治理与强请求清理审计关闭治理分层.md)。

如果 `217` 的长文解释的是：

`为什么 old stronger cleanup echo 已经退出 active operational surface，仍不等于它已经退出 replay / debug / diagnostics 审计世界，`

那么这一页只做一件事：

`把 repo 里现成的 stronger-request archive-close surface / stronger-request audit-close surface 正例，与 stronger-request cleanup 线当前仍缺的 audit-close grammar，压成一张矩阵。`

## 2. 强请求清理归档关闭治理与强请求清理审计关闭治理分层矩阵

| line | stronger-request archive-close surface | stronger-request audit-close surface | positive control | cleanup audit gap | governor question | 关键证据 |
| --- | --- | --- | --- | --- | --- | --- |
| `control_response` replay path | old echo may already be off active lifecycle / queue surfaces | replay mode still re-exposes the same old echo upstream | `Propagate control responses when replay is enabled` + `output.enqueue(message)` | stronger-request cleanup line has no explicit rule for when an archived stronger cleanup echo must also leave replay world | who decides when an archived stronger cleanup echo no longer deserves replay visibility | `structuredIO.ts:424-428`; `print.ts:4030-4036` |
| duplicate debug trail | active duplicate handling is already closed | debug log still records duplicate request_id / toolUseID trace | `Ignoring duplicate control_response ...` | stronger-request cleanup line has no explicit decision for when duplicate stronger cleanup echoes stop leaving debug trace | who decides when an archived stronger cleanup duplicate should no longer remain in debug / audit trace | `structuredIO.ts:386-398` |
| orphaned permission debug trail | old orphan may already be refused active re-entry | audit / debug still records received / skipped / resolved / enqueued states | orphaned permission debug lines | stronger-request cleanup line has no explicit boundary for when archived stronger cleanup echoes stop being diagnosable | who decides when archived stronger cleanup orphan traces no longer remain in explainability surfaces | `print.ts:5258-5292` |
| diagnostics parse surface | active-world handling can be over | returned messages in replay mode still enter diagnostics parsing | `cli_stdin_message_parsed` | stronger-request cleanup line has no explicit diagnostics-close gate for archived stronger cleanup echoes | who decides when an archived stronger cleanup echo no longer counts as a parsed / observable diagnostics object | `structuredIO.ts:228-236,424-428` |
| no-admission vs no-audit | old echo may be refused queue admission | refusal does not erase the fact or explanation of that refusal from audit surfaces | `return false` plus retained trace | stronger-request cleanup line has no explicit separation between operational non-admission and evidentiary disappearance | who decides when refusing active re-entry is still not enough, because audit evidence remains open | `print.ts:5238-5305` |

## 3. 三个最重要的判断问题

判断一句

`old stronger cleanup echo 已经 archive-close，所以等于已经 audit-close`

有没有越级，先问三句：

1. 这里回答的是 active-surface exit，还是 evidentiary-surface exit
2. replay / debug / diagnostics 面是否仍在继续承载这条 old echo
3. 这里是不是把“operator 现在看不见”偷写成“审计者以后也看不见”

## 4. 最常见的五类误读

| 误读 | 实际问题 |
| --- | --- |
| “不再 active 就等于不再可审计” | archive close != audit close |
| “不再进 queue 就说明不会留下 trace” | non-admission != no evidence |
| “debug log 只是工程噪音，不算审计面” | explainability traces are part of audit surface |
| “replay 只是兼容功能，不影响关闭层级” | replay is a real evidence surface |
| “看不见旧 echo 了，所以它已经彻底退出世界” | hidden from operators != gone from audit world |

## 5. 一条硬结论

真正成熟的 stronger-request cleanup audit-close grammar 不是：

`old stronger cleanup echo is archived out of active operation -> therefore it is out of audit world too`

而是：

`old stronger cleanup echo is archived out of active operation -> inspect replay / debug / diagnostics surfaces -> close those evidence surfaces explicitly -> only then treat it as audit-closed`

只有中间这些层被补上，
stronger-request cleanup archive-close governance 才不会继续停留在：

`它能决定 old echo 已经离开活跃操作表面，却没人正式决定它什么时候也离开 replay、debug 与 diagnostics 这些审计世界。`
