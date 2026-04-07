# ingress reading chain split 拆分记忆

## 本轮继续深入的核心判断

191-196 连续拆完之后，目录结构出现了一个新问题：

- 这六页已经不是并列碎页，但局部导航还只散落在 `00-阅读路径.md` 里

本轮要补的更窄一句是：

- 191-196 应被固定成一条从 reader boundary 到 local verdict ledger 的六层阅读链，且这一层结构导航不应继续挤压 `00-阅读路径.md`

## 为什么这轮必须单列

如果不单列，正文最容易在四种偷换里回卷：

- 把 191-196 当成六篇平行小文
- 把 195/196 这类下游细化误读成可独立脱离上游主句的零散技巧页
- 把 `00-阅读路径.md` 继续当作局部子系统的唯一导航页
- 为了弥补导航缺口，再造重复正文

这四种都会把：

- 局部结构
- 正文主语
- 任务入口

重新压扁。

## 本轮最关键的新判断

### 判断一：191 是 reader boundary，不是“细节之一”

### 判断二：192 是 continuity boundary，必须接在 191 后面

### 判断三：193/196 是 control leg 的一前一后两层

### 判断四：194/195 是 user leg 的一前一后两层

### 判断五：197 不是重复 00，而是子系统-local 的 anti-overlap map

## 苏格拉底式自审

### 问：为什么这页不是简单目录复制？

答：因为它回答的是“这些页为什么不能乱序读”，不是“点哪一页”。

### 问：为什么不继续只在 `00-阅读路径.md` 加路径？

答：因为 00 面向任务入口；191-196 这组已经形成局部子系统，需要自己的第二层导航。

### 问：为什么这页不该变成新的运行时正文？

答：因为它的职责不是再造合同，而是固定已有合同之间的阅读顺序和非重叠边界。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/197-handleIngressMessage、recentInboundUUIDs、onPermissionResponse、extractInboundMessageFields、resolveAndPrepend 与 pendingPermissionHandlers：为什么 bridge ingress 的 191-196 不是并列碎页，而是一条六层阅读链.md`
- `bluebook/userbook/03-参考索引/02-能力边界/186-handleIngressMessage、recentInboundUUIDs、onPermissionResponse、extractInboundMessageFields、resolveAndPrepend 与 pendingPermissionHandlers 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/197-2026-04-08-ingress reading chain split 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 长文层只补 197 这张结构收束页
- 索引层只补 186
- 记忆层只补 197

不回写 191-196 正文。

## 下一轮候选

1. 若继续 permission 面，可看 `cancelRequest(...)`、unsubscribe、queue recheck 之间的 race closeout contract，但必须避免回卷 196 的 ledger 主句。
2. 若继续结构层，可把 bridge ingress 阅读链再投影进更高层的功能面导航，但不能复制 197 的局部 anti-overlap map。
3. 若继续 transcript 面，可看 webhook sanitize 是否值得单列，但必须避免把 195 切成实现噪音。
