# 安全能力声明仲裁：当status、notification、footer与hook同时说话时，谁有资格代表当前能力真相

## 1. 为什么在 `74` 之后还要继续写“能力声明仲裁”

`74-安全能力声明主权` 已经回答了：

`不是任何表面都配把能力状态说得一样满。`

但如果继续追问，  
还会碰到一个更棘手、也更接近真实产品运行态的问题：

`当多个 surface 同时说话，而且说法还不完全一致时，到底谁算数？`

因为在 Claude Code 里，  
能力状态不是只出现在一个地方：

1. 底层 type / hook 会先给出窄状态
2. `/status` 与 `/mcp` 会给出盘点摘要
3. notification 会抢占当前注意力
4. footer pill 会维持低占位连续反馈

一旦这些表面并存，  
系统就不能只回答“每层最多能说到哪”，  
还必须继续回答：

`冲突出现时，谁负责抢注意力，谁负责下结论，谁必须让位。`

所以在 `74` 之后，  
安全专题必须再补一条更下沉但更实战的原则：

`能力声明仲裁。`

也就是：

`多表面同时描述同一能力时，系统必须把“注意力优先级”和“真相解释权”分开治理；不是谁先冒出来，谁就更接近真相。`

## 2. 最短结论

从源码看，Claude Code 已经把这件事做成了两条并行规则，而不是一条简单总排序：

1. notification queue 负责 `attention arbitration`，用 `immediate / high / medium / low` 决定谁先抢到用户眼睛  
   `src/context/notifications.tsx:45-76,78-117,172-191,230-239`
2. bridge footer 明确让出 failed 解释权，作者直接写明失败状态应走 notification，而不是 footer pill  
   `src/components/PromptInput/PromptInputFooter.tsx:173-189`
3. bridge 真遇到失败时，也确实发的是 `priority: 'immediate'` 的 `Remote Control failed` 通知  
   `src/hooks/useReplBridge.tsx:102-111`
4. IDE 通知层内部还做了更细的冲突让位：只要 install error 或 JetBrains plugin 未连接成立，就撤掉 generic disconnected 提示  
   `src/hooks/notifs/useIDEStatusIndicator.tsx:78-152`
5. `/status` 与 `/mcp` 不抢“先声夺人”，却拥有更高的用户态解释权，因为通知层反复把用户导向 `/status for info` 与 `/mcp`  
   `src/hooks/notifs/useIDEStatusIndicator.tsx:119-152`  
   `src/hooks/notifs/useMcpConnectivityStatus.tsx:29-63`  
   `src/utils/status.tsx:38-114`
6. hook / type layer 又继续约束上层不得越词，因为它们先把原始状态集收窄为 `connected / pending / disconnected / failed / needs-auth ...` 这类基础真相  
   `src/hooks/useIdeConnectionStatus.ts:4-32`  
   `src/services/mcp/types.ts:179-220`

所以这一章的最短结论是：

`Claude Code 没有把“谁最显眼”误当成“谁最权威”。`

我把它再压成一句：

`notification 赢的是注意力，/status 赢的是解释权，footer 只配保留不与风险冲突的连续性弱词。`

## 3. 源码已经说明：Claude Code 把“谁先提醒”和“谁能定性”故意拆开了

## 3.1 notification queue 解决的是“谁先被看见”，不是“谁代表最终真相”

`src/context/notifications.tsx:45-76`、`78-117`、`172-191` 与 `230-239` 非常关键。

这里通知系统做了四件事：

1. 统一维护 `current + queue`
2. 用 `getNext(...)` 按 `immediate / high / medium / low` 选下一个通知
3. `immediate` 可以直接顶掉当前通知
4. `invalidates` 可以显式使旧通知失效

这说明 notification lane 的职责是：

`决定当前哪条风险最值得先让用户看到。`

但它并没有说：

`当前这条通知就是最完整的能力真相。`

换句话说，  
notification queue 管的是：

`attention arbitration`

而不是：

`semantic truth arbitration`

这是 Claude Code 很成熟的一点。  
很多系统会把“当前显示中的 banner”误当成“当前系统真相”。  
Claude Code 至少在结构上没有这样混。

## 3.2 bridge 的处理最能说明：高风险否定词必须赢可见性，但不必长期占据 footer

`src/components/PromptInput/PromptInputFooter.tsx:173-189` 里有一句非常重要的注释：

`Failed state is surfaced via notification (useReplBridge), not a footer pill.`

而 `src/hooks/useReplBridge.tsx:102-111` 则把这条原则真正落成了代码：

1. bridge 失败时发送 `bridge-failed`
2. 文案是 `Remote Control failed`
3. 优先级是 `immediate`

这说明在 bridge 这个子系统里，  
作者明确区分了两种权力：

1. footer pill 的低占位连续反馈权
2. notification 的紧急失败显化权

因此即便 `getBridgeStatus(...)` 仍然定义了 `Remote Control failed` 这一词法，  
真正的 UI 仲裁却是：

`失败不留在弱占位 pill 里，而要抢到 notification 前景。`

这本质上是在说：

`否定性高风险状态必须先赢注意力，再谈后续解释。`

## 3.3 IDE 通知层内部也有自己的仲裁梯度：更具体原因压过更粗症状

`src/hooks/notifs/useIDEStatusIndicator.tsx:78-152` 很值得细看。

这里 generic 的：

`{ideName} disconnected`

并不是总会出现。  
只要更具体的两类情况存在：

1. install error
2. JetBrains plugin not connected

系统就会先 `removeNotification("ide-status-disconnected")`，  
然后改为更具体的提示：

1. `IDE plugin not connected · /status for info`
2. `IDE extension install failed (see /status for info)`

这说明通知层内部也不是“谁都能同时挂出来”。  
它已经在做一个更细的局部仲裁：

`更具因果指向性的词，应压过更泛化的症状词。`

也就是说，  
在同一 attention lane 里，  
Claude Code 也在尽量避免：

`generic symptom 抢走了 specific root-cause 的解释位置。`

## 3.4 `/status` 与 `/mcp` 才是用户态解释面的正式 handoff 终点

`src/hooks/notifs/useIDEStatusIndicator.tsx:119-152` 与 `src/hooks/notifs/useMcpConnectivityStatus.tsx:29-63` 都反复把用户导向：

1. `/status for info`
2. `/mcp`

而 `src/utils/status.tsx:38-114` 又确实证明 `/status` 拿到的是更完整的输入：

1. IDE 安装信息
2. IDE 连接信息
3. MCP server counts
4. `connected / need auth / pending / failed` 的聚合摘要

这说明 notification 自己知道自己的角色边界：

`我负责打断你，不负责替系统完成最终解释。`

因此真正的跨面仲裁不是：

`notification 永远赢 /status`

而是：

`notification 赢“先看我”，/status 赢“最终去哪里确认”。`

这是本章最重要的区分。

## 3.5 footer 之所以必须输，不是因为它不重要，而是因为它只配承担 continuity semantics

`src/bridge/bridgeStatusUtil.ts:123-140` 把 footer 可见桥接词法收敛成：

1. `Remote Control reconnecting`
2. `Remote Control active`
3. `Remote Control connecting…`
4. `Remote Control failed`

但真正挂到 footer 时，  
`src/components/PromptInput/PromptInputFooter.tsx:173-189` 又立刻做了二次仲裁：

1. failed 不在 footer 显示
2. implicit remote 连一般状态都不全显示，只保留 `reconnecting`

这说明 footer 的角色不是“代表完整真相”，  
而是：

`在不打扰主交互的前提下保留最保守的连续性状态。`

所以它一旦和 notification 冲突，  
或者和更高主权解释面冲突，  
就必须输。

因为 footer 真正保护的不是解释完整性，  
而是：

`低摩擦持续感知。`

## 3.6 `Notifications.tsx` 进一步证明：当前通知占的是主动态槽，但仍不是全部状态面

`src/components/PromptInput/Notifications.tsx:286-330` 显示得很清楚：

1. `IdeStatusIndicator` 先单独渲染
2. `notifications.current` 再占据当前通知槽
3. 后面才是 overage、token、auto-updater、memory 与 sandbox hint

这说明 footer 区域里，  
notification 当前项确实拥有更高的动态可见性。  
但同一组件也保留了很多其他状态面同时存在。

作者并没有把通知 current 设计成：

`把所有别的状态全部抹平的唯一真相层`

而是把它放在一个更准确的位置：

`高优先级动态状态插槽。`

这再次说明 Claude Code 真正在做的是：

`多表面协作 + 明确仲裁`

而不是：

`单面垄断真相。`

## 3.7 第一性原理：能力声明仲裁的本质，是把“误导成本”按表面重新分配

如果从第一性原理追问：

`为什么系统不能让所有表面都输出同一套结论，再靠用户自己理解？`

因为不同表面的误导成本根本不一样：

1. notification 误把低风险说成高风险，成本主要是打扰
2. footer 误把高风险说成低风险，成本是让用户错过失败
3. `/status` 误把局部状态说成全局状态，成本是让用户走错修复路径
4. hook / type 误放宽底层词法，成本是所有上层一起越权

因此成熟系统不会只做“统一文案”，  
而会做：

`按误导成本分配不同表面的发言权。`

Claude Code 在这里的设计哲学可以压成一句：

`最该先防的是危险的假绿词，而不是界面上出现多个状态入口。`

## 4. 能力声明仲裁的最短规则

把这一章压成最短规则，就是下面五句：

1. type / hook 先定义 lexical ceiling，防止所有上层乱说
2. notification 负责抢占注意力，不负责完成最终解释
3. `/status` 与 `/mcp` 负责聚合解释，不负责像 notification 一样抢位
4. footer 只能保留不与高风险冲突的 continuity semantics
5. 一旦出现冲突，系统必须显式 handoff，而不是让低主权表面继续并存装没事

## 5. 苏格拉底式追问：这套设计还能怎样再向前推进

如果继续自问，  
这套设计仍然还有三个可改进点：

1. 当前源码已经有通知优先级，但还没有把 `semantic authority level` 做成显式字段；这会让评审仍需跨文件推理
2. `/status` 与 notification 已有 handoff 文案，但缺一张统一的 cross-surface authority map，宿主适配者仍可能误抄错层文案
3. footer 当前靠注释与局部判断让位，若下一代控制台要更强一致性，最好把“必须让位给谁”做成表驱动规则

所以这一章最终收束出的不是抱怨，  
而是一条可迁移启示：

`多表面系统真正成熟的标志，不是状态都能显示出来，而是每个表面都知道自己什么时候必须闭嘴。`
