# 133-138 remote three-branch split 拆分记忆

## 本轮继续深入的核心判断

`133-138` 还不能被写成：

- 一条从 metadata、bridge、direct connect 一路排到 `activeRemote` 的线性 remote 六连页

更准确的结构是：

- `133 -> 137` = schema/store 到 cross-frontend consumer path 这一条线
- `134 -> 136` = bridge consumer chain 到 v2 active surface split 这一条线
- `135 -> 138` = foreground remote runtime 到 shared interaction shell 这一条线

所以这轮最该补的是：

- 一张新的 `05` 局部结构页，把 `133-138` 收成三条两步后继线
- 一张新的 `03` 索引页，把 `133/137`、`134/136`、`135/138` 的分工钉死
- 一条新的持久化记忆，记录为什么这轮不直接去重写 `204`

## 为什么这轮不直接去细化 `204`

### 判断一：`204` 处理的是更大的 `132/135/138/141/142/143` 分叉图

`204` 已经在回答：

- `132` 是 front-state consumer topology 根页
- `135` 是 foreground remote runtime
- `138` 是 shared interaction shell
- 再从这里继续分叉到 `141/142/143`

如果这轮直接改 `204`，

就会把：

- `133/137`
- `134/136`

这两条局部后继线

硬塞进更大的总图里，

反而损失了阅读清晰度。

### 判断二：`133/137` 与 `134/136` 更像 `132` 下的局部 zoom，不是 `204` 主干上的并列根

这轮最值钱的结构句是：

- `133/137` 在保护 “formal state / metadata 不等于当前 CLI foreground consumer”
- `134/136` 在保护 “bridge chain depth 不等于 same active surface”

它们都很重要，

但都没有像 `135`、`138` 那样继续把问题送到：

- presence ledger
- gray runtime
- global remote bit

因此更稳的做法是先在 `132` 和 `204` 之间补一张局部结构页，

而不是提前重写大图。

## 为什么这轮的三条线最稳

### 判断三：`133 -> 137` 是一条 consumer boundary 线

`133` 先拆：

- schema/type
- worker store
- local restore
- foreground consumer

`137` 再继续追问：

- 注释里的 frontend 到底是不是当前 CLI foreground
- `post_turn_summary/task_summary/pending_action.input` 为什么更像跨前端 consumer path

所以这条线的主语一直没变：

- consumer boundary

但这轮还要补一句更精确的保护句：

- `133` 不只是这条线的根页，它还给 `134` 的 bridge 子树提供判读闸门

也就是：

- 先问 schema/store/restore/foreground reader 是不是同一层
- 再问 bridge v1/v2 的 chain depth 到底分裂在哪

### 判断四：`134 -> 136` 是一条 bridge chain depth 线

`134` 先拆：

- v1 local surface 仍在
- v2 才真正接上 worker-side state / delivery chain

`136` 再继续拆：

- 即便同属 v2
- full env-less / mirror / outboundOnly 也不是同一种 active front-state surface

所以这条线的主语也一直没变：

- bridge chain split

### 判断五：`135 -> 138` 是一条 runtime 到 shell 的线

`135` 先把 direct connect 固定成：

- foreground remote runtime

`138` 再把 REPL 顶层固定成：

- shared interaction shell

而不是：

- shared remote presence ledger

所以这条线会自然接到 `204` 后面的：

- `141`
- `142`
- `143`

## 本轮最关键的新判断

### 判断六：`138` 是这组三线里真正的交接点

本轮最该保护的一句不是：

- `138` 只是 `135` 的附录

而是：

- `138` 是从局部结构页继续走到 `204` 大图的交接点

这能避免后面把：

- `141`
- `142`
- `143`

误写成 `132` 的直接平行叶页。

### 判断七：这轮不需要再下沉到 `04-专题深潜`

这轮主语仍然是：

- consumer boundary
- bridge chain depth
- interaction shell

它们还属于结构层，不是新的用户症状层。

因此这轮最稳的最小改动面仍然是：

- `05 + 03 + memory + README/阅读路径`

而不是再把 `04` 专题页拉宽。

### 判断八：本轮起笔前的主工作树状态已再次确认

本轮开始前已核对：

- `git fetch origin`
- `git rev-list --left-right --count HEAD...origin/main` = `0 0`
- `/home/mo/m/projects/cc/analysis` 上 `merge --ff-only origin/main` = `Already up to date.`
- 主树 `status` 为 `## main...origin/main`
- `userbook` worktree 起笔时为 `## userbook`

所以本轮继续只在：

- `.worktrees/userbook`

里推进，不触碰主树与其他 worktree。

### 判断九：`pending_action/task_summary/post_turn_summary` 当前不能并作同档证据

这轮还要记住：

- `pending_action` 在当前树里有明确 producer
- `task_summary` 更多是语义与清理证据，正向写入证据更弱
- `post_turn_summary` 更多是 schema / wide-wire 与 foreground narrowing 证据

所以 133/137 相关正文里，

不能再把这三者压成一句：

- “都已经 producer/store 落地，只差 UI”

## 苏格拉底式自审

### 问：我现在写的是 formal state、bridge chain，还是 runtime shell？

答：如果一句话不能先回答自己属于哪条两步后继线，就不要落字。

### 问：我是不是把 `133/137` 和 `134/136` 混成了同一种 bridge / metadata 细节？

答：先问它保护的是 consumer boundary，还是 chain depth。

### 问：我是不是想一步跳去改 `204`？

答：先追问当前页是不是已经能自然接到 `141/142/143`；如果不能，它就还只是局部 zoom。

### 问：我是不是把 `138` 当成了普通尾页？

答：如果一句话没有指出它是 shared interaction shell 与 `204` 的交接点，就还没真正抓住本轮最值钱的结构关系。
