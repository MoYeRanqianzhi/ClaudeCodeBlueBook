# Claude Code Userbook

基于 `@anthropic-ai/claude-code` `v2.1.88` 反编译源码整理的用户手册。目标不是再写一套“架构蓝皮书”，而是回答三个用户问题：

1. Claude Code 实际能做什么。
2. 这些能力分别通过什么入口暴露。
3. 什么时候该用普通提示词、斜杠命令、技能、工具、计划模式、子代理、worktree、MCP 或插件。

## 按目标进入

如果你不是来“按目录从头读”，而是想先解决眼前问题，建议直接按目标进入：

- 快速上手：
  [00-导读.md](./00-%E5%AF%BC%E8%AF%BB.md) ->
  [01-主线使用/README.md](./01-%E4%B8%BB%E7%BA%BF%E4%BD%BF%E7%94%A8/README.md)
- 建立稳定工作流：
  [01-主线使用/05-开工前自检：状态、诊断、额度与工作边界.md](./01-%E4%B8%BB%E7%BA%BF%E4%BD%BF%E7%94%A8/05-%E5%BC%80%E5%B7%A5%E5%89%8D%E8%87%AA%E6%A3%80%EF%BC%9A%E7%8A%B6%E6%80%81%E3%80%81%E8%AF%8A%E6%96%AD%E3%80%81%E9%A2%9D%E5%BA%A6%E4%B8%8E%E5%B7%A5%E4%BD%9C%E8%BE%B9%E7%95%8C.md) ->
  [04-专题深潜/README.md](./04-%E4%B8%93%E9%A2%98%E6%B7%B1%E6%BD%9C/README.md) ->
  [05-控制面深挖/README.md](./05-%E6%8E%A7%E5%88%B6%E9%9D%A2%E6%B7%B1%E6%8C%96/README.md)
- 把上下文送准：
  [01-主线使用/02-提问、补上下文与让模型继续工作.md](./01-%E4%B8%BB%E7%BA%BF%E4%BD%BF%E7%94%A8/02-%E6%8F%90%E9%97%AE%E3%80%81%E8%A1%A5%E4%B8%8A%E4%B8%8B%E6%96%87%E4%B8%8E%E8%AE%A9%E6%A8%A1%E5%9E%8B%E7%BB%A7%E7%BB%AD%E5%B7%A5%E4%BD%9C.md) ->
  [04-专题深潜/08-上下文接入、附件与提示编译专题.md](./04-%E4%B8%93%E9%A2%98%E6%B7%B1%E6%BD%9C/08-%E4%B8%8A%E4%B8%8B%E6%96%87%E6%8E%A5%E5%85%A5%E3%80%81%E9%99%84%E4%BB%B6%E4%B8%8E%E6%8F%90%E7%A4%BA%E7%BC%96%E8%AF%91%E4%B8%93%E9%A2%98.md)
- 把结果交付给团队或外部流程：
  [04-专题深潜/09-评审、提交、导出与反馈专题.md](./04-%E4%B8%93%E9%A2%98%E6%B7%B1%E6%BD%9C/09-%E8%AF%84%E5%AE%A1%E3%80%81%E6%8F%90%E4%BA%A4%E3%80%81%E5%AF%BC%E5%87%BA%E4%B8%8E%E5%8F%8D%E9%A6%88%E4%B8%93%E9%A2%98.md)
- 运营长任务的状态、预算和模型节奏：
  [04-专题深潜/10-状态、额度、模型与节奏运营专题.md](./04-%E4%B8%93%E9%A2%98%E6%B7%B1%E6%BD%9C/10-%E7%8A%B6%E6%80%81%E3%80%81%E9%A2%9D%E5%BA%A6%E3%80%81%E6%A8%A1%E5%9E%8B%E4%B8%8E%E8%8A%82%E5%A5%8F%E8%BF%90%E8%90%A5%E4%B8%93%E9%A2%98.md)
- 提升终端交互效率：
  [04-专题深潜/11-终端交互、状态栏与输入效率专题.md](./04-%E4%B8%93%E9%A2%98%E6%B7%B1%E6%BD%9C/11-%E7%BB%88%E7%AB%AF%E4%BA%A4%E4%BA%92%E3%80%81%E7%8A%B6%E6%80%81%E6%A0%8F%E4%B8%8E%E8%BE%93%E5%85%A5%E6%95%88%E7%8E%87%E4%B8%93%E9%A2%98.md)
- 找回过去的会话与提问：
  [04-专题深潜/12-会话发现、历史检索与恢复选择专题.md](./04-%E4%B8%93%E9%A2%98%E6%B7%B1%E6%BD%9C/12-%E4%BC%9A%E8%AF%9D%E5%8F%91%E7%8E%B0%E3%80%81%E5%8E%86%E5%8F%B2%E6%A3%80%E7%B4%A2%E4%B8%8E%E6%81%A2%E5%A4%8D%E9%80%89%E6%8B%A9%E4%B8%93%E9%A2%98.md)
- 把 Claude Code 接进脚本、后台任务或协议流：
  [04-专题深潜/13-非交互、后台会话与自动化专题.md](./04-%E4%B8%93%E9%A2%98%E6%B7%B1%E6%BD%9C/13-%E9%9D%9E%E4%BA%A4%E4%BA%92%E3%80%81%E5%90%8E%E5%8F%B0%E4%BC%9A%E8%AF%9D%E4%B8%8E%E8%87%AA%E5%8A%A8%E5%8C%96%E4%B8%93%E9%A2%98.md)
- 分清 host、viewer 与 health-check 的会外入口边界：
  [05-控制面深挖/21-Host、Viewer 与 Health Check：为什么 server、remote-control、assistant、doctor 不能写成同一类会外入口.md](./05-%E6%8E%A7%E5%88%B6%E9%9D%A2%E6%B7%B1%E6%8C%96/21-Host%E3%80%81Viewer%20%E4%B8%8E%20Health%20Check%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%20server%E3%80%81remote-control%E3%80%81assistant%E3%80%81doctor%20%E4%B8%8D%E8%83%BD%E5%86%99%E6%88%90%E5%90%8C%E4%B8%80%E7%B1%BB%E4%BC%9A%E5%A4%96%E5%85%A5%E5%8F%A3.md)
- 分清 `skip trust dialog`、项目级 `.mcp.json` 批准与 health-check 为什么不是一层：
  [05-控制面深挖/22-Trust Dialog、项目级 .mcp.json 批准与 Health Check：为什么 skip trust dialog 不等于 project MCP 已被批准.md](./05-%E6%8E%A7%E5%88%B6%E9%9D%A2%E6%B7%B1%E6%8C%96/22-Trust%20Dialog%E3%80%81%E9%A1%B9%E7%9B%AE%E7%BA%A7%20.mcp.json%20%E6%89%B9%E5%87%86%E4%B8%8E%20Health%20Check%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%20skip%20trust%20dialog%20%E4%B8%8D%E7%AD%89%E4%BA%8E%20project%20MCP%20%E5%B7%B2%E8%A2%AB%E6%89%B9%E5%87%86.md)
- 初始化仓库规范、安装 CLI 与开工环境：
  [04-专题深潜/14-初始化、安装与开工环境搭建专题.md](./04-%E4%B8%93%E9%A2%98%E6%B7%B1%E6%BD%9C/14-%E5%88%9D%E5%A7%8B%E5%8C%96%E3%80%81%E5%AE%89%E8%A3%85%E4%B8%8E%E5%BC%80%E5%B7%A5%E7%8E%AF%E5%A2%83%E6%90%AD%E5%BB%BA%E4%B8%93%E9%A2%98.md)
- 切换账户、理解隐私与升级资格：
  [04-专题深潜/15-账户、隐私、资格与升级专题.md](./04-%E4%B8%93%E9%A2%98%E6%B7%B1%E6%BD%9C/15-%E8%B4%A6%E6%88%B7%E3%80%81%E9%9A%90%E7%A7%81%E3%80%81%E8%B5%84%E6%A0%BC%E4%B8%8E%E5%8D%87%E7%BA%A7%E4%B8%93%E9%A2%98.md)
- 在 IDE、Desktop、Mobile 之间继续同一工作：
  [04-专题深潜/16-IDE、Desktop、Mobile 与会话接续专题.md](./04-%E4%B8%93%E9%A2%98%E6%B7%B1%E6%BD%9C/16-IDE%E3%80%81Desktop%E3%80%81Mobile%20%E4%B8%8E%E4%BC%9A%E8%AF%9D%E6%8E%A5%E7%BB%AD%E4%B8%93%E9%A2%98.md)
- 管理插件、MCP、skills、hooks 与 agents：
  [04-专题深潜/17-插件、MCP、技能、Hooks 与 Agents 运维专题.md](./04-%E4%B8%93%E9%A2%98%E6%B7%B1%E6%BD%9C/17-%E6%8F%92%E4%BB%B6%E3%80%81MCP%E3%80%81%E6%8A%80%E8%83%BD%E3%80%81Hooks%20%E4%B8%8E%20Agents%20%E8%BF%90%E7%BB%B4%E4%B8%93%E9%A2%98.md)
- 分清 `claude ...` 本身的根入口、旗标与启动模式：
  [04-专题深潜/18-CLI 根入口、旗标与启动模式专题.md](./04-%E4%B8%93%E9%A2%98%E6%B7%B1%E6%BD%9C/18-CLI%20%E6%A0%B9%E5%85%A5%E5%8F%A3%E3%80%81%E6%97%97%E6%A0%87%E4%B8%8E%E5%90%AF%E5%8A%A8%E6%A8%A1%E5%BC%8F%E4%B8%93%E9%A2%98.md)
- 分清会外 root commands 和会内 slash 面板：
  [04-专题深潜/19-会外控制台与会内面板专题.md](./04-%E4%B8%93%E9%A2%98%E6%B7%B1%E6%BD%9C/19-%E4%BC%9A%E5%A4%96%E6%8E%A7%E5%88%B6%E5%8F%B0%E4%B8%8E%E4%BC%9A%E5%86%85%E9%9D%A2%E6%9D%BF%E4%B8%93%E9%A2%98.md)
- 分清 Settings tab、独立诊断屏、调参命令与预算分流：
  [05-控制面深挖/10-设置面板、诊断屏与运营命令：会内控制面的三层分工.md](./05-%E6%8E%A7%E5%88%B6%E9%9D%A2%E6%B7%B1%E6%8C%96/10-%E8%AE%BE%E7%BD%AE%E9%9D%A2%E6%9D%BF%E3%80%81%E8%AF%8A%E6%96%AD%E5%B1%8F%E4%B8%8E%E8%BF%90%E8%90%A5%E5%91%BD%E4%BB%A4%EF%BC%9A%E4%BC%9A%E5%86%85%E6%8E%A7%E5%88%B6%E9%9D%A2%E7%9A%84%E4%B8%89%E5%B1%82%E5%88%86%E5%B7%A5.md)
- 分清 slash command 的对象类型、执行语义与可见性边界：
  [05-控制面深挖/11-命令对象、执行语义与可见性：为什么 slash command 不是同一种按钮.md](./05-%E6%8E%A7%E5%88%B6%E9%9D%A2%E6%B7%B1%E6%8C%96/11-%E5%91%BD%E4%BB%A4%E5%AF%B9%E8%B1%A1%E3%80%81%E6%89%A7%E8%A1%8C%E8%AF%AD%E4%B9%89%E4%B8%8E%E5%8F%AF%E8%A7%81%E6%80%A7%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%20slash%20command%20%E4%B8%8D%E6%98%AF%E5%90%8C%E4%B8%80%E7%A7%8D%E6%8C%89%E9%92%AE.md)
- 分清技能来源、用户可见面、模型可调用面与动态激活面：
  [05-控制面深挖/12-技能来源、暴露面与触发：为什么 skills 菜单不是能力全集.md](./05-%E6%8E%A7%E5%88%B6%E9%9D%A2%E6%B7%B1%E6%8C%96/12-%E6%8A%80%E8%83%BD%E6%9D%A5%E6%BA%90%E3%80%81%E6%9A%B4%E9%9C%B2%E9%9D%A2%E4%B8%8E%E8%A7%A6%E5%8F%91%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%20skills%20%E8%8F%9C%E5%8D%95%E4%B8%8D%E6%98%AF%E8%83%BD%E5%8A%9B%E5%85%A8%E9%9B%86.md)
- 分清 Claude 与 remote client 真正看到的能力曝光链：
  [05-控制面深挖/13-system-init、技能提醒与 SkillTool：Claude 如何看见可用能力.md](./05-%E6%8E%A7%E5%88%B6%E9%9D%A2%E6%B7%B1%E6%8C%96/13-system-init%E3%80%81%E6%8A%80%E8%83%BD%E6%8F%90%E9%86%92%E4%B8%8E%20SkillTool%EF%BC%9AClaude%20%E5%A6%82%E4%BD%95%E7%9C%8B%E8%A7%81%E5%8F%AF%E7%94%A8%E8%83%BD%E5%8A%9B.md)
- 分清扩展面的 workspace trust、来源信任与 hooks 总闸：
  [05-控制面深挖/14-来源信任、Trust Dialog 与 Plugin-only Policy：扩展面为何分级信任.md](./05-%E6%8E%A7%E5%88%B6%E9%9D%A2%E6%B7%B1%E6%8C%96/14-%E6%9D%A5%E6%BA%90%E4%BF%A1%E4%BB%BB%E3%80%81Trust%20Dialog%20%E4%B8%8E%20Plugin-only%20Policy%EF%BC%9A%E6%89%A9%E5%B1%95%E9%9D%A2%E4%B8%BA%E4%BD%95%E5%88%86%E7%BA%A7%E4%BF%A1%E4%BB%BB.md)
- 分清 `relevant skills`、static listing 与 remote skills 的公开边界：
  [05-控制面深挖/15-技能发现、静态 listing 与 remote skills：为什么“relevant skills”不是技能总表.md](./05-%E6%8E%A7%E5%88%B6%E9%9D%A2%E6%B7%B1%E6%8C%96/15-%E6%8A%80%E8%83%BD%E5%8F%91%E7%8E%B0%E3%80%81%E9%9D%99%E6%80%81%20listing%20%E4%B8%8E%20remote%20skills%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%E2%80%9Crelevant%20skills%E2%80%9D%E4%B8%8D%E6%98%AF%E6%8A%80%E8%83%BD%E6%80%BB%E8%A1%A8.md)
- 分清 `/hooks` 可见面、注册面与执行面的错位：
  [05-控制面深挖/16-Hooks 的加载、注册、执行与 UI：为什么 `/hooks` 看到的不是实际会跑的 hooks.md](./05-%E6%8E%A7%E5%88%B6%E9%9D%A2%E6%B7%B1%E6%8C%96/16-Hooks%20%E7%9A%84%E5%8A%A0%E8%BD%BD%E3%80%81%E6%B3%A8%E5%86%8C%E3%80%81%E6%89%A7%E8%A1%8C%E4%B8%8E%20UI%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%20%60%2Fhooks%60%20%E7%9C%8B%E5%88%B0%E7%9A%84%E4%B8%8D%E6%98%AF%E5%AE%9E%E9%99%85%E4%BC%9A%E8%B7%91%E7%9A%84%20hooks.md)
- 分清 `/mcp` 菜单、按名解析与 Agent `mcpServers` 的错位：
  [05-控制面深挖/17-MCP 配置、按名解析与 Agent 引用：为什么你看到的 server 不是 Agent 真能挂上的 server.md](./05-%E6%8E%A7%E5%88%B6%E9%9D%A2%E6%B7%B1%E6%8C%96/17-MCP%20%E9%85%8D%E7%BD%AE%E3%80%81%E6%8C%89%E5%90%8D%E8%A7%A3%E6%9E%90%E4%B8%8E%20Agent%20%E5%BC%95%E7%94%A8%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%E4%BD%A0%E7%9C%8B%E5%88%B0%E7%9A%84%20server%20%E4%B8%8D%E6%98%AF%20Agent%20%E7%9C%9F%E8%83%BD%E6%8C%82%E4%B8%8A%E7%9A%84%20server.md)
- 分清插件安装面、待刷新面与当前会话激活面的错位：
  [05-控制面深挖/18-插件安装、待刷新与当前会话激活：为什么 `/reload-plugins` 不是安装器.md](./05-%E6%8E%A7%E5%88%B6%E9%9D%A2%E6%B7%B1%E6%8C%96/18-%E6%8F%92%E4%BB%B6%E5%AE%89%E8%A3%85%E3%80%81%E5%BE%85%E5%88%B7%E6%96%B0%E4%B8%8E%E5%BD%93%E5%89%8D%E4%BC%9A%E8%AF%9D%E6%BF%80%E6%B4%BB%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%20%60%2Freload-plugins%60%20%E4%B8%8D%E6%98%AF%E5%AE%89%E8%A3%85%E5%99%A8.md)
- 分清插件为什么有时自动出现、有时只停在待刷新：
  [05-控制面深挖/19-插件自动物化、Startup Trust 与 Headless 刷新：为什么插件有时会自己出现、有时只提示 `/reload-plugins`.md](./05-%E6%8E%A7%E5%88%B6%E9%9D%A2%E6%B7%B1%E6%8C%96/19-%E6%8F%92%E4%BB%B6%E8%87%AA%E5%8A%A8%E7%89%A9%E5%8C%96%E3%80%81Startup%20Trust%20%E4%B8%8E%20Headless%20%E5%88%B7%E6%96%B0%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%E6%8F%92%E4%BB%B6%E6%9C%89%E6%97%B6%E4%BC%9A%E8%87%AA%E5%B7%B1%E5%87%BA%E7%8E%B0%E3%80%81%E6%9C%89%E6%97%B6%E5%8F%AA%E6%8F%90%E7%A4%BA%20%60%2Freload-plugins%60.md)
- 分清 headless 的启动链、首问就绪与结构化宿主对象：
  [05-控制面深挖/20-Headless 启动链、首问就绪与 StructuredIO：为什么 print 不是没有 UI 的 REPL.md](./05-%E6%8E%A7%E5%88%B6%E9%9D%A2%E6%B7%B1%E6%8C%96/20-Headless%20%E5%90%AF%E5%8A%A8%E9%93%BE%E3%80%81%E9%A6%96%E9%97%AE%E5%B0%B1%E7%BB%AA%E4%B8%8E%20StructuredIO%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%20print%20%E4%B8%8D%E6%98%AF%E6%B2%A1%E6%9C%89%20UI%20%E7%9A%84%20REPL.md)
- 判断稳定面、灰度面和内部面：
  [03-参考索引/02-能力边界/README.md](./03-%E5%8F%82%E8%80%83%E7%B4%A2%E5%BC%95/02-%E8%83%BD%E5%8A%9B%E8%BE%B9%E7%95%8C/README.md)
- 建立系统总图：
  [03-参考索引/04-功能面七分法.md](./03-%E5%8F%82%E8%80%83%E7%B4%A2%E5%BC%95/04-%E5%8A%9F%E8%83%BD%E9%9D%A2%E4%B8%83%E5%88%86%E6%B3%95.md) ->
  [02-能力地图/README.md](./02-%E8%83%BD%E5%8A%9B%E5%9C%B0%E5%9B%BE/README.md)

## 阅读原则

- 本手册优先写“用户能做什么”和“为什么这样设计”。
- 所有关键结论尽量挂到源码注册点，而不是只挂到 UI 现象。
- 功能按“稳定公开能力、灰度能力、内部能力”分层，不混写。
- 源码锚点默认相对源码根 `../../claude-code-source-code/` 描述。该目录被主仓库 `.gitignore` 排除，不会跟随 worktree 一起复制。

## 结构导航

- [00-导读.md](./00-%E5%AF%BC%E8%AF%BB.md)
- [00-阅读路径.md](./00-%E9%98%85%E8%AF%BB%E8%B7%AF%E5%BE%84.md)
- [01-主线使用/README.md](./01-%E4%B8%BB%E7%BA%BF%E4%BD%BF%E7%94%A8/README.md)
- [02-能力地图/README.md](./02-%E8%83%BD%E5%8A%9B%E5%9C%B0%E5%9B%BE/README.md)
- [03-参考索引/README.md](./03-%E5%8F%82%E8%80%83%E7%B4%A2%E5%BC%95/README.md)
- [04-专题深潜/README.md](./04-%E4%B8%93%E9%A2%98%E6%B7%B1%E6%BD%9C/README.md)
- [05-控制面深挖/README.md](./05-%E6%8E%A7%E5%88%B6%E9%9D%A2%E6%B7%B1%E6%8C%96/README.md)

## 这本 Userbook 的边界

这本手册覆盖的是“发布构建中可见或可从源码恢复”的 Claude Code 能力，包括：

- CLI 启动链、REPL、会话恢复、上下文装配。
- 斜杠命令系统、技能系统、工具系统。
- 文件、Shell、Web、Notebook、LSP、MCP 等工作能力。
- 权限、沙箱、计划模式、worktree、任务、子代理、团队。
- 模型、努力等级、输出风格、成本、限额、统计。
- IDE、终端、Vim、语音、桌面、移动端、远程控制。
- 发布构建中灰度暴露、feature gate 包裹、内部专用的能力边界。

不覆盖的部分：

- Anthropic 内部 monorepo 中被 Bun `feature()` 死代码消除后完全缺失的实现细节。
- 未发布模块的运行时行为重建，只做“可从现有源码推断到的边界”说明。

## 两类专题的分工

### `04-专题深潜`

按真实工作目标组织：

- 代码工作流
- 连续性与记忆
- 治理与安全
- 扩展与集成
- 并行执行与隔离
- 前端与远程
- 上下文接入与提示编译
- 评审、提交、导出与反馈
- 状态、额度、模型与节奏运营
- 终端交互与输入效率
- 会话发现与恢复选择
- 非交互、后台会话与自动化
- 初始化、安装与开工环境搭建
- 账户、隐私、资格与升级
- IDE、Desktop、Mobile 与会话接续
- 插件、MCP、技能、Hooks 与 Agents 运维
- CLI 根入口、旗标与启动模式
- 会外控制台与会内面板

适合已经知道自己要完成什么工作，并准备读长文专题的读者。

### `05-控制面深挖`

按高价值控制面组织：

- 权限、计划模式与 worktree
- MCP、插件、技能与 hooks 的边界
- compact / resume / memory 的控制面
- agent / task / team / cron 的控制面
- 入口决策树
- status / doctor / usage 的运行时自检面
- add-dir 的工作面扩张与 sandbox 刷新
- rename / export 的会话对象化与交付
- release-notes / feedback 的版本证据与反馈回路
- 设置面板、诊断屏与运营命令的三层分工
- slash command 的对象、执行与可见性边界
- skills 的来源、暴露面与触发边界
- Claude 如何看见可用能力
- 扩展来源为何被分级信任
- `relevant skills`、static listing 与 remote skills 的公开边界
- `/hooks` 可见面、注册面与执行面的错位
- `/mcp` 总览、按名解析与 Agent 引用的错位
- `/reload-plugins` 与插件当前会话激活面的错位
- 插件自动物化链与当前会话激活链的错位
- headless 启动链、首问就绪与结构化宿主合同
- host / viewer / health-check 的会外入口边界
- `skip trust dialog`、project `.mcp.json` 批准与 health-check 的边界

适合想判断“为什么系统这样设计、哪里不能混写”的读者。
