# 安全恢复资格签发权：为什么不是任何局部signal都配说仍可恢复，而必须由掌握边界真相的控制层签字

## 1. 为什么在 `86` 之后还要继续写“恢复资格签发权”

`86-安全恢复承诺诚实性` 已经回答了：

`resume surface 不是帮助文案，而是对边界可恢复性的安全承诺。`

但如果继续往下追问，  
还会碰到一个更制度化的问题：

`既然“仍可恢复”是一种承诺，那到底谁有资格把这句话说出口？`

因为一旦承认 resume 提示是 promise surface，  
就必须继续回答：

1. 谁能签发这项 promise
2. 谁能撤回这项 promise
3. 谁只能转述，不能独立宣布

否则系统仍然可能落入另一种危险：

`每个局部 signal 都觉得自己看到了希望，于是各自越权对用户承诺“还可以继续恢复”。`

所以在 `86` 之后，  
安全专题还必须再补一章，把“promise honesty”继续推进成更完整的主权问题：

`恢复资格签发权。`

也就是：

`成熟控制面不仅要让恢复承诺保持真实，还必须明确只有掌握边界真相、模式语义和失败等级的控制层，才有资格签发或撤回“仍可恢复”这句话。`

## 2. 最短结论

从源码看，Claude Code 已经把恢复资格的签发权收得很窄：

1. shutdown 路径只有在 `single-session + initialSessionId + !fatalExit` 同时成立时，才打印 `--continue` 提示，说明 resume promise 由掌握模式、对象存在性和退出等级的主流程签字  
   `src/bridge/bridgeMain.ts:1515-1538`
2. `--continue` 不接受任意局部文件自己宣布“可恢复”，而是统一通过 `readBridgePointerAcrossWorktrees(...)` 选 freshest valid pointer，再把来源目录一并带入后续控制流  
   `src/bridge/bridgeMain.ts:2141-2174`  
   `src/bridge/bridgePointer.ts:115-184`
3. pointer reader 自己只负责“这个 carrier 还像不像一个有效候选”，并不会单独签发最终恢复资格；真正 resume 前还要经过 `getBridgeSession(...)` 与 `environment_id` 校验  
   `src/bridge/bridgePointer.ts:76-113`  
   `src/bridge/bridgeMain.ts:2380-2415`
4. reconnect failure 的 `transient` / `fatal` 区分决定了是否保留 pointer、是否允许说 `may still be resumable`，说明 promise 签发权最终仍掌握在知道 failure semantics 的 bridgeMain 控制层  
   `src/bridge/bridgeMain.ts:2524-2540`
5. pointer 写入权本身也不是开放的：只有 `single-session` path 和 REPL perpetual path 才会保留或刷新 pointer，说明不是任何运行模式都配发布 resumability carrier  
   `src/bridge/bridgeMain.ts:2700-2728`  
   `src/bridge/replBridge.ts:479-488,1595-1615`
6. non-perpetual clean exit 明确 clear pointer，等于正式撤回恢复资格；这一步发生在掌握完整 teardown 语义的控制层，而不是某个局部 UI surface  
   `src/bridge/replBridge.ts:1618-1663`

所以这一章的最短结论是：

`Claude Code 不允许任何局部 signal 越权宣布“仍可恢复”；恢复资格必须由掌握完整边界真相的控制层签字。`

我把它再压成一句：

`promise 必须有 signer。`

## 3. 源码已经说明：恢复资格签发权必须集中，而不能让局部观察者各说各话

## 3.1 printed resume command 只能由知道退出语义的主流程签发

`src/bridge/bridgeMain.ts:1515-1538` 说明最典型的一点。

打印：

`Resume this session by running \`claude remote-control --continue\``

这句话的前提不是某个底层对象“看起来还在”，  
而是主流程同时确认：

1. 当前是 `single-session`
2. 已知 `initialSessionId`
3. 不是 `fatalExit`
4. 将跳过 archive+deregister

这意味着 shutdown hint 的 signer 不是：

1. pointer 文件
2. session id 自身
3. 某个 transport callback

而是：

`掌握退出制度语义的 bridgeMain 主流程。`

它知道自己有没有把恢复路径亲手关掉，  
所以它才配说：

`你仍可继续恢复。`

## 3.2 pointer reader 只是候选过滤器，不是最终 signer

`src/bridge/bridgePointer.ts:76-113,115-184` 很容易被误读成：

`有 pointer 就等于可恢复。`

但源码恰恰不是这么设计的。

pointer reader 实际只负责三件事：

1. 判断 schema 是否有效
2. 判断 mtime 是否 stale
3. 在 worktree 范围内挑 freshest candidate

它解决的是：

`哪个 carrier 还值得继续检查。`

它没有资格单独回答：

`这个边界现在是否真的仍可恢复。`

因为这个问题还取决于：

1. server 上 session 是否还存在
2. 有没有 `environment_id`
3. 当前模式是否与恢复语义兼容
4. reconnect failure 是 transient 还是 fatal

所以 pointer reader 不是 signer，  
它只是：

`promise candidate selector。`

## 3.3 `--continue` 之所以先过 worktree-aware 入口，再走 session fetch，是因为签发权必须逐层升级

`src/bridge/bridgeMain.ts:2141-2174` 和 `2380-2415` 连起来很能说明问题。

这里恢复资格不会一次性由某一层拍板，  
而是分两层完成：

第一层：

1. 从当前目录或 worktree siblings 找 freshest pointer
2. 决定继续针对哪个 session 做验证

第二层：

1. 取 session 真实对象
2. 检查是否存在
3. 检查 `environment_id`
4. 决定是否允许进入 resume flow

这说明恢复资格签发权在 Claude Code 里不是扁平的。  
它更像：

`候选发现权 -> 对象核验权 -> 最终承诺权`

而最终 promise 的 signer 只能是经过这整条链的控制层，  
不能让任何前置局部层级越权抢签。

## 3.4 `transient` 与 `fatal` 的分层说明：failure semantics owner 才配签发重试型恢复资格

`src/bridge/bridgeMain.ts:2524-2540` 特别重要。

这里作者明确区分：

1. fatal  
   清 pointer
2. transient  
   保留 pointer，并打印：`The session may still be resumable`

这意味着同样是一条 reconnect failure，  
也不是谁都能看一眼错误就说：

`还可以再试。`

只有掌握下面这些语义的层才配这么说：

1. 当前 environment 是否仍是 session 自己的 environment
2. 失败类型是不是 fatal
3. pointer 是否仍应保留
4. 下次启动是否真的还会 re-prompt

也就是说，  
`may still be resumable` 的 signer 不是 error string，  
而是：

`failure semantics owner`

## 3.5 pointer 写入权被限制在特定模式，本质上也是恢复资格发布权的收口

`src/bridge/bridgeMain.ts:2700-2728` 与 `src/bridge/replBridge.ts:479-488,1595-1615` 说明了另一层主权边界。

源码明确限制：

1. standalone 只有 `single-session` 才写 pointer
2. REPL perpetual 路径才刷新并保留 pointer
3. non-perpetual clean exit 会 clear pointer

这说明 pointer 不是任何运行模式都能随手发布的对象。  
因为一旦写 pointer，  
系统就几乎等于在对外发布：

`这里存在一个后续可能被恢复的边界。`

所以 pointer write 本身就是一种 publish action，  
而 publish action 当然应当有主权约束。

## 3.6 promise 撤回权同样必须集中在掌握完整 teardown truth 的层

`src/bridge/replBridge.ts:1618-1663` 很能说明问题。

在 non-perpetual clean exit 路径里，  
系统会：

1. send result
2. stopWork + archive
3. deregister environment
4. clear pointer

这等于在正式执行一件事：

`撤回“你仍可恢复”这项资格。`

而这项撤回动作不是由：

1. pointer 自己超时
2. 某个 UI surface 自动隐藏
3. 某个 transport close handler 自行判断

来完成的。  
它必须由掌握完整退役事实的控制层统一签字。

所以恢复资格不只是有 issuance authority，  
还有：

`revocation authority`

## 3.7 第一性原理：恢复资格本质上是一种面向用户的行动授权

如果从第一性原理再压一层，  
“仍可恢复”本质上是在对用户说：

1. 你可以继续围绕这个旧边界投入操作
2. 你不必立刻放弃它
3. 你下一步仍应沿恢复路径行动

这已经不只是信息传递，  
而是一种行动授权。

而任何行动授权都必须回答：

1. 谁配发
2. 谁配撤
3. 谁只能转述

所以恢复资格签发权的问题，  
其实和前面整套安全主线是一致的：

`主权没有缺席，只是换了一个更接近用户体验的表现形态。`

## 3.8 技术先进性：Claude Code 已经开始把 promise issuance 做成控制面职责，而不是文案职责

从技术角度看，  
很多系统会把：

1. recent session
2. retry hint
3. reconnect prompt

都当成产品层的小功能。

但 Claude Code 在这里更成熟的地方在于：

1. 它知道哪些 surface 只是 candidate carrier
2. 它把最终承诺建立在 session existence、environment binding、mode compatibility、failure semantics 上
3. 它允许 promise 撤回和 pointer 清理联动发生
4. 它让“说这句话的资格”跟 runtime truth owner 对齐

这说明它已经不只是“恢复体验做得细”，  
而是：

`在把恢复资格的签发权也控制面化。`

## 4. 安全恢复资格签发权的最短规则

把这一章压成最短规则，就是下面七句：

1. “仍可恢复”是一种资格声明，不是普通帮助文案
2. 资格声明必须有 signer，不能由局部 signal 越权发布
3. pointer reader 只配筛候选，不配单独签发最终恢复资格
4. failure semantics owner 才配说“可重试”或“已不可恢复”
5. pointer write 本身就是恢复资格发布动作，必须受模式与生命周期约束
6. pointer clear 本身就是恢复资格撤回动作，必须由掌握退役真相的层执行
7. 成熟控制面不仅治理 promise honesty，还治理 promise issuance authority

## 5. 苏格拉底式追问：这套系统还能怎样再向前推进

如果继续自问，  
下一步最值得补的三项升级会是：

1. 给每个 resume surface 显式标出 `signer` 与 `basis owner`，避免未来代码演化时签发权漂移
2. 把 `candidate / verified / retryable / retired` 做成统一 resumability state machine，而不是散落在多个 if 分支里
3. 在统一安全控制台里单独展示“当前是谁在为这条恢复承诺签字”，让用户看到 promise 不是拍脑袋给出的

所以这一章最终沉淀出的设计启示是：

`成熟安全系统不仅要让恢复承诺保持真实，还必须让恢复承诺的签发权掌握在真正知道边界真相的那一层。`
