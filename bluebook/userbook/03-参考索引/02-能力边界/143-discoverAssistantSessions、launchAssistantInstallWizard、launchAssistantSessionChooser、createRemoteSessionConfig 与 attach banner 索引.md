# `discoverAssistantSessions`、`launchAssistantInstallWizard`、`launchAssistantSessionChooser`、`createRemoteSessionConfig` 与 attach banner 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/154-discoverAssistantSessions、launchAssistantInstallWizard、launchAssistantSessionChooser、createRemoteSessionConfig 与 attach banner：为什么 claude assistant 的发现、安装、选择与附着不是同一种 connect flow.md`
- `05-控制面深挖/58-viewerOnly、hasInitialPrompt、useAssistantHistory 与 updateSessionTitle：为什么 attached assistant REPL 的首问加载、历史翻页与会话标题不是同一种主权.md`
- `05-控制面深挖/123-viewerOnly、history、timeout、Ctrl+C 与 title：为什么 assistant client 不是 session owner.md`
- `05-控制面深挖/151-getSessionId、switchSession、StatusLine、assistant viewer、remoteSessionUrl 与 useRemoteSession：为什么 remote.session_id 可见，不等于当前前端拥有那条 remote session.md`

边界先说清：

- 这页不是 attached viewer 行为总表。
- 这页不是 history / ownership / session identity 页。
- 这页只抓 `claude assistant` 在 attach 之前和 attach 当下的四段入口链。

## 1. 四段入口链

| 段 | 当前更像什么 | 关键对象 |
| --- | --- | --- |
| discovery | 找当前有哪些可 attach 的 assistant session | `discoverAssistantSessions()` |
| install bootstrap | 当前没有 session，转向安装/启动 daemon | `launchAssistantInstallWizard()` |
| chooser | 多候选 session 的人工选择 | `launchAssistantSessionChooser()` |
| attach | 真正进入 viewerOnly remote client 合同 | `createRemoteSessionConfig(sessionId, ..., viewerOnly=true)` |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `claude assistant` 就是“找到 session 然后 attach” | 中间还有 install bootstrap 与 chooser 两段独立流程 |
| zero-session 等于 attach failed | 代码明确转 install / daemon bootstrap |
| chooser 就是 attach 的 UI 皮肤 | chooser 只返回 picked session id |
| install / chooser / attach 都是同一类前端 | install/chooser 是 setup dialog host，attach 才是 REPL host |

## 3. stable / conditional / gray

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | discovery / install / chooser / attach 四段链；各段输入输出与退出行为 |
| 条件公开 | 未传 `sessionId` 时才走 discovery；多 session 才走 chooser |
| 内部/灰度层 | `discoverAssistantSessions()`、chooser UI、install wizard 的内部实现细节在当前源码快照里缺席 |

## 4. 五个检查问题

- 我现在写的是 discovery、install、chooser，还是 attach？
- 我是不是把 zero-session 误写成 attach failure？
- 我是不是把 chooser 误写成 attach UI？
- 我是不是忽略了 setup-dialog host 与 attached REPL host 的宿主差异？
- 我是不是把当前快照里缺失的实现体写成了已知事实？

## 5. 源码锚点

- `claude-code-source-code/src/main.tsx`
- `claude-code-source-code/src/dialogLaunchers.tsx`
- `claude-code-source-code/src/interactiveHelpers.tsx`
- `claude-code-source-code/README.md`
- `claude-code-source-code/README_CN.md`
