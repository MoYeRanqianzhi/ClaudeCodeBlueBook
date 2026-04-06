# cleanup、backgroundHousekeeping 与 settings 的保留期治理边界

## 1. 为什么单开这一篇源码剖面

安全主线推进到 `155` 时，  
真正需要被单独拆开的已经不是：

`谁会做 destructive delete，`

而是：

`谁在定义 retention policy，谁在决定何时启动 cleanup，谁在 validation 出错时有权停手，谁又只是最后执行 unlink/rm 的人？`

如果这个问题只停在主线长文里，  
很容易被压成抽象的“保留期主权”。  
所以这里单开一篇，只盯住：

- `src/utils/settings/types.ts`
- `src/utils/settings/settings.ts`
- `src/utils/backgroundHousekeeping.ts`
- `src/utils/cleanup.ts`
- `src/main.tsx`
- `src/screens/REPL.tsx`

把 retention declaration、merge precedence、intent guard、scheduler 与 executor 拆给源码本身说话。

## 2. 先给最短判断

这组代码最重要的技术事实不是：

`Claude Code 能不能按保留期删文件。`

而是：

`Claude Code 已经把 retention governance 拆成 declaration、precedence、honesty guard、scheduler 与 executor 五层。`

因为它同时做了五件很硬的事：

1. schema 先定义 `cleanupPeriodDays` 语义
2. effective value 走通用 settings merge 顺序
3. `rawSettingsContainsKey()` 会在 validation 出错时保住用户显式 retention intent
4. housekeeping 的启动时机受 entrypoint、submitCount、delay 与 recent activity gating
5. `cleanup.ts` 最终才真正执行 unlink/rm

这意味着它治理的不是单一 cleanup 函数，  
而是一套：

`retention-governance stack`

## 3. 关键源码锚点

| 主题 | 关键源码 | 这里回答的问题 |
| --- | --- | --- |
| retention schema declaration | `src/utils/settings/types.ts:325-332` | 谁先定义 cleanupPeriodDays 及其默认/零值语义 |
| validation tip semantics | `src/utils/settings/validationTips.ts:48-54` | 产品语言怎样描述 retention 语义 |
| merge precedence | `src/utils/settings/settings.ts:798-820` | cleanup policy 到底服从哪条 source priority |
| sensitive-setting contrast | `src/utils/settings/settings.ts:877-904,916-921` | 为什么 retention governance 当前没有被像危险权限那样单独加固 |
| raw intent detection | `src/utils/settings/settings.ts:871-875,984-1015` | validation 错误时谁有资格阻止默认 retention 接管 |
| housekeeping start points | `src/main.tsx:2811-2818`; `src/screens/REPL.tsx:3903-3906` | cleanup 何时真的被启动，而不是只停在 policy 文案里 |
| deferred scheduler | `src/utils/backgroundHousekeeping.ts:25-29,43-60` | 为什么 cleanup 还要受 delay 与 activity gating 约束 |
| destructive executor | `src/utils/cleanup.ts:155-257,305-347,575-595` | 真正谁在删 session files / backups / tool-results |

## 4. `cleanupPeriodDays` 先写 law，再轮到 runtime 决定何时执法

`src/utils/settings/types.ts:325-332` 先把 retention semantics 写成 schema：

1. 默认 30 天
2. 非负整数
3. `0` 禁用 session persistence
4. 现有 transcripts 据文案应在 startup 删除

这说明 retention 在源码世界里首先不是：

`cleanup function behavior`

而是：

`configuration law`

也就是说，  
policy declaration 天然位于 executor 之前。

## 5. merge order 暴露出 retention governance 目前服从通用配置主权

`src/utils/settings/settings.ts:798-820` 明确给出 effective settings 的 merge 顺序：

`userSettings -> projectSettings -> localSettings -> policySettings`

这很重要。  
因为它说明 `cleanupPeriodDays` 当前首先服从的是：

`general settings sovereignty`

而不是：

`special destructive-policy sovereignty`

这与同文件里别的敏感 setting 形成对照：

- 危险权限确认排除 `projectSettings`
- auto-mode opt-in 排除 `projectSettings`
- `useAutoModeDuringPlan` 也排除 `projectSettings`

但 `cleanupPeriodDays` 的可见实现里没有这种单独加固。

所以至少在当前 extracted source 中：

`retention governance 仍比 permission governance 更通用，也更少被安全特化。`

## 6. `rawSettingsContainsKey()` 是一个非常强的 honesty guard

`src/utils/settings/settings.ts:871-875,984-1015` 与 `src/utils/cleanup.ts:575-584` 组成了一条很漂亮的约束链：

1. 用户可以显式设置 `cleanupPeriodDays`
2. 即使其他 settings validation 失败，系统仍先检测这个 key 是否真的被用户写过
3. 一旦确认用户显式写过而当前 settings 又有 validation errors，cleanup 整体直接跳过

这说明源码作者明确拒绝：

`用户配置坏了，那就退回默认 retention 继续删。`

他们选择的是：

`宁可不删，也不要让默认值篡位成用户真正想要的 retention policy。`

这条 guard 的价值不在于它会删什么，  
而在于它规定了：

`什么时候不配删。`

## 7. scheduler 再次拆出一层：谁有权说“现在开始执法”

`src/main.tsx:2811-2818` 与 `src/screens/REPL.tsx:3903-3906` 很关键：

1. headless 非 bare 路径会尽早启动 `backgroundHousekeeping`
2. interactive REPL 路径则直到第一次 submit 后才启动

`src/utils/backgroundHousekeeping.ts:25-29,43-60` 又进一步说明：

1. housekeeping 有 10 分钟延迟
2. 最近 1 分钟有用户活动会再次推迟
3. 注释明确说 scripted calls 不需要这些 bookkeeping，下一次 interactive session 会 reconcile

这意味着 cleanup 并不是：

`policy 存在 -> 立刻执行`

而是：

`policy 存在 -> entrypoint 允许 -> scheduler 启动 -> delay/activity gate 放行 -> executor 执行`

所以 scheduler 在这里不是实现细节，  
而是 retention governance 的正式一层。

## 8. “startup delete” 文案与可见执行链之间存在值得单独记录的诚实性张力

`src/utils/settings/types.ts:331-332` 与 `validationTips.ts:52-54` 都把 `cleanupPeriodDays = 0` 描述成：

`existing transcripts are deleted at startup`

但在当前可见代码里，  
我能明确定位到的执行链是：

1. `main.tsx` 或 `REPL.tsx` 启动 housekeeping
2. `backgroundHousekeeping.ts` 延迟/择机运行
3. `cleanup.ts` 再实际删文件

至少从这条可见链看，  
这里并不是一个单纯的：

`进程刚起即同步删旧 transcripts`

语义。

这条张力不一定直接等于 bug。  
但它已经足够说明：

`declaration truth`

和

`runtime enforcement truth`

在当前实现里仍未被压平。

## 9. `cleanup.ts` 最终扮演的是 executor，而不是 governor

`src/utils/cleanup.ts:155-257,305-347,575-595` 最终做的是：

1. 计算 cutoff
2. 删除旧 session `.jsonl/.cast/tool-results`
3. 删除旧 file-history session 目录
4. 串起 env dirs、debug logs、pastes、worktrees 等清理

这里最值得注意的不是“删得广”，  
而是它没有同时决定：

- 哪个 source 最有权定义 retention
- validation 错误时默认是否可接管
- scheduler 是否该现在就跑
- 文案是否有资格说“startup delete”

所以 `cleanup.ts` 在制度位置上更像：

`executor`

而不是：

`governor`

## 10. 这篇源码剖面给主线带来的三条技术启示

### 启示一

真正成熟的 destruction governance 不是一个函数，  
而是一条跨 schema、merge、guard、scheduler 与 executor 的控制栈。

### 启示二

系统越接近 destructive authority，  
越不能允许默认值、文案或局部 rm 调用越级冒充 policy truth。

### 启示三

如果 retention governance 没有像 permission governance 那样被单独加固，  
那它就仍值得被继续研究，而不能被轻易说成“已经制度完备”。

## 11. 一条硬结论

这组源码真正先进的地方不是：

`支持 cleanupPeriodDays`

而是：

`它已经把 retention declaration、policy merge、intent honesty、scheduler 与 destroy executor 拆成不同治理层。`

因此：

`irreversible erasure 仍不能越级冒充 retention governance。`
