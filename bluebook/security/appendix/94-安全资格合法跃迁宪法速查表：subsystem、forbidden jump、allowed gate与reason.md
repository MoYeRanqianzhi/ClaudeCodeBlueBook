# 安全资格合法跃迁宪法速查表：subsystem、forbidden jump、allowed gate与reason

## 1. 这一页服务于什么

这一页服务于 [110-安全资格合法跃迁宪法：为什么不是任何from_state都能跳到任何to_state，而必须用transition constitution封死非法改口](../110-%E5%AE%89%E5%85%A8%E8%B5%84%E6%A0%BC%E5%90%88%E6%B3%95%E8%B7%83%E8%BF%81%E5%AE%AA%E6%B3%95%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%E4%B8%8D%E6%98%AF%E4%BB%BB%E4%BD%95from_state%E9%83%BD%E8%83%BD%E8%B7%B3%E5%88%B0%E4%BB%BB%E4%BD%95to_state%EF%BC%8C%E8%80%8C%E5%BF%85%E9%A1%BB%E7%94%A8transition%20constitution%E5%B0%81%E6%AD%BB%E9%9D%9E%E6%B3%95%E6%94%B9%E5%8F%A3.md)。

如果 `110` 的长文解释的是：

`真正的状态机必须封死非法跃迁，`

那么这一页只做一件事：

`把各 subsystem 当前最关键的 forbidden jump、其 allowed gate 与背后原因压成一张宪法矩阵。`

## 2. 合法跃迁宪法矩阵

| subsystem | forbidden jump | allowed gate | reason | 关键证据 |
| --- | --- | --- | --- | --- |
| notifications | old-timeout -> clear new current | `current.key` 必须仍匹配 timeout 所属 key | 旧因果不得改写新 current | `notifications.tsx:54-68,90-104,131-146` |
| notifications | duplicate key -> duplicated queue/current | `shouldAdd` only when key absent from queue/current | 同一状态槽位不得分叉成多个命运 | `notifications.tsx:172-188` |
| notifications | absent -> removed | 只有 `isCurrent || inQueue` 才允许 remove | 不允许伪造“我刚成功清掉了某对象” | `notifications.tsx:193-212` |
| bridge | fuse_blown -> still_enabled_retry_loop | 连续失败达到上限后必须 disable | 已证明不可恢复时不得继续假装普通重试 | `useReplBridge.tsx:113-127` |
| bridge | no-error-timeout -> disable now | timeout 回调只有在 `replBridgeError` 仍存在时才可执行 | 旧失败计时器不得改写已恢复世界 | `useReplBridge.tsx:354-360,636-642` |
| bridge | failed/pending -> connected without bundle | handle/url/session/env bundle 必须到位 | 强正向结论不能靠裸布尔跳跃成立 | `useReplBridge.tsx:230-245,252-258,525-535,592-605` |
| plugin | `needsRefresh=true` -> `false` without refresh | 只有 `refreshActivePlugins()` consumes it | completion 不得被假宣布 | `useManagePlugins.ts:293-303`; `refresh.ts:59-67,123-138` |
| pointer | stale/invalid -> still current resumable | stale/invalid 必须 clear -> null | 失效恢复资产不得继续代表 current | `bridgePointer.ts:98-109` |
| pointer | resumable clean shutdown -> retired/cleared | non-fatal single-session resume path must keep pointer | 可恢复边界不得被误杀 | `bridgeMain.ts:1525-1537` |
| pointer | transient reconnect failure -> clear forever | 只有 fatal reconnect failure 才 clear | 过度悲观会误夺用户重试资格 | `bridgeMain.ts:2524-2534` |

## 3. 最短判断公式

看到某次状态跃迁时，先问五句：

1. 这条 from->to 本身是否被允许
2. 如果被允许，它依赖什么 gate
3. 如果没有 gate，会制造哪种假真相
4. 这条跃迁是否只有特定 owner 才能触发
5. 如果这条跃迁现在发生，会不会构成越级改口

## 4. 最常见的五类非法跃迁错误

| 错误方式 | 会造成什么问题 |
| --- | --- |
| 旧 timeout 清掉新 current | 过期因果篡改当前真相 |
| 重复 key 并排入队 | 同一对象出现分叉状态 |
| 未完成 refresh 就宣告完成 | completion overclaim |
| transient failure 被清成永久失效 | 恢复资格被误杀 |
| 缺 bundle 校验就写 connected/active | 强正向词被伪造 |

## 5. 一条硬结论

对安全控制面来说，  
真正重要的不是：

`当前有哪些状态，`

而是：

`哪些状态跃迁绝不能发生，以及系统是否真的在入口处把它们挡住了。`
