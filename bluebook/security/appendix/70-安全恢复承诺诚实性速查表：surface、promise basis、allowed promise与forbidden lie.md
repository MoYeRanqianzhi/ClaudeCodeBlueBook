# 安全恢复承诺诚实性速查表：surface、promise basis、allowed promise与forbidden lie

## 1. 这一页服务于什么

这一页服务于 [86-安全恢复承诺诚实性：为什么`--continue`、pointer与resume提示不是帮助文案，而是对边界可恢复性的安全承诺](../86-%E5%AE%89%E5%85%A8%E6%81%A2%E5%A4%8D%E6%89%BF%E8%AF%BA%E8%AF%9A%E5%AE%9E%E6%80%A7%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88--continue%E3%80%81pointer%E4%B8%8Eresume%E6%8F%90%E7%A4%BA%E4%B8%8D%E6%98%AF%E5%B8%AE%E5%8A%A9%E6%96%87%E6%A1%88%EF%BC%8C%E8%80%8C%E6%98%AF%E5%AF%B9%E8%BE%B9%E7%95%8C%E5%8F%AF%E6%81%A2%E5%A4%8D%E6%80%A7%E7%9A%84%E5%AE%89%E5%85%A8%E6%89%BF%E8%AF%BA.md)。

如果 `86` 的长文解释的是：

`为什么 resume surface 本身就是安全承诺面，`

那么这一页只做一件事：

`把不同恢复表面到底依据什么发声、最多配说到哪一步、何时必须撤回承诺，以及哪些 promise 绝不能说压成一张诚实性矩阵。`

## 2. 恢复承诺诚实性矩阵

| surface | promise basis | allowed promise | invalidation trigger | required cleanup | forbidden lie | 关键证据 |
| --- | --- | --- | --- | --- | --- | --- |
| shutdown 时打印的 `claude remote-control --continue` | session 与 environment 被刻意保留，且不是 fatal exit | “这个 session 仍可继续恢复” | archive 或 deregister 将发生；fatal exit | 不打印 resumable hint | 在 session/env 即将销毁时仍打印 resume command | `bridgeMain.ts:1515-1538` |
| `--continue` 解析到的 pointer | freshest valid pointer across current dir/worktrees | “Resuming session X (Ym ago) ...” | 没找到 pointer 或 pointer 已无效 | 报错并停止继续承诺 | 用错误 worktree 或陈旧 pointer 冒充当前恢复对象 | `bridgeMain.ts:2141-2174`、`bridgePointer.ts:115-184` |
| stale / invalid pointer 文件 | pointer schema 与 mtime 校验失败 | 不应承诺任何恢复 | invalid schema / >4h stale | `clearBridgePointer(...)` | 继续 re-prompt 用户恢复死边界 | `bridgePointer.ts:76-113` |
| resume 时 session 不存在或无 `environment_id` | `getBridgeSession(...)` 返回不可恢复对象 | 只能说“当前不可恢复” | session gone / no environment_id | 清理对应 `resumePointerDir` | 继续保留 pointer 让用户反复撞向死 session | `bridgeMain.ts:2380-2410` |
| reconnect transient failure | pointer 仍在，environment 仍可能可重试 | “The session may still be resumable — try running the same command again.” | failure 被判定为 fatal | 保留 pointer 作为 retry mechanism | 在真实可重试路径已不存在时继续让用户反复 retry | `bridgeMain.ts:2524-2540` |
| reconnect fatal failure | 边界不可恢复 | 只能撤回恢复承诺 | fatal reconnect error | 清 pointer | 对 dead boundary 继续承诺可恢复 | `bridgeMain.ts:2527-2534` |
| standalone single-session pointer | single-session 模式且 session 真实存在 | 允许为 crash / restart 建立恢复承诺 | multi-session 语义不兼容 | 不在 multi-session 写 pointer | 写出与后续 resume 语义冲突的 pointer | `bridgeMain.ts:2700-2728` |
| REPL perpetual pointer | perpetual teardown 选择挂起而非退役 | “本地退出后仍可继续恢复” | non-perpetual clean exit / pointer stale | 在退役路径 clear pointer | 边界已退役仍保留恢复承诺 | `replBridge.ts:479-488,1595-1615,1660-1663` |

## 3. 最短判断公式

看到一句恢复提示时，先问五句：

1. 这句话承诺的到底是 retry、resume，还是完整 continuation
2. 它背后的 promise basis 现在还真实存在吗
3. 当前 pointer、session、environment 与 mode 语义是否彼此一致
4. 如果 promise 已失效，系统是否已经撤回并清理对应 carrier
5. 这句话是在帮助用户，还是在误导用户继续围绕死边界行动

## 4. 最常见的五类假承诺

| 假承诺 | 会造成什么问题 |
| --- | --- |
| 已准备 archive+deregister 仍打印 resume command | 系统公开承诺一个必然失败的恢复路径 |
| stale pointer 未清理 | 用户被重复引导到死 session |
| fatal failure 后仍保留 “try again” 语气 | retry 被伪装成仍有希望 |
| worktree 指针指错对象 | promise 指向错误边界 |
| multi-session 下仍写单-session pointer | 恢复承诺与模式语义冲突 |

## 5. 一条硬结论

对 Claude Code 这类安全控制面来说，  
真正成熟的不是：

`实现了 resume 功能，`

而是：

`系统只在恢复仍然真实时才承诺恢复，并在恢复不再真实时立即撤回这项承诺。`
