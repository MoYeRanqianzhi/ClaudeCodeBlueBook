# 安全能力声明主权：为什么不是任何层都配把能力状态说成enabled、pending、connected、active

## 1. 为什么在 `73` 之后还要继续写“能力声明主权”

`73-安全能力恢复主权` 已经回答了：

`能力恢复不是回暖，而是重新授权。`

但如果继续往下追问，  
还会触到一个更贴近用户感知的问题：

`到底谁有资格把能力状态说成 “enabled”、“pending”、“connected”、“active” 或 “failed”？`

因为在 Claude Code 这类系统里，  
能力状态并不是只有一层：

1. 底层连接状态
2. 配置与审批状态
3. 表面可见状态
4. 提示层告警状态

如果低主权表面把高主权状态说得太满，  
那就不是普通文案问题，  
而是：

`声明越权。`

所以在 `73` 之后，  
安全专题必须再补一条原则：

`能力声明主权。`

也就是：

`不是任何层都配把能力状态说成“已连接”“已启用”“可用中”；不同表面只能在自己掌握的事实范围内发言。`

## 2. 最短结论

从源码看，Claude Code 已经把“谁能怎么说能力状态”做成了分层设计：

1. MCP 底层类型先把 server 明确分成 `connected / failed / needs-auth / pending / disabled`  
   `src/services/mcp/types.ts:179-220`
2. IDE 连接 hook 只输出 `connected / pending / disconnected / null` 这种窄声明，而不是自造更满词法  
   `src/hooks/useIdeConnectionStatus.ts:4-32`
3. `/status` 会把 IDE 说成 `Connected to ...`、`Installed ...`、`Not connected ...`，把 MCP 压成 `n connected / n pending / n need auth / n failed` 摘要  
   `src/utils/status.tsx:38-114`
4. bridge footer pill 只允许 `Remote Control active / reconnecting / failed / connecting…` 这套更窄的词，而且 failed 不直接留在 footer pill  
   `src/bridge/bridgeStatusUtil.ts:113-140`  
   `src/components/PromptInput/PromptInputFooter.tsx:173-189`
5. IDE / MCP 通知层又故意说得更弱，只说 `IDE plugin not connected · /status for info`、`install failed (see /status for info)`、`n MCP servers failed · /mcp`、`n need auth · /mcp`  
   `src/hooks/notifs/useIDEStatusIndicator.tsx:83-152`  
   `src/hooks/notifs/useMcpConnectivityStatus.tsx:29-63`

所以这一章的最短结论是：

`能力状态不是单一本体词，而是一套按表面主权分层输出的声明系统。`

我把它再压成一句：

`谁掌握的事实越少，谁就越不配把能力状态说得太满。`

## 3. 源码已经说明：Claude Code 把能力状态声明做成了分层词法

## 3.1 底层类型先定义真相边界：状态枚举不是任意表面都能自由改写

`src/services/mcp/types.ts:179-220` 很关键。

这里底层 `MCPServerConnection` 直接被拆成：

1. `connected`
2. `failed`
3. `needs-auth`
4. `pending`
5. `disabled`

这说明系统并不是让各个表面自己随便发明：

`almost ready`
`temporarily unavailable`
`kind of connected`

而是先由 authoritative type layer 给出受约束状态集。

也就是说，  
表面层的自由度不是“随便解释”，  
而是：

`在给定状态集之上按自己的 lexical ceiling 进行受限投影。`

## 3.2 IDE 基础 hook 已经在刻意保持窄声明

`src/hooks/useIdeConnectionStatus.ts:4-32` 更进一步。

这个 hook 并不输出复杂文案，  
而只输出：

1. `connected`
2. `pending`
3. `disconnected`
4. `null`

它甚至没有把安装、选择上下文、错误提示、提示词法混进去。

这说明基础 hook 的职责不是：

`替所有上层界面下结论`

而是：

`提供一组窄而稳定的语义基元。`

这正是声明主权里的一个重要原则：

`基础层应当生产状态，不应越权生产满语义。`

## 3.3 `/status` 拥有更高声明权，因为它掌握更完整的上下文

`src/utils/status.tsx:38-114` 展示了另一层。

这里 `/status` 对 IDE 和 MCP 的说法明显更丰富：

IDE:

1. `Connected to ... extension`
2. `Installed ...`
3. `Not connected to ...`

MCP:

1. `n connected`
2. `n need auth`
3. `n pending`
4. `n failed`

并且 MCP 还被压成统计摘要，而不是逐 server 断言。

这说明 `/status` 在这里掌握的，不只是单个 client status，  
而是：

1. 安装信息
2. server counts
3. 失败/认证/连接的汇总盘点

因此它配说得比 notification 和 footer 更完整。

换句话说：

`更完整的上下文，才配更完整的能力声明。`

## 3.4 bridge footer pill 明显被限制在更窄的声明 ceiling

`src/bridge/bridgeStatusUtil.ts:113-140` 把 bridge label 强行收窄为四类：

1. `Remote Control failed`
2. `Remote Control reconnecting`
3. `Remote Control active`
4. `Remote Control connecting…`

但 `src/components/PromptInput/PromptInputFooter.tsx:173-189` 更有意思。

这里作者明确写了：

`Failed state is surfaced via notification, not a footer pill.`

并且对于 implicit remote，  
甚至只显示 `reconnecting`。

这说明 footer pill 的角色不是：

`成为完整状态面`

而是：

`在极窄空间里输出最保守、最不易误导的词。`

也就是说，  
footer 拥有的是最弱的一类声明主权。  
它不配承担完整失败解释权。

## 3.5 通知层同样故意说得更弱，只负责提醒，不负责完整定义

`src/hooks/notifs/useIDEStatusIndicator.tsx:83-152` 很值得注意。

这里通知层说的是：

1. `${ideName} disconnected`
2. `IDE plugin not connected · /status for info`
3. `IDE extension install failed (see /status for info)`

`src/hooks/notifs/useMcpConnectivityStatus.tsx:29-63` 对 MCP 也是类似：

1. `n MCP servers failed · /mcp`
2. `n claude.ai connectors unavailable · /mcp`
3. `n servers need auth · /mcp`

这类通知的共同特征是：

1. 只报异常
2. 只给粗粒度分类
3. 强制把用户导向 `/status` 或 `/mcp`

这说明 notification 层明确知道：

`自己只有提醒权，没有完整声明权。`

因此它不会说：

`server X 现在处于完整的 capability state Y`

而只说：

`你该去 authoritative surface 看。`

## 3.6 第一性原理：状态词不是标签，而是权限

如果从第一性原理追问：

`为什么系统要把能力状态词法分得这么细？`

因为在安全控制面里，  
状态词本身不是装饰，  
而是：

`一种解释权限。`

一个表面一旦说出：

`connected`
`active`
`installed`
`needs auth`

它实际上就在声明：

`我已经掌握了足够事实，足以替你总结当前能力边界。`

所以能力声明主权的第一性原理可以压成一句：

`status words are permissions.`

进一步展开，就是：

1. 不掌握完整上下文，就不该说完整状态词
2. 不掌握失败根因，就不该说完整失败结论
3. 不掌握 capability publish set，就不该说“现在可用”

## 4. 苏格拉底式自问：为什么不能所有表面都直接复用同一套满词

### 4.1 同一套词不是更一致吗

表面一致不等于语义一致。

如果 footer、notification、`/status`、底层 hook 都复用同一句：

`已连接`

那用户看起来像是“一致”，  
实际上却失去了：

`它们各自掌握事实范围不同`

这一关键信息。

### 4.2 为什么通知层不直接说满一点，省得用户跳转

因为通知层的职责是抢注意力，  
不是承载完整状态账本。

它一旦说得太满，  
就会越权把 alert surface 冒充成 authoritative surface。

### 4.3 为什么 footer 不能直接显示 failed 细节

因为 footer 的空间最窄，  
也最容易制造过度压缩后的误导。

所以成熟系统宁可把 failed 分流到 notification，  
也不把复杂失败硬塞进一个短 pill。

### 4.4 为什么基础 hook 只给枚举，不直接给文案

因为一旦基础 hook 直接下结论，  
上层表面就很难再按自己的主权边界降级表达。

保持基础层窄语义，  
才能让高层表面按各自 ceiling 说话。

## 5. 技术先进性与技术启示

这一章最重要的技术判断是：

`Claude Code 的先进性不只在于它定义了很多状态，而在于它把“谁有资格说哪种状态词”也纳入了安全设计。`

它先进的地方有六点：

1. 先用类型层固定状态枚举，再让各表面做受限投影
2. `/status`、notification、footer 各自有不同 lexical ceiling
3. 失败说明被有意分流到更合适的 surface，而不是所有层都说满
4. 通知层大量使用 “see /status” 与 “· /mcp” 这种转介语法
5. bridge footer 对 implicit remote 甚至进一步降低声明强度
6. 系统在实践中把“状态词说得多满”当作一个需要收口的设计问题

对其他 Agent 平台构建者的直接启示有六条：

1. 把 status enum 和 user-facing lexicon 分开建模
2. 不同 surface 必须有不同的 lexical ceiling
3. alert surface 应优先负责告警和转介，不要强行承担完整解释
4. 空间越窄、上下文越少的 surface，越应该克制
5. “connected / active / available” 这类正向词都应受主权约束
6. 设计评审时必须单独问：这个表面现在配说到哪一步

## 6. 一条硬结论

对 Claude Code 这类安全控制面来说，  
真正危险的不是状态词太少，  
而是：

`掌握局部事实的表面，却在替系统说完整真相。`

所以比“发布-撤回-恢复主权”再深一层的原则是：

`能力状态的命名权，本身也是一项受限的安全主权。`
