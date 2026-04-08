# 安全载体家族强请求清理制度元数据治理与强请求清理运行时符合性治理分层速查表：metadata signal、runtime truth、gap type、receipt surface与governor question

## 1. 这一页服务于什么

这一页服务于 [352-安全载体家族强请求清理制度元数据治理与强请求清理运行时符合性治理分层](../352-安全载体家族强请求清理制度元数据治理与强请求清理运行时符合性治理分层.md)。

如果 `352` 的长文解释的是：

`为什么 stronger-request cleanup metadata 已经存在，仍不等于运行时已经按这份 metadata 发生并留下可证明结果，`

那么这一页只做一件事：

`把 metadata truth、runtime truth、gap type 与 receipt surface 压成一张矩阵。`

## 2. 强请求清理制度元数据治理与强请求清理运行时符合性治理分层矩阵

| metadata signal | runtime truth | gap type | receipt surface | governor question | 关键证据 |
| --- | --- | --- | --- | --- | --- |
| `cleanupPeriodDays=0` means no writes + existing transcripts deleted at startup | `shouldSkipPersistence()` first suppresses writes; delete path is separate | temporal split between suppression and deletion | no unified transcript deletion receipt | who signs that startup-delete wording has actually been fulfilled in this runtime | `settings/types.ts:325-333`; `settings/validationTips.ts:46-53`; `sessionStorage.ts:954-969` |
| startup cleanup is declared as part of retention semantics | REPL starts housekeeping only after first submit | interactive admission gap | no immediate startup receipt | who signs when cleanup really entered interactive runtime rather than merely being declared | `REPL.tsx:3903-3906` |
| headless startup should also reconcile cleanup metadata | headless world starts housekeeping by deferred import, not immediate delete | deferred admission gap | no immediate headless receipt | who signs that headless runtime has actually begun cleanup work | `main.tsx:2811-2818` |
| background housekeeping should reconcile cleanup eventually | execution is delayed 10 minutes and can be rescheduled by recent interaction | temporal gap | no surfaced family-by-family conformance result | who signs that eventual cleanup really happened rather than being repeatedly deferred | `backgroundHousekeeping.ts:28-80` |
| explicit retention metadata should guide cleanup execution | validation errors with explicit `cleanupPeriodDays` cause intentional skip | skip gap driven by higher-order fail-safe | only debug log message, no structured surfaced receipt | who signs `not executed because safer not to execute` as runtime truth | `cleanup.ts:575-584` |
| `plansDirectory` is a formal metadata knob | storage/permission/resume planes consume it, cleanup executor still targets default `~/.claude/plans` | propagation gap | no plan-family conformance receipt | who signs that plan metadata is actually honored across all runtime planes | `settings/types.ts:824-830`; `plans.ts:79-106,164-233`; `permissions/filesystem.ts:244-255,1487-1495,1644-1652`; `cleanup.ts:300-303` |
| cleanup functions return `CleanupResult` | background entry discards almost all results; only stale worktrees get telemetry | receipt gap | local return values exist, stronger-request family receipt absent | who turns local cleanup counts into a stronger-request conformance receipt | `cleanup.ts:33-44,575-598` |
| diagnostics are retained via host-visible env contract | diagnostics carrier never enters visible cleanup dispatcher coverage | coverage gap | no diagnostics cleanup receipt | who signs conformance for carriers still outside visible cleanup world | `diagLogs.ts:11-20,27-60`; `cleanup.ts:575-598` |

## 3. 五个最快判断问题

判断一句

`这些 stronger-request cleanup metadata 已经存在，所以 runtime 已经符合`

有没有越级，先问五句：

1. 这里说的是 declared truth，还是 actual runtime event
2. 当前 gap 是时间差、传播差、intentional skip，还是 receipt / coverage 缺口
3. 当前 family outcome 是被正式 surfaced 了，还是只在 local helper return value / debug log 里短暂停留
4. 当前是不是把 suppression 偷写成 deletion
5. 当前是不是把某些平面的 metadata consumption 偷写成所有平面的 runtime conformance

## 4. 最常见的六类误读

| 误读 | 实际问题 |
| --- | --- |
| `文案写 startup delete，所以启动时已经删了` | startup language != immediate runtime receipt |
| `停写已经生效，所以删除也一定生效了` | suppression != deletion |
| `metadata 在一些平面被消费了，所以 executor 一定也跟上` | partial consumption != full conformance |
| `这次 skip 说明实现不稳定` | intentional skip may express a higher-order fail-safe |
| ``CleanupResult`` 存在，所以 conformance surface 也存在` | local countability != surfaced conformance receipt |
| `系统已经记住规则，所以执行自然会忠于规则` | self-description != runtime proof |

## 5. 技术启示六条

1. 声明 truth 不等于运行时 truth。
2. suppression、deletion、delay 与 receipt 是四个不同问题。
3. propagation gap 是 runtime-conformance 的硬证据。
4. local outcome vocabulary 的存在说明系统知道自己需要 receipt，只是还没升格成 family-wide plane。
5. uncovered diagnostics carrier 证明 conformance 不只看执行，还看 coverage。
6. validation-driven intentional skip 说明更成熟的系统会把避免误删放在机械执行文案之上。

## 6. 一条硬结论

真正成熟的 stronger-request cleanup-runtime-conformance grammar 不是：

`metadata exists -> therefore runtime already conforms`

而是：

`metadata declared -> scheduler admitted -> executor actually consumed it -> skips explained -> coverage stated -> results surfaced as receipt`

只有这些层被补上，
stronger-request cleanup metadata 才不会继续停留在：

`系统已经把规则写出来了，却没人正式证明这些规则当前已经被运行时诚实执行、覆盖并签收。`
