# ArbiEver Explorer Stack

A custom-branded, dedicated block explorer suite for the **ArbiEver Layer 2** network. This repository packages both a lightweight frontend (based on **Alethio Ethereum Lite Explorer**) and a full-featured indexer/portal (based on **Blockscout**).

---

## 🌐 Project Context: What is ArbiEver?

**ArbiEver** is a custom **Arbitrum Nitro AnyTrust Layer 2** rollup designed to operate seamlessly on top of **EtherEver L1**—a custom PoW parent chain hardforked from Ethereum at block `1919999`. 

### 📐 Chain Configurations

| Parameter | Layer 1 Parent Chain (`EtherEver`) | Layer 2 Rollup Chain (`ArbiEver`) |
|---|---|---|
| **Chain ID** | `58051` (`0xe2c3`) | `580511` |
| **RPC Endpoint** | `https://rpc-ether.ever-chain.xyz` | `https://rpc-arbi.ever-chain.xyz` |
| **Gas Currency** | `ETE` | `ETE` |
| **Gas Engine** | Legacy Gas Model (London EVM compatible, no EIP-1559) | Nitro ArbOS EVM Execution Engine |
| **Consensus Mode** | Proof-of-Work (PoW) | AnyTrust Rollup (1-Member DAC consensus via `daserver`) |

---

## 🛠️ Repository Architecture

This repository offers two distinct tiers of explorer components, fully customized and rebranded to represent the **ArbiEver** brand and native currency (`ETE`):

```
┌─────────────────────────────────────────────────────────────────┐
│                      ArbiEver Explorer Stack                    │
└─────────────────────────────────────────────────────────────────┘
         │                                         │
         ▼                                         ▼
┌─────────────────────────────────┐      ┌─────────────────────────┐
│       Alethio Lite Explorer     │      │  Blockscout Full-stack  │
│       (Root Directory)          │      │  (/blockscout)          │
├─────────────────────────────────┤      ├─────────────────────────┤
│ - Light HTML/JS Static SPA      │      │ - Redis & Postgres DBs  │
│ - Instant block/tx lookup       │      │ - Elixir Nitro Indexer  │
│ - Custom sed-rebrand script     │      │ - Next.js UI Frontend   │
│ - Port 4002 -> RPC polling      │      │ - Custom Nginx Proxy    │
└─────────────────────────────────┘      └─────────────────────────┘
```

---

## 🚀 Build & Deployment Instructions

### 1. Alethio Lite Explorer (Root)
The root workspace defines the **Alethio Lite** deployment. It leverages an in-image rebranding mechanism using a shell script (`rebrand.sh`) to substitute text and assets in the static build output of `alethio/ethereum-lite-explorer`.

#### Prerequisites
- Docker & Docker Compose v2+

#### Deployment Steps
You can build and spin up the container using either the quickstart script or raw Docker Compose commands:

```bash
# Option A: Quickstart shell script
./start.sh

# Option B: Docker Compose
docker compose up -d --build
```

#### Access Configuration
- **Internal Port**: `4002` (mapped to Nginx HTTP port `80` in the container)
- **External URL**: `https://arbiever2.ever-chain.xyz`
- **L2 Node RPC target**: configured dynamically via the `APP_NODE_URL` environment variable (`https://rpc-arbi.ever-chain.xyz`).

---

### 2. Blockscout Explorer Stack (`/blockscout`)
For deep data analysis, full transaction indexing, contract source verification, and detailed token tables, use the Blockscout full-stack.

#### Directory Structure
All related deployment files are housed within the [`/blockscout`](file:///root/ArbiEver-Explorer/blockscout) subdirectory.

#### Deployment Steps
1. Navigate into the blockscout folder:
   ```bash
   cd blockscout
   ```
2. Generate a secure `.env` file containing unique secret keys and passwords:
   ```bash
   cat > .env <<EOF
   POSTGRES_PASSWORD=$(openssl rand -hex 16)
   SECRET_KEY_BASE=$(openssl rand -hex 32)
   EOF
   chmod 600 .env
   ```
3. Pull the required service images:
   ```bash
   docker compose --env-file .env pull
   ```
4. Start the 5-service orchestration in detached mode:
   ```bash
   docker compose --env-file .env up -d
   ```

#### Orchestrated Services
- **`arbiever-bs-redis`**: Key-value cache layer.
- **`arbiever-bs-db`**: PostgreSQL database for block and log indexing.
- **`arbiever-bs-backend`**: Core Blockscout platform (Elixir/Phoenix) running background indexer tasks.
- **`arbiever-bs-frontend`**: Next.js-based modern user portal interface.
- **`arbiever-bs-proxy`**: Nginx web server routing traffic, serving custom brand assets, and exposing the UI.

#### Access Configuration
- **Internal Port**: `4005` (exposed by `arbiever-bs-proxy`)
- **External URL**: `https://arbiever.ever-chain.xyz`

---

## 🎨 Branding Customization Details

Both explorers integrate brand-specific details to fit the custom L2 chain seamlessly:
- **String Rebranding**: Text occurrences of `Ethereum` and `ETH` are substituted with `ArbiEver` and `ETE` dynamically in assets.
- **Visual Rebranding**: The custom network logo (`arbiicon512.png`) is embedded as favicons, application logos, and sidebar svgs using automatic image wrapping and Base64 compilation.
