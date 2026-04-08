# remote command index conditional boundary sync 拆分记忆

## 本轮继续深入的核心判断

这一轮最值得收的，

不是再扩 remote 专题，

而是把命令索引里仍被写成稳定并列项的：

- `/remote-env`
- `/web-setup`

压回条件公开边界。

## 为什么这轮值得单独提交

### 判断一：命令索引不该让 remote 配置面看起来像稳定默认主线

当前命令索引这一段里：

- `/remote-control`

已经标了：

- 隐藏 / 条件公开

但相邻的：

- `/remote-env`
- `/web-setup`

还被写成没有任何门控提示的普通并列项。

这会让读者在最先看的命令总览里先吸收成：

- remote 配置面是稳定公开菜单

而这与边界正文已经冲突。

## 证据链

### 判断二：两条命令都有现成的条件边界证据

现有正文已经明确：

- `03-参考索引/02-能力边界/02-Feature Gate 与可见性索引.md`
  里 `web-setup` 受 `CCR_REMOTE_SETUP` 门控
- `04-专题深潜/16-IDE、Desktop、Mobile 与会话接续专题.md`
  里明确写：
  - `/remote-control` 与 `/remote-env` 都不是稳定默认主线
  - `/remote-env` 受 `claude.ai` 订阅与 `allow_remote_sessions` policy 共同控制

所以问题不在缺证据，

而在命令索引还没把这些边界带回上游。

## 这轮具体怎么拆

### 判断三：只补索引注记，不改矩阵和专题正文

这轮只改命令索引两行：

1. `/remote-env`
   - 标成条件公开
   - 补上订阅与 policy 约束
2. `/web-setup`
   - 标成条件公开
   - 补上 `CCR_REMOTE_SETUP` 门控

这样：

- 命令总览层不会再先把 remote 配置面讲成稳定菜单
- 但专题层和边界索引无需重写

## 为什么这轮不顺手改 `/session`

### 判断四：`/session` 的 viewer 侧边界已经在相邻专题里立住

`/session`

虽然也落在 remote 组里，

但当前误导主要来自：

- `/remote-env`
- `/web-setup`

缺少条件公开提示。

所以这轮不扩大范围。

## 主树状态记录

2026-04-08 在主仓库 `/home/mo/m/projects/cc/analysis` 执行：

- `git fetch origin main`
- `git pull --ff-only origin main`

结果是：

- `pull` 成功：`Already up to date.`

因此本轮继续深入仍只在：

- `.worktrees/userbook`

推进。

## 苏格拉底式自审

### 问：我是不是把 remote 配置面说成完全不可用？

答：没有。这轮只把它们从“稳定默认主线”收回到“条件公开”。

### 问：我是不是该把整个 remote 命令组都重写？

答：不需要。当前最小有效切片就是这两条命令缺少边界注记。

### 问：我是不是只是在重复专题正文？

答：不是。专题证据已经有了，这轮的价值是把边界带回最上游命令索引。
