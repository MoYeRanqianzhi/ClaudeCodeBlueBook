# 如何用构建系统塑形Agent Runtime：入口影子、transport shell、薄registry与反zombification

这一章回答五个问题：

1. 如果你在做自己的 agent runtime，为什么构建系统也该被当成架构工具。
2. 怎样把 external stubs、portable shadow entry、transport shell、薄 registry 和恢复治理写成同一套工程动作。
3. 为什么恢复路径应先于某些日常状态写法被设计出来。
4. 为什么 stale state 不只是 race bug，而应被视为 zombification 风险。
5. 怎样用苏格拉底式追问避免把源码先进性重新写回“目录更漂亮”。

## 0. 代表性源码锚点

- `claude-code-source-code/src/moreright/useMoreRight.tsx:1-25`
- `claude-code-source-code/src/state/AppState.tsx:12-23`
- `claude-code-source-code/src/utils/listSessionsImpl.ts:1-27`
- `claude-code-source-code/src/services/api/emptyUsage.ts:3-16`
- `claude-code-source-code/src/services/compact/compactWarningHook.ts:1-20`
- `claude-code-source-code/src/utils/queryContext.ts:1-87`
- `claude-code-source-code/src/utils/cleanupRegistry.ts:1-21`
- `claude-code-source-code/src/utils/swarm/backends/registry.ts:81-114`
- `claude-code-source-code/src/bridge/replBridgeTransport.ts:13-116`
- `claude-code-source-code/src/bridge/bridgePointer.ts:22-120`
- `claude-code-source-code/src/services/api/sessionIngress.ts:60-120`
- `claude-code-source-code/src/utils/task/framework.ts:160-248`

这些锚点共同说明：

- Claude Code 的源码秩序不只靠运行时逻辑维持，还靠构建制度、入口影子、transport 外壳、薄 registry 和反-zombie 恢复治理一起塑形。

## 1. 先说结论

更成熟的工程做法，不是：

- 先写完代码，再想怎么打包、怎么恢复、怎么切层

而是：

1. 先决定不同发布面允许哪些边存在。
2. 先给不同入口设计各自可承受的 implementation shadow。
3. 先把 transport 分叉收进统一外壳。
4. 先把高扇入 registry 保持足够薄。
5. 先把恢复与 stale-state 风险写进日常状态更新规则。

如果你把这五件事做了，代码库才会真的被：

- 构建系统塑形

而不是只是“源码碰巧还能工作”。

## 2. 第一步：先画发布面矩阵，而不是先写所有实现

Claude Code 的 external stub 和 DCE 设计告诉你的第一件事是：

- 不同发布面不该共享同一张依赖图

所以先做一张矩阵：

```text
Build Surface Matrix
- external build 允许哪些模块
- internal build 才允许哪些模块
- 哪些路径必须由 stub 代替
- 哪些 re-export 只为迁移期兼容保留
```

团队动作：

1. 每新增 internal-only 能力，就同时指定 external stub 策略。
2. 每新增 feature gate，就问这条边是否该在外部构建中彻底消失。
3. 每次做 re-export，都写清 migration 结束后要删除。

真正高级的地方不是“打包成功”，而是：

- 发布面先于实现被制度化

## 3. 第二步：给不同入口设计 implementation shadow

`listSessionsImpl.ts` 和 `EMPTY_USAGE` 给 builder 的一个直接启发是：

- 同一语义可以有不同厚度的合法实现

你可以把它写成一条团队规则：

```text
Entry Shadow Policy
- CLI 主路径可依赖完整实现
- SDK / bridge / lightweight path 只拿 portable shadow
- shadow 必须保持同一语义，但禁止拉入重初始化和重依赖
```

落地动作：

1. 为安全导入要求高的入口提供轻量实现。
2. 不强求所有入口 import 同一个“真身”。
3. 如果某个入口一导入就会触发整个 CLI 世界，立刻抽 shadow。

这样做的收益是：

- 入口安全从“开发者记得小心”变成“结构上不容易出错”

## 4. 第三步：把 transport 分叉收进 shell，而不是到处扩散

`replBridgeTransport.ts` 最值得迁移的不是某个 v1/v2 细节，而是它的结构方法：

- transport 差异被限制在 construction site

你在自己的 runtime 里也可以先做一个统一 transport shell：

```text
Transport Shell
- 统一 write / writeBatch / close / connect
- 统一 state / metadata / delivery reporting
- 各 transport 的差异只在 shell 内部展开
```

团队规则：

1. transport 协议分叉不得直接扩散进业务层。
2. transport 适配层只负责吃掉差异，不负责长新业务。
3. 任何新的 transport 都必须先接进 shell，再进入更高层。

如果不这么做，你的仓库很快就会长出：

- REPL 一套 runtime
- remote 一套 runtime
- SDK 又一套 runtime

## 5. 第四步：让 registry 只做注册，不顺手长业务

Claude Code 的 `cleanupRegistry.ts` 和 backend `registry.ts` 很值得抄的一点是：

- 高扇入 registry 只承担最小装配职责

可以直接写成 review rule：

```text
Thin Registry Rule
- registry 只保存注册项
- registry 只做最小构造
- registry 不长业务逻辑
- registry 必须写清切环动机
```

团队动作：

1. 一旦 registry 开始知道太多业务语义，就拆回边缘。
2. registry 改动要被视作高扇入改动，单独 review。
3. registry 一定要薄到别人敢放心 import。

这样做的核心收益不是整洁，而是：

- 中心节点不会无声变胖

## 6. 第五步：先设计恢复资产，再写日常状态更新

`bridgePointer.ts`、`sessionIngress.ts`、`task/framework.ts` 共同说明：

- 恢复不是补丁，而是状态写法的上游约束

所以在你写状态管理之前，先列恢复资产：

```text
Recovery Assets
- crash pointer
- last-seen cursor / uuid
- fresh-state merge rule
- stale epoch drop rule
```

然后反过来问：

1. 现在的状态写法会不会破坏这些资产。
2. 有没有旧快照可能在 await 后回写 fresh state。
3. 有没有 stale client state 会被误当最新真相。

如果答案是会，你就不是在写功能，而是在提前制造恢复债。

## 7. 第六步：把 zombification 当成正式敌人

Claude Code 对 stale state 的最值得抄的一点是：

- 它直接把风险命名出来

`task/framework.ts` 不是说“有点竞态”，而是说：

- 旧快照回写会 zombify the task

这给 builder 的启发非常直接：

1. 对 stale write 风险要起正式名字。
2. against fresh state merge 应成为默认模式。
3. 任何跨 await 回写都要先验证对象是否仍处于当前代。

可以沉淀成一条硬规则：

```text
Anti-Zombie Rule
- 不允许全量 stale snapshot 回写 fresh object
- 只合并 patch，不覆盖 fresh state
- 任何 terminal transition 都要防止被旧对象复活污染
```

这不是“更仔细一点”，而是：

- 把对象命运纳入结构治理

## 8. Source-Order Shaping 设计卡

```text
1. Build Surface Matrix
- 哪些边能进入哪个发布面

2. Entry Shadow Policy
- 哪些入口必须用 portable shadow

3. Transport Shell
- transport 分叉只允许在外壳内展开

4. Thin Registry Rule
- registry 只注册，不长业务

5. Recovery Assets
- pointer / cursor / fresh-merge / stale-drop

6. Anti-Zombie Rule
- stale snapshot 不得复活当前对象
```

## 9. 苏格拉底式检查清单

在你准备继续加模块、加 transport 或加入口前，先问自己：

1. 这条边真的配进入当前发布面吗。
2. 这个入口是否应该拿一个更轻的 shadow，而不是完整真身。
3. transport 差异是否被困在 shell 里，还是已开始蔓延。
4. 这个 registry 是在注册，还是正在变成第二业务中心。
5. 这段状态写法会不会在恢复时把旧对象写活成 zombie。

如果这些问题答不清，源码先进性很快就会退回“目录还行，但仓库越来越重”。

## 10. 一句话总结

Claude Code 值得学的，不是目录多好看，而是怎样用构建系统、入口影子、transport shell、薄 registry 和反-zombification 规则一起塑形整个 agent runtime 的源码秩序。
