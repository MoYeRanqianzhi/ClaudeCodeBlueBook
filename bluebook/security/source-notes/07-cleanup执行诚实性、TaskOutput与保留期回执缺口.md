# cleanup 执行诚实性、TaskOutput 与保留期回执缺口

## 1. 为什么单开这一篇源码剖面

安全主线推进到 `156` 时，  
真正需要被单独拆开的已经不是：

`谁定义 retention policy，`

而是：

`谁配宣布这条 policy 在当前 runtime 里已经执行、被推迟、被跳过，还是只停留在 declaration 层？`

如果这个问题只停在主线长文里，  
很容易被说成抽象的“诚实性”。  
所以这里单开一篇，只盯住：

- `src/utils/settings/types.ts`
- `src/utils/settings/validationTips.ts`
- `src/utils/sessionStorage.ts`
- `src/utils/backgroundHousekeeping.ts`
- `src/utils/cleanup.ts`
- `src/main.tsx`
- `src/screens/REPL.tsx`
- `src/utils/task/TaskOutput.ts`

把 declaration、suppression、scheduling、execution 与 post-hoc diagnostics 拆给源码本身说话。

## 2. 先给最短判断

这组代码最重要的技术事实不是：

`Claude Code 最终会不会删旧文件。`

而是：

`Claude Code 当前可见实现里，还缺一位能把 retention declaration 与 runtime enforcement 真正重新签起来的 honesty signer。`

因为它同时做了五件互不等价的事：

1. schema/tip 先声明 “0 会 startup delete”
2. `shouldSkipPersistence()` 立刻阻止未来写入
3. housekeeping 再按 mode/lifecycle/delay 进入运行链
4. `cleanup.ts` 最终执行 unlink/rm
5. `TaskOutput` 只能事后用字符串补偿说明 cleanup side effect

这意味着当前系统至少已经把：

`policy declared`

和

`policy honestly reported as executed`

拆成两层。

## 3. 关键源码锚点

| 主题 | 关键源码 | 这里回答的问题 |
| --- | --- | --- |
| declaration text | `src/utils/settings/types.ts:325-332` | policy 文案先说到了什么 |
| validation tip text | `src/utils/settings/validationTips.ts:48-54` | 用户错误提示怎样重复这条文案 |
| immediate suppression | `src/utils/sessionStorage.ts:953-969` | 哪些东西会立刻停止写入 |
| scheduler start | `src/main.tsx:2811-2818`; `src/screens/REPL.tsx:3903-3906` | cleanup 何时才真正开始进入 runtime |
| deferred execution | `src/utils/backgroundHousekeeping.ts:25-29,43-60` | 为什么 “startup” 在执行层仍可能被延迟/推迟 |
| result loss | `src/utils/cleanup.ts:33-45,575-595` | cleanup 结果怎样在背景路径中被吞掉 |
| telemetry asymmetry | `src/utils/cleanup.ts:521-530,595-597` | 为什么 peripheral cleanup 有 event，而核心 transcript cleanup 没有 |
| side-effect diagnostic | `src/utils/task/TaskOutput.ts:313-325` | 为什么 cleanup 副作用只能事后被字符串暴露 |

## 4. declaration 先说“startup delete”，但 suppression 只保证“以后不再写”

`src/utils/settings/types.ts:325-332` 与 `validationTips.ts:48-54` 先把语义说得很满：

`Setting 0 disables session persistence entirely: no transcripts are written and existing transcripts are deleted at startup.`

但 `src/utils/sessionStorage.ts:953-969` 的 `shouldSkipPersistence()` 真正直接保证的是：

1. test env 不写
2. `cleanupPeriodDays === 0` 不写
3. `--no-session-persistence` 不写
4. `CLAUDE_CODE_SKIP_PROMPT_HISTORY` 不写

这说明最即时、最确定的 runtime truth 实际上是：

`future writes are suppressed now`

而不是：

`past artifacts are already gone now`

所以 declaration 语义在这里至少已经比 immediate runtime guarantee 更强了一层。

## 5. scheduler 的存在让“startup”在 enforcement 层变成一个会滑动的词

`src/main.tsx:2811-2818` 说明：

1. headless 非 bare 模式会启动 backgroundHousekeeping
2. 而且是 `void import(...).then(...)` 的 fire-and-forget 样式

`src/screens/REPL.tsx:3903-3906` 又说明：

1. interactive REPL 不是一启动就做
2. 而是 `submitCount === 1` 后才 `startBackgroundHousekeeping()`

`src/utils/backgroundHousekeeping.ts:25-29,43-60` 再继续把“startup”滑动化：

1. 延迟 10 分钟
2. 最近 1 分钟有用户活动则继续推迟
3. scripted calls 不需要 bookkeeping，下一次 interactive session 再 reconcile

这说明一旦把 declaration 里的 `startup` 拿到 enforcement 层来看，  
它就已经不是一个简单、同步、立刻的词。

这正是本章最值得留下的源码事实：

`startup` 在声明层可以是一个产品短语，
但在执行层它已经被 entrypoint、submit、delay 与 activity gating 重新切开。

## 6. `CleanupResult` 的丢失说明系统还没有把执行真相升级成正式回执

`src/utils/cleanup.ts:33-45` 先定义了：

`CleanupResult = { messages, errors }`

这意味着系统内部并不是不知道 cleanup 可以被计数。

但 `cleanupOldMessageFilesInBackground()` 接下来做的是：

1. 顺序 await 各 cleanup
2. 直接丢弃所有 `CleanupResult`
3. 返回 `Promise<void>`

也就是说，  
内部执行层知道可以统计，  
却没有把这些统计升级成：

`cleanup execution receipt`

于是结果是：

- executor 知道发生了什么
- governor 也许定义了 policy
- 但 runtime 没有把这两者重新连成一条正式 truth surface

## 7. 可观测性不对称让缺口更清楚：外围 cleanup 有 event，核心 cleanup 没有

`src/utils/cleanup.ts` 里当前能看到的 cleanup event 很少，而且不对称：

1. npm cache cleanup 有 `tengu_npm_cache_cleanup`
2. worktree cleanup 有 `tengu_worktree_cleanup`
3. transcript/session/file-history cleanup 没有对应对等 event

这说明“cleanup 已经发生”并不是一个被统一对待的事实：

- 某些 cleanup 会被正式观测
- 某些 cleanup 只在内部执行
- 某些 cleanup 甚至只在跨进程副作用里被侧面看见

从 honesty 角度说，  
这比“完全无执行”更值得重视，  
因为它说明系统已经接近有 receipt 的边缘，  
但还没有把 receipt 统一化。

## 8. `TaskOutput` 几乎是在替缺席的 signer 喊话

`src/utils/task/TaskOutput.ts:313-325` 的文案非常珍贵：

1. 输出文件读不到时，系统不再沉默返回空
2. 而是明确告诉模型与用户：
   这通常意味着同项目里的另一个 Claude Code 进程在 startup cleanup 中删掉了它

这段代码像是在说：

`既然系统里还没有正式的 cleanup enforcement receipt，那至少先用 diagnostic string 把后果说出来。`

这是一种很务实的补偿，  
但也反过来证明：

`formal honesty signer is still missing`

因为如果这层 signer 已经存在，  
这里最自然看到的应该是一个结构化状态，  
而不是一段事后救火文案。

## 9. 这篇源码剖面给主线带来的三条技术启示

### 启示一

执行诚实性不只是“有没有删”，  
而是“系统是否能把 declaration、scheduling、execution 与 side effect 重新关成同一条真相链”。

### 启示二

一套系统即使已经有 policy 和 executor，  
只要没有 execution receipt，  
它仍会在用户体验层退回到：

`靠文案猜、靠副作用推、靠错误字符串补偿`

### 启示三

Claude Code 当前实现最值得学习的，不是它已经完全解决这层问题，  
而是它已经把缺口暴露到足够清楚：  
你可以明确指出缺的是 signer，而不是泛泛说“还需要更多可观测性”。

## 10. 一条硬结论

这组源码真正说明的不是：

`retention policy 已天然拥有执行诚实性`

而是：

`declaration、suppression、scheduling、execution 与 post-hoc explanation 仍是分开的。`

因此：

`retention governor 仍不能越级冒充 retention-enforcement-honesty signer。`
