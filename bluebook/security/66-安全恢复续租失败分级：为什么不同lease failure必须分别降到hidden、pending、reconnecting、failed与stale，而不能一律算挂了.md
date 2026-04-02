# 安全恢复续租失败分级：为什么不同lease failure必须分别降到hidden、pending、reconnecting、failed与stale，而不能一律算挂了

## 1. 为什么在 `65` 之后还要继续写“续租失败分级”

`65-安全恢复续租信号` 已经回答了：

`绿色词必须靠 heartbeat、poll、refresh 与 recheck 持续续租；没有续租信号的绿色词，不应继续被信任。`

但如果继续往下一层追问，  
还会出现一个更贴近控制面落地的问题：

`当续租失败时，系统到底该降到哪一级？`

因为“续租失败”并不是一个单一状态。  
不同 failure 的含义完全不同：

1. 有的只是暂时失去续租，仍可自动重连
2. 有的说明对象进入等待态，仍保留再次进入入口
3. 有的说明租约已经终局失败
4. 有的说明对象已经 stale，不应再被当成当前事实
5. 还有的只是被隐藏，不等于失败

如果把这些 failure 全部压成一句：

`挂了`

系统就会同时失去：

1. 正确的下一步动作
2. 正确的恢复入口
3. 正确的风险强度表达

所以在 `65` 之后，  
统一安全控制台还必须再补一条制度：

`续租失败分级。`

也就是：

`不同 lease failure 必须分别降到 hidden、pending、reconnecting、failed、stale、auth_failed 等不同层级，而不能被一律压成同一种失败。`

## 2. 最短结论

从源码看，Claude Code 已经在多个域里自然形成了一条失败分级梯子：

1. 本地任务面在 recheck 后可退到 `hidden`  
   `src/hooks/useTasksV2.ts:138-170`
2. IDE / MCP / transport 域会进入 `pending` 或 `reconnecting`  
   `src/hooks/useIdeConnectionStatus.ts:4-32`、`src/services/mcp/useManageMCPConnections.ts:389-441`
3. bridge active work heartbeat 失败会区分 `auth_failed`、`failed`、`fatal`  
   `src/bridge/bridgeMain.ts:198-275`
4. crash-recovery pointer 则有独立的 `stale` 语义  
   `src/bridge/bridgePointer.ts:22-34,56-70`

所以这一章的最短结论是：

`续租失败不是二元断裂，而是一条关于“剩余恢复能力”的分级梯子。`

我会把这条结论再压成一句话：

`lease failure 的本质，不是“还行/挂了”，而是“还剩下什么恢复能力”。`

## 3. 源码已经证明：Claude Code 不把续租失败压成单一失败

## 3.1 `hidden` 是最温和的失败等级，它表示“不再展示”，不是“对象坏了”

`src/hooks/useTasksV2.ts:138-170` 很关键。  
当任务都已完成后，系统会：

1. 启动 hide timer
2. recheck `allStillCompleted`
3. 若仍成立，则 `resetTaskList()` 并把 `#hidden = true`

这里的 failure 不是：

`任务失败`

而是：

`当前没有继续展示它的必要。`

这说明 `hidden` 是一种非常温和的降级：

1. 它不表达错误
2. 它也不表达不可恢复
3. 它只是表达“当前已不需前景呈现”

## 3.2 `pending` / `reconnecting` 表示租约失去实时性，但仍保留自动或半自动恢复能力

`src/hooks/useIdeConnectionStatus.ts:4-32` 先给出 `pending` 这一级。  
这表示：

1. 还不能说 connected
2. 也不该直接说 failed
3. 当前处在过渡或等待态

`src/services/mcp/useManageMCPConnections.ts:389-441` 进一步说明：

1. automatic reconnection 会写 `type: 'pending'`
2. 附带 `reconnectAttempt`
3. 达到上限前都不该直接说终局失败

而 bridge 域里 `reconnecting` 也是同类语义：  
它表达的是：

`租约暂时失效，但自动恢复路径仍在运作。`

这类状态的关键点在于：

`它们不是绿色，但也不是终局失败。`

## 3.3 `auth_failed` 表示租约失效的根因是资格过期，而不是对象本身立即不可恢复

`src/bridge/bridgeMain.ts:198-275` 是这一章最重要的证据之一。  
`heartbeatActiveWorkItems()` 不会把所有 heartbeat failure 都压成一个 `failed`。

它会明确区分：

1. `ok`
2. `auth_failed`
3. `fatal`
4. `failed`

其中 `auth_failed` 对应 401/403，  
还会主动尝试：

`reconnectSession()`

也就是说，  
作者已经在架构上承认：

`租约失败的根因不同，恢复路径也不同。`

资格失败不等于对象立即死掉。  
它更像：

`当前通行证过期，但重派发后仍可能恢复。`

## 3.4 `failed` 才是自动续租预算耗尽后的更强降级

`src/services/mcp/useManageMCPConnections.ts:434-441` 说明，  
只有在：

1. 尝试达到上限
2. 仍未恢复

时，  
系统才会落成：

`type: 'failed'`

这说明在 MCP 域里，  
`failed` 不是第一个失败信号，  
而是：

`在自动重连预算被耗尽之后的更终局降级。`

这比很多系统的“出一次错就 failed”要成熟得多。

## 3.5 `stale` 则表达“这个对象仍存在，但已不配代表当前现实”

`src/bridge/bridgePointer.ts:22-34,56-70` 把 pointer 的 staleness 做得非常明确：

1. pointer 可能仍然存在
2. 但一旦超过 TTL
3. 它就只能被视作 stale

这说明 `stale` 又是一种和 `failed` 不同的 failure：

1. 它不是立即错误
2. 它也不是 pending
3. 它表达的是：

`对象还在，但时间语义已经过期。`

这类状态非常关键，  
因为它保护了“存在”和“仍可代表当前真相”这两件事的分离。

## 4. 第一性原理：失败分级的本质是表达剩余恢复能力，而不是表达情绪强弱

如果从第一性原理追问：

`为什么成熟控制面不能把所有失败压成一种失败？`

因为控制面的任务不是抒发情绪，  
而是给出：

`剩余恢复能力的真实地图。`

一个 failure state 至少应回答：

1. 还能不能自动恢复
2. 还能不能人工恢复
3. 还能不能继续信任旧对象
4. 这个对象现在是不存在、不可达、过渡中还是已过期

所以 failure taxonomy 的本质不是“坏到什么程度”，  
而是：

`还剩什么恢复路径。`

## 5. 我给统一安全控制台的“续租失败梯子”

我会把它压成六级。

## 5.1 hidden

对象已不需前景展示，  
但没有失败语义。

## 5.2 pending

当前未恢复完成，  
但自动或预设路径仍在。

## 5.3 reconnecting

当前正处于主动续租/重连过程。

## 5.4 auth_failed

当前失败根因是资格/令牌失效，  
需要刷新资格而不是直接放弃对象。

## 5.5 failed

当前自动续租预算已耗尽，  
需要人工或更高层 repair path 介入。

## 5.6 stale

对象仍存在，  
但不再配代表当前现实。

## 6. 技术先进性与技术启示

这一章最重要的技术判断是：

`Claude Code 的先进性不只在于它有很多失败状态，而在于这些失败状态其实都在表达不同的恢复余量。`

当前先进的地方：

1. bridge heartbeat 区分 `auth_failed / fatal / failed`
2. MCP 自动重连区分 `pending` 与最终 `failed`
3. pointer 独立拥有 `stale`
4. hidden 被保留为非失败型降级

当前仍待系统化的地方：

1. 这些失败层级还没有被统一压成一张正式的跨域梯子
2. 用户仍可能把它们混读成同一种“坏了”
3. 缺少一张统一的“failure -> next path”映射表

这对其他 Agent 平台构建者的直接启示有五条：

1. 把 failure 设计成恢复能力地图，而不是情绪标签
2. 明确区分 pending/reconnecting 与 final failed
3. 给 auth failure 独立位置，不和 generic failure 混写
4. 给 stale 独立位置，不和 missing/failed 混写
5. 保留 hidden 这类“非失败型退场”状态，避免所有退场都被说成错误

## 7. 哲学本质

这一章更深层的哲学是：

`真正成熟的系统，不会把一切坏消息都说成同一种坏。`

因为不同的坏，  
意味着不同的未来。  
而控制面的职责，就是忠实表达：

`未来还有多少路。`

## 8. 苏格拉底式反思：这一章最需要追问什么

### 8.1 为什么用户总喜欢把 pending/reconnecting/failed 混成一个“没连上”

因为大多数产品从未教过用户失败其实有梯度。

### 8.2 为什么这对安全有影响

因为错误的 failure taxonomy 会直接把用户带向错误 repair path。

### 8.3 真正危险的错误是什么

不是状态太多，  
而是：

`系统把剩余恢复能力完全不同的 failure 状态压成同一个词。`

### 8.4 这一章之后还缺什么

还缺一张更短的失败梯子矩阵：

`lease failure type -> recovery capacity -> next repair path`

也就是说，  
下一步最自然的延伸就是：

`appendix/50-安全恢复续租失败分级速查表`

## 9. 结语

`65` 回答的是：绿色词必须持续续租。  
这一章继续推进后的结论则是：

`续租失败后系统不能只说“挂了”，而必须诚实表达当前还剩下哪一种恢复能力。`

这意味着 Claude Code 更深层的安全启示之一是：

`成熟控制面不仅要定义成功的层级，也要定义失败的梯子。`
