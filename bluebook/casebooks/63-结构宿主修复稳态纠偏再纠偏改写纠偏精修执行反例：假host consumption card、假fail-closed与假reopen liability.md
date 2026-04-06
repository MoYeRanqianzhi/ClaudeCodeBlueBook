# 结构宿主修复稳态纠偏再纠偏改写纠偏精修执行反例：假 host consumption card、假 fail-closed 与假 reopen liability

这一章不再回答“结构 refinement execution 该怎样运行”，而是回答：

- 为什么团队明明已经写了 host consumption card、固定 hard reject order 与 reopen drill，仍会重新退回假 card、假 fail-closed 与假 reopen liability。

## 0. 第一性原理

结构 refinement execution 真正最容易失真的地方，不在 `host consumption card` 有没有写出来，而在 authority、single-source writeback、lineage、fresh merge、anti-zombie、transport boundary、dirty git fail-closed 与 reopen boundary 是否仍围绕同一个结构真相面消费 later 维护者的判断。

## 1. 假 host consumption card：card by pointer and prose

### 坏解法

- 宿主、CI、评审与交接系统虽然都拿到了 `host_consumption_card_id`，但真正执行时只要架构说明更完整、目录更整洁、pointer 还活着，就默认 authority 与 single-source 仍成立。

### 为什么坏

- host consumption card 保护的不是“现在更像一份正式运行卡”，而是 same authority、same seam、same head 仍支撑 later 维护者的消费与反对能力。

### Claude Code 式正解

- card 只能是 packet carrier；真正的主语仍是 `authority_object_id + current_truth_surface_ref + writer_chokepoint`。

## 2. 假 fail-closed：fail-closed by luck

### 坏解法

- 只要结果没坏、telemetry 还绿、工作树当前还能用、没有立刻炸出 git 错误，就提前落下“系统已 resealed”。

### 为什么坏

- `fresh merge` 保护的不是“最终结果看起来还行”，而是旧 finally、旧 append、旧 snapshot 即使迟到也不能继续篡位。
- `dirty git fail-closed` 保护的不是“当前大概没事”，而是脏状态时系统必须拒绝继续写。

### Claude Code 式正解

- hard reject order 必须先证明 `freshness gate + fail-closed boundary` 仍成立，再决定 resealed、reentry 或 reopen。

## 3. 假 reopen liability：liability by reconnect hint and author memory

### 坏解法

- 工单里写“以后有问题再 reconnect”“原入口还在”，却没有正式绑定 `reopen_boundary`、`return_authority_object`、`return_writeback_path` 与 `threshold_retained_until`。

### 为什么坏

- reopen liability 不是“以后再试一次”，而是“未来失稳时正式回到哪个 boundary 组合并由谁负责”。
- 一旦责任保留退回 reconnect 提示与作者记忆，later 团队会同时失去 recovery boundary、stale path 清退保证与 fail-closed 拒写保证。

### Claude Code 式正解

- reopen liability 应围绕 authority、writeback、fail-closed 与 return boundary，而不是围绕 reconnect 提示与旧入口。

## 4. 苏格拉底式追问

在你读完这些反例后，先问自己：

1. 我救回的是唯一 authority object，还是一张更正式的宿主消费卡。
2. 我现在保住的是 `single-source + fresh merge`，还是更漂亮的目录与几次幸运 reconnect。
3. 我现在保住的是 `dirty_git_fail_closed`，还是一种“当前没报错就先过”的冲动。
4. 我现在保留的是 future reopen 的正式 liability，还是一句“以后再试一次”。
5. later 团队明天如果必须 reopen，依赖的是正式 packet field 与 later reject path，还是作者口述、旧入口与 retry 循环。

## 5. 一句话总结

真正危险的结构宿主修复稳态纠偏再纠偏改写纠偏精修执行失败，不是没跑 host consumption card，而是跑了它却仍在围绕假 card、假 fail-closed 与假 reopen liability 消费结构世界。
