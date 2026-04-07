# ingress topic projection split 拆分记忆

## 本轮继续深入的核心判断

191-199 已经在 `05-控制面深挖` 形成稳定深线，

但从目录结构看还缺一层更高的用户目标投影：

- 这条线不应只停留在 `00-阅读路径` 与 `05`，还需要一个 `04-专题深潜` 的专题页，把远端接续、bridge ingress 输入注入与桥接审批分开

本轮要补的更窄一句是：

- `04-专题深潜` 需要一页面向用户目标的 bridge ingress 投影页，用来承接 “远端接续 / 输入注入 / 桥接审批为什么不是一件事”，而不是继续把局部导航压力堆到 `00-阅读路径.md`

## 为什么这轮必须单列

如果不单列，结构上最容易继续出现四种问题：

- 用户只能从 `00-阅读路径` 跳到 `05`，中间缺少用户目标层的承接页
- `06-前端与远程专题` 与 `16-IDE、Desktop、Mobile 与会话接续专题` 仍主要停留在 continuation / host / viewer，对 bridge ingress 深线没有稳定投影
- 191-199 这条深线只能被看成“控制面里的局部链”，而不容易回到真实使用目标
- 为了补这个缺口，又会继续往 `00-阅读路径` 堆更多路径

## 本轮最关键的新判断

### 判断一：197 是局部 anti-overlap map，不能替代 04 的用户目标页

### 判断二：06/16 讲的是 front-end continuation / host-viewer 分工，不等于 bridge ingress 深线

### 判断三：20 页的职责是把远端接续、输入注入与桥接审批在用户目标层拆开，而不是重复 05 的 runtime 句子

## 苏格拉底式自审

### 问：为什么这轮不是再补一篇 05 长文？

答：因为 05 的 deep-runtime 主句已经足够密集，当前缺的是目录结构上的上一层投影。

### 问：为什么不是只改 `00-阅读路径.md`？

答：因为 00 面向任务入口；这里缺的是一个可在 04 层反复复用的用户目标专题。

### 问：为什么 20 页不该复制 197？

答：197 回答“这几篇为什么要按顺序读”；20 回答“这个用户目标到底在分哪几层对象”。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/04-专题深潜/20-远端输入注入、桥接审批与会话接续专题.md`
- `docs/userbook-memory/05-结构演化与迭代记录/200-2026-04-08-ingress topic projection split 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/04-专题深潜/README.md`
- `bluebook/userbook/04-专题深潜/06-前端与远程专题.md`
- `bluebook/userbook/04-专题深潜/16-IDE、Desktop、Mobile 与会话接续专题.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

这轮不新增 03 速查页。

原因：

- 20 页本身就是 04 层的用户目标投影，不是新的能力边界速查对象。

## 下一轮候选

1. 若继续结构层，可把 20 页再投影进根 `README` 的更高层“按目标进入”分组，但不要把根 README 变成长导航页。
2. 若继续 permission 面，可看 sandbox network bridge 的 host-level sibling cleanup 与 tool-level closeout 是否值得单列。
3. 若后续 `webhookSanitizer` 源码可见，再重新评估 transcript 前处理线，不在当前缺源码状态下造页。
