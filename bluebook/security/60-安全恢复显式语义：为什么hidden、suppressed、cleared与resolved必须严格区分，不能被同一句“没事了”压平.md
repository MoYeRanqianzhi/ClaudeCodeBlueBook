# 安全恢复显式语义：为什么hidden、suppressed、cleared与resolved必须严格区分，不能被同一句“没事了”压平

## 1. 为什么在 `59` 之后还要继续写“显式语义”

`59-安全恢复隐藏权与删除权` 已经回答了：

`提示消失、卡片转绿与摘要收缩都不等于正式 trace 已被安全清除。`

但如果继续往下一层追问，  
还会出现一个更偏产品语义、却同样具有安全后果的问题：

`既然“没显示了”不等于“已删除”，那控制面到底该用什么词来区分这些状态？`

因为一个成熟系统最终不能只靠工程师脑内记忆来维持边界。  
它必须把这些差别变成：

1. 可写入的状态语义
2. 可审查的界面文案
3. 可迁移的设计规则

如果做不到这一点，  
系统就会不断把完全不同的对象压成同一句：

`没事了`

而这会让下面这些语义全部互相污染：

1. hidden  
   当前前景不显示，但对象仍然存在
2. suppressed  
   当前被更高优先级对象或模式暂时压住
3. cleared  
   authoritative writer 已把正式 trace 清空
4. resolved  
   更高层 explanation signer 已确认问题真正闭环

所以在 `59` 之后，  
统一安全控制台还必须再补一条制度：

`恢复显式语义。`

也就是：

`控制面必须把 hidden、suppressed、cleared、resolved 做成不同语义层，而不能继续复用一个模糊的“已恢复”或“没事了”。`

## 2. 最短结论

从源码看，Claude Code 已经有了这套显式语义的零件，但还没有完全产品化成一张统一词法表：

1. `useTasksV2` 把 hidden 明确定义成：snapshot 返回 `undefined`，但内部 cache 仍保留  
   `src/hooks/useTasksV2.ts:49-55,123-185`
2. `Messages.tsx` 直接维护 `hiddenMessageCount`，明确告诉用户“这些消息是被隐藏，不是被删除”  
   `src/components/Messages.tsx:522-528,681-689`
3. `PromptInput/Notifications.tsx` 又展示了 suppressed / replaced 的语义：voice mode 可以暂时接管全部通知前景  
   `src/components/PromptInput/Notifications.tsx:147-163,281-286`
4. `sessionState.ts` 与 `ccrClient.ts` 才真正展示 cleared 语义：`pending_action: null`、`task_summary: null`、stale metadata 清理  
   `src/utils/sessionState.ts:99-116`、`src/cli/transports/ccrClient.ts:476-520`
5. 而 resolved 仍是更高层对象，需要对应 signer 与解释闭环才能成立  
   `49`-`59` 主线归纳

所以这一章的最短结论是：

`Claude Code 的实现已经隐含区分了 hidden、suppressed、cleared 与 resolved，但产品层仍需要把这四类词法显式做成制度。`

我会把这条结论再压成一句话：

`语义不显式，边界就会被文案重新压坏。`

## 3. 源码已经提供了四类不同语义的原型

## 3.1 hidden：对象暂时不暴露，但内部缓存和未来恢复价值仍在

`src/hooks/useTasksV2.ts:49-55` 很关键。  
这里 `getSnapshot()` 明确规定：

1. 当 `#hidden` 为真时，返回 `undefined`
2. 但内部 `#tasks` 并没有立即丢失

同文件 `src/hooks/useTasksV2.ts:123-185` 更进一步说明：

1. 所有任务完成后不会立刻清空
2. 会先进入 hide timer
3. 只有确认 `allStillCompleted` 后才 `resetTaskList()`
4. 即便最后一个 subscriber 退订，也会保留 `#tasks/#hidden cache`

这说明 hidden 在当前系统里已经不是“删除”的同义词，  
而是：

`当前读者看不到，但对象与其未来价值仍然存在。`

这是一个非常成熟的安全语义原型。

## 3.2 suppressed：对象被更高优先级模式或前景临时压住

`src/components/PromptInput/Notifications.tsx:281-286` 说明，  
当 voice mode 处于 recording / processing，  
组件会直接返回 `VoiceIndicator`，  
从而替换通知前景。

这不是 cleared，  
也不是 resolved。  
它更接近：

`suppressed`

也就是：

1. 旧通知并未被重新定义成“问题已解决”
2. 只是当前前景必须优先显示另一个对象
3. 一旦模式结束，原有通知逻辑仍会继续参与前景仲裁

`src/components/PromptInput/Notifications.tsx:147-163` 中 external editor hint 的 add/remove 也属于同类语义：  
这是当前前景的显隐，不是正式账本的生死。

## 3.3 cleared：authoritative writer 明确把正式对象清成 null 或替换掉

`src/utils/sessionState.ts:99-116` 与 `src/cli/transports/ccrClient.ts:476-520` 一起给出了 cleared 的正式定义。

这里发生的不是：

`前景不再显示`

而是：

1. `pending_action` 被写成 `null`
2. `task_summary` 被写成 `null`
3. prior crash 留下的 stale metadata 在 worker init 时被正式清理

这说明 cleared 是一种更重的动作：

`它必须由 authoritative writer 在正式账本上发生。`

只有到了这一步，  
系统才有资格说：

`这个正式 trace 已经被清掉了。`

## 3.4 resolved：更高层结论已获得解释闭环

resolved 则比 cleared 还要更高一层。

因为即便：

1. 某个 prompt hint 已 hidden
2. 某个前景对象已 suppressed
3. 某个 metadata 字段已被 cleared

也仍然不自动意味着：

`控制面可以恢复绿色结论`

resolved 需要的是：

1. 相应 trace 已经过正式 writer 清理
2. 替代证据足够强
3. 更高层 signer 已完成 explanation closure

所以 resolved 永远不能由低层 UI 状态直接代理。

## 3.5 Messages 组件其实已经在教系统如何诚实地说“隐藏了”

`src/components/Messages.tsx:522-528,681-689` 很值得注意。  
这里没有把被 render cap 压下去的消息说成“删掉了”，  
而是显式维护：

`hiddenMessageCount`

并明确展示：

1. `show ... previous messages`
2. `hide ... previous messages`

这说明 Claude Code 的另一部分实现已经意识到：

`hidden` 本身就是一等语义，应该被诚实命名。

如果恢复控制面也沿用这套思路，  
很多“表层安静 = 系统恢复”的误读会直接减少。

## 4. 第一性原理：系统最危险的不是状态多，而是把不同语义压成同一个词

如果从第一性原理追问：

`为什么恢复控制面必须显式区分这些词？`

因为不同语义承担的责任不同：

1. hidden 保护的是当前视图秩序
2. suppressed 保护的是注意力优先级
3. cleared 保护的是正式账本一致性
4. resolved 保护的是更高层解释正确性

一旦把它们压成同一个词，  
系统就会同时损坏四个边界：

1. 用户不知道对象只是没显示，还是已经清掉
2. 产品无法审查某条文案是否越级
3. 开发者容易把低层状态变化误用成高层恢复签字
4. 控制面最终退化成“谁声音大谁定义当前真相”

所以恢复显式语义真正保护的是这条公理：

`不同责任层的状态，必须有不同词。`

## 5. 我给统一安全控制台的恢复语义词法

我会把它压成四个必须保留的词。

## 5.1 hidden

定义：

`当前读者或当前视图不再展示该对象，但对象本身与其恢复价值仍在。`

禁止误说：

1. 已清除
2. 已解决

## 5.2 suppressed

定义：

`对象被更高优先级模式、提示或前景暂时压住，但并未失去资格。`

禁止误说：

1. 已完成
2. 已关闭

## 5.3 cleared

定义：

`authoritative writer 已在正式账本中把该对象清空、替换或终结。`

禁止误说：

1. 全链已恢复
2. 风险已消失

## 5.4 resolved

定义：

`对应恢复链与解释链都已闭环，更高层 signer 允许撤警、转绿或恢复动作可用性。`

这是唯一一个接近“真的没事了”的词。

## 6. 技术先进性与技术启示

这一章最重要的技术判断是：

`Claude Code 的先进性不只在于分层控制面，还在于它的很多实现已经把“hidden 不等于 deleted”编码进了具体对象。`

先进之处在于：

1. `useTasksV2` 明确把 hidden 做成 cache-preserving state
2. `Messages.tsx` 明确把 hidden count 做成正式 UI 对象
3. `sessionState.ts` / `ccrClient.ts` 明确把 cleared 绑定到 authoritative writer

但仍未完全成型的地方在于：

1. 系统还没有统一输出 hidden / suppressed / cleared / resolved 词法
2. 不同界面仍可能把这些状态压成同一句绿色或静默文案
3. 用户仍要自己推理“现在看不到”究竟属于哪一类

这对其他 Agent 平台构建者的直接启示有五条：

1. 把 visibility 语义与 ledger 语义分开编码
2. 把 hidden 和 cleared 当成不同类型，而不是同一个布尔
3. 对 summary / badge / status line 采用比 authoritative ledger 更弱的词法
4. 给 resolved 预留更高层 signer，不让低层 transport 文案越级
5. 把“当前不显示”做成显式、可审查的状态，而不是静默实现细节

## 7. 哲学本质

这一章更深层的哲学是：

`一个系统只有在能够诚实地区分“我没展示”“我压住了它”“我真的清掉了”“我确认解决了”时，才算真正尊重真相。`

很多产品表面上是状态太少，  
本质上是：

`它们不愿意承认自己知道的其实没有那么多。`

于是系统就会偷懒地把不同确定性等级压成同一种安抚性文案。  
这不是简洁，  
而是：

`对真相层级的逃避。`

## 8. 苏格拉底式反思：这一章最需要追问什么

### 8.1 为什么不能继续只用“已恢复”这种宽词

因为这会把 hidden、cleared、resolved 三层全部压平。

### 8.2 如果用户已经不需要看见它了，为什么还要保留 hidden / suppressed 语义

因为当前不展示和正式不存在是两件完全不同的事。

### 8.3 真正危险的是什么

不是词太多，  
而是：

`不同责任层的状态共用同一个词，最终让低层对象越级替高层对象签字。`

### 8.4 这一章之后还缺什么

还缺一张更短的词法矩阵：

`hidden -> suppressed -> cleared -> resolved`

也就是说，  
下一步最自然的延伸就是：

`appendix/44-安全恢复显式语义速查表`

## 9. 结语

`59` 回答的是：隐藏权与删除权必须分离。  
这一章继续推进后的结论则是：

`只有把 hidden、suppressed、cleared、resolved 做成不同词法，控制面才能避免再被一句“没事了”压坏。`

这意味着 Claude Code 更深层的安全启示之一是：

`成熟控制面不仅需要正确对象和正确 signer，还需要正确词汇。`
