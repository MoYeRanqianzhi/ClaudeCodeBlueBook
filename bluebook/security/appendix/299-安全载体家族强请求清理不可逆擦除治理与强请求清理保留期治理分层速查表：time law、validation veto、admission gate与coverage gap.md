# 安全载体家族强请求清理不可逆擦除治理与强请求清理保留期治理分层速查表：time law、validation veto、admission gate与coverage gap

## 1. 这一页服务于什么

这一页服务于 [315-安全载体家族强请求清理不可逆擦除治理与强请求清理保留期治理分层](../315-安全载体家族强请求清理不可逆擦除治理与强请求清理保留期治理分层.md)。

如果 `315` 的长文解释的是：

`为什么 stronger-request old echo carrier 已经能被 destroy，仍不等于这类 carriers 的保留期时间法、validation veto、admission timing 与 coverage boundary 已经被正式治理，`

那么这一页只做一件事：

`把 repo 里现成的 stronger-request carrier retention law / validation veto / admission gate / visible coverage / uncovered gap，压成一张矩阵。`

## 2. 强请求清理不可逆擦除治理与强请求清理保留期治理分层矩阵

| carrier / plane | time law / owner | validation veto | admission gate | visible executor / coverage | coverage gap | governor question | 关键证据 |
| --- | --- | --- | --- | --- | --- | --- | --- |
| session transcript family | `cleanupPeriodDays` declaration | explicit key + validation errors => skip cleanup | background housekeeping delay / activity / one-shot gate | `.jsonl/.cast` cleanup + future-write suppression | “existing transcripts deleted at startup” 比 runtime truth 更强 | 谁决定 transcript old echo 本来保留多久，且何时准删 | `settings/types.ts:325-332`; `validationTips.ts:48-54`; `sessionStorage.ts:954-969`; `cleanup.ts:155-190,575-598`; `backgroundHousekeeping.ts:43-60,77-80` |
| debug log carrier | same `cleanupPeriodDays` -> `getCutoffDate()` | same cleanup skip path | same background admission | `cleanupOldDebugLogs()` 清 `.txt` 并保留 `latest` symlink | request-scoped destruction 不等于 time-law verdict | 谁决定 debug trace 本来活多久，而不是它现在能不能删 | `cleanup.ts:23-30,396-428,575-598` |
| messages / MCP logs carrier | same declaration | same cleanup skip path | same background admission | `cleanupOldMessageFiles()` 清 error/message/MCP log files | 局部结果未升格成 family receipt | 谁给 message-family retention 执法结果正式签收 | `cleanup.ts:93-131,575-598` |
| plan / file-history / session-env / image / paste / stale worktree carriers | same declaration extended by visible executor stack | same cleanup skip path | same background admission | background cleanup 明确顺序触达这些 families | visible stack 很宽，但“宽覆盖”不等于“统一签收” | 谁证明这些异质 carriers 已被同一 retention law 诚实执行 | `cleanup.ts:300-303,305-348,350-428,575-598` |
| diagnostics logfile carrier | env-selected logfile writer visible | no same-layer repo-local veto path visible | append happens when env path exists | `logForDiagnosticsNoPII()` 追加写入 | repo-local retention owner / cleanup dispatcher not visible | 谁决定 diagnostics old echo 本来该保留多久，且 policy 究竟活在哪 | `diagLogs.ts:27-60` |
| retention execution truth 本身 | `cleanupPeriodDays` + local `CleanupResult` vocabulary | explicit user intent can stop cleanup | scheduler decides whether current run is admitted | local cleanup functions can count messages/errors | family-wide surfaced receipt absent | 谁能正式宣布“这条时间法律已经在正确时机、正确覆盖面上兑现” | `cleanup.ts:33-40,575-598`; `backgroundHousekeeping.ts:43-60,77-80` |

## 3. 五个最快判断问题

判断一句

`这个 stronger-request old echo 已经被删掉，所以 retention governance 也已经回答了`

有没有越级，先问五句：

1. 这里回答的是具体 carrier 的 destruction event，还是 carrier family 的 retention horizon
2. 当前 delete path 是否还要经过 settings intent、validation veto 与 background scheduling admission
3. 当前说法是不是把 `future-write suppression` 偷写成了 `past-carrier cleanup`
4. 当前说法是不是把某个 covered carrier 的 retention path 偷写成了所有 stronger-request carriers 都已被同层治理
5. 当前是否真的存在 family-wide receipt，还是只有 local `CleanupResult`

## 4. 最常见的六类误读

| 误读 | 实际问题 |
| --- | --- |
| “能删 debug log 就等于已回答 retention law” | delete path != time law |
| “`cleanupPeriodDays=0` 就等于过去和未来都已被同一瞬间解决” | future suppression != past cleanup |
| “validation 有错时默认 30 天照样可以接管” | explicit user intent can veto cleanup |
| “只要进程启动，startup delete 就算完成” | housekeeping 仍要过 delay / activity / one-shot gate |
| “visible cleanup stack 很宽，所以 diagnostics 当然也在里面” | visible executor scope != full carrier coverage |
| “有 `CleanupResult` 就等于系统已出具 retention receipt” | local result != family-wide surfaced verdict |

## 5. 技术启示五条

1. 删除路径不等于时间法律。
2. 用户意图诚实性可以高于默认值与删除能力。
3. scheduler admission 是 retention governance 的一部分，不是枝节。
4. 覆盖范围本身就是治理对象，不能拿一个 covered carrier 代表全部 carrier。
5. receipt 不是统计细节，而是证明时间法律已兑现的签字面。

## 6. 一条硬结论

真正成熟的 stronger-request cleanup retention grammar 不是：

`carrier erased -> governance complete`

而是：

`retention declared -> intent validated -> future writes suppressed when required -> scheduler admitted -> covered carriers cleaned -> uncovered carriers honestly named -> receipt surfaced`

只有中间这些层被补上，
stronger-request cleanup irreversible-erasure governance 才不会继续停留在：

`它能说明某个 stronger-request carrier 已经被删掉，却没人正式说明这类 stronger-request carriers 本来该保留多久、什么时候允许删、哪些 carriers actually 被纳入这条 retention 栈、以及系统有没有把执行结果签成统一 receipt。`
