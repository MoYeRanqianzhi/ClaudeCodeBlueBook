# control-vs-governance crosswalk uplift 拆分记忆

## 本轮继续深入的核心判断

这一轮最值得收的，

不是继续修入口页，

而是给：

- `05-控制面深挖/README.md`

补上一张更明确的：

- `control vs governance`

crosswalk。

## 为什么这轮值得单独提交

### 判断一：入口层现在更缺“中间护栏”，而不是更多入口

前几轮已经持续把根前门、自动化、前端/远端接续这些入口收窄了。

现在最容易继续发生的误读，

不是：

- 找不到入口

而是：

- 把入口词、状态词、viewer 词、projection 词
  直接拿去代签 governance verdict

并行只读分析也明确指出：

- `05-体验与入口`
  已经声明自己没有真相签发权
- `03-治理与边界`
  已经给出治理最小顺序
- 真正还缺的是两者之间那一步：
  - 先归 control
  - 再决定要不要升级成 governance

### 判断二：最适合承接这张 crosswalk 的文件不是 `02`，而是 `05-控制面深挖/README`

原因很直接：

- `05`
  已经明确承担“把 Prompt / governance / current-truth 的最小顺序翻成用户动作”的职责
- `02-治理与边界/README`
  更像上游治理总则，不是用户动作层
- `02-体验与入口/README`
  又已经明说自己没有真相签发权

所以这张 crosswalk 最合适的落点，

不是更上游的机制页，

而是：

- 用户真正开始把相邻词拆层的这一页

### 判断三：这刀比继续修某个单页稳定/灰度边界更有结构收益

`06`、`13`、`16`

那些页的可见性收窄已经开始形成闭环，

再继续修入口，

收益会快速递减。

而补一张 `control vs governance` crosswalk，

能一次拦住一大批高频误判：

- `/status`
- `/usage`
- `/resume`
- `/remote-control`
- host / session / viewer / worktree / sandbox

这些词以后都更不容易被直接拿去猜裁决结论。

## 这轮具体怎么拆

这轮只做一件事：

1. 在 `05-控制面深挖/README.md`
   现有最小 crosswalk 前，
   增加一个新的：
   - `## control vs governance`
2. 用 5 行把它压成：
   - control 先回答哪条控制面在说话、哪些词只是 projection / readback / consumer
   - governance 再回答这次继续、扩张、降级或停止是否真的拿到了 `pricing-right + truth-surface`
   - `/status / /doctor / /usage / /resume / /remote-control`
     这类高频词先按 control 归位，不直接代签 verdict
   - `host / session / sandbox / worktree / viewer`
     先当 control 问题
   - `decision window / continuation pricing / cleanup-before-resume`
     才升级成 governance 问题

## 苏格拉底式自审

### 问：为什么这刀不放在 `02-治理与边界/README`？

答：因为那一层负责治理总则，不负责把用户的高频误判翻成动作顺序。真正需要这张 crosswalk 的，是 `05` 这种用户动作层。

### 问：为什么不继续修更多入口，而先做这张 crosswalk？

答：因为现在入口收窄已经有了，但“先归 control，再判 governance”这步还不够显式。没有这步，读者仍会拿 `/status`、`/resume`、`/remote-control` 这类词直接猜 verdict。

### 问：为什么要保留原来那张三行 crosswalk？

答：因为新的 crosswalk 解决的是“control 和 governance 怎么分”；原来的三行解决的是“Prompt / governance / current-truth 三问的正式过关条件”。两者层级不同，保留能避免把对象分层和过关条件重新揉成一团。
