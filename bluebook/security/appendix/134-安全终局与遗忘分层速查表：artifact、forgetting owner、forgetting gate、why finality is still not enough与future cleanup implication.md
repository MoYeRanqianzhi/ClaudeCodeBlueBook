# 安全终局与遗忘分层速查表：artifact、forgetting owner、forgetting gate、why finality is still not enough与future cleanup implication

## 1. 这一页服务于什么

这一页服务于 [150-安全终局与遗忘分层：为什么finality signer不能越级冒充forgetting signer](../150-%E5%AE%89%E5%85%A8%E7%BB%88%E5%B1%80%E4%B8%8E%E9%81%97%E5%BF%98%E5%88%86%E5%B1%82%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88finality%20signer%E4%B8%8D%E8%83%BD%E8%B6%8A%E7%BA%A7%E5%86%92%E5%85%85forgetting%20signer.md)。

如果 `150` 的长文解释的是：

`为什么 finality 仍不等于 forgetting，`

那么这一页只做一件事：

`把不同 artifact 到底由谁忘、什么条件下才配忘、以及为什么 finality 仍然不够，压成一张矩阵。`

## 2. 遗忘分层矩阵

| artifact | forgetting owner | forgetting gate | why finality is still not enough | future cleanup implication | 关键证据 |
| --- | --- | --- | --- | --- | --- |
| notification current / queue | notification queue owner | `timeoutMs` / `invalidates` / `removeNotification(key)` | 新状态出现不等于弱表面就能顺手删旧提示 | cleanup future design 需要 `cleanup_projection_hidden_only` | `notifications.tsx:45-75,193-214` |
| `plugins.needsRefresh` | `refreshActivePlugins()` | full refresh consumption path | 弱提示层能看到新状态，仍不配 reset old trace | cleanup future design 需要 `cleanup_trace_retained` 与 `cleanup_forget_allowed` 分开 | `useManagePlugins.ts:292-304`; `utils/plugins/refresh.ts:62-76,123-136` |
| plugin auto-refresh failure path | plugin install / refresh owner | auto-refresh truly succeeds；失败则回退 `needsRefresh: true` | “已经试过了”不等于可以忘掉失败痕迹 | cleanup future design 需要 explicit fallback-to-retain grammar | `PluginInstallationManager.ts:146-166` |
| bridge pointer on env/session loss | bridge recovery asset owner | env gone / session gone / stale pointer | future-readable truth 不等于 retry asset 已无价值 | cleanup future design 需要 `cleanup_retry_asset_retained` | `bridgeMain.ts:1568-1578,2384-2405` |
| bridge pointer on reconnect error | bridge reconnect owner | fatal failure 才 clear；transient 必须保留 | transient error 后仍要为 future retry 保留资产 | cleanup future design 绝不能让 transient finality 冒充 lawful forgetting | `bridgeMain.ts:2528-2540` |

## 3. 最短判断公式

判断某条“现在可以删旧痕迹”的说法有没有越级，先问三句：

1. 当前 artifact 的 forgetting owner 是谁
2. 它的 forgetting gate 到底是什么
3. 当前所谓 finality 是否其实仍在服务 future retry / explanation / audit

## 4. 最常见的四类误读

| 误读 | 实际问题 |
| --- | --- |
| “既然已经 final，就能删提示” | projection hide 不等于 formal forgetting |
| “插件已经稳定了，就把 needsRefresh 清掉” | 只有 refresh owner 才配消费它 |
| “自动刷新试过了，失败也可以算忘掉” | failure fallback 反而要求 trace retention |
| “桥接看起来结束了，pointer 就该删” | transient / resumable 场景里它仍是 retry asset |

## 5. 一条硬结论

真正成熟的 forgetting grammar 不是：

`final -> delete`

而是：

`final、retain、retry-asset、forget-allowed 各由不同 owner 在不同 gate 下签字。`
