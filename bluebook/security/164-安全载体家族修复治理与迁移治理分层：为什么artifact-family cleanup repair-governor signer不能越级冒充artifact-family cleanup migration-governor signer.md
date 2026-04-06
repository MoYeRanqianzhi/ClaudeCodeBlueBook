# 安全载体家族修复治理与迁移治理分层：为什么artifact-family cleanup repair-governor signer不能越级冒充artifact-family cleanup migration-governor signer

## 1. 为什么在 `163` 之后还必须继续写 `164`

`163-安全载体家族反漂移验证与修复治理分层` 已经回答了：

`cleanup 线即便以后长出 verifier，也还需要 repair governor 去决定到底修 metadata、修 scheduler、修 executor，还是降级承诺。`

但如果继续往下追问，  
还会碰到下一层更容易被误写成“修完就结束”的错觉：

`只要 repair governor 已经决定怎么修，它就等于自动拥有了把旧世界平滑迁到新世界的主权。`

Claude Code 当前源码仍然不能支持这种更强的说法。

因为继续看 `main.tsx` 中的 migration 链、`migrations/*` 下的具体迁移函数、`installedPluginsManager.ts` 的单文件迁移、`cacheUtils.ts` 的 orphan grace period，以及 `plans.ts` 的 resume / fork plan continuity 会发现：

1. repo 并不把“发现该修什么”直接偷写成“过渡该怎么走”
2. 某些修改会立刻改变新世界的规则
3. 但旧值、旧路径、旧缓存、旧会话资产怎样继续可读、多久作废、是否要重写、是否要保留 grace window，仍然是另一层治理

这说明：

`artifact-family cleanup repair-governor signer`

和

`artifact-family cleanup migration-governor signer`

仍然不是一回事。

前者最多能说：

`我们已经决定应该修哪一层。`

后者才配说：

`旧世界的 artifact、旧设置、旧承诺和旧 receipt 应怎样被带过渡、作废、保留兼容期，或者被重签发。`

所以 `163` 之后必须继续补的一层就是：

`安全载体家族修复治理与迁移治理分层`

也就是：

`artifact-family cleanup repair-governor signer 只能决定修什么；artifact-family cleanup migration-governor signer 才能决定旧世界如何在不制造新谎言的前提下被迁到新世界。`

## 2. 先做一条谨慎声明：`artifact-family cleanup migration-governor signer` 仍是研究命名，不是源码现成类型

这里同样要先讲清楚：

`Claude Code 当前源码里并没有一个字面存在的类型叫 artifact-family cleanup migration-governor signer。`

这里的 `artifact-family cleanup migration-governor signer` 仍然只是研究命名。  
它不是在声称 cleanup 线已经有一个 migration policy object 只是未导出，  
而是在说：

1. repo 在其他子系统里已经明确展示出 migration governance 的存在
2. migration governance 回答的是兼容期、旧值重写、旧路径保留、旧资产回收时机与用户通知
3. cleanup 线今天若要真正进入成熟世界，也迟早要回答这些问题

因此 `164` 不是在虚构已有实现，  
而是在给更深的一层缺口命名：

`修复决定做完了，不等于过渡策略已经被治理。`

## 3. 最短结论

Claude Code 当前源码至少给出了六类“repair-governor signer 仍不等于 migration-governor signer”证据：

1. `main.tsx:323-341` 明确维护一组启动迁移函数，说明 repo 知道“新规则落地”与“旧世界平滑过渡”是显式治理事项
2. `migrateSonnet1mToSonnet45.ts:1-45` 与 `migrateLegacyOpusToCurrent.ts:1-53` 说明模型修复不等于简单替换字符串；迁移层还要决定  
   只改 `userSettings` 还是保留 project/local/policy pin  
   是否 remap runtime 但不重写某些来源  
   是否保存 timestamp 供一次性通知
3. `migrateReplBridgeEnabledToRemoteControlAtStartup.ts:1-18` 说明旧 key 到新 key 的迁移还要决定  
   何时复制值、何时删除旧 key、何时保持幂等
4. `installedPluginsManager.ts:96-213` 的 `migrateToSinglePluginFile()` 说明修复插件元数据结构之后，还要治理  
   v2 文件重命名  
   v1→v2 in-place conversion  
   legacy cache cleanup
5. `cacheUtils.ts:20-99` 里的 `.orphaned_at` 与 `CLEANUP_AGE_MS = 7 days` 说明旧插件版本不是“新版本一来就立即消失”；迁移治理要决定 grace window 和 orphan cleanup 节奏
6. `plans.ts:150-248` 的 `copyPlanForResume()` / `copyPlanForFork()` 说明 plan artifact 的过渡也不是单纯 repair；还要决定  
   原 slug 是否复用  
   缺失文件如何从 snapshot / history 恢复  
   fork 时是继续共享还是复制并换新 slug

因此这一章的最短结论是：

`repair governor 最多能说“该修哪里”；migration governor 才能说“旧世界怎样有次序地退出，而不把兼容世界和新世界一起搞乱”。`

再压成一句：

`会修，不等于会迁。`

## 4. 第一性原理：repair governor 回答“修哪层”，migration governor 回答“旧世界如何不被粗暴抹平”

从第一性原理看，  
repair governance 与 migration governance 处理的是两个不同时间面的主权问题。

repair governor 回答的是：

1. 应修 metadata、runtime、scheduler、executor 还是 promise
2. 哪条路径现在不可信
3. 哪类 drift 必须立即止血
4. 哪种 stronger claim 应先撤回
5. 哪一层对当前 bug 负主责

migration governor 回答的则是：

1. 旧值是立刻重写，还是先 runtime remap
2. 哪些 source 允许被改写，哪些必须保持原样
3. 兼容窗口多长
4. 旧缓存、旧目录、旧版本何时清理
5. 是否需要 one-time notification、completion flag 或 grace period

如果把这两层压成一句“决定修复方案就行”，  
系统就会制造五类危险幻觉：

1. fix-means-cutover illusion  
   只要修法确定，就误以为可以立刻切到新世界
2. one-write-fits-all illusion  
   只要一个 source 被重写，就误以为所有 source 都应该被重写
3. no-grace-needed illusion  
   只要新规则更正确，就误以为旧世界不需要兼容窗口
4. migration-equals-rewrite illusion  
   只把 migration 理解成“改文件”，忽略 runtime remap、orphan retention、通知与幂等控制
5. artifact-world-is-stateless illusion  
   忽略旧 receipts、旧 path、旧 slug、旧 cache 仍在现实中继续活着

所以从第一性原理看：

`repair governor` 决定修复方向；  
`migration governor` 决定旧世界如何安全地让位。

## 5. 模型迁移先给出最强正例：真正成熟的系统不会把“更正模型”直接写成“粗暴覆盖所有旧值”

`main.tsx:323-341` 直接维护了一组 migration calls。  
这本身就说明：

`新规则进入系统，不等于旧设置自然消失。`

更具体地看：

`migrateSonnet1mToSonnet45.ts:1-45` 做了三件非常 migration-governor 的事：

1. 只改 `userSettings`，不碰 merged/project/local 世界
2. 对 in-memory override 也做过渡
3. 用 `sonnet1m45MigrationComplete` flag 保证一次性迁移

而 `migrateLegacyOpusToCurrent.ts:1-53` 则做了另一组决定：

1. 只迁 first-party users
2. 只改 `userSettings`
3. project/local/policy strings 仍保留，但 runtime 会继续 remap
4. 记录 migration timestamp 供 REPL 做 one-time notification

这些决定都不是“修复主权”本身能回答的。  
它们回答的是：

`哪些旧世界要被重写，哪些旧世界只在运行时兼容，哪些用户要被通知，哪些来源必须保持原样。`

这就是典型的 migration governance。

## 6. 配置键迁移再给出第二个正例：迁移治理还要决定何时复制旧键、何时删除旧键，以及何时保持幂等

`migrateReplBridgeEnabledToRemoteControlAtStartup.ts:1-18` 特别适合作为 cleanup 线的镜子。

它做的并不是：

`发现旧键不好 -> 立刻 everywhere break`

而是：

1. 只有旧键存在且新键未设置时才复制
2. 把旧值迁到新 key
3. 再删除旧 key
4. 保持 idempotent

同样，`migrateBypassPermissionsAcceptedToSettings.ts:1-34` 也说明：

1. 只有 globalConfig 里旧字段存在时才迁
2. 若 settings 里已接受新字段，则不重复覆盖
3. 迁完后才删旧 global key

这再次说明：

`repair governor` 只能说“这个字段设计不对”；  
`migration governor` 才能决定“新旧字段在过渡期怎样并存、覆盖与退场”。`

cleanup 线未来若修 `plansDirectory` propagation，  
同样会遇到这个问题：

1. 是否同时清 `~/.claude/plans` 与 project-root plans
2. 旧 home-root plan files 保留多久
3. 旧 cleanup semantics 是立即失效，还是 grace period 后失效

这些都属于 migration governance，而不是 repair choice 本身。

## 7. plugin 线给出第三个更强正例：真正成熟的 migration governor 会管理旧缓存世界的延迟退场，而不是只管新结构能不能工作

`installedPluginsManager.ts:96-213` 的 `migrateToSinglePluginFile()` 已经非常清楚地说明：

1. 如果 `installed_plugins_v2.json` 存在，重命名到主文件
2. 如果主文件仍是 v1，则 in-place 迁到 v2
3. 同时清理 legacy non-versioned cache directories

更关键的是 `cacheUtils.ts:20-99`：

1. 旧版本不会立即删掉
2. 会先被标成 `.orphaned_at`
3. `CLEANUP_AGE_MS = 7 days`
4. 只有超过 7 天才真正删

这里体现的就是最典型的 migration-governor 主权：

`旧世界何时退场，不由 repair 逻辑瞬间决定，而由兼容窗口治理来决定。`

对于 cleanup 线，这是极其强的技术启示。  
一旦未来要修 `plansDirectory` 或 transcript / receipt semantics，  
就一定会面对同样的问题：

`旧 artifact 是立即无效，还是进入 orphan / grace / dual-read 期。`

## 8. plans 自己也已经悄悄暴露出 migration 问题：resume / fork 不是修复逻辑，而是过渡逻辑

`plans.ts:150-248` 的 `copyPlanForResume()` / `copyPlanForFork()` 很关键。

它们做的不是 repair；  
而是：

1. resume 时复用原 slug
2. 若 plan file 缺失，则尝试从 file snapshot / message history 恢复
3. fork 时生成新 slug、复制原 plan 内容，避免 clobber

这说明 plans family 今天已经存在一条隐含但真实的 migration grammar：

1. old session plan 如何被 current session 接续
2. forked session 如何从旧世界拷贝出一个兼容但不冲突的新世界
3. 缺失实体文件时如何通过历史世界补回连续性

这再一次证明：

`artifact migration` 不是修复之后才会出现的后话，而是系统一旦承认旧 artifact 仍有价值，就必须主动治理的世界。`

## 9. 技术先进性：Claude Code 真正先进的不是“修复后立刻切断旧世界”，而是它在别处已经知道如何用幂等、范围限制、兼容 remap 与 grace window 管理过渡

从技术角度看，Claude Code 在这条线上真正先进的地方，不是它会写迁移脚本。  
更值钱的是它已经在多个子系统里承认：

1. 不是所有 source 都该被重写
2. 不是所有旧值都该立即失效
3. 有些过渡要靠 runtime remap
4. 有些过渡要靠 one-time notification
5. 有些过渡要靠 grace window 与 orphan cleanup

这背后的设计启示非常强：

`真正成熟的治理，不只会决定新规则是什么，还会决定旧世界怎样体面退出。`

cleanup 线未来若进入更强修复阶段，  
就不能只停在：

`谁配修`

而必须继续追问：

`修完以后旧世界怎样被带走，而不在过渡期制造新的谎言与误删。`

## 10. 哲学本质：真正成熟的治理，不只要会纠偏，还要会送旧世界离场

`163` 的哲学本质是：

`系统发现 drift 后，必须知道谁来负责纠偏。`

`164` 的哲学本质则更进一步：

`系统纠偏时，还必须知道谁来负责让旧世界离场，而不是把旧世界直接撕掉。`

也就是说，  
成熟系统最终必须长出五层能力：

1. 说出规则
2. 证明当前执行
3. 持续校正漂移
4. 分配修复主权
5. 分配迁移主权

只要第五层缺失，  
系统就仍会停留在一种危险的半治理状态：

`新世界也许更正确，但旧世界会以未被治理的残影继续制造副作用。`

所以 `164` 的哲学要点不是拖延修复，  
而是提醒一个更硬的原则：

`不会治理过渡的修复，往往只是把今天的问题换成明天的迁移事故。`

## 11. 苏格拉底式自诘：我的判断有没有再次越级

为了避免把“cleanup 线现在还没有 migration governor”直接写成“系统不会迁移”，  
这里必须主动追问自己四个问题。

### 第一问

`我是不是把模型迁移、插件迁移、plan continuity 直接等同于 cleanup 线本体？`

不能这样写。  
这些只是正对照，  
用于证明 repo 已经具备 migration governance culture，  
而 cleanup 线迟早也要回答同类问题。

### 第二问

`repair governor 和 migration governor 一定要分成不同模块吗？`

也不能这么绝对。  
它们可以由同一实现承载，  
但逻辑上回答的问题不同，因此不应被默认偷写成同一层。

### 第三问

`如果 repair 很小，是否真的还需要 migration governor？`

不总是需要重型迁移，  
但只要旧值、旧路径、旧承诺、旧缓存仍真实存在，  
就至少需要回答：

`它们现在怎么退场。`

这已经是 migration 治理问题。

### 第四问

`我真正该继续约束自己的是什么？`

是这句：

`不要把 migration object 确实有多个，误写成 repo 已经把多对象迁移主权制度化。`

当前更稳妥的说法只能是：
旧 path、旧 promise、旧 receipt semantics 确实可能分别进入迁移问题，
而 repair layer 并不能自动决定它们怎样退出旧世界、进入新世界。

因此本章能成立的是：

`repair != migration`

不能偷加的 stronger claim，
则是：

`cleanup 已经拥有正式、多对象、可复述的 migration governance map。`

## 12. 一条硬结论

这组源码真正说明的不是：

`Claude Code 只要决定怎么修 cleanup drift，就已经自动拥有了完整的过渡治理能力。`

而是：

`repo 在模型、配置键、插件元数据与 plan continuity 上已经明确展示了 migration governance 的存在；因此 artifact-family cleanup repair-governor signer 仍不能越级冒充 artifact-family cleanup migration-governor signer。`

再压成最后一句：

`修复负责改变新规则；迁移，才负责让旧规则有秩序地退场。`
