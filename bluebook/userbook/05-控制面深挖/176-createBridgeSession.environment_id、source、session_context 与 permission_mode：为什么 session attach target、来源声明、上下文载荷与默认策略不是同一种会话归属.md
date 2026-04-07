# `createBridgeSession.environment_id`、`source`、`session_context` 与 `permission_mode`：为什么 session attach target、来源声明、上下文载荷与默认策略不是同一种会话归属

## 用户目标

175 已经把 bridge provenance 继续拆成：

- origin label
- local prior-state trust domain
- environment identity

但如果正文停在这里，读者还是很容易把 `createBridgeSession(...)` 这条 session create request 再写平：

- `environment_id` 不就是在说这条 session 从哪儿来吗？
- `source: 'remote-control'` 不也是在说来源吗？
- `session_context` 不也还是在补充“这条 session 是什么”吗？
- `permission_mode` 不也是创建时写进 session object 的归属属性吗？

这句还不稳。

从当前源码看，`createBridgeSession` request body 至少还分成四种不同的 session-side authority：

1. attach target
2. origin declaration
3. context payload
4. default policy

如果这四层不先拆开，后面就会把：

- `environment_id`
- `source: 'remote-control'`
- `session_context`
- `permission_mode`

重新压成同一种“会话归属”。

## 第一性原理

更稳的提问不是：

- “这些字段不都是 session create 时一起发给服务端的吗？”

而是先问五个更底层的问题：

1. 当前字段决定的是“附着到哪条已有 environment”，还是“声明这条 session 属于哪类来源家族”？
2. 当前字段服务的是 object attachment、provenance classification、context hydration，还是 default policy？
3. 当前字段如果改了，系统变化的是 session 绑定对象、来源家族、上下文载荷，还是默认行为策略？
4. 当前字段会不会被后续 typed readback surface 继续正面暴露？
5. 如果字段同在一个 request body，但消费主语完全不同，为什么还要把它们写成同一种归属字段？

只要这五轴不先拆开，后面就会把：

- attach
- source declaration
- context
- policy

混成一句模糊的“创建 session 时一起写进去的属性”。

## 第一层：`environment_id` 先回答“附着到哪条 env”，不是来源声明

`createSession.ts` 在 request body 里明确写：

- `environment_id: environmentId`

而 174 已经把这一层拆清楚：

- 这里消费的是注册后已经落成的 live env
- 它回答的是这条 session 现在附着到哪条 environment 对象

因此更准确的理解不是：

- `environment_id` 在说“这条 session 来自 remote-control”

而是：

- `environment_id` 在说“这条 session 要挂在哪条 environment 上”

所以它的厚度更像：

- session attach target

不是：

- session origin declaration

## 第二层：`source: 'remote-control'` 先回答“属于哪类来源家族”，不是附着到哪条 env

同一个 request body 里还明确写着：

- `source: 'remote-control'`

这最容易被误读成：

- 只是再说一遍当前挂的是 remote-control 的 environment

但更稳的证据正好相反。

`createBridgeSession(...)` 顶部注释已经写明它同时被两条入口共用：

- `claude remote-control`
- `/remote-control`

也就是说：

- 同一个 `source: 'remote-control'`
- 同时覆盖 standalone host 和 REPL bridge host

这说明它回答的问题不是：

- 这条 session 具体挂在哪条 env
- 也不是它来自 standalone 还是 REPL

而是：

- 这条 session 在更高一层会话来源家族里，属于 remote-control family

所以更准确的说法不是：

- `source` 与 `environment_id` 都在表达附着来源

而是：

- `environment_id` 负责对象附着
- `source` 负责来源声明

## 第三层：`session_context` 再厚，也不等于来源声明或附着目标

`createSession.ts` 对 `session_context` 也写得很清楚：

- `sources`
- `outcomes`
- `model`

并按 git repo / branch 构造：

- git source
- git outcome

这说明 `session_context` 回答的问题不是：

- 这条 session 附着在哪条 env
- 也不是它属于哪类来源家族

而是：

- 这条 session 在服务端创建时，带了什么工作上下文与模型上下文

更关键的一点是：

- `utils/teleport/api.ts` 当前 typed `SessionResource` 里明确暴露 `environment_id` 与 `session_context`
- 但并没有同层暴露一个 `source` 字段

这至少说明在当前这套 durable readback surface 里，

更稳定被读回的仍是：

- attach target
- context payload

而不是：

- 同等厚度的 source declaration surface

所以更准确的理解不是：

- `session_context` 就是在更详细地解释 `source`

而是：

- `session_context` 是上下文载荷
- `source` 是来源声明
- 两者主语不同

## 第四层：`permission_mode` 也在 request body 里，但它仍只回答“默认策略”，不是来源或附着

`createSession.ts` 还会条件性写入：

- `permission_mode`

39 已经把 host flag 继承拆过一次，

但在这页需要继续补一句更窄的话：

- 同在 create request body 里，不等于主语相同

`permission_mode` 回答的问题不是：

- 这条 session 附着到哪条 env
- 也不是它属于哪类来源家族
- 更不是它有哪些 git/model 上下文

而是：

- 这条 session 创建时要带哪种默认权限策略

所以它的厚度更像：

- default policy

不是：

- attach target
- source declaration
- context payload

## 第五层：同一个 `source:'remote-control'` 覆盖 standalone 与 `/remote-control`，正好证明它不是 host identity

这层是本页最硬的证据。

如果 `source: 'remote-control'` 真在回答：

- “到底是谁开的这条会话”

那么它至少应该能把：

- standalone `claude remote-control`
- REPL `/remote-control`

再往下分开。

但当前实现没有这么做。

`createBridgeSession(...)` 作为一个共用 helper，

无论被 standalone 还是 REPL wrapper 调用，

都写：

- `source: 'remote-control'`

这说明更准确的理解应是：

- `source` 在声明一层更粗的 session origin family
- 它不承担更细的 host identity 区分

因此它与：

- `workerType`
- `BridgePointer.source`

也不是同一层 provenance。

## 第六层：因此 request body 内部至少有四种不同的会话归属主语

把前面几层合起来，更稳的写法应该是：

### attach target

- `environment_id`
- 回答 session 挂到哪条 live environment

### origin declaration

- `source: 'remote-control'`
- 回答 session 属于哪类来源家族

### context payload

- `session_context`
- 回答 session 创建时携带哪些 git/model/source/outcome 上下文

### default policy

- `permission_mode`
- 回答 session 默认权限策略

所以更准确的结论不是：

- 这些字段只是会话归属的一组平行属性

而是：

- 它们同在一个 request body
- 但对象主语、消费面和后续可见性完全不同

## 第七层：为什么这页不是 39、42、174 或 175 的附录

### 不是 39 的附录

39 讲的是：

- `--name`
- `--permission-mode`
- `--sandbox`
- title 回填

这些 host flags 为什么不是同一种继承。

176 讲的是：

- 在 `createBridgeSession` request body 里，attach/source/context/policy 为什么不是同一种会话归属

39 更像 host-flag inheritance，
176 更像 request-body field authority。

### 不是 42 的附录

42 讲的是：

- environment
- work
- session

三类 lifecycle 动词为什么不是同一种操作。

176 讲的是：

- 就连 session create 这一步内部，也还要继续拆 attach/source/context/policy

42 更像 lifecycle object taxonomy，
176 更像 session-create field split。

### 不是 174 的附录

174 讲的是：

- register chain 里的 env authority

176 则继续往下走一跳，讲的是：

- session create request 里的字段主语

174 更像 environment register authority，
176 更像 session attach and declaration authority。

### 不是 175 的附录

175 讲的是：

- origin label
- trust domain
- identity

176 讲的是：

- attach target
- source declaration
- context payload
- default policy

175 还是在做 provenance 分类，
176 已经切到 session-create object authority。

## 第八层：专题内 stable / gray 也要分开

### 专题内更稳定的不变量

- `environment_id` 负责 session attach target。
- `source: 'remote-control'` 负责更粗的 session origin declaration。
- `session_context` 负责上下文载荷。
- `permission_mode` 负责默认策略。
- 同一个 `source` 会覆盖 standalone 与 `/remote-control` 两类入口。

### 更脆弱、应后置的细节

- git source/outcome 的具体构造细节
- org UUID / beta header
- permission_mode 的更细继承链
- typed SessionResource 当前未显式暴露 source 的实现现状

更准确的写法不是：

- 这页在复述 `createBridgeSession` 的所有字段

而是：

- 这页只抓同一 request body 内部不同字段主语的错位

## 苏格拉底式自审

### 问：如果删掉 `source: 'remote-control'`，这页还成立吗？

答：不成立。因为这页的核心就是要证明 attach target 与来源声明不是同一种会话归属。

### 问：为什么 `environment_id` 不能被写成“session 的来源”？

答：因为它只回答 session 当前附着到哪条 env；它不区分 remote-control family，也不区分 standalone 与 REPL host。

### 问：为什么 `source: 'remote-control'` 又不能被写成 host identity？

答：因为同一个 helper 同时被 standalone 与 `/remote-control` 共用；它声明的是更粗的来源家族，而不是更细的 host 身份。

### 问：这页是不是又写回 39 的 host flag 继承了？

答：不是。39 讲 flag 继承；176 讲 create request body 里的字段主语分裂。
