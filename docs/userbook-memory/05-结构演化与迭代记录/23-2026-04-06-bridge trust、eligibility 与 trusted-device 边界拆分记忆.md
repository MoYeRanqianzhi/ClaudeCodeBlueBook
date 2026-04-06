# bridge trust、eligibility 与 trusted-device 边界拆分记忆

## 本轮继续深入的核心判断

上一批已经拆清了：

- host / viewer / health-check
- trust dialog vs project `.mcp.json` 批准
- bridge 连接主题不应误回填到 `04`

但 bridge 这一侧仍有一条高价值边界没有稳定成文：

- workspace trust
- bridge entitlement / policy / OAuth 前提
- trusted-device 认证层

这三层都和 `remote-control` 有关，却还没有一篇正文把它们拆开。

如果不补这一批，正文会继续犯三种错：

- 把 `run claude first` 写成“先登录”
- 把 `/login` 触发的 trusted-device enrollment 写成 trust 的一部分
- 把 `allow_remote_control`、gate、最小版本、OAuth 混写成“信任检查”

## 苏格拉底式自审

### 问：为什么这批不能继续塞在 `21-Host、Viewer 与 Health Check`？

答：第 21 页回答的是：

- 这些入口到底是 host、viewer 还是 health-check

而本轮问题变成：

- 当对象已经确定是 bridge host 时
- 它到底还要过哪几种不同前提

这已经不是对象类型，而是：

- bridge 的多层准入边界

### 问：为什么这批也不能塞在 `22-Trust Dialog、项目级 .mcp.json 批准与 Health Check`？

答：第 22 页回答的是：

- workspace trust
- project server approval
- health-check

三者的关系。

而本轮不再关注 project `.mcp.json`，而是更窄地看：

- remote-control / bridge 这一条线上
- trust、eligibility、trusted-device 如何再次分层

所以它是第 22 页之后的继续收窄。

### 问：为什么不把 trusted-device 并到 `14-来源信任、Trust Dialog 与 Plugin-only Policy`？

答：第 14 页关注的是：

- 来源信任
- plugin-only policy
- admin-trusted source

trusted-device 的对象完全不同：

- 它是 bridge/code-session API 的设备认证材料

不是：

- 扩展来源信任

### 问：这批最该防的假并列是什么？

答：

- workspace trust = `/login`
- trusted-device = trusted workspace
- `allow_remote_control` = trust 开关
- bridge gate / 最小版本 / 订阅资格 = “又一个 trust dialog”
- standalone bridge 不弹 trust = 已自动 trust

只要这五组没先拆开，正文就会把 `trusted` 重新写回一个词。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/23-Workspace Trust、Bridge Eligibility 与 Trusted Device：为什么 remote-control 的 trust、auth、policy 不是同一把钥匙.md`
- `bluebook/userbook/03-参考索引/02-能力边界/12-Workspace Trust、Bridge Eligibility 与 Trusted Device 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/23-2026-04-06-bridge trust、eligibility 与 trusted-device 边界拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 正文落笔纪律

### 应写进正文的

- standalone / headless bridge 需要 prior trust
- interactive `/remote-control` 建立在当前 session trust 之后
- CLI fast-path 的 bridge preflight 至少包含 OAuth、gate、版本、组织策略
- trusted-device 在 `/login` 后 enrollment
- `X-Trusted-Device-Token` 属于 bridge/code-session API 层
- `trusted` 这个词在 bridge 语境里至少有三种不同含义

### 不应写进正文的

- Anthropic 内部门控 rollout 顺序
- SDK 预先授权路径的过细实现
- trusted-device 90d rolling expiry 的过度运营细节
- keychain / secure storage 的平台实现差异
- 服务端 enforcement 细枝末节

这些内容只作为作者判断依据，不回流正文。

## 本轮特殊注意

### 这批必须保护稳定面与条件面

`remote-control` 真实存在，但它不是：

- 默认稳定主线

更稳的写法是：

- 条件公开能力

而 trusted-device 更不应被写成：

- 用户日常可见控制面

### `trusted` 一词必须带对象

正文里不能再写：

- “这个 remote-control 已 trusted”

必须改写成：

- 工作区已 trust
- bridge 资格门已通过
- 设备具备 trusted-device token

## 后续继续深入时的检查问题

1. 我现在讲的是目录 trust、bridge 资格门，还是设备认证层？
2. 这里的 `trusted` 到底指 workspace 还是 device？
3. 这里失败的是目录前提、登录状态、版本/gate、组织策略，还是设备令牌？
4. 这条判断应进正文，还是只该留在记忆里作为写作纪律？

只要这四问没先答清，bridge 一组文档就会继续把：

- trust
- login
- policy
- gate
- device token

混写成一个模糊的“远控已被信任”状态。
