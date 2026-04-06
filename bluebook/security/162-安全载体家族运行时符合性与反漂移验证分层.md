# 安全载体家族运行时符合性与反漂移验证分层：为什么artifact-family cleanup runtime-conformance signer不能越级冒充artifact-family cleanup anti-drift verifier signer

## 1. 为什么在 `161` 之后还必须继续写 `162`

`161-安全载体家族元数据与运行时符合性分层` 已经回答了：

`即便 artifact-family metadata 已经存在，runtime reality 也仍然可能因为调度延迟、validation skip、传播不一致与回执缺口而不自动符合。`

但如果继续往下追问，  
还会碰到下一层更容易被误写成“已经解决”的错觉：

`只要本次 runtime 看起来已经符合 policy，就等于系统已经具备了长期反漂移验证能力。`

Claude Code 当前源码仍然不能支持这种更强的说法。

因为继续看 `cleanup.ts`、`backgroundHousekeeping.ts`、`sessionStorage.ts`、`plans.ts`、`permissions/filesystem.ts`、`settings/types.ts`，再对照 `microCompact.ts`、`bootstrap/state.ts` 与 `permissions/permissionSetup.ts` 会发现：

1. repo 其他地方已经明确长出了 anti-drift verifier 的设计意识
2. cleanup 线却还停留在 metadata、runtime execution 与局部注释层
3. 也就是说，某次运行“看起来符合”与“系统长期有 verifier 防止再次分叉”仍不是同一层

这说明：

`artifact-family cleanup runtime-conformance signer`

和

`artifact-family cleanup anti-drift verifier signer`

仍然不是一回事。

前者最多能说：

`这次运行里某些 cleanup policy 看起来已经被执行了。`

后者才配说：

`系统已经拥有持续的、显式的验证机制，能长期发现 metadata、scheduler、executor、permission、resume 之间是否再次分叉。`

所以 `161` 之后必须继续补的一层就是：

`安全载体家族运行时符合性与反漂移验证分层`

也就是：

`artifact-family cleanup runtime-conformance signer 只能说明“这次也许已符合”；artifact-family cleanup anti-drift verifier signer 才能说明“将来若再偏离，系统会自己发现并拒绝继续撒谎”。`

## 2. 先做一条谨慎声明：`artifact-family cleanup anti-drift verifier signer` 仍是研究命名，不是源码现成类型

这里仍要先讲清楚：

`Claude Code 当前源码里并没有一个字面存在的类型叫 artifact-family cleanup anti-drift verifier signer。`

这里的 `artifact-family cleanup anti-drift verifier signer` 仍然只是研究命名。  
它不是在声称仓库里已经有一个 `verifyCleanupFamilyConformance()` 没被调用，  
而是在说：

1. repo 的其他区域已经明确展示出 source-of-truth test、atomic invariant 与 live re-verification 这类 anti-drift 思维
2. cleanup 线当前还没有展示出同等级的显式 verifier 面
3. 所以更高阶的问题已经不是“这次有没有删”，而是“以后再漂移时谁会第一时间把它抓出来”

因此 `162` 不是在虚构已有实现，  
而是在给一个更深的缺口命名：

`运行时偶尔符合，不等于系统已经学会长期防漂移。`

## 3. 最短结论

Claude Code 当前源码至少给出了六类“runtime-conformance signer 仍不等于 anti-drift verifier signer”证据：

1. `microCompact.ts:31-36` 明确写出  
   `Drift is caught by a test asserting equality with the source-of-truth.`  
   这说明 repo 确实知道什么叫 anti-drift verifier
2. `bootstrap/state.ts:456-466` 又明确写出  
   `sessionId` 与 `sessionProjectDir` `cannot drift out of sync`  
   并通过原子切换接口防漂移
3. `permissionSetup.ts:1078-1150` 的 `verifyAutoModeGateAccess()` 则更进一步，专门用 live read 去纠正 stale cache，并把 gate truth 拉回当前 runtime
4. 与这些正例相比，cleanup 线目前只有 runtime 发生的局部迹象  
   `sessionStorage.ts:954-969`  
   `backgroundHousekeeping.ts:24-58`  
   `cleanup.ts:575-595`
5. plans family 还继续暴露传播漂移  
   `plans.ts:79-110` 与 `cleanup.ts:300-303` 仍未对齐
6. 当前可见 cleanup 线既没有 source-of-truth test 注释、也没有专门 verify function、也没有 family-by-family conformance receipt surface

因此这一章的最短结论是：

`runtime-conformance signer 最多能说“现在看起来符合”；anti-drift verifier signer 才能说“如果将来不符合，系统会主动发现”。`

再压成一句：

`一次符合，不等于长期可信。`

## 4. 第一性原理：conformance 回答“此刻是否成立”，anti-drift verification 回答“偏离时谁会报警”

从第一性原理看，  
runtime-conformance 与 anti-drift verification 处理的是两种完全不同的时间问题。

runtime-conformance 回答的是：

1. 当前这次运行里 policy 是否被执行
2. execution 有没有被 skip
3. skip 的理由是什么
4. 哪些 family 当前已 conform
5. 当前有没有 receipt

anti-drift verification 回答的则是：

1. 如果代码未来改了，谁来验证 source-of-truth 没被改坏
2. 如果 cache、settings、live state 分叉了，谁来做再验证
3. 如果多个字段必须原子变化，谁来保证它们不会悄悄脱钩
4. 如果某个 helper 已更新但 executor 没更新，谁会主动失败而不是沉默
5. 如果系统开始说谎，谁会先把谎言暴露出来

如果把两层压成一句“当前看起来没问题”，  
系统就会制造五类危险幻觉：

1. green-now-means-stable-later illusion  
   这次没出事，就误以为未来也不会漂移
2. execution-means-verification illusion  
   运行时做过一次，就误以为已具备长期验证
3. no-symptom-means-no-drift illusion  
   没出现症状，就误以为没有潜在分叉
4. helper-update-means-plane-sync illusion  
   某个 helper 改了，就误以为其他平面自动跟上
5. comment-awareness-means-checking-awareness illusion  
   注释里知道有风险，就误以为代码已经有 verifier

所以从第一性原理看：

`runtime-conformance` 是当前事实；  
`anti-drift verification` 是未来失真会不会被及时抓住。

## 5. `microCompact` 先给出一个非常强的正例：真正的 anti-drift verifier 会把“源真相”直接绑定到测试

`services/compact/microCompact.ts:31-36` 的注释非常关键：

`Drift is caught by a test asserting equality with the source-of-truth.`

这句话值钱的地方不在于它提到了 test，  
而在于它把四件事压成了一起：

1. 有一份 source-of-truth
2. 有一处派生实现
3. 作者预期两者未来可能漂移
4. 因此专门安排测试去抓漂移

这就是成熟 anti-drift verifier 的标准形状：

`source truth exists -> derived truth exists -> drift is expected as a risk -> verifier is made explicit`

cleanup 线当前最缺的恰恰就是这一层。  
现在我们看到的是：

1. metadata 信号存在
2. runtime 执行路径存在
3. 漂移风险也已经暴露
4. 但 verifier 仍未被同等级显式化

## 6. `switchSession` 再给出第二个正例：真正的 anti-drift verifier 有时不是 test，而是结构性原子约束

`bootstrap/state.ts:456-466` 写得更直接：

`sessionId` 与 `sessionProjectDir` `cannot drift out of sync`

而且它不是靠注释自我安慰，  
而是通过：

1. 没有分开的 setter
2. 原子 `switchSession(...)`

把这种 drift 在结构上直接封死。

这说明 anti-drift verifier 不一定总是独立测试文件。  
它也可以是一种：

`architectural anti-drift mechanism`

也就是：

`让某种分叉根本不再有表达机会。`

这对 cleanup 线特别有启发。  
因为今天 cleanup 线的问题不只是“没写测试”，  
而是：

`metadata、scheduler、executor、permission、resume 这些平面仍能各自变化，因此漂移在结构上仍有表达机会。`

## 7. `verifyAutoModeGateAccess` 再给出第三个正例：有些 anti-drift verifier 甚至是运行时主动复核，而不是等事故发生

`permissions/permissionSetup.ts:1078-1150` 的 `verifyAutoModeGateAccess()` 更进一步。

它做的不是被动等待症状，  
而是：

1. 读取 fresh dynamic config
2. 对照 cached availability 与 live gate state
3. 重新设置 circuit breaker / availability
4. 防止 stale cache 让 UI / runtime 继续说谎

`getNextPermissionMode.ts:7-17` 还专门写出：

`cached isAutoModeAvailable` 与 live `isAutoModeGateEnabled()` `can diverge`

于是代码真的去同时检查两者。

这说明成熟 verifier 的第三种形态是：

`live re-verification against possibly stale state`

相比之下，cleanup 线现在有什么？

1. 有 delayed housekeeping
2. 有 validation skip
3. 有 `CleanupResult`
4. 有 propagation gap

但还没有一处等价的：

`verifyCleanupPolicyAlignment()`  
`checkCleanupFamilyConformance()`  
或任何 live dual-read verifier

这就让 cleanup 线即使偶尔符合，  
也仍未进入同等级的 anti-drift world。

## 8. 与这些正例对照，cleanup 线当前最缺的不是又一个 executor，而是“谁来长期验证这些 executor 没再分叉”

`161` 已经证明 cleanup 线至少存在三种 gap：

1. temporal gap  
   `cleanupPeriodDays=0` 文案很强，但 execution 是延迟的
2. propagation gap  
   `plansDirectory` 被某些平面消费，却没被 `cleanupOldPlanFiles()` 消费
3. receipt gap  
   `CleanupResult` 存在，却没被汇总成正式 receipt

但这些 gap 目前仍主要是：

`研究者通过跨文件阅读发现的`

而不是：

`系统自己通过 verifier surface 暴露的`

这正是 `162` 的核心判断。  
cleanup 线现在并不是完全没有安全设计，  
而是：

`设计已经长得足够复杂，以至于真正缺的是 anti-drift verifier，而不是再补一个零散 helper。`

## 9. 为什么这层在技术上尤其重要：因为 cleanup 线天然横跨多个时间面和多个执行面

cleanup 线和很多普通 feature 不一样。  
它同时横跨：

1. settings plane
2. doc / tip plane
3. write suppression plane
4. background scheduling plane
5. destructive execution plane
6. path override plane
7. permission visibility plane
8. receipt / telemetry plane

只要一个 feature 横跨这么多平面，  
没有 anti-drift verifier 几乎就等于：

`把一致性寄托给后来者的记忆。`

而 Claude Code 这套安全设计恰恰最反对“寄托给记忆”。  
它在别处已经用 source-of-truth test、atomic switch 与 live verify 告诉我们：

`成熟系统不靠记忆维持真相，而靠显式 verifier 维持真相。`

因此 cleanup 线继续长出 anti-drift verifier，  
在技术上不是锦上添花，  
而是同一哲学在这个子系统里的迟到补课。

## 10. 技术先进性：Claude Code 真正先进的不是“从不漂移”，而是它已经在多个系统里承认漂移会发生，并为此发明 verifier

从技术角度看，Claude Code 的先进性不在于“代码永远不会漂移”。  
真正先进的地方恰恰是：

1. 它在 `microCompact` 里承认派生常量会漂移，所以安排 source-of-truth test
2. 它在 session state 里承认两个字段可能脱钩，所以做原子更新面
3. 它在 auto-mode gate 里承认 cache 与 live state 会分叉，所以做 async re-verification

这背后的设计启示非常强：

`真正成熟的系统，不是宣称自己不会漂移，而是把漂移视为正常风险，并为它发明显式 verifier。`

也正因如此，  
cleanup 线今天最需要的，  
不是再多写一篇“为什么这条 policy 合理”，  
而是把这些已知 drift risk 正式接入同等级的 verifier grammar。

## 11. 哲学本质：真正成熟的真相，不只要被写下、被执行，还要被反复校正

`160` 的哲学本质是：

`制度要能自述。`

`161` 的哲学本质是：

`制度要能自证。`

`162` 的哲学本质则更进一步：

`制度还要能自校。`

也就是说，  
成熟系统最终必须长出三种真相能力：

1. 说明自己相信什么
2. 说明自己此刻做了什么
3. 说明如果自己以后偏离了，会由谁先发现

只要第三层缺失，  
系统就仍会继续停留在一种危险的半成熟状态：

`它这次说的可能是真的，但没人能保证下次偏离时它不会继续若无其事。`

所以 `162` 的哲学要点不是增加形式主义，  
而是提醒一条更硬的原则：

`不能被持续校正的真相，最终仍会退回偶然正确。`

## 12. 苏格拉底式自诘：我的判断有没有再次越级

为了避免把“当前没看到 verifier”直接写成“repo 完全不关心 drift”，  
这里必须主动追问自己四个问题。

### 第一问

`我是不是把“没有 cleanup verifier”误写成了“没有任何 verifier 文化”？`

不能这样写。  
恰恰相反，本章最关键的证据就是：

`repo 在别处明明已经有 verifier 文化。`

所以 cleanup 线的缺口才更值得单独命名。

### 第二问

`我是不是把“未发现测试目录中的 cleanup 测试”偷换成了“绝对没有测试”？`

也不能这样写。  
更谨慎的说法应该是：

`在当前可见源码中，我看到了 microCompact 这类明确自述“drift is caught by a test”的正例，却没有看到 cleanup 线同等级的显式 verifier 说明。`

### 第三问

`如果某次 runtime receipt 已经补出来，还需要 anti-drift verifier 吗？`

仍然需要。  
因为 receipt 证明的是：

`this run`

verifier 证明的是：

`future runs will not silently drift`

这两者处理的时间维度不同。

### 第四问

`我真正该继续约束自己的是什么？`

是这句：

`不要把一次 runtime receipt 或一次正确运行，误写成长期 anti-drift proof。`

当前更稳妥的说法只能是：
repo 在别处已经明确展示 verifier culture，
cleanup 线也已经暴露出 temporal gap、propagation gap 与 receipt gap。

因此本章能成立的是：

`this run conform != future runs stay honest`

不能偷加的 stronger claim，
则是：

`cleanup 已经拥有正式、长期、自校正的 anti-drift verifier plane。`

## 13. 一条硬结论

这组源码真正说明的不是：

`Claude Code 当前只要偶尔表现出 cleanup runtime conform，就已经具备了长期可信的 cleanup verification。`

而是：

`Claude Code 在其他系统里已经明确发明了 anti-drift verifier 的多种形态，但 cleanup 线当前仍缺少同等级的显式 verifier；因此 artifact-family cleanup runtime-conformance signer 仍不能越级冒充 artifact-family cleanup anti-drift verifier signer。`

再压成最后一句：

`符合性说明这次没说谎；反漂移验证，才说明系统将来不容易继续说谎。`
