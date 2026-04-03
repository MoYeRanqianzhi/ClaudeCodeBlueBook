# 安全工程词法协议速查表：term、allowed layer、meaning与forbidden stronger synonym

## 1. 这一页服务于什么

这一页服务于 [125-安全工程词法宪法：为什么observed、wired、hosted、verified、equivalent这些词必须固定含义而不能互相偷换](../125-%E5%AE%89%E5%85%A8%E5%B7%A5%E7%A8%8B%E8%AF%8D%E6%B3%95%E5%AE%AA%E6%B3%95%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88observed%E3%80%81wired%E3%80%81hosted%E3%80%81verified%E3%80%81equivalent%E8%BF%99%E4%BA%9B%E8%AF%8D%E5%BF%85%E9%A1%BB%E5%9B%BA%E5%AE%9A%E5%90%AB%E4%B9%89%E8%80%8C%E4%B8%8D%E8%83%BD%E4%BA%92%E7%9B%B8%E5%81%B7%E6%8D%A2.md)。

如果 `125` 的长文解释的是：

`为什么不同层级必须绑定固定词汇，`

那么这一页只做一件事：

`把主要 term 的 allowed layer、meaning 与 forbidden stronger synonym 压成一张矩阵。`

## 2. 词法协议矩阵

| term | allowed layer | meaning | forbidden stronger synonym |
| --- | --- | --- | --- |
| `mentioned` | lexical layer | 在文本中被提到 | `present`、`exists`、`available` |
| `observed` | artifact layer | 在当前树或当前 artifact 中被看到 | `available`、`implemented` |
| `wired` | entry layer | 已接入正式入口或调用链 | `integrated`、`institutionalized` |
| `hosted` | host layer | 已被自动化或长期宿主承载 | `supported`、`operationalized` |
| `verified` | verification layer | formal verification closure 已成立 | `works`、`validated enough` |
| `equivalent` | equivalence layer | 与目标系统语义等价 | `close enough`、`basically same` |

## 3. 最短判断公式

判断一个词是否越权时，先问三句：

1. 这个词属于哪一层
2. 当前证据是否真的到达这一层
3. 它是否偷偷替换掉了一个更低层但更真实的词

## 4. 最常见的六类词法偷换

| 偷换 | 实际问题 |
| --- | --- |
| `mentioned -> exists` | 文本层越权成对象层 |
| `observed -> available` | 对象层越权成能力层 |
| `wired -> integrated` | 入口层越权成制度层 |
| `hosted -> supported` | 宿主层越权成稳定承诺 |
| `verified -> works` | 验证层越权成宽泛正确性 |
| `best-effort -> equivalent` | 受限产物越权成语义等价 |

## 5. 一条硬结论

对这份研究版源码来说，  
最可靠的表达不是：

`换个近义词润色，`

而是：

`宁可词更硬，也不让词跨层。`

