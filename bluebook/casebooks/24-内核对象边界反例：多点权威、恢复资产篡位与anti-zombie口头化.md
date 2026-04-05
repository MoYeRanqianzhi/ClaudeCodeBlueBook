# 内核对象边界反例：多点权威、恢复资产篡位与anti-zombie口头化

这一章不再回答“怎样验证 `evolvable kernel object boundary` 仍然成立”，而是回答：

- 为什么源码结构明明已经被写成 `authority surface + dependency seam + transition legality + recovery asset + anti-zombie`，团队却仍会重新退回多点权威、目录审美、恢复成功率与作者记忆。

它主要回答五个问题：

1. 为什么结构机制最危险的失败方式不是“没有抽象”，而是“抽象还在，但对象级真相重新分裂”。
2. 为什么多点权威会把结构先进性退回多处半真相协商。
3. 为什么 seam 一旦被打穿，目录依旧整齐也会重新说谎。
4. 为什么 recovery asset 最容易长成第二权威面。
5. 怎样用苏格拉底式追问避免把这些反例读成“结构还可以优化一下”。

## 0. 代表性源码锚点

- `claude-code-source-code/src/query/config.ts:1-45`
- `claude-code-source-code/src/query/deps.ts:1-40`
- `claude-code-source-code/src/utils/QueryGuard.ts:1-121`
- `claude-code-source-code/src/utils/task/framework.ts:160-248`
- `claude-code-source-code/src/bridge/bridgePointer.ts:22-184`
- `claude-code-source-code/src/utils/queryContext.ts:1-140`
- `claude-code-source-code/src/state/onChangeAppState.ts:43-92`

这些锚点共同说明：

- 源码先进性真正脆弱的地方，不在文件大不大，而在 authority、transition、dependency 与 recovery 是否仍围绕同一个内核对象说真话。

## 1. 第一性原理

可演化内核边界最危险的，不是：

- 没有模块
- 没有注释

而是：

- 模块、注释、恢复逻辑都还在，却重新长出多个都能宣布真相的入口

一旦如此，团队就会重新回到：

1. 看目录图
2. 看作者说明
3. 看恢复成功率
4. 看“这次好像没出事”

而不再围绕：

- 同一个 authority surface 与 transition boundary

## 2. 多点权威 vs authority surface

### 坏解法

- mode、session、query、bridge、recovery 各自保有一份“当前真相”，后来者只能在多处状态里猜谁说了算。

### 为什么坏

- 结构先进性会从单一权威面退回多处半真相协商。
- later 修改者无法知道该先核对哪个入口，错误会在不同状态副本里漂移。
- “看起来都同步了”会替代“实际上只有一个权威”。

### Claude Code 式正解

- 关键状态变化必须继续经过单一 choke point，对外做正式 externalize，对内保持唯一 authority surface。
- 任何辅助状态都只能是 projection，不得重新宣布主权。


## 3. seam 被打穿 vs dependency honesty

### 坏解法

- 为了方便复用，把高依赖图模块继续往 `query/config`、`deps`、`queryContext` 之类的轻量 seam 里拉，或者反过来让底层文件去依赖高层对象。

### 为什么坏

- 目录外观看起来仍然整齐，依赖图却已经不再说真话。
- 轻量 seam 会退回“顺手放一点逻辑”的重力井。
- later 测试、初始化顺序与 tree-shaking 边界都会被悄悄污染。

### Claude Code 式正解

- seam 文件只保留最小 contract、最小 production deps 与最小 fallback 逻辑。
- 高复杂度对象必须被挡在 seam 外，让依赖图继续诚实暴露危险改动面。


## 4. 陈旧快照回写 fresh state vs transition legality

### 坏解法

- 跨 `await` 之后继续整对象回写旧快照，或者让 stale finally 清理 fresh state，只靠“应该没竞态”维持正确。

### 为什么坏

- anti-zombie 会退回口号。
- later query cancel、task poll、resume merge 时，过去的对象会重新把现在写坏。
- 结构看起来没问题，时间维度却已经开始说谎。

### Claude Code 式正解

- 关键 transition 必须继续用 generation、fresh merge、delta patch 与 stale drop 守住。
- 任何跨 await 写回应优先补丁化，而不是快照化。


## 5. 恢复资产篡位 vs recovery asset

### 坏解法

- bridge pointer、resume pointer、recovery ledger 等恢复资产被直接当作当前主真相消费。

### 为什么坏

- 恢复资产会从“帮助回到真相”变成“自己宣布真相”。
- later crash-recovery 成功率越高，团队越容易忽视第二权威面的形成。
- 系统会把“能继续找回来”误读成“它本来就是真相”。

### Claude Code 式正解

- recovery asset 必须继续只是恢复资产，不得越权成为 authority surface。
- 任何恢复入口都应先回到正式对象，再决定后续读写路径。


## 6. anti-zombie 退回注释口头化 vs formal evidence

### 坏解法

- 注释里写了不要 zombie，但没有 QueryGuard generation、fresh re-check、drop stale writer 或正式 evidence 字段。

### 为什么坏

- 这会把结构先进性退回作者道德要求。
- 后来维护者能读懂风险，却无法从代码里直接拒绝错误实现。
- anti-zombie 会沦为“大家小心一点”的口头文化。

### Claude Code 式正解

- anti-zombie 必须继续体现为 generation guard、fresh-state merge、terminal re-check、stale writer drop 等正式机制。
- 风险命名应同时有注释与可执行证据，不得只剩一种。


## 7. 苏格拉底式追问

在你读完这些反例后，先问自己：

1. 我现在维护的是单一 authority surface，还是多点权威协商。
2. 当前 seam 还在说真话，还是只是目录还算好看。
3. 这次跨 `await` 写回能否证明不会 zombify 新状态。
4. recovery asset 还只是恢复资产，还是已经在篡位。
5. anti-zombie 是正式证据，还是作者写下来的道德提醒。
