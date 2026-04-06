# 安全完成与终局分层速查表：surface、finality scope、what it still cannot sign、stronger future readback与future cleanup implication

## 1. 这一页服务于什么

这一页服务于 [149-安全完成与终局分层：为什么completion signer不能越级冒充finality signer](../149-%E5%AE%89%E5%85%A8%E5%AE%8C%E6%88%90%E4%B8%8E%E7%BB%88%E5%B1%80%E5%88%86%E5%B1%82%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88completion%20signer%E4%B8%8D%E8%83%BD%E8%B6%8A%E7%BA%A7%E5%86%92%E5%85%85finality%20signer.md)。

如果 `149` 的长文解释的是：

`为什么 completion 仍不等于 finality，`

那么这一页只做一件事：

`把不同 surface 到底签哪一层终局、仍缺哪条更强 readback、以及这对 future cleanup protocol 有什么直接含义，压成一张矩阵。`

## 2. 终局分层矩阵

| surface | finality scope | what it still cannot sign | stronger future readback | future cleanup implication | 关键证据 |
| --- | --- | --- | --- | --- | --- |
| `control_response` | request receipt finality | semantic completion / persistence / restorable truth | completion event or stronger reconciler | cleanup future design 需要 `cleanup_receipted` | `structuredIO.ts:362-429` |
| `session_state_changed(idle)` | authoritative turn-over finality | effect persistence / future-readable finality | `files_persisted` or later restorable proof | cleanup future design 需要把 `cleanup_completed` 与 `cleanup_persisted` 分开 | `print.ts:2456-2468`; `sdkEventQueue.ts:60-90`; `coreSchemas.ts:1739-1748` |
| `flushInternalEvents()` | transcript persistence gate | file effect persistence / remote finality | later file or restore readback | cleanup future design 不应把 internal-event flush 误当 full finality | `print.ts:2456-2468`; `ccrClient.ts:816-823` |
| `files_persisted` | effect persistence finality | future session guaranteed restorable truth | later `state_restored`-like readback | cleanup future design 需要 `cleanup_persisted` 单独词法 | `print.ts:2248-2270`; `coreSchemas.ts:1671-1689` |
| `ccrClient.flush()` | delivery confirmation only | server-state finality | explicit server readback | cleanup future design 绝不能把 transport drain 说成 cleanup final | `ccrClient.ts:826-838` |
| `state_restored` | future-readable restorable finality | universal semantic proof for every effect | even stronger cross-surface reconciliation if needed | cleanup future design 可进一步引出 `cleanup_restorable` | `ccrClient.ts:514-523` |

## 3. 最短判断公式

判断某条“已完成”或“已终局”说法有没有越级，先问三句：

1. 当前 surface 签的是 receipt、turn-over、persistence 还是 restorable truth
2. 它还缺哪条更强 readback
3. 它现在说的话有没有超过自己的 finality ceiling

## 4. 最常见的四类误读

| 误读 | 实际问题 |
| --- | --- |
| “收到 success 就是终局” | 这只签 receipt |
| “idle 就是全部完成” | turn-over 不等于 effect persistence |
| “flush 成功就说明远端状态已落定” | delivery confirmation 不等于 server truth |
| “files_persisted 就保证下次一定能恢复” | persisted 不等于 restorable |

## 5. 一条硬结论

真正成熟的 finality grammar 不是：

`一个 completed。`

而是：

`receipt、completion、persisted、restorable 各由不同 signer 只说到自己的上限。`
