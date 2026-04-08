# root path-15 example scope cleanup 拆分记忆

## 本轮继续深入的核心判断

这一轮最值得收的，

不是改写根 `README` 里整条 root-vs-slash 的分流说明，

而是把：

- `路径 15`

示例里混进去的：

- `claude doctor`
- `/status`

拿掉。

## 为什么这轮值得单独提交

### 判断一：路径 15 讲的是“会外 root commands vs 会内面板”，不是“状态/诊断对象分层”

`00-阅读路径.md` 里：

- `路径 15`

明确服务的是：

- `claude auth` 与 `/login`
- `claude mcp` 与 `/mcp`
- `claude plugin` 与 `/plugin`

这类：

- 会外 root commands
- 会内面板

之间的对象分层。

但根 `README` 当前却把：

- `claude doctor`
- `/status`

也混在这组示例里。

这会让读者误以为：

- `doctor/status`

也该先按路径 15 去理解。

### 判断二：`doctor/status` 的更准确归宿其实已经在路径 16

`00-阅读路径.md` 里：

- `路径 16：我想分清 Settings tab、独立诊断屏、调参命令与预算分流`

已经明确覆盖：

- `/status`
- `/doctor`

以及相关状态 / 诊断 / 调参对象。

所以当前最小修正，

不是再给根页加一层新说明，

而是先把路径 15 例子里的错吸附拿掉。

## 这轮具体怎么拆

### 判断三：只删混层例子，不扩写到路径 16 handoff

这轮只做一件事：

1. 把根 `README` 里路径 15 的举例
   从：
   - `claude auth`、`claude mcp`、`claude plugin`、`claude doctor`
   - `/login`、`/mcp`、`/plugin`、`/status`
   收回到：
   - `claude auth`、`claude mcp`、`claude plugin`
   - `/login`、`/mcp`、`/plugin`

这样：

- 路径 15 的示例重新只覆盖它真正处理的对象族
- `doctor/status` 仍留给路径 16 去承接
- 改动保持在一句示例范围内

## 为什么这轮不顺手加一句“状态/诊断类看路径 16”

### 判断四：那会从“去错例”扩大成“重写整段分流文案”

当前最小有效切片只是：

- 把错误示例删掉

而不是同时：

- 再补一个新的 handoff

因为根页下面已经单独有：

- `运营长任务的状态、预算和模型节奏`

这组入口去承接状态 / 预算 / 模型对象。

如果这轮再往路径 15 旁边补路径 16，

就会把一个“去混层例子”的小修，

扩大成整段目标路由重写。

## 主树状态记录

2026-04-08 在主仓库 `/home/mo/m/projects/cc/analysis` 执行：

- `git fetch origin main`
- `git pull --ff-only origin main`

结果是：

- `pull` 成功：`Already up to date.`

因此本轮继续深入是在主树已同步的前提下，

仍只在：

- `.worktrees/userbook`

推进。

## 苏格拉底式自审

### 问：我是不是把“都和命令有关”误当成了“都该走同一条 root-vs-panel 路径”？

答：是。命令名字相近不等于对象问题相同。

### 问：如果 `/status` 和 `/doctor` 更像状态/诊断对象，为什么我还把它们塞进 `auth/mcp/plugin` 这一组示例？

答：因为我被“名字都像命令入口”这个表层相似性带偏了，没有先问路径 15 真正在拆哪一种对象边界。

### 问：我是不是应该把路径 15 和路径 16 在根页直接合写成一组？

答：不应该。当前要修的是示例范围，不是把两条路径再糊成一组。
