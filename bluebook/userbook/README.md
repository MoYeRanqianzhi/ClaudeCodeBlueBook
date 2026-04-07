# Claude Code Userbook

当前官方 npm public artifact 现场核验为 `@anthropic-ai/claude-code@2.1.92`；本手册在 `public-evidence only` 约束下，结合已归档源码锚点与蓝皮书 owner 页整理用户侧理解路径。它不是第二本蓝皮书，而是用户侧入口：先判工作对象有没有送错、扩张或权限判断卡在哪一段、旧状态是否还在污染当前，再决定下一跳读哪个 README。

这棵子树默认继承 [../README.md](../README.md)、[../09-三张控制面总图：世界进入模型、扩张定价与防过去写坏现在.md](../09-%E4%B8%89%E5%BC%A0%E6%8E%A7%E5%88%B6%E9%9D%A2%E6%80%BB%E5%9B%BE%EF%BC%9A%E4%B8%96%E7%95%8C%E8%BF%9B%E5%85%A5%E6%A8%A1%E5%9E%8B%E3%80%81%E6%89%A9%E5%BC%A0%E5%AE%9A%E4%BB%B7%E4%B8%8E%E9%98%B2%E8%BF%87%E5%8E%BB%E5%86%99%E5%9D%8F%E7%8E%B0%E5%9C%A8.md) 与 `docs/development/00-研究方法.md` 已承认的 owner law；`userbook/` 只翻译用户动作、问题分型与二跳，不再在各层重复目录法、发言权或申诉链。

如果只先记住三条使用判断，也只先记这三条：

1. 好 Prompt 不是更像专家，而是先确认你还在同一件事上，附件、文件与 working set 仍服务同一现场。
2. 扩张或权限判断不要先看弹窗、`status`、`usage` 或继续入口；先看这次动作、可见性或继续请求有没有被当前控制面准入。
3. 若问题已经是“为什么这里会省 token / 为什么要 `Later` / `Outside`”，先回 `10 -> philosophy/85 -> philosophy/61` 固定 why；要看 signer / cleanup / mechanism 时进 `security/README`，要看用户侧恢复与 reopen 时进 `risk/README`，要看现场执行时进 `playbooks/README`。

如果你只缺治理收费链的一屏速记，而不是具体控制面下潜，先回 [../10-治理收费链入口卡：四类被收费资源、reject trio 与弱读回面](../10-%E6%B2%BB%E7%90%86%E6%94%B6%E8%B4%B9%E9%93%BE%E5%85%A5%E5%8F%A3%E5%8D%A1%EF%BC%9A%E5%9B%9B%E7%B1%BB%E8%A2%AB%E6%94%B6%E8%B4%B9%E8%B5%84%E6%BA%90%E3%80%81reject%20trio%20%E4%B8%8E%E5%BC%B1%E8%AF%BB%E5%9B%9E%E9%9D%A2.md)；userbook 根入口只保留问题分型、用户侧最小顺序与二跳。

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

- 想先知道今天该怎么开工：
  [00-导读.md](./00-%E5%AF%BC%E8%AF%BB.md) ->
  [01-主线使用/README.md](./01-%E4%B8%BB%E7%BA%BF%E4%BD%BF%E7%94%A8/README.md)
- `上下文送错`：
  [01-主线使用/README.md](./01-%E4%B8%BB%E7%BA%BF%E4%BD%BF%E7%94%A8/README.md) ->
  [04-专题深潜/README.md](./04-%E4%B8%93%E9%A2%98%E6%B7%B1%E6%BD%9C/README.md)
- `扩张或权限判错`：
  [01-主线使用/README.md](./01-%E4%B8%BB%E7%BA%BF%E4%BD%BF%E7%94%A8/README.md) ->
  [05-控制面深挖/README.md](./05-%E6%8E%A7%E5%88%B6%E9%9D%A2%E6%B7%B1%E6%8C%96/README.md)
- `旧状态污染`：
  [01-主线使用/README.md](./01-%E4%B8%BB%E7%BA%BF%E4%BD%BF%E7%94%A8/README.md) ->
  [05-控制面深挖/README.md](./05-%E6%8E%A7%E5%88%B6%E9%9D%A2%E6%B7%B1%E6%8C%96/README.md)
- 想建立运行时总图，而不是先学操作：
  [02-能力地图/README.md](./02-%E8%83%BD%E5%8A%9B%E5%9C%B0%E5%9B%BE/README.md)
- 只想按名字、入口和合同速查：
  [03-参考索引/README.md](./03-%E5%8F%82%E8%80%83%E7%B4%A2%E5%BC%95/README.md)

如果你已经确定要读某个专题，请先到对应 README 再选深页，不要把根前门当默认深链库存。

## 根入口的 first reject signal

看到下面迹象时，应先停在根入口，不要直接跳进深页：

1. 你还没先判 `上下文送错 / 扩张或权限判错 / 旧状态污染`，就已经开始点深页标题。
2. 你还没先判工作对象或控制面，就已经在 mode、usage、status、summary 和目录体感之间来回切。
3. 你把根 README 当成专题层或控制面层，而不是二跳路由。

## 阅读原则

- 本手册优先写“用户能做什么”和“为什么这样设计”。
- 所有关键结论尽量挂到源码注册点，而不是只挂到 UI 现象。
- 功能按“稳定公开能力、灰度能力、内部能力”分层，不混写。
- 入口页优先提醒你不要把 UI transcript、mode 条、token 百分比、长摘要或 slash 面板误当系统真相。
- 入口页不只负责告诉你“去哪读”，也负责先给你最小排查顺序；如果一个入口只能给目录和概念，却给不出“先看哪一格”，它就还没成熟。
- 源码锚点默认相对源码根 `../../claude-code-source-code/` 描述。该目录被主仓库 `.gitignore` 排除，不会跟随 worktree 一起复制。

## 结构导航

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

更准确地说，`userbook/` 有使用判断翻译权，但没有第一性原理改判权，也没有 host-facing truth 的签发权；一旦它开始替 `philosophy/` 重判为什么成立，或替 `api/` 重签现在是什么，它就会从使用手册长成第二蓝皮书。

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
3. 什么时候该把问题退回 `09 / 10 / security / risk / architecture / playbooks` 的对应 owner。
