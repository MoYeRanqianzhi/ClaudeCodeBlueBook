# 安全执行诚实性与清理隔离分层速查表：artifact family、current isolation guard、remaining cross-session risk、missing proof与design implication

## 1. 这一页服务于什么

这一页服务于 [157-安全执行诚实性与清理隔离分层：为什么retention-enforcement-honesty signer不能越级冒充cleanup-isolation signer](../157-%E5%AE%89%E5%85%A8%E6%89%A7%E8%A1%8C%E8%AF%9A%E5%AE%9E%E6%80%A7%E4%B8%8E%E6%B8%85%E7%90%86%E9%9A%94%E7%A6%BB%E5%88%86%E5%B1%82%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88retention-enforcement-honesty%20signer%E4%B8%8D%E8%83%BD%E8%B6%8A%E7%BA%A7%E5%86%92%E5%85%85cleanup-isolation%20signer.md)。

如果 `157` 的长文解释的是：

`为什么 cleanup executed 仍不等于 cleanup isolated，`

那么这一页只做一件事：

`把不同 artifact family 当前有哪些隔离护栏、还剩什么 cross-session 风险、缺什么 live-peer proof，压成一张矩阵。`

## 2. 执行诚实性与清理隔离分层矩阵

| artifact family | current isolation guard | remaining cross-session risk | missing proof | design implication | 关键证据 |
| --- | --- | --- | --- | --- | --- |
| task outputs | session-scoped temp dir: `projectTempDir/sessionId/tasks` | same-project peers may still read temp space, so isolation must stay explicit | explicit noninterference receipt | task output family already shows a repaired isolation model | `diskOutput.ts:33-55`; `permissions/filesystem.ts:1688-1700` |
| task output side effects | diagnostic string exposes historical startup-cleanup deletion | still post-hoc, not a formal isolation receipt | structured cross-session side-effect record | need pre/post cleanup isolation ledger | `TaskOutput.ts:313-325` |
| persisted tool-results | per-session path `projectDir/sessionId/tool-results` | cleanup sweep still traverses all session dirs by mtime | live-peer dependency check before delete | session-bucketed storage is not enough by itself | `toolResultStorage.ts:94-118`; `cleanup.ts:196-250` |
| session transcripts / casts | stored under project dir and cleaned by old-session sweep | no visible active-session registry consultation in cleanup path | active-session isolation gate | need transcript-family cleanup preflight | `sessionStorage.ts:198-215`; `cleanup.ts:155-195` |
| live session registry | `~/.claude/sessions/<pid>.json` records live peers | registry exists but cleanup path does not visibly consult it | bridge from liveness ledger to cleanup decision | existing ledger should become cleanup input, not just ps telemetry | `concurrentSessions.ts:49-109,163-204`; `main.tsx:2526-2542` |
| project temp shared read surface | read access intentionally spans all sessions in same project | shared readability raises the cost of wrong deletes | family-specific isolation constitution | same-project is not a sufficient delete boundary | `permissions/filesystem.ts:1688-1700` |

## 3. 最短判断公式

判断某句“cleanup 这次已经安全隔离地执行了”的说法有没有越级，先问五句：

1. 当前 artifact family 有没有专门的 session-scoped path or guard
2. cleanup 执行前有没有 consult live-session ledger
3. 当前只知道执行发生，还是也知道没有 live peer 依赖
4. 当前解释是 formal receipt，还是事后 diagnostic string
5. 这个 family 的 isolation 修补是否已经推广成统一 cleanup constitution

## 4. 最常见的五类误读

| 误读 | 实际问题 |
| --- | --- |
| “执行有回执了，所以隔离也一定没问题” | execution honesty 不等于 noninterference proof |
| “路径里有 sessionId，所以不会误伤别的 session” | path scoping 不等于 live dependency check |
| “既然仓库里有 concurrent session registry，cleanup 一定会用它” | ledger 存在不等于 cleanup consults it |
| “TaskOutput 能报错说明系统已经把问题治理完了” | post-hoc diagnostic 不等于 prevention |
| “同项目 temp 空间都可读，所以删同项目文件也无所谓” | shared readability 反而提高了 isolation requirement |

## 5. 一条硬结论

真正成熟的 cleanup isolation grammar 不是：

`cleanup_executed -> cleanup_isolated`

而是：

`artifact_family_scoped、live_peer_checked、cleanup_executed、side_effects_recorded、noninterference_proved`

分别由不同 guard、不同 ledger 与不同 receipt surface 署名。
