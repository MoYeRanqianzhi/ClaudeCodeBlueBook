# 安全专题入口

`security/` 当前有 236 篇正文，范围 `00-235`；`appendix/` 当前有 219 篇速查文档；`source-notes/` 当前有 86 篇源码剖面。

`security/` 研究的不是“规则越多越安全”，而是动作、权威、上下文与时间四种扩张如何被同一条治理秩序收费，以及弱 signer 为什么永远不配越级冒充强 signer。本目录覆盖从 `receipt -> completion -> finality -> forgetting -> liability release -> archive close -> audit close -> irreversible erasure` 一路推进到 stronger-request cleanup 家族的同构治理链。

## 先记四句

- 安全不是单点沙箱，也不是单点分类器，而是一套 signer、ledger 与 lifecycle control plane。
- `governance key -> externalized truth chain -> typed ask -> decision window -> continuation pricing -> durable-transient cleanup` 不是安全页和省 token 页的拼接，而是同一条治理收费链。
- `147-235` 这一整段已经证明：弱层只能说明局部事实，强层才有权宣布更高阶治理结果；任何弱层都不能越级冒充强层。
- 宿主不该自己从事件流回放拼当前真相；更稳的做法是消费 runtime 已外化的 authority / status / verdict。

## 高阶前门

想先抓第一性原理，不要从安全目录库存开始：

- [../09-三张控制面总图：世界进入模型、扩张定价与防过去写坏现在.md](../09-%E4%B8%89%E5%BC%A0%E6%8E%A7%E5%88%B6%E9%9D%A2%E6%80%BB%E5%9B%BE%EF%BC%9A%E4%B8%96%E7%95%8C%E8%BF%9B%E5%85%A5%E6%A8%A1%E5%9E%8B%E3%80%81%E6%89%A9%E5%BC%A0%E5%AE%9A%E4%BB%B7%E4%B8%8E%E9%98%B2%E8%BF%87%E5%8E%BB%E5%86%99%E5%9D%8F%E7%8E%B0%E5%9C%A8.md)
  第二张图先回答“扩张如何被定价”。
- [治理收费链为什么不是两套优化](../philosophy/19-%E5%AE%89%E5%85%A8%E4%B8%8EToken%E7%BB%8F%E6%B5%8E%E4%B8%8D%E6%98%AF%E6%9D%83%E8%A1%A1%E8%80%8C%E6%98%AF%E5%90%8C%E4%B8%80%E4%BC%98%E5%8C%96.md)
  看为什么治理收费链在动作、上下文与时间三面是同一优化。
- [宿主体验为什么只是治理收费链的外显](../philosophy/22-%E5%AE%89%E5%85%A8%E3%80%81%E6%88%90%E6%9C%AC%E4%B8%8E%E4%BD%93%E9%AA%8C%E5%BF%85%E9%A1%BB%E5%85%B1%E7%94%A8%E9%A2%84%E7%AE%97%E5%99%A8.md)
  看为什么体验只是这条治理收费链对外的结果。
- [architecture/83：反扩张治理流水线](../architecture/83-%E5%8F%8D%E6%89%A9%E5%BC%A0%E6%B2%BB%E7%90%86%E6%B5%81%E6%B0%B4%E7%BA%BF%EF%BC%9Atrusted%20inputs%E3%80%81distributed%20ask%20arbitration%E3%80%81deferred%20visibility%E4%B8%8Econtinuation%20pricing.md)
  看治理控制面如何把 `governance key`、`externalized truth chain`、`typed ask`、`decision window`、`continuation pricing` 与 `durable-vs-transient cleanup` 写成同一条流水线。
- [229-安全载体家族强请求清理迁移治理与强请求清理退役治理分层](229-安全载体家族强请求清理迁移治理与强请求清理退役治理分层.md)
- [230-安全载体家族强请求清理退役治理与强请求清理墓碑治理分层](230-安全载体家族强请求清理退役治理与强请求清理墓碑治理分层.md)
- [231-安全载体家族强请求清理墓碑治理与强请求清理复活治理分层](231-安全载体家族强请求清理墓碑治理与强请求清理复活治理分层.md)
- [232-安全载体家族强请求清理复活治理与强请求清理再赋权治理分层](232-安全载体家族强请求清理复活治理与强请求清理再赋权治理分层.md)
- [233-安全载体家族强请求清理再赋权治理与强请求清理重配置治理分层](233-安全载体家族强请求清理再赋权治理与强请求清理重配置治理分层.md)
- [234-安全载体家族强请求清理重配置治理与强请求清理重新激活治理分层](234-安全载体家族强请求清理重配置治理与强请求清理重新激活治理分层.md)
- [235-安全载体家族强请求清理重新激活治理与强请求清理就绪治理分层](235-安全载体家族强请求清理重新激活治理与强请求清理就绪治理分层.md)

## 目录分层

- `00-17`：研究方法、总论、权限/沙箱、配置与受管环境、统一安全控制台导读。
- `18-29`：检测内核、控制台字段与卡片、宿主资格、对象协议与显式降级。
- `30-69`：真相源、账本、恢复闭环、清理纪律、词法、租约与 failure path。
- `70-99`：能力发布、状态编辑、恢复资格、默认路由与 reject semantics。
- `100-138`：完成权、字段生命周期、工程迁移、验证架构与制度化接口。
- `139-235`：cleanup 契约与 signer/governor ladder，含 stronger-request cleanup 的 runtime-conformance、anti-drift、repair、migration、sunset、tombstone、resurrection、re-entitlement、reconfiguration、reactivation、readiness 等高阶治理分层。

## 按问题进入

- 想看来源主权、权限模式、能力边界与显式降级
  从 `00-29` 进入。
- 想看当前真相、账本、恢复闭环、状态编辑与 failure semantics
  从 `30-138` 进入。
- 想看 signer ladder 从 `receipt -> completion -> finality -> forgetting`
  从 `147-166` 进入。
- 想看 artifact-family cleanup ladder
  从 `167-196` 进入。
- 想看 stronger-request cleanup ladder
  从 `197-235` 进入。

## 什么时候去 appendix / source-notes / docs

- [appendix/README.md](appendix/README.md)
  想快速查矩阵、字段、词法、签字权与速查表。
- [source-notes/README.md](source-notes/README.md)
  想追单机制、单协议、单文件群的源码证据簇。
- [../../docs/development/security/README.md](../../docs/development/security/README.md)
  想看长期记忆与目录治理，而不是正文判断。

## 维护约定

- README 只保留前门判断、编号段职责与代表性入口，不再镜像全部 236 篇标题。
- `security/` 解释的是同一价格秩序的不同资产切面，不把“多道窄门”误写成“更多规则”。
- `security/` 前门优先解释 `governance key`、动作/上下文/时间收费顺序与 host truth 消费关系，不回退成权限弹窗导览。
- 深层速查表统一回 `appendix/README.md`，源码剖面统一回 `source-notes/README.md`。
- 章节推进记忆、未来候选和目录编排提示统一写入 [../../docs/development/security/README.md](../../docs/development/security/README.md)，不再回写到正文尾段。
- 需要宿主接入、验收、修复与长期回归时，回 [../playbooks/README.md](../playbooks/README.md) 与 [../risk/README.md](../risk/README.md)，不要继续停在安全首页摘要。

## 相关目录

- [../architecture/README.md](../architecture/README.md)
  更关心安全机制如何接线、如何进入状态机与恢复链。
- [../risk/README.md](../risk/README.md)
  更关心能力撤回、资格限制、误伤与治理后果。
- [../casebooks/README.md](../casebooks/README.md)
  更关心失败样本、伪成功与恢复失真。
- [../philosophy/README.md](../philosophy/README.md)
  更关心第一性原理和抽象判断。
