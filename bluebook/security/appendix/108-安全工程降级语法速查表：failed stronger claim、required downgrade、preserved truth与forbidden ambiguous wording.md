# 安全工程降级语法速查表：failed stronger claim、required downgrade、preserved truth与forbidden ambiguous wording

## 1. 这一页服务于什么

这一页服务于 [124-安全工程降级语法：当stronger claim无法补证时，系统必须如何改口、保留什么真相、禁止什么模糊表达](../124-%E5%AE%89%E5%85%A8%E5%B7%A5%E7%A8%8B%E9%99%8D%E7%BA%A7%E8%AF%AD%E6%B3%95%EF%BC%9A%E5%BD%93stronger%20claim%E6%97%A0%E6%B3%95%E8%A1%A5%E8%AF%81%E6%97%B6%EF%BC%8C%E7%B3%BB%E7%BB%9F%E5%BF%85%E9%A1%BB%E5%A6%82%E4%BD%95%E6%94%B9%E5%8F%A3%E3%80%81%E4%BF%9D%E7%95%99%E4%BB%80%E4%B9%88%E7%9C%9F%E7%9B%B8%E3%80%81%E7%A6%81%E6%AD%A2%E4%BB%80%E4%B9%88%E6%A8%A1%E7%B3%8A%E8%A1%A8%E8%BE%BE.md)。

如果 `124` 的长文解释的是：

`为什么 stronger claim 一旦补证失败就必须明确降级表达，`

那么这一页只做一件事：

`把主要 failed stronger claim 的 required downgrade、preserved truth 与 forbidden ambiguous wording 压成一张矩阵。`

## 2. 降级语法矩阵

| failed stronger claim | required downgrade | preserved truth | forbidden ambiguous wording |
| --- | --- | --- | --- |
| `verify 存在` | `README 中存在 verify 命名；当前未观察到对应 artifact/entry/host` | lexical existence | `可能只是没展开`、`大概率存在` |
| `当前已有验证体系` | `当前仅存在 build/check/start 入口制度；无 formal verify/test 入口` | partial interface existence | `验证体系基本齐了`、`差不多已有` |
| `当前构建已验证` | `best-effort artifact 已可构建且可最小启动；不构成 formal verification closure` | artifact + smoke truth | `基本可视作已验证`、`大体正确` |
| `这些层只是暂时缺文档` | `当前未证明，且不能按已存在处理` | uncertainty itself | `先按有处理`、`默认已经接上` |

## 3. 最短判断公式

判断一句 failed stronger claim 该怎样改口时，先问四句：

1. 当前最小仍成立的真相子集是什么
2. 哪一层 stronger claim 必须被撤回
3. 该撤回是否已显式写出来
4. 当前是否还残留模糊词在偷偷续命

## 4. 最常见的四类模糊续命词

| 模糊词 | 实际问题 |
| --- | --- |
| `可能` | 替未证 stronger claim 保留生存空间 |
| `大概` | 把缺证包装成温和猜测 |
| `基本` | 把未满足条件写成接近完成 |
| `先按有处理` | 直接把默认推定冒充制度事实 |

## 5. 一条硬结论

对这份研究版源码来说，  
真正正确的改口不是：

`把强结论说软一点，`

而是：

`撤回强层、保留真层，并禁止模糊词继续代强结论发言。`

