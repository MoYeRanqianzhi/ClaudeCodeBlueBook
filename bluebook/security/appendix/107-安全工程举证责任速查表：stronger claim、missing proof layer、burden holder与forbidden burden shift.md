# 安全工程举证责任速查表：stronger claim、missing proof layer、burden holder与forbidden burden shift

## 1. 这一页服务于什么

这一页服务于 [123-安全工程举证责任协议：为什么想把结论说得更强的人必须补齐缺失层证明，而不能把沉默与默认推定外包给读者](../123-%E5%AE%89%E5%85%A8%E5%B7%A5%E7%A8%8B%E4%B8%BE%E8%AF%81%E8%B4%A3%E4%BB%BB%E5%8D%8F%E8%AE%AE%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%E6%83%B3%E6%8A%8A%E7%BB%93%E8%AE%BA%E8%AF%B4%E5%BE%97%E6%9B%B4%E5%BC%BA%E7%9A%84%E4%BA%BA%E5%BF%85%E9%A1%BB%E8%A1%A5%E9%BD%90%E7%BC%BA%E5%A4%B1%E5%B1%82%E8%AF%81%E6%98%8E%EF%BC%8C%E8%80%8C%E4%B8%8D%E8%83%BD%E6%8A%8A%E6%B2%89%E9%BB%98%E4%B8%8E%E9%BB%98%E8%AE%A4%E6%8E%A8%E5%AE%9A%E5%A4%96%E5%8C%85%E7%BB%99%E8%AF%BB%E8%80%85.md)。

如果 `123` 的长文解释的是：

`为什么 stronger claim 的升级成本必须由主张者承担，`

那么这一页只做一件事：

`把主要 stronger claim 的 missing proof layer、burden holder 与 forbidden burden shift 压成一张矩阵。`

## 2. 举证责任矩阵

| stronger claim | missing proof layer | burden holder | required proof | forbidden burden shift |
| --- | --- | --- | --- | --- |
| `README` 里的 `verify/*` 代表真实 verify files | artifact layer | stronger-claim proposer | 当前树中的真实文件与路径映射 | 让读者自己去猜文件只是没翻到 |
| 当前 verify 能力已制度化 | entry layer | stronger-claim proposer | `package` 或等价正式入口 | 让读者接受“虽然没入口但大概已有制度” |
| 当前 verify 能力已有自动化宿主 | host layer | stronger-claim proposer | CI host / scheduler / persistent runner | 让读者接受“未来大概会有所以先当有” |
| `build/check/smoke` 已足够代表验证 | equivalence layer | stronger-claim proposer | 解释为何缺 tests/CI 仍可升级成 verify claim | 让读者自己承担 stronger claim 的剩余证明 |

## 3. 最短判断公式

判断 stronger claim 是否履行了举证责任时，先问四句：

1. 它比当前证据多主张了哪一层
2. 这层当前缺什么证明
3. 这份证明该由谁补
4. 作者是否在把缺失成本转嫁给读者

## 4. 最常见的四类 burden shift

| burden shift | 实际问题 |
| --- | --- |
| “也许文件在别处” | 把 artifact 举证责任外包给读者 |
| “虽然没入口但能力应该有” | 把 entry 举证责任外包给读者 |
| “未来自然会接上宿主” | 把 host 举证责任外包给读者 |
| “这些局部成功差不多够了” | 把 equivalence 举证责任外包给读者 |

## 5. 一条硬结论

对这份研究版源码来说，  
强结论的正确写法不是：

`先说满，再让别人补证，`

而是：

`谁主张 stronger claim，谁负责补齐缺层。`

