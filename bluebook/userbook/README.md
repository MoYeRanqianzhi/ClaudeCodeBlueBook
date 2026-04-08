# Claude Code Userbook

当前官方 npm public artifact 现场核验为 `@anthropic-ai/claude-code@2.1.92`；本手册在 `public-evidence only` 约束下，结合已归档源码锚点与蓝皮书 owner 页整理用户侧理解路径。它不是第二本蓝皮书，而是用户侧入口：先判工作对象有没有送错、扩张或权限判断卡在哪一段、旧状态是否还在污染当前，再决定下一跳读哪个 README。

这棵子树默认继承 [../README.md](../README.md)、[../09-三张控制面总图：世界进入模型、扩张定价与防过去写坏现在.md](../09-%E4%B8%89%E5%BC%A0%E6%8E%A7%E5%88%B6%E9%9D%A2%E6%80%BB%E5%9B%BE%EF%BC%9A%E4%B8%96%E7%95%8C%E8%BF%9B%E5%85%A5%E6%A8%A1%E5%9E%8B%E3%80%81%E6%89%A9%E5%BC%A0%E5%AE%9A%E4%BB%B7%E4%B8%8E%E9%98%B2%E8%BF%87%E5%8E%BB%E5%86%99%E5%9D%8F%E7%8E%B0%E5%9C%A8.md) 与 `docs/development/00-研究方法.md` 已承认的首答来源/申诉链；`userbook/` 只翻译用户动作、问题分型与二跳，不再在各层重复目录法、发言权或申诉链。

## 先按目录结构进入

如果你还没确定自己现在该走“主线使用”、“参考索引”、“专题深潜”还是“控制面深挖”，先从这组顶层 hub 进入：

- [00-导读.md](./00-%E5%AF%BC%E8%AF%BB.md)
- [00-阅读路径.md](./00-%E9%98%85%E8%AF%BB%E8%B7%AF%E5%BE%84.md)
- [01-主线使用/README.md](./01-%E4%B8%BB%E7%BA%BF%E4%BD%BF%E7%94%A8/README.md)
- [03-参考索引/README.md](./03-%E5%8F%82%E8%80%83%E7%B4%A2%E5%BC%95/README.md)
- [04-专题深潜/README.md](./04-%E4%B8%93%E9%A2%98%E6%B7%B1%E6%BD%9C/README.md)
- [05-控制面深挖/README.md](./05-%E6%8E%A7%E5%88%B6%E9%9D%A2%E6%B7%B1%E6%8C%96/README.md)

如果你已经知道自己卡在某个具体目标，再继续看下面这组“按目标进入”。

如果你要建立机制总图，而不是先做用户入口分诊，走：

- [03-参考索引/04-功能面七分法.md](./03-%E5%8F%82%E8%80%83%E7%B4%A2%E5%BC%95/04-%E5%8A%9F%E8%83%BD%E9%9D%A2%E4%B8%83%E5%88%86%E6%B3%95.md) ->
  [02-能力地图/README.md](./02-%E8%83%BD%E5%8A%9B%E5%9C%B0%E5%9B%BE/README.md)

## 按目标进入

如果只先记住三条使用判断，也只先记这三条：

1. 好 Prompt 不是更像专家，而是先确认你还在同一件事上，附件、文件与 working set 仍服务同一现场。
2. 扩张或权限判断不要先看弹窗、`status`、`usage` 或继续入口；先看这次动作、可见性或继续请求有没有被当前控制面准入。
3. 若问题已经是“为什么这里会省 token / 为什么要 `Later` / `Outside`”，先回 `10 -> philosophy/85 -> philosophy/61` 固定 why；要看 signer / cleanup / mechanism 时进 `security/README`，要看用户侧恢复与 reopen 时进 `risk/README`，要看现场执行时进 `playbooks/README`。

如果你只缺治理收费链的一屏速记，而不是具体控制面下潜，先回 [../10-治理收费链入口卡：最早 unpaid expansion、reject trio 与弱读回面](../10-%E6%B2%BB%E7%90%86%E6%94%B6%E8%B4%B9%E9%93%BE%E5%85%A5%E5%8F%A3%E5%8D%A1%EF%BC%9A%E6%9C%80%E6%97%A9%20unpaid%20expansion%E3%80%81reject%20trio%20%E4%B8%8E%E5%BC%B1%E8%AF%BB%E5%9B%9E%E9%9D%A2.md)；userbook 根入口只保留问题分型、用户侧最小顺序与二跳。

这里也只先记三条边界：

- Prompt 线只翻 user-facing witness；owner 级 ABI 统一回 `philosophy/84`
- 治理线只翻 weak readback surface，并显式降格 continuation consumer 与 reopen tail evidence；治理速记与 why 统一回 `10 -> philosophy/85 -> philosophy/61`，机制、用户侧恢复与现场执行分别回 `security / risk / playbooks`
- `continuity` 不是第四类使用主题；它只是同一工作对象在时间轴上的继续条件

## 用户侧四问

- 我是不是正在拿界面投影偷替工作对象或继续判断说话。
- 我缺的是同一现场、控制面准入，还是 current-truth writeback，而不是“再点一个入口”。
- 我现在是在找下一跳，还是已经越级偷问 canonical owner。
- 当前 worktree 若缺镜像，我写的是用户侧读法，还是在越界补签 runtime truth。

## 先做三类问题分型

根前门最值钱的不是深页清单，而是先把问题分到对的层：

1. `上下文送错`
   - 先看是不是已经换了工作对象，或附件/文件/working set/handoff 已不再服务同一件事。
2. `扩张或权限判错`
  - 先看这次扩张有没有先被准入、当前真相有没有先说清，再决定该继续、收口、降级还是升级给人。
  - 先别拿任何治理界面、状态读数或压缩入口直接下结论；治理速记与 why 先回 `10 -> philosophy/85 -> philosophy/61`，控制面顺序回 `05-控制面深挖/README`，机制细节回 `security`，用户侧恢复/尾链读回回 `risk`，现场执行回 `playbooks`。
3. `旧状态污染`
   - 先看是不是旧 shim、旧恢复资产、旧 capability token 或旧 authority width 还在冒充当前世界。

## 按问题二跳，不按深页碰运气

根前门真正负责的是 `问题分型 -> 二跳`，不负责替 `04 / 05` 的 README 重新充当专题目录。

更稳一点说，`userbook/README -> 01 -> 04 / 05` 也应继续共享同一组 first-answer order；目录优化若只共享 nouns、不共享顺序，用户层仍会先退回“按页碰运气”。
更稳一点说，治理界面、状态投影、继续入口、导出入口与收口结果词都只能帮助二跳，不能代替 `扩张或权限判错` 的控制面判断。

更稳的默认二跳是：

- 如果你已经明确只是 `扩张或权限判错` 或 `旧状态污染`，最短单跳仍可直接去 [05-控制面深挖/README.md](./05-%E6%8E%A7%E5%88%B6%E9%9D%A2%E6%B7%B1%E6%8C%96/README.md)；下面保留的是更稳定的二跳起点。

- 想先知道今天该怎么开工：
  [00-导读.md](./00-%E5%AF%BC%E8%AF%BB.md) ->
  [01-主线使用/README.md](./01-%E4%B8%BB%E7%BA%BF%E4%BD%BF%E7%94%A8/README.md)
- 分清启动时决定什么，进会话后决定什么：
  [00-阅读路径.md](./00-%E9%98%85%E8%AF%BB%E8%B7%AF%E5%BE%84.md)
  里的“路径 14：我想分清 root flags、root commands 和 slash commands”。
  如果你主要卡在 `claude auth`、`claude mcp`、`claude plugin`、`claude doctor` 和 `/login`、`/mcp`、`/plugin`、`/status` 为什么不在同一层，再接着看里面的“路径 15：我想分清会外 root commands 和会内面板”。
- 建立稳定工作流：
  [01-主线使用/05-开工前自检：状态、诊断、额度与工作边界.md](./01-%E4%B8%BB%E7%BA%BF%E4%BD%BF%E7%94%A8/05-%E5%BC%80%E5%B7%A5%E5%89%8D%E8%87%AA%E6%A3%80%EF%BC%9A%E7%8A%B6%E6%80%81%E3%80%81%E8%AF%8A%E6%96%AD%E3%80%81%E9%A2%9D%E5%BA%A6%E4%B8%8E%E5%B7%A5%E4%BD%9C%E8%BE%B9%E7%95%8C.md) ->
  [04-专题深潜/README.md](./04-%E4%B8%93%E9%A2%98%E6%B7%B1%E6%BD%9C/README.md) ->
  [05-控制面深挖/README.md](./05-%E6%8E%A7%E5%88%B6%E9%9D%A2%E6%B7%B1%E6%8C%96/README.md)
- 安全放大工作面，而不是一上来把行动半径开到最大：
  [00-阅读路径.md](./00-%E9%98%85%E8%AF%BB%E8%B7%AF%E5%BE%84.md)
  里的“路径 92：我想安全放大工作面，而不是一上来把行动半径开到最大”。
  如果你只想先做第一跳分诊，再直接看
  [04-专题深潜/安全放大工作面/README.md](./04-%E4%B8%93%E9%A2%98%E6%B7%B1%E6%BD%9C/%E5%AE%89%E5%85%A8%E6%94%BE%E5%A4%A7%E5%B7%A5%E4%BD%9C%E9%9D%A2/README.md)。
- `上下文送错`：
  [01-主线使用/README.md](./01-%E4%B8%BB%E7%BA%BF%E4%BD%BF%E7%94%A8/README.md) ->
  [04-专题深潜/README.md](./04-%E4%B8%93%E9%A2%98%E6%B7%B1%E6%BD%9C/README.md)
- `扩张或权限判错`：
  [01-主线使用/README.md](./01-%E4%B8%BB%E7%BA%BF%E4%BD%BF%E7%94%A8/README.md) ->
  [05-控制面深挖/README.md](./05-%E6%8E%A7%E5%88%B6%E9%9D%A2%E6%B7%B1%E6%8C%96/README.md)
- `旧状态污染`：
  [01-主线使用/README.md](./01-%E4%B8%BB%E7%BA%BF%E4%BD%BF%E7%94%A8/README.md) ->
  [05-控制面深挖/README.md](./05-%E6%8E%A7%E5%88%B6%E9%9D%A2%E6%B7%B1%E6%8C%96/README.md)
- 想先看主线使用约束，而不是专题或控制面：
  [01-主线使用/README.md](./01-%E4%B8%BB%E7%BA%BF%E4%BD%BF%E7%94%A8/README.md)
- 把上下文送准：
  [01-主线使用/02-提问、补上下文与让模型继续工作.md](./01-%E4%B8%BB%E7%BA%BF%E4%BD%BF%E7%94%A8/02-%E6%8F%90%E9%97%AE%E3%80%81%E8%A1%A5%E4%B8%8A%E4%B8%8B%E6%96%87%E4%B8%8E%E8%AE%A9%E6%A8%A1%E5%9E%8B%E7%BB%A7%E7%BB%AD%E5%B7%A5%E4%BD%9C.md) ->
  [04-专题深潜/08-上下文接入、附件与提示编译专题.md](./04-%E4%B8%93%E9%A2%98%E6%B7%B1%E6%BD%9C/08-%E4%B8%8A%E4%B8%8B%E6%96%87%E6%8E%A5%E5%85%A5%E3%80%81%E9%99%84%E4%BB%B6%E4%B8%8E%E6%8F%90%E7%A4%BA%E7%BC%96%E8%AF%91%E4%B8%93%E9%A2%98.md)
- 把结果交付给团队或外部流程：
  [04-专题深潜/09-评审、提交、导出与反馈专题.md](./04-%E4%B8%93%E9%A2%98%E6%B7%B1%E6%BD%9C/09-%E8%AF%84%E5%AE%A1%E3%80%81%E6%8F%90%E4%BA%A4%E3%80%81%E5%AF%BC%E5%87%BA%E4%B8%8E%E5%8F%8D%E9%A6%88%E4%B8%93%E9%A2%98.md)
- 运营长任务的状态、预算和模型节奏：
  [00-阅读路径.md](./00-%E9%98%85%E8%AF%BB%E8%B7%AF%E5%BE%84.md)
  里的“路径 16：我想分清 Settings tab、独立诊断屏、调参命令与预算分流”。
  如果你已经分清 `/status`、`/doctor`、`/usage`、`/config`、`/model`、`/effort`
  各自属于哪种对象，只是想继续看长任务的状态、预算和节奏运营，再读
  [04-专题深潜/10-状态、额度、模型与节奏运营专题.md](./04-%E4%B8%93%E9%A2%98%E6%B7%B1%E6%BD%9C/10-%E7%8A%B6%E6%80%81%E3%80%81%E9%A2%9D%E5%BA%A6%E3%80%81%E6%A8%A1%E5%9E%8B%E4%B8%8E%E8%8A%82%E5%A5%8F%E8%BF%90%E8%90%A5%E4%B8%93%E9%A2%98.md)。
- 提升终端交互效率：
  [00-阅读路径.md](./00-%E9%98%85%E8%AF%BB%E8%B7%AF%E5%BE%84.md)
  里的“路径 7：我想让终端更顺手”。
  如果你已经确认自己主要卡在主题、按键、Vim、状态栏或输入回调，再继续看
  [04-专题深潜/11-终端交互、状态栏与输入效率专题.md](./04-%E4%B8%93%E9%A2%98%E6%B7%B1%E6%BD%9C/11-%E7%BB%88%E7%AB%AF%E4%BA%A4%E4%BA%92%E3%80%81%E7%8A%B6%E6%80%81%E6%A0%8F%E4%B8%8E%E8%BE%93%E5%85%A5%E6%95%88%E7%8E%87%E4%B8%93%E9%A2%98.md)。
- 让长任务在压缩、恢复与记忆之间稳定续上：
  [01-主线使用/04-会话、恢复、压缩与记忆.md](./01-%E4%B8%BB%E7%BA%BF%E4%BD%BF%E7%94%A8/04-%E4%BC%9A%E8%AF%9D%E3%80%81%E6%81%A2%E5%A4%8D%E3%80%81%E5%8E%8B%E7%BC%A9%E4%B8%8E%E8%AE%B0%E5%BF%86.md) ->
  [04-专题深潜/02-连续性与记忆专题.md](./04-%E4%B8%93%E9%A2%98%E6%B7%B1%E6%BD%9C/02-%E8%BF%9E%E7%BB%AD%E6%80%A7%E4%B8%8E%E8%AE%B0%E5%BF%86%E4%B8%93%E9%A2%98.md)。
  如果你主要卡在“旧会话怎么找回来”，而不是 `/memory`、`/compact`、`/resume`
  各自延续什么对象，再看
  [04-专题深潜/12-会话发现、历史检索与恢复选择专题.md](./04-%E4%B8%93%E9%A2%98%E6%B7%B1%E6%BD%9C/12-%E4%BC%9A%E8%AF%9D%E5%8F%91%E7%8E%B0%E3%80%81%E5%8E%86%E5%8F%B2%E6%A3%80%E7%B4%A2%E4%B8%8E%E6%81%A2%E5%A4%8D%E9%80%89%E6%8B%A9%E4%B8%93%E9%A2%98.md)。
- 稳地运营当前会话对象，而不是把 `/copy`、`/rename`、`/export`、`/branch`、`/rewind`、`/clear` 当成杂项命令：
  [04-专题深潜/07-会话运营、分叉与回退专题.md](./04-%E4%B8%93%E9%A2%98%E6%B7%B1%E6%BD%9C/07-%E4%BC%9A%E8%AF%9D%E8%BF%90%E8%90%A5%E3%80%81%E5%88%86%E5%8F%89%E4%B8%8E%E5%9B%9E%E9%80%80%E4%B8%93%E9%A2%98.md)。
  如果你主要卡在“以前的工作在哪里、该恢复哪个会话”，而不是当前工作对象怎样分叉、回退、外化和清空，再看
  [04-专题深潜/12-会话发现、历史检索与恢复选择专题.md](./04-%E4%B8%93%E9%A2%98%E6%B7%B1%E6%BD%9C/12-%E4%BC%9A%E8%AF%9D%E5%8F%91%E7%8E%B0%E3%80%81%E5%8E%86%E5%8F%B2%E6%A3%80%E7%B4%A2%E4%B8%8E%E6%81%A2%E5%A4%8D%E9%80%89%E6%8B%A9%E4%B8%93%E9%A2%98.md)。
- 找回过去的会话与提问：
  [04-专题深潜/12-会话发现、历史检索与恢复选择专题.md](./04-%E4%B8%93%E9%A2%98%E6%B7%B1%E6%BD%9C/12-%E4%BC%9A%E8%AF%9D%E5%8F%91%E7%8E%B0%E3%80%81%E5%8E%86%E5%8F%B2%E6%A3%80%E7%B4%A2%E4%B8%8E%E6%81%A2%E5%A4%8D%E9%80%89%E6%8B%A9%E4%B8%93%E9%A2%98.md)
- 在 IDE、Desktop、Mobile 之间继续同一工作：
  [04-专题深潜/多前端接续与条件远端/README.md](./04-%E4%B8%93%E9%A2%98%E6%B7%B1%E6%BD%9C/%E5%A4%9A%E5%89%8D%E7%AB%AF%E6%8E%A5%E7%BB%AD%E4%B8%8E%E6%9D%A1%E4%BB%B6%E8%BF%9C%E7%AB%AF/README.md)
- 稳地管理插件、MCP、skills、hooks 和 agents：
  [00-阅读路径.md](./00-%E9%98%85%E8%AF%BB%E8%B7%AF%E5%BE%84.md)
  里的“路径 91：我想稳地管理插件、MCP、skills、hooks 和 agents”。
  如果你主要卡在“到底该选技能、插件、MCP 还是 Hooks 这一层”，再继续看
  [05-控制面深挖/02-MCP、插件、技能与 Hooks：如何选择正确扩展层.md](./05-%E6%8E%A7%E5%88%B6%E9%9D%A2%E6%B7%B1%E6%8C%96/02-MCP%E3%80%81%E6%8F%92%E4%BB%B6%E3%80%81%E6%8A%80%E8%83%BD%E4%B8%8E%20Hooks%EF%BC%9A%E5%A6%82%E4%BD%95%E9%80%89%E6%8B%A9%E6%AD%A3%E7%A1%AE%E6%89%A9%E5%B1%95%E5%B1%82.md)。
- 把 Claude Code 接进脚本、后台任务或协议流：
  [04-专题深潜/13-非交互、后台会话与自动化专题.md](./04-%E4%B8%93%E9%A2%98%E6%B7%B1%E6%BD%9C/13-%E9%9D%9E%E4%BA%A4%E4%BA%92%E3%80%81%E5%90%8E%E5%8F%B0%E4%BC%9A%E8%AF%9D%E4%B8%8E%E8%87%AA%E5%8A%A8%E5%8C%96%E4%B8%93%E9%A2%98.md) ->
  [05-控制面深挖/非交互结果、summary 与协议流/README.md](./05-%E6%8E%A7%E5%88%B6%E9%9D%A2%E6%B7%B1%E6%8C%96/%E9%9D%9E%E4%BA%A4%E4%BA%92%E7%BB%93%E6%9E%9C%E3%80%81summary%20%E4%B8%8E%E5%8D%8F%E8%AE%AE%E6%B5%81/README.md)
- 想建立运行时总图，而不是先学操作：
  [03-参考索引/04-功能面七分法.md](./03-%E5%8F%82%E8%80%83%E7%B4%A2%E5%BC%95/04-%E5%8A%9F%E8%83%BD%E9%9D%A2%E4%B8%83%E5%88%86%E6%B3%95.md) ->
  [02-能力地图/README.md](./02-%E8%83%BD%E5%8A%9B%E5%9C%B0%E5%9B%BE/README.md)
- 只想按名字、入口和合同速查：
  [03-参考索引/README.md](./03-%E5%8F%82%E8%80%83%E7%B4%A2%E5%BC%95/README.md)
- 分清 host、viewer 与 health-check 的会外入口边界：
  [05-控制面深挖/21-Host、Viewer 与 Health Check：为什么 server、remote-control、assistant、doctor 不能写成同一类会外入口.md](./05-%E6%8E%A7%E5%88%B6%E9%9D%A2%E6%B7%B1%E6%8C%96/21-Host%E3%80%81Viewer%20%E4%B8%8E%20Health%20Check%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%20server%E3%80%81remote-control%E3%80%81assistant%E3%80%81doctor%20%E4%B8%8D%E8%83%BD%E5%86%99%E6%88%90%E5%90%8C%E4%B8%80%E7%B1%BB%E4%BC%9A%E5%A4%96%E5%85%A5%E5%8F%A3.md)
- 分清 remote-control 的 workspace trust、bridge eligibility 与 trusted-device 为什么不是同一把钥匙：
  [05-控制面深挖/23-Workspace Trust、Bridge Eligibility 与 Trusted Device：为什么 remote-control 的 trust、auth、policy 不是同一把钥匙.md](./05-%E6%8E%A7%E5%88%B6%E9%9D%A2%E6%B7%B1%E6%8C%96/23-Workspace%20Trust%E3%80%81Bridge%20Eligibility%20%E4%B8%8E%20Trusted%20Device%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%20remote-control%20%E7%9A%84%20trust%E3%80%81auth%E3%80%81policy%20%E4%B8%8D%E6%98%AF%E5%90%8C%E4%B8%80%E6%8A%8A%E9%92%A5%E5%8C%99.md)
- 分清 remote session 的远端发布命令面、本地保留命令面与执行路由为什么不是同一张命令表：
  [05-控制面深挖/68-slash_commands、REMOTE_SAFE_COMMANDS、local-jsx fallthrough 与 remote send：为什么 remote session 的远端发布命令面、本地保留命令面与实际执行路由不是同一张命令表.md](./05-%E6%8E%A7%E5%88%B6%E9%9D%A2%E6%B7%B1%E6%8C%96/68-slash_commands%E3%80%81REMOTE_SAFE_COMMANDS%E3%80%81local-jsx%20fallthrough%20%E4%B8%8E%20remote%20send%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%20remote%20session%20%E7%9A%84%E8%BF%9C%E7%AB%AF%E5%8F%91%E5%B8%83%E5%91%BD%E4%BB%A4%E9%9D%A2%E3%80%81%E6%9C%AC%E5%9C%B0%E4%BF%9D%E7%95%99%E5%91%BD%E4%BB%A4%E9%9D%A2%E4%B8%8E%E5%AE%9E%E9%99%85%E6%89%A7%E8%A1%8C%E8%B7%AF%E7%94%B1%E4%B8%8D%E6%98%AF%E5%90%8C%E4%B8%80%E5%BC%A0%E5%91%BD%E4%BB%A4%E8%A1%A8.md)
- 想分清 `assistant viewer`、`--remote` TUI、`viewerOnly` 与 coarse remote bit 的合同厚度：
  [03-参考索引/02-能力边界/README.md](./03-%E5%8F%82%E8%80%83%E7%B4%A2%E5%BC%95/02-%E8%83%BD%E5%8A%9B%E8%BE%B9%E7%95%8C/README.md) ->
  [05-控制面深挖/146-assistant%20viewer%E3%80%81--remote%20TUI%E3%80%81viewerOnly%E3%80%81remoteSessionUrl%20%E4%B8%8E%20filterCommandsForRemoteMode%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%E5%90%8C%E4%B8%80%20coarse%20remote%20bit%20%E4%B8%8D%E7%AD%89%E4%BA%8E%E5%90%8C%E6%A0%B7%E5%8E%9A%E5%BA%A6%E7%9A%84%20remote%20%E5%90%88%E5%90%8C.md](./05-%E6%8E%A7%E5%88%B6%E9%9D%A2%E6%B7%B1%E6%8C%96/146-assistant%20viewer%E3%80%81--remote%20TUI%E3%80%81viewerOnly%E3%80%81remoteSessionUrl%20%E4%B8%8E%20filterCommandsForRemoteMode%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%E5%90%8C%E4%B8%80%20coarse%20remote%20bit%20%E4%B8%8D%E7%AD%89%E4%BA%8E%E5%90%8C%E6%A0%B7%E5%8E%9A%E5%BA%A6%E7%9A%84%20remote%20%E5%90%88%E5%90%8C.md)
- 想分清 `REMOTE_SAFE_COMMANDS`、`filterCommandsForRemoteMode`、`handleRemoteInit`、`session` 与 `mobile` 的 remote-safe surface：
  [03-参考索引/02-能力边界/README.md](./03-%E5%8F%82%E8%80%83%E7%B4%A2%E5%BC%95/02-%E8%83%BD%E5%8A%9B%E8%BE%B9%E7%95%8C/README.md) ->
  [05-控制面深挖/147-REMOTE_SAFE_COMMANDS%E3%80%81filterCommandsForRemoteMode%E3%80%81handleRemoteInit%E3%80%81session%20%E4%B8%8E%20mobile%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%20remote-safe%20%E5%91%BD%E4%BB%A4%E9%9D%A2%E4%B8%8D%E6%98%AF%20runtime%20readiness%20proof.md](./05-%E6%8E%A7%E5%88%B6%E9%9D%A2%E6%B7%B1%E6%8C%96/147-REMOTE_SAFE_COMMANDS%E3%80%81filterCommandsForRemoteMode%E3%80%81handleRemoteInit%E3%80%81session%20%E4%B8%8E%20mobile%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%20remote-safe%20%E5%91%BD%E4%BB%A4%E9%9D%A2%E4%B8%8D%E6%98%AF%20runtime%20readiness%20proof.md)
- 想分清 `CLAUDE_CODE_REMOTE`、`getIsRemoteMode()`、`print`、`reload-plugins` 与 `settingsSync` 的 headless remote env：
  [03-参考索引/02-能力边界/README.md](./03-%E5%8F%82%E8%80%83%E7%B4%A2%E5%BC%95/02-%E8%83%BD%E5%8A%9B%E8%BE%B9%E7%95%8C/README.md) ->
  [05-控制面深挖/148-CLAUDE_CODE_REMOTE%E3%80%81getIsRemoteMode%E3%80%81print%E3%80%81reload-plugins%20%E4%B8%8E%20settingsSync%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%20headless%20remote%20%E5%88%86%E6%94%AF%E4%B8%8D%E6%98%AF%20interactive%20remote%20bit%20%E7%9A%84%E9%95%9C%E5%83%8F.md](./05-%E6%8E%A7%E5%88%B6%E9%9D%A2%E6%B7%B1%E6%8C%96/148-CLAUDE_CODE_REMOTE%E3%80%81getIsRemoteMode%E3%80%81print%E3%80%81reload-plugins%20%E4%B8%8E%20settingsSync%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%20headless%20remote%20%E5%88%86%E6%94%AF%E4%B8%8D%E6%98%AF%20interactive%20remote%20bit%20%E7%9A%84%E9%95%9C%E5%83%8F.md)
- 想分清 `CLAUDE_CODE_REMOTE_MEMORY_DIR`、`memdir`、`SessionMemory`、`extractMemories` 与 `print` 的 remote 记忆持久化：
  [03-参考索引/02-能力边界/README.md](./03-%E5%8F%82%E8%80%83%E7%B4%A2%E5%BC%95/02-%E8%83%BD%E5%8A%9B%E8%BE%B9%E7%95%8C/README.md) ->
  [05-控制面深挖/149-CLAUDE_CODE_REMOTE_MEMORY_DIR%E3%80%81memdir%E3%80%81SessionMemory%E3%80%81extractMemories%20%E4%B8%8E%20print%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%20remote%20%E8%AE%B0%E5%BF%86%E6%8C%81%E4%B9%85%E5%8C%96%E4%B8%8D%E6%98%AF%E5%8D%95%E6%A0%B9%E7%9B%AE%E5%BD%95%EF%BC%8C%E8%80%8C%E6%98%AF%20auto-memory%20%E6%A0%B9%E4%B8%8E%20session%20%E8%B4%A6%E6%9C%AC%E7%9A%84%E5%8F%8C%E8%BD%A8%E4%BD%93%E7%B3%BB.md](./05-%E6%8E%A7%E5%88%B6%E9%9D%A2%E6%B7%B1%E6%8C%96/149-CLAUDE_CODE_REMOTE_MEMORY_DIR%E3%80%81memdir%E3%80%81SessionMemory%E3%80%81extractMemories%20%E4%B8%8E%20print%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%20remote%20%E8%AE%B0%E5%BF%86%E6%8C%81%E4%B9%85%E5%8C%96%E4%B8%8D%E6%98%AF%E5%8D%95%E6%A0%B9%E7%9B%AE%E5%BD%95%EF%BC%8C%E8%80%8C%E6%98%AF%20auto-memory%20%E6%A0%B9%E4%B8%8E%20session%20%E8%B4%A6%E6%9C%AC%E7%9A%84%E5%8F%8C%E8%BD%A8%E4%BD%93%E7%B3%BB.md)
- 想分清 `system/init.slash_commands`、`REMOTE_SAFE_COMMANDS`、`PromptInput`、`REPL`、`processUserInput` 与 `print` 的 slash contract：
  [03-参考索引/02-能力边界/README.md](./03-%E5%8F%82%E8%80%83%E7%B4%A2%E5%BC%95/02-%E8%83%BD%E5%8A%9B%E8%BE%B9%E7%95%8C/README.md) ->
  [05-控制面深挖/150-system-init.slash_commands%E3%80%81REMOTE_SAFE_COMMANDS%E3%80%81PromptInput%E3%80%81REPL%E3%80%81processUserInput%20%E4%B8%8E%20print%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%20slash%20%E4%B8%8D%E6%98%AF%E4%B8%80%E5%BC%A0%E5%91%BD%E4%BB%A4%E8%A1%A8%EF%BC%8C%E8%80%8C%E6%98%AF%E5%A3%B0%E6%98%8E%E9%9D%A2%E3%80%81%E6%96%87%E6%9C%AC%E8%BD%BD%E8%8D%B7%E4%B8%8E%20runtime%20%E5%86%8D%E8%A7%A3%E9%87%8A%E7%9A%84%E4%B8%89%E6%AE%B5%E5%90%88%E5%90%8C.md](./05-%E6%8E%A7%E5%88%B6%E9%9D%A2%E6%B7%B1%E6%8C%96/150-system-init.slash_commands%E3%80%81REMOTE_SAFE_COMMANDS%E3%80%81PromptInput%E3%80%81REPL%E3%80%81processUserInput%20%E4%B8%8E%20print%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%20slash%20%E4%B8%8D%E6%98%AF%E4%B8%80%E5%BC%A0%E5%91%BD%E4%BB%A4%E8%A1%A8%EF%BC%8C%E8%80%8C%E6%98%AF%E5%A3%B0%E6%98%8E%E9%9D%A2%E3%80%81%E6%96%87%E6%9C%AC%E8%BD%BD%E8%8D%B7%E4%B8%8E%20runtime%20%E5%86%8D%E8%A7%A3%E9%87%8A%E7%9A%84%E4%B8%89%E6%AE%B5%E5%90%88%E5%90%8C.md)
- 想分清 `getSessionId`、`switchSession`、`StatusLine`、`assistant viewer`、`remoteSessionUrl` 与 `useRemoteSession` 的 remote session identity：
  [03-参考索引/02-能力边界/README.md](./03-%E5%8F%82%E8%80%83%E7%B4%A2%E5%BC%95/02-%E8%83%BD%E5%8A%9B%E8%BE%B9%E7%95%8C/README.md) ->
  [05-控制面深挖/151-getSessionId%E3%80%81switchSession%E3%80%81StatusLine%E3%80%81assistant%20viewer%E3%80%81remoteSessionUrl%20%E4%B8%8E%20useRemoteSession%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%20remote.session_id%20%E5%8F%AF%E8%A7%81%EF%BC%8C%E4%B8%8D%E7%AD%89%E4%BA%8E%E5%BD%93%E5%89%8D%E5%89%8D%E7%AB%AF%E6%8B%A5%E6%9C%89%E9%82%A3%E6%9D%A1%20remote%20session.md](./05-%E6%8E%A7%E5%88%B6%E9%9D%A2%E6%B7%B1%E6%8C%96/151-getSessionId%E3%80%81switchSession%E3%80%81StatusLine%E3%80%81assistant%20viewer%E3%80%81remoteSessionUrl%20%E4%B8%8E%20useRemoteSession%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%20remote.session_id%20%E5%8F%AF%E8%A7%81%EF%BC%8C%E4%B8%8D%E7%AD%89%E4%BA%8E%E5%BD%93%E5%89%8D%E5%89%8D%E7%AB%AF%E6%8B%A5%E6%9C%89%E9%82%A3%E6%9D%A1%20remote%20session.md)
- 想分清 `sessionStorage`、`hydrateFromCCRv2InternalEvents`、`sessionRestore`、`listSessionsImpl`、`SessionPreview` 与 `sessionTitle` 的 durable session metadata：
  [03-参考索引/02-能力边界/README.md](./03-%E5%8F%82%E8%80%83%E7%B4%A2%E5%BC%95/02-%E8%83%BD%E5%8A%9B%E8%BE%B9%E7%95%8C/README.md) ->
  [05-控制面深挖/152-sessionStorage%E3%80%81hydrateFromCCRv2InternalEvents%E3%80%81sessionRestore%E3%80%81listSessionsImpl%E3%80%81SessionPreview%20%E4%B8%8E%20sessionTitle%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%20durable%20session%20metadata%20%E4%B8%8D%E6%98%AF%20live%20system-init%EF%BC%8C%E4%B9%9F%E4%B8%8D%E6%98%AF%20foreground%20external-metadata.md](./05-%E6%8E%A7%E5%88%B6%E9%9D%A2%E6%B7%B1%E6%8C%96/152-sessionStorage%E3%80%81hydrateFromCCRv2InternalEvents%E3%80%81sessionRestore%E3%80%81listSessionsImpl%E3%80%81SessionPreview%20%E4%B8%8E%20sessionTitle%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%20durable%20session%20metadata%20%E4%B8%8D%E6%98%AF%20live%20system-init%EF%BC%8C%E4%B9%9F%E4%B8%8D%E6%98%AF%20foreground%20external-metadata.md)
- 想分清 `SENTINEL_LOADING`、`SENTINEL_LOADING_FAILED`、`SENTINEL_START`、`maybeLoadOlder`、`fillBudgetRef`、`remoteConnectionStatus` 与 `BriefIdleStatus` 的历史翻页哨兵：
  [03-参考索引/02-能力边界/README.md](./03-%E5%8F%82%E8%80%83%E7%B4%A2%E5%BC%95/02-%E8%83%BD%E5%8A%9B%E8%BE%B9%E7%95%8C/README.md) ->
  [05-控制面深挖/153-SENTINEL_LOADING%E3%80%81SENTINEL_LOADING_FAILED%E3%80%81SENTINEL_START%E3%80%81maybeLoadOlder%E3%80%81fillBudgetRef%E3%80%81remoteConnectionStatus%20%E4%B8%8E%20BriefIdleStatus%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%20attached%20viewer%20%E7%9A%84%E5%8E%86%E5%8F%B2%E7%BF%BB%E9%A1%B5%E5%93%A8%E5%85%B5%E4%B8%8D%E6%98%AF%20remote%20presence%20surface.md](./05-%E6%8E%A7%E5%88%B6%E9%9D%A2%E6%B7%B1%E6%8C%96/153-SENTINEL_LOADING%E3%80%81SENTINEL_LOADING_FAILED%E3%80%81SENTINEL_START%E3%80%81maybeLoadOlder%E3%80%81fillBudgetRef%E3%80%81remoteConnectionStatus%20%E4%B8%8E%20BriefIdleStatus%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%20attached%20viewer%20%E7%9A%84%E5%8E%86%E5%8F%B2%E7%BF%BB%E9%A1%B5%E5%93%A8%E5%85%B5%E4%B8%8D%E6%98%AF%20remote%20presence%20surface.md)
- 想分清 `discoverAssistantSessions`、`launchAssistantInstallWizard`、`launchAssistantSessionChooser`、`createRemoteSessionConfig` 与 attach banner 的 assistant entry chain：
  [03-参考索引/02-能力边界/README.md](./03-%E5%8F%82%E8%80%83%E7%B4%A2%E5%BC%95/02-%E8%83%BD%E5%8A%9B%E8%BE%B9%E7%95%8C/README.md) ->
  [05-控制面深挖/154-discoverAssistantSessions%E3%80%81launchAssistantInstallWizard%E3%80%81launchAssistantSessionChooser%E3%80%81createRemoteSessionConfig%20%E4%B8%8E%20attach%20banner%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%20claude%20assistant%20%E7%9A%84%E5%8F%91%E7%8E%B0%E3%80%81%E5%AE%89%E8%A3%85%E3%80%81%E9%80%89%E6%8B%A9%E4%B8%8E%E9%99%84%E7%9D%80%E4%B8%8D%E6%98%AF%E5%90%8C%E4%B8%80%E7%A7%8D%20connect%20flow.md](./05-%E6%8E%A7%E5%88%B6%E9%9D%A2%E6%B7%B1%E6%8C%96/154-discoverAssistantSessions%E3%80%81launchAssistantInstallWizard%E3%80%81launchAssistantSessionChooser%E3%80%81createRemoteSessionConfig%20%E4%B8%8E%20attach%20banner%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%20claude%20assistant%20%E7%9A%84%E5%8F%91%E7%8E%B0%E3%80%81%E5%AE%89%E8%A3%85%E3%80%81%E9%80%89%E6%8B%A9%E4%B8%8E%E9%99%84%E7%9D%80%E4%B8%8D%E6%98%AF%E5%90%8C%E4%B8%80%E7%A7%8D%20connect%20flow.md)
- 想分清 `showSetupDialog`、`renderAndRun`、`launchResumeChooser`、`launchRepl`、`AppStateProvider` 与 `KeybindingSetup` 的 interactive host 边界：
  [03-参考索引/02-能力边界/README.md](./03-%E5%8F%82%E8%80%83%E7%B4%A2%E5%BC%95/02-%E8%83%BD%E5%8A%9B%E8%BE%B9%E7%95%8C/README.md) ->
  [05-控制面深挖/155-showSetupDialog、renderAndRun、launchResumeChooser、launchRepl、AppStateProvider 与 KeybindingSetup：为什么 setup-dialog host 与 attached REPL host 不是同一种 interactive host.md](./05-控制面深挖/155-showSetupDialog、renderAndRun、launchResumeChooser、launchRepl、AppStateProvider%20与%20KeybindingSetup：为什么%20setup-dialog%20host%20与%20attached%20REPL%20host%20不是同一种%20interactive%20host.md)
- 想分清 `getSessionFilesLite`、`loadFullLog`、`SessionPreview`、`useAssistantHistory` 与 `fetchLatestEvents` 的 resume preview 历史边界：
  [03-参考索引/02-能力边界/README.md](./03-%E5%8F%82%E8%80%83%E7%B4%A2%E5%BC%95/02-%E8%83%BD%E5%8A%9B%E8%BE%B9%E7%95%8C/README.md) ->
  [05-控制面深挖/156-getSessionFilesLite、loadFullLog、SessionPreview、useAssistantHistory 与 fetchLatestEvents：为什么 resume preview 的本地 transcript 快照不是 attached viewer 的 remote history.md](./05-控制面深挖/156-getSessionFilesLite、loadFullLog、SessionPreview、useAssistantHistory%20与%20fetchLatestEvents：为什么%20resume%20preview%20的本地%20transcript%20快照不是%20attached%20viewer%20的%20remote%20history.md)
- 想分清 `getSessionFilesLite`、`enrichLogs`、`LogSelector`、`SessionPreview` 与 `loadFullLog` 的列表摘要边界：
  [03-参考索引/02-能力边界/README.md](./03-%E5%8F%82%E8%80%83%E7%B4%A2%E5%BC%95/02-%E8%83%BD%E5%8A%9B%E8%BE%B9%E7%95%8C/README.md) ->
  [05-控制面深挖/157-getSessionFilesLite、enrichLogs、LogSelector、SessionPreview 与 loadFullLog：为什么 resume 的列表摘要面不是 preview transcript.md](./05-控制面深挖/157-getSessionFilesLite、enrichLogs、LogSelector、SessionPreview%20与%20loadFullLog：为什么%20resume%20的列表摘要面不是%20preview%20transcript.md)
- 想分清 `SessionPreview`、`loadFullLog`、`loadConversationForResume`、`switchSession` 与 `adoptResumedSessionFile` 的 preview transcript 边界：
  [03-参考索引/02-能力边界/README.md](./03-%E5%8F%82%E8%80%83%E7%B4%A2%E5%BC%95/02-%E8%83%BD%E5%8A%9B%E8%BE%B9%E7%95%8C/README.md) ->
  [05-控制面深挖/158-SessionPreview、loadFullLog、loadConversationForResume、switchSession 与 adoptResumedSessionFile：为什么 resume 的 preview transcript 不是正式 session restore.md](./05-控制面深挖/158-SessionPreview、loadFullLog、loadConversationForResume、switchSession%20与%20adoptResumedSessionFile：为什么%20resume%20的%20preview%20transcript%20不是正式%20session%20restore.md)
- 想分清 `forkSession`、`switchSession`、`copyPlanForFork`、`restoreWorktreeForResume` 与 `adoptResumedSessionFile` 的会话分叉边界：
  [05-控制面深挖/159-forkSession、switchSession、copyPlanForFork、restoreWorktreeForResume 与 adoptResumedSessionFile：为什么 --fork-session 不是较弱的原会话恢复，而是新 session 分叉.md](./05-%E6%8E%A7%E5%88%B6%E9%9D%A2%E6%B7%B1%E6%8C%96/159-forkSession%E3%80%81switchSession%E3%80%81copyPlanForFork%E3%80%81restoreWorktreeForResume%20%E4%B8%8E%20adoptResumedSessionFile%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%20--fork-session%20%E4%B8%8D%E6%98%AF%E8%BE%83%E5%BC%B1%E7%9A%84%E5%8E%9F%E4%BC%9A%E8%AF%9D%E6%81%A2%E5%A4%8D%EF%BC%8C%E8%80%8C%E6%98%AF%E6%96%B0%20session%20%E5%88%86%E5%8F%89.md)
- 想分清 `loadConversationForResume`、`deserializeMessagesWithInterruptDetection`、`copyPlanForResume`、`fileHistoryRestoreStateFromLog` 与 `processSessionStartHooks` 的 resume 内容载荷边界：
  [05-控制面深挖/160-loadConversationForResume、deserializeMessagesWithInterruptDetection、copyPlanForResume、fileHistoryRestoreStateFromLog 与 processSessionStartHooks：为什么 resume 恢复包不是同一种内容载荷.md](./05-%E6%8E%A7%E5%88%B6%E9%9D%A2%E6%B7%B1%E6%8C%96/160-loadConversationForResume%E3%80%81deserializeMessagesWithInterruptDetection%E3%80%81copyPlanForResume%E3%80%81fileHistoryRestoreStateFromLog%20%E4%B8%8E%20processSessionStartHooks%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%20resume%20%E6%81%A2%E5%A4%8D%E5%8C%85%E4%B8%8D%E6%98%AF%E5%90%8C%E4%B8%80%E7%A7%8D%E5%86%85%E5%AE%B9%E8%BD%BD%E8%8D%B7.md)
- 想分清 `main.tsx`、`launchResumeChooser`、`ResumeConversation`、`resume.tsx` 与 `REPL.resume` 的 resume 入口宿主：
  [05-控制面深挖/161-main.tsx、launchResumeChooser、ResumeConversation、resume.tsx 与 REPL.resume：为什么 --continue、startup picker 与会内 resume 共享恢复合同，却不是同一种入口宿主.md](./05-控制面深挖/161-main.tsx、launchResumeChooser、ResumeConversation、resume.tsx%20与%20REPL.resume：为什么%20--continue、startup%20picker%20与会内%20resume%20共享恢复合同，却不是同一种入口宿主.md)
- 想分清 `main.tsx`、`print.ts`、`loadInitialMessages`、`ResumeConversation` 与 `REPL.resume` 的宿主族边界：
  [05-控制面深挖/162-main.tsx、print.ts、loadInitialMessages、ResumeConversation 与 REPL.resume：为什么 interactive resume host 与 headless print host 共享恢复语义，却不是同一种宿主族.md](./05-控制面深挖/162-main.tsx、print.ts、loadInitialMessages、ResumeConversation%20与%20REPL.resume：为什么%20interactive%20resume%20host%20与%20headless%20print%20host%20共享恢复语义，却不是同一种宿主族.md)
- 想分清 `print.ts`、`parseSessionIdentifier`、`hydrateRemoteSession` 与 `loadConversationForResume` 的 print resume 前置阶段：
  [05-控制面深挖/163-print.ts、parseSessionIdentifier、hydrateRemoteSession 与 loadConversationForResume：为什么 print resume 的 parse、hydrate、restore 不是同一种前置阶段.md](./05-控制面深挖/163-print.ts、parseSessionIdentifier、hydrateRemoteSession%20与%20loadConversationForResume：为什么%20print%20resume%20的%20parse%E3%80%81hydrate%E3%80%81restore%20不是同一种前置阶段.md)
- 想分清 `deserializeMessages`、`SessionEnd`、`SessionStart` 与 `interrupted-resume` 的 runtime stage：
  [05-控制面深挖/164-deserializeMessages、SessionEnd、SessionStart 与 interrupted-resume：为什么恢复前后的合法化、修复与 hook 注入不是同一种 runtime stage.md](./05-控制面深挖/164-deserializeMessages、SessionEnd、SessionStart%20与%20interrupted-resume：为什么恢复前后的合法化、修复与%20hook%20注入不是同一种%20runtime%20stage.md)
- 想分清 `hydrateFromCCRv2InternalEvents`、`externalMetadataToAppState`、`hydrateRemoteSession` 与 `startup fallback` 的 remote recovery 阶段：
  [05-控制面深挖/165-hydrateFromCCRv2InternalEvents、externalMetadataToAppState、hydrateRemoteSession 与 startup fallback：为什么 print resume 的 remote recovery 不是同一种 stage.md](./05-控制面深挖/165-hydrateFromCCRv2InternalEvents、externalMetadataToAppState、hydrateRemoteSession%20与%20startup%20fallback：为什么%20print%20resume%20的%20remote%20recovery%20不是同一种%20stage.md)
- 想分清 `print.ts`、`externalMetadataToAppState`、`setMainLoopModelOverride` 与 `startup fallback` 的 print remote state：
  [05-控制面深挖/166-print.ts、externalMetadataToAppState、setMainLoopModelOverride 与 startup fallback：为什么 print remote recovery 的 transcript、metadata 与 emptiness 不是同一种 stage.md](./05-控制面深挖/166-print.ts、externalMetadataToAppState、setMainLoopModelOverride%20与%20startup%20fallback：为什么%20print%20remote%20recovery%20的%20transcript%E3%80%81metadata%20与%20emptiness%20不是同一种%20stage.md)
- 想分清 `restoredWorkerState`、`externalMetadataToAppState`、`SessionExternalMetadata` 与 `RemoteIO` 的 metadata readback 消费合同：
  [05-控制面深挖/167-restoredWorkerState、externalMetadataToAppState、SessionExternalMetadata 与 RemoteIO：为什么 CCR v2 的 metadata readback 不是 observer metadata 的同一种本地消费合同.md](./05-控制面深挖/167-restoredWorkerState、externalMetadataToAppState、SessionExternalMetadata%20与%20RemoteIO：为什么%20CCR%20v2%20的%20metadata%20readback%20不是%20observer%20metadata%20的同一种本地消费合同.md)
- 想分清 `StructuredIO`、`RemoteIO`、`setInternalEventReader`、`setInternalEventWriter` 与 `flushInternalEvents` 的 transport 恢复厚度：
  [05-控制面深挖/168-StructuredIO、RemoteIO、setInternalEventReader、setInternalEventWriter 与 flushInternalEvents：为什么 headless transport 的协议宿主不等于同一种恢复厚度.md](./05-控制面深挖/168-StructuredIO、RemoteIO、setInternalEventReader、setInternalEventWriter%20与%20flushInternalEvents：为什么%20headless%20transport%20的协议宿主不等于同一种恢复厚度.md)
- 想分清 `/resume`、`--continue`、`print --resume` 与 `remote-control --continue` 的接续来源边界：
  [05-控制面深挖/169-resume、--continue、print --resume 与 remote-control --continue：为什么 stable conversation resume、headless remote hydrate 与 bridge continuity 不是同一种接续来源.md](./05-控制面深挖/169-resume、--continue、print%20--resume%20与%20remote-control%20--continue：为什么%20stable%20conversation%20resume%E3%80%81headless%20remote%20hydrate%20与%20bridge%20continuity%20不是同一种接续来源.md)
- 想分清 `print --continue`、`print --resume session-id`、`print --resume url` 与 `loadConversationForResume` 的 headless resume 来源确定性：
  [05-控制面深挖/170-print --continue、print --resume session-id、print --resume url 与 loadConversationForResume：为什么同属 headless resume，也不是同一种 source certainty.md](./05-控制面深挖/170-print%20--continue、print%20--resume%20session-id、print%20--resume%20url%20与%20loadConversationForResume：为什么同属%20headless%20resume，也不是同一种%20source%20certainty.md)
- 想分清 `loadMessagesFromJsonlPath`、`parseSessionIdentifier`、`loadConversationForResume` 与 `sessionId` 的 local artifact provenance：
  [05-控制面深挖/171-loadMessagesFromJsonlPath、parseSessionIdentifier、loadConversationForResume 与 sessionId：为什么 print --resume .jsonl 与 print --resume session-id 不是同一种 local artifact provenance.md](./05-控制面深挖/171-loadMessagesFromJsonlPath、parseSessionIdentifier、loadConversationForResume%20与%20sessionId：为什么%20print%20--resume%20.jsonl%20与%20print%20--resume%20session-id%20不是同一种%20local%20artifact%20provenance.md)
- 想分清 `readBridgePointerAcrossWorktrees`、`getBridgeSession`、`reconnectSession` 与 `environment_id` 的 bridge authority：
  [05-控制面深挖/172-readBridgePointerAcrossWorktrees、getBridgeSession、reconnectSession 与 environment_id：为什么 remote-control --continue 与 remote-control --session-id 不是同一种 bridge authority.md](./05-控制面深挖/172-readBridgePointerAcrossWorktrees、getBridgeSession、reconnectSession%20与%20environment_id：为什么%20remote-control%20--continue%20与%20remote-control%20--session-id%20不是同一种%20bridge%20authority.md)
- 想分清 `BridgePointer.environmentId`、`getBridgeSession.environment_id`、`reuseEnvironmentId` 与 `registerBridgeEnvironment` 的环境真相层级：
  [05-控制面深挖/173-BridgePointer.environmentId、getBridgeSession.environment_id、reuseEnvironmentId 与 registerBridgeEnvironment：为什么 pointer 里的 env hint、server session env 与 registered env 不是同一种 truth.md](./05-控制面深挖/173-BridgePointer.environmentId、getBridgeSession.environment_id、reuseEnvironmentId%20与%20registerBridgeEnvironment：为什么%20pointer%20里的%20env%20hint、server%20session%20env%20与%20registered%20env%20不是同一种%20truth.md)
- 想分清 `BridgeConfig.environmentId`、`reuseEnvironmentId`、`registerBridgeEnvironment.environment_id` 与 `createBridgeSession` 的环境主权：
  [05-控制面深挖/174-BridgeConfig.environmentId、reuseEnvironmentId、registerBridgeEnvironment.environment_id 与 createBridgeSession：为什么本地 env key、reuse claim、live env 与 session attach target 不是同一种环境主权.md](./05-控制面深挖/174-BridgeConfig.environmentId、reuseEnvironmentId、registerBridgeEnvironment.environment_id%20与%20createBridgeSession：为什么%20本地%20env%20key、reuse%20claim、live%20env%20与%20session%20attach%20target%20不是同一种环境主权.md)
- 想分清 `BridgeWorkerType`、`metadata.worker_type`、`BridgePointer.source` 与 `environment_id` 的 provenance：
  [05-控制面深挖/175-BridgeWorkerType、metadata.worker_type、BridgePointer.source 与 environment_id：为什么环境来源标签、prior-state 域与环境身份不是同一种 provenance.md](./05-控制面深挖/175-BridgeWorkerType、metadata.worker_type、BridgePointer.source%20与%20environment_id：为什么%20环境来源标签、prior-state%20域与环境身份不是同一种%20provenance.md)
- 想分清 `createBridgeSession.environment_id`、`source`、`session_context` 与 `permission_mode` 的会话归属：
  [05-控制面深挖/176-createBridgeSession.environment_id、source、session_context 与 permission_mode：为什么 session attach target、来源声明、上下文载荷与默认策略不是同一种会话归属.md](./05-控制面深挖/176-createBridgeSession.environment_id、source、session_context%20与%20permission_mode：为什么%20session%20attach%20target、来源声明、上下文载荷与默认策略不是同一种会话归属.md)
- 想分清 `createBridgeSession.source`、`metadata.worker_type`、`BridgeWorkerType` 与 `claude_code_assistant` 的 remote provenance：
  [05-控制面深挖/177-createBridgeSession.source、metadata.worker_type、BridgeWorkerType 与 claude_code_assistant：为什么 session origin declaration 与 environment origin label 不是同一种 remote provenance.md](./05-控制面深挖/177-createBridgeSession.source、metadata.worker_type、BridgeWorkerType%20与%20claude_code_assistant：为什么%20session%20origin%20declaration%20与%20environment%20origin%20label%20不是同一种%20remote%20provenance.md)
- 想分清 `session_context.sources`、`session_context.outcomes`、`session_context.model` 与 `getBranchFromSession` 的上下文主语：
  [05-控制面深挖/178-session_context.sources、session_context.outcomes、session_context.model 与 getBranchFromSession：为什么 repo source、branch outcome 与 model stamp 不是同一种上下文主语.md](./05-控制面深挖/178-session_context.sources、session_context.outcomes、session_context.model%20与%20getBranchFromSession：为什么%20repo%20source、branch%20outcome%20与%20model%20stamp%20不是同一种上下文主语.md)
- 想分清 `session_context.sources`、`session_context.outcomes`、`parseGitRemote`、`parseGitHubRepository` 与 `getBranchFromSession` 的 git context：
  [05-控制面深挖/179-session_context.sources、session_context.outcomes、parseGitRemote、parseGitHubRepository 与 getBranchFromSession：为什么 repo declaration 与 branch projection 不是同一种 git context.md](./05-控制面深挖/179-session_context.sources、session_context.outcomes、parseGitRemote、parseGitHubRepository%20与%20getBranchFromSession：为什么%20repo%20declaration%20与%20branch%20projection%20不是同一种%20git%20context.md)
- 想分清 `validateSessionRepository`、`getBranchFromSession`、`checkOutTeleportedSessionBranch` 与 `teleportToRemote` 的 teleport contract：
  [05-控制面深挖/180-validateSessionRepository、getBranchFromSession、checkOutTeleportedSessionBranch 与 teleportToRemote：为什么 repo admission 与 branch replay 不是同一种 teleport contract.md](./05-控制面深挖/180-validateSessionRepository、getBranchFromSession、checkOutTeleportedSessionBranch%20与%20teleportToRemote：为什么%20repo%20admission%20与%20branch%20replay%20不是同一种%20teleport%20contract.md)
- 想分清 `createBridgeSession.events`、`initialMessages`、`previouslyFlushedUUIDs` 与 `writeBatch` 的 history hydrate 合同：
  [05-控制面深挖/181-createBridgeSession.events、initialMessages、previouslyFlushedUUIDs 与 writeBatch：为什么 session-create events 不是 remote-control 历史回放机制.md](./05-控制面深挖/181-createBridgeSession.events、initialMessages、previouslyFlushedUUIDs%20与%20writeBatch：为什么%20session-create%20events%20不是%20remote-control%20历史回放机制.md)
- 想分清 `session_context.model`、`metadata.model`、`lastModelUsage`、`modelUsage` 与 `restoreAgentFromSession` 的 model ledger：
  [05-控制面深挖/182-session_context.model、metadata.model、lastModelUsage、modelUsage 与 restoreAgentFromSession：为什么 create-time model stamp、live override shadow、durable usage ledger 与 resumed-agent fallback 不是同一种 model ledger.md](./05-控制面深挖/182-session_context.model、metadata.model、lastModelUsage、modelUsage%20与%20restoreAgentFromSession：为什么%20create-time%20model%20stamp、live%20override%20shadow、durable%20usage%20ledger%20与%20resumed-agent%20fallback%20不是同一种%20model%20ledger.md)
- 想分清 `initialMessageUUIDs`、`previouslyFlushedUUIDs`、`createBridgeSession.events` 与 `writeBatch` 的初始消息账本：
  [05-控制面深挖/183-initialMessageUUIDs、previouslyFlushedUUIDs、createBridgeSession.events 与 writeBatch：为什么注释里的 session creation events 不等于 bridge 的真实历史账.md](./05-控制面深挖/183-initialMessageUUIDs、previouslyFlushedUUIDs、createBridgeSession.events%20与%20writeBatch：为什么注释里的%20session%20creation%20events%20不等于%20bridge%20的真实历史账.md)
- 想分清 `getUserSpecifiedModelSetting`、`settings.model`、`getMainLoopModelOverride`、`currentAgentDefinition` 与 `restoreAgentFromSession` 的 model authority：
  [05-控制面深挖/184-getUserSpecifiedModelSetting、settings.model、getMainLoopModelOverride、currentAgentDefinition 与 restoreAgentFromSession：为什么 persisted model preference、live override 与 resumed-agent fallback 不是同一种 model authority.md](./05-控制面深挖/184-getUserSpecifiedModelSetting、settings.model、getMainLoopModelOverride、currentAgentDefinition%20与%20restoreAgentFromSession：为什么%20persisted%20model%20preference、live%20override%20与%20resumed-agent%20fallback%20不是同一种%20model%20authority.md)
- 想分清 `getUserSpecifiedModelSetting`、`ANTHROPIC_MODEL`、`settings.model`、`mainThreadAgentDefinition.model` 与 `setMainLoopModelOverride` 的 model source：
  [05-控制面深挖/185-getUserSpecifiedModelSetting、ANTHROPIC_MODEL、settings.model、mainThreadAgentDefinition.model 与 setMainLoopModelOverride：为什么ambient env preference、saved setting、agent bootstrap 与 live launch override 不是同一种 model source.md](./05-控制面深挖/185-getUserSpecifiedModelSetting、ANTHROPIC_MODEL、settings.model、mainThreadAgentDefinition.model%20与%20setMainLoopModelOverride：为什么ambient%20env%20preference、saved%20setting、agent%20bootstrap%20与%20live%20launch%20override%20不是同一种%20model%20source.md)
- 想分清 `initialHistoryCap`、`isEligibleBridgeMessage`、`toSDKMessages` 与 `local_command` 的 history projection：
  [05-控制面深挖/186-initialHistoryCap、isEligibleBridgeMessage、toSDKMessages 与 local_command：为什么 bridge 的 eligible history replay 不是 model prompt authority.md](./05-控制面深挖/186-initialHistoryCap、isEligibleBridgeMessage、toSDKMessages%20与%20local_command：为什么%20bridge%20的%20eligible%20history%20replay%20不是%20model%20prompt%20authority.md)
- 想分清 `getUserSpecifiedModelSetting`、`isModelAllowed`、`ANTHROPIC_MODEL`、`settings.model` 与 `getMainLoopModel` 的 allowlist veto：
  [05-控制面深挖/187-getUserSpecifiedModelSetting、isModelAllowed、ANTHROPIC_MODEL、settings.model 与 getMainLoopModel：为什么 source selection 之后的 allowlist veto 不会回退到更低优先级来源.md](./05-控制面深挖/187-getUserSpecifiedModelSetting、isModelAllowed、ANTHROPIC_MODEL、settings.model%20与%20getMainLoopModel：为什么%20source%20selection%20之后的%20allowlist%20veto%20不会回退到更低优先级来源.md)
- 想分清 `model.tsx`、`validateModel`、`getModelOptions` 与 `getUserSpecifiedModelSetting` 的 allowlist contract：
  [05-控制面深挖/188-model.tsx、validateModel、getModelOptions 与 getUserSpecifiedModelSetting：为什么显式拒绝、选项隐藏与 silent veto 不是同一种 allowlist contract.md](./05-控制面深挖/188-model.tsx、validateModel、getModelOptions%20与%20getUserSpecifiedModelSetting：为什么显式拒绝、选项隐藏与%20silent%20veto%20不是同一种%20allowlist%20contract.md)
- 想分清 `reusedPriorSession`、`previouslyFlushedUUIDs`、`createCodeSession` 与 `flushHistory` 的 continuity ledger：
  [05-控制面深挖/189-reusedPriorSession、previouslyFlushedUUIDs、createCodeSession 与 flushHistory：为什么 v1 continuity ledger 与 v2 fresh-session replay 不是同一种 history contract.md](./05-控制面深挖/189-reusedPriorSession、previouslyFlushedUUIDs、createCodeSession%20与%20flushHistory：为什么%20v1%20continuity%20ledger%20与%20v2%20fresh-session%20replay%20不是同一种%20history%20contract.md)
- 想分清 `writeMessages`、`writeSdkMessages`、`initialMessageUUIDs`、`recentPostedUUIDs` 与 `flushGate` 的 bridge write contract：
  [05-控制面深挖/190-writeMessages、writeSdkMessages、initialMessageUUIDs、recentPostedUUIDs 与 flushGate：为什么 REPL path 与 daemon path 不是同一种 bridge write contract.md](./05-控制面深挖/190-writeMessages、writeSdkMessages、initialMessageUUIDs、recentPostedUUIDs%20与%20flushGate：为什么%20REPL%20path%20与%20daemon%20path%20不是同一种%20bridge%20write%20contract.md)
- 想分清 `handleIngressMessage`、`recentPostedUUIDs`、`recentInboundUUIDs` 与 `onInboundMessage` 的 ingress consumer contract：
  [05-控制面深挖/191-handleIngressMessage、recentPostedUUIDs、recentInboundUUIDs 与 onInboundMessage：为什么 outbound echo drop、inbound replay guard 与 non-user ignore 不是同一种 ingress consumer contract.md](./05-控制面深挖/191-handleIngressMessage、recentPostedUUIDs、recentInboundUUIDs%20与%20onInboundMessage：为什么%20outbound%20echo%20drop、inbound%20replay%20guard%20与%20non-user%20ignore%20不是同一种%20ingress%20consumer%20contract.md)
- 想分清 `lastTransportSequenceNum`、`recentInboundUUIDs`、`tryReconnectInPlace`、`createSession` 与 `rebuildTransport` 的 inbound replay contract：
  [05-控制面深挖/192-lastTransportSequenceNum、recentInboundUUIDs、tryReconnectInPlace、createSession 与 rebuildTransport：为什么 same-session continuity 与 fresh-session reset 不是同一种 inbound replay contract.md](./05-控制面深挖/192-lastTransportSequenceNum、recentInboundUUIDs、tryReconnectInPlace、createSession%20与%20rebuildTransport：为什么%20same-session%20continuity%20与%20fresh-session%20reset%20不是同一种%20inbound%20replay%20contract.md)
- 想分清 `handleIngressMessage`、`isSDKControlResponse`、`isSDKControlRequest`、`onPermissionResponse` 与 `onControlRequest` 的 control side-channel：
  [05-控制面深挖/193-handleIngressMessage、isSDKControlResponse、isSDKControlRequest、onPermissionResponse 与 onControlRequest：为什么 bridge ingress 的 control side-channel 不是对称的通用 control 总线.md](./05-控制面深挖/193-handleIngressMessage、isSDKControlResponse、isSDKControlRequest、onPermissionResponse%20与%20onControlRequest：为什么%20bridge%20ingress%20的%20control%20side-channel%20不是对称的通用%20control%20总线.md)
- 想分清 `handleIngressMessage`、`control_response-control_request`、`extractInboundMessageFields` 与 `enqueue(prompt)` 的 transcript adapter 边界：
  [05-控制面深挖/194-handleIngressMessage、control_response-control_request、extractInboundMessageFields 与 enqueue(prompt)：为什么 bridge ingress 只有 control 旁路和 user-only transcript adapter，non-user SDKMessage 没有第二消费面.md](./05-控制面深挖/194-handleIngressMessage、control_response-control_request、extractInboundMessageFields%20与%20enqueue%28prompt%29：为什么%20bridge%20ingress%20只有%20control%20旁路和%20user-only%20transcript%20adapter，non-user%20SDKMessage%20没有第二消费面.md)
- 想分清 `extractInboundMessageFields`、`normalizeImageBlocks`、`resolveInboundAttachments`、`prependPathRefs` 与 `resolveAndPrepend` 的 inbound normalization：
  [05-控制面深挖/195-extractInboundMessageFields、normalizeImageBlocks、resolveInboundAttachments、prependPathRefs 与 resolveAndPrepend：为什么 image block repair 与 attachment path-ref prepend 不是同一种 inbound normalization contract.md](./05-控制面深挖/195-extractInboundMessageFields、normalizeImageBlocks、resolveInboundAttachments、prependPathRefs%20与%20resolveAndPrepend：为什么%20image%20block%20repair%20与%20attachment%20path-ref%20prepend%20不是同一种%20inbound%20normalization%20contract.md)
- 想分清 `pendingPermissionHandlers`、`BridgePermissionCallbacks`、`request_id`、`handlePermissionResponse` 与 `isBridgePermissionResponse` 的 permission verdict ledger：
  [05-控制面深挖/196-pendingPermissionHandlers、BridgePermissionCallbacks、request_id、handlePermissionResponse 与 isBridgePermissionResponse：为什么 bridge permission race 的 verdict ledger 不是 generic control callback ownership.md](./05-控制面深挖/196-pendingPermissionHandlers、BridgePermissionCallbacks、request_id、handlePermissionResponse%20与%20isBridgePermissionResponse：为什么%20bridge%20permission%20race%20的%20verdict%20ledger%20不是%20generic%20control%20callback%20ownership.md)
- 想分清 `handleIngressMessage`、`recentInboundUUIDs`、`onPermissionResponse`、`extractInboundMessageFields`、`resolveAndPrepend` 与 `pendingPermissionHandlers` 的 ingress reading chain：
  [05-控制面深挖/197-handleIngressMessage、recentInboundUUIDs、onPermissionResponse、extractInboundMessageFields、resolveAndPrepend 与 pendingPermissionHandlers：为什么 bridge ingress 的 191-196 不是并列碎页，而是一条六层阅读链.md](./05-控制面深挖/197-handleIngressMessage、recentInboundUUIDs、onPermissionResponse、extractInboundMessageFields、resolveAndPrepend%20与%20pendingPermissionHandlers：为什么%20bridge%20ingress%20的%20191-196%20不是并列碎页，而是一条六层阅读链.md)
- 想分清 `cancelRequest`、`onResponse unsubscribe`、`pendingPermissionHandlers.delete` 与 `leader queue recheck` 的收口合同：
  [05-控制面深挖/198-cancelRequest、onResponse unsubscribe、pendingPermissionHandlers.delete 与 leader queue recheck：为什么 bridge permission race 的 prompt 撤场、订阅退役、响应消费与策略重判不是同一种收口合同.md](./05-控制面深挖/198-cancelRequest、onResponse%20unsubscribe、pendingPermissionHandlers.delete%20与%20leader%20queue%20recheck：为什么%20bridge%20permission%20race%20的%20prompt%20撤场、订阅退役、响应消费与策略重判不是同一种收口合同.md)
- 想分清 `onSetPermissionMode`、`getLeaderToolUseConfirmQueue`、`recheckPermission`、`useRemoteSession` 与 `useInboxPoller` 的 permission re-evaluation surface：
  [05-控制面深挖/199-onSetPermissionMode、getLeaderToolUseConfirmQueue、recheckPermission、useRemoteSession 与 useInboxPoller：为什么 permission context 变更后的本地重判广播不是同一种 permission re-evaluation surface.md](./05-控制面深挖/199-onSetPermissionMode、getLeaderToolUseConfirmQueue、recheckPermission、useRemoteSession%20与%20useInboxPoller：为什么%20permission%20context%20变更后的本地重判广播不是同一种%20permission%20re-evaluation%20surface.md)
- 想把 headless print 的 `92-99` 先压成一条 result-convergence reading chain，而不是逐页拼装多账本与延迟交付：
  [03-参考索引/02-能力边界/194-Headless print result-convergence reading chain 索引.md](./03-参考索引/02-能力边界/194-Headless%20print%20result-convergence%20reading%20chain%20索引.md) ->
  [05-控制面深挖/207-task triad、result return-path、flush ordering、authoritative idle、semantic last result 与 suggestion delivery：为什么 headless print 的 92-99 不是并列细页，而是一条从多账本前提走到延迟交付的收束链.md](./05-控制面深挖/207-task%20triad、result%20return-path、flush%20ordering、authoritative%20idle、semantic%20last%20result%20与%20suggestion%20delivery：为什么%20headless%20print%20的%2092-99%20不是并列细页，而是一条从多账本前提走到延迟交付的收束链.md)
- 想把 `100-104` 先收成 summary tail、observer restore 与终态收口的 branch map：
  [03-参考索引/02-能力边界/195-Headless print summary-tail and observer-restore branch map 索引.md](./03-参考索引/02-能力边界/195-Headless%20print%20summary-tail%20and%20observer-restore%20branch%20map%20索引.md) ->
  [05-控制面深挖/208-task_summary、post_turn_summary、terminal tail、observer restore 与 suggestion settlement：为什么 100-104 不是并列细页，而是先从 summary 分家，再分叉到终态收口与恢复合同.md](./05-控制面深挖/208-task_summary、post_turn_summary、terminal%20tail、observer%20restore%20与%20suggestion%20settlement：为什么%20100-104%20不是并列细页，而是先从%20summary%20分家，再分叉到终态收口与恢复合同.md)
- 想把 `105-110` 先看成 wider-wire visibility 的分叉图，而不是把 raw wire、summary narrowing 与 streamlined rewrite 混成一页：
  [03-参考索引/02-能力边界/196-Headless print wire-visibility and projection branch map 索引.md](./03-参考索引/02-能力边界/196-Headless%20print%20wire-visibility%20and%20projection%20branch%20map%20索引.md) ->
  [05-控制面深挖/209-post_turn_summary、StdoutMessage、SDKMessage、stream-json raw wire 与 streamlined_*：为什么 105、106、108、109、110 不是并列尾页，而是从 wider-wire visibility 分叉出去的四种后继问题.md](./05-控制面深挖/209-post_turn_summary、StdoutMessage、SDKMessage、stream-json%20raw%20wire%20与%20streamlined_%2A：为什么%20105、106、108、109、110%20不是并列尾页，而是从%20wider-wire%20visibility%20分叉出去的四种后继问题.md)
- 想把 `111-115` 先还原成 builder transport、callback surface 与 UI consumer 的四层可见性表：
  [03-参考索引/02-能力边界/197-Headless print builder-callback-UI branch map 索引.md](./03-参考索引/02-能力边界/197-Headless%20print%20builder-callback-UI%20branch%20map%20索引.md) ->
  [05-控制面深挖/210-builder transport、callback surface、streamlined dual-entry 与 UI consumer policy：为什么 111、112、113、114、115 不是并列细页，而是先定四层可见性表，再分叉到 streamlined 与 adapter 两条后继线.md](./05-控制面深挖/210-builder%20transport、callback%20surface、streamlined%20dual-entry%20与%20UI%20consumer%20policy：为什么%20111、112、113、114、115%20不是并列细页，而是先定四层可见性表，再分叉到%20streamlined%20与%20adapter%20两条后继线.md)
- 想把 `116-121` 先还原成 completion signal、system.init dual-axis 与 history attach restore 的三组相邻配对分叉：
  [03-参考索引/02-能力边界/198-Headless print completion-init-attach pair map 索引.md](./03-参考索引/02-能力边界/198-Headless%20print%20completion-init-attach%20pair%20map%20索引.md) ->
  [05-控制面深挖/211-completion signal、system.init dual-axis、history attach restore 与 loading edge：为什么 116、117、118、119、120、121 不是线性后续页，而是三组相邻配对分叉.md](./05-控制面深挖/211-completion%20signal、system.init%20dual-axis、history%20attach%20restore%20与%20loading%20edge：为什么%20116、117、118、119、120、121%20不是线性后续页，而是三组相邻配对分叉.md)
- 想把 `122-127` 先看成 remote recovery 与 transport/compaction 的分叉，而不是单线 recovery 尾链：
  [03-参考索引/02-能力边界/199-Headless print remote recovery branch map 索引.md](./03-参考索引/02-能力边界/199-Headless%20print%20remote%20recovery%20branch%20map%20索引.md) ->
  [05-控制面深挖/212-remote recovery、viewer ownership、transport terminality 与 compaction contract：为什么 122、123、124、125、126、127 不是一条 recovery 后续链.md](./05-控制面深挖/212-remote%20recovery%E3%80%81viewer%20ownership%E3%80%81transport%20terminality%20%E4%B8%8E%20compaction%20contract%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%20122%E3%80%81123%E3%80%81124%E3%80%81125%E3%80%81126%E3%80%81127%20%E4%B8%8D%E6%98%AF%E4%B8%80%E6%9D%A1%20recovery%20%E5%90%8E%E7%BB%AD%E9%93%BE.md)
- 想把 `122-127` 再压成 owner-side recovery 与 transport stop rule 的双主干读法：
  [03-参考索引/02-能力边界/200-Headless print remote recovery double-trunk map 索引.md](./03-参考索引/02-能力边界/200-Headless%20print%20remote%20recovery%20double-trunk%20map%20索引.md) ->
  [05-控制面深挖/213-owner-side recovery、transport stop rule 与 compaction boundary：为什么 122、123、124、125、126、127 不是线性六连，而是双主干加两个 zoom.md](./05-控制面深挖/213-owner-side%20recovery%E3%80%81transport%20stop%20rule%20%E4%B8%8E%20compaction%20boundary%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%20122%E3%80%81123%E3%80%81124%E3%80%81125%E3%80%81126%E3%80%81127%20%E4%B8%8D%E6%98%AF%E7%BA%BF%E6%80%A7%E5%85%AD%E8%BF%9E%EF%BC%8C%E8%80%8C%E6%98%AF%E5%8F%8C%E4%B8%BB%E5%B9%B2%E5%8A%A0%E4%B8%A4%E4%B8%AA%20zoom.md)
- 想把 `128-132` 先看成 contract / presence / ledger 到 front-state topology 的两段延伸：
  [03-参考索引/02-能力边界/201-128-132 contract、presence、ledger 与 front-state consumer topology 索引.md](./03-参考索引/02-能力边界/201-128-132%20contract%E3%80%81presence%E3%80%81ledger%20%E4%B8%8E%20front-state%20consumer%20topology%20索引.md) ->
  [05-控制面深挖/214-4001 contract、surface presence、status ledger 与 front-state consumer topology：为什么 128、129、130、131、132 不是线性五连，而是两段延伸加一个后继根页.md](./05-控制面深挖/214-4001%20contract%E3%80%81surface%20presence%E3%80%81status%20ledger%20%E4%B8%8E%20front-state%20consumer%20topology%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%20128%E3%80%81129%E3%80%81130%E3%80%81131%E3%80%81132%20%E4%B8%8D%E6%98%AF%E7%BA%BF%E6%80%A7%E4%BA%94%E8%BF%9E%EF%BC%8C%E8%80%8C%E6%98%AF%E4%B8%A4%E6%AE%B5%E5%BB%B6%E4%BC%B8%E5%8A%A0%E4%B8%80%E4%B8%AA%E5%90%8E%E7%BB%A7%E6%A0%B9%E9%A1%B5.md)
- 想把 `133-138` 先看成 schema-store consumer、bridge chain split 与 shared remote shell 的三条两步后继线：
  [03-参考索引/02-能力边界/202-133-138 schema-store consumer、bridge chain 与 remote interaction shell 索引.md](./03-参考索引/02-能力边界/202-133-138%20schema-store%20consumer%E3%80%81bridge%20chain%20%E4%B8%8E%20remote%20interaction%20shell%20索引.md) ->
  [05-控制面深挖/215-schema-store consumer path、bridge chain split 与 remote interaction shell：为什么 133、134、135、136、137、138 不是线性六连，而是从 132 分出去的三条两步后继线.md](./05-控制面深挖/215-schema-store%20consumer%20path%E3%80%81bridge%20chain%20split%20%E4%B8%8E%20remote%20interaction%20shell%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%20133%E3%80%81134%E3%80%81135%E3%80%81136%E3%80%81137%E3%80%81138%20%E4%B8%8D%E6%98%AF%E7%BA%BF%E6%80%A7%E5%85%AD%E8%BF%9E%EF%BC%8C%E8%80%8C%E6%98%AF%E4%BB%8E%20132%20%E5%88%86%E5%87%BA%E5%8E%BB%E7%9A%84%E4%B8%89%E6%9D%A1%E4%B8%A4%E6%AD%A5%E5%90%8E%E7%BB%A7%E7%BA%BF.md)
- 想把 `139-143` 先看成 post-turn_summary 可见性、mirror gray runtime、remote-session ledger 与 global remote bit 的 remote truth split：
  [03-参考索引/02-能力边界/203-139-143 visibility、mirror runtime 与 remote truth split 索引.md](./03-参考索引/02-能力边界/203-139-143%20visibility%E3%80%81mirror%20runtime%20%E4%B8%8E%20remote%20truth%20split%20索引.md) ->
  [05-控制面深挖/216-post_turn_summary visibility、mirror gray runtime、remote-session ledger 与 global remote bit：为什么 139、140、141、142、143 不是线性五连，而是接在三条后继线上的三组问题.md](./05-控制面深挖/216-post_turn_summary%20visibility%E3%80%81mirror%20gray%20runtime%E3%80%81remote-session%20ledger%20%E4%B8%8E%20global%20remote%20bit%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%20139%E3%80%81140%E3%80%81141%E3%80%81142%E3%80%81143%20%E4%B8%8D%E6%98%AF%E7%BA%BF%E6%80%A7%E4%BA%94%E8%BF%9E%EF%BC%8C%E8%80%8C%E6%98%AF%E6%8E%A5%E5%9C%A8%E4%B8%89%E6%9D%A1%E5%90%8E%E7%BB%A7%E7%BA%BF%E4%B8%8A%E7%9A%84%E4%B8%89%E7%BB%84%E9%97%AE%E9%A2%98.md)
- 想把 `144-149` 先看成 session pane、command shell 与 headless remote memory 的三组相邻配对：
  [03-参考索引/02-能力边界/204-144-149 coarse remote bit pair map 索引.md](./03-参考索引/02-能力边界/204-144-149%20coarse%20remote%20bit%20pair%20map%20索引.md) ->
  [05-控制面深挖/217-session pane、command shell 与 headless remote memory：为什么 144、145、146、147、148、149 不是线性六连，而是从 143 分出去的三组相邻配对.md](./05-控制面深挖/217-session%20pane%E3%80%81command%20shell%20%E4%B8%8E%20headless%20remote%20memory%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%20144%E3%80%81145%E3%80%81146%E3%80%81147%E3%80%81148%E3%80%81149%20%E4%B8%8D%E6%98%AF%E7%BA%BF%E6%80%A7%E5%85%AD%E8%BF%9E%EF%BC%8C%E8%80%8C%E6%98%AF%E4%BB%8E%20143%20%E5%88%86%E5%87%BA%E5%8E%BB%E7%9A%84%E4%B8%89%E7%BB%84%E7%9B%B8%E9%82%BB%E9%85%8D%E5%AF%B9.md)
- 想把 `168-179` 先看成 headless source、bridge authority 与 create-context 的子树，而不是线性十二连：
  [03-参考索引/02-能力边界/205-168-179 headless source、bridge authority 与 create-context 子树 索引.md](./03-参考索引/02-能力边界/205-168-179%20headless%20source%E3%80%81bridge%20authority%20%E4%B8%8E%20create-context%20%E5%AD%90%E6%A0%91%20索引.md) ->
  [05-控制面深挖/218-headless source、bridge authority 与 create-context 子树：为什么 168-179 不是线性十二连.md](./05-控制面深挖/218-headless%20source%E3%80%81bridge%20authority%20%E4%B8%8E%20create-context%20%E5%AD%90%E6%A0%91%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%20168-179%20%E4%B8%8D%E6%98%AF%E7%BA%BF%E6%80%A7%E5%8D%81%E4%BA%8C%E8%BF%9E.md)
- 想把 `180-190` 先看成 teleport、model 与 bridge 的分支，而不是线性十一连：
  [03-参考索引/02-能力边界/206-180-190 teleport、model 与 bridge branch map 索引.md](./03-参考索引/02-能力边界/206-180-190%20teleport%E3%80%81model%20%E4%B8%8E%20bridge%20branch%20map%20索引.md) ->
  [05-控制面深挖/219-teleport、model 与 bridge 分支：为什么 180-190 不是线性十一连.md](./05-控制面深挖/219-teleport%E3%80%81model%20%E4%B8%8E%20bridge%20%E5%88%86%E6%94%AF%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%20180-190%20%E4%B8%8D%E6%98%AF%E7%BA%BF%E6%80%A7%E5%8D%81%E4%B8%80%E8%BF%9E.md)

如果你已经确定要读某个专题，请先到对应 README 再选深页，不要把根前门当默认深链库存。

## 根入口的 first reject signal

看到下面迹象时，应先停在根入口，不要直接跳进深页：

1. 你还没先判 `上下文送错 / 扩张或权限判错 / 旧状态污染`，就已经开始点深页标题。
2. 你还没先判工作对象或控制面，就已经在 mode、usage、status、summary 和目录体感之间来回切。
3. 你把根 README 当成专题层或控制面层，而不是二跳路由。

## 阅读原则

- 本手册优先写“用户能做什么”和“先排查哪一格”，不承担 why 改判。
- 所有关键结论尽量挂到源码注册点，而不是只挂到 UI 现象。
- 功能按“稳定公开能力、条件公开或灰度能力、内部能力、影子能力”分层，不混写。
- 入口页优先提醒你不要把 UI transcript、mode 条、token 百分比、长摘要或 slash 面板误当系统真相。
- 入口页只负责问题分型、最小排查顺序与二跳；why、owner 与 truth 一律退回蓝皮书根前门或对应 owner 页。
- 源码锚点默认相对源码根 `../../claude-code-source-code/` 描述。该目录被主仓库 `.gitignore` 排除，不会跟随 worktree 一起复制。

## 完整结构导航

- [00-导读.md](./00-%E5%AF%BC%E8%AF%BB.md)
- [00-阅读路径.md](./00-%E9%98%85%E8%AF%BB%E8%B7%AF%E5%BE%84.md)
- [01-主线使用/README.md](./01-%E4%B8%BB%E7%BA%BF%E4%BD%BF%E7%94%A8/README.md)
- [02-能力地图/README.md](./02-%E8%83%BD%E5%8A%9B%E5%9C%B0%E5%9B%BE/README.md)
- [03-参考索引/README.md](./03-%E5%8F%82%E8%80%83%E7%B4%A2%E5%BC%95/README.md)
- [04-专题深潜/README.md](./04-%E4%B8%93%E9%A2%98%E6%B7%B1%E6%BD%9C/README.md)
- [05-控制面深挖/README.md](./05-%E6%8E%A7%E5%88%B6%E9%9D%A2%E6%B7%B1%E6%8C%96/README.md)

## 这本 Userbook 的边界

这本手册覆盖的是“发布构建中可见或可从源码恢复”的 Claude Code 能力对象范围，不等于这些页面拥有系统首答权，包括：

- CLI 启动链、REPL、会话恢复、上下文装配。
- 斜杠命令系统、技能系统、工具系统。
- 文件、Shell、Web、Notebook、LSP、MCP 等工作能力。
- 权限、沙箱、计划模式、worktree、任务、子代理、团队。
- 模型、努力等级、输出风格、成本、限额、统计。
- IDE、终端、Vim、语音、桌面、移动端、远程控制。
- 发布构建中灰度暴露、feature gate 包裹、内部专用的能力边界。

不覆盖的部分：

- Anthropic 内部 monorepo 中被 Bun `feature()` 死代码消除后完全缺失的实现细节。
- 未发布模块的运行时行为重建，只做“可从现有源码推断到的边界”说明。

更准确地说，`userbook/` 有使用判断翻译权，但没有第一性原理改判权，也没有 host-facing truth 的签发权；一旦它开始替 `philosophy/` 重判为什么成立，或替 `api/` 重签现在是什么，它就会从使用手册长成第二蓝皮书，因此根页只保留问题分型、最小顺序与二跳矩阵。

## 两类专题的分工

### `04-专题深潜`

按真实工作目标组织，负责回答：

1. 我在推进哪个工作对象。
2. 这类工作先按哪组最小顺序排。
3. 什么时候该退出专题，退回 `05` 或主线使用重校边界。

### `05-控制面深挖`

按高价值控制面组织，负责回答：

1. 哪条控制面现在在说话。
2. 哪些相邻入口只是 projection、continuation consumer 或 `Outside` handoff surface，不配改判。
3. 什么时候该把问题退回 `09 / 10 / security / architecture` 的对应 owner，或退回 `risk / playbooks` 的 tail-readback / execution next-hop。

`04` 与 `05` 的更细分工仍以各自 README 为准；根页只负责把你送到正确的一层，不提前库存另一份专题表。
