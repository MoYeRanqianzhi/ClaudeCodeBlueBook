# 安全遗忘投影规则：为什么cleanup字段不应平均撒到所有surface，而必须按带宽、责任与解释权分层投影

## 1. 为什么在 `136` 之后还必须继续写“投影规则”

`136-安全遗忘协议字段` 已经回答了：

`如果 Claude Code 想把 cleanup audit 做成正式能力，就必须把 cleanup_owner、cleanup_reason、cleanup_gate、cleanup_replaced_by 与 cleanup_audit_id 之类语义升级成结构化字段。`

但如果继续追问，  
还会碰到另一个同样关键的问题：

`字段一旦存在，是否应被所有 surface 平权看到？`

答案同样是否定的。

因为同一条 cleanup 语义如果被不加区分地撒给：

1. notification 前景
2. footer pill
3. `/status` 摘要
4. dialog 细节面
5. SDK host

这些完全不同带宽、责任和解释权的 surface，  
就会立刻产生新的风险：

`弱 surface 过度解释强真相，强 surface 却被压缩成贫血摘要。`

所以 `136` 之后必须继续补出的下一层就是：

`安全遗忘投影规则`

也就是：

`cleanup 字段必须被分层投影，而不是被平均广播。`

## 2. 最短结论

Claude Code 当前的源码虽然还没有结构化 cleanup fields，  
但它已经通过不同 surface 的设计，透露出一条很明确的投影分层规律：

1. `Notifications` 只适合承载短促前景与 action hint，不适合背完整 cleanup 因果  
   `src/components/PromptInput/Notifications.tsx:147-163,281-292`
2. footer pill 只适合承载极窄 operational status，不适合承载 cleanup reason / gate  
   `src/components/PromptInput/PromptInputFooter.tsx:173-189`
3. `/status` 明确倾向聚合摘要，而不是展开全部服务器/恢复细节  
   `src/utils/status.tsx:95-114`
4. `BridgeDialog` 明显更接近 authoritative detail surface，能够承载 statusLabel、error、environmentId、QR 等细节  
   `src/components/BridgeDialog.tsx:137-240`
5. SDK `system:init` / `system:status` 已经具备结构化 runtime state surface，但目前还没容纳 cleanup protocol  
   `src/entrypoints/sdk/coreSchemas.ts:1457-1542`

所以这一章的最短结论是：

`cleanup 协议字段不是“有没有”的问题，还必须继续回答“该落在哪一层看见”。`

再压成一句：

`结构化之后，下一步不是平均展示，而是分层投影。`

## 3. 第一性原理：为什么安全字段一旦进入协议，就必须继续进入“投影宪法”

字段化只解决了一半问题。

它解决的是：

`系统终于有了正式语言。`

但它还没有解决：

`不同观察者究竟配听到多少。`

如果所有观察者都平权看到同一份最强 cleanup 语义，  
会有两个后果：

1. 弱 surface 过度解释，前景被信息洪泛
2. 强 surface 被迫照顾最窄带宽，结果失去真正的解释能力

所以从第一性原理看，  
字段化之后必然紧跟着要解决：

1. 哪个 surface 只配看到摘要
2. 哪个 surface 配看到 cleanup owner
3. 哪个 surface 配看到 cleanup gate
4. 哪个 surface 配看到 cleanup reason
5. 哪个 surface 只配拿到 `cleanup_replaced_by`

这就是投影规则。

换句话说：

`协议决定真相可以被说成什么，投影决定不同层各自最多配说到哪里。`

## 4. 当前源码已经暗示出的 surface 分层

### 4.1 Notification 层只适合最短前景，不适合背完整 cleanup 叙事

`src/components/PromptInput/Notifications.tsx:147-163` 很典型：

1. external editor hint 只在满足条件时发一条短通知
2. 条件失效时直接 `removeNotification("external-editor-hint")`

而 `281-292` 又说明：

1. voice mode 一旦 recording/processing
2. 整个 notification 区甚至会被 `VoiceIndicator` 直接替换

这表明 notification 层的本质是：

`高时效、低带宽、强前景的注意力路由层`

这种层如果未来承载 cleanup fields，  
最适合看到的只会是：

1. `cleanup_replaced_by`
2. 非常短的 `cleanup_reason` 摘要
3. 行动提示

而不适合看到：

4. `cleanup_gate`
5. `cleanup_owner`
6. `cleanup_audit_id`

因为它并不具备承载完整因果的空间。

### 4.2 Footer pill 天生是更窄的 operational projection

`src/components/PromptInput/PromptInputFooter.tsx:173-189` 更能说明这点。

这里 `BridgeStatusIndicator`：

1. 只显示 `status.label`
2. 选中时最多加一句 `Enter to view`
3. failed state 根本不在 footer pill 上表达，而是交给 notification

这意味着 footer pill 的角色非常明确：

`它不是解释层，它只是操作入口提示层。`

所以如果 cleanup fields 未来要进入 footer，  
它最多只适合承载：

1. `cleanup_replaced_by`
2. “有更详细 cleanup 信息可查看”的 affordance

而不能承载：

3. `cleanup_gate`
4. `cleanup_owner`
5. 长 `cleanup_reason`

否则这个层会立刻失真。

### 4.3 `/status` 被明确设计成 summary，而不是明细账本

`src/utils/status.tsx:95-114` 的注释写得很直接：

1. 20+ servers 的 full list 会把状态面撑爆
2. 所以这里改成按 state 的 counts summary
3. 再加一个 `/mcp` hint

这说明 `/status` 的角色不是 authoritative trace ledger，  
而是：

`聚合摘要层`

因此 cleanup fields 未来进入 `/status` 时，  
最自然的只会是：

1. 是否存在 pending cleanup
2. cleanup counts by category
3. 是否有需要进入 detail surface 的未消费 cleanup

而不是逐条摊开 cleanup cause。

### 4.4 `BridgeDialog` 明显更接近 authoritative detail surface

`src/components/BridgeDialog.tsx:137-240` 则是另一端。

这里 dialog 会承载：

1. `statusLabel`
2. `statusColor`
3. footer text
4. `error`
5. `environmentId`
6. QR lines
7. context suffix

也就是说：

`BridgeDialog` 天然就是细节面。`

如果 cleanup fields 被引入，  
这里就是最适合承载：

1. `cleanup_reason`
2. `cleanup_gate`
3. `cleanup_replaced_by`
4. cleanup 是否仍 pending

的地方。

### 4.5 SDK host surface 已经具备结构化承载能力，但缺 cleanup fields

`src/entrypoints/sdk/coreSchemas.ts:1457-1542` 很关键。

这里已经有：

1. `system:init`
2. `system:status`
3. structured arrays for `mcp_servers`, `plugins`, `permissionMode`

这说明 SDK host 并不是只能吃纯文本。  
它已经有正式的 structured runtime state surface。

也正因为如此，  
cleanup protocol 若未来字段化，  
SDK host 其实是最适合直接拿到完整 cleanup metadata 的 surface 之一。

但现在还没有。

这恰好构成了一个很清楚的缺口：

`最适合承载结构化 cleanup 语义的面，当前却没有这套字段。`

## 5. 为什么平均撒字段会造成新的安全失真

### 5.1 弱 surface 会过度解释

如果把 `cleanup_gate=layer3_swap_completed`、`cleanup_owner=refresh_active_plugins`  
这类信息直接塞进 notification / footer，  
用户感受到的不会是解释力上升，  
而是：

`前景层突然开始说它本不配说的强语义。`

这会让弱 surface 从提示层滑向 overclaim。

### 5.2 强 surface 会被弱 surface 拖窄

相反，  
若为了兼容弱 surface 而只保留最粗字段，  
则 dialog / SDK host 这种本来有能力承载更完整 cleanup semantics 的 surface  
也会被一起压扁。

结果就是：

`哪里都能看，但哪里都看不全。`

这正是最坏结果。

## 6. 下一代 cleanup projection 最值得采用的分层

基于当前源码结构，  
最合理的 cleanup projection 分层至少应是这样：

### 6.1 Notification / footer

只显示：

1. 极短 `cleanup_replaced_by`
2. 必要时的一句 `cleanup_reason` 摘要
3. “Enter to view” 或跳转提示

### 6.2 `/status`

显示：

1. cleanup category counts
2. 当前是否存在 deferred cleanup
3. 当前是否存在 unresolved cleanup debt

### 6.3 Dialog / detail panes

显示：

1. `cleanup_reason`
2. `cleanup_gate`
3. `cleanup_replaced_by`
4. 当前 cleanup stage

### 6.4 SDK / host structured surface

显示：

1. `cleanup_owner`
2. `cleanup_reason`
3. `cleanup_gate`
4. `cleanup_replaced_by`
5. `cleanup_audit_id`

因为 host 是最适合做自定义审计、UI 和 automation 的层。

## 7. 技术先进性：Claude Code 的下一步不只是“加字段”，而是“让字段按层说话”

这也是这一章最核心的技术启示。

很多团队一旦决定字段化，  
下一步就会犯另一个错误：

`所有地方都展示同一批字段。`

Claude Code 当前不同 surface 的源码设计已经说明这不是好路。

正确的下一步应该是：

1. 先字段化
2. 再定义 projection ceilings
3. 再定义 per-surface must-show / optional / forbidden fields

这才是从日志化走向产品化的完整路径。

## 8. 哲学本质：真相不是平均分发的，真相必须按责任分发

这一章真正的哲学核心是：

`同一条真相，不同观察者并不天然配看见同样多。`

这并不是隐藏，  
而是责任分层。

Notification 的责任是：

`让你立刻注意到该注意的事。`

Footer 的责任是：

`给你一个极窄 operational cue。`

Dialog 的责任是：

`让你理解当前这一面真正发生了什么。`

SDK host 的责任是：

`以结构化方式承载可以继续计算和投影的真相。`

所以：

`真相不是平均分发的，真相是按责任分发的。`

## 9. 苏格拉底式反思：如果要把 cleanup projection 再推进一代，还缺什么

继续追问，还能看到三个明显缺口。

### 9.1 缺 explicit per-surface cleanup field policy

今天我们可以从代码推断各 surface 的带宽差异，  
但还没有正式的：

1. must-show
2. may-show
3. forbidden-to-show

策略表。

### 9.2 缺 host-facing cleanup projection schema

SDK schemas 已经有足够空间，  
但 cleanup fields 还没进入。

### 9.3 缺 cleanup projection tests

如果未来真的加字段，  
就必须测：

1. notification 不会展示过强 cleanup cause
2. footer 不会越权宣布 cleanup finality
3. dialog 能看到完整 detail
4. SDK host 能拿到 structured cleanup payload

## 10. 本章结论

把 `136` 再推进一层后，  
Claude Code 安全性的下一步产品化方向就更清楚了：

`cleanup fields 不是加了就完。`

它们还必须继续被：

1. 分层投影
2. 责任分发
3. 带宽约束
4. projection ceiling 治理

所以如果要真正学习 Claude Code 的安全设计启示，  
最值得学的不是“把所有 cleanup 语义都展示出来”，  
而是：

`把 cleanup 真相做成结构化字段之后，再让不同 surface 只看见它们配看见的那一层。`

