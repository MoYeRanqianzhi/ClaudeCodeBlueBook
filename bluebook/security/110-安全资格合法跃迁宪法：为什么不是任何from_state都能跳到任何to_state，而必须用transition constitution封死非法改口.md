# 安全资格合法跃迁宪法：为什么不是任何from_state都能跳到任何to_state，而必须用transition constitution封死非法改口

## 1. 为什么在 `109` 之后还必须继续写“合法跃迁宪法”

`109-安全资格生命周期调度与状态机` 已经回答了：

`高风险字段不该继续通过裸 setState 变化，而应经由 typed transition dispatch / state machine 合法发生。`

但如果继续往下追问，  
还会碰到一个更硬的问题：

`这个 state machine 到底在保护什么？`

答案不是：

`只是让状态变化更整洁。`

真正被保护的是：

`某些 from_state -> to_state 的跳跃本来就不应被允许发生。`

也就是说，  
统一调度器如果只是把变化“记下来”，  
仍然不够；  
它还必须在入口处明确回答：

1. 哪些跃迁合法
2. 哪些跃迁必须被拒绝
3. 哪些跃迁只能经过特定 gate
4. 哪些跃迁只能由特定 owner 触发

所以 `109` 之后必须继续补出的下一层就是：

`安全资格合法跃迁宪法`

也就是：

`不是任何 from_state 都能跳到任何 to_state，系统必须用 transition constitution 封死那些会伪造真相、越级改口、误清恢复资产的非法跃迁。`

## 2. 最短结论

从源码看，Claude Code 已经在多个地方写出了“非法跃迁禁止令”，只是这些禁令目前分散在局部 guard 里：

1. notification 不允许同 key 重复入队，也不允许旧 timeout 清掉已经被新 key 替代的 current  
   `src/context/notifications.tsx:54-68,90-116,121-188,193-212`
2. bridge 不允许在已熔断状态下继续伪装为可重试，也不允许不存在 error 时 timeout 再次把 bridge 关掉  
   `src/hooks/useReplBridge.tsx:113-127,330-362,633-644`
3. bridge ready/connected 也不是随便写 `true`，而是要求 handle/url/id bundle 对齐，且重复同态写入会被直接拒绝  
   `src/hooks/useReplBridge.tsx:230-245,252-258,525-535,592-605`
4. plugin 不允许 `needsRefresh=true` 直接跳回 `false`，只有 `/reload-plugins -> refreshActivePlugins()` 这一合法路径配完成跃迁  
   `src/hooks/useManagePlugins.ts:293-303`; `src/utils/plugins/refresh.ts:59-67,123-138`
5. pointer 不允许 invalid/stale/session-gone 继续留在 current，也不允许 transient reconnect failure 被错误清成“彻底不可恢复”  
   `src/bridge/bridgePointer.ts:98-109`; `src/bridge/bridgeMain.ts:1525-1537,2323-2325,2384-2403,2524-2534`

所以这一章的最短结论是：

`安全生命周期状态机的核心，不是“描述已有跃迁”，而是“禁止不该发生的跃迁”。`

再压成一句：

`真正的状态机，不只是会转，还会拒绝乱转。`

## 3. notification 已经给出最清楚的“非法跃迁禁止令”

## 3.1 旧 timeout 不能清掉新的 current

`src/context/notifications.tsx:54-68` 和 `90-104` 都有同一类 guard：

1. timeout 触发时先比对当前 key
2. 如果 `prev.notifications.current?.key !== nextKey/notif.key`
3. 就直接 `return prev`

这意味着：

`旧 timer -> current=null`

这条跃迁不是天然合法。  
它必须先满足：

`我仍然是当前那条通知`

否则就是非法改口。

这是一个非常重要的宪法性原则：

`失效来源不能改写不再属于自己的 current。`

## 3.2 同 key 重复入队被显式禁止

`src/context/notifications.tsx:172-175` 非常直接：

1. 收集 queued keys
2. 如果同 key 已在 queue 或 current
3. `shouldAdd = false`
4. `return prev`

这说明：

`queued/current -> duplicate queued`

是一条被显式禁止的跃迁。

为什么重要？  
因为如果允许这条跃迁，  
就会出现：

1. 同一 truth family 并排占位
2. timeout 次序影响真相解释
3. 弱旧版本可能在未来重新浮出来

所以这里本质上不是去重优化，  
而是：

`防止同一状态槽位产生分叉宇宙。`

## 3.3 remove 也不是想删谁就删谁

`src/context/notifications.tsx:193-212` 里：

1. 如果既不在 current 也不在 queue
2. 直接 `return prev`

这说明：

`absent -> removed`

并不是合法跃迁。  
系统明确拒绝把“不存在的对象”当成“刚刚被我成功删除的对象”。

这条规则看似小，  
但它实际上防的是：

`伪删除叙事`

也就是防止代码误以为自己已经成功执行了一个具有治理意义的 retire。

## 4. bridge 生命周期里真正危险的，是错误的“恢复性跳跃”

## 4.1 熔断后不允许继续假装还处于普通重试态

`src/hooks/useReplBridge.tsx:113-127` 里：

1. 连续失败达到上限
2. 直接写 `replBridgeEnabled=false`
3. 给出 `disabled after repeated failures`
4. 然后 `return`

这说明：

`fuse_blown -> still_enabled_retry_loop`

是一条被显式禁止的跃迁。

否则系统就会进入一种危险状态：

1. 表面像“还能继续重试”
2. 实际已经证明再重试只会制造更多错误

这其实是在保护：

`失败后的制度降级权`

## 4.2 没有 error 时 timeout 不允许继续执行 disable

`src/hooks/useReplBridge.tsx:354-360` 与 `636-642` 都有同样的 guard：

1. timeout 触发
2. 若 `!prev.replBridgeError`
3. 直接 `return prev`

这意味着：

`error already cleared -> disable bridge now`

是一条非法跃迁。

这和 notification 的 stale timeout guard 是同一条宪法：

`旧因果不能在自己已失效后继续改写当前世界。`

## 4.3 `failed -> connected` 也不是裸布尔翻转，而是要过 bundle gate

`src/hooks/useReplBridge.tsx:230-245,252-258,525-535,592-605` 反复出现：

1. 若已经在目标同态则 `return prev`
2. 只有 handle/url/id bundle 合法时才写 connected
3. ready / connected / mirror init 各自有不同 gate

这说明：

`failed/reconnecting/pending -> connected`

不是一句 `replBridgeConnected = true` 就能合法完成。

它至少需要：

1. 正确 source state
2. 正确 handle
3. 正确 bundle
4. 非重复改写

这正是 transition constitution 的核心精神：

`越强的正向结论，越不能被轻率跃迁到。`

## 5. plugin lifecycle 证明：completion 结论必须有专属跃迁门

`src/hooks/useManagePlugins.ts:293-303` 明确禁止：

1. auto-refresh
2. reset `needsRefresh`

`src/utils/plugins/refresh.ts:59-67,123-138` 又明确规定：

1. `refreshActivePlugins()` consumes `needsRefresh`
2. 完整 refresh 完成后才写 `needsRefresh=false`

所以：

`needsRefresh=true -> needsRefresh=false`

并不是任意调用方都可触发的普通跃迁。  
它是一条：

`只有 full refresh completion gate 才配触发的专属跃迁`

这说明安全控制面的很多“布尔切换”其实都不是普通布尔，  
而是：

`受宪法保护的 completion jump`

## 6. pointer 生命周期则把“非法跃迁”推进到了恢复资产主权层

## 6.1 invalid/stale pointer 不允许继续留在 current

`src/bridge/bridgePointer.ts:98-109` 明确：

1. invalid schema -> clear -> return null
2. stale age -> clear -> return null

这说明：

`invalid/stale -> still_current_resumable`

是一条被强行禁止的跃迁。

系统宁可直接撤场，  
也不允许旧 pointer 继续假装拥有恢复资格。

## 6.2 resumable clean shutdown 不允许被错误降级成“已彻底退役”

`src/bridge/bridgeMain.ts:1525-1537` 里：

1. single-session
2. 有 initialSessionId
3. 且 `!fatalExit`
4. 就直接 `return`
5. 不 archive/deregister/clear pointer

这说明：

`resumable_shutdown -> retired_and_cleared`

是一条被禁止的跃迁。

换句话说，  
系统不允许 clean resumable path 被错误写成 dead path。

## 6.3 transient reconnect failure 不允许误跳到“彻底清除资格”

`src/bridge/bridgeMain.ts:2524-2534` 极其关键：

1. transient reconnect failure 不应 deregister
2. 只有 fatal 才 clear pointer

这说明：

`transient_failure -> irrevocable_retire`

是一条被显式封死的非法跃迁。

而：

`fatal_failure -> keep_resumable_pointer`

则是另一条同样危险的非法跃迁。

这恰好说明 transition constitution 的双重作用：

1. 禁止过度乐观
2. 也禁止过度悲观

## 7. 从第一性原理看，transition constitution 到底在保护什么

它保护的不是某个布尔值，  
而是：

`改口权的边界。`

换句话说，  
任何状态机宪法最终都在回答三件事：

1. 谁配改口
2. 在什么证据下配改口
3. 哪些改口绝不能被允许

所以安全系统的真正危险，并不只是错误状态本身，  
而是：

`错误的改口`

例如：

1. 旧 timeout 把新 current 清掉
2. duplicate queue 把同一对象分叉成多条命运
3. fuse 已炸却继续假装还能普通 retry
4. refresh 未完成却说已同步
5. transient failure 被误写成永久退役
6. stale pointer 被误留为 current

这就是为什么这一章必须写“宪法”，  
而不能只写“状态机”。

因为：

`状态机描述变化，宪法裁定变化是否合法。`

## 8. 下一代统一 transition constitution 至少应显式包含什么

如果把前几章推进成真正的统一协议，  
我会建议每个高风险状态族都要显式定义：

## 8.1 allowed transitions

例如：

1. `pending -> active`
2. `reconnecting -> failed`
3. `needsRefresh -> refreshed`

## 8.2 forbidden transitions

例如：

1. `stale -> current`
2. `transient_failure -> cleared_forever`
3. `needsRefresh -> false_without_refresh`
4. `duplicate_key -> duplicated_queue`

## 8.3 required gate

例如：

1. `completion_signer`
2. `freshness_check`
3. `full_refresh_complete`
4. `current_key_match`

## 8.4 required owner

例如：

1. notification queue manager
2. bridge lifecycle controller
3. plugin refresh path
4. pointer revocation owner

这样系统才不只是：

`有 dispatch`

而是：

`有能拒绝非法 dispatch 的宪法。`

## 9. 技术先进性：Claude Code 已经有很多“隐形宪法条文”

Claude Code 当前最先进的地方之一，  
是它已经在很多局部 guard 里写出了强烈的宪法意识：

1. compare current key before timeout clear
2. forbid duplicate notification enqueue
3. refuse no-op / duplicate bridge writes
4. forbid auto-reset of `needsRefresh`
5. clear pointer only on the correct class of failure

这说明作者并不是在“随便写几个 if”，  
而是在不断防守：

`那些会伪造当前真相的非法跃迁。`

这对其他平台的启示很直接：

`成熟的安全系统，不是等错误状态出现后再解释，而是在状态跃迁入口就已经知道哪些跳跃绝不能发生。`

## 10. 苏格拉底式反思：如果要把这一层做得更好，还应继续追问什么

可以继续追问七个问题：

1. 当前哪些非法跃迁已经被局部 guard 防住，但还没有进入统一 constitution 表
2. 当前哪些 guard 其实对应的是同一类宪法原则，只是分散在不同 subsystem
3. 当前有没有某些高风险字段仍缺 `from_state` 校验
4. 当前有没有某些 transition 仍缺 owner 校验
5. 当前有没有某些 timeout / cleanup 仍可能越级改写已更新的 current
6. 当前如果要做统一安全状态机自动测试，哪些非法跃迁最值得先写成 property tests
7. 当前系统是否已经足够成熟，可以把“非法跃迁拒绝”直接暴露给 review 和 debug 工具

这些问题共同指向一句话：

`系统真正的安全性，不在于它最终显示了什么，而在于它一路上拒绝了多少不该发生的改口。`

## 11. 一条硬结论

对 Claude Code 这类安全控制面来说，  
真正成熟的下一步不是：

`只有 dispatch，没有宪法，`

而是：

`把各状态族允许什么跃迁、禁止什么跃迁、需要什么 gate、由谁有权触发，正式写成统一的 transition constitution。`

因为只有这样，  
系统才能从：

`会调度状态变化`

进一步升级到：

`会拒绝不合法的状态变化。`
