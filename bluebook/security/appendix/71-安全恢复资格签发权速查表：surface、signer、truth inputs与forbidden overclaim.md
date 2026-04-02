# 安全恢复资格签发权速查表：surface、signer、truth inputs与forbidden overclaim

## 1. 这一页服务于什么

这一页服务于 [87-安全恢复资格签发权：为什么不是任何局部signal都配说仍可恢复，而必须由掌握边界真相的控制层签字](../87-%E5%AE%89%E5%85%A8%E6%81%A2%E5%A4%8D%E8%B5%84%E6%A0%BC%E7%AD%BE%E5%8F%91%E6%9D%83%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%E4%B8%8D%E6%98%AF%E4%BB%BB%E4%BD%95%E5%B1%80%E9%83%A8signal%E9%83%BD%E9%85%8D%E8%AF%B4%E4%BB%8D%E5%8F%AF%E6%81%A2%E5%A4%8D%EF%BC%8C%E8%80%8C%E5%BF%85%E9%A1%BB%E7%94%B1%E6%8E%8C%E6%8F%A1%E8%BE%B9%E7%95%8C%E7%9C%9F%E7%9B%B8%E7%9A%84%E6%8E%A7%E5%88%B6%E5%B1%82%E7%AD%BE%E5%AD%97.md)。

如果 `87` 的长文解释的是：

`为什么 resume promise 必须有 signer，`

那么这一页只做一件事：

`把不同恢复表面到底由谁签字、依赖哪些 truth inputs、最多配说到哪一步，以及哪些 overclaim 绝不能说压成一张签发矩阵。`

## 2. 恢复资格签发矩阵

| surface | signer | truth inputs | max allowed claim | forced handoff | forbidden overclaim | 关键证据 |
| --- | --- | --- | --- | --- | --- | --- |
| shutdown printed resume command | bridgeMain shutdown control flow | `spawnMode`、`initialSessionId`、`fatalExit`、是否跳过 archive+deregister | “仍可通过 `--continue` 恢复” | 若将 archive/deregister 或 fatal exit，则不得打印 | 在即将销毁边界时继续承诺 resume | `bridgeMain.ts:1515-1538` |
| `--continue` pointer discovery | worktree-aware pointer resolver | current dir、worktree siblings、pointer freshness、pointer source dir | “找到一个值得继续核验的恢复候选” | 必须 handoff 给 session fetch / env validation | 单凭某个本地 pointer 就宣布最终可恢复 | `bridgeMain.ts:2141-2174`、`bridgePointer.ts:115-184` |
| pointer validity check | pointer schema/TTL gate | schema valid、mtime 未 stale | “这个 carrier 仍可作为候选” | 必须 handoff 给 higher-level resume verifier | 把 carrier 有效说成边界一定可恢复 | `bridgePointer.ts:76-113` |
| session existence / env binding verification | bridgeMain resume verifier | `getBridgeSession(...)`、`environment_id` | “该对象具备进入 resume flow 的基本资格” | 失败时 clear pointer 并撤回 promise | 对不存在 session 继续维持恢复资格 | `bridgeMain.ts:2380-2415` |
| transient reconnect retry hint | failure semantics owner in bridgeMain | reconnect error type、pointer 是否保留、environment 是否仍可重试 | “may still be resumable / try again” | 若判定 fatal，则必须撤回 | 没有真实 retry path 还继续鼓励重试 | `bridgeMain.ts:2524-2540` |
| pointer publication | standalone single-session path / REPL perpetual path | mode compatibility、session presence、lifecycle type | “这里存在一个可被后续恢复追索的边界 carrier” | multi-session 或 retire path 必须禁止或清除 | 在语义不兼容模式下继续发布 resumability carrier | `bridgeMain.ts:2700-2728`、`replBridge.ts:479-488,1595-1615` |
| pointer revocation | clean exit / fatal invalidation owner | archive、deregister、fatality、stale/invalid status | “恢复资格已撤回” | clear pointer 并停止所有 resumability promise | 退役后仍让旧 carrier 留在前台 | `replBridge.ts:1618-1663`、`bridgePointer.ts:76-113` |

## 3. 最短判断公式

看到一句“还能恢复”时，先问五句：

1. 谁是这句话的 signer
2. 它掌握了哪些 truth inputs
3. 它最多配说到 candidate、verified 还是 retryable
4. 它是否本应 handoff 给更高层 verifier
5. 如果它越权说满了，会把哪个死边界继续包装成活边界

## 4. 最常见的五类越权签发

| 越权签发 | 会造成什么问题 |
| --- | --- |
| pointer 文件自己冒充最终 signer | 本地 carrier 被误当成最终真相 |
| retry hint 不区分 transient / fatal | 失败语义被压扁，用户被误导继续追索死边界 |
| shutdown 文案层不看 archive/deregister 结果 | printed resume command 变成 lie |
| 模式不兼容却继续发布 pointer | 恢复资格与运行语义冲突 |
| 退役层不及时 clear pointer | 撤回权缺失，旧 promise 继续残留 |

## 5. 一条硬结论

对 Claude Code 这类安全控制面来说，  
真正成熟的不是：

`哪个地方都能提示你试试恢复，`

而是：

`只有真正掌握边界真相的那一层，才配签发或撤回“仍可恢复”这项资格。`
