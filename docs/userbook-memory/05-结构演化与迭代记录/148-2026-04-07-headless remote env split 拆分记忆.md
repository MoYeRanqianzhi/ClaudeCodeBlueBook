# headless remote env split 拆分记忆

## 本轮继续深入的核心判断

147 已经把 remote-safe command surface 从 readiness proof 里拆开了。

但正文还差最后一刀：

- `CLAUDE_CODE_REMOTE` 和 `getIsRemoteMode()` 到底是不是同一根 remote 轴？

本轮要补的更窄一句是：

- headless remote env 分支不是 interactive remote bit 的镜像

## 为什么这轮必须单列

如果不单列，正文最容易在三种偷换里回卷：

- 把 env fact 写成 UI bit
- 把 `(env || bit)` 写成“二者同义”
- 把所有 remote 分支继续压回一根轴

这三种都会把：

- env/runtime policy
- interactive/UI behavior
- dual acceptance gate

重新压扁。

## 本轮最关键的新判断

### 判断一：`CLAUDE_CODE_REMOTE` 是 env-driven CCR/headless/container fact

### 判断二：`getIsRemoteMode()` 是 bootstrap REPL/UI behavior bit

### 判断三：很多 env-only 分支根本不在回答 UI 行为，而是在回答 proxy、SSH key、permission defaults、timeout、container policy

### 判断四：`print.ts` 与 `/reload-plugins` 同时接受 env 与 bit，只是在兼容双 remote 入口，不是在证明两者同义

### 判断五：因此当前 repo 至少存在两根不同的 remote 行为轴

## 苏格拉底式自审

### 问：为什么这页不继续写 remote-safe command shell？

答：因为 147 已经回答命令面；148 继续回答“就连 remote 本身也不是一根轴”。

### 问：为什么一定要把 `pluginLoader`、`permissionSetup`、`api timeout` 拉进来？

答：因为这些 consumer 最能证明 env remote 不是 UI remote bit 的别名。

### 问：为什么一定要把 `(env || bit)` 单独写出来？

答：因为这正是最容易诱发“二者同义”误读的代码形态。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/148-CLAUDE_CODE_REMOTE、getIsRemoteMode、print、reload-plugins 与 settingsSync：为什么 headless remote 分支不是 interactive remote bit 的镜像.md`
- `bluebook/userbook/03-参考索引/02-能力边界/137-CLAUDE_CODE_REMOTE、getIsRemoteMode、print、reload-plugins 与 settingsSync 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/148-2026-04-07-headless remote env split 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 长文层只补 148
- 索引层只补 137
- 记忆层只补 148

不回写旧页，不新开子目录。

## 下一轮候选

1. 单独拆 assistant viewer 路径里 `StatusLine` 的 `remote.session_id` 为什么在结构上活着，却不一定等于远端那个 session。
2. 单独拆 `system/init.slash_commands`、`REMOTE_SAFE_COMMANDS` 与 prompt/plain-text wire routing 为什么不属于同一种命令合同。
3. 单独拆 `CLAUDE_CODE_REMOTE_MEMORY_DIR`、memdir 与 session memory 为什么不是同一层 remote 持久化语义。
