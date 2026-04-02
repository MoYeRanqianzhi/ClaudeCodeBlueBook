# 安全恢复资产保全义务速查表：asset、preservation owner、expiry basis与forbidden early loss

## 1. 这一页服务于什么

这一页服务于 [91-安全恢复资产保全义务：为什么pointer、retry-path与resumable-shutdown在资格未撤回前必须被制度性保留](../91-%E5%AE%89%E5%85%A8%E6%81%A2%E5%A4%8D%E8%B5%84%E4%BA%A7%E4%BF%9D%E5%85%A8%E4%B9%89%E5%8A%A1%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88pointer%E3%80%81retry-path%E4%B8%8Eresumable-shutdown%E5%9C%A8%E8%B5%84%E6%A0%BC%E6%9C%AA%E6%92%A4%E5%9B%9E%E5%89%8D%E5%BF%85%E9%A1%BB%E8%A2%AB%E5%88%B6%E5%BA%A6%E6%80%A7%E4%BF%9D%E7%95%99.md)。

如果 `91` 的长文解释的是：

`为什么恢复资产在资格未撤回前应被保全，`

那么这一页只做一件事：

`把不同恢复资产到底由谁保全、什么时候过期、哪些过早丢失绝不能发生压成一张保全矩阵。`

## 2. 恢复资产保全义务矩阵

| asset | preservation owner | why preserve | expiry basis | forbidden early loss | 关键证据 |
| --- | --- | --- | --- | --- | --- |
| resumable shutdown 保留的 session/environment | bridgeMain shutdown control flow | 这是 printed resume command 仍为真的物质前提 | fatal exit 或正式 archive+deregister | 打印了 `--continue` 却立刻销毁边界 | `bridgeMain.ts:1515-1538` |
| transient reconnect pointer | failure semantics owner | 它本身就是 retry mechanism | 失败被证明为 fatal | 因一次暂时失败就撤销 retry 机会 | `bridgeMain.ts:2524-2534` |
| REPL perpetual pointer | REPL perpetual teardown owner | suspend 后仍需可恢复 | lifecycle 从 suspend 进入 retire | 把 suspend 会话误清成退役会话 | `replBridge.ts:1595-1615` |
| freshly written crash-recovery pointer | bridge init / REPL init path | kill -9 后仍需 recoverable trail | stale proof、退役 proof 或模式不再兼容 | 还未验证失效就先撤销事故恢复路径 | `replBridge.ts:479-488` |
| pointer freshness | pointer refresh writer | 长时会话仍需保持 recoverability | TTL 过期 | 会话还活着却因不刷新而被误判 stale | `replBridge.ts:1605-1611` |
| pointer carrier 本身 | pointer reader | 默认保留直到证明确实失效 | schema invalid / TTL stale | 未证失效就因为“看起来旧”而清除 | `bridgePointer.ts:76-113` |
| fresh start 前 leftover pointer | bridgeMain startup control flow | 仅在当前主路径仍承认其相关时才配保留 | 本次明确不走 resume flow | stale env linger past relevance | `bridgeMain.ts:2316-2326` |

## 3. 最短判断公式

看到一个恢复资产时，先问五句：

1. 它托底的是哪一项恢复资格
2. 当前谁是 preservation owner
3. 这项资产什么时候才算真正过期
4. 当前是否已有足够真相支持撤回
5. 如果现在丢失它，系统会不会把仍真实存在的恢复机会变成空头 promise

## 4. 最常见的五类过早丢失

| 过早丢失 | 会造成什么问题 |
| --- | --- |
| resumable shutdown 后仍 archive+deregister | promise 失去物质前提 |
| transient reconnect 时清 pointer | retry path 被提前拆掉 |
| perpetual suspend 时不刷新 pointer | 活边界被时间性误杀 |
| 未证 stale 就清 carrier | recoverable trail 被错误撤回 |
| 当前主路径不再相关却继续保留旧 pointer | stale asset 继续制造错误承诺 |

## 5. 一条硬结论

对 Claude Code 这类安全控制面来说，  
真正成熟的不是：

`什么时候把旧资产清干净，`

而是：

`什么时候必须主动保全那些仍在托底真实恢复资格的资产。`
