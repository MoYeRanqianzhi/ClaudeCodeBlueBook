# long-task continuity contract table split 拆分记忆

## 本轮继续深入的核心判断

在完成：

- 顶层入口
- 专题层 first-hop
- 阅读路径层 dedicated path

之后，

`long-task continuity`

这条线当前真正还缺的不是：

- 再补正文
- 再开目录层入口

而是：

- 一张可直接扫读的 continuity contract table

## 为什么这轮落点选 `03-参考索引/06`

### 判断一：`03-参考索引/06` 本来就在收“高价值入口背后的运行时合同”

这页当前已经覆盖：

- `/commit`
- `/commit-push-pr`
- `/review`
- `/status`
- `/doctor`
- `/usage`
- `/add-dir`
- `/session`
- `/remote-control`
- `/tasks`

也就是：

- 用户会高频调用
- 且背后带着强对象边界

的一组入口。

continuity 里的：

- `/memory`
- `/compact`
- `/resume`

完全符合这个落点规则。

所以这轮应当：

- 在 `03-参考索引/06`
  里补 continuity section

而不是：

- 另起一张平行索引页

## 为什么不新建 continuity 参考索引页

### 判断二：当前缺的是“把已成形主线压成速查对象”，不是“再长出一个目录节点”

continuity 线现在已经有：

- 主线页
- 专题页
- 路径页

如果再新建一张：

- `03-参考索引/07-...`

会带来：

- 目录再膨胀
- 新页还要再接目录索引
- 读者要重新判断这页和 `06` 谁才是“高价值入口合同页”

所以这轮最小有效做法是：

- 扩 `06`

不是：

- 再造 sibling page

## 为什么 `05-任务到入口速查矩阵` 不足以承接这一刀

### 判断三：矩阵解决“先用哪个入口”，合同表解决“这些入口各自延续什么对象”

`03-参考索引/05`

已经有三行：

- 管理记忆
- 压缩上下文
- 恢复旧会话

但那张矩阵只有：

- 用户目标
- 首选入口
- 次选入口
- 稳定性

它不能充分回答：

- 当前工作对象如何继续
- 过去工作对象如何被找到
- 身份补强与外化为什么不等于 continuity 本身

所以 continuity 这轮需要的不是再加一行矩阵，

而是：

- 一张对象分工表

## 为什么表头要收成“真正延续的对象 / 更像什么 / 不是什么”

### 判断四：continuity 最容易被写平的是对象主语，不是按钮名

这条线最常见的误判不是：

- 不知道按钮叫啥

而是：

- 把 `/resume` 当历史搜索
- 把 `/compact` 当清屏
- 把 `/export` 当 continuity 替代品
- 把 `/rename` 当纯 UI 美化

所以表头不该再重复：

- 稳定性
- 长篇运行时细节

而应直接回答：

- 这个入口到底在延续什么对象
- 它更像哪类动作
- 它不是什么

## 为什么这轮不复写正文里的稳定面 / 条件面合同

### 判断五：当前问题在索引抽象层，不在能力合同本体

`02-连续性与记忆专题`

已经把：

- `/context`
- `/files`
- `/memory`
- `/compact`
- `/resume`
- `/rename`
- `/export`

和：

- `/tag`
- 自动 session memory
- 某些 reactive compact / cached microcompact 分支
- 远程环境中的恢复补写逻辑

分成：

- 稳定面
- 条件或内部面

`12-会话发现、历史检索与恢复选择专题`

也已经把：

- `/resume`
- resume picker
- custom title 搜索
- 同 repo worktree 感知
- prompt 历史检索

与：

- ant-only `/tag`
- 跨目录手动恢复命令路径
- sidechain、team 等非普通恢复主线

拆开了。

这说明正文合同并没有缺位。

所以这轮只该：

- 在速查层压对象分工

不该：

- 把正文合同重写一遍

### 判断六：速查表仍要保留默认/条件限定词，不能把正文里的边界抹平

这轮虽然不复写正文合同，

但也不能把表写成：

- 无前提的能力名词表

所以速查页仍需明确：

- 这张表覆盖的是普通用户、默认宿主、当前工作树里的 continuity 稳定主线
- `/resume` 默认是同 repo worktree-aware，跨目录必要时只给恢复命令
- prompt history 与 session history 是两本账
- `/tag` 仍是 ant-only / 内部能力，不应混进普通用户 continuity 主干

## 主树状态记录

2026-04-08 在主仓库 `/home/mo/m/projects/cc/analysis` 执行：

- `git fetch origin main`
- `git rev-parse HEAD origin/main`

返回：

- `HEAD = 6dc2cdb43beb03b5d5e6e7acaf09455d4d095aae`
- `origin/main = 6dc2cdb43beb03b5d5e6e7acaf09455d4d095aae`

所以本轮继续推进 continuity contract table 前，主分支仍与远端一致。

随后本轮继续只在：

- `.worktrees/userbook`

推进 continuity 的速查收口。

## 苏格拉底式自审

### 问：我现在缺的是再讲一次正文，还是缺把这条线压成一张能直接扫的对象分工表？

答：如果主线、专题、路径都已存在，缺的是 contract table。

### 问：我是不是想再造一个 continuity 索引页，而没有先检验 `03-参考索引/06` 能不能承接？

答：如果现有 `06` 已经是高价值入口合同页，就不该无端再长目录节点。

### 问：我是不是又想把稳定/条件边界合同抄进速查页，结果把表做成正文缩写？

答：如果速查页开始复制正文，说明这一刀已经偏离“最小有效收口”。
