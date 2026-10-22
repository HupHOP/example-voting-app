# DevOps Capstone 1: Voting App

Forked from [dockersamples/example-voting-app](https://github.com/dockersamples/example-voting-app). The original README is kept as [ORIGINAL_README.md](ORIGINAL_README.md).

The raw working notes are in [docs/PROGRESS.md](docs/PROGRESS.md).

## Step 1: Run it locally

- Forked the repo to my GitHub account, cloned it, and added the original as the `upstream` remote.
- Ran the app with `docker compose up -d --build`.
- Vote page: http://localhost:8080
- Result page: http://localhost:8081

First build hit DNS timeouts while pulling base images. Retrying the pulls fixed it and all three images built.

### Proof

Vote page after casting a vote:

![Vote page](docs/images/step1-vote.jpg)

Result page showing the count:

![Result page](docs/images/step1-result.jpg)

All containers running:

![docker compose ps](docs/images/step1-terminal.jpg)

## Step 2: Containerize it safely

- **Pinned base images** by digest in all three Dockerfiles (`python:3.11-slim`, `node:18-slim`, `dotnet/sdk:7.0` and `dotnet/runtime:7.0`), so builds are reproducible.
- **Non-root:** vote and worker run as `appuser` (UID 10001); result runs as the built-in `node` user (UID 1000).
- **`.dockerignore`** added for vote and worker and tightened for result, so `node_modules`, `bin/obj`, `.git`, env files and keys stay out of the build context.

### Verification

```text
docker compose exec vote id     -> uid=10001(appuser)
docker compose exec result id   -> uid=1000(node)
docker compose exec worker id   -> uid=10001(appuser)
docker build --target final ./vote  -> builds and serves HTTP 200
```

## Setup and issues hit so far

### Environment

- Windows with Ubuntu on WSL 2, Docker Desktop with WSL integration enabled for the Ubuntu distro.
- Git authentication over HTTPS with a GitHub personal access token (repo and workflow scopes), stored outside the repo.

### Issues and fixes

| Issue | Cause | Fix |
|---|---|---|
| `docker: command not found` in Ubuntu | Docker Desktop WSL integration was off | Enabled it under Settings, Resources, WSL integration, then `wsl --shutdown` and reopened Ubuntu |
| Image pulls and `pip install` failed with `no such host` during builds | Intermittent DNS failures inside Docker | Retried the build loop, and set public DNS (8.8.8.8, 1.1.1.1) in Docker Engine settings |
| `Password authentication is not supported` on clone | GitHub no longer accepts account passwords for Git | Used a personal access token as the password |
| `:Zone.Identifier` files appeared next to screenshots | Windows metadata added when copying files into WSL | Deleted them and added `*:Zone.Identifier` to `.gitignore` |
