# 结构 Evidence Envelope反例：只看文件Diff、目录美观与作者记忆

这一章不再收集“结构本身设计错”的反例，而是收集结构证据被不同消费者拆散之后最常见的失真样本。

它主要回答五个问题：

1. 为什么结构升级明明已经有 authoritative surface、recovery asset 与 rollback object boundary，团队仍然会退回文件级回退与目录审美。
2. 为什么结构的 shared evidence envelope 最容易被拆成“文件 diff”“目录图”“评审心得”“作者记忆”四份材料。
3. 哪些坏解法最容易把源码先进性退回到静态美观和作者权威。
4. 怎样把这些坏解法改写回 Claude Code 式共享证据消费。
5. 怎样用苏格拉底式追问避免把这一章读成“作者偏好某种代码审美”。

## 0. 第一性原理

结构线最危险的，不是：

- 没有图

而是：

- 图很多、提交很多、总结很多，却没有一份 shared envelope 能让不同消费者围绕同一对象与同一回退边界判断

这样一来，系统虽然已经能描述：

- authoritative surface
- projection set
- recovery asset
- anti-zombie gate
- rollback object

团队却仍然回到：

- 改了哪些文件
- 目录是不是更清爽
- 作者说哪里危险

## 1. 只看文件 Diff vs rollback object boundary

### 坏解法

- 宿主、评审或交接先看文件 diff，默认结构升级的核心证据就是改了哪些文件、删了哪些模块、挪了哪些目录。

### 为什么坏

- 结构真相是按对象成立的，不是按文件成立的。
- 一个 session object、task object、bridge object 往往跨越多个文件和多个持久化资产。
- 只看文件 diff，会让回退重新退回文件级 rollback，而不是对象级 rollback。

### Claude Code 式正解

- 先写 rollback object boundary，再看文件 diff。
- 文件变更只作为执行痕迹，不能替代对象真相。

### 改写路径

1. 在结构 envelope 里固定 object type / object id / authority surface。
2. 文件 diff 只能挂在对象之后，不得反过来定义对象。
3. 评审与交接时禁止“只讲改了哪些文件，不讲回退哪个对象”。

## 2. 只看目录美观 vs authoritative surface

### 坏解法

- CI 或评审只看模块边界、目录层次、解耦程度，默认结构更清爽就更先进。

### 为什么坏

- 目录美观不等于真相收口。
- authoritative surface、projection set、写入口与读投影若没有同时明确，系统仍然会说谎。
- 团队会把结构进步误读成视觉整洁。

### Claude Code 式正解

- 先问 authority，再看目录。
- 目录只是说明方式，authority surface 才是结构真相。

### 改写路径

1. 任何结构评审单都先列 authoritative surface。
2. 目录图只能解释 authority，不得替代 authority。
3. 不再用“拆得更细”直接推断“结构更先进”。

## 3. 只看恢复成功率 vs recovery asset ledger

### 坏解法

- 宿主、CI 或评审只看 resume / reconnect 成功率，默认恢复指标不错就说明结构升级成立。

### 为什么坏

- 恢复成功率只说明“这次看起来恢复了”，不说明恢复资产是否清楚、stale writer 是否被拦住、旧对象是否可能复活。
- 如果没有 pointer、snapshot、replacement log、retained assets 的台账，恢复只会变成黑盒结果。

### Claude Code 式正解

- 恢复指标必须和 recovery asset ledger 一起消费。
- 只有既知道恢复结果，也知道靠哪些资产恢复，结构判断才成立。

### 改写路径

1. 在结构 envelope 里固定 recovery assets 栏。
2. 成功率后面必须挂 retained assets / dropped stale writers。
3. 任何“恢复成功但说不清靠什么恢复”的情况，都视为 envelope 失真。

## 4. 只靠作者记忆 vs retained assets / danger paths

### 坏解法

- 交接或评审遇到复杂结构时，默认去问作者：“哪里危险、哪里别碰、回退时注意什么。”

### 为什么坏

- 这会把 shared envelope 重新退回作者权威。
- retained assets、danger paths、anti-zombie gate、rollback boundary 全部被口头记忆替代。
- 作者一旦离开，结构真相就断裂。

### Claude Code 式正解

- 让 retained assets、danger paths、seam、rollback object 写进 envelope，而不是写在作者脑中。
- 作者说明只能补充，不得替代结构证据。

### 改写路径

1. 把最危险的路径写进 risk naming 与 retained assets。
2. 交接材料强制包含 rollback object 与 danger paths。
3. 禁止只靠“问作者”完成结构接手。

## 5. 分裂消费 vs shared structure envelope

### 坏解法

- 宿主看文件，CI 看指标，评审看结构图，交接听作者说明，默认四者合起来就等于结构证据。

### 为什么坏

- 四组材料描述的是同一升级的不同投影，却没有共享同一 authority / recovery / rollback 骨架。
- 它们各自都可能局部正确，却合不成同一份结构真相。
- 最终团队会重新退回“作者最懂”和“目录更好看”的判断模式。

### Claude Code 式正解

- 所有消费者先共享同一套结构 envelope：
  - authoritative surface
  - projection set
  - recovery asset
  - anti-zombie gate
  - rollback object boundary

### 改写路径

1. 为结构线固定 shared envelope header。
2. 宿主、CI、评审、交接都先消费这一 header。
3. 任何 consumer-specific 视图都不得替代 header 本体。

## 6. 苏格拉底式追问

在你读完这些反例后，先问自己：

1. 我现在消费的是对象级结构真相，还是只是在看文件和目录。
2. authoritative surface 与 recovery asset 是否已经点名。
3. retained assets 与 dropped stale writers 是否已经记录。
4. rollback object boundary 是否比文件 diff 更先被定义。
5. 我是在共享同一套结构证据骨架，还是在共享几份彼此相关但互不约束的材料。
