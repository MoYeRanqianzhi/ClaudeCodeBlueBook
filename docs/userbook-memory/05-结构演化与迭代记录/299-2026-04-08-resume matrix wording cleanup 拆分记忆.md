# resume matrix wording cleanup 拆分记忆

## 本轮继续深入的核心判断

这轮最值得先收的，

不是再扩 continuity 正文，

而是把任务矩阵里：

- `/resume`

的用户目标表述从“旧会话”拉回“同一工作对象”。

## 为什么这轮落点选 `03-参考索引/05-任务到入口速查矩阵.md`

### 判断一：矩阵这一行仍在把主语重新拉回“旧 session 本身”

近期多轮修正已经把 `/resume` 收成：

- continuity 本体
- 重新接回同一工作对象
- 与 session discovery / resume picker 分层

但任务矩阵里，

`/resume`

这一行的用户目标仍写成：

- 恢复旧会话

这会让读者在最短速查层先吸收成：

- `/resume` 的主语是旧 session 本身

而不是：

- 当前工作对象如何重新回到可继续现场

这和合同页、主线页、专题页已经形成的口径不一致。

## 为什么这轮不顺手再改“次选入口”

### 判断二：当前最小有效切片只是一行用户目标，不需要扩成整行重写

这一行的：

- 次选入口 `手工找 session 文件`

虽然也偏向 session discovery 语感，

但这轮最直接、最小的对象边界残留仍是：

- 用户目标写成“恢复旧会话”

所以先把主语修正成：

- 接回同一工作对象

即可。

如果后面还要继续细化，

再单独处理次选入口的语义层次。

## 这轮具体怎么拆

### 判断三：只改目标栏位，不改稳定性和次选入口

这轮只把：

- `恢复旧会话`

改成：

- `接回同一工作对象`

其余栏位不动，

保持矩阵压缩度，

同时把最关键的对象主语纠正回来。

## 为什么这轮不联动其它 continuity 页面

### 判断四：其它层已经对齐，这轮只补矩阵最后一条 wording 残留

当前已经对齐的层包括：

- 主线使用页
- continuity 专题
- 运行时合同速查
- 命令索引

这轮剩下的明显残留只在：

- 任务矩阵的一行文案

所以这轮只补它。

## 主树状态记录

2026-04-08 在主仓库 `/home/mo/m/projects/cc/analysis` 执行：

- `git fetch origin main`
- `git pull --ff-only origin main`
- `git rev-parse HEAD origin/main`
- `git status --short --branch`

结果是：

- `pull` 失败：`Pulling is not possible because you have unmerged files.`
- `HEAD = 972710438969878ee81241448a9d4b0e5789ccb3`
- `origin/main = 14c35307967740992aecb66f821b74a5d86efa7e`
- 主仓库状态：`## main...origin/main [ahead 10]`
- 且存在未解决冲突，例如：
  - `UU bluebook/userbook/01-主线使用/04-会话、恢复、压缩与记忆.md`
  - `UU bluebook/userbook/03-参考索引/06-高价值入口运行时合同速查.md`
  - `UU bluebook/userbook/README.md`

因此本轮继续深入仍继续只在：

- `.worktrees/userbook`

推进，不触碰主仓库冲突。

## 苏格拉底式自审

### 问：我是不是把“恢复旧会话”误当成了 `/resume` 的最稳用户心智？

答：如果系统已经把“找回会话”和“接回工作对象”分开，这个表述就太粗了。

### 问：我是不是因为矩阵追求短句，就允许它回退到更模糊的 session 主语？

答：短句可以短，但不能短到把对象写错。

### 问：我是不是又想把这一行的次选入口、稳定性和对象列一起全部重写？

答：这轮最小有效切片只是一行目标主语，不需要扩大。
