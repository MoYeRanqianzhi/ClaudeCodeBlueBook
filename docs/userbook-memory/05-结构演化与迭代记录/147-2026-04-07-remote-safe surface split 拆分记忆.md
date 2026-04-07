# remote-safe surface split 拆分记忆

## 本轮继续深入的核心判断

146 已经把 assistant viewer 与 `--remote` TUI 拆成了不同厚度的 remote 合同。

但正文还差一刀：

- 即使命令壳长得很像，能不能说明 runtime 也 ready？

本轮要补的更窄一句是：

- remote-safe command surface 不是 runtime readiness proof

## 为什么这轮必须单列

如果不单列，正文最容易在三种偷换里回卷：

- 把 allowlist 写成 readiness 表
- 把 `/session` 个例误当成 safe 集合整体
- 把 `handleRemoteInit` 的 surface merge 写成 semantic proof

这三种都会把：

- local-safe affordance
- backend command merge
- runtime dependency

重新压扁。

## 本轮最关键的新判断

### 判断一：`REMOTE_SAFE_COMMANDS` 从注释和实现上都只是在回答“哪些命令可安全留在本地壳里”

### 判断二：`filterCommandsForRemoteMode(...)` 只是 coarse pre-filter，不做 readiness 校验

### 判断三：`handleRemoteInit(...)` 只是把 backend 命令面与 local-safe 命令面做并集保留

### 判断四：同一 safe 集合里本来就混着 `/session`、`/mobile`、`/cost`、`/usage` 这类不同主权和不同状态依赖的命令

### 判断五：因此命令仍可见，只能说明 affordance shell 仍在，不能说明命令依赖的 runtime 语义已 ready

### 判断六：CCR remote TUI 里的 safe 更像 affordance 保留，而 bridge/mobile 的 `isBridgeSafeCommand()` 更接近严格执行 gate；safe 是入口 policy 语义，不是统一的 readiness 语义

## 苏格拉底式自审

### 问：为什么这页不继续写 viewerOnly / operator contract？

答：因为 146 已经回答合同厚度；147 继续回答“即使命令壳相似，也不能把它误写成 readiness 证明”。

### 问：为什么一定要把 `/mobile` 和 `/cost` 拉进来？

答：因为只有把明显异质的 safe 命令摆在一起，才能看出 safe 集合从一开始就不是 readiness 表。

### 问：为什么要把 `BRIDGE_SAFE_COMMANDS` 也记在判断里？

答：因为它能证明“command safe”是 policy/入口分类，而不是 readiness 分类。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/147-REMOTE_SAFE_COMMANDS、filterCommandsForRemoteMode、handleRemoteInit、session 与 mobile：为什么 remote-safe 命令面不是 runtime readiness proof.md`
- `bluebook/userbook/03-参考索引/02-能力边界/136-REMOTE_SAFE_COMMANDS、filterCommandsForRemoteMode、handleRemoteInit、session 与 mobile 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/147-2026-04-07-remote-safe surface split 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 长文层只补 147
- 索引层只补 136
- 记忆层只补 147

不回写旧页，不新开子目录。

## 下一轮候选

1. 单独拆 `CLAUDE_CODE_REMOTE` 与 `getIsRemoteMode()` 为什么会在 headless / command path 上形成另一组 remote 行为分支。
2. 单独拆 assistant viewer 路径里 `StatusLine` 的 `remote.session_id` 为什么在结构上活着，却不一定等于远端那个 session。
3. 单独拆 `system/init.slash_commands`、`REMOTE_SAFE_COMMANDS` 与 prompt/plain-text wire routing 为什么不属于同一种命令合同。
