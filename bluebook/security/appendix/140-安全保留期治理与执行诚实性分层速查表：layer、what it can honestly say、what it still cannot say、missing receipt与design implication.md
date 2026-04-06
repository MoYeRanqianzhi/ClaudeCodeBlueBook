# 安全保留期治理与执行诚实性分层速查表：layer、what it can honestly say、what it still cannot say、missing receipt与design implication

## 1. 这一页服务于什么

这一页服务于 [156-安全保留期治理与执行诚实性分层：为什么retention-governor signer不能越级冒充retention-enforcement-honesty signer](../156-%E5%AE%89%E5%85%A8%E4%BF%9D%E7%95%99%E6%9C%9F%E6%B2%BB%E7%90%86%E4%B8%8E%E6%89%A7%E8%A1%8C%E8%AF%9A%E5%AE%9E%E6%80%A7%E5%88%86%E5%B1%82%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88retention-governor%20signer%E4%B8%8D%E8%83%BD%E8%B6%8A%E7%BA%A7%E5%86%92%E5%85%85retention-enforcement-honesty%20signer.md)。

如果 `156` 的长文解释的是：

`为什么 retention governance 仍不等于 runtime enforcement honesty，`

那么这一页只做一件事：

`把 declaration、scheduler、executor 与 honesty receipt 各自最多能诚实说到哪里，压成一张矩阵。`

## 2. 保留期治理与执行诚实性分层矩阵

| layer | what it can honestly say | what it still cannot say | missing receipt | design implication | 关键证据 |
| --- | --- | --- | --- | --- | --- |
| settings schema / validation tip | “policy is defined as X” | “current runtime has already executed X” | declaration vs enforcement separation | 需要双层 truth surface | `settings/types.ts:325-332`; `validationTips.ts:48-54` |
| `shouldSkipPersistence()` | “future transcript writes are suppressed now” | “past transcripts have already been deleted” | suppression != cleanup receipt | 需要 future-write 与 past-cleanup 分栏 | `sessionStorage.ts:953-969` |
| housekeeping start gates | “cleanup path may run under these mode/lifecycle conditions” | “cleanup has completed in this session” | schedule-state receipt | 需要 scheduled/deferred status | `main.tsx:2811-2818`; `REPL.tsx:3903-3906`; `backgroundHousekeeping.ts:25-29,43-60` |
| cleanup executor | “these files are eligible for unlink/rm under cutoff” | “users have been honestly told execution happened/skipped/deferred” | aggregated cleanup execution receipt | 需要 executor result aggregation | `cleanup.ts:33-45,155-257,305-347,575-595` |
| current telemetry asymmetry | “npm cache/worktree cleanup may emit events” | “session/transcript/file-history cleanup has equivalent structured truth surface” | cleanup event parity | 需要 transcript/file-history cleanup events | `cleanup.ts:521-530,595-597` |
| post-hoc diagnostic string | “a cleanup side effect likely happened” | “system has a formal honesty signer for cleanup execution” | pre/post side-effect ledger | 需要 side-effected status and attribution | `TaskOutput.ts:313-325` |

## 3. 最短判断公式

判断某句“保留期策略现在已经被执行”的说法有没有越级，先问五句：

1. 当前说的是 declaration、suppression、scheduling、execution 还是 receipt
2. 当前层能证明的是未来不再写，还是过去已经删
3. 当前 cleanup 结果有没有被聚合成结构化结论
4. 当前 session mode 是否只处于 scheduled/deferred，而非 executed
5. 系统是不是只靠事后 diagnostic string 来补偿说明

## 4. 最常见的五类误读

| 误读 | 实际问题 |
| --- | --- |
| “schema 说 startup delete，所以现在一定已经删了” | declaration 不等于 execution receipt |
| “已经禁止未来写 transcript，所以旧 transcript 也一定没了” | suppression 不等于 cleanup completion |
| “backgroundHousekeeping 启动了，所以 cleanup 已完成” | scheduled 不等于 executed |
| “cleanup.ts 会 unlink/rm，所以系统一定会告诉用户删了什么” | executor 不等于 honesty surface |
| “出现了 startup cleanup 的副作用字符串，所以系统已经有正式回执” | post-hoc diagnostic 不等于 structured receipt |

## 5. 一条硬结论

真正成熟的 retention honesty grammar 不是：

`policy_defined -> execution_honest`

而是：

`policy_declared、writes_suppressed、cleanup_scheduled、cleanup_executed、side_effects_explained`

分别由不同 layer 与不同 receipt surface 署名。
