# 结构宿主修复演练反例：breadcrumb篡位、旁路写回与anti-zombie伪证明

这一章不再回答“结构宿主修复演练该怎样运行”，而是回答：

- 为什么团队明明已经写了 authority recovery 共享升级卡、rollback drill 与 re-entry drill，仍会重新退回 breadcrumb、重连通过感、日志繁荣与恢复成功率崇拜。

它主要回答五个问题：

1. 为什么结构宿主修复演练最危险的失败方式不是“没有升级卡”，而是“升级卡存在，却仍围绕入口感与成功率工作”。
2. 为什么 breadcrumb 篡位最容易把 authority object 重新退回 pointer、sidecar 与上次位置。
3. 为什么旁路写回最容易把 writeback restoration 重新退回 telemetry 成功感。
4. 为什么 anti-zombie 伪证明最容易把源码先进性重新退回目录美学、日志繁荣与恢复成功率。
5. 怎样用苏格拉底式追问避免把这些反例读成“再补几张恢复时序图就好”。

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
- `claude-code-source-code/src/cli/print.ts:5048-5072`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:578-619`

这些锚点共同说明：

- 结构宿主修复演练真正最容易失真的地方，不在字段有没有写出来，而在 authority object、resume order、writeback 主路径与 anti-zombie 结果面是否仍被当成 live truth，而不是被 breadcrumb、telemetry 与成功率替位。

## 1. 第一性原理

结构宿主修复演练最危险的，不是：

- 没有 authority recovery
- 没有 rollback drill
- 没有 re-entry ticket

而是：

- 这些东西已经存在，却仍然围绕 pointer、spinner、PUT 成功数、恢复成功率与作者说明运作

一旦如此，团队就会重新回到：

1. 看 pointer 还在不在
2. 看重连是不是成功了
3. 看日志是不是很繁荣
4. 看最终似乎是不是恢复了

而不再围绕：

- 同一个结构真相面

## 2. breadcrumb 篡位：pointer 与 sidecar 冒充 authority object

### 坏解法

- 宿主、CI 与评审只要看到 pointer 文件还在、sidecar 还在、路径还能找到，就默认 authority object 仍然存在。

### 为什么坏

- `bridgePointer` 与 sidecar 保存的是恢复入口与身份，不是 live truth。
- Claude Code 的结构先进性，恰恰在于把 breadcrumb 压成 breadcrumb，把 authority 压给 query/task/session/worker 的正式对象。
- 一旦 breadcrumb 篡位，团队就会重新容忍：
  - pointer 还在但 authority 已漂
  - sidecar 还在但 live state 已失配
  - 路径能找到但 resume 顺序已坏掉
- 这会把结构真相面重新退回“上次在哪”的错觉。

### Claude Code 式正解

- breadcrumb 只能证明“还有入口”，不能证明“当前对象仍成立”。

### 改写路径

1. 把 pointer、sidecar 降为边界信号。
2. 把 `authority_object_id + authority_state_surface + generation` 提升为通过前提。
3. 任何把 breadcrumb 当 authority 的结构 repair drill 都判为 drift。

## 3. resume 顺序隐式化：recovery 看起来成功，却没有重放对象顺序

### 坏解法

- 团队虽然写了 `resume_order`，但真正演练时只看“现在又连上了”，不再检查 restore、hydrate、adopt 与 clear stale 是否按正式顺序发生。

### 为什么坏

- Claude Code 的恢复能力值钱，不在“能重连”，而在“即使故障后也能重放对象顺序，不让旧对象复活”。
- 一旦顺序隐式化，团队就会最先误以为：
  - “最后好了就行”
  - “中间顺序不是关键”
- 这会把结构修复从对象级恢复重新退回偶然成功。

### Claude Code 式正解

- recovery 应先恢复顺序，再恢复通过感。

### 改写路径

1. 把重连成功降为结果信号。
2. 把 `resume_order` 提升为正式恢复对象。
3. 任何“结果成功即可忽略顺序”的结构 repair drill 都判为 drift。

## 4. 旁路写回：telemetry 成功感冒充 writeback restoration

### 坏解法

- 团队只要看到 PUT 次数多、日志完整、监控繁荣，就默认 writeback path 健康，不再检查 `worker_status + external_metadata` 是否仍经由唯一主路径回灌。

### 为什么坏

- `WorkerStateUploader` 的先进性不在“写得勤”，而在“写得唯一、可合并、可删除、可恢复”。
- 一旦修复演练只消费 telemetry 成功感，就会重新容忍：
  - 多路旁写
  - metadata 全量覆盖
  - 局部成功掩盖最终状态错误
- 这会把真相回灌重新退回日志繁荣。

### Claude Code 式正解

- writeback restoration 应围绕唯一 writer、merge 语义与最终 authority state 对齐，而不是围绕请求数量与日志丰富度。

### 改写路径

1. 把写回次数与日志量降为次级信号。
2. 把 `writeback_path + worker_status + external_metadata` 提升为正式对象。
3. 任何只看 telemetry 成功感的结构 repair drill 都判为 drift。

## 5. anti-zombie 伪证明：源码先进性退回目录美学与成功率崇拜

### 坏解法

- 团队在复盘里夸赞目录更清楚、恢复成功率更高、日志更完整，却不检查 stale writer、late finally、重复恢复与 terminal revive 是否仍被阻断。

### 为什么坏

- Claude Code 的源码先进性，不在“拆得更漂亮”，而在故障模型被提前编码进结构。
- 一旦 anti-zombie 伪证明出现，团队就会重新把先进性理解成：
  - 文件分层更好看
  - 监控更丰富
  - 成功率更高
- 这会把真正值钱的 stale-safe、generation guard 与 anti-zombie projection 直接蒸发掉。

### Claude Code 式正解

- 源码先进性应首先被验证为 anti-zombie 结果面仍然存在，而不是目录美学仍然成立。

### 改写路径

1. 把目录清晰度、日志量与成功率降为摘要指标。
2. 把 `anti_zombie_projection` 提升为正式通过条件。
3. 任何只夸源码更漂亮、不验 anti-zombie 的结构 repair drill 都判为 drift。

## 6. reconnect 冒充 rollback 与假重入

### 坏解法

- rollback 看起来存在，实际只是回到旧 pointer、重新点一次恢复、看监控恢复正常，然后默认允许重入，而不明确回到哪个 authority object 与 recovery boundary。

### 为什么坏

- 结构 rollback 真正要回的是对象边界，而不是恢复入口。
- 一旦回滚只剩重连与绿灯，later 维护者会知道“还能再连一次”，却不知道“该回退到哪个真相面”。
- 假重入则会让 stale writer、旧 generation 与 orphan response 一起混进新的时间线。

### Claude Code 式正解

- rollback 应先绑定 authority object、recovery boundary 与 writeback path，再允许操作 pointer、reconnect 与 UI；re-entry 应先证明旧 writer 不会复活。

### 改写路径

1. 把 pointer 与 reconnect 降为回退动作，不再当回退对象。
2. 把 `rollback_object + recovery_boundary + re_entry_condition` 提升为正式主对象。
3. 任何只回退到旧路径并默认重入的结构 repair drill 都判为 drift。

## 7. 苏格拉底式追问

在你读完这些反例后，先问自己：

1. 我现在消费的是 authority object，还是 pointer 与 sidecar。
2. 我现在验证的是对象顺序，还是最终成功感。
3. 我现在保护的是 writeback 主路径，还是日志繁荣。
4. 我现在保护的是 anti-zombie 结果面，还是恢复成功率与目录美学。
5. 我现在回滚与重入的是结构边界，还是恢复入口与监控绿灯。

## 8. 一句话总结

真正危险的结构宿主修复演练失败，不是没写升级卡，而是写了升级卡却仍在围绕 breadcrumb 篡位、旁路写回与 anti-zombie 伪证明消费结构世界。
