# 安全专题附录

`appendix/` 当前包含 159 篇速查文档。
这里不展开主论证，只提供证据索引、字段矩阵、状态语义、恢复/续租速查和工程迁移检查表；安全主线仍以 [../README.md](../README.md) 为准，源码剖面见 [../source-notes/README.md](../source-notes/README.md)。

## 这一子目录放什么

- 源码证据索引
- 字段矩阵、签字矩阵、状态矩阵
- 恢复、续租、cleanup、迁移与验证的速查卡

它的职责是：

`让主线负责论证，让附录负责快速核对。`

## 目录分段

- `01-13`
  检测证据、统一安全控制台、宿主降级与宿主资格。
  入口：[01-安全检测证据索引：从模块到结论的映射](01-%E5%AE%89%E5%85%A8%E6%A3%80%E6%B5%8B%E8%AF%81%E6%8D%AE%E7%B4%A2%E5%BC%95%EF%BC%9A%E4%BB%8E%E6%A8%A1%E5%9D%97%E5%88%B0%E7%BB%93%E8%AE%BA%E7%9A%84%E6%98%A0%E5%B0%84.md)、[06-统一安全控制台总图：主体、主权、仲裁、包络、外部能力、状态与审批](06-%E7%BB%9F%E4%B8%80%E5%AE%89%E5%85%A8%E6%8E%A7%E5%88%B6%E5%8F%B0%E6%80%BB%E5%9B%BE%EF%BC%9A%E4%B8%BB%E4%BD%93%E3%80%81%E4%B8%BB%E6%9D%83%E3%80%81%E4%BB%B2%E8%A3%81%E3%80%81%E5%8C%85%E7%BB%9C%E3%80%81%E5%A4%96%E9%83%A8%E8%83%BD%E5%8A%9B%E3%80%81%E7%8A%B6%E6%80%81%E4%B8%8E%E5%AE%A1%E6%89%B9.md)、[12-宿主降级速查表：宿主类型、支持子集、显式失败与安全风险](12-%E5%AE%BF%E4%B8%BB%E9%99%8D%E7%BA%A7%E9%80%9F%E6%9F%A5%E8%A1%A8%EF%BC%9A%E5%AE%BF%E4%B8%BB%E7%B1%BB%E5%9E%8B%E3%80%81%E6%94%AF%E6%8C%81%E5%AD%90%E9%9B%86%E3%80%81%E6%98%BE%E5%BC%8F%E5%A4%B1%E8%B4%A5%E4%B8%8E%E5%AE%89%E5%85%A8%E9%A3%8E%E9%99%A9.md)、[13-宿主资格速查表：观察、控制、证明三层责任与典型实现](13-%E5%AE%BF%E4%B8%BB%E8%B5%84%E6%A0%BC%E9%80%9F%E6%9F%A5%E8%A1%A8%EF%BC%9A%E8%A7%82%E5%AF%9F%E3%80%81%E6%8E%A7%E5%88%B6%E3%80%81%E8%AF%81%E6%98%8E%E4%B8%89%E5%B1%82%E8%B4%A3%E4%BB%BB%E4%B8%8E%E5%85%B8%E5%9E%8B%E5%AE%9E%E7%8E%B0.md)。
- `14-29`
  真相源、账本、声明等级、动作与完成差异字段。
  入口：[14-安全真相源速查表：实时真相、语义真相、复制真相、本地真相与UI投影](14-%E5%AE%89%E5%85%A8%E7%9C%9F%E7%9B%B8%E6%BA%90%E9%80%9F%E6%9F%A5%E8%A1%A8%EF%BC%9A%E5%AE%9E%E6%97%B6%E7%9C%9F%E7%9B%B8%E3%80%81%E8%AF%AD%E4%B9%89%E7%9C%9F%E7%9B%B8%E3%80%81%E5%A4%8D%E5%88%B6%E7%9C%9F%E7%9B%B8%E3%80%81%E6%9C%AC%E5%9C%B0%E7%9C%9F%E7%9B%B8%E4%B8%8EUI%E6%8A%95%E5%BD%B1.md)、[19-安全多账本速查表：语义账、复制账、可见账与恢复账的读者、边界与误判成本](19-%E5%AE%89%E5%85%A8%E5%A4%9A%E8%B4%A6%E6%9C%AC%E9%80%9F%E6%9F%A5%E8%A1%A8%EF%BC%9A%E8%AF%AD%E4%B9%89%E8%B4%A6%E3%80%81%E5%A4%8D%E5%88%B6%E8%B4%A6%E3%80%81%E5%8F%AF%E8%A7%81%E8%B4%A6%E4%B8%8E%E6%81%A2%E5%A4%8D%E8%B4%A6%E7%9A%84%E8%AF%BB%E8%80%85%E3%80%81%E8%BE%B9%E7%95%8C%E4%B8%8E%E8%AF%AF%E5%88%A4%E6%88%90%E6%9C%AC.md)、[23-安全声明等级速查表：状态、理由、强度与典型误读](23-%E5%AE%89%E5%85%A8%E5%A3%B0%E6%98%8E%E7%AD%89%E7%BA%A7%E9%80%9F%E6%9F%A5%E8%A1%A8%EF%BC%9A%E7%8A%B6%E6%80%81%E3%80%81%E7%90%86%E7%94%B1%E3%80%81%E5%BC%BA%E5%BA%A6%E4%B8%8E%E5%85%B8%E5%9E%8B%E8%AF%AF%E8%AF%BB.md)、[24-安全动作语法速查表：声明族、正确下一步与错误动作压缩](24-%E5%AE%89%E5%85%A8%E5%8A%A8%E4%BD%9C%E8%AF%AD%E6%B3%95%E9%80%9F%E6%9F%A5%E8%A1%A8%EF%BC%9A%E5%A3%B0%E6%98%8E%E6%97%8F%E3%80%81%E6%AD%A3%E7%A1%AE%E4%B8%8B%E4%B8%80%E6%AD%A5%E4%B8%8E%E9%94%99%E8%AF%AF%E5%8A%A8%E4%BD%9C%E5%8E%8B%E7%BC%A9.md)、[29-安全完成差异字段速查表：字段、来源、展示层级与缺失后果](29-%E5%AE%89%E5%85%A8%E5%AE%8C%E6%88%90%E5%B7%AE%E5%BC%82%E5%AD%97%E6%AE%B5%E9%80%9F%E6%9F%A5%E8%A1%A8%EF%BC%9A%E5%AD%97%E6%AE%B5%E3%80%81%E6%9D%A5%E6%BA%90%E3%80%81%E5%B1%95%E7%A4%BA%E5%B1%82%E7%BA%A7%E4%B8%8E%E7%BC%BA%E5%A4%B1%E5%90%8E%E6%9E%9C.md)。
- `30-44`
  卡片升级规则、恢复签字、中间态、清理权限与显式语义。
  入口：[30-安全完成差异卡片速查表：卡片挂载点、展示优先级、默认动作与最危险埋深](30-%E5%AE%89%E5%85%A8%E5%AE%8C%E6%88%90%E5%B7%AE%E5%BC%82%E5%8D%A1%E7%89%87%E9%80%9F%E6%9F%A5%E8%A1%A8%EF%BC%9A%E5%8D%A1%E7%89%87%E6%8C%82%E8%BD%BD%E7%82%B9%E3%80%81%E5%B1%95%E7%A4%BA%E4%BC%98%E5%85%88%E7%BA%A7%E3%80%81%E9%BB%98%E8%AE%A4%E5%8A%A8%E4%BD%9C%E4%B8%8E%E6%9C%80%E5%8D%B1%E9%99%A9%E5%9F%8B%E6%B7%B1.md)、[34-安全恢复签字层级速查表：signer、可恢复对象、不可恢复对象与典型误读](34-%E5%AE%89%E5%85%A8%E6%81%A2%E5%A4%8D%E7%AD%BE%E5%AD%97%E5%B1%82%E7%BA%A7%E9%80%9F%E6%9F%A5%E8%A1%A8%EF%BC%9Asigner%E3%80%81%E5%8F%AF%E6%81%A2%E5%A4%8D%E5%AF%B9%E8%B1%A1%E3%80%81%E4%B8%8D%E5%8F%AF%E6%81%A2%E5%A4%8D%E5%AF%B9%E8%B1%A1%E4%B8%8E%E5%85%B8%E5%9E%8B%E8%AF%AF%E8%AF%BB.md)、[35-安全恢复中间态速查表：中间态、可见账本、可用动作、禁止文案与默认跳转](35-%E5%AE%89%E5%85%A8%E6%81%A2%E5%A4%8D%E4%B8%AD%E9%97%B4%E6%80%81%E9%80%9F%E6%9F%A5%E8%A1%A8%EF%BC%9A%E4%B8%AD%E9%97%B4%E6%80%81%E3%80%81%E5%8F%AF%E8%A7%81%E8%B4%A6%E6%9C%AC%E3%80%81%E5%8F%AF%E7%94%A8%E5%8A%A8%E4%BD%9C%E3%80%81%E7%A6%81%E6%AD%A2%E6%96%87%E6%A1%88%E4%B8%8E%E9%BB%98%E8%AE%A4%E8%B7%B3%E8%BD%AC.md)、[38-安全恢复验证闭环速查表：repair path、verifier、signer与可清除对象](38-%E5%AE%89%E5%85%A8%E6%81%A2%E5%A4%8D%E9%AA%8C%E8%AF%81%E9%97%AD%E7%8E%AF%E9%80%9F%E6%9F%A5%E8%A1%A8%EF%BC%9Arepair%20path%E3%80%81verifier%E3%80%81signer%E4%B8%8E%E5%8F%AF%E6%B8%85%E9%99%A4%E5%AF%B9%E8%B1%A1.md)、[44-安全恢复显式语义速查表：hidden、suppressed、cleared与resolved](44-%E5%AE%89%E5%85%A8%E6%81%A2%E5%A4%8D%E6%98%BE%E5%BC%8F%E8%AF%AD%E4%B9%89%E9%80%9F%E6%9F%A5%E8%A1%A8%EF%BC%9Ahidden%E3%80%81suppressed%E3%80%81cleared%E4%B8%8Eresolved.md)。
- `45-60`
  词法主权、绿色词租约、续租失败、能力发布/撤回/声明仲裁。
  入口：[45-安全恢复词法主权速查表：surface、visible inputs、max allowed lexicon与forbidden stronger terms](45-%E5%AE%89%E5%85%A8%E6%81%A2%E5%A4%8D%E8%AF%8D%E6%B3%95%E4%B8%BB%E6%9D%83%E9%80%9F%E6%9F%A5%E8%A1%A8%EF%BC%9Asurface%E3%80%81visible%20inputs%E3%80%81max%20allowed%20lexicon%E4%B8%8Eforbidden%20stronger%20terms.md)、[48-安全恢复绿色词租约速查表：positive lexicon、renewal condition、revocation trigger与lease length](48-%E5%AE%89%E5%85%A8%E6%81%A2%E5%A4%8D%E7%BB%BF%E8%89%B2%E8%AF%8D%E7%A7%9F%E7%BA%A6%E9%80%9F%E6%9F%A5%E8%A1%A8%EF%BC%9Apositive%20lexicon%E3%80%81renewal%20condition%E3%80%81revocation%20trigger%E4%B8%8Elease%20length.md)、[50-安全恢复续租失败分级速查表：lease failure type、recovery capacity与next repair path](50-%E5%AE%89%E5%85%A8%E6%81%A2%E5%A4%8D%E7%BB%AD%E7%A7%9F%E5%A4%B1%E8%B4%A5%E5%88%86%E7%BA%A7%E9%80%9F%E6%9F%A5%E8%A1%A8%EF%BC%9Alease%20failure%20type%E3%80%81recovery%20capacity%E4%B8%8Enext%20repair%20path.md)、[55-安全能力发布主权速查表：surface、authoritative publisher、visible capability与forbidden overclaim](55-%E5%AE%89%E5%85%A8%E8%83%BD%E5%8A%9B%E5%8F%91%E5%B8%83%E4%B8%BB%E6%9D%83%E9%80%9F%E6%9F%A5%E8%A1%A8%EF%BC%9Asurface%E3%80%81authoritative%20publisher%E3%80%81visible%20capability%E4%B8%8Eforbidden%20overclaim.md)、[59-安全能力声明仲裁速查表：surface、authority kind、conflict winner-loser与forced handoff](59-%E5%AE%89%E5%85%A8%E8%83%BD%E5%8A%9B%E5%A3%B0%E6%98%8E%E4%BB%B2%E8%A3%81%E9%80%9F%E6%9F%A5%E8%A1%A8%EF%BC%9Asurface%E3%80%81authority%20kind%E3%80%81conflict%20winner-loser%E4%B8%8Eforced%20handoff.md)。
- `61-79`
  状态家族、句柄化、上下文连续性、恢复资格对象与重签发。
  入口：[61-安全状态替换语法速查表：change pattern、operator、safe effect与forbidden shortcut](61-%E5%AE%89%E5%85%A8%E7%8A%B6%E6%80%81%E6%9B%BF%E6%8D%A2%E8%AF%AD%E6%B3%95%E9%80%9F%E6%9F%A5%E8%A1%A8%EF%BC%9Achange%20pattern%E3%80%81operator%E3%80%81safe%20effect%E4%B8%8Eforbidden%20shortcut.md)、[64-安全状态句柄化速查表：current carrier、missing scope、recommended handle fields与migration gain](64-%E5%AE%89%E5%85%A8%E7%8A%B6%E6%80%81%E5%8F%A5%E6%9F%84%E5%8C%96%E9%80%9F%E6%9F%A5%E8%A1%A8%EF%BC%9Acurrent%20carrier%E3%80%81missing%20scope%E3%80%81recommended%20handle%20fields%E4%B8%8Emigration%20gain.md)、[67-安全授权连续性速查表：context、continuity owner、allowed substitution与boundary failure](67-%E5%AE%89%E5%85%A8%E6%8E%88%E6%9D%83%E8%BF%9E%E7%BB%AD%E6%80%A7%E9%80%9F%E6%9F%A5%E8%A1%A8%EF%BC%9Acontext%E3%80%81continuity%20owner%E3%80%81allowed%20substitution%E4%B8%8Eboundary%20failure.md)、[72-安全恢复资格证据门槛速查表：evidence piece、owner、threshold与failure downgrade](72-%E5%AE%89%E5%85%A8%E6%81%A2%E5%A4%8D%E8%B5%84%E6%A0%BC%E8%AF%81%E6%8D%AE%E9%97%A8%E6%A7%9B%E9%80%9F%E6%9F%A5%E8%A1%A8%EF%BC%9Aevidence%20piece%E3%80%81owner%E3%80%81threshold%E4%B8%8Efailure%20downgrade.md)、[79-安全资格重签发协议速查表：artifact、revocation trigger、regrant path与forbidden shortcut](79-%E5%AE%89%E5%85%A8%E8%B5%84%E6%A0%BC%E9%87%8D%E7%AD%BE%E5%8F%91%E5%8D%8F%E8%AE%AE%E9%80%9F%E6%9F%A5%E8%A1%A8%EF%BC%9Aartifact%E3%80%81revocation%20trigger%E3%80%81regrant%20path%E4%B8%8Eforbidden%20shortcut.md)。
- `80-99`
  资格中间态、投影协议、字段生命周期与验证蓝图。
  入口：[80-安全资格中间态速查表：state、meaning、allowed promise与next action](80-%E5%AE%89%E5%85%A8%E8%B5%84%E6%A0%BC%E4%B8%AD%E9%97%B4%E6%80%81%E9%80%9F%E6%9F%A5%E8%A1%A8%EF%BC%9Astate%E3%80%81meaning%E3%80%81allowed%20promise%E4%B8%8Enext%20action.md)、[87-安全资格显式投影协议字段速查表：field、meaning、example source与UI gain](87-%E5%AE%89%E5%85%A8%E8%B5%84%E6%A0%BC%E6%98%BE%E5%BC%8F%E6%8A%95%E5%BD%B1%E5%8D%8F%E8%AE%AE%E5%AD%97%E6%AE%B5%E9%80%9F%E6%9F%A5%E8%A1%A8%EF%BC%9Afield%E3%80%81meaning%E3%80%81example%20source%E4%B8%8EUI%20gain.md)、[91-安全资格字段生命周期协议化速查表：subsystem、current carrier、hidden lifecycle rule与recommended protocol fields](91-%E5%AE%89%E5%85%A8%E8%B5%84%E6%A0%BC%E5%AD%97%E6%AE%B5%E7%94%9F%E5%91%BD%E5%91%A8%E6%9C%9F%E5%8D%8F%E8%AE%AE%E5%8C%96%E9%80%9F%E6%9F%A5%E8%A1%A8%EF%BC%9Asubsystem%E3%80%81current%20carrier%E3%80%81hidden%20lifecycle%20rule%E4%B8%8Erecommended%20protocol%20fields.md)、[98-安全最小可执行验证蓝图速查表：suite、first test、minimal assertion与rollout order](98-%E5%AE%89%E5%85%A8%E6%9C%80%E5%B0%8F%E5%8F%AF%E6%89%A7%E8%A1%8C%E9%AA%8C%E8%AF%81%E8%93%9D%E5%9B%BE%E9%80%9F%E6%9F%A5%E8%A1%A8%EF%BC%9Asuite%E3%80%81first%20test%E3%80%81minimal%20assertion%E4%B8%8Erollout%20order.md)、[99-安全验证制度化接口速查表：interface、current state、missing hook与recommended contract](99-%E5%AE%89%E5%85%A8%E9%AA%8C%E8%AF%81%E5%88%B6%E5%BA%A6%E5%8C%96%E6%8E%A5%E5%8F%A3%E9%80%9F%E6%9F%A5%E8%A1%A8%EF%BC%9Ainterface%E3%80%81current%20state%E3%80%81missing%20hook%E4%B8%8Erecommended%20contract.md)。
- `100-122`
  工程迁移阶段门、词法宪法、失败语义、缩域、状态机与遗忘契约。
  入口：[100-安全工程迁移路线图速查表：phase、goal、repo touchpoint与exit criteria](100-%E5%AE%89%E5%85%A8%E5%B7%A5%E7%A8%8B%E8%BF%81%E7%A7%BB%E8%B7%AF%E7%BA%BF%E5%9B%BE%E9%80%9F%E6%9F%A5%E8%A1%A8%EF%BC%9Aphase%E3%80%81goal%E3%80%81repo%20touchpoint%E4%B8%8Eexit%20criteria.md)、[101-安全工程阶段门速查表：phase、entry gate、exit criteria与forbidden shortcut](101-%E5%AE%89%E5%85%A8%E5%B7%A5%E7%A8%8B%E9%98%B6%E6%AE%B5%E9%97%A8%E9%80%9F%E6%9F%A5%E8%A1%A8%EF%BC%9Aphase%E3%80%81entry%20gate%E3%80%81exit%20criteria%E4%B8%8Eforbidden%20shortcut.md)、[109-安全工程词法协议速查表：term、allowed layer、meaning与forbidden stronger synonym](109-%E5%AE%89%E5%85%A8%E5%B7%A5%E7%A8%8B%E8%AF%8D%E6%B3%95%E5%8D%8F%E8%AE%AE%E9%80%9F%E6%9F%A5%E8%A1%A8%EF%BC%9Aterm%E3%80%81allowed%20layer%E3%80%81meaning%E4%B8%8Eforbidden%20stronger%20synonym.md)、[115-安全真相状态机速查表：state family、entry condition、stay condition、exit operator与authoritative signer](115-%E5%AE%89%E5%85%A8%E7%9C%9F%E7%9B%B8%E7%8A%B6%E6%80%81%E6%9C%BA%E9%80%9F%E6%9F%A5%E8%A1%A8%EF%BC%9Astate%20family%E3%80%81entry%20condition%E3%80%81stay%20condition%E3%80%81exit%20operator%E4%B8%8Eauthoritative%20signer.md)、[122-安全遗忘宿主契约速查表：contract surface、current payload、missing cleanup semantics与upgrade target](122-%E5%AE%89%E5%85%A8%E9%81%97%E5%BF%98%E5%AE%BF%E4%B8%BB%E5%A5%91%E7%BA%A6%E9%80%9F%E6%9F%A5%E8%A1%A8%EF%BC%9Acontract%20surface%E3%80%81current%20payload%E3%80%81missing%20cleanup%20semantics%E4%B8%8Eupgrade%20target.md)。
- `123-132`
  cleanup 契约、偏斜治理、receipt signer 与 completion layering。
  入口：[123-安全遗忘契约机检速查表：layer、current anchor、cleanup gap与recommended guard](123-%E5%AE%89%E5%85%A8%E9%81%97%E5%BF%98%E5%A5%91%E7%BA%A6%E6%9C%BA%E6%A3%80%E9%80%9F%E6%9F%A5%E8%A1%A8%EF%BC%9Alayer%E3%80%81current%20anchor%E3%80%81cleanup%20gap%E4%B8%8Erecommended%20guard.md)、[126-安全版本偏斜治理速查表：skew object、mismatch symptom、current handling strategy、blocking level与cleanup migration implication](126-%E5%AE%89%E5%85%A8%E7%89%88%E6%9C%AC%E5%81%8F%E6%96%9C%E6%B2%BB%E7%90%86%E9%80%9F%E6%9F%A5%E8%A1%A8%EF%BC%9Askew%20object%E3%80%81mismatch%20symptom%E3%80%81current%20handling%20strategy%E3%80%81blocking%20level%E4%B8%8Ecleanup%20migration%20implication.md)、[130-安全偏斜处置回执速查表：receipt surface、matching key、completion signal、orphan handling与cleanup receipt implication](130-%E5%AE%89%E5%85%A8%E5%81%8F%E6%96%9C%E5%A4%84%E7%BD%AE%E5%9B%9E%E6%89%A7%E9%80%9F%E6%9F%A5%E8%A1%A8%EF%BC%9Areceipt%20surface%E3%80%81matching%20key%E3%80%81completion%20signal%E3%80%81orphan%20handling%E4%B8%8Ecleanup%20receipt%20implication.md)、[131-安全回执签字权速查表：surface、receipt authority、required truth input、forbidden weak receipt与future cleanup implication](131-%E5%AE%89%E5%85%A8%E5%9B%9E%E6%89%A7%E7%AD%BE%E5%AD%97%E6%9D%83%E9%80%9F%E6%9F%A5%E8%A1%A8%EF%BC%9Asurface%E3%80%81receipt%20authority%E3%80%81required%20truth%20input%E3%80%81forbidden%20weak%20receipt%E4%B8%8Efuture%20cleanup%20implication.md)、[132-安全回执与完成分层速查表：surface、what it can sign、what it cannot sign、required stronger signal与future cleanup implication](132-%E5%AE%89%E5%85%A8%E5%9B%9E%E6%89%A7%E4%B8%8E%E5%AE%8C%E6%88%90%E5%88%86%E5%B1%82%E9%80%9F%E6%9F%A5%E8%A1%A8%EF%BC%9Asurface%E3%80%81what%20it%20can%20sign%E3%80%81what%20it%20cannot%20sign%E3%80%81required%20stronger%20signal%E4%B8%8Efuture%20cleanup%20implication.md)。
- `133`
  完成与终局分层。
  入口：[133-安全完成与终局分层速查表：surface、finality scope、what it still cannot sign、stronger future readback与future cleanup implication](133-%E5%AE%89%E5%85%A8%E5%AE%8C%E6%88%90%E4%B8%8E%E7%BB%88%E5%B1%80%E5%88%86%E5%B1%82%E9%80%9F%E6%9F%A5%E8%A1%A8%EF%BC%9Asurface%E3%80%81finality%20scope%E3%80%81what%20it%20still%20cannot%20sign%E3%80%81stronger%20future%20readback%E4%B8%8Efuture%20cleanup%20implication.md)。
- `134`
  终局与遗忘分层。
  入口：[134-安全终局与遗忘分层速查表：artifact、forgetting owner、forgetting gate、why finality is still not enough与future cleanup implication](134-%E5%AE%89%E5%85%A8%E7%BB%88%E5%B1%80%E4%B8%8E%E9%81%97%E5%BF%98%E5%88%86%E5%B1%82%E9%80%9F%E6%9F%A5%E8%A1%A8%EF%BC%9Aartifact%E3%80%81forgetting%20owner%E3%80%81forgetting%20gate%E3%80%81why%20finality%20is%20still%20not%20enough%E4%B8%8Efuture%20cleanup%20implication.md)。
- `135`
  遗忘与免责释放分层。
  入口：[135-安全遗忘与免责释放分层速查表：surface、what forgetting can clear、what liability still remains、required stronger release gate与future cleanup implication](135-%E5%AE%89%E5%85%A8%E9%81%97%E5%BF%98%E4%B8%8E%E5%85%8D%E8%B4%A3%E9%87%8A%E6%94%BE%E5%88%86%E5%B1%82%E9%80%9F%E6%9F%A5%E8%A1%A8%EF%BC%9Asurface%E3%80%81what%20forgetting%20can%20clear%E3%80%81what%20liability%20still%20remains%E3%80%81required%20stronger%20release%20gate%E4%B8%8Efuture%20cleanup%20implication.md)。
- `136`
  免责释放与归档关闭分层。
  入口：[136-安全免责释放与归档关闭分层速查表：surface、what it can close、what it cannot close、required stronger archive gate与future control-plane implication](136-%E5%AE%89%E5%85%A8%E5%85%8D%E8%B4%A3%E9%87%8A%E6%94%BE%E4%B8%8E%E5%BD%92%E6%A1%A3%E5%85%B3%E9%97%AD%E5%88%86%E5%B1%82%E9%80%9F%E6%9F%A5%E8%A1%A8%EF%BC%9Asurface%E3%80%81what%20it%20can%20close%E3%80%81what%20it%20cannot%20close%E3%80%81required%20stronger%20archive%20gate%E4%B8%8Efuture%20control-plane%20implication.md)。
- `137`
  归档关闭与审计关闭分层。
  入口：[137-安全归档关闭与审计关闭分层速查表：artifact、what archive can close、what audit still retains、required stronger audit gate与future retention implication](137-%E5%AE%89%E5%85%A8%E5%BD%92%E6%A1%A3%E5%85%B3%E9%97%AD%E4%B8%8E%E5%AE%A1%E8%AE%A1%E5%85%B3%E9%97%AD%E5%88%86%E5%B1%82%E9%80%9F%E6%9F%A5%E8%A1%A8%EF%BC%9Aartifact%E3%80%81what%20archive%20can%20close%E3%80%81what%20audit%20still%20retains%E3%80%81required%20stronger%20audit%20gate%E4%B8%8Efuture%20retention%20implication.md)。
- `138`
  审计关闭与不可逆销毁分层。
  入口：[138-安全审计关闭与不可逆销毁分层速查表：artifact、what audit can close、what irreversible erasure still requires、retention owner与destruction gate](138-%E5%AE%89%E5%85%A8%E5%AE%A1%E8%AE%A1%E5%85%B3%E9%97%AD%E4%B8%8E%E4%B8%8D%E5%8F%AF%E9%80%86%E9%94%80%E6%AF%81%E5%88%86%E5%B1%82%E9%80%9F%E6%9F%A5%E8%A1%A8%EF%BC%9Aartifact%E3%80%81what%20audit%20can%20close%E3%80%81what%20irreversible%20erasure%20still%20requires%E3%80%81retention%20owner%E4%B8%8Edestruction%20gate.md)。
- `139`
  不可逆销毁与保留期主权分层。
  入口：[139-安全不可逆销毁与保留期主权分层速查表：layer、current authority、execution gate、forbidden overclaim与design implication](139-%E5%AE%89%E5%85%A8%E4%B8%8D%E5%8F%AF%E9%80%86%E9%94%80%E6%AF%81%E4%B8%8E%E4%BF%9D%E7%95%99%E6%9C%9F%E4%B8%BB%E6%9D%83%E5%88%86%E5%B1%82%E9%80%9F%E6%9F%A5%E8%A1%A8%EF%BC%9Alayer%E3%80%81current%20authority%E3%80%81execution%20gate%E3%80%81forbidden%20overclaim%E4%B8%8Edesign%20implication.md)。
- `140`
  保留期治理与执行诚实性分层。
  入口：[140-安全保留期治理与执行诚实性分层速查表：layer、what it can honestly say、what it still cannot say、missing receipt与design implication](140-%E5%AE%89%E5%85%A8%E4%BF%9D%E7%95%99%E6%9C%9F%E6%B2%BB%E7%90%86%E4%B8%8E%E6%89%A7%E8%A1%8C%E8%AF%9A%E5%AE%9E%E6%80%A7%E5%88%86%E5%B1%82%E9%80%9F%E6%9F%A5%E8%A1%A8%EF%BC%9Alayer%E3%80%81what%20it%20can%20honestly%20say%E3%80%81what%20it%20still%20cannot%20say%E3%80%81missing%20receipt%E4%B8%8Edesign%20implication.md)。
- `141`
  执行诚实性与清理隔离分层。
  入口：[141-安全执行诚实性与清理隔离分层速查表：artifact family、current isolation guard、remaining cross-session risk、missing proof与design implication](141-%E5%AE%89%E5%85%A8%E6%89%A7%E8%A1%8C%E8%AF%9A%E5%AE%9E%E6%80%A7%E4%B8%8E%E6%B8%85%E7%90%86%E9%9A%94%E7%A6%BB%E5%88%86%E5%B1%82%E9%80%9F%E6%9F%A5%E8%A1%A8%EF%BC%9Aartifact%20family%E3%80%81current%20isolation%20guard%E3%80%81remaining%20cross-session%20risk%E3%80%81missing%20proof%E4%B8%8Edesign%20implication.md)。
- `142`
  清理隔离与载体家族宪法分层。
  入口：[142-安全清理隔离与载体家族宪法分层速查表：artifact family、storage scope、cleanup root、current gate与constitution question](142-%E5%AE%89%E5%85%A8%E6%B8%85%E7%90%86%E9%9A%94%E7%A6%BB%E4%B8%8E%E8%BD%BD%E4%BD%93%E5%AE%B6%E6%97%8F%E5%AE%AA%E6%B3%95%E5%88%86%E5%B1%82%E9%80%9F%E6%9F%A5%E8%A1%A8%EF%BC%9Aartifact%20family%E3%80%81storage%20scope%E3%80%81cleanup%20root%E3%80%81current%20gate%E4%B8%8Econstitution%20question.md)。
- `143`
  载体家族宪法与制度理由分层。
  入口：[143-安全载体家族宪法与制度理由分层速查表：artifact family、primary risk object、reader scope、recovery duty、host visibility与rationale drift](143-%E5%AE%89%E5%85%A8%E8%BD%BD%E4%BD%93%E5%AE%B6%E6%97%8F%E5%AE%AA%E6%B3%95%E4%B8%8E%E5%88%B6%E5%BA%A6%E7%90%86%E7%94%B1%E5%88%86%E5%B1%82%E9%80%9F%E6%9F%A5%E8%A1%A8%EF%BC%9Aartifact%20family%E3%80%81primary%20risk%20object%E3%80%81reader%20scope%E3%80%81recovery%20duty%E3%80%81host%20visibility%E4%B8%8Erationale%20drift.md)。
- `144`
  载体家族制度理由与元数据分层。
  入口：[144-安全载体家族制度理由与元数据分层速查表：artifact family、where truth lives、what is explicit、what is still implicit与drift risk](144-%E5%AE%89%E5%85%A8%E8%BD%BD%E4%BD%93%E5%AE%B6%E6%97%8F%E5%88%B6%E5%BA%A6%E7%90%86%E7%94%B1%E4%B8%8E%E5%85%83%E6%95%B0%E6%8D%AE%E5%88%86%E5%B1%82%E9%80%9F%E6%9F%A5%E8%A1%A8%EF%BC%9Aartifact%20family%E3%80%81where%20truth%20lives%E3%80%81what%20is%20explicit%E3%80%81what%20is%20still%20implicit%E4%B8%8Edrift%20risk.md)。
- `145`
  载体家族元数据与运行时符合性分层。
  入口：[145-安全载体家族元数据与运行时符合性分层速查表：policy signal、runtime consumer、delay or skip window、missing proof与conformance risk](145-%E5%AE%89%E5%85%A8%E8%BD%BD%E4%BD%93%E5%AE%B6%E6%97%8F%E5%85%83%E6%95%B0%E6%8D%AE%E4%B8%8E%E8%BF%90%E8%A1%8C%E6%97%B6%E7%AC%A6%E5%90%88%E6%80%A7%E5%88%86%E5%B1%82%E9%80%9F%E6%9F%A5%E8%A1%A8%EF%BC%9Apolicy%20signal%E3%80%81runtime%20consumer%E3%80%81delay%20or%20skip%20window%E3%80%81missing%20proof%E4%B8%8Econformance%20risk.md)。
- `146`
  载体家族运行时符合性与反漂移验证分层。
  入口：[146-安全载体家族运行时符合性与反漂移验证分层速查表：current proof、anti-drift pattern、positive control、cleanup gap与design implication](146-%E5%AE%89%E5%85%A8%E8%BD%BD%E4%BD%93%E5%AE%B6%E6%97%8F%E8%BF%90%E8%A1%8C%E6%97%B6%E7%AC%A6%E5%90%88%E6%80%A7%E4%B8%8E%E5%8F%8D%E6%BC%82%E7%A7%BB%E9%AA%8C%E8%AF%81%E5%88%86%E5%B1%82%E9%80%9F%E6%9F%A5%E8%A1%A8%EF%BC%9Acurrent%20proof%E3%80%81anti-drift%20pattern%E3%80%81positive%20control%E3%80%81cleanup%20gap%E4%B8%8Edesign%20implication.md)。
- `147`
  载体家族反漂移验证与修复治理分层。
  入口：[147-安全载体家族反漂移验证与修复治理分层速查表：detector、governance consequence、positive control、cleanup repair gap与next control question](147-%E5%AE%89%E5%85%A8%E8%BD%BD%E4%BD%93%E5%AE%B6%E6%97%8F%E5%8F%8D%E6%BC%82%E7%A7%BB%E9%AA%8C%E8%AF%81%E4%B8%8E%E4%BF%AE%E5%A4%8D%E6%B2%BB%E7%90%86%E5%88%86%E5%B1%82%E9%80%9F%E6%9F%A5%E8%A1%A8%EF%BC%9Adetector%E3%80%81governance%20consequence%E3%80%81positive%20control%E3%80%81cleanup%20repair%20gap%E4%B8%8Enext%20control%20question.md)。
- `148`
  载体家族修复治理与迁移治理分层。
  入口：[148-安全载体家族修复治理与迁移治理分层速查表：repair decision、migration decision、positive control、cleanup transition gap与governor question](148-%E5%AE%89%E5%85%A8%E8%BD%BD%E4%BD%93%E5%AE%B6%E6%97%8F%E4%BF%AE%E5%A4%8D%E6%B2%BB%E7%90%86%E4%B8%8E%E8%BF%81%E7%A7%BB%E6%B2%BB%E7%90%86%E5%88%86%E5%B1%82%E9%80%9F%E6%9F%A5%E8%A1%A8%EF%BC%9Arepair%20decision%E3%80%81migration%20decision%E3%80%81positive%20control%E3%80%81cleanup%20transition%20gap%E4%B8%8Egovernor%20question.md)。
- `149`
  载体家族迁移治理与退役治理分层。
  入口：[149-安全载体家族迁移治理与退役治理分层速查表：migration decision、sunset decision、positive control、cleanup retirement gap与governor question](149-%E5%AE%89%E5%85%A8%E8%BD%BD%E4%BD%93%E5%AE%B6%E6%97%8F%E8%BF%81%E7%A7%BB%E6%B2%BB%E7%90%86%E4%B8%8E%E9%80%80%E5%BD%B9%E6%B2%BB%E7%90%86%E5%88%86%E5%B1%82%E9%80%9F%E6%9F%A5%E8%A1%A8%EF%BC%9Amigration%20decision%E3%80%81sunset%20decision%E3%80%81positive%20control%E3%80%81cleanup%20retirement%20gap%E4%B8%8Egovernor%20question.md)。
- `150`
  载体家族退役治理与墓碑治理分层。
  入口：[150-安全载体家族退役治理与墓碑治理分层速查表：sunset decision、tombstone decision、positive control、cleanup post-retirement gap与governor question](150-%E5%AE%89%E5%85%A8%E8%BD%BD%E4%BD%93%E5%AE%B6%E6%97%8F%E9%80%80%E5%BD%B9%E6%B2%BB%E7%90%86%E4%B8%8E%E5%A2%93%E7%A2%91%E6%B2%BB%E7%90%86%E5%88%86%E5%B1%82%E9%80%9F%E6%9F%A5%E8%A1%A8%EF%BC%9Asunset%20decision%E3%80%81tombstone%20decision%E3%80%81positive%20control%E3%80%81cleanup%20post-retirement%20gap%E4%B8%8Egovernor%20question.md)。
- `151`
  载体家族墓碑治理与复活治理分层。
  入口：[151-安全载体家族墓碑治理与复活治理分层速查表：tombstone decision、resurrection decision、positive control、cleanup re-entry gap与governor question](151-%E5%AE%89%E5%85%A8%E8%BD%BD%E4%BD%93%E5%AE%B6%E6%97%8F%E5%A2%93%E7%A2%91%E6%B2%BB%E7%90%86%E4%B8%8E%E5%A4%8D%E6%B4%BB%E6%B2%BB%E7%90%86%E5%88%86%E5%B1%82%E9%80%9F%E6%9F%A5%E8%A1%A8%EF%BC%9Atombstone%20decision%E3%80%81resurrection%20decision%E3%80%81positive%20control%E3%80%81cleanup%20re-entry%20gap%E4%B8%8Egovernor%20question.md)。
- `152`
  载体家族复活治理与再赋权治理分层。
  入口：[152-安全载体家族复活治理与再赋权治理分层速查表：resurrection decision、re-entitlement decision、positive control、cleanup requalification gap与governor question](152-%E5%AE%89%E5%85%A8%E8%BD%BD%E4%BD%93%E5%AE%B6%E6%97%8F%E5%A4%8D%E6%B4%BB%E6%B2%BB%E7%90%86%E4%B8%8E%E5%86%8D%E8%B5%8B%E6%9D%83%E6%B2%BB%E7%90%86%E5%88%86%E5%B1%82%E9%80%9F%E6%9F%A5%E8%A1%A8%EF%BC%9Aresurrection%20decision%E3%80%81re-entitlement%20decision%E3%80%81positive%20control%E3%80%81cleanup%20requalification%20gap%E4%B8%8Egovernor%20question.md)。
- `153`
  载体家族再赋权治理与重配置治理分层。
  入口：[153-安全载体家族再赋权治理与重配置治理分层速查表：re-entitlement decision、reconfiguration decision、positive control、cleanup reconfiguration gap与governor question](153-%E5%AE%89%E5%85%A8%E8%BD%BD%E4%BD%93%E5%AE%B6%E6%97%8F%E5%86%8D%E8%B5%8B%E6%9D%83%E6%B2%BB%E7%90%86%E4%B8%8E%E9%87%8D%E9%85%8D%E7%BD%AE%E6%B2%BB%E7%90%86%E5%88%86%E5%B1%82%E9%80%9F%E6%9F%A5%E8%A1%A8%EF%BC%9Are-entitlement%20decision%E3%80%81reconfiguration%20decision%E3%80%81positive%20control%E3%80%81cleanup%20reconfiguration%20gap%E4%B8%8Egovernor%20question.md)。
- `154`
  载体家族重配置治理与重新激活治理分层。
  入口：[154-安全载体家族重配置治理与重新激活治理分层速查表：reconfiguration decision、reactivation decision、positive control、cleanup reactivation gap与governor question](154-%E5%AE%89%E5%85%A8%E8%BD%BD%E4%BD%93%E5%AE%B6%E6%97%8F%E9%87%8D%E9%85%8D%E7%BD%AE%E6%B2%BB%E7%90%86%E4%B8%8E%E9%87%8D%E6%96%B0%E6%BF%80%E6%B4%BB%E6%B2%BB%E7%90%86%E5%88%86%E5%B1%82%E9%80%9F%E6%9F%A5%E8%A1%A8%EF%BC%9Areconfiguration%20decision%E3%80%81reactivation%20decision%E3%80%81positive%20control%E3%80%81cleanup%20reactivation%20gap%E4%B8%8Egovernor%20question.md)。
- `155`
  载体家族重新激活治理与就绪治理分层。
  入口：[155-安全载体家族重新激活治理与就绪治理分层速查表：reactivation decision、readiness decision、positive control、cleanup readiness gap与governor question](155-%E5%AE%89%E5%85%A8%E8%BD%BD%E4%BD%93%E5%AE%B6%E6%97%8F%E9%87%8D%E6%96%B0%E6%BF%80%E6%B4%BB%E6%B2%BB%E7%90%86%E4%B8%8E%E5%B0%B1%E7%BB%AA%E6%B2%BB%E7%90%86%E5%88%86%E5%B1%82%E9%80%9F%E6%9F%A5%E8%A1%A8%EF%BC%9Areactivation%20decision%E3%80%81readiness%20decision%E3%80%81positive%20control%E3%80%81cleanup%20readiness%20gap%E4%B8%8Egovernor%20question.md)。
- `156`
  载体家族就绪治理与连续性治理分层。
  入口：[156-安全载体家族就绪治理与连续性治理分层速查表：readiness decision、continuity decision、positive control、cleanup continuity gap与governor question](156-%E5%AE%89%E5%85%A8%E8%BD%BD%E4%BD%93%E5%AE%B6%E6%97%8F%E5%B0%B1%E7%BB%AA%E6%B2%BB%E7%90%86%E4%B8%8E%E8%BF%9E%E7%BB%AD%E6%80%A7%E6%B2%BB%E7%90%86%E5%88%86%E5%B1%82%E9%80%9F%E6%9F%A5%E8%A1%A8%EF%BC%9Areadiness%20decision%E3%80%81continuity%20decision%E3%80%81positive%20control%E3%80%81cleanup%20continuity%20gap%E4%B8%8Egovernor%20question.md)。
- `157`
  载体家族连续性治理与恢复治理分层。
  入口：[157-安全载体家族连续性治理与恢复治理分层速查表：continuity decision、recovery decision、positive control、cleanup recovery gap与governor question](157-%E5%AE%89%E5%85%A8%E8%BD%BD%E4%BD%93%E5%AE%B6%E6%97%8F%E8%BF%9E%E7%BB%AD%E6%80%A7%E6%B2%BB%E7%90%86%E4%B8%8E%E6%81%A2%E5%A4%8D%E6%B2%BB%E7%90%86%E5%88%86%E5%B1%82%E9%80%9F%E6%9F%A5%E8%A1%A8%EF%BC%9Acontinuity%20decision%E3%80%81recovery%20decision%E3%80%81positive%20control%E3%80%81cleanup%20recovery%20gap%E4%B8%8Egovernor%20question.md)。
- `158`
  载体家族恢复治理与重新并入治理分层。
  入口：[158-安全载体家族恢复治理与重新并入治理分层速查表：recovery decision、reintegration decision、positive control、cleanup reintegration gap与governor question](158-%E5%AE%89%E5%85%A8%E8%BD%BD%E4%BD%93%E5%AE%B6%E6%97%8F%E6%81%A2%E5%A4%8D%E6%B2%BB%E7%90%86%E4%B8%8E%E9%87%8D%E6%96%B0%E5%B9%B6%E5%85%A5%E6%B2%BB%E7%90%86%E5%88%86%E5%B1%82%E9%80%9F%E6%9F%A5%E8%A1%A8%EF%BC%9Arecovery%20decision%E3%80%81reintegration%20decision%E3%80%81positive%20control%E3%80%81cleanup%20reintegration%20gap%E4%B8%8Egovernor%20question.md)。
- `159`
  载体家族重新并入治理与重新投影治理分层。
  入口：[159-安全载体家族重新并入治理与重新投影治理分层速查表：reintegration decision、reprojection decision、positive control、cleanup reprojection gap与governor question](159-%E5%AE%89%E5%85%A8%E8%BD%BD%E4%BD%93%E5%AE%B6%E6%97%8F%E9%87%8D%E6%96%B0%E5%B9%B6%E5%85%A5%E6%B2%BB%E7%90%86%E4%B8%8E%E9%87%8D%E6%96%B0%E6%8A%95%E5%BD%B1%E6%B2%BB%E7%90%86%E5%88%86%E5%B1%82%E9%80%9F%E6%9F%A5%E8%A1%A8%EF%BC%9Areintegration%20decision%E3%80%81reprojection%20decision%E3%80%81positive%20control%E3%80%81cleanup%20reprojection%20gap%E4%B8%8Egovernor%20question.md)。

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
