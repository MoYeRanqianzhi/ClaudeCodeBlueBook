# session dual gate split 拆分记忆

## 本轮继续深入的核心判断

143 把 `getIsRemoteMode()` 从 remote presence truth 里拆出来之后，还差最后一个容易复燃的误写：

- “既然 `/session` 用 `getIsRemoteMode()` 显隐，那 pane 内容和命令显隐本来就是同一种 remote mode。”

这句仍然不稳。

本轮要补的更窄一句是：

- `/session` 的命令显隐与 pane 内容不是同一种 remote mode

## 为什么这轮必须单列

如果不单列，正文最容易在三种偷换里回卷：

- 把 command affordance 写成 presence content
- 把 footer 的 UI 抑制写成 remote presence 展示
- 把 status line 的 remote schema export 写成 `/session` pane 的内容依据

这三种都会把：

- coarse latch
- pane content
- UI correctness
- schema export

重新压扁。

## 本轮最关键的新判断

### 判断一：`commands/session/index.ts` 只管命令 surface，不管 pane 内容

### 判断二：`SessionInfo` 真正认的是 `remoteSessionUrl`，不是 `getIsRemoteMode()`

### 判断三：`claude assistant` attach / viewer 与 `claude --remote` TUI 都会 `setIsRemoteMode(true)`，但只有后者会在初始 AppState 里显式种下 `remoteSessionUrl`

### 判断四：同一个 footer 已经把 `remoteSessionUrl` 当 link presence、把 `getIsRemoteMode()` 当 modePart 抑制阈值

### 判断五：`remoteSessionUrl` 在状态定义里本来就被限定为 “for --remote mode / shown in footer indicator”，footer 读取它时又是 mount-time snapshot，不是通用 presence 订阅

### 判断六：`StatusLine` 再提供第三类 consumer，它消费的是 schema export，而不是 pane presence

## 苏格拉底式自审

### 问：为什么 143 之后还要再补 144？

答：143 只回答“flag 不是 truth”；144 继续回答“就连同一功能族里的 `/session`，命令显隐和 pane 内容也不是一回事”。

### 问：为什么要把 `main.tsx` 的两条启动路径拉进来？

答：因为只有这样，`SessionInfo` 的 fallback 才不再像纯 defensive branch，而是能和真实启动分叉对上。

### 问：为什么必须把 footer 和 status line 一起写？

答：因为它们能把 `getIsRemoteMode()` 的三类 consumer 拆开：

- affordance
- UI correctness
- schema export

### 问：为什么不能直接说“`remoteSessionUrl` 才是真相，所以都该按它显隐”？

答：因为 command surface 需要先做 remote-safe affordance 筛选，这不是 pane 内容问题。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/144-getIsRemoteMode、commands-session、remoteSessionUrl、SessionInfo、PromptInputFooterLeftSide 与 StatusLine：为什么 session 命令的显隐与 pane 内容不是同一种 remote mode.md`
- `bluebook/userbook/03-参考索引/02-能力边界/133-getIsRemoteMode、commands-session、remoteSessionUrl、SessionInfo、PromptInputFooterLeftSide 与 StatusLine 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/144-2026-04-07-session dual gate split 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 长文层只补 144
- 索引层只补 133
- 记忆层只补 144

不回写旧页，不新开子目录。

## 下一轮候选

1. 单独拆 `getIsRemoteMode()` 为真但 `remoteSessionUrl` 缺席时，哪些 consumer 还能工作、哪些 consumer 会失效。
2. 单独拆 `claude assistant` attach 与 `claude --remote` TUI 为什么共用 coarse latch，却不共用同样厚度的 presence 初始态。
3. 单独拆 `REMOTE_SAFE_COMMANDS`、`handleRemoteInit` 与 `/session` 为什么说明 remote-safe command surface 不是 presence ledger 的镜像。
