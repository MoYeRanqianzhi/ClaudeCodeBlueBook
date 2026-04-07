# 安全载体家族强请求清理制度理由治理与强请求清理制度元数据治理分层速查表：carrier family、where truth lives、who currently consumes it、metadata gap与drift symptom

## 1. 这一页服务于什么

这一页服务于 [288-安全载体家族强请求清理制度理由治理与强请求清理制度元数据治理分层：为什么artifact-family cleanup stronger-request cleanup-rationale-governor signer不能越级冒充artifact-family cleanup stronger-request cleanup-metadata-governor signer](../288-安全载体家族强请求清理制度理由治理与强请求清理制度元数据治理分层.md)。

如果 `288` 的长文解释的是：

`为什么“这些 stronger-request carrier family 的理由已经存在”仍不等于“系统已经把这些理由提升成自己会复述的 metadata plane”，`

那么这一页只做一件事：

`把不同 family 的 truth 当前住在哪里、谁在消费、哪里存在 metadata gap 与 drift symptom 压成一张矩阵。`

## 2. 强请求清理制度理由治理与强请求清理制度元数据治理分层矩阵

| carrier family | where truth currently lives | who currently consumes it | metadata gap | drift symptom | governor question | 关键证据 |
| --- | --- | --- | --- | --- | --- | --- |
| task outputs | `diskOutput.ts` comment + repaired-temp path helper | task-output writer/reader path 与局部 runtime contract | truth explicit but still local; no shared family descriptor across cleanup / settings / drift-check planes | currently lower, but local explicit truth still not objectified | who turns anti-clobber local truth into reusable family metadata | `diskOutput.ts:33-49` |
| tool-results | file header + `TOOL_RESULTS_SUBDIR` + storage helper + project-session cleanup traversal | tool-result persistence path + cleanup traversal | inspection rationale exists, but still split across header/helper/traversal | medium; inspection truth remains easier for researchers to reconstruct than for the system to restate | who encodes persisted-inspection duty as system-readable metadata | `toolResultStorage.ts:1-5,94-118`; `cleanup.ts:155-257` |
| transcripts / casts | session persistence helper + transcript path helper + cleanup traversal | transcript writers/readers + replay / continuity consumer + cleanup traversal | continuity rationale not centralized with tool-results despite same constitution world | medium; same law, different duty, no shared explicit split | who separates continuity metadata from inspection metadata | `sessionStorage.ts:198-220`; `cleanup.ts:155-195` |
| plans | settings schema + storage helper + permission rule + resume helper + cleanup helper | settings, storage, permission gate, current-session read/write, resume recovery, cleanup | strongest cross-plane propagation gap | `plansDirectory` already changes storage/permission world while cleanup still targets default root | who preserves one plan-family truth across all planes | `settings/types.ts:824-830`; `plans.ts:79-106,164-233`; `permissions/filesystem.ts:245-255,1487-1494,1644-1652`; `cleanup.ts:300-303` |
| file-history | module-local path helper + restore helper + cleanup helper | restore flow + backup reader + cleanup | stable local truth, but no explicit restore-family grammar | lower now, but still not promoted to shared descriptor | who turns restore local truth into explicit metadata | `fileHistory.ts:951-957`; `cleanup.ts:305-347` |
| session-env | env-dir helper + replay helper + cleanup helper | env replay consumer + cleanup | stable local truth, but still module-bounded | lower now, but still not objectified into replay-family metadata | who turns replay local truth into explicit metadata | `sessionEnvironment.ts:15-21,60-140`; `cleanup.ts:350-387` |
| debug logs | argv/env checks + comment + debug path helper + cleanup helper | operational debugging, `/share`, bug-report support, cleanup | operational truth explicit but stays convention-heavy | medium; operational duty is visible yet not centralized with other retained carriers | who encodes operational-log duty as family metadata instead of comment/argv convention | `debug.ts:30-68,91-111,230-249`; `cleanup.ts:391-428` |
| diagnostics | no-PII comment + env-selected logfile helper | diagnostics writer + host-visible monitor world | host-monitoring truth not joined to repo-local family grammar | high from repo-local viewpoint; truth remains comment/env-local | who signs host-visible no-PII diagnostics metadata | `diagLogs.ts:11-20,27-60` |
| cleanup dispatcher | hardcoded call list in `cleanupOldMessageFilesInBackground()` | background cleanup executor | family plurality known operationally, not metadata-driven | hand-written order replaces shared registry-driven policy plane | who upgrades plural dispatch into plural metadata governance | `cleanup.ts:575-595` |

## 3. 三个最重要的判断问题

判断一句
“这些 stronger-request cleanup 理由既然已经存在，所以 metadata 也已经存在”
有没有越级，先问三句：

1. 这份 truth 目前是寄居在 local helper / comment，还是已经被多个平面共读
2. settings、storage、permissions、resume、cleanup 有没有共享同一份 family descriptor
3. 一处 family truth 变化后，别的平面会自动跟上，还是仍然依赖人工传播

## 4. 最常见的五类误读

| 误读 | 实际问题 |
| --- | --- |
| “注释写得很清楚，所以 metadata 已经有了” | explicit comment != metadata plane |
| “有 settings 字段，就说明 policy 已对象化” | local knob != family grammar |
| “现在没出 bug，说明传播没问题” | no current failure != no metadata gap |
| “多个 helper 拼起来能解释，就等于系统也能读回” | helper composition != shared descriptor |
| “dispatcher 已经分家，所以 metadata 已经齐了” | split execution != metadata-driven execution |

## 5. 一条硬结论

真正成熟的 stronger-request cleanup-metadata grammar 不是：

`family rationale exists in comments and helpers -> therefore the system already knows it`

而是：

`family truth named -> stored in explicit descriptor -> consumed by multiple planes -> drift can be checked`

只有这些层被补上，
stronger-request cleanup rationale 才不会继续停留在：

`研究者能把理由讲清楚，但系统自己还没有把这份理由保存成会重复读取的 metadata plane。`
