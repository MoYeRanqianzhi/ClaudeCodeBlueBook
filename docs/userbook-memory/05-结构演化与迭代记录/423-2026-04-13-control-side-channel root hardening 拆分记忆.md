# control-side-channel root hardening 拆分记忆

## 本轮继续深入的核心判断

在当前 worktree 已经把：

- `122`

这类 remote recovery 叶根页拉回当前成熟口径之后，

下一刀更值钱的，

不是继续新增结构入口，

而是回到：

- `193-handleIngressMessage、isSDKControlResponse、isSDKControlRequest、onPermissionResponse 与 onControlRequest：为什么 bridge ingress 的 control side-channel 不是对称的通用 control 总线.md`

把这张 bridge ingress control-side-channel 根页，

继续从旧版的：

- `稳定 / 条件 / 灰度保护`

抬升成最近已经稳定下来的：

- `稳定层、条件层与灰度层`

口径，

并补上一句更明确的安全收束。

## 为什么这轮值得单独提交

### 判断一：`193` 是 bridge ingress control 线的根页，根页的口径应该和近几轮成熟页统一

`193`

已经把对象拆得足够清楚：

- `control_response` = permission verdict 返回腿
- `control_request` = session-control 请求腿
- 二者共用 ingress socket，不等于共用同一条 control 总线

它真正缺的，

不是更多结构事实，

而是：

- 和最近连续补过的 root / branch page 共享同一套三层标题
- 明确写出结论应停在 `control side-channel != symmetric generic control bus`

### 判断二：当前更值钱的是收束根页合同边界，不是继续扩结构入口

这条线已经同时有：

- `191` ingress consumer contract
- `193` control side-channel root
- `197` ingress 阅读链
- `203` permission tail 分叉图
- `206` blocked-state ceiling

继续新增 README/hub，

收益会低于直接把 `193` 自己的口径抬平。

所以这轮结构优化的动作，

不是新增入口，

而是继续减少根页与相邻成熟页之间的命名漂移。

### 判断三：这轮也在保护 “根页负责稳定合同，后继页负责细化” 的职责分工

当前如果 `193` 继续停在旧版标题，

读者就更容易把：

- `193`
- `203`
- `206`

读成三种不同写法，

而不是同一簇里不同层次的收束页。

把 `193` 的标题和 stop line 补齐，

能让这条 control 线的 root page 更稳地承担根页职责。

## 这轮具体怎么拆

这轮只做三件事：

1. 修改 `193-...control 总线.md`
   - 把旧版 `稳定 / 条件 / 灰度保护`
   - 改成 `稳定层、条件层与灰度层`
   - 并补上 `control side-channel != symmetric generic control bus` 的 stop line
2. 新增这条 `423` 记忆
   - 记录为什么这轮优先补 `193` 自己的口径，而不是继续扩目录
3. 更新 `memory/05 README`
   - 把最新批次索引推进到 `423`

## 苏格拉底式自审

### 问：为什么这轮不是先去做 `203`？

答：因为 `203` 已经是三层表，只是标题版本稍旧；`193` 作为更直接的根页，先统一口径收益更高。

### 问：为什么这轮不是继续去补 `206` 之后的新页？

答：因为 `206` 已经被补成成熟口径，当前更明显的缺口反而是 `193` 这个根页自己还留着旧标题。

### 问：为什么这也算“优化相关目录结构”？

答：因为结构优化不只等于新增 README。当前让同一条 bridge/control 支线上的根页与相邻收束页共享同一套术语，本身就在降低目录系统里的口径漂移。
