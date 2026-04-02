# 安全恢复隐藏权与删除权速查表：surface hider、projection owner、trace writer与explanation closer

## 1. 这一页服务于什么

这一页服务于 [59-安全恢复隐藏权与删除权：为什么提示消失、卡片转绿与摘要收缩都不等于正式trace已被安全清除](../59-%E5%AE%89%E5%85%A8%E6%81%A2%E5%A4%8D%E9%9A%90%E8%97%8F%E6%9D%83%E4%B8%8E%E5%88%A0%E9%99%A4%E6%9D%83%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%E6%8F%90%E7%A4%BA%E6%B6%88%E5%A4%B1%E3%80%81%E5%8D%A1%E7%89%87%E8%BD%AC%E7%BB%BF%E4%B8%8E%E6%91%98%E8%A6%81%E6%94%B6%E7%BC%A9%E9%83%BD%E4%B8%8D%E7%AD%89%E4%BA%8E%E6%AD%A3%E5%BC%8Ftrace%E5%B7%B2%E8%A2%AB%E5%AE%89%E5%85%A8%E6%B8%85%E9%99%A4.md)。

如果 `59` 的长文解释的是：

`为什么“没显示了”不等于“已删除”，`

那么这一页只做一件事：

`把 surface hider、projection owner、trace writer 与 explanation closer 压成一张分层矩阵。`

## 2. 隐藏权与删除权矩阵

| 层级 | 典型对象 / 模块 | 可以做什么 | 不能做什么 | 真正的删除者 / closer | 最危险误读 | 关键证据 |
| --- | --- | --- | --- | --- | --- | --- |
| surface hider | `PromptInput/Notifications.tsx` 的 hint、voice 覆盖、notification 当前前景 | 显示、替换、timeout、暂时隐藏前景提示 | 删除正式恢复账本 trace；宣布恢复闭环已完成 | 不是正式删除者 | 提示没了 = 问题没了 | `PromptInput/Notifications.tsx:147-163,281-286` |
| projection owner | `BridgeDialog.tsx`、`status.tsx` 的 label、footer、计数摘要 | 压缩状态、投影颜色、给默认入口、改摘要句式 | 用投影文案替代 authoritative state；替更高层 signer 清 trace | 不是正式删除者 | 卡片转绿 / 摘要收缩 = trace 已安全清空 | `BridgeDialog.tsx:137-205`、`status.tsx:38-114` |
| transport / readiness reporter | `replBridgeTransport.ts` 的 `isConnectedStatus()`、`getStateLabel()`、`onClose(4090/4091/4092)` | 报告 write-ready、连接生命周期、局部活性信号 | 把 write-readiness 说成 full recovery；替读链和解释链签字 | 不是正式删除者 | `connected` = read-ready = 可删 trace | `replBridgeTransport.ts:289-299,304-366` |
| trace writer | `sessionState.ts` 与 `ccrClient.ts` 对 `pending_action`、`task_summary`、`worker_status`、delivery 的 authoritative 写回 | 正式写入、正式清空、镜像事件、flush 后持久化 | 单凭表层注意力变化就清 trace；跳过 writer discipline | authoritative writer | UI 不再显示 = metadata 已清成 null | `sessionState.ts:92-130`、`ccrClient.ts:476-520,644-663,764-785,964-990` |
| explanation closer | 更高层 signer / 控制台解释层 / 人工确认闭环 | 决定何时撤警、何时恢复动作、何时允许转绿 | 用低层 visibility change 代替 explanation closure | explanation signer / 人工确认 | “用户看不到了” = “控制面可以忘记了” | `49`-`59` 主线归纳 |

## 3. 最短判断公式

看到任一痕迹“消失”时，先问四句：

1. 它只是从前景隐藏了，还是被 authoritative writer 清成 null 了
2. 当前动作发生在 surface hider、projection owner 还是 trace writer
3. 当前拿到的是 visibility change，还是正式账本变更
4. 是否已经有 explanation closer 对“这件事可以忘记”完成签字

## 4. 最常见的四类混层错误

| 混层错误 | 会造成什么问题 |
| --- | --- |
| 把 hint 消失当成问题消失 | 用户失去继续修复的认知线索 |
| 把卡片转绿当成 trace 已清空 | 表层摘要越级替底层账本签字 |
| 把 `connected` 当成 full recovery | write-ready 被误说成 read-ready / explanation-ready |
| 把 UI 安静当成系统遗忘合法 | surface hiding 冒充 explanation closure |

## 5. 一条硬结论

对 Claude Code 这类安全控制面来说，  
最危险的不是表层暂时有点吵，  
而是：

`surface hider 和 projection owner 被误当成了正式 trace writer 与 explanation closer。`
