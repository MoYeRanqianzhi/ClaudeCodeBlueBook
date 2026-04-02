# 源码演化案例集：影子层化石化、传输泄漏与zombification

这一章收集最能暴露 Claude Code 源码先进性真义的失败样本。

它主要回答五个问题：

1. 为什么源码先进性真正暴露在演化失败，而不是静态结构图。
2. 哪些样本最能说明“目录漂亮”和“结构先进”不是一回事。
3. 为什么 shadow / stub、transport shell、recovery asset 与 zombification 应一起看。
4. 怎样从这些失败形态反推 Claude Code 的结构哲学。
5. 怎样用苏格拉底式追问避免把案例读成纯工程吐槽。

## 0. 代表性源码锚点

- `claude-code-source-code/scripts/prepare-src.mjs:3-64`
- `claude-code-source-code/scripts/stub-modules.mjs:2-42`
- `claude-code-source-code/src/moreright/useMoreRight.tsx:1-25`
- `claude-code-source-code/src/state/AppState.tsx:23-29`
- `claude-code-source-code/src/bridge/replBridgeTransport.ts:13-116`
- `claude-code-source-code/src/bridge/sessionIdCompat.ts:1-54`
- `claude-code-source-code/src/bridge/bridgePointer.ts:22-167`
- `claude-code-source-code/src/services/api/sessionIngress.ts:60-120`
- `claude-code-source-code/src/utils/QueryGuard.ts:69-106`
- `claude-code-source-code/src/utils/task/framework.ts:160-248`

## 1. 案例一：shadow 层从过渡隔离层变成永久第二实现

### 现象

某个 shadow / lightweight impl 本来只是为了入口隔离存在，后来开始长期承担独立真相。

### 为什么重要

这不是“多了点重复实现”，而是：

- shadow fossilization

### 暴露的制度边界

- 影子层必须有退出条件
- 否则入口隔离会演化成双真相

### 反推哲学

源码先进性不在“可以加影子层”，而在：

- 影子层知道什么时候该消失

## 2. 案例二：transport 差异泄漏出 shell

### 现象

本应只在 construction site 处理的 transport 版本差异，开始渗进业务层、状态层或工具层。

### 为什么重要

这不是“适配代码有点散”，而是：

- transport leakage

### 暴露的制度边界

- shell 的职责是吃掉协议差异
- 一旦泄漏，仓库就会长出多个 runtime 世界

### 反推哲学

真正强的 transport shell 不是会兼容更多，而是：

- 会阻止兼容差异继续蔓延

## 3. 案例三：恢复资产失真，但平时没人发现

### 现象

bridge pointer、cursor、last uuid 或 merge rule 失真，系统平时看着还能跑，出故障时才暴露。

### 为什么重要

这说明 recovery 不是附属层，而是：

- 日常状态写法的上游约束

### 暴露的制度边界

- 没有 recovery drill，恢复资产就只是看起来存在

### 反推哲学

先进结构不是更会恢复，而是：

- 平时就在为恢复而写状态协议

## 4. 案例四：旧快照复活当前对象

### 现象

stale finally、stale snapshot 或 stale append 把旧状态写回当前对象，造成 terminal state 污染或假继续。

### 为什么重要

这不是普通 race，而是：

- zombification

### 暴露的制度边界

- against fresh state merge 是默认制度，不是优化技巧
- generation / stale-drop 是对象命运保护，不是局部修补

### 反推哲学

源码先进性的一条深线，其实是：

- 系统是否把对象命运当正式治理对象

## 5. 案例五：兼容层和 registry 越来越厚，但团队还觉得“结构更完整”

### 现象

compat、stub、registry 持续增长，表面上目录更齐、入口更多，实际高扇入节点越来越重。

### 为什么重要

这类事故最容易被误判为：

- “系统更成熟了”

真实却可能是：

- registry obesity
- stub becoming truth

### 暴露的制度边界

- 成熟不是能包住更多历史包袱
- 成熟是还能逐步退出历史包袱

### 反推哲学

强结构真正擅长的不是累积兼容层，而是：

- 让兼容层始终保持可退出

## 6. 苏格拉底式追问

在你读完这些演化样本后，先问自己：

1. 我看到的是结构增强，还是新真相偷偷长出来。
2. 这条 transport 差异还在 shell 里吗。
3. 这个 shadow / stub 还记得自己本来是过渡层吗。
4. recovery asset 是活制度，还是静态注释。
5. 这次 stale write 是小竞态，还是 zombie 事故。

## 7. 一句话总结

源码先进性的真义，往往在失败样本里更清楚：强结构不是更整齐，而是影子层可退出、差异被困在壳层、恢复资产被演练、旧对象不能复活。
