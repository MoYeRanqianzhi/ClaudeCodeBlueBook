# 研究日志

## 当前基线

- 日期: `2026-04-02`
- 工作目录: `/home/mo/m/projects/cc/analysis/.worktrees/mainloop`
- 研究源码: `claude-code-source-code/`
- 目标版本: `v2.1.88`

### A027. 宿主修复失真之后，下一层应进入宿主修复纠偏层

- Prompt repair distortion 即使已经被写成 repair object 伪绑定、摘要回滚与假重入的反例，如果团队不能进一步把这些失真压回固定纠偏顺序、拒收升级路径与改写模板骨架，Prompt 修复就仍会围绕更制度化的事故叙事工作；这说明 Prompt 线下一层最值钱的不是继续补坏样例，而是把 repair distortion 压成 repair correction guide。
- Governance repair distortion 即使已经被写成 authority 假恢复、假窗口重置与免费重入的反例，如果团队不能进一步把这些失真压回固定纠偏顺序、拒收升级路径与改写模板骨架，安全设计与省 token 设计就仍会围绕 mode、面板与默认继续各自修补；这说明治理线下一层最值钱的不是继续补坏样例，而是把 repair distortion 压成 repair correction guide。
- Structure repair distortion 即使已经被写成 breadcrumb 篡位、旁路写回与 anti-zombie 伪证明的反例，如果团队不能进一步把这些失真压回固定纠偏顺序、拒收升级路径与改写模板骨架，源码先进性就仍会围绕目录美学、日志繁荣与恢复成功率工作；这说明结构线下一层最值钱的不是继续补坏样例，而是把 repair distortion 压成 repair correction guide。
- 这意味着蓝皮书在宿主修复失真之后需要继续长出“宿主修复纠偏层”：
  - `navigation/57` 负责统一入口。
  - `guides/63-65` 负责三类宿主修复演练失真的固定纠偏顺序、拒收升级路径与改写模板骨架。
- 这也意味着下一步如果还要继续深化，最值钱的候选不是继续补 guide 叙述，而是考虑新的 `api/60+` 或 `playbooks/41+`，把这些 repair correction 继续压成宿主可消费规则面或新的演练手册。

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

### A026. 宿主修复演练之后，下一层应进入宿主修复失真反例层

- Prompt repair drill 即使已经被写成共享升级卡、rollback drill 与 re-entry drill，如果团队不能进一步指出 repair object 伪绑定、protocol truth 被修复说明掩盖、摘要回滚与假重入这些失真，Prompt 修复就仍会围绕更制度化的事故叙事工作；这说明 Prompt 线下一层最值钱的不是继续补 playbook，而是把 repair drill 压成 repair distortion casebook。
- Governance repair drill 即使已经被写成共享升级卡、window reset 与 repricing drill，如果团队不能进一步指出 authority 假恢复、stale ledger 漂白、假窗口重置与免费重入这些失真，安全设计与省 token 设计就仍会围绕 mode、仪表盘与默认继续各自补救；这说明治理线下一层最值钱的不是继续补 playbook，而是把 repair drill 压成 repair distortion casebook。
- Structure repair drill 即使已经被写成共享升级卡、writeback restoration 与 anti-zombie drill，如果团队不能进一步指出 breadcrumb 篡位、resume 顺序隐式化、旁路写回、anti-zombie 伪证明与 reconnect 冒充 rollback 这些失真，源码先进性就仍会围绕目录美学、日志繁荣与恢复成功率工作；这说明结构线下一层最值钱的不是继续补 playbook，而是把 repair drill 压成 repair distortion casebook。
- 这意味着蓝皮书在宿主修复演练之后需要继续长出“宿主修复失真反例层”：
  - `navigation/56` 负责统一入口。
  - `casebooks/34-36` 负责三类宿主修复演练的假修复、假回滚与假重入反例。
- 这也意味着下一步如果还要继续深化，最值钱的候选不是继续补坏样例名录，而是考虑新的 `guides/63+`，把这些 repair drill 失真继续压回固定纠偏顺序、拒收升级路径与改写模板骨架。

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
- `query.ts`、`sessionStorage.ts`、`REPL.tsx`、`replBridge.ts` 等热点文件依然很大；后续若继续写“源码先进性”，必须同时写基础设施优点与热点文件债务。
- workflow engine 的类型入口和 transcript 归档语义当前可见，但主体实现未完整展开；后续必须持续区分“已可证实的 task 维度”与“尚未完全展开的引擎细节”。
