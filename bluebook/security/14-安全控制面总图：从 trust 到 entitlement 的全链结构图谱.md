# 安全控制面总图：从 trust 到 entitlement 的全链结构图谱

## 1. 为什么还要单独写一张总图

到目前为止，`security/` 已经覆盖了：

- 方法论
- 总论
- 权限
- 认证与受管环境
- 外部入口
- 哲学
- 第一性原理
- 状态机
- 主权矩阵
- 攻击面矩阵
- 可解释性
- 平台路线图
- 二级索引

这时最缺的反而不是新观点，  
而是一张能把这些观点重新压回同一结构里的总图。

如果没有这一章，  
读者很容易理解每个局部，  
却不容易一眼看清：

`Claude Code 的安全控制面到底是怎样从启动一路收口到高阶 entitlement 的。`

## 2. 先说结论

Claude Code 的安全控制面可以被压成一条七层主链：

1. 启动信任层
2. 配置与来源层
3. 权限模式层
4. 动作仲裁层
5. 环境隔离层
6. 外部入口层
7. 身份与 entitlement 层

而用户之所以常把它体验成黑箱，  
不是因为这条链不存在，  
而是因为：

`这条链今天更多存在于运行时结构和源码里，还没有完全被统一可视化。`

## 3. 一张压缩后的全链总图

可以先把整套安全控制面压成下面这张文字图：

```text
项目内容 / 本地配置 / 管理策略 / 插件与外部入口
                    |
                    v
        [1] 启动信任与预加载边界
            - trust 前 safe env
            - remote managed settings eligibility
                    |
                    v
        [2] 配置来源与主权收口
            - user / project / local / flag / policy
            - host-managed provider vars
            - managed-only / plugin-only policies
                    |
                    v
        [3] 权限模式切换
            - default / plan / acceptEdits / auto / bypass
            - dangerous rule strip / restore
                    |
                    v
        [4] 动作仲裁链
            - ask rules
            - tool.checkPermissions
            - safetyCheck
            - fast-path / allowlist / classifier / deny tracking
                    |
                    v
        [5] 环境隔离与外部补偿
            - sandbox fs/network
            - bypass 需更强环境边界
                    |
                    v
        [6] 外部入口收口
            - MCP
            - WebFetch
            - hooks
            - gateway / proxy
                    |
                    v
        [7] 身份与高阶资格
            - auth source
            - claude.ai OAuth entitlement
            - bridge / Remote Control
                    |
                    v
        [8] 状态面与解释层
            - permission explanation
            - status / source display
            - managed settings approval
            - gate notifications
```

这张图里最重要的一点是：

`安全不是在末端“多问一句”，而是每一层都在重新定义下一层的允许边界。`

## 4. 第一层：启动信任层在做什么

这一层的中心问题不是：

- 允许什么工具

而是：

- 当前运行时在 trust 建立前允许哪些来源先影响自己

这一层由：

- `init`
- `managedEnv.ts`
- remote managed settings eligibility

共同构成。

它要解决的是最早期、也最底层的污染风险：

- 恶意项目过早改写 env
- 宿主还没立 trust 就被导向错误 provider / auth 语义

## 5. 第二层：配置来源层在做什么

这一层的中心问题是：

`谁有资格定义运行时。`

这里不只是 later-overrides-earlier，  
还包括：

- host-managed provider vars 的反向收口
- managed-only hooks / permissions / MCP / sandbox 约束
- strictPluginOnlyCustomization 一类插件主权收口

因此它本质上不是配置层，  
而是：

`主权分配层。`

## 6. 第三层：权限模式层在做什么

这一层的中心问题是：

`当前允许系统以多大程度自动行动。`

mode 的真正作用不是 UI 风格，  
而是决定：

- 是否允许 acceptEdits fast-path
- 是否能进入 auto classifier 语义
- 是否可能进入 bypassPermissions
- 是否要先剥离 dangerous rules

也就是说，这一层负责定义：

`仲裁门槛。`

## 7. 第四层：动作仲裁层在做什么

这一层是整个安全控制面最容易被误解的一层。  
很多人会以为：

- classifier 决定一切

但从前面章节已经知道，  
实际链条是：

- ask rule
- tool.checkPermissions
- safetyCheck
- acceptEdits fast-path
- safe-tool allowlist
- classifier
- deny tracking / fallback

因此这一层真正的本质不是：

- 某个小模型在判定

而是：

`多段仲裁链在按顺序工作。`

## 8. 第五层：环境隔离层在做什么

这一层的中心问题是：

`即使某动作被允许，它还能接触到什么。`

也就是：

- 文件系统边界
- 网络边界
- bypass 模式时的外部补偿条件

Claude Code 在这里的成熟点是：

- 允许与隔离被拆开治理

这意味着：

- 某动作允许
- 不等于它能接触整个世界

## 9. 第六层：外部入口层在做什么

这一层处理的是：

- MCP
- WebFetch
- hooks
- gateway / proxy

其中心问题不是：

- 要不要扩展

而是：

- 这些扩展各自会把哪类外部世界带进来
- 是读风险、写风险、执行风险、身份风险还是语义漂移风险

这也是为什么安全专题后面必须单独长出 `09` 章风险分级矩阵。

## 10. 第七层：身份与 entitlement 层在做什么

这一层解决的是很多兼容系统最容易偷懒的一件事：

`调用成功，不代表身份语义仍然正确。`

在 Claude Code 里，这一层会明确区分：

- API key
- gateway token
- provider auth
- claude.ai OAuth
- 高阶 Remote Control entitlement

因此它实际上守的是：

`谁能代表第一方身份做高阶动作。`

## 11. 第八层：状态面与解释层为什么应被画进总图

很多系统会把解释层当作“额外附送的 UX”。

但从前面的专题推进到现在，  
已经可以明确说：

`解释层也是安全控制面的一层。`

因为如果用户看不见：

- 当前谁在定义运行时
- 当前为什么被 ask / deny
- 当前哪些 managed-only 策略在生效
- 当前 entitlement 差异为何存在

那么前面七层即使结构正确，  
最终也会在体验上退化成：

- 黑箱
- 不可信
- 难以支持

## 12. 把整条链再压成一条总时序

如果从执行时序角度压缩，可以写成这样：

1. 启动时先决定 trust 与受信 env
2. 再按来源合并配置并施加 host / managed 收口
3. 再决定当前 permission mode 与相关状态转换
4. 真正执行动作前跑仲裁链
5. 动作即使通过，也仍受 sandbox / env 隔离限制
6. 一旦动作涉及外部入口，再由对应入口自己的风险模型继续收口
7. 涉及高阶远程能力时，再由身份与 entitlement 层裁决
8. 最终结果再通过状态面与解释层回写给用户

从这个角度看，Claude Code 的安全实际上很像一条多级 pipeline。  
每一级都不是重复，而是在回答不同问题。

## 13. 从第一性原理看，这张总图在回答什么

如果再往下压，这张图其实在回答四个最根本的问题：

1. 谁有资格改变系统
2. 谁有资格批准系统行动
3. 系统在行动后还能接触到什么
4. 用户能否看见这些边界正在如何工作

这四个问题合起来，  
就是 Claude Code 安全控制面的哲学本质。

## 14. 给平台构建者的技术启示

这张总图最值得迁移的，不是某个具体实现细节，  
而是：

1. 把安全拆成多个语义层
2. 让每一层只解决自己的问题
3. 让上一层为下一层重新定义边界
4. 最后再把结果汇入统一解释层

如果没有最后一步，  
前面的分层结构对用户来说仍然几乎不可见。

## 15. 一句话总结

Claude Code 的安全控制面可以被压成一条从 trust、配置主权、permission mode、动作仲裁、环境隔离、外部入口、身份 entitlement 一路流到解释层的全链结构；它真正先进的地方，不是某一层特别强，而是这些层前后咬合得足够紧，足以把“能力存在”和“边界存在”同时做成运行时现实。 
