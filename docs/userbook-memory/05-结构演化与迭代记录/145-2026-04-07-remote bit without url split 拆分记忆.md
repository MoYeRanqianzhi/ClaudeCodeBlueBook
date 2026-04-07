# remote bit without url split 拆分记忆

## 本轮继续深入的核心判断

144 已经把 `/session` 的命令显隐和 pane 内容拆开了。

但正文还差最后一刀：

- 当 `getIsRemoteMode()` 为真，而 `remoteSessionUrl` 缺席时，系统到底坏到了哪一层？

本轮要补的更窄一句是：

- remote bit 为真但 URL 缺席时，坏掉的是 link/QR affordance，不是 CCR runtime 本体

## 为什么这轮必须单列

如果不单列，正文最容易在三种误写里回卷：

- 把 `/session` 的 warning 文案当成系统 verdict
- 把 footer remote pill 当成 remote health probe
- 把 URL 缺席偷换成 remote runtime 不成立

这三种都会把：

- coarse behavior bit
- remote runtime config
- URL affordance

重新压扁。

## 本轮最关键的新判断

### 判断一：`remoteSessionUrl` 在状态定义里本来就是 “for --remote mode / shown in footer indicator”

### 判断二：assistant viewer 路径会写 `setIsRemoteMode(true)`，会创建 `remoteSessionConfig`，但不会在初始态里显式种下 URL

### 判断三：`useRemoteSession` / `RemoteSessionManager` / `activeRemote` 的运行链路依赖 config，不依赖 URL

### 判断四：大量 consumer 只认 remote bit，因此在 URL 缺席时仍继续工作

### 判断五：真正直接依赖 URL 的运行时 consumer 很窄，核心只有 `/session` pane 与 footer remote pill

### 判断六：因此这类分叉态更像 affordance failure，而不是 runtime failure

## 苏格拉底式自审

### 问：为什么这页不直接写成 “viewer 和 `--remote` TUI 的差异”？

答：因为用户更关心的是使用后果，不只是启动路径差异；这页先回答“哪些面会坏、哪些不会坏”。

### 问：为什么一定要把 `useRemoteSession` 拉进来？

答：因为只有证明 runtime engine 不依赖 URL，才能把损伤精确限定在 display affordance。

### 问：为什么一定要做全仓 `remoteSessionUrl` 搜索？

答：因为只有这样才能证明 URL 依赖面很窄，不该被夸大成系统级停机。

### 问：这页和 144 的最小分工是什么？

答：144 讲 gate 结构；145 讲 gate 失败后的运行时影响表。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/145-getIsRemoteMode、remoteSessionUrl、useRemoteSession、StatusLine、PromptInputFooterLeftSide、SessionInfo 与 assistantInitialState：为什么 remote bit 为真但 URL 缺席时，CCR 本体仍可继续，而 link 与 QR affordance 会停摆.md`
- `bluebook/userbook/03-参考索引/02-能力边界/134-getIsRemoteMode、remoteSessionUrl、useRemoteSession、StatusLine、PromptInputFooterLeftSide、SessionInfo 与 assistantInitialState 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/145-2026-04-07-remote bit without url split 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 长文层只补 145
- 索引层只补 134
- 记忆层只补 145

不回写旧页，不新开子目录。

## 下一轮候选

1. 单独拆 assistant viewer 与 `--remote` TUI 为什么共用 coarse remote bit，却不共享同样厚度的 presence 初始态。
2. 单独拆 `REMOTE_SAFE_COMMANDS`、`filterCommandsForRemoteMode` 与 `handleRemoteInit` 为什么说明 remote-safe command surface 不是 runtime readiness proof。
3. 单独拆 `CLAUDE_CODE_REMOTE` 与 `getIsRemoteMode()` 为什么会在 headless / command path 上形成另一组 remote 行为分支。
