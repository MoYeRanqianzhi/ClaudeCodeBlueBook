# 安全写权撤销协议：为什么Claude Code一旦认定旧上下文失效，就会撤销旧snapshot、旧timer、旧closure、旧credential与旧promise的写权

## 1. 为什么在 `132` 之后还必须继续写“撤权协议”

`132-安全状态机宪法` 已经把问题推进到：

`Claude Code 的高级性不只在于有状态机，而在于它明确禁止非法跃迁、旧写者回魂与假恢复。`

但如果继续追问，  
还会碰到一个更底层的问题：

`系统到底如何让“旧写者”真正失去写权？`

因为“禁止旧写者回魂”这句话如果落不到机制上，  
就仍然只是原则。

真正困难的地方在于，  
旧写者从来不只是一种东西。  
在运行时系统里，它至少可能以五种形式存在：

1. 旧 snapshot
2. 旧 timer
3. 旧 closure
4. 旧 credential
5. 旧 promise / 旧承诺工件

所以 `132` 之后必须继续补出的下一层就是：

`安全写权撤销协议`

也就是：

`Claude Code 不只是禁止错误跃迁，它还会在旧上下文失效时，主动收回这些旧对象继续改写当前真相的资格。`

## 2. 最短结论

Claude Code 安全设计真正成熟的一点，不只是知道“旧东西危险”，  
而在于：

`它把旧上下文失效后的撤权动作做成了具体机制。`

从源码看，这种撤权至少体现为六种动作：

1. 不返回旧快照，而返回基于当前上下文的 transform  
   `src/utils/permissions/permissionSetup.ts:1035-1041`
2. 关键 gate 读取 current state，而不是 stale setting snapshot  
   `src/utils/permissions/permissionSetup.ts:1078-1090`
3. 清掉旧 reconnect timer，防止旧时序继续写当前状态  
   `src/services/mcp/useManageMCPConnections.ts:803-807,1055-1060,1086-1090`
4. 删掉旧 `onclose` closure，防止旧 config closure 复活  
   `src/services/mcp/useManageMCPConnections.ts:794-810`
5. 登录前先清理旧 trusted device token，防止前一个账号的 credential 越界写入新会话  
   `src/bridge/trustedDevice.ts:65-87`
6. pointer 被认定 stale 后主动清除，防止旧恢复承诺继续支配后续启动流程  
   `src/bridge/bridgeMain.ts:2384-2392`

所以这一章的最短结论是：

`安全系统若不能主动撤销失效对象的写权，就无法真正防止旧世界篡改新世界。`

再压成一句：

`安全不只定义谁能写，更定义谁必须停止继续写。`

## 3. 第一性原理：为什么真正的安全控制面必须会“撤权”

传统权限系统最常见的想法是：

`先定义谁有权限。`

但在运行时安全里，  
这只完成了一半。

另一半更难的是：

`当条件变化后，谁已经不再有权限继续写当前真相。`

因为真实系统里，  
“写权”往往不只存在于账号或角色上，  
它还潜伏在：

1. 异步等待前捕获的 context
2. 已经挂起的 timer
3. 捕获旧 config 的 callback closure
4. 本地缓存中的旧 token
5. 文件系统里的旧恢复工件

如果系统只会授予写权，  
不会撤销写权，  
它就会不停地出现同一种深层故障：

`新的现实已经成立，旧的能力却还在继续替现实发言。`

所以撤权协议是运行时安全的核心组成部分。

它处理的不是：

`谁理论上应该有资格，`

而是：

`谁在这一刻已经不配再写。`

## 4. 旧 snapshot 的撤权：不允许 await 之前的世界覆盖 await 之后的世界

`src/utils/permissions/permissionSetup.ts:1035-1041` 是一个非常高密度的设计点。

作者明确说明：

1. auto gate check 不能返回预计算好的 context
2. 因为 async GrowthBook await 期间
3. 用户可能已经 mid-turn 改了 mode
4. 若直接回写旧 context，会覆盖用户新选择

于是这里返回的是：

`updateContext(ctx) => newCtx`

而不是：

`precomputedContext`

这本质上是一种撤权：

`旧 snapshot 被剥夺了直接写 current context 的资格。`

只有在真正读取“当前 ctx”之后，  
它才被允许以 transform 的形式参与。

这是非常强的运行时安全意识。  
因为它在说：

`capture 不是 authority。`

### 4.1 current state 优先于 sticky state

同文件 `1078-1090` 继续把这层意思说得更清楚：

1. `disableFastMode` circuit breaker 读取的是 current AppState.fastMode
2. 而不是 sticky 的 `settings.fastMode`
3. sync startup path 的 stale cache 只是临时值
4. authoritative source 在后续异步校正里

这进一步说明：

`不是所有“已经存下来”的状态都继续配拥有最高写权。`

系统会主动把 stale state 降级，  
把 current state 升成更高作者。

## 5. 旧 timer 的撤权：时序对象一旦过时，必须被取消

这在 `src/services/mcp/useManageMCPConnections.ts` 里尤其明显。

### 5.1 stale client cleanup 先撤销旧 timer

`803-807` 先做的不是 reconnect，  
而是：

1. 找到旧 timer
2. `clearTimeout`
3. 从 `reconnectTimersRef` 删除

这说明作者清楚知道：

`旧 timer 不是中性对象，它是未来的写权。`

如果不撤销，  
它就会在错误时机重新写入：

1. `pending`
2. `failed`
3. reconnect attempt state
4. 甚至覆盖 fresh connection 的结果

### 5.2 手动 reconnect / disable 前也先撤销旧 timer

同文件 `1055-1060` 和 `1086-1090` 进一步说明：

无论是：

1. 手动 reconnect
2. 还是手动 disable

系统都先清旧 automatic reconnect timer。

这说明 timer 的撤权并不是异常处理，  
而是合法 transition 的前置条件。

也就是说：

`新操作要生效，旧时序写权必须先被回收。`

## 6. 旧 closure 的撤权：旧 config closure 不得在新世界里继续拥有作者资格

`src/services/mcp/useManageMCPConnections.ts:791-810` 的注释非常罕见地把风险说得极其直白：

1. `onclose` 会从 closure 里带着 `OLD config`
2. 它会基于旧 config 启动 reconnect
3. 然后与 fresh connection 竞争
4. 最后变成 `last updateServer wins`

所以作者做了一个看似细小、实际上非常重的动作：

`s.client.onclose = undefined`

这不是普通的资源释放。  
这是：

`显式撤销旧 closure 的写权。`

很多系统对 closure 的理解仍然停留在语言层面，  
但 Claude Code 在这里已经是运行时控制面层面的理解：

`closure 不是“函数值”，closure 是带着旧世界上下文的潜在作者。`

一旦旧世界失效，  
它就必须被撤权。

## 7. 旧 credential 的撤权：前一账号的 token 绝不允许在新登录窗口继续发声

`src/bridge/trustedDevice.ts:65-87` 提供了另一类非常关键的证据。

这里 `clearTrustedDeviceToken()` 被要求：

1. 在 `/login` 期间、`enrollTrustedDevice()` 之前调用
2. 先从 secure storage 删除旧 token
3. 再清 memo cache

原因写得非常明确：

1. 否则前一账号留下的 stale token
2. 会在 enrollment 仍在异步进行时
3. 被继续当成 `X-Trusted-Device-Token` 发出去

这就是典型的 credential 写权污染。

也就是说：

`旧 credential 不只是“可能失效”，它甚至可能在新会话建立过程中越权替新会话发言。`

Claude Code 对此的处理不是“等它过期”，  
而是：

`在新 enrollment 开始前，先撤销旧 token 的发送资格。`

这是一种很强的账号边界意识。

## 8. 旧 promise / 旧工件的撤权：恢复承诺一旦 stale，就不能继续支配启动流程

`src/bridge/bridgeMain.ts:2384-2392` 很有代表性：

1. 当 session 在 server 侧已经不存在
2. pointer 就被判定为 stale
3. 系统会主动 `clearBridgePointer(...)`
4. 目的就是不让用户下次启动时继续被这个旧 pointer 反复提示

这说明 pointer 不是中立文件。  
它是一种：

`恢复承诺工件`

一旦它不再对应真实可恢复对象，  
它就必须被撤权。

否则系统就会出现一种非常隐蔽的安全失真：

`旧 promise 在当前现实里继续拥有路由权。`

这件事和 stale token、stale timer 在哲学上是同一类问题。

## 9. store.getState() 的意义：稳定 callback 不等于固定 snapshot

`src/services/mcp/useManageMCPConnections.ts:1043-1050` 还展示了另一种成熟设计：

1. `reconnectMcpServer` callback 要保持 stable
2. 但它读取 client 时，不捕获旧 client
3. 而是每次都 `store.getState().mcp.clients.find(...)`

这说明作者并不把“稳定 callback”理解成“绑定旧对象”。  
他们做的是：

`callback stable，authority live`

这是一种很高级的工程分离：

1. React 层需要 callback identity 稳定
2. 安全层需要 writer authority 永远来自 current state

如果把这两件事混在一起，  
就会出现 stale closure authoring 问题。

Claude Code 这里是显式避免的。

## 10. 技术先进性：Claude Code 的撤权设计到底先进在哪里

从技术角度看，这套设计至少有四个高级点。

### 10.1 它把“旧对象”视为权限对象，而不是垃圾对象

很多系统把 stale timer、stale cache、stale pointer 只当资源泄漏问题。

Claude Code 更进一步：

`这些对象一旦继续影响当前真相，就已经是安全问题。`

### 10.2 它把撤权放在正确顺序上

例如：

1. disable 先写盘再断开
2. new enroll 先清旧 token 再发新 enrollment
3. stale client 先清 timer / onclose 再清 cache

这说明它知道：

`撤权顺序错了，保护就会被自己副作用反打。`

### 10.3 它区分“稳定接口”与“新鲜权威”

stable callback 不是 stale authority。  
这在 `store.getState()` 模式里体现得很清楚。

### 10.4 它把恢复工件也纳入撤权治理

这很关键。

很多系统会治理 auth token，  
却不治理 pointer、resume hint、cached needs-auth、stale promise 这类解释层工件。

Claude Code 则开始把它们也纳入统一的撤权逻辑。

## 11. 哲学本质：安全不是只授予能力，而是持续回收不再配拥有的能力

如果把这一章继续压缩到最底层，  
会看到一个很重要的哲学转向：

`传统权限观更像“授予”。`

而 Claude Code 这种运行时安全观，  
更像：

`授予 + 回收`

甚至在某种意义上，  
后者更重要。

因为系统多数严重失真，并不是因为一开始授错了权，  
而是因为：

`条件已经变化，系统却没有及时把旧权收回。`

所以 Claude Code 给出的更深教训是：

`安全不是只会说 yes/no，而是要会在真相变化时系统性撤权。`

## 12. 苏格拉底式反思：如果要把撤权协议再推进一代，还缺什么

继续追问，仍能看到几个明显可改进点。

### 12.1 撤权对象是否已经有统一 taxonomy

还没有。

现在我们是通过阅读源码归纳出：

1. stale snapshot
2. stale timer
3. stale closure
4. stale credential
5. stale promise

但源码本身还没有统一把这些对象命名成一套 protocol taxonomy。

所以第一个反问是：

`系统什么时候才会把“谁属于可撤权对象”正式协议化？`

### 12.2 撤权动作是否已经结构化可观察

也不够。

很多撤权今天仍表现为：

1. `clearTimeout`
2. `cache.delete`
3. `onclose = undefined`
4. `clearBridgePointer`

这些动作是对的，  
但还缺统一的观测层。

所以第二个反问是：

`当一次安全事件发生后，系统能否统一回答：这次撤销了哪些旧写者的写权、按什么顺序撤的、是否全部撤干净？`

### 12.3 撤权是否已经可机检

同样还不够。

如果没有 tests 专门覆盖：

1. stale timer 不再触发
2. stale closure 不再写回
3. stale token 不再发送
4. stale pointer 被清掉

那撤权协议就仍过于依赖维护者理解。

所以第三个反问是：

`撤权机制什么时候会成为 machine-checkable invariant，而不是局部好习惯？`

## 13. 本章结论

把 `132` 再推进一层后，  
Claude Code 安全性的更深结构就更清楚了：

`它不只在定义状态与禁止捷径。`

它更深地在做的是：

1. 识别哪些旧对象仍然握有潜在写权
2. 判断这些写权何时已经失效
3. 用 clear / delete / uncouple / transform / reorder 等机制撤销它们
4. 防止旧世界继续替当前现实发言

所以如果要真正学习 Claude Code 的安全设计启示，  
最值得学的不是“多写几条 guard”，  
而是：

`把安全系统做成一套能够持续撤销失效写权的运行时控制面。`

