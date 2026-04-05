# 安全保留期治理与执行诚实性分层：为什么retention-governor signer不能越级冒充retention-enforcement-honesty signer

## 1. 为什么在 `155` 之后还必须继续写 `156`

`155-安全不可逆销毁与保留期主权分层` 已经回答了：

`irreversible-erasure signer 最多只能说“删掉了什么”；retention-governor signer 才配说“保留期怎么定义、谁有权执行、何时必须暂停执行”。`

但如果继续追问，  
还会碰到更细一层、也更容易被忽视的错觉：

`既然 retention policy 已经被定义，housekeeping 也已经存在，系统是否就已经自动拥有一位可以诚实宣布“这条 retention policy 在当前 session mode 下已经真正执行了”的 signer？`

Claude Code 当前源码给出的答案仍然是否定的。

因为继续往下看会发现，  
保留期治理和保留期执行诚实性，  
并不是同一层：

1. schema 与 validation tip 会声明  
   `cleanupPeriodDays = 0` 时，现有 transcripts 会在 startup 删除  
   `src/utils/settings/types.ts:325-332`  
   `src/utils/settings/validationTips.ts:48-54`
2. 但可见执行链显示 cleanup 进入运行时，要经过  
   `main.tsx / REPL.tsx -> backgroundHousekeeping -> delay/activity gating -> cleanup.ts`
   `src/main.tsx:2811-2818`  
   `src/screens/REPL.tsx:3903-3906`  
   `src/utils/backgroundHousekeeping.ts:25-29,43-60`
3. `cleanupOldMessageFilesInBackground()` 本身返回 `Promise<void>`，丢弃各 cleanup 函数的 `CleanupResult`，也没有为 transcript/session cleanup 产出统一事件回执  
   `src/utils/cleanup.ts:33-45,575-595`
4. 唯一能明显看见 cleanup 已真实影响别的运行对象的地方，反而是 `TaskOutput` 的诊断文案：另一个 Claude Code 进程可能在 startup cleanup 中删掉了当前输出文件  
   `src/utils/task/TaskOutput.ts:313-325`

这说明：

`retention policy exists`

和

`current runtime honestly knows and can declare whether it has been executed`

仍然不是一回事。

所以 `155` 之后必须继续补的一层就是：

`安全保留期治理与执行诚实性分层`

也就是：

`retention-governor signer 最多只能定义 retention policy；retention-enforcement-honesty signer 才配宣布这条 policy 在当前 session mode、当前 entrypoint、当前时刻里到底已经执行、被跳过、被推迟，还是根本尚未进入执行路径。`

## 2. 先做一条谨慎声明：`retention-enforcement-honesty signer` 仍是研究命名，不是源码现成类型

和 `147-155` 一样，  
这里也要先讲清楚：

`Claude Code 当前源码里并没有一个字面存在的 signer 类型叫 retention-enforcement-honesty signer。`

这里的 `retention-enforcement-honesty signer` 仍然是研究命名。  
它不是在声称 Anthropic 已经做出了这层结构化对象，  
而是在说：

1. 当前源码已经有 retention declaration
2. 当前源码已经有 runtime cleanup executor
3. 当前源码又显露出 declaration 与 runtime enforcement 之间并不自动同层
4. 所以最自然的下一层主权，就是谁配诚实宣布“这条 retention policy 现在到底执行到哪里了”

换句话说：

`156` 不是在虚构现有实现，
而是在给当前仍显缺位的一层诚实性主权命名。

## 3. 最短结论

Claude Code 当前源码至少给出了五类“retention governor 仍不等于 retention-enforcement-honesty signer”证据：

1. schema 和 validation tip 声称 `cleanupPeriodDays = 0` 时旧 transcripts 会在 startup 删除  
   `src/utils/settings/types.ts:325-332`  
   `src/utils/settings/validationTips.ts:48-54`
2. 但未来写入抑制与既有 transcript 删除本身已经分离：`shouldSkipPersistence()` 会立刻禁止新 transcript 写入，而既有 cleanup 仍走 housekeeping 路径  
   `src/utils/sessionStorage.ts:953-969`  
   `src/utils/cleanup.ts:575-595`
3. runtime 执行链受 entrypoint、first submit、delay 与 recent activity gating 影响，说明 policy declaration 不等于 immediate enforcement  
   `src/main.tsx:2811-2818`  
   `src/screens/REPL.tsx:3903-3906`  
   `src/utils/backgroundHousekeeping.ts:25-29,43-60`
4. `cleanupOldMessageFilesInBackground()` 不返回 aggregated `CleanupResult`，调用方也不等待它产出一条“已执行/已跳过/已延期”的结构化结论  
   `src/utils/cleanup.ts:33-45,575-595`
5. `TaskOutput` 只能事后用诊断字符串暴露“另一个 Claude Code 进程可能在 startup cleanup 中删掉了文件”，这说明真实副作用存在，但缺少正式 enforcement honesty layer  
   `src/utils/task/TaskOutput.ts:313-325`

因此这一章的最短结论是：

`retention-governor signer 最多只能说“policy 应该如何治理”；它仍然不能越级说“当前 runtime 已经诚实、完整且结构化地宣布这条 policy 已被执行”。`

再压成一句：

`有治理，不等于有执行诚实性。`

## 4. 第一性原理：为什么 retention governance 仍不等于 enforcement honesty

从第一性原理看：

- retention governance 回答的是  
  `policy 应该是什么`
- enforcement honesty 回答的是  
  `这条 policy 现在在当前 runtime 中到底执行了没有、执行到哪一步、有没有被跳过或推迟`

所以两者处理的是两种完全不同的问题：

1. normative truth
2. runtime truth

如果把两者压成同一句绿色话术，  
系统就会制造四类危险幻觉：

1. declared-means-executed illusion  
   只要 schema/文案写了，就误以为当前进程已经执行
2. disabled-future-writes-means-past-cleaned illusion  
   只要以后不再写 transcript，就误以为以前的 transcript 已被删掉
3. background-scheduled-means-completed illusion  
   只要 housekeeping 被启动，就误以为 cleanup 已完成
4. side-effect-observed-means-honestly-accounted illusion  
   只要某次副作用真的发生，就误以为系统已正式告诉用户这次副作用已发生

所以从第一性原理看：

`governance` 规定应然；  
`enforcement honesty` 才陈述实然。

## 5. `cleanupPeriodDays = 0` 已经暴露出 declaration truth 与 runtime truth 的第一条裂缝

`src/utils/settings/types.ts:325-332` 和 `validationTips.ts:48-54` 都明确说：

`Setting 0 disables session persistence entirely: no transcripts are written and existing transcripts are deleted at startup.`

但从当前可见源码看，  
至少可以确认两件事实：

1. `src/utils/sessionStorage.ts:953-969` 的 `shouldSkipPersistence()` 会立刻让未来 transcript writes 停止
2. 既有 transcripts 的删除则仍要走 `cleanup.ts` + `backgroundHousekeeping` 的运行链

这说明同一句产品语义，其实已经包着两种完全不同的 truth：

1. future-write suppression truth
2. past-artifact cleanup truth

而这两种 truth 在当前实现里并没有共享同一个即时执行路径。

所以如果没有更高层的 honesty signer，  
“0 disables persistence” 这句很容易被误听成：

`现在所有旧材料都已经没了`

而源码实际上只保证了其中一半。

## 6. scheduler 的存在本身就要求一位专门的 honesty signer

`src/main.tsx:2811-2818` 与 `src/screens/REPL.tsx:3903-3906` 展示出两个非常不同的启动条件：

1. headless 非 bare 路径会更早启动 housekeeping
2. REPL interactive 路径直到 `submitCount === 1` 才启动

`src/utils/backgroundHousekeeping.ts:43-60` 又继续加门：

1. 先延迟 10 分钟
2. 最近 1 分钟有用户活动则继续推迟
3. 注释明确说 scripted calls 不需要这些 bookkeeping，下一次 interactive session 再 reconcile

只要一个系统允许：

- delayed execution
- activity-based deferral
- mode-based gating
- next-session reconciliation

它就已经在第一性原理上需要一位专门的 signer 来回答：

`这条 policy 现在到底执行了没有？`

否则，  
governor 的 policy declaration 就必然被误当成 executor 的 current fact。

## 7. `CleanupResult` 的命运说明：系统内部会统计结果，但没有把它升级成对外真相

`src/utils/cleanup.ts:33-45` 先定义了：

`CleanupResult = { messages, errors }`

并且各具体 cleanup 函数：

- `cleanupOldMessageFiles()`
- `cleanupOldSessionFiles()`
- `cleanupOldFileHistoryBackups()`
- `cleanupOldSessionEnvDirs()`
- `cleanupOldDebugLogs()`

都各自返回 `CleanupResult`。

但 `cleanupOldMessageFilesInBackground()` 却把这些结果直接吞掉了：

1. 顺序 await 各 cleanup
2. 不聚合结果
3. 不返回结果
4. 不为 session/transcript/file-history cleanup 产出统一 telemetry event

这是一条非常重要的结构信号。

因为它说明系统内部已经知道：

`cleanup can be counted`

却还没有升级成：

`cleanup execution can be formally signed and surfaced`

所以这里缺的不是执行能力，  
而是 execution honesty protocol。

## 8. 可观测性不对称进一步证明：有些 cleanup 有事件，有些 cleanup 只有后果

`src/utils/cleanup.ts` 当前可见的事件化输出很不对称：

1. `tengu_npm_cache_cleanup` 有 telemetry  
   `src/utils/cleanup.ts:521-530`
2. `tengu_worktree_cleanup` 也有 telemetry  
   `src/utils/cleanup.ts:595-597`
3. 但最核心的 transcript/session/file-history cleanup 没有对等的结构化事件

这说明当前系统里已经存在一种可观测性不对称：

- 某些 peripheral cleanup 被正式记录
- 某些直接影响 transcript/history continuity 的 cleanup 却没有同等级的公开回执

从安全设计哲学看，  
这恰恰进一步说明：

`retention enforcement honesty`

还没有被做成统一控制面。

## 9. `TaskOutput` 的诊断文案说明：真实副作用会外溢到别的运行对象，但系统仍主要靠事后字符串自证

`src/utils/task/TaskOutput.ts:313-325` 极有价值。  
这里写得很直白：

1. 读输出文件失败的 `ENOENT`
2. 历史原因之一是  
   `another Claude Code process in the same project deleted it during startup cleanup`
3. 系统用一段 diagnostic string 告诉模型与用户发生了什么

这条证据非常强，  
因为它说明：

1. cleanup 的副作用是真实的
2. 它可能跨进程影响别的运行对象
3. 但系统主要通过事后错误字符串来补偿解释

如果一个系统真正拥有成熟的 enforcement honesty signer，  
更自然的设计本应是：

`cleanup was deferred / executed / caused cross-session deletion side effect`

这类结构化真相先存在，  
然后再决定如何文案化。

当前实现至少在可见源码里还没走到这一步。

## 10. 技术先进性与哲学本质：Claude Code 真正先进的不是完全没有张力，而是已经把张力暴露出来

从技术上看，Claude Code 这条 retention 链先进的地方，不是它已经完美解决了 enforcement honesty，  
而是它已经把几个关键裂缝暴露得足够清楚：

1. declaration 与 execution 不是同层
2. future-write suppression 与 past-artifact cleanup 不是同层
3. scheduler 与 executor 不是同层
4. side-effect visibility 与 structured receipt 不是同层

这背后的哲学本质是：

`真正成熟的安全系统，不会因为自己有 policy 和 executor，就假装自己已经拥有了 execution honesty。`

Claude Code 当前源码最值得学习的地方，  
不是“没有问题”，  
而是它已经把问题压缩到了可命名、可继续制度化的层级。

## 11. 苏格拉底式反思：如果这章还可能写错，最容易错在哪里

### 反思一

既然我没有找到同步 startup delete 的完整实现，能不能直接说文案是错的？

不能。  
当前更稳妥的判断只是：

`在可见 extracted source 中，declaration truth 与 runtime enforcement truth 之间存在尚未被统一签字的张力。`

这和直接宣判 bug 不是一回事。

### 反思二

既然 cleanup 真会发生，我为什么还要继续强调 honesty signer 缺位？

因为真实副作用发生，并不等于系统已经给出了结构化且可验证的执行结论。  
`TaskOutput` 恰恰证明了两者可以分离。

### 反思三

既然 `CleanupResult` 已存在，是否说明 honesty signer 已经差不多有了？

还不够。  
内部计数不等于正式 truth surface。  
只有当这些结果被聚合、分层、挂载到用户/系统可消费的结论面，  
它们才开始接近 honesty signer。

### 反思四

如果我要把这套设计再提高一倍，下一步最该补什么？

我会优先补三样东西：

1. `retention_execution_status` 结构化字段  
   区分 `declared / scheduled / deferred / skipped / executed / side_effected`
2. declaration vs enforcement 的双层 UI 文法
3. cleanup aggregation event  
   至少把 transcript/session/file-history cleanup 的结果像 worktree/npm cleanup 那样正式打点或挂账

因为现在源码已经把这些层次摆出来了，  
但还没有把它们升级成统一 honesty protocol。

## 12. 一条硬结论

Claude Code 当前源码真正说明的不是：

`retention policy 一旦被定义，就自动拥有执行诚实性`

而是：

`retention governor、runtime scheduler、cleanup executor 与 enforcement honesty 仍然是不同强度的层。`

因此：

`retention-governor signer 不能越级冒充 retention-enforcement-honesty signer。`
