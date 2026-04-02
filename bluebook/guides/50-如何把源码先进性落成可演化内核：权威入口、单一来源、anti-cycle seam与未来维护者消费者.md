# 如何把源码先进性落成可演化内核：权威入口、单一来源、anti-cycle seam与未来维护者消费者

这一章不再解释“代码结构不错”是什么意思，而是把 Claude Code 式源码先进性压成一张可演化内核手册。

它主要回答五个问题：

1. 为什么真正先进的源码，不是目录更整齐，而是未来维护者仍能守住不变量。
2. 怎样把 authority surface、single-source、anti-cycle seam 与 anti-zombie 写成同一条构建顺序。
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

- Claude Code 的结构先进性，不在“有没有大文件”，而在它持续用权威入口、单一来源、切边 seam 与反陈旧写回来保护未来演化。

## 1. 第一性原理

更成熟的源码结构，不是：

- 先把目录拆细，再期待系统自然变稳

而是：

1. 先定义哪些对象拥有权威入口。
2. 先定义共享真相收口到哪里。
3. 先定义哪些依赖必须被 seam 切断。
4. 先定义哪些 await 之后的写回必须被 fresh state 复核。
5. 最后才决定目录与模块长什么样。

所以真正先进的结构首先保护的不是：

- 抽象优雅

而是：

- 未来维护者继续拒绝半真相的能力

## 2. 第一步：先固定 authority surface

Claude Code 很多关键平面都先固定了单一权威入口：

1. mode 变化从统一 diff 点外化
2. query lifecycle 由同步 guard 守住
3. recovery pointer 由专门对象管理
4. config / deps 由窄接口封装

构建动作：

1. 先写出你的系统里哪些对象有唯一 authority surface。
2. 先把对外消费与内部实现分开。
3. 先为高风险状态面定义 choke point。

不要做的事：

1. 不要把 mode、tool pool、session state 散落在多个调用点。
2. 不要让“读起来方便”凌驾于 authority 清晰之上。
3. 不要把某个 adapter 投影当成权威入口。

## 3. 第二步：把共享真相压成 single-source 与窄 config/deps

Claude Code 并不追求“到处可拿”，而是追求：

1. 共享真相有 single-source file
2. query config 是窄快照
3. runtime deps 是显式注入

这让系统获得三件事：

1. 配置变化能被定位
2. 测试替身能被局部替换
3. 未来提取 reducer / engine 时不会把整个模块图拖进去

构建动作：

1. 先把共享常量、共享类型、共享策略压成单一来源。
2. 先把 query config 与 mutable state 分开。
3. 先把高频依赖收成窄 deps 包，而不是任由热点文件四处 import。

## 4. 第三步：用 anti-cycle seam 切断脏边

成熟系统不是没有复杂依赖，而是会诚实地把脏边关进 seam。

更稳的做法是：

1. 先承认某条边很脏。
2. 先把它压成窄 seam。
3. 先保护主路径依赖图继续说真话。

构建动作：

1. 先标出不能继续扩张的循环边。
2. 先用 helper / seam / thin registry 隔离它。
3. 先让大部分模块图保持可解释，而不是追求全局完美无环。

不要做的事：

1. 不要为了一次抽象把整个模块图重新拉脏。
2. 不要把 anti-cycle 误写成“以后再重构”。
3. 不要因为存在大文件就忽略 choke point 的价值。

## 5. 第四步：把 anti-zombie 写成日常写法

Claude Code 很多先进性不在静态结构，而在动态写回规则：

1. await 之后只补 offset patch，不回写整对象
2. stale generation 的 finally 不允许清 fresh state
3. recovery pointer 采用 best-effort 与 TTL，不自造第二套真相

构建动作：

1. 先定义哪些写回只能 patch fresh state。
2. 先定义 generation / epoch / TTL / stale-safe 规则。
3. 先定义恢复资产如何只做恢复，不做第二权威面。

不要做的事：

1. 不要把旧快照 spread 回新状态。
2. 不要把 finally 块当默认安全区。
3. 不要让恢复文件、桥接指针、临时补丁长成第二套主真相。

## 6. 第五步：把未来维护者当正式消费者

Claude Code 的高级感还来自：

1. 风险命名
2. 制度注释
3. 显式危险改动面
4. subset / internal-only / main path 的分层说明

这些都在帮助未来维护者回答：

1. 这里为什么不能随手改。
2. 改坏以后会伤到谁。
3. 哪些消费者真的依赖这条语义。

构建动作：

1. 先给高风险代码命名风险。
2. 先给危险路径写制度注释。
3. 先把 protocol full set、consumer subset、internal-only 分层说清。

## 7. 五步结构评审卡

如果要把上面的原则压成一张结构评审卡，可以固定成：

1. `authority surface`
   - 当前真相从哪里宣布
2. `single-source`
   - 共享真相收口到哪里
3. `anti-cycle seam`
   - 哪些脏边被正式圈住
4. `anti-zombie`
   - 哪些写回必须 fresh-safe
5. `future maintainer consumer`
   - 后来者靠什么继续反驳错误实现

## 8. 苏格拉底式检查清单

在你准备宣布“这个结构已经很成熟”前，先问自己：

1. 我固定的是权威入口，还是只固定了目录分层。
2. 共享真相是否真的只有一个来源。
3. 脏边是否被显式圈进 seam，而不是口头约定。
4. await 之后的写回是否会把旧快照重新僵尸化。
5. 后来维护者是否能从代码里直接看见危险改动面与消费者边界。

## 9. 一句话总结

真正先进的源码，不是把目录拆得更好看，而是把权威入口、单一来源、anti-cycle seam、anti-zombie 与未来维护者消费者一起写成可演化内核。

