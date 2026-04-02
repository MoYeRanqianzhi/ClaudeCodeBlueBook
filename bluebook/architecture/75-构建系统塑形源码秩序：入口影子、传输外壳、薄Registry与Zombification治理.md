# 构建系统塑形源码秩序：入口影子、传输外壳、薄Registry与Zombification治理

这一章回答五个问题：

1. 为什么源码先进性不该只从目录整洁度和分层图来判断。
2. 为什么 external stub、portable shadow entry、transport shell、薄 registry 与恢复治理应被放在同一条线上。
3. 为什么构建系统本身也在塑造模块图、发布面和入口安全。
4. 为什么恢复路径会反向塑造平日的状态写法。
5. 这对 agent runtime 设计者意味着什么。

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

## 1. 先说结论

Claude Code 的源码秩序不是只靠运行时机制维持的。

更深一层，它由四种结构动作共同塑形：

1. 构建系统塑形发布面：
   - 决定哪些边能进入公开图谱。
2. 入口影子保护入口安全：
   - 不同入口拿到不同重量级的 implementation shadow。
3. transport shell 吃掉协议分叉：
   - 把 v1/v2、不同 transport 的分歧关进统一外壳。
4. 恢复治理反向约束日常写法：
   - stale state、zombification 和 crash recovery 先被设计，平时状态更新才敢简化。

这四层放在一起，才构成 Claude Code 更成熟的：

- source-order shaping control plane

## 2. 构建系统塑形发布面：哪些边根本不该进入公开图谱

`useMoreRight.tsx` 和 `AppState.tsx` 最有价值的地方，不在它们实现了什么，而在它们限制了什么：

1. external build stub 会直接替换某些 internal-only 路径；
2. ant-only passthrough 让 DCE 成为正式结构工具；
3. back-compat re-export 又把迁移期兼容壳限制在局部。

这说明 Claude Code 不把构建看成：

- 写完代码之后的打包步骤

而是：

- 主动塑形发布面和模块图的架构动作

从底盘角度看，这一步解决的是：

1. 哪些内部能力必须在外部构建中彻底消失；
2. 哪些依赖边不能进入公开图谱；
3. 哪些兼容层必须保留，但只能作为局部 costume。

真正成熟的仓库，不会等到最后打包时才发现图谱已经失控，而会让构建制度本身参与：

- 限制未来失控的方式

## 3. portable shadow entry：同一语义，不同厚度的合法实现

`listSessionsImpl.ts` 和 `EMPTY_USAGE` 的价值不是复用，而是：

- 给不同入口提供可承受的实现影子

具体来说：

1. `listSessionsImpl.ts` 强调自己可从 SDK 入口安全导入，不触发 CLI 初始化；
2. `EMPTY_USAGE` 被从重模块图里单独抽出来，避免 bridge 路径反向把整个世界拉进来。

这说明 Claude Code 不在追求：

- 所有入口都 import 同一个完整真身

它更在意：

- 保持同一语义的同时，不污染入口的依赖图与初始化副作用。

从底盘视角看，这是一种非常成熟的入口设计：

- portable shadow entry

也就是说，同一能力可以有：

1. 同一份语义合同；
2. 针对不同入口的不同厚度实现影子。

## 4. transport shell：协议分叉要被吃进外壳，而不是蔓延进业务层

`replBridgeTransport.ts` 的重要性，不在 transport 本身，而在：

- 它把 transport 分叉限制在 construction site

文件里明确把：

1. v1 HybridTransport；
2. v2 SSETransport + CCRClient；
3. state / metadata / delivery 补充通道；
4. flush / dropped batch / sequence number 等差异。

全部收口到同一个 `ReplBridgeTransport` 表面。

这说明 Claude Code 对协议演化的处理，不是：

- 不同 transport 各写一套业务逻辑

而是：

- 让 transport 变成外壳，语义层继续稳定

这和 Prompt Constitution 很像：

1. 载体可以变；
2. 不变语义必须继续稳定。

从底盘设计上，这非常关键，因为一旦 transport 分叉穿透进业务层，整个仓库就会开始出现：

- 平行 runtime

而 Claude Code 显然在主动避免这一点。

## 5. 薄 Registry：高扇入节点只能承担装配秩序，不能顺手吞业务

`cleanupRegistry.ts` 与 swarm backend `registry.ts` 体现的是一条很硬的纪律：

- 高扇入 registry 必须足够薄

它们做的事非常有限：

1. 保存 cleanup handler；
2. 保存 backend class slot；
3. 提供最小构造逻辑；
4. 在注释里直接写明切环目的。

这说明 Claude Code 并不把 registry 当成：

- 更强大的公共层

而是：

- 只负责注册和转运的 chokepoint

一旦这类节点开始顺手长业务，它就会变成：

1. 高扇入；
2. 高耦合；
3. 高误改风险；
4. 第二业务中心。

而 Claude Code 显然在主动防止这一点发生。

## 6. 恢复先于写法：恢复路径会反向塑造日常状态更新

`bridgePointer.ts`、`sessionIngress.ts` 和 `task/framework.ts` 揭示了另一层更深的结构关系：

- 恢复制度会反向塑造日常写法

体现在三类场景：

1. bridge pointer：
   - pointer 不是附属日志，而是按 repo 作用域、按 mtime 刷新、worktree-aware fanout 的 crash-recovery 资产；
2. session ingress：
   - `Last-Uuid` / 409 recovery 让客户端必须承认 stale append state 是正式问题；
3. task framework：
   - against fresh state merge 明确写出，旧快照回写 fresh 任务态会 zombify the task。

这说明 Claude Code 真正在治理的不是：

- 某个 race bug

而是：

- 跨 await、跨 transport、跨进程对象命运如何不撒谎

从底盘角度看，这一点非常高级，因为它让开发者在平时写状态更新时就知道：

- 哪些写法未来一定会毁掉恢复

## 7. zombification 治理：stale state 是正式敌人

`task/framework.ts` 把 stale snapshot clobber terminal transition 直接命名成：

- zombifying the task

这说明 Claude Code 对 stale state 的理解不是：

- 普通边角 bug

而是：

- 一类会把“已死对象重新写活、并污染当前真相”的正式风险

配合：

1. against fresh state merge；
2. session ingress 409 adoption；
3. pointer freshness / stale clearing；

Claude Code 其实已经形成了一整套：

- zombification governance

这是一种比“处理并发问题”更高级的说法，因为它直接指出了真正危险的后果：

- 当前真相被过时对象复活后污染。

## 8. 为什么这是一块正式控制面，而不是工程附属层

把以上几层放在一起看，Claude Code 做的不是“改善工程细节”。

它是在主动塑造源码秩序：

1. build system 决定哪些边有资格进入发布面；
2. shadow entry 决定不同入口怎样安全导入；
3. transport shell 决定协议分叉如何不扩散；
4. thin registry 决定高扇入节点如何保持克制；
5. recovery / zombification governance 决定平时状态写法必须遵守哪些约束。

这五层共同构成的，正是 Claude Code 更高级的：

- source-order shaping control plane

## 9. 一句话总结

Claude Code 的源码先进性不只在运行时设计，还在于它让构建系统、入口影子、传输外壳、薄 registry 与 zombification 治理一起塑造源码秩序，从而让仓库在持续增长中更不容易失控。
