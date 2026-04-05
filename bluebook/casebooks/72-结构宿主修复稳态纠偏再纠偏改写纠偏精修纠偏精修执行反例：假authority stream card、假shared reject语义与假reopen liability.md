# 结构宿主修复稳态纠偏再纠偏改写纠偏精修纠偏精修执行反例：假authority stream card、假shared reject语义与假reopen liability

这一章不再回答“结构 refinement correction refinement execution 该怎样运行”，而是回答：

- 为什么团队明明已经写了 `authority stream card`、shared `reject order` 与 `reopen drill`，仍会重新退回假 `authority stream card`、假 shared `reject` 语义与假 `reopen liability`。

它主要回答五个问题：

1. 为什么结构 refinement correction refinement execution 最危险的失败方式不是“没有 card”，而是“card 存在，却仍围绕 pointer、telemetry、目录整洁度、reconnect 成功率与作者说明工作”。
2. 为什么假 `authority stream card` 最容易把 `authority stream`、`lineage/fresh merge`、`single-source writeback`、`anti-zombie` 与 `repair attestation` 重新退回更像先进架构的说明稿。
3. 为什么假 shared `reject` 语义最容易把宿主、CI、评审与交接重新拆成四套不同的结构健康标准。
4. 为什么假 `reopen liability` 最容易把 fail-closed、worktree guard、unpushed commit guard 与 future reopen 的正式能力重新退回 reconnect 提示与作者记忆。
5. 怎样用苏格拉底式追问避免把这些反例读成“把结构运维卡再写严一点就好”。

## 0. 代表性源码锚点

- `claude-code-source-code/src/utils/QueryGuard.ts:1-121`
- `claude-code-source-code/src/utils/sessionRestore.ts:435-490`
- `claude-code-source-code/src/utils/conversationRecovery.ts:186-400`
- `claude-code-source-code/src/bridge/bridgePointer.ts:22-184`
- `claude-code-source-code/src/cli/transports/WorkerStateUploader.ts:3-112`
- `claude-code-source-code/src/services/api/sessionIngress.ts:57-211`
- `claude-code-source-code/src/utils/worktree.ts:1046-1172`
- `claude-code-source-code/src/cli/transports/SSETransport.ts:149-457`

这些锚点共同说明：

- 结构 refinement correction refinement execution 真正最容易失真的地方，不在 `authority stream card` 有没有写出来，而在 authority、lineage、single-source、anti-zombie、transport boundary、dirty git fail-closed 与 reopen boundary 是否仍围绕同一个结构真相面消费 later 维护者的判断。

## 1. 第一性原理

结构 refinement correction refinement execution 最危险的，不是：

- 没有 `authority stream card`
- 没有 shared `reject order`
- 没有 `reopen drill`

而是：

- 这些东西已经存在，却仍然围绕 pointer 还在、telemetry 转绿、目录更整洁、reconnect 成功与作者说“应该没事了”运作

一旦如此，团队就会重新回到：

1. 看 pointer 是否还能指过去。
2. 看 reconnect 是否成功。
3. 看结果没坏就默认 merge 没问题。
4. 看当前 worktree 还能用就默认 fail-closed 还在。
5. 看作者是不是还能解释。

而不再围绕：

- 同一个 `authority_object_id + externally_verifiable_head + single_source_ref + resume_lineage_ref + anti_zombie_evidence_ref + transport_boundary_attested + dirty_git_fail_closed_attested + threshold_retained_until`

## 2. 假authority stream card：card by pointer and health projection

### 坏解法

- 宿主、CI、评审与交接系统虽然都拿到了 `authority_stream_card_id` 与 `shared_reject_verdict=steady_state_chain_resealed`，但真正执行时只要 pointer 还活着、telemetry 还绿、目录更整洁、reconnect 成功、结构 prose 更完整，就默认 `authority_object_id`、`externally_verifiable_head`、`single_source_ref`、`resume_lineage_ref` 与 `repair_attestation_id` 仍围绕同一个结构真相面成立。

### 为什么坏

- 结构 `authority stream card` 保护的不是“现在更像一张正式运行卡”，而是 same authority、same writeback、same lineage 仍支撑 later 维护者的消费与反对能力。
- `BridgePointerSchema` 只说明去哪里找，不说明当前 authority 是谁。
- `sessionRestore` 说明恢复首先是切回同一个项目目录、同一份 transcript、同一份 session file，而不是“看起来接回来了”。
- `sessionIngress` 说明真正重要的是 append head adoption，不是恢复成功率。
- 一旦 card 退回 pointer 健康感与结构 prose，团队就会重新容忍：
  - `authority_object_id` 只是说明中的名词
  - `externally_verifiable_head` 被对象自述替代
  - `single_source_ref` 只是目录意图
  - `repair_attestation` 只是“团队都认同这个结构”

### Claude Code 式正解

- `shared_reject_verdict` 应先绑定同一个 `authority_object_id + externally_verifiable_head + single_source_ref + resume_lineage_ref + repair_attestation_id`，再宣布 `steady_state_chain_resealed`。

### 改写路径

1. 把 pointer 健康感、telemetry 转绿与结构 prose 降为观察材料。
2. 把 authority、head、single-source、lineage 与 attestation 提升为前提对象。
3. 任何先看健康投影、后看结构对象的 refinement correction refinement execution 都判为 drift。

## 3. 假shared reject语义：reject by health split

### 坏解法

- 宿主认为“pointer 还在，所以可以继续写”。
- CI 认为“telemetry 还绿，所以不用 reject”。
- 评审认为“目录整洁度更高，所以结构更先进”。
- 交接认为“reconnect 成功了，所以 later 团队能再慢慢修”。

表面上四方都在复述同一张 `authority stream card`，实际上他们消费的是四个不同对象：

1. breadcrumb projection
2. health projection
3. aesthetics projection
4. reconnect projection

### 为什么坏

- shared `reject order` 保护的不是“大家都写了 reject 这个词”，而是四类消费者必须围绕同一个结构真相面、同一条 fail-closed 语义链说话。
- 源码先进性真正成立的地方，不是任何单个投影都看起来健康，而是 authority、lineage、writeback、anti-zombie 与 fail-closed 仍围绕同一个 later-consumable object chain 工作。
- 一旦 shared `reject` 退回 health split，团队就会最先误以为：
  - “pointer 还在就说明 authority 还在”
  - “telemetry 还绿就说明 merge 没问题”
  - “目录更整洁就说明 single-source 更诚实”
  - “reconnect 成功就说明 reopen liability 还在”

### Claude Code 式正解

- shared `reject order` 必须先证明 `authority_object_id + externally_verifiable_head + single_source_ref + resume_lineage_ref + anti_zombie_evidence_ref + dirty_git_fail_closed_attested` 仍围绕同一个结构对象，再决定 `steady_state_chain_resealed`、`merge_reproof_required`、`fail_closed_reseal_required`、`reentry_required` 或 `reopen_required`。

### 改写路径

1. 把 pointer、telemetry、目录整洁度与 reconnect 成功率降为分角色观察。
2. 把 shared `reject` 明确绑定到同一个结构真相面。
3. 任何四类消费者共享同一 verdict 名字、却不共享同一 authority/writeback/fail-closed 对象的执行都判为 drift。

## 4. 假reopen liability：liability by reconnect hint and author memory

### 坏解法

- 团队虽然写了 `reopen drill`，但真正保留责任时只是在工单里写“以后有问题再 reconnect”“当前 worktree 看起来没事”“原作者知道要看哪几处”，却没有正式绑定 `worktree_change_guard`、`unpushed_commit_guard`、`dirty_git_fail_closed_attested`、`reopen_boundary`、`return_authority_object` 与 `threshold_retained_until`。

### 为什么坏

- `worktree.ts` 明确说明 dirty worktree、tracked changes、unpushed commit 与 git 失败必须 fail-closed，而不是交给好运气。
- `reopen liability` 不是“以后再试一次 reconnect”，而是“未来失稳时正式回到哪个 authority/writeback/boundary 组合并由谁负责”。
- 一旦 `reopen liability` 退回 reconnect 提示与作者记忆，结构 refinement correction refinement execution 就会重新退回：
  - worktree optimism
  - reconnect optimism
  - author-dependent reopen
  - boundary amnesia

### Claude Code 式正解

- `reopen liability` 必须显式绑定 `worktree_change_guard + unpushed_commit_guard + dirty_git_fail_closed_attested + reopen_boundary + return_authority_object + threshold_retained_until`，并把 later 团队应返回的结构对象写清楚。

### 改写路径

1. 把“原作者知道怎么接回来”降为非正式帮助。
2. 把 fail-closed、boundary 与 threshold 提升为 reopen 前提。
3. 任何依赖 reconnect 乐观主义而不是正式 boundary/guard 的结构 refinement correction refinement execution 都判为 drift。

## 5. 从更多角度看它为什么迷惑

这类假象之所以迷惑，至少有五个原因：

1. 它借用了 Claude Code 真正先进的外观：恢复、桥接、transport、worktree、writeback 都看起来像在认真工作。
2. 它满足了不同角色最容易满足的局部需求：宿主要能继续写，CI 要健康，评审要结构漂亮，交接要能接上。
3. 它把 later 团队应消费的结构真相面偷换成了多个看起来都合理的健康投影。
4. 它把 fail-closed 的第一性原理偷换成了“现在没出事”的运气。
5. 它把源码先进性从可复证对象链偷换成了更像先进架构的叙事。

## 6. 苏格拉底式自检

在你准备宣布“结构精修执行没有漂移”前，先问自己：

1. 我现在共享的是同一个结构真相面，还是四份彼此相像的健康投影。
2. 我现在共享的是同一条 `reject` 语义链，还是四个角色各自的健康标准。
3. 我现在保留的是 formal reopen 能力，还是 reconnect 成功之后的乐观希望。
4. later 团队如果拿不到当前作者，是否仍能只凭 card 复原 authority、lineage、writeback、fail-closed 与 threshold。
5. 我现在保护的是 Claude Code 的结构先进性，还是只是在模仿它更像先进系统的外观。
