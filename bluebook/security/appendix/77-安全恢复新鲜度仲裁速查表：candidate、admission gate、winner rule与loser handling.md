# 安全恢复新鲜度仲裁速查表：candidate、admission gate、winner rule与loser handling

## 1. 这一页服务于什么

这一页服务于 [93-安全恢复新鲜度仲裁：为什么多个worktree候选并存时，最新活性证明而不是路径亲缘才配代表当前边界](../93-%E5%AE%89%E5%85%A8%E6%81%A2%E5%A4%8D%E6%96%B0%E9%B2%9C%E5%BA%A6%E4%BB%B2%E8%A3%81%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%E5%A4%9A%E4%B8%AAworktree%E5%80%99%E9%80%89%E5%B9%B6%E5%AD%98%E6%97%B6%EF%BC%8C%E6%9C%80%E6%96%B0%E6%B4%BB%E6%80%A7%E8%AF%81%E6%98%8E%E8%80%8C%E4%B8%8D%E6%98%AF%E8%B7%AF%E5%BE%84%E4%BA%B2%E7%BC%98%E6%89%8D%E9%85%8D%E4%BB%A3%E8%A1%A8%E5%BD%93%E5%89%8D%E8%BE%B9%E7%95%8C.md)。

如果 `93` 的长文解释的是：

`为什么恢复候选并存时必须由最新活性证明决定当前真相，`

那么这一页只做一件事：

`把候选入场、胜出规则与失败后处理压成一张仲裁矩阵。`

## 2. 安全恢复新鲜度仲裁矩阵

| candidate / stage | admission gate | arbitration basis | winner rule | loser handling | forbidden shortcut | 关键证据 |
| --- | --- | --- | --- | --- | --- | --- |
| current-dir pointer | `readBridgePointer(dir)` 成功 | 当前目录 fast path | 命中则先返回 | 未命中才进入 fanout | 把 fast path 误当主权 | `bridgePointer.ts:129-137`; `bridgeMain.ts:2141-2154` |
| sibling-worktree pointer | `readBridgePointer(wt)` 成功 | 与当前目录同一标准 | 并入候选集比较 `ageMs` | 无 pointer 的 sibling 自然出局 | 因为“不在当前目录”就排除 | `bridgePointer.ts:139-164` |
| stale / invalid pointer | schema valid 且 `ageMs <= TTL` 才能入场 | 不参与优先级比较 | 直接失格 | 清理并返回 `null` | 让失格对象继续反复参与恢复叙事 | `bridgePointer.ts:98-109` |
| wrong-source prior pointer | `source === 'repl'` | 制度同类性 | 只有同类 pointer 可复用 | source 不匹配则忽略 | 把不同恢复制度下的 pointer 混用 | `replBridge.ts:305-312` |
| multi-worktree candidate set | 候选全部通过 admission gate | `ageMs` 最低 | freshest pointer 胜出 | 其他候选暂不清，等待后续证伪 | 选“最近路径”或“第一个找到的” | `bridgePointer.ts:166-181` |
| selected winner provenance | winner 已选出 | `pointerDir` | 跟随 winner 一起保存 | 后续 deterministic failure 定点清理 | 选对 winner 却忘掉来源目录 | `bridgeMain.ts:2162-2174` |
| dead-session winner | `getBridgeSession()` 返回空 | 候选已被服务器证伪 | 取消其代表资格 | 清理 `resumePointerDir` | 只报错，不撤销已败诉候选 | `bridgeMain.ts:2380-2398` |
| no-environment winner | `environment_id` 缺失 | 对象不具备 attach 条件 | 取消其代表资格 | 清理 `resumePointerDir` | 把不具 attach 资格的对象继续当可恢复候选 | `bridgeMain.ts:2400-2410` |
| transient reconnect failure | reconnect 失败但非 fatal | retry value 仍在 | 不撤销 winner | 保留 pointer，允许下次再试 | 一次失败就清空恢复资产 | `bridgeMain.ts:2524-2539` |
| fatal reconnect failure | reconnect fatal | 恢复价值被正式打穿 | 撤销 winner | 清理 `resumePointerDir` | 把 fatal 与 retryable 混成同一失败 | `bridgeMain.ts:2527-2533` |

## 3. 最短判断公式

看到多个恢复候选时，先问五句：

1. 哪些候选先通过了 admission gate
2. 它们是不是属于同一恢复制度
3. 谁的 freshness proof 最新
4. winner 的 provenance 有没有被保留
5. 后续失败是 fatal 还是 retryable，是否应撤销这份资格

## 4. 最常见的五类仲裁错误

| 错误方式 | 会造成什么问题 |
| --- | --- |
| 把当前目录命中当最终真相 | worktree 迁移后误选旧边界 |
| 不过滤 stale / invalid candidate | 失格对象反复污染恢复入口 |
| 不区分 pointer source | 不同恢复制度对象被错误混用 |
| 选出 winner 却不保留 provenance | 后续失败时清错 carrier |
| 不区分 fatal 与 retryable | 一次瞬时失败就提前抹掉恢复价值 |

## 5. 一条硬结论

对 Claude Code 这类恢复控制面来说，  
真正成熟的不是：

`在某个目录里找到一个 pointer，`

而是：

`先过滤失格候选，再让最新活性证明胜出，并在 winner 被正式证伪时精确回收它的代表权。`
