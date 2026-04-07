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

1. 好 Prompt 不是更像专家，而是先确认你还在同一件事上，附件、文件与 working set 仍服务同一现场。
2. 扩张或权限判断不要先看弹窗、`status`、`usage` 或继续入口；先看这次动作、可见性或继续请求有没有被当前控制面准入。
3. 若问题已经是“为什么这里会省 token / 为什么要 `Later` / `Outside`”，统一回 `security/README`；`userbook/` 根入口只保留用户动作与二跳。

如果你只缺治理收费链的一屏速记，而不是具体控制面下潜，先回 [../10-治理收费链入口卡：四类被收费资源、reject trio 与弱读回面](../10-%E6%B2%BB%E7%90%86%E6%94%B6%E8%B4%B9%E9%93%BE%E5%85%A5%E5%8F%A3%E5%8D%A1%EF%BC%9A%E5%9B%9B%E7%B1%BB%E8%A2%AB%E6%94%B6%E8%B4%B9%E8%B5%84%E6%BA%90%E3%80%81reject%20trio%20%E4%B8%8E%E5%BC%B1%E8%AF%BB%E5%9B%9E%E9%9D%A2.md)；userbook 根入口只保留问题分型、用户侧最小顺序与二跳。

这里还应先钉死六条 user-facing discipline：

- `userbook/` 不宣布新的系统真相，它只把已经承认的对象链、控制面和可见边界翻译成用户侧可操作判断。
- `userbook/` 默认只把已承认的对象链、控制面与可见边界翻成用户侧判断与二跳，不替 `README / 09 / api` 补签 runtime-core 缺口。
- `userbook/` 不在根入口第二次展开完整治理顺序；治理速记统一回 `../10 -> ../09`，控制面翻译统一回 `05-控制面深挖/README`。
- 别拿界面投影替系统真相说话；弱读回面总声明统一回 `10`。
- `CLAUDE.md / hooks / settings` 能影响行为，但不能单独证明你仍在同一工作对象上。
- `continuity` 在 `userbook/` 里也不是第四条使用主题；它只是“同一工作对象能否继续”的时间轴读法。所以 user-facing 第一问不该是“该点哪个入口”，而应先判 `上下文送错 / 扩张或权限判错 / 旧状态污染`。

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
  - 先别拿任何治理界面、状态读数或压缩入口直接下结论；治理速记回 `10`，控制面顺序回 `05-控制面深挖/README`。
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
- 把上下文送准：
  [01-主线使用/02-提问、补上下文与让模型继续工作.md](./01-%E4%B8%BB%E7%BA%BF%E4%BD%BF%E7%94%A8/02-%E6%8F%90%E9%97%AE%E3%80%81%E8%A1%A5%E4%B8%8A%E4%B8%8B%E6%96%87%E4%B8%8E%E8%AE%A9%E6%A8%A1%E5%9E%8B%E7%BB%A7%E7%BB%AD%E5%B7%A5%E4%BD%9C.md) ->
  [04-专题深潜/08-上下文接入、附件与提示编译专题.md](./04-%E4%B8%93%E9%A2%98%E6%B7%B1%E6%BD%9C/08-%E4%B8%8A%E4%B8%8B%E6%96%87%E6%8E%A5%E5%85%A5%E3%80%81%E9%99%84%E4%BB%B6%E4%B8%8E%E6%8F%90%E7%A4%BA%E7%BC%96%E8%AF%91%E4%B8%93%E9%A2%98.md)
- 把结果交付给团队或外部流程：
  [04-专题深潜/09-评审、提交、导出与反馈专题.md](./04-%E4%B8%93%E9%A2%98%E6%B7%B1%E6%BD%9C/09-%E8%AF%84%E5%AE%A1%E3%80%81%E6%8F%90%E4%BA%A4%E3%80%81%E5%AF%BC%E5%87%BA%E4%B8%8E%E5%8F%8D%E9%A6%88%E4%B8%93%E9%A2%98.md)
- 运营长任务的状态、预算和模型节奏：
  [04-专题深潜/10-状态、额度、模型与节奏运营专题.md](./04-%E4%B8%93%E9%A2%98%E6%B7%B1%E6%BD%9C/10-%E7%8A%B6%E6%80%81%E3%80%81%E9%A2%9D%E5%BA%A6%E3%80%81%E6%A8%A1%E5%9E%8B%E4%B8%8E%E8%8A%82%E5%A5%8F%E8%BF%90%E8%90%A5%E4%B8%93%E9%A2%98.md)
- 提升终端交互效率：
  [04-专题深潜/11-终端交互、状态栏与输入效率专题.md](./04-%E4%B8%93%E9%A2%98%E6%B7%B1%E6%BD%9C/11-%E7%BB%88%E7%AB%AF%E4%BA%A4%E4%BA%92%E3%80%81%E7%8A%B6%E6%80%81%E6%A0%8F%E4%B8%8E%E8%BE%93%E5%85%A5%E6%95%88%E7%8E%87%E4%B8%93%E9%A2%98.md)
- 找回过去的会话与提问：
  [04-专题深潜/12-会话发现、历史检索与恢复选择专题.md](./04-%E4%B8%93%E9%A2%98%E6%B7%B1%E6%BD%9C/12-%E4%BC%9A%E8%AF%9D%E5%8F%91%E7%8E%B0%E3%80%81%E5%8E%86%E5%8F%B2%E6%A3%80%E7%B4%A2%E4%B8%8E%E6%81%A2%E5%A4%8D%E9%80%89%E6%8B%A9%E4%B8%93%E9%A2%98.md)
- 把 Claude Code 接进脚本、后台任务或协议流：
  [04-专题深潜/13-非交互、后台会话与自动化专题.md](./04-%E4%B8%93%E9%A2%98%E6%B7%B1%E6%BD%9C/13-%E9%9D%9E%E4%BA%A4%E4%BA%92%E3%80%81%E5%90%8E%E5%8F%B0%E4%BC%9A%E8%AF%9D%E4%B8%8E%E8%87%AA%E5%8A%A8%E5%8C%96%E4%B8%93%E9%A2%98.md)
- 想建立运行时总图，而不是先学操作：
  [02-能力地图/README.md](./02-%E8%83%BD%E5%8A%9B%E5%9C%B0%E5%9B%BE/README.md)
- 只想按名字、入口和合同速查：
  [03-参考索引/README.md](./03-%E5%8F%82%E8%80%83%E7%B4%A2%E5%BC%95/README.md)
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
