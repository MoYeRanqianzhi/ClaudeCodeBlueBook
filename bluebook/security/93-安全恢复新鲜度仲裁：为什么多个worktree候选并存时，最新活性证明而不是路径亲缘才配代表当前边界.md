# 安全恢复新鲜度仲裁：为什么多个worktree候选并存时，最新活性证明而不是路径亲缘才配代表当前边界

## 1. 为什么在 `92` 之后还必须继续写“新鲜度仲裁”

`92-安全恢复资产续保协议` 已经回答了：

`恢复资产必须持续获得 freshness proof，否则就会时间性失效。`

但如果继续往下追问，  
还会碰到一个更尖锐的问题：

`如果同时存在多个仍未被正式判死的恢复候选，系统该信谁？`

这时，问题就已经不再只是：

`它还新不新鲜`

而变成：

`在多个看起来都像恢复入口的对象里，谁有资格代表当前仍活着的边界`

这就是 `92` 之后必须继续补出的下一层：

`安全恢复新鲜度仲裁`

因为成熟控制面不能只回答：

`这个候选没过期`

还必须继续回答：

`多个候选同时出现时，哪一个才是当前真相，哪一些只是尚未清理干净的剩余物`

## 2. 最短结论

从源码看，Claude Code 已经把恢复候选的选择逻辑写成了一套很清楚的仲裁协议：

1. 当前目录只是 fast path，不是真相源；一旦当前目录里没有可用 pointer，系统会 fanout 到 git worktree siblings 查找候选  
   `src/bridge/bridgeMain.ts:2141-2174`; `src/bridge/bridgePointer.ts:115-164`
2. 不是所有 pointer 都有资格进入仲裁，stale、schema invalid、source 不匹配的候选会先被排除  
   `src/bridge/bridgePointer.ts:76-113`; `src/bridge/replBridge.ts:305-312`
3. 真正进入候选集后，winner 不是“离你近”的那个，也不是“当前目录里的那个”，而是 `ageMs` 最低、也就是 freshest 的那个  
   `src/bridge/bridgePointer.ts:166-181`
4. 一旦 winner 后续被证明是 dead session、missing environment 或 fatal reconnect failure，系统会精确清理 winner 所在目录的 pointer，而不是模糊清当前目录  
   `src/bridge/bridgeMain.ts:2171-2174,2384-2404,2524-2533`
5. transient reconnect failure 明确保留 pointer，说明 loser/winner 的命运不只由一次 lookup 决定，还取决于“这个候选还有没有 retry value”  
   `src/bridge/bridgeMain.ts:2524-2539`

所以这一章的最短结论是：

`Claude Code 的恢复控制面不是按路径亲缘选择恢复入口，而是按候选合法性和活性新鲜度仲裁谁有资格代表当前边界。`

再压成一句：

`恢复入口的真相，不由你站在哪个目录决定，而由哪份证据最能证明“这条边界现在还活着”决定。`

## 3. 当前目录不是权威，只是低成本猜测

## 3.1 fast path 的意义是省成本，不是授主权

`src/bridge/bridgeMain.ts:2141-2174` 和 `src/bridge/bridgePointer.ts:129-164` 很关键。

这里系统先检查当前目录，  
如果找不到，再 fanout 到 git worktree siblings。

这说明作者对“当前 shell 所在路径”有非常清楚的定位：

`它只是最快的先验，不是最终的权威。`

为什么？

因为 REPL bridge 写 pointer 的目录，并不总和用户下次执行 `--continue` 的目录重合。  
源码已经明确指出：

1. REPL bridge 写入的是 `getOriginalCwd()`
2. `EnterWorktreeTool` / `activeWorktreeSession` 可能把它变成某个 worktree 路径
3. 用户下一次却可能从 repo root 或另一个 sibling worktree 启动 `--continue`

这意味着如果系统把“当前目录里恰好有什么”当成最终真相，  
那么一旦 worktree 关系发生迁移，  
恢复控制面就会把路径偶然性误当成边界真相。

Claude Code 没这么做。  
它把路径当成本优化，  
但把 worktree fanout 当真相补全。

这是一种成熟的控制面思路：

`局部命中可以走快路，但主权不能交给快路。`

## 3.2 从第一性原理看，路径只是投影，边界连续性才是对象

如果用第一性原理追问：

`系统在恢复时真正要找回的到底是什么？`

答案不是：

`某个目录下的某个文件`

而是：

`某条仍与真实 session/environment 连续相连的活边界`

目录只是这个对象在本地文件系统上的投影。  
投影可以迁移、可以并存、可以残留，  
所以它天然不配拥有最终解释权。

从这一点看，Claude Code 的设计是对的：

`把路径从权威降级为候选定位器，把活性证据抬升为最终仲裁标准。`

## 4. 新鲜度仲裁之前，先有资格过滤

## 4.1 stale 和 invalid candidate 连入场资格都没有

`src/bridge/bridgePointer.ts:76-113` 已经写得很清楚：

1. 缺文件，返回 `null`
2. JSON 无法解析或 schema mismatch，清理并返回 `null`
3. `mtime` 超过 `BRIDGE_POINTER_TTL_MS`，清理并返回 `null`

这说明仲裁不是“把所有 pointer 都拉进来比新旧”，  
而是：

`先判断谁配进赛场，再判断进赛场的人里谁更有资格胜出。`

所以新鲜度仲裁不是裸比较，  
而是建立在 admission gate 之后的比较。

这也解释了为什么 stale pointer 会被直接删除。  
因为它已经不是弱候选，  
而是：

`不应继续参与恢复叙事的失格对象`

## 4.2 source 过滤说明“像 pointer”不等于“属于同一恢复制度”

`src/bridge/replBridge.ts:305-312` 进一步把资格过滤再推进了一层。

perpetual REPL 在读取 prior state 时，  
只接受 `source === 'repl'` 的 pointer。

这说明系统不仅问：

`它新不新`

还问：

`它是不是同一制度里的候选`

同样是 pointer，  
standalone crash-recovery pointer 与 repl perpetual prior pointer 也不是可随意互换的。

这背后体现的不是实现洁癖，  
而是制度边界：

`恢复候选必须先属于正确的恢复语法，再谈时间新鲜度。`

## 5. 真正胜出的不是“这里的”，而是“最新活着的”

## 5.1 freshest 规则把 freshness 从过期判断升级为优先级判断

`src/bridge/bridgePointer.ts:166-181` 是这一章的中心证据。

多 worktree fanout 读完后，  
系统没有选：

1. 第一个找到的
2. 当前目录里的
3. 路径最短的
4. 名字最像当前 repo 的

而是明确选：

`ageMs 最低的那个`

也就是 freshest pointer。

这一步非常关键。  
因为它说明 freshness 在 Claude Code 里承担了双重角色：

1. `validity threshold`
   没有足够新鲜度，连资格都没有
2. `arbitration priority`
   都有资格时，最新活性证明者胜出

因此 `freshness` 不是一个后台 housekeeping 字段，  
而是恢复控制面的投票权重。

## 5.2 这其实是在避免“旧但近”的伪真相打败“新但远”的活真相

如果系统按路径亲缘选择，  
就会出现一种非常危险的错判：

`旧但离你更近的残留 pointer，打败了新但写在 sibling worktree 的活 pointer`

Claude Code 用 freshest 规则正是在防这个。

所以它真正防御的不是普通 UX 混乱，  
而是：

`局部拓扑位置对全局边界真相的越权解释`

把这句话再压一下，就是：

`近，不等于真；新，才更接近活。`

## 6. 仲裁选出 winner 之后，还必须绑定正确 provenance

## 6.1 winner 不只要被选中，还要带着来源目录一起被记住

`src/bridge/bridgeMain.ts:2162-2174` 明确记录了：

1. `--continue` 选出 `pointer`
2. 同时拿到 `pointerDir`
3. 后续 deterministic failure 时要清理 `resumePointerDir`

这说明系统并没有在 winner 选出后把 provenance 丢掉。  
相反，它保留了一个很重要的事实：

`这次恢复判断是基于哪一个候选目录做出的`

为什么这很重要？

因为一旦之后发现这个 winner 实际上是 dead session 或 non-attachable object，  
系统就必须撤销：

`刚才被它代表的那份恢复资格`

而撤销动作必须落到正确 carrier 上。

## 6.2 清对文件，比“知道错了”更重要

`src/bridge/bridgeMain.ts:2384-2404` 进一步说明：

1. 如果 session 已不存在
2. 或 session 没有 `environment_id`
3. 系统会 clear `resumePointerDir`

这里不是简单报错，  
而是：

`对刚才胜出的候选执行精确撤销`

这说明 Claude Code 已经意识到：

`错误的 winner 如果不被精确撤销，就会在下一次继续污染仲裁。`

因此 provenance 的意义，不只是方便日志，  
而是为了让撤权也保持精确。

这就是成熟系统和半成熟系统的差别：

半成熟系统只会“重新试一次”；  
成熟系统会先把上一次错胜出的那份资格精确回收。

## 7. winner 也不是一次性真理，而是带 retry 语义的临时主张

## 7.1 fatal 和 transient 的区别，说明仲裁不是一次性判决

`src/bridge/bridgeMain.ts:2524-2539` 非常值得细读。

当 reconnect 失败时，  
系统没有统一清掉 pointer。

它明确区分：

1. `fatal`：清理 pointer
2. `transient`：保留 pointer，并提示用户再次运行同一命令

这说明 winner 的含义不是：

`既然这次没成功，它刚才就不该赢`

而是：

`它刚才作为当前最优候选胜出是对的，但其恢复尝试结果还要继续分层判断`

也就是说，仲裁胜出和最终失效不是同一个时刻、也不是同一个动作。

从控制面设计看，这很成熟。  
因为它避免了另一种常见错误：

`把一次网络/时序失败误写成对象本体失效`

Claude Code 在这里守住了边界：

`retryable failure 影响的是本次恢复尝试，不应自动撤销候选本身。`

## 7.2 真正被保护的是“仍有恢复价值的候选”

这进一步暴露出恢复安全的更深层本体：

系统保护的并不是 pointer 文件本身，  
也不是一次 reconnect 调用本身，  
而是：

`该候选是否仍保有继续恢复的价值`

fatal 失败说明这种价值已被打穿；  
transient 失败说明这种价值仍在，只是当前尝试没走通。

所以清理与保留的分界，本质上是：

`恢复价值是否被正式证伪`

## 8. 这套设计背后的哲学本质

## 8.1 安全不是找最近对象，而是找最可信的连续性证明

这一章最值得提炼的哲学结论是：

`恢复安全不是位置问题，而是连续性证明问题。`

文件位置、工作目录、worktree 邻近性这些东西，  
都只是局部几何事实。

而恢复控制面真正关心的是：

1. 这个候选是不是合法候选
2. 它是不是仍在 freshness window 内
3. 它是否仍指向真实存在的 session/environment
4. 它的失败是不是 fatal，而非 retryable

只有这些问题被回答之后，  
“这个目录里刚好有个文件”才有意义。

所以从哲学上看，Claude Code 的做法是在说：

`边界真相属于制度化证据，不属于空间直觉。`

## 8.2 所谓安全先进性，体现在它把“近似正确”让位给“制度正确”

很多系统会偷懒：

1. 当前目录优先
2. 找到就用
3. 失败就全部清掉

这样实现很短，  
但安全语义很差。

Claude Code 更先进的地方在于：

1. 它承认当前目录可能撒谎
2. 它承认多个候选会并存
3. 它承认 freshness 既是时效问题，也是仲裁问题
4. 它承认失败还要继续分 fatal 与 retryable
5. 它承认撤销必须精确命中刚才胜出的 carrier

所以它的先进性不在算法复杂度，  
而在：

`它愿意把恢复控制面做成一套制度，而不是一段侥幸可用的文件查找逻辑。`

## 9. 从第一性原理继续追问：如果这套仲裁还要再做得更好，还缺什么

## 9.1 苏格拉底式追问

可以继续问六个问题：

1. 如果当前目录不是真相源，为什么 CLI 仍只在命中失败后才 fanout，而不是先统一列出候选集？
2. 如果 freshest 胜出是对的，是否还应把 second-best candidate 暴露给用户，防止误清唯一可用备份？
3. 如果 provenance 已被内部保存，为什么不把“本次命中的 worktree 来源”做成更显式的状态面字段？
4. 如果 transient failure 仍保留 pointer，系统是否还应把剩余 retry value 做成可见等级，而不只是提示一句 try again？
5. 如果 source gating 已存在，未来是否还应把 candidate class 正式编码成更强的恢复对象类型，而不是只靠 payload 字段？
6. 如果 freshness 同时承担 validity 和 priority，是否应显式区分“刚好没过期”和“优先级强”的两层语义，减少边界含混？

这些问题说明，  
Claude Code 现在的实现已经很成熟，  
但下一代控制面还可以进一步产品化：

`把内部已有的仲裁语义显式外化给用户。`

## 9.2 对蓝皮书结构的启发

写到这里，恢复安全链已经比较清楚地分成了三层：

1. `资格层`
   谁仍可恢复
2. `资产层`
   哪些对象必须保留、续保
3. `仲裁层`
   多个候选并存时谁代表当前真相

这也说明安全专题后续继续往下写时，  
不该再把恢复问题看成单点 resume command，  
而应把它视为：

`资格、资产、时效、仲裁、撤销五层连续制度`

## 10. 给系统设计者的技术启示

最后把这一章压成五条工程启示：

1. 不要把“当前上下文”直接当权威，只能把它当 fast path
2. 仲裁前先做 admission filtering，避免无资格对象污染优先级比较
3. freshness 最好同时服务于 validity 和 arbitration，避免再发明第二套 winner rule
4. winner 一旦选出，必须携带 provenance，以便后续精确撤销
5. reconnect failure 必须区分 fatal 与 retryable，否则恢复资产会被错误清空

这一章最终要守住的一条硬结论是：

`在多候选恢复系统里，真正安全的不是“找到一个文件”，而是“让最能证明边界仍活着的那份证据赢，并在它被证伪时把它精确撤销”。`
