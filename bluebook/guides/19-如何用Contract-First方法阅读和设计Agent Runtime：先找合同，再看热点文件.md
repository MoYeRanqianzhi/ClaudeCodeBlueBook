# 如何用Contract-First方法阅读和设计Agent Runtime：先找合同，再看热点文件

这一章回答五个问题：

1. 为什么研究 Claude Code 源码时，第一步不该直接冲进 `query.ts`、`main.tsx` 这类热点文件。
2. 怎样区分合同真相、registry 真相、authoritative surface 与 adapter subset。
3. 为什么“协议里声明存在”不等于“当前入口已经实现”。
4. 怎样用 contract-first 方法避免对公开镜像缺口和大文件职责产生脑补。
5. 怎样把这套方法迁移到自己的 agent runtime 设计与代码评审里。

## 0. 代表性源码锚点

- `claude-code-source-code/src/Task.ts:6-124`
- `claude-code-source-code/src/tasks.ts:1-39`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1-8`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:57-240`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:552-590`
- `claude-code-source-code/src/utils/plugins/pluginStartupCheck.ts:30-90`
- `claude-code-source-code/src/utils/QueryGuard.ts:1-106`
- `claude-code-source-code/src/utils/sessionStorage.ts:128-162`
- `claude-code-source-code/src/state/AppStateStore.ts:113-120`
- `claude-code-source-code/src/bridge/bridgeMain.ts:2799-2810`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:28-120`

这些锚点共同说明：

- Claude Code 的很多关键真相，早就写在 schema、union、状态机、single source 注释和 adapter 边界里；大文件只是这些正式合同的实现现场，而不是阅读起点。

## 1. 先说结论

更稳的源码阅读顺序，不是：

- 先看热点文件，再从实现猜合同

而是：

1. 先找 schema、type union、state interface 这些正式合同。
2. 再找 registry，判断“声明存在”和“当前注册”之间的差异。
3. 再找 authoritative surface，判断哪一个入口才是当前真相。
4. 再找 adapter subset，判断哪个宿主只实现了协议全集的一部分。
5. 最后才看 `query.ts`、`main.tsx` 这类热点文件在维护什么 invariant。

这套顺序不仅更适合读 Claude Code，也更适合设计自己的 runtime，因为它能持续压制两种常见幻觉：

1. 把局部实现细节误当全局合同。
2. 把协议全集、当前注册和某个适配器子集混成同一层真相。

## 2. 第一步：先找正式合同，而不是先找最热的实现

`Task.ts` 先定义了：

- `TaskType`
- `TaskStatus`
- `TaskStateBase`
- `Task`

`coreSchemas.ts` 又在文件头直接说明：

- SDK schemas 是 SDK 数据类型的 single source of truth

`controlSchemas.ts` 则把 initialize、permission、model、MCP、settings、elicitation 等控制动作全收进 `SDKControlRequestInnerSchema` 的 union。

这意味着 Claude Code 的作者已经把最该先看的东西放在了非常明确的位置：

- 对象合同
- 协议合同
- 状态合同

从第一性原理看，先找合同的价值不是“读起来更系统”，而是：

- 先确定系统承认哪些对象与动作，再去看它们怎样被实现

否则一旦先冲进热点文件，你很容易把：

- 某个分支
- 某个补丁路径
- 某个 UI 派生逻辑

误读成全局设计。

## 3. 第二步：把 contract truth 和 registry truth 分开

`Task.ts` 里的 `TaskType` 声明了任务空间。

但 `tasks.ts` 里的 `getAllTasks()` 明显是另一层真相：

1. 它只返回当前进程真正注册的 task 集合。
2. `LocalWorkflowTask` 与 `MonitorMcpTask` 还要经过 `feature()` gate。

所以“协议里承认某种 task”不等于“这次运行一定注册了它”。

这条区分非常关键，因为它会反复出现：

- type union 说可能存在
- registry 说当前有没有启用

如果阅读时不把这两层分开，就很容易把“声明存在”误当“当前必然可用”。

实践上：

1. 先看 union / enum，知道系统的设计空间。
2. 再看 registry，知道当前 build 或当前进程真正暴露了什么。
3. 对 feature-gated 公开镜像尤其要保持克制，不能由 type 反推全部实装。

## 4. 第三步：把协议全集和适配器子集分开

`SDKControlRequestInnerSchema` 给出的是控制协议全集。

但 `bridgeMain.ts` 的 `runBridgeHeadless()` 注释又明确写出：

- 它只是 `bridgeMain()` 的 linear subset

这说明 Claude Code 的宿主真相至少分三层：

1. 协议全集里声明了哪些动作。
2. 某个 adapter 当前实现了哪些动作。
3. 某个入口此刻是否真的启用这些动作。

所以正确读法不是：

- 看到 schema 里有某 subtype，就默认所有入口都支持它

而是：

- 先认协议全集，再逐个问这个 adapter 取了哪个子集

从第一性原理看，这能防止你把“平台能力上限”和“某个宿主当前支持面”混成一回事。

## 5. 第四步：先找 authoritative surface，再看热点文件怎样围着它转

Claude Code 源码里有大量非常直白的提示：

1. `checkEnabledPlugins()` 是 authoritative enabled check，不要委托给 `getPluginEditableScopes()`。
2. `QueryGuard` 是本地 query lifecycle 的同步状态机。
3. `REPL.tsx` 直接写明它是“is a local query in flight”的 single source of truth。
4. `isTranscriptMessage(...)` 是 transcript message 定义的 single source of truth。
5. `kairosEnabled` 在 `AppStateStore` 里被写成 single source of truth，不要下游各自重算。

这些注释的共同作用是：

- 告诉你哪一个入口才是当前真相

所以 contract-first 阅读法的关键不是“先看类型文件就结束”，而是：

- 顺着合同继续找 authoritative surface

因为很多运行时系统真正脆弱的地方，不在 schema，而在：

- 谁才有权决定 enabled
- 谁才有权定义 in flight
- 谁才有权定义 transcript 对象边界

只有先认出这些权威面，后面去读 `query.ts`、`sessionStorage.ts`、`REPL.tsx` 才不容易把派生逻辑、显示层逻辑或补偿逻辑错认成主状态机。

## 6. 第五步：最后才看热点文件在维护什么 invariant

等你已经有了：

1. 合同空间；
2. 当前 registry；
3. authoritative surface；
4. adapter subset；

这时再读热点文件，问题就会从：

- “怎么这么大”

变成：

- “它到底在保护哪几个不变量”

`promptCacheBreakDetection.ts` 就是典型例子。

如果你先没认出 cache-safe prompt 合同和控制面，看到它只会觉得“又一个复杂调试工具”。

但按 contract-first 顺序读，它显然是在维护：

- system hash
- tool schema hash
- cache control hash
- model / effort / beta / extra body params

也就是说，它服务的是 prompt 合同稳定性，而不是调试附属层。

这就是为什么 contract-first 能把热点文件从“实现噪音”还原成“invariant kernel”。

## 7. 第六步：把这套方法迁移到自己的 runtime 设计里

如果你在做自己的 agent runtime，更稳的构建顺序也应该类似：

1. 先写对象合同：任务、消息、状态、权限、恢复语义。
2. 先写协议合同：control request / response、host event、cancel、elicitation。
3. 先指定 authoritative surface：哪一个函数、字段或状态机是真相入口。
4. 再写 registry：哪些能力当前 build 或当前宿主真的暴露。
5. 最后才让热点 kernel 去维护 compaction、recovery、budget、cache 等复杂不变量。

如果你反过来做，就会得到一种很常见但很脆弱的系统：

- 大文件先长出来
- 真相散落在 UI、service、adapter、hook 各处
- 新人只能靠追实现猜合同

而 Claude Code 更值得学的地方，正好就是：

- 它尽量让合同先被看见

## 8. 苏格拉底式检查清单

在你准备继续追热点文件之前，先问自己：

1. 我已经知道这个系统承认哪些对象、状态和控制动作了吗。
2. 我分清了“合同里存在”“registry 里注册”“adapter 当前实现”这三层吗。
3. 我找到了 authoritative surface，还是还在从派生逻辑反推真相。
4. 我现在看到的是协议全集，还是某个宿主的线性子集。
5. 我读热点文件时，是在看 invariant kernel，还是还在把局部细节误当全局设计。

如果这些问题答不清，继续读热点文件通常只会增加细节，不会增加理解。

## 9. 一句话总结

Claude Code 最稳的阅读法不是先扑热点文件，而是先找合同、再分清 registry 与 adapter 子集、再锁定权威真相入口，最后才去看大文件怎样维护这些不变量。
