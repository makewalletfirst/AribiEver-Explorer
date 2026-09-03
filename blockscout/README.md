# ArbiEver Blockscout 풀스택

L2 트랜잭션 인덱싱 + 컨트랙트 verify + REST API.
가벼운 5컨테이너 구성으로 4코어 12GB 서버에서 안정 가동.

## 접속

- **외부**: https://arbiever.ever-chain.xyz
- 로컬: http://localhost:4005

## 가동

```bash
# .env 생성
cat > .env <<EOF2
POSTGRES_PASSWORD=$(openssl rand -hex 16)
SECRET_KEY_BASE=$(openssl rand -hex 32)
EOF2
chmod 600 .env

# 이미지 받기
docker compose --env-file .env pull

# 가동 (재부팅 시 자동 복구 — restart: unless-stopped)
docker compose --env-file .env up -d
```

## 5개 서비스

| 컨테이너 | 역할 |
|---|---|
| `arbiever-bs-redis` | Redis (인덱서 캐시) |
| `arbiever-bs-db` | Postgres 17 (인덱서 DB) |
| `arbiever-bs-backend` | Blockscout 6.10.1 (Elixir) — L2 RPC 폴링 + 인덱싱 |
| `arbiever-bs-frontend` | Blockscout Frontend v1.36.4 (Next.js) |
| `arbiever-bs-proxy` | nginx — 4005 → backend/frontend + favicon |

비활성화: visualizer, sig-provider, stats, user-ops-indexer (메모리 절약). 필요 시 활성화.

## ArbiEver 브랜드 패치

- `backend.env`: `NETWORK=ArbiEver`, `COIN=ETE`, `LOGO=/static/arbiicon.png`
- `frontend.env`: 
  - `NEXT_PUBLIC_NETWORK_NAME=ArbiEver`
  - `NEXT_PUBLIC_NETWORK_CURRENCY_SYMBOL=ETE`
  - `NEXT_PUBLIC_NETWORK_LOGO=https://arbiever.ever-chain.xyz/static/arbiicon.png`
- `nginx.conf`: `/static/arbiicon.png` 정적 서빙 (volume mount)

## 핵심 설정

- L2 RPC: `http://host.docker.internal:8449/` (서버 내부 — Nitro 가 0.0.0.0:8449 listen)
- L1 노출: 4005 (Cloudflare → OCI:4005 stunnel → 10.8.0.14:4005 → docker)
- Chain ID: 580511
- 통화 단위: ETE

## 향후 확장

- 컨트랙트 verify: Backend 가 이미 지원. Frontend 의 verify 폼에서 Solidity 소스 업로드 시 검증.
- 토큰 페이지: ERC20 인덱싱 자동.
- 정밀 차트: `stats` 서비스 추가 활성화 (`docker-compose.override.yml`).
- 스마트 컨트랙트 검증: `sig-provider` + `smart-contract-verifier` 서비스 추가.

## 자원 사용

| 상태 | RAM | 디스크 |
|---|---|---|
| 시동 | ~1.5GB | 5GB 이미지 |
| 인덱싱 시작 | 2-3GB | DB 누적 |

L2 트랜잭션이 적은 dev 체인이라 장기적으로 DB 사이즈는 작게 유지됨.
