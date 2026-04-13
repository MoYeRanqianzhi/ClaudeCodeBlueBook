# Status、Doctor、Usage：宿主状态、环境可信度与预算投影

## 先把它们读成运行时证据面

在 `05` 这一层，这页真正值钱的不是新建一条控制面，而是先把三组 runtime evidence surface 分开：

- 当前宿主状态到底是什么。
- 当前工具环境到底值不值得信任。
- 当前套餐和额度到底还能不能支持这次任务。

这三件事分别投影成 `/status`、`/doctor`、`/usage`，但它们在这一层更该被读成同一组 runtime projection cluster，而不是第四条控制面或新的判断来源。

如果你还想把 `/config`、`/cost`、`/stats`、`/statusline`、`/extra-usage` 这些邻接入口一起按 UI/控制面对象拆开，应继续看 `10-设置面板、诊断屏与运营命令：会内控制面的三层分工.md`。

如果把这一页压成用户侧最小顺序，只该先做四步：

1. 先看 `/status` 暴露的宿主状态投影
   - 它有没有暴露 same-world / host-state drift，而不是自己给出“还是同一个现场”的结论。
2. 再看 `/doctor` 暴露的环境可信度投影
   - 它有没有暴露 host trust / tool-environment drift，而不是自己给出“已经安全可用”的结论。
3. 再看 `/usage` 与 `Context Usage` 暴露的预算投影
   - 它们有没有暴露 `decision window / continuation pricing` 的压力，而不是自己给出“还该继续付费”的结论。
4. 最后才调节模型、effort、节奏和成本观测。

如果这四步反过来，最容易发生的就是：还没确认这些投影在暴露哪条上层 frontdoor 失真，就先去换模型、提 effort 或继续深挖。

## 进入本页前的 first reject signal

看到下面迹象时，应先回到这组 runtime projection 的分工，不要直接去调参：

- 你把 `/status` 当 about 页，或直接把它抬成宿主状态本体。
- 你把 `/doctor` 当“装不上才跑一次”的工具，而不是 host trust 入口。
- 你把 `Context Usage` 或 `/usage` 当 token 条，或直接把它抬成当前 `decision window` 的结论来源。
- 你还没确认状态、环境和预算，就已经在讨论“换更强模型”“调更高 effort”。

## 它们都是运行时投影，不是控制面本体

更稳一点说：

- `/status` 只投影当前宿主状态，不单独下“这还是同一个工作现场”的结论。
- `/doctor` 只汇总可信度证据，不单独下“这套环境已经安全可用”的结论。
- `/usage` 只投影预算窗口，不单独下“这轮还值得继续付费”的结论。
- 更硬一点说，它们都是 weak readback surface：只暴露 drift 与 pressure，不代签 same-world、governance truth 或 continue qualification。
- approval receipt、status green、usage 回单若没有新增 signer 证据、boundary delta 或 cleanup 结果，就只是 `zero-delta ask / weak readback`；它们只补回单，不补新的 `repricing proof`。
- 反过来，只有当这些 surface 真新增 signer 证据、boundary delta 或 cleanup delta 时，它们才配从 runtime projection 升级成治理事实；否则一律停在 receipt-grade。

对用户来说，这页最多只帮助你判断该继续、降级、停止、转入恢复链或升级给人；如果你已经在判恢复、cleanup 或 reopen，就不要继续停在本页。
更稳一点说，`/status / /doctor / /usage` 只做 runtime projection；`Compact / Resume / Memory` 这些连续性动作另在相邻页处理；`Export` 另归 `Outside` handoff surface。若你在这里开始直接判断治理结论或恢复成立，先回 `../../10`、`../../risk/README.md` 或 `../../09-三张控制面总图：世界进入模型、扩张定价与防过去写坏现在.md`。
若把 projection 直接抬成 verdict signer，consumer 就会长成 shadow compiler / shadow pricing surface；这时你看到的就不再是诊断，而是第二套偷偷代签的治理故事。

## `/status` 解决的是宿主状态投影

`/status` 不是 about 页，而是当前 CLI 会话的状态投影。

它直接打开 `Settings` 的 `Status` tab，说明 Claude Code 把版本、会话、cwd、账户、provider、模型、IDE、MCP、设置来源和部分诊断信息，都视作当前工作现场的一部分。

对用户的实际意义：

- 接手旧会话前，先看 `/status`，确认自己站在什么宿主状态上。
- 遇到工具消失、MCP 断开、模型不对、账号不对时，先看 `/status`，而不是直接怀疑业务逻辑。

误用边界：

- 它不是全部真相，只是状态面板。
- IDE、MCP、sandbox 在这里看到的是摘要投影，不是每一层的全部细节。

## `/doctor` 解决的是环境可信度

`/doctor` 不是“装不上再跑一次”的命令，而是工具环境可信度的系统诊断入口。

它打开独立诊断屏，会把安装方式、路径、settings 错误、MCP 配置、keybinding warning、sandbox 依赖、version lock、agent 解析错误、plugin error 和 context warning 汇总起来。

对用户的实际意义：

- 当 `/status` 只能告诉你“现在不对劲”，但还不知道错在安装、配置还是扩展层时，用 `/doctor` 收敛根因。
- 当 Claude Code 自己表现异常时，先修环境可信度，再继续要求模型推进任务。

误用边界：

- 它不是项目代码调试器。
- 它也不是自动修复器；更多是在给你“当前工具环境哪一层失真了”的证据。

## `/usage` 解决的是运行时预算

`/usage` 不是账单页，而是套餐和额度的运行时投影。

它同样走 `Settings` 的 `Usage` tab，说明 Claude Code 至少把预算投影公开成当前任务是否还能稳定推进的运行时观察面。

对用户的实际意义：

- 长任务开始前先看 `/usage`，比撞上限后才减速更稳。
- 当你在“继续深挖 / 压缩上下文 / 切换节奏”之间做判断时，预算本身就是运行时输入。

更准确地说：

- `/usage` 不是 token 条。
- `Context Usage` 也不是 token 条。
- 它们更接近 `decision window / continuation pricing` 的运行时投影，不等于这两个治理对象本身。
- 是否继续仍要回 `continue qualification -> continuation pricing`，而不是让 `/usage` 自己把预算投影写成继续 verdict。
- repeated allow、modal closeout 或 `Context Usage` 变绿，只要没有收紧边界、推进 cleanup 或改写 deny/allow 结论，就仍只是 `zero-delta ask / weak readback`，不是新的治理事实。
- 是否继续仍只看正式对象有没有补齐 `repricing proof / lease checkpoint / cleanup`；`/status / /doctor / /usage` 最多提醒你该回哪层，不替 `continue qualification` 签字。
- 更稳一点说，预算效率不是 `/usage` 变绿得更快，而是 delta-free approvals 与 zero-delta asks 更少；若只是回单更顺滑，治理成本并没有真的下降。

误用边界：

- 它不该被写成所有 provider 都同样存在的额度台。
- 对普通读者更稳的表述是：这属于 Claude AI 产品面下的正式预算入口。

## 这三者为什么应该一起看

因为它们回答的是同一个更深的问题：

- `/status` 暴露你现在站在哪个宿主状态投影上。
- `/doctor` 暴露这套宿主状态的可信度压力。
- `/usage` 暴露这套宿主状态面对当前任务的预算压力。

最稳的顺序通常是：

1. 先看 `/status`。
2. 状态异常时再看 `/doctor`。
3. 长任务和高成本任务再看 `/usage`。
4. 只有把这三组投影都读成上层 frontdoor 的证据后，再去调模型、effort、`/cost`、`/stats` 和 `/statusline`。

## 用户策略

如果你把 Claude Code 纳入日常工作流，最稳的习惯不是“直接开始提需求”，而是：

- 进入会话先确认状态。
- 有异样先确认环境。
- 任务要拉长时先确认预算。

如果你现在更想按“长任务如何运营节奏”来读，而不是按控制面来读，应继续看：

- [../04-专题深潜/10-状态、额度、模型与节奏运营专题.md](../04-%E4%B8%93%E9%A2%98%E6%B7%B1%E6%BD%9C/10-%E7%8A%B6%E6%80%81%E3%80%81%E9%A2%9D%E5%BA%A6%E3%80%81%E6%A8%A1%E5%9E%8B%E4%B8%8E%E8%8A%82%E5%A5%8F%E8%BF%90%E8%90%A5%E4%B8%93%E9%A2%98.md)

如果你已经不在判断证据面，而是在判断恢复、cleanup 或 reopen，也不要继续停在本页：

- 用户侧恢复与 reopen：回 [../../risk/README.md](../../risk/README.md)
- 机制主语与治理 verdict：回 [../../09-三张控制面总图：世界进入模型、扩张定价与防过去写坏现在.md](../../09-%E4%B8%89%E5%BC%A0%E6%8E%A7%E5%88%B6%E9%9D%A2%E6%80%BB%E5%9B%BE%EF%BC%9A%E4%B8%96%E7%95%8C%E8%BF%9B%E5%85%A5%E6%A8%A1%E5%9E%8B%E3%80%81%E6%89%A9%E5%BC%A0%E5%AE%9A%E4%BB%B7%E4%B8%8E%E9%98%B2%E8%BF%87%E5%8E%BB%E5%86%99%E5%9D%8F%E7%8E%B0%E5%9C%A8.md) 与 [../../api/README.md](../../api/README.md)

## 源码锚点

- `src/commands/status/status.tsx`
- `src/components/Settings/Settings.tsx`
- `src/components/Settings/Status.tsx`
- `src/screens/Doctor.tsx`
- `src/commands/doctor/doctor.tsx`
- `src/commands/usage/usage.tsx`
- `src/components/Settings/Usage.tsx`
- `src/services/api/usage.ts`
