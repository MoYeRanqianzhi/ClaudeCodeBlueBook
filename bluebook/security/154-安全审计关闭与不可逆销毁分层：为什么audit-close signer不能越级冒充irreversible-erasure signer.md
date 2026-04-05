# 安全审计关闭与不可逆销毁分层：为什么audit-close signer不能越级冒充irreversible-erasure signer

## 1. 为什么在 `153` 之后还必须继续写 `154`

`153-安全归档关闭与审计关闭分层` 已经回答了：

`archive-close signer 最多只能决定对象是否退出活跃操作表面；audit-close signer 才配决定 transcript、metadata、history 与恢复材料是否退出 audit world。`

但如果继续追问，  
还会碰到一层更危险的错觉：

`如果某些材料已经不再参与 resume、loadFullLog 或审计读取，这是否已经等于它们被不可逆销毁了？`

Claude Code 当前源码给出的答案仍然是否定的。

因为继续往下看会发现，源码里至少同时存在四种完全不同的动作：

1. 读取侧过滤  
   例如 `readTranscriptForLoad()`、`walkChainBeforeParse()`、`applySnipRemovals()` 这类路径，会在加载或重建时主动跳过旧边界、死分支或已 snip 区段
2. 局部重写  
   例如 `removeMessageByUuid()` 会为了 tombstone orphaned message 而做 tail truncate / rewrite
3. 镜像替换  
   例如 remote hydration 与 CCR v2 hydration 会用 `writeFile()` 截断并重写本地 transcript 文件
4. 保留期删除  
   例如 `cleanup.ts` 会按 `cleanupPeriodDays` 对旧 `.jsonl`、`.cast`、tool-results 与 file-history 目录做 `unlink` / `rm`

这四类动作里，  
只有最后一类才更接近真正的 destructive authority；  
前面三类要么只是读时过滤，要么只是局部修补，要么只是把某个本地镜像换成另一份来源。

所以 `153` 之后必须继续补的一层就是：

`安全审计关闭与不可逆销毁分层`

也就是：

`audit-close signer 最多只能说“这些材料现在不再参与当前 audit world”；irreversible-erasure signer 才配说“这些材料本身已被销毁到足以不再作为证据载体存在”。`

## 2. 先做一条谨慎声明：`irreversible-erasure signer` 仍是研究命名，不是源码现成类型

和 `151-153` 一样，  
这里也要先讲清楚：

`Claude Code 当前源码里并没有一个字面存在的 signer 类型叫 irreversible-erasure signer。`

这里的 `irreversible-erasure signer` 仍然是研究命名。  
它不是在声称 Anthropic 已经把“不可逆销毁”做成显式状态机对象，  
而是在说：

1. 当前源码已经把 active surface、resume world 与 audit world 拆开
2. 当前源码又进一步把“读取时不再消费”与“真正对磁盘做 destructive delete”拆开
3. 所以下一层最自然的分析主权，就是谁配宣布“这些载体现在不只是退出读取链，而且已被实际销毁到不再构成可恢复证据”

换句话说：

`154` 不是在虚构现有实现，
而是在把源码里已经分裂出来的 destructive authority 单独命名出来。

## 3. 最短结论

Claude Code 当前源码至少给出了四类“audit close 仍不等于 irreversible erasure”证据：

1. `readTranscriptForLoad()` 与 `walkChainBeforeParse()` 会在加载期重排、截断输出 buffer，但这是 read-path filtering，不是磁盘删除  
   `src/utils/sessionStoragePortable.ts:613-645,717-792`  
   `src/utils/sessionStorage.ts:3227-3465`
2. `applySnipRemovals()` 明确写着 `The JSONL is append-only, so removed messages stay on disk`，说明有些“移除”只是 load-time replay semantics  
   `src/utils/sessionStorage.ts:1959-1977`
3. `removeMessageByUuid()`、remote hydration 与 CCR v2 hydration 确实会 `truncate/writeFile`，但它们只是特定本地 transcript 的窄域变异或镜像替换，不等于系统级 destruction sovereignty  
   `src/utils/sessionStorage.ts:863-949,1595-1608,1654-1660`
4. 真正更接近 retention-driven delete 的权力出现在 `cleanup.ts`：它由 `cleanupPeriodDays` 推出 cutoff，再对旧 session files 与 file-history backups 做 `unlink` / `rm`  
   `src/utils/cleanup.ts:25-31,155-257,305-347`

因此这一章的最短结论是：

`audit-close signer 最多只能说“这些材料现在不再参与当前 audit / resume world”；它仍然不能越级说“这些材料已经被真实销毁”。`

再压成一句：

`退出证据世界，不等于证据载体消失。`

## 4. 第一性原理：为什么 audit close 仍不等于 irreversible erasure

从第一性原理看：

- audit close 回答的是  
  `这些材料是否仍参与证明、恢复、回读与追索？`
- irreversible erasure 回答的是  
  `这些材料本身是否已经被 destroy 到系统不再把它们当作可恢复载体？`

所以两者处理的是两种完全不同的问题：

1. participation closure
2. carrier destruction

如果把两者压成同一个 green state，  
系统就会制造四类危险幻觉：

1. hidden-means-destroyed illusion  
   只要前台看不到，就误以为底层载体不存在
2. filtered-means-erased illusion  
   只要 loader 不再消费，就误以为旧字节已消失
3. rewritten-means-forgotten illusion  
   只要本地镜像被替换，就误以为整个证据世界已被抹平
4. aged-out-policy-means-audit-close illusion  
   只要将来可能被 cleanup 删除，就误以为当前已经得到 destroy verdict

所以从第一性原理看：

`audit close` 只决定“还能不能被证明”；  
`irreversible erasure` 才决定“载体还在不在”。

## 5. 读取侧过滤不是销毁：Claude Code 明确区分了 load-path 与 disk-path

`src/utils/sessionStoragePortable.ts:613-645,717-792` 很关键。  
这里的 `scanChunkLines()` 会：

1. strip attribution snapshots
2. 在 compact boundary 命中时把输出 buffer `s.out.len = 0`
3. 记录 `boundaryStartOffset`
4. 返回 `postBoundaryBuf`

这回答的是：

`为了当前 load，要把哪一段 buffer 视为有效输入？`

它没有回写原 transcript 文件。  
也没有对原 JSONL 做 `unlink`、`truncate(filePath)` 或 destructive rewrite。  
这说明 compact/scan 在这里首先是：

`read-path compaction`

而不是：

`storage-path destruction`

`src/utils/sessionStorage.ts:3227-3465` 的 `walkChainBeforeParse()` 也一样。  
它会在 parse 前：

1. 索引 transcript message 行
2. 只保留最新 leaf 的 parent chain
3. 让 dead fork branches 不再进入 parse 成本

这里被“跳过”的是 parse 输入，  
不是磁盘上的原始行。

所以如果某个系统在 read path 上变得更窄、更快、更新鲜，  
你最多只能说：

`它在当前解释层不再消费这些旧材料`

还不能说：

`这些旧材料已经被 destroy`

## 6. `applySnipRemovals()` 把话说得更直白：removed messages stay on disk

`src/utils/sessionStorage.ts:1959-1977` 这一段几乎就是本章的中心证据。  
注释写得非常直接：

1. snip 与 compact boundary 不同，它会删除中间段
2. `The JSONL is append-only`
3. `removed messages stay on disk`
4. 所以 load 时必须 replay removal semantics 与 relink parentUuid

这条注释的哲学含义非常深：

`系统已经公开承认：有些“删除”只是语义删除，不是载体删除。`

也就是说，  
某条历史即使已经从当前 conversation chain 里被移除，  
它仍可能继续作为底层字节存在；  
系统只是选择在恢复时不再把它当成 live chain 的一部分。

这正是：

`audit participation changed`

而不是：

`carrier physically vanished`

## 7. `removeMessageByUuid()` 证明存在局部 destructive edit，但这仍不是系统级 destroy verdict

`src/utils/sessionStorage.ts:863-949` 说明 Claude Code 不是完全没有 destructive write。  
它在 tombstoning orphaned message 时会：

1. 读尾部 chunk
2. 找到目标 line
3. `fh.truncate(absLineStart)`
4. 必要时再把 trailing lines 写回
5. slow path 则读全文件再 `writeFile()`

这说明局部 destructive mutation 当然存在。  
但它回答的只是：

`某个 orphaned entry 是否还应留在当前 transcript 里`

而不是：

`系统是否已经对该会话或该证据世界作出不可逆销毁宣判`

原因有两点：

1. 这是窄域 repair action，不是统一 retention policy
2. 它只覆盖某个本地 transcript 文件，不覆盖 file-history、remote event source、其他副本与更高层索引

所以即使这里真的出现了 `truncate`，  
也只能说明：

`局部 destruction operator 存在`

不能说明：

`irreversible-erasure sovereignty 已经被 audit close 吸收`

## 8. remote hydration 的 `writeFile()` 更像镜像替换，不像 destroy sovereignty

`src/utils/sessionStorage.ts:1605-1608,1658-1660` 继续给出另一个容易误读的强动作：

1. hydrate remote session 时，`writeFile()` 截断并重写本地 session file
2. hydrate CCR v2 internal events 时，前台 transcript 也被 `writeFile()` 覆盖

如果只盯着 `writeFile truncates` 这句，  
很容易误以为这里已经是 destroy authority。

但实际上它更像：

`local mirror replacement`

因为这里要解决的问题不是：

`这些证据应不应该被制度性销毁`

而是：

`本地 transcript 应该以哪份 authoritative upstream log 为准`

换句话说，  
这里的 destructive action 是同步策略的一部分，  
不是 retention judgment 本身。

## 9. file history 再次证明：工作区恢复、内存裁剪、备份销毁属于三种不同动作

`src/utils/fileHistory.ts` 很能说明 Claude Code 的分层成熟度：

1. `fileHistoryMakeSnapshot()` 会把 state 里的 snapshots cap 到 `MAX_SNAPSHOTS = 100`，但代码里没有因为这个 cap 去删除对应 backup files  
   `src/utils/fileHistory.ts:54,305-325`
2. `applySnapshot()` 在 rewind 时如果目标版本是 `null`，会 `unlink(filePath)` 删除工作区当前文件  
   `src/utils/fileHistory.ts:533-582`
3. 但真正删除备份目录的是 `cleanupOldFileHistoryBackups()`，它按 cutoff 对整个 `file-history/{sessionId}` 目录做 `rm -r`  
   `src/utils/cleanup.ts:305-347`

这三件事在弱系统里很容易被混成一句“恢复/回滚/清理”。  
Claude Code 当前实现却已经把它们拆成三层：

1. in-memory windowing
2. workspace restoration side-effect
3. backup retention destruction

这恰恰证明：

`irreversible erasure` 从来不是 rewind、snip 或 compact 的自然副作用，
它是一条另立的 destructive control plane。

## 10. 真正接近 destroy sovereignty 的代码，出现在 `cleanup.ts`

`src/utils/cleanup.ts:25-31,155-257,305-347` 把这条边界写得很清楚：

1. `getCutoffDate()` 根据 `cleanupPeriodDays` 计算保留期
2. `cleanupOldSessionFiles()` 对旧 `.jsonl`、`.cast` 与 session tool-results 执行 `unlink`
3. `cleanupOldFileHistoryBackups()` 对旧 `file-history/{sessionId}` 目录执行 `rm({ recursive: true, force: true })`
4. `cleanupOldMessageFilesInBackground()` 会周期性调度这些 housekeeping

也就是说，  
真正更接近 destroy verdict 的控制面不是：

- archive
- audit load
- snip replay
- compact skip

而是：

- retention cutoff
- housekeeping executor
- background cleanup scheduler

这正是本章最重要的结构判断：

`destroy authority lives in retention governance, not in audit-close semantics.`

## 11. 技术先进性与哲学本质：Claude Code 真正先进的不是“删得快”，而是“把不同删除语义分开”

从技术上看，Claude Code 这套设计先进的地方不在于它已经完美解决了 irreversible erasure，  
而在于它已经把最容易被混淆的几类动作拆开：

1. read-time filter
2. semantic replay
3. local file rewrite
4. workspace rewind delete
5. retention-based destructive cleanup

这背后对应的哲学本质是：

`真正成熟的安全系统，不会让“现在看不见”自动冒充“以后也不存在”。`

它宁可多留几层主权、  
多保留几种 awkward state，  
也不愿意把：

- hidden
- skipped
- filtered
- rewritten
- expired
- destroyed

压成同一句“已经清掉了”。

这正是 Claude Code 多重安全技术真正值得学习的地方：

`不是把删除做成一个按钮，而是把删除拆成多种不同强度的 truth claim。`

## 12. 苏格拉底式反思：如果这章还可能写错，最容易错在哪里

### 反思一

如果 loader 已不再消费某段历史，我为什么不能直接说它已经被抹掉？

因为 `readTranscriptForLoad()`、`walkChainBeforeParse()` 与 `applySnipRemovals()` 都展示了同一件事：  
系统完全可以只改变解释层，而不改变底层字节。

### 反思二

既然 `removeMessageByUuid()` 会 truncate，本章为什么还不直接把它叫做 irreversible erasure？

因为那只是某个局部 transcript 的 repair/tombstone action。  
如果别的副本、remote source、backups、plan chain 或 file-history 仍在，  
你就不能把局部 destructive edit 冒充成系统级 destroy verdict。

### 反思三

既然 `cleanup.ts` 会真的 unlink / rm，我为什么还要继续强调 signer 分层？

因为真正难的不是写出 `unlink()`，  
而是回答：

`谁配决定何时 unlink，基于什么 cutoff，删的是哪一类 artifact，删完后还保留什么审计诚实性。`

没有这层分权，删除动作本身只会变成新的 overclaim 来源。

### 反思四

如果我要把这套设计再提高一倍，还缺什么？

我会优先补三样东西：

1. 结构化的 destruction scope 字段  
   区分 transcript / backup / workspace / remote mirror / tool-results
2. destruction owner 与 retention governor 的显式协议
3. “filtered / hidden / destroyed” 的固定词法宪法

因为现在源码已经把这些语义在动作上拆开了，  
但还没有把它们在 product language 与 typed contract 上完全做实。

## 13. 一条硬结论

Claude Code 当前源码真正说明的不是：

`audit close 之后一切都会自然消失`

而是：

`audit close、semantic removal、local rewrite、retention cleanup 与 irreversible erasure 仍然是不同强度的声明。`

因此：

`audit-close signer 不能越级冒充 irreversible-erasure signer。`
