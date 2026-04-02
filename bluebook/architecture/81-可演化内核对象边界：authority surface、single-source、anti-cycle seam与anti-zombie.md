# 可演化内核对象边界：authority surface、single-source、anti-cycle seam与anti-zombie

这一章回答五个问题：

1. 为什么 Claude Code 的源码先进性最终要回到可演化内核的对象边界，而不是停在结构美学。
2. 为什么 authority surface、single-source、anti-cycle seam 与 anti-zombie 本质上在保护同一类长期不变量。
3. 为什么 `config / deps / QueryGuard / task framework / bridge pointer` 这些看似分散的实现，其实都在共同塑形内核。
4. 为什么没有这层对象边界，未来维护者就会重新落回半真相、陈旧写回与第二套恢复面。
5. 这对 Agent Runtime 设计者意味着什么。

## 0. 代表性源码锚点

- `claude-code-source-code/src/query/config.ts:1-45`
- `claude-code-source-code/src/query/deps.ts:1-40`
- `claude-code-source-code/src/utils/QueryGuard.ts:1-108`
- `claude-code-source-code/src/utils/task/framework.ts:160-269`
- `claude-code-source-code/src/bridge/bridgePointer.ts:22-184`
- `claude-code-source-code/src/state/onChangeAppState.ts:43-92`

## 1. 先说结论

Claude Code 更深一层的结构先进性，不只是它会：

1. 写 leaf module
2. 切断循环依赖
3. 加状态机

而是它在持续把这些动作压回同一个目标：

- 守住可演化内核的对象边界

这条边界至少有四个维度：

1. authority surface
2. single-source
3. anti-cycle seam
4. anti-zombie

如果把前面的 builder-facing 总结继续压缩，它真正要保护的是：

- 未来增长时，系统不会轻易长出第二套真相

## 2. authority surface：先固定谁宣布对象当前真相

`onChangeAppState.ts` 与 `QueryGuard.ts` 说明：

1. mode 这类关键状态不能散落同步
2. query lifecycle 不能交给多个 flag 分头维护
3. 当前对象真相必须有单一权威入口

这意味着可演化内核的第一层不是：

- 文件怎么分

而是：

- 谁负责宣布对象当前状态

一旦 authority surface 漂移，后续所有 consumer subset、host projection、CI gate 都会一起漂移。

## 3. single-source：再固定哪些真相只能有一个来源

`query/config.ts` 与 `query/deps.ts` 说明：

1. immutable config 先在 query 入口快照
2. mutable state 不与 config 混写
3. deps 通过窄接口显式注入

这意味着 single-source 在这里并不是：

- DRY 口号

而是：

- 高风险共享真相只能有一个真正的来源，其他地方只能消费、不能再判断一次

这也是为什么 config / deps 很关键：

它们是在提前告诉未来维护者：

1. 哪些东西应该被冻结
2. 哪些东西应该被替换
3. 哪些东西不该直接从模块图里四处抓取

## 4. anti-cycle seam：再固定哪些脏边必须被圈进 seam

Claude Code 早就不是“没有复杂度”的系统，所以它真正成熟的地方在于：

- 愿意诚实承认哪些边很脏，并把它们圈进 seam

`config / deps` 本身就是一种 seam。

同样，很多 leaf module、narrow helper 与 registry 也都在做一件事：

- 保护主路径依赖图继续说真话

这意味着可演化内核的第三层不是：

- 模块图要不要绝对完美

而是：

- 哪些复杂边必须被限制在可控范围内

## 5. anti-zombie：最后固定过去不能把自己写回现在

`task/framework.ts` 说明：

1. await 之后只补 offset patch，不回写整对象
2. fresh state 会在写回前再次复核
3. evict 与 retain 都围绕当前 fresh object 判断

`QueryGuard.ts` 说明：

1. generation mismatch 的 finally 不得清理 fresh query
2. forceEnd 会显式推进代际，拒绝旧异步路径复活

`bridgePointer.ts` 说明：

1. 恢复资产只能帮助恢复，不应长成第二权威面
2. best-effort、TTL 与跨 worktree 扫描都在限制 stale pointer 的命运

这意味着可演化内核的第四层不是：

- 恢复功能是否存在

而是：

- 过去的快照、旧 finally、陈旧指针是否会把自己重新写回现在

## 6. 为什么这四层本质上在保护同一件事

authority surface 保护：

- 当前谁说了算

single-source 保护：

- 真相从哪里来

anti-cycle seam 保护：

- 模块图不要把真相重新拉散

anti-zombie 保护：

- 过去不要重新覆盖现在

四者合在一起，才真正构成：

- evolvable kernel object boundary

也就是说，源码先进性最终保护的不是抽象优雅，而是：

- 对象身份、对象主权、对象命运在增长中仍然不被写坏

## 7. 为什么这会改变“好结构”的定义

从这个角度看，一个结构是否成熟，首先不看：

1. 目录拆得多细
2. 抽象层有多少

而看：

1. 关键对象是否有权威入口
2. 共享真相是否仍能指回单一来源
3. 脏边是否已被 seam 圈住
4. stale writer 是否已被正式拒绝

所以“好结构”真正意味着：

- 后来维护者仍能继续拒绝半真相

## 8. 一句话总结

Claude Code 的可演化内核之所以成熟，不在于结构更整齐，而在于它把 authority surface、single-source、anti-cycle seam 与 anti-zombie 一起写成了对象边界，先替未来维护者保住了不变量。
