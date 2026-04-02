# 如何把故障模型编码进源码结构：authority surface、dependency seam、stale-safe merge与recovery boundary

这一章不再解释源码先进性为什么重要，而是把 Claude Code 式故障模型编码压成一张 builder-facing 的结构实现手册。

它主要回答五个问题：

1. 为什么真正先进的源码不是目录更漂亮，而是 authority drift、dependency drift、stale write 与 recovery 篡位都被提前写成正式故障模型。
2. 怎样把 authority surface、dependency seam、stale-safe merge、recovery boundary 与 anti-zombie 写成同一条结构实现顺序。
3. 为什么未来维护者真正需要的不是目录图，而是能够直接拒绝半真相实现的结构条件。
4. 怎样用苏格拉底式追问避免把结构实现重新退回模块美学。
5. 怎样把 Claude Code 的工程先进性迁移到自己的 Agent Runtime，而不误抄某个目录布局。

## 0. 代表性源码锚点

- `claude-code-source-code/src/query/config.ts:1-45`
- `claude-code-source-code/src/query/deps.ts:1-40`
- `claude-code-source-code/src/utils/QueryGuard.ts:1-121`
- `claude-code-source-code/src/utils/task/framework.ts:160-248`
- `claude-code-source-code/src/bridge/bridgePointer.ts:22-184`
- `claude-code-source-code/src/utils/queryContext.ts:1-140`
- `claude-code-source-code/src/state/onChangeAppState.ts:43-92`

这些锚点共同说明：

- Claude Code 的结构先进性，不在“有没有大文件”，而在“哪些故障模型已经被提前编码，所以后来者能正式拒绝错误实现”。

## 1. 第一性原理

更成熟的结构实现，不是：

- 先把目录拆细，再期待系统自然变稳

而是：

1. 先定义哪些对象拥有唯一 authority surface。
2. 先定义哪些高复杂度依赖必须被 seam 圈住。
3. 先定义跨 `await` 的写回必须怎样通过 fresh-state 校验。
4. 先定义 recovery asset 如何只做恢复，不做第二权威面。
5. 先定义 later maintainer 怎样一眼看见危险改动面。

所以真正先进的结构首先保护的不是：

- 模块美学

而是：

- 故障模型

## 2. 第一步：先固定 authority surface

Claude Code 很多关键状态都先通过单一扼流点外化：

1. mode 变化通过统一 diff 点同步。
2. query lifecycle 通过同步 guard 守住。
3. session metadata 通过正式状态对象投影。
4. recovery pointer 通过专门对象管理。

构建动作：

1. 先写出哪些对象有唯一 authority surface。
2. 先区分 authority 与 projection。
3. 先为高风险状态定义单一外化点。

不要做的事：

1. 不要让多个 adapter 各自宣布当前真相。
2. 不要把“读起来方便”放在 authority 清晰前面。
3. 不要让 projection 反过来成为新权威面。

## 3. 第二步：把 dependency drift 压进 seam

Claude Code 的 `query/config`、`query/deps`、`queryContext` 值钱，不是因为文件小，而是因为它们把脏边正式圈了出来。

构建动作：

1. 先标出不能继续扩张的依赖边。
2. 先把重模块挡在 seam 外。
3. 先让 plain data、窄 deps 与 fallback params 各司其职。

不要做的事：

1. 不要为了方便把重依赖继续拉进轻量 seam。
2. 不要把 anti-cycle 当口头约定。
3. 不要用“以后重构”掩盖当前依赖图已经说谎。

## 4. 第三步：把 stale-safe merge 写成默认写法

很多结构失败不是静态分层错，而是过去把现在写坏。

Claude Code 更成熟的地方在于，它持续要求：

1. generation guard
2. fresh-state re-check
3. delta patch 而非整对象覆盖
4. terminal re-check 与 stale writer drop

构建动作：

1. 先定义哪些写回只能 patch fresh state。
2. 先为长链异步路径写 generation / epoch。
3. 先把 finally、poll、resume、merge 当作高危路径审计。

不要做的事：

1. 不要跨 `await` 继续 spread 旧快照。
2. 不要把 finally 视为默认安全区。
3. 不要在无法证明 stale-safe 时依赖“应该没竞态”。

## 5. 第四步：把 recovery asset 关回 recovery boundary

Claude Code 的 bridge pointer、resume pointer、ledger 等恢复资产都很重要，但它们不能越权。

构建动作：

1. 先定义 recovery asset 的职责只到“帮助回到主权对象”。
2. 先定义 TTL、best-effort、staleness clear 等边界。
3. 先规定 resume 入口必须回到 authority surface 再继续后续读写。

不要做的事：

1. 不要把 pointer、ledger、resume file 直接当当前主真相。
2. 不要用恢复成功率掩盖恢复资产篡位。
3. 不要让恢复对象绕开正式 authority path。

## 6. 第五步：把 anti-zombie 写成正式证据

如果 anti-zombie 只剩注释，那后来维护者拿到的只是作者提醒。

Claude Code 更成熟的地方在于，它把：

1. generation mismatch
2. fresh merge
3. stale writer drop
4. retain / evict 条件

都写成正式证据。

构建动作：

1. 先给 anti-zombie 找到明确的证据点。
2. 先把风险命名写进注释与机制双层结构。
3. 先让 later maintainer 能从代码里直接看见反对路径。

不要做的事：

1. 不要把 anti-zombie 留给团队默契。
2. 不要只写危险提醒，不写拒收机制。
3. 不要让 later maintainer 仍需问作者“这里能不能改”。

## 7. 六步最小实现顺序

如果要把上面的原则压成一张结构 builder 卡，顺序可以固定成：

1. `authority surface`
   - 当前真相从哪里宣布
2. `dependency seam`
   - 哪些边必须被正式圈住
3. `query config / deps split`
   - 哪些是 plain data，哪些是 injectable deps
4. `stale-safe merge`
   - 跨时间写回怎样不 zombify 新状态
5. `recovery boundary`
   - 恢复资产怎样不篡位
6. `anti-zombie evidence`
   - later maintainer 靠什么直接拒绝错误实现

## 8. 苏格拉底式检查清单

在你准备宣布“这个结构已经很先进”前，先问自己：

1. 我固定的是 authority surface，还是只固定了目录层次。
2. 当前 seam 是否仍在说真话。
3. 这条异步路径能否证明不会把过去写回现在。
4. recovery asset 还只是恢复资产，还是已经在篡位。
5. later maintainer 能否直接从代码里看见反对当前实现的证据。

## 9. 一句话总结

真正先进的源码，实现上不是更漂亮的目录，而是把 authority surface、dependency seam、stale-safe merge、recovery boundary 与 anti-zombie 证据一起写成正式故障模型。
