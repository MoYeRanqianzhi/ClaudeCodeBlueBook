# 持续验证底盘：Artifact Runner、Alignment Gate、Drift Ledger 与 Rewrite Adoption Loop

这一章回答五个问题：

1. 为什么 replay lab 还不等于成熟验证底盘，系统还必须长出 artifact runner。
2. 为什么 `replay queue`、`alignment gate`、`drift ledger` 与 `rewrite adoption loop` 应被视为同一运行时平面。
3. 为什么这条线会同时解释 Prompt 魔力、安全/省 token 与源码先进性的更深统一性。
4. Claude Code 源码里哪些机制最接近这条持续执行底盘。
5. 这对 agent runtime 设计者意味着什么。

## 0. 代表性源码锚点

- `claude-code-source-code/src/QueryEngine.ts:436-463`
- `claude-code-source-code/src/QueryEngine.ts:687-717`
- `claude-code-source-code/src/QueryEngine.ts:734-750`
- `claude-code-source-code/src/QueryEngine.ts:875-933`
- `claude-code-source-code/src/query.ts:365-375`
- `claude-code-source-code/src/query/stopHooks.ts:84-132`
- `claude-code-source-code/src/services/compact/compact.ts:766-899`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:243-380`
- `claude-code-source-code/src/utils/messages.ts:1989-2148`
- `claude-code-source-code/src/utils/toolResultStorage.ts:739-880`
- `claude-code-source-code/src/query/tokenBudget.ts:1-92`
- `claude-code-source-code/src/utils/QueryGuard.ts:1-121`
- `claude-code-source-code/src/utils/permissions/permissions.ts:593-760`
- `claude-code-source-code/src/utils/permissions/permissions.ts:1169-1280`
- `claude-code-source-code/src/hooks/toolPermission/handlers/interactiveHandler.ts:138-330`
- `claude-code-source-code/src/services/mcp/channelPermissions.ts:1-240`
- `claude-code-source-code/src/utils/sessionState.ts:92-133`
- `claude-code-source-code/src/state/onChangeAppState.ts:43-92`
- `claude-code-source-code/src/cli/structuredIO.ts:149-657`
- `claude-code-source-code/src/services/api/sessionIngress.ts:57-186`
- `claude-code-source-code/src/utils/sessionStorage.ts:1085-1215`
- `claude-code-source-code/src/utils/sessionStorage.ts:3469-3705`
- `claude-code-source-code/src/utils/task/framework.ts:160-269`
- `claude-code-source-code/src/tasks/RemoteAgentTask/RemoteAgentTask.tsx:386-845`
- `claude-code-source-code/src/bridge/bridgePointer.ts:22-184`
- `claude-code-source-code/src/bridge/remoteBridgeCore.ts:824-880`
- `claude-code-source-code/src/utils/swarm/inProcessRunner.ts:1175-1361`

## 1. 先说结论

Claude Code 源码里没有一份名为：

- `artifact_harness_runner.ts`

的集中定义。

但它已经把这层底盘真正需要的四类动作写成了正式运行时习惯：

1. `replay queue`
   - 哪些对象被允许继续执行，哪些对象必须等待下一轮判断。
2. `alignment gate`
   - 不同消费者是否仍在围绕同一 shared object 做出同源判断。
3. `drift ledger`
   - 当前这次执行到底在哪个对象边界发生了 drift。
4. `rewrite adoption loop`
   - 修复是否真的恢复同一 shared object，而不是仅仅修补投影。

这四块合起来，才构成更成熟的：

- continuous validation runtime

## 2. 为什么 replay lab 还不够

`playbooks/23-25` 已经解决了：

1. replay case 怎么写。
2. alignment assertion 怎么写。
3. drift regression 怎么写。
4. rewrite replay 怎么写。

但实验室仍然可能停在三种不成熟状态：

1. 只会证明一次。
2. 只会产生 verdict，不会沉淀 drift。
3. 只会提示 rewrite，不会把 adoption 重新接回执行链。

成熟底盘需要继续回答四个更难的问题：

1. 当前哪个对象值得进入下一次 replay。
2. 当前哪个消费者先暴露了 shared object drift。
3. 当前 drift 怎样成为下一次继续执行的正式输入。
4. 当前 rewrite 采纳后怎样重新证明 alignment 已恢复。

这就是 runner / ledger 层存在的理由。

而且源码其实已经给出了四个非常接近 runner 的硬检查点：

1. `QueryEngine.ts` 在进入 query loop 前就先 `recordTranscript(messages)`，说明“被接受的请求”先于“模型给出的答案”成为可恢复事实。
2. `QueryEngine.ts` 在写 `compact_boundary` 前强制把 preserved tail 落盘，说明 boundary 不是显示优化，而是正式 checkpoint。
3. `structuredIO.ts` 把 permission / control race 写成单胜者协议，说明 continue / cancel / response 本来就该有唯一 winner、唯一 cancel 与唯一日志。
4. `sessionStorage.ts` 把 `content-replacement`、`worktree-state`、`mode`、`snapshot` 等对象分开持久化，说明 ledger 更接近 typed object set，而不是 transcript 一坨字节。

## 3. Prompt 线：为什么 replay 之后必须继续变成 queue + ledger

`stopHooks.ts` 说明：

- 主线程会在 stop hook 阶段保存 `cache-safe params`，供 `/btw` 与 `side_question` 复用。

`QueryEngine.ts` 与 `query.ts` 说明：

- 用户输入一旦被接受，就先被写成 transcript 并在 compact boundary 之后只取 protocol transcript slice；这意味着 replay 保护的不是 UI 历史，而是被编译后的 continuation 边界。

`promptCacheBreakDetection.ts` 说明：

- 系统持续记录 system、tools、cache control、betas、effort、extra body params 的变化，而不是只在回顾时猜 prompt 为什么变了。

`normalizeMessagesForAPI(...)` 与 `toolResultStorage.ts` 说明：

- Claude Code 真正保护的是编译后的 request truth 与字节级稳定重放，而不是 UI 原始历史。

这三点合起来意味着：

- Prompt 线真正成熟的 runner，不是定时回放实验室，而是持续维护 `compiled request continuity`

换句话说，Prompt 的魔力不只来自：

- 某次 replay 证明了 reject semantics

更来自：

- 系统平时就在持续保存下次 replay 所需的 continuation 对象、stable bytes 与 drift 证据

## 4. 治理线：为什么 replay 之后必须继续变成 gate + adoption loop

`tokenBudget.ts` 说明：

- continuation 不是默认权利，而是一个不断被重新证明的决策窗口。

`QueryGuard.ts` 说明：

- 继续、取消、清理都必须围绕当前 generation 进行，旧 finally 不能复活旧判断。

`permissions.ts`、`interactiveHandler.ts`、`channelPermissions.ts` 与 `structuredIO.ts` 说明：

- 权限决策不是单点弹窗，而是本地 UI、bridge、channel、hook、classifier 围绕同一请求并行竞速，谁先合法决策，谁结束等待。

这三点合起来意味着：

- 安全与省 token 真正成熟的 runner，不是让更多 gate 重放，而是持续维护同一 `decision_window`、同一 `control_arbitration_truth` 与同一 `rollback_object`

换句话说，治理线的高级感不只来自：

- 某次 replay 证明了不该继续

更来自：

- 系统平时就在持续记录“为什么这次不该继续”“谁赢得仲裁”“失败时该回退哪个对象”

## 5. 结构线：为什么 replay 之后必须继续变成 ledger + recovery loop

`sessionIngress.ts` 说明：

- 会话持久化不是盲写日志，而是用 `Last-Uuid` 与 `409 adopt server uuid` 保护 append chain 这个对象。

`sessionStorage.ts` 与 `RemoteAgentTask.tsx` 说明：

- 恢复对象边界是 typed object set；很多状态只持久化 identity，恢复时再拉 live truth，而不是把 stale runtime status 当真相继续带下去。

`task/framework.ts` 说明：

- 偏移补丁与 task eviction 必须合并到 fresh state，避免 stale snapshot 覆盖已完成状态，防止 task zombification。

`bridgePointer.ts` 与 `remoteBridgeCore.ts` 说明：

- 恢复不是简单重连；pointer 要有 TTL，要在 worktree 间找 freshest pointer，401 恢复期间还要主动丢弃 stale control / stale result。

这三点合起来意味着：

- 源码先进性真正成熟的 runner，不是重复跑 anti-zombie case，而是持续维护同一 `authoritative object`、同一 `recovery asset ledger` 与同一 `dropped stale writers`

换句话说，结构线的高级感不只来自：

- 某次 replay 证明了 split-brain

更来自：

- 系统平时就在持续保存恢复资产、权威对象边界与 stale writer 清退证据

## 6. 四段式执行循环

更稳的 artifact runner 可以被理解成四段循环：

### 6.1 Queue

先决定：

1. 哪个 shared object 进入本轮执行。
2. 哪个 replay case 只是历史证据，哪个才是当前继续对象。

### 6.2 Alignment Gate

再判断：

1. 宿主、CI、评审与交接是否仍在围绕同一 shared object。
2. 不同消费者的不同 verdict 是否仍然同源。

### 6.3 Drift Ledger

再留下：

1. 这次 drift 发生在哪个对象边界。
2. 哪个 evidence ref 可以作为下一轮继续输入。
3. 这次 verdict 为什么导致 rewrite / rollback / reject。

### 6.4 Rewrite Adoption Loop

最后验证：

1. 改写后是否真的恢复 shared object continuity。
2. adoption 结果是否足以回写下一轮 queue，而不是只留在 review comment。

最接近这条语义骨架的现成实现，其实已经出现在 `inProcessRunner.ts`：

- 它保留长生命周期 `allMessages`
- 超阈值时主动 compact
- full compact 后重置 replacement / microcompact 状态
- 区分 per-turn abort 与 lifecycle abort
- idle 后继续等待下一条 prompt 或 shutdown

这说明 runner / ledger 不是凭空发明的新层，而是把源码里已经存在的长生命周期执行习惯正式命名出来。

## 7. 为什么这是 Prompt、安全与源码先进性的更深统一

这三条线表面上在处理不同问题：

1. Prompt 线在处理 continuation。
2. 治理线在处理 decision gain。
3. 结构线在处理 authoritative object。

但到了 runner / ledger 层，它们都在回答同一个第一性问题：

- 当前这次继续执行，到底是不是还在围绕同一个正式对象

所以它们才会共享同一组底盘动作：

1. 先排队。
2. 再对齐。
3. 再留痕。
4. 再采纳改写并重新进入下一轮。

这也是为什么 Claude Code 的 prompt 有魔力、安全设计能省 token、源码结构显得先进，最后会在同一层重新会合。

## 8. 这对 agent runtime 设计者意味着什么

如果你在设计自己的 runtime，最容易少掉的不是：

- 更多 replay case

而是：

1. 没有正式 queue，只能手工挑 case。
2. 没有 alignment gate，只能并排看四份结果。
3. 没有 drift ledger，只能事后解释。
4. 没有 adoption loop，rewrite 永远回不到主路径。

Claude Code 值得学的地方，不是它把每个问题都做成一套新系统，而是它总能把：

- 下一次继续执行所需的判断条件

提前保存到当前运行时里。

## 9. 苏格拉底式自反

在你准备宣布“我们已经有持续验证底盘了”前，先问自己：

1. 我记录的是同一 shared object 的 drift，还是不同 dashboard 的异常。
2. rewrite adoption 回写的是正式对象，还是只回写文字说明。
3. 当前 queue 保护的是对象连续性，还是保护了几个脚本入口。
4. 这套 runner 能不能在删掉绿灯、摘要、目录图和统计面板后仍然成立。
5. 我是在增加验证工具，还是在把下一次继续执行的判断条件写进当前 runtime。
