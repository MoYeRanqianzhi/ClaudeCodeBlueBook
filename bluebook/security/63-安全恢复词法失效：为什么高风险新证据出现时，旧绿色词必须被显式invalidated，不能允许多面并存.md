# 安全恢复词法失效：为什么高风险新证据出现时，旧绿色词必须被显式invalidated，不能允许多面并存

## 1. 为什么在 `62` 之后还要继续写“词法失效”

`62-安全恢复词法仲裁` 已经回答了：

`当通知、卡片、摘要与 footer 同时说话时，系统必须仲裁谁能代表当前真相。`

但如果继续往下一层追问，  
还会出现一个更偏运行时机制的问题：

`当更强的新证据出现时，旧词是自动失效，还是继续留在界面上和它并存？`

因为仲裁只解决了：

`冲突时谁更应该被相信。`

但它还没有解决：

`旧的弱词是否应该继续存在。`

如果一个系统没有正式的“词法失效”规则，  
就会出现非常危险的局面：

1. 弱绿色词还挂着
2. 新的高风险通知也出来了
3. 用户同时看到“似乎还行”和“其实出错了”
4. 控制面把真假冲突外包给用户自己做融合

所以在 `62` 之后，  
统一安全控制台还必须再补一条制度：

`恢复词法失效。`

也就是：

`当更高风险或更高主权的新证据出现时，旧的弱词必须被显式 invalidated、remove 或降级，而不是继续与之并存。`

## 2. 最短结论

从源码看，Claude Code 已经拥有不少“词法失效”的局部机制，  
但还没有把它们统一提升为跨 surface 的正式纪律：

1. `notifications.tsx` 原生支持 `invalidates`、`removeNotification()`、priority 抢占与 `fold`  
   `src/context/notifications.tsx:78-212`
2. `useIDEStatusIndicator.tsx` 会在状态切换时显式 `removeNotification(...)`，让旧 hint / 旧 disconnected / 旧 install-error 失效  
   `src/hooks/notifs/useIDEStatusIndicator.tsx:49-154`
3. `PromptInput/Notifications.tsx` 里 external editor hint 会在条件不满足时被移除，voice mode 甚至会直接替换所有通知前景  
   `src/components/PromptInput/Notifications.tsx:147-170,281-286`
4. `PromptInputFooter.tsx` 明确把 failed state 从 footer pill 分流出去，不让它与弱状态同层并存  
   `src/components/PromptInput/PromptInputFooter.tsx:173-189`

所以这一章的最短结论是：

`Claude Code 已经知道旧词不能永远留着，但这条纪律目前更多是局部实现，还缺一套跨面统一的词法失效规则。`

我会把这条结论再压成一句话：

`真相更新不只需要新词出现，还需要旧词退场。`

## 3. 源码已经证明：系统内部多处都在做“旧词失效”

## 3.1 notification 内核已经把 invalidation 做成正式对象

`src/context/notifications.tsx:78-212` 很关键。  
这里不只是一个简单的 toast 容器，  
而是一套正式的词法失效机制：

1. 新 `immediate` 通知会抢占当前
2. `invalidates` 可以让旧 notification 失效
3. `removeNotification(key)` 可以显式撤销某个旧词
4. `fold` 可以用新内容覆盖旧内容，而不是并存

这说明在 notification 这一层，  
系统已经非常清楚：

`旧词不是永远有效的；新证据出现后，旧词应被替换、撤销或合并。`

## 3.2 IDE 通知层已经实践了条件变化 -> 旧词撤销

`src/hooks/notifs/useIDEStatusIndicator.tsx:49-154` 连续几段 `useEffect` 都在做同一件事：

1. 当环境不再满足 hint 条件时，`removeNotification("ide-status-hint")`
2. 当 disconnected 条件不再成立时，`removeNotification("ide-status-disconnected")`
3. 当 JetBrains 特例不再成立时，`removeNotification("ide-status-jetbrains-disconnected")`
4. 当 install error 不再成立时，`removeNotification("ide-status-install-error")`

这说明作者已经接受了一条很强的纪律：

`旧提示在失去语义前提后，不应继续悬挂。`

这其实就是恢复控制面需要的词法失效原则的雏形。

## 3.3 前景模式切换也已经在做“整层替换”

`src/components/PromptInput/Notifications.tsx:147-170` 里，  
external editor hint 在条件不满足时会被移除。

更强的是 `src/components/PromptInput/Notifications.tsx:281-286`：  
当 voice mode 处于 recording / processing，  
组件会直接返回 `VoiceIndicator`，  
也就是：

`替换整个通知前景。`

这说明系统已经知道一种更强的失效模式：

`不是只删单条旧词，而是让一个更高优先级前景整体接管当前叙述面。`

这对恢复控制面的启示很直接：

`高风险或高主权词法出现时，也应该能整体压掉旧的弱词前景。`

## 3.4 footer 已经用“失败分流”避免弱词与强风险词并存

`src/components/PromptInput/PromptInputFooter.tsx:173-189` 里有一句特别关键的注释：

`Failed state is surfaced via notification, not a footer pill.`

这说明 bridge footer 已经在实践一条重要纪律：

1. footer 只保留低占位弱词
2. 一旦进入 failed 这类更强风险语义
3. 就不该再让 footer 继续装作是常态状态 pill

也就是说，  
当前系统至少已经在 bridge 域承认：

`高风险词出现时，弱状态词必须让位。`

## 4. 第一性原理：真相更新的本质不是叠加新词，而是重写当前词法空间

如果从第一性原理追问：

`为什么词法失效要单独上升成一条原则？`

因为控制面更新真相时，  
实际发生的不是：

`多知道了一点。`

而是：

`旧的解释空间被新的更强证据重写了。`

如果系统只会添加新词，  
不会撤销旧词，  
它就会把不同时间点、不同强度、不同主权层的解释全部堆到一起。  
这等价于让用户自己做：

`版本合并`

而这正是控制面本应替用户完成的工作。

这条原则可以压成一句话：

`真相更新必须伴随旧解释失效。`

## 5. 我给统一安全控制台的“词法失效模型”

我会把它压成四条规则。

## 5.1 更高风险词必须能 invalidates 更弱绿色词

例如：

1. `failed`
2. `needs auth`
3. `install error`
4. `disconnected`

出现时，  
同域旧的：

1. `active`
2. `connected`
3. `ready`

必须被降级、隐藏或撤销。

## 5.2 同域旧词失效应显式而非默会

不要指望用户自己推断：

`哦，既然有一条错误提示，那前面的 active 大概不算数了。`

系统应显式：

1. remove
2. invalidate
3. fold
4. 降词

## 5.3 跨面冲突时，弱面板要能自动让位

footer、badge、summary 这类弱叙述面，  
在冲突时应能：

1. 暂时沉默
2. 改口
3. 退成更弱词

而不是继续和 notification 平行争夺解释权。

## 5.4 resolved 出现前，所有较弱绿色词都应接受“随时失效”

只要更高层 signer 尚未完成 explanation closure，  
任何绿色词都不应被设计成稳定不可撤销。

## 6. 技术先进性与技术启示

这一章最重要的技术判断是：

`Claude Code 的先进性不只在于它有 notification invalidates，而在于很多局部实现已经承认“新证据应让旧词退场”；下一步真正需要的是把这条纪律从局部习惯升级成跨面规则。`

当前先进的地方：

1. notification invalidates/fold/remove 已是正式机制
2. IDE 通知层已经按条件变化移除旧词
3. footer 已经知道 failed 不该和普通状态 pill 同层并存

当前仍待系统化的地方：

1. 这种失效规则还没有统一扩展到所有 surface
2. 旧绿色词的降级/撤销仍缺统一 grammar
3. 缺少“高风险词出现时弱词必须退场”的跨面协议

这对其他 Agent 平台构建者的直接启示有五条：

1. 把 invalidation 设计成一等对象，而不是零散 if/else
2. 把 notification 的 invalidates 语义扩展到 card / badge / footer / summary
3. 给绿色词设计明确的 revocation path
4. 让同域不同 surface 共享同一张 lexical invalidation table
5. 让用户看到的是“当前有效解释”，而不是“历史解释的并集”

## 7. 哲学本质

这一章更深层的哲学是：

`一个诚实的系统，不只会说新话，还会承认旧话已经失效。`

很多系统不是真的不知道真相变了，  
而是：

`懒得把旧的解释收回。`

于是它们把“知识更新”的成本，  
转嫁给了用户的认知整合能力。  
这不是透明，  
而是：

`把仲裁责任外包给用户。`

## 8. 苏格拉底式反思：这一章最需要追问什么

### 8.1 为什么不能让旧绿色词先留着，等用户自己理解

因为控制面的职责就是替用户做解释收敛，而不是展示冲突原料。

### 8.2 如果 notification 已经足够显眼，为什么还要撤销其他旧词

因为“看见了新风险”不等于“系统已经收回旧承诺”。

### 8.3 真正危险的错误是什么

不是界面有两句不同的话，  
而是：

`旧的弱承诺在更强风险出现后仍被保留，继续污染当前真相。`


## 9. 结语

`62` 回答的是：当多个界面同时发声时，必须仲裁谁代表当前真相。  
这一章继续推进后的结论则是：

`当更强的新证据出现时，旧的弱词还必须被显式失效，不能继续留在界面上与之并存。`

这意味着 Claude Code 更深层的安全启示之一是：

`成熟控制面不仅要会添加新解释，还要会撤销旧解释。`
