# mainline-continuity preview-vs-restore echo 拆分记忆

## 本轮继续深入的核心判断

在：

- `158-...为什么 /resume 的 preview transcript 不是正式 session restore.md`

已经把 proof layer 做厚之后，

下一刀不该继续下沉到更多源码深页，

也不该横切去改：

- `03-Session 与 Remote-control：多宿主生命周期.md`

而应回到：

- `01-主线使用/04-会话、恢复、压缩与记忆.md`

补一句用户语言的本地 echo，

把 `preview/history != formal restore`

正式接进主线使用页。

## 为什么这轮值得单独提交

### 判断一：当前真正缺的是“用户默认工作流语言”的接球句

这条边界现在已经在三层被讲清：

- `158` 深页给了完整 proof
- `02-能力地图` 的 runtime / experience README 给了 handoff
- `05-体验与入口/README.md`
  已把 `viewer continuation / preview / history`
  定成 consumption

但用户真正顺着使用路径读到：

- `01-主线使用/04-会话、恢复、压缩与记忆.md`

时，

当前页还只排除了：

- `/rename`
- `/export`

这类邻近动作，

还没有把：

- `viewer / preview / history`

这组消费面明确踢出 continuity 本体。

### 判断二：这一刀比去改 `/session` 多宿主页更稳

并行只读分析有一个相邻候选：

- `02-能力地图/05-体验与入口/03-Session 与 Remote-control：多宿主生命周期.md`

但那一页的主轴是：

- `/session` vs `/remote-control`
- viewer/client vs bridge host

如果在那一页继续补“preview vs formal restore”，

就容易把：

- remote attach / viewer continuation
- local `/resume` ownership handoff

重新揉回同一层。

所以当前更稳的落点，

是用户侧 continuity 叶子页。

## 这轮具体怎么拆

这轮只做一件事：

1. 在 `01-主线使用/04-会话、恢复、压缩与记忆.md`
   的：
   - `这些命令不替你签继续资格`
   段末，
   增加一句：
   - `viewer / preview / history` 只是在消费恢复资产，能帮你看、找、挑候选，但不是 formal restore，也不能替 continuity 本体补签继续资格

这样：

- `158 -> 能力地图 echo -> 主线使用页`
  完成闭环
- 用户默认工作流不再把“看见旧 transcript”误听成“runtime 已经接回旧现场”
- 主线页也不需要引入更多源码细节

## 苏格拉底式自审

### 问：为什么不把 `switchSession()`、`adoptResumedSessionFile()` 这类关键词直接写进主线页？

答：因为那会让主线页过度源码化。这里最值钱的是把边界翻译成用户工作流语言，而不是重复 proof layer 的证据链。

### 问：为什么这句要放在“这些命令不替你签继续资格”段落里？

答：因为它和 `/compact / /resume / /memory / /export` 共享同一个判断轴：谁只是 continuity consumer，谁不能补签继续资格。放在这里最稳，也最短。

### 问：为什么不继续改更多页，把 `preview/history` 一次对齐完？

答：因为这条线现在已经从 proof layer 到 landing README 基本齐了。当前缺的是主线使用页的一声回音，而不是新一轮多页同步措辞。
