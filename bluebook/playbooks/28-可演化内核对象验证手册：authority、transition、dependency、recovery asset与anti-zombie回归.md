# 可演化内核对象验证手册：authority object、transition legality、dependency honesty、recovery asset non-sovereignty与anti-zombie回归

这一章不再解释 `evolvable kernel object boundary` 为什么重要，而是把它压成一张长期演化里的验证手册。

它主要回答五个问题：

1. 团队怎样知道当前仍在围绕同一个可演化内核对象工作。
2. 哪些症状最能暴露结构先进性已经退回目录审美、作者记忆或规则存在性。
3. 哪些检查点最适合作为长期演化门禁。
4. 哪些 drift 必须直接拒收，而不是交给后续重构慢慢消化。
5. 怎样用苏格拉底式追问避免把这层写成“结构卫生检查表”。

## 0. 代表性源码锚点

- `claude-code-source-code/src/query/config.ts:1-45`
- `claude-code-source-code/src/query/deps.ts:1-40`
- `claude-code-source-code/src/utils/QueryGuard.ts:1-108`
- `claude-code-source-code/src/utils/task/framework.ts:160-269`
- `claude-code-source-code/src/bridge/bridgePointer.ts:22-184`
- `claude-code-source-code/src/state/onChangeAppState.ts:43-92`
- `claude-code-source-code/src/utils/queryContext.ts:1-87`

## 1. 第一性原理

对可演化内核来说，真正重要的不是：

- 目录看起来更整齐
- 规则文件还存在

而是：

- 当前 authority object、transition legality、dependency honesty、recovery asset non-sovereignty 与 anti-zombie 仍然围绕同一内核对象成立

所以这层验证最先要看的不是静态结构图，而是：

1. authority object continuity
2. transition legality continuity
3. dependency honesty continuity
4. recovery asset non-sovereignty continuity
5. anti-zombie continuity

## 2. 回归症状

看到下面信号时，应提高警惕：

1. mode、query state、task state 开始多处宣布。
2. `config / deps` seam 开始重新拉深模块图。
3. stale finally 或旧快照开始回写 fresh state。
4. recovery pointer、临时资产开始长成第二权威面。
5. 结构讨论开始退回“文件大不大”“目录好不好看”。

## 3. 每轮检查点

每次变更后，至少逐项检查：

1. `authority object continuity`
   - 当前真相是否仍有单一权威入口。
2. `transition legality continuity`
   - generation / stale-writer / terminal transition 是否仍受正式保护。
3. `dependency honesty continuity`
   - single-source、leaf module 与 anti-cycle seam 是否仍说真话。
4. `recovery asset non-sovereignty continuity`
   - 恢复资产是否仍只做恢复，不宣布第二套真相。
5. `anti-zombie continuity`
   - 过去的对象是否仍无法写回现在。

## 4. 直接拒收条件

出现下面情况时，应直接拒收：

1. 关键状态开始多点同步、没有单一 authority。
2. `config / deps` seam 被打穿，模块图重新失真。
3. await 之后旧快照整对象回写新状态。
4. recovery asset 被直接消费成主真相。
5. anti-zombie 规则只剩注释，不再有可验证证据。

## 5. 复盘记录最少字段

每次结构 drift 至少记录：

1. `kernel_object_id`
2. `authority_object`
3. `transition_boundary`
4. `dependency_boundary`
5. `recovery_asset_non_sovereignty`
6. `anti_zombie_evidence`
7. `rollback_object`
8. `symptom`
9. `reject_reason`

## 6. 防再发动作

更稳的防再发顺序是：

1. 先补 authority object 的单一入口。
2. 先补 stale-safe transition 规则。
3. 先补 dependency seam 的边界说明。
4. 先补 recovery asset ledger。
5. 最后才谈目录优化或抽象重排。

## 7. 苏格拉底式检查清单

在你准备宣布“结构机制仍然健康”前，先问自己：

1. 当前真相是否仍然只有一个 authority object。
2. 状态迁移是否合法，还是只是运气好没撞上竞态。
3. 依赖图是否仍在说真话。
4. recovery asset 是否还只是一份恢复资产，而不是第二主语。
5. 如果把作者记忆拿掉，后来维护者是否仍能拒绝错误实现。

## 8. 一句话总结

真正成熟的结构机制验证，不是看规则还在不在，而是持续证明 authority object、transition legality、dependency honesty、recovery asset non-sovereignty 与 anti-zombie 仍然围绕同一个可演化内核对象成立。
