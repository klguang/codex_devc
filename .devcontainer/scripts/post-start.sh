#!/usr/bin/env bash
set -euo pipefail

# Ensure mounted cache/auth volumes exist and remain writable by the dev user.
sudo install -d -o vscode -g vscode \
  /home/vscode/.m2/repository \
  /home/vscode/.npm \
  /home/vscode/.codex

sudo chown -R vscode:vscode \
  /home/vscode/.m2/repository \
  /home/vscode/.npm \
  /home/vscode/.codex

if docker ps >/dev/null; then
  echo "Docker daemon is reachable from the dev container."
else
  echo "Docker daemon is not reachable from the dev container."
fi
