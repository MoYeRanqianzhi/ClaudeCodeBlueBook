# 安全声明等级：为什么控制面不该只输出 yes/no，而要把状态、理由与证据强度分层编码

## 1. 为什么在 `38` 之后还要继续写“声明等级”

`38-安全未知语义` 已经回答了：

`当系统不知道时，必须显式说不知道。`

但如果继续往第一性原理再压一层，  
还会出现另一个更普遍的问题：

`当系统知道一点、知道很多、或者知道得不够稳时，它应该怎么说？`

也就是说，  
真正成熟的控制面并不只需要区分：

1. 知道
2. 不知道

它还必须区分：

1. 允许
2. 允许但带警告
3. 拒绝
4. 已连接
5. 待认证
6. 待连接
7. 失败
8. 暂时未知

Claude Code 的源码在很多地方都没有采用“布尔化声明”，  
而是在反复做另一件事：

`把结论做成带等级、带原因、带细粒度状态的声明。`

所以这一章的核心问题是：

`Claude Code 为什么不满足于 yes/no，而要把安全控制面的结论编码成分级声明？`

## 2. 最短结论

从源码看，Claude Code 的安全控制面依赖一种很成熟的语义策略：

`重要结论不应只输出二元真假，而应输出“状态 + 理由 + 强度”的组合声明。`

这至少体现在四类地方：

1. 允许类声明有 `allowed / allowed_warning / rejected`
2. 连接类声明有 `connected / failed / needs-auth / pending / disabled`
3. 运行类声明有 `blocked / waiting / completed / review_ready / failed`
4. 初始化和验证类声明有 typed reason 或 descriptive message，而不是只有 true/false

所以这一章的最短结论是：

`Claude Code 的先进性，不只在于它显式表达未知，也在于它把“已知”进一步分级成可操作的声明等级。`

## 3. 什么叫“安全声明等级”

这里说的“声明等级”，不是 UI 上的装饰标签。  
我在这一章里的定义是：

`系统对某个安全相关事实给出的、包含结论强度和原因粒度的结构化陈述。`

一个成熟的声明至少要回答三件事：

1. 当前结论是什么
2. 这个结论有多强
3. 为什么是这个结论

如果少掉其中任何一块，  
用户、宿主和支持链路就很容易把：

`一个带条件的结论`

误读成：

`一个绝对结论`

## 4. 第一类等级：允许不是布尔量，而是分成 allowed / warning / rejected

## 4.1 `SDKRateLimitInfoSchema` 明确把“可用”拆成三档

`src/entrypoints/sdk/coreSchemas.ts:1308-1336` 很关键。

这里 rate limit 信息不是：

`allowed: true/false`

而是：

1. `allowed`
2. `allowed_warning`
3. `rejected`

并且还能继续带：

- `rateLimitType`
- `utilization`
- `overageStatus`
- `overageDisabledReason`

这说明系统非常清楚：

`允许本身也有不同强度。`

## 4.2 这是一种很高阶的安全语义

因为真正危险的不是单纯的拒绝，  
而是：

`系统已经在靠近边界，却还只能输出一个模糊的“现在还能用”。`

`allowed_warning` 的存在说明作者不接受这种粗糙语义。  
他们要的是：

`把边界逼近状态单独编码出来。`

## 5. 第二类等级：连接也不是 connected / not connected，而是完整状态机

## 5.1 MCP 连接状态被明确拆成五种

`src/services/mcp/types.ts:176-248` 很有代表性：

1. `connected`
2. `failed`
3. `needs-auth`
4. `pending`
5. `disabled`

这说明作者非常清楚：

`连接失败、等待认证、正在连接、被禁用，并不是同一类“不在线”。`

## 5.2 这背后的设计启示很直接

很多系统喜欢把连接状态压成：

`connected = true / false`

Claude Code 没有这样做，  
因为这样会把：

1. 配置禁用
2. 认证缺失
3. 临时等待
4. 真正失败

全部混成一种体感。

而成熟控制面必须反过来：

`让不同恢复路径对应不同声明等级。`

## 6. 第三类等级：运行结论同样要分层，而不是只说完成或失败

## 6.1 `post_turn_summary` 直接把结果拆成状态类别、细节与重要性

`src/entrypoints/sdk/coreSchemas.ts:1550-1558` 显示：

1. `status_category` 有 `blocked / waiting / completed / review_ready / failed`
2. `status_detail` 提供具体细节
3. `is_noteworthy` 进一步标记是否值得用户关注

这说明系统并不满足于：

`turn finished`

它还要继续回答：

1. finish 到了哪一类
2. 细节是什么
3. 这是不是一个值得用户优先看的事件

## 6.2 这体现的是“结论强度产品化”

很多系统把摘要当成文学包装。  
这里恰恰不是。  
这里的 summary 结构本身就是：

`安全与运行声明等级的产品化接口。`

## 7. 第四类等级：错误也不是一团字符串，而是 typed error + extra signal

## 7.1 `SDKAPIRetryMessageSchema` 把失败做成“类型 + HTTP 状态 + 重试预算”

`src/entrypoints/sdk/coreSchemas.ts:1573-1586` 已经非常说明问题：

1. 有 `attempt`
2. 有 `max_retries`
3. 有 `retry_delay_ms`
4. 有 `error_status`
5. 有 typed `error`

这说明系统不是简单抛一句：

`API 调用失败`

而是在说：

`这是一种什么失败、还能不能重试、当前在第几次、有没有 HTTP 状态。`

## 7.2 `error_status = null` 也不是缺省噪声，而是等级语义的一部分

同一段描述直接说：

`null` 对应没有 HTTP 响应的连接类错误。

也就是说，  
就连“没有这个状态值”都被拿来编码结论类别，  
这正是成熟声明等级的特征：

`字段缺失本身也被纳入语义。`

## 8. 第五类等级：初始化与组织校验也不靠布尔值，而靠 typed reason 与 descriptive message

## 8.1 `CCRInitFailReason` 把 init 失败拆成三类

`src/cli/transports/ccrClient.ts:49-57` 明确给出：

1. `no_auth_headers`
2. `missing_epoch`
3. `worker_register_failed`

这说明作者不接受：

`initialize failed`

这种糊成一团的结论。  
他们要的是：

`失败，但失败在第几层。`

## 8.2 `OrgValidationResult` 也选择“结果对象 + message”，而不是只抛异常

`src/utils/auth.ts:1911-1994` 同样很关键：

1. `valid: true`
2. `valid: false; message: string`
3. 注释明确说 returns a result object rather than throwing
4. 并且 fail closed

这说明系统在处理组织校验时，  
并不是只想告诉调用方：

`通过 / 不通过`

而是要提供：

`为什么不通过，以及调用方如何把这个结论表达到用户面。`

## 9. 第六类等级：权限请求本身也附带解释材料

`src/entrypoints/sdk/controlSchemas.ts:106-118` 里 `can_use_tool` request 有：

1. `decision_reason`
2. `title`
3. `display_name`
4. `description`

这说明 even 在权限请求阶段，  
系统也没有把结论做成一个裸的：

`allow / deny`

而是在提供一套后续可以被宿主用来解释的材料。

这进一步说明：

`结论不是终点，结论的可解释等级也是协议的一部分。`

## 10. 第七类等级：外部暴露还会主动压掉内部模式，避免把低可信声明冒充外部事实

`src/state/onChangeAppState.ts:68-79` 与  
`src/utils/permissions/PermissionMode.ts:111-123` 说明：

1. 内部 mode 先被 externalize
2. internal-only mode 不直接暴露到 CCR metadata
3. 噪声级变化会被跳过

这说明系统不仅在给声明分级，  
还在做另一件更细的事：

`不是每一个内部已知状态，都配拥有同等外部声明资格。`

这是一种更深的声明纪律：

`先决定什么能被外化，再决定如何外化。`

## 11. 把这些例子压成一条底层公理

我会把它压成一句话：

`安全控制面不应只输出结论，还必须输出结论的等级、条件和理由。`

这条公理几乎可以解释前面所有高质量语义：

1. allowed / warning / rejected
2. connected / needs-auth / pending / disabled / failed
3. blocked / waiting / review_ready / completed / failed
4. typed init reason
5. descriptive org-validation result
6. decision_reason
7. internal -> external 的外化过滤

## 12. 技术先进性与技术启示

这一章最重要的技术判断是：

`Claude Code 的先进性，不只在于结论显式，还在于结论分级。`

这对其他 Agent 平台构建者的启示很直接：

1. 不要把所有安全状态压成布尔量
2. 要把“允许但临近边界”单独编码出来
3. 要把“失败原因”做成 typed reason，而不是只留日志
4. 要把“需要用户注意”的等级单独编码
5. 要区分内部真相与外部声明等级

否则系统最容易出现的不是判断错误，  
而是另一种更隐蔽的失败：

`结论本身没错，但语义粒度太粗，导致恢复、支持和用户动作全都走偏。`

## 13. 哲学本质

这一章更深层的哲学是：

`真相不只有内容，还有语气。`

很多系统以为只要把“结果是什么”说出来就够了。  
Claude Code 的源码更接近另一种成熟认识：

`同样一句结果，如果不标出强度、条件和原因，就仍然可能是不诚实的。`

这意味着安全控制面的成熟，不只在于它“说了什么”，  
还在于它：

`以多大把握、在什么条件下、用什么等级来说。`

## 14. 苏格拉底式反思：这章最容易犯什么错

### 14.1 我们是不是把很多产品字段过度哲学化了

有风险。  
但这些字段并非随机 UI 糖衣，  
而是多个模块里反复出现的结构性选择。

### 14.2 分级会不会让接口过于复杂

会。  
但如果不分级，  
复杂性只是被偷偷转嫁给用户、宿主和支持团队。

### 14.3 “未知语义”与“声明等级”会不会重叠

会有交叉。  
但 `38` 关注的是“什么时候不能给结论”，  
这一章关注的是“已经给结论时，结论应当多细地分级”。

## 15. 结语

`38` 回答的是：系统不知道时必须显式说不知道。  
`39` 继续推进后的结论则是：

`系统即使知道，也不能只给粗糙的 yes/no，而应把结论的等级、理由和强度编码进去。`

这意味着 Claude Code 更深层的安全启示之一是：

`成熟安全控制面不是二元裁决器，而是一台会分级说话的声明机器。`
