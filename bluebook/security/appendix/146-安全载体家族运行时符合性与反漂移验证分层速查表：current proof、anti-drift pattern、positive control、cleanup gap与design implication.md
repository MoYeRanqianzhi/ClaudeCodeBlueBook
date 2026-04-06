# 安全载体家族运行时符合性与反漂移验证分层速查表：current proof、anti-drift pattern、positive control、cleanup gap与design implication

## 1. 这一页服务于什么

这一页服务于 [162-安全载体家族运行时符合性与反漂移验证分层：为什么artifact-family cleanup runtime-conformance signer不能越级冒充artifact-family cleanup anti-drift verifier signer](../162-%E5%AE%89%E5%85%A8%E8%BD%BD%E4%BD%93%E5%AE%B6%E6%97%8F%E8%BF%90%E8%A1%8C%E6%97%B6%E7%AC%A6%E5%90%88%E6%80%A7%E4%B8%8E%E5%8F%8D%E6%BC%82%E7%A7%BB%E9%AA%8C%E8%AF%81%E5%88%86%E5%B1%82.md)。

如果 `162` 的长文解释的是：

`为什么一次 runtime conform 仍然不等于系统已经具备长期 anti-drift verification，`

那么这一页只做一件事：

`把 cleanup 线当前已有的 proof、repo 里现成的 anti-drift 正例、cleanup 线还缺什么 verifier，以及由此得到的设计启示，压成一张矩阵。`

## 2. 运行时符合性与反漂移验证分层矩阵

| line | current proof | anti-drift pattern needed | positive control in repo | cleanup gap | design implication | 关键证据 |
| --- | --- | --- | --- | --- | --- | --- |
| `cleanupPeriodDays=0` write suppression | `shouldSkipPersistence()` immediately suppresses writes | source-truth execution split must be re-verified | `verifyAutoModeGateAccess()` re-checks stale vs live gate truth | no verifier that “startup delete” language still matches runtime timing | split declaration, suppression, execution, receipt | `sessionStorage.ts:954-969`; `permissionSetup.ts:1078-1150` |
| delayed housekeeping | scheduler eventually runs cleanup | live re-verification of actual run timing and skip reasons | `verifyAutoModeGateAccess()` does runtime fresh read | cleanup timing may drift silently under interactivity and delay rules | scheduler invariants need explicit verifier | `backgroundHousekeeping.ts:24-58`; `REPL.tsx:3903-3906`; `main.tsx:2813-2818`; `permissionSetup.ts:1078-1150` |
| plans override propagation | some planes consume `plansDirectory` | propagation verifier across storage / permission / cleanup planes | `switchSession()` prevents path/session drift by atomic update | cleanup executor still ignores effective plan dir | plan-family metadata needs anti-drift cross-plane check | `plans.ts:79-110`; `permissions/filesystem.ts:245-254,1645-1652`; `cleanup.ts:300-303`; `bootstrap/state.ts:456-466` |
| cleanup receipt | `CleanupResult` exists locally | explicit conformance receipt + anti-drift regression check | `microCompact.ts` explicitly says drift is caught by a test asserting equality with source-of-truth | results are not aggregated or surfaced | receipt alone is not enough; regression verifier must guard it | `cleanup.ts:33-44,575-595`; `microCompact.ts:31-36` |
| cleanup line overall | current analysis can reconstruct drift risks | dedicated cleanup anti-drift verifier plane | repo already has source-of-truth tests, atomic invariants, and live re-verifiers elsewhere | no cleanup-specific verifier of equal clarity is visible | cleanup governance should gain its own verifier vocabulary | `microCompact.ts:31-36`; `bootstrap/state.ts:456-466`; `permissionSetup.ts:1078-1150`; cleanup source cluster |

## 3. 三个最重要的判断问题

判断一句“cleanup 线已经长期可信”有没有越级，先问三句：

1. 当前 evidence 证明的是 this run，还是 future drift will be caught
2. repo 里有没有与 cleanup 同等级明确的 anti-drift pattern，而不是只在别的系统里存在
3. 如果某个 helper、schema 或 executor 明天改了，系统会在哪里首先失败并暴露

## 4. 最常见的五类误读

| 误读 | 实际问题 |
| --- | --- |
| “这次执行成功，所以长期也可信” | one run != anti-drift verification |
| “repo 里别处有 verifier，所以 cleanup 线等价地安全” | verifier culture elsewhere != cleanup verifier here |
| “有 `CleanupResult` 类型就说明漂移会被抓住” | local result type != regression guard |
| “plans 只是一个小漏口，不需要专门 verifier” | one visible propagation gap often means missing verifier grammar |
| “注释里提到了风险，所以系统一定已经防住了” | risk awareness != anti-drift mechanism |

## 5. 一条硬结论

真正成熟的 verifier grammar 不是：

`runtime conform once -> assume stable forever`

而是：

`runtime proof now -> explicit anti-drift pattern -> future mismatch fails loudly`

只有最后一层被补上，  
artifact-family cleanup runtime-conformance 才不会继续停留在“这次看起来没问题”的偶然正确状态。
