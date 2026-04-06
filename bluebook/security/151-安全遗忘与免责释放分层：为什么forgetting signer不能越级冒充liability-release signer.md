# 安全遗忘与免责释放分层：为什么forgetting signer不能越级冒充liability-release signer

## 1. 为什么在 `150` 之后还必须继续写 `151`

`150-安全终局与遗忘分层` 已经回答了：

`finality signer 只能证明真相已成立并可被未来读回；forgetting signer 才配决定哪些旧痕迹现在可以被安全抹除。`

但如果继续追问，  
还会碰到最后一个更容易被混淆的跳跃：

`如果某些旧痕迹已经可以 forget，这是否已经等于系统对这条边界不再负有续作、重开、追责或恢复责任？`

Claude Code 当前源码给出的答案仍然是否定的。

因为它在 bridge、resume、session restore 与 interrupted-turn recovery 上都坚持了一条更强的边界：

1. crash-recovery pointer 会在 clean shutdown 以外被保留，用于下次 `--continue`
2. 单会话 bridge 在可恢复退出时会故意跳过 `archive + deregister`，因为否则打印出来的 resume 命令会变成谎言
3. `processResumedConversation()` 默认复用原 session ID，而不是把 resume 伪装成一条新生命线
4. `conversationRecovery` 会把 interrupted turn 补成 `Continue from where you left off.`，把未完成责任重新挂回同一会话

这说明即使某些 trace 可以被 forget，  
系统也仍然拒绝把：

`部分痕迹已可清理`

压成：

`同一责任线程已经被正式免责释放。`

所以 `150` 之后必须继续补的一层就是：

`安全遗忘与免责释放分层`

也就是：

`forgetting signer 只能决定某些旧痕迹可被清除；liability-release signer 才配决定系统是否正式结束同一续作责任、reopen 义务与未来追索链。`

## 2. 先做一条谨慎声明：`liability-release signer` 是研究命名，不是源码现成类型

需要明确：

`Claude Code 当前源码里并没有一个字面存在的 signer 类型叫 liability-release signer。`

这里的 `liability-release signer` 是本研究为了描述更强 release gate 而引入的分析命名。  
它不是在声称 Anthropic 已经实现了这个对象，  
而是在说：

1. 当前源码已经明确把 `finality` 与 `forgetting` 拆开
2. 当前源码又同样明确保留了大量 `resume / retry / same-session continuity`
3. 所以如果未来要继续把 cleanup 设计推进到底，仍然还缺一层比 forgetting 更强的正式 release authority

换句话说：

`151` 不是在虚构一个现有实现，  
而是在从当前源码已经显露出来的边界，反推出下一层仍未被正式对象化的主权。

## 3. 最短结论

Claude Code 当前源码至少展示了四类“forgetting 仍不等于 liability release”证据：

1. `bridgePointer` 被设计成 crash-recovery artifact，fresh pointer 默认服务下次 resume  
   `src/bridge/bridgePointer.ts:22-34,56-113`
2. `--continue` 会跨 worktree 找 freshest pointer，把同一责任线程重新接回当前入口  
   `src/bridge/bridgePointer.ts:115-180`  
   `src/bridge/bridgeMain.ts:2162-2174`
3. 单会话 bridge 非 fatal 退出时会刻意跳过 `archive + deregister`，因为系统仍承认用户对同一 session 拥有续作权  
   `src/bridge/bridgeMain.ts:1516-1535`
4. session resume 默认复用原 session ID，并把 interrupted turn 补成 continuation，而不是宣告“旧责任已经自然消散”  
   `src/utils/sessionRestore.ts:403-487`  
   `src/utils/conversationRecovery.ts:204-245`

因此这一章的最短结论是：

`forgetting signer 最多只能说“某些痕迹现在可以被安全忘掉”；它仍然不能越级说“同一责任线程已经被正式免责释放”。`

再压成一句：

`痕迹可忘，不等于责任可赦。`

## 4. 第一性原理：为什么“允许遗忘”仍不等于“允许免责释放”

从第一性原理看：

- forgetting 回答的是  
  `删掉这条旧痕迹后，会不会损害当前控制面的解释、修复与可用性？`
- liability release 回答的是  
  `系统现在是否已经可以正式放弃同一责任线程的续作、重试、恢复、追索与 future reopen？`

所以两者解决的根本不是同一个问题：

1. trace disposal
2. obligation closure

如果把两者压成同一个 green state，  
系统就会制造三类危险幻觉：

1. forget-means-finished illusion  
   既然某个 surface 已经清爽，就误以为同一责任线程已经结束
2. cleanup-means-release illusion  
   既然某个 owner 允许删 trace，就误以为未来不得再 resume / retry / reopen
3. less-visible-means-less-liable illusion  
   既然用户眼前不再看到旧痕迹，就误以为系统也不再对这件事负有连续性义务

所以从第一性原理看：

`forgetting 是 trace 主权，liability release 是责任主权；前者不能自然推导出后者。`

## 5. `bridgePointer` 说明系统在 clean shutdown 之外主动保存“续作责任线索”

`src/bridge/bridgePointer.ts:22-34` 把 bridge pointer 定义得非常清楚：

1. 它是 crash-recovery pointer
2. 会在 session 创建后立即写入
3. 在会话期间持续 refresh
4. 只在 clean shutdown 清掉
5. 非正常退出时则保留，供下次 `claude remote-control` 检测并 resume

这意味着 pointer 不是普通缓存，  
而是：

`同一责任线程未来仍可被重新接回的证据工件。`

更关键的是 `src/bridge/bridgePointer.ts:76-113`：

1. stale / invalid pointer 才清
2. fresh pointer 就继续保留
3. mtime 甚至被设计成 rolling TTL 证据

这说明源码作者对 pointer 的态度不是：

`旧了就删，删了就算。`

而是：

`只要它仍能合法代表同一续作线程，就不配被忘。`

## 6. worktree-aware pointer fanout 说明责任不是绑定在“当前目录表面”，而是绑定在“freshest continuity truth”

`src/bridge/bridgePointer.ts:115-180` 更进一步：

1. `--continue` 先查当前目录
2. 不命中时 fan out 到 git worktree siblings
3. 最后挑 freshest pointer
4. 并把实际 pointer 所在目录也带回，供 deterministic failure 时清理正确文件

再配合 `src/bridge/bridgeMain.ts:2162-2174`：

1. CLI 会明确打印 `Resuming session ...`
2. 就算 pointer 来自 sibling worktree，也照样接回

这说明 Claude Code 治理的不是：

`我眼前这个 worktree 表面是否干净`

而是：

`哪一条 continuity truth 仍然最新、仍然配代表同一责任线程`

所以从哲学上看：

`liability thread 追随的是 freshest continuity evidence，不是当前 surface 的整洁程度。`

## 7. single-session shutdown 明确拒绝把“退出”伪装成“免责释放”

`src/bridge/bridgeMain.ts:1516-1535` 的注释几乎就是一条 release 宪法：

1. single-session + known session + non-fatal exit
2. 保持 session 和 environment 继续 alive
3. 跳过 `archive + deregister`
4. 原因是：否则 printed resume command 会变成 lie

这条边界极其关键。  
因为如果系统真认为：

`现在已经没有续作责任了`

那它完全可以在这里直接 archive / deregister。  
但作者反而选择：

`为了保证 future resume 仍真实可用，宁可保留环境与会话。`

这意味着在 bridge subsystem 里：

`可退出`

并不等于：

`可免责`

更不等于：

`可释放同一 session continuity。`

## 8. deterministic dead-end 与 transient failure 被严格区分，说明 release gate 必须比 forgetting gate 更硬

`src/bridge/bridgeMain.ts:2384-2407` 说明：

1. 如果 session 在 server 上已经 gone
2. 或根本没有 `environment_id`
3. 这时才 clear pointer

而 `src/bridge/bridgeMain.ts:2524-2540` 又说明：

1. transient reconnect failure 明确不得 deregister
2. fatal failure 才清 pointer
3. 非 fatal failure 还会提示用户“可能仍然可 resume，再试一次”

这说明源码作者并不把“这次没连上”解释成 release。  
它只在更强 truth 成立时才收回 continuity artifact：

1. stale
2. invalid
3. session gone
4. env missing
5. fatal reconnect failure

所以从设计上看：

`forgetting gate 只能由本地 surface 或局部 owner 给出；真正的 liability release gate 必须踩到更强的 server-side death truth。`

## 9. `processResumedConversation()` 说明 resume 是继续同一责任线程，不是生成一条天然免责的新线程

`src/utils/sessionRestore.ts:403-487` 写得很直白：

1. 默认复用 resumed session 的 ID
2. 恢复同一 transcript file pointer
3. 恢复同一 cost state
4. 恢复同一 worktree state
5. 恢复同一 metadata / mode / agent setting

只有在 `--fork-session` 时，  
系统才保留 fresh startup session ID。

这条分叉本身就很重要。  
因为它说明源码作者心里非常清楚地区分了两件事：

1. resume same lineage
2. fork new lineage

而默认路径始终是前者。

这意味着：

`Claude Code 不把 resume 当成“旧责任已清零后的重新开始”，而把它当成“同一责任线程的继续履行”。`

从第一性原理看，  
这几乎已经构成了一条隐式规则：

`只要系统还默认复用同一 session identity，它就还没有给出免责释放。`

## 10. interrupted turn 被补成 continuation message，说明系统甚至不允许“中断”伪装成“责任蒸发”

`src/utils/conversationRecovery.ts:204-245` 的设计同样非常有启发：

1. 检测到 `interrupted_turn`
2. 自动补一条 synthetic continuation message
3. 文本就是 `Continue from where you left off.`
4. 再补一个 assistant sentinel，让 conversation API-valid

这说明源码作者面对 mid-turn interruption 时的原则不是：

`既然上轮没走完，那就算了`

而是：

`把未完成责任重新绑定成一个可以继续完成的 prompt`

这相当于把：

`unfinished obligation`

正式变成：

`resumable obligation`

所以 even after some trace cleanup，  
只要 interrupted-turn debt 还在，  
系统就根本没有给出 release。

## 11. 技术启示：future cleanup protocol 至少还要继续拆哪四层 release grammar

如果沿着 Claude Code 当前已经露出来的边界继续往前设计，  
未来 cleanup / release protocol 至少还要拆开：

1. `cleanup_forget_allowed`
   某类旧 trace 已可被安全删除
2. `cleanup_resume_retained`
   虽然某些表面可忘，但同一 resume / retry 线程仍保留
3. `cleanup_liability_open`
   系统仍保留 future reopen / continuation / audit 权
4. `cleanup_release_granted`
   只有在更强 gate 成立后，才正式宣告同一责任线程被释放

可能的 stronger release gate 至少应包含：

1. no fresh pointer
2. no resumable session
3. no interrupted-turn debt
4. no retry asset retained
5. explicit archive / deregister / fork or stronger equivalent server truth

否则系统很容易再次退回：

`一个 forgetting 吃掉 trace cleanup、resume retention 与 liability release`

这会让控制面重新滑回伪结束。

## 12. 用苏格拉底诘问法再追问一次

### 问：如果 pointer 已经清掉了，不就说明已经 release 了吗？

答：不一定。pointer 只是某一类 continuity artifact。release 必须回答的是整条责任线程是否正式关闭，而不是某一个 artifact 是否不在了。

### 问：为什么 resume 同 session ID 这么关键？

答：因为 identity reuse 本身就是责任连续性的制度表达。只要系统默认承认“还是这条 session”，它就没有宣告“责任已被释放”。

### 问：为什么 interrupted turn 的 synthetic continuation 重要？

答：因为它说明系统把“中断”解释成“待继续完成”，而不是“自然失效”。这是 obligation continuity 最直接的编码。

### 问：那 `--fork-session` 是不是最接近 release？

答：它更接近新 lineage 的显式切换，但仍不是对旧 lineage 的普遍免责。源码仍会复制必要记录，说明 fork 是重开边界，不是历史蒸发。

### 问：如果以后真要做 formal release，最难的部分是什么？

答：不是再补一个 delete action，而是明确谁有资格说“future reopen / retry / audit 现在全部不再成立”，以及这句话到底依赖哪些 stronger truth。

## 13. 一条硬结论

Claude Code 当前源码已经非常清楚地展示出一条更深的安全哲学：

`允许遗忘，不等于允许免责；允许清理痕迹，不等于允许释放责任。`

因此从源码设计思路往前推，  
真正成熟的 cleanup system 最终必须坚持四层分离：

1. finality
2. forgetting
3. continuity retention
4. liability release

其中第 4 层比第 3 层更强，  
第 3 层又比第 2 层更强。  
所以：

`forgetting signer 不能越级冒充 liability-release signer。`
