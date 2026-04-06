# 安全载体家族制度理由与元数据分层：为什么artifact-family cleanup rationale signer不能越级冒充artifact-family cleanup metadata signer

## 1. 为什么在 `159` 之后还必须继续写 `160`

`159-安全载体家族宪法与制度理由分层` 已经回答了：

`Claude Code 当前不只活在多宪法世界，还活在多理由世界。`

但如果继续往下追问，  
还会碰到下一层更隐蔽、也更工程化的错觉：

`只要系统已经有不同 family 的 cleanup rationale，就等于这些理由已经被正式做成了系统自己的显式元数据。`

Claude Code 当前源码仍然不能支持这句更强的话。

因为继续看 `task/diskOutput.ts`、`permissions/filesystem.ts`、`toolResultStorage.ts`、`sessionStorage.ts`、`plans.ts`、`sessionEnvironment.ts`、`fileHistory.ts`、`cleanup.ts` 与 `settings/types.ts` 会发现：

1. 不同 family 的理由确实已经存在
2. 但这些理由大多还散落在路径 helper、权限 helper、resume helper、settings schema、注释与 cleanup dispatcher 之间
3. 系统很少把它们集中表达成一个可传播、可校验、可防漂移的 family metadata object

这说明：

`artifact-family cleanup rationale signer`

和

`artifact-family cleanup metadata signer`

仍然不是一回事。

前者最多能说：

`我能解释为什么 task outputs、tool-results、plans、file-history、session-env 应该服从不同 cleanup law。`

后者才配说：

`这些理由已经被系统自己编码成可共享的 policy metadata，因此 storage、permissions、resume、cleanup 与 drift check 正在消费同一份 family truth。`

所以 `159` 之后必须继续补的一层就是：

`安全载体家族制度理由与元数据分层`

也就是：

`artifact-family cleanup rationale signer 最多只配解释制度理由；artifact-family cleanup metadata signer 才配把这些理由升级成系统内可复用、可传播、可防漂移的显式自描述。`

## 2. 先做一条谨慎声明：`artifact-family cleanup metadata signer` 仍是研究命名，不是源码现成类型

这里仍要先讲清楚：

`Claude Code 当前源码里并没有一个字面存在的类型叫 artifact-family cleanup metadata signer。`

这里的 `artifact-family cleanup metadata signer` 仍然只是研究命名。  
它不是在声称仓库里已经有一个 `ArtifactFamilyPolicy` 类却没人发现，  
而是在说：

1. 当前 family truth 已经被多处代码隐式表达
2. 这些 truth 包括 storage scope、reader scope、recovery duty、cleanup root、retention gate 与 drift boundary
3. 但系统并没有把这些 truth 明确收束为单一 metadata plane

所以 `160` 不是在虚构已有实现，  
而是在给一个更深的缺口命名：

`制度理由已经存在，但制度自描述仍未同等级存在。`

## 3. 最短结论

Claude Code 当前源码至少给出了六类“rationale signer 仍不等于 metadata signer”证据：

1. task outputs 的 family truth 主要活在 `diskOutput.ts` 的路径构造与注释里  
   `getTaskOutputDir()` 解释 session-scoped temp path，但不是统一 metadata object  
   `task/diskOutput.ts:33-55`
2. scratchpad 的 family truth 主要活在 `filesystem.ts` 的 path helper 与 read/write allow rule 里  
   `getScratchpadDir()`、`isScratchpadPath()` 与 current-session read/write rule 共同定义它  
   `permissions/filesystem.ts:381-423,1488-1506,1645-1684`
3. tool-results 与 transcripts 的 family truth 分散在 path helper、read rule 与 cleanup traversal 里  
   `TOOL_RESULTS_SUBDIR`、`getToolResultsDir()`、`getTranscriptPath()`、`cleanupOldSessionFiles()` 各自持有一部分  
   `toolResultStorage.ts:27,94-118`  
   `sessionStorage.ts:198-225`  
   `cleanup.ts:155-257`
4. plans 的 family truth 分散得最明显  
   `plansDirectory` settings、`getPlansDirectory()`、`isSessionPlanFile()`、`copyPlanForResume()` 与 `cleanupOldPlanFiles()` 各拿一段  
   `plans.ts:79-110,164-233`  
   `permissions/filesystem.ts:245-254,1645-1652`  
   `cleanup.ts:300-303`  
   `settings/types.ts:824-830`
5. file-history / session-env 也只有各自模块内的局部 truth，缺少共同的 family metadata grammar  
   `fileHistory.ts:728-741,951-957`  
   `sessionEnvironment.ts:15-30,60-134`  
   `cleanup.ts:305-387`
6. `cleanupOldMessageFilesInBackground()` 以硬编码方式串起各 family cleanup，而不是从统一 registry 读取 policy  
   `cleanup.ts:575-595`

因此这一章的最短结论是：

`rationale signer 最多能解释“为什么应当如此”；metadata signer 才能证明“系统已经把这个为什么保存成了自己会重复读取的同一份 truth”。`

再压成一句：

`有理由，不等于有自描述。`

## 4. 第一性原理：rationale 回答“为什么”，metadata 回答“这份为什么被系统存放在哪里”

从第一性原理看，  
rationale 与 metadata 处理的是两层不同的问题。

rationale 回答的是：

1. 这个 family 为什么存在
2. 它主要防的是什么风险
3. 它首先服务谁
4. 它为什么该活在 temp-dir、project tree 或 home-root
5. 它为什么该被这样删、这样保留、这样恢复

metadata 回答的则是：

1. 上面这些判断被系统保存在哪里
2. 哪些子系统读的是同一份 family truth
3. 存储、权限、恢复、cleanup 是否消费的是同一个描述对象
4. 一处策略变化能否自动传播到其他执行面
5. 哪些 drift check 可以由代码自己完成，而不是等研究者事后发现

如果缺少 metadata 层，  
系统就会制造五类危险幻觉：

1. explained-means-objectified illusion  
   只要人类研究者能解释，就误以为系统自己也保存了这份解释
2. helper-composition-means-policy illusion  
   只要若干 helper 拼起来能还原制度理由，就误以为那里已经等于 policy object
3. path-fact-means-metadata-fact illusion  
   只要路径 helper 存在，就误以为 family metadata 已经被正式声明
4. schema-field-means-full-governance illusion  
   只要某个 settings 字段存在，就误以为 executor、permission、resume 都已共用这份 truth
5. no-regression-so-far-means-no-drift illusion  
   只要目前还能工作，就误以为不会继续发生 rationale drift

所以从第一性原理看：

`rationale` 是制度说明；  
`metadata` 是制度说明被系统自己持久保存和重复消费的方式。

## 5. `cleanup.ts` 先暴露出最硬的元数据缺口：它更像硬编码 dispatcher，而不是 family policy registry

`cleanup.ts:25-29` 的 `getCutoffDate()` 已经先暴露出一个事实：

`cleanupPeriodDays` 被压成一个全局 cutoff，`

它并不直接携带 family-specific metadata。

继续看 `cleanup.ts:575-595` 的 `cleanupOldMessageFilesInBackground()`，  
会发现这个后台 cleanup 入口做的是：

1. 先跑 validation-guard
2. 然后依次硬编码调用  
   `cleanupOldMessageFiles()`  
   `cleanupOldSessionFiles()`  
   `cleanupOldPlanFiles()`  
   `cleanupOldFileHistoryBackups()`  
   `cleanupOldSessionEnvDirs()`  
   `cleanupOldDebugLogs()`  
   `cleanupOldImageCaches()`  
   `cleanupOldPastes()`  
   `cleanupStaleAgentWorktrees()`

这意味着 cleanup plane 当前最像：

`hand-written dispatch list`

而不是：

`iterate over artifact-family policy registry`

这条证据很关键。  
因为它说明：

1. family 差异已经存在
2. executor 也确实知道这些差异
3. 但这些差异尚未被统一提升为一个显式 registry / metadata plane

换句话说：

`系统知道要分别清理谁，`

但还没有把“为什么这样分别”“分别后的共同字段是什么”做成统一对象。

## 6. settings schema 进一步说明：当前公开的是个别字段，不是 family metadata grammar

`settings/types.ts:325-333` 只公开了：

`cleanupPeriodDays`

其描述是：

`Number of days to retain chat transcripts...`

而 `settings/types.ts:824-830` 则单独公开了：

`plansDirectory`

这两个字段连在一起看，会暴露一个更深的问题：

1. settings plane 公开了某些局部 policy knobs
2. 但它并没有形成统一的 artifact-family metadata grammar
3. 用户和系统都看不到诸如  
   `readerScope`  
   `recoveryDuty`  
   `cleanupRoot`  
   `retentionOwner`  
   `driftInvariant`
   这类 family 级字段

也就是说，  
当前 schema 能表达的是：

- 某个全局 retention number
- 某个特定 family 的路径 override

它不能直接表达的是：

`每个 artifact family 的制度理由及其传播约束。`

这也解释了为什么 `plansDirectory` 很容易先改写 storage world，  
而 cleanup executor 却没有自动跟上。  
不是因为谁不会写 if/else，  
而是因为 family metadata grammar 根本还没被正式对象化。

## 7. task outputs 与 scratchpad 说明：有 family truth，但 truth 主要躲在 helper 与注释里

`task/diskOutput.ts:33-55` 已经把 task outputs 的关键 truth 写得很清楚：

1. storage scope 是 `project temp dir / sessionId / tasks`
2. 主要风险是 concurrent sessions clobber
3. session ID 在 first call capture，避免 `/clear` 造成路径漂移

但这些 truth 的保存方式仍然是：

1. 注释
2. `getTaskOutputDir()` helper
3. 下游对该 helper 的信任

而不是一个形如：

`{ family: "task-outputs", primaryRisk: "live-noninterference", storageScope: "...", cleanupRoot: "...", recoveryDuty: "..."}`

的 metadata object。

scratchpad 也是一样。

`permissions/filesystem.ts:381-423,1488-1506,1645-1684` 一起说明：

1. `getScratchpadDir()` 定义 path
2. `isScratchpadPath()` 定义 path boundary
3. 写权限单独放行
4. 读权限单独放行

这说明 scratchpad family truth 当然存在，  
但它被拆成：

`path helper + boundary check + read rule + write rule`

而不是：

`single family descriptor consumed by all four places`

所以 task outputs / scratchpad 这组代码给出的最硬启示不是“它们没有制度理由”，  
而是：

`它们已经有制度理由，但系统保存这份理由的方式仍偏分散。`

## 8. tool-results 与 transcripts 说明：一旦 family 进入 persisted world，元数据缺口会进一步放大

`toolResultStorage.ts:27,94-118` 给出了：

1. `TOOL_RESULTS_SUBDIR`
2. `getToolResultsDir()`
3. `getToolResultPath()`

`sessionStorage.ts:198-225` 给出了：

1. `getProjectsDir()`
2. `getTranscriptPath()`
3. `getTranscriptPathForSession()`

`permissions/filesystem.ts:1645-1667` 又只在读路径层面单独放行 tool-results。

`cleanup.ts:155-257` 再负责真正的 project-root sweep。

这说明 persisted families 的 truth 现在被拆成至少四片：

1. path naming truth
2. readable-internal-path truth
3. retention executor truth
4. session/project bucket truth

如果存在显式 metadata plane，  
这些 truth 理论上应该能从同一 family descriptor 中被读取；  
但当前并不是这样。

于是 persisted families 就更容易出现一种工程问题：

`每个子系统都懂一点，但没有谁持有正式全貌。`

这既解释了为什么研究者还要跨多个文件拼图，  
也解释了为什么后续 drift 很难靠代码自动发现。

## 9. plans family 再次给出最强反例：一旦 metadata 不显式，rationale drift 就只能事后被发现

`plans.ts:79-110`、`permissions/filesystem.ts:245-254,1645-1652`、`plans.ts:164-233` 与 `cleanup.ts:300-303` 放在一起看，  
会得到一条非常强的结论：

1. plans 有默认 home-root path truth
2. 也有 project-root override truth
3. 也有 current-session readable truth
4. 也有 resume recoverable truth
5. 但 cleanup executor 仍只消费 default home-root truth

这正是 metadata 缺口最具体的表现。

如果系统已经有显式 family metadata，  
那么 `plansDirectory` 这类变化理论上应该传播给：

1. path resolver
2. permission rule
3. resume logic
4. cleanup executor
5. drift invariant checker

但现在并没有一份 central descriptor 来驱动这种传播。  
于是系统只能依赖开发者记忆、局部习惯和事后比对。

因此 plans family 把 `159` 的“理由漂移”继续推进成了 `160` 的“元数据缺口”：

`一旦制度理由没有被对象化，漂移就只能靠后来者重新阅读多个文件后才发现。`

## 10. file-history 与 session-env 说明：即便暂时没有明显漂移，也不等于已有显式 metadata plane

`fileHistory.ts:728-741,951-957` 给出了 backup path truth。

`sessionEnvironment.ts:15-30,60-134` 给出了 env-dir path truth、hook ordering truth 与 replay loading truth。

`cleanup.ts:305-387` 给出了它们的 retention executor truth。

这两类 family 目前看起来比 plans 更稳，  
因为还没有暴露出同等级的 customization drift。  
但“暂时更稳”和“已有 metadata signer”仍然不是一回事。

它们现在的状态更准确地说是：

1. rationale 相对一致
2. executor 也大体跟随 rationale
3. 但这些 truth 仍然散落在各自模块与 cleanup helper 中

所以它们证明的不是：

`Claude Code 已经拥有 family metadata plane`

而是：

`Claude Code 已经拥有足够多的 family truth，值得被提升到 metadata plane。`

## 11. 技术先进性：Claude Code 真正先进的不是已经有完美元数据，而是它已经长出足够真实的 family truth 值得被对象化

从技术上看，Claude Code 在这一层真正先进的地方，不是已经把 artifact-family policy 完全做成了声明式系统。  
相反，它更真实的先进性在于：

1. 它没有把所有 artifact 粗暴塞进同一 cleanup law
2. 它已经在多个子系统里长出相当稳定的 family truth
3. 这些 truth 不是拍脑袋命名，而是由 live interference、inspection continuity、planning autonomy、restore safety、environment replay 等真实职责逼出来的

这意味着它距离更成熟的一层只差：

`把已有的 family truth 从分散实现，升级成显式 metadata grammar。`

这给源码设计带来的技术启示非常直接：

1. 当系统已拥有稳定的 family truth 时，应尽快抽出 descriptor，而不是继续让 helper composition 充当 policy
2. family metadata 至少应包含  
   `storageScope`  
   `readerScope`  
   `recoveryDuty`  
   `cleanupRoot`  
   `retentionGate`  
   `configurablePathResolver`  
   `driftInvariant`
3. cleanup dispatcher 最终应从 registry 读 family policy，而不是维护硬编码调用链
4. settings schema 不该只暴露零散 knobs，而应逐渐拥有与 family descriptor 对齐的表达能力

## 12. 哲学本质：真正成熟的制度，不只要可解释，还要可自述

`159` 的哲学本质是：

`不同 family 有不同理由。`

`160` 的哲学本质则更进一步：

`不同理由如果不能被系统自己保存成自述，它们最终仍会退回到人类记忆。`

这意味着成熟系统的更高要求不再只是：

1. 有制度
2. 有制度理由

而是还必须有：

3. 制度自述

没有这第三层，  
系统的秩序就仍然只是：

`靠注释、路径习惯、helper 拼图与后来者经验维持的半显式世界。`

而只要世界仍停留在半显式，  
它就还会继续面对两类命运：

1. 好理由难以传播
2. 坏漂移难以及时自证

所以 `160` 的哲学要点不是鼓吹元数据崇拜，  
而是提醒一条更硬的原则：

`制度若不能被系统自己复述，制度终将回落为传统。`

## 13. 苏格拉底式自诘：我的判断有没有再次越级

为了避免把“缺少显式对象”偷换成“设计失败”，  
这里必须主动追问自己四个问题。

### 第一问

`我是不是把“没有 central registry”直接说成了“系统一定有 bug”？`

不能这样说。  
更谨慎的判断应该是：

`当前证据足以证明 metadata plane 仍然分散，但不足以单凭这一点断言系统已经错误；它更准确地说明的是扩展性、传播性与防漂移能力仍依赖实现纪律。`

### 第二问

`我是不是把研究者能拼出全貌，误写成系统完全不自知？`

也不能这样写。  
系统当然“部分自知”，因为各 helper 已经体现了稳定 truth。  
本章真正要说的是：

`系统的自知尚未被提升成统一自述。`

### 第三问

`如果分散 truth 也能工作，为什么还要追 metadata signer？`

因为能工作和能传播、能校验、能防漂移不是同一个层级。

分散 truth 最脆弱的地方在于：

`一处变化后，其他消费面不会自动被提醒。`

plans family 已经给出最好的例子。

### 第四问

`我真正该继续约束自己的是什么？`

是这句：

`不要把研究者事后能拼出来的 distributed truth，误写成系统已经拥有统一 metadata plane。`

当前更稳妥的说法只能是：
repo 已经有足够稳定的 family truth，
但这些 truth 仍主要散落在 helper、path、settings schema 与 dispatcher 之间。

因此本章能成立的，
是：

`rationale != metadata`

不能偷加的 stronger claim，
则是：

`系统已经能用统一 registry 自己复述整套 artifact-family policy。`

## 14. 一条硬结论

这组源码真正说明的不是：

`Claude Code 现在已经把所有 artifact family 的制度理由升级成了系统自己的显式 policy metadata。`

而是：

`Claude Code 已经拥有足够真实、足够稳定的 family truth，但这些 truth 仍主要散落在路径 helper、权限 helper、resume helper、settings schema、注释与 cleanup dispatcher 之间；因此 artifact-family cleanup rationale signer 仍不能越级冒充 artifact-family cleanup metadata signer。`

再压成最后一句：

`理由证明世界有秩序；元数据，才证明这套秩序能被系统自己反复守住。`
