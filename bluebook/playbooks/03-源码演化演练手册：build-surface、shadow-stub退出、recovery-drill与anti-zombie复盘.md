# 源码演化演练手册：build-surface、shadow-stub退出、recovery-drill与anti-zombie复盘

这一章把 `guides/29` 继续推进到运营层。

它主要回答五个问题：

1. 为什么源码先进性最终必须进入演化演练，而不是只停在结构模板。
2. 怎样把 build surface、shadow / stub、transport shell、recovery asset 与 anti-zombie protocol 纳入同一套演练体系。
3. 为什么迁移退出条件和恢复 drill 是结构先进性的正式组成部分。
4. 怎样识别“目录更整齐，但系统更难删除兼容层”的伪进步。
5. 怎样用苏格拉底式追问避免把源码质量退回成审美讨论。

## 0. 代表性源码锚点

- `claude-code-source-code/scripts/prepare-src.mjs:3-64`
- `claude-code-source-code/scripts/stub-modules.mjs:2-42`
- `claude-code-source-code/src/moreright/useMoreRight.tsx:1-25`
- `claude-code-source-code/src/state/AppState.tsx:23-29`
- `claude-code-source-code/src/utils/listSessionsImpl.ts:1-425`
- `claude-code-source-code/src/services/api/emptyUsage.ts:3-16`
- `claude-code-source-code/src/bridge/replBridgeTransport.ts:13-116`
- `claude-code-source-code/src/bridge/sessionIdCompat.ts:1-54`
- `claude-code-source-code/src/bridge/bridgePointer.ts:22-167`
- `claude-code-source-code/src/services/api/sessionIngress.ts:60-120`
- `claude-code-source-code/src/utils/QueryGuard.ts:69-106`
- `claude-code-source-code/src/utils/task/framework.ts:160-248`

这些锚点共同说明：

- Claude Code 的源码先进性不只在于结构当下合理，还在于它愿意把兼容层退出、恢复演练与 zombie 故障模型写进长期演化制度。

## 1. 第一性原理：源码先进性为什么必须进入运营层

从第一性原理看，先进源码真正难的不是：

- 把当前目录排得好看

而是：

- 在新增能力、引入兼容层、发生恢复事故、删除历史包袱时，仍然让结构继续说真话

因此成熟代码库最终必须能回答：

1. 哪个 shadow / stub 还是过渡层，什么时候退出。
2. 哪个 transport 分叉仍被关在 shell 里，哪个已经泄漏。
3. 哪个恢复资产一旦损坏，会直接导致 zombie 状态。

## 2. 演化风险分类

源码层最常见的演化事故，不是“代码有点乱”，而是：

```text
1. shadow fossilization
- 影子实现本来为入口隔离存在，最后变成永久第二实现

2. stub becoming truth
- stub / compat 层本来为过渡存在，最后反过来定义公共真相

3. transport leakage
- 本应只在 construction site 处理的协议差异渗进业务层

4. registry obesity
- 原本薄的高扇入节点偷偷长成第二业务中心

5. recovery-asset corruption
- pointer / cursor / last-uuid / merge rule 失真

6. zombification
- stale snapshot / stale finally / stale append 复活旧对象
```

## 3. 演化前审读仪式

任何结构性改动在合入前都先过这六问：

```text
[ ] 这条能力进入哪个 build surface
[ ] 它是否新增了 shadow / stub / compat
[ ] 这个新增层的退出条件是什么
[ ] transport 差异是否仍被关在 shell 里
[ ] recovery asset 是否被影响
[ ] 是否引入新的 zombie 风险
```

如果这六问答不清，代码即使短期能跑，长期也会越来越难演进。

## 4. Shadow / Stub 退出台账

所有过渡层都应登记：

```text
名称:
为什么存在:
服务哪个入口或 build surface:
退出条件:
退出前验证项:
计划删除时间:
```

重点不是“今天删不删”，而是：

- 团队是否仍然知道它本来就该被删

## 5. Recovery Drill

恢复演练至少要包含三类：

```text
演练 1:
- bridge pointer / continue path 是否仍然可恢复

演练 2:
- session ingress 遇到旧 cursor / 409 adopt 时是否仍选择权威真相

演练 3:
- 本地 query 或 task 遇到 stale finally / stale snapshot 时是否拒绝旧状态回写
```

没有 drill，recovery 只是静态设计；有 drill，recovery 才是活制度。

## 6. Anti-Zombie Postmortem

任何 stale-state 事故都先按这张表复盘：

```text
旧对象来自哪里:
- await 前快照
- finally
- remote append
- retry state

它污染了什么:
- in-flight state
- terminal state
- pointer / cursor
- UI 派生状态

为什么没有被挡住:
- generation 未检查
- fresh merge 未采用
- stale drop 规则缺失

如何防再发:
- 增加 merge rule
- 增加 stale-drop
- 增加 drill case
```

真正的重点不是定位某个 bug，而是确认：

- 系统有没有把 zombification 当作正式故障模型

## 7. Structure Anti-Pattern Library

长期应维护一张反模式库：

```text
1. 入口为图方便直接 import 主实现
2. transport 版本差异扩散到业务层
3. registry 同时做注册和业务
4. stub / compat 没有退出条件
5. 恢复逻辑只靠注释，没有 drill
6. stale snapshot 能覆盖 current truth
```

有了这张库，结构评审才会从“审美评论”升级为“演化判断”。

## 8. 苏格拉底式追问

在你准备继续“优化结构”前，先问自己：

1. 我是在增加秩序，还是只是在隐藏复杂度。
2. 这个 shadow / stub 是隔离层，还是正在长成新真相。
3. transport 差异是否仍被困在 shell 里。
4. 恢复资产是否已经被正式登记和演练。
5. 我是在消灭 zombie，还是在制造更隐蔽的 zombie。

## 9. 一句话总结

源码先进性的终局不是“结构很漂亮”，而是 build surface、兼容层退出、恢复 drill 和 anti-zombie protocol 都被正式运营起来。
