# 安全恢复错误路径禁令：为什么控制面必须主动禁止邻近wrong path，而不只是提示dominant repair path

## 1. 为什么在 `67` 之后还要继续写“错误路径禁令”

`67-安全恢复失败路径选择器` 已经回答了：

`不同 failure tier 必须直接决定下一步 dominant repair path。`

但如果继续往下追问，  
还会出现一个更接近安全本质的问题：

`只给出正确路径，真的足够吗？`

答案是否定的。

因为在真实控制面里，  
用户面对的从来不是一道只有一个选项的题，  
而是一组同时可见、同时诱人的邻近路径：

1. `/mcp`
2. `/login`
3. `/status`
4. `/remote-control`
5. 等待自动恢复
6. 直接重试
7. 直接重建对象

如果系统只是告诉用户：

`当前最推荐的路径是什么`

却没有同时告诉用户：

`哪些附近路径现在绝对不能走`

那么 dominant repair path 仍然只是建议，  
还不是控制。

所以在 `67` 之后，  
统一安全控制面还必须再补一条制度：

`错误路径禁令。`

也就是：

`每个 failure tier 不只要给出 dominant repair path，还必须显式排除最容易被误选、且一旦误选就会破坏收敛的 adjacent wrong path。`

## 2. 最短结论

从源码看，Claude Code 已经隐含了大量“错误路径禁令”：

1. `pending` 表示自动恢复仍在预算内推进，所以“立刻人工抢修”是 wrong path  
   `src/services/mcp/useManageMCPConnections.ts:387-441,1112-1123`
2. `reconnecting` 表示系统正在主动续租或重连，所以“把对象判死或立刻整重建”是 wrong path  
   `src/bridge/replBridge.ts:938-965,1065-1071`
3. `auth_failed / needs-auth` 表示根因是资格失效，所以 generic reconnect 不是正确修复域  
   `src/tools/McpAuthTool/McpAuthTool.ts:86-107,115-205`  
   `src/bridge/bridgeMain.ts:198-275`
4. `session expired / stale` 表示旧锚点已失效，所以“继续信旧对象再试一次”是 wrong path  
   `src/bridge/replBridge.ts:2293-2298`  
   `src/bridge/bridgePointer.ts:22-34,56-60`
5. `hidden` 表示当前无须继续前景暴露，所以“把它升级成待修故障”本身就是 wrong path  
   `src/hooks/useTasksV2.ts:154-170`
6. `failed` 表示自动预算已耗尽，所以“继续无限等待自动恢复”也是 wrong path  
   `src/services/mcp/useManageMCPConnections.ts:417-441`

所以这一章的最短结论是：

`成熟恢复控制面的核心，不只是告诉用户去哪里修，而是主动禁止他们在错误的时候走向错误的邻近路径。`

我把它再压成一句话：

`dominant path 决定效率，forbidden path 决定安全。`

## 3. 源码已经说明：正确路径之外，系统其实也在隐式地说“不”

## 3.1 `pending` 已经在隐式禁止“抢修”

`src/services/mcp/useManageMCPConnections.ts:387-441` 很关键。

这里的 reconnect loop 在每次尝试前都会把 server 写成 `pending`，  
随后才进入 `reconnectMcpServerImpl(...)`。  
只有到最终预算耗尽时，  
它才会把对象真正落成 `failed`。

同文件 `src/services/mcp/useManageMCPConnections.ts:1112-1123` 又说明：  
启用 server 时也不是直接跳到“已恢复”或“彻底失败”，  
而是先进入 `pending`，再由 reconnect 结果决定后续状态。

这意味着 `pending` 的真正含义不是：

`出错了，你现在随便修`

而是：

`系统仍持有当前修复路径的所有权。`

因此它天然禁止的 wrong path 是：

1. 抢先人工重置对象
2. 提前把状态改口成 `failed`
3. 在自动预算尚未耗尽时切去别的人工入口

`pending` 的安全意义，不是“还没好”，而是：

`现在还不该由用户接管。`

## 3.2 `reconnecting` 已经在隐式禁止“过早宣判终局”

`src/bridge/replBridge.ts:938-965` 清楚说明：

1. transport reconnect budget exhausted 后
2. bridge 先切到 `reconnecting`
3. 然后尝试 `reconnectEnvironmentWithSession()`
4. 只有这条更高层自动路径也失败，才落成 `failed`

同文件 `src/bridge/replBridge.ts:1065-1071` 更直接：

`Work item lease expired, fetching fresh token`

这里的语义已经不是“也许坏了”，  
而是：

`系统知道当前需要的是 fresh token，不是别的。`

因此 `reconnecting` 这一层天然禁止的 wrong path 是：

1. 把对象直接判成 terminal failed
2. 在系统仍持有修复权时强行人工接管
3. 把“正在续租”误读成“必须立即整重建”

这是一种非常典型的安全设计：

`当自动路径仍拥有更短、更低损的恢复能力时，系统必须先禁止用户破坏这条路径。`

## 3.3 `auth_failed / needs-auth` 已经在隐式禁止“根因错配”

`src/tools/McpAuthTool/McpAuthTool.ts:86-107` 说明：

1. claude.ai connector 直接导向 `/mcp`
2. 不支持 OAuth 的 transport 也要求 `/mcp` 手工认证

同文件 `src/tools/McpAuthTool/McpAuthTool.ts:115-205` 又说明：

1. 支持 OAuth 的情形会给出 auth URL
2. 完成后后台自动 reconnect
3. 启动失败时再回退到 `/mcp`

`src/services/mcp/useManageMCPConnections.ts:596-603` 还把 channel auth gate 明确写成：

`Channels require claude.ai authentication · run /login`

`src/bridge/bridgeMain.ts:198-275` 则进一步说明：

1. 401/403 被归为 `auth_failed`
2. 系统会通过 `reconnectSession(...)` 触发 re-dispatch
3. 这不是 generic network failure，而是 token / entitlement 失效

所以 `auth_failed / needs-auth` 这一层真正禁止的是：

1. 把资格问题当成 transport 问题
2. 继续信旧 token 或旧登录态
3. 用 generic reconnect 掩盖 credential root cause

这里的哲学本质非常重要：

`错误路径禁令首先是一条因果纪律。`

如果根因属于资格域，  
修复动作就必须回到资格域；  
不允许用户用另一个原因域的动作去蒙对结果。

## 3.4 `stale / expired` 已经在隐式禁止“继续信旧锚点”

`src/bridge/replBridge.ts:2293-2298` 给出的是一条极强的负约束：

`session expired · /remote-control to reconnect`

这句话真正排除的不是一个按钮，  
而是一整类错法：

`不要继续围着旧 session 打转。`

`src/bridge/bridgePointer.ts:22-34,56-60` 又说明：

1. pointer 是 crash recovery anchor
2. 新鲜度依赖 mtime 续租
3. 过期并不等于文件不存在
4. 但过期后它已不配代表当前现实

因此 stale / expired 的 dominant path 是：

`rebuild fresh anchor`

同时它必须禁止的 adjacent wrong path 是：

1. 继续信旧 pointer
2. 对旧对象做 generic retry
3. 把“引用失效”误当“对象还在，所以还能继续用”

安全上最危险的不是对象消失，  
而是：

`对象还在，但已不再有资格代表现实。`

## 3.5 `hidden` 已经在隐式禁止“制造伪修复任务”

`src/hooks/useTasksV2.ts:154-170` 说明：

1. task list 在确认全体仍为 `completed` 后
2. 会 `resetTaskList(...)`
3. 然后把本地状态标成 `hidden`

这说明 `hidden` 不是一个待修故障词，  
而是一种前景退出语义。

因此它天然禁止的 wrong path 是：

1. 把隐藏态重新升级成 failed
2. 为无须前景展示的对象制造修复动作
3. 把“无需继续暴露”误读成“系统遗漏了错误”

这类禁令的价值在于：

`控制面不仅要避免修错，还要避免没事硬修。`

## 3.6 `failed` 已经在隐式禁止“无限等待”

`src/services/mcp/useManageMCPConnections.ts:417-441` 已经写明：

1. reconnect 会不断重试
2. 预算耗尽后才会最终放弃
3. 最终状态显式落成 `failed`

所以 `failed` 的含义不是：

`也许再等等`

而是：

`自动路径已经没有剩余恢复能力。`

这时它必须禁止的 wrong path 反而是：

1. 继续把它当 `pending`
2. 继续把“等”当默认动作
3. 假装系统仍在自动闭环

因此错误路径禁令并不只是禁止“过度动作”，  
也禁止“应接管而不接管”的消极错法。

## 4. 第一性原理：恢复安全的本质，是收缩动作空间

如果从第一性原理追问：

`为什么控制面必须正式维护 forbidden wrong path？`

因为恢复阶段真正昂贵的，不是状态名不够漂亮，  
而是：

`动作空间太大。`

用户一旦在错误时刻被允许尝试太多相邻路径，  
系统就会出现三种典型代价：

1. 破坏剩余自动恢复能力
2. 用错误原因域动作覆盖真实根因
3. 继续相信已失效的旧对象、旧资格或旧锚点

所以一个真正成熟的 failure tier，  
至少要同时编码三件事：

1. `还剩多少恢复能力`
2. `当前 dominant repair path 归谁所有`
3. `哪些 adjacent wrong path 必须立即排除`

我会把它压成一个更强的公式：

`failure tier = remaining recovery capacity + current repair owner + forbidden adjacent path set`

没有第三项，  
前两项就无法稳定落地。

## 5. 苏格拉底式自问：如果 dominant path 已存在，为什么还要单独写禁令

### 5.1 如果系统已经提示了“该去哪里”，为什么还不够

因为提示只是在增加正确动作的可见度，  
而禁令是在减少错误动作的可行度。

安全系统真正需要的是后者。

### 5.2 如果某些 wrong path 偶尔也能修好，为什么还要禁止

因为控制面优化的不是偶发成功故事，  
而是整体收敛率、平均修复时间和误伤成本。

偶尔能修好，  
不代表它在这个 tier 上是正确路径。

### 5.3 是否所有非 dominant path 都必须一律禁掉

不是。

真正该禁的是那些：

1. 与当前根因域不匹配
2. 会破坏剩余自动恢复能力
3. 会延续对 stale object 的错误信任
4. 会把 no-action 状态误升级成 incident

也就是说，  
要禁的是高混淆、高损失、紧邻当前正确路径的 wrong path。

### 5.4 这套禁令会不会太强，反而妨碍专家用户

不会，前提是系统把“禁令解除条件”也编码出来。

例如：

1. `pending` 预算耗尽后，manual path 解禁
2. `reconnecting` 真正失败后，full manual repair 解禁
3. `auth_failed` 完成认证后，reconnect path 才重新有效
4. `stale` 重建 fresh anchor 后，旧对象路径永久失效

所以禁令不是僵硬封锁，  
而是阶段化约束。

## 6. 技术先进性与技术启示

这一章最重要的技术判断是：

`Claude Code 的先进性不只在于它把 failure 写成更细的状态机，还在于这些状态机已经隐含了负约束；下一代产品化工作，应把这些负约束正式提升为可见规则。`

它先进的地方有四点：

1. 它已经把“等待”当成正式动作，而不是空白
2. 它已经把“认证失效”与“连接失败”分成不同原因域
3. 它已经把 stale pointer / expired session 识别成引用失效，而不是 generic failure
4. 它已经把 hidden 这种 no-action tier 从待修状态里剥离出来

对其他 Agent 平台构建者的直接启示有六条：

1. 让状态机显式编码 prohibited transitions，而不只编码 happy path
2. 让 UI 默认隐藏、降权或禁用当前 tier 下的错误入口
3. 让错误消息同时回答“现在该做什么”和“现在别做什么”
4. 把 cause domain 和 repair domain 一一对齐，禁止跨域蒙修
5. 把 stale object / stale pointer 设计成正式错误类，而不是继续混在 retry 里
6. 把 wrong-path attempt 计入遥测，作为恢复设计质量指标

## 7. 我给统一安全控制面的新增规则

如果把这一章真的产品化，  
我会要求每个 failure card 最少新增四个字段：

1. `dominant_repair_path`
2. `forbidden_adjacent_paths`
3. `block_reason`
4. `release_condition`

这样系统才能真正回答完整的恢复问题：

`现在该走哪条路、哪几条路绝不能走、为什么不能走、何时才会放开。`

## 8. 一条硬结论

对 Claude Code 这类恢复控制面来说，  
真正危险的不是状态多，  
也不是入口多，  
而是：

`系统已经知道当前最短修复路径，却仍允许用户在邻近错误路径上自由试错。`

所以比“路径选择器”更深一层的原则是：

`安全恢复不是提供建议，而是收缩动作空间。`
