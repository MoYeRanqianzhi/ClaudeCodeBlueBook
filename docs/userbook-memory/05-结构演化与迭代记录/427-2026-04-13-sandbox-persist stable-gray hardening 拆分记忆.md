# sandbox-persist stable-gray hardening 拆分记忆

## 本轮继续深入的核心判断

在当前 worktree 已经把：

- `203`
- `199`
- `201`

这些 permission-tail 结构页与叶页入口句继续拉回成熟口径之后，

下一刀更值钱的，

不是继续扩目录入口，

而是回到：

- `202-applyPermissionUpdate、persistPermissionUpdate、SandboxManager.refreshConfig 与 localSettings：为什么 sandbox permission 的 persist-to-settings 不是一次单层 permission 写入.md`

把这张 sandbox persist 写面页，

从旧式的：

- 稳定不变量
- 条件公开
- 灰度 / 内部层

收束成最近已经稳定下来的：

- `稳定层、条件层与灰度层`

口径，

并补上一句更明确的 stop line。

## 为什么这轮值得单独提交

### 判断一：`202` 的正文事实已经够，真正落后的只是尾部口径

`202`

前五层已经把三张写面拆得很清楚：

- `applyPermissionUpdate(...)` = leader 本地 context mutation
- `persistPermissionUpdate(...)` = durable settings write
- `SandboxManager.refreshConfig()` = live runtime catch-up

当前更明显的缺口，

不是再补更多 sandbox persist 事实，

而是它的尾部还停在较旧的分层写法。

### 判断二：这页最需要保护的是“三层传播”与“非替代关系”两句稳定结论

当前最容易重新塌掉的误判是：

- sandbox permission persist 不就是一次 settings write

所以这轮最该保住的是：

- persist 手势会跨 context / settings / runtime 三层传播
- `persistPermissionUpdate(...)` 与 `refreshConfig()` 不是替代关系

最该降到条件或灰度层的则是：

- worker sandbox 只有 allow 才落 `localSettings`
- `refreshConfig()` 受 sandbox enable gate 约束
- settings detector 的追平节奏与内部 wiring

### 判断三：这轮继续贯彻“正文合同厚度优先于新增 hub”的目录策略

近期连续几轮都在指向同一件事：

- 当前 ROI 更高的是正文 hardening
- 不是继续裂 README / hub

这轮对 `202` 的处理，

就是把一个已经成立的 leaf page，

进一步拉回当前统一的 stable / conditional / gray 收束格式。

## 这轮具体怎么拆

这轮只做三件事：

1. 修改 `202-...persist-to-settings.md`
   - 把旧式“稳定不变量 / 条件公开 / 灰度 / 内部层”
   - 改成 `稳定层、条件层与灰度层`
   - 补一句 stop line：结论必须停在“三层传播 + 非替代关系”
2. 新增这条 `427` 记忆
   - 记录为什么这轮优先补 `202` 尾部口径
3. 更新 `memory/05 README`
   - 把最新批次索引推进到 `427`

## 苏格拉底式自审

### 问：为什么这轮不是继续去改 `199/201` 更多正文？

答：因为它们刚完成 leaf-entry anti-linearity hardening。当前更不统一的，反而是 `202` 尾部还保留旧式分层口径。

### 问：为什么这轮不是继续回到 `203`？

答：因为 `203` 的 successor skeleton 与 canonical topology 已经够硬；继续补它的收益，低于把 `202` 这种还在旧口径里的叶页补平。

### 问：为什么这也算“优化相关目录结构”？

答：因为结构优化不只等于增加入口。当前让 permission tail 相邻页共享同一套 stable / conditional / gray 收束术语，本身就在减少目录系统里的口径漂移。
