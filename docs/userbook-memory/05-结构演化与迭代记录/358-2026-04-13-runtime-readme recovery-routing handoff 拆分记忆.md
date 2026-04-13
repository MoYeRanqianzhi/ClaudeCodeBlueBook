# runtime-readme recovery-routing handoff 拆分记忆

## 本轮继续深入的核心判断

在上一刀已经把：

- `03-治理与边界/README.md`

钉成“这里判 continuation pricing，不判恢复对象本身”之后，

下一刀不该再横向去碰体验层，

而应把：

- `01-运行时主链/README.md`

也补上一句最小 handoff，

让 recovery routing axis 在 runtime landing 页真正落地。

## 为什么这轮值得单独提交

### 判断一：当前最缺的是 runtime landing 页对“谁不归我判”的显式拒收

总 README 现在已经能把：

- `resume / compact / memory`
  路由进运行时主链
- `viewer / preview / history`
  路由进体验层
- `这次继续是否仍被允许`
  路由进治理层

但落到：

- `01-运行时主链/README.md`

之后，

当前文本还只有：

- `projection != signer`
- `continuity contract`

它还缺一条最小否定句，

把两类最容易混进来的问题直接踢出去：

- `governance verdict`
- `viewer / preview / history` 这类 consumption

### 判断二：这刀比直接改体验层更稳

并行只读分析给出的排序是：

1. 治理 README
2. runtime README
3. 体验 README

治理 README 已在上一刀补齐。

而体验 README 本身已经有：

- `projection / readback / consumer`
- `无真相签发权`

所以当前更硬的缺口，

是 runtime README 还没把“不判 governance、也不管 viewer consumption”说成一句落地的入口拒收句。

## 这轮具体怎么拆

这轮只做一件事：

1. 在 `01-运行时主链/README.md`
   现有的：
   - continuity 是 `session truth -> continuation` 的时间轴合同
   后面，
   再补一句：
   - 这一层只负责 `session truth / continuation contract`，不代签 `governance` verdict，也不负责 `viewer / preview / history` 这类 projection consumption

这样：

- runtime landing 页不再像一张泛机制目录
- recovery routing axis 在总 README 与 child README 之间闭环
- `truth / continue / govern / consume`
  四种问题不再继续在入口页混层

## 苏格拉底式自审

### 问：为什么不把这句写回 `02-能力地图/README.md` 就够了？

答：因为总 README 已经负责横向路由。现在缺的是 child README 自己接球时，能不能一眼拒收不属于本页的问题。

### 问：为什么不和体验页一起改，形成成对 echo？

答：因为那会把“一刀一个 handoff”重新扩成双页并改。当前最稳的是先补 runtime landing 页，下一轮再决定是否需要给体验层补对应 echo。

### 问：这句为什么一定要把 `governance` 和 `viewer consumption` 一起排除？

答：因为这两类正好是 runtime landing 页最常见的串层来源：前者会把 continue contract 误听成 verdict，后者会把 projection consumption 误听成 restore 本体。
