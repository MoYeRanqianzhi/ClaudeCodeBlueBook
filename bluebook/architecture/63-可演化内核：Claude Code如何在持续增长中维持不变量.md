# 可演化内核：Claude Code如何在持续增长中维持不变量

这一章回答五个问题：

1. 为什么 Claude Code 的源码先进性不只在当前结构，而在它显露出的演化方法。
2. 为什么 `query/config.ts`、`query/deps.ts`、`QueryGuard`、freshness gate、leaf modules 这些细节透露出“可演化内核”的意识。
3. 为什么真正成熟的源码不只是今天能跑，而是增长时仍能守住不变量。
4. 为什么这套方法比“先拆很多模块”更值得学。
5. 这条线如何把 contract-first、race-aware、authoritative surface 继续统一到更高层。

## 0. 代表性源码锚点

- `claude-code-source-code/src/query/config.ts:1-43`
- `claude-code-source-code/src/query/deps.ts:1-37`
- `claude-code-source-code/src/utils/QueryGuard.ts:1-108`
- `claude-code-source-code/src/utils/toolSchemaCache.ts:1-20`
- `claude-code-source-code/src/query.ts:265-420`
- `claude-code-source-code/src/utils/messages.ts:1989-2045`
- `claude-code-source-code/src/cli/transports/WorkerStateUploader.ts:1-118`
- `claude-code-source-code/src/bridge/remoteBridgeCore.ts:477-560`

## 1. 先说结论

Claude Code 的源码最值得继续上升一层理解的地方，是它显然不是在写：

- 一个一次性长成的实现

它更像在写：

- 一个允许持续增长、但增长时仍能守住关键不变量的内核

如果再压缩一句，它其实在做：

- agent runtime 的熵治理

这套方法可以压成四个动作：

1. 把真正不会频繁变化的东西冻结成 config。
2. 把 I/O 和外部副作用显式抽成 deps。
3. 把高风险时序压进 chokepoint / state machine。
4. 把清理、缓存、cycle-cutting 这些脏活显式承认成基础设施。

所以 Claude Code 值得学的，不只是它“现在长什么样”，而是它“准备如何继续长”。

## 2. `query/config.ts` 透露的是增长治理

`query/config.ts` 的注释非常关键：

- immutable values snapshotted once at query() entry
- separating config from mutable state makes future step() extraction tractable

这段话说明作者在做的不是简单抽文件，而是在提前为未来的：

- pure reducer
- step extraction
- state/event/config 分离

铺路。

换句话说，当前实现还没完全变成 reducer，但内核已经开始被往那个方向整理。

这是一种很成熟的信号：

- 先在边界上为未来留出生长接口
- 而不是等复杂度炸开后再全仓重构

更硬一点说，这类 seam 若还答不出第一条局部 veto 与第一退回层，就还只是 extraction hint，不配被 later maintainer 当成可继承的 `next-refactor entry`。

## 3. `query/deps.ts` 透露的是可测试、可替换、可迁移意识

`query/deps.ts` 不是传统意义上的“为了优雅而依赖注入”。

它的注释同样直白：

- 让测试直接注入 fake
- 避免 module-import-and-spy boilerplate
- narrow scope to prove the pattern

这说明作者的取向很清楚：

- 先从最痛的点开始抽依赖
- 用最小模式验证路径
- 以后再扩大

这是一种非常工程化的演化方法：

- 不一次性抽象全部
- 先抽最值钱、最可验证的一小圈

所以 Claude Code 的先进性，不只是“懂依赖注入”，而是：

- 知道应该在哪些地方先注入，以换取最大未来收益

## 4. `QueryGuard` 透露的是“增长时先保护状态机”

`QueryGuard` 值得学的地方不只是它的三个状态：

- `idle`
- `dispatching`
- `running`

更关键的是，它说明作者知道：

- 一旦系统继续增长，最容易烂掉的不是函数拆分，而是状态迁移

所以它优先把：

- generation
- stale finally 防护
- 同步快照
- 强制结束

收进一个小而强的权威状态机里。

这意味着后续再长更多 feature 时，至少 query lifecycle 这根主梁不会继续靠分散 flag 勉强维持。

## 5. leaf module 与基础设施注释透露的是“演化时先保住图”

`toolSchemaCache.ts` 的注释直接写出：

- 为什么它 lives in a leaf module
- 它在防什么 import cycle

这说明 Claude Code 并不把 cycle-cutting 当成“重构后再美化一下”的卫生工作。

它把这类问题当成：

- 演化中的图结构治理

同理，`WorkerStateUploader`、`normalizeMessagesForAPI()`、`remoteBridgeCore` 这些文件，也都在承担类似角色：

- 不是业务 feature
- 而是未来功能继续叠加时，防止真相和时序失控的底盘

## 6. 可演化内核还会显式处理 stale worldview 与 ghost capability

真正成熟的 anti-stale，不只处理：

- stale finally
- stale async work
- stale snapshot

它还会继续往下处理两类更隐蔽的失真：

1. `stale worldview`
   - validator、adapter、host consumer 看到的命名空间、cwd、可见集已经落后于 runtime 当前世界
2. `ghost capability`
   - 旧 display pin、旧 capability token、旧 authority width 仍在冒充 live authority

所以可演化内核不会只做“状态迁移正确”。

它还会要求：

1. worldview freshness
   - validator 一旦发现自己站在 stale namespace 上，就应降级为 `ask / deny`，而不是继续 auto-allow
2. per-host authority width
   - 不同 host / consumer 只能消费属于自己的 authority surface，不能把 event stream、writeback、pointer 混成一份真相
3. dead capability eviction
   - recovery asset 可以帮助恢复，但不能继续冒充 live authority；语义已死的 capability token 必须 eviction 或 freeze

这也是为什么 `authoritative surface` 真正成熟时，不只是在说“有单一真相”，而是在说：

- 单一真相怎样按 host / consumer 被切成不同宽度
- 哪些恢复资产只是恢复辅助，不是继续执政的权威

### 6.1 什么时候它已经不再可演化

如果继续把“可演化内核”写成 later maintainer 可执行的失效判据，最少还要继续追问：

1. `config`
   - 一旦开始夹带 mutable truth，它就不再是 config，而是隐蔽状态面。
2. `deps`
   - 一旦开始吞并跨域对象与全局上下文，它就不再是窄依赖盒，而是 service locator 回潮。
3. `leaf module`
   - 一旦重新拿到 runtime context、初始化副作用或双向依赖，它就不再是 leaf，而是伪 seam。
4. `recovery asset`
   - 一旦能直接宣布 present truth，它就已从恢复辅助篡位成第二主权面。

更稳的 later maintainer 最小 reject 规则也应写清：

1. 看见 shim 没有退出条件，就先撤回这次结构升级。
2. 看见 snapshot 可直接回写主状态，就先撤回这次结构升级。
3. 看见旧 capability token、旧 pin、旧 authority width 还能继续放权，就先把升级退回到 freshness / eviction / boundary 层。

“可演化”也不能只写成方向，它必须带回退协议：

- 哪个指标坏了先退哪一层。
- 哪些 shadow 资产必须保留到哪一步。
- 哪些恢复辅助对象在 cutover 前永远不能拿到 present-truth 主权。

## 7. 为什么这条线统一了前面那些“先进性方法”

前面已经把 Claude Code 的先进性总结成：

- chokepoint
- typed decision
- authoritative surface
- race-aware runtime
- contract-first

如果再往上收一层，它们其实都在服务同一个目标：

- 让系统在持续增长时，关键不变量仍然有固定落点

也就是让：

- 真相
- 转移
- 边界
- 依赖
- worldview
- capability freshness

六类最容易在增长中失控的对象，继续被固定在可推理的边上。

更具体地说：

1. chokepoint
   - 防止新增 feature 把优先级打散。
2. typed decision
   - 防止新增状态把迁移关系揉成布尔泥。
3. authoritative surface
   - 防止新增入口把协议真相写裂，也防止不同 host 拿错 authority width。
4. race-aware runtime
   - 防止新增异步路径把时序击穿，也防止旧 epoch / stale finally 假装自己仍然有效。
5. contract-first
   - 防止新增能力把宿主和模型共同语言搞漂。
6. stale worldview guard
   - 防止 validator / adapter 站在过期世界里继续签发允许。
7. ghost capability eviction
   - 防止 dead capability token、dead pin、dead grant 在恢复后继续冒充 live authority。

所以这些不是几个孤立技巧，而是：

- 同一套“增长中守不变量”的内核方法

## 8. 为什么这比“先拆很多模块”更值得学

很多团队遇到复杂度上升，第一反应是：

- 拆目录
- 拆文件
- 加抽象层

Claude Code 更成熟，因为它更先问：

- 这次增长会威胁哪个不变量
- 应该把哪个边界先变成正式基础设施
- 哪个 validator / host / capability token 已经不再有资格继续说“当前世界是什么”

如果没有这一步，拆得再漂亮也可能只是：

- 结构更细
- 真相更散
- 演化更难

而 Claude Code 现在显露出来的思路是：

- 先把增长风险写进底盘
- 再让结构慢慢跟上

这也是为什么它更像一个：

- 持续重写熵边界的 runtime

而不是：

- 一次性做完的功能拼盘

## 9. 一句话总结

Claude Code 的源码先进性，真正值得学的不是某一次漂亮分层，而是它在持续增长中不断把 config、deps、state machine、freshness gate、worldview guard、ghost capability eviction 和权威面收成内核，让不变量始终有地方可守。
