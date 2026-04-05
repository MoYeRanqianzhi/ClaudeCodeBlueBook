# 安全恢复失败路径选择器：为什么failure ladder必须直接决定下一步repair path，而不是让用户自己猜

## 1. 为什么在 `66` 之后还要继续写“失败路径选择器”

`66-安全恢复续租失败分级` 已经回答了：

`lease failure 不是一个二元断裂，而是一条关于剩余恢复能力的分级梯子。`

但如果继续往下一层追问，  
还会出现一个最贴近用户体验和修复效率的问题：

`既然失败已经被分级，那系统下一步到底应该把用户带去哪里？`

因为 failure taxonomy 只有在能指导动作时才真正有价值。  
如果系统能区分：

1. `pending`
2. `reconnecting`
3. `auth_failed`
4. `failed`
5. `stale`

却仍然把所有用户都丢给同一句：

`请自行处理`

那么这套分级在产品层几乎没有兑现价值。

所以在 `66` 之后，  
统一安全控制台还必须再补一条制度：

`失败路径选择器。`

也就是：

`不同 lease failure 不只要有不同名字，还必须直接绑定不同的 next repair path，避免用户在 /mcp、/login、/status、/remote-control、重试命令与等待之间盲选。`

## 2. 最短结论

从源码看，Claude Code 已经在多个地方隐含了这种“failure -> repair path”映射：

1. `McpAuthTool` 对 claude.ai connector 和不支持 OAuth 的 transport，直接把用户导向 `/mcp`  
   `src/tools/McpAuthTool/McpAuthTool.ts:86-107`
2. 同一个工具在可启动 OAuth flow 时，给出 URL 并在后台自动 reconnect，说明 `needs-auth` 的默认路径是认证后重连  
   `src/tools/McpAuthTool/McpAuthTool.ts:115-205`
3. bridge 在 transport reconnect budget exhausted 时进入 `reconnecting`，随后尝试 env reconnect；若失败则落成 `failed`  
   `src/bridge/replBridge.ts:939-965`
4. work item lease expired 时，bridge 会明确改口为 `reconnecting`，并给出 `fetching fresh token` 这一路径  
   `src/bridge/replBridge.ts:1064-1071`
5. session expired 时，bridge 直接给出 `/remote-control to reconnect`  
   `src/bridge/replBridge.ts:2293-2298`
6. MCP automatic reconnection 说明 `pending` 的默认动作应是等待自动恢复，直到预算耗尽才升级为 `failed`  
   `src/services/mcp/useManageMCPConnections.ts:389-441,1112-1123`

所以这一章的最短结论是：

`failure ladder 的真正价值，在于它应直接产出下一步动作。`

我会把这条结论再压成一句话：

`没有 next repair path 的 failure taxonomy，只是更精细的困惑。`

## 3. 源码已经说明：不同 failure 在当前系统里天然对应不同 repair path

## 3.1 `needs-auth` 不是 generic failed，它默认指向认证路径

`src/tools/McpAuthTool/McpAuthTool.ts:86-107` 很关键。  
这里作者没有把认证问题写成一条模糊的失败说明，  
而是明确区分：

1. claude.ai connector  
   -> `run /mcp and select "<server>" to authenticate`
2. 不支持 OAuth 的 transport  
   -> `run /mcp and authenticate manually`

同文件 `src/tools/McpAuthTool/McpAuthTool.ts:115-205` 又说明：

1. 可用 OAuth 的情形会返回 auth URL
2. 认证完成后后台自动 reconnect
3. 失败时仍回退到 `/mcp`

这说明 `needs-auth` 并不是一种“坏了”的描述，  
而是一种非常明确的 repair selector：

`去认证，然后让系统继续重连。`

## 3.2 `pending` 的默认动作不是“修”，而是“等”

`src/services/mcp/useManageMCPConnections.ts:389-441,1112-1123` 说明：

1. automatic reconnection 会把状态先写成 `pending`
2. 期间持续消耗 retry budget
3. 只有预算耗尽才转 `failed`

这意味着 `pending` 的默认 next repair path 不是：

`立刻去做人工修复`

而是：

`优先等待自动路径继续推进`

也就是说，  
failure taxonomy 在这里已经直接决定了动作语义：

1. `pending`
   -> wait
2. `failed`
   -> escalate to manual

## 3.3 `reconnecting` 指向“系统仍在主动修”，不该和 `failed` 共用同一路径

`src/bridge/replBridge.ts:939-965` 显示：

1. transport reconnect budget exhausted 后
2. 系统不会立刻只给一个 `failed`
3. 而是先切到 `reconnecting`
4. 尝试 `reconnectEnvironmentWithSession()`
5. 失败后才落成真正的 `failed`

`src/bridge/replBridge.ts:1064-1071` 还进一步写出：

`Work item lease expired, fetching fresh token`

这说明 `reconnecting` 不是文案润色，  
而是：

`当前 repair path = 系统主动修复`

因此这一级状态的动作语义应当是：

`先等待系统完成这条自动路径，而不是立即让用户重试所有东西。`

## 3.4 `session expired` 与 `stale` 都不是 generic failed，而是指向“重建 fresh anchor”

`src/bridge/replBridge.ts:2293-2298` 给出了一个极清晰的例子：

`session expired · /remote-control to reconnect`

这说明 `session expired` 不是“随便试试”型错误。  
它对应的路径非常明确：

`去 /remote-control 重建一个 fresh remote-control anchor`

同理，  
`stale` 这类状态的本质也不是对象坏了，  
而是：

`这个对象不再配代表当前现实，需要建立 fresh 替代对象。`

所以 stale / expired 类 failure 的默认 repair path 应该是：

`rebuild fresh anchor`

而不是 generic retry。

## 3.5 `hidden` 则说明当前根本不需要 repair path

`src/hooks/useTasksV2.ts:154-170` 再次证明：

`hidden`

这种状态不是“失败后要修”，  
而是：

`没有继续暴露的必要`

这说明 failure ladder 顶端其实还包含一种常被忽略的情况：

`不是所有降级状态都该导向 repair path。`

有些状态真正的动作就是：

`no action needed`

这也是 failure taxonomy 对用户体验的一个重要贡献：

`它帮助系统避免无意义地制造修复动作。`

## 4. 第一性原理：一个 failure state 的真正价值，不在于名字，而在于它是否排除了错误动作

如果从第一性原理追问：

`为什么 failure 必须直接绑定 next repair path？`

因为系统真正要帮用户减少的，  
不是“命名模糊”，  
而是：

`错误动作选择。`

一个好的 failure state 至少应排除下面这些错误：

1. 本该等待却去乱修
2. 本该认证却去重连
3. 本该重建 fresh anchor 却继续信旧对象
4. 本该人工接管却一直等待自动恢复

所以 failure taxonomy 的最高价值，不是把状态名取得更细，  
而是：

`用状态名直接缩小用户下一步动作空间。`

## 5. 我给统一安全控制台的“failure -> repair path selector”

我会把它压成六条。

## 5.1 hidden -> no action

对象已退出前景，  
默认不产生修复动作。

## 5.2 pending -> wait / observe

系统还在自动路径里，  
先等，不要抢先人工改写。

## 5.3 reconnecting -> wait for automatic recovery

系统正在主动续租或重连，  
优先观察自动路径是否收敛。

## 5.4 auth_failed / needs-auth -> authenticate

优先刷新资格、完成 OAuth 或登录，  
而不是直接把对象判死。

## 5.5 failed -> manual repair path

自动预算已耗尽，  
转人工命令或显式修复入口。

## 5.6 stale / expired -> rebuild fresh anchor

不是继续相信旧对象，  
而是建立新的有效锚点。

## 6. 技术先进性与技术启示

这一章最重要的技术判断是：

`Claude Code 的先进性不只在于它把失败分级，还在于这些分级已经在源码里隐含了动作语义；下一步真正需要的是把这套 failure -> repair path 显式产品化。`

当前先进的地方：

1. `needs-auth` 已经天然绑定 `/mcp` / 认证流
2. `reconnecting` 已经天然绑定自动恢复路径
3. `session expired` 已经天然绑定 `/remote-control to reconnect`
4. `pending` 已经天然绑定等待而非立刻人工修

当前仍待系统化的地方：

1. 这些动作语义还没被统一抽象成同一张恢复路径表
2. 用户仍可能在多个命令之间自行猜测
3. 缺少一张正式的 “failure type -> next path” 选择器

这对其他 Agent 平台构建者的直接启示有五条：

1. 让 failure state 直接绑定下一步动作
2. 把等待也视作一种正式动作，而不是空白
3. 为 auth failure、stale、generic failed 设计不同 repair path
4. 不要把所有失败都导向同一个 help 页面
5. 把错误动作排除能力视为 failure taxonomy 的主要指标

## 7. 哲学本质

这一章更深层的哲学是：

`系统真正尊重用户，不是把状态说得多细，而是让用户少走弯路。`

失败状态如果不能减少错误动作，  
就只是更细的标签收藏。  
而成熟控制面的目标恰恰应该是：

`让每一种坏，都直接指向最短的对。`

## 8. 苏格拉底式反思：这一章最需要追问什么

### 8.1 为什么单有 failure ladder 还不够

因为用户面对的是动作选择，而不是状态分类考试。

### 8.2 什么叫真正有价值的状态分级

能直接排除错误下一步动作的分级，才有价值。

### 8.3 真正危险的错误是什么

不是状态词少一点，  
而是：

`系统已经知道 failure 根因不同，却仍让用户自己在多个 repair path 里盲猜。`


## 9. 结语

`66` 回答的是：lease failure 必须分级表达剩余恢复能力。  
这一章继续推进后的结论则是：

`这些 failure 层级还必须直接选择下一步 repair path，而不是把动作决策外包给用户。`

这意味着 Claude Code 更深层的安全启示之一是：

`成熟控制面不仅要给出正确的失败名字，还要给出正确的失败下一步。`
