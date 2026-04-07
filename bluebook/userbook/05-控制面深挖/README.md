# 控制面深挖

这一层只继承 [../README.md](../README.md) 已判清的问题分型，负责把 Prompt / governance / current-truth 的最小顺序翻成用户动作与相邻替身拒收。
它不再重写 speaking-rights、申诉链或完整治理公式；若你已经开始追问“谁签字 / 谁记账 / 谁负责恢复 / 能不能 reopen”，直接回 `security / risk / playbooks`。

## trusted-inputs 梯子

如果你现在卡在“到底哪把钥匙先说了算”，先不要把 trust、auth、approval 与 probe 写成同一个准入词。用户侧更稳的最小顺序是：

1. `workspace trust`
   - 当前工作目录是否允许进入更高风险工作面。
2. `project MCP approval`
   - 项目级 `.mcp.json` 是否被正式承认。
3. `bridge eligibility`
   - 当前 remote-control / bridge 场景是否具备被接管资格。
4. `trusted-device auth`
   - 当前设备与账号能否代表用户继续签发远端动作。
5. `health-check runtime`
   - 当前 runtime 是否能被探活、诊断或继续消费。

这五层只共享“都像准入”，不共享 signer：

- `skip trust dialog` 不等于 `project MCP approval`
- `bridge eligible` 不等于 `trusted-device auth`
- `health-check passed` 不等于前四层都已成立

需要分别下潜时，优先回：

- [14-来源信任、Trust Dialog 与 Plugin-only Policy：扩展面为何分级信任.md](./14-%E6%9D%A5%E6%BA%90%E4%BF%A1%E4%BB%BB%E3%80%81Trust%20Dialog%20%E4%B8%8E%20Plugin-only%20Policy%EF%BC%9A%E6%89%A9%E5%B1%95%E9%9D%A2%E4%B8%BA%E4%BD%95%E5%88%86%E7%BA%A7%E4%BF%A1%E4%BB%BB.md)
- [21-Host、Viewer 与 Health Check：为什么 server、remote-control、assistant、doctor 不能写成同一类会外入口.md](./21-Host%E3%80%81Viewer%20%E4%B8%8E%20Health%20Check%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%20server%E3%80%81remote-control%E3%80%81assistant%E3%80%81doctor%20%E4%B8%8D%E8%83%BD%E5%86%99%E6%88%90%E5%90%8C%E4%B8%80%E7%B1%BB%E4%BC%9A%E5%A4%96%E5%85%A5%E5%8F%A3.md)
- [22-Trust Dialog、项目级 .mcp.json 批准与 Health Check：为什么 skip trust dialog 不等于 project MCP 已被批准.md](./22-Trust%20Dialog%E3%80%81%E9%A1%B9%E7%9B%AE%E7%BA%A7%20.mcp.json%20%E6%89%B9%E5%87%86%E4%B8%8E%20Health%20Check%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%20skip%20trust%20dialog%20%E4%B8%8D%E7%AD%89%E4%BA%8E%20project%20MCP%20%E5%B7%B2%E8%A2%AB%E6%89%B9%E5%87%86.md)
- [23-Workspace Trust、Bridge Eligibility 与 Trusted Device：为什么 remote-control 的 trust、auth、policy 不是同一把钥匙.md](./23-Workspace%20Trust%E3%80%81Bridge%20Eligibility%20%E4%B8%8E%20Trusted%20Device%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%20remote-control%20%E7%9A%84%20trust%E3%80%81auth%E3%80%81policy%20%E4%B8%8D%E6%98%AF%E5%90%8C%E4%B8%80%E6%8A%8A%E9%92%A5%E5%8C%99.md)

## 先按控制面，不按相邻按钮

进入这一层前，先问自己：

1. 我当前缺的是 Prompt 判断、治理判断，还是当前真相边界。
2. 我看到的是控制面对象，还是它们的 UI 投影。
3. 如果删掉 slash 面板、status 页、usage 条和目录体感，我还能不能说清是哪条控制面失真。

如果还说不清，就先回 `09 / 15 / userbook/01-主线使用`，不要在这一层继续背更长的入口列表。

## 先判哪条控制面失真

这一层真正承接的，不是再抄一遍对象链，而是把它们翻译成三句用户问法：

1. 这还是同一件工作吗
   - 若目标、附件、handoff 或 summary 已经不再服务同一工作对象，优先按 Prompt 失真处理。
2. 这是治理裁决吗
   - 若你现在卡在继续、收口、降级、停止、清理后恢复或升级给人之间，就按治理失真处理，不要先盯投影替身。
   - 更稳的最小顺序是：先判 `pricing-right / truth-surface`，再判 `typed ask / sandbox`，最后才判 `decision window / continuation pricing / durable-transient cleanup`。
   - 最短 reject trio 也只先认 `decision-window collapse / projection usurpation / free-expansion relapse`。
   - 若你追问 why，固定回 `../../10 -> ../../philosophy/85 -> ../../philosophy/61`；若追问 signer / cleanup mechanism，回 `../../security`；若追问 user-side readback / reopen，回 `../../risk`；若要现场执行，回 `../../playbooks`。
3. 这是旧状态污染吗
   - 若旧目录、旧恢复资产、旧 capability 或旧 authority 在冒充现在，就按当前真相失真处理。

更细的 object chain 与 truth plane 统一回蓝皮书根前门；治理 why / signer / reopen / execution 则按上一条 next-hop route 分流；`05` 只负责把它们翻译成用户侧判断。

如果 `05` 不能和根 `userbook/README`、`01`、`04` 共享同一组 first-answer order，它就会重新退回“控制面话题集合”，而不是用户真正可执行的判断层。

Prompt 失真在这一层也只该继续消费同一张 user-facing witness packet：

- `目标`
  - 你是否还在同一件事上看控制面
- `附件`
  - 当前文件、上下文和外置材料是否仍在给这件事补事实
- `working set`
  - 当前控制面真正还在裁决的是不是这件事，而不是旧摘要或显示层投影
- `next step`
  - 这次继续、拒收、清理或 handoff 是否仍围绕同一工作对象

若这里开始靠 `systemPrompt` 截图、summary prose 或最后一条回复改判 Prompt 主语，就已经越位回第二套 Prompt 前门。
这张 packet 也只做 user-side reject aid：它只验同一工作对象是否被继承，不签 `world-definition source`，也不签 `continue qualification`。
换句话说，它只做 `same-work prefilter / reject aid`：先帮你排除“这已经不是同一件工作”的假继续；真正是否过关，仍要把这张 packet 上交给 `continue qualification` 的正式判定，而不是让 packet 自己代签。

如果继续把这一层压成用户动作，也只先记三句：

1. 说不清哪层在说真话时，先退回 `../../10 -> ../../philosophy/85 -> ../../philosophy/61 -> ../../security` 判 owner / verdict seam；若已经确认自己只在读用户侧恢复或尾链证据，再分别去 `../../risk` / `../../playbooks`，不要直接在 readback surface 上猜 verdict
2. `/status / /doctor / /usage` 这些都只是 weak readback surface；`/compact / /resume / /memory` 这些都只是 continuation consumer；`cleanup result / handoff promise / product promise readback` 这些都只是 reopen tail evidence，它们都不直接下结论
3. user-facing 最值钱的是 first reject path：先知道该拒收什么、退到哪层、再看深页拆解

更硬一点说，`/status / /doctor / /usage` 这些都只是 weak readback surface；`/compact / /resume / /memory` 这些都只是 continuation consumer；`cleanup result / handoff promise / product promise readback` 这些都只保留 liability / evidence，不代签治理 verdict。谁拿它们直接代签 same-world、治理真相或继续资格，谁就在把 consumer 写成 compiler。
续租也只延长仍合法的同一 lease；`resume / heartbeat / keep_alive / token refresh` 都不能替代 `re-entry / reopen / rebinding`。

如果还想要一张最小正向 crosswalk，也只记三行：

- `这还是同一件工作吗`
  - 正式过关条件是 `continue qualification`；packet 只负责 same-work prefilter
- `这是治理裁决吗`
  - 过关条件是 `pricing-right + truth-surface attestation`
- `这是旧状态污染吗`
  - 过关条件是 `sole writer + freshness`

如果还要继续追问这三项过关条件背后的 shared runtime correctness / continuity budget，而不是停在用户动作层，固定回 `../../07-运行时契约、知识层与生态边界.md`。

## 进入控制面前的 first reject signal

看到下面迹象时，应先停下来重审，而不是继续在相邻入口间来回切：

1. 你在用 mode、modal、usage、default continue 这些投影替身，或把 `compact / resume` 这些 continuation consumer，直接拿来判断治理真相。
   - 更直接地说，`/status / /doctor / /usage` 只是 weak readback；`/compact / /resume` 只是 continuation consumer；`cleanup result / handoff promise / product promise readback` 只是 reopen tail evidence。若你在用它们直接下结论，先回 `../../10`。
2. 你在用 `systemPrompt` 截图、最后一条消息或 summary prose 直接判断 Prompt 是否仍在同一个世界里。
3. 你在用目录体感、作者说明或“看起来能跑”直接判断当前真相边界。
4. 你还没选定是该继续、降级、停止、清理后恢复还是升级给人，就已经在换入口。

- [01-权限、计划模式与 Worktree：如何安全放大行动范围.md](./01-%E6%9D%83%E9%99%90%E3%80%81%E8%AE%A1%E5%88%92%E6%A8%A1%E5%BC%8F%E4%B8%8E%20Worktree%EF%BC%9A%E5%A6%82%E4%BD%95%E5%AE%89%E5%85%A8%E6%94%BE%E5%A4%A7%E8%A1%8C%E5%8A%A8%E8%8C%83%E5%9B%B4.md)
- [02-MCP、插件、技能与 Hooks：如何选择正确扩展层.md](./02-MCP%E3%80%81%E6%8F%92%E4%BB%B6%E3%80%81%E6%8A%80%E8%83%BD%E4%B8%8E%20Hooks%EF%BC%9A%E5%A6%82%E4%BD%95%E9%80%89%E6%8B%A9%E6%AD%A3%E7%A1%AE%E6%89%A9%E5%B1%95%E5%B1%82.md)
- [03-Compact、Resume、Memory：长任务连续性手册.md](./03-Compact%E3%80%81Resume%E3%80%81Memory%EF%BC%9A%E9%95%BF%E4%BB%BB%E5%8A%A1%E8%BF%9E%E7%BB%AD%E6%80%A7%E6%89%8B%E5%86%8C.md)
- [04-Agent、Task、Team、Cron：并行执行而不失控.md](./04-Agent%E3%80%81Task%E3%80%81Team%E3%80%81Cron%EF%BC%9A%E5%B9%B6%E8%A1%8C%E6%89%A7%E8%A1%8C%E8%80%8C%E4%B8%8D%E5%A4%B1%E6%8E%A7.md)
- [05-命令、提示词、技能、工具：入口选择决策树.md](./05-%E5%91%BD%E4%BB%A4%E3%80%81%E6%8F%90%E7%A4%BA%E8%AF%8D%E3%80%81%E6%8A%80%E8%83%BD%E3%80%81%E5%B7%A5%E5%85%B7%EF%BC%9A%E5%85%A5%E5%8F%A3%E9%80%89%E6%8B%A9%E5%86%B3%E7%AD%96%E6%A0%91.md)
- [06-Status、Doctor、Usage：运行时自检、额度与诊断.md](./06-Status%E3%80%81Doctor%E3%80%81Usage%EF%BC%9A%E8%BF%90%E8%A1%8C%E6%97%B6%E8%87%AA%E6%A3%80%E3%80%81%E9%A2%9D%E5%BA%A6%E4%B8%8E%E8%AF%8A%E6%96%AD.md)
- [07-Add-dir：工作面扩张、权限上下文与 Sandbox 刷新.md](./07-Add-dir%EF%BC%9A%E5%B7%A5%E4%BD%9C%E9%9D%A2%E6%89%A9%E5%BC%A0%E3%80%81%E6%9D%83%E9%99%90%E4%B8%8A%E4%B8%8B%E6%96%87%E4%B8%8E%20Sandbox%20%E5%88%B7%E6%96%B0.md)
- [08-Rename、Export：会话对象化与对外交付.md](./08-Rename%E3%80%81Export%EF%BC%9A%E4%BC%9A%E8%AF%9D%E5%AF%B9%E8%B1%A1%E5%8C%96%E4%B8%8E%E5%AF%B9%E5%A4%96%E4%BA%A4%E4%BB%98.md)
- [09-Release-notes、Feedback：版本证据与产品反馈回路.md](./09-Release-notes%E3%80%81Feedback%EF%BC%9A%E7%89%88%E6%9C%AC%E8%AF%81%E6%8D%AE%E4%B8%8E%E4%BA%A7%E5%93%81%E5%8F%8D%E9%A6%88%E5%9B%9E%E8%B7%AF.md)
- [10-设置面板、诊断屏与运营命令：会内控制面的三层分工.md](./10-%E8%AE%BE%E7%BD%AE%E9%9D%A2%E6%9D%BF%E3%80%81%E8%AF%8A%E6%96%AD%E5%B1%8F%E4%B8%8E%E8%BF%90%E8%90%A5%E5%91%BD%E4%BB%A4%EF%BC%9A%E4%BC%9A%E5%86%85%E6%8E%A7%E5%88%B6%E9%9D%A2%E7%9A%84%E4%B8%89%E5%B1%82%E5%88%86%E5%B7%A5.md)
- [11-命令对象、执行语义与可见性：为什么 slash command 不是同一种按钮.md](./11-%E5%91%BD%E4%BB%A4%E5%AF%B9%E8%B1%A1%E3%80%81%E6%89%A7%E8%A1%8C%E8%AF%AD%E4%B9%89%E4%B8%8E%E5%8F%AF%E8%A7%81%E6%80%A7%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%20slash%20command%20%E4%B8%8D%E6%98%AF%E5%90%8C%E4%B8%80%E7%A7%8D%E6%8C%89%E9%92%AE.md)
- [12-技能来源、暴露面与触发：为什么 skills 菜单不是能力全集.md](./12-%E6%8A%80%E8%83%BD%E6%9D%A5%E6%BA%90%E3%80%81%E6%9A%B4%E9%9C%B2%E9%9D%A2%E4%B8%8E%E8%A7%A6%E5%8F%91%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%20skills%20%E8%8F%9C%E5%8D%95%E4%B8%8D%E6%98%AF%E8%83%BD%E5%8A%9B%E5%85%A8%E9%9B%86.md)
- [13-system-init、技能提醒与 SkillTool：Claude 如何看见可用能力.md](./13-system-init%E3%80%81%E6%8A%80%E8%83%BD%E6%8F%90%E9%86%92%E4%B8%8E%20SkillTool%EF%BC%9AClaude%20%E5%A6%82%E4%BD%95%E7%9C%8B%E8%A7%81%E5%8F%AF%E7%94%A8%E8%83%BD%E5%8A%9B.md)
- [14-来源信任、Trust Dialog 与 Plugin-only Policy：扩展面为何分级信任.md](./14-%E6%9D%A5%E6%BA%90%E4%BF%A1%E4%BB%BB%E3%80%81Trust%20Dialog%20%E4%B8%8E%20Plugin-only%20Policy%EF%BC%9A%E6%89%A9%E5%B1%95%E9%9D%A2%E4%B8%BA%E4%BD%95%E5%88%86%E7%BA%A7%E4%BF%A1%E4%BB%BB.md)
- [15-技能发现、静态 listing 与 remote skills：为什么“relevant skills”不是技能总表.md](./15-%E6%8A%80%E8%83%BD%E5%8F%91%E7%8E%B0%E3%80%81%E9%9D%99%E6%80%81%20listing%20%E4%B8%8E%20remote%20skills%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%E2%80%9Crelevant%20skills%E2%80%9D%E4%B8%8D%E6%98%AF%E6%8A%80%E8%83%BD%E6%80%BB%E8%A1%A8.md)
- [16-Hooks 的加载、注册、执行与 UI：为什么 `/hooks` 看到的不是实际会跑的 hooks.md](./16-Hooks%20%E7%9A%84%E5%8A%A0%E8%BD%BD%E3%80%81%E6%B3%A8%E5%86%8C%E3%80%81%E6%89%A7%E8%A1%8C%E4%B8%8E%20UI%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%20%60%2Fhooks%60%20%E7%9C%8B%E5%88%B0%E7%9A%84%E4%B8%8D%E6%98%AF%E5%AE%9E%E9%99%85%E4%BC%9A%E8%B7%91%E7%9A%84%20hooks.md)
- [17-MCP 配置、按名解析与 Agent 引用：为什么你看到的 server 不是 Agent 真能挂上的 server.md](./17-MCP%20%E9%85%8D%E7%BD%AE%E3%80%81%E6%8C%89%E5%90%8D%E8%A7%A3%E6%9E%90%E4%B8%8E%20Agent%20%E5%BC%95%E7%94%A8%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%E4%BD%A0%E7%9C%8B%E5%88%B0%E7%9A%84%20server%20%E4%B8%8D%E6%98%AF%20Agent%20%E7%9C%9F%E8%83%BD%E6%8C%82%E4%B8%8A%E7%9A%84%20server.md)
- [18-插件安装、待刷新与当前会话激活：为什么 `/reload-plugins` 不是安装器.md](./18-%E6%8F%92%E4%BB%B6%E5%AE%89%E8%A3%85%E3%80%81%E5%BE%85%E5%88%B7%E6%96%B0%E4%B8%8E%E5%BD%93%E5%89%8D%E4%BC%9A%E8%AF%9D%E6%BF%80%E6%B4%BB%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%20%60%2Freload-plugins%60%20%E4%B8%8D%E6%98%AF%E5%AE%89%E8%A3%85%E5%99%A8.md)
- [19-插件自动物化、Startup Trust 与 Headless 刷新：为什么插件有时会自己出现、有时只提示 `/reload-plugins`.md](./19-%E6%8F%92%E4%BB%B6%E8%87%AA%E5%8A%A8%E7%89%A9%E5%8C%96%E3%80%81Startup%20Trust%20%E4%B8%8E%20Headless%20%E5%88%B7%E6%96%B0%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%E6%8F%92%E4%BB%B6%E6%9C%89%E6%97%B6%E4%BC%9A%E8%87%AA%E5%B7%B1%E5%87%BA%E7%8E%B0%E3%80%81%E6%9C%89%E6%97%B6%E5%8F%AA%E6%8F%90%E7%A4%BA%20%60%2Freload-plugins%60.md)
- [20-Headless 启动链、首问就绪与 StructuredIO：为什么 print 不是没有 UI 的 REPL.md](./20-Headless%20%E5%90%AF%E5%8A%A8%E9%93%BE%E3%80%81%E9%A6%96%E9%97%AE%E5%B0%B1%E7%BB%AA%E4%B8%8E%20StructuredIO%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%20print%20%E4%B8%8D%E6%98%AF%E6%B2%A1%E6%9C%89%20UI%20%E7%9A%84%20REPL.md)
- [21-Host、Viewer 与 Health Check：为什么 server、remote-control、assistant、doctor 不能写成同一类会外入口.md](./21-Host%E3%80%81Viewer%20%E4%B8%8E%20Health%20Check%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%20server%E3%80%81remote-control%E3%80%81assistant%E3%80%81doctor%20%E4%B8%8D%E8%83%BD%E5%86%99%E6%88%90%E5%90%8C%E4%B8%80%E7%B1%BB%E4%BC%9A%E5%A4%96%E5%85%A5%E5%8F%A3.md)
- [22-Trust Dialog、项目级 .mcp.json 批准与 Health Check：为什么 skip trust dialog 不等于 project MCP 已被批准.md](./22-Trust%20Dialog%E3%80%81%E9%A1%B9%E7%9B%AE%E7%BA%A7%20.mcp.json%20%E6%89%B9%E5%87%86%E4%B8%8E%20Health%20Check%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%20skip%20trust%20dialog%20%E4%B8%8D%E7%AD%89%E4%BA%8E%20project%20MCP%20%E5%B7%B2%E8%A2%AB%E6%89%B9%E5%87%86.md)
- [23-Workspace Trust、Bridge Eligibility 与 Trusted Device：为什么 remote-control 的 trust、auth、policy 不是同一把钥匙.md](./23-Workspace%20Trust%E3%80%81Bridge%20Eligibility%20%E4%B8%8E%20Trusted%20Device%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%20remote-control%20%E7%9A%84%20trust%E3%80%81auth%E3%80%81policy%20%E4%B8%8D%E6%98%AF%E5%90%8C%E4%B8%80%E6%8A%8A%E9%92%A5%E5%8C%99.md)
- [24-remoteControlAtStartup、CCR Mirror、Perpetual Session 与 --continue：为什么 bridge 的 auto、mirror、resume 不是同一种重连.md](./24-remoteControlAtStartup%E3%80%81CCR%20Mirror%E3%80%81Perpetual%20Session%20%E4%B8%8E%20--continue%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%20bridge%20%E7%9A%84%20auto%E3%80%81mirror%E3%80%81resume%20%E4%B8%8D%E6%98%AF%E5%90%8C%E4%B8%80%E7%A7%8D%E9%87%8D%E8%BF%9E.md)
- [25-Settings、remote-control 命令、Footer 状态 pill 与 Bridge Dialog：为什么 bridge 的默认配置、当前开关与连接展示不是同一个按钮.md](./25-Settings%E3%80%81remote-control%20%E5%91%BD%E4%BB%A4%E3%80%81Footer%20%E7%8A%B6%E6%80%81%20pill%20%E4%B8%8E%20Bridge%20Dialog%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%20bridge%20%E7%9A%84%E9%BB%98%E8%AE%A4%E9%85%8D%E7%BD%AE%E3%80%81%E5%BD%93%E5%89%8D%E5%BC%80%E5%85%B3%E4%B8%8E%E8%BF%9E%E6%8E%A5%E5%B1%95%E7%A4%BA%E4%B8%8D%E6%98%AF%E5%90%8C%E4%B8%80%E4%B8%AA%E6%8C%89%E9%92%AE.md)
- [26-Connect URL、Session URL、Environment ID、Session ID 与 remoteSessionUrl：为什么 remote-control 的链接、二维码与 ID 不是同一种定位符.md](./26-Connect%20URL%E3%80%81Session%20URL%E3%80%81Environment%20ID%E3%80%81Session%20ID%20%E4%B8%8E%20remoteSessionUrl%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%20remote-control%20%E7%9A%84%E9%93%BE%E6%8E%A5%E3%80%81%E4%BA%8C%E7%BB%B4%E7%A0%81%E4%B8%8E%20ID%20%E4%B8%8D%E6%98%AF%E5%90%8C%E4%B8%80%E7%A7%8D%E5%AE%9A%E4%BD%8D%E7%AC%A6.md)
- [27-remote-control 命令、--remote-control、claude remote-control 与 Remote Callout：为什么 remote-control 的会内开桥、启动带桥与 standalone host 不是同一种入口.md](./27-remote-control%20%E5%91%BD%E4%BB%A4%E3%80%81--remote-control%E3%80%81claude%20remote-control%20%E4%B8%8E%20Remote%20Callout%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%20remote-control%20%E7%9A%84%E4%BC%9A%E5%86%85%E5%BC%80%E6%A1%A5%E3%80%81%E5%90%AF%E5%8A%A8%E5%B8%A6%E6%A1%A5%E4%B8%8E%20standalone%20host%20%E4%B8%8D%E6%98%AF%E5%90%8C%E4%B8%80%E7%A7%8D%E5%85%A5%E5%8F%A3.md)
- [28-remote 会话、session 命令、assistant viewer 与 remote-safe commands：为什么远端会话 client、viewer 与 bridge host 不是同一种远程工作流.md](./28-remote%20%E4%BC%9A%E8%AF%9D%E3%80%81session%20%E5%91%BD%E4%BB%A4%E3%80%81assistant%20viewer%20%E4%B8%8E%20remote-safe%20commands%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%E8%BF%9C%E7%AB%AF%E4%BC%9A%E8%AF%9D%20client%E3%80%81viewer%20%E4%B8%8E%20bridge%20host%20%E4%B8%8D%E6%98%AF%E5%90%8C%E4%B8%80%E7%A7%8D%E8%BF%9C%E7%A8%8B%E5%B7%A5%E4%BD%9C%E6%B5%81.md)
- [29-Bridge Permission Callbacks、Control Request 与 Bridge-safe Commands：为什么远端的权限提示、会话控制与命令白名单不是同一种控制合同.md](./29-Bridge%20Permission%20Callbacks%E3%80%81Control%20Request%20%E4%B8%8E%20Bridge-safe%20Commands%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%E8%BF%9C%E7%AB%AF%E7%9A%84%E6%9D%83%E9%99%90%E6%8F%90%E7%A4%BA%E3%80%81%E4%BC%9A%E8%AF%9D%E6%8E%A7%E5%88%B6%E4%B8%8E%E5%91%BD%E4%BB%A4%E7%99%BD%E5%90%8D%E5%8D%95%E4%B8%8D%E6%98%AF%E5%90%8C%E4%B8%80%E7%A7%8D%E6%8E%A7%E5%88%B6%E5%90%88%E5%90%8C.md)
- [30-remoteConnectionStatus、remoteBackgroundTaskCount、BriefIdleStatus 与 viewerOnly：为什么远端会话的连接告警、后台任务与 bridge 重连不是同一张运行态面.md](./30-remoteConnectionStatus%E3%80%81remoteBackgroundTaskCount%E3%80%81BriefIdleStatus%20%E4%B8%8E%20viewerOnly%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%E8%BF%9C%E7%AB%AF%E4%BC%9A%E8%AF%9D%E7%9A%84%E8%BF%9E%E6%8E%A5%E5%91%8A%E8%AD%A6%E3%80%81%E5%90%8E%E5%8F%B0%E4%BB%BB%E5%8A%A1%E4%B8%8E%20bridge%20%E9%87%8D%E8%BF%9E%E4%B8%8D%E6%98%AF%E5%90%8C%E4%B8%80%E5%BC%A0%E8%BF%90%E8%A1%8C%E6%80%81%E9%9D%A2.md)
- [31-Remote Control active、reconnecting、Connect URL、Session URL 与 outbound-only：为什么 bridge 的状态词、恢复厚度与动作上限不是同一个“已恢复”.md](./31-Remote%20Control%20active%E3%80%81reconnecting%E3%80%81Connect%20URL%E3%80%81Session%20URL%20%E4%B8%8E%20outbound-only%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%20bridge%20%E7%9A%84%E7%8A%B6%E6%80%81%E8%AF%8D%E3%80%81%E6%81%A2%E5%A4%8D%E5%8E%9A%E5%BA%A6%E4%B8%8E%E5%8A%A8%E4%BD%9C%E4%B8%8A%E9%99%90%E4%B8%8D%E6%98%AF%E5%90%8C%E4%B8%80%E4%B8%AA%E2%80%9C%E5%B7%B2%E6%81%A2%E5%A4%8D%E2%80%9D.md)
- [32-Remote Control failed、disconnect、replBridgeEnabled=false 与 remoteControlAtStartup=false：为什么 bridge 的故障提示、当前会话停机与默认策略回退不是同一种关闭.md](./32-Remote%20Control%20failed%E3%80%81disconnect%E3%80%81replBridgeEnabled=false%20%E4%B8%8E%20remoteControlAtStartup=false%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%20bridge%20%E7%9A%84%E6%95%85%E9%9A%9C%E6%8F%90%E7%A4%BA%E3%80%81%E5%BD%93%E5%89%8D%E4%BC%9A%E8%AF%9D%E5%81%9C%E6%9C%BA%E4%B8%8E%E9%BB%98%E8%AE%A4%E7%AD%96%E7%95%A5%E5%9B%9E%E9%80%80%E4%B8%8D%E6%98%AF%E5%90%8C%E4%B8%80%E7%A7%8D%E5%85%B3%E9%97%AD.md)
- [33-Disconnect Dialog、Perpetual Teardown、bridge pointer 与 --continue：为什么 bridge 的断开、退出与恢复轨迹不是同一种收口.md](./33-Disconnect%20Dialog%E3%80%81Perpetual%20Teardown%E3%80%81bridge%20pointer%20%E4%B8%8E%20--continue%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%20bridge%20%E7%9A%84%E6%96%AD%E5%BC%80%E3%80%81%E9%80%80%E5%87%BA%E4%B8%8E%E6%81%A2%E5%A4%8D%E8%BD%A8%E8%BF%B9%E4%B8%8D%E6%98%AF%E5%90%8C%E4%B8%80%E7%A7%8D%E6%94%B6%E5%8F%A3.md)
- [34-No recent session found、Session not found、environment_id 与 try running the same command again：为什么 bridge 的 stale pointer、过期环境与瞬态重试不是同一种恢复失败.md](./34-No%20recent%20session%20found%E3%80%81Session%20not%20found%E3%80%81environment_id%20%E4%B8%8E%20try%20running%20the%20same%20command%20again%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%20bridge%20%E7%9A%84%20stale%20pointer%E3%80%81%E8%BF%87%E6%9C%9F%E7%8E%AF%E5%A2%83%E4%B8%8E%E7%9E%AC%E6%80%81%E9%87%8D%E8%AF%95%E4%B8%8D%E6%98%AF%E5%90%8C%E4%B8%80%E7%A7%8D%E6%81%A2%E5%A4%8D%E5%A4%B1%E8%B4%A5.md)
- [35-Workspace Trust、login、restart remote-control、fresh session fallback 与 retry：为什么 bridge 的补救动作不是同一种恢复建议.md](./35-Workspace%20Trust、login、restart%20remote-control、fresh%20session%20fallback%20与%20retry：为什么%20bridge%20的补救动作不是同一种恢复建议.md)
- [36-Remote Control build 不可用、资格不可用、组织拒绝与权限噪音：为什么 bridge 的 not enabled、policy disabled、not available 与 Access denied 不是同一种“不能用”.md](./36-Remote%20Control%20build%20不可用、资格不可用、组织拒绝与权限噪音：为什么%20bridge%20的%20not%20enabled、policy%20disabled、not%20available%20与%20Access%20denied%20不是同一种“不能用”.md)
- [37-single-session、same-dir、worktree、capacity、create-session-in-dir 与 w：为什么 standalone remote-control 的 spawn topology、并发上限与前台 cwd 会话不是同一种调度.md](./37-single-session、same-dir、worktree、capacity、create-session-in-dir%20与%20w：为什么%20standalone%20remote-control%20的%20spawn%20topology、并发上限与前台%20cwd%20会话不是同一种调度.md)
- [38-Bridge Banner、QR、footer、session count 与 session list：为什么 standalone remote-control 的 banner、状态行与会话列表不是同一种显示面.md](./38-Bridge%20Banner、QR、footer、session%20count%20与%20session%20list：为什么%20standalone%20remote-control%20的%20banner、状态行与会话列表不是同一种显示面.md)
- [39-name、permission-mode、sandbox 与 session title：为什么 standalone remote-control 的 host flags、session 默认策略与标题回填不是同一种继承.md](./39-name、permission-mode、sandbox%20与%20session%20title：为什么%20standalone%20remote-control%20的%20host%20flags、session%20默认策略与标题回填不是同一种继承.md)
- [40-can_use_tool、SandboxNetworkAccess、hook-classifier 与 control_cancel_request：为什么 remote-control 的工具审批、网络放行、自动批准与提示撤销不是同一种批准.md](./40-can_use_tool、SandboxNetworkAccess、hook-classifier%20与%20control_cancel_request：为什么%20remote-control%20的工具审批、网络放行、自动批准与提示撤销不是同一种批准.md)
- [41-sdk-url、sessionIngressUrl、environmentSecret、session access token 与 workerEpoch：为什么 standalone remote-control 的 URL、密钥、令牌与传输纪元不是同一种连接凭证.md](./41-sdk-url、sessionIngressUrl、environmentSecret、session%20access%20token%20与%20workerEpoch：为什么%20standalone%20remote-control%20的%20URL、密钥、令牌与传输纪元不是同一种连接凭证.md)
- [42-register、poll、ack、heartbeat、stop、archive 与 deregister：为什么 standalone remote-control 的环境、work 与 session 生命周期不是同一种收口.md](./42-register、poll、ack、heartbeat、stop、archive%20与%20deregister：为什么%20standalone%20remote-control%20的环境、work%20与%20session%20生命周期不是同一种收口.md)
- [43-session tag、compat shim 与 reconnect tag：为什么 bridge 的 compat session ID、infra session ID 与 sameSessionId 不是同一种标识.md](./43-session%20tag、compat%20shim%20与%20reconnect%20tag：为什么%20bridge%20的%20compat%20session%20ID、infra%20session%20ID%20与%20sameSessionId%20不是同一种标识.md)
- [44-session token refresh、child sync 与 bridge reconnect：为什么 standalone remote-control 的 child 刷新、heartbeat 续租与 v2 重派发不是同一种 token refresh.md](./44-session%20token%20refresh、child%20sync%20与%20bridge%20reconnect：为什么%20standalone%20remote-control%20的%20child%20刷新、heartbeat%20续租与%20v2%20重派发不是同一种%20token%20refresh.md)
- [45-work secret、ack timing、existing session refresh 与 unknown work：为什么 standalone remote-control 的 work intake 不是同一种领取.md](./45-work%20secret、ack%20timing、existing%20session%20refresh%20与%20unknown%20work：为什么%20standalone%20remote-control%20的%20work%20intake%20不是同一种领取.md)
- [46-session timeout、watchdog、SIGTERM、SIGKILL 与 failed remap：为什么 bridge 的会话超时、收尾中断与请求 timeout 不是同一种 timeout.md](./46-session%20timeout、watchdog、SIGTERM、SIGKILL%20与%20failed%20remap：为什么%20bridge%20的会话超时、收尾中断与请求%20timeout%20不是同一种%20timeout.md)
- [47-poll、heartbeat、reconnecting、give up 与 sleep reset：为什么 bridge 的保活、回连预算与放弃条件不是同一种重试.md](./47-poll、heartbeat、reconnecting、give%20up%20与%20sleep%20reset：为什么%20bridge%20的保活、回连预算与放弃条件不是同一种重试.md)
- [48-Workspace not trusted、login token、HTTP base URL、worktree availability 与 registration failure：为什么 headless remote-control 的 permanent error 与 transient retry 不是同一种开桥失败.md](./48-Workspace%20not%20trusted、login%20token、HTTP%20base%20URL、worktree%20availability%20与%20registration%20failure：为什么%20headless%20remote-control%20的%20permanent%20error%20与%20transient%20retry%20不是同一种开桥失败.md)
- [49-remoteDialogSeen、multi-session gate、ProjectConfig.remoteControlSpawnMode 与 effective spawnMode：为什么 standalone remote-control 的一次性说明、账号资格、项目偏好与当前模式不是同一个默认.md](./49-remoteDialogSeen、multi-session%20gate、ProjectConfig.remoteControlSpawnMode%20与%20effective%20spawnMode：为什么%20standalone%20remote-control%20的一次性说明、账号资格、项目偏好与当前模式不是同一个默认.md)
- [50-worker epoch、state restore、worker heartbeat、keep_alive 与 self-exit：为什么 CCR v2 worker 的初始化、保活与代际退场不是同一种存活合同.md](./50-worker%20epoch、state%20restore、worker%20heartbeat、keep_alive%20与%20self-exit：为什么%20CCR%20v2%20worker%20的初始化、保活与代际退场不是同一种存活合同.md)
- [51-worker_status、requires_action_details、pending_action、task_summary、post_turn_summary 与 session_state_changed：为什么远端看到的运行态不是同一张面.md](./51-worker_status、requires_action_details、pending_action、task_summary、post_turn_summary%20与%20session_state_changed：为什么%20远端看到的运行态不是同一张面.md)
- [52-permission_mode、is_ultraplan_mode 与 model：为什么远端恢复回填、当前本地状态与 session control request 不是同一种会话参数.md](./52-permission_mode、is_ultraplan_mode%20与%20model：为什么%20远端恢复回填、当前本地状态与%20session%20control%20request%20不是同一种会话参数.md)
- [53-task_started、task_progress、task_notification 与 session_state_changed：为什么远端消费方收到的不是同一种事件流.md](./53-task_started、task_progress、task_notification%20与%20session_state_changed：为什么%20远端消费方收到的不是同一种事件流.md)
- [54-transport rebuild、initial flush、flush gate 与 sequence resume：为什么 CCR v2 remote bridge 的重建 transport、历史续接与 connected 不是同一步.md](./54-transport%20rebuild、initial%20flush、flush%20gate%20与%20sequence%20resume：为什么%20CCR%20v2%20remote%20bridge%20的重建%20transport、历史续接与%20connected%20不是同一步.md)
- [55-received、processing、processed、lastWrittenIndexRef、recentPostedUUIDs、recentInboundUUIDs 与 sentUUIDsRef：为什么 remote bridge 的送达回执、增量转发、echo 过滤与重放防重不是同一种去重.md](./55-received、processing、processed、lastWrittenIndexRef、recentPostedUUIDs、recentInboundUUIDs%20与%20sentUUIDsRef：为什么%20remote%20bridge%20的送达回执、增量转发、echo%20过滤与重放防重不是同一种去重.md)
- [56-initialize、can_use_tool、control_response、control_cancel_request 与 result：为什么 remote bridge 的握手、提问、作答、撤销与回合收口不是同一种状态交接.md](./56-initialize、can_use_tool、control_response、control_cancel_request%20与%20result：为什么%20remote%20bridge%20的握手、提问、作答、撤销与回合收口不是同一种状态交接.md)
- [57-useRemoteSession、useDirectConnect 与 useSSHSession：为什么看起来都是远端 REPL，但连接、重连、权限与退出不是同一种会话合同.md](./57-useRemoteSession、useDirectConnect%20与%20useSSHSession：为什么看起来都是远端%20REPL，但连接、重连、权限与退出不是同一种会话合同.md)
- [58-viewerOnly、hasInitialPrompt、useAssistantHistory 与 updateSessionTitle：为什么 attached assistant REPL 的首问加载、历史翻页与会话标题不是同一种主权.md](./58-viewerOnly、hasInitialPrompt、useAssistantHistory%20与%20updateSessionTitle：为什么%20attached%20assistant%20REPL%20的首问加载、历史翻页与会话标题不是同一种主权.md)
- [59-cc__、open、createDirectConnectSession、ws_url 与 fail-fast disconnect：为什么 direct connect 的建会话、直连 socket 与断线退出不是同一种远端附着.md](./59-cc__、open、createDirectConnectSession、ws_url%20与%20fail-fast%20disconnect：为什么%20direct%20connect%20的建会话、直连%20socket%20与断线退出不是同一种远端附着.md)
- [60-can_use_tool、interrupt、result、disconnect 与 stderr shutdown：为什么 direct connect 的控制子集、回合结束与连接失败不是同一种收口.md](./60-can_use_tool、interrupt、result、disconnect%20与%20stderr%20shutdown：为什么%20direct%20connect%20的控制子集、回合结束与连接失败不是同一种收口.md)
- [61-init、status、tool_result、tool_progress 与 ignored families：为什么 direct connect 的远端消息流不是原样落进 REPL transcript.md](./61-init、status、tool_result、tool_progress%20与%20ignored%20families：为什么%20direct%20connect%20的远端消息流不是原样落进%20REPL%20transcript.md)
- [62-Connected to server、Remote session initialized、busy_waiting_idle、PermissionRequest 与 stderr disconnect：为什么 direct connect 的可见状态面不是同一张远端状态板.md](./62-Connected%20to%20server、Remote%20session%20initialized、busy_waiting_idle、PermissionRequest%20与%20stderr%20disconnect：为什么%20direct%20connect%20的可见状态面不是同一张远端状态板.md)
- [63-Ctrl+O transcript、verbose、showAllInTranscript 与 tool_result：为什么 direct connect 的 transcript 不是 prompt 面展开版，也不是 raw SDK stream.md](./63-Ctrl%2BO%20transcript、verbose、showAllInTranscript%20与%20tool_result：为什么%20direct%20connect%20的%20transcript%20不是%20prompt%20面展开版，也不是%20raw%20SDK%20stream.md)
- [64-remoteSessionUrl、remoteConnectionStatus、remoteBackgroundTaskCount 与 busy_waiting_idle：为什么 remote session 的持续状态面和 direct connect 的当前交互面不是同一种状态来源.md](./64-remoteSessionUrl、remoteConnectionStatus、remoteBackgroundTaskCount%20与%20busy_waiting_idle：为什么%20remote%20session%20的持续状态面和%20direct%20connect%20的当前交互面不是同一种状态来源.md)
- [65-stream_event、task_started、task_notification 与 transcript_overlay_stderr：为什么 remote session 是持续事件流消费者，而 direct connect 只是离散交互投影.md](./65-stream_event、task_started、task_notification%20与%20transcript_overlay_stderr：为什么%20remote%20session%20是持续事件流消费者，而%20direct%20connect%20只是离散交互投影.md)
- [66-stream_event、task_started、status、remote pill 与 BriefIdleStatus：为什么同一 remote session 事件不会以同样厚度出现在每个消费者里.md](./66-stream_event、task_started、status、remote%20pill%20与%20BriefIdleStatus：为什么同一%20remote%20session%20事件不会以同样厚度出现在每个消费者里.md)
- [67-slash_commands、stream_event、task_started 与 status_compacting：为什么 remote session 的命令集、流式正文、后台计数与 timeout 策略不是同一种消费者.md](./67-slash_commands、stream_event、task_started%20与%20status_compacting：为什么%20remote%20session%20的命令集、流式正文、后台计数与%20timeout%20策略不是同一种消费者.md)
- [68-slash_commands、REMOTE_SAFE_COMMANDS、local-jsx fallthrough 与 remote send：为什么 remote session 的远端发布命令面、本地保留命令面与实际执行路由不是同一张命令表.md](./68-slash_commands、REMOTE_SAFE_COMMANDS、local-jsx%20fallthrough%20与%20remote%20send：为什么%20remote%20session%20的远端发布命令面、本地保留命令面与实际执行路由不是同一张命令表.md)
- [69-hasCommand、isHidden、isCommandEnabled、local-jsx 与 remote send：为什么 remote mode 里的 slash 高亮、候选补全、启用态与实际执行去向不是同一个判定器.md](./69-hasCommand、isHidden、isCommandEnabled、local-jsx%20与%20remote%20send：为什么%20remote%20mode%20里的%20slash%20高亮、候选补全、启用态与实际执行去向不是同一个判定器.md)
- [70-disableSlashCommands、commands=[]、hasCommand 与 remote send：为什么关掉本地 slash 命令层，不等于 remote mode 失去 slash 文本入口.md](./70-disableSlashCommands、commands%3D%5B%5D、hasCommand%20与%20remote%20send：为什么关掉本地%20slash%20命令层，不等于%20remote%20mode%20失去%20slash%20文本入口.md)
- [71-useSkillsChange、useManagePlugins、MCPConnectionManager 与 useMergedCommands：为什么 remote session 的本地命令面不是持续增厚的本地 REPL，也不是完全冻结的远端镜像.md](./71-useSkillsChange、useManagePlugins、MCPConnectionManager%20与%20useMergedCommands：为什么%20remote%20session%20的本地命令面不是持续增厚的本地%20REPL，也不是完全冻结的远端镜像.md)
- [72-getTools、useMergedTools、mcp.tools 与 toolPermissionContext：为什么 remote session 的 tool plane 不会像 command plane 一样一起变薄.md](./72-getTools、useMergedTools、mcp.tools%20与%20toolPermissionContext：为什么%20remote%20session%20的%20tool%20plane%20不会像%20command%20plane%20一样一起变薄.md)
- [73-toolPermissionContext、initialMsg.mode、message.permissionMode、applyPermissionUpdate 与 computeTools：为什么 remote session 的本地 tool plane 主权不等于远端命令面主权.md](./73-toolPermissionContext、initialMsg.mode、message.permissionMode、applyPermissionUpdate%20与%20computeTools：为什么%20remote%20session%20的本地%20tool%20plane%20主权不等于远端命令面主权.md)
这一层适合在你已经知道“我想做什么”之后，进一步判断“为什么系统推荐这条路径，而不是相邻那条路径”。

更稳一点说，这一层真正值钱的目录优化也不是继续补页，而是让每个控制面首页都先回答：

1. 我在承接哪条最小顺序。
2. 哪些相邻入口是常见替身，必须直接拒收。
3. 什么时候应把问题退回专题层、主线使用层或蓝皮书主线重新定题。
