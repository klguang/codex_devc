# `.devcontainer` 目录说明

这个目录同时支持两种使用方式：

- 本地构建模式：使用 [devcontainer.json](/workspace/codex_devc/.devcontainer/devcontainer.json:1)，由当前仓库里的 `Dockerfile` 和 `features` 构建开发镜像
- 预构建镜像模式：参考 [devcontainer.prebuilt-image.example.json](/workspace/codex_devc/.devcontainer/devcontainer.prebuilt-image.example.json:1)，直接复用已经发布好的镜像，尽量避免在新项目里重复构建

如果你只是想在当前仓库里开发，直接使用 `devcontainer.json` 即可。  
如果你想把这套环境复制到别的项目，并尽量减少重新构建镜像的次数，优先考虑预构建镜像模式。

## 目录内容

- `Dockerfile`：定义基础开发镜像，包含常用系统工具、Java、Maven、Node.js、TypeScript、Codex CLI 等工具
- `devcontainer.json`：当前仓库默认使用的 Dev Container 配置，采用本地构建模式
- `devcontainer.prebuilt-image.example.json`：给其他项目复用时参考的预构建镜像版配置
- `scripts/post-start.sh`：容器每次启动时执行的脚本，用于修复挂载卷权限并检查 Docker 可用性
- `maven/settings.xml`：容器内 Maven 默认配置文件

## 复用到其他项目

最简单的做法，是把整个 `.devcontainer/` 目录复制到新项目里，然后根据需要选择一种模式。

### 方式一：继续在项目内本地构建

适合场景：

- 这个新项目需要自己维护开发镜像
- 你经常会改 `Dockerfile`
- 你不介意首次打开项目时执行一次构建

做法：

1. 复制整个 `.devcontainer/` 目录。
2. 保留 `devcontainer.json`。
3. 根据新项目调整 `name`、`forwardPorts`、`extensions`、`postCreateCommand`、`mounts` 等配置。

### 方式二：复用预构建镜像

适合场景：

- 多个项目共用几乎相同的开发环境
- 希望新项目打开时尽量不要重新构建镜像
- 团队希望统一维护一份公共开发镜像

做法：

1. 先把当前仓库的开发环境构建并发布为镜像。
2. 在新项目中复制整个 `.devcontainer/` 目录。
3. 将 `devcontainer.prebuilt-image.example.json` 改名为 `devcontainer.json`。
4. 把示例中的镜像地址替换成你们真实发布的镜像地址。
5. 再按项目需要调整 `name`、`forwardPorts`、`extensions`、`postCreateCommand`、`mounts`。

## 预构建镜像里需要包含什么

如果你要走预构建镜像模式，发布出去的镜像里应该已经包含当前本地构建模式提供的核心能力：

- `.devcontainer/Dockerfile` 里安装的工具和用户环境
- `devcontainer.json` 中 `features` 提供的 Docker 支持能力

换句话说，这个镜像至少应该已经具备：

- Java
- Maven
- Node.js
- TypeScript
- Codex CLI
- `vscode` 用户
- Docker 相关工具支持

## 一个常见的发布流程

通常做法是：在这个仓库里先构建并发布一次镜像，之后让其他仓库直接引用这个镜像。

示例命令：

```bash
docker build -f .devcontainer/Dockerfile -t docker.io/kevin-agent/springboot-typescript-codex:1.0.0 .
```

镜像推送到你们自己的镜像仓库后，其他项目就可以基于 `devcontainer.prebuilt-image.example.json` 改成自己的 `devcontainer.json`，从而避免重复构建相同工具链。
