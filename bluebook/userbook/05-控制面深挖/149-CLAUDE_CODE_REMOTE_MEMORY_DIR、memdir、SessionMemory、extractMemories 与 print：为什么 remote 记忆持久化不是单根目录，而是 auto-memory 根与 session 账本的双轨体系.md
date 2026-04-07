# `CLAUDE_CODE_REMOTE_MEMORY_DIR`、`memdir`、`SessionMemory`、`extractMemories` 与 `print`：为什么 remote 记忆持久化不是单根目录，而是 auto-memory 根与 session 账本的双轨体系

## 用户目标

148 已经把：

- `CLAUDE_CODE_REMOTE`
- `getIsRemoteMode()`

拆成了 env-driven remote 轴与 interactive remote bit。

但如果正文停在这里，下一种常见误写马上会出现：

- “既然 remote 有 `CLAUDE_CODE_REMOTE_MEMORY_DIR`，那 remote memory 应该都落在同一根目录下。”

这句也不稳。

这轮要补的不是：

- “哪里又出现了 memory 相关代码”

而是：

- “为什么 `CLAUDE_CODE_REMOTE_MEMORY_DIR` 只回答 remote 场景下 memdir/auto-memory 根目录是否存在、落在哪里，而 `SessionMemory` 仍然挂在 transcript/session-persistence 账本上”

也只有把这层拆开，才不会把：

- auto-memory
- agent-memory
- session memory
- headless `print`
- interactive remote
- assistant viewer

重新压回成一种“remote 记忆”。

## 第一性原理

比起直接问：

- “remote memory 放哪？”

更稳的提问是先拆四个更底层的问题：

1. 当前代码在回答的是 memory 根目录、agent-memory 路径，还是 session summary 账本？
2. 当前分支在回答“有没有 persistent storage”，还是“当前会话要不要写摘要”？
3. 当前宿主是 local interactive、interactive remote、assistant viewer，还是 headless `print`？
4. 如果 `SessionMemory` 的路径根本不读 `CLAUDE_CODE_REMOTE_MEMORY_DIR`，那两者还能被写成同一条持久化语义吗？

这四问不先拆开，remote memory 很容易被误写成：

- “一切都落在 remote memory dir”

## 第一层：`CLAUDE_CODE_REMOTE_MEMORY_DIR` 决定的是 memdir 根是否存在，不是 session memory 根

`memdir/paths.ts` 的判断非常关键。

这里真正先回答的是：

- auto-memory 在当前环境下到底启不启

而不是：

- 本地/远端所有记忆对象都该往哪写

当前逻辑里，`isAutoMemoryEnabled()` 的优先级链已经把一种情况写死了：

- `CLAUDE_CODE_REMOTE=true` 且没有 `CLAUDE_CODE_REMOTE_MEMORY_DIR`

这时并不是：

- “先写到默认 session memory 目录里”

而是更直接地：

- CCR remote without persistent storage -> auto-memory 关闭

也就是说，`CLAUDE_CODE_REMOTE_MEMORY_DIR` 首先回答的是：

- remote 环境有没有可持久化的 memdir 根

它不是：

- 所有 memory 都共享的总根目录

再往下看 `getMemoryBaseDir()`、`getAutoMemPath()`，也能看到它的对象更窄：

- 先决定 memdir base dir
- 再在其下展开 `projects/<sanitized-git-root>/memory/...`

这条链回答的是：

- auto-memory / agent-memory 的目录拓扑

不是：

- session transcript / session summary 的基座

## 第二层：`memdir` / agent-memory 与 `SessionMemory` 本来就是两张账

如果只看“都叫 memory”，很容易把它们误认成同类。

但路径策略已经说明它们不在同一账本里。

### `memdir` / agent-memory

`tools/AgentTool/agentMemory.ts` 里的 `user` / `project` / `local` scope，本来就是三种不同的路径策略。

特别是 `local` scope，在 remote mount 场景下会显式带 project namespace。

这说明 agent-memory 的持久化考虑的是：

- scope
- project namespace
- memdir base
- remote mount 是否存在

### `SessionMemory`

而 `utils/permissions/filesystem.ts` 里 session memory 文件路径则是另一套：

- `{projectDir}/{sessionId}/session-memory/summary.md`

这里真正依赖的是：

- `projectDir`
- `sessionId`
- transcript/session persistence 栈

它根本不读：

- `CLAUDE_CODE_REMOTE_MEMORY_DIR`

再连到 `sessionStoragePortable.ts` 的 `getProjectDir()`，会更清楚：

- 它走的是 `~/.claude/projects/<sanitized-path>` 这套 project/session storage 基座

所以更稳的表述应该是：

- `CLAUDE_CODE_REMOTE_MEMORY_DIR` 管的是 memdir 根
- `SessionMemory` 管的是 session ledger

这不是同一根路径被不同函数包装，

而是：

- 两套不同的持久化账本

## 第三层：interactive remote 与 assistant viewer 共享“跳过本地 SessionMemory”的边界

这层最容易被忽略。

很多人会默认：

- 只要 remote 场景还在跑，本地某种 session memory 总会继续写

但 `setup.ts` 注册 session memory 之后，真正的初始化分支在 `services/SessionMemory/sessionMemory.ts` 里还会再看：

- `getIsRemoteMode()`

也就是说，session memory 不是“只要 setup 了就继续跑”，而是：

- 还要经过 interactive remote bit 的第二道 gate

而 `main.tsx` 里 assistant viewer 和 interactive `--remote` 两条路径又都会把：

- `getIsRemoteMode()`

推成真。

所以当前源码更像在说：

### interactive remote

- 本地 `SessionMemory` 不启

### assistant viewer

- 同样落在 remote bit 为真的分支里
- 同样不把自己当成本地 session memory writer

这一步就把：

- “interactive remote / assistant viewer / local interactive 都共享同一条 session-memory 语义”

彻底拆掉了。

## 第四层：headless `print` 不是 `SessionMemory` 的写回器，它主要驱动 `extractMemories`

这里又是另一种常见误写：

- “interactive remote 不写 session memory，那 headless print 应该补上这条链。”

源码并不支持这种压缩。

`SessionMemory` 抽取器一侧会限制：

- 只跑 `repl_main_thread`

而 headless `print` 走的是：

- `querySource='sdk'`

所以它不是：

- session memory 的 headless 替身

真正会在 headless / non-interactive 一侧起作用的，是：

- `backgroundHousekeeping`
- `stopHooks`
- `extractMemories`

再看 `extractMemories.ts`，判断顺序也非常说明问题：

1. 先看 `isAutoMemoryEnabled()`
2. 再看 `getIsRemoteMode()`

这说明 headless remote memory 的边界其实是两层：

- 有没有 memdir / persistent storage
- 当前是不是 interactive remote bit

而 `main.tsx` 与 `cli/print.ts` 在退出前 drain `extractMemories`，也再次证明：

- headless `print` 主要收口的是 auto-memory 背景链

不是：

- `SessionMemory` 会话摘要账本

## 第五层：因此 remote memory 不是一根目录，而是双轨持久化体系

把前面几层合起来，结论就会稳定很多。

### 轨道一：auto-memory / agent-memory

它关心的是：

- `CLAUDE_CODE_REMOTE_MEMORY_DIR`
- memdir base
- remote mount
- scope / project namespace
- `extractMemories`

这是：

- auto-memory 根目录轨

### 轨道二：session memory / transcript persistence

它关心的是：

- `projectDir`
- `sessionId`
- `session-memory/summary.md`
- `sessionStoragePortable`
- `repl_main_thread`

这是：

- session 账本轨

所以更稳的写法不是：

- remote memory 都落在同一根 remote dir

而是：

- remote 场景里至少有 memdir 根与 session 账本两套持久化体系

## 稳定面与灰度面

### 稳定面

- `CLAUDE_CODE_REMOTE_MEMORY_DIR` 只直接影响 memdir / auto-memory 根
- `SessionMemory` 路径属于 project/session persistence 栈
- interactive remote 与 assistant viewer 会一起跳过本地 session memory 初始化
- headless `print` 主要对接 `extractMemories`

### 灰度面

- 哪些 remote 宿主未来会继续共享 `extractMemories` 的 drain 节奏
- auto-memory 与 agent-memory 的 scope/path policy 是否还会继续收敛
- viewer/remote attach 未来是否会引入新的只读 memory 消费面

## 苏格拉底式自审

### 问：为什么这页不继续写 148 的 env remote 轴？

答：因为 148 解释的是“哪根 remote 轴在起作用”；149 要解释的是“持久化到底落在哪张账上”。问题已经从 behavior axis 变成 storage contract。

### 问：为什么一定要把 `SessionMemory` 路径和 `memdir` 路径并排写？

答：因为只有把两条路径并排摆出来，才能证明这不是一个目录被两层 API 封装，而是两套不同账本。

### 问：为什么一定要把 assistant viewer 拉进来？

答：因为它能证明 interactive remote 并不自动等于“本地某条 session memory 仍在继续”，viewer 更像 remote 消费者，而不是本地记忆写回器。

### 问：为什么 headless `print` 不能被写成 session memory 的替身？

答：因为它真正 drain 的是 `extractMemories` 背景链，而 `SessionMemory` 本身被限定在另一套宿主/线程边界里。

### 问：这页的一句话 thesis 是什么？

答：`CLAUDE_CODE_REMOTE_MEMORY_DIR` 只控制 remote 场景下 memdir/auto-memory 根是否存在、落在哪里，而 `SessionMemory` 仍挂在 transcript/session-persistence 账本上，所以 headless remote、interactive remote、assistant viewer 不共享同一种 memory 持久化语义。

## 结论

对当前源码来说，更准确的写法应该是：

1. `CLAUDE_CODE_REMOTE_MEMORY_DIR` 决定的是 memdir/auto-memory 根
2. `SessionMemory` 仍落在 project/session persistence 账本里
3. interactive remote 与 assistant viewer 共享“跳过本地 session memory”边界
4. headless `print` 主要收口的是 `extractMemories`，不是 `SessionMemory`

所以：

- remote 记忆持久化不是单根目录，而是 auto-memory 根与 session 账本的双轨体系

## 源码锚点

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
