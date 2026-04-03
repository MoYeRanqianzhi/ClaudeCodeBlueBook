# 安全状态机宪法：为什么Claude Code不仅定义状态，还封死非法跃迁、旧写者回魂与假恢复

## 1. 为什么在 `131` 之后还必须继续写“宪法”

`131-安全真相状态机` 已经把 Claude Code 的安全控制面推进到一个更高层结论：

`它不是在维护散点规则，而是在维护多组可进入、可续签、可降级、可恢复、可终止的安全状态机。`

但如果继续追问，  
还会碰到一个比“状态机”更尖锐的问题：

`有状态机，是否就等于安全？`

答案是否定的。

因为很多系统也有状态，  
但它们依然不安全。  
真正的问题不在于：

`系统有没有状态名，`

而在于：

`系统有没有封死那些本不该发生的状态跃迁。`

也就是：

1. 能不能从旧上下文直接回写新状态
2. 能不能让 stale timer 在错误时机把旧世界写回来
3. 能不能让错误修复路径伪装成正确修复路径
4. 能不能在已不成立时继续打印看起来成立的承诺

所以 `131` 之后必须继续补出的下一层就是：

`安全状态机宪法`

也就是：

`Claude Code 的真正高级性不只在于定义状态，而在于它显式禁止非法跃迁、旧写者回魂与假恢复。`

## 2. 最短结论

Claude Code 安全设计真正成熟的一点，不只是它把很多对象做成状态机，  
更在于：

`它为这些状态机定义了不能走的捷径。`

从源码看，这套“宪法性禁令”至少已经体现在六类地方：

1. 同态切换不算跃迁，防止伪 leave branch  
   `src/utils/permissions/permissionSetup.ts:602-603`
2. auto mode 未过 gate 时禁止进入  
   `src/utils/permissions/permissionSetup.ts:627-630`
3. `insufficient_scope` 禁止走 refresh 假升级  
   `src/services/mcp/auth.ts:1625-1650`
4. cached `needs-auth` 时禁止继续盲连  
   `src/services/mcp/client.ts:2308-2321`
5. stale MCP client 禁止让旧 timer / 旧 closure 回写新状态  
   `src/services/mcp/useManageMCPConnections.ts:791-810`
6. fatal bridge 退出后禁止打印可恢复承诺，避免对用户说谎  
   `src/bridge/bridgeMain.ts:1515-1522`

所以这一章的最短结论是：

`安全状态机若没有非法跃迁禁令，就仍只是一个容易被旧上下文篡改的动态缓存。`

再压成一句：

`真正被保护的，不只是状态，而是状态变化的合法性。`

## 3. 第一性原理：为什么安全最终要从“状态枚举”升级到“跃迁宪法”

状态枚举只回答：

`系统现在可以把自己描述成什么。`

但安全系统真正危险的地方往往不是“描述词不够多”，  
而是：

`系统在不该改口的时候改口了。`

这类失真通常来自四种根源：

1. 旧上下文覆盖新上下文
2. 异步等待期间发生并发切换
3. 旧定时器或旧闭包在新世界里复活
4. 修复路径看起来相似，但安全强度其实不同

所以成熟系统必须继续追问：

1. 哪些 transition 是合法的
2. 哪些 transition 绝不能发生
3. 一旦发生竞争，谁的写入必须失效
4. 哪种成功外观本质上是假成功

这就是“状态机宪法”的意义。

它比状态机更进一步，  
因为它关心的不是：

`系统能处于哪些状态，`

而是：

`系统绝不允许通过哪些路径到达某个状态。`

## 4. Claude Code 的宪法性高级点，不在“状态多”，而在“禁令硬”

### 4.1 同态切换不算跃迁，先封死伪状态变化

`src/utils/permissions/permissionSetup.ts:602-603` 很短，但非常关键：

1. `fromMode === toMode` 直接返回
2. 明确避免 `plan -> plan` 错打到 leave branch

这说明作者非常清楚：

`不是所有 set_mode 都配被解释成真实跃迁。`

这条禁令的哲学意义是：

`安全系统必须先区分“请求变化”与“真实变化”。`

否则系统会因为一次伪跃迁，  
误触发退出副作用、恢复动作或解释面更新。

### 4.2 auto mode 未过 gate 时，禁止直跳高风险态

同文件 `627-630` 更直接：

1. 如果要进入 auto / classifier 侧
2. 先看 `isAutoModeGateEnabled()`
3. 未开启就 `throw`

也就是说：

`高风险状态不是“想进就进”，而是“未获宪法许可就根本不能跳”。`

这比普通 guard 更重，  
因为它不是在进入后补救，  
而是在跃迁边界上直接否决。

### 4.3 refresh 不能假装完成 step-up

`src/services/mcp/auth.ts:1625-1650` 几乎是在写一条安全宪法：

1. 若已检测到 `insufficient_scope`
2. 且当前 token 不包含所需 scope
3. 则 `needsStepUp`
4. 此时要省略 `refresh_token`
5. 因为 refresh 不能提升 scope

这条禁令非常重要，  
因为它封死了一条“看起来合理、实际上错误”的近邻路径：

`授权级别不够 -> refresh 一下 -> 假装问题解决`

Claude Code 明确拒绝这条路径。  
它要求系统承认：

`step-up 与 refresh 不是同一类修复。`

这是一种非常成熟的安全思维。

它不是问：

`有没有办法继续往前走？`

而是问：

`这条继续往前走的路径，会不会把较弱证明伪装成较强证明？`

### 4.4 `needs-auth` 缓存禁止连接风暴与假恢复

`src/services/mcp/client.ts:2308-2321` 也很典型：

1. 如果 auth failure 已缓存
2. 或者 discovery 有了但 token 没有
3. 就直接 `Skipping connection (cached needs-auth)`
4. 并把状态表述成 `needs-auth`

这说明 Claude Code 不是“失败了就继续试，直到看起来又连上”。  
它明确封死了一条错误捷径：

`needs-auth -> connect spam -> 假装可以靠重试自然恢复`

它逼系统说真话：

`现在不是 reconnectable，而是需要先补认证。`

### 4.5 旧 timer、旧 closure、旧 config 不得回魂

`src/services/mcp/useManageMCPConnections.ts:791-810` 是这一章最有价值的证据之一。

作者在注释里非常坦率地把风险说穿了：

1. pending reconnect timer 会带着 `OLD config` 触发
2. `onclose` 里的 closure 会带着 `OLD config` 启动重连
3. 它可能与 fresh connection 竞争，最后变成 `last updateServer wins`

所以他们做了三件事：

1. 清掉旧 reconnect timer
2. 删除旧 client 的 `onclose`
3. 只对真正 `connected` 的 stale client 做清理

这不是一般意义上的 cleanup。  
这是：

`禁止旧世界在新世界里继续拥有写权。`

这是运行时安全里非常深的一层。

很多系统不是没有状态机，  
而是没有处理：

`旧写者回魂`

一旦旧 timer、旧 closure、旧 callback 还能写状态，  
系统就会出现最危险的安全裂脑：

`新真相刚建立，旧真相又把它改回去。`

Claude Code 在这里是明确设防的。

### 4.6 disable 必须先写盘，再允许断开副作用发生

`src/services/mcp/useManageMCPConnections.ts:1093-1096` 也值得单列。

这里作者要求：

1. 禁用 server 时
2. 必须先把 disabled state 持久化到磁盘
3. 再去清 cache / 断连接

原因写得很清楚：

`onclose handler checks disk state`

也就是说：

`系统要先更新权威状态，再触发会读这个状态的副作用。`

否则就会出现一个典型非法跃迁：

`我明明在关掉 server，但 onclose 却把它当成临时断线，又自动拉起来了。`

这条禁令说明 Claude Code 非常重视：

`先改宪法账本，再放副作用执行。`

## 5. 安全状态机最怕的不是“失败”，而是“错误路径太像正确路径”

这是 Claude Code 源码里反复出现的一个深层主题。

### 5.1 stale snapshot 看起来像 current context

`src/utils/permissions/permissionSetup.ts:1035-1041` 解释了为什么 auto gate check 返回的是 transform function，  
而不是预计算好的 context：

1. async GrowthBook await 期间
2. 用户可能已经 mid-turn 切 mode
3. 如果直接返回旧 context，  
   就会把用户的新 mode 覆盖掉

也就是说：

`旧快照看起来像 context，其实已经不再有资格写回 current context。`

这是经典的非法跃迁问题。

### 5.2 stale cache 看起来像 truth

`remoteManagedSettings/index.ts:432-442,492-501` 之所以重要，  
就是因为 Claude Code 不把 stale cache 假装成 fresh truth。

它允许 stale cache 临时驻留，  
但会显式把它当成 degrade 路径处理。

也就是说：

`可以临时借住，但不能篡位。`

### 5.3 refresh 看起来像 re-auth，其实不是

这在 step-up 一节已经看到：

`refresh` 与 `re-auth` 长得很像，  
但安全强度不同。

Claude Code 不允许它们被混用。

### 5.4 resume hint 看起来像善意提示，其实可能是错误承诺

`src/bridge/bridgeMain.ts:1515-1522` 几乎是把“不要说谎”直接写进注释：

1. fatal 退出场景下，resume 已不可能
2. 若此时仍打印 resume command
3. 这条命令就会变成 `a lie`
4. 还会与已打印的错误相矛盾

这说明 Claude Code 理解到：

`错误承诺本身也是一种安全故障。`

这件事的哲学含义非常重。

因为很多系统把安全只理解成“是否阻断危险动作”，  
而 Claude Code 进一步理解成：

`系统不得对用户发布自己已经不再能兑现的恢复承诺。`

## 6. bridge pointer 设计说明：恢复资产也受宪法约束

`src/bridge/bridgeMain.ts:2700-2728` 又展示了另一类禁令：

1. pointer 立即写入，保证 crash 后有 recoverable trail
2. pointer 按小时刷新，避免因 stale 丧失恢复资格
3. 但 pointer 只在 `single-session` 下写
4. 因为 multi-session 下写 pointer 会与用户实际配置矛盾

这说明：

`不是任何恢复工件都能在任何上下文里存在。`

恢复资产也有自己的宪法：

1. 什么时候配被签发
2. 什么时候必须续保
3. 什么时候必须清掉
4. 什么时候即使存在也不能继续解释成“可恢复”

## 7. 技术先进性：Claude Code 为什么比普通状态机更进一步

普通状态机系统做到的是：

1. 列出 states
2. 列出 transitions

Claude Code 更进一步，  
它开始处理：

1. stale snapshot
2. stale closure
3. stale timer
4. stale cache
5. stale promise

这五种 stale，其实就是运行时安全的真正难点。

因为真正让系统失真的，  
往往不是“没有规则”，  
而是：

`旧世界的权力还没被收回。`

从技术角度看，这套设计至少有四个先进点。

### 7.1 它显式识别旧写者问题

`last updateServer wins`、`OLD config from closure` 这类注释说明作者不是在抽象谈状态机，  
而是在处理真实并发失真。

### 7.2 它把“不能走这条修复路径”做成一等逻辑

step-up pending 时禁止 refresh，  
就是典型例子。

### 7.3 它把状态解释诚实性也纳入安全边界

fatal exit 不打印 resume command，  
pointer 只在单会话模式下写，  
都说明：

`解释面不能说超过自己能兑现的话。`

### 7.4 它开始形成“权威状态先于副作用”的秩序

disable 先写盘，  
然后再让 onclose / reconnect 等副作用运行，  
这说明：

`副作用必须服从权威状态，而不是反过来定义权威状态。`

## 8. 哲学本质：安全的更深层定义不是“防危险”，而是“禁止不诚实跃迁”

如果从第一性原理重新压缩这一章，  
会发现 Claude Code 的安全哲学正在越来越清晰：

`安全不是只防止危险动作发生。`

它更深的定义其实是：

`系统不能通过不诚实的状态跃迁，把较弱现实伪装成较强现实。`

所谓“不诚实跃迁”，包括：

1. 用 stale snapshot 覆盖 current truth
2. 用 refresh 伪装 step-up
3. 用 blind reconnect 伪装 auth resolved
4. 用旧 closure 伪装当前 writer
5. 用 resume hint 伪装仍可恢复

所以 Claude Code 的进步，并不只是技术复杂。  
它的真正进步是：

`它越来越把“改口必须诚实”当成安全的一部分。`

## 9. 苏格拉底式反思：如果要把这套宪法再推进一代，还缺什么

继续追问，仍能看到几个未完成点。

### 9.1 非法跃迁禁令是否已经统一建模

还没有。

现在很多禁令存在于：

1. 注释
2. 分支 guard
3. timer cleanup
4. cache skip
5. 持久化顺序要求

它们很真实，  
但还不够集中。

所以第一个反问是：

`这些 forbidden transitions 什么时候才会从局部经验，升级成统一 transition constitution？`

### 9.2 旧写者撤权是否已经有统一协议

也没有完全做到。

我们已经看见 timer、closure、cache、pointer 各自都在撤权，  
但还没有统一的 stale-writer protocol。

所以第二个反问是：

`当一个对象失效时，系统是否能统一回答它的 timer、handler、cache、promise、UI projection 谁先撤权、谁后撤权？`

### 9.3 “不会说谎”的原则是否已协议化

目前只在若干高价值注释里明确出现，  
例如 `printed resume command a lie`。

这很好，  
但还不够。

所以第三个反问是：

`哪些 UI、CLI、SDK surface 被允许发布哪种恢复承诺，是否已经被正式做成词法与状态协议？`

### 9.4 非法跃迁是否已经可机检

这同样还不够。

现在不少禁令仍依赖代码评审与作者记忆。  
如果没有 assertion、property test、state transition test 去兜底，  
这些宪法未来仍可能被局部重构悄悄打穿。

所以第四个反问是：

`这些禁令什么时候会被升级成真正的 machine-checkable constitution？`

## 10. 本章结论

把 `131` 再推进一层后，  
Claude Code 安全性的更深本质就进一步清楚了：

`它不是只在管理状态。`

它更深地在管理：

1. 哪些跃迁合法
2. 哪些捷径非法
3. 哪些旧写者必须失效
4. 哪些恢复承诺已经无权继续发布

所以如果要真正学习 Claude Code 的安全设计启示，  
最值得学的不是“列一张状态表”，  
而是：

`把安全系统做成既有状态机，又有非法跃迁宪法、旧写者撤权规则与反说谎约束的运行时控制面。`

