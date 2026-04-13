# replay-dedup branch hardening 拆分记忆

## 本轮继续深入的核心判断

在当前 worktree 已经把：

- `116`
- `117`

这条 direct-connect completion / init 可见性支线的 root page 先后拉回当前成熟口径之后，

这一支下一刀更值钱的，

不是继续新增结构入口，

也不是直接跳去 `119`，

而是回到：

- `118-convertUserTextMessages、sentUUIDsRef、fetchLatestEvents(anchor_to_latest)、pageToMessages 与 source-blind append：为什么 viewerOnly 的本地 echo 去重、history attach overlap 与 transcript 追加不是同一种 replay dedup.md`

把这张 replay/dedup 后继页，

从旧式的：

- 当前源码能稳定证明什么
- 当前源码不能稳定证明什么

抬升成：

- `稳定可见`
- `条件公开`
- `内部/灰度层`

三层口径。

## 为什么这轮值得单独提交

### 判断一：`118` 是 `117` 之后最直接的 replay/dedup 后继页，先补它比先补 `119` 更顺

`117`

先回答：

- same init object != same initialization visibility

而 `118`

接着回答：

- same replay duplication symptom != same dedup mechanism

这两页是同一条 direct-connect / viewer 支线里相邻的两步。

先补 `118`，

能把：

- init visibility
- replay visibility
- echo dedup
- overlap dedup

这条线继续按顺序压实。

### 判断二：当前更值钱的是把 replay/dedup 的分层对象写成稳定对象

这页最容易被误写成：

- viewerOnly 其实已经保证了通用 replay dedup

这轮真正要保住的稳定层是：

- same replay duplication symptom != same dedup mechanism

最需要降到条件或灰度层的是：

- attach/reconnect 是否一定带 backlog replay
- overlap 实际频率
- future build 是否会新增跨来源 dedup index
- `sentUUIDsRef` 与 transcript sink 的 exact host wiring

这比继续补新导航，

更直接服务于：

- 保护稳定功能
- 隔离灰度实现

### 判断三：这轮也在继续优化根页与后继页的术语一致性

当前明确不再给这一支再裂目录，

而是让：

- `116`
- `117`
- `118`

逐步共享同一套 stable / conditional / gray 口径。

这本身就是在减少这条支线里的术语漂移。

## 这轮具体怎么拆

这轮只做三件事：

1. 修改 `118-...replay dedup.md`
   - 把原来的“稳定证明 / 不能稳定证明”改写成
   - `稳定可见`
   - `条件公开`
   - `内部/灰度层`
2. 新增这条 `417` 记忆
   - 记录为什么这轮优先补 `118`，而不是去做 `110` 或 `119`
3. 更新 `memory/05 README`
   - 把最新批次索引推进到 `417`

## 苏格拉底式自审

### 问：为什么这轮不是先去做 `110`？

答：因为 `110` 当然仍有价值，但 `118` 属于 `116/117` 刚补完的这条支线，局部上下文更连续，补完后这条线的递进关系更稳。

### 问：为什么这轮不是直接去改 `119`？

答：因为 `119` 更像 loading lifecycle 的另一条 zoom；`118` 则是 `117` 之后最直接的 replay/dedup 后继页，顺序收益更高。

### 问：为什么这也算“优化相关目录结构”？

答：因为结构优化不只等于新增 README。当前让相邻根页与后继页共享同一套分层术语，本身就在降低支线里的口径漂移。
