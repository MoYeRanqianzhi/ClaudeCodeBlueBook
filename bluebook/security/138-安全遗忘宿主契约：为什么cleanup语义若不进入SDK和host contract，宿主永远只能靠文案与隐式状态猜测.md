# 安全遗忘宿主契约：为什么cleanup语义若不进入SDK和host contract，宿主永远只能靠文案与隐式状态猜测

## 1. 为什么在 `137` 之后还必须继续写“宿主契约”

`137-安全遗忘投影规则` 已经回答了：

`cleanup 字段即便被定义出来，也不应平均撒到所有 surface，而必须按带宽、责任与解释权分层投影。`

但如果继续追问，  
还会碰到一个更深的问题：

`哪些 surface 才真正有资格承载“完整 cleanup 真相”？`

答案并不是普通 UI 组件。  
真正最强的承载层其实是：

`SDK / host contract`

因为只有进入 contract 的 cleanup 语义，  
才真正具有：

1. 可被宿主正式消费
2. 可被自动化与集成系统正式消费
3. 可被 machine-check 与 schema 演进正式守护

所以 `137` 之后必须继续补出的下一层就是：

`安全遗忘宿主契约`

也就是：

`cleanup 语义若不进入 SDK 和 host contract，宿主永远只能靠文案、计数和隐式状态猜测恢复是否被合法消费。`

## 2. 最短结论

Claude Code 当前已经拥有相当成熟的宿主协议基础：

1. `system:init` 能把 `mcp_servers`、`plugins`、`permissionMode` 结构化给宿主  
   `src/entrypoints/sdk/coreSchemas.ts:1457-1493`
2. `system:status` 已经是结构化状态消息  
   `src/entrypoints/sdk/coreSchemas.ts:1533-1542`
3. `reload_plugins` control response 也会返回 commands、agents、plugins、`mcpServers`、`error_count`  
   `src/entrypoints/sdk/controlSchemas.ts:405-432`
4. `mcp_status` 也有单独 response schema  
   `src/entrypoints/sdk/controlSchemas.ts:157-173`
5. 甚至 `task_notification`、`post_turn_summary` 都已经是正式消息类型  
   `src/entrypoints/sdk/coreSchemas.ts:1544-1569,1694-1712`

但 cleanup 语义仍然缺席：

1. `system:init` 的 `mcp_servers` 只有 `name/status`
2. `plugins` 只有 `name/path/source`
3. `reload_plugins` response 没有 `needsRefresh` 的消费依据
4. `mcp_reconnect` / `mcp_toggle` request 也没有 cleanup semantics 的 response

所以这一章的最短结论是：

`Claude Code 已经有 host contract，却还没有 cleanup contract。`

再压成一句：

`宿主今天能看见状态，却还看不见状态是如何被合法忘记的。`

## 3. 第一性原理：为什么 cleanup 语义若不进 contract，就永远只是本地实现细节

从第一性原理看，  
真正的“宿主能力”不是代码里有，  
而是：

`协议里有。`

只要 cleanup 语义还停留在：

1. 本地 debug log
2. 本地 UI 组件
3. 本地注释
4. 本地状态位的隐式组合

那么对宿主来说，  
这些东西都仍然只是：

`实现细节`

宿主只能观察到：

1. 某个值变了
2. 某个状态消失了
3. 某个列表更新了

却不知道：

4. 是谁消费了 cleanup 闭环
5. 为什么允许清理
6. 旧痕迹被什么替代
7. 这次变化是 resolved 还是 merely hidden

所以：

`cleanup 语义要想成为真正可集成能力，最终必须进入 host contract。`

## 4. 当前 SDK surface 已经足够成熟，恰恰反衬 cleanup contract 的缺席

### 4.1 `system:init` 已经在发结构化运行时装配态

`src/entrypoints/sdk/coreSchemas.ts:1457-1493` 说明：

1. `system:init` 会发 `mcp_servers`
2. 会发 `plugins`
3. 会发 `permissionMode`
4. 会发 `tools`、`skills`、`slash_commands`

这意味着宿主不是只能收到欢迎文本。  
它已经能拿到：

`当前运行时装配态快照`

但这个快照对 cleanup 来说仍然太弱。

例如：

1. `mcp_servers` 只有 `name/status`
2. 没有 `cleanup_reason`
3. 没有 `cleanup_replaced_by`
4. 没有任何 cleanup provenance

### 4.2 `system:status` 已经在发结构化状态，却仍没有 cleanup depth

`1533-1542` 进一步说明：

1. `system:status` 已经是结构化系统消息
2. status 本身有专门 schema

也就是说：

`Claude Code 已经承认“状态变化值得被正式发消息给宿主”。`

但仍未承认：

`cleanup 变化也值得被正式发给宿主。`

这就造成一个很奇怪的落差：

1. 宿主知道当前 status
2. 却不知道 status 背后的 cleanup 是否已被 authoritative owner 消费

### 4.3 `reload_plugins` response 已经很接近 cleanup contract，却停在半步

`src/entrypoints/sdk/controlSchemas.ts:405-432` 很关键。

这里 `reload_plugins` response 已经会给：

1. `commands`
2. `agents`
3. `plugins`
4. `mcpServers`
5. `error_count`

这已经几乎是一个 cleanup-consumed response 了。

但它仍缺：

1. 这次是否消费了 `needsRefresh`
2. `cleanup_owner`
3. `cleanup_gate`
4. `cleanup_reason`
5. 是否仍有 residual cleanup debt

换句话说：

`宿主能看见结果，却看不见结果为何足以清理旧痕迹。`

### 4.4 `mcp_status`、`mcp_reconnect`、`mcp_toggle` 也都缺 cleanup semantics

`157-173`、`435-452` 说明：

1. `mcp_status` 只返回 `mcpServers`
2. `mcp_reconnect` / `mcp_toggle` 只有 request schema

这意味着宿主可以发动作，  
也能拿到某些状态，  
但还没有办法正式知道：

1. reconnect 后旧 pending trace 是否已消费
2. toggle 后旧 failure/pending path 是否被 authoritative disable 取代
3. 当前 transition 属于 hide、clear、replace，还是 merely defer

## 5. 反过来看，其他语义已经被正式 contract 化了，这更说明 cleanup contract 的缺位

### 5.1 `post_turn_summary` 已经是正式结构化语义

`src/entrypoints/sdk/coreSchemas.ts:1544-1569` 说明：

1. `post_turn_summary` 有 `status_category`
2. 有 `status_detail`
3. 有 `needs_action`
4. 有 `artifact_urls`

这说明 Claude Code 已经接受一种设计哲学：

`不是所有解释都该停留在文案，某些解释本来就配结构化。`

### 5.2 `task_notification` 也已经结构化

`1694-1712` 说明：

1. `task_notification` 有 `status`
2. 有 `output_file`
3. 有 `summary`
4. 还有 optional `usage`

也就是说：

`任务完成/失败语义，已经进入 host contract。`

这就更凸显 cleanup 语义的落差：

`完成语义被 contract 化了，遗忘语义却还停留在局部推断。`

## 6. 为什么这会成为真正的宿主集成问题

### 6.1 宿主今天无法区分“状态没了”与“状态被合法清了”

如果 cleanup 不进 contract，  
宿主只能看到：

1. 某个 notification 不见了
2. 某个 `needsRefresh` 不再为 true
3. 某个 pointer 不再存在

但它分不清：

1. hidden
2. cleared
3. replaced
4. resolved

这会迫使宿主重走一遍我们前面批评过的错误路径：

`从前景变化反推强语义。`

### 6.2 宿主无法自己做正确的 cleanup projection

只要宿主拿不到 cleanup fields，  
它就不能在自己的 UI 上正确实现：

1. 极浅摘要层
2. detail pane
3. audit pane
4. retry path handoff

这会直接削弱 Claude Code 的 host-integrated runtime 价值。

### 6.3 tests 和 SDK evolution 也没有抓手

没有 contract，  
cleanup 语义很难被：

1. snapshot tests
2. compatibility tests
3. schema evolution
4. backward-compatible rollout

系统性守住。

## 7. 下一代最值得引入的 cleanup host contract 形态

基于当前 SDK 结构，  
最自然的做法不是另起炉灶，  
而是在现有 message / response surface 上扩展 cleanup payload。

### 7.1 扩展 `system:status`

加入例如：

1. `cleanup_summary`
2. `deferred_cleanup_count`
3. `cleanup_projection_level`

### 7.2 扩展 `reload_plugins` response

加入例如：

1. `consumed_needs_refresh: boolean`
2. `cleanup_owner`
3. `cleanup_gate`
4. `cleanup_residuals`

### 7.3 扩展 `mcp_status` / reconnect result

加入例如：

1. `replaced_pending_trace`
2. `cleanup_reason`
3. `residual_needs_auth`

### 7.4 增加专门的 cleanup event

例如：

1. `system:cleanup_applied`
2. `system:cleanup_deferred`
3. `system:cleanup_denied`

这会比让宿主从状态差分里自己猜强得多。

## 8. 技术先进性：Claude Code 的下一步不只是“字段化”，还应是“contract 化”

这一章最核心的技术启示是：

`字段化解决本地控制面；contract 化解决跨宿主控制面。`

如果只做前者不做后者，  
Claude Code 最终仍会陷入一种半成品状态：

1. CLI 内部更懂 cleanup 了
2. 宿主侧仍看不懂 cleanup

而真正先进的 agent runtime 不该停在这一步。

## 9. 哲学本质：真相只有进入契约，才算真正从“内部知识”变成“公共知识”

这一章真正的哲学核心是：

`系统内部知道，不等于生态知道。`

只有当 cleanup 语义进入 SDK / host contract，  
它才会从：

1. CLI 内部知识
2. 实现细节知识
3. 调试知识

升级成：

`公共知识`

也就是：

`任何遵守这个 contract 的宿主都配正式理解的知识。`

## 10. 苏格拉底式反思：如果要把 cleanup host contract 再推进一代，还缺什么

继续追问，还能看到三个明显下一步。

### 10.1 缺 cleanup event family

当前最明显的缺口是专门 cleanup events 还不存在。

### 10.2 缺 backward-compatible migration story

如果要往 SDK 里加 cleanup fields，  
必须设计：

1. old hosts 忽略新字段
2. new hosts 优先消费新字段
3. projection fallback 策略

### 10.3 缺 host-side cleanup conformance tests

未来若 contract 化，  
还必须验证 host 不会：

1. 继续脑补 stronger cleanup truth
2. 把 `deferred` 当成 `resolved`
3. 把 `replaced` 当成 `cleared`

## 11. 本章结论

把 `137` 再推进一层后，  
Claude Code 安全性的下一步宿主化方向就很清楚了：

`cleanup 语义不只要字段化、投影化，还必须 contract 化。`

所以如果要真正学习 Claude Code 的安全设计启示，  
最值得学的不是“在 CLI 里把 cleanup 理清”，  
而是：

`把 cleanup 真相正式带进 SDK 与 host contract，让宿主不再靠文案和隐式状态猜。`

