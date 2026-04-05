# IDE、终端、Vim、语音、桌面与远程控制

## Claude Code 不把终端当唯一前端

源码里的这组命令非常说明问题：

- `/ide`
- `/desktop`
- `/mobile`
- `/chrome`
- `/voice`
- `/session`
- `/remote-control`
- `/remote-env`

这代表 Claude Code 实际上是在做一个“多前端共享同一工作对象”的系统。

## IDE 集成的价值

IDE 集成不是只为打开文件，而是让 Claude Code 能拿到：

- 编辑器状态。
- 选区。
- 自动连接能力。
- 差异查看与跳转能力。

这也是为什么源码里会有 `useIDEIntegration`、自动连接对话框和 IDE 安装状态管理。

## Vim、主题、颜色、按键绑定

`/vim`、`/theme`、`/color`、`/keybindings` 说明终端交互体验不是后置细节，而是正式产品面。

尤其 `src/vim/*` 的存在说明：

- Claude Code 不是简单复用 readline。
- 它在把“文本输入体验”本身当作可进化子系统。

## 语音与 Chrome 不是噱头，但也不是默认主线

语音模式与 Claude in Chrome 都有独立命令与模块，说明多模态和浏览器接入在源码里已经被认真建模：

- 语音走独立 feature gate、账户、依赖与权限检查链。
- Chrome 集成有自己的账户资格、设置与权限面。

这类能力不一定对所有用户稳定开放，但它们也不是概念验证，而是条件公开的正式产品方向。

## 远程控制是条件公开的另一条产品线

`bridge`/`remote-control` 入口、`src/bridge/*`、远程环境设置都表明 Claude Code 不是只在本地执行。

用户应把远程控制理解为：

- 本地终端可变成一个远程执行宿主。
- 会话可在不同终端/设备间迁移。
- 某些执行动作可绑定到远程环境，而非当前机。

但更稳的写法应始终保留条件说明：

- `/session` 是稳定的接续入口。
- `/remote-control` 是条件公开的远程控制面。

## 用户实践

### 本地仓库开发

终端 REPL 仍然是主面。

### 强 IDE 依赖工作流

优先启用 IDE 集成，让选区、跳转、差异查看进入系统循环。

### 跨设备继续工作

利用桌面、移动端、session/remote-control 等入口，不要把单个终端视作唯一会话容器。

## 源码锚点

- `src/commands/ide/index.ts`
- `src/hooks/useIDEIntegration.tsx`
- `src/commands/desktop/index.ts`
- `src/commands/mobile/index.ts`
- `src/commands/chrome/index.ts`
- `src/commands/voice/index.ts`
- `src/voice/*`
- `src/commands/keybindings/index.ts`
- `src/commands/vim/index.ts`
- `src/vim/*`
- `src/commands/bridge/index.ts`
- `src/commands/remote-env/index.ts`
- `src/bridge/*`
