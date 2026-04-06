# Status、Doctor、Usage：运行时自检、额度与诊断

## 第一性问题

Claude Code 要先解决的，不是“模型够不够聪明”，而是：

- 当前宿主状态到底是什么。
- 当前工具环境到底值不值得信任。
- 当前套餐和额度到底还能不能支持这次任务。

这三件事分别投影成 `/status`、`/doctor`、`/usage`，但本质上都属于同一个控制面：运行时自检。

如果你还想把 `/config`、`/cost`、`/stats`、`/statusline`、`/extra-usage` 这些邻接入口一起按 UI/控制面对象拆开，应继续看 `10-设置面板、诊断屏与运营命令：会内控制面的三层分工.md`。

如果把这一页压成用户侧最小顺序，只该先做四步：

1. 先过 `same-world test`
   - 当前 `/status` 看到的还是不是同一个宿主现场。
2. 再过 host trust
   - 当前 `/doctor` 看到的工具环境还值不值得继续信任。
3. 再过 `decision window`
   - 当前 `/usage` 与 `Context Usage` 看到的 working set 是否仍有决策增益。
4. 最后才调节模型、effort、节奏和成本观测。

如果这四步反过来，最容易发生的就是：还没确认状态真相、环境可信度和预算窗口，就先去换模型、提 effort 或继续深挖。

## 进入本页前的 first reject signal

看到下面迹象时，应先回到运行时自检顺序，不要直接去调参：

- 你把 `/status` 当 about 页，而不是宿主状态真相的第一面。
- 你把 `/doctor` 当“装不上才跑一次”的工具，而不是 host trust 入口。
- 你把 `Context Usage` 或 `/usage` 当 token 条，而不是当前 `decision window` 的诚实投影。
- 你还没确认状态、环境和预算，就已经在讨论“换更强模型”“调更高 effort”。

## `/status` 解决的是宿主状态真相

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

它同样走 `Settings` 的 `Usage` tab，说明 Claude Code 把预算当成当前任务是否还能稳定推进的控制面。

对用户的实际意义：

- 长任务开始前先看 `/usage`，比撞上限后才减速更稳。
- 当你在“继续深挖 / 压缩上下文 / 切换节奏”之间做判断时，预算本身就是运行时输入。

更准确地说：

- `/usage` 不是 token 条。
- `Context Usage` 也不是 token 条。
- 它们更接近当前 working set 还值不值得继续付费的 `decision window`。

误用边界：

- 它不该被写成所有 provider 都同样存在的额度台。
- 对普通读者更稳的表述是：这属于 Claude AI 产品面下的正式预算入口。

## 这三者为什么应该一起看

因为它们回答的是同一个更深的问题：

- `/status` 告诉你“我现在在哪个宿主状态里”。
- `/doctor` 告诉你“这套宿主状态是否可信”。
- `/usage` 告诉你“这套宿主状态是否还承受得起当前任务”。

最稳的顺序通常是：

1. 先看 `/status`。
2. 状态异常时再看 `/doctor`。
3. 长任务和高成本任务再看 `/usage`。
4. 只有这三步过关后，再去调模型、effort、`/cost`、`/stats` 和 `/statusline`。

## 用户策略

如果你把 Claude Code 纳入日常工作流，最稳的习惯不是“直接开始提需求”，而是：

- 进入会话先确认状态。
- 有异样先确认环境。
- 任务要拉长时先确认预算。

如果你现在更想按“长任务如何运营节奏”来读，而不是按控制面来读，应继续看：

- [../04-专题深潜/10-状态、额度、模型与节奏运营专题.md](../04-%E4%B8%93%E9%A2%98%E6%B7%B1%E6%BD%9C/10-%E7%8A%B6%E6%80%81%E3%80%81%E9%A2%9D%E5%BA%A6%E3%80%81%E6%A8%A1%E5%9E%8B%E4%B8%8E%E8%8A%82%E5%A5%8F%E8%BF%90%E8%90%A5%E4%B8%93%E9%A2%98.md)

## 源码锚点

- `src/commands/status/status.tsx`
- `src/components/Settings/Settings.tsx`
- `src/components/Settings/Status.tsx`
- `src/screens/Doctor.tsx`
- `src/commands/doctor/doctor.tsx`
- `src/commands/usage/usage.tsx`
- `src/components/Settings/Usage.tsx`
- `src/services/api/usage.ts`
