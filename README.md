# Java / Spring Boot Dev Container 模板

这是一个面向 VS Code Dev Containers 的 Java / Spring Boot 开发环境模板，内置 Testcontainers 所需的 Docker 能力，并预装 Codex CLI。

模板偏向中国大陆网络环境的开箱即用体验，基础镜像使用 `mcr.m.daocloud.io`，Ubuntu APT 和 Maven 默认使用国内镜像源。

如果你想了解 `.devcontainer` 目录内部结构、以及如何把这套配置复用到其他项目，可以继续看 [.devcontainer/README.md](/workspace/codex_devc/.devcontainer/README.md:1)。

## 模板特点

- 基于 `Ubuntu 24.04`
- 内置 `OpenJDK 21`、`Maven`、`Node.js 22`
- 预装 `@openai/codex` CLI
- 支持 `docker-outside-of-docker`
- 适合运行 Spring Boot + Testcontainers
- 支持通过 `.env` 注入代理变量
- 默认挂载 Maven、npm、Codex 相关持久化卷
- 默认转发 `8080` 端口
- 时区默认 `Asia/Shanghai`

## 内置环境

- Java：`OpenJDK 21`
- Maven：默认读取 `/home/vscode/.m2/settings.xml`
- Node.js：`22.x`
- Codex CLI：`0.122.0`
- Docker：通过 Dev Container Feature 访问宿主机 Docker
- 持久化卷：
  - `maven-repo -> /home/vscode/.m2/repository`
  - `npm-cache -> /home/vscode/.npm`
  - `codex-auth -> /home/vscode/.codex`

## 快速开始

### 1. 准备环境

- Docker Desktop 或 Docker Engine
- VS Code
- VS Code 扩展 `Dev Containers`

### 2. 生成本地 `.env`

先基于模板生成：

```bash
cp .env.example .env
```

`.env` 会同时用于 Docker 构建阶段和容器运行阶段。一个常见示例如下：

```bash
HTTP_PROXY=http://host.docker.internal:7890
HTTPS_PROXY=http://host.docker.internal:7890
NO_PROXY=localhost,127.0.0.1,host.docker.internal
http_proxy=http://host.docker.internal:7890
https_proxy=http://host.docker.internal:7890
no_proxy=localhost,127.0.0.1,host.docker.internal
```

### 3. 在 VS Code 中启动 Dev Container

执行：

```text
Dev Containers: Rebuild and Reopen in Container
```

### 4. 进入容器后验证环境

```bash
java -version
mvn -version
node -v
npm -v
codex --version
docker version
docker ps
```

如果 `docker ps` 能正常返回，说明容器已经可以访问宿主机 Docker，Testcontainers 具备运行条件。

## 当前模板做了什么

### Docker 与 Testcontainers

- 启用 `docker-outside-of-docker`
- 设置 `TESTCONTAINERS_DOCKER_SOCKET_OVERRIDE=/var/run/docker.sock`
- 增加 `host.docker.internal:host-gateway`

### 开发体验

- 默认用户为 `vscode`
- 自动挂载 Maven、npm、Codex 相关卷
- 启动时自动修复挂载目录权限
- 默认转发 `8080` 端口
- 预装 Docker、Java Extension Pack、Maven for Java、Spring Boot Extension Pack

## 如何复用到其他项目

如果只是偶尔复用，最简单的做法是直接复制整个 `.devcontainer/` 目录。

如果多个项目都共用几乎相同的开发环境，并且你希望尽量不要在每个新项目里重新构建镜像，推荐改用“预构建镜像”模式。这个仓库里已经提供了示例文件：

- [.devcontainer/devcontainer.json](/workspace/codex_devc/.devcontainer/devcontainer.json:1)：本地构建模式
- [.devcontainer/devcontainer.prebuilt-image.example.json](/workspace/codex_devc/.devcontainer/devcontainer.prebuilt-image.example.json:1)：预构建镜像模式示例

更详细的复用说明见 [.devcontainer/README.md](/workspace/codex_devc/.devcontainer/README.md:1)。

## 注意事项

- `.env` 里可能包含代理或认证信息，不要提交真实敏感内容；建议只提交 `.env.example`。
- 修改 `.devcontainer/Dockerfile` 或 `.devcontainer/devcontainer.json` 后，通常需要重新执行 `Rebuild and Reopen in Container`。
- 当前模板依赖宿主机 Docker；如果宿主机 Docker 不可用，容器内的 `docker ps` 和 Testcontainers 也无法正常工作。
- 当前仓库提供的是开发环境模板，不包含示例业务代码或 CI 配置。
