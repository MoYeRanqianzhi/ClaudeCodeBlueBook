# 安全清理隔离与载体家族宪法分层速查表：artifact family、storage scope、cleanup root、current gate与constitution question

## 1. 这一页服务于什么

这一页服务于 [158-安全清理隔离与载体家族宪法分层：为什么cleanup-isolation signer不能越级冒充artifact-family cleanup constitution signer](../158-%E5%AE%89%E5%85%A8%E6%B8%85%E7%90%86%E9%9A%94%E7%A6%BB%E4%B8%8E%E8%BD%BD%E4%BD%93%E5%AE%B6%E6%97%8F%E5%AE%AA%E6%B3%95%E5%88%86%E5%B1%82%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88cleanup-isolation%20signer%E4%B8%8D%E8%83%BD%E8%B6%8A%E7%BA%A7%E5%86%92%E5%85%85artifact-family%20cleanup%20constitution%20signer.md)。

如果 `158` 的长文解释的是：

`为什么不同 artifact family 当前并不共享同一套 cleanup constitution，`

那么这一页只做一件事：

`把不同载体家族的 storage scope、cleanup root、当前 gate 与仍待回答的 constitution question 压成一张矩阵。`

## 2. 清理隔离与载体家族宪法分层矩阵

| artifact family | storage scope | cleanup root | current gate | constitution question | 关键证据 |
| --- | --- | --- | --- | --- | --- |
| task outputs | `projectTempDir/sessionId/tasks` | local task-output lifecycle, not `projects/` sweep | session-scoped temp-dir guard | why this family already earned explicit session isolation | `diskOutput.ts:33-55` |
| scratchpad | `projectTempDir/sessionId/scratchpad` | current-session temp path | current-session read/write path guard | why this family is session-scoped while others are not | `permissions/filesystem.ts:381-423,1499-1506,1676-1684` |
| tool-results | `projectDir/sessionId/tool-results` | `cleanupOldSessionFiles()` project sweep | session bucket + mtime sweep | why this family still lives under project sweep instead of temp-dir isolation | `toolResultStorage.ts:94-118`; `cleanup.ts:196-250` |
| transcripts / casts | `projectDir/<session>.jsonl/.cast` | `cleanupOldSessionFiles()` project sweep | top-level project file + mtime sweep | why transcript cleanup does not visibly consult live-session ledger | `sessionStorage.ts:198-215`; `cleanup.ts:181-195` |
| plans | `~/.claude/plans` by default, optionally project-root override | `cleanupOldPlanFiles()` | extension-only single-directory cleanup | why plan files get a home-root constitution, not session tree cleanup | `plans.ts:79-110`; `cleanup.ts:300-303`; `settings/types.ts:824-830` |
| file-history backups | `~/.claude/file-history/<sessionId>/` | `cleanupOldFileHistoryBackups()` | per-session dir mtime + recursive rm | why backup family uses home-root retention instead of project-root sweep | `fileHistory.ts:951-957`; `cleanup.ts:305-347` |
| session-env dirs | `~/.claude/session-env/<session>/` | `cleanupOldSessionEnvDirs()` | per-session dir mtime + recursive rm | why env dirs share home-root per-session constitution | `cleanup.ts:350-387` |

## 3. 最短判断公式

判断某句“这些 artifact family 现在共享同一套 cleanup law”的说法有没有越级，先问五句：

1. 它们的 storage scope 是否真的相同
2. 它们的 cleanup root 是 temp-dir、project tree 还是 home-root
3. 它们的 current gate 是 session path、mtime sweep 还是 single-dir cleanup
4. 当前 family-specific 差异有没有被正式解释
5. 当前说法是在陈述局部修补，还是在假装全局同宪

## 4. 最常见的五类误读

| 误读 | 实际问题 |
| --- | --- |
| “带 sessionId 的都算同一 constitution” | session bucket 不等于 same cleanup law |
| “都在内部路径里，所以 gate 应该一样” | internal readable/editable 不等于 same cleanup root |
| “task outputs 修好了，所以 tool-results/transcripts 也算同级安全” | one family’s repair does not generalize automatically |
| “plans 在 home-root，所以一定更成熟” | home-root placement 不等于 better constitution |
| “多种 cleanup 规则并存就是设计混乱” | plural constitutions can be intentional, but they need explicit rationale |

## 5. 一条硬结论

真正成熟的 cleanup constitution grammar 不是：

`one_cleanup_fix -> one_repo_constitution`

而是：

`family_scoped_storage、family_scoped_cleanup_root、family_scoped_gate、family_scoped_rationale`

分别由不同 artifact family 的 constitution signer 解释与署名。
