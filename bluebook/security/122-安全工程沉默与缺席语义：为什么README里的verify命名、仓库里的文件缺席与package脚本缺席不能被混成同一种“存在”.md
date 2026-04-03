# 安全工程沉默与缺席语义：为什么README里的verify命名、仓库里的文件缺席与package脚本缺席不能被混成同一种“存在”

## 1. 为什么在 `121` 之后还必须继续写“沉默与缺席语义”

`121-安全工程否决权宪法` 已经回答了：

`缺口信号、未证事实与能力上限必须压过 build/check/smoke 的正向信号。`

但如果继续追问，  
还会碰到一个更隐蔽的问题：

`什么才算“缺口真的存在”？`

因为在实际工程里，  
最容易制造错觉的不是正向信号本身，  
而是：

`命名似乎存在，但制度其实缺席。`

这份研究版源码里就有一个非常典型的例子：

1. `README.md:167-174` 里出现了 `verify/SKILL.md`、`verify/examples/cli.md`、`verify/examples/server.md`
2. 但在当前提取树里，本地检索 `verify/` 实际没有文件
3. 同时 `package.json:7-11` 也没有任何 `verify/test` script
4. 本地检查又显示 `.github dirs: 0`、`test/spec files: 0`

这意味着：

`“README 里提到 verify” 并不等于 “仓库里存在 formal verify system”。`

所以 `121` 之后必须继续补出的下一层就是：

`安全工程沉默与缺席语义`

也就是：

`在安全工程里，文本命名、文件存在、脚本入口、自动化宿主是四类不同的存在；它们不能被混成同一种“有”。`

## 2. 最短结论

对这份研究版 Claude Code 源码来说，  
最危险的误判之一不是“完全没看到东西”，  
而是：

`看到了名字，就误以为看到了制度。`

当前证据非常典型：

1. `README.md:167-174` 提到 `verify/*`
2. 但当前树中 `rg --files ... | rg 'verify/' => 0`
3. `package.json:7-11` 中没有 `verify/test` script
4. `.github dirs: 0`、`test/spec files: 0`

所以这一章的最短结论是：

`在安全工程里，“命名存在”“文件存在”“脚本存在”“宿主存在”是四种不同层级的存在；只有后几层才配支撑制度结论。`

再压成一句：

`名字不是制度，回声不是入口，文本不是宿主。`

## 3. 第一性原理：为什么“存在”必须分层解释

因为“存在”这个词本身太粗。

至少要分成四层：

1. `lexical existence`
   某个名字在文本里出现
2. `artifact existence`
   某个文件或对象真的在当前树里存在
3. `entry existence`
   某项能力有正式入口可被调用
4. `host existence`
   某项制度有自动执行或长期承载宿主

如果不分层，  
系统就会不断发生偷换：

1. 把 lexical existence 写成 artifact existence
2. 把 artifact existence 写成 entry existence
3. 把 entry existence 写成 host existence

而这恰恰是研究版仓库最容易出现的失真。

## 4. 当前仓库里的 `verify` 就是一个典型案例

## 4.1 README 有 lexical existence

`README.md:167-174` 明确列出了：

1. `verify/SKILL.md`
2. `verify/examples/cli.md`
3. `verify/examples/server.md`

这只能证明一件事：

`verify` 这个命名在 README 的目录说明文本里出现过。`

它不能直接证明：

1. 当前树里这些文件真的存在
2. 当前仓库中存在正式验证系统
3. 当前验证能力可以被执行

所以这是：

`lexical existence`

而不是：

`institutional existence`

## 4.2 当前树没有 artifact existence

本地检索结果是：

1. `rg --files ../../claude-code-source-code | rg 'verify/' => 0`
2. `find ../../claude-code-source-code -maxdepth 3 -path '*/verify/*' -type f => 0`

这说明在当前提取树里，  
`verify/*` 至少并不是一个实际存在的文件集。

这就把上一层 README 命名的语义，  
直接降级成：

`文本回声`

所以在当前树里，  
“README 提到 verify” 与 “仓库存在 verify files” 并不成立同义。

## 4.3 当前仓库也没有 entry existence

`package.json:7-11` 当前只承认：

1. `prepare-src`
2. `build`
3. `check`
4. `start`

没有：

1. `verify`
2. `test`
3. `ci`

这意味着即便某些 `verify/*` 文件真存在，  
也仍然不能自动升级成：

`formal verify entry exists`

因为 entry existence 的签字人是：

`正式入口层`

而不是 README 文本层。

## 4.4 当前更没有 host existence

本地检查：

1. `.github dirs: 0`
2. `test/spec files: 0`

说明的不只是“还没写 tests”，  
而是：

1. 没有自动执行宿主
2. 没有显式测试骨架
3. 没有 formal verification closure

所以 host existence 更无从谈起。

## 5. 为什么沉默不是中立，缺席也不是小问题

很多人会自然觉得：

1. README 提到 verify
2. 当前树没看到 verify

那就先保持中立，  
也许只是还没翻到。

但对安全工程来说，  
这种“中立”其实很危险。

因为如果你不把缺席写成结构化事实，  
系统就会自动把它填成：

`默认存在，只是暂时没细看。`

而这会直接抬高结论强度。

所以在安全工程里：

1. `absence of artifact`
2. `absence of entry`
3. `absence of host`

都不应被视作小问题，  
而应被视作：

`需要显式写出来的降级依据。`

## 6. 技术先进性：成熟系统会区分“文本存在”“工件存在”“入口存在”“宿主存在”

这其实是一个很深的工程哲学问题。

低成熟度系统常常只会问：

`有没有。`

高成熟度系统会问：

1. 是在文本里有
2. 还是在树里有
3. 还是在入口层有
4. 还是在自动化宿主层有

只有把这四层分开，  
团队才不会：

1. 把 README 清单误当实际工件
2. 把实际工件误当正式入口
3. 把正式入口误当长期制度宿主

从这个角度看，  
Claude Code 这份研究版源码给出的一个很深的启示是：

`安全研究不仅要会读“出现了什么”，还要会读“缺席了什么”，以及“这种缺席属于哪一层”。`

## 7. 苏格拉底式反思：当我看到一个名字时，我该先问什么

可以先追问八句：

1. 这个名字是出现在 README 里，还是出现在文件系统里
2. 即便文件存在，它有没有正式入口
3. 即便入口存在，它有没有自动执行宿主
4. 我是不是把 lexical existence 写成了 artifact existence
5. 我是不是把 artifact existence 写成了 institutional existence
6. 当前缺席的是文件、入口还是宿主
7. 如果把“存在”拆成四层，我这句话现在究竟在说哪一层
8. 若把沉默与缺席都显式写出来，这个结论是否必须降级

这些追问最后都会收敛到一句：

`存在必须带层级，缺席也必须带层级。`

## 8. 一条硬结论

对这份 Claude Code 研究版源码来说，  
真正严谨的写法不是：

`README 里提到了 verify，所以验证能力大概率存在，`

而是：

`README 里只有 lexical existence；当前树缺 artifact existence；package 没有 entry existence；仓内也没有 host existence。`

因为只有这样，  
这份蓝皮书才不会陷入：

`名字已经出现，于是制度被脑补`

而会继续升级成：

`对存在层级、缺席层级与沉默语义都有明确约束的安全工程分析。`

