# 安全能力撤回主权：为什么不是任何层都能撤回已发布入口，必须由authoritative publisher改口

## 1. 为什么在 `71` 之后还要继续写“能力撤回主权”

`71-安全能力发布主权` 已经回答了：

`不是任何接入层都能把能力显示成可用入口，只有 authoritative publish set 才有资格宣布“现在可用”。`

但如果继续往下追问，  
还会出现一个同样重要、却更容易被忽略的问题：

`那谁有资格把一个已经显示出来的入口撤回、降级或静默？`

因为能力发布一旦成立，  
用户心中就已经形成了“这项能力存在且可达”的前台事实。  
这时撤回入口不是普通 UI 刷新，  
而是在推翻先前的安全承诺。

所以在 `71` 之后，  
安全专题必须再补一条对称原则：

`能力撤回主权。`

也就是：

`不是任何 adapter、任何镜像层、任何局部状态都能把已发布入口撤回；只有掌握对应发布主权的 authoritative publisher，才有资格正式改口。`

## 2. 最短结论

从源码看，Claude Code 已经在多个地方把“撤回入口”的主权写成了硬规则：

1. REPL 收到 remote authoritative `slash_commands` 后，只保留远端声明的命令与本地 `REMOTE_SAFE_COMMANDS`，本地不得继续保留更多入口  
   `src/screens/REPL.tsx:1379-1384`
2. remote mode 启动前先按 `filterCommandsForRemoteMode()` 预先收窄，避免后续再被动撤回一批 local-only 命令  
   `src/main.tsx:3337-3345,3484-3492`  
   `src/commands.ts:678-686`
3. MCP config 变更后，`excludeStalePluginClients(...)` 会把 stale client 从当前集合中剔除，并取消旧 timer / 旧 onclose / 旧 cache 链  
   `src/services/mcp/useManageMCPConnections.ts:782-836`
4. project MCP server 若未获 `approved`，根本不会进入 merge；换言之，一旦 approval 失效，配置层就有权撤掉它的可见资格  
   `src/services/mcp/utils.ts:351-372`  
   `src/services/mcp/config.ts:1231-1248`
5. CLI/IDE 输出 capability 时，会在 allowlist 不成立时显式删除 `experimental['claude/channel']`，避免已经不合法的入口继续显示成按钮  
   `src/cli/print.ts:1666-1688`

所以这一章的最短结论是：

`能力撤回不是普通隐藏动作，而是一次主权改口。`

我把它再压成一句：

`谁有资格发布入口，谁才有资格正式撤回它。`

## 3. 源码已经说明：Claude Code 把“入口撤回”也当成安全对象在管理

## 3.1 remote authoritative init 一到，本地命令面就必须服从收窄

`src/screens/REPL.tsx:1379-1384` 很关键。

`handleRemoteInit(remoteSlashCommands)` 收到远端 authoritative publish set 后，
本地直接：

1. 建立 `remoteCommandSet`
2. 仅保留 `remoteCommandSet` 命中的命令
3. 外加本地 `REMOTE_SAFE_COMMANDS`

这意味着本地 REPL 在这里没有资格说：

`我记得之前这里还有更多命令，不如先保留着`

因为一旦远端 init 已经明确给出新的 publish set，  
本地镜像层就只能：

`服从收窄`

而不能继续维持旧入口。

这就是撤回主权的第一条原则：

`镜像层只能跟随撤回，不能抵抗撤回。`

## 3.2 最成熟的撤回往往是前置撤回：不让错误入口先出现

`src/main.tsx:3337-3345,3484-3492` 与 `src/commands.ts:678-686` 一起说明：

进入 remote mode 时，  
系统不会先把全量命令展示出来，  
再等 authoritative init 到来后撤掉一部分。

它会先做：

`filterCommandsForRemoteMode(commands)`

把 local-only 命令前置撤掉。

这条设计的重要含义是：

`最佳的撤回不是事后撤回，而是事前不发布。`

也就是说，  
能力撤回主权不仅决定谁能“删掉入口”，  
也决定谁有资格把撤回前移成预防性不暴露。

这是比普通“动态隐藏按钮”更高级的安全设计。

## 3.3 stale MCP client 的撤回也必须由配置主权层统一执行

`src/services/mcp/useManageMCPConnections.ts:782-836` 是这一章的核心证据之一。

这里当 config 变化后，  
系统先通过：

`excludeStalePluginClients(prevState.mcp, configs)`

把 stale client 从当前集合中拆出来，  
然后再执行三类撤回配套动作：

1. 清掉 pending reconnect timer
2. 解除旧 `onclose` closure
3. 清理旧 cache

作者甚至直接列了三类 hazard：

1. old timer 带着 old config 再次触发
2. old `onclose` 带着 old closure 重新抢写状态
3. old cache 在错误对象上诱发假连接

这说明 stale client 的撤回不是局部 UI 行为，  
而是：

`必须由配置主权层统一宣布“它已不再属于当前可见能力集合”，并同步拆掉旧执行链。`

如果只是某个界面把它藏起来，  
但旧 timer、旧 closure、旧 cache 仍活着，  
那不叫撤回，  
只是：

`伪隐藏。`

## 3.4 project MCP approval 的失效，本质上也是一种能力撤回

`src/services/mcp/utils.ts:351-372` 定义了 project server 的状态：

1. `approved`
2. `rejected`
3. `pending`

而 `src/services/mcp/config.ts:1231-1248` 最终只把 `approvedProjectServers` 放进 merge，并继续过 policy filter。

这意味着 project MCP server 的撤回逻辑不是：

`谁想隐藏就隐藏`

而是：

`审批主权层改变状态后，配置主权层据此把它移出最终可连接集合。`

所以 approval 的失效不是纯标签变化，  
而是：

`一次正式的能力撤回。`

这说明撤回主权在 Claude Code 里并不是“界面层删按钮”，  
而是从：

`审批结论 -> 配置集合 -> 连接集合 -> 可见入口`

整条链一路下传。

## 3.5 channel capability 被 allowlist 删除时，输出层必须同步改口

`src/cli/print.ts:1666-1688` 更直接体现了这件事。

这里作者不是单纯读取底层 capability 然后原样输出，  
而是：

1. 复制 `experimental`
2. 检查 `exp['claude/channel']`
3. 若 channels 未启用或 pluginSource 不在 allowlist
4. 直接 `delete exp['claude/channel']`

注释说明目的就是：

`avoids dead buttons`

这说明即便底层连接对象本身还在，  
输出层也没有资格继续保留一个已经失去 allowlist 主权支撑的入口。

换句话说，  
`capability` 的撤回也要遵守：

`如果上游主权已收回，输出层必须同步改口。`

否则就会形成一种非常典型的 overclaim：

`系统明知某项能力不该再被启用，却仍让前台按钮继续活着。`

## 3.6 第一性原理：撤回和发布一样，都是主权动作，不是显示动作

如果从第一性原理追问：

`为什么入口撤回不能交给任意层自己处理？`

因为入口一旦被显示过，  
它就已经不再是普通渲染对象，  
而是一段对用户心智模型的承诺。

所以撤回一项入口，  
本质上就是在说：

`之前那段承诺现在不再成立。`

这显然不是任何镜像层都能越权说的话。

于是就会得到能力撤回主权的第一性原理：

`revocation is a sovereign act.`

进一步展开，就是：

1. 撤回必须服从原发布主权
2. 镜像层只能传播撤回，不能自造撤回或抵抗撤回
3. 如果上游主权已经收回，低层继续保留入口就是越权 overclaim

## 4. 苏格拉底式自问：为什么不能让每个表面各自决定什么时候隐藏入口

### 4.1 如果表面发现入口点不通，自己先隐藏不就好了

不够。

因为“点不通”只是局部症状，  
不等于“能力主权已收回”。

局部失败可能是：

1. 网络暂时抖动
2. init 尚未同步
3. 本地镜像滞后

如果每个表面都能按局部症状自作撤回，  
系统就会形成新的撤回裂脑。

### 4.2 那为什么某些地方又会前置撤回、直接不显示

因为那些地方掌握的是：

`更高、更早、更 authoritative 的 publish condition`

例如 remote mode 预过滤，  
掌握的是 remote-safe command set；  
CLI capability pre-filter，  
掌握的是 allowlist condition。

它们不是“局部猜测”，  
而是在执行上游主权。

### 4.3 撤回和隐藏到底有什么区别

隐藏只是表现。  
撤回则意味着：

`这项能力不再配被这个表面承诺为“现在可用”。`

所以真正的撤回一定包含：

1. 上游主权变化
2. 可见集合变化
3. 下游表面的同步改口

### 4.4 为什么 dead button 也是安全问题

因为它虽然没让能力立刻越权执行，  
却已经让用户获得了错误心智模型：

`这个入口似乎仍被系统认可。`

对高安全系统来说，  
错误的能力预期本身就是一种安全债。

## 5. 技术先进性与技术启示

这一章最重要的技术判断是：

`Claude Code 的先进性不只在于它能把能力发布做成主权动作，还在于它能把能力撤回同样做成主权动作。`

它先进的地方有六点：

1. authoritative publish set 一变，本地命令面就必须收窄
2. remote mode 用预过滤减少后续撤回成本
3. stale MCP client 的撤回伴随 timer / closure / cache 一起清链
4. project MCP approval 的变化会一路传导到最终可见集合
5. capability field 本身可以被输出层按 allowlist 条件撤回
6. 系统宁可前置删入口，也不让 dead button 长期存在

对其他 Agent 平台构建者的直接启示有六条：

1. 把 capability revocation 当成和 capability publish 对称的主权动作
2. 镜像层只能传播 authoritative revoke，不要自作主张
3. 撤回时不仅要删按钮，还要拆 timer、closure、cache 这些旧执行链
4. dead button 应被视作错误承诺，而不是小瑕疵
5. 任何“局部失败即局部撤回”的设计都要警惕撤回裂脑
6. 最好的撤回往往是上游条件不成立时直接不发布

## 6. 一条硬结论

对 Claude Code 这类安全控制面来说，  
真正危险的不是入口消失，  
而是：

`上游主权已经收回能力，低层表面却还在继续替它作“现在可用”的承诺。`

所以比“能力发布主权”更完整的一条原则是：

`能力的发布与撤回都必须服从同一个 authoritative publisher。`
