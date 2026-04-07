# 如何把源码先进性落成可演化内核：current-truth surface、single-source、anti-cycle seam 与 future maintainer consumer

这一章不再解释“代码结构不错”是什么意思，而是把 Claude Code 式源码先进性压成一条可执行的机制回灌顺序。

注：本章把旧称 `authority surface / 权威入口` 统一收回为 `current-truth surface`，把 `anti-zombie` 的动态约束统一落在 `current-truth writeback`。

它主要回答五个问题：

1. 为什么真正先进的源码，不是目录更整齐，而是未来维护者仍能守住不变量。
2. 怎样把 `compiled request truth`、`current-truth surface`、single-source、anti-cycle seam 与 `current-truth writeback` 写成同一条构建顺序。
3. 为什么成熟系统会主动给未来维护者留下反对当前实现的结构条件。
4. 怎样用苏格拉底式追问避免把结构先进性退回“模块化洁癖”。
5. 怎样把 Claude Code 的工程先进性迁移到自己的 Agent Runtime，而不误抄目录表面。

## 0. 代表性源码锚点

- `claude-code-source-code/src/utils/task/framework.ts:160-269`
- `claude-code-source-code/src/query/config.ts:1-45`
- `claude-code-source-code/src/query/deps.ts:1-40`
- `claude-code-source-code/src/utils/QueryGuard.ts:1-106`
- `claude-code-source-code/src/state/AppStateStore.ts:113-120`
- `claude-code-source-code/src/bridge/bridgePointer.ts:22-184`

这些锚点共同说明：

- Claude Code 的结构先进性，不在“有没有大文件”，而在它持续把请求真相、当前真相宣布面、依赖切边与写回拒收规则压成同一套机制对象。

## 1. 第一性原理：先对象，后目录

更成熟的源码结构，不是：

- 先把目录拆细，再期待系统自然变稳

而是固定以下回灌顺序：

1. 先把请求对象编译成 `compiled request truth`。
2. 先定义谁拥有 `current-truth surface`（谁能宣布当前真相）。
3. 先把共享真相收口到 single-source 与窄 config/deps。
4. 先把脏依赖圈进 anti-cycle seam。
5. 先把异步与恢复路径收敛到 `current-truth writeback`。
6. 最后才决定目录与模块长什么样，并把维护者当正式消费者。

所以真正先进的结构首先保护的不是抽象优雅，而是未来维护者继续拒绝半真相的能力。

## 2. 第一步：先固定 compiled request truth

结构先进性不是从“分层”开始，而是从“请求对象先被编译成同一真相”开始。

构建动作：

1. 先定义请求对象的最小字段集与协议语义边界。
2. 先固定哪些输入能参与编译，哪些输入只允许做消费投影。
3. 先规定任何后续控制面与状态写回都只能消费这份 `compiled request truth`。

不要做的事：

1. 不要让 adapter 或缓存路径直接改写请求主语。
2. 不要把“易读提示词”当成可执行请求对象。
3. 不要让不同模块各自持有不同版本的请求真相。

## 3. 第二步：固定 current-truth surface 与 single-source

`current-truth surface` 负责宣布当前真相，single-source 负责收口共享真相；两者必须一起设计。

构建动作：

1. 先写清哪些对象拥有唯一 `current-truth surface`。
2. 先把共享常量、共享类型、共享策略压成 single-source。
3. 先把 query config 与 mutable state 分开，把 runtime deps 压成窄注入包。

不要做的事：

1. 不要把 mode、tool pool、session state 散落在多个调用点。
2. 不要把某个 adapter 投影误当 `current-truth surface`。
3. 不要让热点文件随意横向 import，破坏真相收口。

## 4. 第三步：用 anti-cycle seam 圈住脏边

成熟系统不是没有复杂依赖，而是会诚实地把脏边关进 seam，让主路径依赖图继续说真话。

构建动作：

1. 先标出不能继续扩张的循环边。
2. 先用 helper / seam / thin registry 隔离它。
3. 先确保主路径模块图仍可解释，再讨论全局最优重构。

不要做的事：

1. 不要为一次抽象把整个模块图重新拉脏。
2. 不要把 anti-cycle 误写成“以后再重构”。
3. 不要因为存在大文件就忽略 choke point 的价值。

## 5. 第四步：把 anti-zombie 严格化为 current-truth writeback

动态一致性要靠 `current-truth writeback`，而不是靠“工程习惯”。

构建动作：

1. 先定义哪些写回只能 patch fresh state，禁止整对象回填。
2. 先定义 generation / epoch / TTL / stale-safe 规则并绑定到写回路径。
3. 先规定恢复资产只做恢复，不得宣布第二套当前真相。

不要做的事：

1. 不要把旧快照 spread 回新状态。
2. 不要把 finally 块当默认安全区。
3. 不要让恢复文件、桥接指针、临时补丁长成第二套主真相。

## 6. 第五步：把未来维护者当正式消费者

可演化内核必须显式服务未来维护者，而不只服务当前实现者。

构建动作：

1. 先给高风险代码命名风险，并说明失败语义。
2. 先给危险路径写制度注释，标明改动责任与回退边界。
3. 先把 protocol full set、consumer subset、internal-only 分层说清。

## 7. 五步结构评审卡

如果要把上面的原则压成一张结构评审卡，可以固定成：

1. `compiled request truth`
   - 请求对象从哪里被编译并冻结主语
2. `current-truth surface`
   - 当前真相从哪里宣布、谁有写权限
3. `single-source + anti-cycle seam`
   - 共享真相收口与脏边圈定是否同时成立
4. `current-truth writeback`
   - 哪些异步写回被 fresh-safe 与 stale-safe 共同约束
5. `future maintainer consumer`
   - 后来者靠什么继续反驳错误实现

## 8. 苏格拉底式检查清单

在你准备宣布“这个结构已经很成熟”前，先问自己：

1. 我固定的是 `current-truth surface`，还是只固定了目录分层。
2. `compiled request truth` 是否已成为所有后续机制的共同输入。
3. 共享真相是否真的只有一个来源，且脏边已被显式圈进 seam。
4. await 之后的写回是否都走 `current-truth writeback`，不会把旧快照重新僵尸化。
5. 后来维护者是否能从代码里直接看见危险改动面与消费者边界。

## 9. 一句话总结

真正先进的源码，不是把目录拆得更好看，而是把 `compiled request truth`、`current-truth surface`、single-source、anti-cycle seam、`current-truth writeback` 与未来维护者消费者一起写成可演化内核。
