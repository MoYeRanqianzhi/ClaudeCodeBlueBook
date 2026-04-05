# 结构宿主修复收口执行反例：假seal、假交接与假重开

这一章不再回答“结构宿主修复收口执行该怎样运行”，而是回答：

- 为什么团队明明已经写了 closeout card、completion verdict order、handoff warranty 与 reopen drill，仍会重新退回假 seal、假交接与假重开。

它主要回答五个问题：

1. 为什么结构宿主修复收口执行最危险的失败方式不是“没有收口卡”，而是“收口卡存在，却仍围绕入口感与成功率工作”。
2. 为什么 breadcrumb 复辟与 resume 跳步最容易把 authority seal 重新退回 pointer、sidecar 与 reconnect 成功感。
3. 为什么 writeback seal 最容易被 telemetry 繁荣冒充。
4. 为什么 anti-zombie witness 与 handoff warranty 最容易重新退回作者说明与监控绿灯。
5. 怎样用苏格拉底式追问避免把这些反例读成“把恢复完成页再做细一点就好”。

## 0. 代表性源码锚点

- `claude-code-source-code/src/utils/QueryGuard.ts:1-121`
- `claude-code-source-code/src/utils/handlePromptSubmit.ts:430-517`
- `claude-code-source-code/src/utils/task/framework.ts:77-248`
- `claude-code-source-code/src/utils/sessionRestore.ts:435-490`
- `claude-code-source-code/src/utils/conversationRecovery.ts:533-570`
- `claude-code-source-code/src/services/api/sessionIngress.ts:57-170`
- `claude-code-source-code/src/bridge/bridgePointer.ts:22-184`
- `claude-code-source-code/src/cli/transports/WorkerStateUploader.ts:3-112`
- `claude-code-source-code/src/utils/sessionState.ts:1-149`
- `claude-code-source-code/src/state/onChangeAppState.ts:50-92`
- `claude-code-source-code/src/cli/structuredIO.ts:362-657`
- `claude-code-source-code/src/cli/print.ts:5048-5072`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:578-619`

这些锚点共同说明：

- 结构宿主修复收口执行真正最容易失真的地方，不在 closeout verdict 有没有写出来，而在 seal、交接与 reopen 是否仍围绕同一个 authority object、唯一 writeback 主路径、anti-zombie witness 与 recovery boundary 运作。

## 1. 第一性原理

结构宿主修复收口执行最危险的，不是：

- 没有 authority seal
- 没有 writeback seal
- 没有 reopen drill

而是：

- 这些东西已经存在，却仍然围绕 pointer、重连通过感、日志繁荣与作者口述运作

一旦如此，团队就会重新回到：

1. 看 pointer 还在不在
2. 看 reconnect 是不是成功了
3. 看日志是不是很繁荣
4. 看现在是不是又能恢复

而不再围绕：

- 同一个结构真相面

## 2. breadcrumb 复辟：pointer 与 sidecar 冒充 authority seal

### 坏解法

- 宿主、CI 与评审只要看到 pointer 文件还在、sidecar 还在、旧路径还能找到，就默认 `authority_seal` 已经成立，不再检查 authority object、authority state surface 与 generation 是否仍唯一。

### 为什么坏

- breadcrumb 只能证明“还有入口”，不能证明“authority 仍唯一”。
- 一旦 breadcrumb 复辟，团队就会重新容忍：
  - pointer 还在但 authority 已漂
  - sidecar 还在但 live state 已失配
  - 路径能找到但 seal 只剩作者解释
- 这会把结构收口重新退回“上次在哪”的错觉。

### Claude Code 式正解

- authority seal 应先证明 live truth 仍只有一个 authority object，再保留 breadcrumb 作为入口。


## 3. resume 跳步：reconnect 成功感冒充顺序关闭

### 坏解法

- 团队虽然写了 `resume_closure_order`，但真正 closeout 时只看“现在又连上了”，不再检查 `switch/reset -> restore metadata -> restore worktree -> adopt resumed session -> clear stale` 是否按正式顺序发生。

### 为什么坏

- Claude Code 的恢复能力值钱，不在“能重连”，而在“即使故障后也能重放对象顺序，不让旧对象复活”。
- 一旦顺序被成功感替代，团队就会最先误以为：
  - “最后好了就行”
  - “中间顺序不是关键”
- 这会把结构收口从对象级关闭重新退回偶然成功。

### Claude Code 式正解

- resume closeout 应先关闭顺序，再接受通过感。


## 4. writeback seal 伪装：telemetry 繁荣冒充唯一主写点

### 坏解法

- 团队只要看到 PUT 次数多、日志完整、监控繁荣，就默认 `writeback_seal` 成立，不再检查 `worker_status + external_metadata` 是否仍经由唯一主路径 merge/delete。

### 为什么坏

- `WorkerStateUploader` 的先进性不在“写得勤”，而在“写得唯一、可合并、可删除、可恢复”。
- 一旦 seal 退回 telemetry 成功感，就会重新容忍：
  - 多路旁写
  - metadata 全量覆盖
  - 局部成功掩盖最终状态错误
- 这会把真相回灌重新退回日志繁荣。

### Claude Code 式正解

- writeback seal 应围绕唯一 writer、merge 语义与最终 authority state 对齐，而不是围绕请求数量与日志丰富度。


## 5. anti-zombie 口头化：作者说明冒充 witness

### 坏解法

- 团队在 closeout note 里写“我们已经处理了 stale writer 与 orphan response”，却不交付 `anti_zombie_projection`、`stale_writer_evidence` 与去重清退证据。

### 为什么坏

- anti-zombie 是 witness，不是作者说明。
- 一旦 anti-zombie 只剩口头化，团队就会重新把先进性理解成：
  - 文件分层更好看
  - 监控更丰富
  - 成功率更高
- 这会把真正值钱的 stale-safe、generation guard 与 anti-zombie projection 直接蒸发掉。

### Claude Code 式正解

- 源码先进性应首先被验证为 anti-zombie 结果面仍然存在，而不是目录美学仍然成立。


## 6. 假交接与假重开：reconnect 冒充 handoff 与 reopen

### 坏解法

- handoff 看起来存在，实际只是告诉 later 团队“如果出问题就再连一次”；reopen 看起来存在，实际只是回到旧 pointer、旧路径或旧 sidecar，再试一次恢复。

### 为什么坏

- handoff warranty 保护的是 later 团队不靠作者记忆也能围绕同一个 authority object 与 recovery boundary 接手。
- reopen 保护的是回到上一个可验证的 authority/writeback/boundary 组合，而不是重复旧入口。
- 一旦 reconnect 冒充 handoff 与 reopen，later 团队会同时失去：
  - 可独立消费的 closeout 对象
  - 正式的 recovery boundary
  - 对 stale path 的清退保证

### Claude Code 式正解

- handoff 应交付 authority object 与 boundary；reopen 应回到对象边界，而不是回到旧路径。


## 7. 苏格拉底式追问

在你读完这些反例后，先问自己：

1. 我现在消费的是 authority object，还是 pointer 与 sidecar。
2. 我现在验证的是关闭顺序，还是 reconnect 成功感。
3. 我现在保护的是 writeback 主路径，还是日志繁荣。
4. 我现在保护的是 anti-zombie witness，还是作者说明与成功率。
5. 我现在交接与重开的是结构边界，还是旧路径与旧入口。

## 8. 一句话总结

真正危险的结构宿主修复收口执行失败，不是没写 closeout card，而是写了 closeout card 却仍在围绕假 seal、假交接与假重开消费结构世界。
