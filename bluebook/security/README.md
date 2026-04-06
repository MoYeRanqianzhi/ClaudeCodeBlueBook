# 安全专题索引

`security/` 当前有 139 篇正文，范围 `00-138`。本目录研究 Claude Code 的分层安全控制面：来源主权、权限模式、外部能力收口、恢复语义、能力发布、状态编辑与工程化验证。速查表与证据附录下沉到 [appendix/README.md](appendix/README.md)。

还要先记一句：

- 本目录研究的不是“规则越多越安全”，而是动作、权威、上下文与时间四种扩张怎样被同一价格秩序收费；想先抓高阶判断，先回 [../09-三张控制面总图：世界进入模型、扩张定价与防过去写坏现在.md](../09-%E4%B8%89%E5%BC%A0%E6%8E%A7%E5%88%B6%E9%9D%A2%E6%80%BB%E5%9B%BE%EF%BC%9A%E4%B8%96%E7%95%8C%E8%BF%9B%E5%85%A5%E6%A8%A1%E5%9E%8B%E3%80%81%E6%89%A9%E5%BC%A0%E5%AE%9A%E4%BB%B7%E4%B8%8E%E9%98%B2%E8%BF%87%E5%8E%BB%E5%86%99%E5%9D%8F%E7%8E%B0%E5%9C%A8.md) 的第二张图、[../philosophy/85-真正成熟的治理，不是更会拦截，而是更会为扩张定价.md](../philosophy/85-%E7%9C%9F%E6%AD%A3%E6%88%90%E7%86%9F%E7%9A%84%E6%B2%BB%E7%90%86%EF%BC%8C%E4%B8%8D%E6%98%AF%E6%9B%B4%E4%BC%9A%E6%8B%A6%E6%88%AA%EF%BC%8C%E8%80%8C%E6%98%AF%E6%9B%B4%E4%BC%9A%E4%B8%BA%E6%89%A9%E5%BC%A0%E5%AE%9A%E4%BB%B7.md) 与 [../architecture/83-反扩张治理流水线：trusted inputs、distributed ask arbitration、deferred visibility与continuation pricing.md](../architecture/83-%E5%8F%8D%E6%89%A9%E5%BC%A0%E6%B2%BB%E7%90%86%E6%B5%81%E6%B0%B4%E7%BA%BF%EF%BC%9Atrusted%20inputs%E3%80%81distributed%20ask%20arbitration%E3%80%81deferred%20visibility%E4%B8%8Econtinuation%20pricing.md)

这里的收费顺序还必须再记一句：

- 不是先问“要不要拦”，而是先问“谁有资格改边界”；`settings source / policy / trusted input` 的 authority source 先收费，然后才轮到动作、上下文与时间

这里的省 token 不是副题，而是安全控制面的上下文与时间主权。`deferred visibility`、大结果外置、`continuation pricing` 与权限、恢复、能力发布属于同一价格秩序；任何让高体积对象免费常驻主 prompt 的设计，都是未定价的上下文写权与时间占权，因此既不省 token，也不更安全。

对应地，宿主也不该自己从事件流回放拼当前真相；更稳的做法是消费 runtime 已外化的 authority/status。

## 目录分层

- `00-17`: 研究方法、总论、权限/沙箱、配置与受管环境、统一安全控制台导读。
- `18-29`: 检测内核、控制台字段与卡片、宿主资格、对象协议与显式降级。
- `30-69`: 真相源、账本、恢复闭环、清理纪律、词法、租约与 failure path。
- `70-99`: 能力发布、状态编辑、恢复资格、默认路由与 reject semantics。
- `100-138`: 完成权、字段生命周期、工程迁移、验证架构与制度化接口。

## 推荐入口

- [../09-三张控制面总图：世界进入模型、扩张定价与防过去写坏现在.md](../09-%E4%B8%89%E5%BC%A0%E6%8E%A7%E5%88%B6%E9%9D%A2%E6%80%BB%E5%9B%BE%EF%BC%9A%E4%B8%96%E7%95%8C%E8%BF%9B%E5%85%A5%E6%A8%A1%E5%9E%8B%E3%80%81%E6%89%A9%E5%BC%A0%E5%AE%9A%E4%BB%B7%E4%B8%8E%E9%98%B2%E8%BF%87%E5%8E%BB%E5%86%99%E5%9D%8F%E7%8E%B0%E5%9C%A8.md): 先抓“扩张如何被定价”的总判断
- [../07-运行时契约、知识层与生态边界.md](../07-%E8%BF%90%E8%A1%8C%E6%97%B6%E5%A5%91%E7%BA%A6%E3%80%81%E7%9F%A5%E8%AF%86%E5%B1%82%E4%B8%8E%E7%94%9F%E6%80%81%E8%BE%B9%E7%95%8C.md): 先抓 `authority source / capability governance / liability evidence` 怎样构成同一张前门
- [../philosophy/85-真正成熟的治理，不是更会拦截，而是更会为扩张定价.md](../philosophy/85-%E7%9C%9F%E6%AD%A3%E6%88%90%E7%86%9F%E7%9A%84%E6%B2%BB%E7%90%86%EF%BC%8C%E4%B8%8D%E6%98%AF%E6%9B%B4%E4%BC%9A%E6%8B%A6%E6%88%AA%EF%BC%8C%E8%80%8C%E6%98%AF%E6%9B%B4%E4%BC%9A%E4%B8%BA%E6%89%A9%E5%BC%A0%E5%AE%9A%E4%BB%B7.md): 先把“安全=定价”压成第一性原理
- [../architecture/83-反扩张治理流水线：trusted inputs、distributed ask arbitration、deferred visibility与continuation pricing.md](../architecture/83-%E5%8F%8D%E6%89%A9%E5%BC%A0%E6%B2%BB%E7%90%86%E6%B5%81%E6%B0%B4%E7%BA%BF%EF%BC%9Atrusted%20inputs%E3%80%81distributed%20ask%20arbitration%E3%80%81deferred%20visibility%E4%B8%8Econtinuation%20pricing.md): 看统一定价控制面怎样落成对象链
- [00-研究方法与可信边界](00-研究方法与可信边界.md)
- [01-安全总论：Claude Code 不是单点沙箱，而是分层安全控制面](<01-安全总论：Claude Code 不是单点沙箱，而是分层安全控制面.md>)
- [14-安全控制面总图：从 trust 到 entitlement 的全链结构图谱](<14-安全控制面总图：从 trust 到 entitlement 的全链结构图谱.md>)
- [18-安全检测技术内核：从危险模式识别到来源主权收口](18-安全检测技术内核：从危险模式识别到来源主权收口.md)
- [54-安全恢复验证闭环：为什么用户执行修复命令不等于状态已恢复，必须由对应回读与signer关环](54-安全恢复验证闭环：为什么用户执行修复命令不等于状态已恢复，必须由对应回读与signer关环.md)
- [70-安全多重窄门：为什么Claude Code不是先给全量能力再补权限，而是逐层借出能力](70-安全多重窄门：为什么Claude Code不是先给全量能力再补权限，而是逐层借出能力.md)
- [116-安全工程迁移路线图：为什么这份研究版源码若要走向可持续验证系统，必须先固化边界，再分阶段迁移而不能一次性重构](116-安全工程迁移路线图：为什么这份研究版源码若要走向可持续验证系统，必须先固化边界，再分阶段迁移而不能一次性重构.md)
- [安全专题附录索引](appendix/README.md)

## 什么时候先读正文，什么时候先读附录

- 想理解安全控制面是怎么组织的：先读 `00-29`
- 想定位“当前真相从哪里来、为什么恢复不等于完成”：先读 `30-69`
- 想看能力发布、状态编辑与恢复资格：先读 `70-99`
- 想看验证、迁移与工程化落地：先读 `100-138`
- 想快速查字段、词法、路由、签字权和速查表：直接去 `appendix/README.md`

## 维护约定

- README 只保留编号段和代表性入口，不再镜像全部 139 篇标题。
- `security/` 解释的是同一价格秩序的不同资产切面，不把“多道窄门”误写成“更多规则”。
- `security/` 前门优先解释 authority source、动作/上下文/时间收费顺序与 host truth 消费关系，不回退成权限弹窗导览。
- 深层速查和证据字典统一维护在 [appendix/README.md](appendix/README.md)。
- 需要失败样本和恢复演练时，分别回到 [../casebooks/README.md](../casebooks/README.md) 与 [../playbooks/README.md](../playbooks/README.md)。
