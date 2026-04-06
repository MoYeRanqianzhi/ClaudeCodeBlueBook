# 安全载体家族元数据与运行时符合性分层速查表：policy signal、runtime consumer、delay or skip window、missing proof与conformance risk

## 1. 这一页服务于什么

这一页服务于 [161-安全载体家族元数据与运行时符合性分层：为什么artifact-family cleanup metadata signer不能越级冒充artifact-family cleanup runtime-conformance signer](../161-%E5%AE%89%E5%85%A8%E8%BD%BD%E4%BD%93%E5%AE%B6%E6%97%8F%E5%85%83%E6%95%B0%E6%8D%AE%E4%B8%8E%E8%BF%90%E8%A1%8C%E6%97%B6%E7%AC%A6%E5%90%88%E6%80%A7%E5%88%86%E5%B1%82%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88artifact-family%20cleanup%20metadata%20signer%E4%B8%8D%E8%83%BD%E8%B6%8A%E7%BA%A7%E5%86%92%E5%85%85artifact-family%20cleanup%20runtime-conformance%20signer.md)。

如果 `161` 的长文解释的是：

`为什么 policy / metadata signal 已经存在，仍然不等于 runtime 已经诚实符合，`

那么这一页只做一件事：

`把各类 policy signal 被哪些 runtime consumer 消费、存在什么延迟或跳过窗口、缺哪种 conformance proof，以及哪里最容易继续分叉，压成一张矩阵。`

## 2. 元数据与运行时符合性分层矩阵

| family or policy | policy signal | runtime consumer | delay or skip window | missing proof | conformance risk | 关键证据 |
| --- | --- | --- | --- | --- | --- | --- |
| transcript persistence off (`cleanupPeriodDays=0`) | settings schema + validation tip both say “no transcripts are written and existing transcripts are deleted at startup” | `SessionStorage.shouldSkipPersistence()` + background cleanup | writes stop immediately, deletion waits for housekeeping; validation errors can skip cleanup entirely | proof that existing transcripts were actually deleted now | high | `settings/types.ts:323-334`; `validationTips.ts:46-53`; `sessionStorage.ts:954-969`; `backgroundHousekeeping.ts:24-58`; `cleanup.ts:575-584` |
| background cleanup scheduling | housekeeping should eventually enforce cleanup policy | `startBackgroundHousekeeping()` in REPL/headless | first submit gate in REPL; 10-minute delay; recent activity reschedules | receipt of when cleanup actually ran | high | `REPL.tsx:3903-3906`; `main.tsx:2813-2818`; `backgroundHousekeeping.ts:24-58` |
| plans custom directory | `plansDirectory` metadata + `getPlansDirectory()` path resolution | plan path helper + plan read rule | cleanup executor ignores override and still uses default home dir | proof that plan cleanup consumed current effective plan path | high | `settings/types.ts:824-830`; `plans.ts:79-110`; `permissions/filesystem.ts:245-254,1645-1652`; `cleanup.ts:300-303` |
| cleanup execution overall | each cleanup function returns `CleanupResult` | background cleanup dispatcher | results are awaited but not aggregated or surfaced | family-by-family conformance receipt | high | `cleanup.ts:33-44`; `cleanup.ts:575-595` |
| tool-results / transcripts | path helpers and cleanup traversal define persisted-output policy | project-root cleanup traversal | no surfaced proof that current run aligned path/read/cleanup truths | family-level runtime alignment proof | medium | `toolResultStorage.ts:27,94-118`; `sessionStorage.ts:198-225`; `cleanup.ts:155-257` |
| file-history / session-env | per-session retention policy implied by module path helpers and cleanup functions | dedicated cleanup executors | currently less visible drift, but no formal receipt | restore/replay family conformance proof | medium | `fileHistory.ts:728-741,951-957`; `sessionEnvironment.ts:15-30,60-134`; `cleanup.ts:305-387` |

## 3. 三个最重要的判断问题

判断一句“runtime 已经服从 policy”有没有越级，先问三句：

1. 这句 policy signal 说的是 declaration、suppression、scheduled execution，还是 completed execution
2. 当前 runtime 有没有因为 interactivity、validation 或 path propagation 改变这条 policy 的实际生效时点
3. 系统有没有正式保存 conformance receipt，而不是只留下 side effect 让后来者猜测

## 4. 最常见的五类误读

| 误读 | 实际问题 |
| --- | --- |
| “settings 文案写了 startup delete，所以现在已经删了” | metadata language != execution timestamp |
| “writes 被 suppress 了，所以旧文件肯定已经没了” | suppression != deletion receipt |
| “cleanup 函数跑了，所以 family 已符合” | function call != surfaced proof |
| “plansDirectory 被读取了，所以 cleanup 也会跟着变” | path resolver != executor conformance |
| “系统返回了 CleanupResult 类型，所以一定有人在记录” | return type != persisted receipt |

## 5. 一条硬结论

真正成熟的 conformance grammar 不是：

`policy signal -> assume runtime follows`

而是：

`policy signal -> runtime scheduler -> execution or skip reason -> conformance receipt`

只有最后一层被补上，  
artifact-family cleanup metadata 才不会继续停留在“看起来已经写清楚了”的纸面状态。
