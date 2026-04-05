# 安全遗忘审计：为什么Claude Code即使允许清理失败痕迹，也不应让清理变成无痕动作，而要留下谁清了、为何清、清后如何回查的线索

## 1. 为什么在 `134` 之后还必须继续写“遗忘审计”

`134-安全恢复清理权限边界` 已经回答了：

`不是任何局部成功信号都配清除失败痕迹，只有真正消费完整闭环的 owner 才配正式忘记失败。`

但如果继续追问，  
还会碰到另一个更深的问题：

`就算清理者是对的，清理动作本身是否可以无痕发生？`

如果答案是“可以”，  
系统就仍然会留下一个非常危险的缺口：

`失败痕迹虽然被合法清除了，但没人再能回答它是谁清的、为什么清的、清理之前发生了什么、清理失败时又退回到哪条路。`

这会把“合法遗忘”重新推回“无法追责的沉默”。

所以 `134` 之后必须继续补出的下一层就是：

`安全遗忘审计`

也就是：

`Claude Code 不应把清理理解成把痕迹抹掉，而应把它理解成一条需要保留来龙去脉的受审计动作。`

## 2. 最短结论

Claude Code 安全设计真正成熟的一点，不只是开始限制谁配清理痕迹，  
还在于：

`关键清理与恢复动作往往伴随着 debug、event、diagnostic 或显式 error 输出，从而避免“痕迹消失，但历史也消失”。`

从源码看，至少有四类代表性路径已经具备这种“部分审计化”特征：

1. bridge shutdown / archive / deregister / pointer cleanup 会写 diagnostics 与 debug trace  
   `src/bridge/bridgeMain.ts:1407-1415,1543-1579`
2. stale resume pointer 清理会伴随明确错误输出，避免静默吞掉失败背景  
   `src/bridge/bridgeMain.ts:2384-2396,2400-2405`
3. background marketplace install 与 auto-refresh fallback 会写 event、diagnostic、debug 与 error  
   `src/services/plugins/PluginInstallationManager.ts:122-165`
4. `refreshActivePlugins()` 在消费 `needsRefresh` 前后会记录 cache clear、hook failure 与最终刷新摘要  
   `src/utils/plugins/refresh.ts:75-80,123-177`

这些证据共同说明：

`Claude Code 已经部分意识到：痕迹可以被清理，但清理动作本身不应无痕。`

但同时也必须诚实指出：

`这套审计还没有完全统一。`

所以这一章的最短结论是：

`Claude Code 已经形成“遗忘也要留线索”的雏形，但还未把 cleanup audit 升级成统一协议。`

再压成一句：

`允许忘记，不等于允许无痕忘记。`

## 3. 第一性原理：为什么合法遗忘仍然必须可追溯

从第一性原理看，  
安全系统里任何“删除”动作都同时在改写两层东西：

1. 当前前景
2. 历史解释权

当前前景很好理解。  
痕迹被删掉后，  
用户现在看见的状态变了。

但更深的一层是：

`未来谁还能解释这次恢复为什么被判定为完成。`

如果没有遗忘审计，  
系统之后就再也无法可靠回答：

1. 这条失败链存在过吗
2. 它是哪条 repair path 被消费掉的
3. 清理动作由谁发起
4. 清理时依赖了什么证据
5. 如果清理其实过早，哪一步出了问题

所以安全系统真正成熟的做法，不是：

`删除痕迹 = 删除历史`

而是：

`删除前景 ≠ 删除审计`

这就是“遗忘审计”的本质。

## 4. bridge 说明：清理恢复资产时，Claude Code 同时保留运行时解释线索

`src/bridge/bridgeMain.ts` 是这条原则最清晰的证据之一。

### 4.1 shutdown 本身被显式打点

`1407-1415` 表明 bridge loop 在 shutdown 时会写：

1. `tengu_bridge_shutdown`
2. `bridge_shutdown` diagnostics
3. active sessions 与 loop duration

这说明即便接下来要做 archive、deregister 与 pointer cleanup，  
系统也先把“这次结束发生了”记录下来。

这是一种很重要的顺序：

`先记账，再遗忘。`

### 4.2 archive / deregister / pointer cleanup 不是静默收尾

`1543-1579` 又进一步表明：

1. archiving sessions 会写 debug
2. deregister environment 会写 debug / verbose
3. pointer cleanup 发生在 env gone 之后
4. 最后还有 `Environment offline`

这说明 pointer 虽然被清掉了，  
但系统没有把“为什么清”也一并抹掉。  
相反，它保留了足够的 runtime 叙述：

1. 先 archive
2. 再 deregister
3. env gone
4. pointer stale
5. 因而 clear

也就是说：

`被清理的是恢复资产，不是清理因果。`

### 4.3 stale resume pointer 清理时，会把原因直接暴露给用户

`2384-2396` 和 `2400-2405` 非常关键：

1. 若 session 已不存在
2. 或 session 缺少 environment_id
3. 系统先清理 stale pointer
4. 然后明确 `console.error(...)`
5. 告诉用户 session 可能 archived / expired / login lapsed

这说明 Claude Code 理解到：

`对 stale 恢复资产的清理，若没有伴随失败解释，就会被用户体验成“凭空没了”。`

所以它保留了：

1. 清理动作
2. 清理原因
3. 清理后的下一步解释

这就是一种用户可见的 cleanup audit。

## 5. plugin 说明：后台恢复与前台应用之间的清理决策会留下事件与回退线索

`src/services/plugins/PluginInstallationManager.ts:122-165` 很能说明问题。

### 5.1 background install 先写 metrics，再决定是否清理前景痕迹

这里在 reconcile 完成后先写：

1. `tengu_marketplace_background_install`
2. `logForDiagnosticsNoPII(...)`
3. installed / updated / failed / up_to_date counts

这意味着即便后面要：

1. auto-refresh
2. 或 fallback 到 `needsRefresh`

系统也已经先把本次变化的基础事实记下来了。

### 5.2 auto-refresh 失败时不只回退，还把回退写进 debug / error

`145-165` 表明：

1. refresh 成功则继续前推
2. refresh 失败则 `logError(refreshError)`
3. `logForDebugging("Auto-refresh failed, falling back to needsRefresh ...")`
4. 再把 `needsRefresh=true`

这很关键。

因为这里不是简单地：

`失败 -> 继续显示 pending`

而是：

`失败 -> 记录失败 -> 显式说明回退到哪条 repair path`

这就让 cleanup / fallback 不再是黑箱。

### 5.3 updates-only 路径同样保留“为什么没立刻清理”的事实

`166-179` 说明：

1. updates-only 场景不会假装前台已经生效
2. 系统只把 `needsRefresh=true`
3. 保留后续 `/reload-plugins` 入口

这条路径虽然没有额外 event，  
但与前面的 install metrics 结合起来，  
已经构成了一条最小审计链：

1. 发生了 update
2. 没有自动消费
3. 当前仍需手动闭环

## 6. `refreshActivePlugins()` 说明：真正消费闭环的函数还会留下“消费摘要”

`src/utils/plugins/refresh.ts:75-177` 展示了更成熟的一面。

这里在真正消费 `needsRefresh` 时，  
会留下三类线索：

1. `refreshActivePlugins: clearing all plugin caches`
2. hook load failure 的 `logError + logForDebugging`
3. 最终 enabled/commands/agents/hooks/MCP/LSP 的 summary log

这说明：

`真正拥有清理权的函数，同时也承担了最低限度的审计责任。`

换句话说：

`谁配清 needsRefresh，谁就应该能交代自己清完之后系统处于什么样的结果态。`

这是一种非常好的设计趋势。

它让 cleanup 不只是布尔位翻转，  
而是：

`带结果摘要的受控消费动作。`

## 7. `useManagePlugins` 说明：弱 surface 自觉不消费，就已经是在减少审计黑洞

`src/hooks/useManagePlugins.ts:287-303` 这段虽然没有显式 cleanup audit event，  
但它有一种同样重要的“反审计缺口”设计：

1. 它只发 notification
2. 明确 `Do NOT auto-refresh`
3. 明确 `Do NOT reset needsRefresh`

这件事的重要性在于：

`很多审计黑洞来自弱 surface 越权消费。`

一旦弱 surface 擅自把痕迹清了，  
系统既没有真的恢复，  
也没有留下谁清的、为何清的线索。

所以：

`自觉不消费，本身就是在避免形成无痕删除。`

## 8. 清理可审计的技术先进性到底体现在哪

Claude Code 目前还没有统一 cleanup ledger，  
但它已经呈现出几个比普通系统更成熟的趋势。

### 8.1 它倾向于在关键 cleanup 前后留 debug / diagnostic / event

bridge shutdown、marketplace install、plugin refresh 都说明：

`关键清理不是静默动作。`

### 8.2 它会把 fallback path 显式写出来

这比单纯记录 error 更成熟。  
因为它不只说：

`失败了`

还说：

`失败后退回哪条 repair path。`

### 8.3 它部分具备“删除前景，不删解释”的意识

pointer 被 clear 了，  
但 user-facing error 还在。  
needsRefresh 未来可被消费，  
但 install / update metrics 仍可追。

这说明它已经开始把：

`前景状态`

和

`解释线索`

分开对待。

## 9. 但真正严格地说，这套遗忘审计还没有完全完成

这里必须保持严格。

从源码推断，  
Claude Code 已经有 cleanup audit 的雏形，  
但还没有统一协议。

### 9.1 它目前是“零散留痕”，还不是“结构化审计”

今天的线索散落在：

1. `logForDebugging`
2. `logEvent`
3. `logForDiagnosticsNoPII`
4. `console.error`
5. comments + fallback branches

这已经很有价值，  
但还不足以称为统一 cleanup ledger。

### 9.2 不是所有 cleanup 都有对称级别的审计强度

例如：

1. bridge cleanup 的审计密度很高
2. plugin refresh 次之
3. notification 层则主要依赖生命周期控制，本身缺显式审计记录

所以第二个严格结论是：

`Claude Code 已有不均匀的 cleanup audit，而不是完全一致的 cleanup audit。`

## 10. 哲学本质：系统最危险的遗忘，不是删除，而是“删除且无人能解释”

这是这一章真正的哲学核心。

很多人以为删除动作的风险只是：

`删早了。`

但更深的风险是：

`删完之后，系统再也没人能解释这次删除到底为什么发生。`

前者还是状态错误，  
后者已经是认识论错误。

Claude Code 值得学的地方就在于，  
它至少在关键路径上已经开始避免这种情况：

`即便要让某个痕迹退出前景，也尽量保留对退出因果的可回查线索。`

这说明它对安全的理解已经不是：

`把错误藏起来`

而是：

`让错误在退出前景后，仍保留可解释历史。`

## 11. 苏格拉底式反思：如果要把这套遗忘审计再推进一代，还缺什么

继续追问，仍能看到几个明显的下一步。

### 11.1 需要统一的 cleanup audit schema

下一代控制台最值得加的，不是更多散落 log，  
而是一组统一字段，例如：

1. `cleanup_owner`
2. `cleanup_reason`
3. `cleanup_gate`
4. `cleanup_replaced_by`
5. `cleanup_audit_id`

否则今天这些线索仍然太分散。

### 11.2 需要显式区分“清理成功”与“清理尝试失败”

现在一些路径已有 fallback debug，  
但还没形成统一的 cleanup-attempt / cleanup-applied / cleanup-deferred 三分语义。

### 11.3 需要把弱 surface 的“不可清理性”也显式审计

也就是：

`这次没有清，不是遗漏，而是因为当前 layer 不配清。`

这会让系统的解释力再上一个层级。

## 12. 本章结论

把 `134` 再推进一层后，  
Claude Code 安全性的更深结构就变得更完整了：

`它不只治理谁配清理。`

它还开始治理：

1. 清理动作是否留痕
2. fallback 是否可回查
3. 删除前景后是否仍保留解释因果
4. 关键遗忘是否具有最低限度的审计线索

所以如果要真正学习 Claude Code 的安全设计启示，  
最值得学的不是“怎么把界面清干净”，  
而是：

`如何让合法遗忘仍然是可解释、可追责、可回放的遗忘。`

