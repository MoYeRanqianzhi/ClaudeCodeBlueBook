# 结构 Rollout样例：从第二真相到 current-truth surface 与反zombie结构的灰度记录

这一章不再给结构迁移工单，而是给一份完整 rollout 样例。

它主要回答五个问题：

1. 一套第二真相 / 伪模块化系统如何渐进迁到 `current-truth surface -> current-truth writeback -> freshness -> anti-zombie -> handoff` 结构。
2. rollout 期间该如何记录 current-truth surface 切换、writeback 收口、transport shell 收口和 recovery asset 建账的真实证据。
3. 怎样判断结构升级是在减少说谎，而不是只在改善目录表面。
4. 怎样定义 stale-state、resume、reconnect 与 adopt 的灰度指标和回退条件。
5. 怎样用苏格拉底式追问避免把 rollout 样例写成“漂亮重构故事”。

## 0. 改写前状态

旧系统的典型状态是：

1. UI、宿主、metadata、恢复各自维护一份“差不多”的当前态。
2. transport 差异扩散到业务层。
3. 恢复仍主要靠重放或重新猜。
4. finally、旧 snapshot、旧 append 仍可能复活旧对象。
5. 新维护者看不出哪里是 current-truth surface、哪里最危险。

## 1. 目标状态

迁移后的目标不是：

- 文件更多、更碎

而是：

1. 关键状态各有唯一 `current-truth surface`。
2. 第二真相先收回唯一 `current-truth writeback`，再下沉为投影层。
3. transport 差异被关进 shell。
4. recovery asset 已正式列账。
5. stale write 被 generation / fresh merge / stale drop 限制。
6. handoff 交付同一条结构证据链。
7. 命名、注释和 seam 让未来维护者能沿结构提出正确质疑。

## 2. 最小结构 diff 样例

### 改写前

```text
UI state -> 直接维护 current mode
host state -> 顺手同步 current mode
resume path -> 再猜 current mode
finally -> 以旧 snapshot 做 cleanup
```

### 改写后

```text
current-truth session state -> 唯一 writeback 入口
UI / host / recovery -> 只消费投影
resume / reconnect -> 依赖 pointer + snapshot + replacement log
async cleanup -> 先过 generation / fresh-state merge / stale drop
```

### 这段 diff 的意义

真正的结构升级不是：

- 多加了一层 state manager

而是：

- current truth 不再到处顺手维护
- 恢复不再靠猜
- 旧对象不再能轻易复活

## 3. Rollout 阶段

### Phase 0：真相盘点

动作：

1. 盘点所有 mutable fact，逐项标明谁写、谁读、谁持久化、谁恢复。
2. 列出所有第二真相来源。
3. 暂不切流，只加 drift 观测。

观测指标：

- split truth 次数
- 当前态读写入口数量
- stale-state 工单数

回退条件：

- 无。只盘点，不切换。

### Phase 1：建 current-truth surface，先双写

动作：

1. 为 mode、state、metadata、pending action 建统一 `current-truth surface`。
2. 旧写路径暂保留，但只做比对，不再新增散写逻辑。

观测指标：

- 新旧 current-truth surface 对账差异
- UI / host 与 current truth 偏差率
- worker_status / metadata 一致性

回退条件：

- 新旧 current-truth surface 对账出现不可解释分歧。
- 统一写入口引入大面积 current truth 丢失。

### Phase 2：收 current-truth writeback，改读投影

动作：

1. UI、宿主、搜索、恢复路径改为只读投影。
2. 旧路径不再顺手维护状态，所有主状态改写统一进入 `current-truth writeback`。

观测指标：

- split truth 下降幅度
- resume 后主语正确率
- stale pending action 数量

回退条件：

- 消费面无法从投影读取到足够信息。
- UI / host 明显缺失当前态。

### Phase 3：收 transport shell

动作：

1. 把 `local/remote`、`v1/v2`、`structured/streaming` 差异压回 transport shell。
2. construction site 之外减少 transport 条件分支。

观测指标：

- 业务层 transport 条件分支数量
- reconnect / adopt 成功率
- transport leakage 工单数

回退条件：

- transport shell 改造后高层语义不一致。
- reconnect / adopt 明显退化。

### Phase 4：补 recovery asset

动作：

1. 正式登记 pointer、snapshot、replacement log、cursor、adopt 规则。
2. resume / reconnect 只依赖正式恢复资产。

观测指标：

- resume 成功率
- adopt / reconnect 成功率
- recovery-asset drift 次数

回退条件：

- 恢复成功率下降。
- 恢复后 current truth 明显错误。

### Phase 5：接 fresh-state merge、anti-zombie 与 handoff

动作：

1. 为 async gap 增加 generation / freshness gate。
2. 用 patch merge 替代旧对象全量回写。
3. finally / append / snapshot 全部纳入 stale drop 规则。
4. 宿主、CI、评审与交接开始消费同一条 `surface -> writeback -> freshness -> anti-zombie -> handoff` 证据链。

观测指标：

- stale finally 拦截率
- stale snapshot 覆盖失败率
- zombie risk 工单数

回退条件：

- fresh merge 误杀正常更新。
- 系统出现更多“状态不再推进”的假死。

## 4. 评审问题卡

```text
本轮先收口了哪份真相:

当前 current-truth surface 是否唯一:

current-truth writeback 是否唯一:

哪些第二真相仍保留:

哪些 transport 差异仍未关进 shell:

recovery asset 是否已经被正式列账:

如果回退，先回退哪一层:
```

## 5. 灰度结果样例

```text
阶段:
Phase 2 read-from-projection

观测:
- split truth -31%
- stale pending action -22%
- reconnect 成功率持平
- 但 search 面板仍依赖旧 state cache

结论:
- current-truth surface 开始形成
- 但搜索路径尚未完全切读投影，不能继续删旧同步逻辑
```

## 6. 回退记录样例

```text
触发器:
- Phase 5 后 stale finally 被拦截，但正常 cleanup 也误伤 7%

定位:
- generation gate 放在 append merge 前，导致合法 cleanup 被提前丢弃

回退动作:
- 回退 anti-zombie gate 到 Phase 4 末版本
- 保留 current-truth surface、current-truth writeback、projection、recovery asset 成果

防再发:
- 为 finally 路径单独加 fate classification
- 将本次样例回填 casebooks/12
```

## 7. 苏格拉底式追问

在你准备宣布结构 rollout 完成前，先问自己：

1. 我收口的是真相，还是只是在换目录。
2. 这轮 rollout 消灭的是第二真相，还是只把它藏得更深。
3. transport 差异是否真的被困进 shell 里。
4. 恢复不再靠猜了吗。
5. zombie 风险减少了吗，还是只是更难被观测了。
