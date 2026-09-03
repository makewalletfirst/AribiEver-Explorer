#!/bin/bash
# 빠른 가동 스크립트
set -e
HERE="$(cd "$(dirname "$0")" && pwd)"
docker build -t arbiever-lite-explorer:latest "$HERE"
docker rm -f arbiever-alethio 2>/dev/null || true
docker run -d --name arbiever-alethio --restart unless-stopped \
  -p 4002:80 \
  -e APP_NODE_URL="https://rpc-arbi.ever-chain.xyz" \
  arbiever-lite-explorer:latest
echo "Started. Visit https://arbiever2.ever-chain.xyz"
