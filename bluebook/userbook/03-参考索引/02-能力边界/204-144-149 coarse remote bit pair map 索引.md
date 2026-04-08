# 144-149 coarse remote bit pair map 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/217-session pane、command shell 与 headless remote memory：为什么 144、145、146、147、148、149 不是线性六连，而是从 143 分出去的三组相邻配对.md`
- `05-控制面深挖/144-getIsRemoteMode、commands-session、remoteSessionUrl、SessionInfo、PromptInputFooterLeftSide 与 StatusLine：为什么 session 命令的显隐与 pane 内容不是同一种 remote mode.md`
- `05-控制面深挖/145-getIsRemoteMode、remoteSessionUrl、useRemoteSession、StatusLine、PromptInputFooterLeftSide、SessionInfo 与 assistantInitialState：为什么 remote bit 为真但 URL 缺席时，CCR 本体仍可继续，而 link 与 QR affordance 会停摆.md`
- `05-控制面深挖/146-assistant viewer、--remote TUI、viewerOnly、remoteSessionUrl 与 filterCommandsForRemoteMode：为什么同一 coarse remote bit 不等于同样厚度的 remote 合同.md`
- `05-控制面深挖/147-REMOTE_SAFE_COMMANDS、filterCommandsForRemoteMode、handleRemoteInit、session 与 mobile：为什么 remote-safe 命令面不是 runtime readiness proof.md`
- `05-控制面深挖/148-CLAUDE_CODE_REMOTE、getIsRemoteMode、print、reload-plugins 与 settingsSync：为什么 headless remote 分支不是 interactive remote bit 的镜像.md`
- `05-控制面深挖/149-CLAUDE_CODE_REMOTE_MEMORY_DIR、memdir、SessionMemory、extractMemories 与 print：为什么 remote 记忆持久化不是单根目录，而是 auto-memory 根与 session 账本的双轨体系.md`

边界先说清：

- 这页不是 `144-149` 的细节证明总集。
- 这页不替代 217 的结构长文。
- 这页只抓 `144->145`、`146->147`、`148->149` 这三组相邻配对。
- 这页保护的是 pane / URL、contract / command shell、env axis / memory persistence 的主语分裂，不把某条文案、某个 allowlist 或某个 env var 直接升级成稳定公共合同。

## 1. 三组 pair 总表

| 节点 | 作用 | 在图上的位置 |
| --- | --- | --- |
| 217 | 解释 `144-149` 的三组相邻配对 | 结构收束页 |
| 144 | 先分 `/session` 命令显隐与 pane 内容为什么不是同一种 remote mode | pane-gate 根页 |
| 145 | 继续分 remote bit 为真但 URL 缺席时，哪些 affordance 先停摆 | URL-affordance zoom |
| 146 | 先分同一 coarse remote bit 为什么不等于同样厚度的 remote 合同 | contract-thickness 根页 |
| 147 | 继续分 remote-safe command surface 为什么不是 runtime readiness proof | command-shell zoom |
| 148 | 先分 `CLAUDE_CODE_REMOTE` 为什么不是 interactive remote bit 的镜像 | env-axis 根页 |
| 149 | 继续分 remote memory 为什么不是单根目录 | memory-persistence zoom |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `144-149` 都在讲同一个 coarse remote bit，所以顺着编号一路读就行 | 更稳的是三组相邻配对，而不是线性六连 |
| `/session` 命令露出来，就说明 pane 内容一定 ready | `144/145` 更稳是 command gate 与 URL-affordance split |
| assistant viewer 只是少一个 URL 的 `--remote` TUI | `146` 先问的是 contract thickness，不是 display field |
| safe 命令还在，就说明 runtime ready | `147` 先问的是 affordance，不是 readiness |
| `CLAUDE_CODE_REMOTE` 只是 env 写法的 `getIsRemoteMode()` | `148` 更稳是 env-driven remote 轴，不是 bootstrap bit mirror |
| remote memory 都该落在 `CLAUDE_CODE_REMOTE_MEMORY_DIR` 一根目录下 | `149` 更稳是 memdir / auto-memory 与 session ledger 双轨 |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | `/session` 双重 gate 当前成立；URL 缺席先打掉 affordance 而不是必然打掉 runtime；same coarse bit != same contract thickness；remote-safe command shell != readiness；env-driven remote 轴 != interactive bootstrap bit；remote memory 持久化是双轨 |
| 条件公开 | safe 命令集合与不同入口的保留策略仍可变；URL 是否存在取决于具体 remote path；headless memory 仍受宿主与持久化环境约束 |
| 内部/灰度层 | 命令最终本地执行还是远端发送；env 分支下 timeout / settingsSync / plugin 细节；memory 双轨未来是否整合 |

## 4. 六个检查问题

- 我现在写的是 pane / URL 问题、command shell 问题，还是 env-driven memory 问题？
- 我是不是把命令仍可见，偷换成了 runtime ready？
- 我是不是把 assistant viewer 与 `--remote` TUI 写成了同样厚度的合同？
- 我是不是把 `CLAUDE_CODE_REMOTE` 和 `getIsRemoteMode()` 又压回同一个 remote bit？
- 我是不是把 memdir 根与 session ledger 写成了同一条持久化路径？
- 我有没有把 `144-149` 又写回成“同一 remote bit 的六步展开”？

## 5. 源码锚点

- `claude-code-source-code/src/commands/session/index.ts`
- `claude-code-source-code/src/commands/session/session.tsx`
- `claude-code-source-code/src/components/PromptInput/PromptInputFooterLeftSide.tsx`
- `claude-code-source-code/src/components/StatusLine.tsx`
- `claude-code-source-code/src/main.tsx`
- `claude-code-source-code/src/hooks/useRemoteSession.ts`
- `claude-code-source-code/src/commands/commands.ts`
- `claude-code-source-code/src/screens/REPL.tsx`
- `claude-code-source-code/src/entrypoints/cli.tsx`
- `claude-code-source-code/src/cli/print.ts`
- `claude-code-source-code/src/memdir/paths.ts`
- `claude-code-source-code/src/services/SessionMemory/sessionMemory.ts`
