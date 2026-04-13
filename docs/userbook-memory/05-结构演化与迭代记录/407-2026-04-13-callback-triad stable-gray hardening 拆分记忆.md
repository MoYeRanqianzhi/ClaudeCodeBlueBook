# callback-triad stable-gray hardening 拆分记忆

## 本轮继续深入的核心判断

在当前 worktree 已经补完：

- `115`
  的 adapter-policy stable/conditional/gray hardening

之后，

当前更值钱的下一刀，

不是继续裂目录，

而是回到：

- `114-convertSDKMessage、useDirectConnect、stream_event 与 ignored：为什么 UI consumer 的三分法不是 callback surface 的镜像映射.md`

把它也补成和相邻成熟结构页一致的：

- `稳定可见`
- `条件公开`
- `内部/灰度层`

三层分账。

## 为什么这轮值得单独提交

### 判断一：当前最需要补的不是入口，而是 `114` 自己的合同厚度

读者现在已经能稳定走到：

- callback-visible
- adapter triad
- hook sink

这一层。

这时继续新增更细目录，

收益会低于直接把：

- triad != callback mirror
- triad 之后还有 hook-specific sink decision

这些判断的稳定层、条件层和灰度层写硬。

### 判断二：`114` 正好卡在“对象层”和“消费层”最容易混写的地方

`114` 当前最容易被误写成：

- callback-visible 对象被 adapter 只是换个显示名字

但它真正回答的是：

- callback-visible 是一层
- adapter triad 是一层
- hook sink 又是下一层

如果不把这三者按稳定合同、条件公开和内部灰度重新分账，

读者就会继续把：

- callback membership
- consumer classification
- actual sink

压成同一种“显示/过滤”问题。

### 判断三：这轮比继续裂 `114-115` 子家族更贴近“保护稳定功能和灰度功能”

这页最需要保住的稳定层是：

- triad != callback mirror

最需要降到条件或灰度层的是：

- 哪类 triad 结果会不会继续被别的 hook/UI 消费
- triad 是否已经穷尽所有 UI consumer 分类
- exact helper 顺序与 host wiring

这正是当前更值钱的工作：

- 保护稳定功能
- 隔离灰度功能

## 这轮具体怎么拆

这轮只做三件事：

1. 修改 `114-...callback surface 的镜像映射.md`
   - 把原来的“稳定证明 / 不能稳定证明”改写成
   - `稳定可见`
   - `条件公开`
   - `内部/灰度层`
2. 新增这条 `407` 记忆
   - 记录为什么这轮继续补正文合同厚度，而不是再裂目录
3. 更新 `memory/05 README`
   - 同步批次索引到新的 `407`

这样：

- `114`
  会和 `115`
  共享同一套分层口径
- callback-visible / triad / hook sink 这条线不再只停在“当前源码能不能证明”的旧式尾部
- 后面如果再继续补 `112` 或回 `100-104`，也有一条清晰模板

## 苏格拉底式自审

### 问：为什么这轮不是继续去做 `114-115` 子家族入口？

答：因为当前更稀缺的不是 findability，而是合同厚度。读者已经能找到这条线，缺的是如何不把 callback membership、triad 和 sink 再写平。

### 问：为什么这轮不是继续去做 `112`？

答：因为 `114` 现在仍保留旧式尾部，而 `115` 已经补完三层分账。先把这一对 callback/adpater 线的口径对齐，收益更高。

### 问：为什么这也算“优化相关目录结构”？

答：因为结构优化不只等于新增目录。当前明确停止继续裂目录，本身就是在保护层级职责，把入口层和合同层重新拉开。
