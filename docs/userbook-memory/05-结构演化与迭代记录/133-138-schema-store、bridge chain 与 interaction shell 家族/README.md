# 133-138 schema-store、bridge chain 与 interaction shell 家族

这个目录不是新的编号总图，

而是给已经存在的：

- `133-137` schema/store 与 cross-frontend consumer path
- `134-136` bridge publish chain 与 v2 active surface
- `135-138` foreground remote runtime 与 shared interaction shell

补一个可浏览的记忆入口。

这里保护的首先是：

- 阅读骨架稳定

不是：

- 目录里出现的 state、helper 或 transport 名都已经属于稳定公开能力

如果你已经分清自己在追：

- metadata 为何不自动落成 store / consumer
- bridge v1 / v2 chain 怎样分叉到 active surface
- direct connect 为什么只是 foreground runtime，`activeRemote` 又为什么只是一层 shared shell

但不想再从 `128-138` 子家族或主 `README` 里逐条找文件，

这里应该先于平铺编号列表阅读。

## 第一性原理

这组记忆真正想回答的不是：

- “`133-138` 该按编号怎么顺着翻”

而是：

- 哪些记忆负责把 `133-137` 收成 schema/store 到 consumer path 的后继线
- 哪些记忆负责把 `134-136` 收成 bridge chain 到 v2 active surface 的后继线
- 哪些记忆负责把 `135-138` 收成 foreground runtime 到 shared interaction shell 的后继线

所以这个目录的作用只是：

- 把现有结构页、scope guard 与 forward handoff 收成一个更窄的子家族入口

不是：

- 再制造一张新的 umbrella map

## 先读哪一条

### 1. 我还在 schema/store 与 consumer path（`133-137`）

先读蓝皮书结构页：

- [../../../../bluebook/userbook/05-控制面深挖/215-schema-store consumer path、bridge chain split 与 remote interaction shell：为什么 133、134、135、136、137、138 不是线性六连，而是从 132 分出去的三条两步后继线.md](../../../../bluebook/userbook/05-%E6%8E%A7%E5%88%B6%E9%9D%A2%E6%B7%B1%E6%8C%96/215-schema-store%20consumer%20path%E3%80%81bridge%20chain%20split%20%E4%B8%8E%20remote%20interaction%20shell%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%20133%E3%80%81134%E3%80%81135%E3%80%81136%E3%80%81137%E3%80%81138%20%E4%B8%8D%E6%98%AF%E7%BA%BF%E6%80%A7%E5%85%AD%E8%BF%9E%EF%BC%8C%E8%80%8C%E6%98%AF%E4%BB%8E%20132%20%E5%88%86%E5%87%BA%E5%8E%BB%E7%9A%84%E4%B8%89%E6%9D%A1%E4%B8%A4%E6%AD%A5%E5%90%8E%E7%BB%A7%E7%BA%BF.md)

再看关键记忆：

- [../133-2026-04-07-metadata not consumed split 拆分记忆.md](../133-2026-04-07-metadata%20not%20consumed%20split%20拆分记忆.md)
- [../137-2026-04-07-cross frontend consumer split 拆分记忆.md](../137-2026-04-07-cross%20frontend%20consumer%20split%20拆分记忆.md)
- [../380-2026-04-13-schema-store bridge-shell branch-map scope clarification 拆分记忆.md](../380-2026-04-13-schema-store%20bridge-shell%20branch-map%20scope%20clarification%20拆分记忆.md)

### 2. 我已经进入 bridge chain 与 active surface（`134-136`）

先读蓝皮书结构页：

- [../../../../bluebook/userbook/05-控制面深挖/215-schema-store consumer path、bridge chain split 与 remote interaction shell：为什么 133、134、135、136、137、138 不是线性六连，而是从 132 分出去的三条两步后继线.md](../../../../bluebook/userbook/05-%E6%8E%A7%E5%88%B6%E9%9D%A2%E6%B7%B1%E6%8C%96/215-schema-store%20consumer%20path%E3%80%81bridge%20chain%20split%20%E4%B8%8E%20remote%20interaction%20shell%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%20133%E3%80%81134%E3%80%81135%E3%80%81136%E3%80%81137%E3%80%81138%20%E4%B8%8D%E6%98%AF%E7%BA%BF%E6%80%A7%E5%85%AD%E8%BF%9E%EF%BC%8C%E8%80%8C%E6%98%AF%E4%BB%8E%20132%20%E5%88%86%E5%87%BA%E5%8E%BB%E7%9A%84%E4%B8%89%E6%9D%A1%E4%B8%A4%E6%AD%A5%E5%90%8E%E7%BB%A7%E7%BA%BF.md)

再看关键记忆：

- [../134-2026-04-07-bridge version split 拆分记忆.md](../134-2026-04-07-bridge%20version%20split%20拆分记忆.md)
- [../136-2026-04-07-outboundOnly active surface split 拆分记忆.md](../136-2026-04-07-outboundOnly%20active%20surface%20split%20拆分记忆.md)
- [../380-2026-04-13-schema-store bridge-shell branch-map scope clarification 拆分记忆.md](../380-2026-04-13-schema-store%20bridge-shell%20branch-map%20scope%20clarification%20拆分记忆.md)

### 3. 我已经进入 foreground runtime 与 interaction shell（`135-138`）

先读蓝皮书结构页：

- [../../../../bluebook/userbook/05-控制面深挖/215-schema-store consumer path、bridge chain split 与 remote interaction shell：为什么 133、134、135、136、137、138 不是线性六连，而是从 132 分出去的三条两步后继线.md](../../../../bluebook/userbook/05-%E6%8E%A7%E5%88%B6%E9%9D%A2%E6%B7%B1%E6%8C%96/215-schema-store%20consumer%20path%E3%80%81bridge%20chain%20split%20%E4%B8%8E%20remote%20interaction%20shell%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%20133%E3%80%81134%E3%80%81135%E3%80%81136%E3%80%81137%E3%80%81138%20%E4%B8%8D%E6%98%AF%E7%BA%BF%E6%80%A7%E5%85%AD%E8%BF%9E%EF%BC%8C%E8%80%8C%E6%98%AF%E4%BB%8E%20132%20%E5%88%86%E5%87%BA%E5%8E%BB%E7%9A%84%E4%B8%89%E6%9D%A1%E4%B8%A4%E6%AD%A5%E5%90%8E%E7%BB%A7%E7%BA%BF.md)

再看关键记忆：

- [../135-2026-04-07-direct connect foreground runtime split 拆分记忆.md](../135-2026-04-07-direct%20connect%20foreground%20runtime%20split%20拆分记忆.md)
- [../138-2026-04-07-activeRemote interaction shell split 拆分记忆.md](../138-2026-04-07-activeRemote%20interaction%20shell%20split%20拆分记忆.md)
- [../380-2026-04-13-schema-store bridge-shell branch-map scope clarification 拆分记忆.md](../380-2026-04-13-schema-store%20bridge-shell%20branch-map%20scope%20clarification%20拆分记忆.md)
- [../393-2026-04-13-remote-surface stable-gray hardening 拆分记忆.md](../393-2026-04-13-remote-surface%20stable-gray%20hardening%20拆分记忆.md)

如果你要继续看这条线如何向 remote truth / shell / memory 送出后继，

回跳：

- [../128-138-surface presence、bridge chain 与 interaction shell 家族/README.md](../128-138-surface%20presence%E3%80%81bridge%20chain%20%E4%B8%8E%20interaction%20shell%20%E5%AE%B6%E6%97%8F/README.md)
- [../../../../bluebook/userbook/05-控制面深挖/204-activeRemote、remoteSessionUrl、outboundOnly、getIsRemoteMode 与 useReplBridge：为什么 remote surface 的 132、135、138、141、142、143 不是并列 remote 页，而是从 front-state consumer topology 分叉出去的五种后继问题.md](../../../../bluebook/userbook/05-%E6%8E%A7%E5%88%B6%E9%9D%A2%E6%B7%B1%E6%8C%96/204-activeRemote%E3%80%81remoteSessionUrl%E3%80%81outboundOnly%E3%80%81getIsRemoteMode%20%E4%B8%8E%20useReplBridge%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%20remote%20surface%20%E7%9A%84%20132%E3%80%81135%E3%80%81138%E3%80%81141%E3%80%81142%E3%80%81143%20%E4%B8%8D%E6%98%AF%E5%B9%B6%E5%88%97%20remote%20%E9%A1%B5%EF%BC%8C%E8%80%8C%E6%98%AF%E4%BB%8E%20front-state%20consumer%20topology%20%E5%88%86%E5%8F%89%E5%87%BA%E5%8E%BB%E7%9A%84%E4%BA%94%E7%A7%8D%E5%90%8E%E7%BB%A7%E9%97%AE%E9%A2%98.md)

## 这层入口保护什么

- 保护的是 `133-138` 这簇记忆的子家族入口，不是新的编号总图。
- 保护的是 `215` 下三条两步后继线的接力关系。
- 不把 `133-137`、`134-136`、`135-138` 误写成三份互不相干的旧批次。
- 不在这一轮移动或重命名任何现有记忆文件。
