# 安全专题附录

`appendix/` 当前包含 208 篇速查文档。
这里不展开主论证，只提供证据索引、字段矩阵、状态语义、恢复/续租速查和工程迁移检查表；安全主线仍以 [../README.md](../README.md) 为准，源码剖面见 [../source-notes/README.md](../source-notes/README.md)。
附录层也继续继承 `问题分型 -> 工作对象 -> 控制面 -> 入口`；它只负责核对字段、矩阵与速查对象，不额外签 signer / verdict。

## 这一子目录放什么

- 源码证据索引
- 字段矩阵、签字矩阵、状态矩阵
- 恢复、续租、cleanup、迁移与验证的速查卡

它的职责是：

`让主线负责论证，让附录负责快速核对。`

这里还应再多记一句：

- `continuity` 相关速查在附录层也不构成第四类附录家族；它们只是治理收费链与 cleanup 时间轴上的核对卡。

## 目录分段

- `01-29` 证据与治理真相速查：先核对检测证据、宿主资格、真相源、账本、声明等级与动作/完成差异字段。
  代表入口：[01-安全检测证据索引](01-%E5%AE%89%E5%85%A8%E6%A3%80%E6%B5%8B%E8%AF%81%E6%8D%AE%E7%B4%A2%E5%BC%95%EF%BC%9A%E4%BB%8E%E6%A8%A1%E5%9D%97%E5%88%B0%E7%BB%93%E8%AE%BA%E7%9A%84%E6%98%A0%E5%B0%84.md)、[13-宿主资格速查表](13-%E5%AE%BF%E4%B8%BB%E8%B5%84%E6%A0%BC%E9%80%9F%E6%9F%A5%E8%A1%A8%EF%BC%9A%E8%A7%82%E5%AF%9F%E3%80%81%E6%8E%A7%E5%88%B6%E3%80%81%E8%AF%81%E6%98%8E%E4%B8%89%E5%B1%82%E8%B4%A3%E4%BB%BB%E4%B8%8E%E5%85%B8%E5%9E%8B%E5%AE%9E%E7%8E%B0.md)、[19-安全多账本速查表](19-%E5%AE%89%E5%85%A8%E5%A4%9A%E8%B4%A6%E6%9C%AC%E9%80%9F%E6%9F%A5%E8%A1%A8%EF%BC%9A%E8%AF%AD%E4%B9%89%E8%B4%A6%E3%80%81%E5%A4%8D%E5%88%B6%E8%B4%A6%E3%80%81%E5%8F%AF%E8%A7%81%E8%B4%A6%E4%B8%8E%E6%81%A2%E5%A4%8D%E8%B4%A6%E7%9A%84%E8%AF%BB%E8%80%85%E3%80%81%E8%BE%B9%E7%95%8C%E4%B8%8E%E8%AF%AF%E5%88%A4%E6%88%90%E6%9C%AC.md)、[29-安全完成差异字段速查表](29-%E5%AE%89%E5%85%A8%E5%AE%8C%E6%88%90%E5%B7%AE%E5%BC%82%E5%AD%97%E6%AE%B5%E9%80%9F%E6%9F%A5%E8%A1%A8%EF%BC%9A%E5%AD%97%E6%AE%B5%E3%80%81%E6%9D%A5%E6%BA%90%E3%80%81%E5%B1%95%E7%A4%BA%E5%B1%82%E7%BA%A7%E4%B8%8E%E7%BC%BA%E5%A4%B1%E5%90%8E%E6%9E%9C.md)。
- `30-44` 恢复签字与显式语义速查：先核对完成差异卡、恢复 signer、中间态、验证闭环与显式恢复语义。
  代表入口：[30-安全完成差异卡片速查表](30-%E5%AE%89%E5%85%A8%E5%AE%8C%E6%88%90%E5%B7%AE%E5%BC%82%E5%8D%A1%E7%89%87%E9%80%9F%E6%9F%A5%E8%A1%A8%EF%BC%9A%E5%8D%A1%E7%89%87%E6%8C%82%E8%BD%BD%E7%82%B9%E3%80%81%E5%B1%95%E7%A4%BA%E4%BC%98%E5%85%88%E7%BA%A7%E3%80%81%E9%BB%98%E8%AE%A4%E5%8A%A8%E4%BD%9C%E4%B8%8E%E6%9C%80%E5%8D%B1%E9%99%A9%E5%9F%8B%E6%B7%B1.md)、[34-安全恢复签字层级速查表](34-%E5%AE%89%E5%85%A8%E6%81%A2%E5%A4%8D%E7%AD%BE%E5%AD%97%E5%B1%82%E7%BA%A7%E9%80%9F%E6%9F%A5%E8%A1%A8%EF%BC%9Asigner%E3%80%81%E5%8F%AF%E6%81%A2%E5%A4%8D%E5%AF%B9%E8%B1%A1%E3%80%81%E4%B8%8D%E5%8F%AF%E6%81%A2%E5%A4%8D%E5%AF%B9%E8%B1%A1%E4%B8%8E%E5%85%B8%E5%9E%8B%E8%AF%AF%E8%AF%BB.md)、[38-安全恢复验证闭环速查表](38-%E5%AE%89%E5%85%A8%E6%81%A2%E5%A4%8D%E9%AA%8C%E8%AF%81%E9%97%AD%E7%8E%AF%E9%80%9F%E6%9F%A5%E8%A1%A8%EF%BC%9Arepair%20path%E3%80%81verifier%E3%80%81signer%E4%B8%8E%E5%8F%AF%E6%B8%85%E9%99%A4%E5%AF%B9%E8%B1%A1.md)、[44-安全恢复显式语义速查表](44-%E5%AE%89%E5%85%A8%E6%81%A2%E5%A4%8D%E6%98%BE%E5%BC%8F%E8%AF%AD%E4%B9%89%E9%80%9F%E6%9F%A5%E8%A1%A8%EF%BC%9Ahidden%E3%80%81suppressed%E3%80%81cleared%E4%B8%8Eresolved.md)。
- `45-79` 词法主权、能力声明、连续性与重签发速查：先核对绿色词租约、能力发布/撤回、continuity owner、恢复资格门槛与资格重签发。
  代表入口：[45-安全恢复词法主权速查表](45-%E5%AE%89%E5%85%A8%E6%81%A2%E5%A4%8D%E8%AF%8D%E6%B3%95%E4%B8%BB%E6%9D%83%E9%80%9F%E6%9F%A5%E8%A1%A8%EF%BC%9Asurface%E3%80%81visible%20inputs%E3%80%81max%20allowed%20lexicon%E4%B8%8Eforbidden%20stronger%20terms.md)、[55-安全能力发布主权速查表](55-%E5%AE%89%E5%85%A8%E8%83%BD%E5%8A%9B%E5%8F%91%E5%B8%83%E4%B8%BB%E6%9D%83%E9%80%9F%E6%9F%A5%E8%A1%A8%EF%BC%9Asurface%E3%80%81authoritative%20publisher%E3%80%81visible%20capability%E4%B8%8Eforbidden%20overclaim.md)、[67-安全授权连续性速查表](67-%E5%AE%89%E5%85%A8%E6%8E%88%E6%9D%83%E8%BF%9E%E7%BB%AD%E6%80%A7%E9%80%9F%E6%9F%A5%E8%A1%A8%EF%BC%9Acontext%E3%80%81continuity%20owner%E3%80%81allowed%20substitution%E4%B8%8Eboundary%20failure.md)、[79-安全资格重签发协议速查表](79-%E5%AE%89%E5%85%A8%E8%B5%84%E6%A0%BC%E9%87%8D%E7%AD%BE%E5%8F%91%E5%8D%8F%E8%AE%AE%E9%80%9F%E6%9F%A5%E8%A1%A8%EF%BC%9Aartifact%E3%80%81revocation%20trigger%E3%80%81regrant%20path%E4%B8%8Eforbidden%20shortcut.md)。
- `80-122` 投影字段、验证蓝图、阶段门与遗忘契约速查：先核对中间态、显式投影字段、字段生命周期、最小验证接口、工程阶段门、状态机与宿主遗忘契约。
  代表入口：[87-安全资格显式投影协议字段速查表](87-%E5%AE%89%E5%85%A8%E8%B5%84%E6%A0%BC%E6%98%BE%E5%BC%8F%E6%8A%95%E5%BD%B1%E5%8D%8F%E8%AE%AE%E5%AD%97%E6%AE%B5%E9%80%9F%E6%9F%A5%E8%A1%A8%EF%BC%9Afield%E3%80%81meaning%E3%80%81example%20source%E4%B8%8EUI%20gain.md)、[98-安全最小可执行验证蓝图速查表](98-%E5%AE%89%E5%85%A8%E6%9C%80%E5%B0%8F%E5%8F%AF%E6%89%A7%E8%A1%8C%E9%AA%8C%E8%AF%81%E8%93%9D%E5%9B%BE%E9%80%9F%E6%9F%A5%E8%A1%A8%EF%BC%9Asuite%E3%80%81first%20test%E3%80%81minimal%20assertion%E4%B8%8Erollout%20order.md)、[101-安全工程阶段门速查表](101-%E5%AE%89%E5%85%A8%E5%B7%A5%E7%A8%8B%E9%98%B6%E6%AE%B5%E9%97%A8%E9%80%9F%E6%9F%A5%E8%A1%A8%EF%BC%9Aphase%E3%80%81entry%20gate%E3%80%81exit%20criteria%E4%B8%8Eforbidden%20shortcut.md)、[115-安全真相状态机速查表](115-%E5%AE%89%E5%85%A8%E7%9C%9F%E7%9B%B8%E7%8A%B6%E6%80%81%E6%9C%BA%E9%80%9F%E6%9F%A5%E8%A1%A8%EF%BC%9Astate%20family%E3%80%81entry%20condition%E3%80%81stay%20condition%E3%80%81exit%20operator%E4%B8%8Eauthoritative%20signer.md)、[122-安全遗忘宿主契约速查表](122-%E5%AE%89%E5%85%A8%E9%81%97%E5%BF%98%E5%AE%BF%E4%B8%BB%E5%A5%91%E7%BA%A6%E9%80%9F%E6%9F%A5%E8%A1%A8%EF%BC%9Acontract%20surface%E3%80%81current%20payload%E3%80%81missing%20cleanup%20semantics%E4%B8%8Eupgrade%20target.md)。
- `123-146` completion/finality/forgetting/release/archive/retention 分层速查：先核对回执、完成、终局、遗忘、免责释放、归档关闭、审计关闭、不可逆擦除与 cleanup 家族治理的关系。
  代表入口：[131-安全回执签字权速查表](131-%E5%AE%89%E5%85%A8%E5%9B%9E%E6%89%A7%E7%AD%BE%E5%AD%97%E6%9D%83%E9%80%9F%E6%9F%A5%E8%A1%A8%EF%BC%9Asurface%E3%80%81receipt%20authority%E3%80%81required%20truth%20input%E3%80%81forbidden%20weak%20receipt%E4%B8%8Efuture%20cleanup%20implication.md)、[133-安全完成与终局分层速查表](133-%E5%AE%89%E5%85%A8%E5%AE%8C%E6%88%90%E4%B8%8E%E7%BB%88%E5%B1%80%E5%88%86%E5%B1%82%E9%80%9F%E6%9F%A5%E8%A1%A8%EF%BC%9Asurface%E3%80%81finality%20scope%E3%80%81what%20it%20still%20cannot%20sign%E3%80%81stronger%20future%20readback%E4%B8%8Efuture%20cleanup%20implication.md)、[138-安全审计关闭与不可逆销毁分层速查表](138-%E5%AE%89%E5%85%A8%E5%AE%A1%E8%AE%A1%E5%85%B3%E9%97%AD%E4%B8%8E%E4%B8%8D%E5%8F%AF%E9%80%86%E9%94%80%E6%AF%81%E5%88%86%E5%B1%82%E9%80%9F%E6%9F%A5%E8%A1%A8%EF%BC%9Aartifact%E3%80%81what%20audit%20can%20close%E3%80%81what%20irreversible%20erasure%20still%20requires%E3%80%81retention%20owner%E4%B8%8Edestruction%20gate.md)、[142-安全清理隔离与载体家族宪法分层速查表](142-%E5%AE%89%E5%85%A8%E6%B8%85%E7%90%86%E9%9A%94%E7%A6%BB%E4%B8%8E%E8%BD%BD%E4%BD%93%E5%AE%B6%E6%97%8F%E5%AE%AA%E6%B3%95%E5%88%86%E5%B1%82%E9%80%9F%E6%9F%A5%E8%A1%A8%EF%BC%9Aartifact%20family%E3%80%81storage%20scope%E3%80%81cleanup%20root%E3%80%81current%20gate%E4%B8%8Econstitution%20question.md)、[146-安全载体家族运行时符合性与反漂移验证分层速查表](146-%E5%AE%89%E5%85%A8%E8%BD%BD%E4%BD%93%E5%AE%B6%E6%97%8F%E8%BF%90%E8%A1%8C%E6%97%B6%E7%AC%A6%E5%90%88%E6%80%A7%E4%B8%8E%E5%8F%8D%E6%BC%82%E7%A7%BB%E9%AA%8C%E8%AF%81%E5%88%86%E5%B1%82%E9%80%9F%E6%9F%A5%E8%A1%A8%EF%BC%9Acurrent%20proof%E3%80%81anti-drift%20pattern%E3%80%81positive%20control%E3%80%81cleanup%20gap%E4%B8%8Edesign%20implication.md)。
- `147-208` stronger-request cleanup ladder 与载体家族治理尾段：先看修复/迁移/续打/终局，再看 retention、隔离、重新并入与制度元数据。
  代表入口：[147-安全载体家族反漂移验证与修复治理分层速查表](147-%E5%AE%89%E5%85%A8%E8%BD%BD%E4%BD%93%E5%AE%B6%E6%97%8F%E5%8F%8D%E6%BC%82%E7%A7%BB%E9%AA%8C%E8%AF%81%E4%B8%8E%E4%BF%AE%E5%A4%8D%E6%B2%BB%E7%90%86%E5%88%86%E5%B1%82%E9%80%9F%E6%9F%A5%E8%A1%A8%EF%BC%9Adetector%E3%80%81governance%20consequence%E3%80%81positive%20control%E3%80%81cleanup%20repair%20gap%E4%B8%8Enext%20control%20question.md)、[163-安全载体家族step-up重授权治理与强请求续打治理分层速查表](163-%E5%AE%89%E5%85%A8%E8%BD%BD%E4%BD%93%E5%AE%B6%E6%97%8Fstep-up%E9%87%8D%E6%8E%88%E6%9D%83%E6%B2%BB%E7%90%86%E4%B8%8E%E5%BC%BA%E8%AF%B7%E6%B1%82%E7%BB%AD%E6%89%93%E6%B2%BB%E7%90%86%E5%88%86%E5%B1%82%E9%80%9F%E6%9F%A5%E8%A1%A8%EF%BC%9Astep-up%20reauthorization%20decision%E3%80%81stronger-request%20continuation%20decision%E3%80%81positive%20control%E3%80%81cleanup%20continuation%20gap%E4%B8%8Egovernor%20question.md)、[188-安全载体家族强请求清理就绪治理与强请求清理连续性治理分层速查表](188-安全载体家族强请求清理就绪治理与强请求清理连续性治理分层速查表：continuity budget、stale retry line、pool repair与governor question.md)、[198-安全载体家族强请求清理终局治理与强请求清理遗忘治理分层速查表](198-安全载体家族强请求清理终局治理与强请求清理遗忘治理分层速查表：finality scope、forgetting gate、retained memory与governor question.md)、[208-安全载体家族强请求清理制度理由治理与强请求清理制度元数据治理分层速查表](208-安全载体家族强请求清理制度理由治理与强请求清理制度元数据治理分层速查表：carrier family、where truth lives、who currently consumes it、metadata gap与drift symptom.md)。

如果需要逐篇平铺查找，直接进编号页或使用文件名搜索；本 README 不再复写 208 条库存。

## 怎么配合主线读

- 读 [../README.md](../README.md) 时，把附录当速查卡，不当主阅读路径。
- 想快速核对“字段从哪来、谁能签字、哪条路径被禁止、当前该看哪张卡”，优先来附录。
- 需要完整论证、设计判断和章节间关系时，返回 [../README.md](../README.md)。

## 和主线、源码剖面的分工

- [../README.md](../README.md)
  主线负责论证链、哲学判断与设计结论。
- [../source-notes/README.md](../source-notes/README.md)
  源码剖面负责更贴近单机制、单协议、单文件群的证据拆解。

附录的定位只有一个：

`把高密度结论压成能快速回查的矩阵。`
