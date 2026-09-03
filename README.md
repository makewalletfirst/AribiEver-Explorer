# ArbiEver Explorer

ArbiEver L2 (Chain ID `580511`) 전용 Alethio Lite 익스플로러.

## 접속

- URL: `https://arbiever2.ever-chain.xyz`
- 백엔드 L2 RPC: `https://rpc-arbi.ever-chain.xyz`

## 가동

```bash
# 빌드(브랜드 패치 적용) + 실행
docker compose up -d --build
# 또는 셸 스크립트
./start.sh
```

## 브랜드 커스터마이징

`Dockerfile` 에서 `alethio/ethereum-lite-explorer` 의 정적 자산 (`.html .json .webapp .js`) 안 `Ethereum Lite Explorer` / `Ethereum Lite Blockchain` 등 문자열을 모두 `ArbiEver Lite` 계열로 sed 치환. 로컬 이미지 `arbiever-lite-explorer:latest` 로 빌드.

페이지 title, manifest, 메인 헤더 등 모든 표시 문자열이 ArbiEver 브랜드로 통일.

## 기능

- 최신 L2 블록 / 트랜잭션 리스트
- 주소별 잔액 + 트랜잭션 히스토리
- 컨트랙트 페이지 (소스 verify 미지원 — 추후 Blockscout 으로 업그레이드 가능)

## ArbiEver 메인 프로젝트

L2 인프라 자체는 별도 레포: https://github.com/makewalletfirst/ArbiEver

## 향후 개선

- Blockscout 분리형 (Postgres + 백엔드 + 프론트엔드) 으로 업그레이드 시 컨트랙트 verify, 토큰 페이지, 차트 등 풍부한 기능
- 도메인 매핑 + HTTPS (Caddy/nginx + Let's Encrypt)
