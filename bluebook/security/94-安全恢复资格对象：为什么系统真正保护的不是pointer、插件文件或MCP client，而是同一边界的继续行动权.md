# 安全恢复资格对象：为什么系统真正保护的不是pointer、插件文件或MCP client，而是同一边界的继续行动权

## 1. 为什么在 `93` 之后还必须继续写“恢复资格对象”

`93-安全恢复新鲜度仲裁` 已经回答了：

`多个候选并存时，谁有资格代表当前活边界。`

但如果继续往下追问，  
还会遇到一个更本体论的问题：

`被仲裁、被续保、被保全、被撤销的，到底是什么对象？`

如果回答成：

`pointer 文件`

那就太浅了。  
因为 Claude Code 的源码反复说明：

1. pointer 还在，不等于可恢复
2. plugin 文件变了，不等于已生效
3. MCP client 还在内存里，不等于仍合法

所以恢复安全真正保护的对象并不是某个工件，  
而是：

`某个主体是否仍有资格在同一授权边界内继续行动`

这就是 `93` 之后必须继续补出的下一层：

`安全恢复资格对象`

## 2. 最短结论

从源码看，Claude Code 在 bridge、plugins、MCP 三条线上都在表达同一个原则：

1. 工件存在，只能证明“某物还在”
2. 恢复资格，还必须证明“它仍属于当前边界、仍新鲜、仍未被撤销、仍可被同一制度重新承认”
3. 所以真正受保护的不是文件、缓存、连接或 UI 投影，而是这些载体背后的继续行动权

最关键的证据有六组：

1. pointer 即使还在，只要 schema 错误或超过 TTL 就被清掉，说明存在性不等于资格  
   `src/bridge/bridgePointer.ts:22-40,76-113`
2. session 不存在或没有 `environment_id` 时，系统会终止 resume 并清理 pointer，说明本地工件必须服从服务端真相  
   `src/bridge/bridgeMain.ts:2380-2407`
3. environment 已换届时，系统不会把新 env 假装成旧恢复，而是降级到 fresh session 或归档旧 session 后重建  
   `src/bridge/bridgeMain.ts:2473-2489`; `src/bridge/replBridge.ts:684-747`
4. plugin 状态发生磁盘变化后，系统故意不自动宣布“已恢复”，而是要求显式 `/reload-plugins`  
   `src/hooks/useManagePlugins.ts:287-303`
5. `refreshActivePlugins()` 明确把合法激活定义为完整的 Layer-3 refresh，而不是“文件已经落盘”  
   `src/utils/plugins/refresh.ts:1-18,59-71,72-138`
6. MCP client 只要配置缺席或 config hash 改变，就会被视为 stale 并清理，以防 ghost tools 继续冒充合法能力  
   `src/services/mcp/utils.ts:171-204`; `src/services/mcp/useManageMCPConnections.ts:765-820`

所以这一章的最短结论是：

`Claude Code 保护的不是恢复工件，而是恢复资格。`

再压成一句：

`工件只是资格载体，资格才是安全对象。`

## 3. pointer 案例已经说明：文件还在，不等于恢复仍合法

## 3.1 pointer 的存在性从一开始就被降格为“候选载体”

`src/bridge/bridgePointer.ts:22-40` 已经把 pointer 定义得很清楚：

1. 它是 crash-recovery pointer
2. 它会被周期性刷新
3. 它会在 clean shutdown 后清理
4. 它只是帮助下次启动进入 resume flow 的本地载体

这说明 pointer 的制度角色从来不是：

`只要存在就自动成立`

而是：

`提供一个可被继续验证的恢复入口`

所以 pointer 在本体上不是资格本身，  
而是资格的本地索引。

## 3.2 schema、TTL 与 clear 逻辑已经证明：载体存在性不配替代资格判断

`src/bridge/bridgePointer.ts:76-113` 更直接地说明：

1. schema mismatch，清掉
2. stale 超时，清掉
3. 只有结构合法且 freshness 合格的 pointer 才返回

这意味着控制面在制度上承认的是：

`合格 pointer`

而不是：

`磁盘上某个同名文件`

所以从第一性原理看，  
pointer 只是资格的一个 carrier。

carrier 失真、过期、损坏时，  
资格并不会因为载体“物理上仍然存在”就继续自动成立。

## 4. bridge 主线继续证明：真正被恢复的是同一边界的继续行动权

## 4.1 服务端 session 真相高于本地 pointer 真相

`src/bridge/bridgeMain.ts:2380-2407` 的逻辑非常关键。

resume 流程会继续检查：

1. session 是否仍存在
2. session 是否仍带 `environment_id`

如果答案是否定的，  
系统会：

1. clear 该 pointer
2. 终止恢复

这说明本地 pointer 的存在，只能让系统说：

`这里有一个值得检查的候选`

但不能让系统说：

`它已经被承认仍可恢复`

因此恢复资格最终依赖的不是本地存在性，  
而是：

`本地载体 + 服务端边界真相`

## 4.2 environment 换届说明恢复资格绑定的是“同一边界”，不是“任一可用边界”

`src/bridge/bridgeMain.ts:2473-2489` 和 `src/bridge/replBridge.ts:684-747` 更进一步暴露了恢复资格的本体。

这里系统在做的事情不是：

`只要还能连上某个环境就算恢复`

而是：

`只有还能连回同一环境/同一边界，才算真正恢复；否则要么 fresh session，要么 archive old session 后重建`

这很重要。  
因为它说明恢复资格不是一般性的“还能工作”，  
而是特指：

`还能在原边界内继续工作`

一旦环境已换届，  
继续行动权就必须重新签发，  
不能把新边界伪装成旧边界的继续。

所以 bridge 子系统真正保护的对象是：

`同一 session-environment binding 下的连续行动权`

而不是：

`任何还能跑起来的执行上下文`

## 4.3 防旧 transport / 旧 session 复活，本质上是在保护资格对象不被借尸还魂

`src/bridge/replBridge.ts:617-747` 整段都在做一件事：

`防止旧边界在换届过程中重新写回 current`

这里包括：

1. 提升 `v2Generation`，作废 in-flight stale handshake
2. 在 stopWork / register await 期间检查 poll loop 是否已恢复
3. 同边界可原地 reconnect；异边界则 archive old session 后 fresh session

这些动作的共同目标不是“把状态修漂亮”，  
而是：

`确保只有仍属于当前边界的资格对象能回来，已失效对象不能借 race 复活`

这恰恰说明：

`恢复资格对象` 才是被治理的核心对象。

## 5. plugin 子系统给出第二个强反例：文件变了，不等于能力已恢复

## 5.1 磁盘上的 plugin state 改变，只能触发“待激活”，不能直接触发“已生效”

`src/hooks/useManagePlugins.ts:287-303` 非常有代表性。

这里作者明确说：

1. plugin state changed on disk
2. 显示 notification
3. 用户运行 `/reload-plugins` 才 apply
4. 不自动 refresh
5. 不自动 reset `needsRefresh`

这说明在 Claude Code 看来：

`插件文件已经变化`

和

`插件能力已经合法进入当前运行边界`

是两回事。

如果系统只是看到文件变了就自动宣布“已恢复”，  
就会把：

`磁盘物理状态`

误写成

`运行时资格状态`

Claude Code 没犯这个错。  
它把两者严格分开。

## 5.2 Layer-3 refresh 说明真正被恢复的是 active entitlement，而不是落盘结果

`src/utils/plugins/refresh.ts:1-18,59-71,72-138` 把这件事说得更彻底。

作者明确区分：

1. Layer 1: intent
2. Layer 2: materialization
3. Layer 3: active components

而 `/reload-plugins` 做的正是 Layer-3 refresh。

这说明 plugin 恢复真正要完成的不是：

`文件落盘`

而是：

`commands / agents / hooks / MCP / LSP / AppState 这一整套 active entitlement 的重新签发`

因此从安全本体上看，  
plugin 文件只是 materialization artifact；  
真正受保护的对象是：

`当前会话对这些 plugin-derived capabilities 的合法拥有权`

这也解释了为什么 `needsRefresh` 不能被乱清。  
因为乱清的不是一个 UI 标志，  
而是：

`对“这批能力尚未被当前边界重新承认”的事实撒谎`

## 6. MCP 子系统给出第三个强反例：client 还在，不等于工具仍合法

## 6.1 配置缺席或 hash 改变，旧 client 就会被当作 stale 对象驱逐

`src/services/mcp/utils.ts:171-204` 已经很明确：

MCP client stale 的条件包括：

1. dynamic scope 下名字已不在 configs
2. config hash changed

一旦 stale，  
系统会把其 tools、commands、resources 一并移出当前集合。

这说明 Claude Code 在 MCP 子系统里保护的也不是：

`某个 client 实例仍在内存`

而是：

`这组由配置签发的外部能力是否仍与当前配置主权一致`

所以 ghost client 最大的问题从来不是“有点脏”，  
而是：

`它继续冒充自己仍有资格发布工具`

## 6.2 连接管理层的清理逻辑，本质上是在撤销已经失效的能力资格

`src/services/mcp/useManageMCPConnections.ts:765-820` 再补上一层：

1. plugin reload 时重新初始化 pending state
2. 先剔除 stale plugin MCP servers
3. 清 timer，防止旧配置回连
4. connected stale clients 才执行 cleanup
5. 然后把新 configs 重新加入 pending 流程

这套动作的本质不是 housekeeping，  
而是：

`先撤销旧资格，再让新资格进入待签发流程`

所以从本体上看，  
MCP 子系统和 bridge / plugin 子系统在说的是同一句话：

`工件或连接能不能继续存在，不由物理残留决定，而由当前配置和边界主权决定。`

## 7. 由三条证据线可以反推出“恢复资格对象”的精确定义

综合 bridge、plugins、MCP 三条线，  
可以把 `恢复资格对象` 定义成一个五元组：

1. `carrier`
   承载它的文件、state、client、pointer、cache 或 handle
2. `boundary binding`
   它归属于哪个 session / environment / config / scope
3. `freshness proof`
   它凭什么证明自己还没过期、没被替代、没失真
4. `revocation gate`
   在什么条件下它必须被撤销、清理或降级
5. `regrant path`
   如果它失效了，要经过什么流程才可被重新签发

这样一来，很多源码现象就全说得通了：

1. pointer 会 stale clear
2. session 会因 env mismatch 失去 resume entitlement
3. plugins 会卡在 `needsRefresh`
4. MCP stale clients 会被清理并重新 pending

因为它们共同治理的都不是“东西在不在”，  
而是：

`这份资格还能不能继续被当前边界承认`

## 8. 哲学本质：安全不是保存对象，而是保存合法性

这一章最该压出来的哲学结论是：

`安全控制面的任务不是尽量保留一切对象，而是尽量只保留仍合法的对象。`

如果把系统目标误写成“尽量别丢文件”，  
就会走偏：

1. stale pointer 会 linger
2. old session 会假续命
3. plugins 会在未激活前就假装已生效
4. stale MCP clients 会继续发布 ghost tools

而 Claude Code 明显采取了另一条路线：

`允许工件存在，但不允许资格被伪造。`

所以它真正先进的地方，不是会不会自动修复，  
而是：

`它把合法性看得比存在性更高。`

## 9. 第一性原理与苏格拉底式自我追问

## 9.1 第一性原理

如果完全不看实现细节，  
只从第一性原理问：

`恢复系统必须避免的最坏事情是什么？`

答案不是：

`某个文件丢了`

而是：

`某个已经失去资格的对象，被重新认证成 current`

因为前者主要是可用性损失，  
后者才是边界失真。

所以恢复安全的首要目标应当是：

`只让仍有资格的对象回来`

## 9.2 苏格拉底式追问

可以继续逼问六个问题：

1. 如果 pointer 还在，为什么系统仍要去问 server 上 session 是否存在？
2. 如果 plugin 文件已经更新，为什么还不允许直接宣布已生效？
3. 如果 MCP client 仍连着，为什么 config hash 一变就要把它当 stale？
4. 如果环境已经换届，为什么不能把新环境说成旧会话的继续？
5. 如果某个对象只是物理残留，凭什么继续发布能力或代表当前边界？
6. 如果 cleanup 看起来很“激进”，它真在删对象，还是在撤销已失效资格？

这些问题最终都会收敛到同一条答案：

`Claude Code 不是在保护对象，而是在保护对象背后的合法继续行动权。`

## 10. 对目录结构与后续研究的启示

写到这里，安全专题在恢复域已经形成了比较稳定的层次：

1. `恢复资格`
   能不能恢复
2. `恢复资产`
   哪些载体必须保留
3. `恢复续保`
   这些载体如何持续保持新鲜
4. `恢复仲裁`
   多个候选并存时谁胜出
5. `恢复对象本体`
   真正被治理的到底是不是载体本身

这意味着后续章节如果继续往下写，  
最自然的推进方向会是：

`恢复资格对象的签发、降级、撤销与重签发是否应被显式句柄化`

因为源码已经隐含了这一套语义，  
只是还没有完全产品化地外露。

## 11. 给系统设计者的技术启示

最后把这一章压成六条工程启示：

1. 不要把 artifact presence 当作 entitlement proof
2. 让服务端真相、配置真相和本地真相形成明确优先级
3. 把“已 materialize”与“已 activate”严格拆开
4. 对 stale object 的清理，要理解成 revocation 而不是 housekeeping
5. 对重连/刷新/激活流程，要显式表达 regrant path，而不是让用户靠直觉猜
6. 把“仍可继续行动”当成安全对象，系统的很多边界设计会自动变清楚

这一章最终要守住的一条硬结论是：

`对 Claude Code 这类安全控制面来说，真正需要被保护的从来不是工件本身，而是工件背后那份仍被当前边界承认的继续行动权。`
