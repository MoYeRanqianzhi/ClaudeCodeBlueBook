# Contract-First审读清单：如何系统读懂Agent Runtime的合同、权威面与热点文件

这一章回答五个问题：

1. 如果你要读 Claude Code 或任意 agent runtime，怎样避免一上来就被热点文件淹没。
2. 怎样把“合同真相”“当前注册”“权威真相入口”“适配器子集”分层看清。
3. 怎样判断某个大文件是在维护不变量，还是只是在堆实现噪音。
4. 怎样把 contract-first 方法写成真正能执行的审读流程。
5. 怎样用苏格拉底式追问防止自己继续脑补缺口。

## 0. 代表性源码锚点

- `claude-code-source-code/src/Task.ts:6-124`
- `claude-code-source-code/src/tasks.ts:1-39`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1-8`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:57-240`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:552-590`
- `claude-code-source-code/src/utils/plugins/pluginStartupCheck.ts:30-90`
- `claude-code-source-code/src/utils/QueryGuard.ts:1-106`
- `claude-code-source-code/src/screens/REPL.tsx:899-907`
- `claude-code-source-code/src/utils/sessionStorage.ts:128-162`
- `claude-code-source-code/src/state/AppStateStore.ts:113-120`
- `claude-code-source-code/src/bridge/bridgeMain.ts:2799-2810`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:28-120`

这些锚点共同说明：

- Claude Code 并没有把真相藏在热点文件深处，很多关键真相早就写在 schema、type union、single-source 注释与 authoritative surface 上。

## 1. 先说结论

contract-first 的最小审读顺序可以压成六步：

1. 先列对象合同。
2. 再列协议合同。
3. 再列当前 registry。
4. 再找 authoritative surface。
5. 再标 adapter subset。
6. 最后才读热点 kernel。

如果这六步顺序被打乱，你很容易犯三种错：

1. 把局部实现误当全局设计。
2. 把声明存在误当当前可用。
3. 把协议全集误当某个入口的实装全集。

## 2. 合同优先审读流程

### 2.1 第一步：列对象合同

先把系统正式承认的对象列出来。

Claude Code 里的典型入口：

1. `Task.ts` 里的 `TaskType / TaskStatus / TaskStateBase / Task`
2. `coreSchemas.ts` 里的 SDK data types single source of truth
3. `controlSchemas.ts` 里的 control request / response union

这一层回答的是：

- 系统承认哪些对象、状态、动作

如果这一层都没列清，后面看任何实现都容易把偶发分支当正式协议。

### 2.2 第二步：列协议合同

对象合同之外，还要列控制协议。

至少要回答：

1. 哪些 control action 被正式声明。
2. 哪些字段属于 host / SDK / bridge 的硬协议。
3. 哪些失败语义、取消语义、回写语义已经进入正式 schema。

Claude Code 里，`SDKControlRequestInnerSchema` 就是最典型的协议全集入口。

如果忽略这一层，你读宿主适配器时就很容易只看到“这个入口目前支持什么”，却看不到平台设计空间本身。

### 2.3 第三步：列当前 registry

合同真相不等于当前注册真相。

审读时要单独列出：

1. 这个对象空间里当前真的注册了哪些实现。
2. 哪些实现要受 `feature()` gate。
3. 哪些只是类型或协议里存在，但当前 build 未必暴露。

`tasks.ts` 的 `getAllTasks()` 就说明了这一层为什么必须单列。

这一步真正防的是：

- 由类型空间直接脑补运行时暴露面

### 2.4 第四步：找 authoritative surface

这一层是 contract-first 最容易被漏掉的。

你需要单独列一张表，写清：

1. 谁是 enabled 的权威真相入口。
2. 谁是 in-flight 的权威状态机。
3. 谁定义 transcript message 边界。
4. 哪个状态字段是唯一权威值，不允许下游重算。

Claude Code 里很典型：

1. `checkEnabledPlugins()` 是 authoritative enabled check。
2. `QueryGuard` 是本地 query lifecycle 的同步状态机。
3. `REPL.tsx` 直接把它标成 “single source of truth for is a local query in flight”。
4. `isTranscriptMessage()` 是 transcript message 的 single source of truth。
5. `kairosEnabled` 是单一真相字段。

如果这一层不先锁定，后面看热点文件时会不断把：

- 派生逻辑
- UI 表现
- 补偿路径

误认成正式状态机。

### 2.5 第五步：标 adapter subset

现在才轮到宿主与适配器。

你需要显式写明：

1. 协议全集是什么。
2. 这个 adapter 只实现了哪个子集。
3. 哪些差异是产品选择，哪些差异是当前入口的线性裁剪。

`runBridgeHeadless()` 注释直接说自己是 `bridgeMain()` 的 linear subset，这就是最好的阅读提示。

只要这一步单独做，很多“为什么 schema 里有但这里没有”的疑惑都会立刻变成正常现象，而不是阅读障碍。

### 2.6 第六步：最后才读热点 kernel

完成前五步后，再去读：

- `query.ts`
- `main.tsx`
- `sessionStorage.ts`
- `promptCacheBreakDetection.ts`

此时你的阅读问题应该是：

- 这个 kernel 在维护哪些不变量

而不是：

- 这里到底想干什么

这就是 contract-first 审读法最实际的收益：它把热点文件从“巨量细节”重新压缩成“少量 invariants”。

## 3. 审读记录模板

可以直接照这张模板读一个 runtime：

```text
对象合同：
- 任务类型
- 状态类型
- 消息对象
- 持久化对象

协议合同：
- control request/response
- host event stream
- cancel / rewind / elicitation / reconnect

当前 registry：
- 当前 build 真正注册的能力
- feature gate 决定的条件性能力

authoritative surface：
- enabled 真相入口
- in-flight 真相入口
- transcript 边界真相入口
- 单一状态字段

adapter subset：
- 协议全集
- 当前 adapter 已实现子集
- 当前入口未覆盖点

热点 kernel：
- 维护哪些 invariants
- 哪些只是补偿路径
- 哪些是公开镜像缺口
```

## 4. 热点文件审读规则

只有完成前面的表格，才允许对热点文件下判断。

判断时只问三类问题：

1. 这里收口了哪些正式不变量。
2. 这里是在实现哪份前面已经列出的合同。
3. 这里的复杂性是 kernel 复杂性，还是散落式复杂性。

例如 `promptCacheBreakDetection.ts`：

- 如果没先认出共享前缀合同，你会把它读成调试工具；
- 如果先认出合同，就会看出它在维护 prompt 稳定性不变量。

## 5. 苏格拉底式检查清单

在你继续深读某个大文件前，先问自己：

1. 我已经列出对象合同了吗。
2. 我已经列出协议合同了吗。
3. 我分清合同里存在、当前注册和 adapter 子集了吗。
4. 我找到 authoritative surface 了吗。
5. 我现在是在看 invariant kernel，还是还在猜系统到底承认什么。

如果这些问题有任何一个答不清，继续追热点文件通常不会让你更懂，只会让你更累。

## 6. 一句话总结

contract-first 审读法真正强的地方，不是“更系统”，而是它先把对象、协议、注册、权威入口和适配器子集分开，再去读热点 kernel，这样大文件才会显露为不变量控制面，而不是实现噪音。
