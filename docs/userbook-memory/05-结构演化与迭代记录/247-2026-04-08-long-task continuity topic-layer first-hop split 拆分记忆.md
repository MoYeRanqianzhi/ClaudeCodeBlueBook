# long-task continuity topic-layer first-hop split 拆分记忆

## 本轮继续深入的核心判断

`long-task continuity`

也就是：

- `/memory`
- `/compact`
- `/resume`

这条线现在已经有：

- 顶层 README 的独立目标入口
- `01-主线使用/04`
- `04-专题深潜/02`
- `04-专题深潜/12`

当前真正还缺的不是：

- 先发明一条新路径
- 重写 continuity 正文
- 把 session discovery 正文再扩一遍

而是：

- 专题层 first-hop

也就是：

- `04-专题深潜/README`

还没有把这条线抬到和 safe action-radius、启动入口分层、settings 分流、extension 运维同级。

## 为什么这轮该补专题层入口

### 判断一：`04-专题深潜/README` 已经承担“高频复杂工作 first-hop”职责

这页前面已经显式抬了：

- `安全放大工作面`
- `多前端接续与条件远端`
- `启动时决定什么，进会话后决定什么`
- `status/doctor/usage/config/model/effort` 的对象分流
- `extension operations`

说明这页不是：

- 纯专题目录

而是：

- 高频复杂工作的 first-hop router

既然 continuity 这条线也已经具备：

- 顶层独立入口
- 主线页
- 专题主文

它就应该在专题层得到同级 first-hop。

## 为什么专题层入口应先去主线 04，再去专题 02

### 判断二：专题层用户先需要动作判断，再需要对象边界

`01-主线使用/04`

更擅长回答：

- `/memory`
- `/compact`
- `/resume`

什么时候该用。

`04-专题深潜/02`

更擅长回答：

- 这些能力各自延续什么对象
- 为什么 compact 不是清屏
- 为什么 resume 不是聊天记录搜索

所以专题层 first-hop 更稳的顺序应当是：

- 先去主线 04
- 再去专题 02

而不是直接把用户一脚踢进 deeper object semantics。

## 为什么这轮要把 continuity 与 session discovery 显式拆开

### 判断三：continuity 关注的是当前工作对象如何继续，session discovery 关注的是过去工作对象如何被找到

`04-专题深潜/12`

回答的是：

- 以前的工作在哪里
- 该恢复哪个会话
- 该直接接回还是只借旧内容

它不等于：

- 记忆层管理
- 长任务压缩
- 当前工作态的续接

如果专题层入口不把这两条线拆开，

用户就会继续把：

- `/memory`
- `/compact`
- `/resume`

误听成：

- “历史会话功能”

## 为什么这轮先不动阅读路径

### 判断四：先补专题层物理入口，再判断是否需要路径层排序

当前 `00-阅读路径`

里并没有一条专门把：

- `/memory`
- `/compact`
- `/resume`

压成稳定阅读顺序的路径。

但在继续开路径号之前，更小也更确定的缺口仍然是：

- 专题层 first-hop

所以这轮只补：

- `04-专题深潜/README`

路径层是否需要继续开：

- continuity dedicated path

应留到这轮提交之后再判断。

## 主树状态记录

2026-04-08 在主仓库 `/home/mo/m/projects/cc/analysis` 执行：

- `git pull --ff-only origin main`

实际返回：

- `There are no candidates for merging among the refs that you just fetched.`

随后进一步核对：

- 当前分支是 `main`
- `HEAD` 与 `origin/main` 同为 `6dc2cdb43beb03b5d5e6e7acaf09455d4d095aae`

所以本轮可确认主分支事实上仍与远端一致。

随后本轮继续只在：

- `.worktrees/userbook`

推进 long-task continuity 的专题层 first-hop。

## 苏格拉底式自审

### 问：我现在缺的是新路径号，还是缺专题层先把这条高频连续性主线抬出来？

答：如果顶层和正文已齐，先缺的是专题层 first-hop。

### 问：我是不是又把 continuity 误压成了“旧会话怎么找回来”？

答：只要不把 `12-会话发现、历史检索与恢复选择专题` 单独拆出来，这个误判就会复发。

### 问：我是不是想直接把用户扔进 continuity 专题，而跳过主线页对动作时机的解释？

答：如果 first-hop 不先去主线 04，用户会更难建立“什么时候该用哪条手段”的判断。
