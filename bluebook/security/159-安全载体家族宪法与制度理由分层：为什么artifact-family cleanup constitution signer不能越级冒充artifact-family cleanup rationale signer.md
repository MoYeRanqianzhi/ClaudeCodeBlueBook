# 安全载体家族宪法与制度理由分层：为什么artifact-family cleanup constitution signer不能越级冒充artifact-family cleanup rationale signer

## 1. 为什么在 `158` 之后还必须继续写 `159`

`158-安全清理隔离与载体家族宪法分层` 已经回答了：

`Claude Code 当前不是一条统一 cleanup law，而是多种 artifact-family constitution 并存。`

但如果继续往下追问，  
还会碰到更隐蔽、也更危险的一层错觉：

`只要系统已经把不同 artifact family 放进不同 constitution，就等于这些 constitution 的理由也已经被清楚建模。`

Claude Code 当前源码并不能支持这种更强说法。

因为继续看 `diskOutput.ts`、`filesystem.ts`、`toolResultStorage.ts`、`sessionStorage.ts`、`plans.ts`、`sessionEnvironment.ts`、`fileHistory.ts` 与 `cleanup.ts` 会发现：

1. 有些 family 的 constitution 与 rationale 目前高度一致  
   例如 task outputs、scratchpad
2. 有些 family 的 constitution 更像功能妥协而不是充分解释  
   例如 tool-results、transcripts
3. 有些 family 甚至已经暴露出 storage rationale 与 cleanup rationale 的漂移  
   例如 plans

这说明：

`artifact-family cleanup constitution signer`

和

`artifact-family cleanup rationale signer`

仍然不是一回事。

前者最多能说：

`这些家族现在事实上活在不同 cleanup constitution 里。`

后者才配回答：

`为什么这些家族应该活在不同 constitution 里，以及当前实现是否仍然忠于这个理由。`

所以 `158` 之后必须继续补的一层就是：

`安全载体家族宪法与制度理由分层`

也就是：

`artifact-family cleanup constitution signer 只能描述现状分宪；artifact-family cleanup rationale signer 才能解释这些宪法为何成立、何时失真，以及哪些地方已经出现制度理由漂移。`

## 2. 先做一条谨慎声明：`artifact-family cleanup rationale signer` 仍是研究命名，不是源码现成类型

和 `147-158` 一样，  
这里也要先讲清楚：

`Claude Code 当前源码里并没有一个字面存在的类型叫 artifact-family cleanup rationale signer。`

这里的 `artifact-family cleanup rationale signer` 仍然只是研究命名。  
它不是在声称仓库里已经存在一个专门的 rationale object，  
而是在说：

1. 当前不同 artifact family 已经明显对应不同 storage scope、不同 reader scope、不同 cleanup root
2. 这些差异背后必然隐含对风险对象、恢复职责、宿主可见性与产品地位的判断
3. 但源码把这些判断显式写成统一制度说明的程度并不一致

所以 `159` 不是在虚构已有机制，  
而是在给另一种真实缺口命名：

`现状分层已经出现，但制度理由并未同等显式。`

## 3. 最短结论

Claude Code 当前源码至少给出了五类“constitution signer 仍不等于 rationale signer”证据：

1. task outputs 的 constitution 与 rationale 相对一致  
   `diskOutput.ts:33-55` 明确把 sessionId 下沉到 `getProjectTempDir()/sessionId/tasks`，并把避免 concurrent sessions clobber 写进注释
2. scratchpad 也呈现出强 rationale 一致性  
   `filesystem.ts:381-423,1499-1506,1645-1652,1676-1684` 把 scratchpad 固定为 current-session path，并分别给出 owner-only dir 与 current-session read/write rule
3. tool-results / transcripts 展示的是另一种 rationale  
   它们分别服务于 persisted output inspection 与 transcript continuity，所以仍活在 `projects/<project>` sweep world  
   `toolResultStorage.ts:94-118`  
   `sessionStorage.ts:198-215`  
   `cleanup.ts:155-257`
4. plans family 暴露出最典型的 rationale drift  
   `plans.ts:79-110` 允许 `plansDirectory` 相对项目根自定义，但 `cleanup.ts:300-303` 的 `cleanupOldPlanFiles()` 仍只扫 `~/.claude/plans`；同一 family 的存储理由与清理理由没有完全对齐
5. file-history / session-env 显示另一种更偏恢复与重放的 rationale  
   `fileHistory.ts:951-957`、`sessionEnvironment.ts:15-30`、`cleanup.ts:305-387` 都指向 home-root per-session retention，而不是 project sweep

因此这一章的最短结论是：

`constitution signer 最多能说“不同家族现在确实被不同规则清理”；rationale signer 才能说“为什么应该这样，以及当前实现是否仍然忠于这个为什么”。`

再压成一句：

`制度存在，不等于制度理由已经被诚实保存。`

## 4. 第一性原理：cleanup constitution 回答“怎么删”，cleanup rationale 回答“为什么配这样删”

从第一性原理看，  
cleanup constitution 与 cleanup rationale 处理的是不同层次的问题。

cleanup constitution 回答的是：

1. 存在哪里
2. 由谁读
3. 由谁删
4. 走哪条 cleanup root
5. 当前 preflight gate 是什么

cleanup rationale 回答的则是：

1. 这个 family 的主要风险对象是什么
2. 它首先服务 live execution、跨 turn inspection、恢复续作，还是宿主审计
3. 它是否应该跨 session 可见
4. 它是否应该随项目走，还是随用户 home 级 retention 走
5. 为什么当前删除规则不会破坏它的主要职责

如果把两层压成同一句“系统已经做了区分”，  
就会制造五类危险幻觉：

1. differentiated-path-means-differentiated-reason illusion  
   只要路径不同，就误以为制度理由已经被充分解释
2. session-bucket-means-session-rationale illusion  
   只要路径里看见 sessionId，就误以为它本质上服务 live-session isolation
3. home-root-means-mature-policy illusion  
   只要落在 `~/.claude/*`，就误以为 retention rationale 比 project-root 更成熟
4. resumable-means-auditable illusion  
   只要某个 family 有恢复用途，就误以为它的 cleanup law 必然同时兼顾审计与宿主可见性
5. configurable-path-means-configurable-cleanup illusion  
   只要存储路径可配置，就误以为 cleanup executor 也同步理解了这项配置

所以从第一性原理看：

`constitution` 负责对象分布与删除语法；  
`rationale` 负责对象存在的正当性与删除的哲学边界。

## 5. task outputs 与 scratchpad 说明：当主要风险是 live interference 时，rationale 会强推 session-scoped temp constitution

`diskOutput.ts:33-55` 很关键。  
它不仅把 task outputs 定到：

`getProjectTempDir()/sessionId/tasks`

还把理由直接写出来：

`concurrent sessions in the same project don't clobber each other's output files`

这说明 task outputs family 的主要风险对象不是长程审计，  
而是：

1. 正在运行的 live process
2. 当前 session 对输出路径的可达性
3. 同项目并发 session 的 clobber / ENOENT side effect

`filesystem.ts:381-423,1499-1506,1645-1652,1676-1684` 对 scratchpad 也是类似逻辑：

1. path 是 `getProjectTempDir()/sessionId/scratchpad`
2. `ensureScratchpadDir()` 使用 owner-only dir
3. `isScratchpadPath()` 只承认当前 session
4. read/write 都只给当前 session path 绿灯

这两个 family 共同说明了一条很硬的原则：

`当一个 artifact family 的第一职责是服务当前 live execution，而不是跨 session 恢复或宿主审计时，最合理的 rationale 通常会把它压向 session-scoped temp constitution。`

换句话说，  
这里的 constitution 不是随便长出来的路径风格，  
而是对主要风险对象的直接回应。

## 6. tool-results 与 transcripts 说明：当主要职责转向可回看、可检查、可续接时，rationale 会把 family 留在 project-session sweep 世界

`toolResultStorage.ts:94-118` 把 tool-results 放到：

`projectDir/sessionId/tool-results`

`sessionStorage.ts:198-215` 把 transcripts/casts 放到：

- `projectDir/<sessionId>.jsonl`
- `projectDir/<sessionId>.cast`

`cleanup.ts:155-257` 则按项目目录 sweep：

1. 先清 project top-level transcript/cast
2. 再进 sessionDir 清 tool-results
3. gate 主要依赖 mtime

如果只看 constitution，  
我们只能说：

`这是 project-session sweep constitution。`

但如果往 rationale 层看，  
更准确的说法是：

1. tool-results 的主要职责不是只给 live process 用一次就丢  
   它还承担 persisted large output inspection
2. transcripts/casts 的主要职责也不是临时中转  
   它们承担 session continuity、history replay、debug trace 等职责
3. 一旦对象开始承载“后续再读”的产品价值，  
   存储就更可能围绕 project/session tree 组织，而不是纯 temp-dir locality

也就是说，  
它们的 constitution 背后其实对应另一条理由：

`这些 family 的首要价值不是最小生存时间，而是受限持久化后的可追索性。`

这恰好解释了为什么它们没有跟 task outputs/scratchpad 一起全部搬进同一 temp constitution。

## 7. plans family 暴露出真正更深的难题：不是 constitution 不存在，而是 rationale 已经开始漂移

`plans.ts:79-110` 非常关键。  
它告诉我们：

1. plan files 默认落在 `~/.claude/plans`
2. 允许通过 `plansDirectory` 把 plans 定到相对项目根的位置
3. `filesystem.ts:245-254,1645-1652` 又只为当前 session 的 plan file 给出明确 read rule
4. `plans.ts:164-233` 还把 resume recovery 直接和 plan file 的恢复绑定

这些证据组合起来，  
可以看见 plan family 的 rationale 至少有三股力量同时存在：

1. planning subsystem 是用户可感知、需要独立保留的产品对象  
   所以默认被抬出 `projects/<project>`，放到 `~/.claude/plans`
2. 当前 session 仍然要把它当作“本 session 的 active plan artifact”来读取  
   所以权限规则围绕 `isSessionPlanFile()` 建模
3. 用户又可能希望把它压回项目根，与项目协作上下文放在一起  
   所以 settings 允许 `plansDirectory`

问题在于：

`cleanup.ts:300-303` 的 `cleanupOldPlanFiles()` 仍然硬编码 `join(getClaudeConfigHomeDir(), 'plans')`

这意味着：

`plan family 的 storage rationale 已经允许 project-root customization，但 cleanup rationale 还停留在 default home-root world。`

这里真正暴露出的就不是“哪条 constitution 更好”，  
而是：

`同一 family 的制度理由正在发生分叉，而 executor 还没有完全跟上。`

因此 plans family 是 `159` 最值钱的技术证据，  
因为它第一次把问题从“多宪法并存”推进到：

`多宪法并存之外，还要继续追问理由是否一致、解释是否诚实、执行是否跟随理由迁移。`

## 8. file-history 与 session-env 说明：当 family 的首要职责是恢复与重放时，rationale 会把它们推向 home-root per-session retention

`fileHistory.ts:951-957` 把 backups 放到：

`~/.claude/file-history/<sessionId>/`

`sessionEnvironment.ts:15-30` 把 hook 生成的 env scripts 放到：

`~/.claude/session-env/<sessionId>/`

`cleanup.ts:305-387` 则对这两个 family 都采用：

1. 以 home-root 为根
2. 以 session dir 为 bucket
3. 以 dir mtime 为 retention gate
4. 过期后递归删除整个 session dir

这说明这两个 family 的 rationale 不是：

`让项目目录内的人持续回看`

而是：

`让某个 session 的恢复、回滚、环境重放资产独立存在，并在过期后整体收束`

这和 tool-results / transcripts 仍然不同。  
后者主要是项目树里的 evidence / continuity artifacts；  
前者更像 home-root 下的 restore / replay kits。

因此这里又能看出一条第一性原则：

`如果 artifact 的第一价值在于恢复某次 session 的内部执行条件，而不在于成为项目目录中的长期可见对象，那么它更可能服从 home-root per-session retention rationale。`

## 9. 技术先进性：Claude Code 真正先进的不是“所有 family 都统一”，而是把不同安全问题拆给不同 family 处理

从技术角度看，Claude Code 在这条线上真正先进的地方，不是已经做到了完美统一，  
而是它没有把所有 artifact 都粗暴压进一条删除流水线。

它已经展示出至少四种不同的风险治理倾向：

1. live noninterference  
   task outputs、scratchpad
2. persisted inspection / continuity  
   tool-results、transcripts
3. planning subsystem autonomy  
   plans
4. restore / replay kits  
   file-history、session-env

这种设计的先进性在于：

`安全不是“删得越快越好”，而是“让每个 artifact family 的存活时间、读者范围、恢复价值与删除方式和它承担的制度职责匹配”。`

也因此，Claude Code 的多重安全检术并不只是权限检查或 startup cleanup 本身，  
而是更深一层的 family-scoped governance：

1. path scoping
2. reader scoping
3. recovery coupling
4. cleanup root specialization
5. retention executor specialization

这给源码设计带来的技术启示非常直接：

1. 不要先定义统一 cleanup pipeline，再强迫所有 artifact 塞进去  
   应先定义 artifact family 的 primary duty
2. 不要只在 storage 层做 family 区分  
   permission、resume、retention、cleanup 也必须跟着 family 化
3. 不要把“历史上恰好放在这里”误写成“制度上就应该放在这里”  
   路径事实和制度理由必须分开说明
4. 任何允许自定义存储位置的 family，都必须同步校验 cleanup executor 是否也理解这个新理由  
   否则就会像 plans 一样出现 rationale drift

## 10. 哲学本质：真正成熟的安全系统，不只区分对象，还区分对象存在的理由

`158` 的哲学本质是：

`世界不是同宪的。`

`159` 的哲学本质则更进一步：

`世界也不是同理的。`

也就是说，  
成熟系统的难点不只是承认对象不同，  
而是承认：

1. 不同对象承担不同的存在目的
2. 不同存在目的要求不同的删除正当性
3. 不同删除正当性又必须被执行器诚实继承

如果缺少这一层，  
系统就会退化成：

`路径上看起来不同，但制度上没人能解释为什么不同。`

而一旦出现这种退化，  
cleanup 就很容易从治理问题退化成惯例问题，  
再从惯例问题退化成历史包袱。

所以 `159` 的哲学要点不是鼓吹复杂，  
而是提醒一条更硬的原则：

`没有被解释过的清理规则，最终只是偶然幸存的历史形状。`

## 11. 苏格拉底式自诘：我的判断有没有越级

为了避免把研究判断写成过强断言，  
这里必须主动追问自己四个问题。

### 第一问

`我是不是把“路径不同”直接偷换成了“制度理由不同”？`

不能这样偷换。  
所以本章并没有说“路径一不同，理由就必然不同”；  
本章真正的论点是：

`当路径、权限、恢复耦合与 cleanup executor 一起呈现稳定差异时，我们才有充分理由推断它们背后至少存在不同的 rationale pressure。`

### 第二问

`我是不是把 plans 的实现不一致直接上升成了设计失败？`

也不能这样写。  
更谨慎的说法应该是：

`plans family 已经暴露出 storage rationale 与 cleanup rationale 可能漂移，但仅凭当前证据，还不能断言这是有意设计失误，只能说 executor 尚未展示对 customization 的同等级制度理解。`

### 第三问

`如果多宪法并存是先进性，那为什么还要批评 rationale drift？`

因为 plural constitutions 与 rationale drift 不是一回事。

前者是：

`不同家族因不同职责而拥有不同 law`

后者是：

`同一家族的 law 已经变化，但解释与执行没有一起变化`

前者是成熟，  
后者才是风险。

### 第四问

`这章最值得进一步逼问自己的地方是什么？`

是这句：

`family-scoped rationale 是否应该被做成显式 metadata，而不是继续藏在路径、注释、权限规则与 cleanup helper 的组合里？`

如果答案是应该，  
那么 Claude Code 下一步真正需要的，  
就不只是再加一个 cleanup helper，  
而是把 family duty、reader scope、recovery duty 与 cleanup executor 的对应关系正式对象化。

## 12. 一条硬结论

这组源码真正说明的不是：

`Claude Code 现在已经完美解释了为什么每个 artifact family 要活在各自的 cleanup constitution 里。`

而是：

`Claude Code 已经进入 artifact-family-specific cleanup world，但只有一部分 family 的 constitution 与 rationale 仍然紧密对齐；另一些 family，尤其 plans，已经开始暴露制度理由漂移。`

因此：

`artifact-family cleanup constitution signer 仍不能越级冒充 artifact-family cleanup rationale signer。`

再压成最后一句：

`分宪只证明世界已经分层；分理由，才证明这套分层仍然诚实。`
