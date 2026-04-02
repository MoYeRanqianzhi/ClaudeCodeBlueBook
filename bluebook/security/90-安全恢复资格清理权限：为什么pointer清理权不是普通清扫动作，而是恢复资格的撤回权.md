# 安全恢复资格清理权限：为什么pointer清理权不是普通清扫动作，而是恢复资格的撤回权

## 1. 为什么在 `89` 之后还要继续写“恢复资格清理权限”

`89-安全恢复资格降级语法` 已经回答了：

`不同恢复失败必须被降级成不同语义，而不能压成同一句“无法恢复”。`

但如果继续往下追问，  
还会碰到一个更偏主权、也更偏执行纪律的问题：

`这些不同的降级结果里，到底谁有权清掉恢复资格？`

因为一旦系统决定：

1. 清 pointer
2. 不再 re-prompt
3. 不再打印 `--continue`
4. 不再保留 retry mechanism

它实际上执行的就不只是“清理一下旧文件”。  
它是在正式做一件更重的事：

`撤回恢复资格。`

而资格撤回和状态清扫不是一回事。  
如果任何局部层都能随手清掉 pointer 或移除恢复入口，  
系统就会把：

1. 暂时失败但仍可 retry 的边界
2. 挂起但仍可恢复的边界
3. 已退役、已 stale、已 fatal 的边界

全部错误地压到同一种“已清理”。

所以在 `89` 之后，  
安全专题还必须再补一章，把“结果语法”继续推进成一条更明确的主权规则：

`恢复资格清理权限。`

也就是：

`成熟控制面不仅要知道何时该降级恢复资格，还必须明确只有掌握 stale、fatal、retire 等真相的层，才有权执行恢复资格的清理与撤回。`

## 2. 最短结论

从源码看，Claude Code 已经把 pointer 清理权收得相当克制：

1. standalone shutdown 只有在不走 resumable early return 时，才 archive+deregister 并 `clearBridgePointer(config.dir)`  
   `src/bridge/bridgeMain.ts:1515-1577`
2. 没有 `--continue` 时清 pointer，是因为上一轮 crash 留下的 pointer 已被主流程认定为 stale，不该继续 linger  
   `src/bridge/bridgeMain.ts:2316-2326`
3. resume path 上 session 不存在或没有 `environment_id` 时，系统会清对应 `resumePointerDir`，因为这类对象已不再具备恢复资格  
   `src/bridge/bridgeMain.ts:2384-2404`
4. reconnect failure 只有在 `fatal` 时才清 pointer；`transient` 必须保留 pointer，因为它本身就是 retry mechanism  
   `src/bridge/bridgeMain.ts:2524-2534`
5. REPL perpetual teardown 明确保留并刷新 pointer，因为该边界被定义为挂起可恢复，而不是退役  
   `src/bridge/replBridge.ts:1595-1615`
6. REPL non-perpetual clean exit 则会在 archive+deregister 之后清 pointer，表示恢复资格已正式撤回  
   `src/bridge/replBridge.ts:1618-1663`
7. pointer reader 也只在 schema invalid 或 TTL stale 时清文件，说明 carrier 的自清理权也被限制在少数高确定性场景  
   `src/bridge/bridgePointer.ts:76-113,186-202`

所以这一章的最短结论是：

`Claude Code 把 pointer 清理权当成恢复资格撤回权，而不是普通 housekeeping。`

我把它再压成一句：

`clear 不是扫地，是撤权。`

## 3. 源码已经说明：恢复资格的清理权必须和边界真相绑在一起

## 3.1 resumable shutdown 的 early return 说明：不是想清就能清

`src/bridge/bridgeMain.ts:1515-1538` 是这章最强的证据之一。

这里主流程明确写出：

1. 如果当前是 `single-session`
2. 已知 `initialSessionId`
3. 且不是 `fatalExit`

那么就要：

1. 打印 `--continue`
2. 跳过 archive+deregister
3. 直接 return

这意味着什么？

意味着即便主流程完全有能力继续往下执行清理，  
它也被自己的制度规则约束住了：

`当前不配清。`

因为一旦清掉，  
就会把仍真实存在的恢复资格错误撤回。

所以源码已经很清楚：

`清理能力不是“有代码路径就能做”，而是“满足撤回条件才配做”。`

## 3.2 archive+deregister 之后才清 pointer，说明清理动作必须站在退役事实之后

`src/bridge/bridgeMain.ts:1540-1577` 很有代表性。

这里的顺序是：

1. archive sessions
2. deregister environment
3. 然后才 `clearBridgePointer(config.dir)`

这不是随便写的顺序。  
它实际上表达的是：

`只有当控制层已经拥有“边界正式离线、恢复承诺不再真实”的事实时，才有资格清掉恢复 carrier。`

换句话说，  
pointer 清理的 signer 不是文件系统，  
而是：

`掌握退役真相的主流程。`

## 3.3 stale-candidate cleanup 之所以允许自动发生，是因为它站在高确定性失效事实之后

`src/bridge/bridgePointer.ts:76-113` 的清理逻辑只覆盖：

1. invalid schema
2. stale mtime > 4h

这说明 carrier 层并不是没有清理权，  
但它的清理权被严格限制在：

`高确定性、无需再问上层语义的失效事实。`

也就是说，  
carrier 层最多配做：

`格式已坏`  
`时间已过`

这类硬门槛清理。  
它并不配根据更高层的：

1. transient / fatal
2. resumable / retryable
3. suspend / retire

去自行宣布撤回资格。

这就是一个很成熟的主权分层。

## 3.4 `!session` 与 `!environment_id` 的清理权属于对象核验层，而不属于 pointer 自己

`src/bridge/bridgeMain.ts:2384-2404` 更能说明这点。

这里 pointer 本身没有发现问题，  
真正发现问题的是：

1. session fetch
2. `environment_id` verification

因此执行 `clearBridgePointer(resumePointerDir)` 的也不是 pointer reader 本身，  
而是已经掌握对象核验结果的 resume verifier。

这说明恢复资格清理权会随着真相层级上移而上移：

1. carrier 层只能清 carrier 级失效
2. object 层才能清 object 级失效

这非常符合安全控制面的设计哲学：

`谁发现哪一级真相，谁才配撤回那一级资格。`

## 3.5 `fatal` 才清、`transient` 不清，说明清理权还必须服从失败等级语义

`src/bridge/bridgeMain.ts:2524-2534` 把这一点说得很透。

源码明确写出：

1. `Clear pointer only on fatal reconnect failure`
2. transient failure 要保留 pointer
3. 因为保留 pointer 本身就是 retry mechanism

这说明 pointer 清理权在这里还要再接受一层限制：

`失败等级语义`

也就是说，  
即便当前路径已经知道“这次没恢复成功”，  
它仍然不能立刻清 pointer。  
它还必须先证明：

`这不是一个仍应保留恢复资产的 retryable 失败。`

所以清理权不是 failure 权限的自动副产物，  
而是：

`failure classification 之后才可能被授予的撤回权限。`

## 3.6 REPL perpetual 路径保留 pointer，说明 suspend 态天然带有“禁止清理”保护

`src/bridge/replBridge.ts:1595-1615` 非常关键。

perpetual teardown 明确：

1. 不发 result
2. 不 stopWork
3. 不 archive
4. 不 clear pointer
5. 反而刷新 pointer mtime

这说明 suspend 态在 Claude Code 里不是一个“可选保留”的温和状态，  
而是一种带保护语义的制度状态：

`在 suspend 态，清理恢复 carrier 默认是被禁止的。`

因为系统已经明确判断：

`边界还活着，只是本地退出。`

所以这里不仅是“选择保留”，  
更是：

`对清理动作的显式禁止。`

## 3.7 non-perpetual clean exit 的 clear 才是真正的资格撤回

`src/bridge/replBridge.ts:1618-1663` 则对应另一端。

这里的顺序是：

1. send result
2. stopWork + archive
3. deregister
4. 然后 clear pointer

这说明 non-perpetual clean exit 并不是简单退出，  
而是明确执行了一次：

`恢复资格正式撤回。`

所以这条路径的 `clear` 不是清缓存，  
而是在做：

`revocation ceremony`

它告诉系统和用户：

`这个边界现在已不再允许被继续恢复。`

## 3.8 第一性原理：恢复资格清理权本质上是资格撤回权

如果从第一性原理再压一层，  
pointer / resume hint / re-prompt 这些东西都不是普通文件或普通文案。

它们共同承载的是一项用户侧资格：

`你仍应把旧边界视为值得继续追索的对象。`

那么清掉它们，本质上就在做：

`撤回这项资格。`

而任何资格撤回都必须回答：

1. 撤回由谁触发
2. 撤回依据什么真相
3. 哪些情形下禁止撤回
4. 哪些情形下必须撤回

这也解释了为什么 Claude Code 不允许任意局部层随手 clear pointer。

## 3.9 技术先进性：Claude Code 已经在把 cleanup authority 做成控制面规则

从技术角度看，  
很多系统会把 cleanup 理解成：

1. 看起来旧了就删
2. 失败了就清
3. 退出了就抹

而 Claude Code 更成熟的地方在于：

1. 它把 resumable shutdown 明确建成“禁止清理”
2. 它把 stale/invalid 清理限制在 carrier 层硬门槛
3. 它把 dead-session / no-env 清理限制在 verifier 层
4. 它把 fatal / transient 分流后才决定是否撤回
5. 它把 non-perpetual clean exit 的 clear 放在退役事实之后

这说明它不是在“做一点清理逻辑”，  
而是在：

`治理恢复资格的清理权限边界。`

## 4. 安全恢复资格清理权限的最短规则

把这一章压成最短规则，就是下面七句：

1. clear pointer 不等于 housekeeping，它等于撤回恢复资格
2. 只有掌握相应层级失效真相的层，才配清掉相应层级的恢复 carrier
3. carrier 层只配处理 schema/TTL 级硬失效
4. verifier 层才配处理 session gone / no environment 这类对象级失效
5. failure semantics owner 才配决定 transient 与 fatal 场景下是否撤回
6. suspend 态默认禁止清理，retire 态必须完成清理
7. 成熟控制面治理的不只是 promise issuance，还包括 promise revocation cleanup authority

## 5. 苏格拉底式追问：这套系统还能怎样再向前推进

如果继续自问，  
下一步最值得补的三项升级会是：

1. 把 cleanup authority 显式建模成字段，例如 `clearer`、`clear_reason`、`clear_level`
2. 给不同恢复 carrier 增加 `revocation_class`，区分 carrier-level、object-level、lifecycle-level 清理
3. 在统一安全控制台里直接展示“当前谁有权清理这条恢复资格、为什么还没清、什么条件下才会清”

所以这一章最终沉淀出的设计启示是：

`成熟安全系统不仅要会建立和降级恢复资格，还必须把恢复资格的清理权当成一项正式的撤回主权来治理。`
