# Java Spring Boot Dev Container with Codex CLI

适用于 VS Code Dev Containers 的 Java / Spring Boot 开发模板，内置 Testcontainers 所需的 Docker 能力，并预装 Codex CLI。

这个模板偏向中国大陆网络环境的开箱即用体验，基础镜像使用 `mcr.m.daocloud.io`，Ubuntu APT 和 Maven 默认使用阿里云镜像。

## 特点

- 基于 `Ubuntu 24.04`
- 内置 `OpenJDK 21`、`Maven`、`Node.js 22`
- 预装 `@openai/codex` CLI
- 支持 `docker-outside-of-docker`
- 适合运行 Spring Boot + Testcontainers
- 支持通过 `.env` 注入代理变量
- 挂载 Maven / npm 缓存卷
- 默认转发 `8080` 端口
- 时区默认 `Asia/Shanghai`

## 内置环境

- Java: `OpenJDK 21`
- Maven: 读取 `/home/vscode/.m2/settings.xml`
- Node.js: `22.x`
- Codex CLI: `0.122.0`
- Docker: 通过 Dev Container Feature 访问宿主机 Docker
- 缓存卷: `maven-repo -> /home/vscode/.m2/repository`、`npm-cache -> /home/vscode/.npm`

## 使用方式

1. 准备前置工具

- Docker Desktop 或 Docker Engine
- VS Code
- VS Code 扩展 `Dev Containers`

2. 配置 `.env`

先基于模板生成本地 `.env`：

```bash
cp .env.example .env
```

`.env` 同时用于 Docker build 阶段和容器运行阶段，模板内容如下：

```bash
HTTP_PROXY=http://host.docker.internal:7890
HTTPS_PROXY=http://host.docker.internal:7890
NO_PROXY=localhost,127.0.0.1,host.docker.internal
http_proxy=http://host.docker.internal:7890
https_proxy=http://host.docker.internal:7890
no_proxy=localhost,127.0.0.1,host.docker.internal
```

3. 在 VS Code 中执行

```text
Dev Containers: Rebuild and Reopen in Container
```

4. 进入容器后验证环境

```bash
java -version
mvn -version
node -v
npm -v
codex --version
docker version
docker ps
```

如果 `docker ps` 正常返回，说明容器已能访问宿主机 Docker，Testcontainers 具备运行条件。

## 已做的配置

- Docker 与 Testcontainers:
  - 启用 `docker-outside-of-docker`
  - 设置 `TESTCONTAINERS_DOCKER_SOCKET_OVERRIDE=/var/run/docker.sock`
  - 增加 `host.docker.internal:host-gateway`
- 开发体验:
  - 默认用户为 `vscode`
  - 自动挂载 Maven / npm 缓存卷
  - 自动转发 `8080` 端口
  - 预装 Docker、Java Extension Pack、Maven for Java、Spring Boot Extension Pack

## 注意事项

- `.env` 里可能包含代理或认证信息，开源前不要提交真实内容；请提交 `.env.example` 作为模板。
- 修改 `.devcontainer/Dockerfile` 或 `.devcontainer/devcontainer.json` 后，需要重新 `Rebuild and Reopen in Container`。
- 该模板依赖宿主机 Docker；如果宿主机 Docker 不可用，容器内的 `docker ps` 和 Testcontainers 也无法正常工作。
- 当前仓库只提供开发环境模板，不包含示例业务代码或 CI 配置。
