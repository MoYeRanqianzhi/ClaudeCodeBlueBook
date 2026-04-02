# 安全恢复显式语义速查表：hidden、suppressed、cleared与resolved

## 1. 这一页服务于什么

这一页服务于 [60-安全恢复显式语义：为什么hidden、suppressed、cleared与resolved必须严格区分，不能被同一句“没事了”压平](../60-%E5%AE%89%E5%85%A8%E6%81%A2%E5%A4%8D%E6%98%BE%E5%BC%8F%E8%AF%AD%E4%B9%89%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88hidden%E3%80%81suppressed%E3%80%81cleared%E4%B8%8Eresolved%E5%BF%85%E9%A1%BB%E4%B8%A5%E6%A0%BC%E5%8C%BA%E5%88%86%EF%BC%8C%E4%B8%8D%E8%83%BD%E8%A2%AB%E5%90%8C%E4%B8%80%E5%8F%A5%E2%80%9C%E6%B2%A1%E4%BA%8B%E4%BA%86%E2%80%9D%E5%8E%8B%E5%B9%B3.md)。

如果 `60` 的长文解释的是：

`为什么不同责任层状态必须有不同词，`

那么这一页只做一件事：

`把 hidden、suppressed、cleared、resolved 压成一张可直接用于文案和状态机评审的词法矩阵。`

## 2. 恢复显式语义矩阵

| 语义 | 最短定义 | 典型对象 / 模块 | 允许系统说什么 | 禁止误说什么 | 对应责任层 | 关键证据 |
| --- | --- | --- | --- | --- | --- | --- |
| hidden | 当前视图不再展示，但对象与其恢复价值仍在 | `useTasksV2.ts` 的 `getSnapshot() -> undefined`、`Messages.tsx` 的 `hiddenMessageCount` | 已隐藏、可展开、当前未显示 | 已删除、已解决 | 视图秩序层 | `useTasksV2.ts:49-55,123-185`、`Messages.tsx:522-528,681-689` |
| suppressed | 当前被更高优先级模式或前景暂时压住 | `PromptInput/Notifications.tsx` 中 voice 覆盖全部通知前景、hint 显隐 | 已让位、已被暂时压住、当前以前景对象为准 | 已清除、已关闭、已恢复 | 注意力仲裁层 | `PromptInput/Notifications.tsx:147-163,281-286` |
| cleared | authoritative writer 已在正式账本中清空、替换或终结该对象 | `pending_action: null`、`task_summary: null`、worker init stale metadata cleanup | 已清空正式 trace、已从账本移除 | 全链已恢复、风险已消失 | 正式账本层 | `sessionState.ts:99-116`、`ccrClient.ts:476-520` |
| resolved | 对应恢复链与解释链都已闭环，更高层 signer 允许撤警/转绿 | 更高层 explanation closure、恢复链最终签字 | 已解决、已恢复、可以撤警/转绿 | 仅因 UI 安静或局部 connected 就宣告 resolved | 解释闭环层 | `49`-`60` 主线归纳 |

## 3. 最短判断公式

审查任一“没事了”式文案时，先问四句：

1. 这说的是 hidden、suppressed、cleared 还是 resolved
2. 当前证据来自视图、前景、账本，还是更高层 signer
3. 如果现在崩溃、重连或晚到消费者读取，相关 trace 还在不在
4. 这句文案有没有把低层状态越级说成高层闭环

## 4. 最常见的四类词法压扁错误

| 词法压扁错误 | 会造成什么问题 |
| --- | --- |
| 把 hidden 说成 cleared | 用户以为对象已不存在 |
| 把 suppressed 说成 resolved | 前景让位被误读成问题解决 |
| 把 cleared 说成 resolved | 账本清理被误读成解释闭环 |
| 把局部 connected 说成 resolved | 低层活性 signal 越级替高层 signer 签字 |

## 5. 一条硬结论

对 Claude Code 这类安全控制面来说，  
真正危险的不是状态词多一点，  
而是：

`hidden、suppressed、cleared、resolved 被压成同一句“没事了”。`
