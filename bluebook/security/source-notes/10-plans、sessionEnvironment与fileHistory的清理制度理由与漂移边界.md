# plans、sessionEnvironment 与 fileHistory 的清理制度理由与漂移边界

## 1. 为什么单开这一篇源码剖面

安全主线推进到 `159` 时，  
真正需要被单独钉住的已经不是：

`不同 artifact family 现在是否活在不同 constitution 里，`

而是：

`这些 constitution 背后的制度理由是否一致、是否被执行器诚实继承、是否已经开始漂移。`

如果这个问题只留在主线长文里，  
最容易被压扁成一句抽象判断：

`plans family 有 rationale drift。`

这句话太短，不足以复用。  
所以这里单开一篇，只盯住：

- `src/utils/plans.ts`
- `src/utils/permissions/filesystem.ts`
- `src/utils/sessionEnvironment.ts`
- `src/utils/fileHistory.ts`
- `src/utils/cleanup.ts`
- `src/utils/settings/types.ts`

把 plans、session-env、file-history 三类 home-root artifact family 的制度理由、恢复职责与潜在漂移边界单独拆开。

## 2. 最短判断

这组代码最重要的技术事实不是：

`home-root families 只是被放在 ~/.claude 下。`

而是：

`home-root 只是外表，真正驱动它们分化的，是 planning autonomy、restore backup 与 environment replay 三种不同理由。`

而在这三种理由里，  
plans family 又进一步暴露出：

`storage rationale 已经允许 project-root override，但 cleanup executor 还停留在 default home-root assumption。`

所以这一组文件最值得留下的结论是：

`home-root artifact family 也不是同理世界；其中至少 plans 已经出现制度理由漂移边界。`

## 3. 关键源码锚点

| 主题 | 关键源码 | 这里回答的问题 |
| --- | --- | --- |
| plan default / override constitution | `src/utils/plans.ts:79-110`; `src/utils/settings/types.ts:824-830` | 为什么 plans 同时带有 home-root 默认与 project-root customization |
| plan read / session coupling | `src/utils/permissions/filesystem.ts:245-254,1645-1652` | 为什么 plan file 仍被当作 current-session active artifact |
| plan resume recovery | `src/utils/plans.ts:164-233` | 为什么 plan family 不能只被看成普通 markdown 存储 |
| plan cleanup executor | `src/utils/cleanup.ts:300-303` | 为什么 executor 仍停留在 default home-root assumption |
| file-history rationale | `src/utils/fileHistory.ts:951-957`; `src/utils/cleanup.ts:305-347` | 为什么 backup family 服从 home-root per-session retention |
| session-env rationale | `src/utils/sessionEnvironment.ts:15-30,60-134`; `src/utils/cleanup.ts:350-387` | 为什么 env scripts 也服从 home-root per-session retention |

## 4. plans 先证明：这个 family 的理由不是单纯“存一份 markdown”

`src/utils/plans.ts:79-110` 说明：

1. 默认 plans dir 是 `~/.claude/plans`
2. 可以用 `plansDirectory` 把 plans 相对项目根重定向
3. 如果越出项目根，会被拒收并退回默认 home-root

单看这里，  
我们已经能看出 plan family 不是普通 cache：

1. 它有默认 home-root 的产品地位
2. 它又允许 project-root 协作化落地
3. 它被配置校验明确视为用户会关心的可控对象

如果再看 `src/utils/permissions/filesystem.ts:245-254,1645-1652`，  
会发现系统还把当前 session 的 plan file 当作一个带活跃语义的对象：

1. `isSessionPlanFile()` 依赖 `getPlansDirectory()` 与当前 `planSlug`
2. 读取规则只为当前 session 的 plan file 亮绿灯

再叠加 `src/utils/plans.ts:164-233`：

1. resume 会尝试恢复缺失的 plan file
2. 恢复不仅能直接读文件
3. 还会退回 file snapshot 与 message history 搜索

这三组证据叠在一起，  
说明 plan family 至少同时承担三层职责：

1. user-facing planning artifact
2. current-session active coordination artifact
3. resume-capable recoverable artifact

所以它的制度理由绝对不是一句“home-root markdown”就能解释完。

## 5. 真正的漂移边界：`plansDirectory` 已经改写了存储理由，但 `cleanupOldPlanFiles()` 还没有同步改写清理理由

`src/utils/settings/types.ts:824-830` 把 `plansDirectory` 描述为：

`Custom directory for plan files, relative to project root. If not set, defaults to ~/.claude/plans/`

这意味着产品层已经正式承认：

`plans 不是永远只能是 home-root artifact，它也可以是 project-root artifact。`

但 `src/utils/cleanup.ts:300-303` 的实现仍然是：

1. 直接 `join(getClaudeConfigHomeDir(), 'plans')`
2. 然后 `cleanupSingleDirectory(plansDir, '.md')`

这说明 cleanup executor 目前理解的仍是：

`plan family = default home-root markdown directory`

而不是：

`plan family = maybe home-root, maybe project-root, depending on configured rationale`

这里的关键不是“发现了一个 bug”这么简单。  
更深一层的技术判断是：

`plan family 的 storage rationale 已经从单一默认世界扩展到可配置世界，但 cleanup rationale 还没有显式追上这个扩展。`

这就是 `159` 里所谓的 rationale drift boundary。

## 6. file-history 说明另一种更稳定的理由：它服务 restore，而不是计划协作

`src/utils/fileHistory.ts:951-957` 把 backups 放到：

`~/.claude/file-history/<sessionId>/`

`src/utils/cleanup.ts:305-347` 则：

1. 扫整个 `file-history`
2. 以 session dir 为单位看 mtime
3. 过期后递归删整目录

这里的理由和 plans 明显不同。

file-history family 的核心职责是：

1. 给当前或恢复中的 session 提供 restore / undo safety net
2. 让 backup 生命周期围绕 session 而不是项目文件叙事组织
3. 在过期后整体退出，而不是保留一堆分散文件等待项目内继续消费

所以它更像：

`restore kit`

而不是：

`planning artifact`

也正因如此，  
它的 constitution 与 rationale 目前看起来更一致：

`home-root per-session-dir retention`

并没有像 plans 一样出现“可迁移存储世界已扩张，但 cleanup executor 仍停在旧世界”的明显裂缝。

## 7. session-env 再说明：environment replay 也是一种独立制度理由

`src/utils/sessionEnvironment.ts:15-30` 把 env scripts 放到：

`~/.claude/session-env/<sessionId>/`

还进一步暴露出两个关键事实：

1. 文件名按 hook event 与 hook index 编排
2. 这些脚本会在 `getSessionEnvironmentScript()` 中重新加载、排序、拼接  
   `src/utils/sessionEnvironment.ts:60-134`

这说明 session-env family 的首要职责也不是项目内长程审计，  
而是：

1. 复原某次 session 的 shell / hook 环境
2. 让 bash provider 等执行路径能够重放这些环境前提
3. 以 session 为粒度打包、过期、删除

`src/utils/cleanup.ts:350-387` 正好对应这一点：

1. session-env 也是 per-session dir
2. retention gate 也是 session dir mtime
3. 删除方式也是整个 session dir 的递归清除

所以 session-env family 和 file-history family 虽然都活在 home-root per-session world，  
但理由仍不一样：

1. file-history 是 restore edited files
2. session-env 是 replay execution environment

也就是说：

`同一 constitution，并不意味着同一 rationale。`

## 8. 这篇源码剖面给主线带来的四条技术启示

### 启示一

判断 cleanup law 是否成熟，  
不能只看路径，  
还要看恢复职责有没有一起被保存。

### 启示二

一旦某个 family 的存储位置可配置，  
cleanup executor 就必须同步理解这项配置，  
否则制度理由会先变，执行器却还活在旧理由里。

### 启示三

home-root artifact family 也不能被一把抓。  
plans、file-history、session-env 虽然都不在 `projects/<project>` 里，  
但分别服务 planning autonomy、restore safety 与 environment replay。

### 启示四

真正成熟的 family-scoped cleanup design，  
应该把：

1. storage reason
2. reader scope
3. recovery duty
4. cleanup executor scope

放进同一张制度地图里看，  
而不是让这些理由散落在设置 schema、permission helper、resume helper 与 cleanup helper 之间。

## 9. 一条硬结论

这组源码真正说明的不是：

`home-root families 只是另一种路径风格。`

而是：

`home-root families 本身也对应不同制度理由；其中 plans family 已经暴露出 storage rationale 与 cleanup rationale 的漂移边界，而 file-history 与 session-env 则更像理由相对一致的 restore / replay retention families。`

因此：

`artifact-family cleanup rationale` 这一层必须独立于 `artifact-family cleanup constitution` 被追问；否则多宪法世界很快就会退化成多惯例世界。
