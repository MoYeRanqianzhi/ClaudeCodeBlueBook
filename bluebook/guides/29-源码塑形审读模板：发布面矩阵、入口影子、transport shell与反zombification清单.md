# 源码塑形审读模板：发布面矩阵、入口影子、transport shell与反zombification清单

这一章把 `guides/26` 继续压成结构审读层，目标不是再解释“构建系统也是架构工具”，而是让团队知道怎样评审一个 runtime 是否真的适合演进。

它主要回答五个问题：

1. 怎样判断一条新能力该进哪个发布面、哪个入口、哪种壳层。
2. 怎样评审 portable shadow、transport shell、thin registry 是否被写对。
3. 怎样把 recovery asset 与 anti-zombie protocol 当成正式结构资产。
4. 怎样识别“目录更好看，但系统更难演进”的伪优化。
5. 怎样用苏格拉底式追问避免把源码先进性退回审美评论。

## 0. 代表性源码锚点

- `claude-code-source-code/scripts/prepare-src.mjs:3-64`
- `claude-code-source-code/scripts/stub-modules.mjs:2-42`
- `claude-code-source-code/src/moreright/useMoreRight.tsx:1-25`
- `claude-code-source-code/src/utils/listSessionsImpl.ts:1-425`
- `claude-code-source-code/src/services/api/emptyUsage.ts:3-16`
- `claude-code-source-code/src/bridge/replBridgeTransport.ts:13-116`
- `claude-code-source-code/src/bridge/sessionIdCompat.ts:1-54`
- `claude-code-source-code/src/bridge/bridgePointer.ts:22-167`
- `claude-code-source-code/src/services/api/sessionIngress.ts:60-120`
- `claude-code-source-code/src/utils/cleanupRegistry.ts:1-21`
- `claude-code-source-code/src/utils/toolPool.ts:43-124`
- `claude-code-source-code/src/utils/QueryGuard.ts:69-106`
- `claude-code-source-code/src/utils/task/framework.ts:160-248`

这些锚点共同说明：

- Claude Code 的先进性不只体现在运行时逻辑，还体现在 build surface、portable entry、transport confinement、recovery asset 与 anti-zombie protocol 一起塑形整个代码库。

## 1. Build Surface Matrix

任何新增能力先填发布面矩阵：

```text
能力名称:
external build 是否可见:
internal build 是否可见:
是否需要 stub:
是否需要 shadow entry:
哪些依赖禁止进入公共发布面:
```

团队规则：

1. 新能力先决定进入哪个发布面，再决定写法。
2. internal-only 依赖若进入公共面，必须显式 stub 或切 shadow。
3. re-export 若只为迁移保留，要写删除条件。

## 2. Entry Shadow Card

把 portable shadow 当正式设计对象：

```text
入口:
- CLI main
- SDK
- bridge
- background / utility read path

当前入口需要的最小语义:
为什么不能直接 import 主实现:
shadow 是否保持同一语义:
它避免了哪些重依赖:
```

经验规则：

1. 入口共享的是可承受的影子实现，不是主实现真身。
2. 一导入就触发整条 CLI 世界的路径，应优先抽 shadow。
3. shadow 可以更薄，但不能偷偷改语义。

## 3. Transport Shell Confinement Checklist

任何协议代际分叉都先关进 shell：

```text
[ ] connect / write / close 是否有统一表面
[ ] transport 差异是否只在 construction site 展开
[ ] delivery reporting 是否统一
[ ] metadata / state writeback 是否统一
[ ] 新 transport 是否先接进 shell，再进入业务层
```

如果做不到这一点，仓库很快会长出：

- REPL 一套 runtime
- remote 一套 runtime
- SDK 又一套 runtime

## 4. Thin Registry Review

高扇入 registry 必须单独审：

```text
[ ] registry 是否只保存注册项
[ ] registry 是否只做最小构造
[ ] registry 是否偷偷长业务
[ ] registry 是否写清切环动机
[ ] import 它是否仍然安全
```

中心节点最危险的不是大，而是：

- 悄悄变成第二业务中心

## 5. Recovery Asset Ledger

恢复资产必须早于日常写法被定义：

```text
资产:
- bridge pointer
- session pointer / cursor
- last uuid
- fresh-state merge rule
- stale-drop rule

生成位置:
读写时机:
过期策略:
恢复时谁是权威:
```

这张台账的意义是反向约束日常代码：

1. 新状态写法不能破坏恢复资产。
2. 新对象语义不能让旧快照复活当前对象。
3. “恢复先成立”比“平时写起来方便”更重要。

## 6. Anti-Zombie Protocol

把 stale write 风险正式命名：

```text
[ ] 是否存在跨 await 的全量旧对象回写
[ ] 是否默认 against fresh state merge
[ ] terminal state 是否可能被旧快照复活
[ ] generation / epoch 是否被检查
[ ] finally 块是否会污染当前真相
```

Claude Code 值得抄走的不是“更小心”，而是：

- 直接把 zombification 当成正式故障模型

## 7. Structure Design Review Template

审一个新能力时，先答这四问：

```text
1. 它应进入主循环、旁路 service、shadow entry 还是 transport shell
2. 它应暴露在哪个 build surface
3. 它新增的恢复资产是什么
4. 它会不会引入新的 zombie 风险
```

只有这四问答清了，才值得讨论目录与模块边界。

## 8. Evolution Checklist

```text
[ ] build surface 已定义
[ ] stub / shadow 策略已定义
[ ] transport confinement 已定义
[ ] registry 变化已单独审读
[ ] recovery assets 已登记
[ ] anti-zombie 保护已就位
[ ] 诊断钩子或观测点已就位
```

## 9. 反模式清单

看到下面信号时，应提高警惕：

1. portable 入口反向拉入整条重依赖链。
2. transport 协议差异穿透到业务层。
3. registry 越写越懂业务。
4. React / UI 依赖污染纯状态核。
5. stale snapshot 在 await 之后直接覆盖 current state。

## 10. 苏格拉底式检查清单

在你准备继续“重构得更漂亮”前，先问自己：

1. 这条边真的该进入当前发布面吗。
2. 这个入口是否更适合影子实现而不是主实现。
3. transport 差异是否被关在 shell 里。
4. recovery asset 是否已经先于日常写法被定义。
5. 我是在消灭 zombie，还是在制造更隐蔽的 zombie。
