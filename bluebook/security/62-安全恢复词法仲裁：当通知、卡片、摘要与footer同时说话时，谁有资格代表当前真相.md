# 安全恢复词法仲裁：当通知、卡片、摘要与footer同时说话时，谁有资格代表当前真相

## 1. 为什么在 `61` 之后还要继续写“词法仲裁”

`61-安全恢复词法主权` 已经回答了：

`不是每个界面都能随意命名恢复状态；不同组件必须服从同一套命名主权。`

但如果继续往下一层追问，  
还会出现一个更动态、更接近运行时的问题：

`当多个界面同时在说话，而且说的强度不一样时，谁的话算数？`

因为控制面不是静态文章，  
而是一个多入口、同时发生的界面系统。  
同一时刻用户可能同时看到：

1. notification
2. status pane 摘要
3. footer pill
4. bridge dialog

如果这些入口对同一恢复事实给出不同强度表达，  
系统就不能只说：

`它们都大致对。`

它必须进一步回答：

`当词法冲突时，谁是当前真相的优先代表？`

所以在 `61` 之后，  
统一安全控制台还必须再补一条制度：

`恢复词法仲裁。`

也就是：

`不同入口不只要服从同一套词法，还必须在冲突时有明确的优先级规则，避免弱风险入口被强绿色词盖住。`

## 2. 最短结论

从源码看，Claude Code 已经拥有一套很强的“注意力仲裁”，  
但还缺一套同等正式的“真相词法仲裁”：

1. `notifications.tsx` 已经把 `immediate / high / medium / low`、`current / queue`、`invalidates` 做成正式注意力优先级  
   `src/context/notifications.tsx:78-212`
2. `useIDEStatusIndicator.tsx` 与 `useMcpConnectivityStatus.tsx` 会把错误、断连、needs-auth 推进 notification 轨道  
   `src/hooks/notifs/useIDEStatusIndicator.tsx:78-154`、`src/hooks/notifs/useMcpConnectivityStatus.tsx:24-74`
3. 与此同时，`status.tsx` 仍会给出更平的摘要盘点  
   `src/utils/status.tsx:38-114`
4. `bridgeStatusUtil.ts` 与 footer 又会给出另一个压缩后的 bridge 词法  
   `src/bridge/bridgeStatusUtil.ts:113-150`、`src/components/PromptInput/PromptInputFooter.tsx:173-189`
5. `BridgeDialog.tsx` 还会再生成一套 dialog 内部 status label 与 footer text  
   `src/components/BridgeDialog.tsx:137-210`

所以这一章的最短结论是：

`Claude Code 已经有 attention arbitration，但还需要把 lexical arbitration 正式做出来，防止多个 surface 同时对恢复状态说出不同强度的话。`

我会把这条结论再压成一句话：

`谁先占据注意力，不等于谁有资格定义真相。`

## 3. 源码已经显示：系统在“注意力”上有仲裁，在“真相”上还主要靠约定

## 3.1 notification 系统已经是一台成熟的注意力仲裁机

`src/context/notifications.tsx:78-212` 很关键。  
这里已经正式实现了：

1. `immediate` 抢占当前通知
2. 非 immediate 进入 queue
3. `invalidates` 可以使旧提示失效
4. `fold` 可以合并同 key 提示
5. `removeNotification` 只移除指定 key

也就是说，  
当前系统非常清楚地知道：

`谁该先被用户看到。`

这是一套成熟的 UI 注意力治理。

## 3.2 但 notification 的优先级并不自动等于恢复真值优先级

问题在于，  
attention priority 和 truth priority 不是一回事。

`useIDEStatusIndicator.tsx:78-154` 会把：

1. `disconnected`
2. `plugin not connected`
3. `install failed`

推成 medium priority 通知。

`useMcpConnectivityStatus.tsx:24-74` 则把：

1. `mcp failed`
2. `needs auth`
3. `connector unavailable`

也推成 medium priority。

这些通知非常适合抢占注意力，  
但它们本身并不天然拥有“定义当前最终恢复结论”的资格。  
否则系统就会把：

`最响的提示`

误当成：

`最有资格代表当前真相的对象`

## 3.3 `/status`、footer、dialog 又提供了三套较弱但更稳定的叙述面

`src/utils/status.tsx:38-114` 负责的是盘点与摘要。  
它会输出：

1. `Connected to ...`
2. `Installed ...`
3. `Not connected`
4. `n connected / n pending / n failed`

`src/components/PromptInput/PromptInputFooter.tsx:173-189` 则只在 footer 中保留一部分 bridge 状态，  
而且明确把 failed 分流给 notification。

`src/components/BridgeDialog.tsx:137-210` 又会在 dialog 内显示：

1. `statusLabel`
2. `statusColor`
3. `footerText`

这说明当前系统已经天然拥有多层叙述面：

1. 抢注意力的 notification
2. 做摘要的 `/status`
3. 做持续低占位的 footer
4. 做局部细节展开的 dialog

问题是：

`它们之间缺的不是 UI 组件，而是词法冲突时的裁决规则。`

## 3.4 bridge 域最能说明为什么需要显式词法仲裁

bridge 域现在尤其容易出现“同时多说”的情况。

`bridgeStatusUtil.ts:135-140` 会给出：

1. `Remote Control failed`
2. `Remote Control reconnecting`
3. `Remote Control active`
4. `Remote Control connecting...`

其中最关键的问题是：

`sessionActive || connected -> active`

这本身已经是一种较强压缩。

与此同时：

1. footer pill 还会进一步裁掉 failed  
   `PromptInputFooter.tsx:173-189`
2. dialog 会再给出 active / idle 风格 footer text  
   `BridgeDialog.tsx:185-210`
3. notification 又可能同时呈现 error / reconnecting 的抢占信息

如果没有词法仲裁，  
用户就很可能在同一轮里同时接收到：

1. 一个更强的绿色/正向词
2. 一个更抢眼的错误提示
3. 一个更平的状态摘要

这时系统必须回答：

`到底哪个才代表“当前该信什么”。`

## 4. 第一性原理：恢复控制面必须同时仲裁“谁先被看见”和“谁更接近真相”

如果从第一性原理追问：

`为什么注意力仲裁还不够？`

因为控制面有两个不同维度：

1. attention order  
   谁先被看见
2. truth precedence  
   谁更接近真相

这两者可以重合，  
但不能被默认当成同一个排序。

一个系统如果只有注意力仲裁，  
就会把：

`最紧急`

误当成：

`最真实`

一个系统如果只有真相仲裁，  
又会把重要风险埋进深层，不被看见。

所以成熟控制面必须同时拥有：

1. 注意力优先级
2. 词法真值优先级

## 5. 我给统一安全控制台的“词法仲裁模型”

我会把它压成四条规则。

## 5.1 抢注意力的 surface 不自动赢得真值解释权

notification 可以抢到当前前景，  
但如果它只是动作导向提醒，  
它的词法 ceiling 仍低于更高层 signer。

## 5.2 冲突时按“风险优先、真值就近、绿色从严”裁决

当多个 surface 同时存在时：

1. 高风险否定性结论优先覆盖弱绿色词
2. 更接近账本的 surface 优先于纯摘要 surface
3. 绿色词必须最保守，只有在高层 signer 到位时才可保留

## 5.3 summary 可以继续存在，但必须被标记成低主权叙述

`/status`、footer、badge 这类 surface 可以继续输出简短表达，  
但它们必须在冲突时：

1. 降级
2. 改口
3. 让位给更高优先级风险词法

## 5.4 dialog / console / card 应承担“解释补全”而不是“重新发明真相”

细节面板的职责不是再造一套新语言，  
而是把更高层已确定的词法解释展开。

## 6. 技术先进性与技术启示

这一章最重要的技术判断是：

`Claude Code 的先进性在于它已经把注意力仲裁实现得相当成熟；下一步真正稀缺的提升，是把词法仲裁也做成与通知系统同等级的正式机制。`

当前先进的地方：

1. notification queue/current/invalidates/fold 已很成熟
2. 多个 surface 已自然分化出不同职责
3. 某些组件已经明确只展示状态子集

当前仍待系统化的地方：

1. 不同 surface 冲突时谁的话算数还没有正式规则
2. `active / connected / installed / failed / needs auth` 的跨面冲突缺统一裁决
3. 风险词和绿色词之间还缺正式的跨面抑制/降级语法

这对其他 Agent 平台构建者的直接启示有五条：

1. 把 attention router 和 truth router 分开设计
2. 给每个 surface 配一个 lexical authority level
3. 让高风险否定词可以抑制低主权绿色词
4. 让 summary / footer 支持冲突时自动降级
5. 把 notification invalidates 的思想扩展到跨 surface 词法失效规则

## 7. 哲学本质

这一章更深层的哲学是：

`真相不是由最响亮的界面定义的。`

很多系统在 UI 上已经有优先级，  
却在认识论上仍然停留在：

`谁先出现、谁更显眼，谁就暂时代表事实。`

这是一种危险的偷懒。  
因为用户看到的不是界面实现细节，  
而是系统对现实的声明。

所以真正成熟的控制面必须承认：

`注意力是一种调度权，真相是一种裁决权。`

## 8. 苏格拉底式反思：这一章最需要追问什么

### 8.1 为什么通知优先级已经很成熟，系统仍可能误导用户

因为通知优先级解决的是“看哪里”，不是“信谁”。

### 8.2 如果多个 surface 都只说了一部分真话，为什么还不够

因为用户接收到的是合成后的整体叙述，而不是组件内部局部正确性的平均值。

### 8.3 真正危险的是什么

不是界面有多个入口，  
而是：

`这些入口在冲突时没有真相仲裁规则。`


## 9. 结语

`61` 回答的是：恢复词法需要主权边界。  
这一章继续推进后的结论则是：

`当多个界面同时发声时，系统还必须有一套词法仲裁规则，决定谁能代表当前真相。`

这意味着 Claude Code 更深层的安全启示之一是：

`成熟控制面不仅要仲裁注意力，还要仲裁真相。`
