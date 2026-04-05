# 安全恢复绿色词租约速查表：positive lexicon、renewal condition、revocation trigger与lease length

## 1. 这一页服务于什么

这一页服务于 [64-安全恢复绿色词租约：为什么active、connected、ready都只能被视作可撤销租约，而不是稳定承诺](../64-%E5%AE%89%E5%85%A8%E6%81%A2%E5%A4%8D%E7%BB%BF%E8%89%B2%E8%AF%8D%E7%A7%9F%E7%BA%A6%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88active%E3%80%81connected%E3%80%81ready%E9%83%BD%E5%8F%AA%E8%83%BD%E8%A2%AB%E8%A7%86%E4%BD%9C%E5%8F%AF%E6%92%A4%E9%94%80%E7%A7%9F%E7%BA%A6%EF%BC%8C%E8%80%8C%E4%B8%8D%E6%98%AF%E7%A8%B3%E5%AE%9A%E6%89%BF%E8%AF%BA.md)。

如果 `64` 的长文解释的是：

`为什么绿色词更像租约而不是产权，`

那么这一页只做一件事：

`把 positive lexicon、renewal condition、revocation trigger 与 lease length 压成一张租约矩阵。`

## 2. 绿色词租约矩阵

| positive lexicon | renewal condition | revocation trigger | lease length | 为什么只是租约 | 关键证据 |
| --- | --- | --- | --- | --- | --- |
| immediate notification 前景词 | timeout 未到、未被 `invalidates`、未被更强前景接管 | timeout、`invalidates`、`removeNotification()`、`fold` 覆盖 | 很短 | 当前只是一段短期注意力占用，不带长期真值担保 | `notifications.tsx:80-104,172-212` |
| 任务完成后的“可隐藏”正向词 | hide delay 结束后再次确认 `allStillCompleted` | hide delay 内出现未完成任务、task list 变化、recheck 失败 | 短到中 | 连“完成”也必须经过一个观察窗口，不能一次观察永久生效 | `useTasksV2.ts:123-170` |
| `Remote Control active` | 当前满足 `sessionActive || connected`，且没有 `error/reconnecting` | `error`、`reconnecting`、footer 分流 failed | 短 | 它只是当前 bridge 状态的临时正向标签，不是闭环结论 | `bridgeStatusUtil.ts:123-140`、`PromptInputFooter.tsx:173-189` |
| `/status` 的 `Connected to ...` | 当前聚合视图仍看到 connected client | client 不再 connected、出现更强风险词或更高层改口 | 中 | 这是盘点视角下的临时描述，不附带最终 resolved 承诺 | `status.tsx:53-85` |
| `/status` 的 `n connected` | 当前聚合计数仍然成立 | 聚合计数变化、`failed/needs auth/pending` 占优、跨面更强风险词出现 | 中 | 聚合词天然丢失细节，只能算暂时正向盘点租约 | `status.tsx:97-114` |
| higher signer 的 `resolved` | 更高层恢复链与解释链持续闭环 | 更强反证出现、上层 signer 撤销、闭环条件失效 | 最长，但仍可撤销 | 这是最接近长期租约的绿色词，但仍不是不可撤销产权 | `49`-`64` 主线归纳 |

## 3. 最短判断公式

评审一个绿色词是否被说得太满时，先问四句：

1. 它的 renewal condition 是什么
2. 它的 revocation trigger 是什么
3. 它的 lease length 属于短、中的盘点租约，还是更高层长期租约
4. 如果这些续租条件现在消失，这个绿色词还能不能继续成立

## 4. 最常见的四类租约误读

| 租约误读 | 会造成什么问题 |
| --- | --- |
| 把短期 notification 词当成稳定状态 | 短租约被误读成长期承诺 |
| 把单次 `completed` 观察当成永久完成 | 缺少 recheck 的正向误判 |
| 把 `active` / `connected` 当成不可撤销 | 局部 ready 冒充长期闭环 |
| 把高层 resolved 当成永远不会被反证推翻 | 控制面失去撤词纪律 |

## 5. 一条硬结论

对 Claude Code 这类安全控制面来说，  
最危险的不是绿色词本身，  
而是：

`短租约绿色词被用户和界面共同误读成了永久产权。`
