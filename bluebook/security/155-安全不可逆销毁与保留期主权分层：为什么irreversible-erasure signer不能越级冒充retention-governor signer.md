# 安全不可逆销毁与保留期主权分层：为什么irreversible-erasure signer不能越级冒充retention-governor signer

## 1. 为什么在 `154` 之后还必须继续写 `155`

`154-安全审计关闭与不可逆销毁分层` 已经回答了：

`audit-close signer 最多只能决定材料是否退出 audit world；irreversible-erasure signer 才配决定载体是否已经被 destroy。`

但如果继续追问，  
还会碰到更深一层的主权错觉：

`既然某些代码已经会 unlink / rm / truncate，它们是否已经天然拥有“决定保留期该怎么设、什么时候删、删哪些 artifact”的主权？`

Claude Code 当前源码给出的答案仍然是否定的。

因为继续往下看会发现，  
真正的删除治理至少已经裂成四层：

1. retention policy declaration  
   `cleanupPeriodDays` 在 settings schema 里定义保留期语义  
   `src/utils/settings/types.ts:325-332`
2. retention policy merge / precedence  
   有效值来自 `user -> project -> local -> policy` 的通用 settings merge  
   `src/utils/settings/settings.ts:798-820`
3. enforcement admission / scheduling  
   housekeeping 不是任意时刻触发，而是受 `main.tsx`、`REPL.tsx`、delay、submitCount 与 mode gating 控制  
   `src/main.tsx:2811-2818`  
   `src/screens/REPL.tsx:3903-3906`  
   `src/utils/backgroundHousekeeping.ts:25-29,43-60`
4. deletion execution  
   `cleanup.ts` 最终才对旧 session files、file-history backups 等做 `unlink` / `rm`  
   `src/utils/cleanup.ts:155-257,305-347,575-595`

这说明：

`会删`

和

`配定义删除政策`

仍然不是一回事。

所以 `154` 之后必须继续补的一层就是：

`安全不可逆销毁与保留期主权分层`

也就是：

`irreversible-erasure signer 最多只能说“某些载体已经被实际删掉”；retention-governor signer 才配说“保留期怎么定义、何时进入删除窗口、谁有权执行、何时必须暂停执行”。`

## 2. 先做一条谨慎声明：`retention-governor signer` 仍是研究命名，不是源码现成类型

和 `147-154` 一样，  
这里也要先讲清楚：

`Claude Code 当前源码里并没有一个字面存在的 signer 类型叫 retention-governor signer。`

这里的 `retention-governor signer` 仍然是研究命名。  
它不是在声称 Anthropic 已经把 retention governance 做成显式 signer object，  
而是在说：

1. 当前源码已经把 destructive execution 与 audit semantics 拆开
2. 当前源码又把 settings declaration、validation guard、scheduler 与 executor 拆到不同文件群
3. 所以下一层最自然的分析主权，就是谁配对 retention policy 本身署名

换句话说：

`155` 不是在虚构现有实现，
而是在把源码里已经分离出来的 policy sovereignty 单独命名出来。

## 3. 最短结论

Claude Code 当前源码至少给出了五类“irreversible erasure 仍不等于 retention governance”证据：

1. `cleanupPeriodDays` 的语义来自 settings schema，而不是来自某个 delete 函数  
   `src/utils/settings/types.ts:325-332`
2. 这个值走的是通用 settings merge 顺序 `user -> project -> local -> policy`，说明 policy definition 与 destructive execution 不是同一层  
   `src/utils/settings/settings.ts:798-820`
3. `rawSettingsContainsKey()` 与 validation error guard 会在用户显式配置 retention 但配置出错时直接跳过 cleanup，拒绝默认 30 天偷偷接管  
   `src/utils/settings/settings.ts:871-875,984-1015`  
   `src/utils/cleanup.ts:575-584`
4. housekeeping 的启动时机受 mode / lifecycle gating 影响：headless 非 bare 会提早加载，interactive REPL 则到第一次 submit 后才启动  
   `src/main.tsx:2811-2818`  
   `src/screens/REPL.tsx:3903-3906`
5. 真正执行 unlink/rm 的 `cleanup.ts` 只是 executor，不负责宣布 policy 的合法性、来源优先级与执行时机真相  
   `src/utils/cleanup.ts:155-257,305-347,575-595`

因此这一章的最短结论是：

`irreversible-erasure signer 最多只能说“删掉了什么”；它仍然不能越级说“保留期该怎么定义、这次删除何时才算被合法授权、为什么现在可以删”。`

再压成一句：

`删除动作，不等于删除主权。`

## 4. 第一性原理：为什么 destroy operator 仍不等于 retention governor

从第一性原理看：

- irreversible erasure 回答的是  
  `某个 carrier 现在是否已经被 destroy？`
- retention governance 回答的是  
  `谁定义 retention window、谁决定 cutoff、谁调度执行、谁在异常情况下有权暂停或改口？`

所以两者处理的是两种完全不同的问题：

1. event truth
2. policy truth

如果把两者压成同一个绿色状态，  
系统就会制造四类危险幻觉：

1. executor-means-legislator illusion  
   只要某段代码会 `rm`，就误以为它也有资格定义 retention law
2. config-means-enforcement illusion  
   只要 schema 写了某个语义，就误以为 runtime 已经按那个时机执行
3. default-means-user-intent illusion  
   只要有默认值，就误以为 validation 失败时也能代替用户意图
4. delete-happened-means-delete-was-legitimately-governed illusion  
   只要文件没了，就误以为 policy source、scheduler 与 guard 都已经正确关环

所以从第一性原理看：

`destroy operator` 只回答结果；  
`retention governor` 才回答制度。

## 5. `cleanupPeriodDays` 先定义 retention grammar，再轮到执行器出手

`src/utils/settings/types.ts:325-332` 先把 retention semantics 写成 schema：

1. 默认是 `30`
2. 必须是非负整数
3. `0` 表示禁用 session persistence
4. 文案进一步声称现有 transcripts 会在 startup 删除

不管这条“startup delete”在当前 runtime 里是否完全兑现，  
这里已经足够说明一件更根本的事：

`保留期语义首先是配置语义，不是执行语义。`

也就是说，  
在当前设计里，  
真正先说话的不是 `cleanupOldSessionFiles()`，  
而是 settings schema。

这就意味着 destructive executor 的上方已经存在一个更高层：

`retention declaration layer`

## 6. merge order 说明 retention governance 目前走的是通用配置主权，而不是特种安全主权

`src/utils/settings/settings.ts:798-820` 明确写出：

`userSettings -> projectSettings -> localSettings -> policySettings`

这是 effective settings 的合并顺序。  
它意味着 `cleanupPeriodDays` 当前并没有被单独拉出去做：

- trusted-only merge
- destructive-governance-only lane
- no-project override constitution

相反，  
它首先服从一条通用的配置主权链。

这里最值得警惕的不是“这样一定错”，  
而是它与别的高风险设置形成了明显对比：

`src/utils/settings/settings.ts:877-888,891-904,916-921` 对危险权限确认、auto-mode opt-in 等敏感决策，明确排除了 `projectSettings`，理由是：

`a malicious project could otherwise ...`

但对 `cleanupPeriodDays`，  
当前可见实现并没有做同样的排除。

这说明至少在当前 extracted 源码里：

`retention governance 的硬化等级低于 permission governance。`

这正是本章最重要的安全判断之一。

## 7. `rawSettingsContainsKey()` 与 validation guard 说明 executor 不配篡改用户 retention intent

`src/utils/settings/settings.ts:871-875,984-1015` 和 `src/utils/cleanup.ts:575-584` 组成了本章最漂亮的一段边界：

1. `rawSettingsContainsKey()` 会跨 enabled setting sources 查原始文件里是否显式出现某个 key
2. 它故意跳过 `policySettings`，因为这里关心的是 user-configured intent
3. `cleanupOldMessageFilesInBackground()` 看到 validation errors 时，如果用户显式设置了 `cleanupPeriodDays`，就直接跳过 cleanup

这段设计的哲学非常值得注意。

它拒绝这样一种偷懒做法：

`配置坏了，那就退回默认 30 天继续删。`

源码作者在这里选择的是：

`宁可不删，也不要让默认值冒充用户真正想要的 retention policy。`

所以这条 guard 已经清楚说明：

`cleanup executor 并不拥有 policy override sovereignty。`

它必须服从：

`intent honesty gate`

## 8. housekeeping scheduler 再次拆出一层：不是“现在能删”，而是“现在该不该启动删除”

`src/main.tsx:2811-2818`、`src/screens/REPL.tsx:3903-3906` 与 `src/utils/backgroundHousekeeping.ts:25-29,43-60` 一起展示了另一条关键边界：

1. headless 非 bare 模式会尽早动态导入 `backgroundHousekeeping`
2. REPL interactive 路径则直到 `submitCount === 1` 才 `startBackgroundHousekeeping()`
3. housekeeping 内部还有 `10 minutes after start` 的延迟
4. `runVerySlowOps()` 还会因为最近 1 分钟内有用户活动而推迟
5. 注释甚至明说 scripted calls 不需要这些 bookkeeping，下一次 interactive session 会 reconcile

这说明 retention governance 里还有一层独立问题：

`不是 policy 允不允许删，而是 runtime 现在应不应该启动删除流程。`

换句话说，  
即使 retention policy 已经存在，  
delete executor 也还要等待：

- session mode
- entrypoint
- user activity
- deferred scheduling

这证明 scheduler 不是 executor 的附属细节，  
而是另一层治理主权。

## 9. “startup delete” 文案与可见执行链之间存在一条值得正视的诚实性张力

这里必须做一条谨慎但重要的观察。

`src/utils/settings/types.ts:331-332` 与 `validationTips.ts:52-54` 都把 `cleanupPeriodDays = 0` 解释成：

`existing transcripts are deleted at startup`

但在当前可见 extracted source 里，  
我能明确定位到的删除执行链是：

1. `main.tsx` 动态启动 housekeeping
2. `REPL.tsx` 在第一次 submit 后启动 housekeeping
3. `backgroundHousekeeping.ts` 再经过延迟与活动检测
4. `cleanup.ts` 才实际执行 unlink/rm

至少从这条可见链路看，  
这里并不是一个显而易见的“process start instant delete”语义。

这不一定意味着产品行为最终就是错的。  
但它已经足够说明：

`retention declaration truth`

和

`runtime enforcement truth`

在当前源码里并没有被压成同一层。

从安全产品诚实性角度说，  
这恰恰进一步支持本章判断：

`retention governor` 不能被 `destroy executor` 冒充，  
反过来也不能让 schema 文案自动冒充 enforcement fact。

## 10. `cleanup.ts` 的角色更像 bailiff，而不是 constitution

`src/utils/cleanup.ts:155-257,305-347,575-595` 已经把执行层写得很清楚：

1. 用 `getCutoffDate()` 算 cutoff
2. `cleanupOldSessionFiles()` 删除旧 `.jsonl` / `.cast` / tool-results
3. `cleanupOldFileHistoryBackups()` 递归删除旧 file-history session dir
4. `cleanupOldSessionEnvDirs()`、`cleanupOldDebugLogs()`、`cleanupOldPastes()` 继续扩大清理面
5. `cleanupOldMessageFilesInBackground()` 统一串起整组 cleanup

所以执行层真正回答的是：

`一旦 policy + scheduler + guard 都放行，现在具体删哪些路径`

它并不回答：

- 这个 policy 从哪个 source 来
- projectSettings 是否该有资格改这个 policy
- validation 失败时默认值能不能顶上
- “startup delete” 的 honesty ceiling 到底该怎么表述

也就是说，  
它更像执达者，  
不是立法者。

## 11. 技术先进性与哲学本质：Claude Code 真正先进的不是“提供一个 cleanupPeriodDays”，而是让多层主权互相制衡

从技术上看，Claude Code 这条 retention 链最先进的地方不在于：

`它能按天数删除文件`

而在于它已经隐含出四层不同主权：

1. declaration layer  
   schema / setting description
2. precedence layer  
   merge order / source priority
3. honesty guard layer  
   rawSettingsContainsKey + validation skip
4. execution layer  
   scheduler + cleanup executor

这背后的哲学本质是：

`真正成熟的 destruction governance，不会让“文件系统动作”自动篡位成“政策真相”。`

它宁可保留 awkward 的分层：

- 谁定义
- 谁合并
- 谁校验
- 谁调度
- 谁执行

也不愿意把这一切压成一句：

`cleanupPeriodDays = N，所以系统自然会删。`

## 12. 苏格拉底式反思：如果这章还可能写错，最容易错在哪里

### 反思一

既然 `cleanup.ts` 真的会 `rm -r`，我为什么还不能直接说它就是 retention governor？

因为执行删除只是最末端动作。  
如果 cutoff、source priority、validation honesty 与启动时机都不是它决定的，  
那它就只是 executor，不是 governor。

### 反思二

既然 settings schema 已经把 retention 语义写出来了，我为什么还不能把 schema 当最终真相？

因为 declaration 仍可能和 enforcement timing 分离。  
当前可见源码里，“startup delete”的文案和可见执行链之间就存在值得正视的距离。

### 反思三

既然 `cleanupPeriodDays` 走通用 settings merge，这一定是安全漏洞吗？

未必。  
但它至少说明 retention governance 目前没有像危险权限那样被单独提升成特种安全主权。  
这是一条设计事实，也是一条未来是否要补强的安全问题。

### 反思四

`我是不是把 retention policy 的存在，偷写成 destruction governance 已经被完整制度化？`

不能这样写。
更稳妥的约束是：

`cleanupPeriodDays` 的声明、source precedence、validation guard、scheduler 与 destructive executor 已经被源码拆层。

因此我能确认的，
只是：

`retention governance != irreversible erasure`

以及：

`真正的 retention governor 不能被任何单一删除动作篡位。`

我还不能反过来宣称产品层已经把 source trust-class、execution ledger 与 honesty 协议全部做实。

## 13. 一条硬结论

Claude Code 当前源码真正说明的不是：

`会删文件的代码就拥有保留期主权`

而是：

`retention policy、source precedence、intent honesty、scheduler 与 destroy executor 仍然是不同强度的治理层。`

因此：

`irreversible-erasure signer 不能越级冒充 retention-governor signer。`
