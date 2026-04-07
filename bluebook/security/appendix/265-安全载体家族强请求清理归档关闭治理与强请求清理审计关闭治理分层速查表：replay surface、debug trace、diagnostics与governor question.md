# 安全载体家族强请求清理归档关闭治理与强请求清理审计关闭治理分层速查表：replay surface、debug trace、diagnostics与governor question

## 1. 这一页服务于什么

这一页服务于 [281-安全载体家族强请求清理归档关闭治理与强请求清理审计关闭治理分层：为什么artifact-family cleanup stronger-request archive-close-governor signer不能越级冒充artifact-family cleanup stronger-request audit-close-governor signer](../281-安全载体家族强请求清理归档关闭治理与强请求清理审计关闭治理分层.md)。

如果 `281` 的长文解释的是：

`为什么“old echo 现在已经退出 active operational surfaces”仍不等于“这条 old echo 现在也已经退出 replay、debug、diagnostics 这些审计面”，`

那么这一页只做一件事：

`把 repo 里现成的 archive-close / audit-close 正例，与 stronger-request cleanup 线当前仍缺的 evidentiary-exit grammar，压成一张矩阵。`

## 2. 强请求清理归档关闭治理与审计关闭治理分层矩阵

| line | stronger-request archive-close decision | stronger-request audit-close decision | positive control | cleanup audit gap | governor question | 关键证据 |
| --- | --- | --- | --- | --- | --- | --- |
| replay propagation | old echo may already be off active handling surfaces | still propagate `control_response` when replay is enabled | `Propagate control responses when replay is enabled` | stronger-request cleanup line has no explicit replay-close layer after archive-close | who decides when an archived stronger cleanup echo must stop being replayable | `structuredIO.ts:424-428` |
| replay enqueue | old echo no longer blocks current operational flow | still enqueue the old echo into replay output stream | `Replay control_response messages when replay mode is enabled` | stronger-request cleanup line has no explicit “off active surface, still on replay surface” grammar | who decides when archived stronger cleanup echoes still remain visible to replay consumers | `print.ts:4030-4036` |
| duplicate/orphan debug traces | old echo may already be no-more-duty and off active queue/lifecycle surfaces | debug traces still preserve why it was ignored, refused, or replayed | `logForDebugging(...)` on duplicate/orphan paths | stronger-request cleanup line has no explicit rule for when audit explainability stops | who decides when archived stronger cleanup echoes stop leaving debug evidence | `structuredIO.ts:386-398`; `print.ts:5258-5292` |
| diagnostics parse surface | message may already be inactive in operator world | returned message still enters diagnostics parsing | `cli_stdin_message_parsed` | stronger-request cleanup line has no explicit diagnostics-close layer after archive-close | who decides when archived stronger cleanup echoes stop being diagnostic observability objects | `structuredIO.ts:228-236,424-428` |
| stronger cleanup audit gap | old echo may already be off lifecycle / waiting / queue / observability surfaces | no explicit audit-close grammar yet | replay/debug/diagnostics surfaces still not formally closed | stronger-request cleanup still lacks a single governor that says old echoes are off evidentiary surfaces too | who decides when an archived stronger cleanup echo is also out of the audit world | current cleanup line evidence set |

## 3. 三个最重要的判断问题

判断一句“old echo 已经 archive-close，所以当然也 audit-close 了”有没有越级，先问三句：

1. 这里回答的是 operational exit，还是 evidentiary exit
2. replay、debug、diagnostics 是否仍在继续承载这条 old echo
3. 当前看到的是 operator surface 关闭，还是审计 surface 关闭

## 4. 最常见的五类误读

| 误读 | 实际问题 |
| --- | --- |
| “不再 active 了，所以以后也不会被 replay” | archive-close != replay-close |
| “不再进队列了，所以调试轨迹自然也该消失” | queue exit != debug exit |
| “completed 已发出，所以 diagnostics 也结束了” | operator-facing close != diagnostics close |
| “看不见了，所以已经审计关闭了” | invisibility now != audit invisibility later |
| “拒绝处理旧 echo 就等于不再需要任何证据面” | refusal != evidentiary closure |

## 5. 技术启示四条

1. 退出现场与退出证据世界必须拆成两张协议，否则系统会丢失可解释性。
2. replay 是证据面，不是兼容噪音。
3. debug trace 是 refusal / ignore / compensate 这些判断的解释资产，不是顺手日志。
4. diagnostics 仍在看见旧消息，本身就说明 audit-close 尚未成立。

## 6. 一条硬结论

真正成熟的 stronger-request cleanup audit-close grammar 不是：

`old echo is off the active surfaces -> therefore it is out of replay/debug/diagnostics too`

而是：

`old echo is off the active surfaces -> inspect replay propagation -> inspect debug traces -> inspect diagnostics observability -> only then decide whether it has left the audit world`

只有中间这些层被补上，
stronger-request cleanup archive-close governance 才不会继续停留在：

`它能决定 old echo 已退出活跃表面，却没人正式决定它什么时候也已退出证据世界。`
