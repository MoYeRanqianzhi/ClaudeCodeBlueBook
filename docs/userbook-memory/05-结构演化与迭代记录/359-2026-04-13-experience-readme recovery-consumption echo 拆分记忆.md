# experience-readme recovery-consumption echo 拆分记忆

## 本轮继续深入的核心判断

在上一刀已经把：

- `01-运行时主链/README.md`

补成“这里只负责 `session truth / continuation contract`”之后，

这一轮最合适的对应切片，

不是去改更多深页，

而是给：

- `05-体验与入口/README.md`

补一句本地 echo，

把 `viewer continuation / preview / history`

正式钉成 consumption。

## 为什么这轮值得单独提交

### 判断一：当前缺的不是定义，而是体验 landing 页的接球句

上游总 README 现在已经写明：

- `viewer / preview / history consumption`
  不是 `formal restore`
  也不是 `current-truth signer`

而体验 README 也已经写到：

- `projection / readback / consumer`
- `无真相签发权`

所以当前最小有效修正，

不是补更多证明材料，

而是让体验 landing 页自己显式接住这条路由。

### 判断二：这一刀比去改 `03-Session 与 Remote-control` 或控制面深挖页更稳

下游页已经分别承担：

- `preview != formal restore`
- `history attach != live restore`
- `viewer != owner`

它们的问题不是没定义，

而是总 README 的横向路由在 child README 还差一个本地 echo。

所以这一刀只改体验层 landing 页，

收益高、重复低。

## 这轮具体怎么拆

这轮只做一件事：

1. 在 `05-体验与入口/README.md`
   现有的 routing bullets 后面，
   再补一句：
   - `viewer continuation / preview / history` 在这里都只算 consumption：不是 formal restore，也不是 current-truth signer

这样：

- 体验层不再只说“这是 projection / consumer”
- 也同时明确它不等于恢复本体
- `总 README -> 体验 landing 页 -> 下游证明页`
  的路由链条完成闭环

## 苏格拉底式自审

### 问：为什么不把这句写进 `03-Session 与 Remote-control` 更准确？

答：因为那样会把本应属于 landing README 的接球句继续下沉。当前缺的是入口层自己的拒收与转译，不是更深一层的细部证明。

### 问：为什么这句要同时写 `formal restore` 和 `current-truth signer`？

答：因为体验层最容易把这两类误读混在一起：一类把 consumption 误听成 restore，另一类把 viewer 误听成 signer。只写一半，入口护栏就还不够硬。

### 问：为什么这轮不再顺手改别的文件？

答：因为现在最稳的推进节奏已经很清楚：一刀一个 landing README echo。继续同时改多页，只会把当前结构收敛重新摊薄成并行重复维护。
