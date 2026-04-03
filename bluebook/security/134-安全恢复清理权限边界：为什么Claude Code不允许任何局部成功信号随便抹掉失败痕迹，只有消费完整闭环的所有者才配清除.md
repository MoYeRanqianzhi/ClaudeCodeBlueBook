# 安全恢复清理权限边界：为什么Claude Code不允许任何局部成功信号随便抹掉失败痕迹，只有消费完整闭环的所有者才配清除

## 1. 为什么在 `133` 之后还必须继续写“清理权限边界”

`133-安全写权撤销协议` 已经回答了：

`Claude Code 一旦认定旧上下文失效，就会主动撤销旧 snapshot、旧 timer、旧 closure、旧 credential 与旧 promise 的写权。`

但如果继续追问，  
还会碰到另一个同样棘手的问题：

`旧写者失效之后，谁有资格宣布“这件事已经结束，可以把痕迹清掉了”？`

这一步比“撤权”更难，  
因为很多系统并不是不会留痕，  
而是：

`太早忘记。`

也就是说，  
真正高风险的并不只是：

1. 旧对象继续写当前真相

还包括：

2. 某个局部成功信号过早把失败痕迹删掉
3. 某个弱 surface 擅自把 pending / needsRefresh / stale 指示清空
4. 某个提示层把“暂时不显示”误当成“正式恢复”

所以 `133` 之后必须继续补出的下一层就是：

`安全恢复清理权限边界`

也就是：

`Claude Code 不只会保留失败痕迹，它还会把“谁配清除这些痕迹”收得很紧，避免局部回暖伪装成正式恢复。`

## 2. 最短结论

Claude Code 安全设计真正成熟的一点，不只是知道要留痕，  
更在于：

`它不允许任何局部成功信号随便抹掉失败痕迹。`

从源码看，这种“清理权收紧”至少体现在五类对象上：

1. 通知痕迹的清除只由 notification queue owner 执行  
   `src/context/notifications.tsx:45-75,78-116,193-213`
2. plugin `needsRefresh` 不能被 `useManagePlugins` 提示层清掉，只能由 `refreshActivePlugins()` 消费  
   `src/hooks/useManagePlugins.ts:287-303`  
   `src/utils/plugins/refresh.ts:59-71,123-138`
3. background plugin installation 若 auto-refresh 失败，只能回退到 `needsRefresh=true`，不能假清理  
   `src/services/plugins/PluginInstallationManager.ts:135-165`
4. MCP reconnect 痕迹只有在成功、最终失败、disable 或 unmount 时才由连接管理器清掉 timer / pending path  
   `src/services/mcp/useManageMCPConnections.ts:333-460,1026-1041`
5. bridge pointer 只有在 env gone / archive+deregister 等强边界下才清；可恢复场景反而故意保留  
   `src/bridge/bridgeMain.ts:1515-1523,1573-1576,2384-2392,2700-2728`

所以这一章的最短结论是：

`安全恢复不是“有个好消息就删痕迹”，而是“只有真正消费完整恢复闭环的所有者才配清除”。`

再压成一句：

`遗忘不是默认动作，而是特权动作。`

## 3. 第一性原理：为什么成熟安全系统必须把“遗忘权”当成权限对象

很多系统对恢复的直觉非常简单：

1. 失败出现时，显示错误
2. 有一点好转时，把错误收起来

但这套直觉在安全系统里是危险的。

因为“把错误收起来”本质上是在做三件事：

1. 改变用户对当前真相的认知
2. 撤销某条修复路径提示
3. 剥夺后续排障所依赖的上下文痕迹

也就是说，  
删除痕迹不是 UI 优化，  
而是：

`改变控制面对失败的官方叙述。`

所以它必须像授权一样被认真治理。

从第一性原理看，  
安全恢复要回答的不是：

`现在看起来是不是好点了？`

而是：

1. 这条失败链是否真的被完整消费
2. 这条失败链的 dominant repair path 是否已经走完
3. 当前看到的只是局部回暖，还是最终 signer 已经改口
4. 哪个对象拥有“清理痕迹”的权威

这就是为什么“遗忘权”本身必须被当成权限对象。

## 4. 通知系统说明：提示可以过期，但清除权仍归 notification owner

`src/context/notifications.tsx:45-75,78-116,193-213` 给出了一个很干净的例子。

这里通知系统明确做到：

1. queue 的推进由 `processQueue()` 控制
2. immediate notification 会抢占并清掉当前 timeout
3. invalidation 会从 queue 和 current 中删掉被它覆盖的 key
4. 主动删除则必须走 `removeNotification(key)`

这说明通知虽然是最轻量的痕迹层，  
它依然不是谁都能直接改。

真正值得注意的不是它会自动 timeout，  
而是：

`即便是 timeout / invalidation / remove，也都由 notification queue owner 这一层统一执行。`

它表达的原则是：

`痕迹是否退出，不由任意调用方直接写 current=null 决定，而由掌管该痕迹生命周期的控制器决定。`

这是一种微缩版的清理权限边界。

## 5. `needsRefresh` 设计说明：提示层可以提醒，但无权假装已经消费刷新闭环

这里最有代表性的，是 plugin 刷新链。

### 5.1 `useManagePlugins` 明确拒绝自己清掉 `needsRefresh`

`src/hooks/useManagePlugins.ts:287-303` 的注释很硬：

1. 当磁盘上的 plugin state 改变
2. 这里只显示一条 notification
3. `Do NOT auto-refresh`
4. `Do NOT reset needsRefresh`
5. 真正消费它的是 `/reload-plugins -> refreshActivePlugins()`

这说明 `useManagePlugins` 很清楚自己的位置：

`我是提示层，不是闭环消费层。`

所以它可以：

1. 发出“Plugins changed. Run /reload-plugins to activate.”

但它不配：

2. 把 `needsRefresh` 改回 `false`

### 5.2 真正的清理权被交给 `refreshActivePlugins()`

`src/utils/plugins/refresh.ts:59-71,123-138` 更进一步：

1. 这里被定义为 Layer-3 refresh primitive
2. 它负责 full swap：commands、agents、hooks、MCP reconnect trigger、AppState arrays
3. 注释里直接写明：`Consumes plugins.needsRefresh (sets to false)`
4. 实际代码也只有这里把 `needsRefresh: false`

这意味着：

`plugin refresh 痕迹的清理权被严格绑定到真正消费完整刷新闭环的函数上。`

这是极其关键的设计。

因为 Claude Code 很清楚：

`只看到变化，不等于已应用变化。`

所以真正配删掉“待刷新”痕迹的，  
不是看到变化的人，  
而是：

`完成 Layer-3 active component swap 的那条路径。`

## 6. Background installation 说明：auto-refresh 失败时，系统宁可留痕，也不假装成功

`src/services/plugins/PluginInstallationManager.ts:135-165` 非常能说明 Claude Code 的安全态度。

这里逻辑是：

1. 若新 marketplace 安装成功
2. 尝试 `refreshActivePlugins(setAppState)`
3. 若 refresh 成功，闭环被消费
4. 若 refresh 失败，不清理 pending 痕迹
5. 而是 fallback 到 `needsRefresh: true`

注释里写得很直白：

`If auto-refresh fails, fall back to needsRefresh notification so the user can manually run /reload-plugins to recover.`

这说明系统宁可：

1. 保留“还没真正应用”的痕迹
2. 转交手动 repair path

也不愿意：

3. 因为前半段成功就把后半段未完成假装成已完成

这正是安全恢复里最成熟的地方之一。

它保护的不是美观，  
而是：

`恢复承诺的诚实性。`

### 6.1 updates-only 场景也同样不做假清理

同文件 `166-179` 还说明：

1. 如果只是 existing marketplaces updated
2. 也只设置 `needsRefresh: true`
3. 让用户自己决定何时 `/reload-plugins`

也就是说：

`后台改动不配替前台会话宣布“已经生效”。`

## 7. MCP reconnect 说明：重连痕迹只能由连接管理器按终局事件收口

`src/services/mcp/useManageMCPConnections.ts:333-460,1026-1041` 展示了另一种清理边界。

这里管理器对 reconnect timer 的处理很清楚：

1. 新重连前先取消旧 timer
2. disable 发生时停止 retry
3. 成功时删除 timer 并用 `onConnectionAttempt(result)` 收口
4. 最终失败时删除 timer 并写成 `failed`
5. unmount 时统一清理全部 timers 与 batched flush timer

这说明：

`reconnect 痕迹的清理权属于连接管理器，而不属于任意 UI surface。`

尤其重要的是：

1. 没有成功前，不会把 reconnect 痕迹假装清掉
2. 没有终局失败前，也不会把 pending path 提前抹平

这再次体现同一原则：

`只有真正消费完连接闭环的人，才配宣布这一条痕迹可以退出。`

## 8. bridge pointer 说明：恢复资产在“可恢复”时反而必须保留

`src/bridge/bridgeMain.ts` 在这点上尤其值得重视。

### 8.1 fatal 时清，resumable 时留

`1515-1523` 说明：

1. fatal exit 下不应打印 resume command
2. 因为 resume 已不可能
3. 再打印就是 lie / contradict

而 `1573-1576` 又说明：

1. env 已 gone 时，pointer 要清
2. 否则 pointer 会 stale

但 `2700-2728` 同时又说明：

1. 若是 crash-recovery / resumable shutdown
2. pointer 应保留
3. 甚至还要定时刷新
4. 因为它仍是有效恢复资产

这说明 pointer 的清理权不是“尽快删干净”。  
它遵循的宪法恰恰相反：

`当它仍然支撑可恢复真相时，任何局部层都不配把它删掉。`

只有当更高层边界确认：

1. env gone
2. archive+deregister 完成
3. session no longer resumable

时，它才配被清理。

这是一种非常成熟的恢复资产治理。

## 9. 哲学本质：恢复的真正完成，不是“看起来没事了”，而是“控制面允许忘记了”

这是这一章最核心的一句话。

很多系统把恢复理解成：

`症状消失。`

Claude Code 更成熟的理解是：

`只有当真正的控制面 owner 认定闭环已被消费，系统才配忘记。`

这意味着恢复完成至少要满足三个层次：

1. 局部症状回暖
2. 正确 repair path 已被执行
3. 对应 owner 已经消费闭环并收口痕迹

只有第三层到了，  
才算正式完成。

所以：

1. notification 消失，不等于恢复完成
2. auto-refresh 部分成功，不等于 plugin 已正式应用
3. pointer 还在，不等于一定恢复；但 pointer 被清，也不代表谁都配清
4. `needsRefresh=false` 只有在真正 full swap 后才有意义

这说明 Claude Code 的恢复哲学不是：

`尽快把红字擦掉`

而是：

`只在有权威闭环消费者的前提下，合法地忘记失败。`

## 10. 技术先进性：Claude Code 为什么比普通“状态清理”更进一步

普通系统也会做状态清理，  
但 Claude Code 的更深高级性在于四点。

### 10.1 它把 cleanup 视为权限问题，而不是卫生问题

这最关键。

cleanup 在这里不是 housekeeping，  
而是：

`谁配代表当前真相宣布这条失败已不再需要保留。`

### 10.2 它区分提示层与闭环消费层

`useManagePlugins` 只提示，  
`refreshActivePlugins` 才消费。

这条边界非常干净。

### 10.3 它允许“保留痕迹”优先于“看起来顺滑”

auto-refresh 失败时不假成功，  
bridge resumable 时保留 pointer，  
这都说明它接受：

`宁可多留一点痕迹，也不要错误清理。`

### 10.4 它把“不能提前忘记”做成了跨子系统的一致原则

从 notifications 到 plugins 到 MCP 再到 bridge，  
能看到同一个精神：

`忘记失败必须有 owner。`

## 11. 苏格拉底式反思：如果要把这套清理权限边界再推进一代，还缺什么

继续追问，仍然能看到几个可提升点。

### 11.1 清理权限是否已经统一字段化

还没有。

我们能从代码推断：

1. notification owner
2. refresh owner
3. reconnect owner
4. pointer owner

但这些 cleanup authority 还没有被结构化成统一字段。

所以第一个反问是：

`未来统一安全控制台是否应该把 cleanup_owner、cleanup_gate、cleanup_proof 显式做成协议字段？`

### 11.2 “暂时隐藏”和“正式清除”是否已全系统区分

也还不完全。

今天很多地方仍需要靠维护者阅读代码理解：

1. timeout 只是通知退出
2. `needsRefresh=false` 才是消费完成
3. pointer clear 才是恢复资产撤场

所以第二个反问是：

`系统什么时候会把 hidden / dismissed / consumed / cleared / resolved 这些层级彻底做成统一词法协议？`

### 11.3 清理权限是否已被机检

还不够。

如果没有测试明确断言：

1. `useManagePlugins` 不得 reset `needsRefresh`
2. auto-refresh fail 后必须 fallback `needsRefresh=true`
3. fatal exit 不得打印 resumable hint
4. pointer 在 resumable path 不得被提前清除

那这些边界仍可能在重构中被打穿。

所以第三个反问是：

`谁配清理失败痕迹，什么时候配清理，能否被机器持续验证？`

## 12. 本章结论

把 `133` 再推进一层后，  
Claude Code 安全性的更深结构又清楚了一步：

`它不只会撤销旧写权。`

它还会进一步约束：

1. 谁配清理失败痕迹
2. 哪些局部成功信号不配触发清理
3. 哪些恢复资产在“仍有价值”时反而必须保留
4. 哪个 owner 真正消费了闭环后，系统才配忘记

所以如果要真正学习 Claude Code 的安全设计启示，  
最值得学的不是“失败之后怎么更快把界面弄干净”，  
而是：

`把遗忘做成一项必须由闭环所有者授权的特权动作。`

