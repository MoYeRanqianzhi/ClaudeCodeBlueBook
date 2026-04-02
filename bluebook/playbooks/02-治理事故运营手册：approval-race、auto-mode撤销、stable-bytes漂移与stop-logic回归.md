# 治理事故运营手册：approval-race、auto-mode撤销、stable-bytes漂移与stop-logic回归

这一章把 `guides/28` 继续推进到运营层。

它主要回答五个问题：

1. 为什么安全与省 token 最终必须进入事故运营，而不是只停在治理矩阵。
2. 审批竞速、auto mode 回收、stable-bytes 漂移和 stop-logic 漏洞分别该怎样复盘。
3. 怎样从第一性原理判断一笔 token 花得有没有决策增益。
4. 怎样把 approval race、automation lease 与 stable bytes 统一纳入运营仪表盘。
5. 怎样用苏格拉底式追问避免把治理设计退回成“更多规则”。

## 0. 代表性源码锚点

- `claude-code-source-code/src/utils/permissions/permissionSetup.ts:235-1283`
- `claude-code-source-code/src/utils/permissions/filesystem.ts:1252-1302`
- `claude-code-source-code/src/utils/permissions/permissions.ts:593-984`
- `claude-code-source-code/src/cli/structuredIO.ts:561-608`
- `claude-code-source-code/src/hooks/toolPermission/handlers/interactiveHandler.ts:244-300`
- `claude-code-source-code/src/services/remoteManagedSettings/index.ts:430-540`
- `claude-code-source-code/src/services/policyLimits/index.ts:504-520`
- `claude-code-source-code/src/services/compact/autoCompact.ts:257-338`
- `claude-code-source-code/src/utils/toolSearch.ts:712-760`
- `claude-code-source-code/src/utils/toolResultStorage.ts:739-860`

这些锚点共同说明：

- Claude Code 的治理成熟度不只在“顺序设计得对”，还在它愿意把错误决策、漂移字节和自动化失效纳入正式运营。

## 1. 第一性原理：治理为什么必须进入运营层

从第一性原理看，治理系统真正要避免的不是：

- 规则不够多

而是：

- 系统在错误的顺序上花了错误的 token，得出错误的结论，还没人知道为什么

因此成熟治理最终都要进入运营层，去回答：

1. 这次事故属于顺序失效、失败语义失配，还是 stop logic 缺席。
2. 这次成本上升，是因为决策真的更难，还是因为快路径失效。
3. 这次审批变慢，是治理更严了，还是 approval race 退化了。

## 2. 事故分类法

治理事故最少分成六类：

```text
1. order violation
- 某条规则被放错顺序，导致错误 fast-path 或错误阻断

2. hard-guard bypass
- 本应不可被 mode 覆盖的保护被绕开

3. failure-semantics mismatch
- 本该 fail-open / fail-closed / human-fallback 的资产被错判

4. approval-race degradation
- 原本应并发竞速的审批路径退化成串行或 split-brain

5. stable-bytes drift
- prompt/tool/output 的制度字节漂移，导致成本或行为突变

6. stop-logic failure
- 自动化继续重试，但其实已经没有决策增益
```

## 3. 治理事故复盘模板

```text
事故现象:
- 是误放行、误阻断、审批过慢，还是 token 激增

事故分类:
- order / guard / semantics / race / stable-bytes / stop-logic

交互条件:
- interactive / headless / managed / local

触发链:
- 哪条 fast-path
- 哪个 classifier
- 哪个 approval source

成本表现:
- token
- latency
- waiting time

修复动作:
- 调整顺序 / 调整失败语义 / 新增撤销条件 / 新增 drift 检查
```

## 4. Approval-Race 运营检查

任何审批异常都先看这张表：

```text
[ ] 哪些通道参与了 race
[ ] 谁 claim 了最终决策
[ ] 谁被取消了，但本应更早返回
[ ] 是否有某通道错误地获得了修改输入的权力
[ ] race 退化是否导致等待时间显著上升
```

如果不单独审 approval race，团队会误以为：

- “治理更严格了，所以更慢”

而真实问题可能是：

- 本应并发的治理协议退化了

## 5. Automation Lease 回收演练

任何自动化能力都应定期演练回收：

```text
演练 1:
- model / mode 变化，确认自动化被撤销

演练 2:
- denial limit 达阈值，确认回退人工或停机

演练 3:
- transcript too long，确认不再盲重试

演练 4:
- managed settings / policy limits 变化，确认本地状态被重新校准
```

重点不是“自动化还能不能继续跑”，而是：

- 当自动化不该继续时，系统能否体面地停下来

## 6. Stable-Bytes Drift Audit

运营层要长期看四类制度字节：

```text
1. prompt sections / boundary
2. tool visibility / tool order
3. replacement preview / replay marker
4. sticky headers / feature bits / betas
```

每次 drift 审计都要问：

1. 哪个字节漂移了。
2. 漂移是否有书面理由。
3. 漂移是否影响 cache key、审批、解释力或 replay。
4. 漂移后是否已有回滚开关。

## 7. Decision-Gain 回归面板

治理层的成本回归至少要长期看：

```text
- fast-path 命中率
- classifier 调用率
- classifier token / latency / cost
- permission waiting time
- auto path 被回收的频率
- stop-logic 触发次数
```

只有看到这组指标，你才能判断：

- 系统是在更贵地做更好的判断，还是在更贵地重复旧判断

## 8. Stop-Logic 漏洞演练

任何自动治理链路都应专门演练下面三种失败：

```text
1. hopeless retry
- 明知不会变，还在继续判

2. humanless escalation
- 明明无人接管，却仍假装等待人工

3. expensive-no-op
- 花了 token，但不会改变最终结论
```

成熟治理不是更会重试，而是更知道：

- 什么时候应该停止花钱

## 9. 苏格拉底式追问

在你准备再加一条治理逻辑前，先问自己：

1. 我修的是顺序，还是只是堆了一个新检查器。
2. 这次失败是资产分型错了，还是 stop logic 没写。
3. 自动化有没有合法撤销路径。
4. 这次多花的 token 还能改变什么。
5. 我现在是在增强治理，还是只是在增加治理开销。

## 10. 一句话总结

治理系统的终局不是“规则更多”，而是把错误顺序、失败语义失配、审批退化、stable-bytes drift 和 stop-logic 漏洞都纳入正式运营。
