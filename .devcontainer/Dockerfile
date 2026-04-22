FROM mcr.m.daocloud.io/devcontainers/base:ubuntu-24.04

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ARG UBUNTU_MIRROR=https://mirrors.aliyun.com/ubuntu
ARG NODE_MAJOR=22
ARG CODEX_VERSION=0.122.0
ARG COMMON_APT_PACKAGES="ca-certificates curl git gnupg sudo tmux tzdata vim wget zip"
ARG JAVA_APT_PACKAGES="maven openjdk-21-jdk"
ARG NODEJS_APT_PACKAGES="nodejs"
ARG TYPESCRIPT_NPM_PACKAGES="typescript"
ARG CODEX_NPM_PACKAGE="@openai/codex"

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Shanghai
ENV JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64
ENV MAVEN_OPTS="-Xmx1g"

COPY .env /tmp/devcontainer-proxy.env

# 默认使用国内 Ubuntu 镜像源
RUN rm -f /etc/apt/sources.list.d/ubuntu.sources \
 && printf "deb %s noble main restricted universe multiverse\n\
deb %s noble-security main restricted universe multiverse\n\
deb %s noble-updates main restricted universe multiverse\n\
deb %s noble-backports main restricted universe multiverse\n" \
    "${UBUNTU_MIRROR}" \
    "${UBUNTU_MIRROR}" \
    "${UBUNTU_MIRROR}" \
    "${UBUNTU_MIRROR}" \
    > /etc/apt/sources.list

# 设置时区
RUN ln -snf "/usr/share/zoneinfo/${TZ}" /etc/localtime \
 && echo "${TZ}" > /etc/timezone

# 安装常用系统工具
RUN set -a \
 && source /tmp/devcontainer-proxy.env \
 && set +a \
 && if [ -n "${COMMON_APT_PACKAGES}" ]; then \
      apt-get update -o Acquire::Retries=3; \
      apt-get install -y --no-install-recommends ${COMMON_APT_PACKAGES}; \
    fi \
 && rm -rf /var/lib/apt/lists/*

# 安装 Java / Maven 工具链
RUN set -a \
 && source /tmp/devcontainer-proxy.env \
 && set +a \
 && if [ -n "${JAVA_APT_PACKAGES}" ]; then \
      apt-get update -o Acquire::Retries=3; \
      apt-get install -y --no-install-recommends ${JAVA_APT_PACKAGES}; \
    fi \
 && rm -rf /var/lib/apt/lists/*

# 配置 NodeSource 源
RUN set -a \
 && source /tmp/devcontainer-proxy.env \
 && set +a \
 && if [ -n "${NODEJS_APT_PACKAGES}" ]; then \
      install -d -m 0755 /etc/apt/keyrings; \
      curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key \
        | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg; \
      echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_${NODE_MAJOR}.x nodistro main" \
        > /etc/apt/sources.list.d/nodesource.list; \
    fi

# 安装 Node.js
RUN set -a \
 && source /tmp/devcontainer-proxy.env \
 && set +a \
 && if [ -n "${NODEJS_APT_PACKAGES}" ]; then \
      apt-get update -o Acquire::Retries=3; \
      apt-get install -y --no-install-recommends ${NODEJS_APT_PACKAGES}; \
    fi \
 && rm -rf /var/lib/apt/lists/*

# 安装全局 TypeScript 工具
RUN set -a \
 && source /tmp/devcontainer-proxy.env \
 && set +a \
 && if [ -n "${NODEJS_APT_PACKAGES}" ] && [ -n "${TYPESCRIPT_NPM_PACKAGES}" ]; then \
      npm install -g ${TYPESCRIPT_NPM_PACKAGES}; \
    fi

# 安装 Codex CLI
RUN set -a \
 && source /tmp/devcontainer-proxy.env \
 && set +a \
 && if [ -n "${NODEJS_APT_PACKAGES}" ] && [ -n "${CODEX_NPM_PACKAGE}" ]; then \
      npm install -g "${CODEX_NPM_PACKAGE}@${CODEX_VERSION}"; \
    fi

# 仅在基础镜像未提供 vscode 用户时再创建
RUN if ! id -u vscode >/dev/null 2>&1; then \
      useradd -m -s /bin/bash vscode; \
    fi \
 && install -d -o vscode -g vscode /home/vscode/.m2 \
 && printf "vscode ALL=(ALL) NOPASSWD:ALL\n" > /etc/sudoers.d/vscode \
 && chmod 0440 /etc/sudoers.d/vscode

COPY --chown=vscode:vscode .devcontainer/maven/settings.xml /home/vscode/.m2/settings.xml

RUN rm -f /tmp/devcontainer-proxy.env

ENV HOME=/home/vscode

USER vscode

WORKDIR /workspaces
