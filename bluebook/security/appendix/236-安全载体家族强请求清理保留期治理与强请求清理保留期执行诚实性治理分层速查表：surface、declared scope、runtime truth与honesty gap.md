# 安全载体家族强请求清理保留期治理与强请求清理保留期执行诚实性治理分层速查表：surface、declared scope、runtime truth与honesty gap

## 1. 这一页服务于什么

这一页服务于 [252-安全载体家族强请求清理保留期治理与强请求清理保留期执行诚实性治理分层：为什么artifact-family cleanup stronger-request retention-governor signer不能越级冒充artifact-family cleanup stronger-request retention-enforcement-honesty-governor signer](../252-安全载体家族强请求清理保留期治理与强请求清理保留期执行诚实性治理分层.md)。

如果 `252` 的长文解释的是：

`为什么 stronger-request retention policy 已经被定义，仍不等于系统已经诚实说明了这条 policy 当前在 scope、timing、coverage 与 execution status 上到底怎样执行，`

那么这一页只做一件事：

`把 repo 里现成的 declaration scope / visible runtime truth / honesty gap，压成一张矩阵。`

## 2. 强请求清理保留期治理与强请求清理保留期执行诚实性治理分层矩阵

| surface | declared scope | visible runtime truth | honesty gap | governor question | 关键证据 |
| --- | --- | --- | --- | --- | --- |
| settings schema / tips / config docs | `cleanupPeriodDays` is about keeping transcripts; `0` says old transcripts are deleted at startup | visible executor reaches wider artifact families than transcripts alone | declaration scope is narrower than visible execution coverage | who honestly states which stronger-request carriers are actually covered by the current retention stack | `settings/types.ts:325-332`; `validationTips.ts:48-54`; `skills/bundled/updateConfig.ts:96-99`; `cleanup.ts:155-257,300-347,350-428,575-595` |
| `cleanupPeriodDays = 0` timing | wording says startup delete | REPL waits for first submit, then housekeeping waits 10 minutes and can defer on recent activity | declaration timing is stronger than visible runtime admission | who honestly states whether current stronger-request cleanup is immediate, deferred, or not yet admitted | `sessionStorage.ts:954-969`; `main.tsx:2811-2818`; `REPL.tsx:3903-3906`; `backgroundHousekeeping.ts:43-60,77-80` |
| future transcript writes | persistence is `disabled entirely` | `shouldSkipPersistence()` immediately suppresses future writes | future suppression is only half of `disabled entirely` | who distinguishes future-write suppression from past-carrier cleanup in stronger-request language | `sessionStorage.ts:954-969`; `settings/types.ts:331-332` |
| generic cleanup execution | cleanup functions run in background | background wrapper drops aggregated `CleanupResult` and emits no unified receipt for core transcript/debug/file-history cleanup | runtime may execute cleanup without producing a unified stronger-request execution truth surface | who signs what has actually been cleaned, skipped, or deferred in this runtime | `cleanup.ts:33-45,575-595` |
| diagnostics carrier | env-selected diagnostics logfile writer is visible | repo-local retention honesty path is not visible at the same layer | coverage remains partially opaque even after retention governance exists | who honestly states the retention/execution status of diagnostics carriers carrying stronger-request old echo traces | `diagLogs.ts:27-60` |

## 3. 三个最重要的判断问题

判断一句

`系统当前已经诚实执行了 stronger-request retention policy`

有没有越级，先问三句：

1. 这里说的是 declaration truth，还是 current runtime truth
2. 当前说法有没有把 `transcripts` 的用户文案偷写成 executor 的完整 artifact coverage
3. 当前说法有没有把 future-write suppression、deferred cleanup 与 opaque diagnostics coverage 压成同一个完成态

## 4. 最常见的五类误读

| 误读 | 实际问题 |
| --- | --- |
| `文案只说 transcripts，所以 cleanup 只影响 transcripts` | visible executor scope is wider |
| `文案说 startup delete，所以当前进程已立刻删完` | runtime admission is delayed and mode-gated |
| `不再写新 transcript 了，所以旧 carrier 也已经清空` | future suppression != past cleanup |
| `cleanup 可能真的跑了，所以用户已经被诚实通知` | execution can exist without unified receipt |
| `diagnostics 既然只是 env file，就不影响 honesty` | uncovered carrier status is itself an honesty gap |

## 5. 一条硬结论

真正成熟的 stronger-request cleanup retention-enforcement honesty grammar 不是：

`retention policy declared -> therefore current execution is honest`

而是：

`scope declared honestly -> timing declared honestly -> future suppression and past cleanup distinguished -> covered carriers named -> uncovered carriers admitted -> execution status surfaced`

只有中间这些层被补上，
stronger-request cleanup retention governance 才不会继续停留在：

`它能定义 stronger-request old echo carriers 的时间法律，却没人正式说明这条法律当前到底覆盖了什么、何时真的执行、何时只是 future suppression、何时仍只是部分显化。`
