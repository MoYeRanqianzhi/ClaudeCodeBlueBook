# session remote-control front-door split 拆分记忆

## 本轮继续深入的核心判断

在已经连续清理：

- 任务矩阵里的伪 fallback
- hub README 的前门层级
- 能力地图与控制面入口的说明歧义

之后，

`03-参考索引/06-高价值入口运行时合同速查.md`

里最值得优先补的，

不是再扩 `/session` 或 `/remote-control` 的深合同，

而是把多前端组中那段匿名比较块重新补回主语。

## 为什么这轮落点选 `03-参考索引/06`

### 判断一：如果比较块没有名字，读者就会先在 first-hop 处丢掉对象分诊

在：

- `## /ide、/desktop、/mobile、/session 与 /remote-control`

这一组里，

`/ide`

`/desktop`

`/mobile`

都有明确子标题，

但紧接着比较 `/session` 与 `/remote-control` 的一段，

却直接从：

- `真正用户目标`
- `隐藏运行时合同`
- `最常见误用`

起笔，

没有：

- `### /session 与 /remote-control`

这样的主语标题。

这会让读者在 first-hop 处先失去：

- 这是比较块
- 这是两个不同对象

这两个最关键判断。

## 为什么这不是“只差一个标题”这么简单

### 判断二：匿名块会把 `/mobile`、`/session` 与 `/remote-control` 压成同一条跨端继续链

匿名块正好跟在：

- `/mobile`

之后。

如果没有显式主语，

读者很容易把这段误读成：

- `/mobile` 的续写
- 或者另一段泛化的“跨设备继续工作”说明

于是：

- `/session` 的 viewer 侧接续
- `/remote-control` 的 host 侧桥接

这两个本来就不该压平的对象，

会在索引层先被压成同一类入口。

## 为什么这轮不顺手重排根 README 的能力地图入口层

### 判断三：根 README 的入口降层是另一个可独立提交的 front-door slice，不该和这轮匿名比较块修复混在一起

并行分析里确实也出现了另一个候选：

- 把 `02-能力地图/README.md` 从根层 first-hop 并列入口降到 second-hop

这个方向有价值，

但它处理的是：

- 根层入口分层

而这轮更直接阻断读者理解的，

是：

- 同一页内部先出现无主语比较块，后文又分别出现 `/session` 与 `/remote-control` 单项合同

所以这轮只做：

- 给比较块补回显式主语
- 明确它只是第一跳分诊
- 保留文后单项合同不动

让提交边界保持单一。

## 主树状态记录

2026-04-08 在主仓库 `/home/mo/m/projects/cc/analysis` 执行：

- `git fetch origin main`
- `git pull --ff-only origin main`
- `git rev-parse HEAD origin/main`
- `git status --short --branch`

结果是：

- `pull` 成功：`Already up to date.`
- `HEAD = 14c35307967740992aecb66f821b74a5d86efa7e`
- `origin/main = 14c35307967740992aecb66f821b74a5d86efa7e`
- 主仓库状态：`## main...origin/main`

因此本轮继续深入仍只在：

- `.worktrees/userbook`

落笔，但主树同步状态本轮末已经核实为最新。

## 苏格拉底式自审

### 问：我现在缺的是再补 `/session` 和 `/remote-control` 的正文细节，还是先把比较块的主语补回来？

答：如果 first-hop 处分诊已经失焦，再多写正文也会被匿名块抵消。

### 问：我是不是把“跨端继续工作”这个表象误当成了单一对象？

答：如果不显式写出 viewer continuation 与 host bridge 的差异，就还是在压平对象。

### 问：我是不是又因为发现另一个可改的 hub 问题，就把本轮最直接的读者绊脚点拖成多文件 churn？

答：能力地图入口层可以另起一刀；当前更应该先把同页内部的匿名比较块修正掉。
