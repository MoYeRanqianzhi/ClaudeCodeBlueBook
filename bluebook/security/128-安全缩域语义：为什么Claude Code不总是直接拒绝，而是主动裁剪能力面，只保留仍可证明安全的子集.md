# 安全缩域语义：为什么Claude Code不总是直接拒绝，而是主动裁剪能力面，只保留仍可证明安全的子集

## 1. 为什么在 `127` 之后还必须继续写“缩域语义”

`127-安全失败语义三分法` 已经回答了：

`Claude Code 不把所有失败都压成 deny，而是按风险对象选择 fail-open、fail-closed 与 step-up。`

但如果继续追问，  
还会碰到一个更细、更像工程内核的问题：

`当系统既不想完全放开，也不想完全拒绝时，它会做什么？`

源码给出的答案是：

`它会缩域。`

也就是：

1. 不直接说“不行”
2. 也不保留完整能力面
3. 而是主动裁掉未经高信任边界承认的那部分能力
4. 只留下仍可证明安全的子集

所以 `127` 之后必须继续补出的下一层就是：

`安全缩域语义`

也就是：

`Claude Code 的安全设计不只会 allow、deny、step-up，还会主动 de-scope：把系统压回一个更窄但仍可继续运行的能力空间。`

## 2. 最短结论

Claude Code 安全设计真正高级的一点是：

`它经常不把风险对象二元化成“全有或全无”，而是先削掉不安全的边缘，再保留中间可证明部分。`

从源码看，至少有六类典型缩域：

1. auto mode 进入前先 strip 掉会绕过 classifier 的危险 allow 规则  
   `permissionSetup.ts:510-579`
2. sandbox 网络侧可切到只承认 managed settings 的 `allowedDomains`，其余来源的 allow 被忽略  
   `sandboxTypes.ts:18-24`
3. sandbox 文件侧可切到只承认 `policySettings.allowRead` 的 managed read paths  
   `sandboxTypes.ts:78-83`
4. 当 `allowUnsandboxedCommands=false` 时，`dangerouslyDisableSandbox` 参数被完全忽略，命令仍必须在 sandbox 中跑  
   `sandboxTypes.ts:113-119`
5. MCP project/plugin server 不是全量接入，而是先过 approved / policy / disabled / dedup 过滤  
   `mcp/config.ts:1164-1245`
6. plugin agent 里 `permissionMode/hooks/mcpServers` 等高风险 frontmatter 字段即便写了也会被忽略；被 managed settings 锁住的 `--plugin-dir` 副本也会被忽略  
   `loadPluginAgents.ts:153-165`; `pluginLoader.ts:3030-3043`

所以这一章的最短结论是：

`Claude Code 很多时候不是在说“这项能力不能存在”，而是在说“这项能力只能以更窄、更受控的形态存在”。`

再压成一句：

`不是全禁，而是缩域。`

## 3. 第一性原理：为什么缩域比直接 deny 更高级

因为很多高风险能力并不是非黑即白。

例如：

1. 权限规则不是必须全关掉，危险 allow 可以先拿掉
2. 网络不是必须全封，只保留 managed allowlist 也可以
3. 文件读不是必须全封，只保留 policySettings 承认的 read paths 也可以
4. MCP 服务器不是必须全禁，只保留 approved / enabled / policy-allowed 的那部分即可

如果系统没有缩域能力，  
它只能在两种粗糙选择之间摇摆：

1. 全开放，风险过大
2. 全拒绝，可用性过低

缩域的高级之处就在于：

`它把“我不能证明整片安全”转成“我只保留我还能证明安全的那一块”。`

这是一种非常成熟的安全哲学。

## 4. auto mode：先删掉危险 allow，再保留 classifier-compatible 子集

`src/utils/permissions/permissionSetup.ts:510-579` 是整个缩域语义最直接的例子。

进入 auto mode 前，  
系统不是简单沿用现有 allow rules，  
而是：

1. 收集 `alwaysAllowRules`
2. 找出 `dangerousPermissions`
3. 记录这些规则来自哪里
4. 调用 `removeDangerousPermissions(...)`
5. 把被删掉的规则 stash 到 `strippedDangerousRules`

离开 auto mode 时，  
再由 `restoreDangerousPermissions(...)` 把它们恢复回来。

这说明系统的判断不是：

`这些规则永久非法`

而是：

`这些规则在 auto/classifier 驱动的高风险上下文里不该继续存在。`

这就是缩域：

1. 不直接 deny 整个 auto mode
2. 也不允许完整权限面进入 auto
3. 而是把它压成 classifier-compatible subset

## 5. sandbox：只承认 managed settings 的子集，而不是全部来源平权

`src/entrypoints/sandboxTypes.ts:18-24` 和 `78-83` 很关键。

这里直接把两种“缩域阀门”写进了 schema：

1. `allowManagedDomainsOnly`
   只尊重 managed settings 的 `allowedDomains` 与 `WebFetch(domain:...)`
   用户、project、local、flag 的 allow 域名会被忽略。
2. `allowManagedReadPathsOnly`
   只使用 `policySettings` 的 `allowRead` 路径。

这两项都不是：

`全部 deny`

而是：

`只保留 managed boundary 承认的那部分 allow surface`

这说明 Claude Code 并不把“来源冲突”简单处理成谁都还能说一点。  
它在高控制场景下会直接把可说话的来源缩减为：

`managed source only`

这是一种非常强的主权收口设计。

## 6. unsandboxed fallback：参数存在，但可能被系统整体降成 no-op

`sandboxTypes.ts:113-119` 更直接：

`allowUnsandboxedCommands=false` 时，`dangerouslyDisableSandbox` 参数会被完全忽略，所有命令都必须继续 sandboxed。

这段很值得注意，  
因为它展示的是另一种缩域：

1. 系统不一定禁掉 BashTool
2. 也不一定禁掉命令执行
3. 而是把“脱离 sandbox 这条更宽的执行路径”整个裁掉

这就是 capability shaping 的典型实现：

`能力保留，逃逸面被切掉。`

## 7. MCP config：project/plugin server 先被缩成 approved subset

`src/services/mcp/config.ts:1164-1245` 是连接面的缩域范式。

作者首先：

1. 只把 `getProjectMcpServerStatus(name) === 'approved'` 的 project server 放进 `approvedProjectServers`

然后又：

1. 只把没被 disable 且 policy-allowed 的 manual server 进入 `enabledManualServers`
2. plugin server 也先分成 enabled / disabled 两组
3. 对 enabled plugin servers 再做 dedup
4. 最后 merge 后再做一次 policy filtering

这整条逻辑说明 MCP 连接面不是：

`发现配置就接`

而是：

`配置先经过多轮缩域，最后只留下 approved + enabled + policy-allowed + non-duplicate 的子集。`

这是一种典型的连接面治理，不是普通配置合并。

## 8. plugin agents：即使字段写了，也不代表你配拥有这层控制

`src/utils/plugins/loadPluginAgents.ts:153-165` 直接把安全边界写得非常清楚：

对于 plugin agents，  
即便 frontmatter 写了：

1. `permissionMode`
2. `hooks`
3. `mcpServers`

这些字段也会被忽略。

理由非常硬：

1. plugin 是第三方 marketplace code
2. 这些字段会让单个 agent file 越过 install-time trust boundary
3. 这一级控制只允许用户显式写在 `.claude/agents/`

这就是一种更细的缩域：

`插件 agent 不是不能存在，但它不能带上那几个会升级能力面的声明。`

再结合 `pluginLoader.ts:3030-3043`：

1. 如果某个 `--plugin-dir` 副本被 managed settings 锁住
2. 那整个副本会被忽略

这说明 marketplace/plugin boundary 里，  
系统也在不断执行同一种哲学：

`不是所有来源都配携带完整能力集合。`

## 9. 技术先进性：Claude Code 真正擅长的是 capability shaping

很多系统的安全设计只会做：

1. 授权
2. 拒绝
3. 升级认证

而 Claude Code 明显多了一层：

`能力塑形`

也就是：

1. 哪些规则保留
2. 哪些来源保留
3. 哪些字段保留
4. 哪些 server 保留
5. 哪条执行路径保留

从这个角度看，  
Claude Code 安全技术的先进性，不只是“控制点多”，  
而是：

`它会把系统主动压回一个仍可运行、但能力面更窄的形态。`

这比简单 deny 更细，比简单 allow 更稳。

## 10. 哲学本质：系统真正保护的是“边界内可继续运行的最小能力面”

把这一章与前面的：

1. 不对称真相
2. 失败语义三分法

合起来看，会得到更深的结论：

Claude Code 安全设计真正守护的，不是：

`功能尽可能多`

也不是：

`功能尽可能少`

而是：

`在当前证明链下，系统还能保留的最小安全能力面。`

这是一种非常强的第一性原理：

`一旦完整能力面无法被证明，就主动缩到还能被证明的子集。`

## 11. 苏格拉底式反思：如果我想把这套缩域哲学继续推进一层，还该问什么

可以继续追问八句：

1. 当前还有哪些二元 deny 路径，其实更适合改造成 de-scope
2. 哪些 de-scope 现在仍然对用户不够可见
3. auto mode 被 strip 的规则是否应显式展示为“已缩域”
4. sandbox managed-only 模式是否应更明确暴露被忽略的来源清单
5. MCP 被 suppressed / policy-blocked / disabled 的 server 是否应统一用同一类 capability-shaping 术语表达
6. plugin agent 被忽略字段是否应进入更强的审计面
7. 当前哪些 fail-closed 其实应先尝试缩域保留最小子集
8. 当前哪些缩域可能会被误解成“功能坏了”，而不是“安全收口”

这些问题共同指向：

`Claude Code 下一代安全产品化，不只要拦得对，还要把“缩掉了什么、为什么缩”讲得更清楚。`

## 12. 一条硬结论

Claude Code 的安全设计之所以先进，  
不只是因为它知道：

1. 何时 `fail-open`
2. 何时 `fail-closed`
3. 何时 `step-up`

还因为它知道：

`何时应该不直接拒绝，而是主动缩窄能力面，只保留仍可证明安全的那一小块。`

这使它保护的从来不只是“能不能做”，  
而是：

`在当前证明链下，系统到底还配保留多少能力。`

