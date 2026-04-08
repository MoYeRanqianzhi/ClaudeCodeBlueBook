# headless print completion-init-attach pair map split 拆分记忆

## 本轮继续深入的核心判断

`116-121` 不该继续被读成：

- 一条从 callback / UI consumer 往后顺排的线性后续链

更准确的结构是三组相邻配对：

- `116 / 119` = completion / waiting 配对
- `117 / 120` = `system.init` 双轴配对
- `118 / 121` = attach / replay 配对

所以这轮最该补的是：

- 一张只覆盖 `116-121` 的 `05` 配对结构页
- 一张对应 `105-110` 索引的 `03` 速查入口
- 一条新的持久化记忆，把“线性后续页”这层误判钉死

## 为什么这轮不能写成父子链

### 判断一：116 和 119 不是普通父子

116 在拆：

- visible outcome
- turn-end classifier
- busy-state transition

119 继续拆的却只是：

- busy-state 自己内部的 start / pause / resume / release / teardown edge

所以更稳的是：

- completion / waiting 配对

不是：

- `116 -> 119` 叶页链

### 判断二：117 和 120 是 `system.init` 的两张正交表

117 处理：

- 谁看见它
- 谁消费它

120 处理：

- 它有多厚
- 宿主怎样裁剪

所以更稳的是：

- `system.init` visibility × thickness 双轴

不是：

- `117 -> 120` 线性继续下钻

### 判断三：118 和 121 已经进入 attach / replay 主题

118 的主语是：

- history latest page
- live stream
- local echo
- source-blind sink

121 的主语是：

- transcript replay
- live bootstrap restore

它们都和 attach 恢复有关，

但也不是普通父子。

更稳的是：

- attach / replay 配对

不是：

- replay 父页 + restore 叶页

## 本轮最关键的新判断

### 判断四：这一组六页最该保护的是“主语分裂”，不是编号顺序

稳定层应先写：

- `result` / loading 不是同一种 completion contract
- `system.init` 的 visibility 与 thickness 不是同一轴
- attach 后的 transcript restore 与 bootstrap restore 不是同一种恢复

而不是先写：

- 第 116 页后面自然接第 117 页

### 判断五：同一个 object / bool / adapter 不等于同一种控制语义

本轮最值钱的三句稳定主干是：

- success `result` 静默不等于它不参与 turn-end 或 busy-state 收口
- transcript init banner 不等于 full init metadata，也不等于 bootstrap effect
- history replay 和 live append 共用 `convertSDKMessage(...)`，不等于共用 dedup / restore contract

### 判断六：必须继续保护稳定合同与灰度实现

稳定层可保：

- `result` 是 public SDK union 成员
- `system.init` 是 public SDK metadata object
- history hook 当前只做 replay，live hook 才做 raw init bootstrap
- direct connect / SSH 至少共享“同一 loading flag 承载多 edge”的宿主家族形状

灰度层应降级：

- success `result` 当前静默
- `isSessionEndMessage(...)` 当前只按 `msg.type === 'result'`
- `tengu_bridge_system_init`
- bridge redaction 的具体字段
- `messaging_socket_path`
- history/live 是否真的重叠
- attach 后 live init 是否一定再次到达

## 苏格拉底式自审

### 问：我现在写的是哪一组配对？

答：先强制归类到：

- completion / waiting
- `system.init`
- attach / replay

没有先归类，就不要继续落字。

### 问：我是不是又把“同一个符号”写成了“同一种语义”？

答：如果一句话依赖：

- 同一个 `result`
- 同一个 `setIsLoading`
- 同一个 `system.init`
- 同一个 `convertSDKMessage(...)`

就要追问它是不是其实跨了不同层。

### 问：我是不是又把当前 host wiring 写成了稳定公共合同？

答：凡是依赖：

- gate 名
- exact helper 名
- once-per-turn dedupe
- hidden field
- backlog / overlap 假设

都必须先降级。

### 问：为什么这轮不新开单独 `04` 专题页？

答：这轮核心仍然是修正 `05/03` 的结构主语；`04` 只需把 attach / session continuation 的症状投影到现有专题页即可，不值得另起新专题。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/211-completion signal、system.init dual-axis、history attach restore 与 loading edge：为什么 116、117、118、119、120、121 不是线性后续页，而是三组相邻配对分叉.md`
- `bluebook/userbook/03-参考索引/02-能力边界/198-Headless print completion-init-attach pair map 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/213-2026-04-08-headless print completion-init-attach pair map split 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/04-专题深潜/16-IDE、Desktop、Mobile 与会话接续专题.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 补 `05` 配对结构页
- 补 `03` 速查索引
- 不新增 `04` 专题页，只在既有 session continuation 专题补投影入口
- 不回写 116-121 旧正文

## 下一轮候选

1. 若继续这一簇，可把 `122-127` 收成 `remote recovery / viewer ownership / recovery signer / surface dashboard` 的后继结构页。
2. 若继续用户症状入口，可把 attach 后“看见 banner 但命令面未恢复”的症状继续投影到 `04-16` 或相邻专题。
3. 若继续保护稳定/灰度边界，可回到 `122-124` 先把 warning、reconnecting、viewerOnly 与 recovery signer 的稳定宿主合同收稳。
