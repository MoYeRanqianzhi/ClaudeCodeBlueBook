# assistant viewer vs remote tui split 拆分记忆

## 本轮继续深入的核心判断

145 已经把“remote bit 真但 URL 缺席”写成了运行时影响表。

但正文还差一刀：

- assistant viewer 到底是不是“少一个 URL 的 `--remote` TUI”？

本轮要补的更窄一句是：

- assistant viewer 与 `--remote` TUI 共享 coarse remote bit，却不共享同样厚度的 remote 合同

## 为什么这轮必须单列

如果不单列，正文最容易在三种偷换里回卷：

- 把相似命令壳误写成相同合同
- 把 `viewerOnly` 低估成小 flag
- 把 URL/prompt/session ownership 的差异压成“只是显示项不同”

这三种都会把：

- coarse shell
- contract thickness
- operator authority

重新压扁。

## 本轮最关键的新判断

### 判断一：两条路径共享 `setIsRemoteMode(true)`、`createRemoteSessionConfig(...)`、`filterCommandsForRemoteMode(commands)` 与 `launchRepl(...)` 这层外壳

### 判断二：assistant viewer 的 config 从一开始就是 `viewerOnly = true`

### 判断三：assistant viewer 与 `--remote` TUI 在初始态厚度上明显分叉：前者是 `assistantInitialState`，后者是 `remoteInitialState + remoteSessionUrl + switchSession + 可选 initialUserMessage`

### 判断四：`useAssistantHistory`、`useRemoteSession` 会围绕 `viewerOnly` 联动 history、title、timeout、interrupt 这些更厚的行为差异

### 判断五：所以两条路径的差异不是“功能开关多少”，而是合同厚度多少

## 苏格拉底式自审

### 问：为什么这页不继续写“URL 缺席会怎样”？

答：因为 145 已经回答后果；146 继续回答这种后果在 assistant viewer 上为什么更像合同本来就更薄。

### 问：为什么一定要把 `filterCommandsForRemoteMode` 也拉进标题？

答：因为最容易误导读者的正是命令壳相似性；不把它写进来，就很难解释为什么“看起来一样”却“合同不一样”。

### 问：为什么一定要把 `switchSession`、`initialUserMessage` 一起写？

答：因为只有把 identity、prompt ownership、display affordance 一起摆出来，厚度差异才成立。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/146-assistant viewer、--remote TUI、viewerOnly、remoteSessionUrl 与 filterCommandsForRemoteMode：为什么同一 coarse remote bit 不等于同样厚度的 remote 合同.md`
- `bluebook/userbook/03-参考索引/02-能力边界/135-assistant viewer、--remote TUI、viewerOnly、remoteSessionUrl 与 filterCommandsForRemoteMode 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/146-2026-04-07-assistant viewer vs remote tui split 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 长文层只补 146
- 索引层只补 135
- 记忆层只补 146

不回写旧页，不新开子目录。

## 下一轮候选

1. 单独拆 `REMOTE_SAFE_COMMANDS`、`filterCommandsForRemoteMode` 与 `handleRemoteInit` 为什么说明 remote-safe command surface 不是 runtime readiness proof。
2. 单独拆 `CLAUDE_CODE_REMOTE` 与 `getIsRemoteMode()` 为什么会在 headless / command path 上形成另一组 remote 行为分支。
3. 单独拆 assistant viewer 路径里 `StatusLine` 的 `remote.session_id` 为什么在结构上活着，却不一定等于远端那个 session。
