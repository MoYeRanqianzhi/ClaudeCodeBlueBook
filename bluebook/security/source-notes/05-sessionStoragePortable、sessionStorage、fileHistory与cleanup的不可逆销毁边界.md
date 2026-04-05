# sessionStoragePortable、sessionStorage、fileHistory 与 cleanup 的不可逆销毁边界

## 1. 为什么单开这一篇源码剖面

安全主线推进到 `154` 时，  
真正需要被单独拆开的已经不是：

`谁还在消费 audit world，`

而是：

`哪些代码只是在读时跳过，哪些代码真的会改写本地载体，哪些代码又是在按 retention policy 做删除？`

如果这个问题只停在主线长文里，  
很容易被讲成抽象的“销毁分层”。  
所以这里单开一篇，只盯住：

- `src/utils/sessionStoragePortable.ts`
- `src/utils/sessionStorage.ts`
- `src/utils/fileHistory.ts`
- `src/utils/cleanup.ts`

把 read-path filtering、local transcript rewrite、workspace rewind delete 与 age-based cleanup 这四类动作拆给源码本身说话。

## 2. 先给最短判断

这组代码最重要的技术事实不是：

`Claude Code 能不能删东西。`

而是：

`Claude Code 把“不再读取”“局部重写”“恢复时替换”“工作区回滚删除”与“保留期销毁”拆成了不同控制面。`

因为它同时做了六件很硬的事：

1. `readTranscriptForLoad()` 会在 load 时裁剪输出 buffer，但不改原文件
2. `walkChainBeforeParse()` 会在 parse 前跳过 dead branches，但不删磁盘原行
3. `applySnipRemovals()` 明写 `removed messages stay on disk`
4. `removeMessageByUuid()` 会对本地 transcript 做 tail truncate / rewrite
5. `applySnapshot()` 在 rewind 时必要时会删除工作区文件
6. `cleanupOldSessionFiles()` 与 `cleanupOldFileHistoryBackups()` 才会按 cutoff 对 session / backup 做 age-based destructive cleanup

这意味着它治理的不是单一 delete 动作，  
而是一套：

`multi-plane destruction grammar`

## 3. 关键源码锚点

| 主题 | 关键源码 | 这里回答的问题 |
| --- | --- | --- |
| load-time truncate of output buffer | `src/utils/sessionStoragePortable.ts:613-645,717-792` | 为什么 compact skip 首先是读取视图收缩，而不是原文件删除 |
| dead-branch parse skipping | `src/utils/sessionStorage.ts:3227-3465` | 为什么 dead fork branch 可以不再被 parse，却仍未必离开磁盘 |
| snip removal replay | `src/utils/sessionStorage.ts:1959-1977,1988-2039` | 为什么 removed message 仍可继续留在 append-only JSONL |
| local transcript tombstone | `src/utils/sessionStorage.ts:863-949` | 为什么局部 destructive rewrite 存在，但只覆盖窄域 transcript 修补 |
| hydration rewrite | `src/utils/sessionStorage.ts:1595-1608,1654-1660` | 为什么 rewrite 本地镜像不等于系统级 destroy verdict |
| in-memory snapshot cap | `src/utils/fileHistory.ts:54,305-325` | 为什么状态窗口裁剪不等于 backup 销毁 |
| rewind delete | `src/utils/fileHistory.ts:533-582` | 为什么工作区文件删除不等于历史备份删除 |
| age-based cleanup | `src/utils/cleanup.ts:25-31,155-257,305-347,587-595` | 为什么真正 destructive authority 更像 retention governor |

## 4. `readTranscriptForLoad()` 先收缩读取视图，而不是销毁原 transcript

`src/utils/sessionStoragePortable.ts:613-645,717-792` 的关键词非常重要：

1. `scanChunkLines()` 会 strip attr-snap lines
2. 命中 compact boundary 时会把 `s.out.len = 0`
3. 返回的是 `postBoundaryBuf`
4. 最终只是把 buffer subarray 交给 load path

这说明这条路径真正做的不是：

`rewrite filePath`

而是：

`rewrite what the loader will see`

从安全分析角度说，  
这条差异极关键。  
因为如果一个系统只是在读取层换了一份更窄的解释材料，  
你就不能把它说成：

`证据已经被 destroy`

最多只能说：

`当前消费层不再承认旧输入`

## 5. `walkChainBeforeParse()` 与 `applySnipRemovals()` 进一步证明“语义删除”不等于“字节删除”

`src/utils/sessionStorage.ts:3227-3465` 的 `walkChainBeforeParse()` 会：

1. 扫描整个 buffer
2. 只保留最新 leaf 的 parent chain
3. 把 metadata lines 原样并回

这里被丢掉的是 parse 负担，  
不是原始字节本体。

`src/utils/sessionStorage.ts:1959-1977` 则把这件事写得更明白：

1. snip 删除的是中间范围
2. `The JSONL is append-only`
3. `removed messages stay on disk`
4. 所以恢复时要 replay removedUuids 并 relink chain

这说明 Claude Code 当前已经正式承认：

`有些 removal 是 replay semantics，不是 storage destruction`

这也是 `154` 能成立的最硬源码依据之一。

## 6. `removeMessageByUuid()` 说明局部 destructive rewrite 的确存在

`src/utils/sessionStorage.ts:863-949` 的边界也必须看清。

这里系统为了 tombstone orphaned message，会：

1. 只读 tail
2. 找到目标 uuid 所在行
3. `truncate(absLineStart)`
4. 必要时把 trailing lines 回写
5. slow path 则读全文件再 `writeFile()`

这说明 Claude Code 当然不是“从不删”。  
它能删，而且删得很工程化。

但这条代码只回答一个更窄的问题：

`这个本地 transcript 里的 orphaned line 还要不要继续保留？`

它没有自动扩展成：

`相关备份、remote source、resume materials 与其他 carriers 也一起销毁`

所以这条路径说明的是：

`local destructive operator exists`

不是：

`global irreversible-erasure truth is granted`

## 7. hydration 的 `writeFile()` 更像本地镜像切换，而不是 destroy sovereignty

`src/utils/sessionStorage.ts:1595-1608,1654-1660` 里两条注释很关键：

1. `Replace local logs with remote logs. writeFile truncates`
2. foreground transcript 也直接 `writeFile(sessionFile, fgContent, ...)`

这显然是 destructive write。  
但它的制度含义仍然不是：

`旧证据应当被消灭`

而是：

`本地 session file 现在应以哪份 upstream event/log 为 authoritative mirror`

所以它更接近：

`mirror replacement`

而不是：

`retention court`

## 8. file history 再次把“状态窗口”“工作区文件”“备份目录”拆成三层

`src/utils/fileHistory.ts:54,305-325` 说明：

1. `MAX_SNAPSHOTS = 100`
2. 新 snapshot 进入后，state 只保留后 100 条
3. 但这里没有一起删除对应 backup files

这表明 in-memory windowing 并不自动等于 backup destruction。

`src/utils/fileHistory.ts:533-582` 的 `applySnapshot()` 又说明：

1. 如果目标版本 `backupFileName === null`
2. 系统会 `unlink(filePath)`
3. 这是为了把工作区恢复到目标 snapshot 语义

这里被删的是当前 workspace file，  
不是 `file-history/{sessionId}` 里的备份总账。

所以 file history 本身就同时承认了三条不同主权：

1. state window owner
2. workspace restore owner
3. backup retention owner

## 9. `cleanup.ts` 才是真正最接近 destroy verdict 的 retention control plane

`src/utils/cleanup.ts:25-31` 先定义了：

1. `cleanupPeriodDays`
2. `cutoffDate`

然后：

- `cleanupOldSessionFiles()`  
  会对旧 `.jsonl`、`.cast` 与 session tool-results 做 `unlink`  
  `src/utils/cleanup.ts:155-257`
- `cleanupOldFileHistoryBackups()`  
  会对旧 `file-history/{sessionId}` 目录做 `rm({ recursive: true, force: true })`  
  `src/utils/cleanup.ts:305-347`
- `cleanupOldMessageFilesInBackground()`  
  会统一调度旧 session、plan、file-history、env dirs 等 cleanup  
  `src/utils/cleanup.ts:587-595`

这说明更接近真正 destructive authority 的地方不是：

- load path
- compact replay
- rewind semantics
- audit close naming

而是：

- retention cutoff
- housekeeping executor
- background cleanup schedule

也就是说：

`真正的 delete plane lives in retention governance.`

## 10. 这篇源码剖面给主线带来的三条技术启示

### 启示一

Claude Code 的“删除”至少已经分裂成五种语义：

- skip
- replay removal
- local rewrite
- workspace rewind delete
- aged-out cleanup

### 启示二

真正强的安全系统，不是完全避免 destructive action，  
而是拒绝让不同强度的 destructive action 共享同一句文案与同一个 signer。

### 启示三

如果一个系统把真正 `unlink/rm` 的权力放到 retention housekeeping，  
而不是放在 archive/audit 文案旁边，  
那它本质上就是在承认：

`visibility closure != evidence death`

## 11. 一条硬结论

这组源码真正先进的地方不是：

`删得更狠`

而是：

`它已经把“不再读取”“局部改写”“恢复性删除”与“保留期销毁”拆成不同强度的控制面。`

因此：

`audit close 仍不能越级冒充 irreversible erasure。`
