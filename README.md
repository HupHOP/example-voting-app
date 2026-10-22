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
