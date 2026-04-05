# 安全恢复资格降级语法速查表：resume result、meaning、next action与forbidden flattening

## 1. 这一页服务于什么

这一页服务于 [89-安全恢复资格降级语法：为什么no-candidate、invalid-id、dead-session、fresh-session-fallback与retryable不能压成同一句无法恢复](../89-%E5%AE%89%E5%85%A8%E6%81%A2%E5%A4%8D%E8%B5%84%E6%A0%BC%E9%99%8D%E7%BA%A7%E8%AF%AD%E6%B3%95%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88no-candidate%E3%80%81invalid-id%E3%80%81dead-session%E3%80%81fresh-session-fallback%E4%B8%8Eretryable%E4%B8%8D%E8%83%BD%E5%8E%8B%E6%88%90%E5%90%8C%E4%B8%80%E5%8F%A5%E6%97%A0%E6%B3%95%E6%81%A2%E5%A4%8D.md)。

如果 `89` 的长文解释的是：

`为什么恢复资格失败必须被分层表达，`

那么这一页只做一件事：

`把不同 resume result 到底表示什么、下一步该做什么，以及哪些压平说法绝不能再说压成一张降级语法矩阵。`

## 2. 恢复资格降级语法矩阵

| resume result | meaning | next action | cleanup policy | forbidden flattening | 关键证据 |
| --- | --- | --- | --- | --- | --- |
| `no-candidate` | 当前没有任何可追索恢复对象 | `start a new one` | 无对象可清 | 不能压成“旧 session 死亡” | `bridgeMain.ts:2149-2160` |
| `invalid-candidate` | 恢复候选 id 不合法，未进入对象核验 | 直接拒绝输入 | 无对象可清 | 不能压成“session not found” | `bridgeMain.ts:2363-2373` |
| `dead-session` | session 已不存在，边界已死 | 停止追索旧边界 | clear pointer | 不能压成 generic retry failure | `bridgeMain.ts:2380-2398` |
| `non-attachable-object` | session 存在，但无 `environment_id`，不属于桥接恢复对象族 | 停止此恢复路径 | clear pointer | 不能压成“对象不存在” | `bridgeMain.ts:2400-2410` |
| `fresh-session-fallback` | 原边界不可续接，但仍可开始新边界 | create fresh session | 不保留 resume success 语义 | 不能压成“彻底不能继续” | `bridgeMain.ts:2473-2489` |
| `retryable` | 当前未恢复成功，但仍有 retry path | try again | 保留 pointer | 不能压成 fatal-nonresumable | `bridgeMain.ts:2524-2540` |
| `fatal-nonresumable` | 当前边界不再可恢复 | 终止恢复，撤回 promise | clear pointer | 不能继续说 `may still be resumable` | `bridgeMain.ts:2527-2540` |

## 3. 最短判断公式

看到一句恢复失败提示时，先问五句：

1. 它是在说没有候选，还是候选已死
2. 它是在说对象存在但不可附着，还是边界已彻底退役
3. 它是在说 resume 不行，还是 fresh-session 仍可行
4. 它是在说 retryable，还是 fatal
5. 这句话有没有把完全不同的下一步动作压成一个 generic failed

## 4. 最常见的五类压平误读

| 压平误读 | 会造成什么问题 |
| --- | --- |
| 把 no-candidate 说成 dead-session | 用户误以为某个旧边界确实存在且已死 |
| 把 invalid-id 说成 not found | 输入问题与对象问题混淆 |
| 把 non-attachable-object 说成不存在 | 丢失对象类型解释 |
| 把 fresh-session-fallback 说成彻底不能继续 | 错失仍可工作的替代路径 |
| 把 retryable 说成 fatal | 用户过早放弃仍可恢复的边界 |

## 5. 一条硬结论

对 Claude Code 这类安全控制面来说，  
真正成熟的不是：

`恢复失败时统一报错，`

而是：

`恢复失败时系统会把失败精确降级成不同语义，从而给出不同动作、不同清理和不同承诺撤回强度。`
