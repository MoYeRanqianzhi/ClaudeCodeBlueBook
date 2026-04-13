# 安全载体家族强请求清理制度元数据治理与强请求清理运行时符合性治理分层速查表：metadata signal、runtime truth、gap type、receipt surface与governor question

## 1. 这一页服务于什么

这一页服务于 [448-安全载体家族强请求清理制度元数据治理与强请求清理运行时符合性治理分层](../448-安全载体家族强请求清理制度元数据治理与强请求清理运行时符合性治理分层.md)。

如果 `448` 的长文解释的是：

`为什么 stronger-request cleanup metadata 已经存在，仍不等于运行时已经按这份 metadata 发生、覆盖并留下可证明结果，`

那么这一页只做一件事：

`把 metadata signal、runtime truth、gap type 与 receipt surface 压成一张矩阵。`

## 2. 强请求清理制度元数据治理与强请求清理运行时符合性治理分层矩阵

| metadata signal | runtime truth | gap type | receipt surface | governor question | 关键证据 |
| --- | --- | --- | --- | --- | --- |
| `cleanupPeriodDays=0` means no writes + existing transcripts deleted at startup | `shouldSkipPersistence()` first suppresses transcript writes | declaration vs effect split | no unified transcript-deletion receipt | 谁来签署 startup-delete wording 现在是否真的已经被 fulfilled | `settings/types.ts:325-332`; `validationTips.ts:47-54`; `sessionStorage.ts:953-969` |
| startup delete is part of retention language | REPL only starts housekeeping after first submit | interactive admission gap | no immediate interactive startup receipt | 谁来签署 cleanup 何时真正进入 interactive runtime | `REPL.tsx:3903-3906` |
| headless startup should also reconcile cleanup metadata | headless mode deferred-imports housekeeping and explicitly says scripted calls don't need bookkeeping | mode-sensitive admission gap | no immediate headless receipt | 谁来签署 headless mode 何时真正开始 cleanup 而不只是 schedule 它 | `main.tsx:2811-2818` |
| housekeeping should reconcile cleanup eventually | execution is delayed 10 minutes and may be rescheduled by recent activity | temporal gap | no surfaced family-by-family conformance result | 谁来签署 eventual execution 而不只是 eventual intent | `backgroundHousekeeping.ts:28-80` |
| explicit retention metadata should guide cleanup execution | validation errors with explicit `cleanupPeriodDays` cause intentional skip | abstention gap with higher-order fail-safe | only debug log message, no structured surfaced receipt | 谁来签署 `not executed because safer not to execute` 也是 runtime truth | `cleanup.ts:575-584` |
| `plansDirectory` is formal metadata | settings/storage/permission/resume planes consume it, cleanup executor still targets default root | propagation gap | no plan-family conformance receipt | 谁来签署 plan metadata 已在所有 execution planes 被 honored | `plans.ts:79-110,164-255`; `permissions/filesystem.ts:244-255,1487-1495,1644-1652`; `cleanup.ts:300-303` |
| cleanup functions return `CleanupResult` | background entry discards most results; only stale worktrees get telemetry | receipt gap | local countability exists, stronger-request family receipt absent | 谁来把 local counts 升级成 official cleanup conformance receipt | `cleanup.ts:33-45,575-598` |
| diagnostics have explicit host-visible metadata contract | diagnostics carrier never enters visible cleanup dispatcher coverage | coverage gap | no diagnostics cleanup receipt | 谁来签署 carriers still outside visible cleanup world 的 conformance | `diagLogs.ts:14-20,27-60`; `cleanup.ts:575-598` |

## 3. 五个最快判断问题

判断一句

`这些 stronger-request cleanup metadata 已经存在，所以 runtime 已经符合`

有没有越级，先问五句：

1. 这里说的是 declared truth，还是 actual runtime event
2. 当前 gap 是时间差、传播差、abstention 差，还是 receipt / coverage 缺口
3. 当前 family outcome 是被正式 surfaced，还是只在 local helper return value / debug log 里短暂停留
4. 当前是不是把 suppression 偷写成 deletion
5. 当前是不是把某些平面的 metadata consumption 偷写成所有平面的 runtime conformance

## 4. 最常见的六类误读

| 误读 | 实际问题 |
| --- | --- |
| `文案写 startup delete，所以启动时已经删了` | startup language != immediate runtime receipt |
| `停写已经生效，所以删除也一定生效了` | suppression != deletion |
| `metadata 在一些平面被消费了，所以 executor 一定也跟上` | partial consumption != full conformance |
| `这次 skip 说明实现不稳定` | intentional skip may express a higher-order fail-safe |
| `CleanupResult` 存在，所以 conformance surface 也存在 | local countability != surfaced conformance receipt |
| `系统已经记住规则，所以执行自然会忠于规则` | self-memory != runtime proof |

## 5. 一条硬结论

真正成熟的 stronger-request cleanup runtime-conformance grammar 不是：

`metadata exists -> therefore runtime already conforms`

而是：

`metadata declared -> scheduler admitted -> executor actually consumed it -> skips explained -> coverage stated -> results surfaced as receipt`

只有这些层被补上，
stronger-request cleanup metadata 才不会继续停留在：

`制度已经把规则记住了，却没人正式证明这些规则当前已经被运行时诚实执行、覆盖并签收。`
