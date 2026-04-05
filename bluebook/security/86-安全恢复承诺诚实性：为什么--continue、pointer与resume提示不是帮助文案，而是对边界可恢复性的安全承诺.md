# 安全恢复承诺诚实性：为什么`--continue`、pointer与resume提示不是帮助文案，而是对边界可恢复性的安全承诺

## 1. 为什么在 `85` 之后还要继续写“恢复承诺诚实性”

`85-安全边界换届协议` 已经回答了：

`系统不仅要区分续接、换届、挂起和退役，还必须为每一种边界生命周期执行不同制度动作。`

但如果继续往下追问，  
还会遇到一个更贴近用户界面、也更贴近平台伦理的问题：

`系统何时才有资格对用户说“还能继续恢复”？`

因为一旦进入恢复主题，  
系统说的每一句话都不再只是说明文案。

下面这些东西本质上都在向用户作出承诺：

1. `claude remote-control --continue`
2. crash-recovery pointer
3. `Resuming session ...`
4. `The session may still be resumable — try running the same command again.`

如果这些承诺和底层真实边界状态不一致，  
问题就不再只是 UX 不佳。  
它会变成一种更深的安全故障：

`系统把一个并不真实存在的恢复资格说成了真实存在。`

所以在 `85` 之后，  
安全专题还必须再补一章，把“边界生命周期”继续推进成一条更高层的设计公理：

`恢复承诺诚实性。`

也就是：

`成熟控制面不仅要正确管理可恢复性本身，还必须对外诚实地表达可恢复性，不能让 resume surface 说出任何与真实边界状态不一致的话。`

## 2. 最短结论

从源码看，Claude Code 已经明确把 resume surface 当成安全承诺来治理：

1. `bridgeMain.ts` 直说：如果准备打印 resume command，就不能 archive+deregister，否则 printed resume command 会变成 lie  
   `src/bridge/bridgeMain.ts:1515-1538`
2. `--continue` 不会盲目读取当前目录一个文件了事，而是 worktree-aware 地寻找 freshest pointer，并明确打印“Resuming session ... from worktree ...”  
   `src/bridge/bridgeMain.ts:2141-2174`  
   `src/bridge/bridgePointer.ts:115-184`
3. stale/invalid pointer 会被主动清掉，目的就是避免用户下次继续被 re-prompt 到一个已经死掉的 session  
   `src/bridge/bridgePointer.ts:76-113`
4. resume path 上如果 session 已不存在或没有 `environment_id`，系统会清对应 pointer 并直接报错，而不是继续维持“也许还能恢复”的假象  
   `src/bridge/bridgeMain.ts:2380-2410`
5. reconnect failure 还明确区分 transient 与 fatal：fatal 才清 pointer；transient 则保留 pointer，并直接告诉用户“可能仍可恢复，再试一次”  
   `src/bridge/bridgeMain.ts:2524-2540`
6. pointer 也不是哪里都能写：standalone path 明确只在 `single-session` 模式下写 pointer，因为 multi-session 下写 pointer 会与用户后续恢复语义相冲突  
   `src/bridge/bridgeMain.ts:2700-2728`
7. REPL perpetual teardown 与 standalone resumable shutdown 都会故意保留或刷新 pointer，因为这时系统仍然认为恢复承诺为真  
   `src/bridge/replBridge.ts:479-488,1595-1615`

所以这一章的最短结论是：

`Claude Code 保护的不是“恢复功能看起来可用”，而是恢复承诺本身必须真实。`

我把它再压成一句：

`resume 不是提示词，它是承诺词。`

## 3. 源码已经说明：恢复承诺是一种资格声明，而不是帮助文本

## 3.1 作者直接写明“否则 resume command 会变成 lie”

`src/bridge/bridgeMain.ts:1515-1538` 是这一章最核心的证据。

这里作者没有含糊其辞，  
而是直接写出：

1. 单 session 模式下，若已知 session 且不是 fatal exit
2. 就保留 session 与 environment
3. 这样 `claude remote-control --continue` 才能真正 resume
4. 否则 archive session 或 deregister environment 会让 printed resume command 变成 lie

这说明在 Claude Code 团队心里，  
resume command 根本不是“顺手给用户的操作建议”，  
而是：

`对边界可恢复性的外部声明。`

一旦这条声明和后端事实不一致，  
系统就认为自己在说谎。

这比普通产品文案严格得多。

## 3.2 `--continue` 的 worktree-aware 设计说明：恢复承诺必须指向真实对象，而不是最近看起来像的对象

`src/bridge/bridgeMain.ts:2141-2174` 与 `src/bridge/bridgePointer.ts:115-184` 合起来很有力量。

这里：

1. `--continue` 会先检查当前目录
2. 找不到再 fanout 到 worktree siblings
3. 只选 freshest pointer
4. 还会把 pointer 来源目录记下来，后续 deterministic failure 时清理正确那份文件
5. 控制台明确打印：`Resuming session X (Ym ago) from worktree ...`

这说明作者要保护的不是“恢复体验流畅”，  
而是：

`用户看到的恢复对象，必须和系统真正准备恢复的边界对象一致。`

如果 worktree 场景下只做当前目录粗暴匹配，  
系统就可能把：

1. 看起来最近的一个指针
2. 当前真实可恢复的那个边界

混为一谈。

而源码恰恰在避免这种假对齐。

## 3.3 stale pointer 主动清理，说明“别再给我虚假恢复机会”本身是硬规则

`src/bridge/bridgePointer.ts:76-113` 明确把下面几类 pointer 都视为不可继续承诺恢复：

1. 文件不存在
2. schema invalid
3. mtime 超过 4h

注释写得也非常直白：

`Stale/invalid pointers are deleted so they don't keep re-prompting after the backend has already GC'd the env.`

这说明在作者心里，  
最重要的不是“尽量多留恢复入口”，  
而是：

`不允许系统继续反复承诺一个已经不真实的恢复入口。`

也就是说，  
恢复承诺的诚实性优先于恢复入口的数量。

## 3.4 resume 失败时不仅要报错，还要撤回错误承诺

`src/bridge/bridgeMain.ts:2380-2410` 说明另外一个很成熟的细节。

如果 `getBridgeSession(...)` 返回：

1. session 不存在
2. 或 session 没有 `environment_id`

系统不是只报一个错误完事，  
而是还会：

1. 清理对应 `resumePointerDir`
2. 防止下次 `--continue` 再次把用户带回同一死边界

这说明对 Claude Code 来说，  
错误处理并不只是：

`告诉用户这次失败了。`

它还包括：

`正式撤回上一次已经失效的恢复承诺。`

这条纪律很重要，  
因为它把 UI 提示和底层边界资格真正绑在了一起。

## 3.5 transient failure 保留 pointer，说明“仍可恢复”也必须有真实依据

`src/bridge/bridgeMain.ts:2524-2540` 特别值得注意。

这里作者明确区分：

1. fatal reconnect failure  
   清 pointer
2. transient reconnect failure  
   不清 pointer，并告诉用户：`The session may still be resumable — try running the same command again.`

这说明 Claude Code 不是一律保守地不敢说恢复，  
它其实愿意说。

但它只在一个条件下说：

`系统内部仍保留真实的 retry path 与恢复资产。`

所以这句“try again”不是安慰文案，  
而是一个有技术前提的恢复承诺。

一旦这个前提不存在，  
系统就必须清 pointer，  
并停止继续说这种话。

## 3.6 pointer 只在 `single-session` 写入，说明恢复承诺必须与用户配置语义相容

`src/bridge/bridgeMain.ts:2700-2728` 很能体现作者的边界感。

这里注释明确写出：

1. pointer 要立刻写，以便 crash 后可恢复
2. resumed session 也要重写 pointer，保证二次 crash 仍可恢复
3. 但 pointer 只在 `single-session` 下写
4. 因为 multi-session 下写 pointer 会与后续 resume 语义冲突，甚至让 pointer orphaned

这说明恢复承诺的真值条件不只是“底层 session 还活着”。  
它还取决于：

`当前恢复语义是否和用户所处模式相兼容。`

换句话说，  
能恢复不等于配承诺恢复。  
只有当：

1. 对象真实存在
2. 路径真实可走
3. 模式语义真实兼容

这三件事同时成立时，  
系统才配立下恢复承诺。

## 3.7 perpetual / resumable shutdown 之所以保留 pointer，是因为系统明确相信恢复承诺仍为真

`src/bridge/replBridge.ts:479-488,1595-1615` 与 `src/bridge/bridgeMain.ts:1515-1538` 放在一起看，会得到更完整的图景。

在这些路径里：

1. pointer 被保留或刷新
2. archive+deregister 被刻意跳过
3. 日志与输出都把“可恢复”作为下一步

这说明保留 pointer 的本质不是“懒得清理”，  
而是：

`系统有意识地维持一条仍然真实的恢复承诺。`

所以 pointer 的存在本身，  
就是一种声明：

`我仍愿意为这条边界的可恢复性背书。`

## 3.8 第一性原理：恢复承诺是用户侧的行动资格分配

如果从第一性原理追问：

`为什么一句“还能继续恢复”会是安全问题？`

因为这句话会直接改变用户的行动选择。

它会告诉用户：

1. 不要新建
2. 不要清理
3. 不要放弃旧边界
4. 继续沿这条边界投入时间

所以 resume 提示本质上是在给用户分配一种行动资格：

`你现在仍应把旧边界视为值得继续追索的对象。`

如果这个资格分配是错的，  
系统就不只是让用户多点一次按钮。  
它是在错误地引导用户围绕一个已失效对象继续组织行动。

这就是恢复承诺诚实性必须被提升为安全议题的原因。

## 3.9 技术先进性：Claude Code 已经在把 promise honesty 编进恢复控制面

从技术角度看，  
很多系统也有：

1. recent session
2. auto resume
3. retry message

但 Claude Code 更成熟的地方在于：

1. 它明确知道 printed resume command 会不会说谎
2. 它把 pointer 看成 promise carrier，而不是缓存文件
3. 它会在 deterministic failure 时主动撤回 promise
4. 它区分 transient 与 fatal，从而区分“继续承诺”和“撤回承诺”
5. 它连 worktree 场景下 promise 指向哪个对象都做了精确治理

这说明它已经不是“做了个恢复功能”，  
而是：

`开始治理恢复承诺的真值条件。`

## 4. 安全恢复承诺诚实性的最短规则

把这一章压成最短规则，就是下面七句：

1. resume surface 不是帮助文案，而是边界可恢复性的承诺面
2. 任何 promise surface 只有在底层对象、路径和模式语义都仍真实时才配发声
3. stale/invalid pointer 必须被清除，因为错误 re-prompt 本身就是假承诺
4. transient failure 可以继续承诺重试，但前提是真实 retry path 仍在
5. fatal failure 必须立即撤回恢复承诺
6. worktree、mode 与 pointer 来源都属于 promise truth condition 的一部分
7. 成熟控制面不仅要实现 resume，还要防自己在 resume 上说谎

## 5. 苏格拉底式追问：这套系统还能怎样再向前推进

如果继续自问，  
下一步最值得补的三项升级会是：

1. 给所有 resume surface 增加显式 `promise_basis` / `promise_confidence` 字段，而不只靠日志和注释约束
2. 把 `transient retryable`、`resumable`、`fresh-session-required`、`retired` 做成统一 lifecycle badge，减少用户对“还能不能继续” 的猜测成本
3. 在统一安全控制台里单独放一张 resumability 卡片，明确列出当前 promise basis、撤回条件和最后可信更新时间

所以这一章最终沉淀出的设计启示是：

`成熟安全系统不只要让恢复成为可能，还必须让“你仍可恢复”这句话在任何时刻都保持真实。`
