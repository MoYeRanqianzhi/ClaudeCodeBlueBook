# 安全免责释放与归档关闭分层：为什么liability-release signer不能越级冒充archive-close signer

## 1. 为什么在 `151` 之后还必须继续写 `152`

`151-安全遗忘与免责释放分层` 已经回答了：

`forgetting signer 最多只能决定哪些旧痕迹可以被安全忘掉；它仍然不能越级宣布同一责任线程已经被免责释放。`

但如果继续追问，  
还会碰到另一条很容易被压扁的边界：

`就算系统已经不再对同一责任线程负有续作责任，这是否已经等于它现在可以把对象正式从活跃表面归档关闭？`

Claude Code 在 bridge lifecycle 上给出的答案仍然是否定的。

因为它把：

1. `resume honesty`
2. `archive session`
3. `deregister environment`
4. `bridge offline projection`

拆成了不同层级的决定。

源码尤其清楚地说明：

1. multi-session mode 下，session completion 可以直接触发 `archiveSession()`，目的是别让它继续在 web UI 里“假活着”
2. single-session non-fatal exit 却会故意跳过 `archive + deregister`，因为否则 printed resume command 会变成 lie
3. graceful shutdown 里的 archive 与 deregister 更像 active-surface close，而不是更强的 semantic closure
4. `session not found` 错误甚至会把 “archived / expired / login lapsed” 并列输出，说明 archive 本身并不是唯一真相

这意味着在 Claude Code 当前设计里：

`liability release`

和

`archive close`

回答的仍然不是同一个问题。

所以 `151` 之后必须继续补的一层就是：

`安全免责释放与归档关闭分层`

也就是：

`liability-release signer 最多只能说“这条责任线程不再要求继续履行”；archive-close signer 才配决定它现在是否应退出活跃操作表面。`

## 2. 先做一条谨慎声明：`archive-close signer` 也是研究命名，不是源码现成类型

和 `151` 一样，需要先讲清楚：

`Claude Code 当前源码里并没有一个字面存在的 signer 类型叫 archive-close signer。`

这里的 `archive-close signer` 仍然是本研究为了描述更强 close gate 而引入的分析命名。  
它不是在声称 Anthropic 已经把这个对象正式类型化，  
而是在说：

1. 当前源码已经把 `forgetting` 与 `liability release` 区分开
2. 当前源码又同样明确把 `archiveSession()`、`deregisterEnvironment()`、`resume honesty` 与 `bridge offline projection` 分层处理
3. 所以下一层最自然的分析主权，就是谁配宣布“这个对象可以退出 active operational surface”

换句话说：

`152` 不是发明现成实现，  
而是从现有 bridge 生命周期设计里继续抽出一个更强的关闭主权。`

## 3. 最短结论

Claude Code 当前源码至少展示了四类“liability release 仍不等于 archive close”证据：

1. multi-session mode 中，session 完成后会直接 `archiveSession()`，目的只是避免 web UI 把它继续显示成 stale  
   `src/bridge/bridgeMain.ts:553-568`
2. graceful shutdown 默认会 `archiveSession + deregisterEnvironment`，其目标是让 web UI 显示 bridge offline，并清理 Redis stream  
   `src/bridge/bridgeMain.ts:1418-1577`
3. single-session non-fatal exit 明确跳过 `archive + deregister`，因为 printed resume command 必须保持诚实  
   `src/bridge/bridgeMain.ts:1515-1537`
4. `session not found` 错误把 archived、expired、login lapsed 并列，说明 archive 只是 close possibility 之一，不是唯一死真相  
   `src/bridge/bridgeMain.ts:2384-2398`

因此这一章的最短结论是：

`liability-release signer 最多只能说“这条责任线程不再要求继续履行”；它仍然不能越级说“对象现在就该退出活跃表面并被归档关闭”。`

再压成一句：

`责任可释，不等于表面可封。`

## 4. 第一性原理：为什么“责任关闭”仍不等于“表面归档关闭”

从第一性原理看：

- liability release 回答的是  
  `系统是否还对同一责任线程负有 continuation / retry / reopen 义务？`
- archive close 回答的是  
  `这个对象现在是否应该退出活跃操作表面，避免继续占用前台位置、误导观察者或污染在线视图？`

所以两者处理的是两种不同的 closure：

1. obligation closure
2. active-surface closure

如果把两者压成同一个 green state，  
系统就会制造三类幻觉：

1. released-means-archived illusion  
   只要责任线程暂时释放，就误以为它应立即退出所有活跃表面
2. archived-means-fully-closed illusion  
   只要对象从 UI 上消失，就误以为更深层语义也已经关闭
3. off-screen-means-out-of-scope illusion  
   只要表面不再展示，就误以为控制面不再需要继续维护它的更强真相

所以从第一性原理看：

`release 决定义务，archive 决定前台；前者不能自然推出后者。`

## 5. multi-session archive 说明 archive 的首要目标是“退出活跃表面”，不是“宣布全部结束”

`src/bridge/bridgeMain.ts:553-568` 把这件事写得非常直白：

1. multi-session mode 下 bridge 还会继续运行
2. 但某个 completed session 会被 `archiveSession()`
3. 理由是：不要让它在 web UI 里继续 linger 成 stale

这条证据特别强，  
因为它说明：

`archive`

在这里首先治理的不是 deep semantic closure，  
而是：

`active operational surface hygiene`

也就是说，  
即使 broader bridge lifecycle 还在继续，  
局部 session 也可以先退出 active surface。

所以 archive signer 在这里签的不是：

`世界对它再也没有责任了`

而是：

`它现在不应继续占据前台运行位。`

## 6. graceful shutdown 说明 archive+deregister 更像 bridge/offline projection close

`src/bridge/bridgeMain.ts:1418-1577` 再进一步说明：

1. shutdown 会收集 sessions to archive
2. 执行 `archiveSession`
3. 再 `deregisterEnvironment`
4. 目标是让 web UI 显示 bridge offline，并清 Redis stream

这条路径说明 archive+deregister 的组合回答的是：

`现在还能不能把这个 bridge / session 当作在线运行对象看待？`

而不是：

`这条对象的所有语义后果是否都已完成审计并正式关闭？`

尤其 `archiveSession` 的 idempotent 设计更说明：

`archive` 先是 control-plane visibility operator，

而不是一次不可逆的深层裁决。

## 7. single-session resumable shutdown 说明 release 之后也可能故意不 archive

`src/bridge/bridgeMain.ts:1515-1537` 是这一章最关键的反例：

1. single-session
2. known session
3. non-fatal exit
4. 明确跳过 `archive + deregister`
5. 原因是：否则 printed resume command 会变成 lie

这说明源码作者承认一种非常重要的状态：

`当前可以退出`

但

`现在还不能 archive close`

因为 resume truth 仍要被保住。

也就是说，  
哪怕某种意义上的 liability 已经减轻，  
只要 active-surface close 会伤害 resume honesty，  
系统就宁可继续让对象保持在可续接状态。

所以 archive close gate 明显比 liability release 更窄：

`是否还能继续履责`

和

`是否可以安全退出活跃表面`

是两张不同的票。

## 8. `session not found` 与 transient reconnect failure 说明 archive 不是唯一 close truth

`src/bridge/bridgeMain.ts:2384-2398` 明确打印：

`archived or expired, or your login may have lapsed`

这说明从源码作者视角看，  
active-surface close 的可能原因至少有：

1. archived
2. expired
3. auth/lapse side failure

而 `src/bridge/bridgeMain.ts:2524-2540` 又说明：

1. transient reconnect failure 明确不得 deregister
2. 非 fatal failure 甚至要求保留 pointer 供下次再试

所以系统在关闭对象表面时真正依赖的不是单一 archive bit，  
而是一套更细的 operational truth：

1. can still resume
2. should still retry
3. should disappear from active UI
4. must be treated as dead

因此 archive close signer 的本质也不是：

`给历史盖棺`

而是：

`在多种 operational truth 里，决定它是否还该被当前表面继续展示。`

## 9. 技术先进性：Claude Code 先进在把“活跃表面关闭”与“语义关闭”继续拆开

从技术角度看，这套设计的先进性不在于它有 `archiveSession()` 这个动作本身，  
而在于它没有偷懒把几种关闭压成一个按钮：

1. session completion 后的 archive
2. bridge shutdown 后的 archive+deregister
3. resumable exit 时的 no-archive
4. transient reconnect failure 时的 no-deregister

这说明 Claude Code 治理的是：

`surface truth`

而不是：

`粗暴的结束感`

它真正先进的地方是：

- 用 idempotent archive 解决表面 linger 问题
- 用 deregister 解决 environment offline projection
- 用 resumable shutdown 守住 resume honesty
- 用 transient/fatal 分流守住 retry possibility

这四层拆开后，控制面才不容易把：

`前台不该继续显示`

误说成：

`对象已经被更深层地彻底关闭。`

## 10. 对下一代安全控制面的技术启示

如果沿着 Claude Code 当前 bridge lifecycle 往前推，  
下一代 control-plane close grammar 至少应继续结构化成：

1. `liability_released`
   同一责任线程不再要求继续履行
2. `archive_close_allowed`
   对象现在可以退出 active operational surface
3. `environment_offline`
   host / bridge 不再对外投影为在线
4. `audit_close_granted`
   更强的审计关闭另行签字

必要时还应补：

5. `resume_honesty_preserved`
   若系统仍打印或保留 resume promise，就不得假装 archive close 已经合法
6. `close_reason`
   archive、expiry、auth lapse、fatal reconnect 应分开结构化

否则系统很容易重新退回：

`一个 close 吃掉 release、archive、offline、audit`

这会让控制面再次滑回伪关闭。

## 11. 用苏格拉底诘问法再追问一次

### 问：multi-session completion 后直接 archive，不就说明 archive 很弱吗？

答：恰恰相反。这正说明 archive 有自己明确的职责，它负责退出 active surface，而不是伪装成 deep semantic closure。

### 问：为什么 resumable shutdown 不 archive 这么关键？

答：因为它证明 archive 不是“退出时默认顺手做掉”的动作，而要服从更强的 resume honesty gate。

### 问：如果 archive 只是 UI hygiene，是否就不重要？

答：不是。active-surface truth 本身就是控制面的一部分。错误归档会制造假离线、假完成、假失效。

### 问：那 archive 是否已经等于 audit close？

答：显然不等于。源码里 archive 被做成 idempotent operational operator，而不是一次深层历史裁决。

### 问：这章之后最值得继续追问什么？

答：不是正文里继续写“下一章是什么”，而是记到隔离记忆层里：如果 archive 仍不等于 audit close，那么未来更强的一层就应回答“谁有资格宣布 audit-close granted”。

## 12. 一条硬结论

Claude Code 当前源码再次展示出一条更深的安全哲学：

`退出责任，不等于退出表面；退出表面，也不等于退出审计。`

因此沿着当前源码设计思路往前推，  
真正成熟的关闭体系至少还要继续分离：

1. liability release
2. archive close
3. environment offline
4. audit close

所以：

`liability-release signer 不能越级冒充 archive-close signer。`
