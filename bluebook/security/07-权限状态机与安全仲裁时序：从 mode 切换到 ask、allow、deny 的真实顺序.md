# 权限状态机与安全仲裁时序：从 mode 切换到 ask、allow、deny 的真实顺序

## 1. 为什么还要单独写这一章

前面的 `02` 章已经解释了：

- 真正危险的是绕过仲裁层
- path safety 先于目录便利
- sandbox 只是外部边界之一

但如果还想更进一步，  
就必须把权限系统真正压成一条执行时序：

`Claude Code 到底按什么顺序决定一个动作是 ask、allow 还是 deny？`

如果不把这一点单独写清，  
读者就会把：

- mode
- 规则
- tool.checkPermissions
- safety check
- bypass
- auto mode classifier

混成一团。

## 2. 先说结论

Claude Code 的权限判定不是“看当前 mode 就结束”，  
而是一个至少分成三段的状态机：

1. 先做 mode 级状态转换
2. 再做 tool permission 判定
3. 最后再决定是否允许 fast-path、classifier、prompt 或 bypass

而且其中有一条最关键的排序原则：

`safetyCheck 和 content-specific ask rule 的优先级，高于 bypassPermissions 与大部分自动放行路径。`

## 3. 第一段时序：mode 切换不是 UI 事件，而是上下文变换

`permissionSetup.ts` 中的 `transitionPermissionMode()` 把这件事写得很清楚。

它处理的不是“按钮变色”，  
而是以下真实状态变换：

1. 进入 / 离开 plan mode 的前后文处理
2. 进入 auto mode 时检查 gate 是否允许
3. 进入 auto mode 时 strip dangerous rules
4. 离开 auto mode 时 restore dangerous rules
5. 必要时清掉 `prePlanMode`

这意味着 mode 切换不是“给已有上下文贴标签”，  
而是：

`直接修改 permission context 本身。`

## 4. 第二段时序：进入 auto mode 时到底发生了什么

从 `stripDangerousPermissionsForAutoMode()` 和 `transitionPermissionMode()` 连起来看，  
auto mode 的进入至少有四步：

1. 读取当前 allow rules
2. 找出会绕过 classifier 的危险规则
3. 从可编辑来源中移除这些规则
4. 把被移除的规则暂存进 `strippedDangerousRules`

这一点很关键。  
Claude Code 没有简单说：

- auto mode 更聪明，所以你不用担心

它的做法恰恰相反：

- auto mode 要先让会绕过 classifier 的捷径失效

也就是说：

`auto mode 不是“更大胆”，而是“先清理会破坏自动仲裁的旧放行规则”。`

## 5. 第三段时序：离开 auto mode 时到底发生了什么

`restoreDangerousPermissions()` 的意义同样容易被低估。

它说明系统承认一个现实：

- 用户原本就可能配置了更宽的 allow rule
- auto mode 只是运行期临时剥离它们
- 离开 auto mode 后，必须把用户原有语义还回去

这说明 Claude Code 的安全观并不是：

`系统永久替用户改规则。`

而是：

`在某种 mode 下临时重写规则语义，离开该 mode 后再恢复。`

这是一种相当成熟的状态机设计。

## 6. 第四段时序：真正执行 tool permission 时，先后顺序是什么

`permissions.ts` 里能看出一个很清晰的顺序。

从高层抽象看，判定链大致是：

1. 先看全工具 ask rule
2. 再调用 tool 自己的 `checkPermissions()`
3. 若 tool 已明确 deny，则直接 deny
4. 若工具要求用户交互，则即使 bypass 也不直接跳过
5. 若是 content-specific ask rule，也先尊重 ask
6. 若是 `safetyCheck`，则仍然优先 ask
7. 之后才看 bypassPermissions
8. 再看全工具 always-allow rule
9. 在 auto / plan+auto 情况下，再决定是否走 fast-path 或 classifier

这条顺序最重要的含义是：

`bypass 不是系统的第一优先级。`

在 Claude Code 里，  
有些 ask 是“可绕过的”，  
有些 ask 是“必须保留的”。

## 7. `safetyCheck` 为什么是整条链里最值得重视的节点

`permissions.ts` 和 `pathValidation.ts` 对 `safetyCheck` 的处理非常说明问题。

系统明确规定：

- 某些 `safetyCheck` 是 bypass-immune
- 在 auto mode 下，非 classifier-approvable 的 `safetyCheck` 也不会走 fast-path
- 即使 acceptEdits 或 allowlist 可以让某些动作自动放行，`safetyCheck` 仍然优先存在

这意味着 Claude Code 有一个很稳定的安全原则：

`结构性危险目标，比当前 mode 的便利性更高优先级。`

例如：

- `.git`
- `.claude`
- `.vscode`
- shell config

这类路径风险不会因为你当前 mode 更激进就自动消失。

## 8. `acceptEdits` fast-path 为什么存在，但又不是真的 YOLO

`permissions.ts` 在 auto mode 下会先试一件事：

- 如果某个动作在 `acceptEdits` mode 下本来就会 allow
- 那么就跳过昂贵 classifier，直接 fast-path allow

这是一种很实用的性能优化。  
但它不是无限制的。

源码同时限制了：

1. `Agent` 和 `REPL` 不走这条 fast-path
2. `safetyCheck` 仍然优先
3. PowerShell 在某些公开构建条件下仍要求更显式的交互确认

这说明 Claude Code 在优化时并没有忘记那条总原则：

`便利路径只能吃掉低风险动作，不能吃掉结构性危险动作。`

## 9. auto mode classifier 在整条时序里的真实位置

很多人会误以为：

- auto mode classifier 决定一切

但从 `permissions.ts` 看，它实际上排在一串前置判断之后：

1. 非 classifier-approvable 的 `safetyCheck` 先保留
2. 需要显式用户交互的工具先保留
3. 某些 PowerShell 情况先保留
4. `acceptEdits` fast-path 先试
5. safe-tool allowlist 再试
6. 直到这些都不成立，才真正调用 classifier

这说明 classifier 在 Claude Code 里的角色更准确地说是：

`中段仲裁器。`

而不是：

`整套安全系统的唯一核心。`

## 10. bypassPermissions 为什么仍然不是“全局无敌”

从 `setup.ts`、`permissions.ts`、`pathValidation.ts` 合起来看，  
bypassPermissions 仍然被多层结构束缚：

1. 启动时需要额外环境前提
2. 某些 `safetyCheck` 仍然会要求 ask
3. 某些 user-interaction-required 场景仍不直接放过
4. Statsig / settings 还可能在更高层直接禁用 bypass mode

这说明系统对 bypass 的哲学不是：

`你都选 bypass 了，那就彻底不管。`

而是：

`你可以跳过一部分交互仲裁，但不能跳过所有结构性边界。`

## 11. 从技术角度看，这条状态机为什么先进

它至少有四点成熟之处：

1. 把 mode 切换做成上下文变换，而不是 UI 标记
2. 把危险规则剥离与恢复做成成对操作，避免语义漂移
3. 把 `safetyCheck` 提升到高于 bypass / fast-path 的优先级
4. 把 classifier 嵌入长时序，而不是孤立成唯一裁判

很多系统只做到其中一两条。  
Claude Code 做到的是一整条有顺序的仲裁链。

## 12. 给平台构建者的技术启示

如果要借鉴 Claude Code，这一章最值得保留的是五条：

1. 权限系统要有显式状态机，不要只有散落 if/else
2. 进入高自动化 mode 前，先剥离会绕过仲裁的旧规则
3. 离开高自动化 mode 后，要恢复用户原有语义
4. `safetyCheck` 必须有比普通 mode 更高的优先级
5. classifier 应是中段仲裁器，不应是唯一安全依赖

## 13. 一句话总结

Claude Code 的权限系统之所以成熟，不在于它有多少规则，而在于它把 mode 切换、危险规则剥离、tool permission、safetyCheck、fast-path、classifier 和 bypass 做成了一条有顺序的安全状态机；真正重要的不是某个节点，而是这条时序本身。 
