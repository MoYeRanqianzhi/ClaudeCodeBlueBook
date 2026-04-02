# 安全资格重签发协议：为什么失效对象不能靠残留工件直接回到current，而必须先回到pending、reload或fresh-session路径

## 1. 为什么在 `94` 之后还必须继续写“资格重签发协议”

`94-安全恢复资格对象` 已经回答了：

`系统真正保护的不是工件，而是工件背后那份继续行动权。`

但如果继续往下追问，  
还会遇到一个更具制度意味的问题：

`这份资格一旦失效、过期、换届或被撤销，之后还能怎么回来？`

如果答案是：

`工件还在，所以直接回来`

那 `94` 就会立刻失效。  
因为这等于承认：

`资格撤销没有真实后果，残留工件随时可以把它重新偷渡回来。`

所以 `94` 之后必须继续补出的下一层是：

`安全资格重签发协议`

也就是：

`系统不能让失效对象靠残留状态直接回到 current，而必须要求它重新经过一条明确的 regrant path。`

## 2. 最短结论

从源码看，Claude Code 在多个子系统里都遵守同一个原则：

1. 原资格若仍连续有效，可以原地续接
2. 原资格若已失效、换届、陈旧或配置漂移，就不能直接复活
3. 此时对象必须先回到某种中间态，再重新被签发

这一原则在三条主线都很清楚：

1. bridge resume 若 env 未变，可 `reconnect in place`；若 env 已变，则必须 fresh session，不能把新 env 假装成旧资格的续命  
   `src/bridge/bridgeMain.ts:2473-2489`; `src/bridge/replBridge.ts:729-835`
2. plugins 磁盘状态变更后，不允许自动宣布“已生效”，而是进入 `needsRefresh`，等待显式 `/reload-plugins` 执行完整 Layer-3 refresh  
   `src/hooks/useManagePlugins.ts:287-303`; `src/utils/plugins/refresh.ts:59-138`
3. MCP stale client 不会直接保留在 current，而是先被剔除，再以 `pending` 形式重新进入连接流程  
   `src/services/mcp/useManageMCPConnections.ts:765-900`

所以这一章的最短结论是：

`Claude Code 的安全控制面把“资格回来”设计成重新签发，而不是残留复活。`

再压成一句：

`真正安全的恢复不是 resurrection，而是 regrant。`

## 3. bridge 子系统已经把“重签发”写成两条截然不同的制度路径

## 3.1 连续性还在时，可以原地续接

`src/bridge/replBridge.ts:729-735` 很关键。

当 `tryReconnectInPlace(requestedEnvId, currentSessionId)` 成功时：

1. `currentSessionId` 保持不变
2. 既有 URL 继续有效
3. `previouslyFlushedUUIDs` 保持
4. 整体被当成同一边界的连续运行

这说明 Claude Code 并不是教条地要求所有恢复都 fresh start，  
而是很清楚地区分：

`原资格仍连续有效`

和

`原资格已经断裂`

前者允许 continuity，  
后者才要求 regrant。

这是一种成熟的安全哲学：

`安全不是一律重建，而是只在连续性不再可信时才重建。`

## 3.2 连续性一旦断裂，就必须 fresh session，而不能假续命

`src/bridge/bridgeMain.ts:2473-2489` 和 `src/bridge/replBridge.ts:737-823` 构成了完整证据链。

这里系统明确写出：

1. 若 backend 返回不同 `environment_id`
2. 原 env 已 expired / reaped
3. reconnect 不再合法
4. 要么 fall back to fresh session
5. 要么 archive old session 后 create new session
6. 然后重写 pointer 指向新的 IDs

这说明系统承认一种非常重要的边界事实：

`新环境上的新 session，不是旧资格自然延续，而是新的资格签发。`

如果系统把这件事压平，  
直接说“恢复成功”，  
那就等于把：

`重签发`

伪装成

`续接`

Claude Code 没这么做。  
它强制走 fresh session path。

## 3.3 archive old session 的意义不是清理，而是为新签发腾出制度空间

`src/bridge/replBridge.ts:743-823` 里最值得强调的一点是：

系统在创建新 session 前，  
先 `archiveSession(currentSessionId)`。

这一步看似只是 housekeeping，  
其实不是。

它真正完成的是：

`把旧资格正式退役，再给新资格腾出合法位置。`

因为如果旧 session 不先 archive，  
新 session 的签发就会处在一个很危险的状态：

`旧资格还在声称自己 current，新资格又已开始写入 current`

所以在 Claude Code 的制度里，  
fresh session 不是“补个新 ID”那么简单，  
而是：

`archive -> create -> rewrite pointer -> reset transport/session-scoped state`

这一整套组合动作。

这就是重签发协议，而不是对象复活。

## 4. plugin 子系统把“重签发”写成显式 reload，而不是静默生效

## 4.1 `needsRefresh` 本身就是资格失效后的待重签发态

`src/hooks/useManagePlugins.ts:287-303` 已经说得非常直白：

1. plugin state changed on disk
2. show notification
3. user runs `/reload-plugins` to apply
4. do not auto-refresh
5. do not reset `needsRefresh`

这里的 `needsRefresh` 不应被理解成一个普通 UI 布尔值。  
它更像是：

`旧资格已不可信，新资格尚未签发完成`

也就是说，  
磁盘 materialization 已经发生，  
但 active entitlement 仍停留在：

`待重签发`

这就是一个很典型的 regrant 中间态。

## 4.2 `/reload-plugins` 不是刷新按钮，而是权限重签发仪式

`src/utils/plugins/refresh.ts:59-138` 说明 `refreshActivePlugins()` 做的是：

1. 清所有 plugin caches
2. 重新 loadAllPlugins
3. 重新派生 commands / agents
4. 补全 MCP / LSP servers
5. `needsRefresh=false`
6. bump `pluginReconnectKey`

这意味着 `/reload-plugins` 的本质不是：

`把界面刷新一下`

而是：

`完成一轮完整的 capability regrant`

也就是说，  
plugin 文件变化只是 regrant 的前提条件；  
真正的资格回来，要等完整 Layer-3 refresh 结束。

所以从第一性原理看：

`若没有 /reload-plugins，plugin 新状态并未被当前边界正式承认。`

## 4.3 为什么不允许 auto-refresh

源码注释已经点明历史经验：

1. 旧 auto-refresh 有 stale-cache bug
2. 旧路径不完整，缺少 MCP / agentDefinitions

这背后揭示的更深层原则是：

`不完整的重签发，比没有重签发更危险。`

因为它会制造一种很有欺骗性的状态：

`用户以为资格已经回来，实际上只有一部分能力被换成了新版本。`

Claude Code 选择了更安全的做法：

`宁可停在 needsRefresh，也不接受半签发。`

## 5. MCP 子系统把“重签发”写成 pending，而不是旧连接自愈

## 5.1 stale client 不会被静默认作 current，而是先被剥离出当前集合

`src/services/mcp/useManageMCPConnections.ts:782-838` 非常关键。

这里系统先：

1. 用 `excludeStalePluginClients(...)` 剔除 stale clients
2. 清 reconnect timers
3. 对 connected stale clients 做 cleanup
4. 再把新的 configs 衍生成 `newClients`
5. 这些 `newClients` 初始状态不是 connected，而是 `pending`

这说明 MCP 子系统在制度上承认：

`旧 client 的存在，不配自然过渡成新 config 下的 current 权限。`

必须先从 current 降出，  
再以 pending 重新入场。

这正是 regrant 语法。

## 5.2 `pending` 的深层含义是“资格正在重新申请”，不是“对象已经差不多好了”

如果从第一性原理看，  
`pending` 的价值在于它明确告诉系统和用户：

`这里不是 current，也不是 dead，而是在重签发流程中。`

这比直接复用旧 connected client 高明得多。  
因为它把两件事分开了：

1. 旧资格已被撤销
2. 新资格正在申请中

很多系统的安全问题，  
恰恰来自把这两件事混成一句：

`应该还能用`

Claude Code 没走这条路。  
它用 pending 保留中间语义。

## 5.3 connect effect 才是 pending 之后的正式再签发

`src/services/mcp/useManageMCPConnections.ts:856-900` 再补上一层。

系统在 pending 初始化之后，  
还有第二个 effect 专门：

1. load configs
2. dedup
3. connect to servers
4. 获取 tools / commands / resources

这说明 pending 不是“差一步等于 connected”，  
而是：

`等着进入正式连接与能力发布链`

因此 MCP 路径完整表达了：

`revoke stale -> mark pending -> reconnect -> publish fresh capabilities`

这是非常典型的多阶段 regrant protocol。

## 6. 这三条证据线共同暴露了 Claude Code 的一个先进性

把 bridge、plugins、MCP 放在一起看，  
会发现它们虽然表面不同，  
但都在做同一件事：

1. 先判断旧资格还能不能连续有效
2. 若不能，则显式降出 current
3. 再进入某个 regrant 中间态
4. 最后经完整流程重回 current

换句话说，Claude Code 的先进性不只是“有很多检查”，  
而是：

`它把资格回归设计成一个有阶段、有签字、有中间态的重签发流程。`

这比“检测到变更就直接替换”高明得多。  
因为它真正保护了：

`撤销权的真实性`

如果撤销后的对象可以靠残留状态自己回来，  
那撤销其实就不是真撤销。

## 7. 第一性原理：为什么安全系统必须区分续接与重签发

## 7.1 如果一份资格失效后还能靠残留对象直接回来，那被撤销的到底是什么

这是这一章最核心的第一性原理追问。

假设某份资格已经因为：

1. env mismatch
2. stale cache
3. config drift
4. source mismatch
5. stale client

而失效。

如果它之后还能因为“旧对象还在”就直接回到 current，  
那说明系统之前所谓的撤销并没有真正撤销：

`它只是在语言上宣布失效，却没有在制度上剥夺返回 current 的路径。`

所以安全系统如果想让 revocation 真实成立，  
就必须同时坚持：

`失效对象只能 regrant，不能 resurrection。`

## 7.2 续接与重签发是两种完全不同的制度动作

这一章也帮助我们把两种容易混淆的动作正式分开：

1. `continuation`
   原资格还连续有效，所以原地续接
2. `regrant`
   原资格已断裂，只能重新签发

bridge 的 `reconnect in place` 属于前者；  
fresh session、`/reload-plugins`、MCP `pending -> connect` 属于后者。

只有把这两种动作分开，  
系统才能既不保守到处 fresh start，  
也不轻率到处假续命。

## 8. 苏格拉底式自我反思：这套协议还能怎么做得更好

可以继续问六个问题：

1. 如果 `needsRefresh`、`pending`、`fresh-session-fallback` 都已经存在，为什么还不把它们统一成一套显式的 regrant state family？
2. 如果 bridge 的 fresh fallback、plugin reload、MCP pending 本质相同，为什么当前 UI 仍按子系统分散表达，而不是给用户统一说“资格正在重签发”？
3. 如果 regrant 是比 resurrection 更安全的原则，哪些其他子系统还在悄悄允许残留状态直接回 current？
4. 如果 partial regrant 比 no regrant 更危险，系统是否应该显式展示“本轮重签发覆盖了哪些 capability、遗漏了哪些 capability”？
5. 如果 revocation 的真实性依赖 regrant path 唯一性，是否所有路径都已经收敛到了唯一默认动作？
6. 如果重签发是多阶段协议，当前控制台是否已经把 revoke、pending、grant、publish 四步全都显式展示给用户？

这些问题说明：

Claude Code 的源码已经有很成熟的制度意识，  
但产品化表达还可以再进一步统一。

## 9. 对目录结构与后续研究的启发

写到这里，恢复安全链又可以再清楚地分成两大块：

1. `资格本体`
   什么是真正被保护的对象
2. `资格生命周期`
   失效后如何退出、如何重签发、如何重返 current

因此后续最自然的下一层会是：

`安全资格中间态语法`

也就是把 `needsRefresh`、`pending`、`fresh-session-fallback`、`retryable reconnect` 这些对象统一放进一套更抽象的重签发阶段模型里。

## 10. 给系统设计者的技术启示

最后把这一章压成六条工程启示：

1. 资格失效后，不要让旧工件直接回到 current
2. 能原地续接时再续接，不能续接时必须显式重签发
3. 中间态不是噪音，它是保护 revocation 真实性的必要层
4. 半签发比未签发更危险，宁可 pending 也不要假完成
5. 撤销与重签发必须成对设计，否则旧状态会借残留工件偷偷回来
6. 把 regrant path 做成清晰协议，系统才真正配谈“安全恢复”

这一章最终要守住的一条硬结论是：

`对 Claude Code 这类安全控制面来说，真正成熟的不是让对象自己活过来，而是让对象在资格失效后重新申请、重新验证、重新签发。`
