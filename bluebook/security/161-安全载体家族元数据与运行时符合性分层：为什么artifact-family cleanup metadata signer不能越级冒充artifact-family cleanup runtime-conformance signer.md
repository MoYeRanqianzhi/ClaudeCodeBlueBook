# 安全载体家族元数据与运行时符合性分层：为什么artifact-family cleanup metadata signer不能越级冒充artifact-family cleanup runtime-conformance signer

## 1. 为什么在 `160` 之后还必须继续写 `161`

`160-安全载体家族制度理由与元数据分层` 已经回答了：

`Claude Code 当前虽然已有大量 artifact-family truth，但这些 truth 还没有被完整升级成统一 metadata plane。`

但如果继续往下追问，  
还会碰到下一层更危险的错觉：

`只要系统已经有了 metadata，runtime reality 就必然已经持续服从这份 metadata。`

Claude Code 当前源码仍然不能支持这种更强的说法。

因为继续看 `settings/types.ts`、`validationTips.ts`、`sessionStorage.ts`、`backgroundHousekeeping.ts`、`cleanup.ts`、`plans.ts`、`permissions/filesystem.ts` 与 `main.tsx / REPL.tsx` 会发现：

1. 某些 policy / metadata signal 已经存在
2. 但 runtime 何时执行、是否跳过、是否真正对齐、是否产生 receipt，仍然是另一层问题
3. 也就是说，policy truth 与 runtime conformance truth 仍然不是同一 signer 层

这说明：

`artifact-family cleanup metadata signer`

和

`artifact-family cleanup runtime-conformance signer`

仍然不是一回事。

前者最多能说：

`系统已经把某些 family policy 编码进 schema、helper、路径规则或 metadata 描述。`

后者才配说：

`当前 runtime 已经在这个 session、这个启动阶段、这个 validation 状态下真实地服从了这份 policy，而且这个服从结果可被证明。`

所以 `160` 之后必须继续补的一层就是：

`安全载体家族元数据与运行时符合性分层`

也就是：

`artifact-family cleanup metadata signer 只能说“规则已经被写出来”；artifact-family cleanup runtime-conformance signer 才能说“当前运行时已经按这份规则发生，而且没有继续分叉”。`

## 2. 先做一条谨慎声明：`artifact-family cleanup runtime-conformance signer` 仍是研究命名，不是源码现成类型

这里同样要先讲清楚：

`Claude Code 当前源码里并没有一个字面存在的类型叫 artifact-family cleanup runtime-conformance signer。`

这里的 `artifact-family cleanup runtime-conformance signer` 仍然只是研究命名。  
它不是在声称仓库里已经有一个正式的 conformance receipt 类型却没人调用，  
而是在说：

1. policy / metadata truth 即使存在，也仍然必须通过 scheduler、executor、skip guard 与 result surfacing 被证成
2. 当前代码已经暴露出多个 policy truth 与 runtime reality 的时间差、跳过差和传播差
3. 所以更强的下一层，不是继续讨论“有没有 policy”，而是“谁配证明 policy 在运行时已被服从”

因此 `161` 不是在虚构已有实现，  
而是在给另一个真实缺口命名：

`规则写下来了，不等于它此刻已经被运行时诚实执行。`

## 3. 最短结论

Claude Code 当前源码至少给出了六类“metadata signer 仍不等于 runtime-conformance signer”证据：

1. `cleanupPeriodDays=0` 的 metadata 语义写得很强  
   `settings/types.ts:323-334` 与 `validationTips.ts:46-53` 都说“existing transcripts are deleted at startup”
2. 但运行时即时发生的首先只是 future-write suppression  
   `sessionStorage.ts:954-969` 的 `shouldSkipPersistence()` 只是立刻停止 transcript writes
3. 真正 cleanup 的 runtime 路径则走 delayed housekeeping  
   `REPL.tsx:3903-3906` 在第一次提交后才启动 `startBackgroundHousekeeping()`；`main.tsx:2813-2818` 也只是在 headless 初始化阶段后台启动它  
   `backgroundHousekeeping.ts:24-58` 又把 cleanup 放到 10 分钟后，并且用户最近有交互时会继续后延
4. runtime 甚至可能因 validation state 故意不执行 cleanup  
   `cleanup.ts:575-584` 明确在 settings 有 validation errors 且用户显式设置了 `cleanupPeriodDays` 时直接 skip cleanup
5. plans family 再次证明 runtime 不一定服从 metadata  
   `plans.ts:79-110` 与 `settings/types.ts:824-830` 允许 `plansDirectory` 自定义，但 `cleanup.ts:300-303` 的 executor 仍只扫默认 `~/.claude/plans`
6. cleanup 函数明明返回 `CleanupResult`，但后台入口几乎全部丢弃  
   `cleanup.ts:33-44` 定义了 `CleanupResult`；`cleanup.ts:575-595` 却没有汇总或输出这些结果，只对 stale worktrees 额外打 telemetry

因此这一章的最短结论是：

`metadata signer 最多能说“系统宣称应该如此”；runtime-conformance signer 才能说“它已经在这个 runtime 中如此发生，并且这个发生结果被正式保存”。`

再压成一句：

`有规则，不等于有符合性证明。`

## 4. 第一性原理：metadata 回答“系统自述了什么”，runtime-conformance 回答“运行时实际做了什么”

从第一性原理看，  
metadata 与 runtime-conformance 处理的是两种完全不同的问题。

metadata 回答的是：

1. 这个 family 的 policy 是什么
2. 存哪、读给谁、由谁删
3. 哪些路径是合法路径
4. 哪些 retention knob / override 是合法输入
5. drift invariant 理论上该是什么

runtime-conformance 回答的则是：

1. scheduler 何时真正开始执行
2. validation / environment / interactivity state 是否改变执行结果
3. executor 是否真的消费了那份 metadata
4. write suppression、delete execution、cleanup receipt 是否同步成立
5. 当前 session 里到底发生了什么，而不是应该发生什么

如果把这两层压成一句“规则已经有了”，  
系统就会制造五类危险幻觉：

1. documented-means-done illusion  
   只要 schema / docstring 写了，就误以为 runtime 已经做完
2. suppression-means-deletion illusion  
   只要 future writes 被抑制，就误以为 past artifacts 已被删除
3. startup-language-means-immediate-execution illusion  
   只要文案说“deleted at startup”，就误以为 cleanup 在启动瞬间已发生
4. metadata-consumed-somewhere-means-consumed-everywhere illusion  
   只要某个 override 被 path helper 读取，就误以为 executor 也已经跟随
5. return-type-means-receipt illusion  
   只要 cleanup 函数返回 `CleanupResult`，就误以为 runtime 实际保存了 conformance receipt

所以从第一性原理看：

`metadata` 是系统对规则的自述；  
`runtime-conformance` 是系统对“这条规则此刻已被执行”的证明。

## 5. `cleanupPeriodDays=0` 先给出最典型的分层样本：声明很强，但运行时实际分成了“先停写，再延迟删”

`settings/types.ts:323-334` 与 `validationTips.ts:46-53` 都给出同一类强语义：

`Setting 0 disables session persistence entirely: no transcripts are written and existing transcripts are deleted at startup.`

这句话如果被当作 metadata signal，  
它已经相当强。  
它不只是说“保留期更短”，  
而是在说：

1. future writes 停止
2. existing transcripts 删除
3. 发生时点在 startup

但 `sessionStorage.ts:954-969` 的 `shouldSkipPersistence()` 说明：

1. 只要 `cleanupPeriodDays === 0`
2. transcript writes 会被 suppress

这显然只证明了：

`future-write suppression`

并没有直接证明：

`past transcript deletion has already happened`

这里就出现第一条非常硬的 conformance 分层：

`metadata promise 可以是一句完整句子，但 runtime reality 往往先分解成多个阶段动作。`

## 6. `backgroundHousekeeping` 进一步说明：所谓 startup cleanup，在运行时并不是“立即删”，而是“满足条件后再异步删”

`REPL.tsx:3903-3906` 很关键。  
它只在 `submitCount === 1` 之后调用：

`startBackgroundHousekeeping()`

也就是说，  
在交互 REPL world 里，cleanup 甚至不是在进程刚启动时立刻跑，  
而是在第一次提交后才开始进入 housekeeping 流程。

`main.tsx:2813-2818` 对 headless world 也是类似逻辑：  
它会后台启动 `startBackgroundHousekeeping()`，  
但这仍然只是“开始启动 housekeeping”，  
不是“cleanup 已经完成”的 receipt。

真正更关键的是 `backgroundHousekeeping.ts:24-58`：

1. `DELAY_VERY_SLOW_OPERATIONS_THAT_HAPPEN_EVERY_SESSION = 10 * 60 * 1000`
2. `runVerySlowOps()` 被设定在 10 分钟后
3. 如果最近一分钟用户有交互，还会继续 reschedule
4. 只有 `needsCleanup` 为真时才第一次跑 `cleanupOldMessageFilesInBackground()`

这说明 metadata 里的：

`deleted at startup`

在 runtime 里更接近：

`cleanup enters an eventually-run background housekeeping path after startup, and interactive activity can defer it further`

这并不一定意味着设计错误。  
更准确地说，它说明了：

`metadata signer` 和 `runtime-conformance signer` 必须被分开。

因为 scheduler 自己已经引入了时间层。

## 7. validation guard 说明：即使 metadata 很清楚，runtime 也可能为了更高阶安全而故意“不符合”

`cleanup.ts:575-584` 还给出另一条更强的运行时事实：

1. 如果 settings 有 validation errors
2. 且用户显式设置了 `cleanupPeriodDays`
3. runtime 会直接 skip cleanup

注释还明确写了原因：

`skip cleanup entirely rather than falling back to the default (30 days). This prevents accidentally deleting files when the user intended a different retention period.`

这意味着 runtime conformance 不是简单的“文案怎么说就怎么执行”，  
而是还要服从更高阶的 safety guard：

`不要因为设置坏了就偷偷按默认值删文件。`

这其实体现了 Claude Code 安全设计里很先进的一点：

`runtime 可以为了避免误删而故意拒绝执行 metadata 看起来要求的动作。`

但也正因如此，  
它再次证明：

`metadata` 不是 `runtime-conformance`。

前者只是 policy truth；  
后者还要纳入 validation state、fallback risk 与 intentional non-execution。

## 8. plans family 再给出传播层面的运行时不符合：metadata 被部分消费，不等于 executor 已跟随

`settings/types.ts:824-830`、`plans.ts:79-110` 与 `permissions/filesystem.ts:245-254,1645-1652` 已经共同说明：

1. `plansDirectory` 是正式 metadata knob
2. `getPlansDirectory()` 会消费它
3. `isSessionPlanFile()` / read rule 也会围绕它工作

但 `cleanup.ts:300-303` 的 `cleanupOldPlanFiles()` 仍然写死：

`join(getClaudeConfigHomeDir(), 'plans')`

这意味着这里的问题已经不仅是“metadata plane 还没统一”，  
而是更进一步：

`某些 metadata 即使已经存在，也没有在 runtime executor 层被真正服从。`

所以 plans family 是 `161` 里最有力的传播层面证据。  
它让我们不必做抽象推演，  
而能直接说：

`metadata-consumption happened in some planes, but runtime-conformance failed in another plane.`

## 9. `CleanupResult` 被丢弃又证明：当前 repo 甚至还缺一张正式的运行时符合性回执

`cleanup.ts:33-44` 明明定义了：

`CleanupResult = { messages, errors }`

而且各 cleanup 函数大多都返回 `Promise<CleanupResult>`。

这说明作者已经意识到：

`cleanup execution should be observable at least in principle.`

但 `cleanup.ts:575-595` 的 `cleanupOldMessageFilesInBackground()` 却基本把这些结果全部丢掉：

1. 没有汇总 `CleanupResult`
2. 没有向上层返回 family-by-family receipt
3. 没有区分“哪类 artifact 已 conform、哪类未 conform”
4. 只有 stale worktrees 被单独打了 telemetry event

这意味着当前 runtime 最缺的其实不是“能不能删”，  
而是：

`删了之后，谁来正式说这次 family policy 已被服从。`

所以 `161` 在这里进一步把问题压出来了：

`runtime-conformance signer` 不只是一个哲学命名，它还对应一个非常具体的工程缺口：cleanup result 没有被提升成正式 conformance receipt。

## 10. 技术先进性：Claude Code 先进的地方不是把 runtime 简化成同步执行，而是承认“规则、调度、执行、回执”是四个不同层

从技术角度看，Claude Code 在这条线上真正先进的地方，不是“设置怎么写，运行时就立刻同步照做”。  
恰恰相反，它更成熟的一面在于：

1. 允许 future-write suppression 与 past-artifact deletion 分层
2. 允许 housekeeping 因交互负载而延迟
3. 允许 validation guard 为防误删而直接 skip cleanup
4. 允许不同 artifact family 在不同执行面上逐步接入 metadata

这背后的先进性在于：

`成熟安全系统首先承认 runtime 是多阶段的，而不是把所有 policy 都伪装成单步原子事实。`

但这种先进性也带来下一层硬要求：

`既然 runtime 是分阶段、多条件、多执行面的，就更需要正式的 conformance signer。`

否则系统就会陷入一种危险状态：

`每个局部设计都很聪明，但全局没有谁能诚实宣布当前到底符合了多少。`

这给源码设计带来的技术启示非常直接：

1. metadata plane 补出来之后，还必须继续补 conformance plane
2. conformance receipt 至少应区分  
   `declared`  
   `suppressed`  
   `scheduled`  
   `executed`  
   `skipped-with-reason`  
   `mismatched`
3. scheduler 的延迟策略不该继续只藏在注释里，而应进入 conformance explanation
4. 每个 family 的 executor 是否真正消费对应 metadata，应该能被自动校验

## 11. 哲学本质：真正成熟的制度，不只要能自述，还要能自证

`160` 的哲学本质是：

`制度必须能被系统自己自述。`

`161` 的哲学本质则更进一步：

`制度如果不能被运行时自证，就仍然只是纸面制度。`

这意味着成熟系统的更高要求已经变成三层：

1. 有制度
2. 有制度自述
3. 有制度自证

只要第三层缺失，  
系统就仍会继续停留在一种半完成状态：

`规则被写出来了，但没有谁能在当前时刻诚实证明它已经被服从。`

所以 `161` 的哲学要点不是继续要求更多文档，  
而是提醒一个更硬的原则：

`规则若不能被运行时证明，它最终仍只是承诺，不是事实。`

## 12. 苏格拉底式自诘：我的判断有没有再次越级

为了避免把“存在时间差和 skip 条件”直接写成“系统不可信”，  
这里必须主动追问自己四个问题。

### 第一问

`我是不是把“不是立即执行”直接写成了“设计错误”？`

不能这样写。  
更谨慎的说法应该是：

`延迟 housekeeping 可能是合理的性能与交互权衡；它证明的是 runtime-conformance 需要独立署名，而不自动证明设计失败。`

### 第二问

`我是不是把 validation guard 的 skip 误写成了不符合 policy？`

也不能这样写。  
更准确地说：

`validation guard 体现的是更高阶的 fail-safe policy，它进一步证明 conformance 不是单层的“照 schema 执行”，而是要在更高安全约束下被解释。`

### 第三问

`如果 CleanupResult 被丢弃，是否就能断言系统没有任何 conformance awareness？`

还不能这样断言。  
更谨慎的判断是：

`系统已经有局部 conformance awareness，因为返回类型存在；但这份 awareness 还没有被提升成正式、可传播、可审计的 signer 层。`

### 第四问

`我真正该继续约束自己的是什么？`

是这句：

`不要把局部返回类型与局部 awareness，误写成正式的 runtime conformance receipt plane。`

当前更稳妥的说法只能是：
repo 已经有局部 conformance awareness，
因为 delay、skip、result object 与 validation guard 都已经被写进运行链。

但这还不足以推出：

`family-by-family conformance receipt 已经成为正式、可传播、可审计的 signer 层。`

## 13. 一条硬结论

这组源码真正说明的不是：

`Claude Code 现在只要把 artifact-family metadata 写出来，就等于 cleanup runtime 已经自动符合。`

而是：

`Claude Code 的 runtime 已经明确展示出调度延迟、validation skip、传播不一致与 receipt 缺口；因此 artifact-family cleanup metadata signer 仍不能越级冒充 artifact-family cleanup runtime-conformance signer。`

再压成最后一句：

`元数据说明规则是什么；运行时符合性，才说明规则真的成了事实。`
