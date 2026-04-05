# 结构宿主验收执行反例：breadcrumb篡位、写回繁荣与anti-zombie口头化

这一章不再回答“结构宿主验收执行该怎样运行”，而是回答：

- 为什么团队明明已经写了 authority object、resume order、recovery boundary、writeback path 与 anti-zombie 剧本，仍会重新退回 pointer、spinner、日志繁荣、恢复成功率与作者说明。

它主要回答五个问题：

1. 为什么结构宿主验收执行最危险的失败方式不是“没有执行卡”，而是“执行卡存在，却仍围绕 breadcrumb 与监控绿灯工作”。
2. 为什么 breadcrumb 篡位最容易把 authority object 重新退回 pointer、sidecar 与上次位置。
3. 为什么写回繁荣最容易把 writeback path 重新退回 telemetry 成功感。
4. 为什么 anti-zombie 口头化最容易把源码先进性重新退回目录美学与成功率崇拜。
5. 怎样用苏格拉底式追问避免把这些反例读成“再补几张时序图就好”。

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

- 结构宿主验收执行真正最容易失真的地方，不在字段有没有写出来，而在 authority object、resume order、writeback path 与 anti-zombie 是否仍被当成 live truth，而不是被 breadcrumb、telemetry 与成功率替位。

## 1. 第一性原理

结构宿主验收执行最危险的，不是：

- 没有 authority 字段
- 没有 resume 顺序
- 没有 rollback 剧本

而是：

- 这些东西已经存在，却仍然围绕 pointer、spinner、PUT 成功数与恢复成功率运作

一旦如此，团队就会重新回到：

1. 看 pointer 还在不在
2. 看 UI 有没有 loading
3. 看 writeback 请求有没有成功
4. 看恢复最后成没成功

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


## 3. 写回繁荣：telemetry 成功感冒充 writeback path

### 坏解法

- 团队只要看到 PUT 次数多、日志完整、监控繁荣，就默认 writeback path 健康，不再检查 `worker_status + external_metadata` 是否仍经由唯一主路径回灌。

### 为什么坏

- `WorkerStateUploader` 的先进性不在“写得勤”，而在“写得唯一、可合并、可删除、可恢复”。
- 一旦执行层只消费 telemetry 成功感，就会重新容忍：
  - 多路旁写
  - metadata 全量覆盖
  - 局部成功掩盖最终状态错误
- 这会把真相回灌重新退回日志繁荣。

### Claude Code 式正解

- writeback path 应围绕唯一 writer、merge 语义与最终 authority state 对齐，而不是围绕请求数量与日志丰富度。


## 4. anti-zombie 口头化：源码先进性退回成功率与目录美学

### 坏解法

- 团队在复盘里夸赞目录更清楚、时序图更漂亮、恢复成功率更高，却不检查 stale writer、late finally、重复恢复与 terminal revive 是否仍被阻断。

### 为什么坏

- Claude Code 的源码先进性，不在“拆得更漂亮”，而在故障模型被提前编码进结构。
- 一旦 anti-zombie 口头化，团队就会重新把先进性理解成：
  - 文件分层更好看
  - 监控更丰富
  - 成功率更高
- 这会把真正值钱的 stale-safe、generation guard 与 anti-zombie projection 直接蒸发掉。

### Claude Code 式正解

- 源码先进性应首先被验证为 anti-zombie 结果面仍然存在，而不是目录美学仍然成立。


## 5. 假 reject：reject reason 存在却不保护恢复边界

### 坏解法

- 团队虽然写了 reject 字段，但真正拒收时仍只记“恢复没完全通过”“状态有点怪”，没有先保护 authority、resume order、writeback 主路径与 anti-zombie 结果面。

### 为什么坏

- 结构 reject 真正要先保护的是对象边界与恢复顺序，而不是先记录现象印象。
- 一旦 reject 顺序缺席，团队最容易在：
  - pointer 篡位时放过
  - writeback 分叉时放过
  - stale writer 未阻断时放过
- 这样 reject 会看起来更谨慎，实际却更晚、更软、更口头。

### Claude Code 式正解

- reject 应先拒收 authority 漂移、resume 顺序缺席、writeback 旁路与 anti-zombie 缺席，再谈症状观感。


## 6. 伪回退：回退到旧路径、旧 pointer 与监控绿灯

### 坏解法

- rollback 看起来存在，实际只是回到旧 pointer、重新点一次恢复、看监控恢复正常，而不明确回到哪个 authority object 与 recovery boundary。

### 为什么坏

- 结构 rollback 真正要回的是对象边界，而不是恢复入口。
- 一旦回退只剩路径与绿灯，later 维护者会知道“还能再连一次”，却不知道“该回退到哪个真相面”。

### Claude Code 式正解

- rollback 应先绑定 authority object、recovery boundary 与 writeback path，再允许操作 pointer、reconnect 与 UI。


## 7. 苏格拉底式追问

在你读完这些反例后，先问自己：

1. 我现在消费的是 authority object，还是 pointer 与 sidecar。
2. 我现在验证的是 writeback 主路径，还是日志繁荣。
3. 我现在保护的是 anti-zombie 结果面，还是恢复成功率与目录美学。
4. 我现在拒收的是对象边界漂移，还是 later 才补写的异常印象。
5. 我现在回退的是 recovery boundary，还是恢复入口与监控绿灯。

## 8. 一句话总结

真正危险的结构宿主验收执行失败，不是没写执行卡，而是写了执行卡却仍在围绕 breadcrumb 篡位、写回繁荣与 anti-zombie 口头化消费结构世界。
