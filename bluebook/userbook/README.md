# Claude Code Userbook

基于 `@anthropic-ai/claude-code` `v2.1.88` 反编译源码整理的用户手册。它不是第二本蓝皮书，而是用户侧入口：先判工作对象有没有送错、扩张或权限判断卡在哪一段、旧状态是否还在污染当前，再决定下一跳读哪个 README。

## 发言权卡

- `能合法说`
  - 把 root / `09` 已承认的对象链、控制面与可见边界翻成用户侧问题分型、最小顺序与二跳动作。
- `不能改判`
  - 不替 `philosophy/` 重判为什么成立，不替 `api/` 重签 host-facing truth，不替 `playbooks/` 直接发现场 verdict。
- `canonical owner`
  - 主语与最小顺序统一回 [../README.md](../README.md) 与 [../09-三张控制面总图：世界进入模型、扩张定价与防过去写坏现在.md](../09-%E4%B8%89%E5%BC%A0%E6%8E%A7%E5%88%B6%E9%9D%A2%E6%80%BB%E5%9B%BE%EF%BC%9A%E4%B8%96%E7%95%8C%E8%BF%9B%E5%85%A5%E6%A8%A1%E5%9E%8B%E3%80%81%E6%89%A9%E5%BC%A0%E5%AE%9A%E4%BB%B7%E4%B8%8E%E9%98%B2%E8%BF%87%E5%8E%BB%E5%86%99%E5%9D%8F%E7%8E%B0%E5%9C%A8.md)；host-facing truth 回 `api/`；执行 verdict 回 `playbooks/`。
- `申诉路径`
  - 若你怀疑 userbook 已越位，先回 `../README -> 09` 重新定题；再按“不知道为什么成立 / 不知道现在是什么 / 不知道该判什么”分别申诉到 `philosophy / api / playbooks`。

如果只先记住三条使用判断，也只先记这三条：

1. 好 Prompt 不是更像专家，而是先解出唯一工作对象，再确认 `compile inputs` 和 `verify witnesses` 仍沿同一条 `message lineage -> continue_qualification_verdict` 继续成立。
2. 安全不是弹窗多少，而是 `pricing-right -> truth-surface attestation -> typed ask / sandbox / writeback seam` 是否先成立；任何治理界面、状态读数或继续入口都只配读取 verdict，不配改判控制面。
3. 真正省 token 不是把话压短，而是 stable bytes 已被外置且可 reload，只把当前 working set 留在场内；`Narrow / Later / Outside` 只是这条 contract 的用户侧读法。

如果你只缺治理收费链的一屏速记，而不是具体控制面下潜，先回 [../10-治理收费链入口卡：四类被收费资源、reject trio 与弱读回面](../10-%E6%B2%BB%E7%90%86%E6%94%B6%E8%B4%B9%E9%93%BE%E5%85%A5%E5%8F%A3%E5%8D%A1%EF%BC%9A%E5%9B%9B%E7%B1%BB%E8%A2%AB%E6%94%B6%E8%B4%B9%E8%B5%84%E6%BA%90%E3%80%81reject%20trio%20%E4%B8%8E%E5%BC%B1%E8%AF%BB%E5%9B%9E%E9%9D%A2.md)；userbook 根入口只保留问题分型、用户侧最小顺序与二跳。

这里还应再多记一句：

- `userbook/` 不在根入口第二次展开完整治理顺序；治理速记统一回 `../10 -> ../09`，控制面翻译统一回 `05-控制面深挖/README`，任何治理界面、状态读数、压缩入口或导出入口都只配读取 verdict，不配改判控制面或恢复资格。
- 弱读回面只做 `projection / readback`：`status / usage / summary / transcript / continue` 只配触发怀疑，不改判治理真相、继续资格或恢复资格。

这里还要再多记一句：

- `userbook/` 不宣布新的系统真相，它只把已经承认的对象链、控制面和可见边界翻译成用户侧可操作判断。
- `userbook/` 默认只把已承认的对象链、控制面与可见边界翻成用户侧判断与二跳，不替 `README / 09 / api` 补签 runtime-core 缺口；先忘了这层 `public-evidence ceiling`，就会把 UI 面和状态词误当系统真相。
- Prompt 也不是单段 `systemPrompt`，而是 multi-surface world-entry object；`CLAUDE.md / hooks / settings` 能影响行为，但不能替 runtime witness 签 continue。
- `continuity` 在 `userbook/` 里也不是第四条使用主题；它只是同一工作对象在 Prompt `Continuation`、治理 `continuation pricing` 与当前真相收口上的共同时间轴。
- 所以 user-facing 第一问也不该是“该点哪个入口”，而应先判 `上下文送错 / 扩张或权限判错 / 旧状态污染`；先定题，不先找页。

## 先做三类问题分型

根前门最值钱的不是深页清单，而是先把问题分到对的层：

1. `上下文送错`
   - 先看是不是已经换了工作对象，或附件/文件/working set/handoff 已不再服务同一件事。
2. `扩张或权限判错`
   - 先看这次扩张有没有先被准入、当前真相有没有先说清，再决定该继续、收口、降级还是升级给人。
  - 先判 `pricing-right -> truth-surface`，不先看任何治理界面、状态读数或压缩入口；前者只是治理投影，后者只是 projection / continuation consumer。
  - 若扩张已经获准，还要继续判 `decision window -> continuation pricing -> durable-transient cleanup`；不要把任何状态读数、继续入口或收口结果词误读成 verdict signer。
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
3. 什么时候该把问题退回 `09 / api / architecture / playbooks`。
