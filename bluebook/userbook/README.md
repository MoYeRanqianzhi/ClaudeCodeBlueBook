# Claude Code Userbook

这本手册是用户侧前门：先判你现在卡在 `上下文送错 / 扩张或权限判错 / 旧状态污染` 的哪一类，再做一次分流。它不在根页重做蓝皮书 owner atlas，也不在这里代判这次 ask 是否仍属 `zero-delta`、继续资格是否仍成立，或 why、mechanism 与恢复执行该怎么写成固定 deep chain。

若当前 worktree 仍缺 `claude-code-source-code/` 镜像，本手册默认处于 `public-evidence only` 模式：只翻译已归档源码锚点、发布构建可见行为与蓝皮书已承认的 owner 结论。

`userbook/` 只翻译用户动作、问题分型与下一跳。why、owner 与 host-facing truth 仍回蓝皮书根前门或对应 owner README；这里不代签，也不在各层重复目录法、发言权或申诉链。

如果只先记住三条使用判断，也只先记这三条：

1. 好 Prompt 不是更像专家，而是先过 `same-world test`：later consumer 在 `verify / delegate / tool choice / resume / handoff` 时，不必重答谁在定义世界、边界内哪些动作和工具仍合法；`resume / handoff / compaction` 后也不必重判继续资格，更不必把已排除路径重新拉回候选集。
2. 扩张或权限判断不要先看弹窗、`status`、`usage`、继续入口或摘要；这些都只算 `receipt-grade lease-checkpoint projection`。除非它们在同一条 `authority lease` 上真的带来新的 `decision delta`，否则最多也只是 `receipt-grade` 证据。先找这次动作、可见性或继续请求里最早那条还没被定价的 `unpaid expansion`，再看它有没有补齐 `repricing proof / same authority lease / new decision delta / cleanup trigger state`。
3. 若问题已经从“现在该怎么做”变成“为什么这么判 / 为什么会出现 `Later` 或 `Outside`”，先回蓝皮书根前门或对应母线入口；userbook 根页不展开 why syllabus。

如果你只缺治理收费链的一屏速记，而不是用户侧动作分型，先回 [../10-治理收费链入口卡：最早 unpaid expansion、reject trio 与弱读回面](../10-%E6%B2%BB%E7%90%86%E6%94%B6%E8%B4%B9%E9%93%BE%E5%85%A5%E5%8F%A3%E5%8D%A1%EF%BC%9A%E6%9C%80%E6%97%A9%20unpaid%20expansion%E3%80%81reject%20trio%20%E4%B8%8E%E5%BC%B1%E8%AF%BB%E5%9B%9E%E9%9D%A2.md)；userbook 根入口只保留问题分型、用户侧最小顺序与单跳分流。

这里也只先记三条边界：

- Prompt 线只翻 user-facing witness，不替 Prompt owner 页重判 `compiled world verdict`
- 治理线只翻用户可见的 readback、恢复与继续信号；弹窗、`status`、`usage`、继续入口与摘要都只算 `receipt-grade lease-checkpoint projection`，没有新增 `decision delta` 时也只配留在 `receipt-grade`；why、mechanism 与 execution 由目标页继续分流，不在根页写死
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
   - 根页先只判自己碰到的是控制面问题，不在这里代判这次 ask 是否仍属 `zero-delta`。
   - 一旦怀疑存在 `unpaid expansion`、`continuation lease` 漂移或旧 authority 未清空，就不要再拿治理界面、状态读数、压缩入口或继续入口直接下结论；这类问题统一单跳进 [05-控制面深挖/README.md](./05-%E6%8E%A7%E5%88%B6%E9%9D%A2%E6%B7%B1%E6%8C%96/README.md) 或回蓝皮书治理入口。
3. `旧状态污染`
   - 先看是不是旧 shim、旧恢复资产、旧 capability token 或旧 authority width 还在冒充当前世界。

## 按问题单跳，不按深页碰运气

根前门真正负责的是 `问题分型 -> 下一跳`，不负责替 `04 / 05` 的 README 重新充当专题目录，也不要求先经固定中转。

更稳一点说，目录优化若只共享 nouns、不共享“先判哪一类问题”，用户层仍会退回“按页碰运气”；根前门要做的是把这个 first answer 固定住，而不是把后续 syllabus 写死。
更稳一点说，治理界面、状态投影、继续入口、导出入口、弹窗、摘要与收口结果词都只能帮助分型与下一跳，不能代替 `扩张或权限判错` 的控制面判断。

更稳的默认单跳是：

- 还没分清问题，只想知道今天该怎么开工：
  [00-导读.md](./00-%E5%AF%BC%E8%AF%BB.md)
- 已知是 `上下文送错`：
  [04-专题深潜/README.md](./04-%E4%B8%93%E9%A2%98%E6%B7%B1%E6%BD%9C/README.md)
- 已知是 `扩张或权限判错` 或 `旧状态污染`：
  [05-控制面深挖/README.md](./05-%E6%8E%A7%E5%88%B6%E9%9D%A2%E6%B7%B1%E6%8C%96/README.md)

如果你已经确定要读某个专题，请先到对应 README 再选深页，不要把根前门当默认深链库存。

## 根入口的 first reject signal

看到下面迹象时，应先停在根入口，不要直接跳进深页：

1. 你还没先判 `上下文送错 / 扩张或权限判错 / 旧状态污染`，就已经开始点深页标题。
2. 你还没先判工作对象或控制面，就已经在 mode、usage、status、summary 和目录体感之间来回切。
3. 你把根 README 当成专题层或控制面层，而不是单跳路由。

## 阅读原则

- 本手册优先写“用户能做什么”和“先排查哪一格”，不承担 why 改判。
- 所有关键结论优先挂到 `contract / registry / current-truth claim state` 这三类高签字权证据，而不是只挂到 UI 现象、adapter 子集或热点文件体感。
- 功能按“稳定公开能力、灰度能力、内部能力”分层，不混写。
- 入口页优先提醒你不要把 UI transcript、mode 条、token 百分比、长摘要或 slash 面板误当系统真相。
- 入口页只负责问题分型、最小排查顺序与单跳；why、owner 与 truth 一律退回蓝皮书根前门或对应专题/owner README。
- 源码锚点默认相对源码根 `../../claude-code-source-code/` 描述。该目录被主仓库 `.gitignore` 排除，不会跟随 worktree 一起复制。

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

更准确地说，`userbook/` 有使用判断翻译权，但没有第一性原理改判权，也没有 host-facing truth 的签发权；一旦它开始替 why、truth 或恢复执行排固定 syllabus，它就会从使用手册长成第二蓝皮书，因此根页只保留问题分型、最小顺序与单跳矩阵。

`04` 与 `05` 的更细分工留在各自 README；根页只负责把你送到正确的一层，不提前库存专题表。
