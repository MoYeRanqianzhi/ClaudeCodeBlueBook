# 安全恢复隐藏权与删除权：为什么提示消失、卡片转绿与摘要收缩都不等于正式trace已被安全清除

## 1. 为什么在 `58` 之后还要继续写“隐藏权与删除权”

`58-安全恢复清理门槛` 已经回答了：

`即便清理者正确，也必须等到对应闭环证据足够强才允许删除痕迹。`

但如果继续往下一层追问，  
还会出现一个非常容易被产品和实现同时搞混的问题：

`一个痕迹不再显示了，究竟是被隐藏了，还是被正式删除了？`

因为在多层控制面里，  
“看不见”有很多种原因：

1. 提示被 timeout 或更高优先级提示覆盖
2. 当前 UI 模式切换，旧提示被临时让位
3. 卡片或状态栏把复杂状态压成一句摘要
4. transport 只恢复了 write-readiness，表层却已经能显示 `connected`

如果把这些“隐藏”都误读成“删除”，  
系统就会犯一种更深的错误：

`把表层注意力路由，误说成底层恢复账本已经被安全清理。`

所以在 `58` 之后，  
统一安全控制台还必须再补一条制度：

`隐藏权与删除权分离。`

也就是：

`能让用户暂时看不见某个痕迹的层，不自动拥有删除该痕迹正式恢复意义的权力。`

## 2. 最短结论

从源码看，Claude Code 已经把这两类权力天然分到了不同层：

1. `PromptInput/Notifications.tsx` 会根据局部谓词显示或移除提示，voice mode 甚至会直接用语音指示器替换全部通知  
   `src/components/PromptInput/Notifications.tsx:147-163,281-286`
2. `BridgeDialog.tsx` 只消费 `connected/sessionActive/reconnecting/error` 这类压缩状态，再生成 `statusLabel` 与 footer  
   `src/components/BridgeDialog.tsx:137-205`
3. `status.tsx` 会把 IDE / MCP 状态压成几句摘要或几个计数  
   `src/utils/status.tsx:38-114`
4. 但 `replBridgeTransport.ts` 明确说明 `isConnectedStatus()` 只是 write-readiness，不是 read-readiness  
   `src/bridge/replBridgeTransport.ts:289-299,336-366`
5. 真正承担正式 trace 写入与清除的是 `sessionState.ts` 与 `ccrClient.ts`：`pending_action`、`task_summary`、`worker_status`、delivery status 都在这里被 authoritative 地写回或清空  
   `src/utils/sessionState.ts:92-130`、`src/cli/transports/ccrClient.ts:476-520,644-663,764-785,964-990`

所以这一章的最短结论是：

`表层组件大多只有隐藏权，正式恢复 trace 的删除权在更深层账本作者和 signer 手里。`

我会把这条结论再压成一句话：

`visibility change 不是 trace deletion。`

## 3. 源码已经证明：Claude Code 的很多表层组件只拥有“隐藏权”

## 3.1 PromptInput 通知层可以让提示消失，但这只改变前景，不改变正式事实

`src/components/PromptInput/Notifications.tsx:147-163` 里，  
external editor hint 会在条件满足时 `addNotification(...)`，  
条件不满足时直接：

`removeNotification("external-editor-hint")`

同文件 `src/components/PromptInput/Notifications.tsx:281-286` 更进一步：  
当 voice mode 处于 recording 或 processing，  
组件会直接用 `VoiceIndicator` 替换全部 notifications。

这说明通知前景的消失，  
可能只是因为：

1. 当前 hint 条件失效
2. 当前 UI 模式切换
3. 当前注意力必须让位给更高优先级对象

也就是说，  
在这个层级里发生的是：

`visible surface 的切换`

不是：

`正式恢复 trace 的删除`

## 3.2 BridgeDialog 与 `/status` 更像投影层，而不是 trace owner

`src/components/BridgeDialog.tsx:137-205` 显示，  
BridgeDialog 会把：

1. `connected`
2. `sessionActive`
3. `reconnecting`
4. `error`

压成：

1. `statusLabel`
2. `statusColor`
3. footer text

而 `src/utils/status.tsx:38-114` 又把 IDE / MCP 状态进一步压成：

1. `Connected to IDE extension`
2. `Installed ...`
3. `Not connected`
4. `n connected / n pending / n failed`

这类组件当然有产品价值，  
但它们真正拥有的是：

`投影权`

而不是：

`正式删除恢复 trace 的权力`

因为它们消费的是压缩后的输入，  
并不负责定义：

1. 某条 trace 是否仍承担恢复职责
2. 某条 trace 是否已被替代证据完整覆盖
3. 某条 trace 是否已跨过 retry / resume / manual-confirmation window

## 3.3 `connected` 文案本身就不是恢复闭环证据

`src/bridge/replBridgeTransport.ts:289-299` 直接写得很清楚：

`isConnectedStatus()` 是：

`Write-readiness, not read-readiness`

而 `src/bridge/replBridgeTransport.ts:336-366` 又说明：

1. write path ready 与 SSE read stream open 是并行但不同的事
2. initialize 失败会走 `onClose(4091)`
3. epoch mismatch 也会主动关闭并回退

这意味着表层 UI 一旦把某种 `connected` 投影说得太满，  
就很容易把：

`局部活性恢复`

误说成：

`完整恢复闭环已成立`

所以这段源码反过来证明了：

`显示在线` 不等于 `trace 已可删除`

## 3.4 正式 trace 的写入与清空发生在更深的 authoritative 层

`src/utils/sessionState.ts:92-130` 很关键。  
这里的 `notifySessionStateChanged(...)` 会：

1. 在 `requires_action` 时把 `pending_action` 写入 `external_metadata`
2. 在下一个非 blocked transition 时用 `pending_action: null` 把它清掉
3. 在 `idle` 时清 `task_summary`
4. 还把 `session_state_changed` 镜像进 SDK event stream

`src/cli/transports/ccrClient.ts:476-520,644-663,764-785,964-990` 则进一步说明：

1. worker init 时会清 prior crash 留下的 stale `pending_action/task_summary`
2. `reportState()` / `reportMetadata()` 是正式写回口
3. stream / internal events 要经过 flush 和 uploader
4. delivery status 还会单独上报 `received/processing/processed`

这说明真正的 trace 删除不是“某个组件不再显示它”，  
而是：

`authoritative writer 在正式账本里把它清成 null、替换掉、或用更高强度事件关闭它。`

## 4. 第一性原理：隐藏权服务于当下注意力，删除权服务于未来恢复能力

如果从第一性原理追问：

`为什么隐藏权和删除权必须拆开？`

因为这两者服务的目标根本不同。

隐藏权服务的是：

`当前前景应该把用户注意力放在哪里。`

删除权服务的是：

`未来系统还能不能依靠这条 trace 做重试、回访、解释、去重和恢复。`

所以一条痕迹即便暂时不该占据前景，  
也完全可能仍然必须留在正式账本里。

这条原则可以压成更短的一句：

`前景安静，不代表后景失忆。`

## 5. 我给统一安全控制台的“隐藏权与删除权模型”

我会把它分成四层。

## 5.1 L0 可见性层

对象：

1. toast
2. hint
3. footer 提示

能力：

1. 显示
2. 覆盖
3. timeout
4. 暂时隐藏

不能做的事：

1. 删除正式恢复账本里的 trace
2. 宣布恢复闭环已完成

## 5.2 L1 投影摘要层

对象：

1. BridgeDialog
2. `/status`
3. 计数摘要

能力：

1. 重命名
2. 压缩
3. 分级显示
4. 给出默认入口

不能做的事：

1. 用压缩后文案替代 authoritative state
2. 替更高层 signer 删除 trace

## 5.3 L2 正式 trace 层

对象：

1. `pending_action`
2. `task_summary`
3. `worker_status`
4. delivery status

能力：

1. authoritative 写入
2. authoritative 清空
3. 为恢复链保留未来可用证据

## 5.4 L3 解释关闭层

对象：

1. 高层解释结论
2. blindspot 结论
3. 是否允许转绿、撤警、恢复动作可用性

只有这一层才配把：

`表层看起来好了`

翻译成：

`正式可以忘记了`

## 6. 技术先进性与技术启示

这一章最重要的技术判断是：

`Claude Code 的底层恢复设计比表层文案更成熟。`

成熟之处在于：

1. authoritative writer 已经存在
2. `pending_action` / `task_summary` / delivery status 已有正式清理口
3. transport 层明确区分 write-ready 与更完整的 read / lifecycle 状态

但它的产品表层仍有继续改进空间，  
因为：

1. 通知层仍会因为模式切换而整体让位
2. BridgeDialog 与 `/status` 仍会压缩多个不同强度的状态
3. 用户仍然可能把“没显示了”误读成“已经删掉了”

这对其他 Agent 平台构建者的直接启示有四条：

1. UI 层应显式区分 hidden、suppressed、cleared 三种语义
2. 摘要层不应复用与 authoritative ledger 同强度的绿色词
3. transport readiness、state readiness、effect readiness 不应共用一个 `connected`
4. 正式 trace 清理口必须被设计成可追踪、可证明的账本动作

## 7. 哲学本质

这一章更深层的哲学是：

`安全系统真正要避免的，不只是错误删除事实，还包括用“当前没看到”来伪装“事实已经不存在”。`

很多系统不是没有保留 trace，  
而是把 trace 藏到了用户不再能正确理解的位置。  
于是系统虽然没有真的删，  
但在用户认知上已经等价于：

`被删了。`

Claude Code 当前源码最值得肯定的地方，  
是底层 author/ledger discipline 已经很强；  
最值得继续推进的地方，  
则是把这种 discipline 显式产品化，  
让系统不仅“没删”，  
还要让用户知道：

`它只是没展示，不是已经不存在。`

## 8. 苏格拉底式反思：这一章最需要追问什么

### 8.1 如果一个提示已经消失，用户为什么还需要知道正式 trace 仍在

因为后续 retry、resume、explanation 和 delayed consumer 仍可能依赖它。

### 8.2 为什么 UI 简化会变成安全问题

因为一旦简化跨过了语义边界，  
用户就会把“当前前景”误认成“全局真相”。

### 8.3 真正危险的不是哪种 bug

不是某个提示多留了几秒，  
而是：

`系统把隐藏动作伪装成删除动作，把摘要动作伪装成闭环动作。`

### 8.4 这一章之后还缺什么

还缺一张更短的分层矩阵：

`surface hider -> projection owner -> trace writer -> explanation closer`

也就是说，  
下一步最自然的延伸就是：

`appendix/43-安全恢复隐藏权与删除权速查表`

## 9. 结语

`58` 回答的是：正确 owner 也必须等到正确 threshold。  
这一章继续推进后的结论则是：

`即便一个对象在界面上已经消失，也不等于正式恢复 trace 已被安全删除。`

这意味着 Claude Code 更深层的安全启示之一是：

`成熟控制面不仅要限制谁能删、何时能删，还要诚实地区分“没显示”与“已删除”。`
