# 研究日志

## 当前基线

- 日期: `2026-04-02`
- 工作目录: `/home/mo/m/projects/cc/analysis/.worktrees/mainloop`
- 研究源码: `claude-code-source-code/`
- 目标版本: `v2.1.88`

### A025. 宿主修复协议之后，下一层应进入宿主修复演练层

- `repair object` 即使已经被写成宿主可消费规则面，如果团队不能进一步把 Prompt 修复协议压成共享升级卡、rollback drill 与 re-entry drill，就仍会继续围绕 reviewer 解释、旧摘要与按钮状态判断；这说明 Prompt 线下一层最值钱的不是继续补 contract 口号，而是把 repair contract 压成 repair drill。
- `authority repair` 即使已经被写成宿主可消费规则面，如果团队不能进一步把治理修复协议压成共享升级卡、rollback drill 与 re-entry drill，就仍会继续围绕 mode 切换、审批补救与 token 面板判断；这说明治理线下一层最值钱的不是继续补 contract 叙述，而是把 repair contract 压成 repair drill，并持续证明安全设计与省 token 设计仍共用同一个治理对象。
- `authority recovery` 即使已经被写成宿主可消费规则面，如果团队不能进一步把结构修复协议压成共享升级卡、rollback drill 与 re-entry drill，就仍会继续围绕 pointer、重连碰碰运气与日志繁荣判断；这说明结构线下一层最值钱的不是继续补 contract 说明，而是把 repair contract 压成 repair drill，并持续证明 authority、writeback 与 anti-zombie 仍围绕同一个结构真相面成立。
- 这意味着蓝皮书在宿主修复协议之后需要继续长出“宿主修复演练层”：
  - `navigation/55` 负责统一入口。
  - `playbooks/38-40` 负责三类宿主修复协议的共享升级卡、rollback drill 与 re-entry drill。
- 这也意味着下一步如果还要继续深化，最值钱的候选不是继续补 playbook 口号，而是考虑新的 `casebooks/34+`，把这些 repair drill 最常见的假修复、假回滚与假重入写成新的反例层。

证据:

- `claude-code-source-code/src/constants/systemPromptSections.ts:20-65`
- `claude-code-source-code/src/constants/prompts.ts:105-115`
- `claude-code-source-code/src/constants/prompts.ts:343-347`
- `claude-code-source-code/src/utils/api.ts:136-405`
- `claude-code-source-code/src/services/api/claude.ts:1374-1485`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:494-698`
- `claude-code-source-code/src/services/compact/prompt.ts:293-337`
- `claude-code-source-code/src/services/compact/compact.ts:330-711`
- `claude-code-source-code/src/services/compact/postCompactCleanup.ts:31-66`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:106-619`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1407-1450`
- `claude-code-source-code/src/cli/structuredIO.ts:362-657`
- `claude-code-source-code/src/utils/permissions/permissionSetup.ts:84-645`
- `claude-code-source-code/src/utils/permissions/permissions.ts:929-1318`
- `claude-code-source-code/src/utils/analyzeContext.ts:1098-1382`
- `claude-code-source-code/src/query/tokenBudget.ts:22-92`
- `claude-code-source-code/src/utils/QueryGuard.ts:1-121`
- `claude-code-source-code/src/utils/task/framework.ts:77-248`
- `claude-code-source-code/src/utils/sessionRestore.ts:435-490`
- `claude-code-source-code/src/utils/conversationRecovery.ts:533-570`
- `claude-code-source-code/src/bridge/bridgePointer.ts:22-184`
- `claude-code-source-code/src/cli/transports/WorkerStateUploader.ts:3-112`

### A024. 宿主验收纠偏之后，下一层应进入宿主修复协议层

- `compiled request truth` 即使已经被写成固定纠偏顺序、拒收升级路径与模板骨架，如果团队不能继续把 Prompt 执行纠偏压成 repair object、reject escalation、rollback boundary 与 re-entry qualification 的宿主可消费规则面，就仍会继续围绕整改经验与 reviewer 心法工作；这说明 Prompt 线下一层最值钱的不是继续补 guide，而是把 execution correction 压成 repair contract。
- 统一定价治理对象即使已经被写成固定纠偏顺序、拒收升级路径与模板骨架，如果团队不能继续把治理执行纠偏压成 authority repair、ledger rebuild、decision window reset、continuation repricing 与 rollback object 的宿主可消费规则面，就仍会继续围绕 mode 调参与审批补救工作；这说明治理线下一层最值钱的不是继续补 guide，而是把 execution correction 压成 repair contract。
- 结构真相面即使已经被写成固定纠偏顺序、拒收升级路径与模板骨架，如果团队不能继续把结构执行纠偏压成 authority recovery、resume replay order、writeback restoration、anti-zombie verdict 与 boundary reset 的宿主可消费规则面，就仍会继续围绕 pointer 修补、重连碰运气与日志繁荣工作；这说明结构线下一层最值钱的不是继续补 guide，而是把 execution correction 压成 repair contract。
- 这意味着蓝皮书在宿主验收纠偏之后需要继续长出“宿主修复协议层”：
  - `navigation/54` 负责统一入口。
  - `api/57-59` 负责三类宿主验收执行纠偏的修复卡、reject 升级语义与重入规则面。
- 这也意味着下一步如果还要继续深化，最值钱的候选不是继续补 api 叙述，而是考虑新的 `playbooks/38+`，把这些修复协议继续压成共享升级卡、回退演练与重入 drill。

证据:

- `claude-code-source-code/src/constants/systemPromptSections.ts:20-65`
- `claude-code-source-code/src/constants/prompts.ts:105-115`
- `claude-code-source-code/src/constants/prompts.ts:343-347`
- `claude-code-source-code/src/utils/api.ts:136-405`
- `claude-code-source-code/src/services/api/claude.ts:1374-1485`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:494-698`
- `claude-code-source-code/src/utils/messages.ts:1989-2148`
- `claude-code-source-code/src/utils/messages.ts:5133-5458`
- `claude-code-source-code/src/services/compact/prompt.ts:293-337`
- `claude-code-source-code/src/services/compact/compact.ts:330-711`
- `claude-code-source-code/src/services/compact/postCompactCleanup.ts:31-66`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:106-619`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1407-1450`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1506-1531`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1735-1747`
- `claude-code-source-code/src/cli/structuredIO.ts:362-657`
- `claude-code-source-code/src/utils/permissions/permissionSetup.ts:84-645`
- `claude-code-source-code/src/utils/permissions/permissions.ts:929-1318`
- `claude-code-source-code/src/utils/analyzeContext.ts:1098-1382`
- `claude-code-source-code/src/query/tokenBudget.ts:22-92`
- `claude-code-source-code/src/utils/QueryGuard.ts:1-121`
- `claude-code-source-code/src/utils/task/framework.ts:77-248`
- `claude-code-source-code/src/utils/sessionRestore.ts:435-490`
- `claude-code-source-code/src/utils/conversationRecovery.ts:533-570`
- `claude-code-source-code/src/bridge/bridgePointer.ts:22-184`
- `claude-code-source-code/src/cli/transports/WorkerStateUploader.ts:3-112`

### A023. 宿主验收失真之后，下一层应进入宿主验收纠偏层

- `compiled request truth` 即使已经被写成执行失真反例，如果团队不能进一步把表单化绿灯、假 reject、伪 rollback、protocol truth 被 CI 绿灯掩盖与 lawful forgetting 被 summary handoff 替位这些坏模式压回固定纠偏顺序、拒收升级路径与模板骨架，Prompt 宿主验收就仍会围绕更制度化的替身工作；这说明 Prompt 线下一层最值钱的不是继续补坏样例，而是把 execution distortion 压成 correction guide。
- 统一定价治理对象即使已经被写成执行失真反例，如果团队不能进一步把 mode 绿灯、假窗口对齐、免费继续、mode/file 回退与 later 补写 reject 压回固定纠偏顺序、拒收升级路径与模板骨架，治理宿主验收就仍会围绕更制度化的交互投影工作；这说明治理线下一层最值钱的不是继续补坏样例，而是把 execution distortion 压成 correction guide。
- 结构真相面即使已经被写成执行失真反例，如果团队不能进一步把 breadcrumb 篡位、写回繁荣、anti-zombie 口头化、pointer 回退与目录美学崇拜压回固定纠偏顺序、拒收升级路径与模板骨架，结构宿主验收就仍会围绕更制度化的监控绿灯工作；这说明结构线下一层最值钱的不是继续补坏样例，而是把 execution distortion 压成 correction guide。
- 这意味着蓝皮书在宿主验收失真之后需要继续长出“宿主验收纠偏层”：
  - `navigation/53` 负责统一入口。
  - `guides/60-62` 负责三类宿主验收执行失真的固定纠偏顺序、拒收升级路径与改写模板骨架。
- 这也意味着下一步如果还要继续深化，最值钱的候选不是继续补 guide 叙述，而是考虑新的 `api/57+` 或 `playbooks/38+`，把这些执行纠偏继续压成宿主可消费规则面、共享升级卡或新的演练手册。

证据:

- `claude-code-source-code/src/constants/systemPromptSections.ts:20-65`
- `claude-code-source-code/src/constants/prompts.ts:105-115`
- `claude-code-source-code/src/constants/prompts.ts:343-347`
- `claude-code-source-code/src/utils/api.ts:136-405`
- `claude-code-source-code/src/services/api/claude.ts:1374-1485`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:494-698`
- `claude-code-source-code/src/utils/messages.ts:1989-2148`
- `claude-code-source-code/src/utils/messages.ts:5133-5458`
- `claude-code-source-code/src/services/compact/prompt.ts:293-337`
- `claude-code-source-code/src/services/compact/compact.ts:330-711`
- `claude-code-source-code/src/services/compact/postCompactCleanup.ts:31-66`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:106-619`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1407-1450`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1506-1531`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1735-1747`
- `claude-code-source-code/src/cli/structuredIO.ts:362-657`
- `claude-code-source-code/src/utils/permissions/permissionSetup.ts:84-645`
- `claude-code-source-code/src/utils/permissions/permissions.ts:929-1318`
- `claude-code-source-code/src/utils/analyzeContext.ts:1098-1382`
- `claude-code-source-code/src/query/tokenBudget.ts:22-92`
- `claude-code-source-code/src/utils/QueryGuard.ts:1-121`
- `claude-code-source-code/src/utils/task/framework.ts:77-248`
- `claude-code-source-code/src/utils/sessionRestore.ts:435-490`
- `claude-code-source-code/src/utils/conversationRecovery.ts:533-570`
- `claude-code-source-code/src/bridge/bridgePointer.ts:22-184`
- `claude-code-source-code/src/cli/transports/WorkerStateUploader.ts:3-112`

### A022. 宿主验收执行之后，下一层应进入宿主验收失真反例层

- `compiled request truth` 即使已经被写成共享执行卡、拒收顺序与回退剧本，如果团队不能进一步指出表单化绿灯、假 reject、伪 rollback、protocol truth 被 CI 绿灯掩盖与 lawful forgetting 被 summary handoff 替位这些执行失真，Prompt 宿主验收就仍会继续围绕更制度化的假真相工作；这说明 Prompt 线下一层最值钱的不是继续补 playbook，而是把 execution layer 压成 distortion casebook。
- 统一定价治理对象即使已经被写成共享执行卡、拒收顺序与回退剧本，如果团队不能进一步指出 mode 绿灯、假窗口对齐、免费继续、mode/file 回退与 later 补写 reject 这些执行失真，治理宿主验收就仍会继续围绕更制度化的交互投影工作；这说明治理线下一层最值钱的不是继续补执行说明，而是把 execution layer 压成 distortion casebook。
- 结构真相面即使已经被写成共享执行卡、拒收顺序与回退剧本，如果团队不能进一步指出 breadcrumb 篡位、写回繁荣、anti-zombie 口头化、pointer 回退与目录美学崇拜这些执行失真，结构宿主验收就仍会继续围绕更制度化的监控绿灯工作；这说明结构线下一层最值钱的不是继续补结构执行叙述，而是把 execution layer 压成 distortion casebook。
- 这意味着蓝皮书在宿主验收执行之后需要继续长出“宿主验收失真反例层”：
  - `navigation/52` 负责统一入口。
  - `casebooks/31-33` 负责三类宿主验收执行的表单化绿灯、假拒收、伪回退与更高级执行幻觉反例。
- 这也意味着下一步如果还要继续深化，最值钱的候选不是继续补坏样例名录，而是考虑新的 `guides/60+`，把这些执行失真继续压成固定纠偏顺序、拒收升级路径与改写模板骨架。

证据:

- `claude-code-source-code/src/constants/systemPromptSections.ts:20-65`
- `claude-code-source-code/src/constants/prompts.ts:105-115`
- `claude-code-source-code/src/constants/prompts.ts:343-347`
- `claude-code-source-code/src/utils/api.ts:136-405`
- `claude-code-source-code/src/services/api/claude.ts:1374-1485`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:494-698`
- `claude-code-source-code/src/utils/messages.ts:1989-2148`
- `claude-code-source-code/src/utils/messages.ts:5133-5458`
- `claude-code-source-code/src/services/compact/prompt.ts:293-337`
- `claude-code-source-code/src/services/compact/compact.ts:330-711`
- `claude-code-source-code/src/services/compact/postCompactCleanup.ts:31-66`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:106-619`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1407-1450`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1506-1531`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1735-1747`
- `claude-code-source-code/src/cli/structuredIO.ts:362-657`
- `claude-code-source-code/src/utils/permissions/permissionSetup.ts:84-645`
- `claude-code-source-code/src/utils/permissions/permissions.ts:929-1318`
- `claude-code-source-code/src/utils/analyzeContext.ts:1098-1382`
- `claude-code-source-code/src/query/tokenBudget.ts:22-92`
- `claude-code-source-code/src/utils/QueryGuard.ts:1-121`
- `claude-code-source-code/src/utils/task/framework.ts:77-248`
- `claude-code-source-code/src/utils/sessionRestore.ts:435-490`
- `claude-code-source-code/src/utils/conversationRecovery.ts:533-570`
- `claude-code-source-code/src/bridge/bridgePointer.ts:22-184`
- `claude-code-source-code/src/cli/transports/WorkerStateUploader.ts:3-112`

### A021. 宿主验收协议之后，下一层应进入宿主验收执行层

- `compiled request truth` 即使已经被写成宿主可消费的验收协议，如果团队不能进一步把它压成共享执行卡、固定拒收顺序与回退剧本，就仍会继续围绕 prompt 截图、摘要交接与 last-message heuristic 工作；这说明 Prompt 线下一层最值钱的不是继续补 contract，而是把 contract 压成 acceptance execution。
- 统一定价治理对象即使已经被写成宿主可消费的验收协议，如果团队不能进一步把它压成 authority source、permission ledger、decision window、continuation gate 与 rollback object 的固定执行顺序，就仍会继续围绕 mode、审批弹窗与 token 仪表盘工作；这说明治理线下一层最值钱的不是继续补协议字段，而是把协议字段压成 acceptance execution。
- 结构真相面即使已经被写成宿主可消费的验收协议，如果团队不能进一步把它压成 authority object、resume order、recovery boundary、writeback path 与 anti-zombie projection 的固定执行顺序，就仍会继续围绕 pointer、spinner、成功率与作者说明工作；这说明结构线下一层最值钱的不是继续补结构 contract，而是把 contract 压成 acceptance execution。
- 这意味着蓝皮书在宿主验收协议之后需要继续长出“宿主验收执行层”：
  - `navigation/51` 负责统一入口。
  - `playbooks/35-37` 负责三类宿主验收协议的执行卡、拒收顺序与回退剧本。
- 这也意味着下一步如果还要继续深化，最值钱的候选不是继续补 playbook 叙述，而是考虑新的 `casebooks/31+`，把这些验收执行最常见的表单化绿灯、假拒收与伪回退写成新的反例层。

证据:

- `claude-code-source-code/src/constants/systemPromptSections.ts:20-65`
- `claude-code-source-code/src/constants/prompts.ts:105-115`
- `claude-code-source-code/src/utils/api.ts:136-405`
- `claude-code-source-code/src/services/api/claude.ts:1374-1485`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:494-698`
- `claude-code-source-code/src/utils/messages.ts:1989-2148`
- `claude-code-source-code/src/utils/messages.ts:5133-5458`
- `claude-code-source-code/src/services/compact/prompt.ts:293-337`
- `claude-code-source-code/src/services/compact/compact.ts:330-711`
- `claude-code-source-code/src/services/compact/postCompactCleanup.ts:31-66`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:106-619`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1407-1450`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1506-1531`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1735-1747`
- `claude-code-source-code/src/cli/structuredIO.ts:362-657`
- `claude-code-source-code/src/utils/permissions/permissionSetup.ts:84-645`
- `claude-code-source-code/src/utils/permissions/permissions.ts:929-1318`
- `claude-code-source-code/src/utils/analyzeContext.ts:1098-1382`
- `claude-code-source-code/src/query/tokenBudget.ts:22-92`
- `claude-code-source-code/src/utils/QueryGuard.ts:1-121`
- `claude-code-source-code/src/utils/task/framework.ts:77-248`
- `claude-code-source-code/src/utils/sessionRestore.ts:435-490`
- `claude-code-source-code/src/utils/conversationRecovery.ts:533-570`
- `claude-code-source-code/src/bridge/bridgePointer.ts:22-184`
- `claude-code-source-code/src/cli/transports/WorkerStateUploader.ts:3-112`

### A020. 宿主迁移纠偏之后，下一层应进入宿主验收协议层

- `compiled request truth` 即使已经被写成固定纠偏顺序与拒收规则，如果团队不能进一步把它压成 `compiled_request_truth`、`section_registry_snapshot`、`protocol_transcript_health`、`lawful_forgetting_object` 与 `continue_qualification` 的宿主可消费规则面，就仍会继续围绕 builder 心里的经验判断工作；这说明 Prompt 线下一层最值钱的不是继续补纠偏描述，而是把纠偏压成 acceptance contract。
- `governance control plane object` 即使已经被写成固定纠偏顺序与拒收规则，如果团队不能进一步把它压成 authority source、typed decision、permission ledger、decision window、continuation gate 与 rollback object 的宿主可消费规则面，就仍会继续围绕 mode、弹窗与仪表盘工作；这说明治理线下一层最值钱的不是继续补 guide，而是把纠偏压成 acceptance contract。
- 结构真相面即使已经被写成固定纠偏顺序与拒收规则，如果团队不能进一步把它压成 authority state、resume order、recovery boundary、writeback path 与 anti-zombie projection 的宿主可消费规则面，就仍会继续围绕 pointer、成功率与恢复口述工作；这说明结构线下一层最值钱的不是继续补 guide，而是把纠偏压成 acceptance contract。
- 这意味着蓝皮书在宿主迁移纠偏之后需要继续长出“宿主验收协议层”：
  - `navigation/50` 负责统一入口。
  - `api/54-56` 负责三类宿主迁移纠偏的验收卡、拒收语义与规则面。
- 这也意味着下一步如果还要继续深化，最值钱的候选不是继续补 contract 叙述，而是考虑新的 `playbooks/35+`，把这些验收协议继续压成固定验收卡、拒收执行顺序与回退处理剧本。

证据:

- `claude-code-source-code/src/constants/systemPromptSections.ts:20-65`
- `claude-code-source-code/src/constants/prompts.ts:105-115`
- `claude-code-source-code/src/utils/api.ts:136-405`
- `claude-code-source-code/src/services/api/claude.ts:1374-1485`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:494-698`
- `claude-code-source-code/src/utils/messages.ts:1989-2148`
- `claude-code-source-code/src/utils/messages.ts:5133-5458`
- `claude-code-source-code/src/services/compact/compact.ts:330-711`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:106-619`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:337-348`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1407-1450`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1506-1531`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1735-1747`
- `claude-code-source-code/src/cli/structuredIO.ts:362-657`
- `claude-code-source-code/src/cli/print.ts:1052-1075`
- `claude-code-source-code/src/cli/print.ts:4568-4641`
- `claude-code-source-code/src/utils/permissions/permissionSetup.ts:510-645`
- `claude-code-source-code/src/utils/permissions/permissions.ts:1071-1318`
- `claude-code-source-code/src/utils/sessionState.ts:92-149`
- `claude-code-source-code/src/state/onChangeAppState.ts:43-92`
- `claude-code-source-code/src/utils/analyzeContext.ts:1098-1382`
- `claude-code-source-code/src/query/tokenBudget.ts:22-92`
- `claude-code-source-code/src/utils/QueryGuard.ts:1-121`
- `claude-code-source-code/src/utils/task/framework.ts:77-248`
- `claude-code-source-code/src/utils/sessionRestore.ts:435-490`
- `claude-code-source-code/src/utils/conversationRecovery.ts:533-570`
- `claude-code-source-code/src/services/api/sessionIngress.ts:57-170`
- `claude-code-source-code/src/bridge/remoteBridgeCore.ts:450-529`
- `claude-code-source-code/src/bridge/remoteBridgeCore.ts:824-880`
- `claude-code-source-code/src/bridge/bridgePointer.ts:22-184`
- `claude-code-source-code/src/cli/transports/WorkerStateUploader.ts:3-112`

### A019. 宿主迁移失真之后，下一层应进入宿主迁移纠偏层

- `compiled request truth` 即使已经被写成宿主迁移失真反例，团队若不能把截图交接、摘要 handoff、黑箱 cache 曲线与 `stop_reason` 幻觉重新压回 `compiled request truth ledger`、protocol truth、cache explainability 与 continue qualification，就仍会继续围绕更高级的替身工作；这说明 Prompt 线下一层最值钱的不是继续补坏例子，而是把坏例子压成固定纠偏顺序与拒收规则。
- `governance control plane object` 即使已经被写成宿主迁移失真反例，团队若不能把 mode 崇拜、权限账本缺席、假窗口对齐与默认继续重新压回 authority source、pending permission ledger、decision window、continuation gate 与 rollback object，就仍会继续围绕界面投影工作；这说明治理线下一层最值钱的不是继续补反例，而是把坏例子压成固定纠偏顺序与拒收规则。
- 结构真相面即使已经被写成宿主迁移失真反例，团队若不能把伪恢复采纳、指针健康幻觉、写回分叉与成功率崇拜重新压回 authority state、resume 顺序、recovery boundary、writeback 主路径与 anti-zombie 结果面，就仍会继续围绕恢复错觉工作；这说明结构线下一层最值钱的不是继续补事故叙事，而是把坏例子压成固定纠偏顺序与拒收规则。
- 这意味着蓝皮书在宿主迁移失真之后需要继续长出“宿主迁移纠偏层”：
  - `navigation/49` 负责统一入口。
  - `guides/57-59` 负责三类宿主迁移失真的固定纠偏顺序、拒收规则与模板骨架。
- 这也意味着下一步如果还要继续深化，最值钱的候选不是继续补纠偏口号，而是考虑新的 `playbooks/35+` 或 `api/54+`，把这些纠偏继续压成固定验收卡、拒收协议或宿主可消费规则面。

证据:

- `claude-code-source-code/src/constants/systemPromptSections.ts:20-65`
- `claude-code-source-code/src/constants/prompts.ts:105-115`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:247-666`
- `claude-code-source-code/src/utils/messages.ts:1989-2148`
- `claude-code-source-code/src/utils/messages.ts:5133-5458`
- `claude-code-source-code/src/services/compact/compact.ts:330-711`
- `claude-code-source-code/src/query/stopHooks.ts:257-331`
- `claude-code-source-code/src/query.ts:1223-1340`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:106-260`
- `claude-code-source-code/src/cli/structuredIO.ts:263-657`
- `claude-code-source-code/src/cli/print.ts:4568-4641`
- `claude-code-source-code/src/utils/permissions/permissionSetup.ts:510-645`
- `claude-code-source-code/src/utils/permissions/permissions.ts:929-1318`
- `claude-code-source-code/src/utils/analyzeContext.ts:1020-1382`
- `claude-code-source-code/src/utils/sessionRestore.ts:435-490`
- `claude-code-source-code/src/utils/conversationRecovery.ts:533-570`
- `claude-code-source-code/src/services/api/sessionIngress.ts:57-170`
- `claude-code-source-code/src/bridge/remoteBridgeCore.ts:450-529`
- `claude-code-source-code/src/bridge/bridgePointer.ts:22-184`
- `claude-code-source-code/src/cli/transports/WorkerStateUploader.ts:3-112`

### A018. 宿主迁移演练之后，下一层应进入宿主迁移失真反例层

- `compiled request truth` 即使已经被写成交接包、灰度记录与回退演练，团队仍最容易把它重新退回 prompt 摘要、截图 handoff、黑箱 cache 指标与 `stop_reason` 继续判断；这说明 Prompt 线下一层最值钱的不是继续补 playbook，而是把这些“像成功”的信号压成 casebook。
- `governance control plane object` 即使已经被写成交接包、灰度记录与回退演练，团队仍最容易把它重新退回 mode 面板、弹窗记忆、假窗口对齐、免费继续与文件级回退；这说明治理线下一层最值钱的不是继续补演练句子，而是把这些“像对齐”的信号压成 casebook。
- 结构真相面即使已经被写成交接包、灰度记录与回退演练，团队仍最容易把它重新退回伪恢复采纳、指针健康幻觉、writeback 分叉与成功率崇拜；这说明结构线下一层最值钱的不是继续补恢复 drill，而是把这些“像恢复成功”的信号压成 casebook。
- 这意味着蓝皮书在宿主迁移演练之后需要继续长出“宿主迁移失真反例层”：
  - `navigation/48` 负责统一入口。
  - `casebooks/28-30` 负责三类宿主迁移的伪交接、假灰度与回退幻觉。
- 这也意味着下一步如果还要继续深化，最值钱的候选不是继续补坏样例名录，而是考虑新的 `guides/57+` 或 `playbooks/35+`，把这些失真压成固定纠偏顺序、拒收规则或模板骨架。

证据:

- `claude-code-source-code/src/constants/systemPromptSections.ts:20-65`
- `claude-code-source-code/src/constants/prompts.ts:105-115`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:247-666`
- `claude-code-source-code/src/utils/messages.ts:1989-2148`
- `claude-code-source-code/src/utils/messages.ts:5133-5458`
- `claude-code-source-code/src/services/compact/compact.ts:330-711`
- `claude-code-source-code/src/query/stopHooks.ts:257-331`
- `claude-code-source-code/src/query.ts:1223-1340`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:106-260`
- `claude-code-source-code/src/cli/structuredIO.ts:263-657`
- `claude-code-source-code/src/cli/print.ts:4568-4641`
- `claude-code-source-code/src/utils/permissions/permissions.ts:929-1318`
- `claude-code-source-code/src/utils/analyzeContext.ts:1020-1382`
- `claude-code-source-code/src/utils/sessionRestore.ts:435-490`
- `claude-code-source-code/src/utils/conversationRecovery.ts:533-570`
- `claude-code-source-code/src/services/api/sessionIngress.ts:57-170`
- `claude-code-source-code/src/bridge/remoteBridgeCore.ts:450-529`
- `claude-code-source-code/src/bridge/bridgePointer.ts:22-184`
- `claude-code-source-code/src/cli/transports/WorkerStateUploader.ts:3-112`

### A017. 宿主迁移工单之后，下一层应进入宿主迁移演练层

- `compiled request truth` 即使已经被写成宿主迁移工单，如果团队仍不能把 section projection、protocol rewrite、cache explainability、compact boundary 与 continue qualification 压成交接包、灰度记录与回退演练，Prompt 迁移就仍会退回 prompt 截图、摘要 handoff 与黑箱继续；这说明 Prompt 线下一层最值钱的不是继续补工单，而是把迁移工单压成 playbook。
- `governance control plane object` 即使已经被写成宿主迁移工单，如果团队仍不能把 authority source、typed decision、decision window、continuation gate 与 rollback object 压成交接包、灰度记录与回退演练，治理迁移就仍会退回 mode 面板、pending action 文案与文件级回退；这说明治理线下一层最值钱的不是继续补控制面说明，而是把迁移工单压成 playbook。
- 结构真相面即使已经被写成宿主迁移工单，如果团队仍不能把 authority state、transition legality、anti-zombie evidence、recovery boundary 与 writeback 主路径压成交接包、灰度记录与回退演练，结构迁移就仍会退回 spinner、pointer、成功率与作者口述；这说明结构线下一层最值钱的不是继续补恢复顺序，而是把迁移工单压成 playbook。
- 这意味着蓝皮书在宿主迁移工单之后需要继续长出“宿主迁移演练层”：
  - `navigation/47` 负责统一入口。
  - `playbooks/32-34` 负责三类宿主迁移的交接包、灰度记录与回退演练。
- 这也意味着下一步如果还要继续深化，最值钱的候选不是继续补 playbook 句子，而是考虑新的 `casebooks/28+`，把这些迁移演练最常见的伪交接、假灰度与回退幻觉写成新的反例层。

证据:

- `claude-code-source-code/src/constants/systemPromptSections.ts:20-65`
- `claude-code-source-code/src/utils/messages.ts:1989-2148`
- `claude-code-source-code/src/utils/messages.ts:5133-5458`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:247-666`
- `claude-code-source-code/src/services/compact/compact.ts:330-711`
- `claude-code-source-code/src/query/stopHooks.ts:257-331`
- `claude-code-source-code/src/query.ts:1223-1340`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:106-260`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1407-1450`
- `claude-code-source-code/src/cli/structuredIO.ts:362-657`
- `claude-code-source-code/src/cli/print.ts:2918-3010`
- `claude-code-source-code/src/utils/permissions/permissions.ts:929-1318`
- `claude-code-source-code/src/utils/analyzeContext.ts:1020-1382`
- `claude-code-source-code/src/utils/QueryGuard.ts:1-121`
- `claude-code-source-code/src/utils/task/framework.ts:77-248`
- `claude-code-source-code/src/state/onChangeAppState.ts:50-92`
- `claude-code-source-code/src/utils/sessionState.ts:92-149`
- `claude-code-source-code/src/services/api/sessionIngress.ts:57-170`
- `claude-code-source-code/src/bridge/remoteBridgeCore.ts:450-529`
- `claude-code-source-code/src/bridge/bridgePointer.ts:22-184`
- `claude-code-source-code/src/cli/transports/WorkerStateUploader.ts:3-112`

### A016. 宿主接入审读之后，下一层应进入宿主迁移工单层

- `compiled request truth` 即使已经进入宿主接入审读层，如果团队仍不能把输入面冻结、协议重写、cache explainability、lawful forgetting 与 continue qualification 压成固定实施顺序，Prompt 宿主接入就仍会退回字符串接入、raw transcript 与 summary handoff；这说明 Prompt 线下一层最值钱的不是继续补排查 checklist，而是把审读结果压成迁移工单、交接包与灰度发布顺序。
- `governance control plane object` 即使已经进入宿主接入审读层，如果团队仍不能把 authority source、typed decision、decision window、continuation gate 与 rollback object 压成固定实施顺序，治理宿主接入就仍会退回 mode 面板、pending action 文案、token 仪表盘与文件级回退；这说明治理线下一层最值钱的不是继续补权限说明，而是把审读结果压成统一定价控制面的迁移工单。
- 结构故障模型即使已经进入宿主接入审读层，如果团队仍不能把 authority state、transition legality、anti-zombie evidence、recovery boundary 与 writeback 主路径压成固定实施顺序，结构宿主接入就仍会退回 spinner、pointer、成功率与作者说明；这说明结构线下一层最值钱的不是继续补恢复演练，而是把审读结果压成结构真相面的迁移工单。
- 这意味着蓝皮书在宿主接入审读之后需要继续长出“宿主迁移工单层”：
  - `navigation/46` 负责统一入口。
  - `guides/54-56` 负责三类宿主接入的迁移工单、交接包与灰度发布顺序。
- 这也意味着下一步如果还要继续深化，最值钱的候选不是继续补迁移口号，而是考虑新的 `playbooks/32+` 或 `casebooks/28+`，把这些迁移工单继续压成交接样例、灰度记录与回退演练。

证据:

- `claude-code-source-code/src/constants/systemPromptSections.ts:20-65`
- `claude-code-source-code/src/utils/api.ts:321-405`
- `claude-code-source-code/src/utils/messages.ts:1989-2148`
- `claude-code-source-code/src/utils/messages.ts:5133-5458`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:247-666`
- `claude-code-source-code/src/services/compact/compact.ts:330-711`
- `claude-code-source-code/src/query/stopHooks.ts:257-331`
- `claude-code-source-code/src/query.ts:1223-1340`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:106-260`
- `claude-code-source-code/src/cli/structuredIO.ts:149-657`
- `claude-code-source-code/src/utils/permissions/permissions.ts:593-984`
- `claude-code-source-code/src/query/tokenBudget.ts:45-92`
- `claude-code-source-code/src/utils/QueryGuard.ts:1-121`
- `claude-code-source-code/src/utils/task/framework.ts:77-248`
- `claude-code-source-code/src/state/onChangeAppState.ts:50-92`
- `claude-code-source-code/src/utils/sessionState.ts:92-149`
- `claude-code-source-code/src/services/api/sessionIngress.ts:57-170`
- `claude-code-source-code/src/bridge/remoteBridgeCore.ts:450-529`
- `claude-code-source-code/src/bridge/bridgePointer.ts:22-184`

### A00l. 机制对象成立之后，下一层应进入持续验证层

- `compiled request truth` 下一层最值钱的不是继续补机制解释，而是把 section continuity、stable bytes、protocol rewrite 与 lawful forgetting 压成长期运行里的回归门禁；否则 Prompt 线很快会重新退回原文 prompt 崇拜与摘要崇拜。
- `governance control plane object` 下一层最值钱的不是继续补控制面说明，而是把 authority source、typed decision、decision window、continuation gate 与 rollback object 压成长期运行里的回归门禁；否则治理线很快会重新退回 modal、仪表盘与阈值崇拜。
- `evolvable kernel object boundary` 下一层最值钱的不是继续补结构原则，而是把 authority、transition legality、dependency honesty、recovery asset 与 anti-zombie 压成长期演化里的回归门禁；否则结构线很快会重新退回目录审美、规则存在性与作者记忆。
- 这意味着蓝皮书在机制回灌之后需要继续长出“机制验证层”：
  - `navigation/39` 负责统一入口。
  - `playbooks/26-28` 负责三类对象的持续回归、拒收条件与复盘最小字段。
- 这也意味着下一步如果还要继续深化，最值钱的候选不是更多 runbook，而是考虑新增 `casebooks/22+`，把这些机制验证最常见的 drift 与形式主义失真写成新的反例层。

证据:

- `claude-code-source-code/src/constants/systemPromptSections.ts:1-51`
- `claude-code-source-code/src/constants/prompts.ts:491-557`
- `claude-code-source-code/src/utils/systemPrompt.ts:28-104`
- `claude-code-source-code/src/query/stopHooks.ts:84-120`
- `claude-code-source-code/src/utils/messages.ts:1989-2148`
- `claude-code-source-code/src/services/compact/prompt.ts:1-260`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:243-520`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:57-240`
- `claude-code-source-code/src/cli/structuredIO.ts:149-657`
- `claude-code-source-code/src/utils/permissions/permissions.ts:593-984`
- `claude-code-source-code/src/state/onChangeAppState.ts:43-92`
- `claude-code-source-code/src/utils/sessionState.ts:92-146`
- `claude-code-source-code/src/query/tokenBudget.ts:45-92`
- `claude-code-source-code/src/query/config.ts:1-45`
- `claude-code-source-code/src/query/deps.ts:1-40`
- `claude-code-source-code/src/utils/QueryGuard.ts:1-108`
- `claude-code-source-code/src/utils/task/framework.ts:160-269`
- `claude-code-source-code/src/bridge/bridgePointer.ts:22-184`

### A00m. 机制验证之后，下一层应进入机制失真反例层

- `compiled request truth` 即使已经进入验证层，仍最容易死于多重真相生产者、协议真相泄漏、side loop 自行重建世界、lawful forgetting 退回摘要崇拜与 cache break 玄学化；这说明 Prompt 魔力如果不能被持续解释成“唯一编译链 + 唯一协议链 + 唯一继续链”，就会重新退回 prompt 崇拜。
- `governance control plane object` 即使已经进入验证层，仍最容易死于 mode 崇拜、审批事件被误当 typed decision、Context Usage 退回 token 仪表盘、continuation 退回默认继续幻觉与 rollback 退回文件级回退；这说明治理控制面如果不能持续作为统一判断对象存在，就会重新退回局部 KPI。
- `evolvable kernel object boundary` 即使已经进入验证层，仍最容易死于多点权威、dependency seam 被打穿、陈旧快照回写 fresh state、recovery asset 篡位与 anti-zombie 口头化；这说明源码先进性如果不能持续编码故障模型，就会重新退回目录审美与作者记忆。
- 这意味着蓝皮书在“机制验证层”之后需要继续长出“机制失真反例层”：
  - `navigation/40` 负责统一入口。
  - `casebooks/22-24` 负责三类对象最常见的形式主义替身与坏解法。
- 这也意味着下一步如果还要继续深化，最值钱的候选不是继续补坏解法列表，而是考虑新增 `philosophy/81+`，把 Prompt 编译链魔力、统一定价治理与故障模型编码重新压成更不可约的判断。

证据:

- `claude-code-source-code/src/constants/systemPromptSections.ts:20-65`
- `claude-code-source-code/src/constants/prompts.ts:105-115`
- `claude-code-source-code/src/utils/api.ts:321-405`
- `claude-code-source-code/src/utils/messages.ts:1989-2148`
- `claude-code-source-code/src/utils/messages.ts:5133-5460`
- `claude-code-source-code/src/services/compact/prompt.ts:61-143`
- `claude-code-source-code/src/services/compact/compact.ts:330-366`
- `claude-code-source-code/src/query/stopHooks.ts:175-331`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:106-260`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:464-519`
- `claude-code-source-code/src/cli/structuredIO.ts:149-657`
- `claude-code-source-code/src/utils/permissions/permissions.ts:593-984`
- `claude-code-source-code/src/query/tokenBudget.ts:45-92`
- `claude-code-source-code/src/utils/sessionState.ts:92-149`
- `claude-code-source-code/src/state/onChangeAppState.ts:43-92`
- `claude-code-source-code/src/query/config.ts:1-45`
- `claude-code-source-code/src/query/deps.ts:1-40`
- `claude-code-source-code/src/utils/QueryGuard.ts:1-121`
- `claude-code-source-code/src/utils/task/framework.ts:160-248`
- `claude-code-source-code/src/bridge/bridgePointer.ts:22-184`
- `claude-code-source-code/src/utils/queryContext.ts:1-140`

### A00n. 机制失真之后，下一层应进入机制哲学收束层

- `compiled request truth` 更深一层的不可约判断不是“Prompt 很强”，而是“Prompt 被写成一条可缓存、可转写、可继续的编译链”；section registry、stable boundary、protocol rewrite、lawful forgetting 与 continue qualification 共同服务的都是同一件事：先规定世界如何进入模型，再规定世界如何被继续继承。
- `governance control plane object` 更深一层的不可约判断不是“安全与省 token 要平衡”，而是“治理控制面在统一定价一切扩张”；authority source、decision window、Context Usage、continuation gate 与 rollback object 共同服务的都是同一件事：拒绝未定价动作、未定价可见面、未定价上下文与未定价时间。
- `evolvable kernel object boundary` 更深一层的不可约判断不是“结构很好”，而是“故障模型先于模块美学进入结构”；authority surface、dependency seam、generation guard、fresh merge、recovery asset boundary 与 anti-zombie 共同服务的都是同一件事：让后来维护者在作者缺席时仍能正式反对错误实现。
- 这意味着蓝皮书在“机制失真反例层”之后需要继续长出“机制哲学收束层”：
  - `navigation/41` 负责统一入口。
  - `philosophy/81-83` 负责把三类对象重新压回第一性原理。
- 这也意味着下一步如果还要继续深化，最值钱的候选不是继续抽象概念，而是考虑新的 `guides/51+` 或 `api/51+`，把这些第一性原理重新翻译成实现者与宿主接入者可直接执行的手册。

证据:

- `claude-code-source-code/src/constants/systemPromptSections.ts:20-65`
- `claude-code-source-code/src/constants/prompts.ts:105-115`
- `claude-code-source-code/src/utils/api.ts:321-405`
- `claude-code-source-code/src/utils/messages.ts:1989-2148`
- `claude-code-source-code/src/utils/messages.ts:5133-5460`
- `claude-code-source-code/src/services/compact/prompt.ts:61-143`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:247-430`
- `claude-code-source-code/src/query.ts:1065-1340`
- `claude-code-source-code/src/utils/permissions/permissions.ts:593-984`
- `claude-code-source-code/src/cli/structuredIO.ts:149-657`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:106-260`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:464-519`
- `claude-code-source-code/src/query/tokenBudget.ts:45-92`
- `claude-code-source-code/src/utils/sessionState.ts:92-149`
- `claude-code-source-code/src/state/onChangeAppState.ts:43-92`
- `claude-code-source-code/src/query/config.ts:1-45`
- `claude-code-source-code/src/query/deps.ts:1-40`
- `claude-code-source-code/src/utils/QueryGuard.ts:1-121`
- `claude-code-source-code/src/utils/task/framework.ts:160-248`
- `claude-code-source-code/src/bridge/bridgePointer.ts:22-184`
- `claude-code-source-code/src/utils/queryContext.ts:1-140`

### A00o. 机制哲学之后，下一层应进入机制实现翻译层

- `compiled request truth` 如果想从第一性原理真正迁移到别的 runtime，最值钱的不是继续讲 Prompt 魔力，而是把它重新翻译成 section registry、stable boundary、compiled request ABI、protocol rewrite、lawful forgetting object 与 continue qualification 的固定实现顺序；否则 Prompt 会重新退回哲学描述与文案经验。
- `governance control plane object` 如果想真正迁移，最值钱的不是继续讲统一定价，而是把它重新翻译成 authority source、typed decision、decision window、continuation gate 与 rollback object 的固定实现顺序；否则治理会重新退回 modal、仪表盘与局部策略。
- `evolvable kernel object boundary` 如果想真正迁移，最值钱的不是继续讲故障模型，而是把它重新翻译成 authority surface、dependency seam、query config/deps split、stale-safe merge、recovery boundary 与 anti-zombie evidence 的固定实现顺序；否则结构会重新退回目录建议与风格偏好。
- 这意味着蓝皮书在“机制哲学层”之后需要继续长出“机制实现翻译层”：
  - `navigation/42` 负责统一入口。
  - `guides/51-53` 负责三类对象的 builder-facing 实现手册。
- 这也意味着下一步如果还要继续深化，最值钱的候选不是继续补哲学，而是考虑新的 `api/51+`，把这些实现对象继续压成宿主可消费支持面。

证据:

- `claude-code-source-code/src/constants/systemPromptSections.ts:20-65`
- `claude-code-source-code/src/constants/prompts.ts:105-115`
- `claude-code-source-code/src/constants/prompts.ts:343-347`
- `claude-code-source-code/src/constants/prompts.ts:560-576`
- `claude-code-source-code/src/utils/api.ts:119-150`
- `claude-code-source-code/src/utils/api.ts:321-405`
- `claude-code-source-code/src/utils/messages.ts:1989-2148`
- `claude-code-source-code/src/utils/messages.ts:5133-5460`
- `claude-code-source-code/src/services/compact/prompt.ts:61-143`
- `claude-code-source-code/src/services/compact/compact.ts:330-366`
- `claude-code-source-code/src/services/compact/compact.ts:596-711`
- `claude-code-source-code/src/query/stopHooks.ts:175-331`
- `claude-code-source-code/src/query.ts:1065-1340`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:106-260`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:464-519`
- `claude-code-source-code/src/cli/structuredIO.ts:149-657`
- `claude-code-source-code/src/utils/permissions/permissions.ts:593-984`
- `claude-code-source-code/src/query/tokenBudget.ts:45-92`
- `claude-code-source-code/src/utils/sessionState.ts:92-149`
- `claude-code-source-code/src/state/onChangeAppState.ts:43-92`
- `claude-code-source-code/src/query/config.ts:1-45`
- `claude-code-source-code/src/query/deps.ts:1-40`
- `claude-code-source-code/src/utils/QueryGuard.ts:1-121`
- `claude-code-source-code/src/utils/task/framework.ts:160-248`
- `claude-code-source-code/src/bridge/bridgePointer.ts:22-184`
- `claude-code-source-code/src/utils/queryContext.ts:1-140`

### A00p. 机制实现之后，下一层应进入机制支持面层

- `compiled request truth` 即使已经被实现者正确搭出来，宿主若不能围绕 `systemPrompt` 输入面、`systemPromptSections`、`messageBreakdown`、`autoCompactThreshold`、`post_turn_summary` 等正式投影消费它，就会重新退回原文 prompt 与黑箱稳定性；这说明 Prompt 编译链迁移的下一步是宿主消费面，而不是继续暴露内部 compiler trace。
- `governance control plane object` 即使已经被实现者正确搭出来，宿主若不能围绕 `authority source`、`session_state_changed`、`pending_action`、`get_context_usage`、`rewind_files` 等正式投影消费它，就会重新退回 modal、状态色与仪表盘；这说明统一定价治理迁移的下一步是宿主消费面，而不是继续暴露 classifier 细节。
- `evolvable kernel object boundary` 即使已经被实现者正确搭出来，宿主若不能围绕 `authority state`、`rewind_files`、`seed_read_state`、recovery boundary、anti-zombie outcome 等正式投影消费它，就会重新退回目录图、恢复成功率与作者说明；这说明故障模型迁移的下一步是宿主消费面，而不是继续暴露 generation 内部字段。
- 这意味着蓝皮书在“机制实现层”之后需要继续长出“机制支持面层”：
  - `navigation/43` 负责统一入口。
  - `api/51-53` 负责三类对象的 host-consumable support surface。
- 这也意味着下一步如果还要继续深化，最值钱的候选不是继续补字段表，而是考虑新的 `playbooks/29+` 或 `casebooks/25+`，把这些支持面最常见的误用与漂移写成新的运行反例层。

证据:

- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:57-72`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:205-306`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:308-360`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:475-519`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1548-1561`
- `claude-code-source-code/src/utils/sessionState.ts:15-45`
- `claude-code-source-code/src/utils/sessionState.ts:92-149`
- `claude-code-source-code/src/state/onChangeAppState.ts:43-92`
- `claude-code-source-code/src/cli/structuredIO.ts:470-639`
- `claude-code-source-code/src/cli/print.ts:2961-3028`
- `claude-code-source-code/src/query/tokenBudget.ts:45-92`
- `claude-code-source-code/src/utils/QueryGuard.ts:55-93`
- `claude-code-source-code/src/utils/task/framework.ts:160-248`
- `claude-code-source-code/src/bridge/bridgePointer.ts:42-184`
- `claude-code-source-code/src/services/api/sessionIngress.ts:57-142`

### A00q. 机制支持面之后，下一层应进入支持面误用反例层

- `compiled request truth` 即使已经有了 `systemPrompt` 输入面、`section breakdown`、`messageBreakdown`、`cache break reason` 与 continue qualification 投影，宿主仍最容易把它误消费成单一 prompt 字符串、黑箱稳定性与 last-message heuristic；这说明 Prompt 支持面的下一层最值钱的不是继续补字段，而是明确指出宿主最常消费了哪些假信号。
- `governance control plane object` 即使已经有了 authority source、decision window、pending action、continuation gate 与 rollback object 投影，宿主仍最容易把它误消费成 mode 名字、弹窗出现过、token 条与文件级回退；这说明治理支持面的下一层最值钱的不是继续补 control schema，而是明确指出宿主最常怎样把对象级治理重新降格成界面投影与流程幻觉。
- `evolvable kernel object boundary` 即使已经有了 authority state、recovery boundary 与 anti-zombie projection，宿主仍最容易把它误消费成 spinner、pointer、恢复成功率与作者说明；这说明故障模型支持面的下一层最值钱的不是继续补 debug 字段，而是明确指出宿主最常怎样重新制造第二真相。
- 这意味着蓝皮书在“机制支持面层”之后需要继续长出“支持面误用反例层”：
  - `navigation/44` 负责统一入口。
  - `casebooks/25-27` 负责三类 host-consumable support surface 的 consumer misuse 反例。
- 这也意味着下一步如果还要继续深化，最值钱的候选不是继续补字段枚举，而是考虑新的 `playbooks/29+`，把这些 consumer misuse 压成新的宿主接入审读手册、复盘动作与防再发顺序。

证据:

- `claude-code-source-code/src/constants/systemPromptSections.ts:20-65`
- `claude-code-source-code/src/constants/prompts.ts:343-347`
- `claude-code-source-code/src/constants/prompts.ts:560-576`
- `claude-code-source-code/src/utils/api.ts:119-150`
- `claude-code-source-code/src/utils/api.ts:321-405`
- `claude-code-source-code/src/services/api/claude.ts:1374-1485`
- `claude-code-source-code/src/services/api/claude.ts:3213-3236`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:470-698`
- `claude-code-source-code/src/utils/messages.ts:1989-2148`
- `claude-code-source-code/src/utils/messages.ts:5133-5460`
- `claude-code-source-code/src/services/compact/compact.ts:330-366`
- `claude-code-source-code/src/services/compact/compact.ts:596-711`
- `claude-code-source-code/src/query/stopHooks.ts:257-331`
- `claude-code-source-code/src/query.ts:1258-1340`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:106-260`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:308-328`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:475-519`
- `claude-code-source-code/src/cli/structuredIO.ts:470-639`
- `claude-code-source-code/src/utils/sessionState.ts:15-45`
- `claude-code-source-code/src/utils/sessionState.ts:92-149`
- `claude-code-source-code/src/state/onChangeAppState.ts:43-92`
- `claude-code-source-code/src/query/tokenBudget.ts:45-92`
- `claude-code-source-code/src/cli/print.ts:2961-3010`
- `claude-code-source-code/src/utils/QueryGuard.ts:55-121`
- `claude-code-source-code/src/utils/task/framework.ts:160-248`
- `claude-code-source-code/src/bridge/bridgePointer.ts:22-184`
- `claude-code-source-code/src/services/api/sessionIngress.ts:57-170`
- `claude-code-source-code/src/bridge/remoteBridgeCore.ts:824-880`

### A00r. 支持面反例之后，下一层应进入宿主接入审读层

- `compiled request truth` 即使已经识别出字符串崇拜、cache 黑箱与 continue qualification 误判，团队若不能把这些误用重新压成“先查输入面、再查 section breakdown、再查 cache break reason、最后查 continue qualification”的固定排查顺序，Prompt 宿主接入就仍然会反复漂移；这说明 support-surface misuse 的下一层最值钱的是 runbook，而不是更多反例叙述。
- `governance control plane object` 即使已经识别出 mode 崇拜、pending action 降格与 rollback object 文件化，团队若不能把这些误用重新压成“先查 authority source、再查 decision window、再查 continuation gate、最后查 rollback object”的固定排查顺序，治理宿主接入就仍然会反复退回面板与流程幻觉。
- `evolvable kernel object boundary` 即使已经识别出 authority state 猜测、pointer 神化与成功率崇拜，团队若不能把这些误用重新压成“先查 authority state、再查 recovery boundary、再查 anti-zombie 结果面”的固定排查顺序，结构宿主接入就仍然会反复退回恢复玄学与作者解释。
- 这意味着蓝皮书在“支持面反例层”之后需要继续长出“宿主接入审读层”：
  - `navigation/45` 负责统一入口。
  - `playbooks/29-31` 负责三类 support-surface misuse 的排查、演练、拒收与防再发顺序。
- 这也意味着下一步如果还要继续深化，最值钱的候选不是继续补 runbook 描述，而是考虑新的 `casebooks/28+` 或 `guides/54+`，把这些宿主接入审读继续压成迁移工单、交接模板与灰度顺序。

证据:

- `claude-code-source-code/src/constants/systemPromptSections.ts:20-65`
- `claude-code-source-code/src/constants/prompts.ts:343-347`
- `claude-code-source-code/src/constants/prompts.ts:560-576`
- `claude-code-source-code/src/utils/api.ts:119-150`
- `claude-code-source-code/src/utils/api.ts:321-405`
- `claude-code-source-code/src/services/api/claude.ts:1374-1485`
- `claude-code-source-code/src/services/api/claude.ts:3213-3236`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:470-698`
- `claude-code-source-code/src/query/stopHooks.ts:257-331`
- `claude-code-source-code/src/query.ts:1258-1340`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:106-260`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:308-328`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:475-519`
- `claude-code-source-code/src/cli/structuredIO.ts:470-639`
- `claude-code-source-code/src/utils/sessionState.ts:15-45`
- `claude-code-source-code/src/utils/sessionState.ts:92-149`
- `claude-code-source-code/src/state/onChangeAppState.ts:43-92`
- `claude-code-source-code/src/query/tokenBudget.ts:45-92`
- `claude-code-source-code/src/cli/print.ts:2961-3010`
- `claude-code-source-code/src/utils/QueryGuard.ts:55-121`
- `claude-code-source-code/src/utils/task/framework.ts:160-248`
- `claude-code-source-code/src/bridge/bridgePointer.ts:22-184`
- `claude-code-source-code/src/services/api/sessionIngress.ts:57-170`
- `claude-code-source-code/src/bridge/remoteBridgeCore.ts:824-880`

### A00k. 方法层之后，最值钱的是把三条线重新回灌成机制层对象

- Prompt 线下一步不应继续停在 Prompt Constitution 或上下文编译方法，而应继续把 `section law + stable prefix producer + protocol transcript + lawful forgetting + cache-break observability` 收口成同一个 `compiled request truth` 对象。
- 治理线下一步不应继续停在统一预算器、治理顺序或 builder-facing 手册，而应继续把 `PolicySettings + typed decision + visibility pricing + Context Usage + continuation window` 收口成同一个 `governance control plane`。
- 结构线下一步不应继续停在可演化内核或未来维护者消费者的判断，而应继续把 `authority surface + single-source + anti-cycle seam + anti-zombie` 收口成同一个 `evolvable kernel object boundary`。
- 这意味着蓝皮书当前最稳的继续方式，不是新开平面，而是新增一层机制回灌：
  - `navigation/38` 负责入口。
  - `architecture/79-81` 负责三条对象化回灌。
  - `api/49-50` 负责 Prompt 编译/稳定性与治理控制面的支持面显式化。
- 下一步如果继续深化，最值钱的候选不是更多 architecture 哲学，而是判断这些机制对象怎样继续进入 host implementation、casebook 与 playbook 的验证层。

证据:

- `claude-code-source-code/src/constants/systemPromptSections.ts:1-51`
- `claude-code-source-code/src/constants/prompts.ts:491-557`
- `claude-code-source-code/src/utils/systemPrompt.ts:28-104`
- `claude-code-source-code/src/query/stopHooks.ts:84-120`
- `claude-code-source-code/src/utils/messages.ts:1989-2148`
- `claude-code-source-code/src/services/compact/prompt.ts:1-260`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:243-520`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:57-240`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:308-519`
- `claude-code-source-code/src/utils/permissions/permissionSetup.ts:1-260`
- `claude-code-source-code/src/utils/permissions/permissions.ts:593-984`
- `claude-code-source-code/src/utils/contextSuggestions.ts:1-220`
- `claude-code-source-code/src/query/tokenBudget.ts:45-92`
- `claude-code-source-code/src/query/config.ts:1-45`
- `claude-code-source-code/src/query/deps.ts:1-40`
- `claude-code-source-code/src/utils/QueryGuard.ts:1-108`
- `claude-code-source-code/src/utils/task/framework.ts:160-269`
- `claude-code-source-code/src/bridge/bridgePointer.ts:22-184`

### A00j. Runtime 构建层之后，应继续下沉到上下文编译、治理控制面与可演化内核三联层

- Prompt 魔力下一层最值钱的写法，不是继续讨论强 prompt，而是把它明确写成上下文准入编译器：section law、stable prefix producer、protocol transcript compiler、lawful forgetting ABI 与 stable bytes ledger 应被理解成同一条 Prompt control plane。
- 安全与省 token 下一层最值钱的写法，不是继续讨论统一预算器，而是把它明确写成治理控制面：authority surface、typed decision、渐进暴露、Context Usage decision window、continuation pricing 应被理解成同一张治理面。
- 源码先进性下一层最值钱的写法，不是继续讨论分层漂亮，而是把它明确写成可演化内核：authority surface、single-source、anti-cycle seam、anti-zombie 与 future maintainer as consumer 应被理解成同一条结构母线。
- 这意味着蓝皮书目录在构建层之后需要继续保持“三联结构”：
  - `navigation/37` 负责统一入口。
  - `guides/48-50` 负责 builder-facing 方法层。
  - `philosophy/78-80` 负责终局判断层。
- 这也意味着下一步如果要继续深化，优先考虑的不是再开新平面，而是判断是否需要把 compiled request truth、governance control plane、evolvable kernel 再回灌到 `architecture/` 或 `api/`。

证据:

- `claude-code-source-code/src/constants/prompts.ts:491-557`
- `claude-code-source-code/src/utils/systemPrompt.ts:28-104`
- `claude-code-source-code/src/query/stopHooks.ts:84-120`
- `claude-code-source-code/src/services/PromptSuggestion/promptSuggestion.ts:184-225`
- `claude-code-source-code/src/services/AgentSummary/agentSummary.ts:81-119`
- `claude-code-source-code/src/utils/messages.ts:1989-2148`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:57-240`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:308-519`
- `claude-code-source-code/src/utils/permissions/permissions.ts:593-984`
- `claude-code-source-code/src/query/tokenBudget.ts:45-92`
- `claude-code-source-code/src/state/onChangeAppState.ts:43-92`
- `claude-code-source-code/src/utils/task/framework.ts:160-269`
- `claude-code-source-code/src/query/config.ts:1-45`
- `claude-code-source-code/src/query/deps.ts:1-40`
- `claude-code-source-code/src/utils/QueryGuard.ts:1-106`
- `claude-code-source-code/src/bridge/bridgePointer.ts:22-184`

## 已确认结论

### A00. 协作语法、资源定价与未来维护者消费者

- Claude Code 的 prompt 魔力更准确地说来自“先规定协作语法，再让模型发言”：system prompt 先决定谁代表谁发言，stop hooks 又把 cache-safe 协作上下文存下供 suggestion、session memory 与旁路 fork 复用，说明 prompt 的真正形态是跨当前、下一步和接手后的协作状态，而不是一次性文案。
- UI transcript 与 protocol transcript 必须分离：显示层需要 progress、虚拟消息和交互提示，执行层需要结构合法、可继续推理的协议消息；compact / resume 之后还要补回 tool_use/tool_result 与 thinking 不变量，说明模型消费的从来不是前台原样历史。
- sticky prompt、suggestion、session memory 应被理解成同一协作接口在不同时间尺度上的投影：sticky 管当前主语，suggestion 管下一步输入，session memory 管压缩后的长期接手连续性。
- Claude Code 的安全不是单点拦截器，而是资源定价秩序：mode 在给动作定价，tool visibility 在给能力定价，externalization 在给上下文席位定价，token continuation 在给时间定价。
- `bypassPermissions` 不是无限自由，而是提高某些动作的通行级别；content-specific ask、`requiresUserInteraction` 与 safety check 等更高价格仍然存在，说明系统追求的是有效自由而不是最大裸露面。
- 审批在实现上是多路协商协议而不是单个弹窗：本地 UI、SDK host、bridge、hook、channel relay、classifier 围绕同一请求并行竞速，谁先给出合法决定，谁就结束等待。
- 源码先进性不在静态分层本身，而在未来维护者被当成正式消费者：`DANGEROUS`、`single choke point`、`IMPORTANT` 这类命名和注释都在提前暴露未来修改的代价与条件。
- 命名、注释、leaf module、config / deps seam、snapshot、state machine 共同构成同一治理制度：用显式边界保护未来维护与未来重构，而不是只服务当前执行。

补充目录判断：

- 57-59 已经形成一组终局判断，继续仅靠 `philosophy/README` 与 `navigation/05` 暴露不够直接，应单独提供终局判断导航，避免读者知道结论存在，却不知道该从哪条短路径进入。

补充实践下沉判断：

- 在终局判断稳定后，下一步不应继续只加哲学收束，而应把 protocol transcript、资源定价、未来维护者消费者三条线分别下沉成高级 guide，让“为什么如此设计”转写成“怎样照此设计 / 使用 / 迁移”。

补充底盘回灌判断：

- 当高级 guide 稳定后，还应再回灌到 `architecture/`：把 `54/57` 与 `15` 收束成 protocol truth control plane，把 `56/58` 与 `16` 收束成 pricing runtime，把 `69/59` 与 `17` 收束成 future-maintainer consumer plane，避免“实践有了，但底盘抽象仍缺席”。

证据:

- `claude-code-source-code/src/utils/systemPrompt.ts:28-127`
- `claude-code-source-code/src/constants/prompts.ts:105-127`
- `claude-code-source-code/src/query/stopHooks.ts:84-120`
- `claude-code-source-code/src/utils/messages.ts:1989-2148`
- `claude-code-source-code/src/services/compact/sessionMemoryCompact.ts:232-395`
- `claude-code-source-code/src/components/VirtualMessageList.tsx:145-180`
- `claude-code-source-code/src/components/VirtualMessageList.tsx:946-1035`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1795-1830`
- `claude-code-source-code/src/utils/permissions/permissions.ts:503-640`
- `claude-code-source-code/src/utils/permissions/permissions.ts:1238-1280`
- `claude-code-source-code/src/constants/systemPromptSections.ts:27-38`
- `claude-code-source-code/src/state/onChangeAppState.ts:50-91`
- `claude-code-source-code/src/utils/fingerprint.ts:40-63`

### A00a. 共享前缀网络、合同优先阅读与依赖图诚实性

- 主线程不只是 query executor，还是 prefix producer：`stopHooks.ts` 只为 `repl_main_thread` 与 `sdk` 保存 `CacheSafeParams`，并明确说 `/btw` 与 `side_question` 会直接复用它；这说明 Claude Code 真正共享的不是聊天历史，而是 cache-safe 协作前缀。
- 旁路循环应共享主线程前缀，而不是各自重建世界模型：`/btw` 首选 `getLastCacheSafeParams()`，SDK suggestion 在拿不到 snapshot 时宁可记录 `sdk_no_params` 并 suppress，`AgentSummary` 甚至为了保住 cache key 明确不设置 `maxOutputTokens`。
- contract-first 的更稳顺序应细化为“先 schema/type union，再 registry，再 authoritative surface，再 adapter subset，最后热点 kernel”：`Task.ts` 定义任务合同，`tasks.ts` 暴露当前注册子集，`controlSchemas.ts` 给出控制协议全集，`checkEnabledPlugins()`、`QueryGuard`、`isTranscriptMessage()`、`kairosEnabled` 则分别标出局部权威真相入口。
- “协议全集”不等于“适配器实装全集”：`runBridgeHeadless()` 直接注明自己是 `bridgeMain()` 的 linear subset，因此不能从 `SDKControlRequestInnerSchema` 反推所有宿主都支持所有 control action。
- 依赖图诚实性是一种工程正确性：`pluginPolicy.ts`、`configConstants.ts`、`types/permissions.ts`、`pluginDirectories.ts` 用 leaf module 与 single-source file 收口共享真相，`queryContext.ts` 与 `teammateViewHelpers.ts` 则用 anti-cycle seam 与适度不 DRY 切断 runtime edge；`DANGEROUS_uncachedSystemPromptSection`、`fingerprint.ts` 进一步说明风险命名和制度注释本身也是依赖治理的一部分。

证据:

- `claude-code-source-code/src/query/stopHooks.ts:84-120`
- `claude-code-source-code/src/commands/btw/btw.tsx:183-227`
- `claude-code-source-code/src/cli/print.ts:2274-2315`
- `claude-code-source-code/src/services/PromptSuggestion/promptSuggestion.ts:184-225`
- `claude-code-source-code/src/services/AgentSummary/agentSummary.ts:81-119`
- `claude-code-source-code/src/services/extractMemories/extractMemories.ts:371-427`
- `claude-code-source-code/src/services/autoDream/autoDream.ts:224-249`
- `claude-code-source-code/src/Task.ts:6-124`
- `claude-code-source-code/src/tasks.ts:1-39`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1-8`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:552-590`
- `claude-code-source-code/src/utils/plugins/pluginStartupCheck.ts:30-90`
- `claude-code-source-code/src/utils/QueryGuard.ts:1-106`
- `claude-code-source-code/src/utils/sessionStorage.ts:128-162`
- `claude-code-source-code/src/state/AppStateStore.ts:113-120`
- `claude-code-source-code/src/bridge/bridgeMain.ts:2799-2810`
- `claude-code-source-code/src/utils/plugins/pluginPolicy.ts:1-20`
- `claude-code-source-code/src/query/config.ts:1-45`
- `claude-code-source-code/src/query/deps.ts:1-40`
- `claude-code-source-code/src/utils/queryContext.ts:1-87`
- `claude-code-source-code/src/types/permissions.ts:1-63`
- `claude-code-source-code/src/utils/configConstants.ts:1-18`
- `claude-code-source-code/src/utils/plugins/pluginDirectories.ts:1-79`
- `claude-code-source-code/src/state/teammateViewHelpers.ts:1-24`
- `claude-code-source-code/src/constants/systemPromptSections.ts:27-38`
- `claude-code-source-code/src/utils/fingerprint.ts:40-63`

补充模板层判断：

- 在 `guides/18-20` 已稳定后，下一步最值钱的不是继续加同层 guide，而是补 `navigation/07` 和三张模板：shared-prefix snapshot policy、contract-first 审读清单、dependency-honesty review checklist。否则读者虽然知道方法存在，但仍缺少“如何执行 / 如何评审 / 如何迁移”的中间层。
- 这三张模板共同服务同一个第一性原理：Claude Code 的高级感不在某条单独机制，而在“先固定工作真相，再限制脑补，再限制结构撒谎”。

### A00b. Prompt Constitution、治理顺序与构建系统高级关系

- prompt 下一层应继续按 `Prompt Constitution` 理解：`systemPromptSections`、`SYSTEM_PROMPT_DYNAMIC_BOUNDARY`、`buildEffectiveSystemPrompt()` 共同说明 prompt 不是一段话，而是一份受 section 宪法、角色优先级链与危险 cache-break 声明治理的制度体。
- prompt 的“合法遗忘”也应被视作正式设计：compact prompt、session memory compact、conversation recovery 都在回答“删掉什么后系统仍能继续工作”，说明 prompt 魔力同样来自删除策略和恢复补边，而不只是注入更多文本。
- 安全与省 token 下一层应继续按“治理顺序 + 失败语义分型 + 可撤销自动化”理解：危险 allow rule 会在 classifier 前被剔除，不同资产采用不同 fail-open/fail-closed，auto mode 在 denial limit 或 transcript too long 时会退回人工或直接终止，说明系统真正优化的是有决策增益的检查，而不是检查越多越安全。
- “稳定字节”应被视为安全和成本共享的制度资产：system prompt section 缓存、sticky beta、tool-result replacement replay、prompt cache break diff 共同说明治理字节本身必须可追踪、可解释、可重放。
- 源码先进性下一层应继续按“构建系统也是架构工具”理解：external stubs、portable shadow entry、安全导入的 lightweight impl、transport shell 与薄 registry 都在主动塑形模块图和发布面，而不是把构建仅当作打包尾巴。
- 高级工程还应继续按“zombification 治理”理解：against fresh state merge、stale epoch 丢弃、恢复路径先设计再简化平时写法，说明 Claude Code 在治理的不是单个 race，而是跨 await 对象命运。

证据:

- `claude-code-source-code/src/constants/prompts.ts:105-560`
- `claude-code-source-code/src/constants/systemPromptSections.ts:17-43`
- `claude-code-source-code/src/utils/systemPrompt.ts:28-104`
- `claude-code-source-code/src/utils/messages.ts:1989-2148`
- `claude-code-source-code/src/utils/conversationRecovery.ts:226-297`
- `claude-code-source-code/src/services/compact/prompt.ts:12-206`
- `claude-code-source-code/src/services/compact/sessionMemoryCompact.ts:188-397`
- `claude-code-source-code/src/utils/permissions/permissionSetup.ts:235-1033`
- `claude-code-source-code/src/utils/permissions/filesystem.ts:1252-1302`
- `claude-code-source-code/src/utils/permissions/permissions.ts:593-984`
- `claude-code-source-code/src/services/remoteManagedSettings/index.ts:433-458`
- `claude-code-source-code/src/services/policyLimits/index.ts:504-520`
- `claude-code-source-code/src/services/api/claude.ts:1405-1460`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:28-520`
- `claude-code-source-code/src/moreright/useMoreRight.tsx:1-25`
- `claude-code-source-code/src/state/AppState.tsx:12-23`
- `claude-code-source-code/src/utils/listSessionsImpl.ts:1-27`
- `claude-code-source-code/src/services/api/emptyUsage.ts:3-16`
- `claude-code-source-code/src/utils/cleanupRegistry.ts:1-21`
- `claude-code-source-code/src/utils/swarm/backends/registry.ts:81-114`
- `claude-code-source-code/src/utils/task/framework.ts:160-248`

补充目录判断：

- 当 60-62 形成第二序制度层后，应单独提供 `navigation/08`，否则 05/06/07 会分别承担“高阶母线 / 终局判断 / 深方法模板”三层职责，却没有一个入口直达“更深一层的制度哲学”。

补充底盘回灌判断：

- 当三条第二序制度母线稳定后，最先该补的不是更多哲学短论，而是对应的 `architecture/73-75`。否则 Prompt Constitution、治理顺序与构建系统塑形会再次停留在高阶解释，无法回落到可迁移的机制层。

### A00d. 第二序制度层已完成到底盘层的第一次闭环

- `architecture/73` 已把 Prompt Constitution 从“高阶哲学”回灌成机制层：section registry、dynamic boundary、角色主权链、protocol truth law、lawful forgetting 与 prompt observability 现在形成同一条 prompt control plane。
- `architecture/74` 已把安全/省 token 从“资源定价哲学”回灌成控制面：治理顺序、失败语义分型、可撤销自动化、decision-gain-aware token spending 与 stable-bytes assets 现在形成同一条 governance-order control plane。
- `architecture/75` 已把“构建系统也是架构工具”从理念回灌成结构层：external stubs、portable shadow entry、transport shell、thin registry 与 zombification governance 现在形成同一条 source-order shaping control plane。
- 这意味着蓝皮书当前首次形成了较完整的六层闭环：哲学判断 -> 高阶导航 -> 深方法导航 -> 模板层 -> 架构底盘 -> 主索引检索，而不是只在哲学和 guide 间来回摆动。

补充下沉判断：

- 当 73-75 稳定后，下一步最值钱的不是继续增加架构抽象，而是把它们各自转写成 builder-facing 操作手册：section registry policy、governance order matrix、source-order shaping checklist。否则底盘层虽然成立，但迁移动作仍然停在读者脑中。

### A00e. 第二序制度层已继续下沉到团队落地包

- `guides/27` 应把 Prompt Constitution 继续压成四类正式团队工件：section constitution card、prompt amendment workflow、lawful forgetting ABI checklist、prompt triage / invalidation runbook。Claude Code 的 prompt 魔力因此更接近“可编译宪法 + 可观测修宪流程”，而不是强文案。
- `guides/28` 应把治理顺序继续压成治理顺序审计表、失败语义矩阵、自动化租约、approval race matrix、stable bytes ledger 与 stop-logic checklist。Claude Code 的省 token 因而更接近“压缩无效决策”，而不是压缩文字。
- `guides/29` 应把源码先进性继续压成 build surface matrix、entry shadow card、transport shell confinement checklist、recovery asset ledger 与 anti-zombie protocol。Claude Code 的结构先进性因而更接近“主动塑形可演化边界”，而不是目录更整齐。
- 当 `24-26` 已成立后，还需要单独的 `navigation/09` 作为团队动作层入口；否则 `08` 会重新同时承载制度解释和模板检索，目录职责会再次变混。

证据:

- `claude-code-source-code/src/constants/prompts.ts:491-557`
- `claude-code-source-code/src/utils/systemPrompt.ts:28-104`
- `claude-code-source-code/src/services/compact/compact.ts:330-340`
- `claude-code-source-code/src/services/compact/postCompactCleanup.ts:31-62`
- `claude-code-source-code/src/utils/permissions/permissionSetup.ts:235-1283`
- `claude-code-source-code/src/utils/permissions/permissions.ts:593-984`
- `claude-code-source-code/src/cli/structuredIO.ts:561-608`
- `claude-code-source-code/src/hooks/toolPermission/handlers/interactiveHandler.ts:244-300`
- `claude-code-source-code/scripts/prepare-src.mjs:3-64`
- `claude-code-source-code/scripts/stub-modules.mjs:2-42`
- `claude-code-source-code/src/bridge/replBridgeTransport.ts:13-116`
- `claude-code-source-code/src/utils/task/framework.ts:160-248`

### A00f. 团队落地包之后，下一层应进入运营与复盘层

- 当 `guides/27-29` 已经把制度压成模板层后，下一步最值钱的不是继续往 `guides/` 里堆更多 checklist，而是把目录显式分成 `guides/` 与 `playbooks/`：前者负责设计与迁移方法，后者负责回归、事故复盘、运营与演化演练。
- Prompt Constitution 的最终形态不只是 section card 和修宪流程，还必须有 `playbooks/01` 这一类运行手册：section drift、boundary drift、lawful forgetting 失败、prompt invalidation 漂移都要进入正式回归与复盘。
- 治理顺序的最终形态不只是顺序表和矩阵，还必须有 `playbooks/02` 这一类运营手册：approval race、auto mode 回收、stable bytes drift、stop-logic 漏洞都要进入正式事故分类与演练。
- 源码先进性的最终形态不只是 build surface / shadow / transport shell 模板，还必须有 `playbooks/03` 这一类演化手册：shadow-stub 退出、compat 壳层收缩、recovery drill 与 anti-zombie 故障模型都要进入正式结构运营。
- 这意味着蓝皮书目录继续从七层推进到八层：主线结论 -> 导航入口 -> 机制底盘 -> API 支持 -> 哲学解释 -> 使用方法 -> 运营 playbooks -> 风险专题；`docs/` 仍只负责开发记忆而不进入正文。
- `navigation/10` 因而成为必要入口：`09` 承接“模板层”，`10` 承接“运营层”，否则团队动作层与运营层会再次混写。

证据:

- `claude-code-source-code/src/constants/prompts.ts:491-557`
- `claude-code-source-code/src/services/compact/postCompactCleanup.ts:31-62`
- `claude-code-source-code/src/utils/analyzeContext.ts:937-1048`
- `claude-code-source-code/src/utils/permissions/permissions.ts:593-984`
- `claude-code-source-code/src/cli/structuredIO.ts:561-608`
- `claude-code-source-code/src/hooks/toolPermission/handlers/interactiveHandler.ts:244-300`
- `claude-code-source-code/src/utils/toolResultStorage.ts:739-860`
- `claude-code-source-code/scripts/prepare-src.mjs:3-64`
- `claude-code-source-code/scripts/stub-modules.mjs:2-42`
- `claude-code-source-code/src/bridge/replBridgeTransport.ts:13-116`
- `claude-code-source-code/src/bridge/bridgePointer.ts:22-167`
- `claude-code-source-code/src/services/api/sessionIngress.ts:60-120`
- `claude-code-source-code/src/utils/QueryGuard.ts:69-106`
- `claude-code-source-code/src/utils/task/framework.ts:160-248`

### A00g. 运营层之后，下一层应进入案例样本层

- 当 `playbooks/01-03` 已经把制度推进到运营层后，下一步最值钱的不是继续新增更抽象的手册，而是新增 `casebooks/`：把 prompt、治理、源码演化分别压成具体失败样本库。
- prompt 的样本层最值得收束成 `section drift / boundary drift / path parity split / lawful-forgetting failure / invalidation drift` 五类案例，因为这些事故最直接暴露“prompt 的魔力来自可治理宪法，而不是文案本身”。
- 治理的样本层最值得收束成 `order violation / hard-guard bypass / approval-race degradation / stable-bytes drift / stop-logic failure` 五类案例，因为这些事故最直接暴露“安全和省 token 是有顺序的制度，而不是更严格的规则堆叠”。
- 源码先进性的样本层最值得收束成 `shadow fossilization / transport leakage / recovery-asset corruption / zombification / registry obesity` 五类案例，因为这些失败形态最直接暴露“先进性在于可演化秩序，而不是静态目录美观”。
- 这意味着蓝皮书目录继续从八层推进到九层：主线 -> 导航 -> 机制 -> API -> 哲学 -> guides -> playbooks -> casebooks -> risk；其中 `casebooks/` 不是开发记忆，而是蓝皮书正文里的样本层。
- `navigation/11` 因而成为必要入口：`10` 负责运营手册，`11` 负责真实样本库，否则运营层与样本层会再次混写。

证据:

- `claude-code-source-code/src/memdir/memoryTypes.ts:228-240`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:437-520`
- `claude-code-source-code/src/services/compact/postCompactCleanup.ts:31-62`
- `claude-code-source-code/src/QueryEngine.ts:284-321`
- `claude-code-source-code/src/utils/queryContext.ts:77-84`
- `claude-code-source-code/src/utils/permissions/permissions.ts:593-984`
- `claude-code-source-code/src/cli/structuredIO.ts:561-608`
- `claude-code-source-code/src/hooks/toolPermission/handlers/interactiveHandler.ts:138-455`
- `claude-code-source-code/src/utils/toolResultStorage.ts:739-860`
- `claude-code-source-code/scripts/prepare-src.mjs:3-64`
- `claude-code-source-code/scripts/stub-modules.mjs:2-42`
- `claude-code-source-code/src/bridge/replBridgeTransport.ts:13-116`
- `claude-code-source-code/src/bridge/bridgePointer.ts:22-167`
- `claude-code-source-code/src/services/api/sessionIngress.ts:60-120`
- `claude-code-source-code/src/utils/QueryGuard.ts:69-106`
- `claude-code-source-code/src/utils/task/framework.ts:160-248`

### A00h. 样本层之后，下一层应进入索引层

- 当 `casebooks/01-03` 已经把制度压成失败样本层后，下一步最值钱的不是继续补更多孤立案例，而是补 `casebooks/04 + playbooks/04 + navigation/12` 这一组索引层：统一标签体系、交叉索引与记录模板。
- Prompt 样本的索引维度最值得固定为：`section / boundary / path / forgetting / invalidation`；这些维度比按“哪次事故”组织更接近 Prompt Constitution 的真实制度字节。
- 治理样本的索引维度最值得固定为：`order / guard / race / stable bytes / stop logic`；这些维度比按“误放行 / 太慢 / 太贵”组织更接近治理系统的真实控制点。
- 结构演化样本的索引维度最值得固定为：`build surface / shadow-stub / transport shell / recovery asset / zombie risk`；这些维度比按“哪个文件坏了”组织更接近源码先进性的真实边界。
- `playbooks/04` 应作为运营层和样本层的统一 ABI：任何演练和复盘都先按同一记录模板写，之后再决定回填到哪类 casebook。
- `navigation/12` 因而成为必要入口：`10` 负责手册层，`11` 负责样本层，`12` 负责“怎样给样本和演练建索引”，否则目录会重新退回“知道有案例，但找不到规律”。

证据:

- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:437-520`
- `claude-code-source-code/src/services/compact/postCompactCleanup.ts:31-62`
- `claude-code-source-code/src/QueryEngine.ts:284-321`
- `claude-code-source-code/src/utils/queryContext.ts:77-84`
- `claude-code-source-code/src/utils/permissions/permissions.ts:593-984`
- `claude-code-source-code/src/cli/structuredIO.ts:561-608`
- `claude-code-source-code/src/hooks/toolPermission/handlers/interactiveHandler.ts:138-455`
- `claude-code-source-code/src/utils/toolResultStorage.ts:739-860`
- `claude-code-source-code/scripts/prepare-src.mjs:3-64`
- `claude-code-source-code/scripts/stub-modules.mjs:2-42`
- `claude-code-source-code/src/bridge/replBridgeTransport.ts:13-116`
- `claude-code-source-code/src/bridge/bridgePointer.ts:22-167`
- `claude-code-source-code/src/utils/QueryGuard.ts:69-106`
- `claude-code-source-code/src/utils/task/framework.ts:160-248`

### A00i. 索引层之后，下一层应进入参考层

- 当 `navigation/12 + casebooks/04 + playbooks/04` 已经把制度压成索引层后，下一步最值钱的不是继续补抽象索引说明，而是补参考层：标签字典、源码锚点反查与完整填表示例。
- `casebooks/05` 应把 `section / boundary / path parity / lawful forgetting / invalidation / order / hard guard / approval race / stable bytes / stop logic / build surface / shadow-stub / transport shell / recovery asset / zombie risk` 这些标签继续压成定义、边界与误分类警戒；否则团队只会给事故贴名词，不会稳定判定。
- `casebooks/06` 应把 `tag -> sample -> playbook -> architecture/api/philosophy/source anchor` 做成反查表；否则知道标签的人，仍然找不到正文和实现入口。
- `playbooks/05` 应提供 Prompt、治理、结构三类完整填表示例，把 `authority source / assembly path / decision gain / evidence schema` 这些字段真正示范出来；否则模板层仍停在空 ABI。
- `navigation/13` 因而成为必要入口：`12` 负责索引结构，`13` 负责“怎样直接查定义、查锚点、查样例”，避免索引层继续抽象化。

证据:

- `claude-code-source-code/src/memdir/memoryTypes.ts:228-240`
- `claude-code-source-code/src/QueryEngine.ts:284-321`
- `claude-code-source-code/src/utils/queryContext.ts:77-84`
- `claude-code-source-code/src/services/compact/postCompactCleanup.ts:31-62`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:437-520`
- `claude-code-source-code/src/utils/permissions/permissions.ts:593-984`
- `claude-code-source-code/src/cli/structuredIO.ts:561-608`
- `claude-code-source-code/src/hooks/toolPermission/handlers/interactiveHandler.ts:138-455`
- `claude-code-source-code/src/utils/toolResultStorage.ts:739-860`
- `claude-code-source-code/scripts/prepare-src.mjs:3-64`
- `claude-code-source-code/scripts/stub-modules.mjs:2-42`
- `claude-code-source-code/src/bridge/replBridgeTransport.ts:13-116`
- `claude-code-source-code/src/bridge/bridgePointer.ts:22-167`
- `claude-code-source-code/src/utils/QueryGuard.ts:69-106`
- `claude-code-source-code/src/utils/task/framework.ts:160-248`

### A00j. 参考层之后，下一层应进入多入口反查层

- 当 `navigation/13 + casebooks/05-06 + playbooks/05` 已经把制度压成参考层后，下一步最值钱的不是继续堆更多定义，而是补多入口反查层：按症状、按阶段与按资产定位制度失效。
- `casebooks/07` 应把 `cache break / cost spike / wrong allow / wrong deny / split truth / replay mismatch / stale state / zombie risk` 这些现场症状重新路由回 Prompt、治理与结构三条主线；否则 oncall 仍然只能先猜标签。
- `casebooks/08` 应把 `design / assembly / runtime / recovery / evolution` 做成阶段反查表；否则 design debt、assembly error、recovery defect 会继续被误丢给 runtime。
- `casebooks/09` 应把 `section / boundary / stable bytes / shadow-stub / transport shell / recovery asset / object state` 做成资产反查表；否则团队仍会按文件名搜索，而不是按正式制度资产定位失效。
- `navigation/14` 因而成为必要入口：`13` 负责直接查定义、锚点与样例，`14` 负责从现场观察进入制度诊断，避免参考层重新变成静态资料库。

证据:

- `claude-code-source-code/src/constants/systemPromptSections.ts:17-43`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:28-520`
- `claude-code-source-code/src/utils/toolResultStorage.ts:739-860`
- `claude-code-source-code/src/utils/permissions/permissionSetup.ts:235-1283`
- `claude-code-source-code/src/utils/permissions/permissions.ts:593-984`
- `claude-code-source-code/src/hooks/toolPermission/handlers/interactiveHandler.ts:138-455`
- `claude-code-source-code/src/bridge/replBridgeTransport.ts:13-116`
- `claude-code-source-code/src/bridge/bridgePointer.ts:22-167`
- `claude-code-source-code/src/services/api/sessionIngress.ts:60-120`
- `claude-code-source-code/src/utils/QueryGuard.ts:69-106`
- `claude-code-source-code/scripts/prepare-src.mjs:3-64`
- `claude-code-source-code/scripts/stub-modules.mjs:2-42`

### A00k. 多入口反查层之后，下一层应进入自反审读层

- 当 `navigation/14 + casebooks/07-09` 已经把制度压成现场诊断层后，下一步最值钱的不是继续补更多反查表，而是补自反审读层：让 Prompt 魔力、安全定价与源码先进性都能在设计前被主动质疑，而不是等到事故后才被动诊断。
- `guides/30` 应把 Prompt 魔力压成一组设计者可直接自问的问题：谁在说话、谁生产共享前缀、边界画在哪里、什么可以被合法遗忘、后来者如何低成本接手。
- `guides/31` 应把安全与省 token 压成一组输入边界问题：哪些动作、能力、上下文与 continuation 还在免费扩张，哪些检查已经没有决策增益，哪些自动化必须可撤销。
- `guides/32` 应把源码先进性压成一组结构审读问题：权威面是否单一、contract 是否先行、transport 是否被关进 shell、recovery asset 是否成立、未来维护者是否已被当成正式消费者。
- `philosophy/63-65` 因而成为必要收束：`63` 负责说明 Prompt 魔力为什么首先是一种“继续约束”，`64` 负责说明安全成熟为什么首先拒绝免费扩张，`65` 负责说明源码先进性为什么首先要把批评路径编码进结构。
- `navigation/15` 因而成为必要入口：`14` 负责从现场回到制度诊断，`15` 负责从制度诊断继续回到设计自校，避免蓝皮书只会解释 Claude Code 为什么强，却不会帮助团队在设计时少犯错。

证据:

- `claude-code-source-code/src/utils/systemPrompt.ts:28-127`
- `claude-code-source-code/src/query/stopHooks.ts:84-120`
- `claude-code-source-code/src/services/PromptSuggestion/promptSuggestion.ts:184-270`
- `claude-code-source-code/src/services/compact/sessionMemoryCompact.ts:188-397`
- `claude-code-source-code/src/utils/permissions/permissionSetup.ts:235-1283`
- `claude-code-source-code/src/query/tokenBudget.ts:1-93`
- `claude-code-source-code/src/utils/toolResultStorage.ts:367-860`
- `claude-code-source-code/src/utils/QueryGuard.ts:1-121`
- `claude-code-source-code/src/query/config.ts:1-45`
- `claude-code-source-code/src/query/deps.ts:1-40`
- `claude-code-source-code/src/bridge/replBridgeTransport.ts:13-116`
- `claude-code-source-code/src/utils/task/framework.ts:160-248`

### A00l. 自反审读层之后，下一层应进入反例对照层

- 当 `navigation/15 + guides/30-32 + philosophy/63-65` 已经把制度压成设计自校层后，下一步最值钱的不是继续补更多诘问，而是补反例对照层：让同一个设计问题同时出现坏解法、坏的理由、Claude Code 式正解与改写路径。
- `casebooks/10` 应把 Prompt 魔力最常见的伪优化写成对照样例：长文案崇拜、主语漂移、共享前缀分叉、边界错放、非法遗忘、接手断裂与 cache-aware assembly 失真。
- `casebooks/11` 应把安全与省 token 最常见的伪成熟写成对照样例：免费扩张、假统一预算器、全量可见面、无决策增益检查、不可撤销自动化、错误失败语义与错误 continuation。
- `casebooks/12` 应把源码先进性最常见的伪优化写成对照样例：伪模块化、第二真相、transport 差异泄漏、registry 变业务中心、恢复资产缺席、zombie 温床与未来维护者被排除。
- `navigation/16` 因而成为必要入口：`15` 负责先问“该如何自校”，`16` 负责再看“同一个问题最容易怎样被做错”，避免蓝皮书只会给正确答案，却不会帮助团队识别自己已经采用了哪类坏答案。

证据:

- `claude-code-source-code/src/constants/prompts.ts:105-560`
- `claude-code-source-code/src/query/stopHooks.ts:84-120`
- `claude-code-source-code/src/services/PromptSuggestion/promptSuggestion.ts:184-270`
- `claude-code-source-code/src/utils/permissions/permissionSetup.ts:235-1283`
- `claude-code-source-code/src/query/tokenBudget.ts:1-93`
- `claude-code-source-code/src/utils/toolResultStorage.ts:367-860`
- `claude-code-source-code/src/utils/QueryGuard.ts:1-121`
- `claude-code-source-code/src/query/config.ts:1-45`
- `claude-code-source-code/src/query/deps.ts:1-40`
- `claude-code-source-code/src/bridge/replBridgeTransport.ts:13-116`
- `claude-code-source-code/src/utils/cleanupRegistry.ts:1-21`
- `claude-code-source-code/src/utils/task/framework.ts:160-248`

### A00m. 反例对照层之后，下一层应进入迁移工单层

- 当 `navigation/16 + casebooks/10-12` 已经把制度压成同题坏解对照层后，下一步最值钱的不是继续补更多坏案例，而是补迁移工单层：让 Prompt、治理与结构三条线都拥有明确的改写顺序、灰度阶段、停止条件与回退动作。
- `playbooks/06` 应把 Prompt 迁移写成渐进工单：先盘点主语与 section，再分 stable prefix / dynamic boundary，再收敛共享前缀生产权，最后再切 compact / resume / handoff 路径。
- `playbooks/07` 应把治理迁移写成渐进工单：先盘点资产，再写治理顺序，再冻结 stable bytes，再用 decision gain 取代“检查越多越安全”，最后再重写 continuation 与自动化回收。
- `playbooks/08` 应把结构迁移写成渐进工单：先找 authoritative surface，再收回第二真相，再切 leaf module 与 seam，再收 transport shell，再补 recovery asset 与 anti-zombie 保护。
- `navigation/17` 因而成为必要入口：`16` 负责识别“最常见的错法”，`17` 负责说明“既然知道错在哪，下一步该按什么顺序改”，避免蓝皮书只会解释设计优劣，却不帮助团队安全地迁移。

证据:

- `claude-code-source-code/src/utils/systemPrompt.ts:28-127`
- `claude-code-source-code/src/query/stopHooks.ts:84-120`
- `claude-code-source-code/src/services/compact/sessionMemoryCompact.ts:188-397`
- `claude-code-source-code/src/utils/permissions/permissionSetup.ts:235-1283`
- `claude-code-source-code/src/query/tokenBudget.ts:1-93`
- `claude-code-source-code/src/utils/toolResultStorage.ts:367-860`
- `claude-code-source-code/src/utils/QueryGuard.ts:1-121`
- `claude-code-source-code/src/query/config.ts:1-45`
- `claude-code-source-code/src/query/deps.ts:1-40`
- `claude-code-source-code/src/bridge/replBridgeTransport.ts:13-116`
- `claude-code-source-code/src/bridge/bridgePointer.ts:22-167`
- `claude-code-source-code/src/services/api/sessionIngress.ts:60-120`
- `claude-code-source-code/src/utils/task/framework.ts:160-248`

### A00n. 迁移工单层之后，下一层应进入 rollout 样例层

- 当 `navigation/17 + playbooks/06-08` 已经把制度压成迁移执行层后，下一步最值钱的不是继续补更多“该怎么改”，而是补 rollout 样例层：把改写前后 diff、阶段观测、灰度结果与回退记录做成正式样例，让团队知道一次正确迁移看起来究竟长什么样。
- `playbooks/09` 应把 Prompt Constitution 迁移写成完整 rollout：旧长文案如何拆成 section，稳定前缀何时切，dynamic boundary 何时切，compact / resume / handoff 何时切，以及这些切换如何留下 diff 和回退记录。
- `playbooks/10` 应把治理顺序迁移写成完整 rollout：输入边界何时收口、stable bytes 何时冻结、decision gain stop-logic 何时上线、auto lease 何时回收，以及这些变化如何通过成本、误判与 approval race 指标被证明。
- `playbooks/11` 应把结构迁移写成完整 rollout：authoritative surface 何时双写、第二真相何时只读投影、transport shell 何时收口、recovery asset 何时列账、anti-zombie 何时上线，以及这些变化如何通过 split truth、resume、stale-state 指标被验证。
- `navigation/18` 因而成为必要入口：`17` 负责知道“该按什么顺序改”，`18` 负责知道“改了之后应该看到什么证据”，避免蓝皮书仍停留在方法论而没有运行样例。

证据:

- `claude-code-source-code/src/utils/systemPrompt.ts:28-127`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:28-520`
- `claude-code-source-code/src/query/tokenBudget.ts:1-93`
- `claude-code-source-code/src/utils/toolResultStorage.ts:367-860`
- `claude-code-source-code/src/utils/QueryGuard.ts:1-121`
- `claude-code-source-code/src/bridge/bridgePointer.ts:22-167`
- `claude-code-source-code/src/services/api/sessionIngress.ts:60-120`
- `claude-code-source-code/src/utils/task/framework.ts:160-248`

### A00o. Rollout 样例层之后，下一层应进入统一证据 ABI 层

- 当 `navigation/18 + playbooks/09-11` 已经把制度压成完整 rollout 样例后，下一步最值钱的不是继续补更多故事，而是补统一 ABI 层：把对象卡、Diff 卡、阶段评审卡、灰度结果卡与回退记录卡固定成正式 evidence interface。
- `playbooks/12` 应把三条线都共享的骨架先固定下来：记录头、对象、最小 diff、阶段门槛、观测结果、回退目标与证据附件必须共用同一语义，而不是每次迁移重新发明字段。
- Prompt 线的专项字段应稳定为 `speaker_chain / section_slots_changed / stable_prefix_surface / dynamic_boundary_surface / shared_prefix_producer / lawful_forgetting_abi / cache_aware_assembly_factors / handoff_continuity_fields`；这样记录的才是 prompt 制度升级，而不是文案改动。
- 治理线的专项字段应稳定为 `order_before / order_after / decision_owner_before / after / decision_gain_hypothesis / cutoff / stable_bytes_touched / lease_model / revoke_conditions / stop_logic / human_fallback_path / failure_semantics_matrix / continuation_policy / object_upgrade_rule`；这样记录的才是判断主权、停止条件与自动化回收，而不是成本感受。
- 结构线的专项字段应稳定为 `authoritative_surface / projection_set / transport_shell / recovery_asset / anti_zombie_gate`；这样记录的才是真相迁移、恢复资产与反 zombie 保护，而不是目录表面变化。
- `playbooks/13` 因而必须继续补最小填写示例：不是再写一组长 narrative，而是直接展示三条线如何按同一 ABI 落卡。
- `navigation/19` 因而成为必要入口：`18` 负责知道“正确 rollout 长什么样”，`19` 负责知道“以后每次 rollout 都该按哪套 ABI 留证据”，避免蓝皮书停在样例层而不能复用。

证据:

- `claude-code-source-code/src/utils/systemPrompt.ts:28-127`
- `claude-code-source-code/src/query/stopHooks.ts:84-120`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:28-520`
- `claude-code-source-code/src/utils/permissions/permissions.ts:593-984`
- `claude-code-source-code/src/query/tokenBudget.ts:1-93`
- `claude-code-source-code/src/utils/toolResultStorage.ts:367-860`
- `claude-code-source-code/src/utils/QueryGuard.ts:1-121`
- `claude-code-source-code/src/bridge/replBridgeTransport.ts:13-116`
- `claude-code-source-code/src/utils/task/framework.ts:160-248`

### A00p. 统一证据 ABI 层之后，下一层应进入证据真相面与宿主消费层

- 当 `navigation/19 + playbooks/12-13` 已经把 rollout 证据压成统一 ABI 后，下一步最值钱的不是继续补更多卡片，而是把这套 ABI 明确接回 runtime：状态写回、可观测 diff、decision window 与 rollback object boundary 其实已经散落在源码里，只差被收口成同一条 evidence surface。
- `architecture/76` 应把四块 runtime 机制统一起来：`sessionState/onChangeAppState/WorkerStateUploader` 负责当前真相写回，`promptCacheBreakDetection/toolResultStorage` 负责 diffable bytes，`tokenBudget/QueryGuard` 负责继续或停止的决策窗口，`sessionIngress/bridgePointer/task framework` 负责 rollback object boundary。
- `api/35` 应明确三层边界：`worker_status / external_metadata / session_state_changed / Context Usage / control evidence` 是正式 host-consumable surfaces；对象卡、observed window、rollback target 应由宿主自建 envelope 统一承载；`promptCacheBreakDetection` 细项、bridge pointer 文件与 task 内部 patch 等仍应停留在 internal hint 层。
- 这条线最重要的目录判断，是不能把“统一 ABI”误写成“又一层 playbook”。一旦这套 ABI 不进入 `architecture/` 与 `api/`，模板就会停在文档层，无法真正被宿主、评审者与后来者共享消费。
- `navigation/20` 因而成为必要入口：`19` 负责知道“字段该怎么写”，`20` 负责知道“写好的字段怎样进入宿主消费、对象回退与复盘真相面”，否则目录会重新退回“模板存在，但没人真正消费”。

证据:

- `claude-code-source-code/src/utils/sessionState.ts:92-146`
- `claude-code-source-code/src/state/onChangeAppState.ts:24-90`
- `claude-code-source-code/src/cli/transports/WorkerStateUploader.ts:1-118`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:243-360`
- `claude-code-source-code/src/utils/toolResultStorage.ts:739-860`
- `claude-code-source-code/src/query/tokenBudget.ts:1-82`
- `claude-code-source-code/src/utils/QueryGuard.ts:1-83`
- `claude-code-source-code/src/services/api/sessionIngress.ts:57-170`
- `claude-code-source-code/src/bridge/bridgePointer.ts:22-120`
- `claude-code-source-code/src/utils/task/framework.ts:160-248`

### A00q. 证据真相面之后，下一层应进入 shared evidence envelope 层

- 当 `navigation/20 + architecture/76 + api/35` 已经把统一 ABI 接回状态写回、diff 解释、decision window 与 rollback object boundary 后，下一步最值钱的不是继续补更多字段，而是补 shared evidence envelope：让宿主、CI、评审与交接继续共享同一套升级真相，而不是各自再造一层解释。
- `architecture/77` 应把 shared envelope 至少拆成五层：对象真相、状态真相、compiled request truth、decision-window truth、rollback-boundary truth。这样不同消费者虽然消费粒度不同，但仍围绕同一骨架判断。
- `api/36` 应把这层 shared envelope 明确压成字段矩阵：`session_state_changed / worker_status / external_metadata / Context Usage / control evidence` 属于正式公共表面，`observed_window / rollback_object / retained_assets / judgement` 属于宿主自建 envelope，而 cache-break 细项、bridge pointer、task patch 等仍应停留在 internal hint。
- 这条线的第一性原理不是“让所有人看同一份日志”，而是“让所有人围绕同一套对象、窗口、字节与回退边界继续判断”；换句话说，成熟证据真正强的地方不是解释过去，而是约束未来判断。
- `navigation/21` 因而成为必要入口：`20` 负责知道“哪些证据应被消费”，`21` 负责知道“这些证据怎样被宿主、CI、评审与交接共同消费成同一套 envelope”，否则蓝皮书会重新退回“接口存在，但共享判断不存在”。

证据:

- `claude-code-source-code/src/utils/sessionState.ts:92-146`
- `claude-code-source-code/src/state/onChangeAppState.ts:43-90`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1735-1745`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:243-360`
- `claude-code-source-code/src/utils/messages.ts:1989-2075`
- `claude-code-source-code/src/query/tokenBudget.ts:1-82`
- `claude-code-source-code/src/services/api/sessionIngress.ts:57-170`
- `claude-code-source-code/src/utils/task/framework.ts:160-248`

### A00r. shared evidence envelope 之后，下一层应进入 consumer distortion casebook 层

- 当 `navigation/21 + architecture/77 + api/36` 已经把 shared evidence envelope 收口成对象、状态、compiled request truth、decision window 与 rollback boundary 五层骨架后，下一步最值钱的不是继续重复 envelope 原则，而是补 consumer distortion casebook：让团队真正看到这套骨架最常见会怎样被宿主、CI、评审与交接拆散消费。
- `casebooks/13` 应把 Prompt 线的 envelope 失真写成四种坏读法：只看原文 prompt、只看 cache 指标、只看人工总结、只读 transcript 交接；这样才能暴露 Prompt 魔力为什么一旦失去 compiled request truth 就会退回文案崇拜。
- `casebooks/14` 应把治理线的 envelope 失真写成四种坏读法：只看 token、只看审批次数、只看最终结果、只看当前状态；这样才能暴露统一定价秩序为什么一旦失去 decision window 与 rollback boundary 就会退回局部 KPI。
- `casebooks/15` 应把结构线的 envelope 失真写成四种坏读法：只看文件 diff、只看目录图、只看恢复成功率、只靠作者记忆；这样才能暴露源码先进性为什么一旦失去 object boundary 与 retained assets 就会退回文件级回退与目录审美。
- `navigation/22` 因而成为必要入口：`21` 负责知道“shared envelope 该怎样成立”，`22` 负责知道“它最常见会怎样被拆散并失真”，避免蓝皮书重新停在理想设计层而没有消费者失真样本。

证据:

- `claude-code-source-code/src/utils/sessionState.ts:92-146`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:243-360`
- `claude-code-source-code/src/query/tokenBudget.ts:1-82`
- `claude-code-source-code/src/services/api/sessionIngress.ts:57-170`
- `claude-code-source-code/src/utils/task/framework.ts:160-248`

### A00s. consumer distortion casebook 之后，下一层应进入 host implementation playbook 层

- 当 `navigation/22 + casebooks/13-15` 已经把宿主、CI、评审与交接最常见的拆散消费方式写成正式反例后，下一步最值钱的不是继续补更多坏样本，而是补 host implementation playbook：把这些反例反向压成真实检查点，让消费者不再靠经验猜“应该看什么”。
- `playbooks/14` 应把 Prompt 线的 host implementation 写成四组真实门禁：authority source 与 assembly path 是否完整、compiled request diff 是否可解释、stable bytes 漂移是否有因、lawful forgetting 与 handoff package 是否齐全；这样才能让 Prompt 魔力继续停留在工作语法层，而不是退回原文 prompt 崇拜。
- `playbooks/15` 应把治理线的 host implementation 写成四组真实门禁：decision window 是否显式、仲裁胜者是否有 authority source、failure semantics 与 rollback object 是否可消费、对象升级条件是否满足；这样才能让安全与省 token 继续停留在治理顺序层，而不是退回局部 KPI 与事后解释。
- `playbooks/16` 应把结构线的 host implementation 写成四组真实门禁：authoritative surface 是否唯一、recovery asset 是否成账、anti-zombie gate 是否被执行、rollback boundary 与 retained assets 是否可交接；这样才能让源码先进性继续停留在可恢复结构层，而不是退回目录审美与作者记忆。
- `navigation/23` 因而成为必要入口：`22` 负责知道“这套 envelope 最常见会怎样坏”，`23` 负责知道“怎样把这些坏法提前变成宿主、CI、评审与交接的真实检查点”，避免蓝皮书重新停在诊断层而没有落地门禁层。

证据:

- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:243-360`
- `claude-code-source-code/src/query/tokenBudget.ts:1-82`
- `claude-code-source-code/src/services/api/sessionIngress.ts:57-170`
- `claude-code-source-code/src/utils/sessionState.ts:92-146`
- `claude-code-source-code/src/utils/task/framework.ts:160-248`

### A00t. host implementation playbook 之后，下一层应进入 implementation distortion casebook 层

- 当 `navigation/23 + playbooks/14-16` 已经把 Prompt、治理与结构三条线写成宿主、CI、评审与交接都能执行的真实检查点后，下一步最值钱的不是继续补更多门禁，而是补 implementation distortion casebook：让团队真正看到这些检查点在实施里最常会怎样退回存在性合规、流程合规与作者兜底。
- `casebooks/16` 应把 Prompt 线的 implementation 失真写成四种坏读法：只看卡片存在、只看 CI 通过、只看评审顺序完成、只交接摘要包；这样才能暴露 Prompt 魔力为什么一旦失去 compiled request truth、stable bytes explanation 与 lawful forgetting ABI，就会重新退回文案崇拜。
- `casebooks/17` 应把治理线的 implementation 失真写成四种坏读法：只看仪表盘转绿、只看审批结束、只看阈值安全、只看回退开关存在；这样才能暴露安全与省 token 为什么一旦失去 decision window、winner source、failure semantics 与 object-upgrade gate，就会重新退回局部 KPI 与事后解释。
- `casebooks/18` 应把结构线的 implementation 失真写成四种坏读法：只看门禁存在、只看恢复通过、只看 anti-zombie 规则存在、只靠作者口头交接危险路径；这样才能暴露源码先进性为什么一旦失去 authoritative path truth、recovery asset ledger、stale writer 清退证据与 rollback object，就会重新退回目录审美与作者权威。
- `navigation/24` 因而成为必要入口：`23` 负责知道“怎样把 envelope 落成检查点”，`24` 负责知道“这些检查点最常会怎样在真实执行里重新失真”，避免蓝皮书重新停在理想落地层而没有实施级反例层。

证据:

- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:243-360`
- `claude-code-source-code/src/query/tokenBudget.ts:1-82`
- `claude-code-source-code/src/services/api/sessionIngress.ts:57-170`
- `claude-code-source-code/src/utils/sessionState.ts:92-146`
- `claude-code-source-code/src/utils/task/framework.ts:160-248`

### A00u. implementation distortion casebook 之后，下一层应进入 host implementation audit guide 层

- 当 `navigation/24 + casebooks/16-18` 已经把 Prompt、治理与结构三条线在真实执行里最常见的形式主义失真写成正式样本后，下一步最值钱的不是继续补更多事故，而是补 host implementation audit guide：把这些失真重新反压成统一审读顺序，让团队不再靠资深 reviewer 心法维持制度。
- `guides/36` 应把 Prompt 线的 audit guide 写成统一审读 header：先锁 authority source、assembly path 与 compiled request truth，再锁 stable bytes、lawful forgetting ABI 与 handoff guard；这样才能把 Prompt 魔力继续固定在可编译真相，而不是退回卡片、摘要与原文 prompt。
- `guides/37` 应把治理线的 audit guide 写成统一审读 header：先锁 current object、decision window、winner source 与 failure semantics，再锁 Context Usage、rollback object 与 object-upgrade rule；这样才能把安全与省 token 继续固定在统一定价判断链，而不是退回 dashboard 与局部 KPI。
- `guides/38` 应把结构线的 audit guide 写成统一审读 header：先锁 authoritative path、current read/write path 与 recovery asset ledger，再锁 anti-zombie evidence、retained assets、danger paths 与 rollback object；这样才能把源码先进性继续固定在对象真相，而不是退回结构图、恢复成功率与作者记忆。
- `navigation/25` 因而成为必要入口：`24` 负责知道“这些检查点最常会怎样在真实执行里重新失真”，`25` 负责知道“怎样把这些失真统一反压成审读模板”，避免蓝皮书重新停在事故层而没有 builder-facing 审读层。

证据:

- `claude-code-source-code/src/constants/prompts.ts:491-557`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:243-520`
- `claude-code-source-code/src/utils/permissions/permissions.ts:593-984`
- `claude-code-source-code/src/query/tokenBudget.ts:1-82`
- `claude-code-source-code/src/bridge/bridgePointer.ts:22-167`
- `claude-code-source-code/src/utils/QueryGuard.ts:69-106`

### A00v. host implementation audit guide 之后，下一层应进入 host artifact contract 层

- 当 `navigation/25 + guides/36-38` 已经把 Prompt、治理与结构三条线的统一审读顺序写成 builder-facing 模板后，下一步最值钱的不是继续补更多审读心法，而是补 host artifact contract：把宿主卡、CI附件、评审卡与 handoff package 压成正式共享工件协议，让不同角色真正共享同一对象真相，而不是共享同一套格式。
- `api/37` 应把 Prompt 线的 artifact contract 写成 shared header：先锁 prompt_object、authority source、assembly path、compiled request diff、stable bytes ledger、lawful forgetting ABI 与 next-step guard，再让宿主卡、CI附件、评审卡与 handoff package 只做不同投影；这样才能把 Prompt 魔力继续固定在 compiled request truth，而不是退回原文、卡片与摘要。
- `api/38` 应把治理线的 artifact contract 写成 shared header：先锁 governance object、decision window、winner source、failure semantics、rollback object 与 object-upgrade rule，再让宿主卡、CI附件、评审卡与 handoff package 只做不同投影；这样才能把安全与省 token 继续固定在统一判断链，而不是退回绿色仪表盘与局部 KPI。
- `api/39` 应把结构线的 artifact contract 写成 shared header：先锁 structure object、authoritative path、current read/write path、recovery asset ledger、anti-zombie evidence、retained assets 与 rollback object，再让宿主卡、CI附件、评审卡与 handoff package 只做不同投影；这样才能把源码先进性继续固定在对象级结构真相，而不是退回结构图、恢复结果与作者记忆。
- `philosophy/69` 因而成为必要收束：成熟工件不是四套表单，而是四类角色共享同一判断对象；没有这层收束，artifact contract 很快又会退回存在性合规和表单繁殖。
- `navigation/26` 因而成为必要入口：`25` 负责知道“怎样统一审读”，`26` 负责知道“怎样把统一审读真正压成共享工件协议”，避免蓝皮书重新停在审读层而没有 contract 层。

证据:

- `claude-code-source-code/src/utils/messages.ts:1989-2148`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:243-520`
- `claude-code-source-code/src/utils/permissions/permissions.ts:593-984`
- `claude-code-source-code/src/query/tokenBudget.ts:1-82`
- `claude-code-source-code/src/bridge/bridgePointer.ts:22-167`
- `claude-code-source-code/src/utils/task/framework.ts:160-248`

### A00w. host artifact contract 之后，下一层应进入 artifact samplebook 层

- 当 `navigation/26 + api/37-39` 已经把 Prompt、治理与结构三条线的 shared header 压成正式共享工件协议后，下一步最值钱的不是继续补更多 schema，而是补 artifact samplebook：让宿主卡、CI附件、评审卡与 handoff package 的最小样例真正落地，避免团队继续从空白模板起步。
- `playbooks/17` 应把 Prompt 线的 samplebook 写成四类最小工件样例：shared header 先锁 prompt_object、authority_source、assembly_path、compiled_request_diff、stable_bytes_ledger、lawful_forgetting_abi 与 next_step_guard，再分别展示宿主卡、CI附件、评审卡与交接包的最小投影；这样才能让 Prompt 魔力继续停留在 compiled request truth，而不是退回原文 prompt 与摘要包。
- `playbooks/18` 应把治理线的 samplebook 写成四类最小工件样例：shared header 先锁 governance_object、decision_window、winner_source、failure_semantics、rollback_object 与 object_upgrade_rule，再分别展示对象卡、窗口卡、仲裁附件、评审卡与交接包的最小投影；这样才能让安全与省 token 继续停留在统一判断链，而不是退回仪表盘和阈值图。
- `playbooks/19` 应把结构线的 samplebook 写成四类最小工件样例：shared header 先锁 structure_object、authoritative_path、current read/write path、recovery_asset_ledger、anti_zombie_evidence、retained_assets 与 rollback_object，再分别展示权威路径卡、恢复附件、评审卡与交接包的最小投影；这样才能让源码先进性继续停留在对象级结构真相，而不是退回结构图、恢复成功率与作者讲解。
- `navigation/27` 因而成为必要入口：`26` 负责知道“怎样把统一审读落成共享工件协议”，`27` 负责知道“这些共享工件协议真正填出来时长什么样”，避免蓝皮书重新停在 contract 层而没有最小可复用样例层。

证据:

- `claude-code-source-code/src/utils/messages.ts:1989-2148`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:243-520`
- `claude-code-source-code/src/utils/permissions/permissions.ts:593-984`
- `claude-code-source-code/src/query/tokenBudget.ts:1-82`
- `claude-code-source-code/src/bridge/bridgePointer.ts:22-167`
- `claude-code-source-code/src/utils/task/framework.ts:160-248`

### A00x. artifact samplebook 之后，下一层应进入 artifact drift casebook 层

- 当 `navigation/27 + playbooks/17-19` 已经把 Prompt、治理与结构三条线的最小共享 artifact 样例写出来之后，下一步最值钱的不是继续补更多正例，而是补 artifact drift casebook：把宿主卡、CI附件、评审卡与交接包已经存在时，最常怎样重新退回局部真相写成正式失真原型。
- `casebooks/19` 应把 Prompt 线的 drift 写成四类工件重新说谎：宿主卡退回原文 prompt、CI 附件退回绿灯、评审卡退回总结、交接包退回摘要；这样才能证明 Prompt 魔力守住的是 compiled request truth，而不是“卡片存在”。
- `casebooks/20` 应把治理线的 drift 写成四类工件重新局部 KPI 化：窗口卡退回状态色、仲裁附件退回计数、评审卡退回 verdict、交接包失去 rollback object；这样才能证明安全与省 token 守住的是统一判断链，而不是仪表盘和统计面板。
- `casebooks/21` 应把结构线的 drift 写成四类工件重新口头化：权威路径卡退回目录图、恢复附件只剩成功率、评审卡退回结构夸奖、交接包回到作者说明；这样才能证明源码先进性守住的是 shared structure object，而不是结构展示。
- `navigation/28` 因而成为必要入口：`27` 负责知道“共享工件怎样正确填写”，`28` 负责知道“这些工件在外观完好时最常怎样重新退回局部真相”，避免蓝皮书重新停在样例层而没有工件级失真层。
- 这一层真正服务的不是抱怨执行力，而是为 validator / linter / hard gate 提供 drift 原型和失败边界；没有这层，自动校验只能检查字段存在，无法检查 shared object 是否已经断掉。

证据:

- `claude-code-source-code/src/utils/messages.ts:1989-2148`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:243-520`
- `claude-code-source-code/src/utils/permissions/permissions.ts:593-984`
- `claude-code-source-code/src/query/tokenBudget.ts:1-82`
- `claude-code-source-code/src/bridge/bridgePointer.ts:22-167`
- `claude-code-source-code/src/utils/task/framework.ts:160-248`

### A00y. artifact drift casebook 之后，下一层应进入 artifact validator / linter 层

- 当 `navigation/28 + casebooks/19-21` 已经把 Prompt、治理与结构三条线的工件级失真原型写出来之后，下一步最值钱的不是继续补更多漂移故事，而是补 artifact validator / linter：把 shared header、hard contract 与 drift 原型编译成自动校验、reviewer gate 与 handoff reject。
- `guides/39` 应把 Prompt 线的 validator 写成共享对象校验：先锁 `prompt_object_id`、`authority_source`、`assembly_path`、`compiled_request_diff_ref`、`stable_bytes_ledger_ref`、`lawful_forgetting_abi_ref` 与 `next_step_guard`，再让宿主卡、CI 附件、评审卡与交接包围绕同一 `compiled request object` 被持续验证；这样才能把 Prompt 魔力继续固定在 shared object continuity，而不是退回文案崇拜。
- `guides/40` 应把治理线的 validator 写成统一判断链校验：先锁 `governance_object_id`、`decision_window`、`winner_source`、`control_arbitration_truth`、`failure_semantics`、`rollback_object` 与 `next_action`，再让状态色、计数、verdict 与交接摘要失去独立夺权资格；这样才能把安全与省 token 继续固定在决策增益判断，而不是退回局部 KPI。
- `guides/41` 应把结构线的 validator 写成对象级结构校验：先锁 `structure_object_id`、`authoritative_path`、`current_read_path`、`current_write_path`、`recovery_asset_ledger`、`anti_zombie_evidence`、`danger_paths` 与 `rollback_object`，再让目录图、恢复成功率与作者说明失去独立夺权资格；这样才能把源码先进性继续固定在 shared structure object，而不是退回目录审美。
- `navigation/29` 因而成为必要入口：`28` 负责知道“这些工件最常怎样重新说谎”，`29` 负责知道“系统应怎样正式拒绝这些谎言”，避免蓝皮书重新停在反例识别层而没有执行收束层。
- `philosophy/70` 因而成为必要收束：真正成熟的校验，不是字段齐全，而是共享对象能拒绝漂移；没有这层收束，validator 很快又会退回 checklist 与格式巡检。

证据:

- `claude-code-source-code/src/constants/prompts.ts:491-557`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:243-520`
- `claude-code-source-code/src/utils/permissions/permissions.ts:593-984`
- `claude-code-source-code/src/query/tokenBudget.ts:1-82`
- `claude-code-source-code/src/bridge/bridgePointer.ts:22-167`
- `claude-code-source-code/src/utils/task/framework.ts:160-248`

### A00z. artifact validator / linter 之后，下一层应进入 artifact rule ABI 层

- 当 `navigation/29 + guides/39-41` 已经把 Prompt、治理与结构三条线的自动校验、reviewer gate 与 handoff reject 写出来之后，下一步最值钱的不是继续补更多规则说明，而是补 artifact rule ABI：把 hard fail、lint warn、reviewer gate、handoff reject 与 rewrite hint 压成不同消费者共享的 machine-readable rule packet。
- `api/40` 应把 Prompt 线的 rule ABI 写成 shared object continuity 规则包：先锁 `prompt_object_id`、`compiled_request_diff_ref`、`stable_bytes_ledger_ref`、`lawful_forgetting_abi_ref` 与 `next_step_guard`，再把原文崇拜、绿灯崇拜、总结崇拜与摘要崇拜压成同一拒收语义；这样才能把 Prompt 魔力继续固定在 compiled request continuity，而不是退回文案。
- `api/41` 应把治理线的 rule ABI 写成 decision gain 规则包：先锁 `governance_object_id`、`decision_window`、`winner_source`、`failure_semantics`、`rollback_object` 与 `next_action`，再把状态色、计数、verdict 与状态摘要压成同一拒收语义；这样才能把安全与省 token 继续固定在“没有决策增益就不该继续”的统一判断。
- `api/42` 应把结构线的 rule ABI 写成 shared reject semantics 规则包：先锁 `structure_object_id`、`authoritative_path`、`recovery_asset_ledger`、`anti_zombie_evidence`、`danger_paths` 与 `rollback_object`，再把目录图、恢复成功率与作者说明压成同一拒收语义；这样才能把源码先进性继续固定在 authoritative surface 与 anti-zombie 约束，而不是退回结构审美。
- `navigation/30` 因而成为必要入口：`29` 负责知道“系统该怎样拒绝 drift”，`30` 负责知道“这些拒绝条件怎样被不同消费者共享成同一规则包”，避免蓝皮书重新停在 validator 层而没有 machine-readable rule layer。
- `philosophy/71` 因而成为必要收束：真正成熟的规则，不是更多检查，而是不同消费者共享同一拒收语义；没有这层收束，rule ABI 很快又会退回到不同团队各自维护的本地 gate。

证据:

- `claude-code-source-code/src/constants/prompts.ts:491-557`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:243-520`
- `claude-code-source-code/src/utils/permissions/permissions.ts:593-984`
- `claude-code-source-code/src/query/tokenBudget.ts:1-82`
- `claude-code-source-code/src/bridge/bridgePointer.ts:22-167`
- `claude-code-source-code/src/utils/task/framework.ts:160-248`

### A010. artifact rule ABI 之后，下一层应进入 artifact rule sample kit / evaluator 层

- 当 `navigation/30 + api/40-42` 已经把 Prompt、治理与结构三条线的 machine-readable rule packet 写出来之后，下一步最值钱的不是继续补更多规则定义，而是补 artifact rule sample kit / evaluator：把 hard fail、lint warn、reviewer gate、handoff reject 与 rewrite hint 写成最小规则样例、失败样例与 evaluator 接口。
- `playbooks/20` 应把 Prompt 线的 sample kit 写成 continuation 验证样例：先锁 `prompt_object_id`、`compiled_request_diff_ref`、`stable_bytes_ledger_ref`、`lawful_forgetting_abi_ref` 与 `next_step_guard`，再让宿主、CI、评审与交接重复触发相同 reject reason；这样才能把 Prompt 魔力继续固定在 shared continuation，而不是退回原文、绿灯与摘要。
- `playbooks/21` 应把治理线的 sample kit 写成 decision gain 验证样例：先锁 `governance_object_id`、`decision_window`、`failure_semantics`、`rollback_object` 与 `next_action`，再让状态色、计数、verdict 与状态摘要在不同消费者里触发相同 reject reason；这样才能把安全与省 token 继续固定在统一决策增益判断，而不是退回局部 KPI。
- `playbooks/22` 应把结构线的 sample kit 写成 split-brain / anti-zombie 验证样例：先锁 `structure_object_id`、`authoritative_path`、`recovery_asset_ledger`、`anti_zombie_evidence`、`danger_paths` 与 `rollback_object`，再让目录图、恢复成功率与作者说明在不同消费者里触发相同 reject reason；这样才能把源码先进性继续固定在 authoritative surface 与 stale-writer 清退，而不是退回结构展示。
- `navigation/31` 因而成为必要入口：`30` 负责知道“规则包怎样定义”，`31` 负责知道“这些规则包怎样被重复验证”，避免蓝皮书重新停在 rule ABI 层而没有验证样例层。
- `philosophy/72` 因而成为必要收束：真正成熟的验证，不是规则会跑，而是共享拒收语义能被反复证明；没有这层收束，sample kit 很快又会退回零散 YAML 与一次性演示。

### A011. artifact rule sample kit / evaluator 之后，下一层应进入 artifact evaluator harness / replay lab 层

- 当 `navigation/31 + playbooks/20-22` 已经把 Prompt、治理与结构三条线的最小规则样例、失败样例与 evaluator 接口写出来之后，下一步最值钱的不是继续补更多 YAML，而是补 evaluator harness / replay lab：把 replay case、cross-consumer alignment、drift regression 与 rewrite replay 接成可重放验证实验室。
- `playbooks/23` 应把 Prompt 线的 harness 写成 continuation replay 实验室：先锁 `prompt_object_id`、`compiled_request_diff_ref`、`lawful_forgetting_abi_ref` 与 `next_step_guard`，再让宿主、CI、评审与交接在同一 replay case 里重复触发相同 reject reason；这样才能把 Prompt 魔力继续固定在 shared continuation，而不是退回原文、绿灯与摘要。
- `playbooks/24` 应把治理线的 harness 写成 decision gain replay 实验室：先锁 `governance_object_id`、`decision_window`、`failure_semantics`、`rollback_object` 与 `next_action`，再让状态色、计数、verdict 与状态摘要在同一 replay case 里重复触发相同 reject reason；这样才能把安全与省 token 继续固定在统一决策增益，而不是退回局部 KPI。
- `playbooks/25` 应把结构线的 harness 写成 split-brain / anti-zombie replay 实验室：先锁 `structure_object_id`、`authoritative_path`、`recovery_asset_ledger`、`anti_zombie_evidence`、`danger_paths` 与 `rollback_object`，再让目录图、恢复成功率与作者说明在同一 replay case 里重复触发相同 reject reason；这样才能把源码先进性继续固定在 authoritative surface 与 stale-writer 清退，而不是退回结构展示。
- `navigation/32` 因而成为必要入口：`31` 负责知道“这些样例怎样定义”，`32` 负责知道“这些样例怎样被重放、对齐与回归”，避免蓝皮书重新停在 sample kit 层而没有验证实验室层。
- `philosophy/73` 因而成为必要收束：真正成熟的回放，不是脚本重跑，而是共享拒收语义能跨消费者重复成立；没有这层收束，replay lab 很快又会退回一次性 demo。

证据:

- `claude-code-source-code/src/constants/prompts.ts:491-557`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:243-520`
- `claude-code-source-code/src/utils/permissions/permissions.ts:593-984`
- `claude-code-source-code/src/query/tokenBudget.ts:1-82`
- `claude-code-source-code/src/bridge/bridgePointer.ts:22-167`
- `claude-code-source-code/src/utils/task/framework.ts:160-248`

### A012. artifact evaluator harness / replay lab 之后，下一层应进入 artifact harness runner / drift ledger 层

- 当 `navigation/32 + playbooks/23-25` 已经把 Prompt、治理与结构三条线的 replay case、cross-consumer alignment、drift regression 与 rewrite replay 写出来之后，下一步最值钱的不是继续补更多实验室 case，而是补 artifact harness runner / drift ledger：把 replay queue、alignment assertion、drift ledger 与 rewrite adoption 接成可持续执行底盘。
- `api/43` 应把 Prompt 线继续写成 harness runner 协议：先锁 `prompt_object_id`、`compiled_request_diff_ref`、`stable_bytes_ledger_ref`、`lawful_forgetting_abi_ref` 与 `next_step_guard`，再把 replay verdict、drift ledger 与 rewrite adoption 接成同一条 continuation 对象链；这样才能把 Prompt 魔力继续固定在 shared continuation，而不是退回原文、绿灯与摘要。
- `api/44` 应把治理线继续写成 harness runner 协议：先锁 `governance_object_id`、`decision_window`、`control_arbitration_truth`、`rollback_object` 与 `next_action`，再把 replay verdict、drift ledger 与 object upgrade 接成同一条 decision-gain 对象链；这样才能把安全与省 token 继续固定在统一决策增益，而不是退回局部 KPI。
- `api/45` 应把结构线继续写成 harness runner 协议：先锁 `structure_object_id`、`authoritative_path`、`recovery_asset_ledger`、`anti_zombie_evidence`、`dropped_stale_writers` 与 `rollback_object`，再把 replay verdict、drift ledger 与 recovery adoption 接成同一条 authority 对象链；这样才能把源码先进性继续固定在 authoritative surface 与 stale-writer 清退，而不是退回结构展示。
- `architecture/78` 因而成为必要底盘：真正成熟的验证运行时，不只会 replay，还会排队、对齐、留痕并把修复重新接回下一轮执行。
- `navigation/33` 因而成为必要入口：`32` 负责知道“实验室怎样证明共享拒收语义”，`33` 负责知道“这些实验室怎样继续进入持续执行底盘”，避免蓝皮书重新停在 replay lab 层而没有 runner / ledger 层。
- `philosophy/74` 因而成为必要收束：真正成熟的验证底盘，不是更多实验室，而是回放、改写与台账共享同一持续执行语义；没有这层收束，runner 很快又会退回定时跑脚本。

证据:

- `claude-code-source-code/src/QueryEngine.ts:436-463`
- `claude-code-source-code/src/QueryEngine.ts:734-750`
- `claude-code-source-code/src/QueryEngine.ts:875-933`
- `claude-code-source-code/src/query.ts:365-375`
- `claude-code-source-code/src/query.ts:699-705`
- `claude-code-source-code/src/services/compact/compact.ts:766-899`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:224-666`
- `claude-code-source-code/src/utils/QueryGuard.ts:29-93`
- `claude-code-source-code/src/utils/toolResultStorage.ts:739-908`
- `claude-code-source-code/src/state/onChangeAppState.ts:43-91`
- `claude-code-source-code/src/utils/sessionState.ts:92-133`
- `claude-code-source-code/src/cli/structuredIO.ts:149-657`
- `claude-code-source-code/src/utils/sessionStorage.ts:1085-1215`
- `claude-code-source-code/src/tasks/RemoteAgentTask/RemoteAgentTask.tsx:386-845`
- `claude-code-source-code/src/bridge/bridgePointer.ts:21-184`

### A013. artifact harness runner / drift ledger 之后，下一层应进入 builder-facing runner 手册层

- 当 `navigation/33 + api/43-45 + architecture/78` 已经把 Prompt、治理与结构三条线的持续执行协议与底盘写出来之后，下一步最值钱的不是继续补更多 runner 名词，而是补 builder-facing runner 手册：把 replay queue policy、alignment gate、drift review 与 adoption runbook 压成团队每天真的会执行的顺序。
- `guides/42` 应把 Prompt 线继续写成 runner 手册：先锁 `prompt_object_id`、accepted transcript checkpoint、compact boundary、`cache_safe_params`、`stable_bytes_ledger_ref`、`lawful_forgetting_abi_ref` 与 `next_step_guard`，再把 replay queue、prefix ledger、continuation gate 与 rewrite adoption 接成同一条 continuation 操作链；这样才能把 Prompt 魔力继续固定在 shared continuation，而不是退回原文、绿灯与摘要。
- `guides/43` 应把治理线继续写成 runner 手册：先锁 `governance_object_id`、`decision_window`、`winner_source`、`control_arbitration_truth`、`rollback_object` 与 `object_upgrade_rule`，再把 decision queue、alignment gate、arbitration ledger 与 object upgrade 接成同一条治理操作链；这样才能把安全与省 token 继续固定在统一决策增益，而不是退回局部 KPI。
- `guides/44` 应把结构线继续写成 runner 手册：先锁 `structure_object_id`、`authoritative_path`、`recovery_asset_ledger`、`dropped_stale_writers`、`bridge_pointer_ref` 与 `rollback_object`，再把 authoritative queue、recovery ledger、anti-zombie review 与 recovery adoption 接成同一条恢复操作链；这样才能把源码先进性继续固定在 authoritative surface 与 stale-writer 清退，而不是退回结构展示。
- `navigation/34` 因而成为必要入口：`33` 负责知道“持续执行协议为什么成立”，`34` 负责知道“团队每天怎样照此执行”，避免蓝皮书重新停在 runner 抽象层而没有团队动作层。
- `philosophy/75` 因而成为必要收束：真正成熟的继续，不是复用上一轮结论，而是重新消费上一轮留下的判断条件；没有这层收束，团队很快又会把 runner 写回默认延长会话。

证据:

- `claude-code-source-code/src/QueryEngine.ts:436-463`
- `claude-code-source-code/src/QueryEngine.ts:687-717`
- `claude-code-source-code/src/query/stopHooks.ts:84-98`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:224-666`
- `claude-code-source-code/src/utils/QueryGuard.ts:29-93`
- `claude-code-source-code/src/cli/structuredIO.ts:149-657`
- `claude-code-source-code/src/utils/sessionState.ts:92-133`
- `claude-code-source-code/src/utils/sessionStorage.ts:1085-1215`
- `claude-code-source-code/src/utils/task/framework.ts:160-269`
- `claude-code-source-code/src/bridge/bridgePointer.ts:22-184`

### A014. builder-facing runner 手册层之后，下一层应进入源码 atlas 层

- 当 `navigation/34 + guides/42-44` 已经把 runner / ledger 方法压成团队操作顺序之后，下一步最值钱的不是继续补更多 checklist，而是回到 `services/`、`tools/`、`commands/` 的二级目录 atlas：把权威入口、消费者子集、internal-only 边界与危险改动面重新拉平。
- `api/46` 应把 `services/` 继续拆成子系统 atlas：至少要分清 `api`、`compact`、`SessionMemory/PromptSuggestion`、`mcp/plugins/oauth/settingsSync`、`lsp/voice/MagicDocs`、`analytics/logging/notifier`、`services/tools` 这几组，并明确哪个目录在宣布真相、哪个目录只是消费它。
- `api/47` 应把 `tools/` 继续拆成工具族群 atlas：至少要分清执行原语、搜索检索、认知控制、任务编排、扩展桥接、环境自动化与 internal/testing；同时要把 `tools.ts` 的 `getAllBaseTools/getTools/assembleToolPool` 立为单一权威入口，避免读者把某个工具目录误当成真实可见面。
- `api/48` 应把 `commands/` 继续拆成命令族群 atlas：至少要分清会话控制、模式治理、扩展装配、交付诊断、协作工作流与 internal-only surface；同时要把 `commands.ts` 的 `INTERNAL_ONLY_COMMANDS + COMMANDS()` 立为公开/内部边界入口，避免“代码里有命令 = 产品承诺支持”的误读。
- `navigation/35` 因而成为必要入口：`30` 负责知道“顶层目录大致分成哪些能力平面”，`35` 负责知道“进入这些平面后，二级目录应该怎样读”，避免蓝皮书重新停在一级目录概览。
- `philosophy/76` 因而成为必要收束：真正成熟的源码地图，不是目录列得更细，而是更快暴露权威入口、消费者子集与危险改动面；没有这层收束，atlas 很快又会退回更长的目录树。

证据:

- `claude-code-source-code/src/commands.ts:224-340`
- `claude-code-source-code/src/tools.ts:193-367`
- `claude-code-source-code/src/services/api/sessionIngress.ts:57-186`
- `claude-code-source-code/src/services/compact/compact.ts:766-899`
- `claude-code-source-code/src/services/SessionMemory/sessionMemory.ts:302-375`
- `claude-code-source-code/src/services/PromptSuggestion/promptSuggestion.ts:184-244`
- `claude-code-source-code/src/services/mcp/config.ts:888-980`
- `claude-code-source-code/src/services/tools/toolOrchestration.ts:19-80`
- `claude-code-source-code/src/tools/ToolSearchTool/ToolSearchTool.ts:21-120`
- `claude-code-source-code/src/commands/mcp/mcp.tsx:63-85`

### A015. 源码 atlas 层之后，下一层应进入 Agent Runtime 构建层

- 当 `navigation/35 + api/46-48 + philosophy/76` 已经把顶层目录继续拆成二级 atlas 之后，下一步最值钱的不是继续补更多目录树，而是补可迁移的 Agent Runtime 构建层：把对象、协作语法、资源定价、恢复闭环、宿主模板与统一蓝图压成一套 builder-facing 方法。
- `guides/45` 应把第一性原理构建顺序写清：先固定正式对象，再固定协作语法，再固定资源定价，再固定恢复闭环，最后才让命令、工具、宿主与集成长出来；这样才能把 prompt 魔力、安全设计与恢复设计重新收口到同一套构建方法，而不是停在功能列表。
- `guides/46` 应把宿主落地模板写清：host 最小闭环必须同时消费 `control_request/control_response/control_cancel_request`、event stream、`worker_status/external_metadata`、`Context Usage` 与 recovery/snapshot；这样才能把安全与省 token 继续固定在正式 host control plane，而不是退回答案流。
- `guides/47` 应把统一蓝图写清：Prompt 语法、资源定价与可演化内核不是三份并列专题，而是 request object、authority surface、consumer subset、recovery asset 与 dangerous change surface 这同一组设计单位的不同投影；这样才能把源码先进性继续固定在统一蓝图，而不是退回表面模仿。
- `navigation/36` 因而成为必要入口：`35` 负责知道“二级目录该怎样读”，`36` 负责知道“读完这些目录后怎样真正把它们编译成自己的 Runtime”，避免蓝皮书重新停在 atlas 层。
- `philosophy/77` 因而成为必要收束：真正成熟的构建，不是复刻功能，而是先固定对象、边界、预算与恢复闭环；没有这层收束，构建指南很快又会退回 feature checklist。

证据:

- `claude-code-source-code/src/constants/prompts.ts:491-557`
- `claude-code-source-code/src/utils/systemPrompt.ts:28-104`
- `claude-code-source-code/src/utils/messages.ts:1989-2148`
- `claude-code-source-code/src/services/compact/compact.ts:517-711`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:57-240`
- `claude-code-source-code/src/cli/structuredIO.ts:149-657`
- `claude-code-source-code/src/utils/sessionState.ts:92-133`
- `claude-code-source-code/src/utils/permissions/permissions.ts:1158-1280`
- `claude-code-source-code/src/query/tokenBudget.ts:45-92`
- `claude-code-source-code/src/utils/sessionStorage.ts:1085-1215`

证据:

- `claude-code-source-code/src/constants/prompts.ts:491-557`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:243-520`
- `claude-code-source-code/src/utils/permissions/permissions.ts:593-984`
- `claude-code-source-code/src/query/tokenBudget.ts:1-82`
- `claude-code-source-code/src/bridge/bridgePointer.ts:22-167`
- `claude-code-source-code/src/utils/task/framework.ts:160-248`

### A00c. 第二序制度层已经稳定成三条母线

- `Prompt Constitution` 现在应被视为 prompt 深线的第二序终点：它不再讨论“哪段文案更强”，而讨论 prompt 的 section 宪法、角色优先级链、合法遗忘与可观测 diff。
- “治理顺序 + 失败语义 + 可撤销自动化”现在应被视为安全/省 token 深线的第二序终点：统一预算器只是第一步，更成熟的问题是哪些检查先发生、哪些失败分型、哪些自动化必须退回人工。
- “构建系统也是架构工具”现在应被视为源码先进性深线的第二序终点：构建、入口影子、transport shell、薄 registry 与 zombification 治理共同塑造发布面、模块图与恢复约束。

### A0. 协作接口、有效自由与治理界面

- Sticky Prompt 只从真实用户主语与非 meta 的 `queued_command` 中提炼可见锚点，还会裁掉 system reminder 与无意义前缀，说明它在维护的是“当前到底在回应什么”的协作接口，而不是简单 UI 装饰。
- Suggestion 只在输入为空且 assistant 未响应时出现，且生成目标被明确约束为“预测用户自然会输入什么”，说明它服务的是低成本接手，而不是替用户发明计划。
- protocol transcript 与 UI transcript 不是同一物：部分 system message 会并入 user turn，不可用的 `tool_reference` 会被剥离，还会为 server 采样稳定性注入额外 sibling text，因此 prompt 纠偏应优先补新边界，而不是机械复述完整聊天历史。
- Session Memory 通过隔离上下文和 forked agent 更新 memory 文件，说明它保存的是未来继续执行需要的最小语义体，而不是普通聊天纪要。
- permission mode 的设计目标是“有效自由”而不是“最大自由”：deny rule、ask rule、content-specific ask 与 safety check 都能在高权限路径上继续生效，bypass 不是对边界的取消。
- Permission Prompt 的 accept / reject 两侧都支持附带反馈，说明审批在作者心中是协商接口，而不是单纯停顿；远程 channel 审批也被设计成结构化事件 race，而不是文本聊天猜测。
- deferred tools delta、tool result replacement state 与 token budget continuation 共同说明：Claude Code 更偏爱按需出现能力、外置大结果、在边际收益下降时主动停止，而不是用全量能力和超长回合换取假自由。
- builder 侧的核心经验不是“目录像不像”，而是把单一真相文件、leaf module、config / deps seam、snapshot 语义和显式状态机写进代码边界，让维护者读代码时直接读到治理规则。

证据:

- `claude-code-source-code/src/components/VirtualMessageList.tsx:145-180`
- `claude-code-source-code/src/components/VirtualMessageList.tsx:946-1035`
- `claude-code-source-code/src/hooks/usePromptSuggestion.ts:15-176`
- `claude-code-source-code/src/services/PromptSuggestion/promptSuggestion.ts:184-270`
- `claude-code-source-code/src/services/SessionMemory/sessionMemory.ts:303-345`
- `claude-code-source-code/src/utils/messages.ts:2078-2148`
- `claude-code-source-code/src/utils/permissions/permissions.ts:1169-1280`
- `claude-code-source-code/src/components/permissions/PermissionPrompt.tsx:30-212`
- `claude-code-source-code/src/services/mcp/channelPermissions.ts:1-240`
- `claude-code-source-code/src/query/tokenBudget.ts:1-93`
- `claude-code-source-code/src/query/config.ts:8-45`
- `claude-code-source-code/src/query/deps.ts:8-39`
- `claude-code-source-code/src/utils/QueryGuard.ts:1-121`

### A. 启动与入口

- CLI 先走 fast path，再决定是否 import `main.js`。
- `main.tsx` 是总控层，不只是 TUI 入口。
- init 显式区分 trust 前后的行为边界。

证据:

- `claude-code-source-code/src/entrypoints/cli.tsx:28-33`
- `claude-code-source-code/src/entrypoints/cli.tsx:95-185`
- `claude-code-source-code/src/main.tsx:585-855`
- `claude-code-source-code/src/entrypoints/init.ts:62-88`

### B. 核心 agent loop

- `QueryEngine` 管会话生命周期。
- `query.ts` 负责 streaming、tool use、fallback、compaction、recovery。
- transcript 在 query 前就会先落盘。

证据:

- `claude-code-source-code/src/QueryEngine.ts:209-333`
- `claude-code-source-code/src/QueryEngine.ts:430-463`
- `claude-code-source-code/src/query.ts:659-865`

### C. 能力系统

- tool 是统一执行原语。
- commands 与 skills 都被收敛进统一命令装配过程。
- skills 支持 frontmatter 声明权限、hooks、model、paths、agent。

证据:

- `claude-code-source-code/src/Tool.ts:362-792`
- `claude-code-source-code/src/commands.ts:445-517`
- `claude-code-source-code/src/skills/loadSkillsDir.ts:185-261`

### D. 扩展与边界

- MCP 是正式扩展总线，支持多 transport、多 config scope、policy/dedup。
- Remote session 与 Remote Control bridge 是两条不同远程路径。
- 多 Agent 建立在 task runtime 上，而不是 prompt hack。

证据:

- `claude-code-source-code/src/services/mcp/types.ts:9-27`
- `claude-code-source-code/src/services/mcp/config.ts:1258-1290`
- `claude-code-source-code/src/remote/RemoteSessionManager.ts:87-141`
- `claude-code-source-code/src/bridge/bridgeEnabled.ts:57-87`
- `claude-code-source-code/src/Task.ts:6-29`

### E. Session / state surface

- SDK 入口已经声明 `getSessionMessages`、`listSessions`、`getSessionInfo`、`renameSession`、`tagSession`、`forkSession` 等 session API，但在当前提取树里这些函数体仍是 stub，必须区分“文档化意图”和“当前可见实现”。
- control protocol 已经形成更完整的 runtime state surface，包括 `get_context_usage`、`rewind_files`、`seed_read_state`、`get_settings`。
- session/state 的后端不是单一 transcript，而是 transcript、metadata、layered memory、session memory、file history / rewind 的组合状态面。

证据:

- `claude-code-source-code/src/entrypoints/agentSdkTypes.ts:167-272`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:175-519`
- `claude-code-source-code/src/utils/sessionStorage.ts:198-258`
- `claude-code-source-code/src/utils/sessionStorage.ts:4739-5105`
- `claude-code-source-code/src/utils/fileHistory.ts:45-320`

### F. Agent orchestration 与 isolation

- AgentTool 真正提供的是编排器，而不是薄的“再起一个模型调用”。
- 多 Agent 的核心不只是并发，而是上下文、权限、文件系统、历史链与环境的分层隔离。
- `createSubagentContext(...)`、worktree、remote isolation、sidechain transcript 与 cleanup 共同构成“隔离优先于并发”的实现基础。

证据:

- `claude-code-source-code/src/tools/AgentTool/AgentTool.tsx:318-764`
- `claude-code-source-code/src/tools/AgentTool/runAgent.ts:95-859`
- `claude-code-source-code/src/utils/forkedAgent.ts:253-625`
- `claude-code-source-code/src/tools/EnterWorktreeTool/EnterWorktreeTool.ts:52-127`
- `claude-code-source-code/src/tools/ExitWorktreeTool/ExitWorktreeTool.ts:67-320`

### G. Unified extension surface

- Claude Code 的扩展面不是“plugins、skills、agents 各自一套系统”，而是目录约定、frontmatter 与 manifest 共同驱动的统一声明式装配面。
- skills / legacy commands / agents 共享大量 frontmatter 语义，但默认值与 trust boundary 按对象类型不同。
- plugin manifest 解决的是 bundle-level distribution 与 install-time trust，而不是取代本地 `.claude/*` 的高信任配置面。
- plugin agent 故意忽略 `permissionMode`、`hooks`、`mcpServers`，表明团队刻意把 plugin 内部单体升权和 manifest 级安装批准分开。

证据:

- `claude-code-source-code/src/utils/frontmatterParser.ts:10-232`
- `claude-code-source-code/src/utils/markdownConfigLoader.ts:28-360`
- `claude-code-source-code/src/skills/loadSkillsDir.ts:185-315`
- `claude-code-source-code/src/tools/AgentTool/loadAgentsDir.ts:541-748`
- `claude-code-source-code/src/utils/plugins/schemas.ts:429-898`
- `claude-code-source-code/src/utils/plugins/loadPluginCommands.ts:218-340`
- `claude-code-source-code/src/utils/plugins/loadPluginAgents.ts:153-168`

### H. Permission chain 与 auto mode

- 权限系统必须按“初始 mode 决议 -> context 装配 -> rule/tool check -> mode 覆写 -> classifier/hooks/headless fallback”理解，不能只看 permission dialog。
- auto mode 的安全性并不只来自 classifier，还来自进入 auto 前对危险 allow rule 的 strip，以及 classifier 前的多层 fast-path / bypass-immune safety check。
- `verifyAutoModeGateAccess(...)` 返回 transform function 而不是静态 context，说明作者明确在处理 gate 异步校验与用户中途切 mode 的竞争问题。

证据:

- `claude-code-source-code/src/utils/permissions/PermissionMode.ts:42-140`
- `claude-code-source-code/src/utils/permissions/permissionSetup.ts:510-645`
- `claude-code-source-code/src/utils/permissions/permissionSetup.ts:689-1033`
- `claude-code-source-code/src/utils/permissions/permissionSetup.ts:1078-1158`
- `claude-code-source-code/src/utils/permissions/permissions.ts:473-1471`

### I. SDK host surface is event stream, not answer stream

- `SDKMessageSchema` 的公共面已经覆盖 user / assistant / `stream_event`、result、system、hook / tool / auth、task / persistence、rate-limit / elicitation / suggestion 等多类消息。
- `system:init` 暴露的不是欢迎文本，而是 runtime 装配态快照。
- 对宿主来说，Claude Code SDK 的价值不只是“拿到模型回复”，而是“接入运行中的事件脉搏、状态变化与执行摘要”。

证据:

- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1290-1302`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1347-1455`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1457-1602`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1604-1779`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1794-1880`

### J. Claude API stream is recoverable execution trajectory

- `query.ts` 在调模型前准备的是工作集、工具、权限、budget、MCP readiness 等执行上下文，而不是裸消息数组。
- 流式解析阶段必须处理 `message_start -> content_block_* -> message_delta -> message_stop`，并在 `message_delta` 上对已 yield 的 assistant message 做原地 mutation，才能保持 transcript 引用一致性。
- streaming fallback、missing tool result repair、reactive compact、max output recovery 共同维护的是“可恢复执行轨迹”，而不是单纯的文本续写。

证据:

- `claude-code-source-code/src/query.ts:123-179`
- `claude-code-source-code/src/query.ts:650-930`
- `claude-code-source-code/src/query.ts:980-1265`
- `claude-code-source-code/src/query.ts:1368-1728`
- `claude-code-source-code/src/services/api/claude.ts:588-673`
- `claude-code-source-code/src/services/api/claude.ts:1270-1335`
- `claude-code-source-code/src/services/api/claude.ts:1979-2365`
- `claude-code-source-code/src/services/api/claude.ts:2366-2475`
- `claude-code-source-code/src/services/api/claude.ts:2560-2825`
- `claude-code-source-code/src/services/api/claude.ts:2924-3025`

### K. MCP is a governed connection plane

- MCP 至少要按 config scope、transport、connection state、control surface 四层理解。
- `needs-auth`、`pending`、`disabled`、`failed`、`connected` 说明它不是一个简单 connect / fail 布尔量。
- plugin MCP 通过动态 scope、名称重写与环境变量分层解析，进一步说明这是受治理的连接平面，而不是“manifest 里顺手带几个 server”。

证据:

- `claude-code-source-code/src/services/mcp/types.ts:10-257`
- `claude-code-source-code/src/services/mcp/config.ts:1253-1569`
- `claude-code-source-code/src/services/mcp/client.ts:340-421`
- `claude-code-source-code/src/services/mcp/client.ts:595-1128`
- `claude-code-source-code/src/services/mcp/client.ts:1216-1402`
- `claude-code-source-code/src/services/mcp/useManageMCPConnections.ts:333-450`
- `claude-code-source-code/src/services/mcp/useManageMCPConnections.ts:765-1128`
- `claude-code-source-code/src/utils/plugins/mcpPluginIntegration.ts:341-620`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:157-173`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:374-452`

### L. Claude Code is host-integrated runtime, not terminal shell

- `StructuredIO` 的职责不是“把 stdin/stdout 包一层”，而是维持 request correlation、cancel、duplicate/orphan 防护、permission race 与 schema-validated control flow。
- `RemoteIO` 没有发明一套 remote-only protocol，而是在 `StructuredIO` 之上扩 transport、token refresh、CCR v2 internal events、bridge-only keepalive。
- direct connect 与 `RemoteSessionManager` 都复用了同一控制语义，但当前支持面明显窄于完整 `StructuredIO`：它们更接近宿主适配器，而不是完整 CLI worker control plane。

证据:

- `claude-code-source-code/src/cli/print.ts:587-620`
- `claude-code-source-code/src/cli/print.ts:1021-1048`
- `claude-code-source-code/src/cli/print.ts:5199-5232`
- `claude-code-source-code/src/cli/structuredIO.ts:135-162`
- `claude-code-source-code/src/cli/structuredIO.ts:275-429`
- `claude-code-source-code/src/cli/structuredIO.ts:470-773`
- `claude-code-source-code/src/cli/remoteIO.ts:35-240`
- `claude-code-source-code/src/server/directConnectManager.ts:40-210`
- `claude-code-source-code/src/remote/RemoteSessionManager.ts:87-323`
- `claude-code-source-code/src/remote/SessionsWebSocket.ts:74-403`

### M. Protocol superset is not the same as adapter subset

- `controlSchemas.ts` 给出的是完整协议全集，但 bridge、direct connect、`RemoteSessionManager` 当前实现的是不同宽度的子集。
- bridge 当前显式处理中等宽度的 inbound control request：`initialize`、`set_model`、`set_max_thinking_tokens`、`set_permission_mode`、`interrupt`，并单独为 `can_use_tool` 构建 permission callback 面。
- direct connect 与 `RemoteSessionManager` 当前更窄，主要围绕 `can_use_tool` 与 `interrupt`，不能把它们直接写成完整 SDK host。
- `handleIngressMessage(...)` 只把 `control_response`、`control_request` 和 `user` inbound message 单独分流，也说明 bridge 不是“把所有 SDKMessage 原样搬进 REPL”。

证据:

- `claude-code-source-code/src/bridge/bridgeMessaging.ts:126-208`
- `claude-code-source-code/src/bridge/bridgeMessaging.ts:243-391`
- `claude-code-source-code/src/bridge/replBridge.ts:1190-1235`
- `claude-code-source-code/src/bridge/replBridge.ts:1528-1819`
- `claude-code-source-code/src/bridge/remoteBridgeCore.ts:422-456`
- `claude-code-source-code/src/bridge/remoteBridgeCore.ts:824-878`
- `claude-code-source-code/src/hooks/useReplBridge.tsx:367-586`
- `claude-code-source-code/src/server/directConnectManager.ts:81-200`
- `claude-code-source-code/src/remote/RemoteSessionManager.ts:153-297`

### N. Explicit failure matters as much as success path

- bridge、direct connect、`RemoteSessionManager` 都不把 unknown control subtype 静默吞掉，而是显式回 error，避免 server 因等待 reply 而挂死连接。
- outbound-only bridge 对 mutable request 也显式回 error，避免“看起来成功但本地没生效”的假成功错觉。
- `StructuredIO` 把 abort、cancel、duplicate/orphan 防护都做成显式协议动作或显式 reject，而不是依赖宿主自己猜测请求是否还有效。

### O. `query.ts` is a turn runtime kernel, not a thin model loop

- `query.ts` 维护的是 `State + while(true) + continue sites + terminal reasons` 的 turn runtime。
- `continue` 不是简单 retry，而是“同一次 `query()` 调用内替换下一轮状态”的 self-loop。
- tool follow-up、recovery、stop hook blocking、token budget continuation 都被统一规约成内部 continue。
- transcript / resume 不是 query 之外的附属日志，而是 turn runtime 的恢复契约。

证据：

- `claude-code-source-code/src/query.ts:203-235`
- `claude-code-source-code/src/query.ts:365-540`
- `claude-code-source-code/src/query.ts:652-950`
- `claude-code-source-code/src/query.ts:1065-1305`
- `claude-code-source-code/src/query.ts:1363-1714`
- `claude-code-source-code/src/utils/QueryGuard.ts:1-99`
- `claude-code-source-code/src/utils/conversationRecovery.ts:159-273`
- `claude-code-source-code/src/utils/sessionRestore.ts:409-545`

### P. Permission system is a typed decision engine, not a modal UX

- 权限链必须按 `typed model -> context/materialization -> rule/tool engine -> mode transform -> automation -> relay/renderer -> hard enforcement` 理解。
- permission modal 只是 `ask` 分支的 renderer，不是安全本体。
- 同一个 `ask` 可以由本地 UI、SDK host、bridge/channel、swarm leader、permission prompt tool 共同消费。
- sandbox、workspace trust、managed policy、MCP approval/auth 是正交的硬边界。

证据：

- `claude-code-source-code/src/utils/permissions/permissionSetup.ts:510-645`
- `claude-code-source-code/src/utils/permissions/permissionSetup.ts:689-1033`
- `claude-code-source-code/src/utils/permissions/permissions.ts:1061-1312`
- `claude-code-source-code/src/services/tools/toolHooks.ts:332-417`
- `claude-code-source-code/src/hooks/toolPermission/handlers/interactiveHandler.ts:43-236`
- `claude-code-source-code/src/cli/structuredIO.ts:534-653`
- `claude-code-source-code/src/cli/print.ts:4146-4340`
- `claude-code-source-code/src/utils/sandbox/sandbox-adapter.ts:172-260`

### Q. Host truth is tri-surface: event stream, snapshot, recovery

- 宿主真相至少分成三层：`SDKMessage` 时间线、`worker_status/external_metadata` 快照、transcript/internal-events 恢复面。
- `request_id`、`tool_use_id`、`uuid`、`session_id`、`parentUuid` 是跨平面的关键主键。
- `control_request / control_response / control_cancel_request` 才是宿主命令闭环。
- `worker_status` 与 `session_state_changed` 比 `system:status` 更接近 authoritative running/idle 真相。

### R. Claude Code repeatedly builds authoritative surfaces, not scattered semi-truths

- `onChangeAppState(...)` 说明 mode sync 的成熟修法不是补更多 mutation callsite，而是把外部可见 mode 真相统一收口到一个 state diff choke point。
- `getAllBaseTools()`、`assembleToolPool(...)`、`mergeAndFilterTools(...)` 说明工具真相至少分成“基础全集”“运行时组合”“多路径共享组合逻辑”三层权威面，而且 capability、policy、prompt-cache 稳定性三者共用同一入口。
- `coreSchemas.ts` 与 `sandboxTypes.ts` 说明 SDK 类型、runtime 校验、settings schema 被刻意设计成共源，而不是 IDE 类型和 runtime shape 各写各的。
- `sessionStorage.ts` 对 `sessionProjectDir`、subagent transcript path、`currentSessionWorktree` tri-state 的处理说明恢复系统最怕 split-brain，路径和 worktree 真相不能由 hooks / resume / cwd 各自推导。
- `pluginPolicy.ts` 说明权威真相面最好同时是 leaf module，这样 single source of truth 不会再次被依赖图污染成多处半真相。
- 更抽象地说，Claude Code 正在把“名词真相”推进到 schema / pure leaf，把“动词真相”推进到 chokepoint / state machine。

证据:

- `claude-code-source-code/src/state/onChangeAppState.ts:43-92`
- `claude-code-source-code/src/utils/sessionState.ts:27-146`
- `claude-code-source-code/src/tools.ts:188-367`
- `claude-code-source-code/src/utils/toolPool.ts:20-79`
- `claude-code-source-code/src/utils/api.ts:119-259`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1-8`
- `claude-code-source-code/src/entrypoints/sandboxTypes.ts:1-6`
- `claude-code-source-code/src/utils/sessionStorage.ts:203-258`
- `claude-code-source-code/src/utils/sessionStorage.ts:533-822`
- `claude-code-source-code/src/utils/plugins/pluginPolicy.ts:1-20`

### S. Claude Code prefers object escalation over endless continuation

- `compact` 主要吸收的是上下文压力，不是协作压力；`ContextSuggestions` 已经在用 token / read / memory / autocompact 信号区分这些上下文类问题。
- `TaskCreateTool` 明确把“3 步以上、non-trivial、需要跟踪”的工作推进到 task object，说明复杂任务的正式承载体是 lifecycle object，不是继续聊天。
- `checkTokenBudget(...)` 在接近阈值或出现 diminishing returns 时停止 continue，这意味着 token budget 不只是省 token 逻辑，也是对象升级信号。
- `EnterWorktreeTool` 与 `createWorktreeForSession(...)` 说明 worktree 是独立 cwd / branch / resume state 的强隔离对象，不是 branch 语法糖；但产品暴露仍然要求用户显式提出 worktree。
- `sessionStorage.ts` 对 subagent transcript、worktree-state 的持久化说明 session 的职责是恢复多对象宇宙，而不是只保存一串聊天历史。

证据:

- `claude-code-source-code/src/query/tokenBudget.ts:1-75`
- `claude-code-source-code/src/utils/analyzeContext.ts:1000-1098`
- `claude-code-source-code/src/utils/contextSuggestions.ts:31-233`
- `claude-code-source-code/src/Task.ts:6-121`
- `claude-code-source-code/src/utils/task/framework.ts:31-117`
- `claude-code-source-code/src/tools/TaskCreateTool/prompt.ts:7-49`
- `claude-code-source-code/src/tools/EnterWorktreeTool/prompt.ts:1-36`
- `claude-code-source-code/src/tools/EnterWorktreeTool/EnterWorktreeTool.ts:68-116`
- `claude-code-source-code/src/utils/worktree.ts:702-770`
- `claude-code-source-code/src/utils/sessionStorage.ts:247-285`
- `claude-code-source-code/src/utils/sessionStorage.ts:804-822`
- `claude-code-source-code/src/utils/sessionStorage.ts:2884-2917`

### T. Prompt magic keeps descending into an explainable stability system

- `promptCacheBreakDetection` 不是简单“缓存断点统计”，而是 pre-call snapshot + post-call token verification 的两阶段诊断器：先记录所有可能影响 server-side cache key 的客户端状态，再用真实 `cache_read_input_tokens` 下降验证 break 是否真的发生。
- 它追踪的不只 system prompt 文本，还包括 tools hash、per-tool schema hash、cache_control、globalCacheStrategy、betas、effort、extraBody 等，说明 Claude Code 把 prompt 看成整条 request surface，而不是一段文案。
- `claude.ts` 显式把 defer-loading tools 排除出 cache detection，因为这些工具不会真正进入 API prompt；这说明作者关心的是“实际发给模型的稳定性对象”，不是本地代码里潜在可见的对象。
- `notifyCacheDeletion(...)`、`notifyCompaction(...)` 与 TTL / server-side 分流说明系统已经把“预期下降”“TTL 过期”“疑似服务端逐出”从真正 client-side break 中分离出来，prompt 失稳不再被一概写成本地 prompt 问题。
- 更抽象地说，Claude Code 的 prompt 魔力正在从“共享前缀资产”继续升级成“可解释稳定性系统”：不仅能复用前缀，还能解释前缀为什么稳定、为什么失稳。

证据:

- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:28-119`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:220-433`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:437-706`
- `claude-code-source-code/src/services/api/claude.ts:1457-1486`
- `claude-code-source-code/src/services/api/claude.ts:2380-2391`
- `claude-code-source-code/src/utils/toolPool.ts:55-71`
- `claude-code-source-code/src/tools.ts:329-367`
- `claude-code-source-code/src/query/stopHooks.ts:92-99`

### U. QueryGuard turns local query state into a synchronous control plane

- `QueryGuard` 不是 loading helper，而是三态 `idle / dispatching / running` 的同步状态机，并通过 `useSyncExternalStore` 暴露给 REPL，作者已明确把它定义为 local query in flight 的 single source of truth。
- `dispatching` 这个中间态专门治理“队列刚出队、异步链还没到 onQuery”这段空窗；如果没有它，queue processor 和 submit path 都会在同一个异步 gap 里把系统误认成 idle。
- `handlePromptSubmit` 会在 `processUserInput(...)` 前先 `reserve()`，说明系统要求“先占住运行权，再开始 await 链”，而不是等真正 query 启动后再补 loading state。
- `tryStart()` / `end(generation)` / `forceEnd()` 把 stale finally、cancel-resubmit race 做成显式代际裁决，说明作者已经把 finally 视为潜在 stale writer，而不是天然可信的 cleanup path。
- `useQueueProcessor` 不再拥有自己的 reservation/finally，而是完全订阅 `queryGuard`；这说明本地查询 authority 已经升级成一个局部控制协议，而不只是 util 类。

证据:

- `claude-code-source-code/src/utils/QueryGuard.ts:1-104`
- `claude-code-source-code/src/screens/REPL.tsx:897-918`
- `claude-code-source-code/src/screens/REPL.tsx:2113-2135`
- `claude-code-source-code/src/screens/REPL.tsx:2866-2928`
- `claude-code-source-code/src/utils/handlePromptSubmit.ts:426-607`
- `claude-code-source-code/src/hooks/useQueueProcessor.ts:1-59`

### V. Remote failure is a layered semantics system, not “disconnect and reconnect”

- `SessionsWebSocket` 已经把 close code 分成 permanent close、session-not-found limited retry、一般 reconnect 三类；这说明连接层失败不是单一布尔值，而是预算化分级。
- `remoteBridgeCore` 把 `401` 做成 transport-semantic change：必须 refresh OAuth、重新取 remote credentials、rebuild transport、切换 epoch，而不是只换 token 继续。
- `authRecoveryInFlight` 期间主动 drop `control_request/response/cancel/result`，说明系统宁可显式丢弃，也不接受陈旧 transport 上制造“好像发出去了”的假成功。
- `replBridge` 在 transport permanent close 后进一步尝试 env reconnect，说明 close code 之外还有“环境级恢复”一层；`envLessBridgeConfig` 则把 connect/archive/http/heartbeat 等超时预算显式制度化。
- `initReplBridge` 在 preflight 阶段主动避免 expired-and-unrefreshable token 继续发请求，说明失败语义还包括 fail-closed 的 guaranteed-fail path 消毒，而不是只覆盖 post-close recovery。

证据:

- `claude-code-source-code/src/remote/SessionsWebSocket.ts:21-36`
- `claude-code-source-code/src/remote/SessionsWebSocket.ts:234-299`
- `claude-code-source-code/src/bridge/remoteBridgeCore.ts:456-588`
- `claude-code-source-code/src/bridge/remoteBridgeCore.ts:824-878`
- `claude-code-source-code/src/bridge/replBridge.ts:887-965`
- `claude-code-source-code/src/bridge/initReplBridge.ts:192-215`
- `claude-code-source-code/src/cli/transports/WebSocketTransport.ts:38-58`
- `claude-code-source-code/src/bridge/envLessBridgeConfig.ts:13-33`

### W. Plugin runtime truth and editable truth must stay separate

- `checkEnabledPlugins()` 明确是 authoritative enabled check，因为它基于 merged settings 处理 policy > local > project > user，再把 `--add-dir` 作为更低优先级来源合并；这意味着“当前是否启用”不是某个单一 scope 的布尔值。
- `getPluginEditableScopes()` 则显式声明自己不是 authoritative enabled check，它解决的是“如果用户要写回，哪个 user-editable scope 拥有这个插件”；说明 editable truth 和 runtime truth 不是同一层。
- `pluginPolicy.ts` 把 policy-blocked plugin 作为 leaf single source of truth，避免安装、启用、UI 过滤各处各写一套企业策略判断。
- 真正的 startup 总控链路并不在 `pluginStartupCheck.ts`，而在 `REPL.tsx -> performStartupChecks -> PluginInstallationManager -> reconciler -> refresh`；`pluginStartupCheck.ts` 更像 enable/scope 计算辅助模块，而不是启动总控。
- `installedPluginsManager.ts` 明确把 installation state 与 enablement state 分离：安装是全局资产面，scope/enablement 仍以 settings.json 为 source of truth；同时 `installed_plugins.json` 只是 persistent metadata，不等于 live session state。loader 的 cache-on-miss materialization 也不自动回写安装记录。
- policy 也不是单轴：除了插件级 block，还有 marketplace source 级策略限制；“插件被禁”与“来源被禁”不是同一个问题。

证据:

- `claude-code-source-code/src/utils/plugins/pluginPolicy.ts:1-20`
- `claude-code-source-code/src/utils/plugins/pluginStartupCheck.ts:30-71`
- `claude-code-source-code/src/utils/plugins/pluginStartupCheck.ts:75-159`
- `claude-code-source-code/src/utils/plugins/performStartupChecks.tsx:24-61`
- `claude-code-source-code/src/services/plugins/PluginInstallationManager.ts:51-90`
- `claude-code-source-code/src/utils/plugins/pluginIdentifier.ts:98-117`
- `claude-code-source-code/src/utils/plugins/installedPluginsManager.ts:4-12`
- `claude-code-source-code/src/utils/plugins/installedPluginsManager.ts:488-537`
- `claude-code-source-code/src/utils/plugins/installedPluginsManager.ts:1033-1164`
- `claude-code-source-code/src/utils/plugins/marketplaceHelpers.ts:472-520`

### X. Unified first principle, multiple budget implementations

- `policySettings` 在 `settings.ts` 里采用 first-source-wins（remote > HKLM/plist > file/drop-ins > HKCU），这说明它更像高阶控制平面，而不是普通 merge source。
- `sandboxTypes` 主要承担策略契约角色，而 `sandbox-adapter` 继续把 `allowManagedDomainsOnly`、`allowManagedReadPathsOnly`、`failIfUnavailable`、`allowUnsandboxedCommands` 等写成运行时硬执行；schema 不是终点，adapter enforcement 才是边界完成点。
- 安全模型是明显不对称的：危险 remote managed settings 触发 blocking dialog；`forceLoginOrgUUID` fail-closed；`--dangerously-skip-permissions` 只在隔离且无公网时放行。这说明治理和安全不是“越严越好”，而是在不同风险面做不同 fail-open / fail-closed 策略。
- Claude Code 实际上不是一个总预算器，而是至少三套：工具结果对象/消息级预算、上下文 headroom/autocompact 预算、turn continuation/token target 预算。它们治理的对象和阶段不同，但共同服务于“限制无序扩张”的同一原则。
- “省 token”最先发生在工具结果外置与聚合替换，不在 summarize 历史；`applyToolResultBudget()` 运行在 `microcompact` / `autocompact` 之前，就是这条顺序的最强证据。

证据:

- `claude-code-source-code/src/utils/settings/settings.ts:74-110`
- `claude-code-source-code/src/utils/settings/settings.ts:319-343`
- `claude-code-source-code/src/utils/settings/settings.ts:645-689`
- `claude-code-source-code/src/entrypoints/sandboxTypes.ts:1-133`
- `claude-code-source-code/src/utils/sandbox/sandbox-adapter.ts:152-235`
- `claude-code-source-code/src/utils/sandbox/sandbox-adapter.ts:475-560`
- `claude-code-source-code/src/utils/sandbox/sandbox-adapter.ts:720-752`
- `claude-code-source-code/src/services/remoteManagedSettings/securityCheck.tsx:1-69`
- `claude-code-source-code/src/components/ManagedSettingsSecurityDialog/utils.ts:20-87`
- `claude-code-source-code/src/utils/managedEnvConstants.ts:75-125`
- `claude-code-source-code/src/utils/auth.ts:1914-1955`
- `claude-code-source-code/src/setup.ts:400-439`
- `claude-code-source-code/src/services/tools/toolExecution.ts:1403-1458`
- `claude-code-source-code/src/utils/toolResultStorage.ts:272-357`
- `claude-code-source-code/src/utils/toolResultStorage.ts:575-924`
- `claude-code-source-code/src/query.ts:369-383`
- `claude-code-source-code/src/services/compact/autoCompact.ts:33-140`
- `claude-code-source-code/src/query/tokenBudget.ts:1-75`

证据：

- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:57-519`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:578-612`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1457-1779`
- `claude-code-source-code/src/utils/sessionState.ts:1-149`
- `claude-code-source-code/src/cli/structuredIO.ts:469-773`
- `claude-code-source-code/src/cli/transports/WorkerStateUploader.ts:1-118`
- `claude-code-source-code/src/utils/sessionStorage.ts:1307-1637`
- `claude-code-source-code/src/utils/sessionRestore.ts:99-177`

### R. `services` are subsystem planes; `utils` are invariant kernels

- `services/` 更像执行、连接、记忆、治理、观测五个长生命周期子平面。
- `utils-heavy` 的关键不在 helper 多，而在 shared invariant 多：cache-key prefix、tool ordering、fork contract、session truth 都是跨域基础设施。
- 真正的工程债务主要是热点文件过大，而不是 `services` / `utils` 边界崩坏。

证据：

- `claude-code-source-code/src/services/tools/toolExecution.ts:1-260`
- `claude-code-source-code/src/services/tools/toolOrchestration.ts:19-132`
- `claude-code-source-code/src/services/mcp/useManageMCPConnections.ts:143-450`
- `claude-code-source-code/src/services/SessionMemory/sessionMemory.ts:134-387`
- `claude-code-source-code/src/utils/queryContext.ts:30-41`
- `claude-code-source-code/src/utils/toolPool.ts:43-73`
- `claude-code-source-code/src/utils/forkedAgent.ts:46-110`
- `claude-code-source-code/src/utils/markdownConfigLoader.ts:1-240`

### S. Multi-agent prompt quality comes from runtime contract, not wording tricks

- coordinator、fresh subagent、fork、team/swarm、workflow 需要分开写，不能都叫“subagent prompt”。
- worker prompt 必须自包含，因为 worker 看不到主线程对话。
- team/swarm 的关键是 team context、mailbox、task list、名字寻址与 leader 审批，而不是普通 prompt 复述。
- Prompt 模板最可靠的来源是源码里的角色合同：`coordinatorMode.ts`、`AgentTool/prompt.ts`、`TeamCreateTool/prompt.ts`、`messages.ts`。

证据：

- `claude-code-source-code/src/coordinator/coordinatorMode.ts:111-260`
- `claude-code-source-code/src/tools/AgentTool/prompt.ts:48-112`
- `claude-code-source-code/src/tools/TeamCreateTool/prompt.ts:37-166`
- `claude-code-source-code/src/utils/messages.ts:3457-3490`
- `claude-code-source-code/src/utils/swarm/inProcessRunner.ts:871-1043`

### T. Recovery is a multi-surface persistence system, not transcript replay

- Claude Code 的恢复链至少分成主 transcript、sidechain transcript、task output、state restore 四层。
- `TaskOutput` 负责长输出与进度观察，不等于 transcript。
- `loadConversationForResume(...)` 与 `restoreSessionStateFromLog(...)` 做的是 runtime re-materialization，而不是只读回消息。
- v1 ingress、v2 internal-events、本地 JSONL 最终都服务同一恢复面。

证据：

- `claude-code-source-code/src/utils/sessionStorage.ts:1451-1545`
- `claude-code-source-code/src/utils/conversationRecovery.ts:456-541`
- `claude-code-source-code/src/utils/sessionRestore.ts:99-147`
- `claude-code-source-code/src/tasks/LocalMainSessionTask.ts:358-416`
- `claude-code-source-code/src/utils/task/TaskOutput.ts:32-110`
- `claude-code-source-code/src/utils/task/TaskOutput.ts:257-388`
- `claude-code-source-code/src/cli/transports/ccrClient.ts:789-854`

### U. Capability atlas now requires object truth, not just plane truth

- “全部功能和 API”不能只按能力平面写，还必须继续补命令 truth、工具 truth、任务 truth、服务 truth、宿主 truth 五张对象表。
- `TaskType` 与 `getAllTasks()` 的差异说明 task model truth 与 task registry truth 必须分开写。
- `constants/tools.ts` 说明 async agent、in-process teammate、coordinator 拥有不同的工具子集 truth，不能把“系统支持某工具”写成单层判断。
- `src/services/` 的约 `20` 个一级子域说明能力大量沉在 subsystem planes 里，而不只长在 commands/tools 上。

证据：

- `claude-code-source-code/src/Task.ts:6-124`
- `claude-code-source-code/src/tasks.ts:1-39`
- `claude-code-source-code/src/constants/tools.ts:36-112`
- `claude-code-source-code/src/tools.ts:193-250`
- `claude-code-source-code/src/services/`

### V. Governance APIs are formal control planes, not misc helpers

- channels、`get_context_usage`、`get_settings` / `apply_flag_settings` 应一起写成治理型 API。
- channels 体现外部输入治理；context usage 体现上下文预算治理；settings 则体现配置真相与运行态治理。
- 这三条 API 共同说明 Claude Code 不只开放“让你做事”的接口，也开放“让你约束 runtime”的接口。

证据：

- `claude-code-source-code/src/services/mcp/channelNotification.ts:1-280`
- `claude-code-source-code/src/utils/messages.ts:5496-5507`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:175-288`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:467-507`

### W. Prompt magic, unified budgeter, and source quality are now explicit philosophy axes

- Prompt 魔力更准确的结构应写成“角色合同 + 工具边界 + 缓存结构 + 状态反馈 + 协作语法”。
- 安全、成本与体验必须共用预算器，因为它们分别约束动作空间、上下文空间与认知噪音。
- 源码质量不能只写成卫生层评价，而应写成 contract、失败语义、恢复路径和共享基础设施如何直接决定产品能力。

证据：

- `claude-code-source-code/src/utils/systemPrompt.ts:29-123`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:24-260`
- `claude-code-source-code/src/utils/permissions/permissionSetup.ts:510-645`
- `claude-code-source-code/src/query/tokenBudget.ts:45-92`
- `claude-code-source-code/src/query.ts:369-540`
- `claude-code-source-code/src/query.ts:1065-1247`

### U. REPL front-end is a cognitive control plane, not a chat shell

- transcript mode 不是历史视图，而是 pager/runtime。
- sticky prompt、search、message actions、teammate view、queued commands 共同组成前台状态机。
- 前台主语切换与锚点保持，是长会话和多 Agent 可用性的核心部分。

证据：

- `claude-code-source-code/src/screens/REPL.tsx:4183-4595`
- `claude-code-source-code/src/components/Messages.tsx:229-320`
- `claude-code-source-code/src/components/FullscreenLayout.tsx:1-120`
- `claude-code-source-code/src/components/VirtualMessageList.tsx:43-99`
- `claude-code-source-code/src/components/VirtualMessageList.tsx:289-767`
- `claude-code-source-code/src/components/messageActions.tsx:1-176`

### V. Product reality is shaped by migration layers and consumer subsets

- Claude Code 的能力边界至少要按 build-time gate、runtime gate、compat shim、consumer subset 四层理解。
- marketplace、plugin manifest、MCPB、LSP、channels 都属于扩展/产品边界，但不处于同一成熟度和同一职责层。
- schema 存在、安装流存在、adapter 消费存在，不等于同一条产品能力链已经完整打通。

证据：

- `claude-code-source-code/src/entrypoints/cli.tsx:18-26`
- `claude-code-source-code/src/bridge/bridgeEnabled.ts:120-202`
- `claude-code-source-code/src/services/mcp/channelNotification.ts:1-220`
- `claude-code-source-code/src/services/mcp/channelAllowlist.ts:1-67`
- `claude-code-source-code/src/utils/plugins/marketplaceManager.ts:1-169`
- `claude-code-source-code/src/utils/plugins/schemas.ts:1-180`
- `claude-code-source-code/src/utils/plugins/mcpbHandler.ts:1-220`
- `claude-code-source-code/src/services/lsp/manager.ts:1-180`

证据:

- `claude-code-source-code/src/cli/structuredIO.ts:362-429`

### O. 风控、账号治理与封号技术

- 客户端源码没有暴露一个单点“ban user”逻辑；更可信的结构是身份鉴权、账号资格、组织策略、远程设置、遥测 targeting 与本地执行边界的组合治理。
- `policyLimits` 和 `remoteManagedSettings` 都是服务端下发的控制面，具备缓存、轮询、热更新和 fail-open/stale-cache 退化路径，说明客户端是治理执行端，不是唯一决策端。
- telemetry 与 GrowthBook 明确绑定用户、会话、设备、组织、订阅、rate limit tier 等属性，说明平台具备按账号与组织维度分流能力和观测行为的基础设施。
- Auto mode、sandbox、workspace trust、trusted device 解决的是动作级或设备级安全边界，不应直接等同于账号封禁；其中 bridge trusted device 明确属于 elevated auth enforcement。
- `forceLoginOrg` 使用服务端 profile 作为组织权威来源并明确 fail-closed，说明组织绑定属于硬边界，不信任本地可写缓存。
- managed settings 对危险 shell settings、非安全 env vars 和 hooks 的变更会触发阻塞确认或直接退出，说明远程下发不仅是配置同步，也是受审查的治理命令通道。
- 从合规使用角度，最能降低误伤和能力撤回风险的不是“规避风控”，而是保持身份源、组织归属、设备和网络环境的可解释一致性，并准备完整支持证据。
- 从技术先进性角度，这套系统的核心不在单个检测器，而在“身份连续性维护 + 远程策略下发 + 本地动作收口 + 高安全会话 + 观测闭环”的分层组合。
- bridge / REPL 相关逻辑明确把 401 风暴、跨进程 backoff、连续失败上限当成一等问题，说明“抑制失败扩散”本身也是风控设计的一部分。
- `403 insufficient_scope` 在 MCP OAuth 里被显式识别为 step-up auth，而不是普通 refresh 失败，说明作者非常清楚地区分“身份失效”和“授权范围不足”。
- rate limit / extra usage exhausted 属于计费与消耗层，而 `not enabled for your account` 更接近 entitlement/rollout；它们都不应被粗暴归类为“封号”。
- 从更高抽象看，Claude Code 的治理闭环至少包含“识别主体 -> 观测主体 -> 判定资格 -> 下发边界 -> 阻断/放行动作 -> 失败与恢复”六段时序，研究风控不能只盯某个点。
- 系统在 failure semantics 上采取明显的 selective fail-open / fail-closed 哲学：资格缓存与普通配置同步更偏向减少误伤，而组织边界、危险变更、高安全远程能力与复杂解析路径更偏向强收口。
- 对用户保护最有价值的不是“继续试错”，而是先识别错误语义、冻结变量、保留证据，再按身份/资格/组织/本地执行/高安全会话这几个层级选择支持路径。
- 图解层面的抽象已经稳定：Remote Control 的成立至少经历“订阅 -> 组织画像 -> entitlement gate -> 组织 policy -> trust / trusted device / env register”这条链，而误伤处置也可以稳定压缩成“识别语义 -> 冻结变量 -> 证据保全 -> 分层支持路径”。
- 平台正义视角下，这套系统最值得继续追问的不是“它能不能挡住风险”，而是“它能否把资格缺失、组织治理、动作阻断与真正处罚清楚地区分给用户”，以及“高波动环境用户是否承担了过高的解释成本”。
- 更细的 bridge / trusted device / 401 recovery 时序已经足以说明：高安全远程会话不是普通请求恢复逻辑的延长，而是“身份恢复 -> 凭证重取 -> transport 重建 -> cleanup/backoff”的独立系统。
- 一页式速查卡已经可以稳定给出：不同错误语义对应不同治理层、不同用户动作和不同支持路径；这对减少用户把所有问题误读成“封号”非常重要。
- 这套系统已经可以被提炼成一组可迁移的 agent 治理法则：主体连续性优先、资格与处罚分离、组织治理独立、高安全远程会话独立建模、本地动作治理前置、策略数据化、selective failure semantics、step-up auth 与 token expiry 分离、失败风暴治理、解释层与支持路径一体化。
- 单页总纲已经稳定形成：主体层、资格层、组织层、观测层、动作层、高安全会话层、计费层、哲学层和用户处置层，可以作为后续所有风险研究的统一骨架。
- 更稳妥的“高封号率中国用户”技术表述不是平台一定针对，而是高波动网络、身份路径分裂、设备/网络切换、组织与权益错配更容易把多层连续性问题压缩成“像被封了”的单一体感。
- 给平台方最有价值的改进建议集中在：更细 reason code、结构化诊断包、高安全远程链路状态可视化、资格与处罚语义分离、以及面向高波动环境用户的低成本恢复路径。
- 风控研究已经可以稳定沉淀成一张源码地图：身份与组织、资格与订阅、组织策略与远程下发、遥测与实验开关、本地动作治理、高安全远程会话、连接认证子系统、解释层与支持层这八组入口。
- 典型案例推演已经足够说明：401、not enabled、policy denied、needs-auth、rate limit 这五类“像被封了”的体感，背后实际上对应不同治理层和完全不同的处理顺序。

证据:

- `claude-code-source-code/src/utils/auth.ts:83-149`
- `claude-code-source-code/src/utils/auth.ts:1360-1561`
- `claude-code-source-code/src/utils/auth.ts:1923-2000`
- `claude-code-source-code/src/entrypoints/cli.tsx:132-159`
- `claude-code-source-code/src/services/policyLimits/index.ts:167-210`
- `claude-code-source-code/src/services/policyLimits/index.ts:505-526`
- `claude-code-source-code/src/services/remoteManagedSettings/index.ts:410-555`
- `claude-code-source-code/src/services/remoteManagedSettings/securityCheck.tsx:22-72`
- `claude-code-source-code/src/components/ManagedSettingsSecurityDialog/utils.ts:24-117`
- `claude-code-source-code/src/utils/managedEnv.ts:93-177`
- `claude-code-source-code/src/utils/user.ts:34-135`
- `claude-code-source-code/src/utils/telemetryAttributes.ts:29-70`
- `claude-code-source-code/src/services/analytics/growthbook.ts:29-47`
- `claude-code-source-code/src/components/AutoModeOptInDialog.tsx:9-10`
- `claude-code-source-code/src/bridge/trustedDevice.ts:15-33`
- `claude-code-source-code/src/bridge/bridgeMain.ts:198-269`
- `claude-code-source-code/src/bridge/initReplBridge.ts:189-220`
- `claude-code-source-code/src/hooks/useReplBridge.tsx:31-40`
- `claude-code-source-code/src/bridge/bridgeEnabled.ts:17-87`
- `claude-code-source-code/src/cli/structuredIO.ts:490-504`
- `claude-code-source-code/src/bridge/bridgeMessaging.ts:265-283`
- `claude-code-source-code/src/bridge/bridgeMessaging.ts:373-390`
- `claude-code-source-code/src/server/directConnectManager.ts:88-98`
- `claude-code-source-code/src/remote/RemoteSessionManager.ts:199-213`
- `claude-code-source-code/src/services/mcp/client.ts:335-370`

### V. 判定非对称性矩阵与边界成本函数

- GrowthBook 安全限制 gate 和 entitlement gate 的缓存语义并不一致，说明平台明确区分“安全限制不能轻放”和“资格误伤要尽量减少”这两类成本函数。
- `isRemoteManagedSettingsEligible()` 愿意接受 externally injected token 的资格假阳性，以避免把企业治理完全漏掉，表明“多一次查询”被认为比“治理不可见”便宜得多。
- `policyLimits` 的主路径整体偏 fail-open，但 `ESSENTIAL_TRAFFIC_DENY_ON_MISS` 又在高敏感场景下保留局部 fail-closed，说明平台不是在选一种哲学，而是在按策略伤害面细分。
- `validateForceLoginOrg()` 强制以 profile 端点确认组织权威来源，本地可写缓存不能替代；组织边界因此被放在“不能模糊”的层级。
- dangerous managed settings 变更要经过交互式确认，拒绝则退出，说明“远程配置”在高风险情况下已经被提升为“治理命令”，而不只是同步配置。
- `bridgeEnabled` 与 `bridgeMain` 的组合明确区分了资格不足、画像不全、session token 过期、环境失效等不同远程失败语义；401/403 会先恢复，404/410 更接近终局失败。
- `rateLimitMessages` 和 `diagLogs` 进一步说明：计费真相与支持证据被刻意从处罚语义里剥离出来，这能显著降低“所有失败都像封号”的认知污染。

证据:

- `claude-code-source-code/src/services/analytics/growthbook.ts:851-975`
- `claude-code-source-code/src/services/remoteManagedSettings/syncCache.ts:32-112`
- `claude-code-source-code/src/services/policyLimits/index.ts:167-220`
- `claude-code-source-code/src/services/policyLimits/index.ts:497-526`
- `claude-code-source-code/src/utils/auth.ts:1917-1989`
- `claude-code-source-code/src/services/remoteManagedSettings/securityCheck.tsx:14-73`
- `claude-code-source-code/src/bridge/bridgeEnabled.ts:16-87`
- `claude-code-source-code/src/bridge/bridgeMain.ts:198-285`
- `claude-code-source-code/src/services/rateLimitMessages.ts:17-120`
- `claude-code-source-code/src/utils/diagLogs.ts:14-94`
- `claude-code-source-code/src/services/mcp/auth.ts:1344-1470`
- `claude-code-source-code/src/services/rateLimitMessages.ts:41-104`
- `claude-code-source-code/src/services/analytics/growthbook.ts:892-903`
- `claude-code-source-code/src/utils/permissions/permissions.ts:843-875`
- `claude-code-source-code/src/services/mcp/officialRegistry.ts:62-67`
- `claude-code-source-code/src/Tool.ts:743-756`
- `claude-code-source-code/src/hooks/notifs/useCanSwitchToExistingSubscription.tsx:11-58`
- `claude-code-source-code/src/bridge/bridgeApi.ts:100-138`
- `claude-code-source-code/src/services/api/sessionIngress.ts:144-182`
- `claude-code-source-code/src/bridge/bridgeEnabled.ts:57-84`
- `claude-code-source-code/src/services/mcp/client.ts:2311-2334`
- `claude-code-source-code/src/commands/remote-setup/index.ts:10-16`
- `claude-code-source-code/src/bridge/remoteBridgeCore.ts:529-589`
- `claude-code-source-code/src/bridge/replBridge.ts:2272-2303`
- `claude-code-source-code/src/bridge/trustedDevice.ts:89-180`
- `claude-code-source-code/src/services/analytics/firstPartyEventLoggingExporter.ts:570-609`
- `claude-code-source-code/src/utils/plugins/pluginLoader.ts:1922-1929`
- `claude-code-source-code/src/services/policyLimits/index.ts:618-629`
- `claude-code-source-code/src/services/remoteManagedSettings/index.ts:432-442`
- `claude-code-source-code/src/utils/diagLogs.ts:14-31`
- `claude-code-source-code/src/bridge/bridgeEnabled.ts:72-83`
- `claude-code-source-code/src/hooks/notifs/useCanSwitchToExistingSubscription.tsx:21-35`

### O. Host protocol is a closed loop, not RPC

- `initialize` 不只返回 `control_response(success)`，还会继续通过 `system:init` 把 runtime 装配态发给宿主。
- `set_permission_mode` 不只返回 success/error，还会通过 `system:status` 把 mode 变化广播出来。
- `can_use_tool` 的真正完成也不是 response 本身，而是 `requires_action -> running/idle` 与后续 tool/task/system messages 一起形成闭环。
- SDK 非交互 session 还会通过 `sdkEventQueue` 补发 `task_started`、`task_progress`、`task_notification`、`session_state_changed`，说明宿主真相来自持续事件流，而不是单次 ack。

证据:

- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1457-1880`
- `claude-code-source-code/src/utils/sessionState.ts:92-149`
- `claude-code-source-code/src/utils/sdkEventQueue.ts:1-121`
- `claude-code-source-code/src/cli/print.ts:1051-1076`

### P. Remote recovery is layered state machine, not plain reconnect

- `SessionsWebSocket` 对 `4003`、`4001`、一般 reconnect budget 做了分级处理。
- `remoteBridgeCore` 把 `401` 看成 JWT/epoch/transport rebuild 问题，而不是普通 socket close。
- `authRecoveryInFlight` 期间主动 drop `control_request` / `control_response` / `control_cancel_request` / `result`，说明作者宁可丢消息，也不愿制造 stale-epoch 的假成功。
- `RemoteIO` 又在更外层补了 token refresh callback、keepalive 与 CCR state reporting，说明“恢复”还包括远端状态真相回写。

证据:

- `claude-code-source-code/src/remote/SessionsWebSocket.ts:234-403`
- `claude-code-source-code/src/bridge/remoteBridgeCore.ts:456-588`
- `claude-code-source-code/src/bridge/remoteBridgeCore.ts:780-878`
- `claude-code-source-code/src/cli/remoteIO.ts:71-85`
- `claude-code-source-code/src/cli/remoteIO.ts:155-196`

### Q. Runtime truth is dual-channel, not pure event stream

- Claude Code 对宿主暴露的不只是 `SDKMessage` 时间线，还包括 `worker_status`、`requires_action_details` 与 `external_metadata` 快照。
- `notifySessionStateChanged(...)`、`notifySessionMetadataChanged(...)`、`onChangeAppState(...)` 构成统一 choke point，让 permission mode、pending action、model 等状态不会因为 mutation path 分散而失同步。
- `WorkerStateUploader` 说明这不是零散 side effect，而是明确设计过的 merge / retry / last-value 语义。
- `CCRClient.initialize()` 还会主动清理 stale `pending_action` / `task_summary`，说明“恢复后真相”是状态面的一部分，而不是后处理。

证据:

- `claude-code-source-code/src/utils/sessionState.ts:1-149`
- `claude-code-source-code/src/state/onChangeAppState.ts:19-91`
- `claude-code-source-code/src/cli/remoteIO.ts:111-168`
- `claude-code-source-code/src/cli/transports/ccrClient.ts:476-545`
- `claude-code-source-code/src/cli/transports/ccrClient.ts:645-662`
- `claude-code-source-code/src/cli/transports/WorkerStateUploader.ts:1-118`

### R. Consumer subset and compatibility shim are part of the API reality

- `coreSchemas.ts` 声明了消息全集，但 `sdkMessageAdapter`、direct connect、`messages/mappers.ts` 明确证明并非每个 consumer 都完整消费它。
- `auth_status`、`tool_use_summary`、`rate_limit_event` 在 remote adapter 里会被主动忽略。
- `system:local_command_output` 甚至会被降级成 `assistant`，以适配尚未认识该 subtype 的下游。
- 因此“schema 存在”与“所有宿主完整渲染”必须继续分开写。

证据:

- `claude-code-source-code/src/remote/sdkMessageAdapter.ts:223-267`
- `claude-code-source-code/src/utils/messages/mappers.ts:145-196`
- `claude-code-source-code/src/server/directConnectManager.ts:100-109`

### S. Prompt magic is runtime assembly, not mystical wording

- `queryContext`、`getSystemPrompt`、`buildEffectiveSystemPrompt`、`systemPromptSections`、attachments 共同说明 Claude Code 的 prompt 是分层装配链，不是单段字符串。
- 动态 agent list、deferred tools、MCP instructions delta、fork cache sharing 说明 prompt 设计始终服从 cache stability 与 token economics。
- coordinator / worker / fork / proactive 各自的 prompt 合同不同，所谓“魔力”更多来自角色契约与 runtime 约束，而不是几句文案本身。

证据:

- `claude-code-source-code/src/utils/queryContext.ts:1-41`
- `claude-code-source-code/src/constants/prompts.ts:444-579`
- `claude-code-source-code/src/utils/systemPrompt.ts:27-121`
- `claude-code-source-code/src/tools/AgentTool/prompt.ts:48-95`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:1-170`

### T. Security is a layered policy-and-runtime closure system

- trust 判定、managed policy、typed permission model、tool-local validator、classifier / hook、sandbox、MCP / remote protocol 构成统一安全架构；UI modal 只是 `ask` 的一种 renderer。
- `policySettings` 与 remote managed settings 证明组织治理是单独平面，不应和普通用户设置混写。
- sandbox、SSRF guard、MCP auth 又说明安全不止于 permission decision，还要下沉到文件系统、网络和外部 trust domain。

证据:

- `claude-code-source-code/src/components/TrustDialog/TrustDialog.tsx:208-208`
- `claude-code-source-code/src/utils/settings/settings.ts:675-675`
- `claude-code-source-code/src/utils/permissions/permissions.ts:1158-1262`
- `claude-code-source-code/src/utils/sandbox/sandbox-adapter.ts:172-266`
- `claude-code-source-code/src/utils/hooks/ssrfGuard.ts:5-17`

### U. Source quality comes from engineered invariants, not local elegance

- `query.ts` 与 `QueryGuard` 说明 turn lifecycle 被显式状态机化。
- `Tool` 接口与 toolExecution pipeline 说明扩展能力先进入平台 ABI，再进入具体实现。
## 2026-04-02 第二十八轮

目标:

- 优化蓝皮书目录结构，使其更适合继续扩张
- 把第一性原理从六问升级为八问
- 给后续 API 全集与哲学深挖预留导航层

结论:

### I. 蓝皮书已经需要显式的 navigation 层

- 现在主线、机制、接口、哲学、风险、实践已经足够多，如果继续只把阅读路径压在 `bluebook/README.md`，检索成本会继续上升。
- `navigation/` 更适合作为蓝皮书内部导航层，单独承担“从什么问题进入”和“这章属于哪一平面”。

证据:

- `bluebook/README.md`
- `docs/development/01-章节规划.md`

### II. Claude Code 的第一性原理应从六问升级为八问

- 旧写法已经覆盖观察、决策、行动、记忆、协作、恢复。
- 但源码已经清楚显示它还在持续处理治理与经济两个问题：
  - 治理：账号、组织、策略、遥测、remote managed settings、trusted device
  - 经济：prompt cache、tool/result budget、compact、输出外置、认知控制面

证据:

- `claude-code-source-code/src/query.ts:571-703`
- `claude-code-source-code/src/services/analytics/growthbook.ts:1-1`
- `claude-code-source-code/src/services/remoteManagedSettings/securityCheck.tsx:1-1`
- `claude-code-source-code/src/tools/AgentTool/prompt.ts:191-243`
- `claude-code-source-code/src/cli/structuredIO.ts:59-173`

### III. 目录优化不是审美问题，而是可持续研究的基础设施

- 当章节跨越主线、API、架构、哲学、风险之后，如果不明确“章节所属平面”，后续写作会反复混写：
  - 功能全集
  - 公开支持边界
  - 设计解释
  - 风控治理
- 所以目录结构本身已经变成研究质量的一部分。

## 2026-04-02 第二十七轮

- `lazySchema`、`toolPool`、`WorkerStateUploader`、`promptCacheBreakDetection` 说明 schema、cache、retry、merge 都被做成正式结构对象。
- 真正的工程债务集中在少数超大核心文件，而不是整体架构缺少方法。

证据:

- `claude-code-source-code/src/query.ts:203-268`
- `claude-code-source-code/src/utils/QueryGuard.ts:1-1`
- `claude-code-source-code/src/Tool.ts:158-792`
- `claude-code-source-code/src/cli/transports/WorkerStateUploader.ts:1-118`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:1-170`

### V. Token economy is a four-layer system, not just compact

- Claude Code 的省 token 主要不是靠单次摘要，而是靠稳定前缀、动态目录外移、工具输出外置、最后才 compact 的四层经济系统。
- `messages.ts` 的 normalize/shaping 行为，本质上更像“上下文编译器”，先修消息拓扑与体积，再决定要不要做摘要。
- shell / local command / task output 被 tag 化、截断、落盘，本质是在把“可再生的大块输出”搬出上下文。

证据:

- `claude-code-source-code/src/utils/analyzeContext.ts:363-1164`
- `claude-code-source-code/src/query.ts:365-468`
- `claude-code-source-code/src/utils/messages.ts:1989-2534`
- `claude-code-source-code/src/utils/toolResultStorage.ts:769-941`
- `claude-code-source-code/src/utils/toolSearch.ts:545-646`
- `claude-code-source-code/src/utils/task/TaskOutput.ts:32-282`

### S. Risk control is signal fusion around continuity, not a single ban verdict

- `bridgeEnabled.ts` 把“Remote Control 不可用”拆成订阅缺失、full-scope token 缺失、组织画像缺失、gate 未放开、build 不支持等多类诊断，说明资格拒绝是分层语义，不是单点处罚。
- `validateForceLoginOrg()` 在 `forceLoginOrgUUID` 存在时对“无法证明组织归属”也 fail-closed，说明组织边界优先级高于可用性，网络或画像问题也会被收敛成拒绝体验。
- `policyLimits` 整体偏 fail-open，但 dangerous managed settings 变化会弹本地阻塞确认框，拒绝后直接退出，说明系统在普通连续性与危险边界之间做分级治理。
- `trustedDevice`、`bridgeApi`、`sessionIngress` 共同体现“高安全会话连续性”思路：trusted device 有独立 enrollment 窗口，401 只做有条件恢复，409 优先恢复服务端状态真相。
- `mcp/auth.ts` 把 `403 insufficient_scope` 单独转为 step-up pending，而不是误走 refresh，说明“授权不足”被明确定义为不同于“凭证失效”的治理语义。
- `rateLimitMessages.ts` 与 `useCanSwitchToExistingSubscription.tsx` 明确把 usage limit、extra usage、订阅未激活写成独立解释路径，进一步证明很多“不能用”并不是处罚。
- `diagLogs.ts` 与 MCP 通知路径体现出无 PII 诊断和 anti-nag 设计，说明平台已把误伤后的支持成本与解释成本纳入工程边界。

证据:

- `claude-code-source-code/src/bridge/bridgeEnabled.ts:17-82`
- `claude-code-source-code/src/utils/auth.ts:1917-1999`
- `claude-code-source-code/src/services/policyLimits/index.ts:1-111`
- `claude-code-source-code/src/services/remoteManagedSettings/securityCheck.tsx:1-64`
- `claude-code-source-code/src/bridge/trustedDevice.ts:17-174`
- `claude-code-source-code/src/bridge/bridgeApi.ts:15-122`
- `claude-code-source-code/src/services/api/sessionIngress.ts:47-169`
- `claude-code-source-code/src/services/mcp/auth.ts:1345-1468`
- `claude-code-source-code/src/services/mcp/auth.ts:1614-1667`
- `claude-code-source-code/src/services/rateLimitMessages.ts:1-179`
- `claude-code-source-code/src/hooks/notifs/useCanSwitchToExistingSubscription.tsx:1-48`
- `claude-code-source-code/src/hooks/notifs/useMcpConnectivityStatus.tsx:1-80`
- `claude-code-source-code/src/utils/config.ts:194-211`
- `claude-code-source-code/src/utils/diagLogs.ts:1-60`

### T. Risk research now has a question-oriented navigation layer

- 现有 `risk/` 章节已经能覆盖方法、机制、失效、误伤、平台改进，但目录层面仍偏顺序阅读，不利于遇到具体症状时快速定位。
- 把“怀疑被封”“Remote Control 失效”“中国用户连续性破坏”“计费还是风控”“needs-auth / insufficient_scope”这类问题改造成显式入口后，研究目录就从线性蓝皮书升级为问题驱动蓝皮书。
- 这类重组不新增事实判断，但显著降低了在章节、源码模块地图、速查卡之间反复跳转的成本。
- 后续如果继续扩写，只要先判断新内容属于哪类问题，再决定挂到哪条入口链，就能减少重复章节和概念漂移。

### U. A second Socratic pass should optimize for total harm, not only strict gating

- 如果把风控目标只写成“拦住不该放的行为”，会低估误伤、解释不足、恢复失败和支持成本带来的总伤害。
- 更高标准的治理目标应是同时降低：滥用伤害、误伤伤害、失败风暴伤害、解释成本和申诉成本。
- 当前源码已经明显在做这件事的一部分，例如更细错误语义、无 PII 诊断、step-up 区分、trusted device、dangerous settings 显式确认，但对用户可见 reason code、会前体检和结构化证据包仍有继续提升空间。
- 这意味着下一轮研究不能只继续找 gate，还应继续研究 preflight、reason code、证据导出和平台正义这些“解释层基础设施”。

### V. User self-protection should optimize continuity discipline, not retry volume

- `checkGate_CACHED_OR_BLOCKING(...)` 对 entitlement gate 明显偏向减少 stale `false` 误伤，说明平台本身就在努力避免把用户主动触发的功能误判成不可用。
- `isRemoteManagedSettingsEligible()` 接受 externally injected token 的资格假阳性，说明“多一次查询”被认为比“把企业治理完全漏掉”代价更低，也提醒用户不要把一次额外查询误解成针对性限制。
- `bridgeMain` 的 `heartbeatActiveWorkItems()` 明确区分 `auth_failed` 和 `fatal`，说明高安全远程失败并不都是终局处罚，用户首先要分语义，而不是放大成统一封号体感。
- `useMcpConnectivityStatus.tsx` 只对“曾经成功连接过”的 claude.ai connector 做 `failed/needs-auth` 提示，说明“最近一次成功时间”是高价值诊断证据。
- `rateLimitMessages.ts` 把 usage、session、weekly、extra usage、reset time 等单独建模，说明很多“突然不能用”本质是计费/额度语义，不应被误写成处罚。
- 更高抽象看，用户最有效的合规自保不是规避检测，而是保持身份、组织、设备、网络和证据链的连续性，并在故障窗口里冻结变量、减少噪声。

证据:

- `claude-code-source-code/src/services/analytics/growthbook.ts:892-935`
- `claude-code-source-code/src/services/remoteManagedSettings/syncCache.ts:32-111`
- `claude-code-source-code/src/bridge/bridgeMain.ts:198-269`
- `claude-code-source-code/src/hooks/notifs/useMcpConnectivityStatus.tsx:25-87`
- `claude-code-source-code/src/services/rateLimitMessages.ts:17-103`

### W. Technical sophistication is the collaboration of signal, decision, recovery, and explanation planes

- `initializeTelemetryAfterTrust()` 先等待 remote managed settings，再初始化 telemetry，说明观测层本身就受治理层约束，而不是治理之外的旁路。
- `checkSecurityRestrictionGate(...)` 与 `checkGate_CACHED_OR_BLOCKING(...)` 使用不同缓存语义，说明安全限制和 entitlement 并不是同一类 gate。
- `checkManagedSettingsSecurity(...)` 把危险设置变化提升为交互式确认，说明平台会把某些远程配置变化当成“治理命令”，而不只是普通同步。
- `mcp/client.ts` 把远程认证失败提升为 `needs-auth` 状态并缓存，说明子系统失败被建模成有记忆的连接状态，而不是瞬时异常。
- `remoteBridgeCore.ts` 在 401 恢复窗口主动 drop stale control/result 消息，说明恢复层优先保护因果一致性，而不是表面不断。
- `diagLogs.ts` 明确禁止 PII，说明解释层追求的是低敏感度可解释性，而不是无限制地收集更多数据。
- 更高抽象看，Claude Code 风控技术的先进性不在秘密检测器，而在信号层、判定层、恢复层、解释层被整合成一套可持续演进的控制平面。

证据:

- `claude-code-source-code/src/entrypoints/init.ts:241-280`
- `claude-code-source-code/src/services/analytics/growthbook.ts:851-935`
- `claude-code-source-code/src/services/remoteManagedSettings/securityCheck.tsx:14-73`
- `claude-code-source-code/src/services/mcp/client.ts:335-370`
- `claude-code-source-code/src/services/mcp/client.ts:2311-2334`
- `claude-code-source-code/src/bridge/remoteBridgeCore.ts:529-588`
- `claude-code-source-code/src/bridge/remoteBridgeCore.ts:824-878`
- `claude-code-source-code/src/utils/diagLogs.ts:14-57`

### X. Preflight and shortest-recovery paths are already implicit in the source

- `useCanSwitchToExistingSubscription()` 已经能识别“你有 Pro/Max 权益，但当前没激活到此身份路径”，并直接提示 `/login to activate`，说明权益恢复最短路径在部分场景里已存在。
- `getBridgeDisabledReason()` 已经把 Remote Control 的资格前提拆成订阅、full-scope token、组织画像、gate、build 五类诊断，这本质上已经是一个准 preflight 系统。
- `trustedDevice` enrollment 依赖 fresh login 后的短窗口，说明某些高安全能力天然需要“会前体检”，而不是等到失败后再做 lazy 修补。
- `errors.ts` 已把 token revoked、组织不允许、通用 auth error、模型不可用、refusal 等分成不同恢复文案，说明最短恢复路径在 API 错误层已具雏形。
- 更高抽象看，平台当前更像“拥有分散的 preflight 零件”，而不是“没有 preflight”；下一步最值得补的是把这些零件组合成显式的预检面。

证据:

- `claude-code-source-code/src/hooks/notifs/useCanSwitchToExistingSubscription.tsx:10-58`
- `claude-code-source-code/src/bridge/bridgeEnabled.ts:38-87`
- `claude-code-source-code/src/bridge/trustedDevice.ts:89-180`
- `claude-code-source-code/src/services/api/errors.ts:838-883`
- `claude-code-source-code/src/services/api/errors.ts:1109-1177`

### Y. Semantic compression tax is a real governance cost

- `getBridgeDisabledReason()` 已经把订阅、full-scope、组织画像、gate、build 拆开，但对用户而言这些差异仍可能被主观压缩成统一的“不能用”体感。
- `errors.ts` 已把 token revoked、组织不允许、通用 auth、model not available、refusal 做分类，说明系统内部有更细 reason families，但体验层仍可能进一步塌缩。
- `useCanSwitchToExistingSubscription()` 证明“没有能力”和“能力未激活到当前路径”根本不是一回事，若提示未被正确吸收，用户很容易误判成权限被收回。
- `mcp/client.ts` 把远程 auth failure 提升成 `needs-auth` 的连接状态，而不是全局账号状态，但用户直觉上仍容易把 connector 故障外推成整套账号不稳定。
- `sessionIngress.ts` 把多种 401 类连续性问题统一翻译成“Please run /login”，恢复上很务实，但也会让不同底层原因在体验层被压缩为同一动作。
- 更高抽象看，系统内部的多层治理语义若没有被充分结构化地暴露给用户，就会把解释负担转嫁给用户和支持团队，这就是语义压缩税。

证据:

- `claude-code-source-code/src/bridge/bridgeEnabled.ts:57-83`
- `claude-code-source-code/src/services/api/errors.ts:838-883`
- `claude-code-source-code/src/services/api/errors.ts:1109-1177`
- `claude-code-source-code/src/hooks/notifs/useCanSwitchToExistingSubscription.tsx:17-58`
- `claude-code-source-code/src/services/mcp/client.ts:335-370`
- `claude-code-source-code/src/services/api/sessionIngress.ts:144-147`
- `claude-code-source-code/src/services/api/sessionIngress.ts:355-359`
- `claude-code-source-code/src/services/api/sessionIngress.ts:462-467`

### Z. Identity is assembled from multiple truth sources, not one

- `config.ts` 持久化了 `oauthAccount`、`cachedStatsigGates`、`cachedGrowthBookFeatures`、`claudeCodeFirstTokenDate` 等状态，说明本地快照本身就是治理真相的一部分。
- `storeOAuthAccountInfo(...)` 会把服务端 profile 摘要持久化进 `oauthAccount`，但 `validateForceLoginOrg()` 又明确要求关键组织边界必须重新向 `/api/oauth/profile` 取权威真相，说明快照真相和权威真相被刻意分层。
- `user.ts` 和 `telemetryAttributes.ts` 会把 `deviceId/sessionId/accountUuid/organizationUuid/subscriptionType/rateLimitTier/firstTokenTime` 重新拼成 GrowthBook/telemetry 用户模型，说明观测层看到的是“组装后的你”。
- `growthbook.ts` 同时依赖本地 cached features 与 fresh value；某些 cached `true` 可直接放行，cached `false` 则要阻塞复核，说明 gate 真相也有自己的时间层。
- `sessionStorage.ts` 与 `sessionIngress.ts` 维护的是另一条会话连续性真相面：`Last-Uuid` 链、409 adopt server UUID、401 bad token，它不等同于账号画像真相。
- 更高抽象看，很多“明明还是同一个账号，为什么系统前后说法变了”的体验，来自本地快照、服务端画像、gate 缓存与会话连续性在短时间内没有同步收敛。

证据:

- `claude-code-source-code/src/utils/config.ts:440-449`
- `claude-code-source-code/src/utils/config.ts:783-795`
- `claude-code-source-code/src/services/oauth/client.ts:517-565`
- `claude-code-source-code/src/utils/auth.ts:1919-1999`
- `claude-code-source-code/src/utils/user.ts:31-47`
- `claude-code-source-code/src/utils/user.ts:78-127`
- `claude-code-source-code/src/utils/telemetryAttributes.ts:29-70`
- `claude-code-source-code/src/services/analytics/growthbook.ts:466-480`
- `claude-code-source-code/src/services/analytics/growthbook.ts:770-789`
- `claude-code-source-code/src/services/analytics/growthbook.ts:921-935`
- `claude-code-source-code/src/utils/sessionStorage.ts:1238-1260`
- `claude-code-source-code/src/services/api/sessionIngress.ts:57-75`
- `claude-code-source-code/src/services/api/sessionIngress.ts:138-147`

### AA. Proof burden transfer is a fairness issue, not just a support issue

- `getBridgeDisabledReason()`、`useCanSwitchToExistingSubscription()`、`errors.ts` 已在主动承担一部分解释责任，说明平台并非完全把恢复路径留给用户自己猜。
- `validateForceLoginOrg()` 在关键边界上仍要求用户补完组织与 scope 的证明链，说明某些证明责任无法被平台完全内包。
- `diagLogs.ts` 和 startup/connectivity notifications 说明支持体系正在承接内部细语义与外部有限提示之间的翻译责任。
- 对高波动环境用户而言，更高的连续性维护成本，本质上也是更高的证明成本；这解释了为什么“高封号体感”常常不是更高惩罚，而是更高举证难度。
- 更高抽象看，可证明性的成本分配是否公平，本身就是平台正义问题，而不只是 UX 或支持效率问题。

证据:

- `claude-code-source-code/src/bridge/bridgeEnabled.ts:57-83`
- `claude-code-source-code/src/hooks/notifs/useCanSwitchToExistingSubscription.tsx:17-58`
- `claude-code-source-code/src/services/api/errors.ts:838-883`
- `claude-code-source-code/src/services/api/errors.ts:1109-1177`
- `claude-code-source-code/src/utils/auth.ts:1919-1999`
- `claude-code-source-code/src/utils/diagLogs.ts:14-57`

### AB. Error families should map to shortest support paths

- `errors.ts` 已将 `invalid_api_key`、`token_revoked`、`oauth_org_not_allowed`、`auth_error`、`bedrock_model_access`、`connection_error`、`ssl_cert_error`、`rate_limit` 等拆成不同分类，说明系统内部已有较完整的 error families。
- `useCanSwitchToExistingSubscription()` 与 `getBridgeDisabledReason()` 进一步说明 entitlement/订阅激活问题不应被混写进通用 auth 家族。
- `mcp/useManageMCPConnections.ts` 把 `needs-auth` 与 `failed/pending/disabled` 明确区分，说明连接域问题本来就应走单独支持路径。
- `rateLimitMessages.ts` 把 session/weekly/Opus/Sonnet/extra usage/reset time 拆开，说明计费家族本身已具独立支持语义。
- 更高抽象看，真正成熟的解释层不只要有错误分类，还要把每个错误家族绑定到最短恢复动作和支持归属，否则复杂度仍会回流到用户和支持团队。

证据:

- `claude-code-source-code/src/services/api/errors.ts:154-219`
- `claude-code-source-code/src/services/api/errors.ts:838-883`
- `claude-code-source-code/src/services/api/errors.ts:1109-1181`
- `claude-code-source-code/src/hooks/notifs/useCanSwitchToExistingSubscription.tsx:17-58`
- `claude-code-source-code/src/bridge/bridgeEnabled.ts:57-83`
- `claude-code-source-code/src/services/mcp/useManageMCPConnections.ts:755-759`
- `claude-code-source-code/src/services/rateLimitMessages.ts:143-220`

### AC. Proof surfaces should be productized, not left as scattered diagnostics

- `authStatus()` 已经能输出当前 `authMethod`、`orgId`、`orgName`、`subscriptionType` 等核心事实，说明平台已有自证面雏形。
- `commands/bridge/bridge.tsx` 的 `checkBridgePrerequisites()` 已把 policy、资格、版本、token 组成完整 preflight，说明高价值能力的前提检查其实已经存在，只是还未统一产品化。
- `useCanSwitchToExistingSubscription()` 与 `useMcpConnectivityStatus()` 已在产品层提供轻量提示，分别覆盖订阅激活与连接域状态，说明平台并非没有用户面零件。
- `diagLogs.ts` 则构成支持侧的低敏感度证据面，说明“用户仪表盘”和“支持仪表盘”本来就共享一套可证明性基础设施。
- 更高抽象看，当前系统缺的不是诊断零件，而是把 `auth status`、资格 preflight、startup notification、support diagnostics 收敛成同一张用户可执行状态面。

证据:

- `claude-code-source-code/src/cli/handlers/auth.ts:232-317`
- `claude-code-source-code/src/commands/bridge/bridge.tsx:467-503`
- `claude-code-source-code/src/hooks/notifs/useCanSwitchToExistingSubscription.tsx:17-58`
- `claude-code-source-code/src/hooks/notifs/useMcpConnectivityStatus.tsx:25-64`
- `claude-code-source-code/src/utils/diagLogs.ts:14-57`

### AD. Failure handling is a four-layer budget: retry, cooldown, cached denial, terminal stop

- `withRetry.ts` 说明很多 401/403/408/409/429/529 不是统一失败，而是进入不同重试预算；CCR 模式、persistent retry、subscriber gates 等都会改变是否重试。
- `handleOAuth401Error()` 明确先检查“是不是别的进程已经恢复了”，说明恢复预算先处理并发与重复成本，再处理刷新本身。
- `fastMode.ts` 把 runtime state 建模成 `active/cooldown`，说明某些失败的正确动作不是继续试，而是进入正式冷却层。
- `mcp/client.ts` 的 15 分钟 `needs-auth` cache 说明系统会对某些路径做短期必败记忆，而不是每次都重新撞墙。
- `initReplBridge.ts` 对 dead token 做跨进程 fail count 和记忆，达到阈值后直接跳过注册，说明 bridge 也有自己的缓存拒绝层。
- `bridgeMain.ts` / `replBridge.ts` 把 `auth_failed` 与 `fatal` 分开，并在 fatal/auth_failed 后 backoff，说明终止层和恢复层并非同一语义。

证据:

- `claude-code-source-code/src/services/api/withRetry.ts:91-98`
- `claude-code-source-code/src/services/api/withRetry.ts:696-780`
- `claude-code-source-code/src/utils/auth.ts:1345-1392`
- `claude-code-source-code/src/utils/fastMode.ts:178-233`
- `claude-code-source-code/src/services/mcp/client.ts:257-263`
- `claude-code-source-code/src/services/mcp/client.ts:363-370`
- `claude-code-source-code/src/services/mcp/client.ts:2311-2322`
- `claude-code-source-code/src/bridge/initReplBridge.ts:169-239`
- `claude-code-source-code/src/bridge/bridgeMain.ts:659-730`
- `claude-code-source-code/src/bridge/replBridge.ts:2080-2105`

### AE. Organization governance is a three-party coordination problem

- `policyLimits` 表明平台负责下发策略接口和客户端消费链，而不是把组织限制硬编码到本地。
- `remoteManagedSettings` 进一步说明组织治理会进入本地运行时：读取缓存、远程拉取、危险设置确认、热更新。
- `securityCheck.tsx` 表明危险变更并非管理员单方面静默生效，终端用户仍是本地最后一跳确认者。
- 更高抽象看，很多“像封号”的体验并不是平台与用户的二元问题，而是平台、管理员、用户三方责任边界没有被清楚对齐。

证据:

- `claude-code-source-code/src/services/policyLimits/index.ts:217-320`
- `claude-code-source-code/src/services/policyLimits/index.ts:505-535`
- `claude-code-source-code/src/services/policyLimits/index.ts:618-629`
- `claude-code-source-code/src/services/remoteManagedSettings/index.ts:410-560`
- `claude-code-source-code/src/services/remoteManagedSettings/securityCheck.tsx:22-73`

### AF. Risk control can be reduced to three proof chains

- `isClaudeAISubscriber()`、`hasProfileScope()`、`getOauthAccountInfo()` 共同说明“有 token”不等于主体链成立，主体链需要凭证、来源、画像一起闭合。
- `getBridgeDisabledReason()` 则表明资格链要额外证明订阅、full-scope、组织画像与 feature gate，而不仅是主体存在。
- `sessionIngress.ts` 与 `mcp/client.ts` 进一步说明会话链是独立事实面：`Last-Uuid`、401、409 adopt server UUID、`needs-auth` 都不等同于主体链或资格链。
- 更高抽象看，很多“像被封了”的体验不是单点风控，而是主体链、资格链、会话链中至少一条未能持续成立。

证据:

- `claude-code-source-code/src/utils/auth.ts:1564-1617`
- `claude-code-source-code/src/bridge/bridgeEnabled.ts:57-83`
- `claude-code-source-code/src/utils/auth.ts:1919-1999`
- `claude-code-source-code/src/services/api/sessionIngress.ts:57-75`
- `claude-code-source-code/src/services/api/sessionIngress.ts:138-147`
- `claude-code-source-code/src/services/mcp/client.ts:335-360`
- `claude-code-source-code/src/services/mcp/client.ts:2311-2322`

### AG. Shared vocabulary reduces semantic mismatch across user, admin, and support

- `getBridgeDisabledReason()` 已能把用户最常感受到的“不能用”拆成订阅、full-scope、组织画像、gate 等共享 reason family 雏形。
- `useCanSwitchToExistingSubscription()` 把“已有权益但未激活”做成单独提示，说明 entitlement/activation 本来就应与 auth_error 分开命名。
- `useMcpConnectivityStatus()` 对 `failed`、`needs-auth`、connector unavailable 使用不同提示，说明连接域本来就需要单独词汇。
- `errors.ts` 进一步把 `token_revoked`、`oauth_org_not_allowed`、`auth_error` 区分成不同错误族，说明支持侧早已有共享词汇基础。
- `diagLogs.ts` 则提供了低敏感度事件面，支持团队可以在不看 PII 的前提下沿这些 reason family 做调查。
- 更高抽象看，很多误伤不是因为没有答案，而是三方没用同一套词汇描述同一个失败；共享词汇本身就是降低总伤害的治理基础设施。

证据:

- `claude-code-source-code/src/bridge/bridgeEnabled.ts:70-83`
- `claude-code-source-code/src/hooks/notifs/useCanSwitchToExistingSubscription.tsx:21-35`
- `claude-code-source-code/src/hooks/notifs/useMcpConnectivityStatus.tsx:36-63`
- `claude-code-source-code/src/services/api/errors.ts:838-883`
- `claude-code-source-code/src/services/api/errors.ts:1109-1133`
- `claude-code-source-code/src/utils/diagLogs.ts:14-30`

### AE. Governance uses multiple clocks, not one static boundary

- `mcp/auth.ts` 会在 token 距离过期 5 分钟时主动刷新，说明会话治理在时间上前移，而不是等 401 才处理。
- `envLessBridgeConfig.ts` 也默认把 `token_refresh_buffer_ms` 设为 300_000，说明 5 分钟预刷新是跨模块时间哲学。
- `trustedDevice.ts` 明确要求 trusted device enrollment 必须发生在 fresh login 后 10 分钟内，说明高安全能力依赖“会话新鲜度”这一时间边界。
- `mcp/client.ts` 把 `needs-auth` 缓存 15 分钟，说明某些失败状态会被短期记忆，而不是每次重新判断。
- `ccrClient.ts` / `envLessBridgeConfig.ts` 使用 20 秒 heartbeat 对应 60 秒 TTL，`withRetry.ts` 用 30 秒切片 keepalive，说明会话连续性在秒级被周期性再证明。
- `useReplBridge.tsx` 与 `initReplBridge.ts` 的 3 次失败阈值、`withRetry.ts` 的 6 小时 reset cap，则说明恢复预算还有更长时间尺度的熔断与等待上界。
- 更高抽象看，很多“刚刚还能用、后来像被封了”的体验，不是新处罚，而是多个治理时钟在高波动环境中同时错位。

证据:

- `claude-code-source-code/src/services/mcp/auth.ts:1645-1660`
- `claude-code-source-code/src/bridge/envLessBridgeConfig.ts:17-23`
- `claude-code-source-code/src/bridge/envLessBridgeConfig.ts:51-53`
- `claude-code-source-code/src/bridge/trustedDevice.ts:94-97`
- `claude-code-source-code/src/services/mcp/client.ts:257-263`
- `claude-code-source-code/src/services/mcp/client.ts:368-370`
- `claude-code-source-code/src/cli/transports/ccrClient.ts:32-33`
- `claude-code-source-code/src/services/api/withRetry.ts:96-98`
- `claude-code-source-code/src/services/api/withRetry.ts:444-459`
- `claude-code-source-code/src/services/api/withRetry.ts:500-505`
- `claude-code-source-code/src/services/api/withRetry.ts:818-821`
- `claude-code-source-code/src/hooks/useReplBridge.tsx:35-40`
- `claude-code-source-code/src/bridge/initReplBridge.ts:169-239`

### AF. Long-horizon user safety is mostly continuity-cost management

- `auth.ts` 的缓存失效、401 去重、跨进程刷新锁，说明系统显式在对抗“多实例、多缓存、多时钟”导致的身份分叉；用户长期混用多条身份路径，会抬高主体链重证明成本。
- `mcp/auth.ts` 与 `envLessBridgeConfig.ts` 都采用 5 分钟级的预刷新缓冲，说明成熟控制面更关心“不要带着快过期凭证进入长链路”，而不是“等出错后再补救”。
- `mcp/client.ts` 的 `needs-auth` 15 分钟缓存，以及 `toolExecution.ts` 把局部连接域直接标记为 `needs-auth`，说明局部认证失效会被短期记忆；用户应先局部恢复，避免把子系统问题扩大成全局重置。
- `trustedDevice.ts` 把 fresh login 10 分钟窗口与 90 天滚动 token 结合起来，说明高安全能力依赖的是“设备连续性 + 会话新鲜度”，不是普通登录成功后的自动延伸。
- `remoteManagedSettings/index.ts`、`policyLimits/index.ts` 与 `securityCheck.tsx` 共同表明：平台治理是缓慢轮询、校验和缓存、危险变更强确认的组合；长期频繁切组织、切环境、切机器，会显著增加资格链与会话链的解释成本。
- 更高抽象看，合规自保的核心不是对抗检测，而是长期降低主体链、资格链、会话链的重证明成本。

证据:

- `claude-code-source-code/src/utils/auth.ts:1303-1556`
- `claude-code-source-code/src/services/mcp/auth.ts:1633-1668`
- `claude-code-source-code/src/bridge/envLessBridgeConfig.ts:14-23`
- `claude-code-source-code/src/bridge/envLessBridgeConfig.ts:47-90`
- `claude-code-source-code/src/services/mcp/client.ts:257-337`
- `claude-code-source-code/src/services/tools/toolExecution.ts:1599-1623`
- `claude-code-source-code/src/bridge/trustedDevice.ts:17-27`
- `claude-code-source-code/src/bridge/trustedDevice.ts:87-98`
- `claude-code-source-code/src/services/remoteManagedSettings/index.ts:1-23`
- `claude-code-source-code/src/services/policyLimits/index.ts:1-23`
- `claude-code-source-code/src/services/remoteManagedSettings/securityCheck.tsx:14-57`

### AG. The control plane can be compressed into a small set of axioms

- `bridgeEnabled.ts` 与 `trustedDevice.ts` 共同说明：权限越高，所需证明越重；claude.ai 订阅、profile scope、组织画像、fresh login、trusted device 并不是可替换条件，而是高能力路径的叠加证明。
- `growthbook.ts` 的 `checkGate_CACHED_OR_BLOCKING()` 明确承认 stale `false` 比 stale `true` 更容易伤害用户，因此对负向拒绝要求更强的新鲜证据；这是“高伤害拒绝比低伤害放行更谨慎”的工程化版本。
- `permissions.ts` 与 `shadowedRuleDetection.ts` 说明这种非对称甚至内建在本地权限引擎里：deny / ask / safety check 先于 bypass 和 allow 执行，宽规则遮蔽窄 allow 还会被显式标记。
- `auth.ts` 的 `validateForceLoginOrg()` 强制去服务端 profile 验证组织，而不是信任本地可写配置；这表明本地真相只能作加速层，不能单独承担裁决。
- `settings.ts` 与 `permissionsLoader.ts` 还说明治理看重“来源可信度”而不只看“配置内容”本身：危险模式和某些自动行为不信任 projectSettings，企业托管策略甚至可以直接压缩规则面。
- `remoteManagedSettings/index.ts` 的 fail-open 与 `securityCheck.tsx` 的危险设置强确认共同表明：治理策略必须按风险等级切换，不能一律 fail-open 或一律 fail-closed。
- `errors.ts`、`mcp/client.ts`、`toolExecution.ts` 则说明系统允许局部撤权、局部失效、局部恢复，而不是把所有失败压成单一“封禁”语义。
- `diagLogs.ts` 进一步说明可解释性也要受限于低敏感证据面；平台并没有把“无限采集”当成成熟风控的前提。
- 更高抽象看，这套系统的核心哲学可以压缩为：持续证明、分层放权、受控恢复、低敏感诊断。

证据:

- `claude-code-source-code/src/bridge/bridgeEnabled.ts:15-88`
- `claude-code-source-code/src/bridge/trustedDevice.ts:17-27`
- `claude-code-source-code/src/bridge/trustedDevice.ts:87-98`
- `claude-code-source-code/src/services/analytics/growthbook.ts:891-929`
- `claude-code-source-code/src/utils/permissions/permissions.ts:1-220`
- `claude-code-source-code/src/utils/permissions/shadowedRuleDetection.ts:1-220`
- `claude-code-source-code/src/utils/auth.ts:1917-1969`
- `claude-code-source-code/src/utils/settings/settings.ts:1-220`
- `claude-code-source-code/src/utils/permissions/permissionsLoader.ts:1-220`
- `claude-code-source-code/src/services/remoteManagedSettings/index.ts:431-500`
- `claude-code-source-code/src/services/remoteManagedSettings/index.ts:604-604`
- `claude-code-source-code/src/services/remoteManagedSettings/securityCheck.tsx:14-57`
- `claude-code-source-code/src/services/api/errors.ts:838-878`
- `claude-code-source-code/src/services/api/errors.ts:1109-1132`
- `claude-code-source-code/src/services/mcp/client.ts:319-360`
- `claude-code-source-code/src/services/tools/toolExecution.ts:1599-1623`
- `claude-code-source-code/src/utils/diagLogs.ts:13-30`

### AH. Support routing quality depends on preserving first-party evidence surfaces

- `sessionIngress.ts` 把每个 session 的远程追加串成单链，409 时会采纳服务端链头并继续，401 则立即停止；这说明会话问题首先是链路一致性问题，不是“多试几次”问题。
- `errorLogSink.ts` 把错误和 MCP 调试写成带 `timestamp`、`cwd`、`sessionId`、`version` 的 JSONL，说明支持路径天然偏好结构化证据而不是口头描述。
- `diagLogs.ts` 提供了无 PII 的事件与时长面，适合在用户、管理员、平台支持之间共享而不暴露过多敏感内容。
- `sessionStorage.ts` 的 `tengu_resume_consistency_delta` 说明恢复一致性已经被当成可观测对象；“恢复后前后不一致”不应被简化成用户感受问题。
- `asciicast.ts` 说明终端录制在存在时可以跟随 session ID 重命名并成为补充证据面，适合重建故障发生过程。
- `toolResultStorage.ts` 明确把“已经被模型看到的内容”冻结成决策边界；从支持角度看，第一现场证据价值高于后续大量变更后的证据。
- `settings.ts`、`permissionsLoader.ts`、`mcp/config.ts` 还说明管理员路径必须先确认是不是 managed-only 策略接管，而不是默认把一切都转成平台封禁叙事。
- 更高抽象看，支持效率取决于三件事：正确归属、结构化证据、保护第一现场。

证据:

- `claude-code-source-code/src/services/api/sessionIngress.ts:28-171`
- `claude-code-source-code/src/utils/errorLogSink.ts:1-198`
- `claude-code-source-code/src/utils/diagLogs.ts:13-30`
- `claude-code-source-code/src/utils/sessionStorage.ts:2208-2235`
- `claude-code-source-code/src/utils/asciicast.ts:20-104`
- `claude-code-source-code/src/utils/toolResultStorage.ts:440-505`
- `claude-code-source-code/src/utils/toolResultStorage.ts:642-690`
- `claude-code-source-code/src/utils/settings/settings.ts:675-726`
- `claude-code-source-code/src/utils/permissions/permissionsLoader.ts:40-130`
- `claude-code-source-code/src/services/mcp/config.ts:338-355`

### AI. The repository itself is treated as a potentially hostile input source

- `permissions.ts` 把 deny / ask / safety check 放在 bypass 和 always-allow 之前，说明系统默认更重视“先避免错误放权”，而不是“尽快让配置生效”。
- `shadowedRuleDetection.ts` 会把宽 deny/ask 遮蔽窄 allow 视为显式不可达规则，说明规则面的可解释性本身就是治理目标之一。
- `settings.ts` 明确把 `projectSettings` 排除在 dangerous mode、auto mode、plan mode 相关高风险 opt-in 之外，并直接写明是 malicious project / RCE risk。
- `permissionsLoader.ts` 的 `allowManagedPermissionRulesOnly` 表明企业托管可以直接收缩权限规则面，而不只是提高某条规则优先级。
- `settings.ts` 对 `policySettings` 使用 first source wins，说明某些治理面关心的首先是“来源是否可信”，而不是“把所有来源都合并一下”。
- `mcp/config.ts` 又进一步展示了 allow/deny 的非对称：allow 可以被托管垄断，deny 仍允许用户保留自我保护权。
- 更高抽象看，Claude Code 的信任模型不是“项目声明什么就信什么”，而是“共享对象不能自动替操作者声明高风险同意”。

证据:

- `claude-code-source-code/src/utils/permissions/permissions.ts:1161-1295`
- `claude-code-source-code/src/utils/permissions/shadowedRuleDetection.ts:1-220`
- `claude-code-source-code/src/utils/settings/settings.ts:675-726`
- `claude-code-source-code/src/utils/settings/settings.ts:875-940`
- `claude-code-source-code/src/utils/permissions/permissionsLoader.ts:28-130`
- `claude-code-source-code/src/services/mcp/config.ts:338-355`

### AJ. Auth continuity is engineered as a multi-cache, multi-process coordination problem

- `saveOAuthTokensIfNeeded()` 不会让 refresh 过程里的空 `subscriptionType` / `rateLimitTier` 覆盖已有稳定值，说明作者在主动防止局部不完整响应破坏连续主体画像。
- `handleOAuth401Error()` 先清缓存并重读 secure storage，若发现另一个终端已经写入新 token 就直接接上，而不是立刻强制重登；401 被当作连续性再协商，而不是简单失败。
- `checkAndRefreshOAuthTokenIfNeeded()` 通过 mtime 检测、pending promise 去重、跨进程 lockfile 和锁后二次确认，对抗多终端并发刷新造成的 relogin loops。
- `macOsKeychainStorage.ts` 的 stale-while-error、TTL、generation guard 说明在安全存储短时不稳定时，系统宁可短时保留旧真相，也不愿立刻把所有子系统打成未登录。
- `login.tsx` 在登录成功后会重同步 GrowthBook、policy limits、managed settings、trusted device 与 authVersion，说明登录本质上是控制面重建动作，不是单一按钮事件。
- `trustedDevice.ts` 进一步证明高安全远程链路有独立于普通登录的认证连续性要求：fresh login 10 分钟窗口、旧 token 清理、再 enrollment。
- 更高抽象看，Claude Code 的认证问题不是“有没有登录”，而是“多个子系统是否仍共享足够新鲜的同一主体真相”。

证据:

- `claude-code-source-code/src/utils/auth.ts:1193-1252`
- `claude-code-source-code/src/utils/auth.ts:1303-1556`
- `claude-code-source-code/src/utils/secureStorage/macOsKeychainStorage.ts:25-111`
- `claude-code-source-code/src/commands/login/login.tsx:20-61`
- `claude-code-source-code/src/bridge/trustedDevice.ts:41-98`

### AK. Recovery is constrained by freeze semantics and single-chain continuity

- `sessionIngress.ts` 通过 per-session sequential append、`Last-Uuid`、409 adopt server UUID 与 401 immediate fail，把远程 transcript 明确建模成单链追加，而不是自由并发写入。
- `sessionStorage.ts` 对 sidechain/main-thread 的注释说明，本地可有局部分支，但权威远程链仍必须单线；否则就会出现 409、悬挂 parentUuid 与 resume 断链。
- `toolResultStorage.ts` 明确把“模型已经见过的结果”冻结成后续决策边界：已替换的要 byte-identical 重放，已见未替换的不能事后再改写，以保持 prompt cache 稳定。
- `withRetry.ts` 与 `fastMode.ts` 则把短等待保持 fast mode、长等待进入 cooldown 做成显式状态机；失败窗口并非空白，而是带状态的窗口。
- `replBridge.ts` 又说明某些 stale transport/work state 若继续硬撑，会形成 10 分钟以上 dead window，因此系统宁可 tear down 旧状态以换取快速重分发。
- `sessionStorage.ts` 的 `tengu_resume_consistency_delta` 表明恢复前后的一致性本身就是正式监控对象，不是附带体验问题。
- 更高抽象看，Claude Code 恢复逻辑优先保护链头一致性与已见前缀稳定，因此用户在故障窗口里乱试，往往是在一个已冻结部分历史事实的系统里继续叠加噪声。

证据:

- `claude-code-source-code/src/services/api/sessionIngress.ts:28-171`
- `claude-code-source-code/src/utils/sessionStorage.ts:1228-1261`
- `claude-code-source-code/src/utils/sessionStorage.ts:2208-2235`
- `claude-code-source-code/src/utils/toolResultStorage.ts:440-505`
- `claude-code-source-code/src/utils/toolResultStorage.ts:642-690`
- `claude-code-source-code/src/utils/toolResultStorage.ts:939-970`
- `claude-code-source-code/src/services/api/withRetry.ts:261-301`
- `claude-code-source-code/src/services/api/withRetry.ts:433-505`
- `claude-code-source-code/src/utils/fastMode.ts:178-228`
- `claude-code-source-code/src/bridge/replBridge.ts:1028-1055`

### AL. High-volatility users need rights-preserving discipline more than evasive tactics

- `errors.ts` 的 `token_revoked`、`oauth_org_not_allowed`、generic auth_error 以及 CCR 专用 auth 提示，说明平台内部已有比较明确的身份/组织错误分层；用户若只说“被封了”会丢失最短分流路径。
- `rateLimitMessages.ts` 把 reset time、session limit、weekly limit、out of extra usage 显式建模，说明很多“突然不能继续”并不是处罚，而是额度/冷却窗口；用户利益保护首先要求不要把这类问题误报成封禁。
- `diagLogs.ts` 提供无 PII 的 diagnostics 事件面，意味着高波动环境用户可以在较低敏感度前提下保留第一现场，而不必在证据保护和隐私之间二选一。
- 结合前面认证连续性、冻结语义、支持分流的证据，可以得出一个更高层结论：对高波动环境用户，最有效的权益保护不是规避检测，而是稳定主路径、减少连续性噪声、保留第一现场并用共享词汇描述问题。

证据:

- `claude-code-source-code/src/services/api/errors.ts:838-878`
- `claude-code-source-code/src/services/rateLimitMessages.ts:143-199`
- `claude-code-source-code/src/utils/diagLogs.ts:13-30`

### AM. Identity continuity is bound to config-home path, storage slot, and org-scoped managed context

- `envUtils.ts` 把 Claude 的本地状态根绑定到 `CLAUDE_CONFIG_DIR` 或 `~/.claude`，说明 config home 本身就是连续性边界的一部分。
- `macOsKeychainHelpers.ts` 用 config-dir 路径哈希参与 keychain service name，意味着不同 config home 对应不同 secure-storage 槽位，而不是同一身份池。
- `plainTextStorage.ts` 与 `fallbackStorage.ts` 则说明即使走 plaintext fallback，也仍沿同一 config home 写 `.credentials.json`，并尽量删除旧主存储以免 stale 凭证遮蔽 fresh 凭证。
- `auth.ts` 的 managed OAuth context 明确禁止 CCR / Claude Desktop 这类受管环境回退到用户终端自己的 API key 来源；凭证存在不等于这条身份路径对当前环境合法。
- `validateForceLoginOrg()` 进一步对组织不匹配做 fail-closed，并明确要求移除错误 env token 或重新按正确组织登录。
- 更高抽象看，Claude Code 在验证的不只是 token，而是“这个 token 是否沿正确 config root、正确 storage slot、正确运行场景和正确组织边界进入当前环境”。

证据:

- `claude-code-source-code/src/utils/envUtils.ts:5-14`
- `claude-code-source-code/src/utils/secureStorage/index.ts:1-16`
- `claude-code-source-code/src/utils/secureStorage/macOsKeychainHelpers.ts:23-40`
- `claude-code-source-code/src/utils/secureStorage/plainTextStorage.ts:8-57`
- `claude-code-source-code/src/utils/secureStorage/fallbackStorage.ts:20-58`
- `claude-code-source-code/src/utils/auth.ts:83-110`
- `claude-code-source-code/src/utils/auth.ts:1917-2000`

### AN. The system’s technical sophistication is in observability-coupled control, not just more gates

- `permissionLogging.ts` 把 permission accept/reject 正式接入 analytics、OTel 和 code-edit metrics，说明权限判定本身就是控制面事件，而非本地黑箱结果。
- `telemetry/events.ts` 给事件加上 session-scoped attributes 与 monotonic `event.sequence`，`sessionTracing.ts` 又把 interaction / tool / llm_request 做成统一 tracing 语义，说明系统把时序与归属当成一等事实。
- `perfettoTracing.ts` 进一步把 agent hierarchy、API 时长、tool 执行、等待时间写成 Perfetto trace，代表它不仅记录结果，还记录跨 agent 的运行机制。
- `bridgeMain.ts` 的 heartbeat/re-dispatch/ack-after-commit 逻辑说明系统在很多关键点上优化的是“不可恢复损失窗口最小化”，而不是表面吞吐或单次成功率最大化。
- `firstPartyEventLoggingExporter.ts` 还会把本 session 的事件批量落盘并重试前批次，说明观测连续性本身也是正式工程目标。
- 更高抽象看，Claude Code 的先进性不在 gate 数量，而在把权限、恢复、观测、实验和分布式时序组织成同一张控制平面。

证据:

- `claude-code-source-code/src/hooks/toolPermission/permissionLogging.ts:1-220`
- `claude-code-source-code/src/utils/telemetry/events.ts:1-63`
- `claude-code-source-code/src/utils/telemetry/sessionTracing.ts:1-220`
- `claude-code-source-code/src/utils/telemetry/perfettoTracing.ts:1-220`
- `claude-code-source-code/src/bridge/bridgeMain.ts:196-320`
- `claude-code-source-code/src/bridge/bridgeMain.ts:832-890`
- `claude-code-source-code/src/services/analytics/firstPartyEventLoggingExporter.ts:130-240`

### AO. Many seemingly inconsistent choices become coherent under a multi-loss objective

- `growthbook.ts` 的 `checkGate_CACHED_OR_BLOCKING()` 说明 stale `true` 和 stale `false` 的损失不对称；系统优先减少错误阻断而不是追求表面判定对称。
- `remoteManagedSettings/index.ts` 的 stale-cache / fail-open，与 `securityCheck.tsx` 的危险变更强确认，说明低风险和高风险路径在损失排序上不同。
- `withRetry.ts`、`fastMode.ts` 与 `rateLimitMessages.ts` 说明平台显式把短时等待、长时 cooldown、reset time 变成正式状态，而不是把一切都简化成继续重试。
- `bridgeMain.ts` 的 ack-after-commit、heartbeat-before-backoff 与 re-dispatch 逻辑说明系统更怕不可恢复丢失窗口，而不是短时多做一次重发或多留一个 stale 状态。
- `permissions.ts` 与 `settings.ts` 的 deny/ask 优先、projectSettings 不可信，则说明高风险错误放权的损失被排在很前面。
- 更高抽象看，Claude Code 的风控不是在最小化一个指标，而是在平台安全、不可恢复状态、用户误伤、支持解释成本之间做动态平衡。

证据:

- `claude-code-source-code/src/services/analytics/growthbook.ts:891-929`
- `claude-code-source-code/src/services/remoteManagedSettings/index.ts:431-500`
- `claude-code-source-code/src/services/remoteManagedSettings/securityCheck.tsx:14-57`
- `claude-code-source-code/src/services/api/withRetry.ts:261-304`
- `claude-code-source-code/src/utils/fastMode.ts:178-228`
- `claude-code-source-code/src/services/rateLimitMessages.ts:143-199`
- `claude-code-source-code/src/bridge/bridgeMain.ts:196-269`
- `claude-code-source-code/src/bridge/bridgeMain.ts:832-890`
- `claude-code-source-code/src/utils/permissions/permissions.ts:1161-1295`
- `claude-code-source-code/src/utils/settings/settings.ts:875-940`

### AP. Approval itself is treated as a governed trust surface

- `permissionLogging.ts` 把 accept/reject 来源显式建模为 config/user/hook/classifier，并把批准结果写入 analytics、OTel 和 toolDecisions，说明批准不是无来源事件。
- `channelPermissions.ts` 允许 Telegram/iMessage/Discord 之类 channel relay 参与 permission prompt，但批准必须通过结构化事件而非普通文本；源码还明确指出真正的 trust boundary 是 allowlist。
- `channelAllowlist.ts` 进一步说明替代批准面必须先通过 `{marketplace, plugin}` allowlist 和总开关 gate，而不是任何能发消息的插件都自动拥有批准资格。
- 更高抽象看，Claude Code 在治理的不只是动作本身，也在治理“谁有资格替用户说 yes”。批准权本身就是风控对象。

证据:

- `claude-code-source-code/src/hooks/toolPermission/permissionLogging.ts:1-240`
- `claude-code-source-code/src/services/mcp/channelPermissions.ts:1-240`
- `claude-code-source-code/src/services/mcp/channelAllowlist.ts:1-77`

### AQ. The system often prefers partial revocation over whole-subject bans

- `mcp/client.ts` 与 `toolExecution.ts` 在认证失败时倾向于只把对应连接打成 `needs-auth`，而不把主体整体判死，说明连接域可以被局部撤权。
- `bridgeMain.ts` / `replBridge.ts` 把 `auth_failed` 与 `fatal` 分开，说明高安全会话链的失效也会分层，而不是一律理解成终局封禁。
- `errors.ts` 与 `rateLimitMessages.ts` 把 quota limit、capacity 429、extra usage requirement 等分开表达，说明时间窗口撤权与主体处罚并不是同一层语义。
- `mcp/config.ts` 和托管权限相关代码还说明组织经常收回的是“谁能放权”的权力，而不是主体本身。
- 更高抽象看，Claude Code 更偏向保住主体，再按连接、能力、时间窗口或自扩权力做局部撤回；用户把这些都压成“被封了”会丢失结构诊断。

证据:

- `claude-code-source-code/src/services/mcp/client.ts:337-360`
- `claude-code-source-code/src/services/tools/toolExecution.ts:1599-1623`
- `claude-code-source-code/src/bridge/bridgeMain.ts:198-267`
- `claude-code-source-code/src/bridge/replBridge.ts:2018-2041`
- `claude-code-source-code/src/services/api/errors.ts:520-575`
- `claude-code-source-code/src/services/rateLimitMessages.ts:143-199`
- `claude-code-source-code/src/services/mcp/config.ts:338-355`

### AR. High-volatility users benefit most from low-cost status surfaces and fixed operating order

- `authStatus()` 已经能输出 `authMethod`、`apiProvider`、`orgId`、`subscriptionType` 等最关键状态，这说明平台至少为用户提供了低成本的会前/故障时自检入口。
- `useMcpConnectivityStatus.tsx` 会把 local MCP failed、claude.ai connector unavailable、needs-auth 分开提示，并且只对“曾经连通过”的 claude.ai connector 提高提醒优先级，说明平台在鼓励用户按状态变化而不是按情绪升级问题。
- 结合前面认证连续性、局部撤权和支持分流的证据，可以推导出一个更严格的运行 SOP：平时固定主路径，开工前先看状态面，故障窗口先冻结变量，再按共享词汇和结构化证据升级求助。

证据:

- `claude-code-source-code/src/cli/handlers/auth.ts:233-315`
- `claude-code-source-code/src/hooks/notifs/useMcpConnectivityStatus.tsx:1-88`

### AS. Many platform-side gains now depend more on productizing existing surfaces than inventing new gates

- `authStatus()` 已经提供主体、组织、订阅、provider 维度的低成本状态面，但仍主要停留在命令输出层。
- `status.tsx` 已经能汇总 MCP connected / needs-auth / failed / pending，说明连接健康面已经具备产品化基础。
- `MCPListPanel.tsx` 进一步把 enterprise / user / local / project / claude.ai connector 分层展示，意味着连接状态不仅存在，而且已经有分层 UI 语义。
- `useMcpConnectivityStatus.tsx` 说明平台已经掌握“状态变化优于静态坏状态”的提示原则，只是还没有完全扩展到统一风控状态面。
- 更高抽象看，误伤进一步下降的主要瓶颈不再只是缺少底层能力，而是这些现有状态面、证据面和分流面还没完全前置成统一产品。

证据:

- `claude-code-source-code/src/cli/handlers/auth.ts:233-315`
- `claude-code-source-code/src/utils/status.tsx:1-180`
- `claude-code-source-code/src/components/mcp/MCPListPanel.tsx:1-160`
- `claude-code-source-code/src/hooks/notifs/useMcpConnectivityStatus.tsx:1-88`

### AT. Evasion attempts generally trade short-term friction relief for higher long-term proof burden

- `auth.ts` 明确禁止 managed session 回退到用户终端私有凭证来源，说明“换一条凭证路径先过再说”在受管上下文里本身就会制造 wrong-org 或 wrong-context 风险。
- `trustedDevice.ts` 中 env token precedence 与 fresh-login enrollment 说明，高安全链路有自己的证明要求；用替代 token / 替代路径临时顶上，并不能稳定替代正确的主体链和设备链。
- `channelAllowlist.ts` 和 `pluginOnlyPolicy.ts` 又说明，即使是扩展面或替代批准面，也被显式放进 allowlist / admin-trusted 边界里；能发声不等于有资格替用户放权。
- 更高抽象看，规避思路的共同问题是：它们试图绕开一层证明，却会同时破坏身份路径、组织边界、批准链或主体连续性中的另一层，因此长期看通常不是最优策略。

证据:

- `claude-code-source-code/src/utils/auth.ts:83-110`
- `claude-code-source-code/src/bridge/trustedDevice.ts:65-115`
- `claude-code-source-code/src/services/mcp/channelAllowlist.ts:1-77`
- `claude-code-source-code/src/utils/settings/pluginOnlyPolicy.ts:1-56`

### AU. Governance is easier to explain when sovereignty and recovery agency are split

- `settings.ts` 的 policySettings first-source-wins 说明组织主权是正式上位裁决层，而不是普通 merge 参与者。
- `pluginOnlyPolicy.ts` 进一步表明管理员不只决定“内容”，还决定“哪些来源还有资格发声”。
- `channelNotification.ts` 和 `channelAllowlist.ts` 则说明替代批准面可以代行批准，但其合法性仍受平台 gate、组织 policy、allowlist 和 session opt-in 共同约束。
- `permissionSetup.ts` 展示了另一类主权：系统可以阻止 mode transition（例如 gate 未开启时不允许进入 auto mode），说明自动化/本地选择权仍受上位边界约束。
- 更高抽象看，平台主权、组织主权、用户主权、替代批准面和自动恢复主权并不对等；很多混乱感来自读者把“能发信号”“能代批”“能恢复”和“能最终裁决”误当成同一件事。

证据:

- `claude-code-source-code/src/utils/settings/settings.ts:675-726`
- `claude-code-source-code/src/utils/settings/pluginOnlyPolicy.ts:1-56`
- `claude-code-source-code/src/services/mcp/channelNotification.ts:220-318`
- `claude-code-source-code/src/services/mcp/channelAllowlist.ts:1-77`
- `claude-code-source-code/src/utils/permissions/permissionSetup.ts:593-633`

### AV. User-interest protection is often better framed as asset preservation than immediate continuation

- `sessionStorage.ts` 的 transcriptPath/sessionProjectDir 逻辑说明 transcript 文件本身是会话主资产；路径漂移会直接伤害恢复和 hooks 的正确性。
- `reAppendSessionMetadata()` 说明 title/tag 等元数据会被持续保尾部化，本质是在保护会话资产而不是单纯优化展示。
- `sessionRestore.ts` 会在 resume 时同时接管 session ID、recording 文件名、cost state、metadata 和 worktree 绑定，说明恢复的对象是一整套资产关系，而非单一消息列表。
- `asciicast.ts` 与 `errorLogSink.ts` 又说明录屏、JSONL 错误日志、MCP 日志都被设计成会话相关资产；一旦风控窗口里把这些资产保护住，用户即使暂时不能继续运行，也仍保有恢复与自证抓手。
- 更高抽象看，用户利益保护不应只被理解成“马上继续用”，更应被理解成“在异常窗口里最大化工作连续性资产的可恢复性和可证据化”。

证据:

- `claude-code-source-code/src/utils/sessionStorage.ts:203-255`
- `claude-code-source-code/src/utils/sessionStorage.ts:694-740`
- `claude-code-source-code/src/utils/sessionRestore.ts:437-520`
- `claude-code-source-code/src/utils/asciicast.ts:12-104`
- `claude-code-source-code/src/utils/errorLogSink.ts:1-198`

### AW. A large share of support cost is really template cost

- `authStatus()` 已经能输出足够多的主体/组织/订阅信息，说明高质量求助文本所需的大部分主体状态其实已经可低成本获得。
- 前面的通知面和状态面又已经能把 local MCP failed、claude.ai connector unavailable、needs-auth 分层提示，这意味着用户如果仍只写“被封了”，问题往往不在证据缺失，而在表达模板缺失。
- 更高抽象看，很多误伤恢复效率低，并不是系统完全没有状态面，而是用户、管理员和平台支持缺少一套统一的最短高质量文本模板。

证据:

- `claude-code-source-code/src/cli/handlers/auth.ts:233-315`
- `claude-code-source-code/src/hooks/notifs/useMcpConnectivityStatus.tsx:1-88`

### AX. China-facing access ecology should be analyzed with explicit epistemic boundaries

- Anthropic 官方支持国家/地区页面当前未列出中国大陆，Claude Code 相关文档又明确要求互联网连接完成认证和 AI 处理，并支持 Claude.ai、API、Bedrock、Vertex 等官方路径；这解释了中国用户面临的基础接入摩擦不是单一网络问题，而是入口层摩擦。
- Anthropic 官方还公开写了第三方 LLM gateway / proxy 的集成文档，这说明“兼容入口”是被产品面显式考虑过的接入形态，但不等于任何第三方入口都与官方全链路能力等价。
- AnyRouter 自身公开文档明确把自己定位为 Claude Code 中转/API 转发入口，强调国内直连、免费额度、无信用卡门槛，并公开展示基于 `ANTHROPIC_BASE_URL` 的使用方式。
- AnyRouter FAQ 还公开承认 `claude --offline` 的相关检查主要看 Google 连通性，且 `fetch` 仍依赖 Claude 国际版服务，说明第三方兼容入口重写的是部分接入面，而不是整个官方能力面。
- 公开社区材料能够支持“中转站/兼容代理是中国用户常见实际使用方式”这一观察，但不能自动推出某个具体幕后公司关系。
- 截至当前检索到的公开资料，我未找到足够可靠证据证明 AnyRouter 与智谱存在明确控制/运营关系；这类说法应保持在“未证实传闻”或“一般性战略推演”层面。
- 智谱官网公开材料能够支持另一类更稳健的推断：其确实高度重视 coding/agentic workflow、API 平台、agent 产品和开发者流量，并使用大规模 token 激励；但这与 AnyRouter 的具体归属关系不是同一层事实。
- Claude Code 源码还能进一步校正认知边界：客户端虽支持 `ANTHROPIC_BASE_URL`，但会显式区分第一方 Anthropic host 与第三方 host；工具搜索、流式接口、Remote Control、OAuth 上传/附件、远程托管设置等能力都表明第三方兼容入口通常只能部分重写接入问题，不能自动等价官方全链路。

证据:

- `https://www.anthropic.com/supported-countries`
- `https://docs.anthropic.com/zh-CN/docs/claude-code/setup`
- `https://docs.anthropic.com/zh-TW/docs/claude-code/third-party-integrations`
- `https://docs.anthropic.com/zh-CN/docs/claude-code/amazon-bedrock`
- `https://docs.anyrouter.top/`
- `https://www.whois.com/whois/anyrouter.top`
- `https://www.zhipuai.cn/zh`
- `claude-code-source-code/src/utils/preflightChecks.tsx:19-21`
- `claude-code-source-code/src/utils/preflightChecks.tsx:130-130`
- `claude-code-source-code/src/utils/apiPreconnect.ts:56-60`
- `claude-code-source-code/src/services/api/filesApi.ts:30-36`
- `claude-code-source-code/src/utils/model/providers.ts:21-36`
- `claude-code-source-code/src/utils/toolSearch.ts:282-307`
- `claude-code-source-code/src/services/api/claude.ts:2607-2618`
- `claude-code-source-code/src/bridge/bridgeEnabled.ts:19-23`
- `claude-code-source-code/src/utils/auth.ts:1611-1616`
- `claude-code-source-code/src/tools/BriefTool/upload.ts:121-122`
- `claude-code-source-code/src/bridge/inboundAttachments.ts:77-83`
- `claude-code-source-code/src/services/remoteManagedSettings/index.ts:188-201`

## 本轮输出

- 已建立蓝皮书主索引
- 已写四个核心章节初稿
- 已把“公开能力 vs gated/incomplete 能力”单独拆章，避免误导
- 已补“功能全景与 API 支持”主线章节
- 已补命令矩阵、SDK 控制协议、MCP/远程传输三篇接口文档
- 已补第一性原理与苏格拉底反思章节，以及内部迭代准则
- 已补 REPL、权限状态机、上下文压缩恢复链三篇架构深挖
- 已补 SDK 消息字典、控制请求矩阵、上下文经济学、安全观四篇专题文档
- 已补 PromptInput/消息渲染链、内置命令域索引、产品实验与演化方法
- 已补 `services/compact/*` 细拆、命令字段与可用性索引、构建期开关/运行期开关/兼容层专题
- 已补工具协议与 `ToolUseContext`、会话存储/记忆/回溯状态面、状态优先于对话三篇专题
- 已补会话与状态 API 手册，明确区分 SDK 文档化接口与当前提取实现边界
- 已补 AgentTool 与隔离编排专题，把 fork/background/worktree/remote 收拢成统一编排面
- 已补“隔离优先于并发”专题，并把第一性原理阅读路径显式映射到目录
- 已补扩展 Frontmatter 与插件 Agent 手册，把 skills / agents / plugins / manifest 收拢成统一扩展面
- 已补权限系统全链路与 Auto Mode 细拆，把 mode、rule、classifier、headless fallback 串成完整状态机
- 已补“统一配置语言优于扩展孤岛”专题，并把扩展面提升为单独阅读链
- 已补 `SDKMessageSchema` 与事件流手册，把 SDK 从“答案流”纠正为“runtime event stream”
- 已补 MCP 配置与连接状态机，把 scope、transport、connection state、control surface 收拢成统一连接平面
- 已补 Claude API 与流式工具执行专题，把 query loop、stream parser、tool executor、fallback、recovery 串成完整执行链
- 已同步更新主索引、API/架构 README、章节规划、证据索引、长期记忆与反思准则
- 已补 `StructuredIO` 与 `RemoteIO` 宿主协议手册，把 host-facing control protocol 做成单独 API 章节
- 已补 `StructuredIO` 与 `RemoteIO` 控制平面专题，把 request correlation、cancel、duplicate/orphan、防乱序与远程 transport 串成完整架构链
- 已补“宿主控制平面优于聊天外壳”专题，把 Claude Code 从 terminal shell 视角提升为 host-integrated runtime
- 已把 `bluebook/` 目录进一步收紧为宿主链、事件链、连接链、策略链、会话链、协作链六条阅读线
- 已补 control subtype 与宿主适配矩阵，明确区分 schema 全集与宿主子集
- 已补 bridge / direct-connect / remote-session 的适配器分层专题，明确 bridge 是中等宽度控制面而不是薄 websocket wrapper
- 已补“协议全集不等于适配器子集”专题，把这条边界上升为正式写作原则
- 已把 `bluebook/` 目录进一步扩展为宿主链、适配器链、事件链、连接链、策略链、会话链、协作链七条阅读线
- 已补 control protocol 字段级对照与最小宿主接入样例，补强 request/response 封套与 payload 字段支持
- 已补宿主路径时序与竞速专题，把本地 host、bridge、direct-connect、remote-session 四条链收拢成统一时序视角
- 已补“显式失败优于假成功”专题，把 explicit error / cancel / reject 提升为 Agent runtime 的正式设计原则
- 已把 `bluebook/` 目录进一步扩展为宿主链、适配器链、时序链、事件链、连接链、策略链、会话链、协作链八条阅读线
- 已补 SDK 消息与 Control 闭环对照表，把 request / response / follow-on SDKMessage 串成闭环视角
- 已补远程恢复与重连状态机，把 `4001` / `4003` / `401` / epoch rebuild / worker_status 回写收拢成分层恢复模型
- 已补“闭环状态机优于单向请求”专题，把 Claude Code 从宿主控制面进一步提升为 control-loop runtime
- 已把 `bluebook/` 目录进一步扩展为宿主链、适配器链、时序链、闭环链、事件链、连接链、策略链、会话链、协作链九条阅读线
- 已补状态消息、外部元数据与宿主消费矩阵，把 `SDKMessage`、`worker_status`、`external_metadata` 与 consumer subset 放到同一张 API 图里
- 已补双通道状态同步与外部元数据回写专题，把事件时间线与状态快照回写收拢成统一架构图
- 已补“外化状态优于推断状态”专题，把宿主真相从“自己猜”提升为“主动外化”
- 已把 `bluebook/` 目录进一步扩展为状态同步链，并把“真相面”加入第一性原理阅读路径
- 已补系统提示词、Frontmatter 与上下文注入手册，把 CLI / SDK / agent / skill / attachment prompt surface 收拢成统一 API 面
- 已补提示词装配链与上下文成形专题，把 prompt 魔力从“文案”上升为装配链、角色合同与 cache 稳定性
- 已补安全分层、策略收口与沙箱边界专题，把 trust、policy、sandbox、SSRF、MCP auth 收拢成统一安全架构
- 已补源码质量、分层与工程先进性专题，把 query turn state、Tool ABI、schema/cache/retry 结构化为工程质量主线
- 已补消息塑形、输出外置与 Token 经济专题，把 message shaping、tool result budget、deferred delta、compact 顺序收拢成统一上下文经济链
- 已补“提示词魔力来自运行时而非咒语”和“工程化质量优于聪明技巧”两篇哲学专题
- 已把 `bluebook/` 目录进一步扩展为 Prompt 链、安全链、工程链、上下文链
- 已补提示词控制、知识注入与记忆 API 手册，把 CLI / SDK initialize / `CLAUDE.md` / typed memory / attachment surface 放到同一层
- 已补插件、Marketplace、MCPB、LSP、channels 接入边界手册，把格式支持、产品边界、信任与治理模型显式拆开
- 已补提示词契约分层、知识层栈、多 Agent 任务对象三篇架构专题，把 prompt contract、knowledge stack、task/mailbox runtime 从主线下沉为机制专题
- 已补 `CLAUDE.md`、记忆层与上下文注入实践指南，把规则层、长期记忆、会话连续性、临时 prompt 约束的使用边界写成实战路径
- 已补“Prompt 不是文本技巧而是契约分层”“安全与 Token 经济不是权衡而是同一优化”“生态成熟度必须与协议支持分开叙述”三篇哲学专题
- 已把 `bluebook/` 主线继续提升为“运行时契约、知识层与生态边界”，并把目录阅读链扩展为契约链、知识链、安全经济链、协作运行时链、生态边界链
- 已补风控专题 `24-信号融合、连续性断裂与“像被封了”的生成机制`，把资格、组织、设备、授权、计费、诊断信号如何压缩成封号体感单独抽成一章
- 已补风控专题 `25-问题导向索引：按症状、源码入口与合规动作阅读风控专题`，把症状、章节、源码入口、支持路径与 `risk/` 的问题主线压到同一张检索页
- 已补风控专题 `27-判定非对称性矩阵：哪些路径要快放行，哪些路径必须硬收口`，把 selective failure semantics 从设计哲学下沉成工程对照表
- 已补风控专题 `26-苏格拉底附录：如果要把误伤再降一半，系统该追问什么`，把平台改进、研究方法反思与用户自保标准提升到“总伤害最小化”视角
- 已补风控专题 `41-连续性成本最小化：把合规自保从故障窗口扩展到日常操作纪律`，把分钟级故障纪律上升到日级、周级的连续性成本管理
- 已补风控专题 `42-风控最小公理与反公理：从第一性原理重写控制面哲学`，把散点机制压缩成持续证明、分层放权、受控恢复的最小原则集
- 已补风控专题 `43-支持联动附录：按症状、证明链、归属方与证据面快速分流`，把用户、管理员、平台支持的分流规则和证据面合并成一张运行手册
- 已补风控专题 `44-仓库不是可信主体：从权限优先级到托管收口的信任边界`，把权限顺序、托管收口和项目不可信原则收束成同一套信任模型
- 已补风控专题 `45-认证连续性工程：缓存、锁、密钥链与为什么不要乱换登录路径`，把认证问题从“登录成功/失败”提升为多缓存、多进程的连续性工程
- 已补风控专题 `46-冻结语义与单链恢复：为什么故障窗口越乱试越像被封了`，把恢复问题从“多试几次”提升为单链、一致性和前缀稳定问题
- 已补风控专题 `47-高波动环境用户的合规权益保护：如何降低误伤并缩短自证路径`，把中国/高波动环境用户的利益保护收束成稳定主路径、证据保全和共享词汇三条主线
- 已补风控专题 `48-身份路径绑定：配置根、托管环境与组织闭锁为什么必须一致`，把 config root、storage slot、managed context 与 forceLoginOrg 收束成同一条身份路径模型
- 已补风控专题 `49-检测先进性再评估：风控不是规则堆积，而是观测驱动的分布式控制平面`，把高级性从“gate 很多”提升为“观测-恢复-判定一体化控制面”
- 已补风控专题 `50-损失函数视角：平台究竟在最小化什么，而用户又在失去什么`，把 fail-open、fail-closed、cooldown 与误伤统一翻译成多目标损失平衡
- 已补风控专题 `51-批准链分析：谁有资格替用户说“可以”，以及这本身为何是风控问题`，把权限批准、替代审批面和 allowlist 收束成正式信任边界
- 已补风控专题 `52-局部撤权优于全局封号：能力撤回、连接降级与主体保全的治理哲学`，把大量“像封号”的体验重新分层为连接、能力、时间窗口和自扩权力撤回
- 已补风控专题 `53-高波动环境严格运行SOP：从日常纪律到升级求助的四阶段手册`，把中国/高波动环境用户的合规建议压成可执行顺序
- 已补风控专题 `54-如果要把误伤再降一半：平台必须把哪些现有能力前置成产品`，把改进重点从“再加 gate”转向“统一状态面、证据面和升级面”
- 已补风控专题 `55-后期研究索引：41-54的二级导航、问题入口与最短阅读链`，把后期高密度章节拆成四条二级主线，改善检索结构
- 已补风控专题 `56-反规避原则：为什么任何绕过思路都会回到更高风险与更高证明负担`，把“规避冲动”改写为第一性原理层面的反规避论证
- 已补风控专题 `57-终局总指南：Claude Code风控研究的最佳最全合规版`，把后期全部研究压缩成一份面向用户和平台构建者的终局合规总结
- 已补风控专题 `58-治理主权与恢复主动权：谁能关、谁能开、谁能替你说 yes`，把平台、组织、用户、替代批准面和自动恢复主权收束成一张主权图
- 已补风控专题 `59-资产保全与退出策略：账号风控窗口里真正该保护的不是面子而是工作连续性`，把用户利益保护进一步压缩成 transcript、日志、录屏和 worktree 资产保全逻辑
- 已补风控专题 `60-结构化求助模板库：用户、管理员与平台支持的最短高质量文本`，把状态面和分流逻辑转化成可直接复制的高质量求助文本
- 已补风控专题 `61-中国用户使用生态与认识论边界：官方路径、中转站与幕后叙事该如何判断`，把官方门槛、AnyRouter 这类中转站、以及 AnyRouter/智谱 关系的证据边界明确分层
- Anthropic 官方 settings 文档进一步确认了用户、项目、本地、managed 四层设置作用域；其中 `.claude/settings.local.json` 是 gitignored 的个人项目覆盖层，而 `cleanupPeriodDays` 默认 30 天、设为 `0` 会禁用会话持久性并让 `/resume` 失效，这对退出策略和本地证据保全非常关键。
- Anthropic 官方 data usage / monitoring 文档进一步确认：Statsig、Sentry、`/bug`、会话质量调查都存在显式开关；同时 OTel 可以导出 `session.id`、`organization.id`、`user.account_uuid` 和 `claude_code.cost.usage` 等指标，说明用户的隐私最小化与支持可解释性之间确实存在张力。
- Anthropic 官方 costs 文档进一步确认了 `/cost`、团队成本管理与正式支持路径的重要性；从用户利益保护角度看，一个缺少标准化成本面和正式支持面的中转入口，应被视为更高的沉没成本风险源，而不是单纯“更便宜”。
- 源码进一步确认 `ANTHROPIC_BASE_URL` 依赖不仅存在于 env，还会进入 settings / worktree 传播面；`worktree.ts` 会复制 `settings.local.json`，这意味着中转站依赖一旦写入 local settings，可能沿 worktree 扩散，退出时必须做本地配置清点，而不能只删一个 shell 变量。
- 已补风控专题 `62-中国用户利益保护与中转站退出策略：把接入便利转化为可控退出权`，把本地资产主权、成本止损、worktree 配置扩散、组织监控证据和 staged exit 收束成单独一章
- 截至 2026 年 4 月 2 日再次核对 Anthropic 官方 supported countries 与 setup / llm gateway 文档后可以更明确地写：对中国用户而言，Claude Code 的困难不是单一网络问题，而是地区边界、资格边界、在线运行时边界和支持边界的叠加；而 gateway / proxy 作为架构形态本身是被官方文档承认的，但这不等于对任何具体 relay 背书。
- 截至 2026 年 4 月 2 日核对 AnyRouter 公开文档与 WHOIS 后可以更明确地写：AnyRouter 公开卖点确实集中在“国内直连、免费额度、无需信用卡、Claude Code 兼容”，说明它卖的是低摩擦接入权；但公开资料仍不足以把 AnyRouter 与智谱关系写成已证事实。
- 截至 2026 年 4 月 2 日核对智谱官方 Claude Code 文档与更新页后可以更明确地写：智谱已经公开把 Claude Code 作为目标宿主来争夺，直接提供 `ANTHROPIC_BASE_URL` / `ANTHROPIC_AUTH_TOKEN` 配置、Claude 到 GLM 的模型映射与面向 Claude Code 的价格叙事；这说明国内厂商的战略重点已经从单纯“模型替代”前移到“工作流入口竞争”。
- 源码进一步确认这种入口竞争在技术上确实可行但不等于官方等价：`providers.ts` 区分 first-party 与第三方 host，`toolSearch.ts` 明确提示很多 `ANTHROPIC_BASE_URL` 代理不支持 `tool_reference`，`auth.ts` 对第一方账号信息有单独语义，说明兼容入口更准确的产品定义是“部分等价的工作流接入层”而不是“完整官方替身”。
- 已补风控专题 `63-中国用户为什么在买入口而不是买模型：Claude Code 的地区摩擦、兼容层补贴与工作流争夺`，把中国用户困难、AnyRouter 这类中转站、智谱公开 Claude-compatible 战略、以及补贴兼容入口背后的入口争夺哲学压成独立一章
- 继续加深第 `63` 章后，可以更稳地把两个技术结论写实：AnyRouter FAQ 已经说明 relay 只能重写部分外部依赖，不能自动抹平 Google 连通性和网页 Fetch 等前置条件；`bridgeEnabled.ts` 又进一步证明 gateway deployment 与 claude.ai OAuth entitlement 不等价，因此“兼容入口”最准确的定义是“接入层与工作流层的部分替身”，不是完整第一方等价物。
- 进一步把这一板块收尾后，可以更清楚地把“等价”拆成四层：传输层、认证层、资格层、治理层。源码已经足够支持这一点：`apiPreconnect.ts` / `filesApi.ts` / `providers.ts` 证明上游可配置是正式现实，但 `auth.ts`、`bridgeEnabled.ts`、`toolSearch.ts` 又证明第一方身份、高阶 entitlement 与 beta 能力并不会因为兼容入口存在而自动等价。
- `worktree.ts` 对 `settings.local.json` 的复制进一步说明，入口选择不是一次性临时变量，而会沉淀成 worktree 扩散面与退出成本。因此“官方直连、官方云厂商路径、第三方 gateway、国内 Claude-compatible 入口”最合适的比较框架，不是谁更像，而是谁替代了哪一层语义、又把哪一层责任重新转嫁给用户。
- 已补风控专题 `64-官方路径、云厂商路径与兼容入口的能力语义差清单：哪些只是能跑，哪些更接近等价`，作为 `61-64` 这一组“中国用户 / 中转生态 / 退出权 / 入口竞争”板块的细致收尾。
- 开始新开 `bluebook/security/` 子目录后，可以更明确地把 Claude Code 的安全性与风控拆开：风控更关心资格、撤权与误伤，安全更关心 trust、permission mode、managed env、外部能力收口与远程 entitlement 的运行时边界。
- 第一批安全专题已经落地 `security/00` 与 `security/01`：`managedEnv.ts` 说明 trust 前只允许受信来源的 env 先进入运行时，防止项目目录借 `ANTHROPIC_BASE_URL` 等变量污染宿主；`setup.ts` 说明 bypassPermissions 不是随手可开的快捷模式，而要求 sandbox / no-internet 等额外外部边界；`dangerousPatterns.ts` 与 `permissionSetup.ts` 则说明系统真正警惕的是“危险 allow rule 绕过仲裁层”，而不是能力本身存在。
- 第二批安全专题继续压实后，可以更系统地写出四条工程判断：`pathValidation.ts` 把 safety check 放在 working-dir 自动允许之前，说明安全优先于目录便利；`auth.ts` 与 `managedEnv.ts` 共同说明认证来源与配置来源都被分层治理，真正危险的是运行时语义被污染；`WebFetchTool/preapproved.ts` 把预批准 GET 域名和 sandbox 网络权限刻意分离，说明读取语义与写入语义被分别治理；`hooksConfigSnapshot.ts` 则说明 hooks 的核心问题不是脚本本身，而是谁拥有插入执行点的主权。
- `secureStorage/*` 还显示出另一条成熟设计：系统先争取 OS keychain 这类更安全介质，再在必要时降级到 plaintext，并显式告知风险；同时 `fallbackStorage.ts` 还处理了旧凭证遮蔽新凭证这一类真实运行时故障，说明它的安全设计不是抽象口号，而是具体到凭证新旧、缓存和回退顺序的工程治理。
- 最后一轮收尾后，`security/06` 已经把这组专题重新压成六条最小公理：来源先于值、仲裁先于放行、外部世界不是默认可信上下文、高阶资格不等于传输层连通、高风险便利必须由更强边界补偿、安全设计必须可解释。这样一来，`bluebook/security/` 已经形成了从方法论、机制、哲学到第一性原理反思的完整独立板块。
- 继续往细粒度手册推进后，权限链的时序已经能更明确写成状态机：`transitionPermissionMode()` 负责 plan/auto 的上下文切换、危险规则剥离与恢复；`permissions.ts` 里的 `safetyCheck` 明确高于 bypass 与大部分 fast-path；auto mode classifier 也不是唯一裁判，而是排在 acceptEdits fast-path、safe-tool allowlist 与若干 bypass-immune 条件之后的中段仲裁器。这使得 `security/07` 可以把权限系统从概念层推进到时序层。
- 再往下压后，配置与受管环境的主权结构也足够清晰：`SETTING_SOURCES` 定义了 later-overrides-earlier 的基础顺序，但 `managedEnv.ts` 又把 trust 前后 env 应用拆成两层；`managedEnvConstants.ts` 把 provider-routing 与 auth 主链变量单独列成 host-managed 风险面；`permissionsLoader.ts`、`hooksConfigSnapshot.ts` 与 `sandbox-adapter.ts` 则说明 managed-only 不只是只读，而是可以把 permission、hooks、sandbox 域与读路径这些整类安全策略重新收口。因此 `security/08` 可以把“谁能改配置”升级为“谁拥有运行时主权”。
- 把外部入口进一步压成风险矩阵后，可以更明确地区分：MCP 的主风险是上下文与工具面扩张，WebFetch 的主风险是读写语义混淆，hooks 的主风险是隐形执行点与主权冲突，gateway 的主风险则是身份/路由漂移与“兼容但不等价”的语义错觉。这样 `security/09` 不再只是重复“外部能力要收口”，而是把风险分成读取、写入、执行、身份与上下文污染五个正交维度。
- 再往产品层推进后，可以更稳地得出一个判断：系统其实已经拥有不少“安全状态面零件”，例如 `permissionExplainer.ts`、`createPermissionRequestMessage()`、`status.tsx` 对 setting sources 的呈现、`ManagedSettingsSecurityDialog`、`getBridgeDisabledReason()` 与 auto-mode gate notification；问题不在于完全没有解释层，而在于这些解释仍然分散，尚未汇成一张统一安全仪表盘。因此 `security/10` 的重点不是再描述机制，而是指出“从结构化安全到可解释安全”之间还差哪一步产品化。
- 继续把安全专题收束到平台构建者层后，可以更稳定地提炼出一组可迁移法则：来源先于值、mode 即安全语义、真正危险的是绕过仲裁层、外部能力要按攻击面建模、兼容不等于 entitlement 等价、解释层必须产品化、以及 public build 边界必须与代码边界同时治理。这样 `security/11` 不再只是总结，而是把 Claude Code 的安全性压缩成可被其他 Agent 平台直接借鉴的一组设计原则。
- 再往平台产品路线图推进后，现有源码中的零件与缺口关系也更清楚了：`Settings/Status.tsx`、`SandboxConfigTab.tsx`、`PluginSettings.tsx`、`ManagedSettingsSecurityDialog`、`permissionExplainer.ts`、`getBridgeDisabledReason()` 已经分别暴露了 setting sources、sandbox 约束、managed-only 指引、危险设置审批、权限解释和 entitlement 失败原因，但它们仍然分散在局部节点中。于是 `security/12` 可以把下一代产品化重点明确压成统一安全状态面、来源血缘、规则优先级解释、风险标签、managed-only 标识和支持证据包这类高收益改进，而不是继续堆更多零散 gate。
- 安全专题扩到 `00-12` 后，再单独补一个 `13-安全专题二级索引` 就很有必要：安全目录现在已经同时覆盖方法论、机制、状态机、主权矩阵、攻击面矩阵、可解释性和平台路线图，如果没有问题导向入口，读者很容易重新退回线性顺读。这个二级索引把专题按问题、攻击面、主权冲突、平台改进四种入口重新组织，后续继续扩充章节时也更不容易破坏整体可读性。
- 继续往“总图化”推进后，安全专题已经足够成熟，可以单独补一个 `14-安全控制面总图`：它把 trust、配置来源、permission mode、动作仲裁、环境隔离、外部入口、身份 entitlement 和解释层重新串成一条全链结构图谱。这样一来，`security/00-13` 不再只是散点深化，而能被重新压回同一张总图，作为后续继续新增章节时的参照坐标。
- 在这之后，再单独补一个 `15-来源主权总表` 就有了明确价值：`settings/settings.ts` 里的 policy first-source-wins、`managedEnv.ts` 的 host-managed provider env、`permissionsLoader.ts` / `hooksConfigSnapshot.ts` / `mcp/config.ts` / `pluginOnlyPolicy.ts` 的 managed-only 与 plugin-only 收口、以及 `managedPlugins.ts` / `marketplaceHelpers.ts` 对插件供应链主权的收束，已经足够支持一张“谁能定义、谁能覆盖、谁能最终收口”的总表。这让安全专题不只是在讲机制，而是在讲整套系统的主权编排。
- 有了总图和总表之后，再单独补一个 `16-安全反模式与反公理` 就很自然了：`shadowedRuleDetection.ts` 说明“规则写上去”不等于规则真正可达，`managedEnv.ts` 说明 project/local settings 不是随意改写主链的合法入口，`bridgeEnabled.ts` 说明兼容不等于 entitlement 等价，`validation.ts` 说明系统宁愿过滤坏规则也不让一个坏值毒化整份设置文件。把这些负面教材单独收束后，安全专题就不再只有“正面原则”，也有了一套“哪些做法会慢慢掏空边界”的反公理。
- 到这里再补一个 `17-终局总指南` 就很有价值了：安全专题已经从方法论一路扩到总图、总表、反模式和产品路线图，继续线性加章节的收益开始下降；更值得做的是把 `00-16` 压缩成一份最短、最高密度、最适合引用的终局版，让读者可以先抓全局判断，再按 `13-二级索引` 回到局部细读。
- 在终局版之后，安全专题开始适合往“检测技术内核”而不是“更大总论”推进，所以补一个 `18-安全检测技术内核` 很有价值：`dangerousPatterns.ts` / `permissionSetup.ts` 说明 Claude Code 会先审 allow rule 本身是否在绕过 classifier，`permissions.ts` 说明 `safetyCheck` 与 content-specific ask 不是可被 mode 轻易抹平的普通分支，`pathValidation.ts` 说明真正高阶的检测对象不是路径字符串，而是 shell expansion、tilde 变体、UNC、glob 与 symlink 共同形成的路径语义，`mcp/config.ts` / `mcpValidation.ts` / `preapproved.ts` / `managedEnv.ts` 则共同证明外部入口、输出预算和来源主权属于同一条更宽的检测链。
- 继续往下推，一个自然的下一章不是再堆更多机制，而是把 `18` 抽象成安全不变量，于是单独补一个 `19-安全不变量` 是合理的：Claude Code 真正在守住的并不是零散规则，而是几条更底层的约束，例如结构性危险高于模式便利、来源合法性高于配置值、语义等价高于文本等价、外部能力必须按能力语义治理、局部坏值不应毒化全局、解释层本身就是边界的一部分。把这些不变量单独写出来后，安全专题就不再只是“模块分析”，而开始有了更稳的理论骨架。
- 继续往源码内核层下钻后，可以更明确地把安全检测技术单独抽成一章：`dangerousPatterns.ts` / `permissionSetup.ts` / `permissions.ts` 说明系统先防“危险 allow rule 架空仲裁层”，`pathValidation.ts` 说明它防的不是路径复杂而是路径语义漂移，`WebFetchTool/preapproved.ts` / `mcpValidation.ts` / `services/mcp/config.ts` 说明外部入口被拆成读取、输出半径、连接定义权三类治理对象，`managedEnv.ts` / `settings.ts` / `validation.ts` / `pluginOnlyPolicy.ts` 则说明真正高风险的是低信任来源改写高风险运行时主链。因此补一个 `18-安全检测技术内核` 是有明确价值的，它把“安全控制面”进一步压成“检测链控制面”。
- 安全专题做到这里后，目录结构也应该从纯线性主目录升级成“主线 + 附录证据”：新增 `security/appendix/` 承载模块到结论的证据索引、图表和速查材料，能避免主目录继续无限拉长，也更符合后续继续做图谱化、表格化和证据化维护的方向。
- 在此基础上，再补一页 `appendix/02-安全检测速查表` 也很有价值：它把“风险对象 -> 检测模块 -> 第一硬拦截层 -> classifier 是否能替代 -> 最短结论”压成一张表，能明显降低后续继续扩写时对长文主线的反复跳转成本，也让 `security/18` 的高密度结论更适合被检索和引用。
- 当 `18-安全检测技术内核` 和 `19-安全不变量` 都成形后，再补一个 `20-边界失真理论` 就很自然了：这时安全专题已经不缺模块级证据，也不缺约束级总结，真正缺的是更高一层的统一解释。把规则失真、指称失真、主权失真、接口失真和解释失真压进同一套理论之后，`dangerousPatterns.ts`、`pathValidation.ts`、`managedEnv.ts`、`mcp/config.ts`、`permissionExplainer.ts` 这些原本分散的模块，就不再只是“不同文件里的不同检测”，而能被理解成同一条边界传递链上的不同修复点。这样 `security/20` 不重复技术细节，而是把整个安全专题推进到真正的本体论层。
- 有了 `18/19/20` 这三层之后，再补一个 `appendix/03-边界失真速查表` 的价值就很明确了：安全主线已经同时覆盖“检测链”“不变量”“失真理论”，但如果没有一张把三者压回同一视图的表，后续引用时仍然需要在三个章节之间来回跳转。把“失真类型 -> 被破坏的不变量 -> 主要检测模块 -> 第一硬拦截层 -> 用户症状”放进同一张表后，安全专题就第一次拥有了从源码、原则到用户感知的统一索引面。
- 继续往源码里的状态面下钻后，可以更明确地把 `21-安全状态面源码解剖` 单独写出来：`utils/status.tsx` 与 `components/Settings/Status.tsx` 说明系统已经有总览型摘要，但主要展示结果状态而不是因果图；`remoteManagedSettings/securityCheck.tsx` 与 `ManagedSettingsSecurityDialog.tsx` 说明高风险 managed 变更已经被做成阻断式增量审批；`SandboxConfigTab.tsx` 说明执行包络已有深度可见性；`PluginSettings.tsx` 说明插件错误已经能按来源与控制主体分流；`bridge/bridgeEnabled.ts` 说明 entitlement 失败已经被解释成分步骤证明链。这样一来，安全专题就可以更稳地提出一个源码级结论：系统并不缺安全状态零件，缺的是把主体、主权、包络、外部入口和资格链汇成统一控制台的联结层。
- 在 `21-安全状态面源码解剖` 之后，再补一页 `appendix/04-安全状态面速查表` 也很有价值：长文已经解释了为什么状态面碎片化是结构问题，但如果没有一张“视图 -> 当前暴露事实 -> 缺失因果 -> 最短跳转”的表，后续引用时还是得重新读整章。把 `Status`、managed dialog、sandbox tab、plugin settings、bridge reason 这些现有视图压进一张表后，安全专题第一次能从“用户现在看到哪个界面”直接反推“系统现在暴露的是哪一类安全事实”。
- 再往前走一步后，可以更明确地把 `22-安全证明链` 单独写出来：前面章节已经分别解释了检测链、不变量、边界失真和状态面碎片，但真正还没有被显式命名的是“系统凭什么认为当前可安全执行”。把主体链、主权链、授权链、包络链、外部能力链和增量审批链压成同一套证明结构后，`permissions.ts`、`pathValidation.ts`、`managedEnv.ts`、`mcp/config.ts`、`bridgeEnabled.ts`、`securityCheck.tsx` 这些模块就不再只是不同层的防线，而会被重新理解成同一条安全证明系统的不同证明节点。这样安全专题就从“控制面”推进到了“可证明性控制面”。
- 有了 `22-安全证明链` 之后，再补一个 `appendix/05-安全证明链速查表` 也就顺理成章：长文已经解释了六条证明链是什么，但实际检索时仍然需要快速回答“这条链在证明什么、关键问题是什么、断了以后会怎样”。把六条链压进同一张矩阵后，安全专题第一次能从“哪条证明链失效”直接回到源码入口、失效后果和用户侧症状，这让后续继续做状态图、术语表或控制台设计时都有了更稳定的索引基面。
- 在此基础上，再补一页 `appendix/06-统一安全控制台总图` 也很自然：`21` 已经解释了状态面为何碎片化，`22` 已经解释了系统为何需要六条证明链，但如果后续要真正讨论“下一代统一安全控制台长什么样”，还需要一张把主体、主权、仲裁、包络、外部能力、增量审批和状态投影全部压到同一页的总图。这样安全专题就第一次同时拥有了长文、矩阵和单页结构图三种表达层级。
- 当 `21/22` 都成立后，再补一个 `23-统一安全控制台字段设计` 就有了明确价值：前面章节已经说明系统为什么需要统一控制台，也说明了统一控制台最少该有哪些面，但还没有回答“字段到底从哪里来”。`AppStateStore.ts` 已经保留了 bridge、mcp、plugins、toolPermissionContext 等大量状态字段，`coreSchemas.ts` 又把 status/auth_status/mcp status 拆成多条结构化消息，`types/permissions.ts` 还定义了非常丰富的 `PermissionDecisionReason` 枚举。这说明系统并不缺字段，缺的是按安全语义进行字段归一化和派生解释。因此 `23` 的意义，是把安全专题从“控制面图”进一步推进到“控制台数据模型图”。
- 在 `23-统一安全控制台字段设计` 之后，再补一个 `appendix/07-统一安全控制台字段速查表` 也很有价值：长文已经解释字段分组与缺口，但实际实现阶段更需要一张“字段组 -> 现有来源 -> 缺失派生字段 -> 展示层级”的矩阵。把这些内容压成一页后，后续无论是继续写控制台卡片设计、诊断路径，还是回到源码补字段，都有了直接可操作的实现索引。
- 再往前走一步后，再补一个 `appendix/08-统一安全控制台卡片速查表` 也就顺理成章：`24` 已经解释了为什么控制台应由七张卡片组成，但实现时仍需要一张更短的卡片矩阵，直接回答“这张卡主导哪条证明链、默认回答什么问题、该给什么动作”。这样安全专题就把统一控制台从长文概念、单页总图、字段模型一路推进到了真正可执行的卡片级信息架构。
- 再往前推进一步后，可以更明确地把 `24-统一安全控制台卡片设计` 单独写出来：`23` 已经解释了控制台需要哪些字段组，但产品实现并不会直接渲染字段表，而会渲染卡片、摘要块和诊断块。结合 `AppStateStore.ts`、`coreSchemas.ts`、`types/permissions.ts`、`sdkMessageAdapter.ts` 这些源码，可以更稳地得出一个结论：当前最大的瓶颈不是采集不到字段，而是结构化状态在宿主适配层被过早压扁，导致后续控制台必须重新猜测因果。因此 `24` 的核心价值，是把“字段设计”推进成“卡片设计”，并明确断链诊断卡才是真正的统一控制台心脏。
- 再往前推进一步后，可以更明确地把 `25-统一安全控制台最短诊断路径` 单独写出来：`24` 已经说明控制台应由哪几张卡组成，但一张控制台如果不能把用户带到最短动作，就仍然只是更漂亮的观察面。`controlSchemas.ts` 已经暴露出 `mcp_status`、`reload_plugins`、`mcp_reconnect`、`mcp_toggle`、`get_settings`、`apply_flag_settings` 这些控制动作；`remoteManagedSettings/index.ts` 又说明 managed settings 已经拥有“审批 -> 应用 / 回退”的闭环；`sdkMessageAdapter.ts` 则反过来暴露出一个关键缺口：结构化状态在宿主适配层被过早压成文本或直接丢弃。这样一来，`25` 的核心价值就很明确了：把控制台从“状态面 + 解释面”推进成“状态 -> 断链 -> 动作 -> 回读验证”的行动型控制面。
- 在 `25-统一安全控制台最短诊断路径` 之后，再补一个 `appendix/09-统一安全控制台最短诊断速查表` 也很自然：长文已经解释了四段闭环，但实现和产品讨论时往往更需要一张“当前状态 -> 断裂证明链 -> 最短动作 -> 默认回读验证”的矩阵。把 bridge、主权、仲裁、包络、外部能力、增量审批这几类典型路径压进一页后，安全专题就第一次拥有了可直接拿来做诊断路由和交互流程设计的最短动作表。
- 继续往前推进后，可以更明确地把 `26-统一安全控制台交互状态机` 单独写出来：`25` 已经解决了“状态 -> 断链 -> 动作 -> 回读”的最短闭环，但还没有回答这些对象怎样跨页面、跨宿主保持同一条因果链。`controlSchemas.ts` 说明协议层动作和回读源已经够用，`sdkMessageAdapter.ts` 又说明 `status` 会被压成薄文本、`auth_status` 甚至会被直接忽略，`bridgeStatusUtil.ts` 与 `PromptInputFooter.tsx` 则说明 bridge 状态目前主要被做成 footer pill 而不是控制对象。相对地，`remoteManagedSettings/index.ts` 与 `securityCheck.tsx` 已经展示了真正成熟的交互链条：拉取、判定、审批、应用或回退、热刷新。因此 `26` 的核心结论不是“再做一页 UI”，而是下一代统一安全控制台必须先统一交互状态机与宿主适配契约。
- 在 `26-统一安全控制台交互状态机` 之后，再补一个 `appendix/10-统一安全控制台交互速查表` 就很自然了：长文已经把页面切换、动作触发、刷新回读、验证和升级压成六段状态机，但实现和评审时仍然需要一张更短的交互矩阵。把六段状态、三类典型动作绑定、默认刷新源和宿主保真底线放进一页后，安全专题第一次拥有了可以直接拿来做产品评审、协议对齐和宿主降级检查的最小交互契约表。
- 继续往前推进后，可以更明确地把 `27-安全对象协议` 单独写出来：`26` 已经指出统一控制台离落地只差交互状态机与宿主适配契约，但还没有回答“宿主之间到底在传什么”。`coreSchemas.ts` 说明协议层本来就有 `status`、`auth_status`、`post_turn_summary`、`tool_progress` 这类结构化对象；`AppStateStore.ts` 也已经保留了 `toolPermissionContext`、bridge 多字段、`mcp.clients`、plugin errors 等对象槽位；真正的问题出在 `sdkMessageAdapter.ts` 与 `bridgeMessaging.ts` 这类边界层，它们会把对象压成文本、缩成子集或直接忽略。因此 `27` 的核心结论是：统一安全控制台下一步最该做的不是新页面，而是先把“哪些安全对象必须跨宿主保真、哪些允许显式降级”写成正式协议。
- 在 `27-安全对象协议` 之后，再补一个 `appendix/11-安全对象协议速查表` 就很自然了：长文已经把主体、主权、授权、包络、外部能力和交互证明六类对象说清楚，但实现和评审时仍需要一张更短的对象矩阵。把对象族、协议来源、宿主槽位、常见压扁点和最低降级规则压进一页后，安全专题就第一次拥有了可直接用于宿主接入评审和对象保真检查的对象级索引表。
- 继续往前推进后，可以更明确地把 `28-显式降级理论` 单独写出来：`27` 已经说明安全控制台必须先有对象协议，但还没有回答“窄宿主是否天然不合格”。`DirectConnectManager.ts` 与 `RemoteSessionManager.ts` 很关键，因为它们都只正式支持 `can_use_tool` 和 `interrupt` 这一类极窄控制面，但会对其他 subtype 显式返回 error；`bridgeMessaging.ts` 则代表更宽但仍非全集的子集宿主。与此相对，真正危险的不是这些显式子集，而是 `sdkMessageAdapter.ts` 这类把对象静默压扁或忽略的路径。因此 `28` 的核心结论是：多宿主、多宽度本身不是安全问题，隐性子集才是安全问题，下一步应把“显式降级”提升成正式宿主语义。
- 在 `28-显式降级理论` 之后，再补一个 `appendix/12-宿主降级速查表` 就很自然了：长文已经把 bridge、direct connect、remote session manager 和适配层的差异解释清楚，但实现和评审时仍然需要一张更短的宿主矩阵。把宿主类型、支持子集、显式失败方式和安全风险压进一页后，安全专题就第一次拥有了直接用于宿主分级和降级风险检查的宿主级速查表。
- 继续往前推进后，可以更明确地把 `29-宿主资格等级` 单独写出来：`28` 已经解释了为什么显式降级重要，但还没有回答“宿主到底有资格承担哪一层责任”。`StructuredIO.ts` 之所以关键，不在于它接了控制消息，而在于它处理 duplicate / orphan / cancel / resolved tool_use_id 这一整套一致性问题；`RemoteIO.ts` 则更进一步，承担了 restored worker state、internal event read/write、delivery / state / metadata 回写；`remoteBridgeCore.ts` 又把 401 恢复窗口中的动作丢弃和状态回写纪律做实。相比之下，`DirectConnectManager.ts` 与 `RemoteSessionManager.ts` 更像诚实的控制宿主，而 `sdkMessageAdapter.ts` 最多只是投影型观察宿主。因此 `29` 的核心结论是：统一安全控制台不该再只区分“完整/不完整宿主”，而应正式区分观察宿主、控制宿主与证明宿主。
- 在 `29-宿主资格等级` 之后，再补一个 `appendix/13-宿主资格速查表` 就很自然了：长文已经把观察、控制、证明三层责任说清楚，但实现评审时仍然需要一张更短的资格矩阵。把三层资格、最低责任、典型实现和“不能声称什么”压进一页后，安全专题就第一次拥有了可以直接拿来做宿主标注和资格审计的责任级速查表。
- 继续往前推进后，可以更明确地把 `30-安全真相源层级` 单独写出来：`29` 已经说明不同宿主承担的责任不同，但还没有回答“它们到底在依赖哪一层真相”。`sessionState.ts` 已经把 requires_action 真相拆成 typed details 和 `external_metadata.pending_action` 两条路径；`WorkerStateUploader.ts` 又明确告诉我们 `worker_status` 与 `external_metadata` 是一层 mergeable、可重试、可复制的 worker 真相，而不是原始事件本体；`ccrClient.ts` 则负责 init 时清 stale metadata、读回 worker state，并持续 reportState/reportMetadata；`onChangeAppState.ts` 和 `print.ts` 再把复制真相灌回本地交互真相。这使得 `30` 的核心结论很清楚：安全控制面真正要治理的，不只是对象和宿主，还是真相层级本身，任何单一表面都不能冒充全部安全真相。
- 在 `30-安全真相源层级` 之后，再补一个 `appendix/14-安全真相源速查表` 就很自然了：长文已经把实时真相、语义真相、复制真相、本地真相和 UI 投影五层关系说清楚，但实际实现和评审时仍然需要一张更短的真相矩阵。把五层真相、各自回答的问题、优势、局限和最常见误读压进一页后，安全专题就第一次拥有了可以直接用于真相源辨识和误读校正的层级速查表。
- 继续往前推进后，可以更明确地把 `31-安全真相仲裁` 单独写出来：`30` 已经说明真相必须分层，但还没有回答“冲突时谁说了算”。`print.ts` 明确要求 restore 与 hydrate 并行等待，避免 SSE catchup 落在 fresh default 上；`coreSchemas.ts` 与 `sdkEventQueue.ts` 又把 `session_state_changed(idle)` 直接命名为 authoritative turn-over signal；`WorkerStateUploader.ts` 与 `ccrClient.ts` 则说明复制层接受延迟一致，但不接受 stale crash residue；`onChangeAppState.ts` 进一步表明本地状态必须经统一 choke point 才能升级成外部真相。这使得 `31` 的核心结论很清楚：多层真相如果没有优先级，就只是多份意见，真正成熟的安全控制面必须明确恢复顺序、语义事件、复制清理、本地镜像和 UI 跟随之间的仲裁规则。
- 在 `31-安全真相仲裁` 之后，再补一个 `appendix/15-安全真相仲裁速查表` 就很自然了：长文已经把恢复优先级、语义优先级、复制清理、本地镜像和 UI 无仲裁权说清楚，但实现和评审时仍需要一张更短的冲突矩阵。把冲突场景、胜出真相、败方不能赢的原因和禁止误读压进一页后，安全专题就第一次拥有了可直接用于仲裁检查和冲突排障的真相优先级速查表。
- 继续往前推进后，可以更明确地把 `32-安全裂脑防御` 单独写出来：`31` 已经回答了真相冲突时谁优先，但还没有解释为什么源码里会反复出现单一 choke point、镜像、去重、清理和恢复串行化。`onChangeAppState.ts` 与 `sessionState.ts` 已经把 mode 和语义状态更新收口成单一出口；`StructuredIO.ts` 直接把 duplicate / orphan response 视为一等问题；`ccrClient.ts` 会在 init 时清 stale `pending_action` / `task_summary`；`remoteBridgeCore.ts` 又通过 `authRecoveryInFlight`、flushGate 和 stale transport 守卫避免双重 /bridge fetch、stale epoch 和 silent message loss。这使得 `32` 的核心结论很清楚：Claude Code 的深层安全性不只是边界收口，也是一套反裂脑工程，它真正持续在防的是同一安全事实在不同层或不同时刻长成两份互相打架的真相。
- 在 `32-安全裂脑防御` 之后，再补一个 `appendix/16-安全裂脑速查表` 就很自然了：长文已经把 mode 分叉、pending_action 分叉、duplicate response、crash residue 和并发恢复这些裂脑场景讲清楚，但实现和评审时仍然需要一张更短的裂脑矩阵。把分叉场景、收口闸门、镜像链、守卫策略和失效后果压进一页后，安全专题就第一次拥有了可直接用于反裂脑代码审计和改动评审的高风险场景表。
- 继续往前推进后，可以更明确地把 `33-安全单写者原则` 单独写出来：`32` 已经解释了系统为什么持续防裂脑，但还没有把更底层的设计公理点破。`onChangeAppState.ts` 与 `sessionState.ts` 已经把关键语义更新收口成单一出口；`StructuredIO.ts` 直接声明 outbound drain loop 是 only writer；`WorkerStateUploader.ts` 又把 worker 真相写入约束成 1 in-flight + 1 pending、top-level last value wins；`AppStateStore.ts` 甚至在能力状态上直接写出 single source of truth。这使得 `33` 的核心结论很清楚：Claude Code 很多高质量安全实现，真正共同依赖的不是“再加同步”，而是先决定谁有资格成为关键安全事实的唯一作者，其余层只能镜像、恢复或投影。
- 在 `33-安全单写者原则` 之后，再补一个 `appendix/17-安全单写者速查表` 就很自然了：长文已经把 mode 外化、会话语义、outbound 顺序、worker 复制真相、资格布尔量和恢复路径这些“唯一作者”讲清楚，但实现和评审时仍然需要一张更短的作者权矩阵。把关键事实、正式作者、合法镜像层与越权后果压进一页后，安全专题就第一次拥有了可直接用于检查“某层是不是在偷偷变成第二作者”的改动审查表。
- 继续往前推进后，可以更明确地把 `34-安全提交语义` 单独写出来：`33` 已经回答了“谁有资格写”，但还没有回答“什么时候算真的写成”。`sessionState.ts` 已经把本地语义、metadata 镜像和 SDK 事件拆成不同层；`WorkerStateUploader.ts` 与 `ccrClient.ts` 又把 enqueue、PUT 成功、恢复读取和 init 注册分开；`print.ts` 进一步把 result 可见性、`heldBackResult`、`flushInternalEvents()` 与 `idle` turn-over 顺序明确排好；`sessionStorage.ts` 则表明 resume 依赖 internal events 账本而不是普通可见事件。这使得 `34` 的核心结论很清楚：Claude Code 的深层安全性不只治理写权限，还治理提交边界，它不允许“本地已改”“远端已见”“持久化已落”和“恢复可重建”被误写成同一个词。
- 在 `34-安全提交语义` 之后，再补一个 `appendix/18-安全提交边界速查表` 也很自然：长文已经把语义、复制、可见、持久和恢复五层提交讲清楚，但实现和评审时仍需要一张更短的边界矩阵。把“哪一层算提交、哪一层还不算、源码入口和最危险误读”压进一页后，安全专题就第一次拥有了可直接用于提交边界审查的五层检查表。
- 继续往前推进后，可以更明确地把 `35-安全多账本原则` 单独写出来：`34` 已经回答了“哪一层算提交”，但还没有回答“为什么这些层不能共用同一本账”。`sessionState.ts` 先维护语义账本，再把状态镜像给 metadata 与 SDK event；`ccrClient.ts` 明确区分 `reportState/reportMetadata`、`writeEvent(...)` 与 `writeInternalEvent(...)`，分别服务复制账、可见账与恢复账；`print.ts` 在 going idle 前先 flush internal events；`sessionStorage.ts` 的 `hydrateFromCCRv2InternalEvents(...)` 又说明 resume 读取的是恢复账而不是普通前端事件。这使得 `35` 的核心结论很清楚：Claude Code 的深层安全性不只是多层提交边界，更是多账本结构，每一本账都服务不同读者、不同边界和不同误判成本。
- 在 `35-安全多账本原则` 之后，再补一个 `appendix/19-安全多账本速查表` 就很自然了：长文已经把语义账、复制账、可见账与恢复账的职责差别讲清楚，但实现和评审时仍然需要一张更短的账本矩阵。把每本账的主要读者、主要写入口、提交边界与误判成本压进一页后，安全专题就第一次拥有了可直接用于回答“这个读者到底该信哪一本账”的速查表。
- 继续往前推进后，可以更明确地把 `36-安全账本投影原则` 单独写出来：`35` 已经回答了“为什么有多本账”，但还没有回答“为什么不同宿主不可能都看到全部账”。`coreSchemas.ts` 与 `controlSchemas.ts` 先给出宽协议全集；`StructuredIO.ts` 则明确默认宿主没有恢复账与 internal-event flush；`RemoteIO.ts` 通过 `CCRClient`、internal event reader/writer、`reportState/reportMetadata` 和 `restoredWorkerState` 拿到更厚的投影；`DirectConnectManager.ts` 与 `RemoteSessionManager.ts` 又只正式支持 `can_use_tool` 这一类窄 control 子集；`remoteBridgeCore.ts` 虽然更宽，但在 recovery 窗口仍会主动 drop 一部分控制与结果。这使得 `36` 的核心结论很清楚：宿主不是完整安全控制台，而是多账本系统上的条件化投影，协议全集绝不等于宿主全集。
- 在 `36-安全账本投影原则` 之后，再补一个 `appendix/20-宿主账本投影速查表` 就很自然了：长文已经把默认 `StructuredIO`、`RemoteIO + CCR v2`、`DirectConnect`、`RemoteSessionManager` 与 `remoteBridgeCore` 这些宿主的账本子集差别讲清楚，但实现和评审时仍然需要一张更短的宿主矩阵。把“每类宿主能看到哪些账、能写哪些账、明显缺哪几本账、最危险的误读是什么”压进一页后，安全专题就第一次拥有了可直接用于宿主接入评审和解释责任分配的速查表。
- 在 `37-安全解释权限` 之后，再补一个 `appendix/21-安全解释权限速查表` 就很自然了：长文已经把不同宿主的解释边界讲清楚，但实现和评审时仍然需要一张更短的权限矩阵。把“每类宿主实际看到了什么、明显没看到什么、可以诚实说什么、绝不能替系统说什么”压进一页后，安全专题就第一次拥有了可直接用于解释责任分配和宿主 UI 文案审查的速查表。

### R. 能力全集必须和公开度 / 成熟度一起叙述

- 当前源码基线同时包含“正式公共表面”“正式宿主表面”“声明存在但实现未闭合的入口”“gated/internal 痕迹”“受策略与组织约束的产品面”。
- `agentSdkTypes.ts` 暴露了 session 管理函数族，但当前提取树里多个函数体仍是显式 `not implemented`，因此蓝皮书必须持续区分“声明接口”和“可见实现”。
- `README.md` 明确指出公开源码仍缺失 `108` 个 `feature()` 相关模块，因此“公开源码边界”与“内部真实能力全集”不能混写。
- 后续“全部功能和 API”章节必须继续按“能力平面 + 公开度 / 成熟度矩阵”双层写法推进，而不是回到单层能力清单。

证据：

- `claude-code-source-code/package.json:2-19`
- `claude-code-source-code/README.md:70-74`
- `claude-code-source-code/README.md:250-280`
- `claude-code-source-code/src/entrypoints/agentSdkTypes.ts:103-272`
- `claude-code-source-code/src/main.tsx:1497-1520`
- `claude-code-source-code/src/main.tsx:1635-1688`

### S. API 写作已进入“总表先行”阶段

- 现在已经有两份总表型文档分别负责“能力平面 + 公开度矩阵”与“命令 / 工具 / 会话 / 宿主 / 协作 API 全谱系”。
- 这意味着后续再补任何单篇 API 章节时，都必须先回到总表检查：它位于哪个平面，属于哪个公开度标签，是否只是 adapter 子集。
- 主线 `08` 负责给出判断标准，`api/23` 与 `api/24` 负责把判断标准落成可检索索引，这三层已经形成稳定写作骨架。

证据：

- `bluebook/08-能力全集、公开度与成熟度矩阵.md`
- `bluebook/api/23-能力平面、公开度与宿主支持矩阵.md`
- `bluebook/api/24-命令、工具、会话、宿主与协作API全谱系.md`

### T. Prompt、安全与源码质量三条母线已经收编为正式专题

- prompt 魔力现在不再只按“runtime contract”抽象描述，而被进一步下沉成“角色合同、缓存结构、状态晚绑定、多 Agent 语法”四层机制。
- 安全与 token 经济现在不再只写成两篇并列专题，而被进一步统一成“预算器”视角，明确动作空间和上下文空间是同构约束。
- 源码质量现在不再只写成泛泛“工程先进”，而是同时写“公开镜像仍然先进的原因”和“热点大文件、测试面缺失、镜像不完整”三类真实局限。

证据：

- `bluebook/architecture/31-提示词合同、缓存稳定性与多Agent语法.md`
- `bluebook/architecture/32-安全、权限、治理与Token预算统一图.md`
- `bluebook/architecture/33-公开源码镜像的先进性、热点与技术债.md`
- `bluebook/philosophy/21-Prompt魔力来自约束叠加与状态反馈.md`
- `bluebook/philosophy/22-安全、成本与体验必须共用预算器.md`
- `bluebook/philosophy/23-源码质量不是卫生而是产品能力.md`

### U. workflow 当前最稳的写法是“对象模型已可见，执行内核仍缺席”

- `local_workflow` 已经是正式 `TaskType`，而不是评论性术语。
- `LocalWorkflowTaskState` 已进入 `TaskState` / `BackgroundTaskState` 联合类型，说明 workflow 是后台任务对象，不是命令宏。
- SDK 进度面允许携带 `workflow_progress`，说明宿主已经被预留了 phase/progress 消费面。
- transcript 与 worktree 命名都显式提到 `subagents/workflows/<runId>/` 与 `wf_<runId>-<idx>`，说明 workflow 是独立 sidechain runtime。
- 但 `LocalWorkflowTask` 主体实现当前公开镜像未展开，因此后续必须继续区分“对象模型已可证实”与“执行机理未完整公开”。

证据：

- `claude-code-source-code/src/Task.ts:6-84`
- `claude-code-source-code/src/tasks/types.ts:1-27`
- `claude-code-source-code/src/utils/task/framework.ts:111-128`
- `claude-code-source-code/src/utils/task/sdkProgress.ts:1-34`
- `claude-code-source-code/src/utils/sessionStorage.ts:232-258`
- `claude-code-source-code/src/utils/worktree.ts:1021-1052`

### V. REPL 的 search、selection、scroll 共同维护的是前台认知真相

- transcript search 不是对 raw transcript 做 grep，而是对 render truth 做索引，显式剔除不可见 sentinel 与 system reminder。
- selection 子系统显式维护 anchor/focus、drag scroll、keyboard scroll 与 scrolled-off rows，目的是让高亮与复制结果尽量一致。
- scroll / sticky prompt 不是视觉润色，而是在长对话里维持“当前正在回复哪个 prompt”的因果锚点。
- PromptInput footer 与 teammate view 进一步把后台任务、agent transcript 与输入路由收进同一前台状态机。

证据：

- `claude-code-source-code/src/utils/transcriptSearch.ts:1-166`
- `claude-code-source-code/src/ink/selection.ts:1-220`
- `claude-code-source-code/src/ink/components/ScrollBox.tsx:1-210`
- `claude-code-source-code/src/screens/REPL.tsx:879-910`
- `claude-code-source-code/src/screens/REPL.tsx:1248-1374`
- `claude-code-source-code/src/screens/REPL.tsx:2068-2140`
- `claude-code-source-code/src/components/PromptInput/PromptInputFooterLeftSide.tsx:417-462`

### W. channels 与托管策略最适合概括成“输入预算 + 管理员预算”

- channels 不是普通 MCP，而是 capability、OAuth、org policy、session opt-in 与 allowlist 联合约束的外部输入面。
- `allowedChannelPlugins` 一旦设置就替换 Anthropic ledger，说明管理员接管的是最终信任决策，而不是“推荐插件列表”。
- permission relay 是第二层 opt-in：除了 channel capability，还必须声明 `claude/channel/permission`。
- 危险 remote managed settings 变化会触发阻塞式安全对话，说明管理员权力本身也被放进预算器，而不是静默全权生效。

证据：

- `claude-code-source-code/src/services/mcp/channelAllowlist.ts:1-67`
- `claude-code-source-code/src/services/mcp/channelNotification.ts:120-310`
- `claude-code-source-code/src/services/mcp/channelPermissions.ts:1-204`
- `claude-code-source-code/src/interactiveHelpers.tsx:237-283`
- `claude-code-source-code/src/services/remoteManagedSettings/securityCheck.tsx:15-56`
- `claude-code-source-code/src/utils/settings/types.ts:896-920`
- `claude-code-source-code/src/utils/plugins/pluginPolicy.ts:1-17`

### X. API atlas 已补到“目录级拓扑 + 动态暴露即预算”这一层

- `api/30` 把 `commands / tools / services / state-query / host control / frontend truth` 六个目录级平面挂到一张能力地图上，避免“字段表齐了，但能力地形仍然不可检索”。
- `api/29` 现在应继续按“动态能力暴露本身也是 token 策略”理解：减少无关工具、稳定 built-in 前缀、把 deferred tools 外移，本质上都在维护 prompt cache 与预算主路径。

证据：

- `claude-code-source-code/src/commands.ts:224-320`
- `claude-code-source-code/src/tools.ts:193-367`
- `claude-code-source-code/src/query.ts:369-395`
- `claude-code-source-code/src/services/api/claude.ts:1270-1355`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:28-158`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:57-220`
- `claude-code-source-code/src/cli/structuredIO.ts:135-162`
- `claude-code-source-code/src/state/onChangeAppState.ts:43-92`
- `claude-code-source-code/src/Task.ts:6-124`
- `claude-code-source-code/src/query/tokenBudget.ts:45-92`

### Y. 第一性原理实践最稳的写法应收敛为“目标、预算、对象、边界、回写”

- 使用专题不能继续只给命令清单，而应先帮助读者判断：这次任务属于 session、task/workflow、worktree 还是单轮对话。
- 更稳的 Claude Code 使用法不是“写更长 prompt”，而是先分目标预算、动作预算、上下文预算、协作预算与治理预算，再决定哪些状态进入稳定层，哪些状态只做晚绑定。
- 长任务若仍被当作多轮聊天来承载，通常已经在逆用 Claude Code；应升级到 task/workflow/session/worktree 等正式对象。

证据：

- `claude-code-source-code/src/utils/systemPrompt.ts:29-122`
- `claude-code-source-code/src/query/tokenBudget.ts:3-92`
- `claude-code-source-code/src/utils/toolPool.ts:43-79`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:28-158`
- `claude-code-source-code/src/Task.ts:6-106`
- `claude-code-source-code/src/utils/task/framework.ts:101-117`
- `claude-code-source-code/src/utils/sessionStorage.ts:231-258`
- `claude-code-source-code/src/utils/worktree.ts:1022-1058`
- `claude-code-source-code/src/utils/transcriptSearch.ts:9-59`
- `claude-code-source-code/src/ink/selection.ts:19-63`
- `claude-code-source-code/src/services/mcp/channelPermissions.ts:1-18`
- `claude-code-source-code/src/services/remoteManagedSettings/securityCheck.tsx:15-73`

### Z. Prompt 深线已升级到“可重放、可观测、可编译、可分层”

- `stopHooks` 会保存 `CacheSafeParams`，让 `/btw` 和 post-turn forks 复用与主线程一致的安全前缀；这说明 prompt 不只是单轮文本，而是可重放前缀资产。
- `get_context_usage` 已把 `systemPromptSections`、`systemTools`、`attachmentsByType`、`messageBreakdown` 暴露出来，说明 prompt 结构本身已经进入可观测预算面。
- `memdir` 与 `systemPromptSectionCache` 说明 prompt 正在按 section 编译和缓存，而不是每轮重写整段 memory 指南。
- `nullRenderingAttachments` 进一步说明“模型可见真相”和“用户可见真相”被显式分层，这是 prompt 低噪音注入的前提。

证据：

- `claude-code-source-code/src/query/stopHooks.ts:84-99`
- `claude-code-source-code/src/commands/btw/btw.tsx:183-227`
- `claude-code-source-code/src/utils/forkedAgent.ts:70-141`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:220-305`
- `claude-code-source-code/src/components/ContextVisualization.tsx:110-149`
- `claude-code-source-code/src/memdir/memdir.ts:121-128`
- `claude-code-source-code/src/memdir/memdir.ts:187-205`
- `claude-code-source-code/src/bootstrap/state.ts:1641-1653`
- `claude-code-source-code/src/components/messages/nullRenderingAttachments.ts:4-69`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:332-460`

### AA. 源码质量深线已升级到“显式失败、反竞争条件、chokepoint 与 leaf module”

- `StructuredIO`、`DirectConnectManager`、`RemoteSessionManager`、`bridgeMessaging` 反复体现同一原则：unsupported / unknown / outbound-only control request 必须显式回 error，不能制造假成功。
- `updateTaskState(...)`、`generateTaskAttachments(...)` 与 mailbox attachment 去重逻辑说明作者不是按“单次调用正确”写代码，而是按 stale snapshot、duplicate response、双来源消息这些 race-aware 主路径写代码。
- `onChangeAppState(...)`、`assembleToolPool(...)`、`promptCacheBreakDetection.ts` 说明 Claude Code 倾向于用少数 chokepoint 统一维护 mode sync、tool truth、cache break 解释等全局不变量。
- `pluginPolicy.ts`、`normalization.ts`、`toolPool.ts`、`teammateViewHelpers.ts` 等 leaf module 则说明作者会主动切断循环依赖和模块图污染，以保护这些 chokepoint 不被反向拖垮。

证据：

- `claude-code-source-code/src/cli/structuredIO.ts:135-162`
- `claude-code-source-code/src/cli/structuredIO.ts:533-658`
- `claude-code-source-code/src/server/directConnectManager.ts:81-99`
- `claude-code-source-code/src/server/directConnectManager.ts:188-200`
- `claude-code-source-code/src/remote/RemoteSessionManager.ts:189-213`
- `claude-code-source-code/src/bridge/bridgeMessaging.ts:126-157`
- `claude-code-source-code/src/bridge/bridgeMessaging.ts:215-283`
- `claude-code-source-code/src/state/onChangeAppState.ts:43-92`
- `claude-code-source-code/src/tools.ts:193-367`
- `claude-code-source-code/src/utils/task/framework.ts:48-71`
- `claude-code-source-code/src/utils/task/framework.ts:158-248`
- `claude-code-source-code/src/utils/attachments.ts:3583-3665`
- `claude-code-source-code/src/utils/plugins/pluginPolicy.ts:1-20`
- `claude-code-source-code/src/services/mcp/normalization.ts:1-23`
- `claude-code-source-code/src/utils/toolPool.ts:43-79`
- `claude-code-source-code/src/state/teammateViewHelpers.ts:5-21`

### AB. 宿主 API 深线已升级到“失败语义、取消请求与 transcript 防腐层”

- `control_response(error)`、`control_cancel_request`、orphan/duplicate response 不能再被当成边角协议；它们共同决定 host control loop 是否仍然活着。
- `notifySessionStateChanged(...)`、`external_metadata.pending_action`、`permission_mode` 外化说明失败之后系统不会让宿主继续猜当前状态。
- `ensureToolResultPairing(...)` 说明 transcript repair 也应被视为正式 API 现实的一部分，而不是内部补丁层。

证据：

- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:606-619`
- `claude-code-source-code/src/cli/structuredIO.ts:362-429`
- `claude-code-source-code/src/cli/structuredIO.ts:469-520`
- `claude-code-source-code/src/bridge/bridgeMessaging.ts:265-283`
- `claude-code-source-code/src/bridge/bridgeMessaging.ts:373-383`
- `claude-code-source-code/src/server/directConnectManager.ts:81-99`
- `claude-code-source-code/src/remote/RemoteSessionManager.ts:159-170`
- `claude-code-source-code/src/remote/RemoteSessionManager.ts:189-213`
- `claude-code-source-code/src/utils/sessionState.ts:92-130`
- `claude-code-source-code/src/cli/print.ts:5241-5270`
- `claude-code-source-code/src/utils/messages.ts:5133-5188`

### AC. Prompt 深线还应继续升级到“辅助循环共享前缀资产网络”

- `CacheSafeParams` 不只服务主线程本轮请求，还被 `/btw`、prompt suggestion、session memory、extract memories、auto-dream、agent summary 这些辅助循环复用。
- 这说明 Claude Code 的 prompt 魔力并不是“主线程 system prompt 很强”，而是主线程持续生产可被旁路循环继承的 prefix asset。
- 真正的设计单位因此不只是单次 query，而是“主线程 + 多个 post-turn / side-loop fork”组成的前缀共享网络。

证据：

- `claude-code-source-code/src/query/stopHooks.ts:92-99`
- `claude-code-source-code/src/commands/btw/btw.tsx:183-227`
- `claude-code-source-code/src/cli/print.ts:2274-2298`
- `claude-code-source-code/src/utils/forkedAgent.ts:70-141`
- `claude-code-source-code/src/services/PromptSuggestion/promptSuggestion.ts:184-221`
- `claude-code-source-code/src/services/SessionMemory/sessionMemory.ts:315-325`
- `claude-code-source-code/src/services/extractMemories/extractMemories.ts:371-427`
- `claude-code-source-code/src/services/autoDream/autoDream.ts:224-233`
- `claude-code-source-code/src/services/AgentSummary/agentSummary.ts:81-109`
- `claude-code-source-code/src/tools/AgentTool/runAgent.ts:721-729`

### AC. 预算器深线已升级到“观测型预算与实际调优方法”

- `get_context_usage` 暴露的不只是总 token，还显式暴露 `systemPromptSections`、`systemTools`、`deferredBuiltinTools`、`mcpTools`、`skills`、`attachmentsByType` 与 `toolCallsByType`，这说明 prompt 预算已被外化成可诊断对象。
- `ContextVisualization` 证明这些字段不是纯 SDK 调试残留，而是前台实际消费的正式观测面。
- 预算观测必须和 `pending_action`、`permission_mode`、`session_state_changed` 一起理解，否则宿主仍会把“预算问题”“审批阻塞”“模式变化”混成一种“系统卡住”。
- `ContextSuggestions` 与 worker init 时对 stale `pending_action` 的清理进一步说明：Claude Code 不是只想让你“看见预算”，而是想形成“观测 -> 建议 -> 调优”的闭环，并防止 crash 后沿用过期阻塞真相。

证据：

- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:175-305`
- `claude-code-source-code/src/utils/analyzeContext.ts:918-1085`
- `claude-code-source-code/src/utils/contextSuggestions.ts:31-220`
- `claude-code-source-code/src/commands/context/context.tsx:12-60`
- `claude-code-source-code/src/components/ContextVisualization.tsx:110-220`
- `claude-code-source-code/src/components/ContextSuggestions.tsx:11-45`
- `claude-code-source-code/src/utils/sessionState.ts:92-130`
- `claude-code-source-code/src/cli/transports/ccrClient.ts:476-487`
- `claude-code-source-code/src/state/onChangeAppState.ts:50-92`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:332-460`

### AD. 预算深线已升级到“观测 -> 建议 -> 调优”的闭环

- `get_context_usage`、`/context` 与 `ContextVisualization` 共享同一条采集路径，观测的是模型实际会看到的工作集，而不是 REPL 原始历史。
- `ContextSuggestions` 说明 Claude Code 不满足于告诉你“哪里胖”，还会继续把预算结构翻译成下一步动作建议。
- 这意味着预算在 Claude Code 里不只是控制器，也是建议器；它既约束系统，也帮助人类和宿主决定下一步该改 prompt、改工具面，还是改对象选择。

证据：

- `claude-code-source-code/src/utils/analyzeContext.ts:918-1085`
- `claude-code-source-code/src/utils/contextSuggestions.ts:31-220`
- `claude-code-source-code/src/commands/context/context.tsx:12-60`
- `claude-code-source-code/src/commands/context/context-noninteractive.ts:16-120`
- `claude-code-source-code/src/components/ContextVisualization.tsx:14-20`
- `claude-code-source-code/src/components/ContextVisualization.tsx:105-245`
- `claude-code-source-code/src/components/ContextSuggestions.tsx:11-45`
- `claude-code-source-code/src/cli/print.ts:2961-2978`

### AE. 安全深线还应升级到“输入边界控制平面”

- `policySettings` 最关键的作用不是“多一个 enterprise source”，而是把“谁有资格扩张运行时边界”建模成一等 authority source。
- Claude Code 明显采用不对称安全模型：allow/allowlist/可执行 hook 这类扩权输入可以被锁到 managed source；deny 与自我限制仍允许来自本地来源。这在 sandbox、permission rules、hooks、MCP allowlist 上都能看到同构模式。
- `sandboxTypes -> settings/types -> sdk/coreTypes -> sandbox-adapter` 说明安全边界是正式 contract 再编译成 runtime hard boundary，而不是工具内部零散判断。
- `sandbox-adapter` 不只执行限制，还会 deny write 到 settings 文件、managed drop-ins 和 `.claude/skills`，说明 runtime boundary 还在反向保护 control plane 本身不被 agent 篡改。
- `remoteManagedSettings` 更像策略分发与热更新通道；真正的安全边界仍在 source gating、settings merge 与 adapter enforcement。

证据：

- `claude-code-source-code/src/utils/settings/constants.ts:159-180`
- `claude-code-source-code/src/utils/settings/settings.ts:319-343`
- `claude-code-source-code/src/utils/settings/settings.ts:665-689`
- `claude-code-source-code/src/utils/managedEnv.ts:93-135`
- `claude-code-source-code/src/entrypoints/sandboxTypes.ts:1-133`
- `claude-code-source-code/src/entrypoints/sdk/coreTypes.ts:1-16`
- `claude-code-source-code/src/utils/settings/types.ts:655-655`
- `claude-code-source-code/src/utils/permissions/permissionsLoader.ts:27-120`
- `claude-code-source-code/src/utils/hooks/hooksConfigSnapshot.ts:9-83`
- `claude-code-source-code/src/services/mcp/config.ts:337-360`
- `claude-code-source-code/src/utils/settings/pluginOnlyPolicy.ts:1-58`
- `claude-code-source-code/src/utils/sandbox/sandbox-adapter.ts:172-247`
- `claude-code-source-code/src/utils/sandbox/sandbox-adapter.ts:743-752`
- `claude-code-source-code/src/services/remoteManagedSettings/securityCheck.tsx:15-60`
- `claude-code-source-code/src/services/remoteManagedSettings/index.ts:321-337`
- `claude-code-source-code/src/services/remoteManagedSettings/index.ts:457-550`
- `claude-code-source-code/src/utils/settings/changeDetector.ts:437-447`

### AF. Claude Code 真正在预算的是“无序自由度”

- 更高一层的统一解释不是“单一预算器”，而是 Claude Code 在同时约束动作空间、权威空间、上下文空间与时间空间的无序扩张。
- 工具过滤、`policySettings` 的 first-source-wins、memoized system sections、tool result replacement、turn continuation、cache-break explanation 这些看似分散的机制，本质上都在反对“先全暴露再事后补救”。
- prompt 稳定性不只是性能技巧，而是运行时治理的一部分；如果 authority、tool order、sections、fork prefix 都会漂移，系统就既不安全，也不稳定，还更贵。
- Claude Code 共享的不只是原则，也共享方法：typed decision、frozen decisions、stable prefix、explicit observability。
- `get_context_usage` 外化 `systemPromptSections` 与 `messageBreakdown`，说明这套反扩张系统并不是内部优化，而是正式控制面真相。

证据：

- `claude-code-source-code/src/tools.ts:345-364`
- `claude-code-source-code/src/utils/toolPool.ts:63-74`
- `claude-code-source-code/src/utils/permissions/permissions.ts:1167-1259`
- `claude-code-source-code/src/utils/settings/settings.ts:322-343`
- `claude-code-source-code/src/utils/settings/settings.ts:675-689`
- `claude-code-source-code/src/constants/systemPromptSections.ts:17-50`
- `claude-code-source-code/src/utils/toolResultStorage.ts:272-320`
- `claude-code-source-code/src/utils/toolResultStorage.ts:740-772`
- `claude-code-source-code/src/query.ts:369-383`
- `claude-code-source-code/src/query/tokenBudget.ts:1-75`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:243-315`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:437-470`
- `claude-code-source-code/src/utils/forkedAgent.ts:47-79`
- `claude-code-source-code/src/query/stopHooks.ts:92-99`
- `claude-code-source-code/src/commands/btw/btw.tsx:183-210`
- `claude-code-source-code/src/utils/analyzeContext.ts:1353-1363`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:175-215`

### AG. 源码先进性更适合压成“五种不变量治理模式”

- `query.ts` 更像 query runtime 的 control-plane chokepoint，而不是单纯的大文件；预算、snip、microcompact、恢复、续轮都被明确排进一条主链。
- `QueryGuard`、`tokenBudget` 与 `state.transition.reason` 说明 Claude Code 偏爱 typed decision / typed transition，而不是让复杂状态继续留在布尔泥团里。
- `normalizeMessagesForAPI()` 与 `claude.ts` 请求出口承担的是 authoritative surface，负责统一合法化 API 输入与最终 wire shape。
- `QueryGuard` generation、防 orphan tool_use、frozen replacement fate 等都说明它按 race-aware runtime 写代码，默认真实世界会中断、重试、fallback、resume。
- `Tool.ts` 把模型序列化、UI 渲染、搜索文本、自动分类输入拆开，说明它理解的“工具”是 contract，而不是一个 `call()`。

证据：

- `claude-code-source-code/src/query.ts:265-420`
- `claude-code-source-code/src/query.ts:1190-1235`
- `claude-code-source-code/src/query.ts:1700-1735`
- `claude-code-source-code/src/query/config.ts:1-43`
- `claude-code-source-code/src/query/deps.ts:1-37`
- `claude-code-source-code/src/QueryEngine.ts:176-210`
- `claude-code-source-code/src/utils/QueryGuard.ts:1-108`
- `claude-code-source-code/src/query/tokenBudget.ts:22-75`
- `claude-code-source-code/src/utils/messages.ts:1989-2045`
- `claude-code-source-code/src/utils/messages.ts:5200-5225`
- `claude-code-source-code/src/Tool.ts:158-220`
- `claude-code-source-code/src/Tool.ts:362-390`
- `claude-code-source-code/src/Tool.ts:557-595`
- `claude-code-source-code/src/Tool.ts:717-750`
- `claude-code-source-code/src/utils/toolResultStorage.ts:835-924`

### AH. Prompt 魔力更像“上下文准入编译器”

- 更强的表述不是“稳定前缀”，而是 Claude Code 有一条上下文准入编译链：先定来源优先级，再分 static/dynamic block，再锁定 schema/header 字节，最后在 compaction 时保住意图连续性。
- `buildEffectiveSystemPrompt()`、dynamic boundary、`splitSysPromptPrefix()` 与 `buildSystemPromptBlocks()` 共同说明 prompt 是编译产物，不是字符串拼接结果。
- `toolSchemaCache` 与 sticky beta headers 说明 prompt 稳定性真正追求的是 byte-level determinism，而不只是语义大致相同。
- `yoloClassifier` 复用 `CLAUDE.md` 前缀给权限分类器，说明安全判断也必须共享同一上下文准入真相。
- compaction 在保留 primary intent / current work / next step 的同时，去掉会重注入的 attachments，并在 context-collapse 接管时主动让路，说明“省 token”不能破坏语义连续性。

证据：

- `claude-code-source-code/src/utils/settings/settings.ts:798-812`
- `claude-code-source-code/src/utils/settings/types.ts:542-548`
- `claude-code-source-code/src/utils/permissions/permissions.ts:1417-1445`
- `claude-code-source-code/src/utils/systemPrompt.ts:25-56`
- `claude-code-source-code/src/constants/prompts.ts:343-355`
- `claude-code-source-code/src/constants/prompts.ts:492-510`
- `claude-code-source-code/src/utils/api.ts:300-340`
- `claude-code-source-code/src/utils/toolSchemaCache.ts:1-20`
- `claude-code-source-code/src/services/api/claude.ts:1405-1418`
- `claude-code-source-code/src/services/api/claude.ts:3213-3234`
- `claude-code-source-code/src/utils/permissions/yoloClassifier.ts:442-470`
- `claude-code-source-code/src/services/compact/prompt.ts:55-95`
- `claude-code-source-code/src/services/compact/compact.ts:120-215`
- `claude-code-source-code/src/services/compact/autoCompact.ts:200-220`

### AI. Prompt 组装深线还应升级到“稳定前缀 + 动态尾部 + 旁路 fork”

- `SYSTEM_PROMPT_DYNAMIC_BOUNDARY` 不是注释，而是 prompt cache topology 的正式边界；system prompt 的 static/dynamic 分层被源码显式固定。
- `systemPromptSection` / `DANGEROUS_uncachedSystemPromptSection` 说明 section cache 属于 prompt runtime 本体；稳定是默认，破坏稳定必须被显式承认。
- built-in tool 前缀、session-stable tool schema、deferred tools discovered set 共同说明“工具暴露”也是 prompt assembly 的一部分，而不是另一个独立子系统。
- 高波动信息被不断迁出主 prompt/tool description，改成 deferred/agent/MCP delta attachments，本质是在把变化从前缀搬到尾部。
- `CacheSafeParams`、prompt suggestion、speculation、session memory 说明 Claude Code 真正依赖的是 prefix asset network：辅助智能旁路 fork，并复用主线程前缀，而不是继续膨胀主循环。
- `normalizeMessagesForAPI()` 说明模型最终看到的是 protocol transcript，而不是 UI transcript；prompt assembly 的最后一步是协议化整形。

证据：

- `claude-code-source-code/src/constants/prompts.ts:104-114`
- `claude-code-source-code/src/constants/prompts.ts:343-355`
- `claude-code-source-code/src/constants/prompts.ts:492-510`
- `claude-code-source-code/src/constants/prompts.ts:560-578`
- `claude-code-source-code/src/constants/systemPromptSections.ts:17-50`
- `claude-code-source-code/src/utils/systemPrompt.ts:25-56`
- `claude-code-source-code/src/utils/api.ts:300-340`
- `claude-code-source-code/src/tools.ts:345-364`
- `claude-code-source-code/src/utils/toolSchemaCache.ts:1-20`
- `claude-code-source-code/src/utils/attachments.ts:1448-1495`
- `claude-code-source-code/src/utils/mcpInstructionsDelta.ts:20-52`
- `claude-code-source-code/src/utils/toolSearch.ts:385-430`
- `claude-code-source-code/src/utils/toolSearch.ts:540-560`
- `claude-code-source-code/src/query.ts:1001-1001`
- `claude-code-source-code/src/query/stopHooks.ts:92-99`
- `claude-code-source-code/src/services/PromptSuggestion/promptSuggestion.ts:184-220`
- `claude-code-source-code/src/services/PromptSuggestion/speculation.ts:402-420`
- `claude-code-source-code/src/services/PromptSuggestion/speculation.ts:740-759`
- `claude-code-source-code/src/services/SessionMemory/sessionMemory.ts:303-325`
- `claude-code-source-code/src/utils/messages.ts:1989-2045`

### AJ. Claude Code 接受“轻微陈旧”，来换取系统级确定性

- `getSessionStartDate`、memoized `getSystemContext/getUserContext` 说明 Claude Code 不把“每次都最新”当成最高目标，而把“会话内前缀尽量稳定”放在更高优先级。
- section cache 与 sticky beta headers 共同说明：系统默认接受受控陈旧，拒绝无规律漂移。
- 这种轻微陈旧并不是放弃更新，而是配合 delta attachments 把变化迁到尾部，以更便宜的方式回写。
- 从 prompt 运行时看，这是一条非常成熟的取舍：与其追求所有信息绝对实时，不如先保证跨轮一致性、fork 复用性与 cache 可解释性。

证据：

- `claude-code-source-code/src/constants/common.ts:17-24`
- `claude-code-source-code/src/context.ts:116-165`
- `claude-code-source-code/src/constants/systemPromptSections.ts:17-50`
- `claude-code-source-code/src/utils/toolSchemaCache.ts:1-20`
- `claude-code-source-code/src/services/api/claude.ts:1398-1418`
- `claude-code-source-code/src/services/api/claude.ts:1460-1478`
- `claude-code-source-code/src/services/api/claude.ts:1640-1674`
- `claude-code-source-code/src/utils/attachments.ts:1448-1495`
- `claude-code-source-code/src/utils/mcpInstructionsDelta.ts:20-52`

### AK. Prompt 运行时并不会把 UI transcript 直接喂给模型

- `normalizeMessagesForAPI()` 本质上是 protocol compiler：attachment reorder、virtual message strip、targeted strip、tool_reference boundary 注入、adjacent user merge、tool_result hoist 都发生在 API 边界前。
- attachment-origin 内容会被统一包成 `<system-reminder>`，随后再尽量 smoosh 进最后一个 `tool_result`，说明 runtime 在主动区分“辅助上下文”和“真实用户输入”。
- tool_reference 的边界注入与 sibling 迁移说明 Claude Code 在处理的是 server-side prompt 语义，而不是前台显示语义。
- `extractDiscoveredToolNames(messages)` 说明 protocol transcript 不只是重放历史，还承担 deferred tool 暴露的记忆功能。
- 结论应升级为：UI transcript 服务人类可见真相，protocol transcript 服务模型侧协议真相；二者相关，但不相同。

证据：

- `claude-code-source-code/src/utils/messages.ts:1760-1858`
- `claude-code-source-code/src/utils/messages.ts:1989-2045`
- `claude-code-source-code/src/utils/messages.ts:2130-2195`
- `claude-code-source-code/src/utils/messages.ts:2440-2485`
- `claude-code-source-code/src/utils/messages.ts:5200-5225`
- `claude-code-source-code/src/utils/toolSearch.ts:540-560`
- `claude-code-source-code/src/services/api/claude.ts:1145-1175`

### AL. Claude Code 偏爱渐进暴露，而不是全量声明

- `ToolSearch + deferred tools` 说明能力可以先存在，但不必先全量暴露给模型；运行时更偏爱“发现 -> 回填”闭环。
- `toolSchemaCache` 与 delta attachments 说明即使能力要变化，也尽量把变化留在尾部或增量，而不是主前缀。
- `strictPluginOnlyCustomization`、`allowManagedPermissionRulesOnly` 说明这种“先限制模型可见世界”也发生在 authority/source 层，而不只发生在 tool 层。
- 这条线的更强哲学表述应是：先限制模型可见世界，再要求模型聪明；否则安全、token、cache、治理四条线会同时变差。

证据：

- `claude-code-source-code/src/utils/toolSchemaCache.ts:1-20`
- `claude-code-source-code/src/utils/toolSearch.ts:385-430`
- `claude-code-source-code/src/utils/toolSearch.ts:540-560`
- `claude-code-source-code/src/services/api/claude.ts:1145-1175`
- `claude-code-source-code/src/utils/attachments.ts:1448-1495`
- `claude-code-source-code/src/utils/mcpInstructionsDelta.ts:20-52`
- `claude-code-source-code/src/utils/settings/types.ts:542-548`
- `claude-code-source-code/src/utils/permissions/permissions.ts:1417-1445`

### AM. 热点大文件并不自动等于坏架构

- `query.ts` 的“大”主要承载 turn kernel 的时序耦合；旁边显式抽出了 `config/deps/tokenBudget/stopHooks/queryContext` 这些 seams，说明它是在集中合法复杂度，而不是放任膨胀。
- `REPL.tsx` 的“大”主要承载前台 orchestration shell：query lifecycle、transcript/fullscreen 分支、scroll chokepoint、modal/overlay 组合，而不是把所有 contract 内联。
- `assembleToolPool()` 统一 REPL 与 runAgent 的工具装配，`QueryGuard` 统一本地 query in-flight 真相，说明热点文件周围的 single source of truth 很强。
- `analytics/index.ts`、`pluginPolicy.ts`、`types/permissions.ts`、`mcp/normalization.ts` 这类 leaf modules 说明仓库在主动用纯模块给热点文件兜边界、断循环。
- 更成熟的工程判断不该停留在“文件大小”，而应升级到“这个文件是不是 kernel / shell / chokepoint，它周围有没有 leaf modules 和 anti-cycle seams”。

证据：

- `claude-code-source-code/src/query.ts:181-260`
- `claude-code-source-code/src/query.ts:365-420`
- `claude-code-source-code/src/query.ts:659-865`
- `claude-code-source-code/src/query.ts:1065-1085`
- `claude-code-source-code/src/query.ts:1678-1735`
- `claude-code-source-code/src/query/config.ts:1-43`
- `claude-code-source-code/src/query/deps.ts:1-37`
- `claude-code-source-code/src/utils/queryContext.ts:1-40`
- `claude-code-source-code/src/QueryEngine.ts:175-210`
- `claude-code-source-code/src/screens/REPL.tsx:889-907`
- `claude-code-source-code/src/screens/REPL.tsx:4392-4408`
- `claude-code-source-code/src/screens/REPL.tsx:4548-4566`
- `claude-code-source-code/src/utils/QueryGuard.ts:1-108`
- `claude-code-source-code/src/tools.ts:329-345`
- `claude-code-source-code/src/hooks/useMergedTools.ts:1-30`
- `claude-code-source-code/src/services/mcp/config.ts:337-365`
- `claude-code-source-code/src/services/mcp/normalization.ts:1-20`
- `claude-code-source-code/src/services/analytics/index.ts:1-40`
- `claude-code-source-code/src/utils/plugins/pluginPolicy.ts:1-18`
- `claude-code-source-code/src/types/permissions.ts:1-36`

### AN. “模型可见世界”本身就是控制平面

- `shouldDefer/alwaysLoad` 已经把“哪些工具应该首轮可见、哪些能力应延后暴露”写进工具协议，而不是散落在调用点里。
- `ToolSearch + discovered set + filteredTools` 说明 Claude Code 更像在维护一个逐步扩张的可见世界，而不是一张静态能力表。
- deferred tools delta、agent listing delta、MCP instructions delta 共同说明：高波动能力描述应走尾部增量，而不是主前缀常驻。
- compaction 后重播这些 delta，说明它们不是 UI 附属提示，而是会话级 capability state continuation。
- trusted sources / managed-only source gating 则说明：不仅“哪些能力可见”被治理，“谁有资格定义这些能力可见性”也被治理。

证据：

- `claude-code-source-code/src/Tool.ts:438-448`
- `claude-code-source-code/src/tools/ToolSearchTool/prompt.ts:53-105`
- `claude-code-source-code/src/utils/toolSearch.ts:385-430`
- `claude-code-source-code/src/utils/toolSearch.ts:540-560`
- `claude-code-source-code/src/services/api/claude.ts:1118-1175`
- `claude-code-source-code/src/utils/toolSchemaCache.ts:1-20`
- `claude-code-source-code/src/utils/attachments.ts:1455-1505`
- `claude-code-source-code/src/utils/attachments.ts:1550-1575`
- `claude-code-source-code/src/services/compact/compact.ts:563-575`
- `claude-code-source-code/src/utils/managedEnv.ts:93-115`
- `claude-code-source-code/src/utils/settings/types.ts:468-525`
- `claude-code-source-code/src/utils/permissions/permissionsLoader.ts:27-40`
- `claude-code-source-code/src/services/mcp/config.ts:337-360`
- `claude-code-source-code/src/utils/settings/pluginOnlyPolicy.ts:1-30`
- `claude-code-source-code/src/tools/AgentTool/runAgent.ts:108-130`
- `claude-code-source-code/src/tools/AgentTool/runAgent.ts:548-565`

### AO. Observability 在 Claude Code 里是正式 explainability contract

- `get_context_usage` 不是 debug dump，而是正式 control schema，且返回的不是一个 token 数字，而是 `systemPromptSections`、`messageBreakdown`、`mcpTools`、`agents` 等分层对象。
- `analyzeContext.ts` 说明这些对象的语义是“模型真正看到的输入真相”，而不是 REPL raw history 的近似统计。
- `sessionState` 与 `onChangeAppState` 说明状态真相不能只靠事件流推理；`pending_action`、`permission_mode`、`task_summary` 都有快照回写职责。
- `promptCacheBreakDetection` 通过 pre-call snapshot + post-call token validation 构成稳定性因果解释层，说明 cache miss 被当成正式运行时真相处理。
- `contextSuggestions` 会继续消费这些观测对象并翻译成建议，说明 observability 不是展示层，而是闭环的一部分。

证据：

- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:175-305`
- `claude-code-source-code/src/utils/analyzeContext.ts:1325-1370`
- `claude-code-source-code/src/state/onChangeAppState.ts:23-70`
- `claude-code-source-code/src/utils/sessionState.ts:90-135`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:240-315`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:430-520`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:640-705`
- `claude-code-source-code/src/utils/contextSuggestions.ts:30-90`

### AP. 依赖图诚实性是 Claude Code 的正式工程方法

- `queryContext.ts` 不是 leaf，而是受控 anti-cycle seam；它把高位共享依赖关进小房间，并限制只有入口层文件可用。
- `analytics/index.ts`、`pluginPolicy.ts`、`normalization.ts`、`systemPromptType.ts` 都在展示同一纪律：高扇入共享面必须极薄，最好 zero/low-dep。
- `types/permissions.ts` 说明更成熟的做法是先抽类型中心，再让实现层依赖它，而不是类型和实现互相咬住。
- `mcpSkillBuilders.ts` 与 `teammateViewHelpers.ts` 证明这不是个别文件习惯，而是仓库级 graph discipline：宁可 registry leaf、宁可内联 type check，也不随手闭合 runtime cycle。
- 更强的总结不是“模块多”，而是“import 边表达真实责任，而不是哪里顺手就从哪里拿”。

证据：

- `claude-code-source-code/src/utils/queryContext.ts:1-40`
- `claude-code-source-code/src/services/analytics/index.ts:1-40`
- `claude-code-source-code/src/utils/plugins/pluginPolicy.ts:1-18`
- `claude-code-source-code/src/services/mcp/normalization.ts:1-20`
- `claude-code-source-code/src/utils/systemPromptType.ts:1-12`
- `claude-code-source-code/src/types/permissions.ts:1-36`
- `claude-code-source-code/src/skills/mcpSkillBuilders.ts:1-40`
- `claude-code-source-code/src/state/teammateViewHelpers.ts:1-20`

### Z. 入口索引层必须被当成正式产物，而不是维护附录

- 当正文已经长出 `api/30`、`architecture/36/37/38`、`guides/06` 这类新判断标准时，`bluebook/README.md`、`navigation/*`、专题 README 若不立刻同步，就会让读者继续沿过时链路阅读。
- 这说明检索层本身也是蓝皮书结构的一部分，不只是排版工作；它决定读者是否能按“问题 -> 平面 -> 章节”而不是按文件名碰运气进入正文。

证据：

- `bluebook/README.md`
- `bluebook/navigation/01-第一性原理阅读地图.md`
- `bluebook/navigation/02-能力、API与治理检索图.md`
- `bluebook/api/README.md`
- `bluebook/architecture/README.md`
- `bluebook/guides/README.md`
- `bluebook/philosophy/README.md`

## 本轮新增结论

- 宿主分析当前必须稳定成三层写法：协议全集、控制平面主路径、consumer subset；不能再把 schema、执行面与消费面混成同一层。
- `controlSchemas.ts` 治理的是可表达协议全集，`StructuredIO + print.ts (+ RemoteIO)` 才是权威控制主路径，bridge / direct connect / `RemoteSessionManager` 是不同宽度的诚实子集。
- `worker_status / requires_action_details / external_metadata` 当前必须按 durability surface 叙述，而不是 telemetry；resume、reconnect 与 stale-write rejection 都直接依赖它。
- `WorkerStateUploader` 的 `1 inflight + 1 pending`、无限重试、RFC 7396 merge 与 `null` 删除语义，说明作者在保护“可恢复当前真相”的最终收敛，而不是在做 best-effort 状态上报。
- “单一权威”必须与“单一全景表示”分开叙述；多消费者系统共享的是权威合同，不是同一种展示或请求表示。
- prompt 魔力当前必须稳定成“世界先被编成可治理语法，再让模型思考”；`systemPromptSections`、tool schema、protocol transcript、delta attachments、deferred discovery 都属于这条工作语法链。
- 安全设计与省 token 设计当前必须用 `Narrow / Later / Outside` 三种动作统一叙述；它们是在控制模型可达世界的宽度、时间与位置，而不是分别做两套优化。
- 源码先进性当前必须继续上升到“可演化内核 / 熵治理”层：config、deps、state machine、leaf module 都是在回答增长时 authority、transition、boundary、dependency 如何不裂。
- prompt 深线当前还应继续上升到“语义压缩器”层：session memory、prompt suggestion、stop hooks、tool result fate freeze 共同保住的是可继续行动的语义，而不是更短原文。
- 安全与省 token 深线当前还应继续上升到“资源宪法”层：runtime 在统一分配能力、时间、注意力与权威，模型不是资源主权拥有者。
- 源码先进性当前还应继续上升到“演化制度设计”层：注释、leaf module、snapshot、narrow extraction 在保留下一次重构可能性，不只是体现作者经验。
- prompt 深线当前还应继续上升到“协调成本控制面”层：prompt 不只组织模型，也在组织人类如何接手、确认、切换与纠偏。
- 安全与省 token 深线当前还应继续上升到“有效自由”层：ask/deny/bypass/deferred/externalize 共同目标不是更保守，而是让约束不破坏高行动力。
- 源码先进性当前还应继续上升到“源码即治理界面”层：命名、注释、显式边界和 dependency-free 小模块都在降低误改、误扩展与制度失忆成本。
- 使用专题当前应继续承担“把高阶结论变成操作方法”的角色；否则蓝皮书会越来越会解释，但越来越难拿来用。

## 下一步待办

- 补 `SDKMessage`、control、snapshot、recovery 四面统一的宿主实现 casebook
- 补 `query.ts` / `sessionStorage.ts` / `REPL.tsx` / `replBridge.ts` 四个热点文件的债务与分层图
- 补 bridge / direct-connect / remote-session 三类宿主路径的更细时序图
- 继续把源码目录级索引表下沉到二级目录与代表性叶子模块
- 补 `REPL.tsx` / Ink 更细的 transcript mode、message actions、PromptInput 交互链
- 补命令索引的更细表格化版本与 workflow/dynamic skills 交叉核对
- 补 feature gate / runtime gate / compat shim 的统一时序与迁移图
- 继续把 session/state API 与子代理状态回收做成字段级索引与时序图
- 补一章“MCP 实战配置与集成范式”
- 补一章“治理型 API 的宿主实践样例”

## 当前风险

- 这份源码不是完整内部 monorepo，不能把 gated/internal 痕迹直接当成公开事实。
- `query.ts` 仍有大量细节未拆完，尤其是 compact / reactive compact / media recovery 分支。
- plugin 市场能力的基础设施很完整，但现阶段不能夸大其生态成熟度。
- SDK 入口可见，但部分 `runtimeTypes` / `toolTypes` / `controlTypes` 源文件未在当前提取树中展开，接口分析需持续标注这层边界。
- `services/compact/*` 已明显显示多条 gated/ant-only 路径，不能把 cached microcompact、API-native clear edits 等直接当作所有 build 的公开能力。
- `commands/` 目录很多模块名与最终 slash name 可能不完全同名，虽然字段级索引已补，但 workflow/dynamic skills 仍需继续核实。
- session/state 面横跨 `sessionStorage.ts`、`fileHistory.ts`、SessionMemory、SDK control schema，后续必须继续防止“API、机制、产品行为”三层混写。
- session API 在 `agentSdkTypes.ts` 中的实现可见度仍不完整，后续写作必须继续强调“入口已声明”不等于“当前提取树里已有完整实现”。
- 多 Agent 隔离逻辑横跨 `AgentTool.tsx`、`runAgent.ts`、`forkedAgent.ts`、worktree tools，后续若继续细拆时应防止把“并发能力”和“隔离约束”混成一个概念。
- 扩展面虽然已经能被解释为统一配置语言，但 plugin manifest、marketplace、MCPB、LSP 仍存在明显的产品成熟度差异，后续不能把 schema 支持直接写成生态成熟。
- 权限系统的很多细节受 ant-only feature、classifier gate、fail-open/fail-closed 配置影响，后续必须持续区分“源码路径存在”和“公开构建稳定可用”。
- `stream_event`、`research`、`advisor`、`claudeai-proxy`、`ws-ide` 等痕迹里混有 internal / host-specific 信号，后续不能直接当作稳定公共契约。
- Claude API 流式执行链与当前 Anthropic event shape、tool execution harness 强绑定，后续若源码升级，最可能先变化的是恢复细节与引用写回策略。
- direct connect 与 `RemoteSessionManager` 当前实现的 control surface 明显窄于 `StructuredIO` 全量 schema，后续必须持续避免把“schema 全集”和“某个宿主已支持的子集”写成同一层事实。
- bridge 当前虽然明显宽于 direct connect / `RemoteSessionManager`，但仍不是完整 control subtype 全集；后续必须避免把它直接等同于完整 SDK host。
- 显式失败路径目前已经能被解释为架构原则，但尚未对 `authRecoveryInFlight`、transport close code、prompt timeout 等失败语义做完全文级整理，后续仍要继续补。
- request / response / follow-on message 的闭环主线已经建立，但仍未把所有 subtype 做成统一 casebook；后续若继续深化，应防止不同闭环粒度混写。
- 运行时真相的双通道主线已经建立，但仍未把每个状态项都标清“时间线 / 快照 / 恢复 / consumer subset”四层；后续若继续深化，应防止再次退回单通道叙述。
- 继续往前推进后，可以更明确地把 `37-安全解释权限` 单独写出来：`36` 已经回答了“宿主只能看到哪些账本子集”，但还没有回答“它凭什么替完整控制面下结论”。`controlSchemas.ts` 与 `coreSchemas.ts` 说明协议全集本身不能直接推出解释权全集；`StructuredIO.ts` 说明默认宿主没有恢复账与 internal-event 面；`RemoteIO.ts` 说明更厚宿主的解释权也依赖初始化与 transport 条件；`DirectConnectManager.ts` 与 `RemoteSessionManager.ts` 的窄 control 子集说明窄宿主最合理的是局部解释；`remoteBridgeCore.ts` 在 recovery 窗口主动 drop 一部分事实，则进一步说明解释权限还会随时序窗口动态收窄。这使得 `37` 的核心结论很清楚：解释权不是默认附赠能力，而是从当前可见账本边界反推出来的受限权限。
- 继续往前推进后，可以更明确地把 `38-安全未知语义` 单独写出来：`37` 已经回答了“谁有解释权”，但还没有回答“系统在没有足够依据时该怎么办”。`DirectConnectManager.ts` 与 `RemoteSessionManager.ts` 对 unsupported subtype 显式回 error，说明“不支持”必须被显式表达而不是静默等待；`StructuredIO.ts` 用 `null` 与 no-op 表达“当前没有恢复账/持久面”；`RemoteIO.ts` 在条件不成立时直接 fail loudly，而不是偷偷退成伪完整模式；`remoteBridgeCore.ts` 在 recovery 窗口直接 drop control 和 result，则说明“当前不可判定”必须被显式保留；`sdkEventQueue.ts` 只在 authoritative turn-over signal 成立后才授予完整解释权，则进一步说明成熟系统宁可晚一点说，也不能早一点猜。这使得 `38` 的核心结论很清楚：不知道不是失败残渣，而是安全控制面必须拥有的一等语义。
- 在 `38-安全未知语义` 之后，再补一个 `appendix/22-安全未知语义速查表` 就很自然了：长文已经把 unsupported、无账本、条件未成立和恢复窗口不可判定这些“未知”讲清楚，但实现和评审时仍然需要一张更短的未知矩阵。把“系统当前缺什么、正确做法是什么、错误做法是什么、硬猜后会坏什么”压进一页后，安全专题就第一次拥有了可直接用于审查伪解释和伪成功路径的速查表。
- 继续往前推进后，可以更明确地把 `39-安全声明等级` 单独写出来：`38` 已经回答了“什么时候必须说不知道”，但还没有回答“在知道时为什么也不能只说 yes/no”。`SDKRateLimitInfoSchema` 把 allowed 拆成 `allowed / allowed_warning / rejected`；MCP 连接状态被拆成 `connected / failed / needs-auth / pending / disabled`；`post_turn_summary` 继续把运行结论细分成 `blocked / waiting / completed / review_ready / failed`，并附带 `status_detail` 与 `is_noteworthy`；`SDKAPIRetryMessageSchema` 又把失败声明细化成 typed error、HTTP status 与 retry budget；`CCRInitFailReason` 和 `OrgValidationResult` 则说明初始化和组织校验都更偏向“typed reason + descriptive message”而不是裸布尔。这样一来，源码已经很清楚地说明：成熟安全控制面不是二元裁决器，而是一台会按强度、理由和条件分级说话的声明机器。
- `query.ts`、`sessionStorage.ts`、`REPL.tsx`、`replBridge.ts` 等热点文件依然很大；后续若继续写“源码先进性”，必须同时写基础设施优点与热点文件债务。
- workflow engine 的类型入口和 transcript 归档语义当前可见，但主体实现未完整展开；后续必须持续区分“已可证实的 task 维度”与“尚未完全展开的引擎细节”。
- 在 `39-安全声明等级` 之后，再补一个 `appendix/23-安全声明等级速查表` 就很自然了：长文已经把允许类、连接类、运行类、重试类和初始化/校验类声明的分级逻辑讲清楚，但实现和评审时仍然需要一张更短的声明矩阵。把“声明族、典型等级、典型字段、真正表达什么、最危险的压扁误读”压进一页后，安全专题就第一次拥有了可直接用于下游接口评审和语义压缩审查的速查表。
- 继续往前推进后，可以更明确地把 `40-安全动作语法` 单独写出来：`39` 已经回答了“结论为什么要分级”，但还没有回答“结论给出后，正确下一步动作为何也必须被编码进协议”。`PermissionUpdateSchema` 与 `SDKControlPermissionRequestSchema` 说明权限请求天然带着建议修法而不是只有阻断；`useDirectConnect.ts`、`useRemoteSession.ts` 与 `useSSHSession.ts` 说明这些 suggestions 会被宿主直接消费；`SDKPostTurnSummaryMessageSchema` 继续把 `recent_action`、`needs_action` 与 `artifact_urls` 放进同一条 turn 摘要；`SDKControlRewindFilesResponseSchema` 与 `SDKAPIRetryMessageSchema` 又把修复可行性和等待/重试策略编码成 typed 分支；`MCPServerConnection`、`handleRemoteAuthFailure()`、`channelNotification.ts` 与 `useManageMCPConnections.ts` 则说明 `needs-auth / pending / disabled / failed` 的真正价值，在于把恢复路径拆开；`OrgValidationResult` 和 `CCRInitFailReason` 最后进一步证明 typed reason 的意义不是分类本身，而是防止错误补救。这样一来，源码已经很清楚地说明：成熟安全控制面不是静态声明面板，而是一台会把状态、理由、等级与下一步动作一起编码出来的控制语法机。
- 在 `40-安全动作语法` 之后，再补一个 `appendix/24-安全动作语法速查表` 就很自然了：长文已经解释了为什么成熟控制面必须把声明和动作绑在一起，但实现、评审与宿主接入时更需要一张更短的动作矩阵。把 `can_use_tool`、`requires_action`、`post_turn_summary`、`api_retry`、MCP 五态、`rewind_files`、`OrgValidationResult` 与 `CCRInitFailReason` 压成“声明族 / 典型状态 / 正确下一步 / 最危险错误动作 / 关键证据”之后，安全专题就第一次拥有了一张可直接用于检查状态压缩是否会误导动作路径的速查表。
- 继续往前推进后，可以更明确地把 `41-安全动作归属` 单独写出来：`40` 已经回答了“下一步该做什么”，但还没有回答“谁来做、写到哪、持续多久”。`PermissionUpdateDestinationSchema` 先把动作目的地拆成 `userSettings / projectSettings / localSettings / session / cliArg`；`supportsPersistence()` 又明确说明只有三类 settings 目标配拥有持久化资格，`session` 与 `cliArg` 不能被偷偷升格成长期授权；`PermissionPromptToolResultSchema` 与 `PermissionDecisionClassificationSchema` 则继续把宿主压回“忠实报告用户实际动作”的见证层，防止宿主把一次性允许偷偷变成永久允许；`useManageMCPConnections.ts` 又把 `auth`、`policy`、`disabled` 三类 gate 显式映射给用户、管理员或无人可立即修复的不同主体；`api_retry` 与 `rewind dry_run` 最后进一步说明系统自动动作和人工确认动作不能混写。这样一来，源码已经很清楚地说明：成熟安全控制面不只是在给动作，还在给动作的责任归属、写入层级与时间边界。
- 在 `41-安全动作归属` 之后，再补一个 `appendix/25-安全动作归属速查表` 就很自然了：长文已经解释了为什么动作需要继续绑定主体、作用域和持久层，但实现、评审与宿主接入时更需要一张更短的归属矩阵。把权限更新 destination、用户临时/永久决定、`requires_action`、`api_retry`、MCP 五态、rewind 预演/执行、组织校验失败等压成“信号 / 执行主体 / 写入范围 / 持久性 / 最危险越权者 / 关键证据”之后，安全专题就第一次拥有了一张可直接用于审查“对的动作是否会被错误主体代做”的速查表。
- 继续往前推进后，可以更明确地把 `42-安全动作完成权` 单独写出来：`41` 已经回答了“谁来做、写到哪、持续多久”，但还没有回答“谁有资格宣布已经做完”。`SDKSessionStateChangedMessageSchema` 与 `sdkEventQueue.ts` 先把 `session_state_changed(idle)` 写成 authoritative turn-over signal；`print.ts` 又明确要求 going idle 前先 `flushInternalEvents()`，说明局部收尾不能抢在事件持久化前宣布完成；`SDKFilesPersistedEventSchema` 与 `print.ts` 继续把文件持久化拆成独立事件，拒绝让普通 result 冒充落盘确认；`ccrClient.flush()` 的注释又进一步强调 delivery confirmation 与 server state 不是同一回事；`remoteBridgeCore.ts` 最后在 401 recovery 窗口主动 drop control/result，说明不可靠窗口里的局部执行痕迹不配拥有完成解释权。这样一来，源码已经很清楚地说明：成熟安全控制面不只是在给动作和归属，还在严格限制谁能对“完成”这件事签字。
- 在 `42-安全动作完成权` 之后，再补一个 `appendix/26-安全动作完成权速查表` 就很自然了：长文已经解释了为什么执行信号不能直接等于完成信号，但实现、评审与宿主接入时更需要一张更短的完成矩阵。把 `session_state_changed(idle)`、`flushInternalEvents()`、`files_persisted`、queue drain、401 recovery、rewind dry-run 与重启后 stale metadata 清理压成“动作 / 执行信号 / 完成签字信号 / 仍然不够的信号 / 最危险提前宣布 / 关键证据”之后，安全专题就第一次拥有了一张可直接用于审查伪完成与提前宣布问题的速查表。
- 继续往前推进后，可以更明确地把 `43-安全完成投影` 单独写出来：`42` 已经回答了“谁能对完成签字”，但还没有回答“不同宿主到底看到了多少签字链”。`session_state_changed(idle)` 与 `sdkEventQueue.ts` 给 SDK 流消费者暴露了一条强完成事件；`RemoteIO` 则继续接上 `restoredWorkerState`、internal-event read/write、`reportState`、`reportMetadata` 与 `flushInternalEvents()`，形成更厚的完成投影；默认 `StructuredIO` 反过来明确把恢复账与 internal-event flush 设成 `null` / no-op / zero，说明这类宿主不配自称拥有同等完成视角；`DirectConnectManager.ts` 与 `RemoteSessionManager.ts` 又把 control surface 收窄到几乎只剩 `can_use_tool`，进一步压缩了它们对整条完成链的资格；`remoteBridgeCore.ts` 最后说明 even 更厚的 bridge 也会在 recovery 窗口主动 drop result/control，从而临时收窄完成投影。这样一来，源码已经很清楚地说明：成熟安全控制面不只定义完成签字权，还定义不同宿主最多能看到多少完成签字链。
- 在 `43-安全完成投影` 之后，再补一个 `appendix/27-安全完成投影速查表` 就很自然了：长文已经解释了不同宿主只能看到完成签字链的子集，但实现、评审与宿主接入时更需要一张更短的宿主矩阵。把 SDK 流消费者、RemoteIO/CCR、默认 StructuredIO、bridge 正常 / recovery 窗口、DirectConnectManager、RemoteSessionManager 压成“宿主 / 可见完成信号 / 缺失账本 / 最安全说法上限 / 最危险误读 / 关键证据”之后，安全专题就第一次拥有了一张可直接用于审查“这个宿主是不是把局部完成说得过满”的速查表。
- 继续往前推进后，可以更明确地把 `44-安全完成差异显化` 单独写出来：`43` 已经回答了“不同宿主看到的是不同子集”，但还没有回答“这种差异是否应该被用户显式看到”。`buildMcpProperties()` 会把异质 MCP 状态压成计数摘要；`sdkMessageAdapter.ts` 会把结构化 status 压成 generic informational text；`bridgeStatusUtil.ts` 又把 bridge 状态压成 `active / reconnecting / failed / connecting` 四个总体标签；可 `replBridgeTransport.ts` 同时明确写出 connected 只是 write-readiness，不是 read-readiness。这说明底层早已承认宿主差异，但展示层仍会在多个地方重新压平。这样一来，源码已经很清楚地说明：下一代统一安全控制台不该只内部保留宿主差异，而必须把“当前宿主缺哪条完成链、因此这条状态最多能说到哪一步”显式做成用户可见语义。
- 在 `44-安全完成差异显化` 之后，再补一个 `appendix/28-安全完成差异显化速查表` 就很自然了：长文已经解释了为什么界面必须显式展示宿主差异，但实现、评审与产品设计时更需要一张更短的界面矩阵。把 `/status` 的 MCP 摘要、remote `sdkMessageAdapter`、bridge 总体标签、repl bridge transport label、StructuredIO / RemoteIO / DirectConnect / RemoteSessionManager 这些典型压缩点压成“当前界面 / 当前压缩写法 / 被隐藏的盲区 / 最少必须显化的字段 / 最不该继续复用的文案 / 关键证据”之后，安全专题就第一次拥有了一张可直接用于审查“展示层是否又把底层宿主差异抹平”的速查表。
- 继续往前推进后，可以更明确地把 `45-安全完成差异字段` 单独写出来：`44` 已经回答了“这些差异必须显式展示”，但还没有回答“到底该用哪些字段展示”。`AppStateStore.ts` 已经明确定义了 `remoteConnectionStatus`、`replBridgeEnabled / Connected / SessionActive / Reconnecting / Error`、`mcp.clients` 等状态槽位；`replBridgeTransport.ts` 又把 write-readiness 与 read-readiness 显式分开；`StructuredIO.ts` 和 `RemoteIO.ts` 则进一步把恢复账、internal-event flush 与 pending depth 的有无做成可观察差异；`DirectConnectManager.ts` 与 `RemoteSessionManager.ts` 最后再把 `supported_control_subtypes` 的天然收窄暴露出来。这样一来，源码已经很清楚地说明：统一安全控制台真正缺的不是更多状态词，而是一组能稳定表达 `host_kind / projection_grade / missing_ledgers / readiness_split / supported_control_subtypes / completion_claim_ceiling` 的正式字段。
- 在 `45-安全完成差异字段` 之后，再补一个 `appendix/29-安全完成差异字段速查表` 就很自然了：长文已经解释了统一安全控制台最少该补哪些字段，但实现、评审与产品设计时更需要一张更短的字段矩阵。把 `host_kind`、`projection_grade`、`missing_ledgers[]`、`write_ready/read_ready`、`label_basis`、`supported_control_subtypes[]`、`restored_worker_state_supported`、`internal_event_flush_supported`、`recovery_window_open` 与 `completion_claim_ceiling` 压成“字段 / 主要来源 / 推荐展示层级 / 缺失后最可能的误导 / 关键证据”之后，安全专题就第一次拥有了一张可直接用于审查“宿主盲区有没有被字段化”的速查表。
- 继续往前推进后，可以更明确地把 `37-安全解释权限` 单独写出来：`36` 已经回答了“宿主只能看到哪些账本子集”，但还没有回答“它凭什么替完整控制面下结论”。`controlSchemas.ts` 与 `coreSchemas.ts` 说明协议全集本身不能直接推出解释权全集；`StructuredIO.ts` 说明默认宿主没有恢复账与 internal-event 面；`RemoteIO.ts` 说明更厚宿主的解释权也依赖初始化与 transport 条件；`DirectConnectManager.ts` 与 `RemoteSessionManager.ts` 的窄 control 子集说明窄宿主最合理的是局部解释；`remoteBridgeCore.ts` 在 recovery 窗口主动 drop 一部分事实，则进一步说明解释权限还会随时序窗口动态收窄。这使得 `37` 的核心结论很清楚：解释权不是默认附赠能力，而是从当前可见账本边界反推出来的受限权限。
- 继续往前推进后，可以更明确地把 `38-安全未知语义` 单独写出来：`37` 已经回答了“谁有解释权”，但还没有回答“系统在没有足够依据时该怎么办”。`DirectConnectManager.ts` 与 `RemoteSessionManager.ts` 对 unsupported subtype 显式回 error，说明“不支持”必须被显式表达而不是静默等待；`StructuredIO.ts` 用 `null` 与 no-op 表达“当前没有恢复账/持久面”；`RemoteIO.ts` 在条件不成立时直接 fail loudly，而不是偷偷退成伪完整模式；`remoteBridgeCore.ts` 在 recovery 窗口直接 drop control 和 result，则说明“当前不可判定”必须被显式保留；`sdkEventQueue.ts` 只在 authoritative turn-over signal 成立后才授予完整解释权，则进一步说明成熟系统宁可晚一点说，也不能早一点猜。这使得 `38` 的核心结论很清楚：不知道不是失败残渣，而是安全控制面必须拥有的一等语义。
- 在 `38-安全未知语义` 之后，再补一个 `appendix/22-安全未知语义速查表` 就很自然了：长文已经把 unsupported、无账本、条件未成立和恢复窗口不可判定这些“未知”讲清楚，但实现和评审时仍然需要一张更短的未知矩阵。把“系统当前缺什么、正确做法是什么、错误做法是什么、硬猜后会坏什么”压进一页后，安全专题就第一次拥有了可直接用于审查伪解释和伪成功路径的速查表。
- 继续往前推进后，可以更明确地把 `39-安全声明等级` 单独写出来：`38` 已经回答了“什么时候必须说不知道”，但还没有回答“在知道时为什么也不能只说 yes/no”。`SDKRateLimitInfoSchema` 把 allowed 拆成 `allowed / allowed_warning / rejected`；MCP 连接状态被拆成 `connected / failed / needs-auth / pending / disabled`；`post_turn_summary` 继续把运行结论细分成 `blocked / waiting / completed / review_ready / failed`，并附带 `status_detail` 与 `is_noteworthy`；`SDKAPIRetryMessageSchema` 又把失败声明细化成 typed error、HTTP status 与 retry budget；`CCRInitFailReason` 和 `OrgValidationResult` 则说明初始化和组织校验都更偏向“typed reason + descriptive message”而不是裸布尔。这样一来，源码已经很清楚地说明：成熟安全控制面不是二元裁决器，而是一台会按强度、理由和条件分级说话的声明机器。
- 在 `39-安全声明等级` 之后，再补一个 `appendix/23-安全声明等级速查表` 就很自然了：长文已经把允许类、连接类、运行类、重试类和初始化/校验类声明的分级逻辑讲清楚，但实现和评审时仍然需要一张更短的声明矩阵。把“声明族、典型等级、典型字段、真正表达什么、最危险的压扁误读”压进一页后，安全专题就第一次拥有了可直接用于下游接口评审和语义压缩审查的速查表。
- 继续往前推进后，可以更明确地把 `40-安全动作语法` 单独写出来：`39` 已经回答了“结论为什么要分级”，但还没有回答“结论给出后，正确下一步动作为何也必须被编码进协议”。`PermissionUpdateSchema` 与 `SDKControlPermissionRequestSchema` 说明权限请求天然带着建议修法而不是只有阻断；`useDirectConnect.ts`、`useRemoteSession.ts` 与 `useSSHSession.ts` 说明这些 suggestions 会被宿主直接消费；`SDKPostTurnSummaryMessageSchema` 继续把 `recent_action`、`needs_action` 与 `artifact_urls` 放进同一条 turn 摘要；`SDKControlRewindFilesResponseSchema` 与 `SDKAPIRetryMessageSchema` 又把修复可行性和等待/重试策略编码成 typed 分支；`MCPServerConnection`、`handleRemoteAuthFailure()`、`channelNotification.ts` 与 `useManageMCPConnections.ts` 则说明 `needs-auth / pending / disabled / failed` 的真正价值，在于把恢复路径拆开；`OrgValidationResult` 和 `CCRInitFailReason` 最后进一步证明 typed reason 的意义不是分类本身，而是防止错误补救。这样一来，源码已经很清楚地说明：成熟安全控制面不是静态声明面板，而是一台会把状态、理由、等级与下一步动作一起编码出来的控制语法机。
- 在 `40-安全动作语法` 之后，再补一个 `appendix/24-安全动作语法速查表` 就很自然了：长文已经解释了为什么成熟控制面必须把声明和动作绑在一起，但实现、评审与宿主接入时更需要一张更短的动作矩阵。把 `can_use_tool`、`requires_action`、`post_turn_summary`、`api_retry`、MCP 五态、`rewind_files`、`OrgValidationResult` 与 `CCRInitFailReason` 压成“声明族 / 典型状态 / 正确下一步 / 最危险错误动作 / 关键证据”之后，安全专题就第一次拥有了一张可直接用于检查状态压缩是否会误导动作路径的速查表。
- 继续往前推进后，可以更明确地把 `41-安全动作归属` 单独写出来：`40` 已经回答了“下一步该做什么”，但还没有回答“谁来做、写到哪、持续多久”。`PermissionUpdateDestinationSchema` 先把动作目的地拆成 `userSettings / projectSettings / localSettings / session / cliArg`；`supportsPersistence()` 又明确说明只有三类 settings 目标配拥有持久化资格，`session` 与 `cliArg` 不能被偷偷升格成长期授权；`PermissionPromptToolResultSchema` 与 `PermissionDecisionClassificationSchema` 则继续把宿主压回“忠实报告用户实际动作”的见证层，防止宿主把一次性允许偷偷变成永久允许；`useManageMCPConnections.ts` 又把 `auth`、`policy`、`disabled` 三类 gate 显式映射给用户、管理员或无人可立即修复的不同主体；`api_retry` 与 `rewind dry_run` 最后进一步说明系统自动动作和人工确认动作不能混写。这样一来，源码已经很清楚地说明：成熟安全控制面不只是在给动作，还在给动作的责任归属、写入层级与时间边界。
- 在 `41-安全动作归属` 之后，再补一个 `appendix/25-安全动作归属速查表` 就很自然了：长文已经解释了为什么动作需要继续绑定主体、作用域和持久层，但实现、评审与宿主接入时更需要一张更短的归属矩阵。把权限更新 destination、用户临时/永久决定、`requires_action`、`api_retry`、MCP 五态、rewind 预演/执行、组织校验失败等压成“信号 / 执行主体 / 写入范围 / 持久性 / 最危险越权者 / 关键证据”之后，安全专题就第一次拥有了一张可直接用于审查“对的动作是否会被错误主体代做”的速查表。
- 继续往前推进后，可以更明确地把 `42-安全动作完成权` 单独写出来：`41` 已经回答了“谁来做、写到哪、持续多久”，但还没有回答“谁有资格宣布已经做完”。`SDKSessionStateChangedMessageSchema` 与 `sdkEventQueue.ts` 先把 `session_state_changed(idle)` 写成 authoritative turn-over signal；`print.ts` 又明确要求 going idle 前先 `flushInternalEvents()`，说明局部收尾不能抢在事件持久化前宣布完成；`SDKFilesPersistedEventSchema` 与 `print.ts` 继续把文件持久化拆成独立事件，拒绝让普通 result 冒充落盘确认；`ccrClient.flush()` 的注释又进一步强调 delivery confirmation 与 server state 不是同一回事；`remoteBridgeCore.ts` 最后在 401 recovery 窗口主动 drop control/result，说明不可靠窗口里的局部执行痕迹不配拥有完成解释权。这样一来，源码已经很清楚地说明：成熟安全控制面不只是在给动作和归属，还在严格限制谁能对“完成”这件事签字。
- 在 `42-安全动作完成权` 之后，再补一个 `appendix/26-安全动作完成权速查表` 就很自然了：长文已经解释了为什么执行信号不能直接等于完成信号，但实现、评审与宿主接入时更需要一张更短的完成矩阵。把 `session_state_changed(idle)`、`flushInternalEvents()`、`files_persisted`、queue drain、401 recovery、rewind dry-run 与重启后 stale metadata 清理压成“动作 / 执行信号 / 完成签字信号 / 仍然不够的信号 / 最危险提前宣布 / 关键证据”之后，安全专题就第一次拥有了一张可直接用于审查伪完成与提前宣布问题的速查表。
- 继续往前推进后，可以更明确地把 `43-安全完成投影` 单独写出来：`42` 已经回答了“谁能对完成签字”，但还没有回答“不同宿主到底看到了多少签字链”。`session_state_changed(idle)` 与 `sdkEventQueue.ts` 给 SDK 流消费者暴露了一条强完成事件；`RemoteIO` 则继续接上 `restoredWorkerState`、internal-event read/write、`reportState`、`reportMetadata` 与 `flushInternalEvents()`，形成更厚的完成投影；默认 `StructuredIO` 反过来明确把恢复账与 internal-event flush 设成 `null` / no-op / zero，说明这类宿主不配自称拥有同等完成视角；`DirectConnectManager.ts` 与 `RemoteSessionManager.ts` 又把 control surface 收窄到几乎只剩 `can_use_tool`，进一步压缩了它们对整条完成链的资格；`remoteBridgeCore.ts` 最后说明 even 更厚的 bridge 也会在 recovery 窗口主动 drop result/control，从而临时收窄完成投影。这样一来，源码已经很清楚地说明：成熟安全控制面不只定义完成签字权，还定义不同宿主最多能看到多少完成签字链。
- 在 `43-安全完成投影` 之后，再补一个 `appendix/27-安全完成投影速查表` 就很自然了：长文已经解释了不同宿主只能看到完成签字链的子集，但实现、评审与宿主接入时更需要一张更短的宿主矩阵。把 SDK 流消费者、RemoteIO/CCR、默认 StructuredIO、bridge 正常 / recovery 窗口、DirectConnectManager、RemoteSessionManager 压成“宿主 / 可见完成信号 / 缺失账本 / 最安全说法上限 / 最危险误读 / 关键证据”之后，安全专题就第一次拥有了一张可直接用于审查“这个宿主是不是把局部完成说得过满”的速查表。
- 继续往前推进后，可以更明确地把 `44-安全完成差异显化` 单独写出来：`43` 已经回答了“不同宿主看到的是不同子集”，但还没有回答“这种差异是否应该被用户显式看到”。`buildMcpProperties()` 会把异质 MCP 状态压成计数摘要；`sdkMessageAdapter.ts` 会把结构化 status 压成 generic informational text；`bridgeStatusUtil.ts` 又把 bridge 状态压成 `active / reconnecting / failed / connecting` 四个总体标签；可 `replBridgeTransport.ts` 同时明确写出 connected 只是 write-readiness，不是 read-readiness。这说明底层早已承认宿主差异，但展示层仍会在多个地方重新压平。这样一来，源码已经很清楚地说明：下一代统一安全控制台不该只内部保留宿主差异，而必须把“当前宿主缺哪条完成链、因此这条状态最多能说到哪一步”显式做成用户可见语义。
- 在 `44-安全完成差异显化` 之后，再补一个 `appendix/28-安全完成差异显化速查表` 就很自然了：长文已经解释了为什么界面必须显式展示宿主差异，但实现、评审与产品设计时更需要一张更短的界面矩阵。把 `/status` 的 MCP 摘要、remote `sdkMessageAdapter`、bridge 总体标签、repl bridge transport label、StructuredIO / RemoteIO / DirectConnect / RemoteSessionManager 这些典型压缩点压成“当前界面 / 当前压缩写法 / 被隐藏的盲区 / 最少必须显化的字段 / 最不该继续复用的文案 / 关键证据”之后，安全专题就第一次拥有了一张可直接用于审查“展示层是否又把底层宿主差异抹平”的速查表。
- 继续往前推进后，可以更明确地把 `45-安全完成差异字段` 单独写出来：`44` 已经回答了“这些差异必须显式展示”，但还没有回答“到底该用哪些字段展示”。`AppStateStore.ts` 已经明确定义了 `remoteConnectionStatus`、`replBridgeEnabled / Connected / SessionActive / Reconnecting / Error`、`mcp.clients` 等状态槽位；`replBridgeTransport.ts` 又把 write-readiness 与 read-readiness 显式分开；`StructuredIO.ts` 和 `RemoteIO.ts` 则进一步把恢复账、internal-event flush 与 pending depth 的有无做成可观察差异；`DirectConnectManager.ts` 与 `RemoteSessionManager.ts` 最后再把 `supported_control_subtypes` 的天然收窄暴露出来。这样一来，源码已经很清楚地说明：统一安全控制台真正缺的不是更多状态词，而是一组能稳定表达 `host_kind / projection_grade / missing_ledgers / readiness_split / supported_control_subtypes / completion_claim_ceiling` 的正式字段。
- 在 `45-安全完成差异字段` 之后，再补一个 `appendix/29-安全完成差异字段速查表` 就很自然了：长文已经解释了统一安全控制台最少该补哪些字段，但实现、评审与产品设计时更需要一张更短的字段矩阵。把 `host_kind`、`projection_grade`、`missing_ledgers[]`、`write_ready/read_ready`、`label_basis`、`supported_control_subtypes[]`、`restored_worker_state_supported`、`internal_event_flush_supported`、`recovery_window_open` 与 `completion_claim_ceiling` 压成“字段 / 主要来源 / 推荐展示层级 / 缺失后最可能的误导 / 关键证据”之后，安全专题就第一次拥有了一张可直接用于审查“宿主盲区有没有被字段化”的速查表。
- 继续往前推进后，可以更明确地把 `46-安全完成差异卡片` 单独写出来：`45` 已经回答了“该有哪些字段”，但还没有回答“字段该挂到哪张卡、按什么优先级显示”。`Status.tsx` 与 `status.tsx` 说明当前 `/status` 面偏向摘要 property 列表，天然容易把宿主盲区埋深；`BridgeDialog.tsx` 说明现有桥接对话框会显示 status label、error、environment/session id 和 footer，但不会优先表达 completion ceiling；`IdeStatusIndicator.tsx` 与 `useIdeConnectionStatus.ts` 又说明 IDE 状态被压成 connected/pending/disconnected 三态；`useMcpConnectivityStatus.tsx` 则继续把 MCP 问题压成 failed / needs-auth 计数通知。这说明统一安全控制台下一步最关键的不是再补字段，而是按解释上限优先级把这些字段挂回主体与资格卡、外部能力卡、警告层和动作层，避免再次在卡片层被埋掉。
- 在 `46-安全完成差异卡片` 之后，再补一个 `appendix/30-安全完成差异卡片速查表` 就很自然了：长文已经解释了这些字段该挂到哪张卡、按什么优先级显示，但实现、评审与设计讨论时更需要一张更短的卡片矩阵。把 `completion_claim_ceiling`、recovery suspension 字段、`host_kind`、`projection_grade`、`missing_ledgers[]`、`write_ready/read_ready`、`supported_control_subtypes[]` 等压成“字段组 / 推荐卡片挂载点 / 展示优先级 / 默认动作 / 最危险埋深方式 / 关键证据”之后，安全专题就第一次拥有了一张可直接用于审查“这些宿主盲区字段有没有被挂到正确位置”的速查表。
- 继续往前推进后，可以更明确地把 `47-安全完成差异升级规则` 单独写出来：`46` 已经回答了“字段该挂到哪张卡”，但还没有回答“哪些问题该立即抢占界面、哪些只需中层提示”。`notifications.tsx` 已经把 `immediate / high / medium / low` 做成正式注意力仲裁语义；`useReplBridge.tsx` 对 `Remote Control failed` 直接给 `immediate`，说明实时推翻当前完成结论的问题必须马上抢断；`useManagePlugins.ts` 与 `useManageMCPConnections.ts` 则把 flagged plugins 与 channels blocked 放进 `high`，说明会改写下一步动作路径的问题需要强提醒；`useIDEStatusIndicator.tsx` 与 `useMcpConnectivityStatus.tsx` 又把 IDE disconnected、MCP failed / needs-auth 放进 `medium`，说明显著退化但不必抢断的宿主差异适合中层提示；而 plugin reload pending 与 statusline trust blocked 则被放在 `low`。这样一来，源码已经很清楚地说明：宿主盲区显化不只需要字段和卡片，还需要一套基于误导风险的升级规则。
- 在 `47-安全完成差异升级规则` 之后，再补一个 `appendix/31-安全完成差异升级规则速查表` 就很自然了：长文已经解释了哪些宿主盲区必须抢占界面、哪些只需中层提示，但实现、评审与设计讨论时更需要一张更短的升级矩阵。把 `completion_claim_ceiling`、recovery suspension、`host_kind`、`projection_grade`、`missing_ledgers[]`、`write_ready/read_ready`、`supported_control_subtypes[]`、MCP failed / needs-auth、IDE disconnected、plugin reload pending 等压成“字段组 / 默认优先级 / 升级条件 / 绝不应降到哪一层 / 关键证据”之后，安全专题就第一次拥有了一张可直接用于审查“宿主盲区有没有被正确升级”的速查表。
- 继续往前推进后，可以更明确地把 `37-安全解释权限` 单独写出来：`36` 已经回答了“宿主只能看到哪些账本子集”，但还没有回答“它凭什么替完整控制面下结论”。`controlSchemas.ts` 与 `coreSchemas.ts` 说明协议全集本身不能直接推出解释权全集；`StructuredIO.ts` 说明默认宿主没有恢复账与 internal-event 面；`RemoteIO.ts` 说明更厚宿主的解释权也依赖初始化与 transport 条件；`DirectConnectManager.ts` 与 `RemoteSessionManager.ts` 的窄 control 子集说明窄宿主最合理的是局部解释；`remoteBridgeCore.ts` 在 recovery 窗口主动 drop 一部分事实，则进一步说明解释权限还会随时序窗口动态收窄。这使得 `37` 的核心结论很清楚：解释权不是默认附赠能力，而是从当前可见账本边界反推出来的受限权限。
- 继续往前推进后，可以更明确地把 `38-安全未知语义` 单独写出来：`37` 已经回答了“谁有解释权”，但还没有回答“系统在没有足够依据时该怎么办”。`DirectConnectManager.ts` 与 `RemoteSessionManager.ts` 对 unsupported subtype 显式回 error，说明“不支持”必须被显式表达而不是静默等待；`StructuredIO.ts` 用 `null` 与 no-op 表达“当前没有恢复账/持久面”；`RemoteIO.ts` 在条件不成立时直接 fail loudly，而不是偷偷退成伪完整模式；`remoteBridgeCore.ts` 在 recovery 窗口直接 drop control 和 result，则说明“当前不可判定”必须被显式保留；`sdkEventQueue.ts` 只在 authoritative turn-over signal 成立后才授予完整解释权，则进一步说明成熟系统宁可晚一点说，也不能早一点猜。这使得 `38` 的核心结论很清楚：不知道不是失败残渣，而是安全控制面必须拥有的一等语义。
- 在 `38-安全未知语义` 之后，再补一个 `appendix/22-安全未知语义速查表` 就很自然了：长文已经把 unsupported、无账本、条件未成立和恢复窗口不可判定这些“未知”讲清楚，但实现和评审时仍然需要一张更短的未知矩阵。把“系统当前缺什么、正确做法是什么、错误做法是什么、硬猜后会坏什么”压进一页后，安全专题就第一次拥有了可直接用于审查伪解释和伪成功路径的速查表。
- 继续往前推进后，可以更明确地把 `39-安全声明等级` 单独写出来：`38` 已经回答了“什么时候必须说不知道”，但还没有回答“在知道时为什么也不能只说 yes/no”。`SDKRateLimitInfoSchema` 把 allowed 拆成 `allowed / allowed_warning / rejected`；MCP 连接状态被拆成 `connected / failed / needs-auth / pending / disabled`；`post_turn_summary` 继续把运行结论细分成 `blocked / waiting / completed / review_ready / failed`，并附带 `status_detail` 与 `is_noteworthy`；`SDKAPIRetryMessageSchema` 又把失败声明细化成 typed error、HTTP status 与 retry budget；`CCRInitFailReason` 和 `OrgValidationResult` 则说明初始化和组织校验都更偏向“typed reason + descriptive message”而不是裸布尔。这样一来，源码已经很清楚地说明：成熟安全控制面不是二元裁决器，而是一台会按强度、理由和条件分级说话的声明机器。
- 在 `39-安全声明等级` 之后，再补一个 `appendix/23-安全声明等级速查表` 就很自然了：长文已经把允许类、连接类、运行类、重试类和初始化/校验类声明的分级逻辑讲清楚，但实现和评审时仍然需要一张更短的声明矩阵。把“声明族、典型等级、典型字段、真正表达什么、最危险的压扁误读”压进一页后，安全专题就第一次拥有了可直接用于下游接口评审和语义压缩审查的速查表。
- 继续往前推进后，可以更明确地把 `40-安全动作语法` 单独写出来：`39` 已经回答了“结论为什么要分级”，但还没有回答“结论给出后，正确下一步动作为何也必须被编码进协议”。`PermissionUpdateSchema` 与 `SDKControlPermissionRequestSchema` 说明权限请求天然带着建议修法而不是只有阻断；`useDirectConnect.ts`、`useRemoteSession.ts` 与 `useSSHSession.ts` 说明这些 suggestions 会被宿主直接消费；`SDKPostTurnSummaryMessageSchema` 继续把 `recent_action`、`needs_action` 与 `artifact_urls` 放进同一条 turn 摘要；`SDKControlRewindFilesResponseSchema` 与 `SDKAPIRetryMessageSchema` 又把修复可行性和等待/重试策略编码成 typed 分支；`MCPServerConnection`、`handleRemoteAuthFailure()`、`channelNotification.ts` 与 `useManageMCPConnections.ts` 则说明 `needs-auth / pending / disabled / failed` 的真正价值，在于把恢复路径拆开；`OrgValidationResult` 和 `CCRInitFailReason` 最后进一步证明 typed reason 的意义不是分类本身，而是防止错误补救。这样一来，源码已经很清楚地说明：成熟安全控制面不是静态声明面板，而是一台会把状态、理由、等级与下一步动作一起编码出来的控制语法机。
- 在 `40-安全动作语法` 之后，再补一个 `appendix/24-安全动作语法速查表` 就很自然了：长文已经解释了为什么成熟控制面必须把声明和动作绑在一起，但实现、评审与宿主接入时更需要一张更短的动作矩阵。把 `can_use_tool`、`requires_action`、`post_turn_summary`、`api_retry`、MCP 五态、`rewind_files`、`OrgValidationResult` 与 `CCRInitFailReason` 压成“声明族 / 典型状态 / 正确下一步 / 最危险错误动作 / 关键证据”之后，安全专题就第一次拥有了一张可直接用于检查状态压缩是否会误导动作路径的速查表。
- 继续往前推进后，可以更明确地把 `41-安全动作归属` 单独写出来：`40` 已经回答了“下一步该做什么”，但还没有回答“谁来做、写到哪、持续多久”。`PermissionUpdateDestinationSchema` 先把动作目的地拆成 `userSettings / projectSettings / localSettings / session / cliArg`；`supportsPersistence()` 又明确说明只有三类 settings 目标配拥有持久化资格，`session` 与 `cliArg` 不能被偷偷升格成长期授权；`PermissionPromptToolResultSchema` 与 `PermissionDecisionClassificationSchema` 则继续把宿主压回“忠实报告用户实际动作”的见证层，防止宿主把一次性允许偷偷变成永久允许；`useManageMCPConnections.ts` 又把 `auth`、`policy`、`disabled` 三类 gate 显式映射给用户、管理员或无人可立即修复的不同主体；`api_retry` 与 `rewind dry_run` 最后进一步说明系统自动动作和人工确认动作不能混写。这样一来，源码已经很清楚地说明：成熟安全控制面不只是在给动作，还在给动作的责任归属、写入层级与时间边界。
- 在 `41-安全动作归属` 之后，再补一个 `appendix/25-安全动作归属速查表` 就很自然了：长文已经解释了为什么动作需要继续绑定主体、作用域和持久层，但实现、评审与宿主接入时更需要一张更短的归属矩阵。把权限更新 destination、用户临时/永久决定、`requires_action`、`api_retry`、MCP 五态、rewind 预演/执行、组织校验失败等压成“信号 / 执行主体 / 写入范围 / 持久性 / 最危险越权者 / 关键证据”之后，安全专题就第一次拥有了一张可直接用于审查“对的动作是否会被错误主体代做”的速查表。
- 继续往前推进后，可以更明确地把 `42-安全动作完成权` 单独写出来：`41` 已经回答了“谁来做、写到哪、持续多久”，但还没有回答“谁有资格宣布已经做完”。`SDKSessionStateChangedMessageSchema` 与 `sdkEventQueue.ts` 先把 `session_state_changed(idle)` 写成 authoritative turn-over signal；`print.ts` 又明确要求 going idle 前先 `flushInternalEvents()`，说明局部收尾不能抢在事件持久化前宣布完成；`SDKFilesPersistedEventSchema` 与 `print.ts` 继续把文件持久化拆成独立事件，拒绝让普通 result 冒充落盘确认；`ccrClient.flush()` 的注释又进一步强调 delivery confirmation 与 server state 不是同一回事；`remoteBridgeCore.ts` 最后在 401 recovery 窗口主动 drop control/result，说明不可靠窗口里的局部执行痕迹不配拥有完成解释权。这样一来，源码已经很清楚地说明：成熟安全控制面不只是在给动作和归属，还在严格限制谁能对“完成”这件事签字。
- 在 `42-安全动作完成权` 之后，再补一个 `appendix/26-安全动作完成权速查表` 就很自然了：长文已经解释了为什么执行信号不能直接等于完成信号，但实现、评审与宿主接入时更需要一张更短的完成矩阵。把 `session_state_changed(idle)`、`flushInternalEvents()`、`files_persisted`、queue drain、401 recovery、rewind dry-run 与重启后 stale metadata 清理压成“动作 / 执行信号 / 完成签字信号 / 仍然不够的信号 / 最危险提前宣布 / 关键证据”之后，安全专题就第一次拥有了一张可直接用于审查伪完成与提前宣布问题的速查表。
- 继续往前推进后，可以更明确地把 `43-安全完成投影` 单独写出来：`42` 已经回答了“谁能对完成签字”，但还没有回答“不同宿主到底看到了多少签字链”。`session_state_changed(idle)` 与 `sdkEventQueue.ts` 给 SDK 流消费者暴露了一条强完成事件；`RemoteIO` 则继续接上 `restoredWorkerState`、internal-event read/write、`reportState`、`reportMetadata` 与 `flushInternalEvents()`，形成更厚的完成投影；默认 `StructuredIO` 反过来明确把恢复账与 internal-event flush 设成 `null` / no-op / zero，说明这类宿主不配自称拥有同等完成视角；`DirectConnectManager.ts` 与 `RemoteSessionManager.ts` 又把 control surface 收窄到几乎只剩 `can_use_tool`，进一步压缩了它们对整条完成链的资格；`remoteBridgeCore.ts` 最后说明 even 更厚的 bridge 也会在 recovery 窗口主动 drop result/control，从而临时收窄完成投影。这样一来，源码已经很清楚地说明：成熟安全控制面不只定义完成签字权，还定义不同宿主最多能看到多少完成签字链。
- 在 `43-安全完成投影` 之后，再补一个 `appendix/27-安全完成投影速查表` 就很自然了：长文已经解释了不同宿主只能看到完成签字链的子集，但实现、评审与宿主接入时更需要一张更短的宿主矩阵。把 SDK 流消费者、RemoteIO/CCR、默认 StructuredIO、bridge 正常 / recovery 窗口、DirectConnectManager、RemoteSessionManager 压成“宿主 / 可见完成信号 / 缺失账本 / 最安全说法上限 / 最危险误读 / 关键证据”之后，安全专题就第一次拥有了一张可直接用于审查“这个宿主是不是把局部完成说得过满”的速查表。
- 继续往前推进后，可以更明确地把 `44-安全完成差异显化` 单独写出来：`43` 已经回答了“不同宿主看到的是不同子集”，但还没有回答“这种差异是否应该被用户显式看到”。`buildMcpProperties()` 会把异质 MCP 状态压成计数摘要；`sdkMessageAdapter.ts` 会把结构化 status 压成 generic informational text；`bridgeStatusUtil.ts` 又把 bridge 状态压成 `active / reconnecting / failed / connecting` 四个总体标签；可 `replBridgeTransport.ts` 同时明确写出 connected 只是 write-readiness，不是 read-readiness。这说明底层早已承认宿主差异，但展示层仍会在多个地方重新压平。这样一来，源码已经很清楚地说明：下一代统一安全控制台不该只内部保留宿主差异，而必须把“当前宿主缺哪条完成链、因此这条状态最多能说到哪一步”显式做成用户可见语义。
- 在 `44-安全完成差异显化` 之后，再补一个 `appendix/28-安全完成差异显化速查表` 就很自然了：长文已经解释了为什么界面必须显式展示宿主差异，但实现、评审与产品设计时更需要一张更短的界面矩阵。把 `/status` 的 MCP 摘要、remote `sdkMessageAdapter`、bridge 总体标签、repl bridge transport label、StructuredIO / RemoteIO / DirectConnect / RemoteSessionManager 这些典型压缩点压成“当前界面 / 当前压缩写法 / 被隐藏的盲区 / 最少必须显化的字段 / 最不该继续复用的文案 / 关键证据”之后，安全专题就第一次拥有了一张可直接用于审查“展示层是否又把底层宿主差异抹平”的速查表。
- 继续往前推进后，可以更明确地把 `45-安全完成差异字段` 单独写出来：`44` 已经回答了“这些差异必须显式展示”，但还没有回答“到底该用哪些字段展示”。`AppStateStore.ts` 已经明确定义了 `remoteConnectionStatus`、`replBridgeEnabled / Connected / SessionActive / Reconnecting / Error`、`mcp.clients` 等状态槽位；`replBridgeTransport.ts` 又把 write-readiness 与 read-readiness 显式分开；`StructuredIO.ts` 和 `RemoteIO.ts` 则进一步把恢复账、internal-event flush 与 pending depth 的有无做成可观察差异；`DirectConnectManager.ts` 与 `RemoteSessionManager.ts` 最后再把 `supported_control_subtypes` 的天然收窄暴露出来。这样一来，源码已经很清楚地说明：统一安全控制台真正缺的不是更多状态词，而是一组能稳定表达 `host_kind / projection_grade / missing_ledgers / readiness_split / supported_control_subtypes / completion_claim_ceiling` 的正式字段。
- 在 `45-安全完成差异字段` 之后，再补一个 `appendix/29-安全完成差异字段速查表` 就很自然了：长文已经解释了统一安全控制台最少该补哪些字段，但实现、评审与产品设计时更需要一张更短的字段矩阵。把 `host_kind`、`projection_grade`、`missing_ledgers[]`、`write_ready/read_ready`、`label_basis`、`supported_control_subtypes[]`、`restored_worker_state_supported`、`internal_event_flush_supported`、`recovery_window_open` 与 `completion_claim_ceiling` 压成“字段 / 主要来源 / 推荐展示层级 / 缺失后最可能的误导 / 关键证据”之后，安全专题就第一次拥有了一张可直接用于审查“宿主盲区有没有被字段化”的速查表。
- 继续往前推进后，可以更明确地把 `46-安全完成差异卡片` 单独写出来：`45` 已经回答了“该有哪些字段”，但还没有回答“字段该挂到哪张卡、按什么优先级显示”。`Status.tsx` 与 `status.tsx` 说明当前 `/status` 面偏向摘要 property 列表，天然容易把宿主盲区埋深；`BridgeDialog.tsx` 说明现有桥接对话框会显示 status label、error、environment/session id 和 footer，但不会优先表达 completion ceiling；`IdeStatusIndicator.tsx` 与 `useIdeConnectionStatus.ts` 又说明 IDE 状态被压成 connected/pending/disconnected 三态；`useMcpConnectivityStatus.tsx` 则继续把 MCP 问题压成 failed / needs-auth 计数通知。这说明统一安全控制台下一步最关键的不是再补字段，而是按解释上限优先级把这些字段挂回主体与资格卡、外部能力卡、警告层和动作层，避免再次在卡片层被埋掉。
- 在 `46-安全完成差异卡片` 之后，再补一个 `appendix/30-安全完成差异卡片速查表` 就很自然了：长文已经解释了这些字段该挂到哪张卡、按什么优先级显示，但实现、评审与设计讨论时更需要一张更短的卡片矩阵。把 `completion_claim_ceiling`、recovery suspension 字段、`host_kind`、`projection_grade`、`missing_ledgers[]`、`write_ready/read_ready`、`supported_control_subtypes[]` 等压成“字段组 / 推荐卡片挂载点 / 展示优先级 / 默认动作 / 最危险埋深方式 / 关键证据”之后，安全专题就第一次拥有了一张可直接用于审查“这些宿主盲区字段有没有被挂到正确位置”的速查表。
- 继续往前推进后，可以更明确地把 `47-安全完成差异升级规则` 单独写出来：`46` 已经回答了“字段该挂到哪张卡”，但还没有回答“哪些问题该立即抢占界面、哪些只需中层提示”。`notifications.tsx` 已经把 `immediate / high / medium / low` 做成正式注意力仲裁语义；`useReplBridge.tsx` 对 `Remote Control failed` 直接给 `immediate`，说明实时推翻当前完成结论的问题必须马上抢断；`useManagePlugins.ts` 与 `useManageMCPConnections.ts` 则把 flagged plugins 与 channels blocked 放进 `high`，说明会改写下一步动作路径的问题需要强提醒；`useIDEStatusIndicator.tsx` 与 `useMcpConnectivityStatus.tsx` 又把 IDE disconnected、MCP failed / needs-auth 放进 `medium`，说明显著退化但不必抢断的宿主差异适合中层提示；而 plugin reload pending 与 statusline trust blocked 则被放在 `low`。这样一来，源码已经很清楚地说明：宿主盲区显化不只需要字段和卡片，还需要一套基于误导风险的升级规则。
- 在 `47-安全完成差异升级规则` 之后，再补一个 `appendix/31-安全完成差异升级规则速查表` 就很自然了：长文已经解释了哪些宿主盲区必须抢占界面、哪些只需中层提示，但实现、评审与设计讨论时更需要一张更短的升级矩阵。把 `completion_claim_ceiling`、recovery suspension、`host_kind`、`projection_grade`、`missing_ledgers[]`、`write_ready/read_ready`、`supported_control_subtypes[]`、MCP failed / needs-auth、IDE disconnected、plugin reload pending 等压成“字段组 / 默认优先级 / 升级条件 / 绝不应降到哪一层 / 关键证据”之后，安全专题就第一次拥有了一张可直接用于审查“宿主盲区有没有被正确升级”的速查表。
- 继续往前推进后，可以更明确地把 `48-安全完成差异交互路由` 单独写出来：`47` 已经回答了“哪些宿主盲区该抢占界面”，但还没有回答“它们一旦变化时，卡片、通知、动作和清除条件是否会一起改口”。`notifications.tsx` 已经把 `immediate/high/medium/low` 和当前通知抢占做成正式注意力仲裁；`PromptInput/Notifications.tsx` 又说明用户真正只会看到一个 `notifications.current`；相对地，`Status.tsx` 与 `utils/status.tsx` 仍主要是属性摘要层，`BridgeDialog.tsx` 会显示 status label、error、environment/session id 和 footer，却不会把 completion ceiling、missing ledgers 与动作收口一起联动；`useIdeConnectionStatus.ts` 和 `IdeStatusIndicator.tsx` 也仍把宿主资格压成低维状态。这说明源码已经拥有“注意力路由”“状态摘要”“宿主差异承认”三种成熟局部能力，但还缺最后一层统一状态机：当盲区变宽时，必须原子地降低主卡结论、升级通知、收紧动作并延后清除旧结论。这样一来，安全专题就能继续从“显示什么”推进到“同一安全事实如何在同一时刻只保留一种可行动解释”。
- 在 `48-安全完成差异交互路由` 之后，再补一个 `appendix/32-安全完成差异交互路由速查表` 就很自然了：长文已经解释了为什么宿主盲区必须被路由成卡片改口、通知抢位、动作收口和清除守纪的同一时刻联动，但实现、评审与协议对齐时更需要一张更短的联动矩阵。把 recovery window、bridge hard fail、`completion_claim_ceiling` 下调、`missing_ledgers[]` 新增、`write_ready/read_ready` 分裂、subtype 缺口、channels blocked、flagged plugins、IDE disconnected、MCP failed / needs-auth、plugin reload pending 等压成“触发器 / 典型字段 / 卡片更新 / 通知优先级 / 动作收口 / 清除条件 / 关键证据”之后，安全专题就第一次拥有了一张可直接用于审查“这些宿主盲区有没有被成套路由，而不是只改一条提示文案”的速查表。
- 继续往前推进后，可以更明确地把 `49-安全完成差异清除纪律` 单独写出来：`48` 已经回答了宿主盲区变化时卡片、通知、动作和清除条件必须一起联动，但还没有回答“什么证据出现之后，系统才有资格真的删除旧告警、撤销旧结论、恢复旧动作”。`notifications.tsx` 已经说明删除与失效是显式动作，不是自然蒸发；`ccrClient.ts` 会在 worker init 时主动清掉 prior crash 留下的 stale `pending_action/task_summary`，并把 `state_restored` 的记录放到成功初始化之后；`print.ts` 又明确要求 restore 与 hydrate 并行等待，避免 SSE catchup 落在 fresh default 上；`remoteBridgeCore.ts` 则在 401 recovery 窗口直接 drop control/result，而不是抢先宣布恢复；`sdkEventQueue.ts` 最后再把 `session_state_changed(idle)` 命名为 authoritative turn-over。这样一来，源码已经很清楚地说明：对宿主盲区而言，降级可以基于风险迹象，恢复必须基于 fresh 回读与正式 signer，下一代统一安全控制台必须把“不要过早忘记旧风险”提升成独立纪律。
- 在 `49-安全完成差异清除纪律` 之后，再补一个 `appendix/33-安全完成差异清除纪律速查表` 就很自然了：长文已经解释了为什么宿主盲区恢复时不能先删旧告警，而必须等待足够强的 fresh 证据，但实现、评审与协议对齐时更需要一张更短的清除矩阵。把 recovery window、bridge fail、`completion_claim_ceiling` 下调、`missing_ledgers[]`、stale metadata、authoritative idle、`files_persisted`、IDE disconnected、MCP failed / needs-auth、channels blocked、flagged plugins 等压成“旧结论 / 禁止依赖的弱信号 / 允许清除的 fresh 证据 / 允许先恢复什么 / 绝不能先恢复什么 / 关键证据”之后，安全专题就第一次拥有了一张可直接用于审查“控制面是不是在抢先恢复、抢先遗忘旧风险”的速查表。
- 继续往前推进后，可以更明确地把 `50-安全恢复签字层级` 单独写出来：`49` 已经回答了“恢复必须等待 fresh 证据”，但还没有回答“不同强度的 fresh 证据到底分别有资格恢复什么”。`replBridgeTransport.ts` 已经明确 connected 只是 write-readiness，不是 read-readiness；`BridgeDialog.tsx` 仍主要消费 status label 和 error，这类信号最多只能当活性 signer；`ccrClient.ts` 与 `remoteIO.ts` 则把 `state_restored / restoredWorkerState / reportState / reportMetadata` 做成更强一层的恢复与状态 signer；`sdkEventQueue.ts` 又把 `session_state_changed(idle)` 命名为 authoritative turn-over；`print.ts` 最后再把 `files_persisted` 单独分出，说明 effect signer 也不能并入普通 result。这样一来，源码已经很清楚地说明：成熟安全控制面不该只有“恢复 / 未恢复”两档，而应正式区分活性 signer、restore signer、state signer、effect signer 与 explanation signer，并让不同层级对象只接受与自己同阶的恢复签字。
- 在 `50-安全恢复签字层级` 之后，再补一个 `appendix/34-安全恢复签字层级速查表` 就很自然了：长文已经解释了为什么恢复证据必须分层签字，但实现、评审与宿主对齐时更需要一张更短的 signer 矩阵。把活性 signer、restore signer、state signer、effect signer、explanation signer 压成“signer 层级 / 典型来源 / 可恢复对象 / 不可恢复对象 / 最危险误读 / 关键证据”之后，安全专题就第一次拥有了一张可直接用于审查“某个绿色信号有没有越级替更高层对象签字”的速查表。
- 继续往前推进后，可以更明确地把 `51-安全恢复中间态` 单独写出来：`50` 已经回答了恢复 signer 的层级，但还没有回答“系统恢复到一半时到底该如何命名自己”。`replBridgeTransport.ts` 已经明确 `outboundOnly` 用于 mirror-mode attachments，只启用写路径而不接收入站 prompt/control；同文件又明确 `isConnectedStatus()` 只是 write-readiness，不是 read-readiness；`ccrClient.ts` 与 `print.ts` 则共同说明 restore 和 hydrate 解决的是“不是 fresh default”，并不自动等于 fresh；`DirectConnectManager.ts` 与 `RemoteSessionManager.ts` 最后再说明某些宿主即使在线也只支持 `can_use_tool` 这种窄 control 面。与此同时，`bridgeStatusUtil.ts` 却会把 `sessionActive || connected` 压成同一个 `Remote Control active`。这样一来，源码已经很清楚地说明：部分恢复状态不是例外，而是正式状态族，下一代统一安全控制台必须显式区分 `mirror-only`、`write-ready/read-blind`、`restored-but-not-fresh`、`control-narrow`、`result-ready/effects-pending` 等中间态，避免再次把半恢复读成全恢复。
- 在 `51-安全恢复中间态` 之后，再补一个 `appendix/35-安全恢复中间态速查表` 就很自然了：长文已经解释了为什么部分恢复必须被正式命名，但实现、评审与宿主接入对齐时更需要一张更短的中间态矩阵。把 `mirror-only`、`write-ready/read-blind`、`restored-but-not-fresh`、`control-narrow`、`result-ready/effects-pending`、`state-ready/explanation-pending` 压成“中间态 / 典型来源 / 当前可见账本 / 当前可用动作 / 禁止文案 / 默认跳转 / 关键证据”之后，安全专题就第一次拥有了一张可直接用于审查“这个半恢复状态有没有被正确命名、有没有被压平成同一句绿色文案”的速查表。
- 继续往前推进后，可以更明确地把 `52-安全恢复文案禁令` 单独写出来：`51` 已经回答了半恢复状态必须被正式命名，但还没有回答“即使系统知道自己只恢复到一半，它到底被允许说哪些词”。`bridgeStatusUtil.ts` 当前会把 `sessionActive || connected` 压成 `Remote Control active`；`status.tsx` 会把 IDE 与 MCP 压成 `Connected to ...`、`Installed ...`、`Not connected`、`connected / need auth / pending / failed` 这类摘要词；而通知层在 `useIDEStatusIndicator.tsx` 与 `useMcpConnectivityStatus.tsx` 里反而更擅长说缺口语言。这样一来，源码已经很清楚地说明：下一代统一安全控制台不只要有中间态词汇表，还必须给语言本身建立禁令，禁止在半恢复状态下继续使用过满绿色词，并要求所有恢复态文案遵守“已恢复部分 + 当前缺口 + 默认下一步”的受约束句式。
- 在 `52-安全恢复文案禁令` 之后，再补一个 `appendix/36-安全恢复文案禁令速查表` 就很自然了：长文已经解释了为什么半恢复状态下必须禁止过满绿色词，但实现、评审与文案校验时更需要一张更短的规则矩阵。把 L0 活性 signer、`mirror-only`、`write-ready/read-blind`、L1 restore signer、`restored-but-not-fresh`、L2 state signer、`control-narrow`、L3 effect signer、`result-ready/effects-pending`、L4 explanation signer 压成“对象层级 / 当前证据强度 / 禁止词 / 允许词 / 默认句式 / 关键证据”之后，安全专题就第一次拥有了一张可直接用于审查“某句绿色文案有没有超出当前证据强度”的速查表。
- 继续往前推进后，可以更明确地把 `53-安全恢复跳转纪律` 单独写出来：`52` 已经回答了恢复文案必须受约束，但还没有回答“诚实文案接下来应把用户带去哪里”。`useManagePlugins.ts` 已经把 flagged plugins 指向 `/plugins`、把 activation pending 指向 `/reload-plugins`；`useMcpConnectivityStatus.tsx` 已把 failed / needs-auth 统一指向 `/mcp`；`ChannelsNotice.tsx` 与 `PromptInput/Notifications.tsx` 又把 auth bottleneck 指向 `/login`；`RemoteCallout.tsx` 与 `bridgeMain.ts` 最后说明 Remote Control 域应回到 `/remote-control`；而 IDE 插件断连与安装失败则更倾向先去 `/status`。这样一来，源码已经很清楚地说明：Claude Code 现有系统其实已经有一套分散的默认修复路径语义，下一代统一安全控制台应该把它正式提升为恢复跳转纪律，让每种半恢复状态都绑定一个 dominant repair path，而不是把路由责任继续外包给用户。
- 在 `53-安全恢复跳转纪律` 之后，再补一个 `appendix/37-安全恢复跳转纪律速查表` 就很自然了：长文已经解释了为什么每种半恢复状态都必须绑定唯一 dominant repair path，但实现、评审与交互校验时更需要一张更短的路由矩阵。把 flagged plugins、plugin activation pending、MCP failed / needs-auth、channels auth bottleneck、global not logged in、IDE plugin not connected、IDE install failed、bridge attach / enable / disconnect、`mirror-only`、`write-ready/read-blind`、`restored-but-not-fresh` 等压成“状态 / 中间态 / 当前缺口归属 / 默认跳转 / 次级跳转 / 禁止歧义 / 关键证据”之后，安全专题就第一次拥有了一张可直接用于审查“某个半恢复状态有没有唯一默认修复路径”的速查表。
- 继续往前推进后，可以更明确地把 `54-安全恢复验证闭环` 单独写出来：`53` 已经回答了半恢复状态必须绑定唯一默认修复路径，但还没有回答“用户执行了这条路径之后，控制面凭什么宣布问题真的解决了”。`refreshActivePlugins()` 已明确区分旧 `needsRefresh` 路径的 stale data 与新的全量重建路径，说明 `/reload-plugins` 的 verifier 是 cache 清空、状态重载和 `pluginReconnectKey` bump；`reconnectMcpServerImpl()` 又把 MCP reconnect 分成 clear cache、`connectToServer()`、以及 tools/commands/resources 重新可见三段；`ChannelsNotice.tsx` 和 `teleport.tsx` 则进一步表明 `/login` 常常还只是起点，后面仍要 restart 或 `/status` 重新核对；`bridgeMain.ts` 最后说明 `bridge/reconnect` 成功与否、pointer 是否保留、是否需要重试都不能由发起动作本身替代。这样一来，源码已经很清楚地说明：repair action 解决的是修复意图，recovery closure 解决的是真相闭环，下一代统一安全控制台必须要求每条 repair path 都声明自己的 verifier readback 和最终 signer，而不是把“用户已经执行过命令”误当成“系统已经恢复”。
- 在 `54-安全恢复验证闭环` 之后，再补一个 `appendix/38-安全恢复验证闭环速查表` 就很自然了：长文已经解释了为什么 repair action 不等于 recovery closure，但实现、评审与交互实现时更需要一张更短的闭环矩阵。把 `/reload-plugins`、MCP reconnect、`/login`、`/remote-control` / bridge reconnect、restore+hydrate、`session_state_changed(idle)`、`files_persisted` 等压成“repair path / verifier readback / 最终 signer / 可清除对象 / 禁止的假闭环 / 关键证据”之后，安全专题就第一次拥有了一张可直接用于审查“某条修复路径有没有 verifier、有没有 signer、有没有在动作执行后就提前宣布闭环”的速查表。
- 继续往前推进后，可以更明确地把 `55-安全恢复自动验证门槛` 单独写出来：`54` 已经回答了 repair action 必须经过 verifier 和 signer 关环，但还没有回答“哪些闭环系统可以自动完成，哪些必须停留在人工确认态”。`PluginInstallationManager.ts` 已经在同一模块里明示了这条分界：新 marketplace 安装允许 auto-refresh，而 updates only 只设置 `needsRefresh`；`useManagePlugins.ts` 又进一步强调某些 auto-refresh 曾因 stale-cache bug 被拿掉，必须退回人工 `/reload-plugins`；`useManageMCPConnections.ts` 则展示了系统对 remote transport 自动重连的强主权，包括 backoff、重试上限和最终状态回写；相对地，`ChannelsNotice.tsx` 与 `teleport.tsx` 明确把 `/login` 后的 restart / `/status` 复核留给用户，而 `bridgeMain.ts` 也把 transient reconnect failure 留在 “try running the same command again” 的人工确认态。这样一来，源码已经很清楚地说明：自动撤警的真正门槛不是有没有修复命令，而是系统是否同时拥有 action ownership、verification ownership 与 interpretation ownership；只有三权都在系统手里，控制面才配 auto-close。
- 在 `55-安全恢复自动验证门槛` 之后，再补一个 `appendix/39-安全恢复自动验证门槛速查表` 就很自然了：长文已经解释了为什么只有在三权都在系统手里时才配 auto-close，但实现、评审与自动化策略设计时更需要一张更短的门槛矩阵。把新 marketplace 安装后的 plugin auto-refresh、plugin updates only、remote MCP transport automatic reconnection、`/login` 后认证恢复、bridge reconnect transient retry、restore+hydrate、authoritative idle / `files_persisted` 等压成“repair path / action ownership / verification ownership / signer ownership / auto-close 许可 / 何时必须转人工确认 / 关键证据”之后，安全专题就第一次拥有了一张可直接用于审查“这条恢复路径到底有没有资格自动撤警”的速查表。
- 继续往前推进后，可以更明确地把 `37-安全解释权限` 单独写出来：`36` 已经回答了“宿主只能看到哪些账本子集”，但还没有回答“它凭什么替完整控制面下结论”。`controlSchemas.ts` 与 `coreSchemas.ts` 说明协议全集本身不能直接推出解释权全集；`StructuredIO.ts` 说明默认宿主没有恢复账与 internal-event 面；`RemoteIO.ts` 说明更厚宿主的解释权也依赖初始化与 transport 条件；`DirectConnectManager.ts` 与 `RemoteSessionManager.ts` 的窄 control 子集说明窄宿主最合理的是局部解释；`remoteBridgeCore.ts` 在 recovery 窗口主动 drop 一部分事实，则进一步说明解释权限还会随时序窗口动态收窄。这使得 `37` 的核心结论很清楚：解释权不是默认附赠能力，而是从当前可见账本边界反推出来的受限权限。
- 继续往前推进后，可以更明确地把 `38-安全未知语义` 单独写出来：`37` 已经回答了“谁有解释权”，但还没有回答“系统在没有足够依据时该怎么办”。`DirectConnectManager.ts` 与 `RemoteSessionManager.ts` 对 unsupported subtype 显式回 error，说明“不支持”必须被显式表达而不是静默等待；`StructuredIO.ts` 用 `null` 与 no-op 表达“当前没有恢复账/持久面”；`RemoteIO.ts` 在条件不成立时直接 fail loudly，而不是偷偷退成伪完整模式；`remoteBridgeCore.ts` 在 recovery 窗口直接 drop control 和 result，则说明“当前不可判定”必须被显式保留；`sdkEventQueue.ts` 只在 authoritative turn-over signal 成立后才授予完整解释权，则进一步说明成熟系统宁可晚一点说，也不能早一点猜。这使得 `38` 的核心结论很清楚：不知道不是失败残渣，而是安全控制面必须拥有的一等语义。
- 在 `38-安全未知语义` 之后，再补一个 `appendix/22-安全未知语义速查表` 就很自然了：长文已经把 unsupported、无账本、条件未成立和恢复窗口不可判定这些“未知”讲清楚，但实现和评审时仍然需要一张更短的未知矩阵。把“系统当前缺什么、正确做法是什么、错误做法是什么、硬猜后会坏什么”压进一页后，安全专题就第一次拥有了可直接用于审查伪解释和伪成功路径的速查表。
- 继续往前推进后，可以更明确地把 `39-安全声明等级` 单独写出来：`38` 已经回答了“什么时候必须说不知道”，但还没有回答“在知道时为什么也不能只说 yes/no”。`SDKRateLimitInfoSchema` 把 allowed 拆成 `allowed / allowed_warning / rejected`；MCP 连接状态被拆成 `connected / failed / needs-auth / pending / disabled`；`post_turn_summary` 继续把运行结论细分成 `blocked / waiting / completed / review_ready / failed`，并附带 `status_detail` 与 `is_noteworthy`；`SDKAPIRetryMessageSchema` 又把失败声明细化成 typed error、HTTP status 与 retry budget；`CCRInitFailReason` 和 `OrgValidationResult` 则说明初始化和组织校验都更偏向“typed reason + descriptive message”而不是裸布尔。这样一来，源码已经很清楚地说明：成熟安全控制面不是二元裁决器，而是一台会按强度、理由和条件分级说话的声明机器。
- 在 `39-安全声明等级` 之后，再补一个 `appendix/23-安全声明等级速查表` 就很自然了：长文已经把允许类、连接类、运行类、重试类和初始化/校验类声明的分级逻辑讲清楚，但实现和评审时仍然需要一张更短的声明矩阵。把“声明族、典型等级、典型字段、真正表达什么、最危险的压扁误读”压进一页后，安全专题就第一次拥有了可直接用于下游接口评审和语义压缩审查的速查表。
- 继续往前推进后，可以更明确地把 `40-安全动作语法` 单独写出来：`39` 已经回答了“结论为什么要分级”，但还没有回答“结论给出后，正确下一步动作为何也必须被编码进协议”。`PermissionUpdateSchema` 与 `SDKControlPermissionRequestSchema` 说明权限请求天然带着建议修法而不是只有阻断；`useDirectConnect.ts`、`useRemoteSession.ts` 与 `useSSHSession.ts` 说明这些 suggestions 会被宿主直接消费；`SDKPostTurnSummaryMessageSchema` 继续把 `recent_action`、`needs_action` 与 `artifact_urls` 放进同一条 turn 摘要；`SDKControlRewindFilesResponseSchema` 与 `SDKAPIRetryMessageSchema` 又把修复可行性和等待/重试策略编码成 typed 分支；`MCPServerConnection`、`handleRemoteAuthFailure()`、`channelNotification.ts` 与 `useManageMCPConnections.ts` 则说明 `needs-auth / pending / disabled / failed` 的真正价值，在于把恢复路径拆开；`OrgValidationResult` 和 `CCRInitFailReason` 最后进一步证明 typed reason 的意义不是分类本身，而是防止错误补救。这样一来，源码已经很清楚地说明：成熟安全控制面不是静态声明面板，而是一台会把状态、理由、等级与下一步动作一起编码出来的控制语法机。
- 在 `40-安全动作语法` 之后，再补一个 `appendix/24-安全动作语法速查表` 就很自然了：长文已经解释了为什么成熟控制面必须把声明和动作绑在一起，但实现、评审与宿主接入时更需要一张更短的动作矩阵。把 `can_use_tool`、`requires_action`、`post_turn_summary`、`api_retry`、MCP 五态、`rewind_files`、`OrgValidationResult` 与 `CCRInitFailReason` 压成“声明族 / 典型状态 / 正确下一步 / 最危险错误动作 / 关键证据”之后，安全专题就第一次拥有了一张可直接用于检查状态压缩是否会误导动作路径的速查表。
- 继续往前推进后，可以更明确地把 `41-安全动作归属` 单独写出来：`40` 已经回答了“下一步该做什么”，但还没有回答“谁来做、写到哪、持续多久”。`PermissionUpdateDestinationSchema` 先把动作目的地拆成 `userSettings / projectSettings / localSettings / session / cliArg`；`supportsPersistence()` 又明确说明只有三类 settings 目标配拥有持久化资格，`session` 与 `cliArg` 不能被偷偷升格成长期授权；`PermissionPromptToolResultSchema` 与 `PermissionDecisionClassificationSchema` 则继续把宿主压回“忠实报告用户实际动作”的见证层，防止宿主把一次性允许偷偷变成永久允许；`useManageMCPConnections.ts` 又把 `auth`、`policy`、`disabled` 三类 gate 显式映射给用户、管理员或无人可立即修复的不同主体；`api_retry` 与 `rewind dry_run` 最后进一步说明系统自动动作和人工确认动作不能混写。这样一来，源码已经很清楚地说明：成熟安全控制面不只是在给动作，还在给动作的责任归属、写入层级与时间边界。
- 在 `41-安全动作归属` 之后，再补一个 `appendix/25-安全动作归属速查表` 就很自然了：长文已经解释了为什么动作需要继续绑定主体、作用域和持久层，但实现、评审与宿主接入时更需要一张更短的归属矩阵。把权限更新 destination、用户临时/永久决定、`requires_action`、`api_retry`、MCP 五态、rewind 预演/执行、组织校验失败等压成“信号 / 执行主体 / 写入范围 / 持久性 / 最危险越权者 / 关键证据”之后，安全专题就第一次拥有了一张可直接用于审查“对的动作是否会被错误主体代做”的速查表。
- 继续往前推进后，可以更明确地把 `42-安全动作完成权` 单独写出来：`41` 已经回答了“谁来做、写到哪、持续多久”，但还没有回答“谁有资格宣布已经做完”。`SDKSessionStateChangedMessageSchema` 与 `sdkEventQueue.ts` 先把 `session_state_changed(idle)` 写成 authoritative turn-over signal；`print.ts` 又明确要求 going idle 前先 `flushInternalEvents()`，说明局部收尾不能抢在事件持久化前宣布完成；`SDKFilesPersistedEventSchema` 与 `print.ts` 继续把文件持久化拆成独立事件，拒绝让普通 result 冒充落盘确认；`ccrClient.flush()` 的注释又进一步强调 delivery confirmation 与 server state 不是同一回事；`remoteBridgeCore.ts` 最后在 401 recovery 窗口主动 drop control/result，说明不可靠窗口里的局部执行痕迹不配拥有完成解释权。这样一来，源码已经很清楚地说明：成熟安全控制面不只是在给动作和归属，还在严格限制谁能对“完成”这件事签字。
- 在 `42-安全动作完成权` 之后，再补一个 `appendix/26-安全动作完成权速查表` 就很自然了：长文已经解释了为什么执行信号不能直接等于完成信号，但实现、评审与宿主接入时更需要一张更短的完成矩阵。把 `session_state_changed(idle)`、`flushInternalEvents()`、`files_persisted`、queue drain、401 recovery、rewind dry-run 与重启后 stale metadata 清理压成“动作 / 执行信号 / 完成签字信号 / 仍然不够的信号 / 最危险提前宣布 / 关键证据”之后，安全专题就第一次拥有了一张可直接用于审查伪完成与提前宣布问题的速查表。
- 继续往前推进后，可以更明确地把 `43-安全完成投影` 单独写出来：`42` 已经回答了“谁能对完成签字”，但还没有回答“不同宿主到底看到了多少签字链”。`session_state_changed(idle)` 与 `sdkEventQueue.ts` 给 SDK 流消费者暴露了一条强完成事件；`RemoteIO` 则继续接上 `restoredWorkerState`、internal-event read/write、`reportState`、`reportMetadata` 与 `flushInternalEvents()`，形成更厚的完成投影；默认 `StructuredIO` 反过来明确把恢复账与 internal-event flush 设成 `null` / no-op / zero，说明这类宿主不配自称拥有同等完成视角；`DirectConnectManager.ts` 与 `RemoteSessionManager.ts` 又把 control surface 收窄到几乎只剩 `can_use_tool`，进一步压缩了它们对整条完成链的资格；`remoteBridgeCore.ts` 最后说明 even 更厚的 bridge 也会在 recovery 窗口主动 drop result/control，从而临时收窄完成投影。这样一来，源码已经很清楚地说明：成熟安全控制面不只定义完成签字权，还定义不同宿主最多能看到多少完成签字链。
- 在 `43-安全完成投影` 之后，再补一个 `appendix/27-安全完成投影速查表` 就很自然了：长文已经解释了不同宿主只能看到完成签字链的子集，但实现、评审与宿主接入时更需要一张更短的宿主矩阵。把 SDK 流消费者、RemoteIO/CCR、默认 StructuredIO、bridge 正常 / recovery 窗口、DirectConnectManager、RemoteSessionManager 压成“宿主 / 可见完成信号 / 缺失账本 / 最安全说法上限 / 最危险误读 / 关键证据”之后，安全专题就第一次拥有了一张可直接用于审查“这个宿主是不是把局部完成说得过满”的速查表。
- 继续往前推进后，可以更明确地把 `44-安全完成差异显化` 单独写出来：`43` 已经回答了“不同宿主看到的是不同子集”，但还没有回答“这种差异是否应该被用户显式看到”。`buildMcpProperties()` 会把异质 MCP 状态压成计数摘要；`sdkMessageAdapter.ts` 会把结构化 status 压成 generic informational text；`bridgeStatusUtil.ts` 又把 bridge 状态压成 `active / reconnecting / failed / connecting` 四个总体标签；可 `replBridgeTransport.ts` 同时明确写出 connected 只是 write-readiness，不是 read-readiness。这说明底层早已承认宿主差异，但展示层仍会在多个地方重新压平。这样一来，源码已经很清楚地说明：下一代统一安全控制台不该只内部保留宿主差异，而必须把“当前宿主缺哪条完成链、因此这条状态最多能说到哪一步”显式做成用户可见语义。
- 在 `44-安全完成差异显化` 之后，再补一个 `appendix/28-安全完成差异显化速查表` 就很自然了：长文已经解释了为什么界面必须显式展示宿主差异，但实现、评审与产品设计时更需要一张更短的界面矩阵。把 `/status` 的 MCP 摘要、remote `sdkMessageAdapter`、bridge 总体标签、repl bridge transport label、StructuredIO / RemoteIO / DirectConnect / RemoteSessionManager 这些典型压缩点压成“当前界面 / 当前压缩写法 / 被隐藏的盲区 / 最少必须显化的字段 / 最不该继续复用的文案 / 关键证据”之后，安全专题就第一次拥有了一张可直接用于审查“展示层是否又把底层宿主差异抹平”的速查表。
- 继续往前推进后，可以更明确地把 `45-安全完成差异字段` 单独写出来：`44` 已经回答了“这些差异必须显式展示”，但还没有回答“到底该用哪些字段展示”。`AppStateStore.ts` 已经明确定义了 `remoteConnectionStatus`、`replBridgeEnabled / Connected / SessionActive / Reconnecting / Error`、`mcp.clients` 等状态槽位；`replBridgeTransport.ts` 又把 write-readiness 与 read-readiness 显式分开；`StructuredIO.ts` 和 `RemoteIO.ts` 则进一步把恢复账、internal-event flush 与 pending depth 的有无做成可观察差异；`DirectConnectManager.ts` 与 `RemoteSessionManager.ts` 最后再把 `supported_control_subtypes` 的天然收窄暴露出来。这样一来，源码已经很清楚地说明：统一安全控制台真正缺的不是更多状态词，而是一组能稳定表达 `host_kind / projection_grade / missing_ledgers / readiness_split / supported_control_subtypes / completion_claim_ceiling` 的正式字段。
- 在 `45-安全完成差异字段` 之后，再补一个 `appendix/29-安全完成差异字段速查表` 就很自然了：长文已经解释了统一安全控制台最少该补哪些字段，但实现、评审与产品设计时更需要一张更短的字段矩阵。把 `host_kind`、`projection_grade`、`missing_ledgers[]`、`write_ready/read_ready`、`label_basis`、`supported_control_subtypes[]`、`restored_worker_state_supported`、`internal_event_flush_supported`、`recovery_window_open` 与 `completion_claim_ceiling` 压成“字段 / 主要来源 / 推荐展示层级 / 缺失后最可能的误导 / 关键证据”之后，安全专题就第一次拥有了一张可直接用于审查“宿主盲区有没有被字段化”的速查表。
- 继续往前推进后，可以更明确地把 `46-安全完成差异卡片` 单独写出来：`45` 已经回答了“该有哪些字段”，但还没有回答“字段该挂到哪张卡、按什么优先级显示”。`Status.tsx` 与 `status.tsx` 说明当前 `/status` 面偏向摘要 property 列表，天然容易把宿主盲区埋深；`BridgeDialog.tsx` 说明现有桥接对话框会显示 status label、error、environment/session id 和 footer，但不会优先表达 completion ceiling；`IdeStatusIndicator.tsx` 与 `useIdeConnectionStatus.ts` 又说明 IDE 状态被压成 connected/pending/disconnected 三态；`useMcpConnectivityStatus.tsx` 则继续把 MCP 问题压成 failed / needs-auth 计数通知。这说明统一安全控制台下一步最关键的不是再补字段，而是按解释上限优先级把这些字段挂回主体与资格卡、外部能力卡、警告层和动作层，避免再次在卡片层被埋掉。
- 在 `46-安全完成差异卡片` 之后，再补一个 `appendix/30-安全完成差异卡片速查表` 就很自然了：长文已经解释了这些字段该挂到哪张卡、按什么优先级显示，但实现、评审与设计讨论时更需要一张更短的卡片矩阵。把 `completion_claim_ceiling`、recovery suspension 字段、`host_kind`、`projection_grade`、`missing_ledgers[]`、`write_ready/read_ready`、`supported_control_subtypes[]` 等压成“字段组 / 推荐卡片挂载点 / 展示优先级 / 默认动作 / 最危险埋深方式 / 关键证据”之后，安全专题就第一次拥有了一张可直接用于审查“这些宿主盲区字段有没有被挂到正确位置”的速查表。
- 继续往前推进后，可以更明确地把 `47-安全完成差异升级规则` 单独写出来：`46` 已经回答了“字段该挂到哪张卡”，但还没有回答“哪些问题该立即抢占界面、哪些只需中层提示”。`notifications.tsx` 已经把 `immediate / high / medium / low` 做成正式注意力仲裁语义；`useReplBridge.tsx` 对 `Remote Control failed` 直接给 `immediate`，说明实时推翻当前完成结论的问题必须马上抢断；`useManagePlugins.ts` 与 `useManageMCPConnections.ts` 则把 flagged plugins 与 channels blocked 放进 `high`，说明会改写下一步动作路径的问题需要强提醒；`useIDEStatusIndicator.tsx` 与 `useMcpConnectivityStatus.tsx` 又把 IDE disconnected、MCP failed / needs-auth 放进 `medium`，说明显著退化但不必抢断的宿主差异适合中层提示；而 plugin reload pending 与 statusline trust blocked 则被放在 `low`。这样一来，源码已经很清楚地说明：宿主盲区显化不只需要字段和卡片，还需要一套基于误导风险的升级规则。
- 在 `47-安全完成差异升级规则` 之后，再补一个 `appendix/31-安全完成差异升级规则速查表` 就很自然了：长文已经解释了哪些宿主盲区必须抢占界面、哪些只需中层提示，但实现、评审与设计讨论时更需要一张更短的升级矩阵。把 `completion_claim_ceiling`、recovery suspension、`host_kind`、`projection_grade`、`missing_ledgers[]`、`write_ready/read_ready`、`supported_control_subtypes[]`、MCP failed / needs-auth、IDE disconnected、plugin reload pending 等压成“字段组 / 默认优先级 / 升级条件 / 绝不应降到哪一层 / 关键证据”之后，安全专题就第一次拥有了一张可直接用于审查“宿主盲区有没有被正确升级”的速查表。
- 继续往前推进后，可以更明确地把 `48-安全完成差异交互路由` 单独写出来：`47` 已经回答了“哪些宿主盲区该抢占界面”，但还没有回答“它们一旦变化时，卡片、通知、动作和清除条件是否会一起改口”。`notifications.tsx` 已经把 `immediate/high/medium/low` 和当前通知抢占做成正式注意力仲裁；`PromptInput/Notifications.tsx` 又说明用户真正只会看到一个 `notifications.current`；相对地，`Status.tsx` 与 `utils/status.tsx` 仍主要是属性摘要层，`BridgeDialog.tsx` 会显示 status label、error、environment/session id 和 footer，却不会把 completion ceiling、missing ledgers 与动作收口一起联动；`useIdeConnectionStatus.ts` 和 `IdeStatusIndicator.tsx` 也仍把宿主资格压成低维状态。这说明源码已经拥有“注意力路由”“状态摘要”“宿主差异承认”三种成熟局部能力，但还缺最后一层统一状态机：当盲区变宽时，必须原子地降低主卡结论、升级通知、收紧动作并延后清除旧结论。这样一来，安全专题就能继续从“显示什么”推进到“同一安全事实如何在同一时刻只保留一种可行动解释”。
- 在 `48-安全完成差异交互路由` 之后，再补一个 `appendix/32-安全完成差异交互路由速查表` 就很自然了：长文已经解释了为什么宿主盲区必须被路由成卡片改口、通知抢位、动作收口和清除守纪的同一时刻联动，但实现、评审与协议对齐时更需要一张更短的联动矩阵。把 recovery window、bridge hard fail、`completion_claim_ceiling` 下调、`missing_ledgers[]` 新增、`write_ready/read_ready` 分裂、subtype 缺口、channels blocked、flagged plugins、IDE disconnected、MCP failed / needs-auth、plugin reload pending 等压成“触发器 / 典型字段 / 卡片更新 / 通知优先级 / 动作收口 / 清除条件 / 关键证据”之后，安全专题就第一次拥有了一张可直接用于审查“这些宿主盲区有没有被成套路由，而不是只改一条提示文案”的速查表。
- 继续往前推进后，可以更明确地把 `49-安全完成差异清除纪律` 单独写出来：`48` 已经回答了宿主盲区变化时卡片、通知、动作和清除条件必须一起联动，但还没有回答“什么证据出现之后，系统才有资格真的删除旧告警、撤销旧结论、恢复旧动作”。`notifications.tsx` 已经说明删除与失效是显式动作，不是自然蒸发；`ccrClient.ts` 会在 worker init 时主动清掉 prior crash 留下的 stale `pending_action/task_summary`，并把 `state_restored` 的记录放到成功初始化之后；`print.ts` 又明确要求 restore 与 hydrate 并行等待，避免 SSE catchup 落在 fresh default 上；`remoteBridgeCore.ts` 则在 401 recovery 窗口直接 drop control/result，而不是抢先宣布恢复；`sdkEventQueue.ts` 最后再把 `session_state_changed(idle)` 命名为 authoritative turn-over。这样一来，源码已经很清楚地说明：对宿主盲区而言，降级可以基于风险迹象，恢复必须基于 fresh 回读与正式 signer，下一代统一安全控制台必须把“不要过早忘记旧风险”提升成独立纪律。
- 在 `49-安全完成差异清除纪律` 之后，再补一个 `appendix/33-安全完成差异清除纪律速查表` 就很自然了：长文已经解释了为什么宿主盲区恢复时不能先删旧告警，而必须等待足够强的 fresh 证据，但实现、评审与协议对齐时更需要一张更短的清除矩阵。把 recovery window、bridge fail、`completion_claim_ceiling` 下调、`missing_ledgers[]`、stale metadata、authoritative idle、`files_persisted`、IDE disconnected、MCP failed / needs-auth、channels blocked、flagged plugins 等压成“旧结论 / 禁止依赖的弱信号 / 允许清除的 fresh 证据 / 允许先恢复什么 / 绝不能先恢复什么 / 关键证据”之后，安全专题就第一次拥有了一张可直接用于审查“控制面是不是在抢先恢复、抢先遗忘旧风险”的速查表。
- 继续往前推进后，可以更明确地把 `50-安全恢复签字层级` 单独写出来：`49` 已经回答了“恢复必须等待 fresh 证据”，但还没有回答“不同强度的 fresh 证据到底分别有资格恢复什么”。`replBridgeTransport.ts` 已经明确 connected 只是 write-readiness，不是 read-readiness；`BridgeDialog.tsx` 仍主要消费 status label 和 error，这类信号最多只能当活性 signer；`ccrClient.ts` 与 `remoteIO.ts` 则把 `state_restored / restoredWorkerState / reportState / reportMetadata` 做成更强一层的恢复与状态 signer；`sdkEventQueue.ts` 又把 `session_state_changed(idle)` 命名为 authoritative turn-over；`print.ts` 最后再把 `files_persisted` 单独分出，说明 effect signer 也不能并入普通 result。这样一来，源码已经很清楚地说明：成熟安全控制面不该只有“恢复 / 未恢复”两档，而应正式区分活性 signer、restore signer、state signer、effect signer 与 explanation signer，并让不同层级对象只接受与自己同阶的恢复签字。
- 在 `50-安全恢复签字层级` 之后，再补一个 `appendix/34-安全恢复签字层级速查表` 就很自然了：长文已经解释了为什么恢复证据必须分层签字，但实现、评审与宿主对齐时更需要一张更短的 signer 矩阵。把活性 signer、restore signer、state signer、effect signer、explanation signer 压成“signer 层级 / 典型来源 / 可恢复对象 / 不可恢复对象 / 最危险误读 / 关键证据”之后，安全专题就第一次拥有了一张可直接用于审查“某个绿色信号有没有越级替更高层对象签字”的速查表。
- 继续往前推进后，可以更明确地把 `51-安全恢复中间态` 单独写出来：`50` 已经回答了恢复 signer 的层级，但还没有回答“系统恢复到一半时到底该如何命名自己”。`replBridgeTransport.ts` 已经明确 `outboundOnly` 用于 mirror-mode attachments，只启用写路径而不接收入站 prompt/control；同文件又明确 `isConnectedStatus()` 只是 write-readiness，不是 read-readiness；`ccrClient.ts` 与 `print.ts` 则共同说明 restore 和 hydrate 解决的是“不是 fresh default”，并不自动等于 fresh；`DirectConnectManager.ts` 与 `RemoteSessionManager.ts` 最后再说明某些宿主即使在线也只支持 `can_use_tool` 这种窄 control 面。与此同时，`bridgeStatusUtil.ts` 却会把 `sessionActive || connected` 压成同一个 `Remote Control active`。这样一来，源码已经很清楚地说明：部分恢复状态不是例外，而是正式状态族，下一代统一安全控制台必须显式区分 `mirror-only`、`write-ready/read-blind`、`restored-but-not-fresh`、`control-narrow`、`result-ready/effects-pending` 等中间态，避免再次把半恢复读成全恢复。
- 在 `51-安全恢复中间态` 之后，再补一个 `appendix/35-安全恢复中间态速查表` 就很自然了：长文已经解释了为什么部分恢复必须被正式命名，但实现、评审与宿主接入对齐时更需要一张更短的中间态矩阵。把 `mirror-only`、`write-ready/read-blind`、`restored-but-not-fresh`、`control-narrow`、`result-ready/effects-pending`、`state-ready/explanation-pending` 压成“中间态 / 典型来源 / 当前可见账本 / 当前可用动作 / 禁止文案 / 默认跳转 / 关键证据”之后，安全专题就第一次拥有了一张可直接用于审查“这个半恢复状态有没有被正确命名、有没有被压平成同一句绿色文案”的速查表。
- 继续往前推进后，可以更明确地把 `52-安全恢复文案禁令` 单独写出来：`51` 已经回答了半恢复状态必须被正式命名，但还没有回答“即使系统知道自己只恢复到一半，它到底被允许说哪些词”。`bridgeStatusUtil.ts` 当前会把 `sessionActive || connected` 压成 `Remote Control active`；`status.tsx` 会把 IDE 与 MCP 压成 `Connected to ...`、`Installed ...`、`Not connected`、`connected / need auth / pending / failed` 这类摘要词；而通知层在 `useIDEStatusIndicator.tsx` 与 `useMcpConnectivityStatus.tsx` 里反而更擅长说缺口语言。这样一来，源码已经很清楚地说明：下一代统一安全控制台不只要有中间态词汇表，还必须给语言本身建立禁令，禁止在半恢复状态下继续使用过满绿色词，并要求所有恢复态文案遵守“已恢复部分 + 当前缺口 + 默认下一步”的受约束句式。
- 在 `52-安全恢复文案禁令` 之后，再补一个 `appendix/36-安全恢复文案禁令速查表` 就很自然了：长文已经解释了为什么半恢复状态下必须禁止过满绿色词，但实现、评审与文案校验时更需要一张更短的规则矩阵。把 L0 活性 signer、`mirror-only`、`write-ready/read-blind`、L1 restore signer、`restored-but-not-fresh`、L2 state signer、`control-narrow`、L3 effect signer、`result-ready/effects-pending`、L4 explanation signer 压成“对象层级 / 当前证据强度 / 禁止词 / 允许词 / 默认句式 / 关键证据”之后，安全专题就第一次拥有了一张可直接用于审查“某句绿色文案有没有超出当前证据强度”的速查表。
- 继续往前推进后，可以更明确地把 `53-安全恢复跳转纪律` 单独写出来：`52` 已经回答了恢复文案必须受约束，但还没有回答“诚实文案接下来应把用户带去哪里”。`useManagePlugins.ts` 已经把 flagged plugins 指向 `/plugins`、把 activation pending 指向 `/reload-plugins`；`useMcpConnectivityStatus.tsx` 已把 failed / needs-auth 统一指向 `/mcp`；`ChannelsNotice.tsx` 与 `PromptInput/Notifications.tsx` 又把 auth bottleneck 指向 `/login`；`RemoteCallout.tsx` 与 `bridgeMain.ts` 最后说明 Remote Control 域应回到 `/remote-control`；而 IDE 插件断连与安装失败则更倾向先去 `/status`。这样一来，源码已经很清楚地说明：Claude Code 现有系统其实已经有一套分散的默认修复路径语义，下一代统一安全控制台应该把它正式提升为恢复跳转纪律，让每种半恢复状态都绑定一个 dominant repair path，而不是把路由责任继续外包给用户。
- 在 `53-安全恢复跳转纪律` 之后，再补一个 `appendix/37-安全恢复跳转纪律速查表` 就很自然了：长文已经解释了为什么每种半恢复状态都必须绑定唯一 dominant repair path，但实现、评审与交互校验时更需要一张更短的路由矩阵。把 flagged plugins、plugin activation pending、MCP failed / needs-auth、channels auth bottleneck、global not logged in、IDE plugin not connected、IDE install failed、bridge attach / enable / disconnect、`mirror-only`、`write-ready/read-blind`、`restored-but-not-fresh` 等压成“状态 / 中间态 / 当前缺口归属 / 默认跳转 / 次级跳转 / 禁止歧义 / 关键证据”之后，安全专题就第一次拥有了一张可直接用于审查“某个半恢复状态有没有唯一默认修复路径”的速查表。
- 继续往前推进后，可以更明确地把 `54-安全恢复验证闭环` 单独写出来：`53` 已经回答了半恢复状态必须绑定唯一默认修复路径，但还没有回答“用户执行了这条路径之后，控制面凭什么宣布问题真的解决了”。`refreshActivePlugins()` 已明确区分旧 `needsRefresh` 路径的 stale data 与新的全量重建路径，说明 `/reload-plugins` 的 verifier 是 cache 清空、状态重载和 `pluginReconnectKey` bump；`reconnectMcpServerImpl()` 又把 MCP reconnect 分成 clear cache、`connectToServer()`、以及 tools/commands/resources 重新可见三段；`ChannelsNotice.tsx` 和 `teleport.tsx` 则进一步表明 `/login` 常常还只是起点，后面仍要 restart 或 `/status` 重新核对；`bridgeMain.ts` 最后说明 `bridge/reconnect` 成功与否、pointer 是否保留、是否需要重试都不能由发起动作本身替代。这样一来，源码已经很清楚地说明：repair action 解决的是修复意图，recovery closure 解决的是真相闭环，下一代统一安全控制台必须要求每条 repair path 都声明自己的 verifier readback 和最终 signer，而不是把“用户已经执行过命令”误当成“系统已经恢复”。
- 在 `54-安全恢复验证闭环` 之后，再补一个 `appendix/38-安全恢复验证闭环速查表` 就很自然了：长文已经解释了为什么 repair action 不等于 recovery closure，但实现、评审与交互实现时更需要一张更短的闭环矩阵。把 `/reload-plugins`、MCP reconnect、`/login`、`/remote-control` / bridge reconnect、restore+hydrate、`session_state_changed(idle)`、`files_persisted` 等压成“repair path / verifier readback / 最终 signer / 可清除对象 / 禁止的假闭环 / 关键证据”之后，安全专题就第一次拥有了一张可直接用于审查“某条修复路径有没有 verifier、有没有 signer、有没有在动作执行后就提前宣布闭环”的速查表。
- 继续往前推进后，可以更明确地把 `55-安全恢复自动验证门槛` 单独写出来：`54` 已经回答了 repair action 必须经过 verifier 和 signer 关环，但还没有回答“哪些闭环系统可以自动完成，哪些必须停留在人工确认态”。`PluginInstallationManager.ts` 已经在同一模块里明示了这条分界：新 marketplace 安装允许 auto-refresh，而 updates only 只设置 `needsRefresh`；`useManagePlugins.ts` 又进一步强调某些 auto-refresh 曾因 stale-cache bug 被拿掉，必须退回人工 `/reload-plugins`；`useManageMCPConnections.ts` 则展示了系统对 remote transport 自动重连的强主权，包括 backoff、重试上限和最终状态回写；相对地，`ChannelsNotice.tsx` 与 `teleport.tsx` 明确把 `/login` 后的 restart / `/status` 复核留给用户，而 `bridgeMain.ts` 也把 transient reconnect failure 留在 “try running the same command again” 的人工确认态。这样一来，源码已经很清楚地说明：自动撤警的真正门槛不是有没有修复命令，而是系统是否同时拥有 action ownership、verification ownership 与 interpretation ownership；只有三权都在系统手里，控制面才配 auto-close。
- 在 `55-安全恢复自动验证门槛` 之后，再补一个 `appendix/39-安全恢复自动验证门槛速查表` 就很自然了：长文已经解释了为什么只有在三权都在系统手里时才配 auto-close，但实现、评审与自动化策略设计时更需要一张更短的门槛矩阵。把新 marketplace 安装后的 plugin auto-refresh、plugin updates only、remote MCP transport automatic reconnection、`/login` 后认证恢复、bridge reconnect transient retry、restore+hydrate、authoritative idle / `files_persisted` 等压成“repair path / action ownership / verification ownership / signer ownership / auto-close 许可 / 何时必须转人工确认 / 关键证据”之后，安全专题就第一次拥有了一张可直接用于审查“这条恢复路径到底有没有资格自动撤警”的速查表。
- 继续往前推进后，可以更明确地把 `56-安全恢复留痕纪律` 单独写出来：`55` 已经回答了哪些闭环该自动完成、哪些必须停在人工确认，但还没有回答“那些未闭环恢复会不会被系统静默忘掉”。`PluginInstallationManager.ts` 已明确把 auto-refresh 失败回退成 `needsRefresh=true`；`useManagePlugins.ts` 又强调 `/reload-plugins` 消费前不得自动 reset `needsRefresh`；`useManageMCPConnections.ts` 则把重连过程显式外化成 `pending`、`reconnectAttempt`、`maxReconnectAttempts`，最终成功收敛或失败落成 `failed`；`bridgeMain.ts` 更进一步要求 transient reconnect failure 保留 pointer、提示再次运行同一命令，并且 crash-recovery pointer 会立即写入并按小时刷新；`notifications.tsx` 最后说明即使是 UI 痕迹的删除，也必须靠显式 `invalidates`、timeout 或 remove。这些证据合在一起已经很清楚地说明：下一代统一安全控制台不只要会判断什么时候不能 auto-close，还必须强制未闭环恢复保留可重试、可回访、可解释的痕迹，避免“问题没解决但系统已经忘了”。
