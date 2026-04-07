# `model.tsx`、`validateModel`、`getModelOptions` 与 `getUserSpecifiedModelSetting`：为什么显式拒绝、选项隐藏与 silent veto 不是同一种 allowlist contract

## 用户目标

187 已经把 model 线继续拆成：

- source selection
- allowlist admission
- default fallback

但如果正文停在这里，读者还是很容易把几个用户可见 surface 再写平：

- `/model` 报错
- `/config model` 拒绝写入
- 模型选项里看不到某些条目
- 运行时 getter 悄悄把某个 model 丢掉

这四件事看起来都和：

- `availableModels`
- `isModelAllowed(...)`

有关，于是就很容易被压成一句：

- “组织 allowlist 不允许的模型，系统都会统一拒绝”

这句还不稳。

从当前源码看，这里至少还要继续拆开三种不同 contract：

1. explicit rejection
2. option hiding
3. silent veto

如果这三层不先拆开，后面就会把：

- `model.tsx`
- `validateModel(...)`
- `getModelOptions()`
- `getUserSpecifiedModelSetting()`

重新压成同一种“allowlist 拒绝行为”。

## 第一性原理

更稳的提问不是：

- “allowlist 不让用的模型，系统会怎么处理？”

而是先问六个更底层的问题：

1. 当前 surface 在回答“用户现在显式输入了什么”，还是“UI 现在应该展示什么选项”，还是“运行时读路径现在该向下游交付什么”？
2. 当前动作发生在 write-time、option-build time，还是 getter read-time？
3. 当前结果是给出明确错误、隐藏候选，还是交出 `undefined` 让下游自己 fallback？
4. 当前 surface 会不会保留 `Default` 这样的例外项？
5. 当前校验是在用户交互前阻断，还是在内部读取时静默丢弃？
6. 我现在分析的是 user-facing allowlist contract，还是 187 已经处理过的 admission stage split？

只要这六轴不先拆开，后面就会把：

- explicit validation
- option filtering
- silent getter veto

混成一张“组织限制表”。

## 第一层：`/model` 先是 explicit rejection，不是 silent veto

`commands/model/model.tsx` 在处理 `/model` 时，一上来就先做：

- `if (model && !isModelAllowed(model))`

命中后直接：

- `onDone("Model '...' is not available ...")`
- `return`

这说明 `/model` 回答的问题首先是：

- 用户当前显式输入了一个 model，系统要不要当场接受它

它不是在回答：

- 运行时 getter 读到这个 model 之后，向下游交付什么

更准确地说：

- `/model` 是 write-time explicit rejection
- 它会当场给出用户可见错误

所以不能把 `/model` 的行为写成：

- “和 getter 一样，读的时候悄悄把它丢掉”

## 第二层：`validateModel(...)` 先是 reusable write-time validator，不是 option surface，也不是 getter 语义

`validateModel.ts` 也会先做：

- `if (!isModelAllowed(normalizedModel)) return { valid: false, error: ... }`

随后才继续处理：

- known alias
- custom model option
- cache / `sideQuery(...)`

`supportedSettings.ts` 里，
`model` 这个 config setting 又显式写着：

- `validateOnWrite: v => validateModel(String(v))`

这说明 `validateModel(...)` 回答的问题首先是：

- 某个写入动作现在能不能被接受

它不是在回答：

- 选项列表现在该展示什么

也不是在回答：

- getter 读路径现在该向下游返回哪个 model

所以更准确的理解不是：

- `validateModel(...)` 就是 allowlist 的总入口

而是：

- 它是 reusable explicit validator
- 被 `/config` 这样的 write-time surface 复用

## 第三层：`getModelOptions()` 先是 option hiding，不是 rejection，也不是 silent drop

`modelOptions.ts` 的 `getModelOptions()` 最后统一走：

- `filterModelOptionsByAllowlist(options)`

而这个过滤函数明确写着：

- always preserves the `Default` option (`value: null`)

同时，它还会在过滤前尝试把：

- current main loop model
- initial main loop model
- custom / known option

补回候选列表。

这说明 `getModelOptions()` 回答的问题首先是：

- UI 现在应该展示哪些可选项

它不是在回答：

- 用户输入这个值时要不要立刻报错

也不是在回答：

- getter 在读路径里该不该静默把它变成 `undefined`

更准确地说：

- 这是 option hiding contract
- 它通过“不给你看见”来缩窄候选面
- 同时又保留 `Default` 作为稳定出口

所以如果把 `getModelOptions()` 写成：

- “另一种显式拒绝”

也已经错位了。

## 第四层：`getUserSpecifiedModelSetting()` 才是 silent veto，它既不报错，也不负责选项面

到了 `model.ts`，
`getUserSpecifiedModelSetting()` 在挑出 candidate 后只做：

- `if (specifiedModel && !isModelAllowed(specifiedModel)) return undefined`

这里没有：

- `onDone(...)`
- validation error object
- option filtering

它只是把读路径结果静默改成：

- `undefined`

随后 `getMainLoopModel()` 再用这个结果去决定是否：

- 走 built-in default

这说明更准确的理解不是：

- getter-time veto 只是前面显式拒绝逻辑的另一个 UI 包装

而是：

- 它根本不是 UI rejection
- 也不是 option filtering
- 它是 silent read-time drop

## 第五层：同一个 `isModelAllowed(...)` 被复用，不等于复用了同一种 contract

这里最容易被写平的就是：

- 反正都是 `isModelAllowed(...)`

但当前源码里，
同一个 allowlist 判定被塞进了三种完全不同的上下文：

1. `/model`
   立即报错
2. `validateModel(...)` / `/config`
   写入前给出 invalid
3. `getModelOptions()`
   直接隐藏候选
4. `getUserSpecifiedModelSetting()`
   静默交出 `undefined`

这说明更准确的结论不是：

- allowlist 在全系统只有一种表现

而是：

- 同一条 policy predicate
- 在不同 surface 上承担不同 contract

## 第六层：`default` 的稳定保留，正好证明 option surface 与 write surface 不是一回事

`/model` 在处理 `default` 时会：

- 直接把 `model` 视为 `null`
- 跳过 custom validation

`getModelOptions()` 也会：

- 永远保留 `Default`

这说明系统对 `default` 的态度不是：

- “allowlist 一刀切”

而是：

- 在 option surface 上，`Default` 是必须保留的出口
- 在 write surface 上，`default` 也是显式允许的控制值

这进一步说明：

- option hiding
- explicit rejection
- silent getter veto

本来就不是同一种 contract。

## 第七层：因此这页真正要保护的是“同一 policy，不同 surface”

到这里更稳的写法已经不是：

- allowlist 不允许的模型，系统都会统一拒绝

而应该明确拆成：

1. `/model`
   explicit rejection
2. `/config` / `validateModel(...)`
   reusable write-time validation
3. `getModelOptions()`
   option hiding with `Default` preserved
4. `getUserSpecifiedModelSetting()`
   silent getter veto

所以更准确的结论不是：

- 这些 surface 只是不同实现细节

而是：

- 它们从一开始就在回答不同用户问题

## 第八层：为什么这页不是 187 的附录

187 讲的是：

- candidate 先被选出来
- 然后 allowlist veto
- veto 后不会 reopen lower-source

也就是：

- source selection 与 admission 的阶段错位

188 这一页更窄地关心的是：

- 同一条 allowlist predicate
- 在不同 user-facing surface 上为什么呈现出不同 contract

所以两页虽然共享：

- `isModelAllowed(...)`
- `getUserSpecifiedModelSetting()`
- `/model`
- `validateModel(...)`

但回答的问题不同：

- 187 问 veto 后为什么不回退低优先级来源
- 188 问为什么显式拒绝、选项隐藏与 silent veto 不是同一种用户合同

## 稳定面与灰度面

本页只保护稳定不变量：

- `/model` 是 explicit rejection
- `/config` / `validateModel(...)` 是 write-time validation
- `getModelOptions()` 是 option hiding，而且保留 `Default`
- `getUserSpecifiedModelSetting()` 是 silent getter veto

本页刻意不展开的灰度层包括：

- alias / custom model / sideQuery 的全部细节
- provider-specific model 选项生成
- 1M context 的资格分支
- allowlist matcher 的 family/version 细则

这些都相关，但不属于本页的 hard sentence。

## 苏格拉底式自审

### 问：为什么不能只写 `/model` 和 getter 的区别？

答：因为如果漏掉 `getModelOptions()`，读者仍会把“我根本看不到某些选项”误听成“系统在输入后拒绝了我”；option surface 这一层必须单独保住。

### 问：为什么 `validateModel(...)` 不能完全退到背景里？

答：因为 `/config` 明确复用了它，用户看到的显式写入失败不只来自 `/model`；如果不把 reusable validator 单列，正文就会误把这件事写成 `/model` 的局部特例。

### 问：为什么这页不继续讲 187 的 lower-source reopen？

答：因为那会把主语重新拉回 admission stage split，而这页真正新增的句子是：同一条 allowlist predicate 在不同 surface 上根本不是同一种合同。
