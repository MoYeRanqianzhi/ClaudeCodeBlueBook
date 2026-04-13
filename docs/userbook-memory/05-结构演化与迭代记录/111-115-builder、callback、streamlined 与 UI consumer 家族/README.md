# 111-115 builder、callback、streamlined 与 UI consumer 家族

这个目录不是新的编号总图，

而是给已经存在的：

- `111` 四层可见性表根页
- `112-113` streamlined dual-entry / passthrough 支线
- `114-115` callback-visible / adapter triad / UI policy 支线

补一个可浏览的记忆入口。

这里保护的首先是：

- 阅读骨架稳定

不是：

- 目录里出现的 builder、callback、streamlined、adapter 或 helper 名都已经属于稳定公开能力

如果你已经分清自己在追：

- builder/control transport、public SDK surface、callback-visible surface 与前台 UI consumer 的逐级收窄
- `streamlined_*` 的 dual-entry、replacement、passthrough 与 suppression
- callback-visible object 为什么不会原样镜像进 adapter triad，以及 adapter 内三种 consumer policy 为什么方向不同

但不想再从 `100-115` 子家族或主 `README` 里逐条找文件，

这里应该先于平铺编号列表阅读。

如果你是从 `100-115` hub 往下继续收窄，

默认也应在这里完成下一次分流：

- `111`
- `112-113`
- `114-115`

而不是再回上游 hub 重找更深入口。

## 第一性原理

这组记忆真正想回答的不是：

- “`111-115` 该按编号怎么顺着翻”

而是：

- 哪些记忆负责把 `111` 立成四层可见性表的根页
- 哪些记忆负责把 `112-113` 收成 streamlined 支线
- 哪些记忆负责把 `114-115` 收成 callback / adapter / UI policy 支线

所以这个目录的作用只是：

- 把现有结构页、scope guard 与 forward handoff 收成一个更窄的子家族入口

不是：

- 再制造一张新的 umbrella map

## 先读哪一簇

### 1. 我还在四层可见性表根页（`111`）

先读蓝皮书结构页：

- [../../../../bluebook/userbook/05-控制面深挖/210-builder transport、callback surface、streamlined dual-entry 与 UI consumer policy：为什么 111、112、113、114、115 不是并列细页，而是先定四层可见性表，再分叉到 streamlined 与 adapter 两条后继线.md](../../../../bluebook/userbook/05-%E6%8E%A7%E5%88%B6%E9%9D%A2%E6%B7%B1%E6%8C%96/210-builder%20transport%E3%80%81callback%20surface%E3%80%81streamlined%20dual-entry%20%E4%B8%8E%20UI%20consumer%20policy%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%20111%E3%80%81112%E3%80%81113%E3%80%81114%E3%80%81115%20%E4%B8%8D%E6%98%AF%E5%B9%B6%E5%88%97%E7%BB%86%E9%A1%B5%EF%BC%8C%E8%80%8C%E6%98%AF%E5%85%88%E5%AE%9A%E5%9B%9B%E5%B1%82%E5%8F%AF%E8%A7%81%E6%80%A7%E8%A1%A8%EF%BC%8C%E5%86%8D%E5%88%86%E5%8F%89%E5%88%B0%20streamlined%20%E4%B8%8E%20adapter%20%E4%B8%A4%E6%9D%A1%E5%90%8E%E7%BB%A7%E7%BA%BF.md)

再看关键记忆：

- [../111-2026-04-06-visibility tables from builder transport to UI consumer 拆分记忆.md](../111-2026-04-06-visibility%20tables%20from%20builder%20transport%20to%20UI%20consumer%20拆分记忆.md)
- [../375-2026-04-13-builder-callback-ui branch-map scope clarification 拆分记忆.md](../375-2026-04-13-builder-callback-ui%20branch-map%20scope%20clarification%20拆分记忆.md)

### 2. 我已经进入 streamlined dual-entry / passthrough（`112-113`）

先读蓝皮书结构页：

- [../../../../bluebook/userbook/05-控制面深挖/210-builder transport、callback surface、streamlined dual-entry 与 UI consumer policy：为什么 111、112、113、114、115 不是并列细页，而是先定四层可见性表，再分叉到 streamlined 与 adapter 两条后继线.md](../../../../bluebook/userbook/05-%E6%8E%A7%E5%88%B6%E9%9D%A2%E6%B7%B1%E6%8C%96/210-builder%20transport%E3%80%81callback%20surface%E3%80%81streamlined%20dual-entry%20%E4%B8%8E%20UI%20consumer%20policy%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%20111%E3%80%81112%E3%80%81113%E3%80%81114%E3%80%81115%20%E4%B8%8D%E6%98%AF%E5%B9%B6%E5%88%97%E7%BB%86%E9%A1%B5%EF%BC%8C%E8%80%8C%E6%98%AF%E5%85%88%E5%AE%9A%E5%9B%9B%E5%B1%82%E5%8F%AF%E8%A7%81%E6%80%A7%E8%A1%A8%EF%BC%8C%E5%86%8D%E5%88%86%E5%8F%89%E5%88%B0%20streamlined%20%E4%B8%8E%20adapter%20%E4%B8%A4%E6%9D%A1%E5%90%8E%E7%BB%A7%E7%BA%BF.md)

再看关键记忆：

- [../112-2026-04-06-streamlined dual-entry gate and null suppression 拆分记忆.md](../112-2026-04-06-streamlined%20dual-entry%20gate%20and%20null%20suppression%20拆分记忆.md)
- [../113-2026-04-06-result passthrough vs terminal primacy 拆分记忆.md](../113-2026-04-06-result%20passthrough%20vs%20terminal%20primacy%20拆分记忆.md)

### 3. 我已经进入 callback-visible / adapter / UI policy（`114-115`）

先读蓝皮书结构页：

- [../../../../bluebook/userbook/05-控制面深挖/210-builder transport、callback surface、streamlined dual-entry 与 UI consumer policy：为什么 111、112、113、114、115 不是并列细页，而是先定四层可见性表，再分叉到 streamlined 与 adapter 两条后继线.md](../../../../bluebook/userbook/05-%E6%8E%A7%E5%88%B6%E9%9D%A2%E6%B7%B1%E6%8C%96/210-builder%20transport%E3%80%81callback%20surface%E3%80%81streamlined%20dual-entry%20%E4%B8%8E%20UI%20consumer%20policy%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%20111%E3%80%81112%E3%80%81113%E3%80%81114%E3%80%81115%20%E4%B8%8D%E6%98%AF%E5%B9%B6%E5%88%97%E7%BB%86%E9%A1%B5%EF%BC%8C%E8%80%8C%E6%98%AF%E5%85%88%E5%AE%9A%E5%9B%9B%E5%B1%82%E5%8F%AF%E8%A7%81%E6%80%A7%E8%A1%A8%EF%BC%8C%E5%86%8D%E5%88%86%E5%8F%89%E5%88%B0%20streamlined%20%E4%B8%8E%20adapter%20%E4%B8%A4%E6%9D%A1%E5%90%8E%E7%BB%A7%E7%BA%BF.md)

再看关键记忆：

- [../114-2026-04-06-callback to UI triad split 拆分记忆.md](../114-2026-04-06-callback%20to%20UI%20triad%20split%20拆分记忆.md)
- [../115-2026-04-06-adapter consumer policies split 拆分记忆.md](../115-2026-04-06-adapter%20consumer%20policies%20split%20拆分记忆.md)

如果你已经确认自己不只是看这一支，

而是要回到 `100-115` 的更上层分流，

回跳：

- [../100-115-summary、wire、callback 与 UI 家族/README.md](../100-115-summary、wire、callback%20与%20UI%20家族/README.md)

## 这层入口保护什么

- 保护的是 `111-115` 这簇记忆的子家族入口，不是新的编号总图。
- 保护的是 `111 -> 112→113` 与 `111 -> 114→115` 的分叉关系。
- 不把四层可见性表、streamlined 支线与 adapter / UI policy 支线误写成同一种“消息显示问题”。
- 不让上游 `100-115` hub 继续代替这里完成 builder/callback/UI 这一层的下一次分流。
- 不在这一轮移动或重命名任何现有记忆文件。
