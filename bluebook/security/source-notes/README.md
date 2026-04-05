# 安全源码剖面索引

`source-notes/` 当前包含 2 篇源码剖面。它专门承接单机制、单协议、单文件群的长证据拆解，不与主线论证层和附录速查层混写。

## 这一子目录放什么

`security/` 主目录继续保留“主线论证链”。  
`security/appendix/` 继续保留“压缩速查层”。  
这里的 `source-notes/` 专门放：

- 单机制源码剖面
- 单协议边界拆解
- 单文件群技术启示

它比 `appendix/` 更长，  
但比主线章节更贴近源码证据，  
目的不是重复结论，  
而是把“这条结论到底踩着哪些代码长出来”单独留下。

## 当前内容

1. [01-StructuredIO回执账本与签收边界](01-StructuredIO%E5%9B%9E%E6%89%A7%E8%B4%A6%E6%9C%AC%E4%B8%8E%E7%AD%BE%E6%94%B6%E8%BE%B9%E7%95%8C.md)
2. [02-print与CCRClient的终局签字边界](02-print%E4%B8%8ECCRClient%E7%9A%84%E7%BB%88%E5%B1%80%E7%AD%BE%E5%AD%97%E8%BE%B9%E7%95%8C.md)

## 和其他目录的分工

- 与 `security/` 主目录的关系：`source-notes/` 负责贴近源码拆机制，主目录负责把这些机制压成更高阶判断。
- 与 `appendix/` 的关系：`appendix/` 负责短表、矩阵和索引；`source-notes/` 负责长一点的证据剖面，不把速查卡撑成半篇长文。
- 与 `docs/development/research-log.md` 的关系：research log 负责记录研究推进；`source-notes/` 负责留下可以长期复用的源码剖面资产。
