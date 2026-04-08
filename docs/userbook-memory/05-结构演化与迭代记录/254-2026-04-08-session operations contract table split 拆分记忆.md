# session operations contract table split 拆分记忆

## 本轮继续深入的核心判断

在完成：

- session operations 顶层前门
- 专题层 route
- 专题页 scope guard

之后，

这条线当前真正还缺的不是：

- 新入口层
- 新专题正文

而是：

- 一张 session operations contract table

## 为什么这轮落点选 `03-参考索引/06`

### 判断一：这张表本质上是“高价值入口背后的运行时合同”，不是新问题域

`03-参考索引/06`

本来就在收：

- 高价值入口
- 背后的运行时合同

而 session operations 里的：

- `/copy`
- `/rename`
- `/export`
- `/branch`
- `/rewind`
- `/clear`

正是一组典型的：

- 用户高频会碰
- 且最容易被写平对象边界

的入口。

所以这轮应该：

- 在现有 `06`
  中补 session operations cluster

而不是：

- 新开参考索引页

## 为什么这轮不新建新的参考索引页

### 判断二：当前缺的是把已有长文专题压成速查对象，不是再长一层目录

这条线现在已经有：

- 顶层 README
- 专题层 route
- 专题正文 `07`

如果这时再新建一张：

- session-operations 专属参考索引

只会让读者重新判断：

- 它和 `03-参考索引/06`
  谁才是“入口合同页”

所以最小有效做法是：

- 在 `06`
  里补一组 session operations 表

## 为什么表头要收成“什么时候用 / 改写或外化的对象 / 不要误用成”

### 判断三：这条线最容易出错的不是按钮名，而是它到底在改写什么对象

`/copy`

不是：

- 正式外化

`/rename`

不是：

- UI 美化

`/export`

不是：

- continuity 替代品

`/branch`

不是：

- Git branch

`/rewind`

不是：

- Ctrl+Z / Git reset

`/clear`

不是：

- 轻量版 `/compact`

所以最小表头必须直接回答：

- 什么时候该用
- 它改写或外化的对象是什么
- 最容易被误用成什么

## 为什么这轮要把 continuity、discovery、viewer/host continuation 排除出主表

### 判断四：session operations 回答的是“当前工作对象怎样被运营”，不是 continuity、discovery 或 host/viewer continuation

这轮如果不把这些线排除掉，

表就会继续把：

- `/memory`
- `/compact`
- `/resume`

和：

- `/copy`
- `/rename`
- `/export`
- `/branch`
- `/rewind`
- `/clear`

写成同层对象。

所以速查页必须明确：

- continuity 主线仍属于 `02`
- discovery 主线仍属于 `12`
- `/session` 是 viewer 侧接续地址，只在 remote mode 下成立
- `/remote-control` 是 host 侧控制能力，属于条件/隐藏面
- `/tag` 仍是 ant-only / 内部边界提醒

## 为什么这轮不改 `07` 正文定义

### 判断五：当前问题在“速查压缩层”，不在长文专题定义层

`07`

正文已经把：

- `copy`
- `export`
- `branch`
- `rewind`
- `clear`

逐一解释清楚。

当前缺的不是：

- 再讲一遍它们是什么

而是：

- 让读者能在索引层一眼看出这些入口的对象分工

所以这轮只补：

- contract table

不改：

- 正文定义

## 主树状态记录

2026-04-08 在主仓库 `/home/mo/m/projects/cc/analysis` 再次执行：

- `git fetch origin main`
- `git rev-parse HEAD origin/main`
- `git pull --ff-only origin main`

返回：

- `HEAD = 9cb9fb702f5ea1590a16b15638d4c875284dabc2`
- `origin/main = 9cb9fb702f5ea1590a16b15638d4c875284dabc2`
- `git pull --ff-only origin main` 返回 `Already up to date.`

因此这一轮 contract table 开始前，主仓库已回到可安全同步状态。

## 苏格拉底式自审

### 问：我现在缺的是新的目录节点，还是缺把 session operations 压成一张一眼能扫的对象分工表？

答：如果入口链和专题正文都已存在，缺的是 contract table。

### 问：我是不是又想把 continuity、旧会话发现、viewer/host continuation 混进 session operations 主表？

答：如果这些线不被显式降为边界或排除项，表就会再次写平。

### 问：我是不是想继续重写正文，而不是在参考索引层做最小收口？

答：如果当前问题是速查不足，就不该把长文专题再写一遍。
