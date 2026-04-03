# 安全工程词法宪法：为什么observed、wired、hosted、verified、equivalent这些词必须固定含义而不能互相偷换

## 1. 为什么在 `124` 之后还必须继续写“词法宪法”

`124-安全工程降级语法` 已经回答了：

`当 stronger claim 无法补证时，系统必须明确改口到真实层级，并禁止用模糊词继续维持过满叙事。`

但如果继续追问，  
还会碰到一个最后必须收紧的问题：

`那系统到底该用哪些固定词？`

因为只要词法不固定，  
同一层事实仍然可能被不同作者换着词说，  
从而重新制造偷换：

1. `README 提到` 被说成 `有`
2. `树里看见` 被说成 `已接入`
3. `package 有入口` 被说成 `已制度化`
4. `smoke 成功` 被说成 `已验证`
5. `best-effort build` 被说成 `等价构建`

所以 `124` 之后必须继续补出的下一层就是：

`安全工程词法宪法`

也就是：

`把不同证据层级对应的词固定下来，并禁止跨层近义词互相偷换。`

## 2. 最短结论

对这份研究版 Claude Code 源码来说，  
真正稳固的安全写作不是“尽量谨慎用词”，  
而是：

`每个词都只绑定一个层级。`

从前面的链条看，  
至少应固定以下词义：

1. `mentioned`
   只表示在文本中被提到
2. `observed`
   只表示在当前树中被看到
3. `wired`
   只表示进入正式入口或调用链
4. `hosted`
   只表示被自动化或长期宿主承载
5. `verified`
   只表示 formal verification closure 成立
6. `equivalent`
   只表示与目标系统语义等价

所以这一章的最短结论是：

`词法若不固定，前面的证据纪律迟早会被近义词重新绕穿。`

再压成一句：

`层级一旦固定，词也必须固定。`

## 3. 第一性原理：为什么词法必须被当成工程约束

因为在安全工程里，  
词不是修辞装饰，  
而是：

`结论权限接口。`

当你说：

1. `observed`
2. `wired`
3. `hosted`
4. `verified`
5. `equivalent`

你其实是在替一条结论调用不同级别的签字权限。

如果词法不固定，  
就会出现一种非常隐蔽的失真：

`证据没升级，但词先升级了。`

所以词法宪法的第一性原理就是：

`禁止用词替结论偷渡升级。`

## 4. 当前链条里最需要被固定的六个词

## 4.1 `mentioned`

它只表示：

`某个对象在文本里被提到。`

例如：

`README.md:167-174` 中出现了 `verify/*` 名称。

这时只能说：

`verify is mentioned`

不能说：

1. `verify exists`
2. `verify is present`
3. `verify is available`

因为这些词都比 lexical existence 更强。

## 4.2 `observed`

它只表示：

`某个对象在当前文件树或当前可见 artifact 中被观察到。`

如果：

1. `rg --files ... | rg 'verify/' => 0`
2. `find ... -path '*/verify/*' -type f => 0`

那正确表达就是：

`verify artifacts are not observed`

而不是：

1. `verify probably absent`
2. `verify maybe elsewhere`
3. `verify likely exists but not extracted`

后面这些话都在引入未证推定。

## 4.3 `wired`

它只表示：

`某项能力已进入正式入口、调用链或制度接口。`

当前 `package.json:7-11` 里只有：

1. `prepare-src`
2. `build`
3. `check`
4. `start`

所以可以说：

1. `build/check/start are wired`
2. `verify is not wired`

不能说：

1. `verify exists but is hidden`
2. `verify is basically there`

因为这些词在暗示 formal entry 已存在。

## 4.4 `hosted`

它只表示：

`某项能力被自动执行宿主或长期运行宿主承载。`

当前：

1. `.github dirs: 0`
2. `test/spec files: 0`

所以正确说法是：

`formal verify is not hosted in the current repo`

不能说：

1. `未来应该会接上`
2. `先按已 hosted 理解`
3. `大概率只是外置`

这些都在绕开 host-level 证据。

## 4.5 `verified`

它必须被保留给最强的一层：

`formal verification closure 已成立。`

在当前仓库里，  
由于：

1. 无 verify script
2. 无 tests corpus
3. 无 CI host

所以不能说：

1. `the current build is verified`
2. `the system is verified enough`

只能说：

1. `best-effort artifact can be built`
2. `artifact can minimally launch`
3. `formal verification closure is not established`

## 4.6 `equivalent`

这是比 `verified` 还更苛刻的词。

它只表示：

`与目标对象语义等价。`

而当前：

1. `README.md:72-74` 已明确 source incomplete
2. `QUICKSTART.md:60-70` 已明确 cannot be fully replicated with esbuild

所以任何关于：

1. `equivalent build`
2. `equivalent semantics`
3. `equivalent runtime`

的说法都必须被禁止。

当前最多只能说：

`best-effort`

而绝不能说：

`equivalent`

## 5. 哪些近义词最危险

最危险的不是明显强词，  
而是那些看起来无害、其实会偷换层级的近义词。

例如：

1. 用 `present` 偷换 `mentioned`
2. 用 `available` 偷换 `observed`
3. 用 `integrated` 偷换 `wired`
4. 用 `supported` 偷换 `hosted`
5. 用 `works` 偷换 `verified`
6. 用 `close enough` 偷换 `equivalent`

这些词的问题都一样：

`它们看起来像中间词，实际上在偷抬结论层级。`

## 6. 技术先进性：成熟系统会把词法做成协议，而不是留给作者自由发挥

真正高级的安全工程不会满足于：

1. 有证据
2. 有 veto
3. 有举证责任
4. 有降级语法

它还会继续做到：

`把标准词汇表做成协议。`

这一步非常重要，  
因为没有 lexical protocol，  
系统就算结构上是严谨的，  
也仍然会在表达层重新滑坡。

从这个角度看，  
Claude Code 这份研究版源码给出的深层启示是：

`安全控制面的最终边界，不只是规则如何执行，还包括系统如何命名自身当前所知之真相。`

## 7. 苏格拉底式反思：当我准备写一个词时，我该怎样质问自己

可以先问八句：

1. 这个词对应哪一层存在
2. 这个词是否要求比当前证据更强的签字人
3. 我是不是在用一个听起来温和的近义词偷偷升级
4. 如果换成更低一层的词，句子会失去什么
5. 那个失去的部分是不是正好说明我刚才越权了
6. 当前该说 `mentioned`、`observed`、`wired`、`hosted`、`verified` 还是 `equivalent`
7. 我能否明确写出“不应使用哪些更强近义词”
8. 这句话若成为控制台默认文案，会不会误导后续判断

这些问题最终都会收敛成一句：

`词法就是结论边界。`

## 8. 一条硬结论

对这份 Claude Code 研究版源码来说，  
真正成熟的安全表达不是：

`尽量注意措辞，`

而是：

`给每个层级绑定固定词，把跨层近义词偷换正式列为违例。`

因为只有这样，  
这份蓝皮书才不会在表达层重新失守，  
而会继续保持：

`证据层级、举证责任、降级语法与词法协议四者一致。`

