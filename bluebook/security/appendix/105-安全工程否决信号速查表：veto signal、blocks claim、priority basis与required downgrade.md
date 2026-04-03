# 安全工程否决信号速查表：veto signal、blocks claim、priority basis与required downgrade

## 1. 这一页服务于什么

这一页服务于 [121-安全工程否决权宪法：为什么缺口信号、未证事实与能力上限必须压过build、check与smoke的正向信号](../121-%E5%AE%89%E5%85%A8%E5%B7%A5%E7%A8%8B%E5%90%A6%E5%86%B3%E6%9D%83%E5%AE%AA%E6%B3%95%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%E7%BC%BA%E5%8F%A3%E4%BF%A1%E5%8F%B7%E3%80%81%E6%9C%AA%E8%AF%81%E4%BA%8B%E5%AE%9E%E4%B8%8E%E8%83%BD%E5%8A%9B%E4%B8%8A%E9%99%90%E5%BF%85%E9%A1%BB%E5%8E%8B%E8%BF%87build%E3%80%81check%E4%B8%8Esmoke%E7%9A%84%E6%AD%A3%E5%90%91%E4%BF%A1%E5%8F%B7.md)。

如果 `121` 的长文解释的是：

`为什么某些缺口信号必须拥有高于正向信号的优先级，`

那么这一页只做一件事：

`把主要 veto signal 的 blocks claim、priority basis 与 required downgrade 压成一张矩阵。`

## 2. 否决信号矩阵

| veto signal | blocks claim | priority basis | required downgrade | 关键证据 |
| --- | --- | --- | --- | --- |
| `source is incomplete` | “公开仓可逐步补成完整产品” | 对象上限已被直接写明 | 降级为 research-extracted / feature-incomplete | `README.md:72-74` |
| `cannot be recovered from published artifact` | “缺失模块只是普通待实现项” | 缺口被明确声明不可恢复 | 降级为公开仓不可闭合 full-fidelity rebuild | `README.md:72-74` |
| `cannot be fully replicated with esbuild` | “当前构建等价官方构建” | 构建能力上限被直接写明 | 降级为 best-effort build only | `QUICKSTART.md:60-70` |
| `no verify/test script in package.json` | “验证制度已存在” | 正式入口层缺位 | 降级为仅有 build/check/start 制度 | `package.json:7-11` |
| `.github dirs: 0` | “已有自动化宿主” | 自动执行宿主缺位 | 降级为当前无 CI host | 本地检查 |
| `test/spec files: 0` | “已有正式 tests corpus” | conventional test corpus 缺位 | 降级为当前未建立显式测试骨架 | 本地检查 |

## 3. 最短判断公式

判断一个强结论是否应被打回时，先问四句：

1. 当前是否已有对象上限 veto
2. 当前是否已有能力上限 veto
3. 当前是否已有验证闭环 veto
4. 若这些 veto 全部显式写出，当前结论应被降级到哪一级

## 4. 最常见的三类错误

| 错误 | 实际问题 |
| --- | --- |
| 把 veto 当附注 | 高优先级约束被降成背景噪音 |
| 把 silence 当 neutral | 缺口信号被静默抹掉 |
| 让正向信号覆盖 veto | 局部成功越权升级整体结论 |

## 5. 一条硬结论

对这份研究版源码来说，  
最重要的不是：

`现在有哪些正向结果，`

而是：

`当前哪些 veto 仍然在场，并因此要求结论降级。`

