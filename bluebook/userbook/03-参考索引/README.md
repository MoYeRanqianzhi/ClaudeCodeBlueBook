# 参考索引

这一层真正值钱的，不是“问题多”，而是它只拥有速查权，不拥有改判权。

## 发言权卡

- `能合法说`
  - 按名字、对象、入口与运行时合同快速定位对应正文。
- `不能改判`
  - 不替 `philosophy/`、`api/`、`architecture/` 或 `playbooks/` 重判主语、真相与 verdict。
- `canonical owner`
  - 速查入口总归 [../README.md](../README.md)；控制面判断回 [../05-控制面深挖/README.md](../05-%E6%8E%A7%E5%88%B6%E9%9D%A2%E6%B7%B1%E6%8C%96/README.md)；工作对象判断回 [../04-专题深潜/README.md](../04-%E4%B8%93%E9%A2%98%E6%B7%B1%E6%BD%9C/README.md)。
- `申诉路径`
  - 若索引页已经开始像 owner 一样签 truth 或给 verdict，先退回 `userbook/README` 重做问题分型，再按对应层级申诉到 `philosophy / api / playbooks / casebooks`。

更稳的读法只该剩三句：

1. 它帮你按名字、对象和入口快速定位。
2. 它帮你知道这些名字背后连接的是哪类运行时合同。
3. 它不替 `philosophy/`、`api/`、`architecture/` 或 `playbooks/` 重判主语、真相与 verdict。

这里也要先压住一个常见误读：`连续性 / 记忆 / 恢复` 在索引层不是第四类问题域；它们只该作为同一工作对象的时间轴入口，被继续路由回主线、专题或控制面。

如果参考索引开始替正文宣布“什么是真的”或“现在该怎么裁决”，later maintainer 就会失去通过正式证据层申诉的入口。

## 最短路由

别把这层当问题库存。更稳的默认用法是：

更稳一点说，索引层也必须继承根前门的 first-answer order；若不能先回到问题分型、工作对象和控制面，再快的索引都会把用户送进 pseudo-authority。

- 想按命令、工具、root/slash、Settings/Doctor/Usage 这类对象速查：
  [01-命令工具/README.md](./01-%E5%91%BD%E4%BB%A4%E5%B7%A5%E5%85%B7/README.md)
- 想判断稳定、条件、内部、影子，以及信任/gate/可见性边界：
  [02-能力边界/README.md](./02-%E8%83%BD%E5%8A%9B%E8%BE%B9%E7%95%8C/README.md)
- 想查 skills、MCP、plugins、hooks 这组扩展入口：
  [03-技能与扩展/README.md](./03-%E6%8A%80%E8%83%BD%E4%B8%8E%E6%89%A9%E5%B1%95/README.md)
- 想用一张总图看全部功能面怎么分层：
  [04-功能面七分法.md](./04-%E5%8A%9F%E8%83%BD%E9%9D%A2%E4%B8%83%E5%88%86%E6%B3%95.md)
- 想从真实任务反查应该先走哪个入口：
  [05-任务到入口速查矩阵.md](./05-%E4%BB%BB%E5%8A%A1%E5%88%B0%E5%85%A5%E5%8F%A3%E9%80%9F%E6%9F%A5%E7%9F%A9%E9%98%B5.md)
- 想看高价值入口背后的运行时合同速查：
  [06-高价值入口运行时合同速查.md](./06-%E9%AB%98%E4%BB%B7%E5%80%BC%E5%85%A5%E5%8F%A3%E8%BF%90%E8%A1%8C%E6%97%B6%E5%90%88%E5%90%8C%E9%80%9F%E6%9F%A5.md)

## 索引层的 first reject signal

看到下面迹象时，应先退出索引层，而不是继续在这里找答案：

1. 你开始期待索引页直接告诉你“哪条 truth 现在成立”。
2. 你开始期待索引页直接给 verdict，而不是把你路由到对应正文。
3. 你把索引里的 projection、可见面或 inventory 当成 signer。
4. 你开始把矩阵、索引或列表里的 continuity consumer 误读成新的独立主题，而不是同一工作对象的时间轴入口。

## 这层到底回答什么

这一层不讲长篇原理，主要回答六类速查问题：

1. 到底有哪些命令、工具和高价值入口。
2. 哪些入口是 root plane，哪些是 session plane。
3. 哪些入口是 Settings tab、独立 screen、调参命令、预算分流或受控 prompt 工作流。
4. 哪些能力是稳定、条件、内部或影子。
5. 哪些扩展对象是 `/skills`、SkillTool、MCP、plugins、hooks、remote skills 的不同投影。
6. 面对真实任务时，应先走哪个入口。
7. `assistant viewer`、`--remote` TUI、`viewerOnly`、`remoteSessionUrl` 与 coarse remote bit 看起来相近时，应该先去哪个入口分辨合同厚度。
8. `REMOTE_SAFE_COMMANDS`、`filterCommandsForRemoteMode`、`handleRemoteInit`、`session` 与 `mobile` 看起来都在 remote 模式附近时，应该先去哪个入口分辨 remote-safe 命令面与 runtime readiness proof。
9. `CLAUDE_CODE_REMOTE`、`getIsRemoteMode()`、`print`、`reload-plugins` 与 `settingsSync` 看起来都指向 remote 环境时，应该先去哪个入口分辨 headless remote 分支与 interactive remote bit。
10. `CLAUDE_CODE_REMOTE_MEMORY_DIR`、`memdir`、`SessionMemory`、`extractMemories` 与 `print` 看起来都在 remote 记忆附近时，应该先去哪个入口分辨 auto-memory 根与 session 账本的双轨体系。
11. `system/init.slash_commands`、`REMOTE_SAFE_COMMANDS`、`PromptInput`、`REPL`、`processUserInput` 与 `print` 看起来都在 slash 附近时，应该先去哪个入口分辨声明面、文本载荷与 runtime 再解释的三段合同。
12. `getSessionId`、`switchSession`、`StatusLine`、`assistant viewer`、`remoteSessionUrl` 与 `useRemoteSession` 看起来都在 remote session 身份附近时，应该先去哪个入口分辨 `remote.session_id` 可见性与当前前端拥有权。
13. `sessionStorage`、`hydrateFromCCRv2InternalEvents`、`sessionRestore`、`listSessionsImpl`、`SessionPreview` 与 `sessionTitle` 看起来都在 session 元数据附近时，应该先去哪个入口分辨 durable metadata、live `system/init` 与 foreground `external_metadata`。
14. `SENTINEL_LOADING`、`SENTINEL_LOADING_FAILED`、`SENTINEL_START`、`useAssistantHistory`、`remoteConnectionStatus` 与 `BriefIdleStatus` 看起来都在历史翻页附近时，应该先去哪个入口分辨 attached viewer 哨兵与 remote presence surface。
15. `discoverAssistantSessions`、`launchAssistantInstallWizard`、`launchAssistantSessionChooser`、`createRemoteSessionConfig` 与 attach banner 看起来都在 assistant 入口附近时，应该先去哪个入口分辨发现、安装、选择与附着不是同一种 connect flow。
16. `showSetupDialog`、`renderAndRun`、`launchResumeChooser`、`launchRepl`、`AppStateProvider` 与 `KeybindingSetup` 看起来都在 interactive 入口附近时，应该先去哪个入口分辨 setup-dialog host 与 attached REPL host。
17. `getSessionFilesLite`、`loadFullLog`、`SessionPreview`、`useAssistantHistory` 与 `fetchLatestEvents` 看起来都在 `/resume` 历史附近时，应该先去哪个入口分辨本地 preview transcript 与 attached viewer remote history。
18. `getSessionFilesLite`、`enrichLogs`、`LogSelector`、`SessionPreview` 与 `loadFullLog` 看起来都在 `/resume` 本地 durable surface 附近时，应该先去哪个入口分辨列表摘要面与 preview transcript。
19. `SessionPreview`、`loadFullLog`、`loadConversationForResume`、`switchSession` 与 `adoptResumedSessionFile` 看起来都在 `/resume` 恢复附近时，应该先去哪个入口分辨 preview transcript 与正式 session restore。

更细的问题库存统一下沉到各子目录 README 和对应索引页，不再在根 README 里重写一长串 one-off 问句。

## 使用边界

- 需要判断“为什么必须如此设计”，退回 `../../philosophy/README.md`
- 需要判断“哪条真相被正式承认”，退回 `../../api/README.md`
- 需要判断“现场现在该判哪一个 verdict”，退回 `../../playbooks/README.md`
- 需要判断“哪种伪证最像成功”，退回 `../../casebooks/README.md`

再补一句：

- 索引层只负责 `触发怀疑 + 路由`，不负责 `签 truth + 出 verdict`。
