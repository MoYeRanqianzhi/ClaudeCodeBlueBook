# 安全遗忘与免责释放分层速查表：surface、what forgetting can clear、what liability still remains、required stronger release gate与future cleanup implication

## 1. 这一页服务于什么

这一页服务于 [151-安全遗忘与免责释放分层：为什么forgetting signer不能越级冒充liability-release signer](../151-%E5%AE%89%E5%85%A8%E9%81%97%E5%BF%98%E4%B8%8E%E5%85%8D%E8%B4%A3%E9%87%8A%E6%94%BE%E5%88%86%E5%B1%82%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88forgetting%20signer%E4%B8%8D%E8%83%BD%E8%B6%8A%E7%BA%A7%E5%86%92%E5%85%85liability-release%20signer.md)。

如果 `151` 的长文解释的是：

`为什么 even after forgetting 仍不等于 liability release，`

那么这一页只做一件事：

`把不同 surface 到底最多能 forget 什么、哪些责任仍然保留、以及真正 release 还缺什么 gate，压成一张矩阵。`

## 2. 遗忘与免责释放分层矩阵

| surface | what forgetting can clear | what liability still remains | required stronger release gate | future cleanup implication | 关键证据 |
| --- | --- | --- | --- | --- | --- |
| crash-recovery pointer schema / TTL | stale / invalid pointer | fresh pointer 仍代表同一 resume 线程 | pointer stale or invalid 之外，还要有 stronger session-death truth | cleanup future design 需要把 `forget-allowed` 与 `resume-retained` 分开 | `bridgePointer.ts:22-34,76-113` |
| worktree-aware pointer fanout | current-dir miss 不等于责任消失 | sibling worktree freshest pointer 仍配接管 continuity | all sibling continuity artifacts retired | cleanup future design 需要 `cleanup_continuity_scope` | `bridgePointer.ts:115-180`; `bridgeMain.ts:2162-2174` |
| single-session bridge shutdown | 可以 clean exit 某些 local surface | session + environment 仍保留给 `--continue` | explicit archive+deregister or stronger death truth | cleanup future design 需要 `cleanup_liability_open` | `bridgeMain.ts:1516-1535` |
| deterministic dead resume path | stale pointer 可清 | 只有 session gone / env missing 才真正结束该条 resume claim | server-side dead truth | cleanup future design 需要 `cleanup_release_granted` 依赖 stronger readback | `bridgeMain.ts:2384-2407` |
| transient reconnect failure | 局部错误提示可替换 | retry possibility 必须继续保留 | fatal reconnect failure 才能进一步 clear pointer | cleanup future design 需要 `cleanup_retry_asset_retained` | `bridgeMain.ts:2524-2540` |
| resumed session identity | startup fresh-session facade 可被覆盖 | same session ID、same cost state、same worktree lineage 仍被复用 | explicit fork or stronger lineage split | cleanup future design 需要 `cleanup_same-lineage` | `sessionRestore.ts:403-487` |
| interrupted turn recovery | broken surface / invalid tail messages 可整理 | unfinished obligation 被补成 continuation message | no interrupted-turn debt | cleanup future design 需要 `cleanup_interrupted_debt_closed` | `conversationRecovery.ts:204-245` |
| `--fork-session` path | 可切换到新 session ID | old lineage 不是自动免责，只是显式分叉 | explicit ownership transfer / release contract | cleanup future design 需要 distinguish `fork` from `release` | `sessionRestore.ts:435-463` |

## 3. 最短判断公式

判断某句“现在已经可以免责释放”的说法有没有越级，先问四句：

1. 当前清掉的是 trace、projection，还是 continuity artifact
2. 同一 session / retry / reopen 线程是否仍可被 resume
3. 当前是否只是 local forgetting，还是已经拿到 stronger server-side death truth
4. 是否存在比 forgetting owner 更强的 release owner 在正式签字

## 4. 最常见的五类误读

| 误读 | 实际问题 |
| --- | --- |
| “pointer 不见了，所以旧责任也没了” | pointer disappearance 不等于 full liability release |
| “退出 bridge 了，所以 session 已彻底结束” | single-session non-fatal exit 明确保留 resume right |
| “这次 reconnect 失败了，就算完全结束” | transient failure 反而必须保留 retry path |
| “resume 只是重新开一个界面” | 默认是 same-session continuity，不是 new lineage |
| “中断后没继续，就是责任自然蒸发” | interrupted turn 会被补成 continuation debt |

## 5. 一条硬结论

真正成熟的 release grammar 不是：

`forget -> release`

而是：

`forget、resume-retained、liability-open、release-granted`

分别由不同 gate、不同 stronger truth、不同 authority 签字。
