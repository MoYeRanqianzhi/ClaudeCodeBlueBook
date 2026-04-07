# `CLAUDE_CODE_REMOTE_MEMORY_DIR`、`memdir`、`SessionMemory`、`extractMemories` 与 `print` 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/149-CLAUDE_CODE_REMOTE_MEMORY_DIR、memdir、SessionMemory、extractMemories 与 print：为什么 remote 记忆持久化不是单根目录，而是 auto-memory 根与 session 账本的双轨体系.md`
- `05-控制面深挖/148-CLAUDE_CODE_REMOTE、getIsRemoteMode、print、reload-plugins 与 settingsSync：为什么 headless remote 分支不是 interactive remote bit 的镜像.md`
- `05-控制面深挖/145-getIsRemoteMode、remoteSessionUrl、useRemoteSession、StatusLine、PromptInputFooterLeftSide、SessionInfo 与 assistantInitialState：为什么 remote bit 为真但 URL 缺席时，CCR 本体仍可继续，而 link 与 QR affordance 会停摆.md`

边界先说清：

- 这页不是 memory feature 总表。
- 这页不是 148 的 env remote 轴重写版。
- 这页只抓 remote 语境下的 memory persistence 为什么至少分成 memdir 根与 session 账本两条轨。

## 1. 两条持久化轨

| 轨 | 当前更像什么 | 关键对象 |
| --- | --- | --- |
| memdir / auto-memory 轨 | remote persistent storage / memory base dir | `CLAUDE_CODE_REMOTE_MEMORY_DIR`、`getMemoryBaseDir()`、`getAutoMemPath()`、`extractMemories` |
| session memory 轨 | transcript / session persistence ledger | `projectDir`、`sessionId`、`session-memory/summary.md`、`SessionMemory` |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| remote memory 都落在 `CLAUDE_CODE_REMOTE_MEMORY_DIR` 下 | 这个 env 只直接回答 memdir 根 |
| `SessionMemory` 只是 memdir 的另一层 API | 它走的是 project/session persistence 栈 |
| interactive remote 不写 session memory，headless print 就会补上 | headless `print` 更像 `extractMemories` 的宿主 |
| assistant viewer 仍属于本地 session memory writer | viewer 更像 remote consumer，不是本地写回器 |

## 3. 宿主视角速查

| 宿主 | auto-memory / memdir | SessionMemory |
| --- | --- | --- |
| local interactive | 可按本地 memdir 规则启用 | 可初始化并写入本地 session ledger |
| interactive remote | 要看 memdir 是否开启 | 本地 `SessionMemory` 跳过 |
| assistant viewer | 不主导本地 memdir 写回 | 同样跳过本地 `SessionMemory` |
| headless `print` | 主要通过 `extractMemories` 背景链收口 | 不是 session memory 的 headless 替身 |

## 4. stable / conditional / gray

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | memdir 根与 session ledger 是两条轨；interactive remote / viewer 会跳过本地 `SessionMemory` |
| 条件公开 | headless remote 是否真的有 memdir，取决于 `CLAUDE_CODE_REMOTE_MEMORY_DIR` 是否存在 |
| 内部/灰度层 | 后续哪些 remote 宿主继续共享 `extractMemories` drain 节奏，仍可能调整 |

## 5. 五个检查问题

- 我现在写的是 memdir 根，还是 session ledger？
- 我是不是把 `CLAUDE_CODE_REMOTE_MEMORY_DIR` 误写成所有 memory 的总根目录？
- 我是不是忽略了 `SessionMemory` 根本不读这个 env？
- 我是不是把 headless `print` 误写成 session memory 的替身？
- 我是不是把 assistant viewer 误写成还在本地写 session summary 的 interactive 宿主？

## 6. 源码锚点

- `claude-code-source-code/src/memdir/paths.ts`
- `claude-code-source-code/src/tools/AgentTool/agentMemory.ts`
- `claude-code-source-code/src/utils/permissions/filesystem.ts`
- `claude-code-source-code/src/utils/sessionStoragePortable.ts`
- `claude-code-source-code/src/setup.ts`
- `claude-code-source-code/src/services/SessionMemory/sessionMemory.ts`
- `claude-code-source-code/src/QueryEngine.ts`
- `claude-code-source-code/src/query.ts`
- `claude-code-source-code/src/utils/backgroundHousekeeping.ts`
- `claude-code-source-code/src/query/stopHooks.ts`
- `claude-code-source-code/src/services/extractMemories/extractMemories.ts`
- `claude-code-source-code/src/main.tsx`
- `claude-code-source-code/src/cli/print.ts`
