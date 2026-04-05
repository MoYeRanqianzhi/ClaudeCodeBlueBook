# 安全载体家族迁移治理与退役治理分层：为什么artifact-family cleanup migration-governor signer不能越级冒充artifact-family cleanup sunset-governor signer

## 1. 为什么在 `164` 之后还必须继续写 `165`

`164-安全载体家族修复治理与迁移治理分层` 已经回答了：

`cleanup 线即便以后知道旧世界该怎么过渡，也还需要一层 migration governor 去决定兼容窗口、过渡写法、旧值保留与新值接管。`

但如果继续往下追问，  
还会碰到另一层更容易被偷写成“迁完就算退役”的错觉：

`只要 migration governor 已经安排了新旧世界如何并存，它就自动拥有了宣布旧世界正式退场的主权。`

Claude Code 当前源码同样不能支持这种更强说法。

因为继续看：

1. `src/utils/model/deprecation.ts` 里的 provider-specific retirement dates
2. `src/hooks/notifs/useDeprecationWarningNotification.tsx` 与 `src/main.tsx:2872-2892` 的 deprecation warning surface
3. `src/hooks/notifs/useModelMigrationNotifications.tsx` 的 one-time migration notifications
4. `src/migrations/migrateLegacyOpusToCurrent.ts` 与 `src/utils/model/model.ts:isLegacyModelRemapEnabled()`
5. `src/utils/plugins/cacheUtils.ts` 的 `.orphaned_at` / `CLEANUP_AGE_MS = 7 days`
6. `src/utils/plugins/orphanedPluginFilter.ts` 与 `src/main.tsx:2546-2568` 的 orphan exclusion warmup

会发现 repo 已经清楚展示出：

1. `migration governance` 负责治理新旧世界如何并存、怎样重写、怎样兼容
2. `sunset governance` 负责治理兼容期何时结束、旧世界何时不再被视为正式 truth、旧 artifact 何时不再应被继续引用

也就是说：

`artifact-family cleanup migration-governor signer`

和

`artifact-family cleanup sunset-governor signer`

仍然不是一回事。

前者最多能说：

`旧世界先怎样被带过渡。`

后者才配说：

`过渡什么时候结束，旧世界从哪一天、哪一个 runtime、哪一个 visibility surface 起正式不再有效。`

所以 `164` 之后必须继续补的一层就是：

`安全载体家族迁移治理与退役治理分层`

也就是：

`migration governor 负责管理 coexistence；sunset governor 才负责宣布 coexistence 结束。`

## 2. 先做一条谨慎声明：`artifact-family cleanup sunset-governor signer` 仍是研究命名，不是源码现成类型

这里同样要先讲清楚：

`Claude Code 当前源码里并没有一个字面存在的类型叫 artifact-family cleanup sunset-governor signer。`

这里的 `artifact-family cleanup sunset-governor signer` 仍是研究命名。  
它不是在声称 cleanup 线已经有一个未公开的 retirement manager，  
而是在说：

1. repo 在 model 与 plugin 线已经展示出正式的 sunset grammar
2. sunset grammar 回答的是 retirement date、grace window 截止、旧世界 visibility 何时被切断
3. cleanup 线如果未来真要把 migration 做完整，也迟早要回答这些“何时正式结束”的问题

因此 `165` 不是在虚构已有实现，  
而是在为另一层缺口命名：

`会迁，不等于会宣告旧世界退役。`

## 3. 最短结论

Claude Code 当前源码至少给出了六类“migration-governor signer 仍不等于 sunset-governor signer”证据：

1. `deprecation.ts:29-100` 已经为 deprecated models 维护 provider-specific retirement dates，说明 repo 区分  
   `已经有迁移路径`  
   和  
   `旧模型在哪一天正式退役`
2. `useModelMigrationNotifications.tsx:7-33` 只负责一次性宣布  
   `模型刚刚被迁到新默认值`
   
   但 `useDeprecationWarningNotification.tsx:6-31` 与 `main.tsx:2872-2892` 负责持续提示  
   `旧模型即将在某日退役`
   
   这说明 migration notice 与 sunset notice 本来就是两张时钟
3. `migrateLegacyOpusToCurrent.ts:12-53` 即便已把 `userSettings` 迁到 `opus`，  
   `model.ts:552-554` 仍保留 `CLAUDE_CODE_DISABLE_LEGACY_MODEL_REMAP` opt-out 语义；  
   这表明 migration 已发生，但旧显式字符串在 runtime 层仍暂时活着，sunset 尚未完成
4. `cacheUtils.ts:23-24, 74-171` 说明 orphan plugin version 先进入 grace world，再在 7 天后删除；  
   这不是 migration 本身，而是 sunset deadline
5. `orphanedPluginFilter.ts:1-79` 与 `main.tsx:2546-2568` 说明旧 plugin version 在 grace 期内虽然仍在磁盘上，却已被 grep/glob exclusion 从当前 session 的可见世界里切出；  
   这是一种 visibility sunset，而不只是 file migration
6. `installedPluginsManager.ts:59-180` 的 `migrationCompleted`、`resetAutoModeOptInForDefaultOffer.ts:24-47` 的 one-shot completion flag 说明  
   “迁移已经跑过”  
   也不等于  
   “旧世界已经正式退役”

因此这一章的最短结论是：

`migration governor 最多能说旧世界怎样过渡；sunset governor 才能说旧世界何时停止作为正式世界继续存在。`

再压成一句：

`会过渡，不等于会退役。`

## 4. 第一性原理：migration governance 回答“如何并存”，sunset governance 回答“何时终止并存”

从第一性原理看，  
迁移治理与退役治理处理的是两个不同时间面的主权问题。

migration governor 回答的是：

1. 旧值是 rewrite、remap，还是 dual-read
2. 哪些 source 可以改写，哪些必须保持原样
3. 兼容期间如何提示用户
4. 哪些旧 artifact 要进入 grace window
5. 怎样保持幂等与 continuity

sunset governor 回答的则是：

1. 兼容窗口在哪个日期、哪次启动或哪类版本后结束
2. 旧值何时不再被 runtime 接受
3. 旧 artifact 何时不再被搜索、引用或恢复
4. 旧 warning 何时从 “建议切换” 进入 “正式不可再用”
5. 双世界共存何时必须切成单世界真相

如果把这两层压成一句“迁移策略已经存在就够了”，  
系统就会制造五类危险幻觉：

1. coexistence-means-forever illusion  
   只要兼容窗口已经存在，就误以为它可以无限拖延
2. completion-means-sunset illusion  
   只要迁移脚本跑过一次，就误以为旧世界已经正式退役
3. warning-means-governance illusion  
   只要有提醒语，就误以为退役时点已经被治理
4. data-still-on-disk-means-still-valid illusion  
   只要旧 artifact 还在磁盘上，就误以为它仍应被当前世界继续消费
5. migration-covers-hard-close illusion  
   把“新旧怎么并存”误当成“旧世界何时不再被允许存在”

所以从第一性原理看：

`migration governor` 决定怎样带着旧世界前进；  
`sunset governor` 决定何时不再继续背着它前进。

## 5. 模型线给出最强正例：迁移通知与退役通知是两种不同制度

`src/hooks/notifs/useModelMigrationNotifications.tsx:7-33` 非常清楚。  
它只在 migration timestamp 刚写入 config、也就是“这次启动刚发生迁移”时弹一次通知。

它回答的是：

`你刚刚被带到了新模型。`

但 `src/utils/model/deprecation.ts:29-100` 与 `src/hooks/notifs/useDeprecationWarningNotification.tsx:6-31` 回答的是另一件事：

`某个旧模型将在哪个 provider、哪个具体日期上被 retired。`

更重要的是，  
`src/main.tsx:2872-2892` 还会把 deprecation warning 加入 initial notification queue，  
说明退役提示不是迁移脚本的副作用，  
而是单独进入 runtime UI surface 的正式控制面。

这意味着模型线已经清楚地拆开了两张时钟：

1. migration clock  
   什么时候把用户带到新默认值
2. sunset clock  
   什么时候旧模型在 provider 侧正式退役

如果这两层是同一主权，  
就不需要同时存在 migration timestamp 和 retirement date。  
源码之所以两者并存，  
恰恰说明：

`带过渡` 和 `宣布退役` 是两件事。

## 6. `legacy opus` 更进一步证明：migration 已完成，旧世界也可能仍以兼容 remap 的形式继续活着

`migrateLegacyOpusToCurrent.ts:12-53` 做了三件 migration-governor 的事：

1. 只改 `userSettings`
2. 记录 `legacyOpusMigrationTimestamp`
3. 让 REPL 产生一次性 migration notification

但它并没有宣布旧字符串立刻失效。

相反，  
`model.ts:552-554` 的 `isLegacyModelRemapEnabled()` 仍允许 runtime remap 继续存在，  
甚至给出 `CLAUDE_CODE_DISABLE_LEGACY_MODEL_REMAP=1` 这样的 opt-out 开关。

这说明：

1. migration 已经发生
2. 旧世界仍被兼容
3. sunset 还没有被彻底 hard-close

这组代码非常适合拿来照 cleanup 线。

cleanup 线未来就算补出 plan path migration、receipt migration 或 promise migration，  
也仍然要继续回答：

1. 旧 home-root plan path 还能活多久
2. 旧 cleanup promise 还能被引用多久
3. 旧 receipt semantics 何时不再可被当成当前 truth

这些都已经不是 migration 本身，  
而是 sunset governance。

## 7. plugin 线给出第二组强正例：grace window 不是迁移附带品，而是退役制度本身

`cacheUtils.ts:23-24` 直接把 `CLEANUP_AGE_MS` 写成 `7 days`。  
再看 `cleanupOrphanedPluginVersionsInBackground():74-171`：

1. 旧版本先被标记 `.orphaned_at`
2. 重装版本会移除 stale marker
3. 超过 7 天才真正删除旧版本

这已经不再只是 “迁到新版本”。

它回答的是：

`旧版本什么时候只算兼容残影，什么时候连残影也不再允许继续留着。`

更进一步，  
`orphanedPluginFilter.ts:1-79` 与 `main.tsx:2546-2568` 还展示了另一种更细的 sunset grammar：

1. orphan GC 先调整磁盘状态
2. 然后 warm Grep/Glob exclusion cache
3. exclusion list 在 session 内冻结，除非 `/reload-plugins`

这意味着旧 plugin version 即便还在磁盘上，  
也可能已经先从“当前会话可见世界”中退役。

所以 plugin 线至少存在两层 sunset：

1. visibility sunset  
   先不再暴露给当前检索世界
2. storage sunset  
   grace window 到期后再物理删除

这种拆法非常先进。  
它没有把“文件仍存在”误写成“当前仍应被继续消费”，  
也没有把“准备删除”误写成“必须立刻粗暴删除”。

## 8. completion flag 再证明：迁移完成标记不等于旧世界已经被正式关停

`installedPluginsManager.ts:59-180` 的 `migrationCompleted`，  
以及 `resetAutoModeOptInForDefaultOffer.ts:24-47` 的 `hasResetAutoModeOptInForDefaultOffer`，  
都说明 repo 很擅长表达：

`这个 migration 不要再重复跑。`

但“不要再重复跑”回答的是：

`migration execution lifecycle`

不是：

`old-world sunset lifecycle`

如果把 completion flag 误认成 sunset authority，  
就会犯一个常见错误：

`以为脚本不再重跑，就等于旧世界已被正式关闭。`

源码给出的真实答案正相反：

1. migration completion 只保证某次 transition 已经执行或无需再执行
2. sunset governance 还要额外决定旧世界何时不再可见、可读、可引用、可恢复

这也是 cleanup 线未来特别危险的点。  
即便某个 cleanup migration 一次性跑完，  
也仍然不自动回答：

`旧 artifact 现在是否仍可被当前系统当真。`

## 9. cleanup 线当前最核心的缺口：即便 future migration governor 出现，也仍没有谁被正式授权宣布旧 cleanup 世界退役

把这些正对照拉回 cleanup 线，  
问题就变得非常具体。

今天即便假设 cleanup 线未来补出了 migration governor，  
它最多也只是开始回答：

1. `getPlansDirectory()` 与 `cleanupOldPlanFiles()` 的旧世界如何并存
2. 旧 startup delete 语言如何被新语义接管
3. 旧 cleanup receipt semantics 是否要重签、映射或降级

但它仍没有正式回答：

1. 旧 home-root plans 从哪一版、哪一时点起不再算正式 plan world
2. 旧 `cleanupPeriodDays=0` 承诺从哪一层起不再允许被继续理解成 startup delete
3. 旧 receipt / promise / path 世界何时从 dual-world 切成 hard close
4. 旧 artifact 何时应从 visibility surface 先退役，再从 storage 层真正清除

也就是说，  
cleanup 线当前真正缺的不只是 migration grammar，  
还缺一层更硬的主权：

`谁配宣布兼容期结束。`

而 repo 在 model/plugin 线已经证明：

`这层主权本来就应该存在。`

## 10. 技术先进性：Claude Code 真正先进的地方，是它在多个子系统里把“过渡”与“退役”拆成两张时钟

从技术角度看，Claude Code 在这条线上的先进性，  
不只是它写了迁移脚本，  
而是它在多个子系统里都承认：

1. migration 与 sunset 不是同一时刻
2. notification 与 retirement date 不是同一件事
3. file still exists 与 still valid 不是同一判断
4. grace window 与 hard close 不是同一动作
5. execution-complete 与 old-world-retired 不是同一状态

这背后的设计启示非常强：

`真正成熟的系统，不只要知道怎样让旧世界跟着新世界走一段路，还要知道何时必须请旧世界下车。`

因此对 cleanup 线最关键的技术启示不是：

`也给它补一个 migration 脚本。`

而是：

`必须同时补 migration clock 和 sunset clock。`

否则系统就会永远停在一种危险的半治理状态：

`大家都知道旧世界已经不是首选，但没有谁正式宣布它从什么时候开始不再算数。`

## 11. 苏格拉底式自诘：我的判断有没有再次越级

为了避免把“repo 在别处已经有 sunset grammar”直接写成“cleanup 线只差照抄即可”，  
这里必须主动追问自己四个问题。

### 第一问

`我是不是把 deprecation warning 直接等同于 sunset governor 本身？`

不能这样写。  
warning 只是对 sunset governance 的可见输出之一，  
不是全部主权本体。  
真正关键的是 retirement date、grace deadline、visibility cutoff 与 hard close 的组合。

### 第二问

`migration governor 和 sunset governor 一定要做成两个模块吗？`

也不能这么绝对。  
它们可以由同一实现承载，  
但回答的问题不同：  
一个回答“怎样并存”，  
一个回答“何时结束并存”。

### 第三问

`如果 cleanup 线将来只有很小的 path fix，还需要 sunset governance 吗？`

只要旧 path、旧 promise 或旧 receipt 在现实中还会继续被引用，  
就至少要回答：

`它们什么时候不再被视为当前 truth。`

这已经是 sunset 问题，  
不取决于修复看起来有多小。

### 第四问

`这章最值得继续逼问自己的地方是什么？`

是这句：

`cleanup 线未来最危险的 sunset object，到底是旧 path、旧 promise，还是旧 receipt semantics？`

如果答案不是一个而是多个，  
那么真正成熟的 cleanup sunset governance  
很可能还要继续拆成：

1. path sunset
2. promise sunset
3. receipt sunset

三条不同 control plane。

## 12. 一条硬结论

这组源码真正说明的不是：

`Claude Code 只要决定了 cleanup artifact 怎么迁，就已经自动拥有了宣布旧 cleanup 世界退役的主权。`

而是：

`repo 在模型退役日期、迁移通知、plugin orphan grace window 与 session-level visibility cutoff 上已经明确展示了 sunset governance 的存在；因此 artifact-family cleanup migration-governor signer 仍不能越级冒充 artifact-family cleanup sunset-governor signer。`

再压成最后一句：

`迁移负责让旧世界跟着走；退役，才负责让旧世界在恰当的时刻真正停下来。`
