# suppress-reason split hardening 拆分记忆

## 本轮继续深入的核心判断

在当前 worktree 已经把：

- `108`
- `109`
- `116`
- `117`
- `118`
- `119`
- `120`
- `121`

这些相邻 root / branch page 依次拉回当前成熟口径之后，

当前更值钱的下一刀，

不是继续新增结构入口，

而是回到：

- `110-同样在过滤名单里，却不是同一种 suppress reason.md`

把这张 suppress-reason split 叶页，

从旧式的：

- 当前源码能稳定证明什么
- 当前源码不能稳定证明什么

抬升成：

- `稳定可见`
- `条件公开`
- `内部/灰度层`

三层口径。

## 为什么这轮值得单独提交

### 判断一：`110` 是 `108/109` 之后最直接的比较叶页，补完后 `105-110` 这条线更完整

`108`

先回答：

- callback consumer-path narrowing 不是 message existence denial

`109`

再回答：

- streamlined output 是 conditional pre-wire rewrite

而 `110`

正好把这两条线并到一起，回答：

- same callback exclusion
- different upstream provenance

如果这页继续停在旧尾部，

那 `105-110`

这条已被连续补厚的支线，

就会留下一个最显眼的“比较页仍旧口径”缺口。

### 判断二：当前更值钱的是把 “same callback exclusion, different upstream provenance” 写成稳定对象

这页最容易被误写成：

- manager 内部一定知道两种 family 的设计理由，并按显式分类器分支

这轮真正要保住的稳定层是：

- same callback exclusion, different upstream provenance

最需要降到条件或灰度层的是：

- 运行时是否一定会遇到两类对象
- manager 是否继续保留同样的 skip wiring
- callback 外是否还存在别的 pre-filter consumer
- manager 是否真按“理由分类器”执行

这比继续补新导航，

更直接服务于：

- 保护稳定功能
- 隔离灰度实现

### 判断三：这轮也在继续优化局部支线的术语一致性

当前明确不再给 `105-110` 再裂目录，

而是让：

- `105`
- `108`
- `109`
- `110`

继续共享 stable / conditional / gray 口径。

这本身就是在减少这条可见性支线里的术语漂移。

## 这轮具体怎么拆

这轮只做三件事：

1. 修改 `110-...suppress reason.md`
   - 把原来的“稳定证明 / 不能稳定证明”改写成
   - `稳定可见`
   - `条件公开`
   - `内部/灰度层`
2. 新增这条 `421` 记忆
   - 记录为什么这轮优先补 `110`，而不是继续去做新的结构入口
3. 更新 `memory/05 README`
   - 把最新批次索引推进到 `421`

## 苏格拉底式自审

### 问：为什么这轮不是继续沿 `117-121` 往下补？

答：因为那条 init/direct-connect 支线当前已经连续补到 `121`；相反，`105-110` 这条可见性支线还留下 `110` 这个最明显的旧尾部页。先把这一簇收齐，局部收益更高。

### 问：为什么这轮不是去做新的 hub？

答：因为当前瓶颈仍然不是入口缺口，而是叶页合同厚度。再补 README 只会重复导航，不会增加 suppress-reason split 的稳定边界。

### 问：为什么这也算“优化相关目录结构”？

答：因为结构优化不只等于新增 README。当前让同一支线的比较页与根页共享同一套分层术语，本身就在降低目录系统里的口径漂移。
